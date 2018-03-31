#
# Copyright (C) 2017-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TowRosterEntry < Ygg::PublicModel
  self.table_name = 'acao_tow_roster_entries'

  belongs_to :person,
             class_name: 'Ygg::Core::Person'

  belongs_to :day,
             class_name: 'Ygg::Acao::TowRosterDay'

  after_initialize do
    if new_record?
      self.selected_at = Time.now
    end
  end
end

end
end
