-- a) Um álbum, com faixas de músicas do período barroco, só pode ser inserido no 
-- banco de dados, caso o tipo de gravação seja DDD.

CREATE TRIGGER BARROCO_COM_DDD ON album 
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS ( 
		SELECT DISTINCT a.cod, f.numero
			FROM periodo_musc pm 
				INNER JOIN compositor c ON pm.cod=c.cod_periodo_musc
				INNER JOIN faixa_compositor fc ON c.cod=fc.cod_comp
				INNER JOIN faixa f ON fc.cod_faixa=f.cod
				INNER JOIN meio_fisico_faixa mfa ON f.cod=mfa.cod_faixa
				INNER JOIN meio_fisico mf ON mfa.cod_meio_fisico = mf.cod
				INNER JOIN album a ON mf.cod_album=a.cod
				WHERE(
					mfa.tipo_gravacao LIKE 'ADD'
					AND
					pm.descr LIKE 'Barroco'
				)
	) BEGIN
		RAISERROR('Um album do periodo barroco só pode ser inserido se o tipo de gravação for DDD',2,2,2);
        ROLLBACK TRANSACTION;
    END
END

-- b) Um álbum não pode ter mais que 64 faixas (músicas).
CREATE TRIGGER MAX_FAIXAS ON faixa FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @cod_album SMALLINT, @QTDE_FAIXAS int

	SELECT @cod_album=cod_album FROM inserted

	SELECT @QTDE_FAIXAS=COUNT(*) 
	FROM faixa f
	INNER JOIN meio_fisico_faixa mfa ON f.cod = mfa.cod_faixa
	INNER JOIN meio_fisico mf ON mfa.cod_meio_fisico = mf.cod
	INNER JOIN album a ON mf.cod_album = a.cod 
	WHERE a.cod=@cod_album GROUP BY a.cod

	IF (@QTDE_FAIXAS > 64)
	BEGIN
		RAISERROR('Numero maximo de faixas execedido!', 16,1)
		ROLLBACK TRANSACTION
	END
END

-- c) No caso de remoção de um álbum do banco de dados, todas as suas faixas 
-- devem ser removidas. Lembre-se que faixas podem apresentar, por sua vez, 
-- outros relacionamentos.

-- REALIZADA USANDO ON DELETE CASCADE

-- d) O preço de compra de um álbum não dever ser superior a três vezes a média 
-- do preço de compra de álbuns, com todas as faixas com tipo de gravação 
-- DDD
CREATE TRIGGER LIMITE_PRECO ON album
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(
		SELECT * FROM inserted WHERE pr_compra > (
			SELECT 3 * AVG(pr_compra) 
			FROM album a INNER JOIN meio_fisico mf ON a.cod = mf.cod_album
			INNER JOIN meio_fisico_faixa mfa ON mf.cod = mfa.cod_meio_fisico 
			WHERE mfa.tipo_gravacao LIKE 'DDD'
		)
	)
	BEGIN
		RAISERROR('O preco de compra de um album nao pode ultrapassar 3x a media do preco de albuns cujas faixas tem tipo de gravacao DDD', 16,1);
		ROLLBACK TRANSACTION
	END
END