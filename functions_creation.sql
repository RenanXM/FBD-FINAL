-- EQUIPE: RENAN XEREZ MARQUES - 508682 | HAVILLON BARROS FREITAS - 508017

-- 6) Defina uma função que tem como parâmetro de entrada o nome (ou parte do) 
-- nome do compositor e o parâmetro de saída todos os álbuns com obras 
-- compostas pelo compositor
create function album_compositor (@nome varchar)
	returns @tabela_obras table
	(albuns_compositor varchar(30))
as
begin
	insert into @tabela_obras
	select distinct a.nome 
	from compositor c
	inner join faixa_compositor fc on c.cod = fc.cod_comp
	inner join faixa f on fc.cod_faixa = f.cod
	inner join meio_fisico_faixa mfa on f.cod = mfa.cod_faixa
	inner join meio_fisico mf ON mfa.cod_meio_fisico = mf.cod
	inner join album a ON mf.cod_album = a.cod
	where c.nome like ('%'+@nome+'%')
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