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
		FILENAME = 'C:\FBD_FINAL\BDSpotPer.mdf',   
		SIZE = 5120KB,                              
		FILEGROWTH = 1024KB                         
	),
	-- Definição do segundo filegroup (BDSpotPer_fg01)
	FILEGROUP BDSpotPer_fg01
	(
		NAME = 'BDSpotPer_001',                     
		FILENAME = 'C:\FBD_FINAL\BDSpotPer_001.ndf',
		SIZE = 1024KB,                              
		FILEGROWTH = 30%                            
	),

	(
		NAME = 'BDSpotPer_002',                     
		FILENAME = 'C:\FBD_FINAL\BDSpotPer_002.ndf',
		SIZE = 1024KB,                              
		MAXSIZE = 3072KB,                           
		FILEGROWTH = 15%                            
	),
	-- Definição do terceiro filegroup (BDSpotPer_fg02)
	FILEGROUP BDSpotPer_fg02
	(
		NAME = 'BDSpotPer_003',                    
		FILENAME = 'C:\FBD_FINAL\BDSpotPer_003.ndf',
		SIZE = 2048KB,                              
		MAXSIZE = 5120KB,                          
		FILEGROWTH = 30%                            
	)
	-- Definição do log
	LOG ON 
	(
		NAME = 'BDSpotPer_log',                     
		FILENAME = 'C:\FBD_FINAL\BDSpotPer_log.ldf',
		SIZE = 1024KB,                              
		FILEGROWTH = 10%                            
	);

-- Alterando para o banco de dados BDSpotPer_FINAL
USE BDSpotPer;


create table gravadora(
	cod smallint not null,
	endereco varchar(100) not null,
	pagina varchar(100) not null,
	nome varchar(20) not null,
	constraint PK_GRAV primary key (cod)

) on BDSpotPer_fg01;

create table album(
	cod smallint not null,
	cod_grav smallint not null,
	nome varchar(50) not null,
	descr varchar(100) not null, 
	tipo_compra varchar(20) not null,
	pr_compra dec(5,2) not null,
	dt_compra date not null,
	dt_gravacao date not null,
	
	constraint PK_ALBM primary key (cod),
	constraint FK_GRAV_ALBM foreign key (cod_grav) references gravadora,
	constraint TIPO_DA_COMPRA check (tipo_compra like 'fisica' or tipo_compra like 'download'),
	constraint DATA_COMPRA_CERTA check (dt_compra > '01/01/2000')

) on BDSpotPer_fg01;

create table telefone(
	numero varchar(13) not null,
	cod_grav smallint not null,
	constraint PK_TEL primary key (numero),
	constraint FK_GRAV_TEL foreign key (cod_grav) references gravadora

) on BDSpotPer_fg01;

create table composicao(
	cod smallint not null,
	nome varchar(20) not null,
	descr varchar(100) not null, -- Sinfonia, ópera, sonata, concerto

	constraint PK_COMPOSICAO primary key (cod)

) on BDSpotPer_fg01;

create table faixa(
	numero smallint not null,
	cod_album smallint not null,
	descr varchar(100) not null, 
	tempo time(0) not null,
	tipo_composicao smallint not null,
	tipo_grav varchar(3) not null

	constraint FK_ALBUM_FAIXA foreign key (cod_album) references album on delete cascade,
	constraint ADD_OU_DDD check (tipo_grav like 'ADD' or tipo_grav like 'DDD')
	
) on BDSpotPer_fg02;

create table playlist(
	cod smallint not null,
	nome varchar(20) not null,
	dt_criacao date not null,
	dt_ult_reprod date not null,
	num_reprod smallint not null,
	tempo time(0) not null,

	constraint PK_PLAYLIST primary key (cod)

) on BDSpotPer_fg02;

create table faixa_playlist(
	numero_faixa smallint not null,
	cod_album smallint not null,
	cod_playlist smallint not null,

	constraint FK_PLAYLIST_FP foreign key (cod_playlist) references playlist

) on BDSpotPer_fg02;

create table interprete(
	cod smallint not null,	
	nome varchar(20) not null,
	tipo varchar(20) not null, --  orquestra, trio, quarteto, ensemble, soprano, tenor..

	constraint PK_INTERP primary key (cod)

) on BDSpotPer_fg01;

create table faixa_interprete(
	numero_faixa smallint not null,
	cod_album smallint not null,
	cod_interp smallint not null,

	constraint FK_INTERP_I foreign key (cod_interp) references interprete

) on BDSpotPer_fg01;

create table compositor(
	cod smallint not null,	
	nome varchar(20) not null,
	local_nasc varchar(100) not null,
	dt_nasc date not null, 
	dt_morte date,

	constraint PK_COMPOSITOR primary key (cod)

) on BDSpotPer_fg01;

create table faixa_compositor(
	numero_faixa smallint not null,
	cod_album smallint not null,
	cod_composit smallint not null,

	constraint FK_COMPOSIT_C foreign key (cod_composit) references compositor

) on BDSpotPer_fg01;

create table periodo_musc(
	cod smallint not null,
	descr varchar(100) not null, --barroco, clássico, romântico, etc..
	intervalo varchar(30) not null, 

	constraint PK_PERIODO primary key (cod)

) on BDSpotPer_fg01;

create table compositor_periodo_music(
	cod_composit smallint not null,
	cod_periodo smallint not null,

	constraint FK_COMPOSIT_CPM foreign key (cod_composit) references compositor,
	constraint FK_PERIODO_CPM foreign key (cod_periodo) references periodo_musc

) on BDSpotPer_fg01;




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






