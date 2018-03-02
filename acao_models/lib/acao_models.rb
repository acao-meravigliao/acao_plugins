#
# Copyright (C) 2008-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'acao_models/version'

module Ygg
module Acao

class ModelsEngine < Rails::Engine
  config.to_prepare do
    Ygg::Core::Person.class_eval do
#      has_one :acao_pilot,
#               class_name: '::Ygg::Acao::Pilot'

      has_many :acao_memberships,
               class_name: '::Ygg::Acao::Membership'

      has_many :acao_payments,
               class_name: '::Ygg::Acao::Payment'

      has_many :acao_roster_entries,
               class_name: '::Ygg::Acao::RosterEntry'
    end
  end
end

end
end
