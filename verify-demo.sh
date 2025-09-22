#!/bin/bash
# AI-Powered Banking Intelligence Platform - Deployment Verification Script
# This script verifies that the fraud detection agent is properly deployed and functioning

set -e

echo "🔍 AI-Powered Banking Intelligence Platform - Deployment Verification"
echo "=================================================================="
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verification functions
function check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
        return 0
    else
        echo -e "${RED}❌ $1${NC}"
        return 1
    fi
}

function check_kubectl() {
    echo -n "Checking kubectl connectivity... "
    kubectl cluster-info --request-timeout=5s >/dev/null 2>&1
    check_status "kubectl is connected to cluster"
}

function check_bank_of_anthos() {
    echo -n "Checking Bank of Anthos deployment... "
    
    # Check if key Bank of Anthos services are running
    local required_services=("frontend" "userservice" "transaction-history" "balance-reader" "accounts-db" "ledger-db")
    local missing_services=()
    
    for service in "${required_services[@]}"; do
        if ! kubectl get deployment "$service" >/dev/null 2>&1; then
            missing_services+=("$service")
        fi
    done
    
    if [ ${#missing_services[@]} -eq 0 ]; then
        check_status "Bank of Anthos services are deployed"
    else
        echo -e "${RED}❌ Missing Bank of Anthos services: ${missing_services[*]}${NC}"
        return 1
    fi
}

function check_pods_running() {
    echo -n "Checking if all pods are running... "
    
    # Check Bank of Anthos pods
    local not_running=$(kubectl get pods --no-headers | grep -v Running | grep -v Completed | wc -l)
    
    if [ "$not_running" -eq 0 ]; then
        check_status "All pods are in Running state"
    else
        echo -e "${RED}❌ $not_running pods are not running${NC}"
        kubectl get pods --no-headers | grep -v Running | grep -v Completed
        return 1
    fi
}

function check_fraud_agent() {
    echo -n "Checking fraud detection agent deployment... "
    
    if kubectl get deployment fraud-detection-agent >/dev/null 2>&1; then
        check_status "Fraud detection agent is deployed"
    else
        echo -e "${RED}❌ Fraud detection agent deployment not found${NC}"
        return 1
    fi
}

function check_fraud_agent_pod() {
    echo -n "Checking fraud detection agent pod status... "
    
    local pod_status=$(kubectl get pods -l app=fraud-detection-agent --no-headers -o custom-columns=":status.phase" 2>/dev/null)
    
    if [ "$pod_status" = "Running" ]; then
        check_status "Fraud detection agent pod is running"
    else
        echo -e "${RED}❌ Fraud detection agent pod status: $pod_status${NC}"
        return 1
    fi
}

function check_fraud_agent_logs() {
    echo -n "Checking fraud detection agent functionality... "
    
    # Get recent logs and check for key indicators
    local logs=$(kubectl logs deployment/fraud-detection-agent --tail=100 2>/dev/null || echo "")
    
    local indicators_found=0
    
    # Check for successful startup
    if echo "$logs" | grep -q "Starting ADK agent"; then
        ((indicators_found++))
    fi
    
    # Check for JWT authentication
    if echo "$logs" | grep -q "Successfully authenticated\|JWT.*success"; then
        ((indicators_found++))
    fi
    
    # Check for API connectivity
    if echo "$logs" | grep -q "API.*successful\|Retrieved.*accounts"; then
        ((indicators_found++))
    fi
    
    # Check for AI analysis
    if echo "$logs" | grep -q "AI Analysis\|Gemini\|analysis completed"; then
        ((indicators_found++))
    fi
    
    if [ $indicators_found -ge 3 ]; then
        check_status "Fraud detection agent is functioning properly"
    else
        echo -e "${RED}❌ Fraud detection agent may not be functioning correctly${NC}"
        echo -e "${YELLOW}   Found $indicators_found/4 expected indicators in logs${NC}"
        return 1
    fi
}

function check_ai_processing() {
    echo -n "Checking AI processing activity... "
    
    # Look for recent AI analysis in logs
    local recent_logs=$(kubectl logs deployment/fraud-detection-agent --since=5m 2>/dev/null || echo "")
    
    if echo "$recent_logs" | grep -q -i "analysis\|gemini\|fraud.*detect\|suspicious"; then
        check_status "AI processing is active"
    else
        echo -e "${YELLOW}⚠️  No recent AI analysis activity detected${NC}"
        echo -e "${BLUE}   This may be normal if no transactions occurred recently${NC}"
    fi
}

function check_resource_usage() {
    echo -n "Checking resource usage... "
    
    # Check if kubectl top is available
    if ! kubectl top nodes >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Metrics server not available for resource monitoring${NC}"
        return 0
    fi
    
    # Get fraud agent resource usage
    local cpu_usage=$(kubectl top pods -l app=fraud-detection-agent --no-headers 2>/dev/null | awk '{print $2}' | sed 's/m//' || echo "0")
    local memory_usage=$(kubectl top pods -l app=fraud-detection-agent --no-headers 2>/dev/null | awk '{print $3}' | sed 's/Mi//' || echo "0")
    
    if [ -n "$cpu_usage" ] && [ -n "$memory_usage" ]; then
        check_status "Resource usage: ${cpu_usage}m CPU, ${memory_usage}Mi Memory"
    else
        echo -e "${YELLOW}⚠️  Unable to retrieve resource usage metrics${NC}"
    fi
}

function show_detailed_status() {
    echo
    echo -e "${BLUE}📊 Detailed System Status${NC}"
    echo "========================"
    echo
    
    echo "🎯 Pod Status:"
    kubectl get pods -o wide | grep -E "(NAME|fraud-detection|frontend|userservice|transaction-history|balance-reader)"
    echo
    
    echo "🔗 Service Status:"
    kubectl get services | grep -E "(NAME|fraud-detection|frontend|userservice|transaction-history|balance-reader)"
    echo
    
    echo "📈 Deployments:"
    kubectl get deployments | grep -E "(NAME|fraud-detection|frontend|userservice|transaction-history|balance-reader)"
    echo
}

function show_recent_fraud_activity() {
    echo -e "${BLUE}🚨 Recent Fraud Detection Activity${NC}"
    echo "=================================="
    echo
    
    local fraud_logs=$(kubectl logs deployment/fraud-detection-agent --tail=20 2>/dev/null | grep -i -E "fraud|suspicious|risk|alert" || echo "No recent fraud alerts found")
    
    if [ "$fraud_logs" != "No recent fraud alerts found" ]; then
        echo "$fraud_logs"
    else
        echo "No recent fraud detection alerts."
        echo "This is normal if no suspicious transactions occurred recently."
    fi
    echo
}

function show_next_steps() {
    echo -e "${GREEN}� Next Steps${NC}"
    echo "============="
    echo
    echo "1. Monitor real-time fraud detection:"
    echo "   kubectl logs -f deployment/fraud-detection-agent"
    echo
    echo "2. Check system status anytime:"
    echo "   kubectl get pods"
    echo
    echo "3. View fraud detection alerts:"
    echo "   kubectl logs deployment/fraud-detection-agent | grep -i fraud"
    echo
    echo "4. Scale the agent if needed:"
    echo "   kubectl scale deployment fraud-detection-agent --replicas=3"
    echo
    echo "5. Update the agent:"
    echo "   kubectl set image deployment/fraud-detection-agent fraud-agent=NEW_IMAGE"
    echo
}

# Main verification sequence
function main() {
    local failed_checks=0
    
    echo "Starting verification checks..."
    echo
    
    # Core infrastructure checks
    check_kubectl || ((failed_checks++))
    echo
    
    check_bank_of_anthos || ((failed_checks++))
    echo
    
    check_pods_running || ((failed_checks++))
    echo
    
    # Fraud agent specific checks
    check_fraud_agent || ((failed_checks++))
    echo
    
    check_fraud_agent_pod || ((failed_checks++))
    echo
    
    check_fraud_agent_logs || ((failed_checks++))
    echo
    
    # AI functionality checks
    check_ai_processing
    echo
    
    check_resource_usage
    echo
    
    # Show detailed information
    show_detailed_status
    show_recent_fraud_activity
    
    # Summary
    echo "=================================================================="
    if [ $failed_checks -eq 0 ]; then
        echo -e "${GREEN}� ALL CHECKS PASSED! Your AI-powered fraud detection system is ready!${NC}"
        echo
        show_next_steps
    else
        echo -e "${RED}❌ $failed_checks checks failed. Please review the errors above.${NC}"
        echo
        echo -e "${YELLOW}Troubleshooting tips:${NC}"
        echo "1. Ensure all Bank of Anthos services are deployed and running"
        echo "2. Check that the fraud detection agent image was built and pushed correctly"
        echo "3. Verify Kubernetes cluster has sufficient resources"
        echo "4. Check logs: kubectl logs deployment/fraud-detection-agent"
        echo "5. See DEPLOYMENT-GUIDE.md for detailed troubleshooting steps"
    fi
    
    exit $failed_checks
}

# Run the main verification
main
kubectl get svc fraud-detection-agent

echo ""
echo "✅ Demo ready! Use 'kubectl logs -l app=fraud-detection-agent -f' to show live monitoring"
