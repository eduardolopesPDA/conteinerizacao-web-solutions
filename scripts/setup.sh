#!/bin/bash
# ============================================
# Script - Setup Inicial
# ============================================
# Configura o ambiente completo
# ============================================

set -e

echo "========================================="
echo " Web Solutions - Setup Inicial"
echo "========================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Verificar pré-requisitos
check_prerequisites() {
    echo -e "${YELLOW}Verificando pré-requisitos...${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker não encontrado. Instale o Docker primeiro.${NC}"
        exit 1
    fi

    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}kubectl não encontrado. Instale o kubectl primeiro.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Pré-requisitos verificados com sucesso!${NC}"
}

# Verificar se Docker está rodando
check_docker() {
    echo -e "${YELLOW}Verificando se Docker está rodando...${NC}"

    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker não está rodando. Inicie o Docker primeiro.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Docker está rodando!${NC}"
}

# Verificar se Kubernetes está rodando
check_kubernetes() {
    echo -e "${YELLOW}Verificando se Kubernetes está rodando...${NC}"

    if ! kubectl cluster-info &> /dev/null; then
        echo -e "${RED}Kubernetes não está rodando. Inicie o cluster primeiro.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Kubernetes está rodando!${NC}"
}

# Build das imagens Docker
build_images() {
    echo -e "${YELLOW}Construindo imagens Docker...${NC}"

    echo "Construindo nginx-web-solutions..."
    docker build -t nginx-web-solutions:latest ./docker/nginx

    echo "Construindo apache-web-solutions..."
    docker build -t apache-web-solutions:latest ./docker/apache

    echo -e "${GREEN}Imagens construídas com sucesso!${NC}"
}

# Executar setup
main() {
    check_prerequisites
    check_docker
    check_kubernetes
    build_images

    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN} Setup concluído com sucesso!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Próximo passo: Execute './scripts/deploy.sh'"
}

main "$@"
