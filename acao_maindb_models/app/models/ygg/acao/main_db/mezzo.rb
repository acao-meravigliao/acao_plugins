
module Ygg
module Acao
module MainDb

class Mezzo < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :mezzi

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
