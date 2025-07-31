# IMPORTS NECESSARIOS
from console_utils import ask, show_msg, confirm, pause, cls #funcoes do ficheiro disponibilizado
import mysql.connector #liga ao mysql
from getpass import getpass #nao mostra a password no terminal, lemos ser vantajoso no StackOverflow
import os #executar comandos no sistema operativo


# LIGAR À BASE DE DADOS
# Pede ao utilizador nome e password para ligar a uma base de dados chamada
# BuyPy, a nossa. Se a ligação for bem sucedida, retorna o conn (connection, funcionalidade
# do mysql.connector), caso contrário, retorna o erro

def ligar_bd():
    cls()
    show_msg("LOGIN OPERADOR")
    user = ask("Utilizador: ")
    password = getpass("Palavra-passe: ")

    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=user,
            password=password,
            database="BuyPy"
        )
        show_msg("Ligação com sucesso!")
        pause()
        return conn
    except mysql.connector.Error as err:
        show_msg(f"Erro na ligação: {err}") 
        pause()
        return None


# MENU UTILIZADOR
#Pesquisa cliente pelo ID ou Nome, apresentando os dados pedidos numa tabela
#em conformidade com a demonstrada no enunciado:
#cursor é um objeto que permite executar comandos SQL e ler os seus resultados
#dentro do programa em python

def menu_utilizador(conn):
    cls()
    show_msg("MENU UTILIZADOR")
    cursor = conn.cursor() #cursor vai interagir com a base de dados

    termo = ask("Pesquisar por ID ou nome: ")

    if termo.isdigit():
        #se for numero pesquisa por ID
        cursor.execute("SELECT client_id, fullname, email, zip_code, city, birthdate FROM Clients WHERE client_id = %s", (termo,))
    else:
        #caso contrario, assume o nome
        cursor.execute("SELECT client_id, fullname, email, zip_code, city, birthdate FROM Clients WHERE fullname LIKE %s", (f"%{termo}%",))

    resultados = cursor.fetchall() #lê os resultados, cada um deles fica gravado como um tuplo

    if not resultados:
        show_msg("Nenhum utilizador encontrado.")
        pause()
        return

    print("+----+------------+------------+--------------------------+-----------+-------------+------------+")
    print("| ID | Nome       | Apelido    | Email                    | Cod. Post | Cidade      | Nascimento |")
    print("+----+------------+------------+--------------------------+-----------+-------------+------------+")
    for cliente in resultados: #percorre o conteudo de resultados, uma lista de tuplos
        id_, fullname, email, zip_code, city, birthdate = cliente
        partes_nome = fullname.split(" ", 1)  # divide só no primeiro espaço
        nome = partes_nome[0]
        apelido = partes_nome[1] if len(partes_nome) > 1 else "" #se só houver um nome, fica em branco 

        print(f"| {id_} | {nome} | {apelido} | {email} | {zip_code} | {city} | {birthdate} |")
    print("+----+------------+------------+--------------------------+-----------+-------------+------------+")

    pause()
    #caso tenhamos pesquisado por nome, pode haver mais do que um com o mesmo nome
    escolha = ask("ID do cliente a alterar (Enter para sair): ") 
    if not escolha:
        return

    cursor.execute("SELECT is_active FROM Clients WHERE client_id = %s", (escolha,))
    resultado = cursor.fetchone()

    if resultado is None:
        show_msg("Utilizador não encontrado.")
        pause()
        return

    is_active = resultado[0] #vamos buscar o tuplo desse utilizador e iremos consultar se está activo ou não

    if is_active:
        #se estiver activo - is_active 0, num bool 0 corresponde a true, pergunta se desejamos bloquear
        if confirm("Deseja bloquear este utilizador?"):
            cursor.execute("UPDATE Clients SET is_active = 0 WHERE client_id = %s", (escolha,))
            conn.commit()
            show_msg("Utilizador bloqueado.")
    else:
        #caso identifique um 1 - false no bool - pergunta se pretendemos desbloquear
        if confirm("Deseja desbloquear este utilizador?"):
            cursor.execute("UPDATE Clients SET is_active = 1 WHERE client_id = %s", (escolha,))
            conn.commit()
            show_msg("Utilizador desbloqueado.")

    pause()


# MENU PRODUTO
# Pesquisa produtos com o tipo livro ou eletronico e com os seguintes critérios definidos no enunciado:
# intervalo de quantidade (definimos um minimo e maximo)
# intervalo de preco (idem)
# Mostra tipo, quantidade, preco e descricao do produto

def menu_produto(conn):
    cls()
    show_msg("MENU PRODUTO")
    cursor = conn.cursor()

    #recolhemos os dados para pesquisa
    tipo = ask("Tipo (livro/eletronico ou Enter para pesquisar em ambos): ").lower()
    q_min = ask("Quantidade mínima (Enter para ignorar): ")
    q_max = ask("Quantidade máxima (Enter para ignorar): ")
    p_min = ask("Preço mínimo (Enter para ignorar): ")
    p_max = ask("Preço máximo (Enter para ignorar): ")

    # Começa a query base
    query = """
        SELECT Product.product_id, quantity, price, 
        COALESCE(Book.title, CONCAT(Electronic.brand, ' ', Electronic.model)) AS descricao
        FROM Product
        LEFT JOIN Book ON Product.product_id = Book.product_id
        LEFT JOIN Electronic ON Product.product_id = Electronic.product_id
    """

    # Lista de condições
    condicoes = []

    if tipo == 'livro':
        condicoes.append("Book.title IS NOT NULL")
    elif tipo == 'eletronico':
        condicoes.append("Electronic.brand IS NOT NULL")

    if q_min:
        condicoes.append(f"quantity >= {int(q_min)}")
    if q_max:
        condicoes.append(f"quantity <= {int(q_max)}")
    if p_min:
        condicoes.append(f"price >= {float(p_min)}")
    if p_max:
        condicoes.append(f"price <= {float(p_max)}")

    # Junta as condições à query
    if condicoes:
        query += " WHERE " + " AND ".join(condicoes)

    # Executa a query
    cursor.execute(query)
    produtos = cursor.fetchall()

    if not produtos:
        show_msg("Nenhum produto encontrado.")
        pause()
        return

    # Mostrar resultados
    print("+----------+-----------+----------+-----------------------------+")
    print("| Código   | Quantidade| Preço    | Descrição                  |")
    print("+----------+-----------+----------+-----------------------------+")
    for p in produtos:
        print(f"| {p[0]} | {p[1]} | {p[2]} | {p[3]} |")
    print("+----------+-----------+----------+-----------------------------+")
    pause()

# FAZER BACKUP

def fazer_backup():
    cls()
    show_msg("A fazer backup da base de dados...")
    #comando para o windows, em casa desenvolvemos nesse sistema operativo 
    os.system(r'"C:\wamp64\bin\mysql\mysql9.1.0\bin\mysqldump.exe" -u root BuyPy > backup_buypy.sql')  
    show_msg("Backup feito com sucesso!")
    pause()

# MENU PRINCIPAL
#mostra o menu e chama a função correspondente à escolha do utilizador
def menu_principal(conn):
    while True:
        cls() #clearscreen
        #menu recriado à imagem do do projeto efeitos, reaproveitamos esse
        print('*'*52) 
        print('*' + ' '*50 + '*')
        print('*' + ' '*2 + 'BACKOFFICE - MENU PRINCIPAL' + ' '*21+'*')
        print('*' + ' '*50 + '*')
        print('*' + ' '*4 + '1 - Menu Utilizador' + ' '*27+'*')
        print('*' + ' '*4 + '2 - Menu Produto' + ' '*30+'*')
        print('*' + ' '*4 + '3 - Fazer Backup' + ' '*30+'*')
        print('*' + ' '*4 + '4 – Sair' + ' '*38+'*')
        print('*' + ' '*50 + '*')
        print('*'*52)
        print('')

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            menu_utilizador(conn)
        elif opcao == '2':
            menu_produto(conn)
        elif opcao == '3':
            fazer_backup()
        elif opcao == '4':
            show_msg("A sair...")
            break
        else:
            show_msg("Opção inválida.")
            pause()


# PROGRAMA PRINCIPAL
# Tenta ligar a base de dados e caso bem sucedido, corre o programa
def main():
    conn = ligar_bd()
    if conn:
        menu_principal(conn)
        conn.close()
    else:
        show_msg("Não foi possível ligar à base de dados.")

if __name__ == "__main__":
    main()