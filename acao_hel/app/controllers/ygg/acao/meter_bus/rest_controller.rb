#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class MeterBus::RestController < Ygg::Hel::RestController

  ar_controller_for Ygg::Acao::MeterBus

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:name) { show! }
    attribute(:descr) { show! }
    attribute(:ipv4_address) { show! }
    attribute(:port) { show! }
  end

  view :edit do
    self.with_perms = true
  end

end

end
end
