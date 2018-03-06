#
# Copyright (C) 2018-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TokenTransaction < Ygg::PublicModel
  self.table_name = 'acao_token_transactions'

  belongs_to :person,
             class_name: '::Ygg::Core::Person'
end

end
end
