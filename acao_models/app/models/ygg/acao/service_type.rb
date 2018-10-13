#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class ServiceType < Ygg::PublicModel
  self.table_name = 'acao_service_types'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "symbol", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "name", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "price", type: :decimal, default: nil, precision: 10, scale: 4, null: true}],
    [ :must_have_column, {name: "extra_info", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "notes", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "descr", type: :text, default: nil, null: true}],
    [ :must_have_column, {name: "available_for_shop", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "available_for_membership_renewal", type: :boolean, default: false, null: true}],
    [ :must_have_column, {name: "onda_1_type", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "onda_1_code", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "onda_1_cnt", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "onda_2_type", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "onda_2_code", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "onda_2_cnt", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["symbol"], unique: true}],
  ]

  has_many :person_services,
           class_name: 'Ygg::Acao::PersonService'

  has_meta_class

  include Ygg::Core::Loggable
  define_default_log_controller(self)
end

end
end
