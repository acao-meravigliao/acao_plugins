#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Year < Ygg::PublicModel
  self.table_name = 'acao_years'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "year", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "renew_opening_time", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "renew_announce_time", type: :datetime, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["year"], unique: true}],
  ]

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  def self.renewal_year
    Ygg::Acao::Year.where('renew_opening_time < ?', Time.now).order(year: :desc).first
  end

  def self.next_renewal_year
    Ygg::Acao::Year.where('renew_announce_time < ?', Time.now).order(year: :desc).first
  end
end

end
end
