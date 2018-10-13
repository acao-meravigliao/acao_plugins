#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Meter < Ygg::PublicModel
  self.table_name = 'acao_meters'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "bus_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "bus_address", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "name", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "descr", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "notes", type: :text, default: nil, null: false}],
    [ :must_have_column, {name: "last_update", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "voltage", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "current", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "power", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "frequency", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "power_factor", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "exported_energy", type: :decimal, default: nil, precision: 10, scale: 2, null: true}],
    [ :must_have_column, {name: "imported_energy", type: :decimal, default: nil, precision: 10, scale: 2, null: true}],
    [ :must_have_column, {name: "total_energy", type: :decimal, default: nil, precision: 10, scale: 2, null: true}],
    [ :must_have_column, {name: "app_power", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "rea_power", type: :float, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["bus_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_fk, {to_table: "acao_meter_buses", column: "bus_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :bus,
             class_name: '::Ygg::Acao::MeterBus'

  belongs_to :person,
             class_name: '::Ygg::Core::Person',
             optional: true

  include Ygg::Core::Loggable
  define_default_log_controller(self)
end

end
end
