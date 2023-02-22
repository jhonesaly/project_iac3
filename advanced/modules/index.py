import random
import barcode
import pymysql
from datetime import date, timedelta

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
consoantes = "bcdfghjklmnpqrstvwxyz"
vogais = "aeiou"
num_silabas = random.randint(2, 4)
nome_rand = ""
for i in range(num_silabas):
    nome_rand += random.choice(consoantes)
    nome_rand += random.choice(vogais)

## gerar preço aleatório
preco_rand = round(random.uniform(0, 100), 2)

## gerar datas aleatórioas
data_inicial = date(2023, 1, 1)
data_final = date(2023, 12, 31)
diferenca_dias = (data_final - data_inicial).days

data_rand = data_inicial + timedelta(days=random.randint(0, diferenca_dias))
data_comp_rand = data_rand.strftime('%d/%m/%Y')

data_rand = data_inicial + timedelta(days=random.randint(0, diferenca_dias))
data_val_rand = data_rand.strftime('%d/%m/%Y')



host_name = socket.gethostname()


# criar e executar a consulta SQL
query = f"INSERT INTO dados (id_codigo_barras, nome, Sobrenome, Endereco, Cidade, Host) VALUES ('{cod_barras_rand}', '{nome_rand}', '{nome_rand}', '{nome_rand}', '{nome_rand}', '{host_name}')"
with conn.cursor() as cursor:
    cursor.execute(query)

# confirmar a inserção dos dados
conn.commit()

# encerrar a conexão
conn.close()

print("New record created successfully")
