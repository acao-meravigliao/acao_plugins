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

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "chief", type: :boolean, default: nil, null: false}],
    [ :must_have_column, {name: "notes", type: :text, default: nil, null: true}],
    [ :must_have_column, {name: "roster_day_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "selected_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "on_offer_since", type: :datetime, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_index, {columns: ["roster_day_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id", "roster_day_id"], unique: true}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_roster_days", column: "roster_day_id", primary_key: "id", on_delete: :cascade, on_update: nil}],
  ]

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  belongs_to :roster_day,
             class_name: 'Ygg::Acao::RosterDay'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

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
