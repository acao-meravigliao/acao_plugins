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

  load_role_defs!

  collection_action :renew

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:status) { show! }
    attribute(:valid_from) { show! }
    attribute(:valid_to) { show! }

    attribute(:reference_year) do
      attribute(:year) { show! }
    end

    attribute(:person) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    self.with_perms = true

    attribute(:reference_year) do
      attribute(:year) { show! }
    end

    attribute :acl_entries do
      show!
      attribute :group do
        show!
        empty!
        attribute(:name) { show! }
      end
      attribute :person do
        show!
        empty!
        attribute(:first_name) { show! }
        attribute(:last_name) { show! }
        attribute(:handle) { show! }
        attribute(:italian_fiscal_code) { show! }
      end
    end
  end

  build_member_roles(:blahblah) do |obj|
     aaa_context.auth_person.id == obj.person_id ? [ :owner ] : []
  end

  def renew_context
    person = aaa_context.auth_person
    pilot = person.becomes(Ygg::Acao::Pilot)
    renewal_year = Ygg::Acao::Year.renewal_year
    next_renewal_year = Ygg::Acao::Year.next_renewal_year

    res = {}

    if renewal_year
      services = []

      pilot.acao_aircrafts.each do |x|

        srvt = if x.hangar
          if x.aircraft_type.is_vintage
            'HANGAR_VNT'
          elsif x.aircraft_type.aircraft_class == 'GLD'
            if x.aircraft_type.wingspan && x.aircraft_type.wingspan <= 15
              'HANGAR_STD'
            elsif x.aircraft_type.wingspan && x.aircraft_type.wingspan <= 18
              'HANGAR_18M'
            elsif x.aircraft_type.wingspan && x.aircraft_type.wingspan <= 20
              'HANGAR_20M'
            elsif x.aircraft_type.wingspan && x.aircraft_type.wingspan <= 25
              'HANGAR_25M'
            else
              'HANGAR_BIG'
            end
          elsif x.aircraft_type.aircraft_class == 'TMG'
            'HANGAR_TMG'
          else
            if x.aircraft_type.foldable_wings
              'HANGAR_ENG_FLD'
            elsif x.aircraft_type.wingspan && x.aircraft_type.wingspan <= 10
              'HANGAR_ENG_10M'
            else
              'HANGAR_ENG_BIG'
            end
          end

          services << { service_type_id: Ygg::Acao::ServiceType.find_by!(symbol: srvt).id, extra_info: x.registration }
        end
      end

      pilot.acao_trailers.each do |x|

        srvt = if x.zone == 'A'
          'TRAILER_A'
        else
          'TRAILER_BC'
        end

        services << { service_type_id: Ygg::Acao::ServiceType.find_by!(symbol: srvt).id, extra_info: x.aircraft && x.aircraft.registration }
      end

      res[:current] = {
        year: renewal_year.year,
        year_id: renewal_year.id,
        announce_time: renewal_year.renew_announce_time,
        opening_time: renewal_year.renew_opening_time,
        services: services,
      }.merge(Ygg::Acao::Membership.determine_base_context(person: person, year: renewal_year))
    end

    if next_renewal_year
      res[:next] = {
        year: next_renewal_year.year,
        year_id: next_renewal_year.id,
        announce_time: next_renewal_year.renew_announce_time,
        opening_time: next_renewal_year.renew_opening_time,
      }.merge(Ygg::Acao::Membership.determine_base_context(person: person, year: next_renewal_year))
    end

    render(json: res)
  end

  def renew_do
    membership = nil

    hel_transaction('Membership renewal wizard') do
      membership = Ygg::Acao::Membership.renew(
        person: aaa_context.auth_person,
        payment_method: json_request[:payment_method],
        enable_email: json_request[:enable_email],
        with_cav: json_request[:with_cav],
        services: json_request[:services],
      )
    end

    render(json: {
      payment_id: membership.invoice_detail.invoice.payments.first.id,
    })
  end
end

end
end
