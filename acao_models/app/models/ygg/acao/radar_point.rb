#
# Copyright (C) 2015-2015, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#
#/

module Ygg
module Acao

class RadarPoint < ActiveRecord::Base
  self.table_name = 'acao_radar_points'

  belongs_to :aircraft,
             class_name: 'Ygg::Acao::Aircraft'
end

end
end
