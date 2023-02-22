import random
import barcode
import pymysql
from datetime import date, timedelta

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


# configurações do banco de dados
host = "192.168.0.9"
user = "root"
password = "123"
database = "test1"

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

# gerar valores aleatórios

## gerar um código de barras aleatório
ean = barcode.get_barcode_class('ean13')
codigo_barras_rand = ean(f'{random.randint(0, 999999999999)}').to_svg()

## gerar nomes aleatórios
nome_rand = name_rand()
marca_rand = name_rand()

## gerar preço aleatório
preco_rand = round(random.uniform(0, 100), 2)

## gerar datas aleatórioas
data_comp_rand = date_rand()
data_val_rand = date_rand()


# criar e executar a consulta SQL
query = f"INSERT INTO dados (id_codigo_barras, nome, marca, preco, data_compra, data_validade) VALUES ('{cod_barras_rand}', '{nome_rand}', '{marca_rand}', '{preco_rand}', '{data_comp_rand}', '{data_val_rand}')"
with conn.cursor() as cursor:
    cursor.execute(query)

# confirmar a inserção dos dados
conn.commit()

# encerrar a conexão
conn.close()

print("New record created successfully")