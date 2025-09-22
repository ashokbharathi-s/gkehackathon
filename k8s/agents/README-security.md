# Fraud Detection Agent - Security Configuration

## 🔐 API Key Management

The fraud detection agent uses **Kubernetes Secrets** to securely store sensitive credentials like the Google API key.

### Quick Start

1. **Create API Key Secret:**
   ```bash
   ./k8s/agents/create-api-secret.sh YOUR_GOOGLE_API_KEY
   ```

2. **Deploy the Agent:**
   ```bash
   ./k8s/agents/deploy-fraud-agent.sh
   ```

### Security Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   ConfigMap     │    │    Secret        │    │   Deployment    │
│ (Non-sensitive) │    │ (Sensitive data) │    │                 │
├─────────────────┤    ├──────────────────┤    ├─────────────────┤
│ PROJECT_ID      │    │ GOOGLE_API_KEY   │──→ │ fraud-detection │
│ REGION          │──→ │ BANK_JWT_TOKEN   │    │ container       │
│ BANK_API_URL    │    │                  │    │                 │
│ LOG_LEVEL       │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Environment Variables

#### From ConfigMap (fraud-detection-config)
- `GOOGLE_CLOUD_PROJECT` - GCP project ID
- `GOOGLE_CLOUD_REGION` - GCP region
- `BANK_API_BASE_URL` - Bank of Anthos API endpoint
- `AGENT_NAME` - Agent identifier
- `LOG_LEVEL` - Logging level
- `FRAUD_THRESHOLD` - Risk threshold
- `ADK_PORT` - Agent server port

#### From Secret (fraud-detection-secrets)
- `GOOGLE_API_KEY` - Google Gemini API key (sensitive)
- `BANK_JWT_TOKEN` - Bank API authentication token (future use)

### Management Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `create-api-secret.sh` | Create new API key secret | `./create-api-secret.sh <api-key>` |
| `update-api-key.sh` | Update existing API key | `./update-api-key.sh <new-api-key>` |
| `deploy-fraud-agent.sh` | Deploy complete setup | `./deploy-fraud-agent.sh` |

### Getting Your Google API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create a new API Key or use existing one
3. Enable the **Generative AI API** for your project
4. Copy the API key (format: `AIza...`)

### Security Best Practices

✅ **What we do:**
- Store API keys in Kubernetes Secrets (base64 encoded)
- Separate sensitive and non-sensitive configuration
- Use proper RBAC and service accounts
- Automatic secret rotation support

❌ **What we avoid:**
- Hardcoded API keys in container images
- API keys in ConfigMaps or environment files
- Logging sensitive credentials

### Troubleshooting

**Secret not found error:**
```bash
# Check if secret exists
kubectl get secret fraud-detection-secrets

# View secret (base64 encoded)
kubectl get secret fraud-detection-secrets -o yaml
```

**API key format issues:**
```bash
# Verify API key format (should start with AIza)
echo "AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz" | grep -E "^AIza[0-9A-Za-z_-]{35}$"
```

**Update API key:**
```bash
# Method 1: Use update script
./k8s/agents/update-api-key.sh NEW_API_KEY

# Method 2: Manual kubectl patch
kubectl patch secret fraud-detection-secrets \
  --type='json' \
  -p='[{"op": "replace", "path": "/data/GOOGLE_API_KEY", "value": "'$(echo -n "NEW_API_KEY" | base64)'"}]'
```