#
# Copyright (C) 2018-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment::SatispayCharge < Ygg::PublicModel
  self.table_name = 'acao_payment_satispay_charges'

  belongs_to :payment,
             class_name: 'Ygg::Acao::Payment'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  require 'am/satispay'

  def satispay
    @satispay ||= AM::Satispay::Client.new(bearer: Rails.application.secrets.satispay_bearer,
                                           http_debug: Rails.application.config.acao.satispay_http_debug || 0)
  end

  def initiate!
    user = satispay.user_create(phone_number: user_phone_number)

    self.user_id = user[:id]
    save!

    charge = satispay.charge_create(
      user_id: self.user_id,
      description: description,
      currency: 'EUR',
      amount: (amount * 100).truncate,
      metadata: { },
      expire_in: 900,
      callback_url: Rails.application.config.acao.satispay_callback_url,
      idempotency_key: idempotency_key,
    )

    sync_charge(charge)

    save!
  end

  def sync!
    charge = satispay.charge_get(charge_id: charge_id)

    sync_charge(charge)

    if status_was == 'REQUIRED' && status == 'SUCCESS'
      save!
      payment.completed!
    else
      save!
    end
  end

  def sync_charge(charge)
    self.charge_id = charge[:id]
    self.status = charge[:status]
    self.status_details = charge[:status_details]
    self.user_short_name = charge[:user_short_name]
    self.charge_date = charge[:charge_date]
  end

  def cancel!
    raise "Cannot cancel in status #{status}" if status != 'REQUIRED'

    satispay.charge_update(charge_id: charge_id, charge_state: 'CANCELED')
  end
end

end
end
