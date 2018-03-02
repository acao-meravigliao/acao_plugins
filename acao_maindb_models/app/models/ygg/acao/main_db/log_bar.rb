module Ygg
module Acao
module MainDb

class LogBar < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :log_bar

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
