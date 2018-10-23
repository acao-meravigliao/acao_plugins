#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Invoice::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Invoice

  load_role_defs!

  attribute(:total) do
    self.type = 'decimal'
    self.writable = false
  end

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:identifier) { show! }
    attribute(:created_at) { show! }
    attribute(:expires_at) { show! }
    attribute(:completed_at) { show! }
    attribute(:first_name) { show! }
    attribute(:last_name) { show! }
    attribute(:state) { show! }
    attribute(:payment_state) { show! }
    attribute(:total) { show! }
  end

  view :edit do
    self.with_perms = true

    attribute :details do
      show!

      attribute :service_type do
        show!
      end
    end
  end

  view :full do
    attribute :details do
      show!

      attribute :service_type do
        show!
      end
    end
  end

  def authorization_prefilter
    ar_model.where(person_id: aaa_context.auth_person.id)
  end

  build_member_roles(:blahblah) do |obj|
    aaa_context.auth_person.id == obj.person_id ? [ :recipient ] : []
  end
end

end
end
