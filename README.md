# Atividade_Linux_PB
Repositório destinado à atividade prática de Linux (Programa de Bolsas - AWS e DevSecOps).

## Requisitos AWS:
* Geração de uma chave pública para acesso ao ambiente;
* Criação de uma instância EC2 com o sistema operacional Amazon Linux 2:
    * Família t3.small;
    * Volume de 16 GB SSD
* Geração de um Elastic IP e sua associação à instância EC2;
* Liberação das portas de comunicação para acesso público:
    * 22/TCP;
    * 111 TCP/UDP;
    * 2049 TCP/UDP;
    * 80/TCP;
    * 443/TCP.

## Requisitos Linux:
* Configuração do NFS entregue;
* Criação de um diretório dentro do filesystem do NFS com seu nome;
* Subida de um Apache no servidor - o Apache deve estar online e rodando;
* Criação de um script que valide se o serviço está online e envie o resultado da validação para o seu diretório no NFS;
* O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou OFFLINE;
* O script deve gerar dois arquivos de saída: um para o serviço ONLINE e um para o serviço OFFLINE;
* Preparação da execução automatizada do script a cada cinco minutos.

## Passos de execução

### Geração da chave pública para acesso na AWS
* Acesso ao serviço EC2 na AWS e à opção "Pares de chaves" relacionada ao tópico Rede e segurança;
* Criação de um par de chaves de nome "chave_execucao";
* Download do arquivo com a extensão `.pem` para acesso posterior.

### Criação de uma instância EC2
* Acesso ao serviço EC2 na AWS e à opção "Instâncias" relacionada ao tópico Instâncias;
* Configuração de uma instância EC2 através da opção "Executar instância" com os seguintes critérios de seleção:
    * Tags da instância para instâncias e volumes (Name, CostCenter e Project);
    * Seleção da imagem de máquina da Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type;
    * Seleção do tipo de instância t3.small;
    * Seleção do par de chaves criado anteriormente (chave_execucao);
    * Seleção de uma VPC principal criada no momento da criação da instância;
    * Seleção de armazenamento de 16GB gp2 (SSD);
    * Execução da instância através da opção "Executar instância".
	
### Alocação de um Elastic IP à instância EC2
* Acesso ao serviço EC2 na AWS e à opção "IPs elásticos" relacionada ao tópico Rede e segurança;
* Configuração de um endereço Elastic IP através da opção "Alocar endereço IP elástico";
* Associação do Elastic IP alocado com a instância EC2 criada anteriormente através das opções "Ações" > "Associar endereço IP elástico".

### Configuração das regras de segurança (Liberação das portas de comunicação)
* Acesso ao serviço EC2 na AWS e à opção "Grupos de segurança" relacionada ao tópico Rede e segurança;
* Seleção do grupo de segurança associado à instância EC2 criada anteriormente;
* Configuração das regras de entrada do grupo através da opção "Editar regras de entrada", adicionando as seguintes regras referentes à liberação das portas:
    * SSH             - TCP - Porta  22  - 0.0.0.0/0 ssh;
    * TCP personalizado TCP - Porta  80  - 0.0.0.0/0 http;
    * TCP personalizado TCP - Porta 443  - 0.0.0.0/0 https;
    * TCP personalizado TCP - Porta 111  - 0.0.0.0/0 rpc;
    * UDP personalizado UDP - Porta 111  - 0.0.0.0/0 rpc;
    * TCP personalizado TCP - Porta 2049 - 0.0.0.0/0 nfs;
    * UDP personalizado UDP - Porta 2049 - 0.0.0.0/0 nfs.

### Configuração do NFS:
* Acesso à instância EC2 através de SSH com o comando: `ssh -i /path/chave_execucao.pem ec2-user@[IP_público_da_instância]`;
* Criação de um diretório para o NFS usando os comandos (alteração da permissão): `sudo mkdir /mnt/nfs` e `sudo chmod 777 /mnt/nfs`;
* Configuração dos serviços necessários para o funcionamento do NFS usando os comandos:  
  `sudo systemctl enable rcpbind`;  
  `sudo systemctl enable nfs-server`;  
  `sudo systemctl enable nfs-lock`;  
  `sudo systemctl enable nfs-idmap`;  
  `sudo systemctl start rpcbind`;  
  `sudo systemctl start nfs-server`;  
  `sudo systemctl start nfs-lock`;  
  `sudo systemctl start nfs-idmap`;  
* Criação de um diretório com o nome do usuário através do comando: `sudo mkdir /mnt/nfs/bianca`.

### Configuração do servidor Apache
* Atualização do sistema através do comando: `sudo yum update -y`;
* Instalação do Apache através do comando: `sudo yum install httpd -y;`
* Inicialização do Apache através do comando: `sudo systemctl start httpd`;
* Configuração da inicialização automática do Apache através do comando: `sudo systemctl enable httpd`;
* Testes de verificação do status e interrupção do Apache através dos comandos, respectivamente: `sudo systemctl status httpd` e `sudo systemctl stop httpd`.

### Configuração do script de validação
* Criação de um arquivo de script através do comando: `nano validacao.sh`;
* Configuração do arquivo de script com as linhas de código disponível no arquivo `validacao.sh` deste repositório;
* Execução do arquivo de script através do comando: `chmod +x validacao.sh`;
* Execução do script executável através do comando: `./validacao.sh`.

### Configuração da execução automática do script a cada 5 minutos (utilizando crontab)
* Configuração do cronjob através do comando: `crontab -e`;
* Inserção da seguinte linha de código no arquivo de cronjob: `*/5 * * * * /home/ec2-user/validacao.sh`;
* Verificação da veracidade do cronjob através do comando: `crontab -l`.
* Verificação dos arquivos gerados na pasta `/mnt/nfs/bianca` através dos comandos: `cat /mnt/nfs/bianca/online.txt` ou `cat /mnt/nfs/bianca/offline.txt`.
