#!/bin/bash

# Deploy Fraud Detection Agent to GKE
# This script applies the ConfigMap, Secrets, and deployment manifests

set -e

echo "🚀 Deploying Fraud Detection Agent to GKE..."

# Check if secrets exist
if ! kubectl get secret fraud-detection-secrets >/dev/null 2>&1; then
    echo "❌ Error: Secret 'fraud-detection-secrets' not found!"
    echo "   Please create the API key secret first:"
    echo "   ./k8s/agents/create-api-secret.sh <your-google-api-key>"
    exit 1
fi

# Apply all resources from the consolidated manifest
echo "🏗️ Applying all resources (ConfigMap, Secret, Deployment, Service, HPA, PDB)..."
kubectl apply -f k8s/agents/fraud-detection.yaml

# Verify secrets are properly configured
echo "🔐 Verifying Secrets..."
kubectl get secret fraud-detection-secrets -o jsonpath='{.data.GOOGLE_API_KEY}' | base64 -d | cut -c1-10
echo "... (API key confirmed)"

# Wait a moment for resources to be ready
sleep 2

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/fraud-detection-agent

# Show status
echo "✅ Deployment complete! Checking status..."
kubectl get pods -l app=fraud-detection-agent
kubectl get svc fraud-detection-agent
kubectl get hpa fraud-detection-agent-hpa
kubectl get pdb fraud-detection-agent-pdb

echo "🎉 Fraud Detection Agent deployed successfully!"
echo ""
echo "🔐 Security Configuration:"
echo "  ✅ API key stored in Kubernetes Secret"
echo "  ✅ Non-sensitive config in ConfigMap"
echo ""
echo "📊 To monitor the agent:"
echo "  kubectl logs -l app=fraud-detection-agent -f"
echo ""
echo "🔍 To test the agent:"
echo "  kubectl port-forward svc/fraud-detection-agent 8080:80"
echo "  curl http://localhost:8080/health"