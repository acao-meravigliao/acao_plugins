
module Ygg
module Acao
module Onda

class Volo < ActiveRecord::Base
  establish_connection :acao_onda

  self.table_name = :voli


end

end
end
end
