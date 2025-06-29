#Production-Ready FastAPI Service

This repository contains a simple FastAPI service made production-ready with:
- Docker and multi-stage builds
- Kubernetes deployment with autoscaling and security
- GitHub Actions CI/CD pipeline
- Monitoring using Prometheus and Grafana
- Security best practices and network policies

---

#Service Overview

### Endpoints
| Method | Path       | Description              |
|--------|------------|--------------------------|
| GET    | /health    | Health check             |
| GET    | /items     | Retrieve item list       |
| POST   | /items     | Create a new item        |

---

#Project Structure

```bash
production-deployment/
├── app.py
├── requirements.txt
├── Dockerfile
├── terraform              # IaC
    ├── cluster-vpc.tf
    ├── project-cluster.tf
    ├── variable.tf
├── k8s/                     # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── networkpolicy.yaml
│   ├── hpa.yaml
│   └── serviceaccount.yaml
├── .github/workflows/       # CI/CD pipeline
│   └── deploy.yml
├── monitoring/              # Observability
│   ├── prometheus.yml
│   ├── alerts.yml
│   └── grafana-dashboard.json
├── scripts/                 # Automation
│   ├── deploy.sh
│   ├── health-check.sh
│   └── rollback.sh
├── security/                # Security policies
│   ├── pod-security.yaml
│   └── rbac.yaml
├── README.md
└── RUNBOOK.md

---
Docker Usage

# Build the image
docker build -t yourusername/fastapi-service:latest .

# Run locally
docker run -p 8000:8000 yourusername/fastapi-service:latest

---
Kubernetes Deployment

kubectl create namespace production
kubectl apply -f k8s/ -n production

---
CI/CD Pipeline

The pipeline would automatically:

- Builds and pushes the Docker image

- Apply the Kubernetes manifests

- Run a health check

- Rollback if unhealthy

Secrets required:

DOCKER_USERNAME, DOCKER_PASSWORD, KUBECONFIG

---
Security

- NetworkPolicy to restrict ingress

- Secrets stored using k8s/secret.yaml

- Namespace-level Pod Security Admission labels

- RBAC rules defined under security/rbac.yaml

---
Monitoring
Prometheus scrapes the /metrics endpoint.

kubectl apply -f monitoring/prometheus.yml
kubectl apply -f monitoring/alerts.yml



