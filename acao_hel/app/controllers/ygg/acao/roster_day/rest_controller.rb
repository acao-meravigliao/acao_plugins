#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class RosterDay::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::RosterDay

  view :_default_ do
    attribute :roster_entries do
      attribute :person do
        show!
        empty!
        attribute(:id) { show! }
        attribute(:first_name) { show! }
        attribute(:last_name) { show! }
      end
    end
  end
end

end
end
