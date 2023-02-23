import os
import subprocess
import pkgutil
from locust import HttpUser, task, between
from mysql.connector import connect, Error

os.system('cls')

# Teste de bibliotecas instaladas necessárias
need_libraries = ['cryptography', 'pymysql', 'locust', 'mysql-connector-python']

for lib in need_libraries:
    if not pkgutil.find_loader(lib):
        print(f"A biblioteca {lib} não está instalada. Instalando...")
        subprocess.run(['pip', 'install', lib])

# Cria bot de teste
class MyUser(HttpUser):
    wait_time = between(1, 5)

    @task(1)
    def get_price(self):
        try:
            # Estabelece conexão com o banco de dados MySQL
            with connect(
                host="192.168.0.9",
                user="root",
                password="123",
                database="test1",
                port=3306
            ) as connection:
                with connection.cursor() as cursor:
                    # Executa uma query que busca o preço do produto com o código de barras especificado
                    cursor.execute("SELECT preco FROM estoque WHERE id_codigo_barras = %s", ("3756392598566",))
                    result = cursor.fetchone()
                    price = result[0]
                    # Imprime o preço do produto retornado pelo banco de dados
                    print("Preço do produto: {}".format(price))
        except Error as e:
            print(e)
