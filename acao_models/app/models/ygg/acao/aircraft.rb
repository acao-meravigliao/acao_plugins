#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#


module Ygg
module Acao

class Aircraft < Ygg::PublicModel
  self.table_name = 'acao_aircrafts'

  has_many :trackers,
           class_name: 'Ygg::Acao::Tracker'

  belongs_to :aircraft_type,
             class_name: 'Ygg::Acao::AircraftType'
end

end
end
