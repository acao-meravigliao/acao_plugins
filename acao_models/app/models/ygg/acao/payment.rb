#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Payment < Ygg::PublicModel
  self.table_name = 'acao_payments'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :payment_services,
           class_name: 'Ygg::Acao::Payment::Service',
           embedded: true,
           autosave: true,
           dependent: :destroy

  has_one :membership,
          class_name: 'Ygg::Acao::Membership'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_acl

  include Ygg::Core::Notifiable

  def set_default_acl
    transaction do
      acl_entries.where(owner: self).destroy_all
      acl_entries << AclEntry.new(owner: self, person: person, capability: 'owner')
    end
  end

  def completed!
    raise "Payment in state #{state} cannot be confirmed" if state != 'PENDING'

    self.state = 'COMPLETED'
    self.completed_at = Time.now

    if membership
      membership.payment_completed!
      membership.save!
    end

    Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_COMPLETED', template_context: {
      first_name: person.first_name,
      code: code,
    }, objects: self)

    save!
  end


  def self.run_chores!
    all.each do |payment|
      payment.run_chores!
    end
  end

  def run_chores!
    transaction do
      now = Time.now
      last_run = last_chore || Time.new(0)

      run_expiration_chores(now: now, last_run: last_run)

      self.last_chore = now

      save!
    end
  end

  def run_expiration_chores(now:, last_run:)
    when_in_advance = 5.days - 10.hours

    if expires_at && state == 'PENDING'
      if (expires_at.beginning_of_day - when_in_advance).between?(last_run, now) && !expires_at.between?(last_run, now)
        Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_NEAR_EXPIRATION', template_context: {
          first_name: person.first_name,
          code: code,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end

      if expires_at.between?(last_run, now)
        Ygg::Ml::Msg.notify(destinations: person, template: 'PAYMENT_EXPIRED', template_context: {
          first_name: person.first_name,
          code: code,
          created_at: created_at.strftime('%Y-%m-%d'),
          expires_at: expires_at.strftime('%Y-%m-%d'),
        })
      end
    end
  end

  class Service < Ygg::BasicModel
    self.table_name = 'acao_payment_services'

    include Ygg::Core::Loggable
    define_default_log_controller(self)

    belongs_to :payment,
               class_name: 'Ygg::Acao::Payment'

    belongs_to :service_type,
               class_name: 'Ygg::Acao::ServiceType'
  end

  def build_receipt
    ric_fisc = XMLInterface::RicFisc.new do |ric_fisc|
      ric_fisc.cod_schema = 'RICFISC1'
      ric_fisc.data_ora_creazione = Time.now
      ric_fisc.docus[0] = XMLInterface::RicFisc::Docu.new do |docu|
        docu.testa = XMLInterface::RicFisc::Docu::Testa.new do |testa|
          testa.abbuono = nil
          testa.acconto = nil
          testa.acconto_in_cassa = true
          testa.calcoli_su_imponibile = false
          testa.cod_divisa = 'EUR'
          testa.cod_pagamento = 'CART'
          testa.contrassegno = nil
          testa.nostro_rif = code
          testa.dati_controparte = XMLInterface::RicFisc::Docu::Testa::DatiControparte.new
          testa.dati_controparte.citta = person.residence_location.city
          testa.dati_controparte.codice_fiscale = person.italian_fiscal_code
          testa.dati_controparte.e_mail = person.contacts.where(type: 'email').first.value
          testa.dati_controparte.indirizzo = person.residence_location.full_address
          testa.dati_controparte.partita_iva = person.vat_number
          testa.dati_controparte.ragione_sociale = person.name
        end

        docu.righe = XMLInterface::RicFisc::Docu::Righe.new do |righe|
          righe.righe[0] = XMLInterface::RicFisc::Docu::Righe::Riga.new do |riga|
            riga.cod_art = 'CONS'
            riga.cod_iva = 22
            riga.cod_un_mis = 'Nr'
            riga.descrizione = 'Pippo'
            riga.imponibile = '123.5'
            riga.importo_sconto = '0'
            riga.imposta = '30'
            riga.perc_sconto1 = 0
            riga.perc_sconto2 = 0
            riga.perc_sconto3 = 0
            riga.perc_sconto4 = 0
            riga.qta = 1
            riga.tipo_riga = 2
            riga.totale = 150
            riga.valore_unitario = 150
          end
        end
      end
    end

    noko = Nokogiri::XML::Document.new
    noko.encoding = 'UTF-8'
    noko.root = ric_fisc.to_xml

    noko
  end

  def export_receipt!
    filename = File.join(Rails.application.config.acao.onda_import_dir, "#{code}.xml")
    filename_new = filename + '.new'

    File.open(filename_new , 'w') do |file|
      file.write(build_receipt)
    end

    File.rename(filename_new, filename)
  end
end

end
end
