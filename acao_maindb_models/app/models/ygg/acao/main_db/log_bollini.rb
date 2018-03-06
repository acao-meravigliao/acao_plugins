module Ygg
module Acao
module MainDb

class LogBollini < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :log_bollini

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
