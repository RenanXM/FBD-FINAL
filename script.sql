-- FILEGROUP 1 arquivo
--Tabela de Playlists, Tabela de Faixas, Tabela de Associação Playlist_Faixa 


-- FILEGROUP 2 arquivos
--Tabela de Meios Físicos, Tabela de Álbuns, Tabela de Discos, 
--Tabela de Tipos de Composição, Tabela de Intérpretes, 
--Tabela de Compositores, Tabela de Períodos Musicais, Tabela de Gravadoras, 

-- Criação do banco de dados BDSpotPer
CREATE DATABASE BDSpotPer
ON
	-- Definição do filegroup primário
	PRIMARY
	(
		NAME = 'BDSpotPer',                         
		FILENAME = 'C:\FBD-FINAL\BDSpotPer.mdf',   
		SIZE = 5120KB,                              
		FILEGROWTH = 1024KB                         
	),
	-- Definição do segundo filegroup (BDSpotPer_fg01)
	FILEGROUP BDSpotPer_fg01
	(
		NAME = 'BDSpotPer_001',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_001.ndf',
		SIZE = 1024KB,                              
		FILEGROWTH = 30%                            
	),

	(
		NAME = 'BDSpotPer_002',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_002.ndf',
		SIZE = 1024KB,                              
		MAXSIZE = 3072KB,                           
		FILEGROWTH = 15%                            
	),
	-- Definição do terceiro filegroup (BDSpotPer_fg02)
	FILEGROUP BDSpotPer_fg02
	(
		NAME = 'BDSpotPer_003',                    
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_003.ndf',
		SIZE = 2048KB,                              
		MAXSIZE = 5120KB,                          
		FILEGROWTH = 30%                            
	)
	-- Definição do log
	LOG ON 
	(
		NAME = 'BDSpotPer_log',                     
		FILENAME = 'C:\FBD-FINAL\BDSpotPer_log.ldf',
		SIZE = 1024KB,                              
		FILEGROWTH = 10%                            
	);

-----------------------------------------------------------------------------------------------

-- Alterando para o banco de dados BDSpotPer
USE BDSpotPer;


CREATE TABLE Gravadora(
	codigo INTEGER  NOT NULL,
	endereco VARCHAR (100) NOT NULL,
	pagina VARCHAR (100) NOT NULL,
	nome VARCHAR (20) NOT NULL,
	CONSTRAINT PK_GRAVADORA PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Album(
	codigo INTEGER  NOT NULL,
	fk_codigo_gravadora INTEGER  NOT NULL,
	nome VARCHAR (50) NOT NULL,
	descricao VARCHAR (100) NOT NULL, 
	tipo_compra VARCHAR (20) NOT NULL,
	pr_compra DEC(5,2) NOT NULL,
	dt_compra DATE NOT NULL,
	dt_gravacao DATE NOT NULL,
	
	CONSTRAINT PK_ALBUM PRIMARY KEY (codigo),
	CONSTRAINT FK_GRAVADORA FOREIGN KEY (fk_codigo_gravadora) REFERENCES Gravadora,
	CONSTRAINT TIPO_COMPRA CHECK (tipo_compra LIKE 'fisica' OR tipo_compra LIKE 'download'),
	CONSTRAINT DATA_COMPRA CHECK (dt_compra > '01/01/2000')

) ON BDSpotPer_fg01;

CREATE TABLE telefone(
	numero VARCHAR (13) NOT NULL,
	cod_grav INTEGER  NOT NULL,
	CONSTRAINT PK_TEL PRIMARY KEY (numero),
	CONSTRAINT FK_GRAV_TEL FOREIGN KEY (cod_grav) REFERENCES gravadora

) ON BDSpotPer_fg01;

CREATE TABLE composicao(
	cod INTEGER  NOT NULL,
	nome VARCHAR (20) NOT NULL,
	descr VARCHAR (100) NOT NULL, -- Sinfonia, ópera, sonata, concerto

	CONSTRAINT PK_COMPOSICAO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa(
	cod_faixa INTEGER  NOT NULL,
	numero INTEGER  NOT NULL,
	cod_album INTEGER  NOT NULL,
	descr VARCHAR (100) NOT NULL, 
	tempo time(0) NOT NULL,
	tipo_composicao INTEGER  NOT NULL,
	tipo_grav VARCHAR (3) NOT NULL

	CONSTRAINT PK_FAIXA PRIMARY KEY (cod_faixa)
	CONSTRAINT FK_ALBUM_FAIXA FOREIGN KEY (cod_album) REFERENCES album ON DELETE CASCADE
	CONSTRAINT ADD_OU_DDD CHECK (tipo_grav LIKE 'ADD' OR tipo_grav LIKE 'DDD')
	
) ON BDSpotPer_fg02;

CREATE TABLE playlist(
	cod INTEGER  NOT NULL,
	nome VARCHAR (20) NOT NULL,
	dt_criacao DATE NOT NULL,
	dt_ult_reprod DATE NOT NULL,
	num_reprod INTEGER  NOT NULL,
	tempo time(0) NOT NULL,

	CONSTRAINT PK_PLAYLIST PRIMARY KEY (cod)

) ON BDSpotPer_fg02;

CREATE TABLE faixa_playlist(
	numero_faixa INTEGER  NOT NULL,
	cod_album INTEGER  NOT NULL,
	fk_cod_playlist INTEGER  NOT NULL,
	fk_cod_faixa INTEGER  NOT NULL

	CONSTRAINT FK_PLAYLIST_FP FOREIGN KEY (fk_cod_playlist) REFERENCES playlist
	CONSTRAINT FK_FAIXA_FP FOREIGN KEY (fk_cod_faixa) REFERENCES faixa

) ON BDSpotPer_fg02;

CREATE TABLE interprete(
	cod INTEGER  NOT NULL,	
	nome VARCHAR (20) NOT NULL,
	tipo VARCHAR (20) NOT NULL, --  orquestra, trio, quarteto, ensemble, soprano, tenor..

	CONSTRAINT PK_INTERP PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa_interprete(
	numero_faixa INTEGER  NOT NULL,
	cod_album INTEGER  NOT NULL,
	cod_interp INTEGER  NOT NULL,

	CONSTRAINT FK_INTERP_I FOREIGN KEY (cod_interp) REFERENCES interprete

) ON BDSpotPer_fg01;

CREATE TABLE compositor(
	cod INTEGER  NOT NULL,	
	nome VARCHAR (20) NOT NULL,
	local_nasc VARCHAR (100) NOT NULL,
	dt_nasc DATE NOT NULL, 
	dt_morte date,

	CONSTRAINT PK_COMPOSITOR PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa_compositor(
	numero_faixa INTEGER  NOT NULL,
	cod_album INTEGER  NOT NULL,
	cod_composit INTEGER  NOT NULL,

	CONSTRAINT FK_COMPOSIT_C FOREIGN KEY (cod_composit) REFERENCES compositor

) ON BDSpotPer_fg01;

CREATE TABLE periodo_musc(
	cod INTEGER  NOT NULL,
	descr VARCHAR (100) NOT NULL, --barroco, clássico, romântico, etc..
	intervalo VARCHAR (30) NOT NULL, 

	CONSTRAINT PK_PERIODO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE compositor_periodo_music(
	cod_composit INTEGER  NOT NULL,
	cod_periodo INTEGER  NOT NULL,

	CONSTRAINT FK_COMPOSIT_CPM FOREIGN KEY (cod_composit) REFERENCES compositor,
	CONSTRAINT FK_PERIODO_CPM FOREIGN KEY (cod_periodo) REFERENCES periodo_musc

) ON BDSpotPer_fg01;

-------------------------------------------------------------------------------------------------------------------------
-- Criar uma visão materializada que tem como atributos o nome da playlist e a quantidade de álbuns que a compõem.
CREATE VIEW view_playlists WITH SCHEMABINDING
AS
	SELECT p.nome AS "Nome da Playlist", count(fp.numero_faixa) AS "Quantidade de Faixas" 
	FROM playlist p 
	JOIN faixa_playlist fp ON p.cod = fp.cod_playlist
	GROUP BY p.nome


-- Defina um índice primário para a tabela de Faixas sobre o atributo código do álbum. 
-- Defina um índice secundário para a mesma tabela sobre o atributo tipo de composição. Os dois com taxas de preenchimento máxima.
CREATE CLUSTERED INDEX idx_cod_album
ON faixa (cod_album) FILLFACTOR=100

CREATE UNCLUSTERED INDEX idx_tipo_composicao
ON faixa (tipo_composicao) FILLFACTOR=100


-- PRIMEIRA RESTRIÇÃO:
--  Um álbum, com faixas de músicas do período barroco, só pode ser inserido no
--  banco de dados, caso o tipo de gravação seja DDD.




-- SEGUNDA RESTRIÇÃO:
-- Um álbum não pode ter mais que 64 faixas (músicas)




-- TERCEIRA RESTRIÇÃO: (num ja foi resolvido?)
-- No caso de remoção de um álbum do banco de dados, todas as suas faixas
-- devem ser removidas. Lembre-se que faixas podem apresentar, por sua vez,
-- outros relacionamentos.




-- QUARTA RESTRIÇÃO
-- O preço de compra de um álbum não dever ser superior a três vezes a média
-- do preço de compra de álbuns, com todas as faixas com tipo de gravação
-- DDD.



-- Defina uma função que tem como parâmetro de entrada o nome (ou parte do) 
-- nome do compositor e o parâmetro de saída todos os álbuns com obras 
-- compostas pelo compositor.


