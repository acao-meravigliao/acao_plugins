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

  load_capabilities!

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:symbol) { show! }
    attribute(:name) { show! }
    attribute(:price) { show! }
  end

  view :edit do
    self.with_perms = true
  end
end

end
end
