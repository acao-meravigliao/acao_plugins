
module Ygg
module Acao
module MainDb

class Volo < ActiveRecord::Base
#  self.table_name = :flights

  establish_connection :acao_sql_server

  self.table_name = :voli


end

end
end
end
