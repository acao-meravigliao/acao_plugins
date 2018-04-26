#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Membership < Ygg::PublicModel
  self.table_name = 'acao_memberships'

  belongs_to :person,
             class_name: '::Ygg::Core::Person'

  belongs_to :payment,
             class_name: 'Ygg::Acao::Payment',
             optional: true

  belongs_to :reference_year,
             class_name: 'Ygg::Acao::Year'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_acl

  include Ygg::Core::Notifiable

#  def set_default_acl
#    transaction do
#      acl_entries.where(owner: self).destroy_all
#      acl_entries << AclEntry.new(owner: self, person: person, capability: 'owner')
#    end
#  end

  append_capabilities_for(:blahblah) do |aaa_context|
     aaa_context.auth_person.id == person_id ? [ :owner ] : []
  end

  def self.compute_completed_years(from, to)
    # Number of completed years is not trivial :)

    completed_years = to.year - from.year

    if from.month > to.month ||
       (from.month == to.month && from.day > to.day)
      completed_years -= 1
    end

    completed_years
  end

  def self.determine_base_context(person:, year:)
    if !person.birth_date
      return { ass_type: 'ASS_STANDARD', cav_type: 'CAV_STANDARD' }
    end

    age = compute_completed_years(person.birth_date, year.renew_opening_time)

    if age < 23
      ass_type = 'ASS_23'
      cav_type = nil
    elsif age <= 26
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_26'
    elsif age >= 75
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_75'
    else
      #if person.residence_location &&
      #   Geocoder::Calculations.distance_between(
      #     [ person.residence_location.lat, person.residence_location.lng ],
      #     [ 45.810189, 8.770963 ]) > 300000

      #  cav_amount = 700.00
      #  cav_type = 'CAV residenti oltre 300 km'
      #else

      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_STANDARD'
    end

    {
     ass_type: ass_type,
     cav_type: cav_type,
    }
  end

  def self.renew(person:, payment_method:, services:, enable_email:, with_cav:)
    payment = nil

    renewal_year = Ygg::Acao::Year.renewal_year

    payment = Ygg::Acao::Payment.create(
      person: person,
      created_at: Time.now,
      expires_at: Time.now + 10.days,
      payment_method: payment_method,
      reason_for_payment: "rinnovo associazione, codice pilota #{person.acao_code}"
    )

#    payment.set_default_acl

    context = determine_base_context(person: person, year: renewal_year)

    # Association
    ass_service_type = Ygg::Acao::ServiceType.find_by_symbol(context[:ass_type])

    payment.payment_services << Ygg::Acao::Payment::Service.new(
      service_type: ass_service_type,
      price: ass_service_type.price,
    )

    # CAV

    if with_cav && context[:cav_type]
      cav_service_type = Ygg::Acao::ServiceType.find_by_symbol(context[:cav_type])

      payment.payment_services << Ygg::Acao::Payment::Service.new(
        service_type: cav_service_type,
        price: cav_service_type.price,
      )
    end

    # Services
    services.each do |service|
      service_type = Ygg::Acao::ServiceType.find(service[:type_id])

      payment.payment_services << Ygg::Acao::Payment::Service.new(
        service_type: service_type,
        extra_info: service[:extra_info],
        price: service_type.price,
      )
    end

    membership = person.acao_memberships.find_or_create_by(year: renewal_year.year)
    membership.status = 'WAITING_PAYMENT'
    membership.email_allowed = enable_email
    membership.payment = payment

#    membership.set_default_acl

    prev_membership = person.acao_memberships.where('year <> ?', renewal_year.year).order(year: 'DESC').first
    if prev_membership
      membership.tug_pilot = prev_membership.tug_pilot
      membership.board_member = prev_membership.board_member
      membership.instructor = prev_membership.instructor
      membership.possible_roster_chief = prev_membership.possible_roster_chief
      membership.fireman = prev_membership.fireman
    end

    membership.save!

    Ygg::Ml::Msg.notify(destinations: person, template: 'MEMBERSHIP_RENEWED', template_context: {
      first_name: person.first_name,
      year: renewal_year.year,
      payment_expiration: payment.expires_at.strftime('%d-%m-%Y'),
    }, objects: [ payment, membership ])

    membership
  end

  def payment_completed!
    self.status = 'COMPLETED'

    Ygg::Ml::Msg.notify(destinations: person, template: 'MEMBERSHIP_COMPLETE', template_context: {
      first_name: person.first_name,
      year: year,
    }, objects: self)
  end

  def active?(time: Time.now)
    ym = Ygg::Acao::Year.find_by(year: year)
    return false if !ym

    time.between?(ym.renew_opening_time, ym.ending_time)
  end

end

end
end
