#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Medical < Ygg::PublicModel
  self.table_name = 'acao_medicals'
  self.inheritance_column = false

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "pilot_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "type", type: :string, default: nil, limit: 32, null: false}],
    [ :must_have_column, {name: "valid_to", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "issued_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "identifier", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["type", "identifier"], unique: true}],
    [ :must_have_index, {columns: ["pilot_id"], unique: false}],
    [ :must_have_fk, {to_table: "core_people", column: "pilot_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :pilot,
             class_name: 'Ygg::Core::Person'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_meta_class
end

end
end
