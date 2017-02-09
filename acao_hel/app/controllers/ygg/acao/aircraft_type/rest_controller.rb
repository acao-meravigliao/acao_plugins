#
# Copyright (C) 2008-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class AircraftType::RestController < Ygg::Hel::RestController

  ar_controller_for AircraftType

#  view :combo do
#    empty!
#    attribute(:id) { show! }
#    attribute(:name) { show! }
#    attribute(:configurations) do
#      show!
#    end
#  end
#
#  filter :combo, lambda { |r| apply_search_to_relation(r, [ 'name' ]) }

end

end
end
