
module Ygg
module Acao
module MainDb

class Socio < ActiveRecord::Base
  establish_connection :acao_sqlserver

  self.table_name = :soci_dati_generale

  has_many :iscrizioni,
           :class_name => '::Ygg::Acao::MainDb::SocioIscritto',
           :primary_key => 'codice_socio_dati_generale',
           :foreign_key => 'codice_iscritto'
end

end
end
end
