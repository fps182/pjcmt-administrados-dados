# Teste Prático - Administrador de Dados

**Nome**: Fernando Prudêncio de Souza  
**CPF**: 004.209.861-03

## Ambiente de Desenvolvimento

Essas instruções fornecerão uma cópia do projeto instalado e funcionando em sua máquina local para fins de desenvolvimento e teste.

### Pré-requisitos

* [Docker](https://www.docker.com/products/docker-desktop) - Para conteinerização do projetos. Versão utilizada: 19.03.x

Opcionalmente:

* [GIT Client](https://git-scm.com/downloads) - Para clonagem do repositório. Versão utilizada: 2.29.x.

### Instalando

* Clone o repositório ou copie a pasta para máquina local
    * *git clone https://github.com/fps182/pjcmt-administrados-dados.git*
* Acesse o terminal do seu SO host ou a ferramente Docker Quickstart Terminal (Docker Toolbox)
* Através do terminal, acesse a pasta do projeto em sua máquina
    * A pasta raiz deve conter o arquivo *docker-compose.yml*
* Ainda no terminal, execute o comandos:
    * *docker-compose up -d*, para inicializar os containers:
        * dbpolicia (PostgresSQL 12)
        * dbadmin (PgAdmin 4)
    * *docker-compose ps*, para listar os containers e seu status atual 
        * Uma vez que o status seja *UP*, os container estão prontos para uso

### Validando a Estrutura

* Acesse o PgAdmin através da url do host (localhost, ou o IP gerado pelo Docker Toolbox)
    * Url: localhost:16543 *OU* IP_GERADO_PELO_DOCKER_TOOLBOX:16543
    * Utilize os usuário/senha informado no arquivo *docker-compose.yml*
        * Usuário: geia@pjc.mt.gov.br
        * Senha: hXCmfR
    * Adicione um novo servidor de banco de dados
        * Acesse o menu *Object > Create > Server*
        * Na aba *General*, informe um nome de sua escolha para conexão
        * Na aba *Connection*, informe:
            * Host Name: dbpolicia
            * Port: 5432
            * Maintenance Database: postgres
            * Username: pjcmt
            * Password: 6tBXh*Eb
        * Marque a opção *Save Password*
        * Clique em *Save*
    * A conexão estará disponível na barra lateral esquerda, sob a opção *Serves*
    * Navegue pela estrutura *Servers* até o banco *dbpolicia*
        * Servers > NOME_ESCOLHIDO_PARA_CONEXAO > Databases > dbpolicia
    * Acesse a ferramenta *Query Tool*
        * Acesse o menu *Tools > Query Tool*
    * Utilize o schema *public* para validar as informações do servidor de Banco de Dados
        * Ex: SELECT current_database() AS nome_banco, version() AS versao_banco
    * Para executar suas consultas no *Query Tool*, pressione F5   

* Acesse o MinIO através da url do host (localhost, ou o IP gerado pelo Docker Toolbox)
    * Url: localhost:9000 *OU* IP_GERADO_PELO_DOCKER_TOOLBOX:9000 
    * Utilize os usuário/senha informado no arquivo *docker-compose.yml*
        * Usuário: minio
        * Senha: 5ZhUF9Qu
    * Os buckets criados no passo **6** da etapa **1** estarão disponíveis na barra lateral esquerda, sob o campo de busca.

## Priorização do Projeto

A avaliação é composta por três etapas distintas: Preparação do ambiente (Docker), Preparação do Banco de Dados e Proposta de adoção de nova ferramenta.

A proposta de adoção (etapa 3), exige um estudo das ferramentas disponíveis para escolha de uma que melhor se adeque ao ambiente informado. O estudo será realizado em paralelo, mas será entregue ao final do projeto.

A preparação do Banco de Dados (etapa 2) faz parte das tarefas cotidianas já desenvolvidas na ocupação atual, embora com bancos não PostgreSQL (Oracle, SQLServer, IBM DB2 e MariaDB). Portando será o segundo item a ser entregue.

A criação do ambiente (etapa 1) exige um certo grau de familiaridade com Docker. Como o prazo para entrega deste projeto foi excepcional, mesmo antes da prorrogação, esta se tornou a maior prioridade de execução. Com o prazo estipulado, houve uma possibilidade de maiores testes, possibilitanto a cobertura de todos os requisitos.

### Validação dos Itens das Etapas

#### 1º Etapa

- [x] 1) Montar um ambiente utilizando Docker Compose de modo a levantar containers do PostgreSql 12, do PGAdmin 4 e do MinIO Server utilizando como sistema operacional base  qualquer distribuição Linux.
- [x] 2) Considere que o SO Linux está na rede 192.168.0.0/24
- [x] 3) Nos arquivos de configuração do PostgreSql faça as alterações necessárias de modo a permitir o acesso ao banco de dados por qualquer computador na rede.
- [ ] 4) Considerando que o sistema operacional de base do servidor PostgreSql seja o Debian 10, executando em um hardware com 32GB de RAM, 8 CPUs, 480GB de Armazenamento SSD,  realize as alterações nos arquivos de configuração do PostgreSql para que trabalhe com a melhor performance e segurança.
- [ ] 5) Considerando que você tenha um banco de dados criado no servidor PostgreSql com o nome “dbPolicia” escreva um script que realize o dump do banco de dados usando o formato “Format Custom” do PostgreSQL todos os dias às 2h para o diretório /tmp/bkp.
- [ ] 6) Utilizando o MinIO Client (mc) conecte no MinIO Server e crie um bucket pgsql-bkp;
- [ ] 7) Espelhe continuamente o diretório /tmp/bkp com os dump’s do item 5 para o MinIO;
- [ ] 8) Use as ferramentas e soluções que achar necessário.

#### 2º Etapa

- [ ] 1) Construa um script SQL (projeto físico) para criar e popular um banco de dados que deverá ser nominado de conveniencia;
- [ ] 2) Construa um script que faça a inserção de pelo menos 3 registros em cada tabela;
- [ ] 3) A tabela venda necessita de algum recurso de segurança e auditoria. Crie um tabela venda_auditoria e para cada operação de insert, update ou delete na tabela venda  haja a inserção de cópia dos registros na tabela vendas_auditoria. Para isso será necessário criar uma trigger para a tabela venda;
- [ ] 4) Crie uma view materializada que liste os cliente e os estilos de cerveja que costuma comprar (exibir nome do cliente e nome do estilo);
- [ ] 5) Considerando que este banco de dados contém centenas de milhares de registros, escreva um script criando os índices necessários para melhorar a performance de eventuais consultas;
- [ ] 6) Crie um usuário usr_relatorio para o banco de dados conveniência;
- [ ] 7) Revogar toda e qualquer permissão relativa ao usr_relatorio;
- [ ] 8) Conceder permissão o usr_relatorio conectar-se no banco de dados conveniencia e realizar a leitura somente da view criada no item 4 e da tabela de auditoria criada  no item 3;
- [ ] 9) Escreva uma sentença SQL que exiba uma lista das cervejas vendidas ordenadas primeiramente pela quantidade de vendas. É imprescindível que nesta lista apareça as cervejas que não tiveram vendas realizadas com o numeral zero;
- [ ] 10) Escreva uma sentença SQL que exiba uma lista da quantidade de vendas realizadas pelos usuários por mês no corrente ano (Retornar nome do usuário, ano da venda, mês  da venda, quantidade vendida);
- [ ] 11) Escreva uma sentença SQL que exiba quanto de comissão em valores recebeu o primeiro usuário cadastrado em sua base de dados (normalmente com id 1) em razão das  vendas que realizou.

#### 3º Etapa

- [ ] 1) Considerando um alto volume de dados binários produzidos por inúmeros sistemas hoje em dia, em especial no formato PDF natos ou transformados com recursos de OCR, verifica-se a necessidade de se implantar recursos de indexação de conteúdo desses documentos de modo a facilitar as buscas.
- [ ] 2) Escreva um documento fazendo uma proposta de adoção de alguma solução Open Source para esta finalidade descrevendo os prós e contras, recursos necessários, etapas da implantação e resultados esperados da solução proposta.

## Sobre as Imagens Utilizadas (Docker)

* [dpage/pgadmin4](https://hub.docker.com/_/postgres) - Imagem Oficial do pgAdmin 4.
* [minio/minio](https://hub.docker.com/r/minio/minio) - Para execução do MinIO Server. Criação de instâncias distribuídas conforme documentação oficial do [MinIO](https://docs.min.io/docs/deploy-minio-on-docker-compose.html).
    * [nginx](https://hub.docker.com/_/nginx) - Imagem Oficial do Nginx (servidor de HTTP). Utilizado para realização do balanceamento de carga nos servidores distribuídos do MinIO.
* [postgres](https://hub.docker.com/_/postgres) - Imagem Oficial do PostgreSQL 12.

## Acesso Rápido

### MinIO Server
* **Nome Servidor**: nginx
* **Porta**: 9000
* **Usuário**: minio
* **Senha**: 5ZhUF9Qu

### PGAdmin
* **Nome Servidor**: dbadmin
* **Porta**: 16543
* **Usuário**: geia@pjc.mt.gov.br
* **Senha**: hXCmfR

### Postgres
* **Nome Servidor**: dbpolicia
* **Porta**: 5432
* **Usuário**: pjcmt
* **Senha**: 6tBXh*Eb