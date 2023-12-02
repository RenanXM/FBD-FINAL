USE BDSpotPer;

CREATE TABLE Album(
	codigo INTEGER NOT NULL,
    descricao VARCHAR (100) NOT NULL, 
	fk_codigo_gravadora INTEGER  NOT NULL,
	nome VARCHAR (50) NOT NULL,
	data_compra DATE NOT NULL,
	data_gravacao DATE NOT NULL,
    tipo_compra VARCHAR (20) NOT NULL,
    fk_codigo_meio_fisico INTEGER NOT NULL,
    preco_compra DEC(5,2) NOT NULL,

	CONSTRAINT PK_ALBUM PRIMARY KEY (codigo),
    CONSTRAINT FK_MEIO_FISICO FOREIGN KEY(fk_codigo_meio_fisico) REFERENCES Meio_Fisico,
    CONSTRAINT DATA_GRAVACAO CHECK (data_gravacao > '2000-01-01'),
	CONSTRAINT FK_GRAVADORA_A FOREIGN KEY (fk_codigo_gravadora) REFERENCES Gravadora,
	CONSTRAINT TIPO_COMPRA CHECK (tipo_compra LIKE '__sica' OR tipo_compra LIKE '_ownload')

) ON BDSpotPer_fg01;

CREATE TABLE Meio_Fisico(
    codigo INTEGER NOT NULL,
    nome VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    descricao VARCHAR(100) NOT NULL,

    CONSTRAINT PK_MEIO_FISICO PRIMARY KEY(codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Faixa(
	codigo_faixa INTEGER  NOT NULL,
	numero INTEGER  NOT NULL,
	fk_codigo_album INTEGER  NOT NULL,
	descricao VARCHAR (100) NOT NULL, 
	tempo time(0) NOT NULL,
	tipo_composicao INTEGER  NOT NULL,
	tipo_gravacao VARCHAR (3) NOT NULL

	CONSTRAINT PK_FAIXA PRIMARY KEY (codigo_faixa)
	CONSTRAINT FK_ALBUM_F FOREIGN KEY (fk_codigo_album) REFERENCES Album ON DELETE CASCADE
	CONSTRAINT ADD_OU_DDD CHECK (tipo_gravacao LIKE 'ADD' OR tipo_gravacao LIKE 'DDD')
	
) ON BDSpotPer_fg02;

CREATE TABLE Meio_Fisico_Faixa(
    codigo INTEGER NOT NULL,
    numero_faixa INTEGER NOT NULL,
    fk_codigo_meio_fisico INTEGER NOT NULL,
    fk_codigo_faixa INTEGER NOT NULL,

    CONSTRAINT PK_MEIO_FISICO_FAIXA PRIMARY KEY(codigo),
    CONSTRAINT FK_MEIO_FISICO_MFA FOREIGN KEY (fk_codigo_meio_fisico) REFERENCES Meio_Fisico,
    CONSTRAINT FK_FAIXA_MFA FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

)ON BDSpotPer_fg01;

CREATE TABLE Gravadora(
	codigo INTEGER  NOT NULL,
	endereco VARCHAR (100) NOT NULL,
	pagina VARCHAR (100) NOT NULL,
	nome VARCHAR (20) NOT NULL,
	CONSTRAINT PK_GRAVADORA PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Telefone(
	numero VARCHAR (13) NOT NULL,
	codigo_gravadora INTEGER  NOT NULL,
	CONSTRAINT PK_TELEFONE PRIMARY KEY (numero),
	CONSTRAINT FK_GRAVADORA_T FOREIGN KEY (codigo_gravadora) REFERENCES Gravadora

) ON BDSpotPer_fg01;

CREATE TABLE Composicao(
	codigo INTEGER  NOT NULL,
	nome VARCHAR (20) NOT NULL,
	descricao VARCHAR (100) NOT NULL, -- Sinfonia, opera, sonata, concerto

	CONSTRAINT PK_COMPOSICAO PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Playlist(
	codigo INTEGER  NOT NULL,
	nome VARCHAR (20) NOT NULL,
	data_criacao DATE NOT NULL,
	data_ultima_reproducao DATE NOT NULL,
	numero_reproducao INTEGER  NOT NULL,
	tempo time(0) NOT NULL,

	CONSTRAINT PK_PLAYLIST PRIMARY KEY (codigo)

) ON BDSpotPer_fg02;

CREATE TABLE Faixa_Playlist(
	numero_faixa INTEGER  NOT NULL,
	codigo_album INTEGER  NOT NULL,
	fk_codigo_playlist INTEGER  NOT NULL,
	fk_codigo_faixa INTEGER  NOT NULL,

	CONSTRAINT FK_PLAYLIST_FP FOREIGN KEY (fk_codigo_playlist) REFERENCES Playlist,
	CONSTRAINT FK_FAIXA_FP FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg02;

CREATE TABLE Interprete(
	codigo INTEGER NOT NULL,	
	nome VARCHAR (20) NOT NULL,
	tipo VARCHAR (20) NOT NULL, --  orquestra, trio, quarteto, ensemble, soprano, tenor..

	CONSTRAINT PK_INTERPRETE PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Faixa_Interprete(
	numero_faixa INTEGER NOT NULL,
	codigo_album INTEGER NOT NULL,
	fk_codigo_interprete INTEGER NOT NULL,
	fk_codigo_faixa INTEGER NOT NULL,

	CONSTRAINT FK_INTERPRETE_FI FOREIGN KEY (fk_codigo_interprete) REFERENCES Interprete,
	CONSTRAINT FK_FAIXA_FI FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg01;

CREATE TABLE Compositor(
	codigo INTEGER NOT NULL,	
	nome VARCHAR (20) NOT NULL,
	local_nascimento VARCHAR (100) NOT NULL,
	data_nascimento DATE NOT NULL, 
	data_morte DATE,

	CONSTRAINT PK_COMPOSITOR PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Faixa_Compositor(
	numero_faixa INTEGER NOT NULL,
	codigo_album INTEGER NOT NULL,
	fk_codigo_compositor INTEGER NOT NULL,
	fk_codigo_faixa INTEGER NOT NULL,

	CONSTRAINT FK_COMPOSITOR_FC FOREIGN KEY (fk_codigo_compositor) REFERENCES Compositor,
	CONSTRAINT FK_FAIXA_FC FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg01;

CREATE TABLE Periodo_Musical(
	codigo INTEGER NOT NULL,
	descricao VARCHAR (100) NOT NULL, --barroco, classico, romantico, etc..
	intervalo VARCHAR (30) NOT NULL, 

	CONSTRAINT PK_PERIODO_MUSICAL PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Compositor_Periodo_Musical(
	codigo_compositor INTEGER NOT NULL,
	codigo_periodo INTEGER NOT NULL,

	CONSTRAINT FK_COMPOSITOR_CPM FOREIGN KEY (codigo_compositor) REFERENCES Compositor,
	CONSTRAINT FK_PERIODO_CPM FOREIGN KEY (codigo_periodo) REFERENCES Periodo_Musical

) ON BDSpotPer_fg01;
