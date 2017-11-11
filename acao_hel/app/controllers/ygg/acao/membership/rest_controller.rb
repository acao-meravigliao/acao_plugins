#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Membership::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Membership

  def compute_completed_years(from, to)
    # Number of completed years is not trivial :)

    completed_years = to.year - from.year

    if from.month > to.month ||
       (from.month == to.month && from.day > to.day)
      completed_years -= 1
    end

    completed_years
  end

  def determine_base_context(person:, year:)
    age = compute_completed_years(person.birth_date, year.renew_opening_time)

    if !person.birth_date
      ass_type = 'ASS_STANDARD'
      cav_type = 'CAV_STANDARD'
    elsif age < 23
      ass_type = 'ASS_23'
      cav_type = nil
    elsif age < 26
      ass_amount = 'ASS_STANDARD'
      cav_amount = 'CAV_26'
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

    { ass_type: ass_type, cav_type: cav_type }
  end

  def renew_context
    person = aaa_context.auth_person
    renewal_year = Ygg::Acao::Year.renewal_year
    membership = person.acao_memberships.find_by(year: renewal_year.year)

#sleep 2

    if !renewal_year || !renewal_year.renew_opening_time
      render(json: {
        renew_for_year: renewal_year.year,
        opening_time: nil,
      })

      return
    end

    context = determine_base_context(person: person, year: renewal_year)

#    # We use #to_f because the frontend does not (yet?) have a arbitrary precision support
#    availableServices = Hash[Ygg::Acao::ServiceType.order(name: :ASC).map { |x|
#      [ x.symbol, { name: x.name, price: x.price.to_f, extraInfo: x.extra_info, notes: x.notes, publish: x.publish } ]
#    } ]

    membership_data = nil

    if membership
      membership_data = {
        id: membership.id,
        status: membership.status,
        payment_id: membership.payment_id,
      }
    end

    render(json: context.merge({
      renew_for_year: renewal_year.year,
      renew_opening_time: renewal_year.renew_opening_time,
      membership: membership_data,
    }))
  end

  def renew_do

    payment = nil

    hel_transaction('Membership renewal wizard') do
      person = aaa_context.auth_person
      renewal_year = Ygg::Acao::Year.renewal_year

      code = Password.random(4, symbols: 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789')
      loop do
        break if !Ygg::Acao::Payment.find_by_code(code)
      end

      payment = Ygg::Acao::Payment.create(
        person: person,
        code: code,
        created_at: Time.now,
        payment_method: json_request[:paymentMethod],
      )

      context = determine_base_context(person: person, year: renewal_year)

      # Association
      ass_service_type = Ygg::Acao::ServiceType.find_by_symbol(context[:ass_type])

      payment.payment_services << Ygg::Acao::Payment::Service.new(
        service_type: ass_service_type,
        price: ass_service_type.price,
      )

      # CAV
      cav_service_type = Ygg::Acao::ServiceType.find_by_symbol(context[:cav_type])

      payment.payment_services << Ygg::Acao::Payment::Service.new(
        service_type: cav_service_type,
        price: cav_service_type.price,
      )

      # Services
      json_request[:services].each do |service|
        service_type = Ygg::Acao::ServiceType.find_by_symbol(service[:type])

        payment.payment_services << Ygg::Acao::Payment::Service.new(
          service_type: service_type,
          extra_info: service[:extra_info],
          price: service_type.price,
        )
      end

      membership = person.acao_memberships.find_or_create_by(year: Ygg::Acao::Year.renew_for_year)
      membership.status = 'WAITING_PAYMENT'
      membership.email_allowed = json_request[:enableEmail]
      membership.payment = payment
      membership.save!
    end

    render(json: {
      payment_id: payment.id,
    });
  end
end

end
end
