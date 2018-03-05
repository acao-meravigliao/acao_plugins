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

  # FIXME FIXME FIXME FIXME
  capability(:anonymous,
    allow_all_actions: true,
    all_readable: true,
    all_writable: true,
    all_creatable: true,
    recursive: true,
  )

  view :grid do
    empty!

    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:chief) { show! }

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
    person = aaa_context.auth_person

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

    if membership && (membership.status == 'COMPLETED' || membership.status == 'WAITING_PAYMENT')
      can_select_entries = true
      roster_entries_needed = person.roster_entries_needed(year: renewal_year.year)
      needed_entries_present = person.roster_needed_entries_present(year: renewal_year.year)
    end

    ar_respond_with({
      renew_for_year: renewal_year.year,
      needed_entries_present: needed_entries_present,
      needed_total: roster_entries_needed[:total],
      needed_high_season: roster_entries_needed[:high_season],
      can_select_entries: can_select_entries,
      possible_roster_chief: membership ? membership.possible_roster_chief : false,
    })
  end
end

end
end
