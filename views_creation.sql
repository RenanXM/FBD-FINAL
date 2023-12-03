-- VIEW PARA RESTRIÇÃO
-- a) Um álbum, com faixas de músicas do período barroco, só pode ser inserido no 
-- banco de dados, caso o tipo de gravação seja DDD.

CREATE VIEW album_com_faixa_barroca_ADD
AS
SELECT DISTINCT a.cod, f.numero
	FROM periodo_musc pm --INNER JOIN compositor_periodo_music cpm ON pm.cod=cpm.cod_periodo AND descr LIKE 'Barroco'
			INNER JOIN compositor c ON pm.cod=c.cod_periodo_musc
			INNER JOIN faixa_compositor fc ON c.cod=fc.cod_comp
			INNER JOIN faixa f ON fc.cod_faixa=f.cod AND f.tipo_grav LIKE 'ADD'
			INNER JOIN album a ON f.cod_album=a.cod
	GROUP BY a.cod, f.numero

CREATE VIEW V5 (cod_playlist, cod_faixa, cod_album, qtd_albuns)
WITH SCHEMABINDING
AS
SELECT p.cod, f.numero, f.cod_album, COUNT_BIG(*)
	FROM dbo.playlist p INNER JOIN dbo.faixa_playlist fp ON p.cod=fp.cod_playlist
		 INNER JOIN dbo.faixa f ON fp.numero_faixa=f.numero
	GROUP BY p.cod, f.numero, f.cod_album

CREATE VIEW V5b (nome_playlist, qtd_album)
AS
SELECT p.nome, COUNT(cod_album) FROM V5 INNER JOIN playlist p ON p.cod=cod_playlist GROUP BY cod_playlist, p.nome

CREATE VIEW setea AS
SELECT a.nome, a.pr_compra FROM album a WHERE a.pr_compra >= all (SELECT AVG(pr_compra) FROM album)

CREATE VIEW faixas_de_dvorack
AS
SELECT f.numero, f.cod_album
	FROM compositor c LEFT OUTER JOIN faixa_compositor fc ON c.nome LIKE 'Dvorack' AND c.cod=fc.cod_composit
		 INNER JOIN faixa f ON f.numero=fc.numero_faixa AND f.cod_album=fc.cod_album

CREATE VIEW qtd_playlist_faixas_dvorack
AS
SELECT a.cod_grav, g.nome AS nome_grav, a.nome AS nome_album, f.cod_album, f.numero, COUNT(fp.cod_playlist) qtd_playlists
	FROM faixas_de_dvorack f LEFT OUTER JOIN faixa_playlist fp ON f.numero=fp.numero_faixa AND f.cod_album=fp.cod_album
		 INNER JOIN album a ON f.cod_album=a.cod
		 INNER JOIN gravadora g ON a.cod_grav=g.cod
	GROUP BY a.cod_grav, g.nome, a.nome, f.cod_album, f.numero

CREATE VIEW seteb AS
SELECT qpfd.nome_grav, SUM(qtd_playlists) AS qtd_de_faixas_em_playlists FROM qtd_playlist_faixas_dvorack qpfd
	GROUP BY cod_grav, qpfd.nome_grav
	HAVING SUM(qtd_playlists) >= all (SELECT SUM(qtd_playlists) FROM qtd_playlist_faixas_dvorack qpfd GROUP BY cod_grav)

CREATE VIEW compositor_e_faixas
AS
SELECT c.cod, c.nome, f.cod_album, f.numero, COUNT(fp.cod_playlist) qtd_playlists
	FROM compositor c LEFT OUTER JOIN faixa_compositor fc ON c.cod=fc.cod_composit
		 INNER JOIN faixa f ON f.numero=fc.numero_faixa AND f.cod_album=fc.cod_album
		 LEFT OUTER JOIN faixa_playlist fp ON f.numero=fp.numero_faixa AND f.cod_album=fp.cod_album
	GROUP BY c.cod, c.nome, f.cod_album, f.numero

CREATE VIEW compositor_por_playlist
AS
SELECT c.nome, SUM(qtd_playlists) sum_qtd_playlists FROM compositor_e_faixas c GROUP BY c.cod, c.nome

CREATE VIEW setec AS
SELECT c.nome, sum_qtd_playlists FROM compositor_por_playlist c WHERE sum_qtd_playlists >= all (SELECT sum_qtd_playlists FROM compositor_por_playlist)

CREATE VIEW faixa_concerto_barroca
AS
SELECT f.cod_album, f.numero, co.nome
	FROM composicao co INNER JOIN faixa f ON co.nome LIKE 'Concerto' AND co.cod=f.tipo_composicao
		 INNER JOIN faixa_compositor fc ON f.numero=fc.numero_faixa AND f.cod_album=fc.cod_album
		 INNER JOIN compositor c ON fc.cod_composit=c.cod
		 INNER JOIN compositor_periodo_music cpm ON c.cod=cpm.cod_composit
		 INNER JOIN periodo_musc pm ON cpm.cod_periodo=pm.cod AND pm.descr LIKE 'Barroco'
	GROUP BY f.cod_album, f.numero, co.nome

CREATE VIEW seted
AS
SELECT DISTINCT p.cod, p.nome, p.dt_criacao, p.dt_ult_reprod, p.num_reprod
	FROM playlist p INNER JOIN faixa_playlist fp ON p.cod=fp.cod_playlist
		 INNER JOIN faixa f ON f.numero=fp.numero_faixa AND f.cod_album=fp.cod_album
	GROUP BY p.cod, p.nome, p.dt_criacao, p.dt_ult_reprod, p.num_reprod, p.tempo, f.numero, f.cod_album
	having dbo.eh_concerto_barroca(f.numero, f.cod_album) = 1

CREATE VIEW faixas_playlists
AS
	SELECT p.cod AS cod_playlist, a.cod AS cod_album, f.numero AS numero, f.descr AS descr, f.tempo AS tempo, c.nome AS composicao, f.tipo_grav
	FROM playlist p LEFT OUTER JOIN faixa_playlist fp ON p.cod=fp.cod_playlist
		INNER JOIN faixa f ON fp.cod_album=f.cod_album AND fp.numero_faixa=f.numero
		INNER JOIN album a ON f.cod_album=a.cod
		INNER JOIN composicao c ON f.tipo_composicao = c.cod
	GROUP BY p.cod, p.nome, a.cod, f.numero, a.nome, f.descr, f.tempo, c.nome,  f.tipo_grav
