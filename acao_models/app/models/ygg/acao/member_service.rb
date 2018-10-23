#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class MemberService < Ygg::PublicModel
  self.table_name = 'acao_member_services'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "service_type_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "payment_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "valid_from", type: :datetime, null: false}],
    [ :must_have_column, {name: "valid_to", type: :datetime, null: false}],
    [ :must_have_column, {name: "service_data", type: :text, null: true}],
    [ :must_have_column, {name: "invoice_detail_id", type: :uuid, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_index, {columns: ["invoice_detail_id"], unique: false}],
    [ :must_have_index, {columns: ["service_type_id"], unique: false}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_invoice_details", column: "invoice_detail_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_service_types", column: "service_type_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  belongs_to :invoice_detail,
             class_name: 'Ygg::Acao::Invoice::Detail',
             optional: true

  belongs_to :service_type,
             class_name: 'Ygg::Acao::ServiceType'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  def payment_completed!
  end
end

end
end
