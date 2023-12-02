CREATE CLUSTERED INDEX idx_cod_album
ON faixa (cod_album) FILLFACTOR=100

CREATE UNCLUSTERED INDEX idx_tipo_composicao
ON faixa (tipo_composicao) FILLFACTOR=100