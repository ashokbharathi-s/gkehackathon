#!/usr/bin/env python3
"""
AI-Powered Banking Intelligence Platform - Architecture Diagram Generator
Creates visual architecture diagrams for the GKE Hackathon project
"""

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import Rectangle, FancyBboxPatch, Circle, ConnectionPatch
import matplotlib.lines as mlines

def create_architecture_diagram():
    """Create the main architecture diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(16, 12))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    plt.title('AI-Powered Banking Intelligence Platform\nArchitecture Overview', 
              fontsize=20, fontweight='bold', pad=20)
    
    # GCP Cloud boundary
    gcp_box = FancyBboxPatch((0.2, 0.5), 9.6, 9, 
                             boxstyle="round,pad=0.1", 
                             facecolor='lightblue', 
                             edgecolor='blue', 
                             linewidth=2, 
                             alpha=0.3)
    ax.add_patch(gcp_box)
    ax.text(0.5, 9.2, 'Google Cloud Platform (GCP)', 
            fontsize=14, fontweight='bold')
    
    # GKE boundary
    gke_box = FancyBboxPatch((0.5, 1), 9, 8, 
                             boxstyle="round,pad=0.1", 
                             facecolor='lightgreen', 
                             edgecolor='green', 
                             linewidth=2, 
                             alpha=0.3)
    ax.add_patch(gke_box)
    ax.text(0.8, 8.7, 'Google Kubernetes Engine (GKE)', 
            fontsize=12, fontweight='bold')
    
    # Bank of Anthos section
    anthos_box = FancyBboxPatch((1, 4.5), 8, 3.8, 
                                boxstyle="round,pad=0.1", 
                                facecolor='lightyellow', 
                                edgecolor='orange', 
                                linewidth=1.5, 
                                alpha=0.5)
    ax.add_patch(anthos_box)
    ax.text(1.3, 8, 'Bank of Anthos (Base Platform)', 
            fontsize=11, fontweight='bold')
    
    # Bank services
    services = [
        ('Frontend', 1.5, 7.2),
        ('User Service', 3.5, 7.2),
        ('Contacts', 5.5, 7.2),
        ('Balance Reader', 1.5, 6.2),
        ('Transaction History', 3.5, 6.2),
        ('Ledger Writer', 5.5, 6.2),
        ('Accounts DB', 7, 6.2),
        ('PostgreSQL', 4.5, 5.2)
    ]
    
    for service, x, y in services:
        service_box = Rectangle((x, y), 1.3, 0.6, 
                               facecolor='white', 
                               edgecolor='gray', 
                               linewidth=1)
        ax.add_patch(service_box)
        ax.text(x + 0.65, y + 0.3, service, 
                ha='center', va='center', fontsize=8, fontweight='bold')
    
    # AI Fraud Detection Agent section
    ai_box = FancyBboxPatch((1, 1.5), 8, 2.5, 
                            boxstyle="round,pad=0.1", 
                            facecolor='lightcoral', 
                            edgecolor='red', 
                            linewidth=1.5, 
                            alpha=0.5)
    ax.add_patch(ai_box)
    ax.text(1.3, 3.7, 'AI-Powered Fraud Detection Agent (Google ADK)', 
            fontsize=11, fontweight='bold')
    
    # AI components
    ai_components = [
        ('Data Collector', 1.5, 3),
        ('JWT Auth', 3.5, 3),
        ('AI Analysis Engine', 5.5, 3),
        ('Transaction API', 1.5, 2.2),
        ('Balance API', 3.5, 2.2),
        ('Fraud Alerts', 5.5, 2.2)
    ]
    
    for component, x, y in ai_components:
        comp_box = Rectangle((x, y), 1.3, 0.5, 
                            facecolor='white', 
                            edgecolor='darkred', 
                            linewidth=1)
        ax.add_patch(comp_box)
        ax.text(x + 0.65, y + 0.25, component, 
                ha='center', va='center', fontsize=7, fontweight='bold')
    
    # Vertex AI section
    vertex_box = FancyBboxPatch((7.5, 1.5), 1.8, 2.5, 
                                boxstyle="round,pad=0.1", 
                                facecolor='lightpink', 
                                edgecolor='purple', 
                                linewidth=1.5, 
                                alpha=0.5)
    ax.add_patch(vertex_box)
    ax.text(7.7, 3.7, 'Vertex AI', 
            fontsize=10, fontweight='bold')
    
    gemini_box = Rectangle((7.7, 2.5), 1.4, 0.8, 
                          facecolor='white', 
                          edgecolor='purple', 
                          linewidth=1)
    ax.add_patch(gemini_box)
    ax.text(8.4, 2.9, 'Gemini\n1.5 Flash', 
            ha='center', va='center', fontsize=8, fontweight='bold')
    
    # Add arrows for data flow
    # Frontend to services
    arrow1 = ConnectionPatch((2.8, 7.5), (4.2, 7.5), "data", "data",
                            arrowstyle="->", shrinkA=0, shrinkB=0, 
                            mutation_scale=20, fc="blue", alpha=0.7)
    ax.add_artist(arrow1)
    
    # Services to AI
    arrow2 = ConnectionPatch((4.2, 6.2), (4.2, 3.5), "data", "data",
                            arrowstyle="->", shrinkA=0, shrinkB=0, 
                            mutation_scale=20, fc="red", alpha=0.7)
    ax.add_artist(arrow2)
    
    # AI to Vertex AI
    arrow3 = ConnectionPatch((6.8, 3), (7.7, 3), "data", "data",
                            arrowstyle="->", shrinkA=0, shrinkB=0, 
                            mutation_scale=20, fc="purple", alpha=0.7)
    ax.add_artist(arrow3)
    
    # Add legend
    legend_elements = [
        mlines.Line2D([0], [0], color='blue', lw=3, alpha=0.7, label='User Data Flow'),
        mlines.Line2D([0], [0], color='red', lw=3, alpha=0.7, label='AI Processing'),
        mlines.Line2D([0], [0], color='purple', lw=3, alpha=0.7, label='AI Model Integration'),
        mpatches.Patch(color='lightblue', alpha=0.3, label='Google Cloud Platform'),
        mpatches.Patch(color='lightgreen', alpha=0.3, label='Kubernetes Engine'),
        mpatches.Patch(color='lightyellow', alpha=0.5, label='Bank of Anthos'),
        mpatches.Patch(color='lightcoral', alpha=0.5, label='AI Agent'),
        mpatches.Patch(color='lightpink', alpha=0.5, label='Vertex AI')
    ]
    
    ax.legend(handles=legend_elements, loc='upper left', bbox_to_anchor=(0, 1), 
              fontsize=9, framealpha=0.9)
    
    plt.tight_layout()
    return fig

def create_data_flow_diagram():
    """Create the data flow diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(14, 10))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    plt.title('AI-Powered Banking Intelligence Platform\nData Flow Diagram', 
              fontsize=18, fontweight='bold', pad=20)
    
    # Define components and positions
    components = [
        ('User Transaction', 1, 7, 'lightblue'),
        ('Frontend Service', 1, 5.5, 'lightgreen'),
        ('Bank Services', 4, 5.5, 'lightyellow'),
        ('Transaction DB', 7, 5.5, 'lightgray'),
        ('Fraud Detection Agent', 2.5, 3, 'lightcoral'),
        ('AI Analysis Engine', 6, 3, 'lightpink'),
        ('Gemini 1.5 Flash', 8.5, 3, 'lavender'),
        ('Fraud Alerts', 5, 1, 'orange')
    ]
    
    # Draw components
    for name, x, y, color in components:
        if 'Engine' in name or 'Flash' in name:
            width, height = 1.8, 1
        else:
            width, height = 1.5, 0.8
            
        comp_box = FancyBboxPatch((x-width/2, y-height/2), width, height, 
                                  boxstyle="round,pad=0.1", 
                                  facecolor=color, 
                                  edgecolor='black', 
                                  linewidth=1)
        ax.add_patch(comp_box)
        ax.text(x, y, name, ha='center', va='center', 
                fontsize=9, fontweight='bold', wrap=True)
    
    # Add flow arrows with labels
    flows = [
        ((1, 6.6), (1, 5.9), 'User Input', 'blue'),
        ((1.75, 5.5), (3.25, 5.5), 'JWT Token', 'green'),
        ((4.75, 5.5), (6.25, 5.5), 'Transaction Data', 'orange'),
        ((4, 5.1), (2.5, 3.4), 'Real-time Monitor', 'red'),
        ((3.4, 3), (5.1, 3), 'Raw Data', 'purple'),
        ((6.9, 3), (7.6, 3), 'AI Processing', 'magenta'),
        ((6, 2.5), (5, 1.4), 'Risk Analysis', 'darkred')
    ]
    
    for start, end, label, color in flows:
        arrow = ConnectionPatch(start, end, "data", "data",
                               arrowstyle="->", shrinkA=5, shrinkB=5, 
                               mutation_scale=15, fc=color, ec=color, alpha=0.8)
        ax.add_artist(arrow)
        
        # Add label
        mid_x = (start[0] + end[0]) / 2
        mid_y = (start[1] + end[1]) / 2 + 0.2
        ax.text(mid_x, mid_y, label, ha='center', va='center', 
                fontsize=7, style='italic', color=color, fontweight='bold')
    
    # Add process steps
    steps_text = """
Data Flow Steps:
1. User initiates banking transaction
2. Frontend generates JWT authentication
3. Bank services process and store data
4. Fraud agent monitors in real-time
5. AI engine analyzes patterns
6. Gemini model provides intelligence
7. System generates fraud alerts
    """
    
    ax.text(0.2, 2, steps_text, fontsize=9, va='top', 
            bbox=dict(boxstyle="round,pad=0.3", facecolor='lightyellow', alpha=0.8))
    
    plt.tight_layout()
    return fig

def create_technology_stack_diagram():
    """Create technology stack visualization"""
    fig, ax = plt.subplots(1, 1, figsize=(12, 8))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    plt.title('Technology Stack Architecture', 
              fontsize=18, fontweight='bold', pad=20)
    
    # Define stack layers
    layers = [
        ('Infrastructure Layer', 'GKE • Docker • Kubernetes', 1, 7, 'lightblue'),
        ('Platform Layer', 'Bank of Anthos • Microservices', 1, 6, 'lightgreen'),
        ('AI Framework Layer', 'Google ADK • A2A Protocol', 1, 5, 'lightyellow'),
        ('AI Model Layer', 'Gemini 1.5 Flash • Vertex AI', 1, 4, 'lightpink'),
        ('Security Layer', 'JWT • RBAC • Network Policies', 1, 3, 'lightcoral'),
        ('Data Layer', 'PostgreSQL • Transaction APIs', 1, 2, 'lightgray'),
        ('Monitoring Layer', 'Kubernetes Logs • Metrics', 1, 1, 'orange')
    ]
    
    for layer_name, technologies, x, y, color in layers:
        # Layer box
        layer_box = FancyBboxPatch((x, y-0.3), 8, 0.6, 
                                   boxstyle="round,pad=0.05", 
                                   facecolor=color, 
                                   edgecolor='black', 
                                   linewidth=1.5,
                                   alpha=0.7)
        ax.add_patch(layer_box)
        
        # Layer name
        ax.text(x+0.2, y, layer_name, fontsize=11, fontweight='bold', va='center')
        
        # Technologies
        ax.text(x+3, y, technologies, fontsize=10, va='center', style='italic')
    
    # Add side annotations
    ax.text(9.5, 4, 'Cloud\nNative\nStack', rotation=90, ha='center', va='center',
            fontsize=14, fontweight='bold', 
            bbox=dict(boxstyle="round,pad=0.3", facecolor='white', alpha=0.8))
    
    plt.tight_layout()
    return fig

def main():
    """Generate all architecture diagrams"""
    print("Generating AI-Powered Banking Intelligence Platform Architecture Diagrams...")
    
    # Create output directory if it doesn't exist
    import os
    output_dir = "/Users/asankar/Documents/gkehackathon/docs/diagrams"
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate main architecture diagram
    print("1. Creating main architecture diagram...")
    fig1 = create_architecture_diagram()
    fig1.savefig(f"{output_dir}/main-architecture.png", dpi=300, bbox_inches='tight')
    plt.close(fig1)
    
    # Generate data flow diagram
    print("2. Creating data flow diagram...")
    fig2 = create_data_flow_diagram()
    fig2.savefig(f"{output_dir}/data-flow.png", dpi=300, bbox_inches='tight')
    plt.close(fig2)
    
    # Generate technology stack diagram
    print("3. Creating technology stack diagram...")
    fig3 = create_technology_stack_diagram()
    fig3.savefig(f"{output_dir}/technology-stack.png", dpi=300, bbox_inches='tight')
    plt.close(fig3)
    
    print(f"\n✅ All diagrams generated successfully!")
    print(f"📁 Output location: {output_dir}")
    print(f"📊 Files created:")
    print(f"   • main-architecture.png")
    print(f"   • data-flow.png") 
    print(f"   • technology-stack.png")
    print(f"\n🎯 Ready for hackathon submission!")

if __name__ == "__main__":
    main()