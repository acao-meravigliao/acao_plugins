#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Trailer < Ygg::PublicModel
  self.table_name = 'acao_trailers'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "identifier", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "zone", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "aircraft_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "notes", type: :text, default: nil, null: true}],
    [ :must_have_column, {name: "payment_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["aircraft_id"], unique: false}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_index, {columns: ["identifier"], unique: true}],
    [ :must_have_fk, {to_table: "acao_aircrafts", column: "aircraft_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :person,
             class_name: '::Ygg::Core::Person',
             optional: true

  belongs_to :aircraft,
             class_name: '::Ygg::Acao::Aircraft',
             optional: true

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  before_save do
    if person_id_changed?
      self.class.readables_set_dirty
    end
  end
end

end
end
