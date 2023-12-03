USE BDSpotPer;


-- Cada álbum, uma coleção de músicas agrupadas em um meio físico de 
-- armazenamento, possui:
-- a. um código identificador uma descrição, gravadora, preço de compra, data OK
-- de compra, data de gravação e o tipo de compra.                            OK
-- b. A data de gravação deve ser obrigatoriamente posterior a 01.01.2000.    OK
-- c. O meio físico do álbum, que pode ser CD, vinil ou download.             NOVA TABELA
-- i. Quando o meio físico for CD ou vinil, o álbum pode ser composto por     ''
-- um ou mais CDs ou vinis.                                                   ''
-- d. O preço de compra                                                       OK
CREATE TABLE album(
	cod SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL, 
	cod_grav SMALLINT NOT NULL,
	pr_compra DEC(5,2) NOT NULL,
	dt_compra DATE NOT NULL,
	dt_gravacao DATE NOT NULL,
	nome VARCHAR(50) NOT NULL,	
	
	CONSTRAINT PK_ALBM PRIMARY KEY (cod),
	CONSTRAINT FK_GRAV_ALBM FOREIGN KEY (cod_grav) REFERENCES gravadora,
	CONSTRAINT CHK_dt_gravacao CHECK (dt_gravacao > '2000-01-01')

) ON BDSpotPer_fg01;

CREATE TABLE gravadora(
	cod SMALLINT NOT NULL,
	endereco VARCHAR(100) NOT NULL,
	pagina VARCHAR(100) NOT NULL,
	nome VARCHAR(20) NOT NULL,
	CONSTRAINT PK_GRAV PRIMARY KEY(cod)

) ON BDSpotPer_fg01;

CREATE TABLE telefone(
	numero VARCHAR(15) NOT NULL,
	cod_grav SMALLINT NOT NULL,
	CONSTRAINT PK_TEL PRIMARY KEY (numero),
	CONSTRAINT FK_GRAV_TEL FOREIGN KEY (cod_grav) REFERENCES gravadora

) ON BDSpotPer_fg01;

CREATE TABLE composicao(
	cod SMALLINT NOT NULL,
	nome VARCHAR(20) NOT NULL,
	descr VARCHAR(100) NOT NULL,

	CONSTRAINT PK_COMPOSICAO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa(
	numero SMALLINT NOT NULL,
	cod_album SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL, 
	tempo TIME(0) NOT NULL,
	tipo_composicao SMALLINT NOT NULL,
	tipo_grav VARCHAR(3) NOT NULL

	CONSTRAINT FK_ALBUM_FAIXA FOREIGN KEY (cod_album) REFERENCES album ON DELETE CASCADE,
	CONSTRAINT ADD_OU_DDD CHECK (tipo_grav LIKE 'ADD' or tipo_grav LIKE 'DDD')
	
) ON BDSpotPer_fg02;

CREATE TABLE playlist(
	cod SMALLINT NOT NULL,
	nome VARCHAR(20) NOT NULL,
	dt_criacao DATE NOT NULL,
	dt_ult_reprod DATE NOT NULL,
	num_reprod SMALLINT NOT NULL,
	tempo TIME(0) NOT NULL,

	CONSTRAINT PK_PLAYLIST PRIMARY KEY (cod)

) ON BDSpotPer_fg02;

CREATE TABLE faixa_playlist(
	numero_faixa SMALLINT NOT NULL,
	cod_album SMALLINT NOT NULL,
	cod_playlist SMALLINT NOT NULL,

	CONSTRAINT FK_PLAYLIST_FP FOREIGN KEY (cod_playlist) REFERENCES playlist

) ON BDSpotPer_fg02;

CREATE TABLE interprete(
	cod SMALLINT NOT NULL,	
	nome VARCHAR(20) NOT NULL,
	tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_INTERP PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa_interprete(
	numero_faixa SMALLINT NOT NULL,
	cod_album SMALLINT NOT NULL,
	cod_interp SMALLINT NOT NULL,

	CONSTRAINT FK_INTERP_I FOREIGN KEY (cod_interp) REFERENCES interprete

) ON BDSpotPer_fg01;

CREATE TABLE compositor(
	cod SMALLINT NOT NULL,	
	nome VARCHAR(20) NOT NULL,
	local_nasc VARCHAR(100) NOT NULL,
	dt_nasc DATE NOT NULL, 
	dt_morte DATE,

	CONSTRAINT PK_COMPOSITOR PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE faixa_compositor(
	numero_faixa SMALLINT NOT NULL,
	cod_album SMALLINT NOT NULL,
	cod_composit SMALLINT NOT NULL,

	CONSTRAINT FK_COMPOSIT_C FOREIGN KEY (cod_composit) REFERENCES compositor

) ON BDSpotPer_fg01;

CREATE TABLE periodo_musc(
	cod SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL,
	intervalo VARCHAR(30) NOT NULL, 

	CONSTRAINT PK_PERIODO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

CREATE TABLE compositor_periodo_music(
	cod_composit SMALLINT NOT NULL,
	cod_periodo SMALLINT NOT NULL,

	CONSTRAINT FK_COMPOSIT_CPM FOREIGN KEY (cod_composit) REFERENCES compositor,
	CONSTRAINT FK_PERIODO_CPM FOREIGN KEY (cod_periodo) REFERENCES periodo_musc

) ON BDSpotPer_fg01;