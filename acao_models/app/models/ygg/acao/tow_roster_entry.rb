#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TowRosterEntry < Ygg::PublicModel
  self.table_name = 'acao_tow_roster_entries'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "day_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "selected_at", type: :datetime, default: nil, null: false}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["day_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_fk, {to_table: "acao_tow_roster_days", column: "day_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  belongs_to :day,
             class_name: 'Ygg::Acao::TowRosterDay'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  after_initialize do
    if new_record?
      self.selected_at = Time.now
    end
  end

  before_save do
    if person_id_changed?
      self.class.readables_set_dirty
    end
  end

end

end
end
