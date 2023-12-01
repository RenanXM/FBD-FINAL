import pyodbc as SQL
import pandas as pd
import os


# Bureaucracy:


# Function to connect to the database

def connect_to_database():
    # AVION ADAPTAR...
    # Faz o L
    return SQL.connect(
        "Driver={SQL Server Native Client 11.0};"
        "Server = ;"
        "Database=BDSpotPer_FINAL;"
        "Trusted_Connection=yes;"
    )


# Function to execute SQL queries and return the result as a Pandas DataFrame

def execute_query(connection, query):
    return pd.read_sql(query, connection)

####################################################################################

# Main function of the program

def main_menu(connection):
    while True:
        os.system("cls")

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
        os.sytem("cls")
        albums = execute_query(connection, "SELECT * FROM album")
        print("\n---------------------------------------------ALBUNS---------------------------------------------")
        print(albums)
        print_menu_options(["Faixas do Album", "Sair"])
        choice = select_menu_option("\n [ ] ", ["Faixas do Album", "Sair"])

        if choice == 1:
            # Função que gerencia as faixas do Album
            album_tracks_menu(connection, albums)

        elif choice == 0:
            break


# playlists_menu

def playlists_menu(connection):
    while True:
        os.system("cls")
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
        elif choice == 0:
            break


# qusetion_7_menu

def question_7_menu(connection):
    while True:
        os.system("cls")


        print_menu_options(["Item A", "Item B", "Item C", "Item D", "Sair"])

        choice = select_menu_option("\n [ ] ", ["Item A", "Item B", "Item C", "Item D", "Sair"])

        
        if choice == 1:
            try:
                os.system("cls")
                print("------------ITEM A------------")
                # IMPORTANTE !!!!!!!!!!!!!!!!!!! (SERÁ QUE NÃO PODE SER UMA VIEW??)
                table = execute_query(connection, "SELECT ?????????????")
                print(table)

                input("\n Pressione enter para voltar")
            
            except:
                input("\n Operação Inválida, Enter para continuar")
        
        elif choice == 2:
            try:
                os.system("cls")
                print("------------ITEM B------------")

                # IMPORTANTE !!!!!!!!!!!!!!!!!!! (SERÁ QUE NÃO PODE SER UMA VIEW??)
                table = execute_query(connection, "SELECT ??????????")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")

        elif choice == 3:
            try:
                os.system("cls")
                print("------------ITEM C------------")

                # IMPORTANTE !!!!!!!!!!!!!!!!!!! (SERÁ QUE NÃO PODE SER UMA VIEW??)
                table = execute_query(connection, "SELECT ??????????")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")


        elif choice == 4:
            try:
                os.sytem("cls")
                print("------------ITEM D------------")

                # IMPORTANTE !!!!!!!!!!!!!!!!!!! (SERÁ QUE NÃO PODE SER UMA VIEW??)
                table = execute_query(connection, "SELECT ?????????????")
                print(table)

                input("\n Pressione enter para voltar")

            except:
                input("\n Operação Inválida, pressione enter para continuar")

                
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
    os.system("cls")
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
        os.system("cls")
        print("\n-----------------------------FAIXAS-----------------------------")    
        print(tracks)
        print_menu_options(["Adicionar Faixa a Playlist", "Sair"])

        choice = select_menu_option("\n [ ] ", ["Adicionar Faixa a Playlist", "Sair"])
        
        if choice == 1:
            # Po mermão tem q fazer tbm
            add_track_to_playlist(connection, album_code, tracks)
        elif choice == 0:
            break
    




####################################################################################
