#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class License < Ygg::PublicModel
  self.table_name = 'acao_licenses'
  self.inheritance_column = false

  belongs_to :pilot,
             class_name: 'Ygg::Acao::Pilot'

  has_many :ratings,
           class_name: '::Ygg::Acao::License::Rating',
           embedded: true,
           autosave: true,
           dependent: :destroy

  has_meta_class

  def self.with_any_capability(aaa_context)
    where(arel_table[:pilot_id].eq(aaa_context.auth_person.id))
  end

  append_capabilities_for(:blahblah) do |aaa_context|
    pilot_id == aaa_context.auth_person.id ? [ :owner ] : []
  end

  class Rating < Ygg::BasicModel
    self.table_name = 'acao_license_ratings'
    self.inheritance_column = false

    belongs_to :license,
               class_name: '::Ygg::Acao::License'
  end
end

end
end
