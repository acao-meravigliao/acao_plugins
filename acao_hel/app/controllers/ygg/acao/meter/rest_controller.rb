#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Meter::RestController < Ygg::Hel::RestController

  ar_controller_for Ygg::Acao::Meter

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:name) { show! }
    attribute(:descr) { show! }
    attribute(:person) { show! }
    attribute(:power) { show! }
    attribute(:total_energy) { show! }
  end

  view :edit do
    self.with_perms = true
    attribute(:person) { show! }
    attribute(:bus) { show! }
  end

end

end
end
