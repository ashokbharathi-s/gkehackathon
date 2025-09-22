#!/bin/bash

# Script to update the Google API Key in the existing secret
# This allows you to rotate or update the API key without redeploying

set -e

echo "🔄 Updating Google API Key for Fraud Detection Agent"
echo "====================================================="

# Check if API key is provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide your new Google API key as an argument"
    echo ""
    echo "Usage: $0 <your-new-google-api-key>"
    echo ""
    echo "Example: $0 AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz"
    exit 1
fi

GOOGLE_API_KEY="$1"

echo "🔍 Validating API key format..."
if [[ ! "$GOOGLE_API_KEY" =~ ^AIza[0-9A-Za-z_-]{35}$ ]]; then
    echo "⚠️  Warning: API key format doesn't match expected pattern"
    echo "   Expected format: AIza... (39 characters total)"
    echo "   Proceeding anyway..."
fi

# Check if secret exists
if ! kubectl get secret fraud-detection-secrets >/dev/null 2>&1; then
    echo "❌ Error: Secret 'fraud-detection-secrets' not found!"
    echo "   Please create it first using: ./k8s/agents/create-api-secret.sh"
    exit 1
fi

echo "🔄 Updating existing secret..."

# Update the secret
kubectl patch secret fraud-detection-secrets \
    --type='json' \
    -p='[{"op": "replace", "path": "/data/GOOGLE_API_KEY", "value": "'$(echo -n "$GOOGLE_API_KEY" | base64)'"}]'

echo "✅ API key updated successfully!"
echo ""
echo "🔄 Restarting fraud detection pods to pick up new key..."
kubectl rollout restart deployment/fraud-detection-agent

echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment/fraud-detection-agent

echo "🎉 API key update complete!"
echo ""
echo "📊 Verify the update:"
echo "  kubectl logs -l app=fraud-detection-agent --tail=10"