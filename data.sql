INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (1, 'Rua A, 123', 'www.gravadora1.com.br', 'Gravadora 1');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (2, 'Rua B, 456', 'www.gravadora2.com.br', 'Gravadora 2');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (3, 'Rua C, 789', 'www.gravadora3.com.br', 'Gravadora 3');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (4, 'Rua D, 123', 'www.gravadora4.com.br', 'Gravadora 4');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (5, 'Rua E, 456', 'www.gravadora5.com.br', 'Gravadora 5');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (6, 'Rua C, 789', 'www.gravadora3.com.br', 'Gravadora 3');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (7, 'Rua D, 123', 'www.gravadora4.com.br', 'Gravadora 4');
INSERT INTO gravadora (cod, endereco, pagina, nome) VALUES (8, 'Rua E, 456', 'www.gravadora5.com.br', 'Gravadora 5');

INSERT INTO album (cod, cod_grav, nome, descr, tipo_compra, pr_compra, dt_compra, dt_gravacao) VALUES (1, 1, 'Album 1', 'Descrição do Album 1', 'fisica', 10.00, '2023-12-01', '2023-11-01');
INSERT INTO album (cod, cod_grav, nome, descr, tipo_compra, pr_compra, dt_compra, dt_gravacao) VALUES (2, 2, 'Album 2', 'Descrição do Album 2', 'download', 5.00, '2023-12-02', '2023-11-02');
INSERT INTO album (cod, cod_grav, nome, descr, tipo_compra, pr_compra, dt_compra, dt_gravacao) VALUES (3, 3, 'Album 3', 'Descrição do Album 3', 'fisica', 15.00, '2023-12-03', '2023-11-03');
INSERT INTO album (cod, cod_grav, nome, descr, tipo_compra, pr_compra, dt_compra, dt_gravacao) VALUES (4, 1, 'Album 4', 'Descrição do Album 4', 'fisica', 20.00, '2023-12-04', '2023-11-04');
INSERT INTO album (cod, cod_grav, nome, descr, tipo_compra, pr_compra, dt_compra, dt_gravacao) VALUES (5, 2, 'Album 5', 'Descrição do Album 5', 'download', 7.00, '2023-12-05', '2023-11-05');

INSERT INTO telefone (numero, cod_grav) VALUES ('(11) 1234-5678', 1);
INSERT INTO telefone (numero, cod_grav) VALUES ('(11) 2345-6789', 2);
INSERT INTO telefone (numero, cod_grav) VALUES ('(11) 3456-7890', 3);
INSERT INTO telefone (numero, cod_grav) VALUES ('(11) 4567-8901', 4);
INSERT INTO telefone (numero, cod_grav) VALUES ('(11) 5678-9012', 5);

INSERT INTO composicao (cod, nome, descr) VALUES (1, 'Composição 1', 'Descrição da Composição 1');
INSERT INTO composicao (cod, nome, descr) VALUES (2, 'Composição 2', 'Descrição da Composição 2');
INSERT INTO composicao (cod, nome, descr) VALUES (3, 'Composição 3', 'Descrição da Composição 3');
INSERT INTO composicao (cod, nome, descr) VALUES (4, 'Composição 4', 'Descrição da Composição 4');
INSERT INTO composicao (cod, nome, descr) VALUES (5, 'Composição 5', 'Descrição da Composição 5');

INSERT INTO faixa (numero, cod_album, descr, tempo, tipo_composicao, tipo_grav) VALUES (1, 1, 'Descrição da Faixa 1', '00:03:30', 1, 'ADD');
INSERT INTO faixa (numero, cod_album, descr, tempo, tipo_composicao, tipo_grav) VALUES (2, 1, 'Descrição da Faixa 2', '00:04:00', 2, 'DDD');
INSERT INTO faixa (numero, cod_album, descr, tempo, tipo_composicao, tipo_grav) VALUES (3, 2, 'Descrição da Faixa 3', '00:03:45', 3, 'ADD');
INSERT INTO faixa (numero, cod_album, descr, tempo, tipo_composicao, tipo_grav) VALUES (4, 2, 'Descrição da Faixa 4', '00:03:30', 4, 'ADD');
INSERT INTO faixa (numero, cod_album, descr, tempo, tipo_composicao, tipo_grav) VALUES (5, 2, 'Descrição da Faixa 5', '00:04:00', 5, 'DDD');


INSERT INTO playlist (cod, nome, dt_criacao, dt_ult_reprod, num_reprod, tempo) VALUES (1, 'Playlist 1', '2023-12-01', '2023-12-02', 10, '00:20:00');
INSERT INTO playlist (cod, nome, dt_criacao, dt_ult_reprod, num_reprod, tempo) VALUES (2, 'Playlist 2', '2023-12-02', '2023-12-03', 15, '00:30:00');
INSERT INTO playlist (cod, nome, dt_criacao, dt_ult_reprod, num_reprod, tempo) VALUES (3, 'Playlist 3', '2023-12-03', '2023-12-04', 20, '00:40:00');
INSERT INTO playlist (cod, nome, dt_criacao, dt_ult_reprod, num_reprod, tempo) VALUES (4, 'Playlist 4', '2023-12-04', '2023-12-05', 25, '01:00:00');
INSERT INTO playlist (cod, nome, dt_criacao, dt_ult_reprod, num_reprod, tempo) VALUES (5, 'Playlist 5', '2023-12-05', '2023-12-06', 30, '01:30:00');

INSERT INTO faixa_playlist (numero_faixa, cod_album, cod_playlist) VALUES (1, 1, 1);
INSERT INTO faixa_playlist (numero_faixa, cod_album, cod_playlist) VALUES (2, 1, 2);
INSERT INTO faixa_playlist (numero_faixa, cod_album, cod_playlist) VALUES (3, 2, 3);
INSERT INTO faixa_playlist (numero_faixa, cod_album, cod_playlist) VALUES (4, 2, 4);
INSERT INTO faixa_playlist (numero_faixa, cod_album, cod_playlist) VALUES (5, 2, 5);

INSERT INTO interprete (cod, nome, tipo) VALUES (1, 'Interprete 1', 'Tipo 1');
INSERT INTO interprete (cod, nome, tipo) VALUES (2, 'Interprete 2', 'Tipo 2');
INSERT INTO interprete (cod, nome, tipo) VALUES (3, 'Interprete 3', 'Tipo 3');
INSERT INTO interprete (cod, nome, tipo) VALUES (4, 'Interprete 4', 'Tipo 4');
INSERT INTO interprete (cod, nome, tipo) VALUES (5, 'Interprete 5', 'Tipo 5');

INSERT INTO faixa_interprete (numero_faixa, cod_album, cod_interp) VALUES (1, 1, 1);
INSERT INTO faixa_interprete (numero_faixa, cod_album, cod_interp) VALUES (2, 1, 2);
INSERT INTO faixa_interprete (numero_faixa, cod_album, cod_interp) VALUES (3, 2, 3);
INSERT INTO faixa_interprete (numero_faixa, cod_album, cod_interp) VALUES (4, 2, 4);
INSERT INTO faixa_interprete (numero_faixa, cod_album, cod_interp) VALUES (5, 2, 5);

INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (1, 'Compositor 1', 'Local de Nascimento 1', '2000-01-01', NULL);
INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (2, 'Compositor 2', 'Local de Nascimento 2', '2000-01-02', '2023-12-01');
INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (3, 'Compositor 3', 'Local de Nascimento 3', '2000-01-03', NULL);
INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (4, 'Compositor 4', 'Local de Nascimento 4', '2000-01-04', NULL);
INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (5, 'Compositor 5', 'Local de Nascimento 5', '2000-01-05', '2023-12-02');
INSERT INTO compositor (cod, nome, local_nasc, dt_nasc, dt_morte) VALUES (6, 'Dvorak', 'Local de Nascimento 6', '2000-01-30', NULL);

INSERT INTO faixa_compositor (numero_faixa, cod_album, cod_composit) VALUES (1, 1, 1);
INSERT INTO faixa_compositor (numero_faixa, cod_album, cod_composit) VALUES (2, 1, 2);
INSERT INTO faixa_compositor (numero_faixa, cod_album, cod_composit) VALUES (3, 2, 3);
INSERT INTO faixa_compositor (numero_faixa, cod_album, cod_composit) VALUES (4, 2, 4);
INSERT INTO faixa_compositor (numero_faixa, cod_album, cod_composit) VALUES (5, 2, 5);

INSERT INTO periodo_musc (cod, descr, intervalo) VALUES (1, 'Período Musical 1', 'Intervalo 1');
INSERT INTO periodo_musc (cod, descr, intervalo) VALUES (2, 'Período Musical 2', 'Intervalo 2');
INSERT INTO periodo_musc (cod, descr, intervalo) VALUES (3, 'Período Musical 3', 'Intervalo 3');
INSERT INTO periodo_musc (cod, descr, intervalo) VALUES (4, 'Período Musical 4', 'Intervalo 4');
INSERT INTO periodo_musc (cod, descr, intervalo) VALUES (5, 'Período Musical 5', 'Intervalo 5');

INSERT INTO compositor_periodo_music (cod_composit, cod_periodo) VALUES (1, 1);
INSERT INTO compositor_periodo_music (cod_composit, cod_periodo) VALUES (2, 2);
INSERT INTO compositor_periodo_music (cod_composit, cod_periodo) VALUES (3, 3);
INSERT INTO compositor_periodo_music (cod_composit, cod_periodo) VALUES (4, 4);
INSERT INTO compositor_periodo_music (cod_composit, cod_periodo) VALUES (5, 5);
