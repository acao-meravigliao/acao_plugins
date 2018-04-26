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

    context = Ygg::Acao::Membership.determine_base_context(person: person, year: renewal_year)

    render(json: context.merge({
      renew_for_year: renewal_year.year,
      renew_for_year_id: renewal_year.id,
      announce_time: renewal_year.renew_announce_time,
      opening_time: renewal_year.renew_opening_time,
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
