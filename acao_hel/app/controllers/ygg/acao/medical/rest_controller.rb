#
# Copyright (C) 2016-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Medical::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Medical

  load_role_defs!

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:type) { show! }
    attribute(:identifier) { show! }
    attribute(:issued_at) { show! }
    attribute(:valid_to) { show! }

    attribute(:pilot) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    attribute :pilot do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
      attribute(:handle) { show! }
      attribute(:italian_fiscal_code) { show! }
    end
  end

  build_member_roles(:blahblah) do |obj|
     aaa_context.auth_person.id == obj.pilot_id ? [ :owner ] : []
  end
end

end
end
