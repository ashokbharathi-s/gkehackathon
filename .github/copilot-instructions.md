# GKE Hackathon: AI-Powered Banking Intelligence Platform

## Project Overview
This project enhances Bank of Anthos with AI agents for the GKE Turns 10 Hackathon. We're building three specialized AI agents that work together to create an intelligent banking ecosystem:

1. **Fraud Detection Agent** - Real-time transaction monitoring and risk assessment
2. **Customer Support Agent** - Natural language banking assistance  
3. **Financial Advisory Agent** - Personalized financial insights and recommendations

## Technology Stack
- **Platform**: Google Kubernetes Engine (GKE)
- **Base Application**: Bank of Anthos microservices
- **AI Framework**: Google Agent Development Kit (ADK)
- **AI Models**: Google Gemini models via Vertex AI
- **Communication**: Model Context Protocol (MCP) + Agent2Agent (A2A) protocol
- **Languages**: Python, Go, TypeScript
- **Infrastructure**: Docker, Kubernetes, Google Cloud

## Project Structure
- `/agents/` - AI agent implementations
- `/bank-of-anthos/` - Cloned base application
- `/mcp-servers/` - Model Context Protocol servers
- `/web-ui/` - Agent management dashboard
- `/k8s/` - Kubernetes manifests
- `/docs/` - Documentation and architecture diagrams

## Development Guidelines
- Agents are containerized and deployed separately from core Bank of Anthos services
- Use MCP servers to interface with existing Bank of Anthos APIs
- Implement A2A protocol for inter-agent communication
- All agents use Gemini models for AI capabilities
- Follow microservices patterns and cloud-native best practices

## GCP Configuration
- Project ID: gkehackathon-472914
- Region: us-central1
- Required APIs: GKE, Vertex AI, Container Registry, Cloud Build