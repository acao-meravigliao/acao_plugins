#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'open-uri'
require 'yaml'

module Ygg
module Acao

class Aircraft < Ygg::PublicModel
  self.table_name = 'acao_aircrafts'

  has_many :trackers,
           class_name: 'Ygg::Acao::Tracker'

  belongs_to :aircraft_type,
             class_name: 'Ygg::Acao::AircraftType'


  def self.import_flarmnet_db!
    flarmnet_db = Hash[open('http://www.flarmnet.org/files/data.fln', 'r').read.lines[1..-1].map { |x|
      s = [ x.strip ].pack('H*').force_encoding('iso-8859-15').encode('utf-8')
      [
        s[0..5].strip.upcase,
        {
         id: s[0..5].strip.upcase,
         name: s[6..26].strip,
         home: s[26..46].strip,
         type: s[46..66].strip,
         reg: s[66..75].strip,
         race_reg: s[76..78].strip.upcase,
         freq: s[79..85].strip
        }
      ]
    }]

    fenum = flarmnet_db.keys.sort!.each
    denum = self.all.where('flarm_identifier IS NOT NULL').order(flarm_identifier: :asc).each

    fcur = fenum.next rescue nil
    dcur = denum.next rescue nil

    while fcur || dcur

      if !dcur || (fcur && fcur < dcur.flarm_identifier)
        flarmnet_entry = flarmnet_db[fcur]

        puts "NEW flarmnet entry #{fcur} #{flarmnet_entry[:reg]}"

        aircraft = Ygg::Acao::Aircraft.where(flarm_identifier: nil).find_by_registration(flarmnet_entry[:reg])
        if !aircraft
          aircraft = Ygg::Acao::Aircraft.new
          aircraft.update_from_flarmnet(flarmnet_entry)

          puts "CRE #{aircraft.attributes}"

          aircraft.save!
        else
          aircraft.update_from_flarmnet(flarmnet_entry)

          if aircraft.changes.any?
            puts "UPD #{aircraft.changes}"
            aircraft.save!
          end
        end

        fcur = fenum.next rescue nil
      elsif !fcur || (dcur && fcur > dcur.flarm_identifier)
        dcur = denum.next rescue nil
      else
        dcur.update_from_flarmnet(flarmnet_db[fcur])

        if dcur.changes.any?
          puts "UPD #{dcur.changes}"
          dcur.save!
        end

        fcur = fenum.next rescue nil
        dcur = denum.next rescue nil
      end
    end
  end

  def update_from_flarmnet(entry)
    self.flarm_identifier = entry[:id]
    self.fn_owner_name = entry[:name]
    self.fn_home_airport = entry[:home]
    self.fn_type_name = entry[:type]
    self.fn_common_radio_frequency = entry[:freq]
    self.registration = entry[:reg] if !registration
    self.race_registration = entry[:race_reg] if !race_registration
  end
end

end
end
