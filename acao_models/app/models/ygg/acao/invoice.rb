#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Invoice < Ygg::PublicModel
  self.table_name = 'acao_invoices'

  self.porn_migration += [
    [ :must_have_column, {name: "id", type: :uuid, null: false, default: 'gen_random_uuid()' }],
    [ :must_have_column, {name: "identifier", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "person_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "first_name", type: :string, default: nil, limit: 255, null: true}],
    [ :must_have_column, {name: "last_name", type: :string, default: nil, limit: 255, null: true}],
    [ :must_have_column, {name: "address", type: :string, default: nil, limit: 255, null: true}],
    [ :must_have_column, {name: "created_at", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "notes", type: :text, default: nil, null: true}],
    [ :must_have_column, {name: "payment_method", type: :string, default: nil, limit: 32, null: false}],
    [ :must_have_column, {name: "last_chore", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "onda_export_status", type: :string, default: nil, limit: 32, null: true}],
    [ :must_have_index, {columns: ["identifier"], unique: true}],
    [ :must_have_index, {columns: ["person_id"], unique: false}],
    [ :must_have_fk, {to_table: "core_people", column: "person_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  has_meta_class

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  has_many :details,
           class_name: 'Ygg::Acao::Invoice::Detail',
           embedded: true,
           dependent: :destroy,
           autosave: true

  has_many :payments,
           class_name: 'Ygg::Acao::Payment'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  include Ygg::Core::Notifiable

  after_initialize do
    if new_record?
      if person
        self.first_name = person.first_name
        self.last_name = person.last_name
        self.address = person.residence_location && person.residence_location.full_address
      end

#      code = nil
#
#      loop do
#        code = "A-" + Password.random(4, symbols: 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789')
#        break if !self.class.find_by_code(code)
#      end
#
#      self.code = code
    end
  end

  def total
    details.reduce(0) { |a,x| a + x.price }
  end

  def close!
  end

  def generate_payment!(reason: "Pagamento fattura", timeout: 10.days)
    Ygg::Acao::Payment.create(
      person: person,
      invoice: self,
      created_at: Time.now,
      expires_at: Time.now + timeout,
      payment_method: payment_method,
      reason_for_payment: reason,
      amount: total,
    )
  end


  def self.run_chores!
    all.each do |invoice|
      invoice.run_chores!
    end
  end

  def run_chores!
    transaction do
      now = Time.now
      last_run = last_chore || Time.new(0)



      self.last_chore = now

      save!
    end
  end

  PAYMENT_METHOD_MAP = {
    'WIRE'      => 'BB',
    'CHECK'     => 'AS',
    'SATISPAY'  => 'SP',
    'CARD'      => 'CC',
    'CASH'      => 'CO',
  }

  def build_xml_for_onda
    cod_pagamento = PAYMENT_METHOD_MAP[payment_method.upcase]

    ric_fisc = XMLInterface::RicFisc.new do |ric_fisc|
      ric_fisc.cod_schema = 'RICFISC1'
      ric_fisc.data_ora_creazione = Time.now
      ric_fisc.docus[0] = XMLInterface::RicFisc::Docu.new do |docu|
        docu.testa = XMLInterface::RicFisc::Docu::Testa.new do |testa|
          testa.abbuono = 0
          testa.acconto = 0
          testa.acconto_in_cassa = true
          testa.calcoli_su_imponibile = false
          testa.cod_divisa = 'EUR'
          testa.cod_pagamento = cod_pagamento
          testa.contrassegno = 0
          testa.nostro_rif = code
          testa.tot_documento = 0
          testa.tot_imponibile = 0
          testa.tot_imposta = 0
          testa.vostro_rif = code
          testa.dati_controparte = XMLInterface::RicFisc::Docu::Testa::DatiControparte.new
          testa.dati_controparte.citta = person.residence_location.city
          testa.dati_controparte.codice_fiscale = person.italian_fiscal_code || person.vat_number
          testa.dati_controparte.e_mail = person.contacts.where(type: 'email').first.value
          testa.dati_controparte.indirizzo = person.residence_location.full_address
          testa.dati_controparte.partita_iva = person.vat_number
          testa.dati_controparte.ragione_sociale = person.name
        end

        docu.righe = XMLInterface::RicFisc::Docu::Righe.new do |righe|
          payment_services.each do |svc|
            if onda_1_code
              righe.righe << XMLInterface::RicFisc::Docu::Righe::Riga.new do |riga|
                riga.cod_art = onda_1_code
                riga.cod_iva = ''
                riga.cod_un_mis = 'NR.'
                riga.descrizione = ''
                riga.imponibile = ''
                riga.importo_sconto = 0
                riga.imposta = ''
                riga.perc_sconto1 = 0
                riga.perc_sconto2 = 0
                riga.perc_sconto3 = 0
                riga.perc_sconto4 = 0
                riga.qta = onda_1_cnt
                riga.tipo_riga = onda_1_type
                riga.totale = ''
                riga.valore_unitario = ''

                riga.dati_art_serv = XMLInterface::RicFisc::Docu::Righe::Riga::DatiArtServ.new do |dati_art_serv|
                  dati_art_serv.cod_art = onda_1_code
                  dati_art_serv.cod_un_mis_base = 'NR.'
                  dati_art_serv.descrizione = ''
                  dati_art_serv.tipo_articolo = onda_1_type
                end
              end
            end

            if onda_2_code
              righe.righe << XMLInterface::RicFisc::Docu::Righe::Riga.new do |riga|
                riga.cod_art = onda_2_code
                riga.cod_iva = ''
                riga.cod_un_mis = 'NR.'
                riga.descrizione = ''
                riga.imponibile = ''
                riga.importo_sconto = 0
                riga.imposta = ''
                riga.perc_sconto1 = 0
                riga.perc_sconto2 = 0
                riga.perc_sconto3 = 0
                riga.perc_sconto4 = 0
                riga.qta = onda_2_cnt
                riga.tipo_riga = onda_2_type
                riga.totale = ''
                riga.valore_unitario = ''

                riga.dati_art_serv = XMLInterface::RicFisc::Docu::Righe::Riga::DatiArtServ.new do |dati_art_serv|
                  dati_art_serv.cod_art = onda_2_code
                  dati_art_serv.cod_un_mis_base = 'NR.'
                  dati_art_serv.descrizione = ''
                  dati_art_serv.tipo_articolo = onda_2_type
                end
              end
            end
          end

          righe.righe << XMLInterface::RicFisc::Docu::Righe::Riga.new do |riga|
            riga.cod_art = ''
            riga.cod_iva = ''
            riga.cod_un_mis = ''
            riga.descrizione = "Acquisto online, codice pagamento #{code}"
            riga.imponibile = ''
            riga.importo_sconto = 0
            riga.imposta = ''
            riga.perc_sconto1 = 0
            riga.perc_sconto2 = 0
            riga.perc_sconto3 = 0
            riga.perc_sconto4 = 0
            riga.qta = 0
            riga.tipo_riga = 3
            riga.totale = ''
            riga.valore_unitario = ''

            riga.dati_art_serv = XMLInterface::RicFisc::Docu::Righe::Riga::DatiArtServ.new do |dati_art_serv|
              dati_art_serv.cod_art = '00000'
              dati_art_serv.cod_un_mis_base = 'NR.'
              dati_art_serv.descrizione = ''
              dati_art_serv.tipo_articolo = 2
            end
          end
        end

        docu.coda = XMLInterface::RicFisc::Docu::Coda.new do |coda|
          coda.aliquota1 = 0
          coda.aliquota2 = 0
          coda.aliquota3 = 0
          coda.aliquota4 = 0
          coda.aliquota5 = 0
          coda.castelletto_manuale = false
          coda.causale_trasporto = ''
          coda.cod_iva1 = 0
          coda.cod_iva2 = 0
          coda.cod_iva3 = 0
          coda.cod_iva4 = 0
          coda.cod_iva5 = 0
          coda.cod_trasporto = 0
          coda.id_indirizzo_fattura = 0
          coda.id_indirizzo_merce = 0
          coda.id_vettore1 = 0
          coda.imponibile1 = 0
          coda.imponibile2 = 0
          coda.imponibile3 = 0
          coda.imponibile4 = 0
          coda.imponibile5 = 0
          coda.imponibile_vb1 = 0
          coda.imponibile_vb2 = 0
          coda.imponibile_vb3 = 0
          coda.imponibile_vb4 = 0
          coda.imponibile_vb5 = 0
          coda.importo_sconto = 0
          coda.imposta1 = 0
          coda.imposta2 = 0
          coda.imposta3 = 0
          coda.imposta4 = 0
          coda.imposta5 = 0
          coda.imposta_vb1 = 0
          coda.imposta_vb2 = 0
          coda.imposta_vb3 = 0
          coda.imposta_vb4 = 0
          coda.imposta_vb5 = 0
          coda.totale1 = 0
          coda.totale2 = 0
          coda.totale3 = 0
          coda.totale4 = 0
          coda.totale5 = 0
          coda.totale_vb1 = 0
          coda.totale_vb2 = 0
          coda.totale_vb3 = 0
          coda.totale_vb4 = 0
          coda.totale_vb5 = 0
        end
      end
    end

    noko = Nokogiri::XML::Document.new
    noko.encoding = 'UTF-8'
    noko.root = ric_fisc.to_xml

    noko
  end

  def export_to_onda!(force: false)
    raise "Cannot export in onda_export_status #{onda_export_status}" if onda_export_status != 'PENDING' && !force

    filename = File.join(Rails.application.config.acao.onda_import_dir, "#{Time.now.strftime('%Y%m%d_%H%M%S')}_#{code}.xml")
    filename_new = filename + '.new'

    File.open(filename_new , 'w') do |file|
      file.write(build_xml_for_onda)
    end

    File.rename(filename_new, filename)

    self.onda_export_status = 'EXPORTED'
    save!
  end

  class Detail < Ygg::BasicModel
    self.table_name = 'acao_invoice_details'

    self.porn_migration += [
      [ :must_have_column, {name: "id", type: :uuid, null: false, default: 'gen_random_uuid()' }],
      [ :must_have_column, {name: "invoice_id", type: :uuid, default: nil, null: false}],
      [ :must_have_column, {name: "count", type: :integer, default: nil, null: false}],
      [ :must_have_column, {name: "price", type: :decimal, default: nil, precision: 14, scale: 6, null: false}],
      [ :must_have_column, {name: "descr", type: :string, default: nil, limit: 255, null: true}],
      [ :must_have_column, {name: "service_type_id", type: :integer, default: nil, limit: 4, null: false}],
      [ :must_have_column, {name: "data", type: :text, default: nil, null: true}],

      [ :must_have_index, {columns: ["invoice_id"], unique: false}],
      [ :must_have_index, {columns: ["service_type_id"], unique: false}],

      [ :must_have_fk, {to_table: "acao_invoices", column: "invoice_id", primary_key: "id", on_delete: nil, on_update: nil}],
      [ :must_have_fk, {to_table: "acao_service_types", column: "service_type_id", primary_key: "id", on_delete: nil, on_update: nil}],
    ]

    belongs_to :invoice,
               class_name: '::Ygg::Acao::Invoice'

    belongs_to :service_type,
               class_name: '::Ygg::Acao::ServiceType',
               optional: true

    has_meta_class

    include Ygg::Core::Loggable
    define_default_log_controller(self)
  end
end

end
end
