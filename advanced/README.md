# project_iac3/advanced

Nessa pasta está contida o script avançado, que utiliza lógica para permitir a generalização do script básico para qualquer caso semelhante.

Tudo isso utilizando uma estrutura modularizada que permite maior flexibilidade e mais implementações no futuro.

Para tal, basta executar o script "new_iac3.sh".

O script é responsável por conduzir o usuário por um conjunto de perguntas iniciais que ajudarão a configurar a aplicação.

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

## Explicando o script "create_leader.sh"

