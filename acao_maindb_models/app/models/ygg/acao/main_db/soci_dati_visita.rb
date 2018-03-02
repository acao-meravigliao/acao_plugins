
module Ygg
module Acao
module MainDb

class SociDatiVisita < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :soci_dati_visite

  belongs_to :socio,
             class_name: '::Ygg::Acao::MainDb::Socio',
             primary_key: 'codice_socio_dati_generale',
             foreign_key: 'codice_socio_dati_visite'

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
