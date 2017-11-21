#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class ServiceType::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::ServiceType

  capability(:anonymous,
    allow_all_actions: true,
    all_readable: true,
    all_writable: false,
    all_creatable: false,
    recursive: true,
  )
end

end
end
