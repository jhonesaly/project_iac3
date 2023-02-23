import os
import subprocess
import pkgutil
from locust import User, between, events, task
import time
import mysql.connector

os.system('cls')

# Teste de bibliotecas instaladas necessárias
need_libraries = ['cryptography', 'pymysql', 'locust', 'mysql-connector-python']

for lib in need_libraries:
    if not pkgutil.find_loader(lib):
        print(f"A biblioteca {lib} não está instalada. Instalando...")
        subprocess.run(['pip', 'install', lib])

# Define o intervalo entre as medições
events.init(tick=0.01)

# Cria o teste
def mysql_test():
    start_time = time.time()
    with mysql.connector.connect(user='root', password='123', host='192.168.0.9', database='test1', port=3306) as cnx:
        cursor = cnx.cursor()
        cursor.execute("SELECT preco FROM estoque WHERE id_codigo_barras = %s", ("3756392598566",))
        result = cursor.fetchone()
        price = result[0]
        # Imprime o preço do produto retornado pelo banco de dados
        print("Preço do produto: {}".format(price))
        cursor.close()
        cnx.close()
        # Envia o evento
        events.request_success.fire(request_type="MySQL", name="execute id_codigo_barras", response_time=int(time.time() * 1000), response_length=0)

# Cria bot de teste
class MyUser(User):
    wait_time = between(1, 2)

    @task
    def mysql_task(self):
        mysql_test()



# Para rodar a interface use o comando: > locust -f advanced/tools/direct_locust_loadtest.py --headless -u 1000 -r 100 -t 5min --host=192.168.0.9:3306
# Para acessá-la abra no browser o endereço: http://localhost:8089