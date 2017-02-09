#
# Copyright (C) 2016-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

module Ygg
module Acao

class TimetableEntry < Ygg::PublicModel
  self.table_name = 'acao_timetable_entries'

  belongs_to :aircraft,
             class_name: '::Ygg::Acao::Aircraft'

  belongs_to :pilot,
             class_name: '::Ygg::Core::Person'

  belongs_to :towed_by,
             class_name: '::Ygg::Acao::TimetableEntry'
end

end
end
