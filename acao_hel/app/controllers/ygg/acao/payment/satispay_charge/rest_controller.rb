#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment::SatispayCharge::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Payment::SatispayCharge
end

end
end
