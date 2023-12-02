CREATE FUNCTION album_compositor (@nome VARCHAR)
RETURNS @tabela_obras TABLE (albuns_compositor NVARCHAR(30))
AS
BEGIN
    INSERT INTO @tabela_obras
    SELECT DISTINCT a.nome
    FROM Compositor c
    INNER JOIN Faixa_Compositor fc ON c.codigo = fc.fk_codigo_compositor
    INNER JOIN Faixa f ON fc.fk_codigo_faixa = f.codigo_faixa
    INNER JOIN Album a ON f.codigo_album = a.codigo
    WHERE c.nome LIKE ('%' + @nome + '%')

    RETURN
END;

CREATE FUNCTION eh_concerto_barroca(@numero SMALLINT, @album SMALLINT)
RETURNS INTEGER
AS
BEGIN 
	DECLARE @retorno INTEGER

	SELECT @retorno=count(*) FROM faixa_concerto_barroca WHERE @numero=numero AND @album=cod_album
	
	RETURN @retorno
END

CREATE FUNCTION eh_concerto_barroca(@numero_faixa SMALLINT, @codigo_album SMALLINT)
RETURNS INTEGER
AS
BEGIN 
    DECLARE @retorno INTEGER

    SELECT @retorno = count(*) 
    FROM faixa_concerto_barroca 
    WHERE @numero_faixa = numero_faixa AND @codigo_album = codigo_album
    
    RETURN @retorno
END