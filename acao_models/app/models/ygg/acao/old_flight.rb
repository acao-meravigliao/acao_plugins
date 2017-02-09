#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class OldFlight < Ygg::PublicModel
  self.table_name = :flights

  belongs_to :aircraft,
             class_name: 'Ygg::Acao::Aircraft'

  belongs_to :towaircraft,
             class_name: 'Ygg::Acao::Aircraft'

  belongs_to :aircraft_pilot1,
             class_name: 'Ygg::Core::Person'

  belongs_to :aircraft_pilot2,
             class_name: 'Ygg::Core::Person'

  belongs_to :towaircraft_pilot1,
             class_name: 'Ygg::Core::Person'

  belongs_to :towaircraft_pilot2,
             class_name: 'Ygg::Core::Person'

#  interface :rest do
#    capability :owner do
##      allow :show
#      default_readable!
#      readable :bollini_volo
#      readable :takeoff_at
#      readable :landing_at
#    end
#  end

#  append_with_capability(:model) do |rel, aaa_context, capa|
#    if !capa
#      belonging_to(aaa_context.auth_identity.person)
#    elsif capa == :owner
#      belonging_to(aaa_context.auth_identity.person)
#    else
#      rel
#    end
#  end
#
#  def self.belonging_to(person)
#    joins { aircraft_pilot1.outer }.
#    joins { aircraft_pilot2.outer }.
#    joins { towaircraft_pilot1.outer }.
#    joins { towaircraft_pilot2.outer }.where{
#      (
#        aircraft_pilot1.id.eq(person.id) |
#        aircraft_pilot2.id.eq(person.id) |
#        towaircraft_pilot1.id.eq(person.id) |
#        towaircraft_pilot2.id.eq(person.id)
#      )
#    }
#  end
#
#  append_class_capabilities_for(:model) do |aaa_context|
#    []
#  end
#
#  append_capabilities_for(:model) do |aaa_context|
#    [ aircraft_pilot1, aircraft_pilot2, towaircraft_pilot1, towaircraft_pilot2 ].include?(aaa_context.auth_identity.person) ? [ :owner ] : []
#  end
#
#  module Scopes
#    def glider_flights(aaa_context)
#      joins { aircraft_pilot1.outer }.
#      joins { aircraft_pilot2.outer }.
#      where { (
#        aircraft_pilot1.id.eq(aaa_context.auth_identity.person.id) |
#        aircraft_pilot2.id.eq(aaa_context.auth_identity.person.id)
#      ) }
#    end
#
#    def motorglider_flights(aaa_context)
#      joins { towaircraft_pilot1.outer }.
#      joins { towaircraft_pilot2.outer }.
#      where { (
#        (towaircraft_pilot1.id.eq(aaa_context.auth_identity.person.id) |
#        towaircraft_pilot2.id.eq(aaa_context.auth_identity.person.id)) &
#        (aircraft_pilot1_id.eq(nil)) & (aircraft_pilot2_id.eq(nil))
#      ) }
#    end
#
#    def pax_flights(aaa_context)
#      joins { aircraft_pilot2.outer }.
#      joins { towaircraft_pilot2.outer }.
#      where { (
#        aircraft_pilot2.id.eq(aaa_context.auth_identity.person.id) |
#        towaircraft_pilot2.id.eq(aaa_context.auth_identity.person.id)
#      ) }
#    end
#
#    def tow_flights(aaa_context)
#      joins { towaircraft_pilot1.outer }.
#      joins { towaircraft_pilot2.outer }.
#      where { (
#        towaircraft_pilot1.id.eq(aaa_context.auth_identity.person.id) |
#        towaircraft_pilot2.id.eq(aaa_context.auth_identity.person.id)
#      ) }
#    end
#  end
#  extend Scopes


  def self.sync_frequent!
    sync!(limit: 200)
  end

  def self.sync!(opts = {})
    ActiveRecord::Base.transaction do

      r_rel = Ygg::Acao::MainDb::Volo.order(id_voli: :asc)
      r_rel = r_rel.limit(opts[:limit]) if opts[:limit]

      r_enum = r_rel.each
      l_enum = Ygg::Acao::Flight.order(acao_ext_id: :asc).each

      r = r_enum.next rescue nil
      l = l_enum.next rescue nil

      while r || l
        if !l || (r && r.id_voli < l.acao_ext_id)

          if r.marche_aliante.strip != 'NO' && !r.marche_aliante.blank?
            aircraft = Ygg::Acao::Aircraft.find_by_registration(r.marche_aliante.strip.upcase)
            if !aircraft
              aircraft = Ygg::Acao::Aircraft.create(
                flarm_code: nil,
                owner_name: nil,
                home_airport: nil,
                type_name: nil,
                race_registration: nil,
                registration: r.marche_aliante.strip.upcase,
                common_radio_frequency: nil,
              )
            end
          end

          if r.marche_aereo.strip != 'NO' && !r.marche_aereo.strip.blank?
            towaircraft = Ygg::Acao::Aircraft.find_by_registration(r.marche_aereo.strip.upcase)
            if !towaircraft
              towaircraft = Ygg::Acao::Aircraft.create(
                flarm_code: nil,
                owner_name: nil,
                home_airport: nil,
                type_name: nil,
                race_registration: nil,
                registration: r.marche_aereo.strip.upcase,
                common_radio_frequency: nil,
              )
            end
          end

          Ygg::Acao::Flight.create(
            acao_ext_id: r.id_voli,
            aircraft_pilot1: r.codice_pilota_aliante != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_pilota_aliante) : nil,
            aircraft_pilot2: r.codice_secondo_pilota_aliante != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_secondo_pilota_aliante) : nil,
            towaircraft_pilot1: r.codice_pilota_aereo != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_pilota_aereo) : nil,
            towaircraft_pilot2: r.codice_secondo_pilota_aereo != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_secondo_pilota_aereo) : nil,
            aircraft: aircraft,
            towaircraft: towaircraft,
            takeoff_at: r.ora_decollo_aereo,
            landing_at: r.ora_atterraggio_aliante,
            towaircraft_landing_at: r.ore_atterraggio_aereo,
            tipo_volo_club: r.tipo_volo_club,
            tipo_aereo_aliante: r.tipo_aereo_aliante,
            durata_volo_aereo_minuti: r.durata_volo_aereo_minuti,
            durata_volo_aliante_minuti: r.durata_volo_aliante_minuti,
            quota: r.quota,
            bollini_volo: r.bollini_volo,
            check_chiuso: r.check_chiuso,
            dep: r.dep.strip,
            arr: r.arr.strip,
            num_att: r.num_att,
            data_att: r.data_att,
          )

          r = r_enum.next rescue nil
        elsif !r || (l && r.id_voli > l.acao_ext_id)
          l = l_enum.next rescue nil
        else
          l = l_enum.next rescue nil
          r = r_enum.next rescue nil
        end
      end
    end
  end

end

end
end
