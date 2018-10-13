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

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "payment_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "charge_id", type: :string, default: nil, limit: 64, null: true}],
    [ :must_have_column, {name: "user_id", type: :string, default: nil, limit: 64, null: true}],
    [ :must_have_column, {name: "user_phone_number", type: :string, default: nil, limit: 64, null: true}],
    [ :must_have_column, {name: "status", type: :string, default: nil, limit: 64, null: true}],
    [ :must_have_column, {name: "status_details", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "user_short_name", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "charge_date", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "amount", type: :decimal, default: nil, precision: 8, scale: 2, null: true}],
    [ :must_have_column, {name: "idempotency_key", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_column, {name: "description", type: :string, default: nil, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["charge_id"], unique: true}],
    [ :must_have_index, {columns: ["payment_id"], unique: false}],
    [ :must_have_index, {columns: ["user_id"], unique: false}],
    [ :must_have_index, {columns: ["user_phone_number"], unique: false}],
    [ :must_have_fk, {to_table: "acao_payments", column: "payment_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

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
