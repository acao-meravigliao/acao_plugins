#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class MeterBus < Ygg::PublicModel
  self.table_name = 'acao_meter_buses'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "ipv4_address", type: :string, default: nil, limit: 15, null: false}],
    [ :must_have_column, {name: "port", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "name", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "descr", type: :string, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["ipv4_address","port"], unique: true}],
  ]

  has_many :meters,
            class_name: '::Ygg::Acao::Meter'

  include Ygg::Core::Loggable
  define_default_log_controller(self)
end

end
end
