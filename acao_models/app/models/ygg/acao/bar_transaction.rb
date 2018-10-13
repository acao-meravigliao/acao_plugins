#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class BarTransaction < Ygg::PublicModel
  self.table_name = 'acao_bar_transactions'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "prev_credit", type: :decimal, default: nil, precision: 14, scale: 6, null: true}],
    [ :must_have_column, {name: "credit", type: :decimal, default: nil, precision: 14, scale: 6, null: true}],
    [ :must_have_column, {name: "amount", type: :decimal, default: nil, precision: 14, scale: 6, null: false}],
    [ :must_have_column, {name: "descr", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "recorded_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "session_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "cnt", type: :integer, default: 1, limit: 4, null: false}],
    [ :must_have_column, {name: "unit", type: :string, default: "€", null: false}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["recorded_at"], unique: false}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_http_sessions", column: "session_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :person,
             class_name: '::Ygg::Core::Person'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

#  has_acl
#
#  include Ygg::Core::Notifiable
#
#  def set_default_acl
#    transaction do
#      acl_entries.where(owner: self).destroy_all
#      acl_entries << AclEntry.new(owner: self, person: person, capability: 'owner')
#    end
#  end
end

end
end
