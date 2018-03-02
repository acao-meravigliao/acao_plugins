
module Ygg
module Acao
module MainDb

class Volo < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :voli

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
