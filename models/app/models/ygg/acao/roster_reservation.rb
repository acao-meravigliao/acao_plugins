module Ygg
module Acao

class RosterReservation < Ygg::PublicModel
  self.table_name = 'acao_roster_reservations'

  belongs_to :pilot,
             class_name: '::Ygg::Acao::Pilot'

  belongs_to :plane,
             class_name: '::Ygg::Acao::Plane'

  interface :rest do
  end
end

end
end
