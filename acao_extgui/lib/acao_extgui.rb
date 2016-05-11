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
end

Ygg::Plugins.register(ExtguiPlugin)

end
end
