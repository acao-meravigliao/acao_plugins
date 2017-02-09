#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Ticket::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Ticket

  view :grid do
#    empty!
#    attribute(:id) { show! }
#    attribute(:uuid) { show! }

    attribute(:aircraft_type) do
      show!
    end

#    attribute(:type) { show! }
#    attribute(:identifier) { show! }
  end
end

end
end
