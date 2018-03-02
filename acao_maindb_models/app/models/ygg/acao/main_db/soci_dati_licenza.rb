
module Ygg
module Acao
module MainDb

class SociDatiLicenza < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :soci_dati_licenze

  belongs_to :socio,
             class_name: '::Ygg::Acao::MainDb::Socio',
             primary_key: 'codice_socio_dati_generale',
             foreign_key: 'codice_socio_dati_licenze'

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
