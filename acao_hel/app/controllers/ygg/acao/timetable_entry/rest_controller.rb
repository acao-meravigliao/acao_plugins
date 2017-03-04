#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TimetableEntry::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::TimetableEntry

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }

    attribute(:reception_state) { show! }
    attribute(:flying_state) { show! }
    attribute(:tow_state) { show! }

    attribute(:takeoff_at) { show! }
    attribute(:landing_at) { show! }

    attribute(:aircraft_id) { show! }

    attribute(:aircraft) do
      empty!
      attribute(:registration) { show! }
      attribute(:flarm_identifier) { show! }
    end

    attribute(:towed_by_id) { show! }
    attribute(:towed_by) do
      empty!
      attribute(:id) { show! }
      attribute(:aircraft_id) { show! } # FIXME, it should really be removed
      attribute(:aircraft) do
        empty!
        attribute(:registration) { show! }
        attribute(:flarm_identifier) { show! }
      end
    end

    attribute(:pilot) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

      show!
    attribute(:takeoff_airfield_id) { show! }
    attribute(:takeoff_airfield) do
      empty!
      attribute(:name) { show! }
      attribute(:icao_code) { show! }
    end

    attribute(:takeoff_location_id) { show! }
    attribute(:takeoff_location) do
      show!
      empty!
      attribute(:lat) { show! }
      attribute(:lng) { show! }
    end

    attribute(:landing_airfield_id) { show! }
    attribute(:landing_airfield) do
      show!
      empty!
      attribute(:name) { show! }
      attribute(:icao_code) { show! }
    end

    attribute(:landing_location_id) { show! }
    attribute(:landing_location) do
      show!
      empty!
      attribute(:lat) { show! }
      attribute(:lng) { show! }
    end

    attribute(:tow_height) { show! }
    attribute(:tow_duration) { show! }
  end

end

end
end
