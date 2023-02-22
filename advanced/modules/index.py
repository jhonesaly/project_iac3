import random
import pymysql

# configurações do banco de dados
host = "192.168.0.9"
user = "root"
password = "123"
database = "test1"

# criar conexão
conn = pymysql.connect(host=host, user=user, password=password, database=database)

# gerar valores aleatórios
valor_rand1 = random.randint(1, 999)
valor_rand2 = ''.join(random.choices('ABCDEF0123456789', k=8))
host_name = socket.gethostname()


# criar e executar a consulta SQL
query = f"INSERT INTO dados (AlunoID, Nome, Sobrenome, Endereco, Cidade, Host) VALUES ('{valor_rand1}', '{valor_rand2}', '{valor_rand2}', '{valor_rand2}', '{valor_rand2}', '{host_name}')"
with conn.cursor() as cursor:
    cursor.execute(query)

# confirmar a inserção dos dados
conn.commit()

# encerrar a conexão
conn.close()

print("New record created successfully")
