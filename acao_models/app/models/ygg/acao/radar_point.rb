#
# Copyright (C) 2015-2015, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#
#/

module Ygg
module Acao

class RadarPoint < ActiveRecord::Base
  self.table_name = 'acao_radar_points'

  include Ygg::Core::HasPornMigration

  self.porn_migration += [
    [ :must_have_column, {name: "at", type: :datetime, default: nil, null: false}],
    [ :must_have_column, {name: "aircraft_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "lat", type: :float, default: nil, null: false}],
    [ :must_have_column, {name: "lng", type: :float, default: nil, null: false}],
    [ :must_have_column, {name: "alt", type: :float, default: nil, null: false}],
    [ :must_have_column, {name: "cog", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "sog", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "tr", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "cr", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "recorded_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "srcs", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "src", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_index, {columns: ["at"], unique: false}],
    [ :must_have_index, {columns: ["at", "aircraft_id"], unique: false}],
    [ :must_have_index, {columns: ["aircraft_id"], unique: false}],
  ]

  belongs_to :aircraft,
             class_name: 'Ygg::Acao::Aircraft'
end

end
end
