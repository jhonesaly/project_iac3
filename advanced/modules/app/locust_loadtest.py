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


# Cria o teste
def mysql_test(user, password, host, database, port):
    with mysql.connector.connect(user=user, password=password, host=host, database=database, port=port) as cnx:
        time_init = time.perf_counter()
        cursor = cnx.cursor()
        cursor.execute("SELECT preco FROM estoque WHERE id_codigo_barras = %s", ("3756392598566",))
        result = cursor.fetchone()
        price = result[0]
        
        # Imprime o preço do produto retornado pelo banco de dados
        print("Preço do produto: {}".format(price))
        cursor.close()
        cnx.close()
        time_fin = time.perf_counter()
    return price, time_init, time_fin

# Cria bot de teste
class MyUser(User):
    wait_time = between(1, 2)

    @task
    def mysql_task(self):
        price, time_init, time_fin = mysql_test('root', '123', '192.168.0.9', 'test1', 3306)
        
        # Envia o evento para gráfico do locust
        response_length = len(str(price))
        events.request.fire(
            request_type="MySQL",
            name="execute id_codigo_barras",
            response_time=(time_fin - time_init) * 1000,
            response_length=response_length,
            context=None,
            exception=None,
            )
        
# Para rodar a interface use o comando: > locust -f advanced/tools/direct_locust_loadtest.py -u 30 -r 1 -t 30s --host=192.168.0.9:3306
# Para acessá-la abra no browser o endereço: http://localhost:8089