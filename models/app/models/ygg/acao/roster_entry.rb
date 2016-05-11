module Ygg
module Acao

class RosterEntry < Ygg::PublicModel
  self.table_name = 'acao_roster_entries'

  belongs_to :plane,
             class_name: '::Ygg::Acao::Plane'

  belongs_to :pilot,
             class_name: '::Ygg::Acao::Pilot'

  interface :rest do
  end
end

end
end
