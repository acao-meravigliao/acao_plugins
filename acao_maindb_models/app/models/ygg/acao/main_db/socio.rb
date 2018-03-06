
module Ygg
module Acao
module MainDb

class Socio < ActiveRecord::Base
  establish_connection :acao_sql_server

  self.table_name = :soci_dati_generale

  has_many :iscrizioni,
           class_name: '::Ygg::Acao::MainDb::SocioIscritto',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_iscritto'

  has_one :licenza,
           class_name: '::Ygg::Acao::MainDb::SociDatiLicenza',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_socio_dati_licenze'

  has_one :visita,
           class_name: '::Ygg::Acao::MainDb::SociDatiVisita',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_socio_dati_visite'

  has_many :log_bar,
           class_name: '::Ygg::Acao::MainDb::LogBar',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_socio'

  has_many :log_bar2,
           class_name: '::Ygg::Acao::MainDb::LogBar2',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_socio'

  has_many :cassetta_bar_locale,
           class_name: '::Ygg::Acao::MainDb::CassettaBarLocale',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice'

  has_many :log_bollini,
           class_name: '::Ygg::Acao::MainDb::LogBollini',
           primary_key: 'codice_socio_dati_generale',
           foreign_key: 'codice_pilota'

  extend Ygg::Acao::MainDb::LastUpdateTracker
end

end
end
end
