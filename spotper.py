import pyodbc as SQL
import pandas as pd

# Bureaucracy:


# Function to connect to the database

# Crie variáveis para suas credenciais de conexão.
SERVER = 'DESKTOP-R31K86D'
DATABASE = 'BDSpotPer'
USERNAME = 'DESKTOP-R31K86D\Havillon'
PASSWORD = ''

# Crie uma variável de cadeia de conexão usando interpolação de cadeia de caracteres.
conn_str = (
    r'DRIVER={ODBC Driver 11 for SQL Server};'
    r'SERVER=DESKTOP-R31K86D;'
    r'DATABASE=BDSpotPer;'
    r'Trusted_Connection=yes;'
)

def connect_to_database():
    return SQL.connect(conn_str)


# Function to execute SQL queries and return the result as a Pandas DataFrame

def execute_query(connection, query):
    return pd.read_sql(query, connection)


####################################################################################

# Main function of the program

def main_menu(connection):
    while True:

        # print_menu_options -> Just print the options of one menu.
        print_menu_options(["Albuns", "Playlists", "Questão 7"])

        # select_menu_option -> Function to select an option on the menu
        choice = select_menu_option("\n [ ] ", ["Albuns", "Playlists", "Questão 7"])

        if choice == 1:
            albums_menu(connection)
        if choice == 2:
            playlists_menu(connection)
        if choice == 3:
            question_7_menu(connection)    
        elif choice == 0:
            break


####################################################################################

# Main Menus of the system: Albuns, Playlists, Questão7:
# The main menus will have submenus within them


# albums_menu

def albums_menu(connection):
    while True:
        albums = execute_query(connection, "SELECT * FROM album")
        print("\n---------------------------------------------ALBUNS---------------------------------------------")
        print(albums)
        print_menu_options(["Faixas do Album", "Sair"])
        choice = select_menu_option("\n [ ] ", ["Faixas do Album", "Sair"])

        if choice == 1:
            # Função que gerencia as faixas do Album
            album_tracks_menu(connection, albums)

        #elif choice == 0:
            #break


# playlists_menu

def playlists_menu(connection):
    while True:
        playlists = execute_query(connection, "SELECT cod, nome, dt_criacao, dt_ult_reprod, num_reprod FROM playlist")
        print("\n-----------------------PLAYLISTS-------------------------")
        print(playlists)


        print_menu_options(["Faixas da Playlist", "Tocar Playlist", "Editar Playlist",
                             "Criar Playlist", "Apagar Playlist", "Sair"])
        
        choice = select_menu_option("\n [ ] ", ["Faixas da Playlist", "Tocar Playlist", "Editar Playlist", 
                                        "Criar Playlist", "Apagar Playlist", "Sair"])

        if choice == 1:
            # Menu que gerencia as Faixas de uma playlist
            playlist_tracks_menu(connection, playlists)

        elif choice == 2:
            # Função para tocar uma playlist (incrementar num_reprod, alterar dt_ulti_reprod)
            play_playlist(connection, playlists)

        elif choice == 3:
            # Função para editar uma playlist
            edit_playlist(connection, playlists)

        elif choice == 4:
            # Função para criar uma playlist
            create_playlist(connection)

        elif choice == 5:
            # Função para deletar uma playlist
            delete_playlist(connection, playlists)
        #elif choice == 0:
            #break


# qusetion_7_menu

def question_7_menu(connection):
    while True:


        print_menu_options(["Item A", "Item B", "Item C", "Item D", "Sair"])

        choice = select_menu_option("\n [ ] ", ["Item A", "Item B", "Item C", "Item D", "Sair"])

        
        if choice == 1:
            try:
                print("------------ITEM A------------")
                # setea = view
                table = execute_query(connection, "SELECT * FROM setea ORDER BY 2 DESC")
                print(table)

                input("\n Pressione enter para voltar")
            
            except:
                input("\n Operação Inválida, Enter para continuar")
        
        elif choice == 2:
            try:
                print("------------ITEM B------------")

                #s eteb = view
                table = execute_query(connection, "SELECT * FROM seteb")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")

        elif choice == 3:
            try:
                print("------------ITEM C------------")

                # setec = view
                table = execute_query(connection, "SELECT * FROM setec")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")


        elif choice == 4:
            try:
                print("------------ITEM D------------")

                # seted = view
                table = execute_query(connection, "SELECT * FROM seted")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")

                
####################################################################################

# Submenus


# album_tracks_menu

def album_tracks_menu(connection, albums):

    # print_table_and_return_selected_row -> auxiliar
    selected_row = print_table_and_return_selected_row(albums,"-----------------------------FAIXAS-----------------------------")

    album_code = albums['cod'][selected_row - 1]

    # Tracks será um DataFrame contendo as informações das faixas relacionadas ao álbum especificado
    # pelo código album_code. O DataFrame terá colunas: numero, descr, tempo, composicao, e tipo_grav.
    tracks = execute_query(connection, f"SELECT numero, descr, tempo, nome as composicao, tipo_grav "
                                       f"FROM faixa f, composicao c "
                                       f"WHERE tipo_composicao = cod AND cod_album = {album_code}")
    

    while True:
        print("\n-----------------------------FAIXAS-----------------------------")    
        print(tracks)
        print_menu_options(["Adicionar Faixa a Playlist", "Sair"])

        choice = select_menu_option("\n [ ] ", ["Adicionar Faixa a Playlist", "Sair"])
        
        if choice == 1:
            # Po mermão tem q fazer tbm
            add_track_to_playlist(connection, album_code, tracks)
        #elif choice == 0:
            #break
    

# playlist_tracks_menu

def playlist_tracks_menu(connection, playlists):

    selected_row = print_table_and_return_selected_row(playlists, "Selecione a Linha da Playlist: ")

    playlist_code = playlists['cod'][selected_row - 1]

    # Tracks será um DataFrame contendo as informações das faixas relacionadas ao álbum especificado
    # pelo código album_code. O DataFrame terá colunas: numero, descr, tempo, composicao, e tipo_grav.

    # faixas_playlists = view implementada no .sql
    tracks = execute_query(connection, f"SELECT numero, descr, tempo, composicao, tipo_grav "
                                       f"FROM faixas_playlists WHERE cod_playlist = {playlist_code}")
    
    while True:
        print("\n-----------------------------FAIXAS-----------------------------")
        print(tracks)

        print_menu_options(["Tocar faixa", "Adicionar Faixa", "Apagar Faixa", "Sair"])
        choice = select_menu_option("\n [ ] ", ["Tocar faixa", "Adicionar Faixa", "Apagar Faixa", "Sair"])

        if choice == 1:
            play_track(connection, playlist_code, tracks)
        elif choice == 2:
            add_track_to_playlist(connection, playlist_code, tracks)
        elif choice == 3:
            delete_track_from_playlist(connection, playlist_code, tracks)
        #elif choice == 0:
            #break


####################################################################################

# Actions!


# play playlist

def play_playlist(connection, playlists):

    selected_row = print_table_and_return_selected_row(playlists, "Selecione a Linha da Playlist: ")
    playlist_code = playlists['cod'][selected_row - 1 ]
    num_reprod = playlists['num_reprod'][selected_row - 1]
    num_reprod = int(num_reprod) + 1
    # O cursor é uma espécie de ponteiro que permite executar comandos SQL no banco de dados e recuperar resultados. 
    # O cursor é criado a partir da conexão com o banco de dados (connection).
    cursor = connection.cursor()
    cursor.execute(f"UPDATE playlist SET dt_ult_reprod = GETDATE(), num_reprod = {num_reprod} WHERE cod = {playlist_code}")
    connection.commit()
    cursor.close()


# edit playlist 

def edit_playlist(connection, playlists):

    selected_row = print_table_and_return_selected_row(playlists, "Selecione a Linha da Playlist: ")
    playlist_code = playlists['cod'][selected_row -  1]
    name = input("\n Nome: ")
    # O cursor é uma espécie de ponteiro que permite executar comandos SQL no banco de dados e recuperar resultados. 
    # O cursor é criado a partir da conexão com o banco de dados (connection).
    cursor = connection.cursor()
    cursor.execute(f"UPDATE playlist SET nome = '{name}' WHERE cod = {playlist_code}")
    connection.commit()
    cursor.close()


# create playlist

def create_playlist(connection):

    try:
        code = input("\n Qual o codigo da playlist?: ")
        name = input("\n Qual o nome dela?" )
        cursor = connection.cursor()
        cursor.execute(f"INSERT INTO playlist VALUES ({code}, '{name}', GETDATE(), GETDATE(), 0, '00:00:00')")
        connection.commit()
        cursor.close()
    except: 
        input("\n Operação Inválida, pressione enter para continuar")


# delete playlist

def delete_playlist(connection, playlists):

    selected_row = print_table_and_return_selected_row(playlists, "Selecione a Linha da Playlist: ")
    playlist_code = playlists['cod'][selected_row - 1]
    cursor = connection.cursor()
    cursor.execute(f"DELETE FROM playlist WHERE cod = {playlist_code}")
    connection.commit()
    cursor.close()


# add track to playlist

def add_track_to_playlist(connection, album_code, tracks):

    selected_row = print_table_and_return_selected_row(tracks, "Selecione a Linha da Faixa: ")
    track_number = tracks['numero'][selected_row - 1]
    playlists = execute_query(connection, "SELECT cod, nome, dt_criacao, dt_ult_reprod, num_reprod FROM playlist")
    print("\n-----------------------PLAYLISTS-------------------------")
    print(playlists)
    selected_row = print_table_and_return_selected_row(playlists, "Selecione a Linha da Playlist: ")
    playlist_code = playlists['cod'][selected_row - 1]
    cursor = connection.cursor()
    cursor.execute(f"INSERT INTO faixa_playlist VALUES ({track_number},{album_code},{playlist_code})")
    cursor.commit()
    cursor.close()


# delete track from playlist

def delete_track_from_playlist(connection, playlist_code, tracks):
    selected_row = print_table_and_return_selected_row(tracks, "Selecione a Linha da Faixa: ")
    track_number = tracks['numero'][selected_row - 1]
    album_code = tracks['cod_album'][selected_row - 1]
    cursor = connection.cursor()
    cursor.execute(f"DELETE FROM faixa_playlist WHERE numero_faixa = {track_number} "
                   f"AND cod_album = {album_code} AND cod_playlist = {playlist_code}")
    cursor.commit()
    cursor.close()


# play track

def play_track(connection, playlist_code, tracks):
    selected_row = print_table_and_return_selected_row(tracks, "Selecione a Linha da Faixa: ")
    track_number = tracks['numero'][selected_row - 1]
    num_reprod = tracks['num_reprod'][selected_row - 1]
    num_reprod = int(num_reprod) + 1 
    cursor = connection.cursor()
    cursor.execute(f"UPDATE playlist SET dt_ult_reprod = GETDATE(), num_reprod = {num_reprod} WHERE cod = {playlist_code}")
    connection.commit()
    cursor.close()


####################################################################################

# Auxiliar


# print_menu_options

def print_menu_options(options):

    print("\n ---------------MENU---------------")
    for i, option in enumerate(options, start=1):
        print(f" [{i}] {option}")
    print("[0] Sair")
    

# select_menu_option

def select_menu_option(prompt, options):

    while True:
        try:
            choice = int(input(prompt))
            if 0 <= choice <= len(options):
                return choice
            else:
                print("Opção inválida. Tente novamente.")
        except ValueError:
            print("Entrada inválida. Digite um número.")


# print_table_and_return_selected_row

def print_table_and_return_selected_row(table, header):

    print(header)
    print(table)

    while True:
        try:
            selected_row = int(input("\n Selecione a linha: "))
            if 1 <= selected_row <= len(table):
                return selected_row
            else:
                print("Linha inválida. Tente Novamente.")
        except ValueError:
            print("Entrada inválida. Digite um número.")


####################################################################################




# A ideia é separar a lógica de execução principal do código de funcionalidades que podem ser reutilizadas em outros scripts. 
# Ao colocar o código dentro do bloco if __name__ == "__main__":, você garante que a lógica principal 
# (como a conexão ao banco de dados e a execução do menu principal) seja executada apenas quando o script for iniciado diretamente.

if __name__ == "__main__":
    connection = connect_to_database()
    main_menu(connection)
    connection.close()