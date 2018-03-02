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

  belongs_to :person,
             class_name: '::Ygg::Core::Person',
             optional: true

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
