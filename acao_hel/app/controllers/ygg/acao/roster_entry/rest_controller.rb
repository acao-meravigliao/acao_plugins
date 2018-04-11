#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class RosterEntry::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::RosterEntry

  load_capabilities!

  action :offer
  action :offer_cancel
  action :offer_accept

  view :grid do
    empty!

    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:chief) { show! }
    attribute(:selected_at) { show! }

    attribute :roster_day do
      show!
    end

    attribute :person do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    attribute :roster_day do
      show!
    end

    attribute :person do
      show!
    end
  end

  def ar_apply_filter(rel, filter)
    if filter['today']
      (attr, path) = rel.nested_attribute('roster_day.date')
      rel = rel.joins(path[0..-1].reverse.inject { |a,x| { x => a } }) if path.any?
      rel = rel.where(attr.eq(Time.now))
    else
      rel = rel.where(filter)
    end

    rel
  end

  def get_status
    person = aaa_context.auth_person.becomes(Ygg::Acao::Pilot)

    renewal_year = Ygg::Acao::Year.renewal_year

    if !renewal_year
      ar_respond_with({
        renew_for_year: nil,
        needed_entries_present: true,
        needed_total: 0,
        needed_high_season: 0,
        can_select_entries: false,
      })

      return
    end

    membership = person.acao_memberships.find_by(year: renewal_year.year)

    needed_entries_present = nil
    needed_total = nil
    needed_high_season = nil
    can_select_entries = false
    roster_entries = nil

    res = {
      renew_for_year: renewal_year.year,
    }

    if membership && (membership.status == 'COMPLETED' || membership.status == 'WAITING_PAYMENT')
      roster_entries_needed = person.roster_entries_needed(year: renewal_year.year)
      needed_entries_present = person.roster_needed_entries_present(year: renewal_year.year)

      res.merge!(
        can_select_entries: true,
        needed_total: roster_entries_needed[:total],
        needed_high_season: roster_entries_needed[:high_season],
        needed_entries_present: needed_entries_present,
        possible_roster_chief: membership ? membership.possible_roster_chief : false,
      )
    end

    ar_respond_with(res)
  end

  def offer
    ar_retrieve_resource
    ar_authorize_member_action(resource: ar_resource, action: :offer)

    hel_transaction('Offered for exchange') do
      ar_resource.offer!
    end

    ar_respond_with({})
  end

  def offer_cancel
    ar_retrieve_resource
    ar_authorize_member_action(resource: ar_resource, action: :offer_cancel)

    hel_transaction('Exchange offer canceled') do
      ar_resource.offer_cancel!
    end

    ar_respond_with({})
  end

  def offer_accept
    ar_retrieve_resource
    ar_authorize_member_action(resource: ar_resource, action: :offer_accept)

    hel_transaction('Exchange offer accepted') do
      ar_resource.offer_accept!(from_user: aaa_context.auth_person)
    end

    ar_respond_with({})
  end
end

end
end
