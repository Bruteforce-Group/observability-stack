# Full Observability Stack

A comprehensive Docker-based observability stack including monitoring, logging, tracing, and alerting capabilities.

## 🏗️ Stack Components

### Core Monitoring
- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization and dashboards
- **AlertManager** - Alert routing and notifications
- **Node Exporter** - Host system metrics
- **cAdvisor** - Container metrics

### Logging
- **Loki** - Log aggregation and storage
- **Promtail** - Log collection agent

### Distributed Tracing
- **Tempo** - Distributed tracing backend
- **Jaeger** - Tracing UI and query interface
- **OpenTelemetry Collector** - Telemetry data collection

### Optional Exporters
- **PostgreSQL Exporter** - Database metrics
- **Redis Exporter** - Redis metrics
- **NGINX Exporter** - Web server metrics

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Linux server with appropriate ports available
- Minimum 4GB RAM, 2 CPU cores recommended

### Installation

1. **Clone or download the configuration files to your server**
   ```bash
   # Create the observability stack directory
   mkdir -p /opt/observability-stack
   cd /opt/observability-stack
   
   # Copy all the configuration files here
   ```

2. **Make the deployment script executable**
   ```bash
   chmod +x deploy.sh
   ```

3. **Deploy the stack**
   ```bash
   ./deploy.sh
   ```

4. **Access the interfaces**
   - Grafana: http://your-server:3000 (admin/admin123)
   - Prometheus: http://your-server:9090
   - AlertManager: http://your-server:9093
   - Jaeger: http://your-server:16686

## 📊 Service Ports

| Service | Port | Purpose |
|---------|------|---------|
| Grafana | 3000 | Web UI |
| Prometheus | 9090 | Metrics & Web UI |
| AlertManager | 9093 | Alert Management |
| Loki | 3100 | Log Ingestion |
| Tempo | 3200 | Trace Ingestion |
| cAdvisor | 8080 | Container Metrics |
| Node Exporter | 9100 | Host Metrics |
| Jaeger | 16686 | Tracing UI |
| OTEL Collector | 4317/4318 | OTLP Receivers |

## 🔧 Configuration

### Prometheus Targets
Edit `prometheus/prometheus.yml` to add custom scrape targets:
```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['my-app:8080']
```

### Alert Rules
Add custom alert rules to `prometheus/rules/alerts.yml`:
```yaml
groups:
- name: my-app.rules
  rules:
  - alert: MyAppDown
    expr: up{job="my-app"} == 0
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "My application is down"
```

### Log Collection
Modify `promtail/promtail-config.yml` to collect additional logs:
```yaml
scrape_configs:
  - job_name: my-app-logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: my-app
          __path__: /var/log/my-app/*.log
```

### Alerting Channels
Configure `alertmanager/alertmanager.yml` with your notification channels:

```yaml
receivers:
- name: 'email-alerts'
  email_configs:
  - to: 'admin@yourcompany.com'
    from: 'alerts@yourcompany.com'
    smarthost: 'smtp.yourcompany.com:587'
    auth_username: 'alerts@yourcompany.com'
    auth_password: 'your-password'

- name: 'slack-alerts'
  slack_configs:
  - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
    channel: '#alerts'
```

## 📈 Grafana Dashboards

### Pre-built Dashboard IDs (Import from grafana.com)
- **Node Exporter Full**: 1860
- **Docker Container & Host Metrics**: 10619
- **Prometheus Stats**: 2
- **cAdvisor exporter**: 14282
- **Loki Dashboard**: 13639

### Import Process
1. Login to Grafana (admin/admin123)
2. Go to "+" → Import
3. Enter dashboard ID
4. Configure data source (usually "Prometheus")
5. Import

## 🔍 Application Instrumentation

### OpenTelemetry Integration
Send traces to the collector:
- **OTLP gRPC**: `http://your-server:4317`
- **OTLP HTTP**: `http://your-server:4318`
- **Jaeger gRPC**: `http://your-server:14250`
- **Jaeger HTTP**: `http://your-server:14268`
- **Zipkin**: `http://your-server:9411`

### Example: Instrumenting a Python App
```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

trace.set_tracer_provider(TracerProvider())
otlp_exporter = OTLPSpanExporter(endpoint="http://your-server:4317", insecure=True)
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)
```

### Example: Prometheus Metrics in Python
```python
from prometheus_client import Counter, Histogram, start_http_server

REQUEST_COUNT = Counter('app_requests_total', 'Total app requests')
REQUEST_DURATION = Histogram('app_request_duration_seconds', 'Request duration')

# Start metrics server
start_http_server(8080)
```

## 🗄️ Database Monitoring

### PostgreSQL
1. Uncomment postgres-exporter service in docker-compose.yml
2. Update the DATA_SOURCE_NAME environment variable
3. Redeploy: `docker-compose up -d postgres-exporter`

### Redis
1. Uncomment redis-exporter service
2. Update REDIS_ADDR environment variable
3. Redeploy: `docker-compose up -d redis-exporter`

## 🔒 Security Considerations

### Production Setup
- Change default Grafana password
- Use environment variables for sensitive configuration
- Enable TLS/HTTPS for all services
- Implement proper network segmentation
- Set up authentication for Prometheus and other services

### Example: Securing Grafana
```yaml
environment:
  - GF_SECURITY_ADMIN_PASSWORD_FILE=/run/secrets/grafana_admin_password
  - GF_SERVER_CERT_FILE=/etc/ssl/certs/grafana.crt
  - GF_SERVER_CERT_KEY=/etc/ssl/private/grafana.key
```

## 🛠️ Maintenance

### Backup Important Data
```bash
# Backup Grafana dashboards and settings
docker exec grafana grafana-cli admin export-dashboard > grafana-backup.json

# Backup Prometheus data (if needed)
docker run --rm -v observability-stack_prometheus_data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz /data
```

### Update Services
```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose up -d
```

### View Logs
```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f prometheus
docker-compose logs -f grafana
```

### Resource Usage
```bash
# Monitor resource usage
docker stats

# Check disk usage
docker system df
```

## 🚨 Troubleshooting

### Common Issues

1. **Services not starting**
   ```bash
   docker-compose ps
   docker-compose logs [service-name]
   ```

2. **Prometheus targets down**
   - Check service connectivity
   - Verify port configurations
   - Check firewall rules

3. **Grafana data source connection issues**
   - Verify service names in datasource URLs
   - Check if services are on the same network
   - Test connectivity from Grafana container

4. **High resource usage**
   - Adjust retention periods in configurations
   - Limit scrape intervals
   - Monitor volume sizes

### Performance Tuning

1. **Prometheus**
   - Adjust `scrape_interval` based on needs
   - Configure appropriate `retention.time`
   - Use recording rules for expensive queries

2. **Loki**
   - Configure log retention policies
   - Optimize chunk and index settings
   - Use appropriate compression

## 📚 Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Grafana Dashboard Library](https://grafana.com/grafana/dashboards/)

## 🤝 Support

For issues and improvements:
1. Check service logs first
2. Verify configuration files
3. Ensure all services are running
4. Check network connectivity between services

---

**Happy Monitoring!** 🎉
