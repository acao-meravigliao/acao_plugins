#
# Copyright (C) 2015-2015, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#
#/

module Ygg
module Tracking

class Contest < ActiveRecord::Base
  self.table_name = 'trk_contests'

  include Ygg::Core::UsesGuid
  uses_guid

  has_many :days,
           :class_name => 'Ygg::Tracking::Contest::Day'

  class Day < ActiveRecord::Base
    self.table_name = 'trk_contest_days'

    include Ygg::Core::UsesGuid
    uses_guid

    belongs_to :contest,
               :class_name => 'Ygg::Tracking::Contest'
  end
end

end
end
