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

  belongs_to :person,
             class_name: '::Ygg::Core::Person'

  belongs_to :payment,
             class_name: 'Ygg::Acao::Payment',
             optional: true

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  append_capabilities_for(:blahblah) do |aaa_context|
     aaa_context.auth_person.id == person_id ? [ :owner ] : []
  end

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
