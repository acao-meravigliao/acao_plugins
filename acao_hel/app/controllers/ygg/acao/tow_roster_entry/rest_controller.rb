#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TowRosterEntry::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::TowRosterEntry

  view :grid do
    empty!

    attribute(:id) { show! }
    attribute(:uuid) { show! }
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

end

end
end
