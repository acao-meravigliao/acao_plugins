#
# Copyright (C) 2016-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class License::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::License

  load_role_defs!

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:type) { show! }
    attribute(:identifier) { show! }
    attribute(:issued_at) { show! }
    attribute(:valid_to) { show! }
    attribute(:valid_to2) { show! }

    attribute(:pilot) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute(:ratings) do
      show!
      empty!
      attribute(:type) { show! }
    end
  end

  view :edit do
    self.with_perms = true

    attribute :pilot do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
      attribute(:handle) { show! }
      attribute(:italian_fiscal_code) { show! }
    end

    attribute(:ratings) do
      show!
    end
  end

  def authorization_prefilter
    ar_model.where(pilot_id: aaa_context.auth_person.id)
  end

  build_member_roles(:blahblah) do |obj|
    obj.pilot_id == aaa_context.auth_person.id ? [ :owner ] : []
  end
end

end
end
