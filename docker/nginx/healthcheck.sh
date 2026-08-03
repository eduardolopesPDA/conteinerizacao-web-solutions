#!/bin/sh
# ============================================
# Health Check Script - Nginx
# ============================================

wget -q --spider http://localhost:80/healthz || exit 1
