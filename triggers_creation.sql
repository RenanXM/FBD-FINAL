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

-- CREATE TRIGGER BARROCO_COM_DDD_FC ON faixa_compositor FOR INSERT, UPDATE
-- AS
-- IF EXISTS (SELECT cod_album FROM inserted WHERE cod_album IN (SELECT DISTINCT cod FROM album_com_faixa_barroca_ADD))
-- BEGIN
-- 	RAISERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1)
-- 	ROLLBACK TRANSACTION
-- END

-- CREATE TRIGGER BARROCO_COM_DDD_F ON faixa FOR INSERT, UPDATE
-- AS
-- IF UPDATE(tipo_composicao) OR UPDATE(tipo_grav)
-- BEGIN
-- 	IF EXISTS (SELECT cod_album FROM inserted where cod_album in (SELECT DISTINCT cod FROM album_com_faixa_barroca_ADD))
-- 	BEGIN
-- 		RAISERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1)
-- 		ROLLBACK TRANSACTION
-- 	END
-- END

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