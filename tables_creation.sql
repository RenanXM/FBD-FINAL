USE BDSpotPer;

-- Para cada gravadora, estão associados um código, nome, endereço, telefones        OK
-- e endereço da home page.                                                          OK
 
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
	tipo_compra VARCHAR(20) NOT NULL,
	nome VARCHAR(50) NOT NULL,	
	
	CONSTRAINT PK_ALBM PRIMARY KEY (cod),
	CONSTRAINT FK_GRAV_ALBM FOREIGN KEY (cod_grav) REFERENCES gravadora,
	CONSTRAINT CHK_dt_gravacao CHECK (dt_gravacao > '2000-01-01')

) ON BDSpotPer_fg01;


-- MEIO FISICO
-- Cada CD, vinil ou download possui ainda um conjunto de faixas (músicas)

CREATE TABLE meio_fisico (
	cod SMALLINT NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	cod_album SMALLINT NOT NULL,

	CONSTRAINT PK_MEIO_FISICO PRIMARY KEY(cod),
	CONSTRAINT FK_COD_ALBUM_MF FOREIGN KEY (cod_album) REFERENCES album
)  ON BDSpotPer_fg01;

-- Para cada tipo de composição, devem estar associados um código                        OK
-- identificador e a descrição. O tipo deve caracterizar se a obra gravada é uma         OK
-- sinfonia, ópera, sonata, concerto e assim por diante. É obrigatório identificar o     OK
-- tipo de composição para cada faixa existente. Uma faixa só pode apresentar            OK CONSTRAINT EM FAIXA
-- um tipo de composição. 	

CREATE TABLE composicao(
	cod SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL,
	tipo_comp VARCHAR(50) NOT NULL,
	CONSTRAINT PK_COMPOSICAO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

-- Cada faixa de um álbum possui obrigatoriamente como propriedades 
-- a. o número da faixa (posição da faixa no álbum), uma descrição, tipo de       OK
-- composição, intérprete(s), compositor(es), tempo de execução e tipo de         OK
-- gravação.                                                                      OK TABELA MEIO_FISICO_FAIXA
-- b. Quando o meio físico de armazenamento é CD, o tipo de gravação tem que      OK TABELA MEIO_FISICO_FAIXA
-- ser ADD ou DDD. Quando o meio físico de armazenamento é vinil ou               ''
-- download, o tipo de gravação não terá valor algum.                             ''
-- c. Uma faixa pode estar associada a vários compositores e intérpretes.         TABELA COMPOSITORES E INTERPRETES

CREATE TABLE faixa(
	cod SMALLINT NOT NULL,
	numero SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL,
	tempo_execucao TIME(0) NOT NULL,
	cod_album SMALLINT NOT NULL,
	cod_tipo_composicao SMALLINT NOT NULL,
	tipo_gravacao VARCHAR(50) NOT NULL,
	
	CONSTRAINT PK_COD_FAIXA PRIMARY KEY (cod),
	CONSTRAINT FK_ALBUM_FAIXA FOREIGN KEY (cod_album) REFERENCES album ON DELETE CASCADE,
	CONSTRAINT FK_TIPO_COMPOSICAO FOREIGN KEY (cod_tipo_composicao) REFERENCES composicao
		
) ON BDSpotPer_fg02;

-- TABELA QUE INTERLIGA O MEIO FISICO COM A FAIXA, E GUARDA O NÚMERO DA FAIXA NO ÁLBUM
-- UMA FAIXA PODE ESTAR EM N MEIOS FÍSICOS, E UM MEIO FÍSICO PODE CONTER N FAIXAS

CREATE TABLE meio_fisico_faixa (
	cod SMALLINT NOT NULL,
	cod_meio_fisico SMALLINT NOT NULL,
	cod_faixa SMALLINT NOT NULL,
	numero_faixa SMALLINT NOT NULL,
	tipo_gravacao VARCHAR(50) NOT NULL,

	CONSTRAINT PK_MEIO_FISICO_FAIXA PRIMARY KEY (cod),
	CONSTRAINT FK_COD_MEIO_FISICO_MFA FOREIGN KEY (cod_meio_fisico) REFERENCES meio_fisico,
	CONSTRAINT FK_COD_FAIXA_MFA FOREIGN KEY (cod_faixa) REFERENCES faixa,
	CONSTRAINT ADD_OU_DDD CHECK (tipo_gravacao LIKE 'ADD' or tipo_gravacao LIKE 'DDD')
)  ON BDSpotPer_fg01;


-- COMPOSITORES E INTERPRETES
 
-- PRECISA DE PERIODO MUSICAL

-- Cada período musical possuirá um código, uma descrição e intervalo de tempo em que esteve ativo       OK

CREATE TABLE periodo_musc(
	cod SMALLINT NOT NULL,
	descr VARCHAR(100) NOT NULL,    -- idade média, renascença, barroco, clássico, romântico e moderno
	inicio_periodo DATE NOT NULL,
	fim_periodo DATE,

	CONSTRAINT PK_PERIODO PRIMARY KEY (cod)

) ON BDSpotPer_fg01;

-- Um compositor deve possuir, como propriedades, nome, local de nascimento         OK
-- (cidade e país), data de nascimento e data de morte (se for o caso). Cada        OK
-- compositor possui um identificador. Podem existir compositores no banco de       OK
-- dados, sem estarem associados a faixas. Cada compositor deve estar               OK
-- obrigatoriamente associado a um período musical                                  PERIODO MUSICAL ACIMA OK

CREATE TABLE compositor(
	cod SMALLINT NOT NULL,	
	nome VARCHAR(20) NOT NULL,
	cidade_nasc VARCHAR(100) NOT NULL,
	pais_nasc VARCHAR(100) NOT NULL,
	dt_nasc DATE NOT NULL, 
	dt_morte DATE,
	cod_periodo_musc SMALLINT NOT NULL,

	CONSTRAINT PK_COMPOSITOR PRIMARY KEY (cod),
	CONSTRAINT FK_PERIODO_MUSC FOREIGN KEY (cod_periodo_musc) REFERENCES periodo_musc

) ON BDSpotPer_fg01;

-- Cada intérprete possui um código identificador, nome, tipo. Tipo de intérprete    OK

CREATE TABLE interprete(
	cod SMALLINT NOT NULL,	
	nome VARCHAR(20) NOT NULL,
	tipo VARCHAR(20) NOT NULL,  

	CONSTRAINT PK_INTERP PRIMARY KEY (cod)   -- pode ser orquestra, trio, quarteto, ensemble, soprano, tenor, etc..

) ON BDSpotPer_fg01;

-- TABELA DE RELACIONAMENTO ENTRE INTERPRETE E FAIXA

CREATE TABLE faixa_interprete(
	cod SMALLINT NOT NULL,
	cod_faixa SMALLINT NOT NULL,
	cod_interp SMALLINT NOT NULL,

	CONSTRAINT PK_FAIXA_INTERPRETE PRIMARY KEY (cod),
	CONSTRAINT FK_FAIXA_FI FOREIGN KEY (cod_faixa) REFERENCES faixa,
	CONSTRAINT FK_INTERP_FI FOREIGN KEY (cod_interp) REFERENCES interprete

) ON BDSpotPer_fg01;

-- TABELA DE RELACIONAMENTO ENTRE COMPOSITOR E FAIXA

CREATE TABLE faixa_compositor(
	cod SMALLINT NOT NULL,
	cod_faixa SMALLINT NOT NULL,
	cod_comp SMALLINT NOT NULL,

	CONSTRAINT PK_FAIXA_COMPOSITOR PRIMARY KEY (cod),
	CONSTRAINT FK_FAIXA_FC FOREIGN KEY (cod_faixa) REFERENCES faixa,
	CONSTRAINT FK_COMP_FC FOREIGN KEY (cod_comp) REFERENCES compositor 

) ON BDSpotPer_fg01;



-- O usuário do SpotPer pode definir Playlists. Uma playlist pode ser composta 
-- por uma ou mais faixas, que, por sua vez, podem pertencer a álbuns distintos. 
-- Uma playlist terá como propriedades:
-- a. Código identificador, nome, data de criação, tempo total de execução                     OK
-- b. Para cada faixa de uma playlist, tem-se a data da última vez que foi tocada              OK
-- e o número de vezes que foi tocada.                                                         OK

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
	cod SMALLINT NOT NULL,
	cod_faixa SMALLINT NOT NULL,
	cod_playlist SMALLINT NOT NULL,

	CONSTRAINT PK_FAIXA_PLAYLIST PRIMARY KEY (cod),
	CONSTRAINT FK_FAIXA_FP FOREIGN KEY (cod_faixa) REFERENCES faixa,
	CONSTRAINT FK_PLAYLIST_FP FOREIGN KEY (cod_playlist) REFERENCES playlist

) ON BDSpotPer_fg02;
