# AI-Powered Banking Intelligence Platform - Deployment Guide

## 🚀 Complete Deployment Instructions

This is the **single comprehensive deployment guide** for building and deploying the AI-powered fraud detection agent on Google Kubernetes Engine (GKE), exactly as implemented for the GKE Turns 10 Hackathon.

## ⚡ Quick Deploy (Experienced Users)

### Essential Commands Reference
```bash
# Set your project variables
export PROJECT_ID="your-project-id"
export REGION="us-central1"
export CLUSTER_NAME="gke-hackathon-cluster"
export REPOSITORY_NAME="fraud-detection"

# 1. Create and configure GCP project
gcloud projects create $PROJECT_ID
gcloud config set project $PROJECT_ID
gcloud services enable container.googleapis.com aiplatform.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com

# 2. Create GKE cluster
gcloud container clusters create $CLUSTER_NAME --project=$PROJECT_ID --zone=${REGION}-a --machine-type=e2-standard-4 --num-nodes=3 --enable-autoscaling --min-nodes=1 --max-nodes=5

# 3. Get credentials and configure Docker
gcloud container clusters get-credentials $CLUSTER_NAME --zone=${REGION}-a --project=$PROJECT_ID
gcloud artifacts repositories create $REPOSITORY_NAME --repository-format=docker --location=$REGION --project=$PROJECT_ID
gcloud auth configure-docker ${REGION}-docker.pkg.dev

# 4. Deploy Bank of Anthos
git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
cd bank-of-anthos && kubectl apply -f kubernetes-manifests/ && kubectl get pods --watch

# 5. Deploy Fraud Detection Agent
git clone https://github.com/ashokbharathi-s/gkehackathon.git
cd gkehackathon/agents/fraud-detection/
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:latest .
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:latest

# 6. Update and deploy Kubernetes manifests
cd ../../k8s/agents/fraud-detection/
sed -i "s/gkehackathon-472914/${PROJECT_ID}/g" fraud-detection.yaml
sed -i "s/us-central1/${REGION}/g" fraud-detection.yaml
kubectl apply -f fraud-detection.yaml

# 7. Verify deployment
cd ../../ && ./verify-demo.sh
kubectl logs -f deployment/fraud-detection-agent
```

**✅ The `verify-demo.sh` script will automatically validate your deployment and show system status.**

---

## 📋 Prerequisites

### Required Tools & Access
- **Google Cloud SDK** (gcloud CLI)
- **Docker** (for building container images)
- **kubectl** (Kubernetes command-line tool)
- **Git** (for cloning repositories)
- **Python 3.8+** (for local development/testing)

### Google Cloud Platform Setup
- **GCP Account** with billing enabled
- **Project with APIs enabled**:
  - Google Kubernetes Engine API
  - Vertex AI API
  - Container Registry API
  - Cloud Build API

### Permissions Required
- **GKE Admin** (to create and manage clusters)
- **Vertex AI User** (to access AI models)
- **Storage Admin** (for container registry)
- **Service Account Admin** (for authentication setup)

---

## 🏗️ Step 1: Environment Setup

### 1.1 Create GCP Project
```bash
# Create new project (replace PROJECT_ID with your choice)
gcloud projects create PROJECT_ID
gcloud config set project PROJECT_ID

# Enable required APIs
gcloud services enable container.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### 1.2 Set Environment Variables
```bash
export PROJECT_ID="your-project-id"
export REGION="us-central1"
export CLUSTER_NAME="gke-hackathon-cluster"
export REPOSITORY_NAME="fraud-detection"
```

### 1.3 Configure Docker Authentication
```bash
gcloud auth configure-docker ${REGION}-docker.pkg.dev
```

---

## 🎯 Step 2: Infrastructure Setup

### 2.1 Create GKE Cluster
```bash
# Create GKE cluster with recommended settings
gcloud container clusters create ${CLUSTER_NAME} \
    --project=${PROJECT_ID} \
    --zone=${REGION}-a \
    --machine-type=e2-standard-4 \
    --num-nodes=3 \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=5 \
    --enable-autorepair \
    --enable-autoupgrade \
    --disk-size=50GB \
    --disk-type=pd-standard

# Get cluster credentials
gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --zone=${REGION}-a \
    --project=${PROJECT_ID}
```

### 2.2 Create Artifact Registry Repository
```bash
# Create repository for container images
gcloud artifacts repositories create ${REPOSITORY_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --project=${PROJECT_ID}
```

### 2.3 Deploy Bank of Anthos (Base Platform)
```bash
# Clone Bank of Anthos repository
git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
cd bank-of-anthos

# Deploy all Bank of Anthos services
kubectl apply -f kubernetes-manifests/

# Wait for services to be ready (this may take 5-10 minutes)
kubectl get pods --watch
```

### 2.4 Verify Bank of Anthos Deployment
```bash
# Check all pods are running
kubectl get pods

# Check services are available
kubectl get services

# Get frontend URL (if using LoadBalancer)
kubectl get service frontend-external
```

---

## 🧠 Step 3: AI Fraud Detection Agent Setup

### 3.1 Clone the Hackathon Repository
```bash
# Clone our hackathon project
git clone https://github.com/ashokbharathi-s/gkehackathon.git
cd gkehackathon
```

### 3.2 Review and Customize Agent Code
```bash
# Navigate to agent directory
cd agents/fraud-detection/

# Review the main agent file
cat adk_fraud_agent.py

# Update configuration if needed (optional)
# - Modify API endpoints
# - Adjust monitoring intervals
# - Customize fraud detection thresholds
```

### 3.3 Build Container Image
```bash
# Build Docker image
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:latest .

# Push image to registry
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:latest
```

---

## 🚀 Step 4: Deploy Fraud Detection Agent

### 4.1 Update Kubernetes Manifests
```bash
# Navigate to Kubernetes manifests
cd ../../k8s/agents/fraud-detection/

# Update the deployment YAML with your project details
sed -i "s/gkehackathon-472914/${PROJECT_ID}/g" fraud-detection.yaml
sed -i "s/us-central1/${REGION}/g" fraud-detection.yaml
```

### 4.2 Deploy the Agent
```bash
# Apply the deployment
kubectl apply -f fraud-detection.yaml

# Verify deployment
kubectl get pods -l app=fraud-detection-agent

# Check deployment status
kubectl describe deployment fraud-detection-agent
```

### 4.3 Monitor Agent Startup
```bash
# Watch logs for successful startup
kubectl logs -f deployment/fraud-detection-agent

# Look for these successful startup messages:
# - "Starting ADK agent..."
# - "Successfully authenticated with JWT token"
# - "Starting real data monitoring cycle"
# - "AI Analysis completed successfully"
```

---

## 🔧 Step 5: Configuration and Verification

### 5.1 Verify API Connectivity
```bash
# Check if agent can access Bank of Anthos APIs
kubectl logs deployment/fraud-detection-agent | grep "API"

# Expected output should show:
# - "Balance API call successful"
# - "Transaction History API call successful"
# - "Retrieved X user accounts"
```

### 5.2 Test Fraud Detection
```bash
# Generate some test transactions (optional)
kubectl apply -f ../../../bank-of-anthos/extras/loadgenerator.yaml

# Monitor fraud detection in real-time
kubectl logs -f deployment/fraud-detection-agent | grep -i "fraud\|suspicious\|risk"
```

### 5.3 Access Agent Logs
```bash
# View recent fraud detection alerts
kubectl logs deployment/fraud-detection-agent --tail=50

# Follow logs in real-time
kubectl logs -f deployment/fraud-detection-agent

# Check specific time range (if needed)
kubectl logs deployment/fraud-detection-agent --since=1h
```

---

## 📊 Step 6: Monitoring and Scaling

### 6.1 Set up Monitoring
```bash
# Check resource usage
kubectl top pods -l app=fraud-detection-agent

# View deployment details
kubectl describe deployment fraud-detection-agent

# Check service endpoints
kubectl get services fraud-detection-agent
```

### 6.2 Scale the Agent (if needed)
```bash
# Scale to multiple replicas for high availability
kubectl scale deployment fraud-detection-agent --replicas=3

# Set up horizontal pod autoscaler
kubectl autoscale deployment fraud-detection-agent \
    --cpu-percent=70 \
    --min=1 \
    --max=5
```

---

## 🔍 Step 7: Troubleshooting

### 7.1 Common Issues and Solutions

#### **Issue**: Pod stuck in "Pending" state
**Solution**:
```bash
# Check node resources
kubectl describe nodes

# Check for resource constraints
kubectl describe pod -l app=fraud-detection-agent
```

#### **Issue**: "ImagePullBackOff" error
**Solution**:
```bash
# Verify image exists
gcloud artifacts repositories list
gcloud artifacts docker images list ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}

# Re-authenticate Docker
gcloud auth configure-docker ${REGION}-docker.pkg.dev
```

#### **Issue**: JWT Authentication failures
**Solution**:
```bash
# Check if Bank of Anthos services are running
kubectl get pods | grep -E "(frontend|userservice|transaction-history|balance-reader)"

# Verify service endpoints
kubectl get services
```

#### **Issue**: AI Model access errors
**Solution**:
```bash
# Verify Vertex AI API is enabled
gcloud services list --enabled | grep aiplatform

# Check project permissions
gcloud auth list
```

### 7.2 Debug Commands
```bash
# Get detailed pod information
kubectl describe pod -l app=fraud-detection-agent

# Check recent events
kubectl get events --sort-by='.metadata.creationTimestamp'

# Verify configuration
kubectl get configmaps
kubectl get secrets

# Test connectivity from within cluster
kubectl run debug-pod --image=curlimages/curl --rm -it --restart=Never -- /bin/sh
```

---

## 🎯 Step 8: Validation and Testing

### 8.1 Functional Testing Checklist
```bash
# ✅ Verify all components are running
kubectl get pods --all-namespaces

# ✅ Check fraud agent logs show AI analysis
kubectl logs deployment/fraud-detection-agent | grep -i "gemini\|analysis\|fraud"

# ✅ Confirm real-time monitoring is active
kubectl logs deployment/fraud-detection-agent | grep -i "monitoring cycle"

# ✅ Test API connectivity
kubectl logs deployment/fraud-detection-agent | grep -i "api.*successful"
```

### 8.2 Performance Validation
```bash
# Check resource utilization
kubectl top pods

# Verify response times in logs
kubectl logs deployment/fraud-detection-agent | grep -i "completed.*seconds"

# Monitor for memory/CPU issues
kubectl describe pods -l app=fraud-detection-agent
```

---

## 🔄 Step 9: Updates and Maintenance

### 9.1 Updating the Agent
```bash
# Build new version
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:v2.0 .
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:v2.0

# Update deployment
kubectl set image deployment/fraud-detection-agent fraud-agent=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/fraud-agent:v2.0

# Monitor rollout
kubectl rollout status deployment/fraud-detection-agent
```

### 9.2 Backup and Recovery
```bash
# Backup current configuration
kubectl get deployment fraud-detection-agent -o yaml > fraud-agent-backup.yaml

# Rollback if needed
kubectl rollout undo deployment/fraud-detection-agent
```

---

## 📈 Step 10: Production Considerations

### 10.1 Security Hardening
- **Enable Pod Security Standards**
- **Implement Network Policies** 
- **Use dedicated service accounts**
- **Enable audit logging**
- **Regular security updates**

### 10.2 High Availability Setup
- **Multi-zone deployment**
- **Database replication**
- **Load balancing**
- **Disaster recovery plan**
- **Monitoring and alerting**

### 10.3 Performance Optimization
- **Resource right-sizing**
- **Caching strategies**
- **Database optimization**
- **Network optimization**
- **Auto-scaling configuration**

---

## 📞 Support and Resources

### Documentation
- **Architecture**: `ARCHITECTURE-COMPLETE.md`
- **Demo Script**: `DEMO-SCRIPT.md`  
- **API References**: `agents/fraud-detection/README.md`

### Helpful Commands Reference
```bash
# Quick status check
kubectl get pods,services,deployments

# Complete system logs
kubectl logs -l app=fraud-detection-agent --tail=100

# Resource monitoring
kubectl top nodes && kubectl top pods

# Restart agent if needed
kubectl rollout restart deployment/fraud-detection-agent
```

### Contact Information
- **Repository**: https://github.com/ashokbharathi-s/gkehackathon
- **Issues**: Create GitHub issue for support
- **Documentation**: Check `/docs` directory for additional resources

---

## 🎉 Congratulations!

You have successfully deployed the AI-Powered Banking Intelligence Platform! The fraud detection agent is now:

✅ **Monitoring real-time transactions**  
✅ **Analyzing patterns with AI**  
✅ **Generating intelligent fraud alerts**  
✅ **Scaling automatically based on load**  

Your system is ready for production use and can be extended with additional AI agents as needed.

---

*This deployment guide ensures you can replicate the exact setup used in the GKE Turns 10 Hackathon submission, with proper production considerations and troubleshooting support.*
