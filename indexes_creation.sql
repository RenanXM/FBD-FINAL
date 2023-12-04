-- EQUIPE: RENAN XEREZ MARQUES - 508682 | HAVILLON BARROS FREITAS - 508017

-- 4) Defina um índice primário para a tabela de Faixas sobre o atributo código do 
-- álbum. Defina um índice secundário para a mesma tabela sobre o atributo tipo de 
-- composição. Os dois com taxas de preenchimento máxima.

CREATE CLUSTERED INDEX IDX_COD_ALBUM ON faixa(cod_album) WITH (fillfactor=100)
CREATE NONCLUSTERED INDEX IDS_FAIXA_TP_COMPOSICAO ON faixa(tipo_composicao) WITH (fillfactor=100)
