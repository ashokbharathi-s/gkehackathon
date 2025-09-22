#!/bin/bash

# Script to create Google API Key secret for Fraud Detection Agent
# This script helps you securely create the Kubernetes secret with your actual API key

set -e

echo "🔐 Creating Google API Key Secret for Fraud Detection Agent"
echo "============================================================"

# Check if API key is provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide your Google API key as an argument"
    echo ""
    echo "Usage: $0 <your-google-api-key>"
    echo ""
    echo "Example: $0 AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz"
    echo ""
    echo "📝 To get your API key:"
    echo "  1. Go to: https://console.cloud.google.com/apis/credentials"
    echo "  2. Create a new API Key or use an existing one"
    echo "  3. Enable the Generative AI API for your project"
    exit 1
fi

GOOGLE_API_KEY="$1"

echo "🔍 Validating API key format..."
if [[ ! "$GOOGLE_API_KEY" =~ ^AIza[0-9A-Za-z_-]{35}$ ]]; then
    echo "⚠️  Warning: API key format doesn't match expected pattern"
    echo "   Expected format: AIza... (39 characters total)"
    echo "   Proceeding anyway..."
fi

echo "📦 Creating Kubernetes secret..."

# Delete existing secret if it exists
kubectl delete secret fraud-detection-secrets --ignore-not-found=true

# Create the secret using kubectl
kubectl create secret generic fraud-detection-secrets \
    --from-literal=GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    --dry-run=client -o yaml | kubectl apply -f -

# Add labels to the secret
kubectl label secret fraud-detection-secrets \
    app=fraud-detection-agent \
    application=bank-of-anthos-ai \
    environment=development \
    team=ai-agents \
    --overwrite

echo "📝 Note: You can also update the base64 value directly in:"
echo "  k8s/agents/fraud-detection.yaml"
echo "  (Search for GOOGLE_API_KEY and replace with: $(echo -n "$GOOGLE_API_KEY" | base64))"

echo "✅ Secret created successfully!"
echo ""
echo "🔐 Secret details:"
kubectl get secret fraud-detection-secrets -o yaml | grep -E "name:|labels:" -A 5

echo ""
echo "🚀 Next steps:"
echo "  1. Deploy the fraud detection agent: ./k8s/agents/deploy-fraud-agent.sh"
echo "  2. Verify the deployment: kubectl get pods -l app=fraud-detection-agent"
echo "  3. Check logs: kubectl logs -l app=fraud-detection-agent -f"