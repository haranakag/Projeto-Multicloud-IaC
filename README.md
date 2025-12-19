# Projeto Multicloud IaC

Este repositório contém exemplos e laboratórios de Infraestrutura como Código (IaC) utilizando Terraform para provisionar recursos na Amazon Web Services (AWS) e Microsoft Azure.

O objetivo é demonstrar cenários de uso de Terraform em ambientes single-cloud e multi-cloud, incluindo o uso de módulos locais e gerenciamento de estado remoto (Remote State).

## Estrutura do Projeto

O projeto está organizado em diretórios que representam diferentes cenários ou "labs":

### AWS

*   **`AWS-VPC`**: 
    *   **Objetivo**: Criar a infraestrutura de rede base (VPC) na AWS.
    *   **Detalhes**: Configura VPC, Subnets e outros componentes de rede. O estado (`terraform.tfstate`) é armazenado remotamente no S3 para ser consumido por outros projetos.
    
*   **`AWS-VM-MOD-LOCAIS`**: 
    *   **Objetivo**: Provisionar uma instância EC2 na AWS.
    *   **Destaque**: Utiliza **módulos locais** (pasta `./network`) para modularizar a criação de recursos de rede, demonstrando boas práticas de reutilização de código.

*   **`AWS-VM-VPC-RS`**: 
    *   **Objetivo**: Provisionar uma instância EC2 na AWS em uma rede existente.
    *   **Destaque**: Utiliza **Remote State** para ler dados da VPC criada no projeto `AWS-VPC`. Isso simula um cenário real onde a equipe de aplicações consome a infraestrutura criada pela equipe de redes.

### Azure

*   **`AZURE-VNET`**: 
    *   **Objetivo**: Criar a infraestrutura de rede base (VNet) na Azure.
    *   **Detalhes**: Semelhante ao `AWS-VPC`, serve como base para outros recursos Azure.

*   **`AZURE-VM`**: 
    *   **Objetivo**: Provisionar uma Máquina Virtual na Azure.
    *   **Detalhes**: Exemplo simples de criação de VM em ambiente Azure.

### Multi-Cloud & Integrações

*   **`AWS-AZURE`**: 
    *   **Objetivo**: Cenário híbrido/multi-cloud.
    *   **Detalhes**: Configura providers para AWS e Azure no mesmo projeto. Consome estados remotos de ambas as nuvens (`aws-vpc` e `azurerm-vnet`) para provisionar recursos que podem se comunicar ou simplesmente coexistir sob a mesma gestão.

*   **`AZURE-AWS-RS`**: 
    *   **Objetivo**: Integração de estados entre nuvens.
    *   **Detalhes**: Focado na leitura de estados remotos cruzados (ex: Azure lendo outputs da AWS ou vice-versa).

## Pré-requisitos

Para executar os projetos, você precisará das seguintes ferramentas instaladas e configuradas:

1.  **Terraform** (versão >= 1.3.0): [Download](https://www.terraform.io/downloads.html)
2.  **AWS CLI** configurado (`aws configure`): [Guia de Instalação](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3.  **Azure CLI** autenticado (`az login`): [Guia de Instalação](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

> **Nota**: Você deve ter permissões adequadas em ambas as nuvens para criar recursos (VPCs, EC2, VNets, VMs, Storage Accounts, S3 Buckets).

## Configuração do Backend (Remote State)

Muitos projetos neste repositório estão configurados para usar **Remote State** (S3 para AWS, Storage Account para Azure). 

**Importante**: Antes de rodar `terraform init`, verifique os blocos `backend` nos arquivos `main.tf`. Você precisará:

1.  Criar o Bucket S3 (ex: `haranaka`) e/ou Storage Account (ex: `haranakaterraformstate`) nas suas contas.
2.  Atualizar os nomes dos buckets/containers nos arquivos `main.tf` para correponder aos seus recursos, pois nomes de buckets S3 são globais e únicos.

Exemplo de bloco que pode precisar de alteração:
```hcl
backend "s3" {
  bucket = "SEU-BUCKET-AQUI" # <--- Altere isso
  key    = "aws-vpc/terraform.tfstate"
  region = "us-east-1"
}
```

## Como Usar

Cada diretório funciona como um projeto Terraform independente. O fluxo básico é:

1.  **Navegue até o diretório do lab:**
    ```bash
    cd AWS-VM-MOD-LOCAIS
    ```

2.  **Inicialize o diretório:**
    Baixa os providers e configura o backend.
    ```bash
    terraform init
    ```

3.  **Planeje a execução:**
    Mostra o que será criado/alterado.
    ```bash
    terraform plan
    ```

4.  **Aplique a infraestrutura:**
    Cria os recursos na nuvem.
    ```bash
    terraform apply
    ```
    *(Digite `yes` quando solicitado)*

5.  **Destrua os recursos (Cleanup):**
    Para evitar cobranças indesejadas, destrua os recursos ao final do teste:
    ```bash
    terraform destroy
    ```

## Dicas Adicionais

*   **Gerar Chaves SSH**: Se o projeto criar VMs Linux (ex: `vm.tf`), você pode precisar de uma chave SSH local. Gere-a na raiz do projeto ou onde especificado:
    ```bash
    ssh-keygen -f aws-key
    ```
*   **Variáveis**: Alguns projetos possuem arquivo `variables.tf`. Você pode customizar valores criando um arquivo `terraform.tfvars` ou passando via linha de comando `-var="nome=valor"`.
