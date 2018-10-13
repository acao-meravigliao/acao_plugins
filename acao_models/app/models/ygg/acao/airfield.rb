#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Airfield < Ygg::PublicModel
  self.table_name = 'acao_airfields'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "name", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "location_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "radius", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "icao_code", type: :string, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "symbol", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["icao_code"], unique: false}],
    [ :must_have_index, {columns: ["symbol"], unique: false}],
    [ :must_have_index, {columns: ["location_id"], unique: false}],
    [ :must_have_fk, {to_table: "core_locations", column: "location_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :location,
             class_name: '::Ygg::Core::Location',
             embedded: true,
             autosave: true

  include Ygg::Core::Loggable
  define_default_log_controller(self)
end

end
end
