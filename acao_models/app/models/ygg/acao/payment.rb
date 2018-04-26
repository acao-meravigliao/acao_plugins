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

  has_many :satispay_charges,
           class_name: 'Ygg::Acao::Payment::SatispayCharge',
           embedded: true,
           autosave: true,
           dependent: :destroy

  has_one :membership,
          class_name: 'Ygg::Acao::Membership'

  include Ygg::Core::Loggable
  define_default_log_controller(self)

  has_acl

  include Ygg::Core::Notifiable

  after_initialize do
    if new_record?
      code = nil

      loop do
        code = "A-" + Password.random(4, symbols: 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789')
        break if !self.class.find_by_code(code)
      end

      self.code = code
    end
  end

  def amount
    payment_services.reduce(0) { |a,x| a + x.price }
  end

#  def set_default_acl
#    transaction do
#      acl_entries.where(owner: self).destroy_all
#      acl_entries << AclEntry.new(owner: self, person: person, capability: 'owner')
#    end
#  end

  append_capabilities_for(:blahblah) do |aaa_context|
     aaa_context.auth_person.id == person_id ? [ :owner ] : []
  end

  def self.with_any_capability(aaa_context)
    aclk = reflections['acl_entries'].klass.arel_table
    pid = aaa_context.auth_person.id
    gids = aaa_context.auth_person.groups.map(&:id)

    rel = left_outer_joins(:acl_entries)
    rel = rel.where(arel_table[:person_id].eq(pid).or(aclk[:person_id].eq(pid).or(aclk[:group_id].in(gids))))
    rel
  end

  def completed!(no_autoinvoice: false)
    raise "Payment in state #{state} cannot be confirmed" if state != 'PENDING'

    self.state = 'COMPLETED'
    self.completed_at = Time.now

    if membership
      membership.payment_completed!
      membership.save!
    end

    unless no_autoinvoice
      export_invoice!
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

  class Service < Ygg::PublicModel
    self.table_name = 'acao_payment_services'

    has_meta_class

    include Ygg::Core::Loggable
    define_default_log_controller(self)

    belongs_to :payment,
               class_name: 'Ygg::Acao::Payment'

    belongs_to :service_type,
               class_name: 'Ygg::Acao::ServiceType'

    append_capabilities_for(:blahblah) do |aaa_context|
      aaa_context.auth_person.id == payment.person_id ? [ :owner ] : []
    end
  end

  PAYMENT_METHOD_MAP = {
    'WIRE'      => 'BB',
    'CHECK'     => 'AS',
    'SATISPAY'  => 'SP',
    'CARD'      => 'CC',
    'CASH'      => 'CO',
  }

  def build_invoice
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

  def export_invoice!(force: false)
    raise "Cannot export in state #{status}" if status != 'COMPLETED' && !force
    raise "Cannot export in state #{onda_export_status}" if onda_export_status != 'PENDING' && !force

    filename = File.join(Rails.application.config.acao.onda_import_dir, "#{Time.now.strftime('%Y%m%d_%H%M%S')}_#{code}.xml")
    filename_new = filename + '.new'

    File.open(filename_new , 'w') do |file|
      file.write(build_invoice)
    end

    File.rename(filename_new, filename)

    self.onda_export_status = 'EXPORTED'
    save!
  end

  require 'am/satispay'

  def satispay_initiate(phone_number:)
    satispay_charges.each do |c|
      c.sync! if c.status == 'REQUIRED'
      raise "Charge is still pending" if c.status == 'REQUIRED'
    end

    charge = Ygg::Acao::Payment::SatispayCharge.new(
      user_phone_number: phone_number,
      amount: amount,
      description: "Pagamento Online codice #{code}",
      idempotency_key: SecureRandom.base64(10),
    )

    satispay_charges << charge

    charge.save!
    charge.initiate!
  end

  def satispay_callback(charge_id:)
    charge = satispay_charges.find_by!(charge_id: charge_id)
    charge.sync!

    case charge.status
    when 'REQUIRED'
    when 'SUCCESS'
      completed!
    when 'FAILURE'
    else
    end
  end
end

end
end
