import random
import os
import pymysql
from datetime import date, timedelta
import subprocess
import pkgutil

os.system('cls')

need_libraries = ['cryptography', 'mysql-connector-python', 'pymysql']

for lib in need_libraries:
    if not pkgutil.find_loader(lib):
        print(f"A biblioteca {lib} não está instalada. Instalando...")
        subprocess.run(['pip', 'install', lib])


# Funções úteis
def name_rand():
    consoantes = "bcdfghjklmnpqrstvwxyz"
    vogais = "aeiou"
    num_silabas = random.randint(2, 4)
    name = ""
    for i in range(num_silabas):
        name += random.choice(consoantes)
        name += random.choice(vogais)
    return name.capitalize()

def date_rand():
    data_inicial = date(2023, 1, 1)
    data_final = date(2023, 12, 31)
    diferenca_dias = (data_final - data_inicial).days
    data = data_inicial + timedelta(days=random.randint(0, diferenca_dias))
    return data.strftime('%Y-%m-%d')

# Argumentos vindos do shell script

ip_vm = input('Informe o ip da máquina: ')
db_name = input('Informe o nome do banco de dados: ')
root_pass = input('informe a senha do banco de dados: ')
n_prod = int(input('Informe quantos produtos aleatórios deseja criar: '))

# configurações do banco de dados
host = ip_vm
user = "root"
password = root_pass
database = db_name

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

# gerar valores aleatórios

for i in range(n_prod):

    ## gerar um código de barras aleatório
    cod_barras_rand = ''.join([str(random.randint(0, 9)) for _ in range(13)])

    ## gerar nomes aleatórios
    nome_rand = name_rand()
    marca_rand = name_rand()

    ## gerar preço aleatório
    preco_rand = round(random.uniform(0, 100), 2)

    ## gerar datas aleatórias
    data_comp_rand = date_rand()
    data_val_rand = date_rand()

    # criar e executar a SQL query
    query = f"INSERT INTO estoque (id_codigo_barras, nome, marca, preco, data_compra, data_validade) VALUES ('{cod_barras_rand}', '{nome_rand}', '{marca_rand}', '{preco_rand}', '{data_comp_rand}', '{data_val_rand}')"
    with conn.cursor() as cursor:
        cursor.execute(query)
    
    print(f"novo produto: '{cod_barras_rand}', '{nome_rand}', '{marca_rand}', '{preco_rand}', '{data_comp_rand}', '{data_val_rand}'")

# confirmar a inserção dos dados
conn.commit()

# encerrar a conexão
conn.close()

print(f"Novos {n_prod} produtos registrados com sucesso.")