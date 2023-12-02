-- Gatilho para a tabela Faixa_Compositor que verifica se um �lbum do per�odo barroco est� presente na vis�o quando h� inser��o ou atualiza��o.
CREATE TRIGGER BARROCO_COM_DDD_FC ON Faixa_Compositor FOR INSERT, UPDATE
AS
IF EXISTS (SELECT codigo_album FROM inserted WHERE codigo_album in (SELECT DISTINCT codigo FROM Album_Compositor_Barroco_Add))
BEGIN
	RAISERROR('Um �lbum, com faixas de m�sicas do per�odo barroco, s� pode ser adquirido, caso o tipo de grava��o seja DDD!', 16, 1)
	ROLLBACK TRANSACTION
END

-- Gatilho para a tabela Faixa que verifica se houve atualiza��o nas colunas tipo_composicao ou tipo_grav, e se um �lbum do per�odo barroco est� presente na vis�o.
CREATE TRIGGER BARROCO_COM_DDD_F ON Faixa FOR INSERT, UPDATE
AS
IF UPDATE(tipo_composicao) OR UPDATE(tipo_gravacao)
BEGIN
	IF EXISTS (SELECT codigo_album FROM inserted WHERE codigo_album IN (SELECT DISTINCT codigo FROM Album_Compositor_Barroco_Add))
	BEGIN
		RAISERROR('Um �lbum, com faixas de m�sicas do per�odo barroco, s� pode ser adquirido, caso o tipo de grava��o seja DDD!', 16, 1)
		ROLLBACK TRANSACTION
	END
END

-- SEGUNDA RESTRI��O 3b):
-- Um �lbum n�o pode ter mais que 64 faixas (m�sicas)

create trigger MAX_FAIXAS on faixa for insert, update
as
begin
	declare @cod_album smallint, @QTDE_FAIXAS int

	select @cod_album=cod_album from inserted

	select @QTDE_FAIXAS=count(*) from faixa where codigo_album=@cod_album group by codigo_album

	if (@QTDE_FAIXAS > 64)
	begin
		raiserror('Numero maximo de faixas execedido!', 16,1)
		rollback transaction
	end
end