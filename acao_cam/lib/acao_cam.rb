#
# Copyright (C) 2008-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'acao_cam/version'

module Ygg
module Acao

class CamEngine < Rails::Engine
end

class CamPlugin < Ygg::Plugin
end

Ygg::Plugins.register(CamPlugin)

end
end
