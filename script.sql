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
	CONSTRAINT FK_GRAVADORA_A FOREIGN KEY (fk_codigo_gravadora) REFERENCES Gravadora,
	CONSTRAINT TIPO_COMPRA CHECK (tipo_compra LIKE 'fisica' OR tipo_compra LIKE 'download'),
	CONSTRAINT DATA_COMPRA CHECK (dt_compra > '01/01/2000')

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
	descricao VARCHAR (100) NOT NULL, -- Sinfonia, ópera, sonata, concerto

	CONSTRAINT PK_COMPOSICAO PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Faixa(
	codigo_faixa INTEGER  NOT NULL,
	numero INTEGER  NOT NULL,
	codigo_album INTEGER  NOT NULL,
	descricao VARCHAR (100) NOT NULL, 
	tempo time(0) NOT NULL,
	tipo_composicao INTEGER  NOT NULL,
	tipo_gravacao VARCHAR (3) NOT NULL

	CONSTRAINT PK_FAIXA PRIMARY KEY (codigo_faixa)
	CONSTRAINT FK_ALBUM_F FOREIGN KEY (codigo_album) REFERENCES Album ON DELETE CASCADE
	CONSTRAINT ADD_OU_DDD CHECK (tipo_gravacao LIKE 'ADD' OR tipo_gravacao LIKE 'DDD')
	
) ON BDSpotPer_fg02;

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

	CONSTRAINT FK_PLAYLIST_FP FOREIGN KEY (fk_codigo_playlist) REFERENCES Playlist
	CONSTRAINT FK_FAIXA_FP FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg02;

CREATE TABLE Interprete(
	codigo INTEGER  NOT NULL,	
	nome VARCHAR (20) NOT NULL,
	tipo VARCHAR (20) NOT NULL, --  orquestra, trio, quarteto, ensemble, soprano, tenor..

	CONSTRAINT PK_INTERPRETE PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Faixa_Interprete(
	numero_faixa INTEGER NOT NULL,
	codigo_album INTEGER NOT NULL,
	fk_codigo_interprete INTEGER NOT NULL,
	fk_codigo_faixa INTEGER NOT NULL,

	CONSTRAINT FK_INTERPRETE_FI FOREIGN KEY (fk_codigo_interprete) REFERENCES Interprete
	CONSTRAINT FK_FAIXA_FI FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg01;

CREATE TABLE Compositor(
	codigo INTEGER  NOT NULL,	
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

	CONSTRAINT FK_COMPOSITOR_FC FOREIGN KEY (fk_codigo_compositor) REFERENCES Compositor
	CONSTRAINT FK_FAIXA_FC FOREIGN KEY (fk_codigo_faixa) REFERENCES Faixa

) ON BDSpotPer_fg01;

CREATE TABLE Periodo_Musical(
	codigo INTEGER NOT NULL,
	descricao VARCHAR (100) NOT NULL, --barroco, clássico, romântico, etc..
	intervalo VARCHAR (30) NOT NULL, 

	CONSTRAINT PK_PERIODO_MUSICAL PRIMARY KEY (codigo)

) ON BDSpotPer_fg01;

CREATE TABLE Compositor_Periodo_Musical(
	codigo_compositor INTEGER NOT NULL,
	codigo_periodo INTEGER NOT NULL,

	CONSTRAINT FK_COMPOSITOR_CPM FOREIGN KEY (codigo_compositor) REFERENCES Compositor,
	CONSTRAINT FK_PERIODO_CPM FOREIGN KEY (codigo_periodo) REFERENCES Periodo_Musical

) ON BDSpotPer_fg01;


-------------------------------------------------------------------------------------------------------------------------







-- PRIMEIRA RESTRIÇÃO 3a):
--  Um álbum, com faixas de músicas do período barroco, só pode ser inserido no
--  banco de dados, caso o tipo de gravação seja DDD.


-- Criação de uma visão para obter códigos de álbuns e números de faixas de músicas do período barroco com tipo de gravação ADD.
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


-- Gatilho para a tabela Faixa_Compositor que verifica se um álbum do período barroco está presente na visão quando há inserção ou atualização.
CREATE TRIGGER BARROCO_COM_DDD_FC ON Faixa_Compositor FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
            SELECT fc.codigo_album
            FROM inserted i
            INNER JOIN Album_Compositor_Barocco_Add ac ON i.codigo_album = ac.codigo_album
        )
    BEGIN
        RAISEERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


-- Gatilho para a tabela Faixa que verifica se houve atualização nas colunas tipo_composicao ou tipo_grav, e se um álbum do período barroco está presente na visão.
CREATE TRIGGER BARROCO_COM_DDD_F ON Faixa FOR INSERT, UPDATE
AS
BEGIN
    IF UPDATE(tipo_composicao) OR UPDATE(tipo_grav)
    BEGIN
        IF EXISTS (
                SELECT f.codigo_album
                FROM inserted i
                INNER JOIN Album_Compositor_Barocco_Add ac ON i.codigo_album = ac.codigo_album
            )
        BEGIN
            RAISEERROR('Um álbum, com faixas de músicas do período barroco, só pode ser adquirido, caso o tipo de gravação seja DDD!', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;



-- SEGUNDA RESTRIÇÃO 3b):
-- Um álbum não pode ter mais que 64 faixas (músicas)

create trigger MAX_FAIXAS on faixa for insert, update
as
begin
	declare @cod_album smallint, @QTDE_FAIXAS int

	select @cod_album=cod_album from inserted

	select @QTDE_FAIXAS=count(*) from faixa where codigo_album=@cod_album group by codigo_album

	if (@QTDE_FAIXAS > 64)
	begin
		raiserror('Numero maximo de faixas execedido!', 16,1)
		rollback transaction
	end
end



-- TERCEIRA RESTRIÇÃO 3c): (RESOLVIDO COM ON DELETE CASCADE)
-- No caso de remoção de um álbum do banco de dados, todas as suas faixas
-- devem ser removidas. Lembre-se que faixas podem apresentar, por sua vez,
-- outros relacionamentos.




-- QUARTA RESTRIÇÃO 3d): (N SEI)
-- O preço de compra de um álbum não dever ser superior a três vezes a média
-- do preço de compra de álbuns, com todas as faixas com tipo de gravação
-- DDD.




-- 4) Defina um índice primário para a tabela de Faixas sobre o atributo código do álbum. 
-- Defina um índice secundário para a mesma tabela sobre o atributo tipo de composição. Os dois com taxas de preenchimento máxima.
CREATE CLUSTERED INDEX idx_cod_album
ON faixa (cod_album) FILLFACTOR=100

CREATE UNCLUSTERED INDEX idx_tipo_composicao
ON faixa (tipo_composicao) FILLFACTOR=100




-- 5) Criar uma visão materializada que tem como atributos o nome da playlist e a quantidade de álbuns que a compõem.
CREATE VIEW view_playlists WITH SCHEMABINDING
AS
	SELECT p.nome AS "Nome da Playlist", count(fp.numero_faixa) AS "Quantidade de Faixas" 
	FROM playlist p 
	JOIN faixa_playlist fp ON p.cod = fp.cod_playlist
	GROUP BY p.nome




-- 6) Defina uma função que tem como parâmetro de entrada o nome (ou parte do) 
-- nome do compositor e o parâmetro de saída todos os álbuns com obras 
-- compostas pelo compositor.

CREATE FUNCTION album_compositor (@nome VARCHAR)
RETURNS @tabela_obras TABLE (albuns_compositor NVARCHAR(30))
AS
BEGIN
    INSERT INTO @tabela_obras
    SELECT DISTINCT a.nome
    FROM Compositor c
    INNER JOIN Faixa_Compositor fc ON c.codigo = fc.fk_codigo_compositor
    INNER JOIN Faixa f ON fc.fk_codigo_faixa = f.codigo_faixa
    INNER JOIN Album a ON f.codigo_album = a.codigo
    WHERE c.nome LIKE ('%' + @nome + '%')

    RETURN
END;


------------------------------------------------------------------------------------------------
-- VIEWS USADAS PARA O .py -> MAIORIA DA QUESTÃO 7

-- 7a) Listar os álbum com preço de compra maior que a média de preços de compra de todos os álbuns.
 
create view setea as
select a.nome, a.pr_compra from album a where a.pr_compra >= all (select avg(pr_compra) from album)




-- 7b) Listar nome da gravadora com maior número de playlists que possuem pelo uma faixa composta pelo compositor Dvorack.

-- View para obter as faixas compostas pelo compositor Dvorak
create view faixas_de_dvorak
as
select f.numero_faixa, f.codigo_album
from compositor c
    left outer join faixa_compositor fc on c.nome = 'Dvorak' and c.codigo = fc.codigo_compositor
    inner join faixa f on f.numero_faixa = fc.numero_faixa and f.codigo_album = fc.codigo_album;

-- View para contar o número de playlists associadas a faixas compostas por Dvorak para cada gravadora e álbum
create view qtd_playlist_faixas_dvorak
as
select a.codigo_gravadora, g.nome as nome_gravadora, a.nome as nome_album, f.codigo_album, f.numero_faixa, count(fp.codigo_playlist) as qtd_playlists
from faixas_de_dvorak f
    left outer join faixa_playlist fp on f.numero_faixa = fp.numero_faixa and f.codigo_album = fp.codigo_album
    inner join album a on f.codigo_album = a.codigo
    inner join gravadora g on a.codigo_gravadora = g.codigo
group by a.codigo_gravadora, g.nome, a.nome, f.codigo_album, f.numero_faixa;

-- View final para listar o nome da gravadora com o maior número de playlists que possuem pelo menos uma faixa composta por Dvorak
create view seteb as
select qpfd.nome_gravadora, sum(qpfd.qtd_playlists) as qtd_de_faixas_em_playlists 
from qtd_playlist_faixas_dvorak qpfd
group by qpfd.codigo_gravadora, qpfd.nome_gravadora
having sum(qpfd.qtd_playlists) >= all (select sum(qpfd_inner.qtd_playlists) from qtd_playlist_faixas_dvorak qpfd_inner group by qpfd_inner.codigo_gravadora);





-- 7c) Listar nome do compositor com maior número de faixas nas playlists existentes.


-- View para obter as faixas associadas aos compositores, incluindo a contagem de playlists para cada faixa
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

-- View final para listar o nome do compositor com o maior número de faixas nas playlists existentes
create view setec as
select top 1 with ties nome, sum_qtd_playlists
from compositor_por_playlist
order by sum_qtd_playlists desc;






-- 7d) Listar playlists, cujas faixas (todas) têm tipo de composição Concerto e período Barroco.

-- View para obter as faixas do tipo "Concerto" e período "Barroco"

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

create function eh_concerto_barroca(@numero smallint, @album smallint)
returns int
as
begin 
	declare @retorno int

	select @retorno=count(*) from faixa_concerto_barroca where @numero=numero and @album=cod_album
	
	return @retorno
end

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

-- Função para verificar se todas as faixas de uma playlist são do tipo "Concerto" e do período "Barroco"
create function eh_concerto_barroca(@numero_faixa smallint, @codigo_album smallint)
returns int
as
begin 
    declare @retorno int

    select @retorno = count(*) 
    from faixa_concerto_barroca 
    where @numero_faixa = numero_faixa and @codigo_album = codigo_album
    
    return @retorno
end

-- View final para listar playlists com todas as faixas do tipo "Concerto" e do período "Barroco"
create view seted
as
select p.codigo, p.nome, p.data_criacao, p.data_ultima_reproducao, p.numero_reproducao
from playlist p
    inner join faixa_playlist fp on p.codigo = fp.codigo_playlist
    inner join faixa f on f.numero_faixa = fp.numero_faixa and f.codigo_album = fp.codigo_album
group by p.codigo, p.nome, p.data_criacao, p.data_ultima_reproducao, p.numero_reproducao
having sum(dbo.eh_concerto_barroca(f.numero_faixa, f.codigo_album)) = count(*);






-- VIEW QUE MOSTRA AS FAIXAS DAS PLAYLISTS
drop view faixas_playlists;
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
