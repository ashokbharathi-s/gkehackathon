# Fraud Detection Agent - Kubernetes Deployment

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `fraud-detection.yaml` | **Complete Kubernetes manifest** (ConfigMap, Secret, Deployment, Service, HPA, PDB) |
| `create-api-secret.sh` | Script to create/update Google API key secret |
| `deploy-fraud-agent.sh` | Deploy the complete fraud detection service |
| `update-api-key.sh` | Update existing API key without redeployment |
| `README-security.md` | Detailed security configuration guide |

## 🚀 Quick Deployment

1. **Set your Google API Key:**
   ```bash
   ./create-api-secret.sh YOUR_GOOGLE_API_KEY
   ```

2. **Deploy the service:**
   ```bash
   ./deploy-fraud-agent.sh
   ```

3. **Verify deployment:**
   ```bash
   kubectl get pods -l app=fraud-detection-agent
   ```

## 📦 What Gets Deployed

The `fraud-detection.yaml` contains:

- **ConfigMap**: Non-sensitive configuration (project ID, API URLs, thresholds)
- **Secret**: Sensitive data (Google API key)
- **Deployment**: Main fraud detection agent with 2 replicas
- **Service**: ClusterIP service on port 80
- **HPA**: Auto-scaling from 2-10 pods based on CPU/memory
- **PDB**: Ensures at least 1 pod stays available during updates

## 🔧 Configuration

### Environment Variables (ConfigMap)
```yaml
GOOGLE_CLOUD_PROJECT: "gkehackathon-472914"
BANK_API_BASE_URL: "http://frontend:80" 
AGENT_NAME: "fraud-detection-agent"
FRAUD_THRESHOLD: "0.7"
ADK_PORT: "8000"
```

### Secrets
```yaml
GOOGLE_API_KEY: <base64-encoded-api-key>
```

## 🔍 Monitoring

```bash
# Check pods
kubectl get pods -l app=fraud-detection-agent

# View logs
kubectl logs -l app=fraud-detection-agent -f

# Check auto-scaling
kubectl get hpa fraud-detection-agent-hpa

# Port forward for testing
kubectl port-forward svc/fraud-detection-agent 8080:80
curl http://localhost:8080/health
```

## 🗂️ Manual Deployment

If you prefer manual steps:

```bash
# 1. Create API key secret first
kubectl create secret generic fraud-detection-secrets \
  --from-literal=GOOGLE_API_KEY="your-api-key-here"

# 2. Deploy all resources
kubectl apply -f fraud-detection.yaml

# 3. Wait for ready
kubectl wait --for=condition=available deployment/fraud-detection-agent
```