#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Aircraft::JapiController < Ygg::Hel::JapiController
  ar_controller_for Ygg::Acao::Aircraft

  skip_before_action :ensure_authenticated_and_authorized!
end

end
end
