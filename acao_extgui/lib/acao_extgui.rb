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
#      members: {
#        _node_: {
#          text: 'Soci',
#          uri: 'model/ygg/acao/members/',
#        }
#      },
      memberships: {
        _node_: {
          text: 'Associazioni',
          uri: 'model/ygg/acao/memberships/',
        }
      },
      member_services: {
        _node_: {
          text: 'Servizi',
          uri: 'model/ygg/acao/member_services/',
        }
      },
      licenses: {
        _node_: {
          text: 'Licenze',
          uri: 'model/ygg/acao/licenses/',
        }
      },
      medicals: {
        _node_: {
          text: 'Visite Mediche',
          uri: 'model/ygg/acao/medicals/',
        }
      },
      invoices: {
        _node_: {
          text: 'Fatture',
          uri: 'model/ygg/acao/invoices/',
        }
      },
      payments: {
        _node_: {
          text: 'Pagamenti',
          uri: 'model/ygg/acao/payments/',
        }
      },
      trailers: {
        _node_: {
          text: 'Carrelli',
          uri: 'model/ygg/acao/trailers/',
        }
      },
      roster_entries: {
        _node_: {
          text: 'Turni di linea',
          uri: 'model/ygg/acao/roster_entries/',
        }
      },
      flights: {
        _node_: {
          text: 'Voli',
          uri: 'model/ygg/acao/flights/',
        }
      },
      timetable: {
        _node_: {
          text: 'Tabella Giornaliera',
          uri: 'model/ygg/acao/timetable_entries/',
        }
      },
      aircrafts: {
        _node_: {
          text: 'Aeromobili',
          uri: 'model/ygg/acao/aircrafts/',
        }
      },
      setup: {
        _node_: {
          text: 'Setup',
        },
        aircraft_types: {
          _node_: {
            text: 'Aircraft Types',
            uri: 'model/ygg/acao/aircraft_types/',
          }
        },
        airfields: {
          _node_: {
            text: 'Airfields',
            uri: 'model/ygg/acao/airfields/',
          }
        },
        clubs: {
          _node_: {
            text: 'Club',
            uri: 'model/ygg/acao/clubs/',
          }
        },
        service_types: {
          _node_: {
            text: 'Service Types',
            uri: 'model/ygg/acao/service_types/',
          }
        },
        roster_days: {
          _node_: {
            text: 'Giorni di linea',
            uri: 'model/ygg/acao/roster_days/',
          }
        },
        years: {
          _node_: {
            text: 'Years',
            uri: 'model/ygg/acao/years/',
          }
        },
        trackers: {
          _node_: {
            text: 'Trackers',
            uri: 'model/ygg/acao/trackers/',
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
