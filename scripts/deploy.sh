#!/bin/bash
set -e

echo "Deploying FastAPI service to Kubernetes"
kubectl apply -f k8s/

