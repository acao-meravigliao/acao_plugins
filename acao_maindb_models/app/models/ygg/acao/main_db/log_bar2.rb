module Ygg
module Acao
module MainDb

class LogBar2 < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :log_bar_2

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
