#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Tracker::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Tracker

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }

    attribute(:aircraft) do
      show!
      empty!
      attribute(:registration) { show! }
    end

    attribute(:type) { show! }
    attribute(:identifier) { show! }
  end

end

end
end
