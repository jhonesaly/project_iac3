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

Script que seguirá estritamente aquilo que foi proposto pelo desafio, com todos os arquivos necessários para realizar a configuração manual do serviço seja em VMs ou na AWS.

Como treino, arquivos foram digitados exatamente como instruído pelo professor.

### advanced

Nessa pasta está contido todos os arquivos para a execução avançada do projeto, que utiliza muita lógica para permitir a generalização e automatização do projeto básico para qualquer caso semelhante, permitindo maior flexibilidade e escalabilidade.

Tudo isso utilizando uma estrutura modularizada que permite maior flexibilidade e mais implementações no futuro.

Dentro da respectiva pasta há um outro README.md que explica detalhadamente o que cada arquivo faz.

Para tal, o projeto foi imaginado como uma estrutura para supermercado, onde o há um banco de dados que contém os produtos, seus códigos de barras como chave e seu respectivo preço. Cada caixa opera com um contêiner do serviço e quando 'bipa' um produto, faz a requisição que adquire seu preço.

![Caixa](./images/caixa.jpg)

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

### NGINX

O Nginx (pronuncia-se "engine-x") é um servidor web de código aberto que pode ser usado como um servidor proxy reverso, balanceador de carga, servidor de correio eletrônico e servidor de streaming de mídia. Ele foi criado por Igor Sysoev em 2002 com o objetivo de resolver problemas de escalabilidade do Apache em um ambiente de alta carga.

Uma das principais características do Nginx é sua capacidade de lidar com muitas conexões simultâneas, tornando-o uma escolha popular para sites de alta demanda. Ele é capaz de lidar com milhares de conexões simultâneas com baixo consumo de recursos do sistema.

Além disso, o Nginx tem uma arquitetura modular, permitindo que os usuários adicionem funcionalidades adicionais através de módulos externos. Ele também tem uma configuração simples e flexível, permitindo que os administradores de sistema personalizem facilmente a configuração do servidor de acordo com suas necessidades específicas.

### Load test (Teste de carga)

Um load test (teste de carga, em português) é um tipo de teste de software que visa avaliar a capacidade de um sistema ou aplicação para lidar com cargas de trabalho específicas. O objetivo é medir a capacidade de resposta e o desempenho do sistema ou aplicação sob uma carga de trabalho simulada e, em seguida, identificar os gargalos e limitações do sistema.

Um load test pode ajudar a identificar problemas relacionados a capacidade de recursos, como memória, CPU, largura de banda, I/O de disco e conexões de rede, bem como gargalos de software, como problemas de concorrência e problemas de escalabilidade.

Os resultados do load test geralmente incluem métricas como tempo de resposta, taxa de transferência, utilização de recursos do sistema, tempos de espera, erros e outros. Essas métricas podem ser usadas para identificar problemas de desempenho, bem como para otimizar e ajustar o sistema para melhorar o desempenho.

Os load tests podem ser realizados manualmente ou com ferramentas automatizadas, como o Locust, que é usado no script mencionado anteriormente. Essas ferramentas permitem que os usuários definam uma carga de trabalho específica para simular, a fim de avaliar a capacidade do sistema ou aplicação em questão.

### Locust

Locust é uma ferramenta de teste de carga de software de código aberto, escrita em Python. Ele permite que os desenvolvedores criem e executem testes de carga para medir a capacidade de um sistema para lidar com uma carga simulada de usuários. O Locust é capaz de gerar um grande número de usuários simulados em uma máquina para testar o desempenho de um sistema em diferentes cenários de carga.

Os testes de carga podem ser personalizados usando o Locust, o que significa que os usuários podem criar cenários de teste personalizados para simular diferentes condições de uso, tipos de usuários e comportamentos. O Locust suporta vários protocolos, incluindo HTTP, HTTPS, WebSockets e mais, permitindo testar aplicativos da web, API's e sistemas em geral.

Além disso, o Locust oferece uma interface da web amigável para que os usuários possam monitorar o desempenho do sistema em tempo real durante o teste. A interface do usuário permite que os usuários visualizem métricas importantes, como o tempo de resposta, o número de solicitações bem-sucedidas e malsucedidas, a taxa de transferência e muito mais. Isso permite que os usuários detectem gargalos e outros problemas de desempenho enquanto os testes estão sendo executados.

------

## Montando na sua máquina

------

## Observações

[Voltar ao topo](#sumário)