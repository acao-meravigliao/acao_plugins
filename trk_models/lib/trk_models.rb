#
# Copyright (C) 2008-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'trk_models/version'

module Ygg
module Trk

class ModelsEngine < Rails::Engine
end

class ModelsPlugin < Ygg::Plugin
end

Ygg::Plugins.register(ModelsPlugin)

end
end
