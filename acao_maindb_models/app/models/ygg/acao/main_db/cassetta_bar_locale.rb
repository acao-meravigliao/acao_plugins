module Ygg
module Acao
module MainDb

class CassettaBarLocale < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :cassetta_bar_locale

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
