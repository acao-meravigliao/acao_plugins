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

  belongs_to :pilot,
             class_name: 'Ygg::Acao::Pilot'

  has_meta_class

  def self.with_any_capability(aaa_context)
    where(arel_table[:pilot_id].eq(aaa_context.auth_person.id))
  end

  append_capabilities_for(:blahblah) do |aaa_context|
     aaa_context.auth_person.id == pilot_id ? [ :owner ] : []
  end
end

end
end
