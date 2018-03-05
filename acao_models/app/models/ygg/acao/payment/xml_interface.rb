#
# Copyright (C) 2018-2018, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'roxml'

module Ygg
module Acao

class Payment::XMLInterface
  class Base
    include ROXML

    def initialize()
      yield self if block_given?
    end
  end

  class RicFisc < Base
    xml_name 'Root'

    xml_accessor :cod_schema, from: '@CodSchema'
    xml_accessor :data_ora_creazione, from: '@DataOraCreazione'

    class Docu < Base
      xml_name 'Docu'

      class Testa < Base
        xml_name 'Testa'

        class DatiControparte < Base
          xml_name 'DatiControparte'

          xml_accessor :citta, from: 'Citta'
          xml_accessor :codice_fiscale, from: 'CodiceFiscale'
          xml_accessor :e_mail, from: 'E_mail'
          xml_accessor :indirizzo, from: 'Indirizzo'
          xml_accessor :partita_iva, from: 'PartitaIva'
          xml_accessor :ragione_sociale, from: 'RagioneSociale'
          xml_accessor :invio_mail, from: 'InvioMail'
        end

        xml_accessor :abbuono, from: 'Abbuono'
        xml_accessor :acconto, from: 'Acconto'
        xml_accessor :acconto_in_cassa, from: 'AccontoInCassa'
        xml_accessor :calcoli_su_imponibile, from: 'CalcoliSuImponibile'
        xml_accessor :cod_divisa, from: 'CodDivisa'
        xml_accessor :cod_pagamento, from: 'CodPagamento'
        xml_accessor :contrassegno, from: 'Contrassegno'
        xml_accessor :nostro_rif, from: 'NostroRif'
        xml_accessor :tot_documento, from: 'TotDocumento'
        xml_accessor :tot_imponibile, from: 'TotImponibile'
        xml_accessor :tot_imposta, from: 'TotImposta'
        xml_accessor :vostro_rif, from: 'VostroRif'
        xml_accessor :dati_controparte, as: DatiControparte
      end

      class Righe < Base
        xml_name 'Righe'

        class Riga < Base
          xml_name 'Riga'

          class DatiArtServ < Base
            xml_name 'DatiArtServ'

            xml_accessor :cod_art, from: 'CodArt'
            xml_accessor :cod_un_mis_base, from: 'CodUnMisBase'
            xml_accessor :descrizione, from: 'Descrizione'
            xml_accessor :tipo_articolo, from: 'TipoArticolo'
          end

          xml_accessor :cod_art, from: 'CodArt'
          xml_accessor :cod_iva, from: 'CodIva'
          xml_accessor :cod_un_mis, from: 'CodUnMis'
          xml_accessor :descrizione, from: 'Descrizione'
          xml_accessor :imponibile, from: 'Imponibile'
          xml_accessor :importo_sconto, from: 'ImportoSconto'
          xml_accessor :imposta, from: 'Imposta'
          xml_accessor :perc_sconto1, from: 'PercSconto1'
          xml_accessor :perc_sconto2, from: 'PercSconto2'
          xml_accessor :perc_sconto3, from: 'PercSconto3'
          xml_accessor :perc_sconto4, from: 'PercSconto4'
          xml_accessor :qta, from: 'Qta'
          xml_accessor :tipo_riga, from: 'TipoRiga'
          xml_accessor :totale, from: 'Totale'
          xml_accessor :valore_unitario, from: 'ValoreUnitario'

          xml_accessor :dati_art_serv, as: DatiArtServ
        end

        xml_accessor :righe, as: [ Riga ]
      end

      class Coda < Base
        xml_name 'Coda'

        xml_accessor :aliquota1, from: 'Aliquota1'
        xml_accessor :aliquota2, from: 'Aliquota2'
        xml_accessor :aliquota3, from: 'Aliquota3'
        xml_accessor :aliquota4, from: 'Aliquota4'
        xml_accessor :aliquota5, from: 'Aliquota5'
        xml_accessor :castelletto_manuale, from: 'CastellettoManuale'
        xml_accessor :causale_trasporto, from: 'CausaleTrasporto'
        xml_accessor :cod_iva1, from: 'CodIva1'
        xml_accessor :cod_iva2, from: 'CodIva2'
        xml_accessor :cod_iva3, from: 'CodIva3'
        xml_accessor :cod_iva4, from: 'CodIva4'
        xml_accessor :cod_iva5, from: 'CodIva5'
        xml_accessor :cod_trasporto, from: 'CodTrasporto'
        xml_accessor :id_indirizzo_fattura, from: 'idIndirizzoFattura'
        xml_accessor :id_indirizzo_merce, from: 'IdIndirizzoMerce'
        xml_accessor :id_vettore1, from: 'IdVettore1'
        xml_accessor :imponibile1, from: 'Imponibile1'
        xml_accessor :imponibile2, from: 'Imponibile2'
        xml_accessor :imponibile3, from: 'Imponibile3'
        xml_accessor :imponibile4, from: 'Imponibile4'
        xml_accessor :imponibile5, from: 'Imponibile5'
        xml_accessor :imponibile_vb1, from: 'ImponibileVB1'
        xml_accessor :imponibile_vb2, from: 'ImponibileVB2'
        xml_accessor :imponibile_vb3, from: 'ImponibileVB3'
        xml_accessor :imponibile_vb4, from: 'ImponibileVB4'
        xml_accessor :imponibile_vb5, from: 'ImponibileVB5'
        xml_accessor :importo_sconto, from: 'ImportoSconto'
        xml_accessor :imposta1, from: 'Imposta1'
        xml_accessor :imposta2, from: 'Imposta2'
        xml_accessor :imposta3, from: 'Imposta3'
        xml_accessor :imposta4, from: 'Imposta4'
        xml_accessor :imposta5, from: 'Imposta5'
        xml_accessor :imposta_vb1, from: 'ImpostaVB1'
        xml_accessor :imposta_vb2, from: 'ImpostaVB2'
        xml_accessor :imposta_vb3, from: 'ImpostaVB3'
        xml_accessor :imposta_vb4, from: 'ImpostaVB4'
        xml_accessor :imposta_vb5, from: 'ImpostaVB5'
        xml_accessor :totale1, from: 'Totale1'
        xml_accessor :totale2, from: 'Totale2'
        xml_accessor :totale3, from: 'Totale3'
        xml_accessor :totale4, from: 'Totale4'
        xml_accessor :totale5, from: 'Totale5'
        xml_accessor :totale_vb1, from: 'TotaleVB1'
        xml_accessor :totale_vb2, from: 'TotaleVB2'
        xml_accessor :totale_vb3, from: 'TotaleVB3'
        xml_accessor :totale_vb4, from: 'TotaleVB4'
        xml_accessor :totale_vb5, from: 'TotaleVB5'
      end

      xml_accessor :testa, as: Testa
      xml_accessor :righe, as: Righe
      xml_accessor :coda, as: Coda
    end

    xml_accessor :docus, as: [ Docu ]
  end
  end
end

end
