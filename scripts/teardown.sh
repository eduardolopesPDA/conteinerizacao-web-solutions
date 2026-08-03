#!/bin/bash
# ============================================
# Script - Teardown
# ============================================
# Remove todos os recursos do Kubernetes
# ============================================

set -e

echo "========================================="
echo " Web Solutions - Teardown"
echo "========================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Confirmação
confirm() {
    read -p "Tem certeza que deseja remover todos os recursos? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operação cancelada."
        exit 1
    fi
}

# Remover serviços
remove_services() {
    echo -e "${YELLOW}Removendo services...${NC}"
    kubectl delete service nginx-service -n web-solutions --ignore-not-found
    kubectl delete service apache-service -n web-solutions --ignore-not-found
    echo -e "${GREEN}Services removidos!${NC}"
}

# Remover deployments
remove_deployments() {
    echo -e "${YELLOW}Removendo deployments...${NC}"
    kubectl delete deployment nginx-deployment -n web-solutions --ignore-not-found
    kubectl delete deployment apache-deployment -n web-solutions --ignore-not-found
    echo -e "${GREEN}Deployments removidos!${NC}"
}

# Remover ConfigMaps
remove_configmaps() {
    echo -e "${YELLOW}Removendo ConfigMaps...${NC}"
    kubectl delete configmap nginx-config -n web-solutions --ignore-not-found
    kubectl delete configmap apache-config -n web-solutions --ignore-not-found
    echo -e "${GREEN}ConfigMaps removidos!${NC}"
}

# Remover PersistentVolumeClaims
remove_pvcs() {
    echo -e "${YELLOW}Removendo PersistentVolumeClaims...${NC}"
    kubectl delete pvc nginx-pvc -n web-solutions --ignore-not-found
    kubectl delete pvc apache-pvc -n web-solutions --ignore-not-found
    echo -e "${GREEN}PersistentVolumeClaims removidos!${NC}"
}

# Remover PersistentVolumes
remove_pvs() {
    echo -e "${YELLOW}Removendo PersistentVolumes...${NC}"
    kubectl delete pv nginx-pv --ignore-not-found
    kubectl delete pv apache-pv --ignore-not-found
    echo -e "${GREEN}PersistentVolumes removidos!${NC}"
}

# Remover Resource Quota
remove_quota() {
    echo -e "${YELLOW}Removendo Resource Quota...${NC}"
    kubectl delete resourcequota web-solutions-quota -n web-solutions --ignore-not-found
    echo -e "${GREEN}Resource Quota removido!${NC}"
}

# Remover namespace
remove_namespace() {
    echo -e "${YELLOW}Removendo namespace...${NC}"
    kubectl delete namespace web-solutions --ignore-not-found
    echo -e "${GREEN}Namespace removido!${NC}"
}

# Executar teardown
main() {
    confirm
    remove_services
    remove_deployments
    remove_configmaps
    remove_pvcs
    remove_pvs
    remove_quota
    remove_namespace

    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN} Teardown concluído com sucesso!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main "$@"
