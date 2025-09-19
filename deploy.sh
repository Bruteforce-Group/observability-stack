#!/bin/bash

# Full Observability Stack Deployment Script
set -e

STACK_NAME="observability-stack"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Deploying Full Observability Stack"
echo "======================================"

# Create necessary directories
echo "📁 Creating required directories..."
mkdir -p prometheus/rules
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/dashboards
mkdir -p loki
mkdir -p promtail
mkdir -p tempo
mkdir -p otel
mkdir -p alertmanager

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install it first."
    exit 1
fi

# Deploy the stack
echo "🐳 Deploying containers..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Health checks
echo "🔍 Performing health checks..."

check_service() {
    local service=$1
    local url=$2
    local name=$3
    
    echo -n "Checking $name... "
    if curl -f -s "$url" > /dev/null; then
        echo "✅ OK"
        return 0
    else
        echo "❌ FAILED"
        return 1
    fi
}

# Service health checks
check_service "prometheus" "http://localhost:9090/-/healthy" "Prometheus"
check_service "grafana" "http://localhost:3000/api/health" "Grafana"
check_service "loki" "http://localhost:3100/ready" "Loki"
check_service "tempo" "http://localhost:3200/ready" "Tempo"
check_service "alertmanager" "http://localhost:9093/-/healthy" "AlertManager"
check_service "node-exporter" "http://localhost:9100/metrics" "Node Exporter"
check_service "cadvisor" "http://localhost:8080/healthz" "cAdvisor"
check_service "jaeger" "http://localhost:16686/" "Jaeger"
check_service "otel-collector" "http://localhost:13133/" "OpenTelemetry Collector"

echo ""
echo "🎉 Deployment Complete!"
echo "======================"
echo ""
echo "📊 Access your observability stack:"
echo "  • Grafana (Dashboards):     http://localhost:3000 (admin/admin123)"
echo "  • Prometheus (Metrics):     http://localhost:9090"
echo "  • AlertManager (Alerts):    http://localhost:9093"
echo "  • Jaeger (Tracing):         http://localhost:16686"
echo "  • cAdvisor (Containers):    http://localhost:8080"
echo ""
echo "📈 Monitoring endpoints:"
echo "  • Node Exporter:            http://localhost:9100/metrics"
echo "  • Loki (Logs):              http://localhost:3100"
echo "  • Tempo (Traces):           http://localhost:3200"
echo "  • OpenTelemetry Collector:  http://localhost:13133"
echo ""
echo "🔧 Configuration files created in:"
echo "  • Prometheus config:        ./prometheus/prometheus.yml"
echo "  • Alert rules:              ./prometheus/rules/alerts.yml"
echo "  • Grafana datasources:      ./grafana/provisioning/datasources/"
echo "  • Loki config:              ./loki/loki-config.yml"
echo "  • Promtail config:          ./promtail/promtail-config.yml"
echo "  • Tempo config:             ./tempo/tempo-config.yml"
echo "  • OTEL config:              ./otel/otel-config.yml"
echo "  • AlertManager config:      ./alertmanager/alertmanager.yml"
echo ""
echo "📚 Next steps:"
echo "  1. Login to Grafana and import dashboards"
echo "  2. Configure AlertManager with your email/Slack settings"
echo "  3. Customize alert rules in prometheus/rules/alerts.yml"
echo "  4. Add application-specific exporters as needed"
echo ""
echo "🛑 To stop the stack: docker-compose down"
echo "🗑️  To remove volumes: docker-compose down -v"

# Show running containers
echo ""
echo "🐳 Running containers:"
docker-compose ps
