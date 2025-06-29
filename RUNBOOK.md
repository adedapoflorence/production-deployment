# RUNBOOK for FastAPI Service.

This runbook provides detailed steps for Deployment,Monitoring, Scaling, Troubleshooting, and Rolling back the service.

---

##Service Summary

- Service Name: FastAPI Service
- Purpose: Exposes CRUD endpoints and health checks via REST API
- Deployment Platform: Kubernetes (Namespace: `production`)
- CI/CD: GitHub Actions
- Observability: Prometheus and Grafana
- Security: NetworkPolicies, Pod Security Admission, RBAC

---

##Deployment

##CI/CD Pipeline (GitHub Actions)

Trigger: Push to `main` branch  
Workflow: `.github/workflows/deploy.yml`  

Actions performed:
1. Builds Docker image and pushes to Docker Hub
2. Applies Kubernetes manifests to `production`
3. Performs health check
4. If health check fails → automatic rollback

##Manual Deployment

#Create secure namespace
kubectl create namespace production

#Apply K8s resources
kubectl apply -f k8s/ -n production

---
##Health Check


Manual
kubectl get pods -n production

kubectl port-forward svc/fastapi-service 8000:8000 -n production

curl http://localhost:8000/health

Automated
bash scripts/health-check.sh

Expected response
{ "status": "healthy", "timestamp": "..." }

---
##Rollback

kubectl rollout undo deployment/fastapi-service -n production

bash scripts/rollback.sh

---
Monitoring & Alerts

Prometheus
Metrics exposed at /metrics endpoint via Prometheus client

Use`prometheus.yml` for config

Grafana
Import dashboard from `monitoring/grafana-dashboard.json`

Key Metrics to Monitor:

- http_requests_total

- http_request_duration_seconds_bucket

- http_requests_total{status=~"5.."} (error rate)

Alerts
Defined in  `monitoring/alerts.yml`









