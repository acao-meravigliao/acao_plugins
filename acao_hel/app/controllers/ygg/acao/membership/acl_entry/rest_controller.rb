#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Membership::AclEntry::RestController
  include ActiveRest::Controller::Basic

  ar_controller_for Membership::AclEntry
end

end
end
