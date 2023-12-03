create function album_compositor (@nome varchar)
	returns @tabela_obras table
	(albuns_compositor nvarchar(30))
as
begin
	insert into @tabela_obras
	select distinct a.nome from compositor c, faixa_compositor fc, faixa f, album a 
		where c.nome like ('%'+@nome+'%') and c.cod=fc.cod_composit
			  and fc.numero_faixa=f.numero and f.cod_album=a.cod
	return			
end

CREATE FUNCTION eh_concerto_barroca(@numero SMALLINT, @album SMALLINT)
RETURNS int
AS
BEGIN 
	DECLARE @retorno int

	SELECT @retorno=COUNT(*) FROM faixa_concerto_barroca WHERE @numero=numero AND @album=cod_album
	
	RETURN @retorno
END