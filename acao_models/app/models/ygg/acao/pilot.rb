#
# Copyright (C) 2017-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'vihai_password_rails'


module Ygg
module Acao

class Pilot < Ygg::Core::Person

  has_many :acao_licenses,
           class_name: '::Ygg::Acao::License'

  has_many :acao_medicals,
           class_name: '::Ygg::Acao::Medical'

  belongs_to :acao_socio,
             class_name: '::Ygg::Acao::MainDb::Socio',
             primary_key: 'id_soci_dati_generale',
             foreign_key: 'acao_ext_id',
             optional: true

  has_many :acao_bar_transactions,
           class_name: '::Ygg::Acao::BarTransaction',
           foreign_key: 'person_id'

  has_many :acao_token_transactions,
           class_name: '::Ygg::Acao::TokenTransaction',
           foreign_key: 'person_id'

  def self.active_members(time: Time.now)
    years = [ time.year ]

    # Consider members active up to 31-1 of the year
    if (Time.now.beginning_of_year - Time.now) < 31.days
      years << [ time.year - 1 ]
    end

    members = Ygg::Acao::Pilot.joins(:acao_memberships).where.not('acao_sleeping').
                where('acao_memberships.year': years).group('core_people.id').order(id: :asc)

    members
  end

  def compute_completed_years(from, to)
    # Number of completed years is not trivial :)

    completed_years = to.year - from.year

    if from.month > to.month ||
       (from.month == to.month && from.day > to.day)
      completed_years -= 1
    end

    completed_years
  end

  # Implementazione dei criteri che stabiliscono il numero di turni di linea da fare
  #
  def roster_entries_needed(year: Time.now.year)
    ym = Ygg::Acao::Year.find_by!(year: year)
    membership = acao_memberships.find_by(year: year)

    needed = {
      total: 2,
      high_season: 1,
    }

    if birth_date
      age_on_renewal_day = compute_completed_years(birth_date, ym.renew_opening_time)

      if age_on_renewal_day >= 65
        needed[:total] = 0
        needed[:high_season] = 0
      elsif membership.board_member
        needed[:total] = 1
        needed[:high_season] = 0
      elsif membership.tug_pilot
        needed[:total] = 1
        needed[:high_season] = 0
      elsif membership.instructor
        needed[:total] = 0
        needed[:high_season] = 0
      end
    end

    needed
  end

  # Verifica che i turni di linea necessari siano stati selezionati
  #
  def roster_needed_entries_present(year: Time.now.year)
    needed = roster_entries_needed(year: year)

    roster_entries = acao_roster_entries.joins(:roster_day).where('acao_roster_days.date': (
      DateTime.new(year).beginning_of_year..DateTime.new(year).end_of_year
    ))

    roster_entries_high = roster_entries.where('acao_roster_days.high_season')

    roster_entries.count >= needed[:total] && roster_entries_high.count >= needed[:high_season]
  end

  def acao_send_initial_password!
    credential = credentials.where('fqda LIKE \'%@cp.acao.it\'').first

    return if !credential

    Ygg::Ml::Msg.notify(destinations: self, template: 'SEND_INITIAL_PASSWORD', template_context: {
      first_name: first_name,
      password: credential.password,
     }, objects: self)
  end

  def send_welcome_message!
    return if acao_sleeping

    credential = credentials.where('fqda LIKE \'%@cp.acao.it\'').first

    return if !credential

    Ygg::Ml::Msg.notify(destinations: self, template: 'WELCOME', template_context: {
      first_name: first_name,
      password: credential.password,
      code: acao_code,
     }, objects: self)
  end

  def send_happy_birthday!
    Ygg::Ml::Msg::Email.notify(destinations: self, template: 'HAPPY_BIRTHDAY', template_context: {
      first_name: first_name,
    })
  end


  ########### Notifications & Chores

  def self.run_chores!
    where.not('acao_sleeping').each do |person|
      person.run_chores!
    end

    transaction do
      sync_ml_voting_members!
    end

    transaction do
      sync_soci_ml!
    end
  end

  def run_chores!
    transaction do
      now = Time.now
      last_run = acao_last_notify_run || Time.new(0)

      run_roster_notification(now: now, last_run: last_run)

      if birth_date && birth_date.between?(last_run, now) &&
         birth_date.to_date == now.to_date # Otherwise it's too late
        send_happy_birthday!
      end

      run_license_expirations(now: now, last_run: last_run)
      run_medical_expirations(now: now, last_run: last_run)

      self.acao_last_notify_run = now

      save!
    end

    transaction do
      now = Time.now
      last_run = acao_bar_last_summary || Time.new(0)

      when_during_day = now.beginning_of_day # Midnight

      if when_during_day.between?(last_run, now)
        send_bar_transactions!(from: last_run.beginning_of_day, to: now.end_of_day)

        self.acao_bar_last_summary = now
        save!
      end
    end
  end

  def run_roster_notification(now:, last_run:)
    when_in_advance_sms = 1.days - 10.hours
    when_in_advance_mail = 7.days - 10.hours

    acao_roster_entries.each do |entry|
      if (entry.roster_day.date.beginning_of_day - when_in_advance_mail).between?(last_run, now)
        Ygg::Ml::Msg::Email.notify(destinations: self, template: 'ROSTER_NEAR_NOTIFICATION', template_context: {
          first_name: first_name,
          date: entry.roster_day.date,
        })
      end

      if (entry.roster_day.date.beginning_of_day - when_in_advance_sms).between?(last_run, now)
        Ygg::Ml::Msg::SMS.notify(destinations: self, template: 'ROSTER_NEAR_NOTIFICATION_SMS', template_context: {
          first_name: first_name,
          date: entry.roster_day.date,
        })
      end
    end
  end

  def run_license_expirations(now:, last_run:)
    when_in_advance = 14.days - 10.hours

    acao_licenses.each do |license|
      context = {
        first_name: first_name,
        license_type: license.type,
        license_identifier: license.identifier,
        license_issued_at: license.issued_at ? license.issued_at.strftime('%d-%m-%Y') : 'N/A',
        license_valid_to: license.valid_to ? license.valid_to.strftime('%d-%m-%Y') : 'N/A',
      }

      if license.valid_to
        expired = if license.valid_to.between?(last_run, now)
          'EXPIRED'
        elsif (license.valid_to.beginning_of_day - when_in_advance).between?(last_run, now)
          'EXPIRING'
        end

        if expired
          template = Ygg::Ml::Template.find_by(symbol: "LIC_#{license.type}_LICENSE_#{expired}")
          template ||= Ygg::Ml::Template.find_by!(symbol: "LIC_OTH_LICENSE_#{expired}")

          Ygg::Ml::Msg::Email.notify(destinations: self, template: template, template_context: context)
        end
      end

      if license.valid_to2
        expired = if license.valid_to2.between?(last_run, now)
          'EXPIRED'
        elsif (license.valid_to2.beginning_of_day - when_in_advance).between?(last_run, now)
          'EXPIRING'
        end

        if expired
          template = Ygg::Ml::Template.find_by(symbol: "LIC_#{license.type}_ANNUAL_#{expired}")
          template ||= Ygg::Ml::Template.find_by(symbol: "LIC_OTH_ANNUAL_#{expired}")

          if template
            Ygg::Ml::Msg::Email.notify(destinations: self, template: template, template_context: context.merge({
              license_annual_valid_to: license.valid_to2 ? license.valid_to2.strftime('%d-%m-%Y') : 'N/A',
            }))
          end
        end
      end

      license.ratings do |rating|
        if rating.valid_to
          expired = if rating.valid_to.between?(last_run, now)
            'EXPIRED'
          elsif (rating.valid_to.beginning_of_day - when_in_advance).between?(last_run, now)
            'EXPIRING'
          end

          template = Ygg::Ml::Template.find_by(symbol: "LIC_#{license.type}_#{rating.type}_#{expired}")
          template ||= Ygg::Ml::Template.find_by!(symbol: "LIC_OTH_RATING_#{expired}")

          Ygg::Ml::Msg::Email.notify(destinations: self, template: template, template_context: context.merge({
            raing_type: rating.type,
            raing_valid_to: rating.valid_to ? rating.valid_to.strftime('%d-%m-%Y') : 'N/A',
          }))
        end
      end
    end
  end

  def run_medical_expirations(now:, last_run:)
    when_in_advance = 14.days - 10.hours

    acao_medicals.each do |medical|
      template = nil

      if medical.valid_to.between?(last_run, now)
        template = 'MEDICAL_EXPIRED'
      elsif (medical.valid_to.beginning_of_day - when_in_advance).between?(last_run, now)
        template = 'MEDICAL_EXPIRING'
      end

      if template
        Ygg::Ml::Msg::Email.notify(destinations: self, template: template, template_context: {
          first_name: first_name,
          medical_type: medical.type,
          medical_identifier: medical.identifier,
          medical_issued_at: medical.issued_at ? medical.issued_at.strftime('%d-%m-%Y') : 'N/A',
          medical_valid_to: medical.valid_to ? medical.valid_to.strftime('%d-%m-%Y') : 'N/A',
        })
      end
    end
  end

  def check_bar_transactions
    xacts = acao_bar_transactions.order(recorded_at: :asc, old_id: :asc, old_cassetta_id: :asc)

    cur = xacts.first.credit || 0

    xacts.each do |xact|
      #puts "%-10s prev=%7.2f + amount=%7.2f => credit=%7.2f == cur=%7.2f" % [ xact.recorded_at.strftime('%Y-%m-%d %H:%M:%S'), xact.prev_credit || 0, xact.amount, xact.credit || 0, cur || 0 ]

      cur = cur + xact.amount

      if cur != xact.credit
        puts "Xact id=#{xact.id} credit inconsistency #{cur} != #{xact.credit}"
        cur = xact.credit if xact.credit
      end
    end

    nil
  end

  def send_bar_transactions!(from:, to:)
    xacts = acao_bar_transactions.where(recorded_at: from..to).order(recorded_at: :asc)

    return if xacts.count == 0

    # To be removed when log entries have credit,prev_credit chain
    credit = acao_bar_credit - acao_bar_transactions.where('recorded_at > ?', from).reduce(0) { |a,x| a + x.amount }

    date = nil
    table = ''

    xacts.each do |x|
      if date != x.recorded_at.to_date
        table << "---------------------------------------------------------------------\n"
        table << "%-10s                                         Credito %8.2f €\n" % [ x.recorded_at.strftime('%d-%m-%Y'), credit ]
        table << "---------------------------------------------------------------------\n"
        date = x.recorded_at.to_date
      end

      table <<  "%5s %2d %-49s %8.2f €\n" % [ x.recorded_at.strftime('%H:%M'), x.cnt, x.descr, -x.amount ]

      credit += x.amount
    end

    table << "---------------------------------------------------------------------\n"
    table << "                                                   Credito %8.2f €\n" % [ credit ]

    table

    Ygg::Ml::Msg::Email.notify(destinations: self, template: 'BAR_SUMMARY', template_context: {
      first_name: first_name,
      date: xacts.first.recorded_at.strftime('%d-%m-%Y'),
      transactions_table: table,
    })
  end

  ########## Mailing lists synchronization

  def self.sync_ml_active_members!(time: Time.now)
    members = voting_members

    list = Ygg::Ml::List.find_by!(symbol: 'ACTIVE_MEMBERS')
    current_members = list.members.where(owner_type: 'Ygg::Core::Person').order(owner_id: :asc)

    merge(l: members, r: current_members,
      l_cmp_r: lambda { |l,r| l.id <=> r.owner_id },
      l_to_r: lambda { |l|
        contact = l.contacts.where(type: 'email').first

        if contact
          addr = Ygg::Ml::Address.find_or_create_by(addr: contact.value, addr_type: 'EMAIL')
          addr.name = l.name
          addr.save!

          list.members << Ygg::Ml::List::Member.new(
            address: addr,
            subscribed_on: Time.now,
            owner: l,
          )
        end
      },
      r_to_l: lambda { |r|
        r.destroy
      },
      lr_update: lambda { |l,r|
        r.address.name = l.name
        r.address.save!
      },
    )
  end

  def self.sync_ml_voting_members!(time: Time.now)
    members = voting_members

    list = Ygg::Ml::List.find_by!(symbol: 'VOTING_MEMBERS')
    current_members = list.members.where(owner_type: 'Ygg::Core::Person').order(owner_id: :asc)

    merge(l: members, r: current_members,
      l_cmp_r: lambda { |l,r| l.id <=> r.owner_id },
      l_to_r: lambda { |l|
        contact = l.contacts.where(type: 'email').first

        if contact
          addr = Ygg::Ml::Address.find_or_create_by(addr: contact.value, addr_type: 'EMAIL')
          addr.name = l.name
          addr.save!

          list.members << Ygg::Ml::List::Member.new(
            address: addr,
            subscribed_on: Time.now,
            owner: l,
          )
        end
      },
      r_to_l: lambda { |r|
        r.destroy
      },
      lr_update: lambda { |l,r|
        r.address.name = l.name
        r.address.save!
      },
    )
  end

  def self.sync_soci_ml!(dry_run: Rails.application.config.acao.soci_ml_dry_run)

    l_full_emails = Hash[Ygg::Ml::List.find_by!(symbol: 'ACTIVE_MEMBERS').addresses.
                     where(addr_type: 'EMAIL').order(addr: :asc).map { |x| [ x.addr, x.name ] }]

    l_emails = l_full_emails.keys.sort
    r_emails = []

    IO::popen([ '/usr/bin/ssh', '-i', '/var/lib/yggdra/lino', 'root@lists.acao.it', '/usr/sbin/list_members', 'soci' ]) do |io|
      data = io.read
      io.close

      if !$?.success?
        raise "Cannot list list members"
      end

      r_emails = data.split("\n").map { |x| x.strip.downcase }.sort
    end

    members_to_add = []
    members_to_remove = []

    merge(l: l_emails, r: r_emails,
      l_cmp_r: lambda { |l,r| l <=> r },
      l_to_r: lambda { |l|
        members_to_add << "#{l_full_emails[l]} <#{l}>"
      },
      r_to_l: lambda { |r|
        members_to_remove << r
      },
      lr_update: lambda { |l,r|
      }
    )

    if members_to_add.any?
      puts "MEMBERS TO ADD:\n#{members_to_add}"

      if !dry_run
        IO::popen([ '/usr/bin/ssh', '-i', '/var/lib/yggdra/lino', 'root@lists.acao.it', '/usr/sbin/add_members',
                      '-r', '-', '--admin-notify=n', '--welcome-msg=n', 'soci' ], 'w') do |io|
          io.write(members_to_add.join("\n"))
          io.close
        end
      end
    end

    if members_to_remove.any?
      puts "MEMBERS TO REMOVE:\n#{members_to_remove}"

      if !dry_run
        IO::popen([ '/usr/bin/ssh', '-i', '/var/lib/yggdra/lino', 'root@lists.acao.it', '/usr/sbin/remove_members',
                      '--file', '-', '--nouserack', '--noadminack', 'soci' ], 'w') do |io|
          io.write(members_to_remove.join("\n"))
          io.close
        end
      end
    end
  end


  ############ Old Database Synchronization

  def self.merge(l:, r:, l_cmp_r:, l_to_r:, r_to_l:, lr_update:)

    r_enum = r.each
    l_enum = l.each

    r = r_enum.next rescue nil
    l = l_enum.next rescue nil

    while r || l
      if !l || (r && l_cmp_r.call(l, r) == 1)
        r_to_l.call(r)

        r = r_enum.next rescue nil
      elsif !r || (l &&  l_cmp_r.call(l, r) == -1)
        l_to_r.call(l)

        l = l_enum.next rescue nil
      else
        lr_update.call(l, r)

        l = l_enum.next rescue nil
        r = r_enum.next rescue nil
      end
    end
  end

  def self.sync_from_maindb!

    l_records = Ygg::Acao::MainDb::Socio.order(id_soci_dati_generale: :asc)
    r_records = Ygg::Acao::Pilot.where('acao_ext_id IS NOT NULL').order(acao_ext_id: :asc)

    transaction do
      merge(l: l_records, r: r_records,
      l_cmp_r: lambda { |l,r| l.id_soci_dati_generale <=> r.acao_ext_id },
      l_to_r: lambda { |l|
        return if [ 0, 1, 4000, 4001, 7000, 8888, 9999 ].include?(l.codice_socio_dati_generale)

        puts "ADDING SOCIO ID=#{l.id_soci_dati_generale} CODICE=#{l.codice_socio_dati_generale}"

        person = Ygg::Acao::Pilot.new({
          acao_ext_id: l.id_soci_dati_generale,
        })

        person.sync_from_maindb(l)

        person.save!

        person.acl_entries << Ygg::Core::Person::AclEntry.new(person: person, capability: 'owner')
        person.person_capabilities.find_or_create_by(capability: Ygg::Core::Capability.find_by_name('simple_interface'))

        person.send_welcome_message!

        puts "ADDED #{person.awesome_inspect(plain: true)}"
      },
      r_to_l: lambda { |r|
#puts "REMOVED SOCIO #{l.first_name} #{l.last_name} L_ID=#{l.acao_ext_id} R_ID=#{r.id_soci_dati_generale}"
#          r.acao_ext_id = r.acao_ext_id
#          r.acao_code = nil
#          r.save!
      },
      lr_update: lambda { |l,r|

        r.sync_from_maindb(l)

        if r.deep_changed?
          puts "UPDATING #{l.id_soci_dati_generale} <=> #{r.acao_ext_id} (#{r.first_name} #{r.last_name})"
          puts r.deep_changes.awesome_inspect(plain: true)
        end

        r.save!
      })
    end
  end

  def sync_from_maindb(other)
    self.first_name = (other.Nome.blank? ? '?' : other.Nome).strip
    self.last_name = other.Cognome.strip
    self.gender = other.Sesso
    self.birth_date = other.Data_Nascita != Date.parse('1900-01-01 00:00:00 UTC') ? other.Data_Nascita : nil

    self.italian_fiscal_code = (other.Codice_Fiscale.strip != 'NO' && !other.Codice_Fiscale.strip.blank?) ? other.Codice_Fiscale.strip : nil

    self.acao_code = other.codice_socio_dati_generale

    raw_address = [ other.Nato_a ].map { |x| x.strip }.
                  reject { |x| x.downcase == 'non specificato' || x.downcase == 'non specificata' || x == '?' }
    if raw_address.any?
      raw_address = raw_address.join(', ')
      if !birth_location || birth_location.raw_address != raw_address
        self.birth_location = Ygg::Core::Location.new_for(raw_address)
        sleep 0.3
      end
    else
      self.birth_location = nil
    end

    raw_address = [ other.Via, other.Citta, other.Provincia, other.CAP, other.Stato ].map { |x| x.strip }.
                  reject { |x| x.downcase == 'non specificato' || x.downcase == 'non specificata' || x == '?' }

    if raw_address.any?
      raw_address = raw_address.join(', ')
      if !residence_location || residence_location.raw_address != raw_address
        self.residence_location = Ygg::Core::Location.new_for(raw_address)
        sleep 0.3
      end
    else
      self.residence_location = nil
    end

    self.acao_sleeping = other.visita.socio_non_attivo
    self.acao_bollini = other.Acconto_Voli
    self.acao_bar_credit = other.visita.acconto_bar_euro

    save! if new_record?

    sync_contacts(other)
 #   sync_memberships(other.iscrizioni)
    sync_credentials(other)
    sync_licenses(other.licenza)
    sync_medicals(other.visita)
    sync_log_bar(other.log_bar2)
    sync_log_bar_deposits(other.cassetta_bar_locale)
    sync_log_bollini(other.log_bollini)
  end

  def sync_log_bar(other_log_bar)
    self.class.merge(
      l: other_log_bar.order(id_logbar: :asc),
      r: acao_bar_transactions.where('old_id IS NOT NULL').order(old_id: :asc),
      l_cmp_r: lambda { |l,r| l.id_logbar <=> r.old_id },
      l_to_r: lambda { |l|
        acao_bar_transactions << Ygg::Acao::BarTransaction.new(
          recorded_at: l.data_reg,
          cnt: 1,
          unit: '€',
          descr: l.descrizione.strip,
          amount: -l.prezzo,
          prev_credit: l.credito_prec,
          credit: l.credito_rim,
          old_id: l.id_logbar,
        )
      },
      r_to_l: lambda { |r|
      },
      lr_update: lambda { |l,r|
      }
    )
  end

  def sync_log_bar_deposits(other_deposits)
    self.class.merge(
      l: other_deposits.order(id_cassetta_bar_locale: :asc),
      r: acao_bar_transactions.where('old_cassetta_id IS NOT NULL').order(old_cassetta_id: :asc),
      l_cmp_r: lambda { |l,r| l.id_cassetta_bar_locale <=> r.old_cassetta_id },
      l_to_r: lambda { |l|
        acao_bar_transactions << Ygg::Acao::BarTransaction.new(
          recorded_at: l.data_reg,
          cnt: 1,
          unit: '€',
          descr: 'Versamento',
          amount: l.avere_cassa_bar_locale,
          prev_credit: nil,
          credit: nil,
          old_cassetta_id: l.id_cassetta_bar_locale,
        )
      },
      r_to_l: lambda { |r|
      },
      lr_update: lambda { |l,r|
      }
    )
  end

  def sync_log_bollini(other)
    self.class.merge(
      l: other.order(id_log_bollini: :asc),
      r: acao_bar_transactions.where('old_id IS NOT NULL').order(old_id: :asc),
      l_cmp_r: lambda { |l,r| l.id_log_bollini <=> r.old_id },
      l_to_r: lambda { |l|
        acao_token_transactions << Ygg::Acao::TokenTransaction.new(
          recorded_at: l.log_data,
          old_operator: l.operatore.strip,
          old_marche_mezzo: l.marche_mezzo.strip,
          descr: l.note.strip,
          amount: -l.n_bollini,
          prev_credit: l.credito_prec,
          credit: l.credito_att,
          old_id: l.id_log_bollini,
        )
      },
      r_to_l: lambda { |r|
      },
      lr_update: lambda { |l,r|
      }
    )
  end

  def sync_credentials(l)
    pw = Password.xkcd(words: 3, dict: VihaiPasswordRails.dict('it'))

    sync_credential("#{l.codice_socio_dati_generale.to_s}@cp.acao.it", pw)

    if l.Email && !l.Email.strip.empty? && l.Email.strip != 'acao@acao.it' && l.Email.strip != 'NO'
      sync_credential(l.Email.strip, pw)
    end
  end

  def sync_credential(fqda, pw)
    cred = credentials.find_by(fqda: fqda)
    if !cred
      credentials << Ygg::Core::Person::Credential::ObfuscatedPassword.new({
        fqda: fqda,
        password: pw,
      })
    end
  end

  def sync_memberships(iscrizioni)
    iscrizioni.each do |x|
      acao_memberships.find_or_create_by(year: x.anno_iscrizione)
    end
  end

  def sync_licenses(licenza)
    if licenza.GL_SiNo && licenza.Numero_GL != 'Allievo' && licenza.Numero_GL != 'Trainatore' && licenza.Numero_GL != 'I-GL-?'  && licenza.Numero_GL != 'I-GL-'
      identifier = (licenza.Numero_GL && licenza.Numero_GL != ''  && licenza.Numero_GL != '0') ? licenza.Numero_GL.strip : nil
      license = acao_licenses.find_or_create_by(type: 'GPL', identifier: identifier)

      license.issued_at = licenza.Data_Rilascio_GL && licenza.Data_Rilascio_GL != Date.parse('1900-01-01 00:00:00 UTC') ?
                          licenza.Data_Rilascio_GL : nil

      license.valid_to = licenza.Scadenza_GL && licenza.Scadenza_GL != Date.parse('1900-01-01 00:00:00 UTC') ?
                         licenza.Scadenza_GL : nil

      license.valid_to2 = licenza.Annotazione_GL && licenza.Annotazione_GL != Date.parse('1900-01-01 00:00:00 UTC') ?
                          licenza.Annotazione_GL : nil

      license.save!
    else
      acao_licenses.where(type: 'GPL').destroy_all
    end

    if licenza.PPL_Si_No
      identifier = (licenza.Numero_PPL && licenza.Numero_PPL != ''  && licenza.Numero_PPL != '0') ? licenza.Numero_PPL.strip : nil

      license = acao_licenses.find_or_create_by(type: 'PPL', identifier: identifier)

      license.issued_at = licenza.Data_Rilascio_PPL && licenza.Data_Rilascio_PPL != Date.parse('1900-01-01 00:00:00 UTC') ?
                         licenza.Data_Rilascio_PPL : nil

      license.valid_to = (licenza.Scadenza_PPL && licenza.Scadenza_PPL != Date.parse('1900-01-01 00:00:00 UTC')) ?
                         licenza.Scadenza_PPL : nil

      license.valid_to2 = (licenza.scadenza_retraining_PPL && licenza.scadenza_retraining_PPL != Date.parse('1900-01-01 00:00:00 UTC')) ?
                         licenza.scadenza_retraining_PPL : nil

      if licenza.Abilitazione_TMG_SiNo
        rating = license.ratings.find_or_create_by(type: 'TMG')
        rating.issued_at = (licenza.DataAbilit_TMG && licenza.DataAbilit_TMG != Date.parse('1900-01-01 00:00:00 UTC')) ?
                           licenza.DataAbilit_TMG : nil
        rating.valid_to = nil
        rating.save!
      else
        rating = license.ratings.find_by(type: 'TMG')
        rating.destroy if rating
      end

      if licenza.Abilitazione_Traino_SiNo
        rating = license.ratings.find_or_create_by(type: 'TOW')
        rating.issued_at = (licenza.Data_Abilit_Traino && licenza.Data_Abilit_Traino != Date.parse('1900-01-01 00:00:00 UTC')) ?
                           licenza.Data_Abilit_Traino : nil
        rating.valid_to = nil
        rating.save!
      else
        rating = license.ratings.find_by(type: 'TOW')
        rating.destroy if rating
      end

      if licenza.Abilit_Istruttore_SiNo
        rating = license.ratings.find_or_create_by(type: 'FI')
        rating.issued_at = (licenza.Data_Abilit_Istruttore && licenza.Data_Abilit_Istruttore != Date.parse('1900-01-01 00:00:00 UTC')) ?
                           licenza.Data_Abilit_Istruttore : nil
        rating.valid_to = nil
        rating.save!
      else
        rating = license.ratings.find_by(type: 'FI')
        rating.destroy if rating
      end

      license.save!
    else
      acao_licenses.where(type: 'PPL').destroy_all
    end
  end

  def sync_medicals(visita)
    type = "IT class #{visita.Tipo_Classe_Visita}"

    if visita && visita.Scadenza_Visita_Medica && visita.Scadenza_Visita_Medica != Date.parse('1900-01-01 00:00:00 UTC')

      medical = acao_medicals.find_or_create_by(type: type)

      medical.issued_at = visita.Data_prima_Visita && visita.Data_prima_Visita != Date.parse('1900-01-01 00:00:00 UTC') ?
                          visita.Data_prima_Visita : nil

      medical.valid_to = visita.Scadenza_Visita_Medica && visita.Scadenza_Visita_Medica != Date.parse('1900-01-01 00:00:00 UTC') ?
                         visita.Scadenza_Visita_Medica : nil

      medical.save!
    else
      acao_medicals.where(type: type).destroy_all
    end
  end

  def sync_contacts(r)
    if r.Email && !r.Email.strip.empty? && r.Email.strip != 'acao@acao.it' && r.Email.strip != 'NO'
      contacts.find_or_create_by(type: 'email', value: r.Email.strip)
    end

    if r.Telefono_Casa && r.Telefono_Casa.strip != '' && r.Telefono_Casa.strip != '0'
      contacts.find_or_create_by(type: 'phone', value: r.Telefono_Casa.strip, descr: 'Casa')
    end

    if r.Telefono_Ufficio && r.Telefono_Ufficio.strip != '' && r.Telefono_Ufficio.strip != '0'
      contacts.find_or_create_by(type: 'phone', value: r.Telefono_Ufficio.strip, descr: 'Ufficio')
    end

    if r.Telefono_Altro && r.Telefono_Altro.strip != '' && r.Telefono_Altro.strip != '0'
      contacts.find_or_create_by(type: 'phone', value: r.Telefono_Altro.strip, descr: 'Ufficio')
    end

    if r.Telefono_Cellulare && r.Telefono_Cellulare.strip != '' && r.Telefono_Cellulare.strip != '0'
      contacts.find_or_create_by(type: 'mobile', value: r.Telefono_Cellulare.strip)
    end

    if r.Fax && r.Fax.strip != '' && r.Fax.strip != '0'
      contacts.find_or_create_by(type: 'fax', value: r.Fax.strip)
    end

    if r.Sito_Web && r.Sito_Web.strip != '' && r.Sito_Web.strip != 'W'
      contacts.find_or_create_by(type: 'url', value: r.Sito_Web.strip)
    end
  end

  def self.voting_members(time: Time.now)
    # Exclude students

    years = [ time.year ]

    # Consider members active up to 31-1 of the year
    if (Time.now.beginning_of_year - Time.now) < 31.days
      years << [ time.year - 1 ]
    end

    members = Ygg::Acao::Pilot.joins(:acao_memberships).where.not('acao_sleeping').
                where('acao_memberships.year': years).
                where('birth_date < ?', time.to_date - 18.years).group('core_people.id').order(id: :asc)

    members
  end

end

end
end
