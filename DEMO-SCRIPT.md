# 🎬 Demo Script: AI-Powered Banking Intelligence Platform

**GKE Turns 10 Hackathon - 2-3 Minute Demo**

## 🎯 Demo Overview
This demo showcases a **real-time AI fraud detection agent** that monitors live Bank of Anthos transactions and uses Google Gemini AI to detect and explain fraudulent activities.

---

## 📋 Demo Script (2-3 Minutes)

### 🎬 **Opening (15 seconds)**
> "Hi! I'm presenting our GKE Turns 10 Hackathon submission - an AI-Powered Banking Intelligence Platform that enhances Bank of Anthos with real-time fraud detection using Google's Agent Development Kit and Gemini AI."

**SCREEN**: Show the project README with architecture diagram

---

### 🏗️ **Architecture Overview (30 seconds)**
> "Our solution integrates seamlessly with Bank of Anthos microservices. The fraud detection agent runs as a separate service, uses JWT authentication to access real banking data, and leverages Google Gemini for intelligent analysis. It's built using the Google Agent Development Kit and implements the Agent2Agent protocol as required by the hackathon."

**SCREEN**: Point to the architecture diagram showing:
- Bank of Anthos services (original)
- AI Agent layer (new)
- Gemini AI integration
- Data flow arrows

---

### 🚀 **Live Demo - Real-Time Monitoring (90 seconds)**

#### **Step 1: Show Live Deployment (20 seconds)**
```bash
kubectl get pods -l app=fraud-detection-agent
```
> "Here's our agent running live in GKE. It's monitoring 645+ real user accounts that exist in the Bank of Anthos database."

**SCREEN**: Show pods running and healthy

#### **Step 2: Real-Time Fraud Detection (45 seconds)**
```bash
kubectl logs -l app=fraud-detection-agent --tail=20 -f
```
> "Watch this - the agent is continuously analyzing real transactions. See here - it just detected suspicious activity on account 1055757655 belonging to user 'bob'. The AI found large incoming transactions totaling $786,274 from multiple accounts."

**SCREEN**: Show live logs with:
- ✅ Balance API: HTTP 200 responses
- ✅ Transaction retrieval: 27 real transactions
- 🚨 FRAUD ALERT with detailed analysis

#### **Step 3: AI Analysis Explanation (25 seconds)**
> "Notice how Gemini AI provides detailed reasoning - it identified large transactions from external routing numbers, rapid succession of high-value transfers, and even suggests specific actions like verifying the $250,000 transaction and investigating account relationships. This isn't just pattern matching - it's intelligent analysis."

**SCREEN**: Highlight the fraud alert details:
- Risk assessment
- Detailed indicators
- Actionable recommendations

---

### 🏆 **Hackathon Compliance (30 seconds)**
> "Our solution fully meets the hackathon requirements. It uses Google ADK framework - you can see the ADK-compliant agent structure here. We've implemented the Agent2Agent protocol running on port 8001 for multi-agent communication. Everything runs cloud-native on GKE with proper scaling, security, and monitoring."

**SCREEN**: Show code structure highlighting:
- ADK compliance in `adk_fraud_agent.py`
- A2A protocol implementation
- Kubernetes deployment manifests

---

### 🎯 **Impact & Innovation (15 seconds)**
> "This demonstrates the power of combining traditional banking applications with modern AI. We're processing real banking data, generating intelligent insights, and providing actionable fraud prevention - all running production-ready on Google Cloud."

**SCREEN**: Show final summary slide or return to README

---

## 🛠️ Demo Preparation Checklist

### Before the Demo:
- [ ] Ensure fraud detection agent is running and healthy
- [ ] Verify logs are showing active monitoring with fraud alerts
- [ ] Have terminal ready with kubectl commands
- [ ] Browser tabs open to:
  - Project README
  - Code repository (ADK agent file)
- [ ] Test screen sharing and audio

### Demo Commands (Copy-Paste Ready):
```bash
# Check pod status
kubectl get pods -l app=fraud-detection-agent

# Show real-time logs
kubectl logs -l app=fraud-detection-agent --tail=20 -f

# Show deployment details
kubectl describe deployment fraud-detection-agent

# Show A2A protocol endpoint (if needed)
kubectl port-forward svc/fraud-detection-agent 8001:8001
```

### Key Talking Points:
1. **Real Data**: Emphasize 645+ real users, not mock data
2. **AI Intelligence**: Highlight Gemini's detailed reasoning
3. **Production Ready**: Show GKE deployment, scaling, security
4. **Hackathon Compliance**: ADK + A2A + GKE requirements met
5. **Innovation**: Traditional banking + modern AI

---

## 🎥 Screen Recording Tips

### Recording Setup:
1. **Resolution**: 1920x1080 for clarity
2. **Audio**: Clear microphone, eliminate background noise
3. **Screens**: 
   - Primary: Terminal with live logs
   - Secondary: Browser with documentation
4. **Timing**: Practice to stay within 2-3 minutes

### Visual Flow:
1. Start with README overview
2. Zoom into architecture diagram
3. Switch to terminal for live demo
4. Return to code/documentation for compliance
5. End with impact summary

### Pro Tips:
- **Practice the timing** - 2-3 minutes goes quickly
- **Have a backup** - Pre-record logs if live demo fails
- **Highlight key moments** - Use mouse to point out important details
- **Speak clearly** - Explain technical concepts simply
- **Show confidence** - You built something impressive!

---

## 📋 Backup Plan

If live logs aren't showing fraud alerts during demo:
1. Use pre-recorded terminal session
2. Show recent logs with `kubectl logs --since=1h`
3. Explain the monitoring cycle timing
4. Focus on the architecture and code instead

## 🏅 Winning Points to Emphasize

1. **Real Banking Integration**: Not a toy - works with actual Bank of Anthos
2. **AI-Powered Intelligence**: Gemini provides human-like reasoning
3. **Hackathon Compliance**: Properly uses ADK, A2A, and GKE
4. **Production Quality**: 645+ users, high availability, proper security
5. **Innovation Impact**: Shows future of AI-enhanced banking

---

**🎬 Break a leg! You've built something amazing - now show it off! 🚀**