#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class RosterDay::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::RosterDay

  load_capabilities!

  view :_default_ do
    attribute :roster_entries do
      attribute :person do
        show!
        empty!
        attribute(:id) { show! }
        attribute(:first_name) { show! }
        attribute(:last_name) { show! }
      end
    end
  end

  def ar_apply_filter(rel, filter)
    if filter && filter[:year]
      year = Time.new(filter.delete(:year))
      rel = rel.where(date: (year.beginning_of_year..year.end_of_year))
    end

    rel = super(rel, filter)

    rel
  end

end

end
end
