#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Membership < Ygg::PublicModel
  self.table_name = 'acao_memberships'

  belongs_to :person,
             class_name: '::Ygg::Core::Person'

  belongs_to :payment,
             class_name: 'Ygg::Acao::Payment'
end

end
end
