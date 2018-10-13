#
# Copyright (C) 2008-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class AircraftType < Ygg::PublicModel
  self.table_name = 'acao_aircraft_types'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "manufacturer", type: :string, default: nil, limit: 64, null: false}],
    [ :must_have_column, {name: "name", type: :string, default: nil, limit: 32, null: false}],
    [ :must_have_column, {name: "seats", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "motor", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "handicap", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "link_wp", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "handicap_club", type: :float, default: nil, null: true}],
    [ :must_have_column, {name: "wingspan", type: :decimal, scale: 1, precision: 4, default: nil, null: true}],
    [ :must_have_column, {name: "aircraft_class", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "is_vintage", type: :boolean, default: false, null: false}],
    [ :must_have_column, {name: "foldable_wings", type: :boolean, default: false, null: false}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["name"], unique: true}],
  ]

  has_many :aircrafts,
           class_name: 'Ygg::Acao::Aircraft'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  validates_presence_of :manufacturer
  validates_presence_of :name
  validates_presence_of :seats
  validates_numericality_of :seats

  validates_presence_of :motor
  validates_numericality_of :motor

  validates_numericality_of :handicap, :allow_nil => true
  validates_numericality_of :handicap_club, :allow_nil => true
end

end
end
