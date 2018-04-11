#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment::Service::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Payment::Service

  load_capabilities!
end

end
end
