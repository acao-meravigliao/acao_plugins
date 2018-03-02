#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Meter < Ygg::PublicModel
  self.table_name = 'acao_meters'

  belongs_to :bus,
             class_name: '::Ygg::Acao::MeterBus'

  belongs_to :person,
             class_name: '::Ygg::Core::Person',
             optional: true

end

end
end
