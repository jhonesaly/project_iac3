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

Docker é uma plataforma de software que permite que os aplicativos sejam executados em ambientes isolados, chamados contêineres, que são uma forma de virtualização de sistema operacional que permite a criação de ambientes portáteis para execução de aplicativos.

O objetivo do Docker é permitir que os desenvolvedores criem, implantem e executem aplicativos de maneira rápida e fácil, independentemente do ambiente de hospedagem.

Cada contêiner é uma instância de um sistema operacional mínimo e contém apenas os componentes necessários para executar o aplicativo. Isso significa que um único host pode executar vários contêineres, cada um com sua própria versão do sistema operacional e das bibliotecas necessárias para executar o aplicativo.

Docker usa imagens para criar e implantar aplicativos em contêineres. Uma imagem Docker é uma coleção de camadas que contêm instruções sobre como criar um contêiner. As imagens são criadas usando arquivos de configuração chamados Dockerfiles, que contêm uma lista de comandos a serem executados na imagem.

Por tudo isso, é uma ferramenta popular para criação e implantação de aplicativos, especialmente em ambientes de nuvem. Ele permite que os desenvolvedores criem aplicativos em seus próprios computadores e, em seguida, implantem esses aplicativos em qualquer ambiente de hospedagem que suporte contêineres Docker, como Amazon Web Services, Google Cloud Platform ou Microsoft Azure. Isso torna o desenvolvimento e implantação de aplicativos mais fácil e mais rápido, reduzindo a complexidade do ambiente de hospedagem.

### Docker Swarm

O Docker Swarm é uma ferramenta de orquestração de contêineres que permite criar um cluster de hosts Docker, permitindo a execução de aplicativos em um ambiente de contêiner escalável e altamente disponível. O Docker Swarm é uma solução integrada no Docker Engine e permite que vários hosts do Docker sejam agrupados em um cluster.

Com o Docker Swarm, é possível definir uma série de serviços em um arquivo de composição do Docker e distribuí-los automaticamente entre os hosts do cluster. O Swarm gerencia o agendamento e o balanceamento de carga dos serviços, garantindo que eles estejam em execução em todo o cluster.

O Docker Swarm usa um conjunto de APIs para permitir que os aplicativos sejam implantados em um cluster de contêineres distribuído. Ele usa o algoritmo de consenso RAFT para gerenciar o estado do cluster e garantir a tolerância a falhas. Com isso, ele pode escalar automaticamente aplicativos em resposta a picos de demanda e garantir a disponibilidade de aplicativos críticos.

O Docker Swarm também oferece recursos de segurança e gerenciamento de recursos, como autenticação e autorização baseadas em certificados TLS e gerenciamento de limites de recursos para controlar o uso de CPU e memória em um ambiente compartilhado. Ele pode ser integrado com outras ferramentas de orquestração, como Kubernetes, para criar soluções de contêineres mais complexas.

### AWS

AWS significa Amazon Web Services, é uma plataforma de computação em nuvem fornecida pela Amazon.com. Ela oferece um conjunto de serviços que ajudam indivíduos e empresas a armazenar, gerenciar e processar dados em uma infraestrutura remota segura e escalável.

Os serviços da AWS incluem, mas não se limitam a: armazenamento em nuvem (S3), bancos de dados (RDS), computação (EC2), rede (VPC), Internet das Coisas (IoT), aprendizado de máquina (Machine Learning), análise de dados (EMR), ferramentas de desenvolvimento (CodeCommit, CodeBuild, CodePipeline), segurança e conformidade, entre outros.

A AWS permite que os usuários acessem recursos computacionais em escala global, permitindo que eles desenvolvam e executem aplicativos e serviços com alta escalabilidade, disponibilidade e segurança. Esses recursos são fornecidos por meio de centros de dados distribuídos em diferentes regiões do mundo.

A plataforma AWS é altamente flexível e personalizável, permitindo que os usuários selecionem os serviços necessários para suas necessidades específicas e paguem apenas pelos recursos utilizados, sem a necessidade de se preocupar com investimentos em infraestrutura e hardware próprios. Além disso, a AWS oferece suporte ao desenvolvimento e implantação de aplicativos em várias linguagens de programação e sistemas operacionais.

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