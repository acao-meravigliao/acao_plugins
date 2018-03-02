#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment < Ygg::PublicModel
  self.table_name = 'acao_payments'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :payment_services,
           class_name: 'Ygg::Acao::Payment::Service',
           embedded: true,
           autosave: true,
           dependent: :destroy

  has_one :membership,
          class_name: 'Ygg::Acao::Membership'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_acl

  include Ygg::Core::Notifiable

  def set_default_acl
    transaction do
      acl_entries.where(owner: self).destroy_all
      acl_entries << AclEntry.new(owner: self, person: person, capability: 'owner')
    end
  end

  def completed!
    raise "Payment in state #{state} cannot be confirmed" if state != 'PENDING'

    self.state = 'COMPLETED'
    self.completed_at = Time.now

    if membership
      membership.payment_completed!
      membership.save!
    end

    Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_COMPLETED', template_context: {
      first_name: person.first_name,
      code: code,
    }, objects: self)

    save!
  end


  def self.run_chores!
    all.each do |payment|
      payment.run_chores!
    end
  end

  def run_chores!
    transaction do
      now = Time.now
      last_run = last_chore || Time.new(0)

      run_expiration_chores(now: now, last_run: last_run)

      self.last_chore = now

      save!
    end
  end

  def run_expiration_chores(now:, last_run:)
    when_in_advance = 5.days - 10.hours

    if expires_at && state == 'PENDING'
      if (expires_at.beginning_of_day - when_in_advance).between?(last_run, now) && !expires_at.between?(last_run, now)
        Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_NEAR_EXPIRATION', template_context: {
          first_name: person.first_name,
          code: code,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end

      if expires_at.between?(last_run, now)
        Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_EXPIRED', template_context: {
          first_name: person.first_name,
          code: code,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end
    end
  end

  class Service < Ygg::BasicModel
    self.table_name = 'acao_payment_services'

    include Ygg::Core::Loggable
    define_default_log_controller(self)

    belongs_to :payment,
               class_name: 'Ygg::Acao::Payment'

    belongs_to :service_type,
               class_name: 'Ygg::Acao::ServiceType'
  end
end

end
end
