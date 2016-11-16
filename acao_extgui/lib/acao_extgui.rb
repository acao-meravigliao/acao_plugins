#
# Copyright (C) 2008-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'acao_extgui/version'

module Ygg
module Acao

class ExtguiEngine < Rails::Engine
end

class ExtguiPlugin < Ygg::Plugin
  def extgui_menu_tree
   lambda { {
    meters: {
      _node_: {
        position: 20,
        text: 'Meters',
#        icon: image_path('ml/ml-16x16.png'),
      },
      meters: {
        _node_: {
          text: 'Meters',
          uri: 'ygg/acao/meters/',
#          icon: image_path('ml/addresses-16x16.png'),
        }
      },
      meters_buses: {
        _node_: {
          text: 'Meters Buses',
          uri: 'ygg/acao/meter_buses/',
#          icon: image_path('ml/lists-16x16.png'),
        }
      },
    },
   } }
  end
end

Ygg::Plugins.register(ExtguiPlugin)

end
end
