CREATE TRIGGER BARROCO_COM_DDD_FC ON faixa_compositor FOR INSERT, UPDATE
AS
IF EXISTS (SELECT cod_album FROM inserted WHERE cod_album IN (SELECT DISTINCT cod FROM album_com_faixa_barroca_ADD))
BEGIN
	RAISERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1)
	ROLLBACK TRANSACTION
END

CREATE TRIGGER BARROCO_COM_DDD_F ON faixa FOR INSERT, UPDATE
AS
IF UPDATE(tipo_composicao) OR UPDATE(tipo_grav)
BEGIN
	IF EXISTS (SELECT cod_album FROM inserted where cod_album in (SELECT DISTINCT cod FROM album_com_faixa_barroca_ADD))
	BEGIN
		RAISERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1)
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER MAX_FAIXAS ON faixa FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @cod_album SMALLINT, @QTDE_FAIXAS int

	SELECT @cod_album=cod_album FROM inserted

	SELECT @QTDE_FAIXAS=COUNT(*) FROM faixa WHERE cod_album=@cod_album GROUP BY cod_album

	IF (@QTDE_FAIXAS > 64)
	BEGIN
		RAISERROR('Numero maximo de faixAS execedido!', 16,1)
		ROLLBACK TRANSACTION
	END
END