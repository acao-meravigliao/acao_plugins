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

  def compute_completed_years(from, to)
    # Number of completed years is not trivial :)

    completed_years = to.year - from.year

    if from.month > to.month ||
       (from.month == to.month && from.day > to.day)
      completed_years -= 1
    end

    completed_years
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

      roster_entries = person.acao_roster_entries.joins(:roster_day).where('acao_roster_days.date': (
        DateTime.new(renewal_year.year).beginning_of_year..
        DateTime.new(renewal_year.year).end_of_year
      ))

      roster_entries_high = roster_entries.where('acao_roster_days.high_season')

      ren_time = Ygg::Acao::Year.renewal_year.renew_opening_time

      if person.birth_date
        age_on_renewal_day = compute_completed_years(person.birth_date, ren_time)

        if age_on_renewal_day >= 65
          needed_total = 0
          needed_high_season = 0
        elsif membership.board_member
          needed_total = 1
          needed_high_season = 0
        elsif membership.tug_pilot
          needed_total = 1
          needed_high_season = 0
        elsif membership.instructor
          needed_total = 0
          needed_high_season = 0
        else
          needed_total = 2
          needed_high_season = 1
        end
      else
        needed_total = 2
        needed_high_season = 1
      end

      needed_entries_present = roster_entries.count >= needed_total && roster_entries_high.count >= needed_high_season
    end

    ar_respond_with({
      renew_for_year: renewal_year.year,
      needed_entries_present: needed_entries_present,
      needed_total: needed_total,
      needed_high_season: needed_high_season,
      can_select_entries: can_select_entries,
      possible_roster_chief: membership ? membership.possible_roster_chief : false,
    })
  end
end

end
end
