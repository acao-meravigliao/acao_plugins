
module Ygg
module Acao
module MainDb

class SocioIscritto < ActiveRecord::Base
  establish_connection :acao_sqlserver

  self.table_name = :soci_iscritti

  belongs_to :socio,
             :class_name => '::Ygg::Acao::MainDb::Socio',
             :primary_key => 'codice_socio_dati_generale',
             :foreign_key => 'codice_iscritto'
end

end
end
end
