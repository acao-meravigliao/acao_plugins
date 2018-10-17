#
# Copyright (C) 2016-2016, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class Flight::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::Flight

  load_role_defs!

  view :grid do
    empty!
    attribute(:id) { show! }
    attribute(:uuid) { show! }
    attribute(:takeoff_time) { show! }
    attribute(:landing_time) { show! }
    attribute(:takeoff_location_raw) { show! }
    attribute(:landing_location_raw) { show! }
    attribute(:aircraft) do
      empty!
      attribute(:registration) { show! }
    end

    attribute(:pilot1) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end

    attribute(:pilot2) do
      show!
      empty!
      attribute(:first_name) { show! }
      attribute(:last_name) { show! }
    end
  end

  view :edit do
    attribute(:aircraft) do
      show!
    end

    attribute(:pilot1) do
      show!
    end
    attribute(:pilot2) do
      show!
    end
  end

  build_member_roles(:blahblah) do |obj|
     roles = []
     pid = aaa_context.auth_person.id

     roles << :pilot1 if pid == obj.pilot1_id
     roles << :pilot2 if pid == obj.pilot2_id
     roles << :tow_pilot if obj.towed_by && pid == obj.towed_by.pilot1_id
     roles
  end
end

end
end
