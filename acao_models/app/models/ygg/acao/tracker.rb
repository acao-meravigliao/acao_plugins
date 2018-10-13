#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Tracker < Ygg::PublicModel
  self.table_name = 'acao_trackers'
  self.inheritance_column = false

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "aircraft_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "type", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "identifier", type: :string, default: nil, null: false}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["aircraft_id"], unique: false}],
    [ :must_have_fk, {to_table: "acao_aircrafts", column: "aircraft_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :aircraft,
             class_name: 'Ygg::Acao::Aircraft',
             optional: true

  include Ygg::Core::Loggable
  define_default_log_controller(self)
end

end
end
