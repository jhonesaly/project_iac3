# project_iac3/advanced

Nessa pasta está contida o script avançado, que utiliza lógica para permitir a generalização do script básico para qualquer caso semelhante.

Tudo isso utilizando uma estrutura modularizada que permite maior flexibilidade e mais implementações no futuro.

Para tal, basta executar o script "new_iac3.sh".

O script é responsável por conduzir o usuário por um conjunto de perguntas iniciais que ajudarão a configurar a aplicação.

------

## Explicando o script "new_iac3.sh"

Na etapa 0, são definidas algumas variáveis de cor para as mensagens que serão impressas na tela. Em seguida, uma mensagem de boas-vindas é impressa na tela com o nome do protocolo a ser executado e um link para a documentação do projeto.

### Configuração

Na etapa 1, o script faz algumas perguntas ao usuário para configurar o cluster. O número da pergunta é armazenado na variável 'question_number'.

A pergunta número 1 pergunta se o usuário deseja criar um líder (gerenciador do cluster) no cluster. Se a resposta for "y", o script faz outra pergunta se o usuário deseja usar um arquivo de configuração pré-existente, o **master_vars.conf**. Se a resposta for "n", o script faz várias perguntas ao usuário para configurar o líder, que são salvas no arquivo de configuração, o sobrescrevendo.

Se a pergunta número 1 for respondida com "n", o script passa para a pergunta número 2, que pergunta se o usuário deseja criar um worker (serviço secundário) no cluster.

Se o usuário responder a pergunta que preenche a variável 'ans_a1' e 'ans_b1' inadequadamente, cai em um loop que continua até que todas as perguntas sejam respondidas. Se as respostas forem "y" ou "n", o loop termina.

### Módulos

A etapa 2 executa os módulos apropriados com base nas respostas do usuário. Se a resposta para a pergunta número 1 for "y", o módulo **create_leader.sh** é executado para criar um líder no cluster.

Se a resposta para a pergunta número 1 for "n" e a resposta para a pergunta número 2 for "y", o módulo **create_worker.sh** é executado para criar um worker no cluster.

Se a segunda pergunta com '[y/n]' dentro da configuração do leader for 'y', executa a inserção de dados aleatórios no banco de dados usando um script Python **rand_insert_shell.py**.

Se a resposta para a pergunta número 1 for "n" e a resposta para a pergunta número 2 também for "n", o script passa para a finalização.

Na última etapa, o script imprime uma mensagem de finalização na tela.

A seguir, serão explicados os scripts dos módulos.

------

## Explicando o script "create_leader.sh"

Esse é um script em Bash que executa uma série de comandos para configurar um cluster de Docker para uma aplicação web e seu respectivo manager.

### 0 - Configurações

Este bloco puxa as variáveis do arquivo **master_vars.conf** que é lido para que as variáveis root_name, root_pass e db_name possam ser usadas em outras partes do script. 

Em seguida, são instalados alguns pacotes e imagens importantes para a execução do código.

Depois, é criado um volume para o banco de dados, um para a aplicação e outro para o proxy.

Por fim, é iniciado o Docker Swarm e são criados tokens de worker e manager, que são adicionados no arquivo **master_vars.conf** para que possam ser usados em outras máquinas e adicionadas ao cluster.

### 1 - Banco de dados

Este bloco cria um contêiner para o banco de dados MySQL e executa um script SQL nele e guarda o ID do contêiner MySQL na variável 'mysql_container_id'.

com o contêiner criado, o tudo que está na pasta /modules/database, que nesse projeto só contém o **dbscript.sql**, é copiado para o diretório do volume do banco de dados.

Em seguida, uma função é definida para executar o script no banco de dados no contêiner. Essa função é usada em um loop até que o comando seja executado com sucesso.

A função foi criada pois, muitas vezes, ao rodar o script, aparece o seguinte erro:

    ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)

Mas, em geral, basta reexecutar o comando para que funcione.

#### dbscript.sql

O script SQL cria uma tabela chamada "estoque". A tabela tem seis colunas: "id_codigo_barras", "nome", "marca", "preco", "data_compra" e "data_validade".

A primeira coluna "id_codigo_barras" é definida como um tipo de dados VARCHAR com um comprimento máximo de 13 caracteres e é declarada como NOT NULL, o que significa que um valor deve ser fornecido ao inserir um registro na tabela.

A segunda coluna "nome" é definida como um tipo de dados VARCHAR com um comprimento máximo de 50 caracteres e também é declarada como NOT NULL.

A terceira coluna "marca" é definida como um tipo de dados VARCHAR com um comprimento máximo de 50 caracteres e é declarada como NOT NULL.

A quarta coluna "preco" é definida como um tipo de dados DECIMAL com um tamanho máximo de 10 e uma precisão máxima de 2, o que significa que o preço pode ter até 10 dígitos no total, com 2 casas decimais. A coluna é declarada como NOT NULL.

A quinta coluna "data_compra" é definida como um tipo de dados DATE e é declarada como NOT NULL.

A sexta coluna "data_validade" é definida como um tipo de dados DATE e também é declarada como NOT NULL.

Por fim, a tabela tem uma chave primária, que é a coluna "id_codigo_barras". Isso garante que cada registro na tabela tenha um valor exclusivo para essa coluna.

### 2 - Proxy

Este bloco cria um contêiner para o proxy nginx. Primeiro, um arquivo de configuração do nginx é criado a partir do modelo e é adicionado um servidor com o IP do gerente. Em seguida, a imagem é criada e o contêiner é iniciado. Depois, é criado um loop que verifica a cada 30 segundos se há trabalhadores adicionais no cluster. Se houver, o contêiner nginx é parado e removido, o novo IP do trabalhador é obtido do arquivo ip_list.conf e o arquivo de configuração do nginx é atualizado com o novo IP. A imagem é recriada e o contêiner é iniciado novamente.

### 3 - Compartilhamento

Este bloco configura o NFS (Network File System) para compartilhamento de arquivos entre os nós do cluster. Um diretório compartilhado é criado em /shared, as permissões são definidas e um arquivo ip_list.conf é criado para armazenar os IPs dos trabalhadores. O arquivo master_vars.conf é copiado para o diretório compartilhado. O NFS é configurado para compartilhar o volume app_volume com a opção de escrita e sincronização ativadas.