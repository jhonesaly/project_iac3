import random
import sys
import barcode
import pymysql
from datetime import date, timedelta

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
    return data.strftime('%d/%m/%Y')

# Argumentos vindos do shell script
ip_vm = sys.argv[1]
db_name = sys.argv[2]
root_pass = sys.argv[3]

# configurações do banco de dados
host = ip_vm
user = "root"
password = root_pass
database = db_name

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

# gerar valores aleatórios

## gerar um código de barras aleatório
ean = barcode.get_barcode_class('ean13')
cod_barras_rand = ean(f'{random.randint(0, 999999999999)}').to_svg()

## gerar nomes aleatórios
nome_rand = name_rand()
marca_rand = name_rand()

## gerar preço aleatório
preco_rand = round(random.uniform(0, 100), 2)

## gerar datas aleatórias
data_comp_rand = date_rand()
data_val_rand = date_rand()

# criar e executar a SQL query
query = f"INSERT INTO dados (id_codigo_barras, nome, marca, preco, data_compra, data_validade) VALUES ('{cod_barras_rand}', '{nome_rand}', '{marca_rand}', '{preco_rand}', '{data_comp_rand}', '{data_val_rand}')"
with conn.cursor() as cursor:
    cursor.execute(query)

# confirmar a inserção dos dados
conn.commit()

# encerrar a conexão
conn.close()

print("Novo registro com sucesso.")