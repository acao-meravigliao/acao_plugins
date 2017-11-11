#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class RosterDay < Ygg::PublicModel
  self.table_name = 'acao_roster_days'

  has_many :roster_entries,
           class_name: 'Ygg::Acao::RosterEntry'

  def self.init_for_year(year: Time.now.year)
    day = Time.new(year).beginning_of_week
    day = day.next_week if day.year < year

    transaction do
      while day.year == year do
        create_day_with_policies(day + 5.days) if (day + 5.days).year == year # Saturday
        create_day_with_policies(day + 6.days) if (day + 6.days).year == year # Sunday

        day += 1.week
      end
    end
  end

  def self.create_day_with_policies(day)
    high_season = day.between?(Time.new(day.year, 3, 1).beginning_of_day, Time.new(day.year, 9, 30).end_of_day)
    needed_people = high_season ? 4 : 3

    self.create(
      date: day,
      high_season: high_season,
      needed_people: needed_people,
    )
  end
end

end
end
