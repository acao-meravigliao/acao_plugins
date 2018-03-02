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
end

end
end
