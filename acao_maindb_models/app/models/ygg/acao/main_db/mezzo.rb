
module Ygg
module Acao
module MainDb

class Mezzo < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :mezzi
#
#  has_many :iscrizioni,
#           :class_name => '::Ygg::Acao::MainDb::SocioIscritto',
#           :primary_key => 'codice_socio_dati_generale',
#           :foreign_key => 'codice_iscritto'
end

end
end
end
