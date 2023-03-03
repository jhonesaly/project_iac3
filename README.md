# Desafio de Projeto 3 - Bootcamp de Linux

## Sumário

- [Proposta do Projeto](##Proposta-do-Projeto)
    - [Objetivos do Projeto](###Objetivos-do-Projeto)
    - [Requerimentos do Projeto](###Requerimentos-do-Projeto)
- [Organização do Repositório](##organização-do-repositório)
    - [basic](####basic)
    - [advanced](####advanced)
- [Definições Importantes](##Definições-Importantes)
- [Montando na sua máquina](##Montando-na-sua-Máquina)
- [Observações](##Observações)

------

## Proposta do Projeto

Utilização Prática do Docker no Cenário de Microsserviços

## Objetivos do Projeto

Neste desafio, você deverá replicar as aulas ministradas pelo instrutor Denilson Bonatti, criando um repositório próprio e, nesse contexto, conheça o Docker, implemente uma estrutura de Microsserviços com as melhores práticas do mercado internacional e ganhe independência entre aplicações e infraestrutura.

------

## Organização do repositório

### basic

### advanced

------

## Definições Importantes

### Docker

### Docker Swarm

### AWS

### NFS

NFS (Network File System) é um protocolo de compartilhamento de arquivos em rede que permite que computadores em uma rede compartilhem arquivos e diretórios de forma transparente, como se estivessem acessando arquivos e diretórios locais. O NFS é um padrão aberto e foi criado pela Sun Microsystems para o sistema operacional Unix.

O NFS funciona de forma similar a outros protocolos de compartilhamento de arquivos, mas com algumas diferenças importantes. Em vez de simplesmente copiar arquivos de um computador para outro, o NFS permite que um computador acesse diretamente os arquivos e diretórios em outro computador como se estivessem armazenados localmente.

Isso é possível porque o NFS compartilha diretórios e arquivos por meio de um sistema de arquivos virtual. Isso significa que o computador que está acessando os arquivos não precisa saber onde eles estão fisicamente armazenados no disco rígido do computador que os compartilha. Em vez disso, o NFS simplesmente fornece um caminho virtual para acessá-los.

Ao usar o NFS, é possível compartilhar arquivos e diretórios em uma rede local de forma eficiente e segura. Isso é especialmente útil em ambientes de rede com muitos computadores, como empresas e instituições de ensino, onde os usuários precisam acessar os mesmos arquivos e diretórios em vários computadores. Além disso, o NFS também é usado em ambientes de computação em cluster e computação de alta performance para compartilhar recursos e dados entre nós de processamento.

### Proxy Reverso

Um proxy reverso é um servidor intermediário que recebe solicitações de clientes e encaminha essas solicitações para um ou mais servidores de origem. Diferentemente de um proxy normal, que encaminha solicitações para um cliente, um proxy reverso encaminha solicitações para um servidor, funcionando como um intermediário entre os clientes e os servidores de origem.

Um exemplo comum de uso de proxy reverso é o balanceamento de carga. Quando vários servidores web são executados em um cluster, um proxy reverso pode distribuir as solicitações entre os servidores para garantir que a carga seja equilibrada e que cada servidor receba uma carga razoável.

Em resumo, um proxy reverso é um servidor intermediário que encaminha solicitações de clientes para um ou mais servidores de origem, enquanto um servidor web pode ser configurado como um proxy reverso para melhorar o desempenho e a escalabilidade de um site. O uso de um proxy reverso pode ajudar a distribuir a carga entre vários servidores e fornecer serviços adicionais, como autenticação, balanceamento de carga e caching.

------

## Montando na sua máquina

------

## Observações

[Voltar ao topo](#sumário)