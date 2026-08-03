#!/bin/bash
# ============================================
# Script - Deploy
# ============================================
# Implantar todos os recursos no Kubernetes
# ============================================

set -e

echo "========================================="
echo " Web Solutions - Deploy"
echo "========================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Criar namespace
create_namespace() {
    echo -e "${YELLOW}Criando namespace...${NC}"
    kubectl apply -f ./kubernetes/base/namespace.yaml
    echo -e "${GREEN}Namespace criado!${NC}"
}

# Criar resource quota
create_quota() {
    echo -e "${YELLOW}Criando resource quota...${NC}"
    kubectl apply -f ./kubernetes/base/resource-quota.yaml
    echo -e "${GREEN}Resource quota criado!${NC}"
}

# Criar ConfigMaps
create_configmaps() {
    echo -e "${YELLOW}Criando ConfigMaps...${NC}"
    kubectl apply -f ./kubernetes/nginx/configmap.yaml
    kubectl apply -f ./kubernetes/apache/configmap.yaml
    echo -e "${GREEN}ConfigMaps criados!${NC}"
}

# Criar PersistentVolumes (opcional)
create_storage() {
    echo -e "${YELLOW}Criando PersistentVolumes...${NC}"
    kubectl apply -f ./kubernetes/storage/persistent-volume.yaml
    kubectl apply -f ./kubernetes/storage/persistent-volume-claim.yaml
    echo -e "${GREEN}PersistentVolumes criados!${NC}"
}

# Deploy Nginx
deploy_nginx() {
    echo -e "${YELLOW}Fazendo deploy do Nginx...${NC}"
    kubectl apply -f ./kubernetes/nginx/deployment.yaml
    kubectl apply -f ./kubernetes/nginx/service.yaml
    echo -e "${GREEN}Nginx implantado!${NC}"
}

# Deploy Apache
deploy_apache() {
    echo -e "${YELLOW}Fazendo deploy do Apache...${NC}"
    kubectl apply -f ./kubernetes/apache/deployment.yaml
    kubectl apply -f ./kubernetes/apache/service.yaml
    echo -e "${GREEN}Apache implantado!${NC}"
}

# Verificar status
check_status() {
    echo -e "${YELLOW}Verificando status do deploy...${NC}"
    kubectl get pods -n web-solutions
    kubectl get services -n web-solutions
}

# Exibir informações de acesso
show_access() {
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN} Deploy concluído com sucesso!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Serviços disponíveis:"
    echo -e "  Nginx:   ${GREEN}http://localhost:30080${NC}"
    echo -e "  Apache:  ${GREEN}http://localhost:30081${NC}"
    echo ""
    echo "Para verificar o status:"
    echo "  kubectl get pods -n web-solutions"
    echo "  kubectl get services -n web-solutions"
    echo ""
}

# Executar deploy
main() {
    create_namespace
    create_quota
    create_configmaps
    create_storage
    deploy_nginx
    deploy_apache
    check_status
    show_access
}

main "$@"
