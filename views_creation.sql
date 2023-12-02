CREATE VIEW Album_Compositor_Barocco_Add AS
    SELECT DISTINCT
        a.codigo,
        f.numero
    FROM
        Periodo_Musical pm
        INNER JOIN Compositor_Periodo_Musical cpm ON pm.codigo = cpm.codigo_periodo AND pm.descricao LIKE 'Barroco'
        INNER JOIN Compositor c ON cpm.codigo_compositor = c.codigo
        INNER JOIN Faixa_Compositor fc ON c.codigo = fc.fk_codigo_compositor
        INNER JOIN Faixa f ON fc.codigo_album = f.codigo_album AND fc.numero_faixa = f.numero AND f.tipo_gravacao LIKE 'ADD'
        INNER JOIN Album a ON f.codigo_album = a.codigo;

CREATE VIEW view_playlists WITH SCHEMABINDING
AS
	SELECT p.nome AS "Nome da Playlist", count(fp.numero_faixa) AS "Quantidade de Faixas" 
	FROM playlist p 
	JOIN faixa_playlist fp ON p.cod = fp.cod_playlist
	GROUP BY p.nome

-- Albuns com preço de compra maior que a média de preço de todos os albuns
CREATE VIEW Albuns_Acima_Media AS
SELECT a.nome, a.pr_compra FROM Album a WHERE a.pr_compra >= ALL(SELECT AVG(pr_compra) FROM Album)

-- Gravadora com maior número de playlists com pelo menos uma faixa composta por Dvorak
CREATE VIEW Faixas_De_Dvorak
AS
SELECT f.numero_faixa, f.codigo_album
FROM compositor c
    LEFT OUTER JOIN faixa_compositor fc ON c.nome = 'Dvorak' AND c.codigo = fc.codigo_compositor
    INNER JOIN faixa f ON f.numero_faixa = fc.numero_faixa AND f.codigo_album = fc.codigo_album;

-- View para contar o n�mero de playlists associadas a faixas compostas por Dvorak para cada gravadora e �lbum
create view qtd_playlist_faixas_dvorak
as
select a.codigo_gravadora, g.nome as nome_gravadora, a.nome as nome_album, f.codigo_album, f.numero_faixa, count(fp.codigo_playlist) as qtd_playlists
from faixas_de_dvorak f
    left outer join faixa_playlist fp on f.numero_faixa = fp.numero_faixa and f.codigo_album = fp.codigo_album
    inner join album a on f.codigo_album = a.codigo
    inner join gravadora g on a.codigo_gravadora = g.codigo
group by a.codigo_gravadora, g.nome, a.nome, f.codigo_album, f.numero_faixa;

-- View final para listar o nome da gravadora com o maior n�mero de playlists que possuem pelo menos uma faixa composta por Dvorak
create view seteb as
select qpfd.nome_gravadora, sum(qpfd.qtd_playlists) as qtd_de_faixas_em_playlists 
from qtd_playlist_faixas_dvorak qpfd
group by qpfd.codigo_gravadora, qpfd.nome_gravadora
having sum(qpfd.qtd_playlists) >= all (select sum(qpfd_inner.qtd_playlists) from qtd_playlist_faixas_dvorak qpfd_inner group by qpfd_inner.codigo_gravadora);

create view compositor_e_faixas
as
select c.codigo as cod_compositor, c.nome, f.codigo_album, f.numero_faixa, count(fp.codigo_playlist) as qtd_playlists
from compositor c
    left outer join faixa_compositor fc on c.codigo = fc.codigo_compositor
    inner join faixa f on f.numero_faixa = fc.numero_faixa and f.codigo_album = fc.codigo_album
    left outer join faixa_playlist fp on f.numero_faixa = fp.numero_faixa and f.codigo_album = fp.codigo_album
group by c.codigo, c.nome, f.codigo_album, f.numero_faixa;

-- View para calcular a soma de playlists para cada compositor
create view compositor_por_playlist
as
select nome, sum(qtd_playlists) as sum_qtd_playlists
from compositor_e_faixas
group by cod_compositor, nome;

-- View final para listar o nome do compositor com o maior n�mero de faixas nas playlists existentes
create view setec as
select top 1 with ties nome, sum_qtd_playlists
from compositor_por_playlist
order by sum_qtd_playlists desc;

drop view faixa_concerto_barroca
create view faixa_concerto_barroca
drop view faixa_concerto_barroca
create view faixa_concerto_barroca
as
select f.cod_album, f.numero, co.nome
	from composicao co inner join faixa f on co.nome like 'Concerto' and co.cod=f.tipo_composicao
		 inner join faixa_compositor fc on f.numero=fc.numero_faixa and f.cod_album=fc.cod_album
		 inner join compositor c on fc.cod_composit=c.cod
		 inner join compositor_periodo_music cpm on c.cod=cpm.cod_composit
		 inner join periodo_musc pm on cpm.cod_periodo=pm.cod and pm.descr like 'Barroco'
	group by f.cod_album, f.numero, co.nome

create view oitod
as
select distinct p.cod, p.nome, p.dt_criacao, p.dt_ult_reprod, p.num_reprod
	from playlist p inner join faixa_playlist fp on p.cod=fp.cod_playlist
		 inner join faixa f on f.numero=fp.numero_faixa and f.cod_album=fp.cod_album
	group by p.cod, p.nome, p.dt_criacao, p.dt_ult_reprod, p.num_reprod, p.tempo, f.numero, f.cod_album
	having dbo.eh_concerto_barroca(f.numero, f.cod_album) = 1
as
select f.codigo_album, f.numero_faixa, co.nome
from composicao co
    inner join faixa f on co.codigo = f.tipo_composicao and co.nome = 'Concerto'
    inner join faixa_compositor fc on f.numero_faixa = fc.numero_faixa and f.codigo_album = fc.codigo_album
    inner join compositor c on fc.cod_composit = c.codigo
    inner join compositor_periodo_musical cpm on c.codigo = cpm.codigo_compositor
    inner join periodo_musical pm on cpm.codigo_periodo = pm.codigo and pm.descricao = 'Barroco'
group by f.codigo_album, f.numero_faixa, co.nome;

create view seted
as
select p.codigo, p.nome, p.data_criacao, p.data_ultima_reproducao, p.numero_reproducao
from playlist p
    inner join faixa_playlist fp on p.codigo = fp.codigo_playlist
    inner join faixa f on f.numero_faixa = fp.numero_faixa and f.codigo_album = fp.codigo_album
group by p.codigo, p.nome, p.data_criacao, p.data_ultima_reproducao, p.numero_reproducao
having sum(dbo.eh_concerto_barroca(f.numero_faixa, f.codigo_album)) = count(*);

create view faixas_playlists
as
select 
    p.cod as cod_playlist, 
    a.cod as cod_album, 
    f.numero as numero, 
    f.descr as descr, 
    f.tempo as tempo, 
    c.nome as composicao, 
    f.tipo_grav
from 
    playlist p 
    left outer join faixa_playlist fp on p.cod = fp.cod_playlist
    inner join faixa f on fp.cod_album = f.cod_album and fp.numero_faixa = f.numero
    inner join album a on f.cod_album = a.cod
    inner join composicao c on f.tipo_composicao = c.cod
group by 
    p.cod, a.cod, f.numero, f.descr, f.tempo, c.nome, f.tipo_grav;