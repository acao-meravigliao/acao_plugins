#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class RosterEntry < Ygg::PublicModel
  self.table_name = 'acao_roster_entries'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  belongs_to :roster_day,
             class_name: 'Ygg::Acao::RosterDay'

  after_initialize do
    if new_record?
      self.selected_at = Time.now
    end
  end

  def offer!
    self.on_offer_since = Time.now
    save!
  end

  def offer_cancel!
    self.on_offer_since = nil
    save!
  end

  def offer_accept!(from_person:)
    transaction do
      self.on_offer_since = nil
      self.person = from_person
      # Regenerate ACLs?
      save!

      # Send notification
    end
  end
end

end
end
