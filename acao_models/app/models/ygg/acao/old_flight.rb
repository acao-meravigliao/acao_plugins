
module Ygg
module Acao

class OldFlight < Ygg::PublicModel
  self.table_name = :flights

  belongs_to :plane,
             :class_name => 'Ygg::Acao::Plane'

  belongs_to :towplane,
             :class_name => 'Ygg::Acao::Plane'

  belongs_to :plane_pilot1,
             :class_name => 'Ygg::Core::Person'

  belongs_to :plane_pilot2,
             :class_name => 'Ygg::Core::Person'

  belongs_to :towplane_pilot1,
             :class_name => 'Ygg::Core::Person'

  belongs_to :towplane_pilot2,
             :class_name => 'Ygg::Core::Person'

  interface :rest do
    capability :owner do
#      allow :show
      default_readable!
      readable :bollini_volo
      readable :takeoff_at
      readable :landing_at
    end
  end

  append_with_capability(:model) do |rel, aaa_context, capa|
    if !capa
      belonging_to(aaa_context.auth_identity.person)
    elsif capa == :owner
      belonging_to(aaa_context.auth_identity.person)
    else
      rel
    end
  end

  def self.belonging_to(person)
    joins { plane_pilot1.outer }.
    joins { plane_pilot2.outer }.
    joins { towplane_pilot1.outer }.
    joins { towplane_pilot2.outer }.where{
      (
        plane_pilot1.id.eq(person.id) |
        plane_pilot2.id.eq(person.id) |
        towplane_pilot1.id.eq(person.id) |
        towplane_pilot2.id.eq(person.id)
      )
    }
  end

  append_class_capabilities_for(:model) do |aaa_context|
    []
  end

  append_capabilities_for(:model) do |aaa_context|
    [ plane_pilot1, plane_pilot2, towplane_pilot1, towplane_pilot2 ].include?(aaa_context.auth_identity.person) ? [ :owner ] : []
  end

  module Scopes
    def glider_flights(aaa_context)
      joins { plane_pilot1.outer }.
      joins { plane_pilot2.outer }.
      where { (
        plane_pilot1.id.eq(aaa_context.auth_identity.person.id) |
        plane_pilot2.id.eq(aaa_context.auth_identity.person.id)
      ) }
    end

    def motorglider_flights(aaa_context)
      joins { towplane_pilot1.outer }.
      joins { towplane_pilot2.outer }.
      where { (
        (towplane_pilot1.id.eq(aaa_context.auth_identity.person.id) |
        towplane_pilot2.id.eq(aaa_context.auth_identity.person.id)) &
        (plane_pilot1_id.eq(nil)) & (plane_pilot2_id.eq(nil))
      ) }
    end

    def pax_flights(aaa_context)
      joins { plane_pilot2.outer }.
      joins { towplane_pilot2.outer }.
      where { (
        plane_pilot2.id.eq(aaa_context.auth_identity.person.id) |
        towplane_pilot2.id.eq(aaa_context.auth_identity.person.id)
      ) }
    end

    def tow_flights(aaa_context)
      joins { towplane_pilot1.outer }.
      joins { towplane_pilot2.outer }.
      where { (
        towplane_pilot1.id.eq(aaa_context.auth_identity.person.id) |
        towplane_pilot2.id.eq(aaa_context.auth_identity.person.id)
      ) }
    end
  end
  extend Scopes


  def self.sync_frequent!
    sync!(:limit => 200)
  end

  def self.sync!(opts = {})
    ActiveRecord::Base.transaction do

      r_rel = Ygg::Acao::MainDb::Volo.order(:id_voli => :asc)
      r_rel = r_rel.limit(opts[:limit]) if opts[:limit]

      r_enum = r_rel.each
      l_enum = Ygg::Acao::Flight.order(:acao_ext_id => :asc).each

      r = r_enum.next rescue nil
      l = l_enum.next rescue nil

      while r || l
        if !l || (r && r.id_voli < l.acao_ext_id)

          if r.marche_aliante.strip != 'NO' && !r.marche_aliante.blank?
            plane = Ygg::Acao::Plane.find_by_registration(r.marche_aliante.strip.upcase)
            if !plane
              plane = Ygg::Acao::Plane.create(
                :flarm_code => nil,
                :owner_name => nil,
                :home_airport => nil,
                :type_name => nil,
                :race_registration => nil,
                :registration => r.marche_aliante.strip.upcase,
                :common_radio_frequency => nil,
              )
            end
          end

          if r.marche_aereo.strip != 'NO' && !r.marche_aereo.strip.blank?
            towplane = Ygg::Acao::Plane.find_by_registration(r.marche_aereo.strip.upcase)
            if !towplane
              towplane = Ygg::Acao::Plane.create(
                :flarm_code => nil,
                :owner_name => nil,
                :home_airport => nil,
                :type_name => nil,
                :race_registration => nil,
                :registration => r.marche_aereo.strip.upcase,
                :common_radio_frequency => nil,
              )
            end
          end

          Ygg::Acao::Flight.create(
            :acao_ext_id => r.id_voli,
            :plane_pilot1 => r.codice_pilota_aliante != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_pilota_aliante) : nil,
            :plane_pilot2 => r.codice_secondo_pilota_aliante != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_secondo_pilota_aliante) : nil,
            :towplane_pilot1 => r.codice_pilota_aereo != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_pilota_aereo) : nil,
            :towplane_pilot2 => r.codice_secondo_pilota_aereo != 0 ? Ygg::Core::Person.find_by_acao_code(r.codice_secondo_pilota_aereo) : nil,
            :plane => plane,
            :towplane => towplane,
            :takeoff_at => r.ora_decollo_aereo,
            :landing_at => r.ora_atterraggio_aliante,
            :towplane_landing_at => r.ore_atterraggio_aereo,
            :tipo_volo_club => r.tipo_volo_club,
            :tipo_aereo_aliante => r.tipo_aereo_aliante,
            :durata_volo_aereo_minuti => r.durata_volo_aereo_minuti,
            :durata_volo_aliante_minuti => r.durata_volo_aliante_minuti,
            :quota => r.quota,
            :bollini_volo => r.bollini_volo,
            :check_chiuso => r.check_chiuso,
            :dep => r.dep.strip,
            :arr => r.arr.strip,
            :num_att => r.num_att,
            :data_att => r.data_att,
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
