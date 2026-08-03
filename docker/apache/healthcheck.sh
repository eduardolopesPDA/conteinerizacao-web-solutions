#!/bin/sh
# ============================================
# Health Check Script - Apache HTTPD
# ============================================

wget -q --spider http://localhost:80/ || exit 1
