import random
import barcode
import pymysql

# configurações do banco de dados
host = "192.168.0.9"
user = "root"
password = "123"
database = "test1"

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

    nome VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    data_compra DATE NOT NULL,
    data_validade DATE NOT NULL,

# gerar valores aleatórios

# gerar um código de barras aleatório
ean = barcode.get_barcode_class('ean13')
codigo_barras_rand = ean(f'{random.randint(0, 999999999999)}').to_svg()

# gerar nomes aleatórios

consoantes = "bcdfghjklmnpqrstvwxyz"
vogais = "aeiou"
num_silabas = random.randint(2, 4)
nome_rand = ""
for i in range(num_silabas):
    nome_rand += random.choice(consoantes)
    nome_rand += random.choice(vogais)

# gerar preço aleatório

preco_rand = random.randint(1, 99)
data_compra = random.randdae

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
