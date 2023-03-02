import os
import random
import sys
from datetime import date, timedelta
import pymysql

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


# Configurações do banco de dados

host = os.environ['MASTER_IP']
user = "root"
password = os.environ['ROOT_PASS']
database = os.environ['DB_NAME']
n_rand_data = os.environ['N_RAND_DATA']

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

for i in range(int(n_rand_data)):

    # gerar valores aleatórios

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

    print(f'cod_barras para teste: ({cod_barras_rand}) e resultado esperado: ({preco_rand})')
    
    # criar e executar a SQL query
    query = f"INSERT INTO estoque (id_codigo_barras, nome, marca, preco, data_compra, data_validade) VALUES ('{cod_barras_rand}', '{nome_rand}', '{marca_rand}', '{preco_rand}', '{data_comp_rand}', '{data_val_rand}')"
    with conn.cursor() as cursor:
        cursor.execute(query)

    # confirmar a inserção dos dados
    conn.commit()

# encerrar a conexão
conn.close()

print("Novo registro com sucesso.")