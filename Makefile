# ============================================
# Makefile - Web Solutions
# ============================================
# Comandos automatizados para o projeto
# ============================================

.PHONY: help setup build deploy teardown test status logs clean

# Cores
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m

# Default target
help:
	@echo ""
	@echo "$(GREEN)Web Solutions - Comandos Disponíveis:$(NC)"
	@echo ""
	@echo "  make setup      - Configura o ambiente (pré-requisitos + build)"
	@echo "  make build      - Constói as imagens Docker"
	@echo "  make deploy     - Implantar no Kubernetes"
	@echo "  make teardown   - Remove todos os recursos"
	@echo "  make test       - Executa testes de conectividade"
	@echo "  make status     - Mostra status dos pods e services"
	@echo "  make logs-nginx - Mostra logs do Nginx"
	@echo "  make logs-apache- Mostra logs do Apache"
	@echo "  make clean      - Remove imagens Docker"
	@echo "  make port-forward- Acessa pods via port-forward"
	@echo ""

# Setup completo
setup:
	@echo "$(YELLOW)Executando setup...$(NC)"
	@chmod +x scripts/*.sh
	@./scripts/setup.sh

# Build das imagens Docker
build:
	@echo "$(YELLOW)Construindo imagens Docker...$(NC)"
	docker build -t nginx-web-solutions:latest ./docker/nginx
	docker build -t apache-web-solutions:latest ./docker/apache
	@echo "$(GREEN)Imagens construídas!$(NC)"

# Deploy no Kubernetes
deploy:
	@echo "$(YELLOW)Fazendo deploy...$(NC)"
	@./scripts/deploy.sh

# Teardown
teardown:
	@echo "$(YELLOW)Removendo recursos...$(NC)"
	@./scripts/teardown.sh

# Testes
test:
	@echo "$(YELLOW)Executando testes...$(NC)"
	@./scripts/test.sh

# Status
status:
	@echo "$(YELLOW)Status dos recursos:$(NC)"
	@echo ""
	@echo "=== Pods ==="
	@kubectl get pods -n web-solutions
	@echo ""
	@echo "=== Services ==="
	@kubectl get services -n web-solutions
	@echo ""
	@echo "=== PersistentVolumes ==="
	@kubectl get pv
	@echo ""

# Logs Nginx
logs-nginx:
	@echo "$(YELLOW)Logs do Nginx:$(NC)"
	@kubectl logs -l app=nginx -n web-solutions -f

# Logs Apache
logs-apache:
	@echo "$(YELLOW)Logs do Apache:$(NC)"
	@kubectl logs -l app=apache -n web-solutions -f

# Port forward para teste local
port-forward:
	@echo "$(YELLOW)Iniciando port-forward...$(NC)"
	@echo "Nginx: http://localhost:8080"
	@echo "Apache: http://localhost:8081"
	@kubectl port-forward -n web-solutions service/nginx-service 8080:80 &
	@kubectl port-forward -n web-solutions service/apache-service 8081:80 &

# Limpar imagens Docker
clean:
	@echo "$(YELLOW)Removendo imagens Docker...$(NC)"
	@docker rmi nginx-web-solutions:latest 2>/dev/null || true
	@docker rmi apache-web-solutions:latest 2>/dev/null || true
	@echo "$(GREEN)Imagens removidas!$(NC)"

# Reiniciar pods
restart:
	@echo "$(YELLOW)Reiniciando pods...$(NC)"
	@kubectl rollout restart deployment nginx-deployment -n web-solutions
	@kubectl rollout restart deployment apache-deployment -n web-solutions
	@echo "$(GREEN)Pods reiniciados!$(NC)"

# Escalar Nginx
scale-nginx:
	@echo "$(YELLOW)Escalando Nginx...$(NC)"
	@read -p "Número de réplicas: " replicas; \
	kubectl scale deployment nginx-deployment --replicas=$$replicas -n web-solutions
	@echo "$(GREEN)Nginx escalado!$(NC)"

# Escalar Apache
scale-apache:
	@echo "$(YELLOW)Escalando Apache...$(NC)"
	@read -p "Número de réplicas: " replicas; \
	kubectl scale deployment apache-deployment --replicas=$$replicas -n web-solutions
	@echo "$(GREEN)Apache escalado!$(NC)"
