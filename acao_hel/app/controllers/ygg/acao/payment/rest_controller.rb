#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Payment

  load_capabilities!

  action :complete

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:code) { show! }
    attribute(:state) { show! }
    attribute(:created_at) { show! }
    attribute(:expires_at) { show! }
    attribute(:completed_at) { show! }

    attribute :person do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute :payment_services do
      show!
      empty!
      attribute(:price) { show! }
    end
  end

  view :edit do
    self.with_perms = true

    attribute :payment_services do
    end

    attribute :person do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
      attribute(:handle) { show! }
      attribute(:italian_fiscal_code) { show! }
    end

    attribute :acl_entries do
      show!
      attribute :group do
        show!
        empty!
        attribute(:name) { show! }
      end
      attribute :person do
        show!
        empty!
        attribute(:first_name) { show! }
        attribute(:last_name) { show! }
        attribute(:handle) { show! }
        attribute(:italian_fiscal_code) { show! }
      end
    end
  end

  def complete
    ar_retrieve_resource
    ar_authorize_member_action(resource: ar_resource, action: :complete)

    hel_transaction('Payment completed') do
      ar_resource.completed!
    end

    ar_respond_with({})
  end
end

end
end
