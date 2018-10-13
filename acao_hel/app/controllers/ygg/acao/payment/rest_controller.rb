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

  load_role_defs!

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
      attribute(:acao_code) { show! }
    end
  end

  view :edit do
    self.with_perms = true

    attribute :person do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
      attribute(:handle) { show! }
      attribute(:italian_fiscal_code) { show! }
    end
  end

  view :full do
    attribute :person do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
      attribute(:handle) { show! }
      attribute(:italian_fiscal_code) { show! }
    end
  end

  build_member_roles(:blahblah) do |obj|
     aaa_context.auth_person.id == obj.person_id ? [ :owner ] : []
  end

  def complete
    ar_retrieve_resource
    ar_authorize_member_action(resource: ar_resource, action: :complete)

    hel_transaction('Payment completed') do
      ar_resource.completed!
    end

    ar_respond_with({})
  end

  def satispay_callback
    charge_id = request.query_parameters[:charge_id]

    charge = Ygg::Acao::Payment::SatispayCharge.find_by!(charge_id: charge_id)

    begin
      hel_transaction('Satispay state change') do
        charge.sync!
      end
    rescue AM::Satispay::Client::GenericError
    end

    ar_respond_with({ thanks: true })
  end
end

end
end
