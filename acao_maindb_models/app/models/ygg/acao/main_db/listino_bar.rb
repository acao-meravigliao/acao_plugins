module Ygg
module Acao
module MainDb

class ListinoBar < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :listino_bar

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
