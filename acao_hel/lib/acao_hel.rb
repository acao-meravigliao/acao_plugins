#
# Copyright (C) 2008-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'acao_hel/version'

module Ygg
module Acao

class HelEngine < Rails::Engine
end

class HelPlugin < Ygg::Plugin
end

Ygg::Plugins.register(HelPlugin)

end
end
