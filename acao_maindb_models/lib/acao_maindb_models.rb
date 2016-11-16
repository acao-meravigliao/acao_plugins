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

class MaindbModelsEngine < Rails::Engine
end

class MaindbModelsPlugin < Ygg::Plugin
end

Ygg::Plugins.register(MaindbModelsPlugin)

end
end
