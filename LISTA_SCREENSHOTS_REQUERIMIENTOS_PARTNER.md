# Lista de Screenshots Requeridos - Especialización Azure Partner
## Basado en Requerimientos Oficiales de Microsoft

Esta lista está organizada según los requerimientos específicos de la especialización **Infrastructure and Database Migration to Microsoft Azure V1.8**.

---

## 3.1 Repeatable Deployment

### Requerimiento: Identity Management (Microsoft Entra ID)

**Screenshots Requeridos:**

1. **Management Groups Hierarchy Completa**
   - **Ubicación:** Azure Portal → Management Groups
   - **Capturar:** 
     - Vista completa de la jerarquía mostrando:
       - `pemex` (Root)
       - `pemex-platform` y sus sub-grupos
       - `pemex-landingzones` y sus sub-grupos
   - **Evidencia:** Demuestra adopción de Microsoft Entra ID para organización
   - **Nombre:** `3.1-01-management-groups-hierarchy.png`

2. **RBAC Role Assignments en Management Groups**
   - **Ubicación:** Azure Portal → Management Groups → [Seleccionar grupo] → Access control (IAM)
   - **Capturar:** 
     - Asignaciones de roles a nivel de Management Groups
     - Múltiples Management Groups mostrando RBAC configurado
   - **Evidencia:** Demuestra control de acceso basado en roles
   - **Nombre:** `3.1-02-rbac-management-groups.png`

3. **User Assigned Managed Identity**
   - **Ubicación:** Azure Portal → Resource Groups → Pemex-mgmt → Managed Identities
   - **Capturar:** Configuración de Managed Identity (id-amba-prod-001)
   - **Evidencia:** Demuestra uso de Managed Identities para automatización
   - **Nombre:** `3.1-03-managed-identity.png`

### Requerimiento: Networking Architecture Design

**Screenshots Requeridos:**

4. **Topología de Red Azure (Network Topology)**
   - **Ubicación:** Azure Portal → Virtual Networks o Network Watcher → Topology
   - **Capturar:** 
     - Diagrama de topología de red mostrando:
       - Virtual WAN Hub
       - Subnets y address spaces
       - Conectividad entre componentes
   - **Evidencia:** Demuestra definición de topología de red Azure
   - **Nombre:** `3.1-04-network-topology.png`

5. **Virtual WAN Hub Configuration**
   - **Ubicación:** Azure Portal → Virtual WAN → Hubs
   - **Capturar:** 
     - Configuración del hub mostrando:
       - Address space
       - Routing configuration
       - Connections
   - **Evidencia:** Demuestra arquitectura de red implementada
   - **Nombre:** `3.1-05-virtual-wan-hub.png`

6. **Azure Firewall Configuration**
   - **Ubicación:** Azure Portal → Azure Firewall → [Firewall name]
   - **Capturar:** 
     - Configuración del firewall
       - Rules (Application, Network, NAT)
       - Firewall Policy
       - Availability Zones
   - **Evidencia:** Demuestra seguridad de red implementada
   - **Nombre:** `3.1-06-azure-firewall-config.png`

7. **VPN Gateway o ExpressRoute (si configurado)**
   - **Ubicación:** Azure Portal → Virtual Network Gateways o ExpressRoute circuits
   - **Capturar:** 
     - Configuración de VPN Gateway o ExpressRoute
     - Connection status
     - Routing configuration
   - **Evidencia:** Demuestra arquitectura híbrida (conectividad on-premises)
   - **Nombre:** `3.1-07-hybrid-connectivity.png` o `3.1-07-expressroute.png`

8. **DDoS Protection**
   - **Ubicación:** Azure Portal → DDoS protection plans
   - **Capturar:** DDoS Protection Standard habilitado y configurado
   - **Evidencia:** Demuestra protección de red
   - **Nombre:** `3.1-08-ddos-protection.png`

9. **Private DNS Zones**
   - **Ubicación:** Azure Portal → Private DNS zones
   - **Capturar:** Lista de Private DNS Zones desplegadas
   - **Evidencia:** Demuestra resolución DNS privada
   - **Nombre:** `3.1-09-private-dns-zones.png`

### Requerimiento: Resource Organization

**Screenshots Requeridos:**

10. **Tagging Standards Implementation**
    - **Ubicación:** Azure Portal → Resource Groups → [Seleccionar RG] → Tags
    - **Capturar:** 
      - Múltiples recursos mostrando tags consistentes:
        - Environment
        - Project (Pemex-ALZ)
        - ManagedBy
        - DeploymentDate
    - **Evidencia:** Demuestra implementación de estándares de tagging
    - **Nombre:** `3.1-10-resource-tags.png`

11. **Naming Standards Applied**
    - **Ubicación:** Azure Portal → Resource Groups o All Resources
    - **Capturar:** 
      - Lista de recursos mostrando naming conventions consistentes:
        - Resource Groups: `Pemex-{service}-{location}`
        - Management Groups: `pemex-{purpose}`
        - Otros recursos siguiendo convención
    - **Evidencia:** Demuestra implementación de naming standards
    - **Nombre:** `3.1-11-naming-standards.png`

12. **Azure Policy - Tagging Enforcement**
    - **Ubicación:** Azure Portal → Policy → Assignments
    - **Capturar:** 
      - Políticas de tagging asignadas
      - Compliance status de políticas de tagging
    - **Evidencia:** Demuestra enforcement de tagging mediante políticas
    - **Nombre:** `3.1-12-policy-tagging-enforcement.png`

13. **Azure Policy - Naming Enforcement**
    - **Ubicación:** Azure Portal → Policy → Assignments
    - **Capturar:** Políticas de naming conventions asignadas
    - **Evidencia:** Demuestra enforcement de naming mediante políticas
    - **Nombre:** `3.1-13-policy-naming-enforcement.png`

### Requerimiento: Azure Landing Zone Review Assessment

**Screenshots Requeridos:**

14. **ALZ Review - Ejecución del Comando**
    - **Ubicación:** Terminal/PowerShell/CLI ejecutando `az alz review`
    - **Capturar:** 
      - Output completo del comando ALZ Review
      - Mostrando subscription ID y parámetros usados
    - **Evidencia:** Demuestra ejecución de ALZ Review assessment
    - **Nombre:** `3.1-14-alz-review-execution.png`

15. **ALZ Review - Resultados JSON**
    - **Ubicación:** Archivo JSON o visualización de resultados
    - **Capturar:** 
      - Resultados del ALZ Review mostrando:
        - Multi-regional redundancy: Configurado
        - Multi-zone redundancy: Configurado
        - Scores y recomendaciones
    - **Evidencia:** Demuestra multi-regional/multi-zone redundancy
    - **Nombre:** `3.1-15-alz-review-results.png`

### Requerimiento: Evidencia de Despliegue Repetible

**Screenshots Requeridos:**

16. **ARM Template File Structure**
    - **Ubicación:** GitHub Repository o Azure Portal → Templates
    - **Capturar:** 
      - Estructura del template ARM
      - Mostrando que es un tenantDeploymentTemplate
      - Ubicación del archivo: `ALZ-Template.json`
    - **Evidencia:** Demuestra uso de ARM templates para despliegue repetible
    - **Nombre:** `3.1-16-arm-template-structure.png`

17. **ARM Template Parameters File**
    - **Ubicación:** GitHub Repository
    - **Capturar:** 
      - Archivo de parámetros mostrando:
        - enterpriseScaleCompanyPrefix: "Pemex"
        - Subscription IDs
        - Configuraciones de red, identity, etc.
    - **Evidencia:** Demuestra configuración parametrizada
    - **Nombre:** `3.1-17-arm-parameters.png`

18. **ARM Template Deployment - Success Status**
    - **Ubicación:** Azure Portal → Deployments (tenant level) o Resource Groups → Deployments
    - **Capturar:** 
      - Deployment exitoso mostrando:
        - Status: "Succeeded"
        - Deployment name
        - Timestamp
        - Resources created
    - **Evidencia:** Demuestra despliegue exitoso del template
    - **Nombre:** `3.1-18-deployment-success.png`

19. **GitHub Actions Workflow - Deployment Job**
    - **Ubicación:** GitHub → Actions → Workflow run → Deploy ALZ job
    - **Capturar:** 
      - Ejecución exitosa del workflow
      - Mostrando deployment steps completados
      - Deployment name y status
    - **Evidencia:** Demuestra automatización mediante CI/CD
    - **Nombre:** `3.1-19-github-actions-deployment.png`

20. **Scripts de Despliegue (PowerShell/Bash)**
    - **Ubicación:** GitHub Repository → deployment-scripts/
    - **Capturar:** 
      - Código de los scripts (deploy-alz.ps1 o deploy-alz.sh)
      - Mostrando funciones de validación y despliegue
    - **Evidencia:** Demuestra scripts de automatización
    - **Nombre:** `3.1-20-deployment-scripts.png`

21. **Script Execution - Terminal Output**
    - **Ubicación:** Terminal ejecutando script de despliegue
    - **Capturar:** 
      - Output del script mostrando:
        - Validación exitosa
        - Deployment iniciado
        - Status messages
    - **Evidencia:** Demuestra ejecución de scripts de despliegue
    - **Nombre:** `3.1-21-script-execution.png`

### Requerimiento: Enfoque Utilizado (Start small and expand)

**Screenshots Requeridos:**

22. **Documentación del Enfoque**
    - **Ubicación:** README.md o documentación del proyecto
    - **Capturar:** 
      - Sección mostrando "Start small and expand" seleccionado
      - Descripción del enfoque utilizado
    - **Evidencia:** Demuestra el enfoque seleccionado
    - **Nombre:** `3.1-22-approach-documentation.png`

---

## 3.2 Plan for Skilling

### Requerimiento: Descripción de Habilidades para Roles Técnicos

**Screenshots Requeridos:**

23. **Plan de Skilling - Overview/Presentación**
    - **Ubicación:** Documento o presentación del plan de skilling
    - **Capturar:** 
      - Primera página o slide principal
      - Mostrando título y estructura del plan
      - Cliente: Pemex
    - **Evidencia:** Demuestra existencia del plan de skilling
    - **Nombre:** `3.2-01-skilling-plan-overview.png`

24. **Roles Técnicos Identificados**
    - **Ubicación:** Documento del plan de skilling
    - **Capturar:** 
      - Tabla o lista de roles técnicos:
        - IT Admins
        - IT Governance
        - IT Operations
        - IT Security
      - Con descripción de cada rol
    - **Evidencia:** Demuestra identificación de roles técnicos
    - **Nombre:** `3.2-02-technical-roles.png`

25. **Habilidades Requeridas por Rol**
    - **Ubicación:** Documento del plan de skilling
    - **Capturar:** 
      - Mapeo de roles a habilidades específicas
      - Habilidades necesarias para gestionar el entorno Azure
    - **Evidencia:** Demuestra descripción de nuevas habilidades
    - **Nombre:** `3.2-03-skills-by-role.png`

### Requerimiento: Recursos de Transferencia de Conocimiento

**Screenshots Requeridos:**

26. **Microsoft Learn Paths**
    - **Ubicación:** Documento del plan de skilling
    - **Capturar:** 
      - Lista de Microsoft Learn paths recomendados
      - Ejemplos: Azure Administrator, Azure Security Engineer, etc.
    - **Evidencia:** Demuestra recursos de Microsoft Learn
    - **Nombre:** `3.2-04-microsoft-learn-paths.png`

27. **Certificaciones Técnicas**
    - **Ubicación:** Documento del plan de skilling
    - **Capturar:** 
      - Lista de certificaciones recomendadas:
        - AZ-104 (Azure Administrator)
        - AZ-305 (Azure Solutions Architect)
        - AZ-500 (Azure Security Engineer)
        - Otras relevantes
    - **Evidencia:** Demuestra certificaciones técnicas como recurso
    - **Nombre:** `3.2-05-technical-certifications.png`

28. **Otros Recursos de Capacitación**
    - **Ubicación:** Documento del plan de skilling
    - **Capturar:** 
      - Lista de recursos adicionales:
        - Hands-on labs
        - Workshops
        - Documentación técnica
        - Comunidades de práctica
    - **Evidencia:** Demuestra recursos comparables adicionales
    - **Nombre:** `3.2-06-additional-training-resources.png`

---

## 3.3 Operations Management Tooling

### Requerimiento: Azure Monitor, Azure Automation, o Azure Backup/Site Recovery

**Screenshots Requeridos:**

### Azure Monitor

29. **Log Analytics Workspace**
    - **Ubicación:** Azure Portal → Log Analytics workspaces
    - **Capturar:** 
      - Workspace configurado
      - Retención configurada
      - Categorías de logs habilitadas
    - **Evidencia:** Demuestra Azure Monitor desplegado
    - **Nombre:** `3.3-01-log-analytics-workspace.png`

30. **Azure Monitor Dashboard Export**
    - **Ubicación:** Azure Portal → Monitor → Dashboards
    - **Capturar:** 
      - Dashboard de monitoreo exportado o visualizado
      - Mostrando métricas y visualizaciones
    - **Evidencia:** Demuestra monitoring dashboard export (requerido)
    - **Nombre:** `3.3-02-monitoring-dashboard.png`

31. **VM Insights Dashboard**
    - **Ubicación:** Azure Portal → Virtual Machines → Insights
    - **Capturar:** 
      - Dashboard de VM Insights
      - Métricas de performance y health
    - **Evidencia:** Demuestra VM monitoring habilitado
    - **Nombre:** `3.3-03-vm-insights-dashboard.png`

32. **Data Collection Rules (DCR)**
    - **Ubicación:** Azure Portal → Monitor → Data Collection Rules
    - **Capturar:** 
      - DCR configuradas para:
        - VM Insights
        - Change Tracking
        - Update Management
    - **Evidencia:** Demuestra configuración de recolección de datos
    - **Nombre:** `3.3-04-data-collection-rules.png`

33. **Alert Rules Configuration**
    - **Ubicación:** Azure Portal → Monitor → Alert rules
    - **Capturar:** 
      - Alertas configuradas
      - Monitor baselines habilitados
    - **Evidencia:** Demuestra alerting configurado
    - **Nombre:** `3.3-05-alert-rules.png`

### Azure Automation

34. **Azure Automation Account**
    - **Ubicación:** Azure Portal → Automation Accounts
    - **Capturar:** 
      - Automation Account desplegado
      - Configuración y estado
    - **Evidencia:** Demuestra Azure Automation desplegado
    - **Nombre:** `3.3-06-automation-account.png`

35. **AMBA - Azure Monitor Baseline Alerts**
    - **Ubicación:** Azure Portal → Automation Accounts → Alert rules
    - **Capturar:** 
      - Alertas AMBA configuradas
      - Múltiples servicios monitoreados
    - **Evidencia:** Demuestra AMBA implementado
    - **Nombre:** `3.3-07-amba-alerts.png`

### Azure Backup / Site Recovery

36. **Azure Backup Vault**
    - **Ubicación:** Azure Portal → Backup vaults
    - **Capturar:** 
      - Backup vault configurado
      - Políticas de backup
    - **Evidencia:** Demuestra Azure Backup desplegado
    - **Nombre:** `3.3-08-backup-vault.png`

37. **VM Backup Policy**
    - **Ubicación:** Azure Portal → Backup vaults → Backup policies
    - **Capturar:** 
      - Política de backup para VMs
      - Schedule y retention configurados
    - **Evidencia:** Demuestra políticas de backup implementadas
    - **Nombre:** `3.3-09-vm-backup-policy.png`

### Requerimiento: Artefactos de Seguridad y Cumplimiento

**Screenshots Requeridos:**

38. **Security Scan Report (TruffleHog)**
    - **Ubicación:** GitHub Actions → Workflow run → Security Scanning job
    - **Capturar:** 
      - Resultados del escaneo de secretos
      - Reporte sanitizado (sin PII)
      - Timestamp visible
    - **Evidencia:** Demuestra security scan report (requerido)
    - **Nombre:** `3.3-10-security-scan-report.png`

39. **GitHub Actions - Pipeline YAML con Security Tasks**
    - **Ubicación:** GitHub → Repository → .github/workflows/deploy-alz.yml
    - **Capturar:** 
      - Secciones del YAML mostrando:
        - Security scanning tasks
        - Code scanning (CodeQL)
        - Secret scanning
      - Líneas relevantes destacadas
    - **Evidencia:** Demuestra audit-ready YAML pipeline (requerido)
    - **Nombre:** `3.3-11-pipeline-yaml-security.png`

40. **SBOM Generation Output**
    - **Ubicación:** GitHub Actions → Workflow run → Generate SBOM job
    - **Capturar:** 
      - Output de generación de SBOM
      - Formato SPDX-JSON
      - Timestamp visible
    - **Evidencia:** Demuestra SBOM generado (requerido)
    - **Nombre:** `3.3-12-sbom-generation.png`

41. **SBOM Artifact Available**
    - **Ubicación:** GitHub Actions → Workflow run → Artifacts
    - **Capturar:** 
      - Artifact de SBOM disponible para descarga
      - Nombre del archivo: `sbom.spdx.json`
    - **Evidencia:** Demuestra SBOM como artifact
    - **Nombre:** `3.3-13-sbom-artifact.png`

42. **Azure Policy Compliance Snapshot**
    - **Ubicación:** Azure Portal → Policy → Compliance
    - **Capturar:** 
      - Dashboard de compliance
      - Estado de políticas
      - Compliance percentage
      - Timestamp visible
    - **Evidencia:** Demuestra policy-as-code compliance snapshot (requerido)
    - **Nombre:** `3.3-14-policy-compliance-snapshot.png`

43. **Azure Policy Assignments**
    - **Ubicación:** Azure Portal → Policy → Assignments
    - **Capturar:** 
      - Lista de asignaciones de políticas
      - Asignadas a Management Groups
      - Compliance status
    - **Evidencia:** Demuestra políticas asignadas
    - **Nombre:** `3.3-15-policy-assignments.png`

44. **GitHub Actions - All Artifacts Generated**
    - **Ubicación:** GitHub Actions → Workflow run → Artifacts section
    - **Capturar:** 
      - Lista completa de artifacts:
        - security-scan-results
        - deployment-artifacts
        - policy-compliance
        - sbom
        - arm-ttk-results
    - **Evidencia:** Demuestra todos los artifacts generados
    - **Nombre:** `3.3-16-all-artifacts.png`

### Microsoft Defender for Cloud (Recomendado)

45. **Defender for Cloud Overview**
    - **Ubicación:** Azure Portal → Microsoft Defender for Cloud → Overview
    - **Capturar:** 
      - Secure score
      - Recomendaciones
      - Estado general
    - **Evidencia:** Demuestra seguridad configurada
    - **Nombre:** `3.3-17-defender-overview.png`

46. **Defender Protections Enabled**
    - **Ubicación:** Azure Portal → Microsoft Defender for Cloud → Environment settings
    - **Capturar:** 
      - Lista de protecciones habilitadas
      - Servers, SQL, Key Vault, Storage, etc.
    - **Evidencia:** Demuestra protecciones configuradas
    - **Nombre:** `3.3-18-defender-protections.png`

---

## Resumen por Requerimiento

### 3.1 Repeatable Deployment (22 screenshots)

**Identity (3):**
- Management Groups Hierarchy
- RBAC Role Assignments
- Managed Identity

**Networking (6):**
- Network Topology
- Virtual WAN Hub
- Azure Firewall
- VPN Gateway/ExpressRoute
- DDoS Protection
- Private DNS Zones

**Resource Organization (4):**
- Tagging Standards
- Naming Standards
- Policy Tagging Enforcement
- Policy Naming Enforcement

**ALZ Review (2):**
- ALZ Review Execution
- ALZ Review Results

**Despliegue Repetible (6):**
- ARM Template Structure
- ARM Parameters
- Deployment Success
- GitHub Actions Deployment
- Deployment Scripts
- Script Execution

**Enfoque (1):**
- Approach Documentation

### 3.2 Plan for Skilling (6 screenshots)

- Plan Overview
- Technical Roles
- Skills by Role
- Microsoft Learn Paths
- Technical Certifications
- Additional Training Resources

### 3.3 Operations Management (16 screenshots)

**Azure Monitor (5):**
- Log Analytics Workspace
- Monitoring Dashboard Export (REQUERIDO)
- VM Insights
- Data Collection Rules
- Alert Rules

**Azure Automation (2):**
- Automation Account
- AMBA Alerts

**Azure Backup (2):**
- Backup Vault
- VM Backup Policy

**Artefactos de Seguridad (5 - REQUERIDOS):**
- Security Scan Report (REQUERIDO)
- Pipeline YAML Security Tasks (REQUERIDO)
- SBOM Generation (REQUERIDO)
- SBOM Artifact (REQUERIDO)
- Policy Compliance Snapshot (REQUERIDO)

**Defender for Cloud (2):**
- Defender Overview
- Defender Protections

**Artifacts (1):**
- All Artifacts Generated

---

## Prioridad de Captura

### CRÍTICOS (Requeridos explícitamente):

1. **ALZ Review Results** - Multi-regional/multi-zone redundancy (3.1)
2. **Monitoring Dashboard Export** - Azure Monitor (3.3)
3. **Security Scan Report** - Sanitizado, timestamped (3.3)
4. **Pipeline YAML Security Tasks** - Audit-ready (3.3)
5. **SBOM** - Generado y disponible (3.3)
6. **Policy Compliance Snapshot** - Timestamped (3.3)
7. **Plan de Skilling** - Documentación completa (3.2)

### ALTA PRIORIDAD (Evidencia clave):

8. Management Groups Hierarchy
9. ARM Template Deployment Success
10. Network Topology
11. Resource Tags y Naming Standards
12. Azure Monitor Workspace
13. Azure Automation o Backup

### MEDIA PRIORIDAD (Complementarios):

14. Resto de screenshots de networking
15. Azure Policy assignments
16. Defender for Cloud
17. Scripts de despliegue

---

## Notas Importantes

1. **Sanitización:** Todos los screenshots deben estar libres de PII (Personally Identifiable Information)
2. **Timestamps:** Los artifacts deben incluir timestamps y ser trazables a pipeline runs específicos
3. **Formato:** PNG preferido, resolución mínima 1920x1080
4. **Nombres:** Usar formato `##.##-descripcion-corta.png`
5. **Ubicación:** Guardar en carpeta `images/`
6. **Dos Clientes:** Necesitas evidencia para 2 clientes únicos (Pemex es el primero)

---

**Total de Screenshots Requeridos: 44**

**Última Actualización:** Diciembre 2025

