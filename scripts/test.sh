#!/bin/bash
# ============================================
# Script - Testes
# ============================================
# Verificar se os serviços estão funcionando
# ============================================

set -e

echo "========================================="
echo " Web Solutions - Testes"
echo "========================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Testar Nginx
test_nginx() {
    echo -e "${YELLOW}Testando Nginx...${NC}"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:30080)

    if [ "$RESPONSE" -eq 200 ]; then
        echo -e "${GREEN}✓ Nginx está respondendo na porta 30080${NC}"
        return 0
    else
        echo -e "${RED}✗ Nginx não está respondendo (HTTP $RESPONSE)${NC}"
        return 1
    fi
}

# Testar Apache
test_apache() {
    echo -e "${YELLOW}Testando Apache...${NC}"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:30081)

    if [ "$RESPONSE" -eq 200 ]; then
        echo -e "${GREEN}✓ Apache está respondendo na porta 30081${NC}"
        return 0
    else
        echo -e "${RED}✗ Apache não está respondendo (HTTP $RESPONSE)${NC}"
        return 1
    fi
}

# Testar Pods
test_pods() {
    echo -e "${YELLOW}Verificando pods...${NC}"

    READY_PODS=$(kubectl get pods -n web-solutions -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' | grep -o "True" | wc -l)
    TOTAL_PODS=$(kubectl get pods -n web-solutions --no-headers | wc -l)

    echo -e "Pods prontos: ${GREEN}$READY_PODS${NC} / $TOTAL_PODS"

    if [ "$READY_PODS" -eq "$TOTAL_PODS" ]; then
        return 0
    else
        return 1
    fi
}

# Testar Services
test_services() {
    echo -e "${YELLOW}Verificando services...${NC}"
    kubectl get services -n web-solutions
}

# Executar todos os testes
main() {
    echo ""
    test_pods
    test_services
    echo ""
    test_nginx
    test_apache
    echo ""

    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN} Testes concluídos!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main "$@"
