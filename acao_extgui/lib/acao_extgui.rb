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
  include Extgui::EngineHelper

  config.acao_extgui = ActiveSupport::OrderedOptions.new if !defined? config.acao_extgui

  def extgui_menu_tree
   lambda { {

    acao: {
      _node_: {
        position: 20,
        text: 'ACAO',
#        icon: image_path('ml/ml-16x16.png'),
      },
      flights: {
        _node_: {
          text: 'Flights',
          uri: 'model/ygg/acao/flights/',
        }
      },
      timetable: {
        _node_: {
          text: 'Timetable',
          uri: 'model/ygg/acao/timetable_entries/',
        }
      },
      pilots: {
        _node_: {
          text: 'Pilots',
          uri: 'model/ygg/acao/pilots/',
        }
      },
      aircrafts: {
        _node_: {
          text: 'Aircrafts',
          uri: 'model/ygg/acao/aircrafts/',
        }
      },
      aircraft_types: {
        _node_: {
          text: 'Aircraft Types',
          uri: 'model/ygg/acao/aircraft_types/',
        }
      },
      trackers: {
        _node_: {
          text: 'Trackers',
          uri: 'model/ygg/acao/trackers/',
        }
      },
      setup: {
        _node_: {
          text: 'Setup',
        },
        airfields: {
          _node_: {
            text: 'Airfields',
            uri: 'model/ygg/acao/airfields/',
          }
        },
      },
    },

    meters: {
      _node_: {
        position: 20,
        text: 'Meters',
#        icon: image_path('ml/ml-16x16.png'),
      },
      meters: {
        _node_: {
          text: 'Meters',
          uri: 'model/ygg/acao/meters/',
#          icon: image_path('ml/addresses-16x16.png'),
        }
      },
      meters_buses: {
        _node_: {
          text: 'Meters Buses',
          uri: 'model/ygg/acao/meter_buses/',
#          icon: image_path('ml/lists-16x16.png'),
        }
      },
    },
   } }
  end

  def extgui_config
   {
    acao: {
      radar_processed_traffic_exchange: Rails.application.config.acao_extgui.radar_processed_traffic_exchange,
    },
   }
  end
end

end
end
