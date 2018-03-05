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

  load_capabilities!

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:year) { show! }
    attribute(:status) { show! }

    attribute(:person) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    self.with_perms = true

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

  def renew_context
    person = aaa_context.auth_person
    renewal_year = Ygg::Acao::Year.renewal_year

    if !renewal_year || !renewal_year.renew_opening_time || !renewal_year.renew_announce_time
      render(json: {
        announce_time: nil,
        opening_time: nil,
      })

      return
    end

    # They may be more than one since each year covers some of the adjacent years
    active_memberships = person.acao_memberships.order(year: :asc).to_a.select(&:active?)

    membership = active_memberships.last

    context = Ygg::Acao::Membership.determine_base_context(person: person, year: renewal_year)

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
      announce_time: renewal_year.renew_announce_time,
      opening_time: renewal_year.renew_opening_time,
      membership: membership_data,
    }))
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
      payment_id: membership.payment.id,
    })
  end
end

end
end
