-- 5) Criar uma visão materializada que tem como atributos o nome da playlist e a 
-- quantidade de álbuns que a compõem.
CREATE VIEW V5 
WITH SCHEMABINDING
AS
	SELECT p.nome AS nome_playlist, COUNT(DISTINCT a.cod) AS qtd_albuns
	FROM dbo.playlist p
	INNER JOIN dbo.faixa_playlist fp ON p.cod = fp.cod_playlist
	INNER JOIN dbo.faixa f ON fp.cod_faixa = f.cod
	INNER JOIN dbo.meio_fisico_faixa mfa ON f.cod = mfa.cod_faixa
	INNER JOIN dbo.meio_fisico mf ON mfa.cod_meio_fisico = mf.cod
	INNER JOIN dbo.album a ON mf.cod_album = a.cod
	GROUP BY p.nome

-- a. Listar os álbuns com preço de compra maior que a média de preços de 
-- compra de todos os álbuns
CREATE VIEW setea AS
SELECT a.nome, a.pr_compra FROM album a WHERE a.pr_compra >= all (SELECT AVG(pr_compra) FROM album)

-- b. Listar nome da gravadora com maior número de playlists que possuem 
-- pelo uma faixa composta pelo compositor Dvorack.
create view seteb
as
select top 1 g.nome, count(distinct p.cod) as qtd_playlists
from gravadora g
inner join album a on a.cod_grav = g.cod
inner join meio_fisico mf on a.cod = mf.cod_album
inner join meio_fisico_faixa mfa on mf.cod = mfa.cod_meio_fisico
inner join faixa f on mfa.cod_faixa = f.cod
inner join faixa_compositor fc on f.cod = fc.cod_faixa
inner join compositor c on fc.cod_comp = c.cod
inner join faixa_playlist fp on f.cod = fp.cod_faixa
inner join playlist p on fp.cod_playlist = p.cod
where c.nome LIKE 'Dvorak'
group by g.nome
order by qtd_playlists desc

-- c. Listar nome do compositor com maior número de faixas nas playlists
-- existentes.
-- CREATE VIEW setec AS
-- SELECT c.nome, sum_qtd_playlists FROM compositor_por_playlist c WHERE sum_qtd_playlists >= all (SELECT sum_qtd_playlists FROM compositor_por_playlist)
create view setec as
select top 1 c.nome, count (fp.cod_faixa) as qtd_faixa
from compositor c
inner join faixa_compositor fc on c.cod =  fc.cod
inner join faixa f on fc.cod_faixa = f.cod
inner join faixa_playlist fp on f.cod = fp.cod_faixa
group by c.nome
order by qtd_faixa desc

-- d. Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e 
-- período “Barroco”
create view seted
as
select distinct p.cod, p.nome, p.dt_criacao, p.dt_ult_reprod, p.num_reprod, p.tempo, f.descr
from playlist p
inner join faixa_playlist fp on p.cod = fp.cod_playlist
inner join faixa f on fp.cod_faixa = f.cod
inner join composicao c on f.cod_tipo_composicao = c.cod
inner join faixa_compositor fc on f.cod = fc.cod_faixa
inner join compositor cr on fc.cod_comp = cr.cod
inner join periodo_musc pm on cr.cod_periodo_musc = pm.cod
where c.descr LIKE 'Conserto' and pm.descr LIKE 'Barroco'

