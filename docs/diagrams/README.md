# Architecture Diagrams

This directory contains visual architecture diagrams for the AI-Powered Banking Intelligence Platform created for the GKE Turns 10 Hackathon.

## Diagrams Available

### 1. main-architecture.png
**Main System Architecture Overview**
- Shows the complete system architecture with GCP, GKE, Bank of Anthos, and AI components
- Illustrates the relationship between existing banking services and the new fraud detection agent
- Displays integration with Google Vertex AI and Gemini models

### 2. data-flow.png
**Data Flow Diagram**  
- Demonstrates how transaction data flows through the system
- Shows the real-time monitoring process from user transactions to fraud alerts
- Illustrates JWT authentication and API integration patterns

### 3. technology-stack.png
**Technology Stack Visualization**
- Layer-by-layer breakdown of the technology stack
- From infrastructure (GKE) to AI models (Gemini 1.5 Flash)
- Shows security, data, and monitoring layers

## Usage Instructions

These diagrams are ready for:
- **Hackathon presentations** - High-resolution PNG format suitable for slides
- **Documentation** - Can be embedded in README files or technical docs
- **Demo videos** - Clear visual aids for explaining the architecture

## Technical Details

- **Format**: PNG (300 DPI)
- **Generated with**: Python matplotlib library
- **Optimized for**: Presentations and documentation
- **Color scheme**: Professional with clear component differentiation

## Architecture Highlights

- **Cloud-Native Design**: Built on GKE with microservices architecture
- **AI Integration**: Seamless connection to Google Vertex AI and Gemini models
- **Security**: JWT authentication and Kubernetes RBAC
- **Scalability**: Kubernetes-native scaling and resource management
- **Observability**: Comprehensive logging and monitoring

---

*Generated for GKE Turns 10 Hackathon - AI-Powered Banking Intelligence Platform*