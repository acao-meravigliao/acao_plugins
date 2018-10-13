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

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "invoice_id", type: :uuid, default: nil, null: true}],
    #[ :must_have_column, {name: "invoice_id", type: :uuid, default: nil, null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "identifier", type: :string, default: nil, limit: 8, null: true}],
    #[ :must_have_column, {name: "identifier", type: :string, default: nil, limit: 8, null: false}],
    [ :must_have_column, {name: "amount", type: :decimal, default: nil, precision: 14, scale: 6, null: true}],
    #[ :must_have_column, {name: "amount", type: :decimal, default: nil, precision: 14, scale: 6, null: false}],
    [ :must_have_column, {name: "payment_method", type: :string, default: nil, limit: 32, null: false}],
    [ :must_have_column, {name: "created_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "state", type: :string, default: "PENDING", limit: 32, null: false}],
    [ :must_have_column, {name: "reason_for_payment", type: :string, default: nil, limit: 140, null: true}],
    [ :must_have_column, {name: "completed_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "expires_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "notes", type: :text, default: nil, null: true}],
    [ :must_have_column, {name: "last_chore", type: :datetime, default: nil, null: true}],

    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["identifier"], unique: true}],
    [ :must_have_index, {columns: ["invoice_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],

    [ :must_have_fk, {to_table: "acao_invoices", column: "invoice_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :invoice,
             class_name: 'Ygg::Acao::Invoice'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :satispay_charges,
           class_name: 'Ygg::Acao::Payment::SatispayCharge',
           embedded: true,
           autosave: true,
           dependent: :destroy

  has_one :membership,
          class_name: 'Ygg::Acao::Membership'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_acl

  include Ygg::Core::Notifiable

  after_initialize do
    if new_record?
      identifier = nil

      loop do
        identifier = "A-" + Password.random(4, symbols: 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789')
        break if !self.class.find_by_identifier(identifier)
      end

      self.identifier = identifier
    end
  end

  def completed!(no_autoinvoice: false)
    raise "Payment in state #{state} cannot be confirmed" if state != 'PENDING'

    self.state = 'COMPLETED'
    self.completed_at = Time.now

# FIXME
    if membership
      membership.payment_completed!
      membership.save!
    end

    unless no_autoinvoice
      export_invoice!
    end

    Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_COMPLETED', template_context: {
      first_name: person.first_name,
      code: identifier,
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
          code: identifier,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end

      if expires_at.between?(last_run, now)
        Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_EXPIRED', template_context: {
          first_name: person.first_name,
          code: identifier,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end
    end
  end

  require 'am/satispay'

  def satispay_initiate(phone_number:)
    satispay_charges.each do |c|
      c.sync! if c.status == 'REQUIRED'
      raise "Charge is still pending" if c.status == 'REQUIRED'
    end

    charge = Ygg::Acao::Payment::SatispayCharge.new(
      user_phone_number: phone_number,
      amount: amount,
      description: "Pagamento Online codice #{identifier}",
      idempotency_key: SecureRandom.base64(10),
    )

    satispay_charges << charge

    charge.save!
    charge.initiate!
  end

  def satispay_callback(charge_id:)
    charge = satispay_charges.find_by!(charge_id: charge_id)
    charge.sync!

    case charge.status
    when 'REQUIRED'
    when 'SUCCESS'
      completed!
    when 'FAILURE'
    else
    end
  end
end

end
end
