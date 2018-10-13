#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TimetableEntry < Ygg::PublicModel
  self.table_name = 'acao_timetable_entries'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "aircraft_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "pilot_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "takeoff_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "landing_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "tow_height", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "towed_by_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "landing_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "takeoff_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "takeoff_airfield_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "landing_airfield_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "flying_state", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "reception_state", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "tow_state", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "tow_duration", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "created_at", type: :datetime, default: nil, default_function: "now()", null: true}],
    [ :must_have_column, {name: "tow_release_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "tow_release_at", type: :datetime, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["aircraft_id"], unique: false}],
    [ :must_have_index, {columns: ["landing_airfield_id"], unique: false}],
    [ :must_have_index, {columns: ["landing_location_id"], unique: false}],
    [ :must_have_index, {columns: ["pilot_id"], unique: false}],
    [ :must_have_index, {columns: ["takeoff_airfield_id"], unique: false}],
    [ :must_have_index, {columns: ["takeoff_location_id"], unique: false}],
    [ :must_have_index, {columns: ["tow_release_location_id"], unique: false}],
    [ :must_have_index, {columns: ["towed_by_id"], unique: false}],
    [ :must_have_fk, {to_table: "acao_aircrafts", column: "aircraft_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_airfields", column: "landing_airfield_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "landing_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_pilots", column: "pilot_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_airfields", column: "takeoff_airfield_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "takeoff_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "tow_release_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_timetable_entries", column: "towed_by_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :aircraft,
             class_name: '::Ygg::Acao::Aircraft'

  belongs_to :pilot,
             class_name: '::Ygg::Core::Person',
             optional: true

  belongs_to :towed_by,
             class_name: '::Ygg::Acao::TimetableEntry',
             optional: true

  belongs_to :takeoff_location,
             class_name: '::Ygg::Core::Location',
             optional: true

  belongs_to :landing_location,
             class_name: '::Ygg::Core::Location',
             optional: true

  belongs_to :takeoff_airfield,
             class_name: '::Ygg::Acao::Airfield',
             optional: true

  belongs_to :landing_airfield,
             class_name: '::Ygg::Acao::Airfield',
             optional: true

  belongs_to :tow_release_location,
             class_name: '::Ygg::Core::Location',
             optional: true

end

end
end
