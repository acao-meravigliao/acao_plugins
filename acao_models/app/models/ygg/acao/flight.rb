
module Ygg
module Acao

class Flight < Ygg::PublicModel
  self.table_name = 'acao_flights'

  belongs_to :plane,
             :class_name => 'Ygg::Acao::Plane'

  belongs_to :pilot1,
             :class_name => 'Ygg::Acao::Pilot'

  belongs_to :pilot2,
             :class_name => 'Ygg::Acao::Pilot'

  interface :rest do
#    capability :owner do
##      allow :show
#      default_readable!
#      readable :bollini_volo
#      readable :takeoff_at
#      readable :landing_at
#    end
  end

end

end
end
