# Web Solutions - Conteinerização e Orquestração

## Visão Geral

Projeto de prova de conceito para modernização da infraestrutura da **Web Solutions Ltda.** utilizando Docker e Kubernetes.

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    CLUSTER KUBERNETES                        │
│                                                              │
│  ┌──────────────────┐        ┌──────────────────┐           │
│  │   Nginx (:80)    │        │   Apache (:80)   │           │
│  │   Porta 8080     │        │   Porta 8081     │           │
│  └────────┬─────────┘        └────────┬─────────┘           │
│           │                           │                      │
│  ┌────────┴─────────┐        ┌────────┴─────────┐           │
│  │ nginx-service    │        │ apache-service   │           │
│  │ NodePort: 30080  │        │ NodePort: 30081  │           │
│  └──────────────────┘        └──────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes](https://kubernetes.io/docs/setup/) (Minikube, Kind ou cluster real)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Estrutura do Projeto

```
conteinerizacao-web-solutions/
├── docker/                    # Imagens Docker
│   ├── nginx/                 # Nginx + configuração
│   └── apache/                # Apache + configuração
├── kubernetes/                # Manifestos K8s
│   ├── base/                  # Namespace e quotas
│   ├── nginx/                 # Deployment + Service Nginx
│   ├── apache/                # Deployment + Service Apache
│   └── storage/               # PersistentVolumes
├── scripts/                   # Scripts auxiliares
├── tests/                     # Testes
├── docs/                      # Documentação
├── Makefile                   # Comandos automatizados
└── README.md                  # Este arquivo
```

## Início Rápido

### 1. Setup

```bash
# Opção 1: Usando Make
make setup

# Opção 2: Usando scripts
chmod +x scripts/*.sh
./scripts/setup.sh
```

### 2. Build das Imagens

```bash
# Opção 1: Usando Make
make build

# Opção 2: Manual
docker build -t nginx-web-solutions:latest ./docker/nginx
docker build -t apache-web-solutions:latest ./docker/apache
```

### 3. Deploy

```bash
# Opção 1: Usando Make
make deploy

# Opção 2: Usando scripts
./scripts/deploy.sh

# Opção 3: Manual
kubectl apply -f ./kubernetes/base/namespace.yaml
kubectl apply -f ./kubernetes/base/resource-quota.yaml
kubectl apply -f ./kubernetes/nginx/
kubectl apply -f ./kubernetes/apache/
```

### 4. Verificar

```bash
# Status
make status

# Testes
make test

# Logs
make logs-nginx
make logs-apache
```

## Acesso

| Serviço | URL |
|---------|-----|
| Nginx | http://localhost:30080 |
| Apache | http://localhost:30081 |

## Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `make setup` | Configura o ambiente |
| `make build` | Constói imagens Docker |
| `make deploy` | Implantar no Kubernetes |
| `make teardown` | Remove todos os recursos |
| `make test` | Executa testes |
| `make status` | Mostra status |
| `make logs-nginx` | Logs do Nginx |
| `make logs-apache` | Logs do Apache |
| `make restart` | Reinicia pods |
| `make scale-nginx` | Escala Nginx |
| `make scale-apache` | Escala Apache |
| `make clean` | Remove imagens |

## Portas

| Componente | Porta Interna | Porta Externa |
|------------|---------------|---------------|
| Nginx Container | 80 | - |
| Apache Container | 80 | - |
| nginx-service | 80 | 30080 |
| apache-service | 80 | 30081 |

## Solução de Problemas

### Pods não estão prontos

```bash
kubectl describe pod <pod-name> -n web-solutions
kubectl logs <pod-name> -n web-solutions
```

### Services não estão acessíveis

```bash
kubectl get endpoints -n web-solutions
kubectl describe service nginx-service -n web-solutions
```

### Erro de imagem

```bash
docker images | grep web-solutions
kubectl get pods -n web-solutions -o wide
```

## Limpeza

```bash
# Opção 1: Usando Make
make teardown

# Opção 2: Usando scripts
./scripts/teardown.sh

# Opção 3: Manual
kubectl delete namespace web-solutions
kubectl delete pv nginx-pv apache-pv
```

## Documentação

- [Relatório de Análise](docs/relatorio-analise.md)
- [Arquitetura](docs/arquitetura.md)


## Tecnologias

- **Docker** - Containerização
- **Kubernetes** - Orquestração
- **Nginx** - Servidor web reverso
- **Apache HTTPD** - Servidor web
- **Alpine Linux** - Base das imagens


---

Este projeto é de propriedade intelectual minha!!
