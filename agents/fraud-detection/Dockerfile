# Dockerfile for Fraud Detection Agent with Google ADK
FROM registry.access.redhat.com/ubi9/python-311@sha256:7581277681d5e53d1332b6a93e8a00fe59c65f75bfbb21e16d8b08c7d9b43e18

# Set working directory  
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy fraud monitor code
COPY real_fraud_monitor.py .
COPY adk_fraud_agent.py .

# Environment variables
ENV PROJECT_ID=gkehackathon-472914
ENV REGION=us-central1
ENV PYTHONUNBUFFERED=1

# ADK Configuration
ENV ADK_MODE=enabled
ENV A2A_PORT=8001

# Expose ports for monitoring and A2A communication (no health checks)
EXPOSE 8000 8001

# Health checks handled by Kubernetes readiness/liveness probes
# No Docker HEALTHCHECK needed

# Run the ADK-compliant fraud detection agent (hybrid approach)
CMD ["python", "adk_fraud_agent.py"]
