#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Flight < Ygg::PublicModel
  self.table_name = 'acao_flights'

  self.porn_migration += [
    [ :must_have_column, { name: "id", type: :integer, null: false, limit: 4 } ],
    [ :must_have_column, { name: "uuid", type: :uuid, default: nil, default_function: "gen_random_uuid()", null: false}],
    [ :must_have_column, {name: "aircraft_reg", type: :string, default: nil, null: false}],
    [ :must_have_column, {name: "aircraft_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "takeoff_time", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "landing_time", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "pilot1_id", type: :integer, default: nil, limit: 4, null: false}],
    [ :must_have_column, {name: "pilot2_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "pilot1_role", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "pilot2_role", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "source", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "source_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "source_expansion", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "acao_tipo_volo_club", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_tipo_aereo_aliante", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_durata_volo_aereo_minuti", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_durata_volo_aliante_minuti", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_quota", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_bollini_volo", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "acao_data_att", type: :datetime, default: nil, null: true}],
    [ :must_have_column, {name: "towed_by_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "tow_release_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "takeoff_airfield_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "landing_airfield_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "takeoff_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "landing_location_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "aircraft_owner", type: :string, default: nil, null: true}],
    [ :must_have_column, {name: "aircraft_owner_id", type: :integer, default: nil, limit: 4, null: true}],
    [ :must_have_column, {name: "instruction_flight", type: :boolean, default: false, null: false}],
    [ :must_have_column, {name: "aircraft_class", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_column, {name: "launch_type", type: :string, default: nil, limit: 16, null: true}],
    [ :must_have_index, {columns: ["uuid"], unique: true}],
    [ :must_have_index, {columns: ["aircraft_id"], unique: false}],
    [ :must_have_index, {columns: ["aircraft_owner_id"], unique: false}],
    [ :must_have_index, {columns: ["landing_airfield_id"], unique: false}],
    [ :must_have_index, {columns: ["landing_location_id"], unique: false}],
    [ :must_have_index, {columns: ["pilot1_id"], unique: false}],
    [ :must_have_index, {columns: ["pilot2_id"], unique: false}],
    [ :must_have_index, {columns: ["takeoff_airfield_id"], unique: false}],
    [ :must_have_index, {columns: ["takeoff_location_id"], unique: false}],
    [ :must_have_index, {columns: ["tow_release_location_id"], unique: false}],
    [ :must_have_index, {columns: ["towed_by_id"], unique: false}],
    [ :must_have_index, {columns: ["source_id", "source_expansion"], unique: true}],
    [ :must_have_index, {columns: ["takeoff_time"], unique: false}],
    [ :must_have_index, {columns: ["landing_time"], unique: false}],
    [ :must_have_fk, {to_table: "acao_aircrafts", column: "aircraft_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "aircraft_owner_id", primary_key: "id", on_delete: :nullify, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_airfields", column: "landing_airfield_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "landing_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "pilot1_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_people", column: "pilot2_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_airfields", column: "takeoff_airfield_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "takeoff_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "core_locations", column: "tow_release_location_id", primary_key: "id", on_delete: nil, on_update: nil}],
    [ :must_have_fk, {to_table: "acao_flights", column: "towed_by_id", primary_key: "id", on_delete: nil, on_update: nil}],
  ]

  belongs_to :aircraft,
             class_name: 'Ygg::Acao::Aircraft'

  belongs_to :pilot1,
             class_name: 'Ygg::Core::Person',
             optional: true

  belongs_to :pilot2,
             class_name: 'Ygg::Core::Person',
             optional: true

  belongs_to :takeoff_location,
             class_name: '::Ygg::Core::Location',
             optional: true

  belongs_to :landing_location,
             class_name: '::Ygg::Core::Location',
             optional: true

  belongs_to :takeoff_airfield,
             class_name: '::Ygg::Acao::Airfield',
             optional: true

  belongs_to :landing_airfield,
             class_name: '::Ygg::Acao::Airfield',
             optional: true

  belongs_to :tow_release_location,
             class_name: '::Ygg::Core::Location',
             optional: true

  belongs_to :towed_by,
             class_name: 'Ygg::Acao::Flight',
             optional: true

  has_one :towing,
           class_name: 'Ygg::Acao::Flight',
           foreign_key: :towed_by_id


#  interface :rest do
#    capability :owner do
##      allow :show
#      default_readable!
#      readable :bollini_volo
#      readable :takeoff_at
#      readable :landing_at
#    end
#  end

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

  class InvalidRecord < StandardError ; end

  def self.sync_from_maindb!(limit: 300)

     l_relation = Ygg::Acao::MainDb::Volo.order(id_voli: :asc)
     l_relation = l_relation.limit(limit) if limit

     r_relation = Ygg::Acao::Flight.where(source: 'OLDDB').where('source_id IS NOT NULL').order(source_id: :asc)
     r_relation = r_relation.where('source_id >= ?', l_relation.first.id_voli) if limit

#    transaction do
      merge(
      l: l_relation,
      r: r_relation,
      l_cmp_r: lambda { |l,r| l.id_voli <=> r.source_id },
      l_to_r: lambda { |l|
        transaction do
        puts "ADDING FLIGHT ID=#{l.id_voli}"

        begin
          if !l.marche_aliante.blank? &&
              l.marche_aliante.strip != 'NO' &&
              l.marche_aliante.strip != 'NOALI' &&
              l.marche_aliante.strip != 'I-ALTRO' &&
              l.marche_aliante.strip != 'ACAO' &&
              l.marche_aliante.strip != 'DG1000' &&
              l.marche_aliante.strip != 'I-ALTRI'

            gl_flight = Ygg::Acao::Flight.new(
              source: 'OLDDB',
              source_id: l.id_voli,
              source_expansion: 'GL',
            )

            gl_flight.sync_from_maindb_as_gl(l)
            gl_flight.save!
          end
        rescue InvalidRecord => e
          puts "OOOOOOOOOOOOOOOOHHHHHHHHH In record #{l.id_voli} (TOW): #{e.to_s}"
        end

        begin
          if !l.marche_aereo.blank? &&
             l.marche_aereo.strip != 'NO' &&
             l.marche_aereo.strip != 'AUTO' &&
             l.marche_aereo.strip != 'I-ALTRI'

            tow_flight = Ygg::Acao::Flight.new(
              source: 'OLDDB',
              source_id: l.id_voli,
              source_expansion: 'TOW',
            )

            tow_flight.sync_from_maindb_as_tow(l)
            tow_flight.save!
          end
        rescue InvalidRecord => e
          puts "OOOOOOOOOOOOOOOOHHHHHHHHH In record #{l.id_voli} (GL): #{e.to_s}"
        end
        end
      },
      r_to_l: lambda { |r|
      },
      lr_update: lambda { |l,r|

        transaction do
        if r.source_expansion == 'GL'
          r.sync_from_maindb_as_gl(l)

          if r.deep_changed?
            puts "UPDATING #{l.id_voli} AS GLIDER"
            puts r.deep_changes.awesome_inspect(plain: true)
          end

          r.save!

        elsif r.source_expansion == 'TOW'
          r.sync_from_maindb_as_tow(l)

          if r.deep_changed?
            puts "UPDATING #{l.id_voli} AS TOWPLANE"
            puts r.deep_changes.awesome_inspect(plain: true)
          end

          r.save!
        end
        end
      })
#    end
  end

  def sync_from_maindb_as_gl(other)
    self.aircraft_reg = other.marche_aliante.strip.upcase
    self.aircraft = Ygg::Acao::Aircraft.find_or_create_by!(registration: other.marche_aliante.strip.upcase)

    self.takeoff_time = other.ora_decollo_aereo
    self.landing_time = other.ora_atterraggio_aliante

    self.towed_by = self.class.find_by(source_id: other.id_voli, source_expansion: 'TOW')

    takeoff_airfield = Ygg::Acao::Airfield.find_by(icao_code: other.dep.strip.upcase)
    takeoff_airfield ||= Ygg::Acao::Airfield.find_by(symbol: other.dep.strip.upcase)

    landing_airfield = Ygg::Acao::Airfield.find_by(icao_code: other.arr.strip.upcase)
    landing_airfield ||= Ygg::Acao::Airfield.find_by(symbol: other.arr.strip.upcase)

    self.takeoff_airfield = takeoff_airfield
    self.landing_airfield = landing_airfield

    self.takeoff_location = takeoff_airfield.location if takeoff_airfield
    self.landing_location = landing_airfield.location if landing_airfield

    self.takeoff_location_raw = takeoff_airfield ? takeoff_airfield.name : other.dep.strip.upcase
    self.landing_location_raw = landing_airfield ? landing_airfield.name : other.arr.strip.upcase

    begin
      self.pilot1 = Ygg::Acao::Pilot.find_by!(acao_code: other.codice_pilota_aliante)
    rescue ActiveRecord::RecordNotFound
      raise InvalidRecord, "Missing referenced pilot1 code=#{other.codice_pilota_aliante}"
    end

    if !other.codice_secondo_pilota_aliante.blank? &&
        other.codice_secondo_pilota_aliante != 0
      self.pilot2 = Ygg::Acao::Pilot.find_by(acao_code: other.codice_secondo_pilota_aliante)
      if !pilot2
        raise InvalidRecord, "Missing referenced pilot2 code=#{other.codice_secondo_pilota_aliante}"
      end
    end

    self.aircraft_class = aircraft.aircraft_type ? aircraft.aircraft_type.aircraft_class : nil
    self.aircraft_owner_id = aircraft.owner_id
    self.aircraft_owner = ((aircraft.owner && aircraft.owner.name) || aircraft.fn_owner_name).presence

    if other.marche_aereo.strip == 'AUTO'
      self.launch_type = 'SELF'
    else
      self.launch_type = ''
    end

    case other.tipo_volo_club
    when 0   # ERRORE
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 1   # ALLIEVO D.C.           : volo scuola trainato doppio commando
      self.instruction_flight = true
      self.pilot1_role = 'DUAL'
      self.pilot2_role = 'FI'
    when 2   # ALLIEVO D.C. TMG       : volo scuola su TMG (non trainato quindi) a doppio commando
      self.instruction_flight = true
      self.pilot1_role = 'DUAL'
      self.pilot2_role = 'FI'
    when 3   # ALLIEVO M.C.           : volo scuola trainato solista
      self.instruction_flight = true
      self.pilot1_role = 'PIC'
      self.pilot2_role = nil
    when 4   # ALIANTE CLUB S.S.      : volo non scuola trainato su monoposto del ACAO
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 5   # ALIANTE CLUB D.S.      : volo non scuola trainato su biposto del ACAO
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 6   # VOLO TMG CLUB          : volo non scuola su TMG del ACAO
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 7   # ALIANTE PRIVATO S.S    : volo non scuola trainato su monoposto privato
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 8   # ALIANTE PRIVATO D.S.   : volo non scuola trainato su biposto privato
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 9   # TMG PRIVATO            : volo non scuola su TMG privato
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 10  # ALIANTE DEC. AUT. PRIV.: volo non scuola non trainato su SLMG privato
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 11  # LANCIO VERRICELLO      : forse per i voli eseguiti fuori sede ?
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 12  # VOLO SEP CLUB          : volo non scuola di un monomotore (traino) del ACAO senza aliante
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 13  # VOLO SEP PRIVATO       : volo non scuola di un monomotore privato senza aliante
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    when 14  # VOLO PROMO             : volo propaganda (a pagamento)
      self.instruction_flight = false
      self.pilot1_role = nil
      self.pilot2_role = nil
    end

    self.acao_tipo_volo_club = other.tipo_volo_club
    self.acao_tipo_aereo_aliante = other.tipo_aereo_aliante
    self.acao_durata_volo_aereo_minuti = other.durata_volo_aereo_minuti
    self.acao_durata_volo_aliante_minuti = other.durata_volo_aliante_minuti
    self.acao_quota = other.quota
    self.acao_bollini_volo = other.bollini_volo
    self.acao_data_att = other.data_att
  end

  def sync_from_maindb_as_tow(other)
    self.aircraft = Ygg::Acao::Aircraft.find_or_create_by!(registration: other.marche_aereo.strip.upcase)

    self.takeoff_time = other.ora_decollo_aereo
    self.landing_time = other.ore_atterraggio_aereo

    self.towing = self.class.find_by(source_id: other.id_voli, source_expansion: 'GL')

    takeoff_airfield = Ygg::Acao::Airfield.find_by(icao_code: other.dep.strip.upcase)
    takeoff_airfield ||= Ygg::Acao::Airfield.find_by(symbol: other.dep.strip.upcase)

    landing_airfield = Ygg::Acao::Airfield.find_by(icao_code: other.dep.strip.upcase)
    landing_airfield ||= Ygg::Acao::Airfield.find_by(symbol: other.dep.strip.upcase)

    self.takeoff_airfield = takeoff_airfield
    self.landing_airfield = landing_airfield

    self.takeoff_location = takeoff_airfield.location if takeoff_airfield
    self.landing_location = landing_airfield.location if landing_airfield

    begin
      self.pilot1 = Ygg::Acao::Pilot.find_by!(acao_code: other.codice_pilota_aereo)
    rescue ActiveRecord::RecordNotFound
      raise InvalidRecord, "Missing referenced pilot1 code=#{other.codice_pilota_aereo}"
    end

    if !other.codice_secondo_pilota_aereo.blank? &&
        other.codice_secondo_pilota_aereo != 0
      self.pilot2 = Ygg::Acao::Pilot.find_by!(acao_code: other.codice_secondo_pilota_aereo)
      if !pilot2
        raise InvalidRecord, "Missing referenced pilot2 code=#{other.codice_secondo_pilota_aereo}"
      end
    end

    self.aircraft_class = aircraft.aircraft_type ? aircraft.aircraft_type.aircraft_class : nil
    self.aircraft_owner_id = aircraft.owner_id
    self.aircraft_owner = ((aircraft.owner && aircraft.owner.name) || aircraft.fn_owner_name).presence

    self.launch_type = 'SELF'

    self.acao_tipo_volo_club = other.tipo_volo_club
    self.acao_tipo_aereo_aliante = other.tipo_aereo_aliante
    self.acao_durata_volo_aereo_minuti = other.durata_volo_aereo_minuti
    self.acao_durata_volo_aliante_minuti = other.durata_volo_aliante_minuti
    self.acao_quota = other.quota
    self.acao_bollini_volo = other.bollini_volo
    self.acao_data_att = other.data_att
  end
end

end
end
