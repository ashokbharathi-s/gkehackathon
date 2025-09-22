#!/bin/bash
# Quick verification script for hackathon demo

echo "🚀 GKE Hackathon - AI Banking Intelligence Platform"
echo "=================================================="
echo ""

echo "📊 Checking fraud detection agent deployment..."
kubectl get pods -l app=fraud-detection-agent

echo ""
echo "🔍 Recent fraud detection activity:"
kubectl logs -l app=fraud-detection-agent --tail=10 --since=5m | grep -E "(FRAUD ALERT|Balance API|Transaction API|✅|🚨)"

echo ""
echo "🏗️ Agent deployment details:"
kubectl get deployment fraud-detection-agent

echo ""
echo "🌐 A2A Protocol service:"
kubectl get svc fraud-detection-agent

echo ""
echo "✅ Demo ready! Use 'kubectl logs -l app=fraud-detection-agent -f' to show live monitoring"