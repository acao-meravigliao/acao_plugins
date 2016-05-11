
require 'open-uri'
require 'yaml'

module Ygg
module Acao

class Plane < Ygg::PublicModel
  self.table_name = 'acao_planes'

  interface :rest do
    capability :simple_interface do
      allow :show
      default_readable!
    end

    capability :full_interface do
      allow :show
      default_readable!
    end
  end

  def self.attributes_from_flarmnet(entry)
    {
     :owner_name => entry[:name].strip,
     :home_airport => entry[:home].strip,
     :type_name => entry[:type].strip,
     :race_registration => entry[:race_reg].strip.upcase,
     :registration => entry[:reg].strip.upcase,
     :common_radio_frequency => entry[:freq].strip,
     :flarm_code => entry[:id].strip.upcase,
    }
  end

  def self.import_flarmnet_db!
    flarmnet_db = Hash[open('http://www.flarmnet.org/files/data.fln', 'r').read.lines[1..-1].map { |x|
      s = [ x.strip ].pack('H*').force_encoding('iso-8859-15').encode('utf-8')
      [
        s[0..5],
        {
         :id => s[0..5],
         :name => s[6..26].strip,
         :home => s[26..46].strip,
         :type => s[46..66].strip,
         :reg => s[66..75].strip,
         :race_reg => s[76..78].strip,
         :freq => s[79..85].strip
        }
      ]
    }]

    fenum = flarmnet_db.keys.sort!.each
    denum = self.all.where('flarm_code IS NOT NULL').order(:flarm_code => :asc).each

    fcur = fenum.next rescue nil
    dcur = denum.next rescue nil

    while fcur || dcur

      if !dcur || (fcur && fcur < dcur.flarm_code)
        flarmnet_entry = flarmnet_db[fcur]

        puts "NEW flarmnet entry #{fcur} #{flarmnet_entry[:reg]}"

        plane = Ygg::Acao::Plane.where(:flarm_code => nil).find_by_registration(flarmnet_entry[:reg].strip.upcase)
        if !plane
          Ygg::Acao::Plane.create(attributes_from_flarmnet(flarmnet_entry))
        else
          plane.update_attributes(attributes_from_flarmnet(flarmnet_entry))
        end

        fcur = fenum.next rescue nil
      elsif !fcur || (dcur && fcur > dcur.flarm_code)
        dcur = denum.next rescue nil
      else
        dcur.attributes = attributes_from_flarmnet(flarmnet_db[fcur])

	dcur.save! if dcur.changed?

        fcur = fenum.next rescue nil
        dcur = denum.next rescue nil
      end
    end

  end

end

end
end
