# Lista de Screenshots Faltantes para Reporte de Cumplimiento 3.0
## Proyecto: Pemex Azure Migration

Esta lista identifica los screenshots que deben capturarse para completar la evidencia visual del reporte de cumplimiento.

---

## 3.1 Repeatable Deployment

### Identity Management - Microsoft Entra ID

**FALTANTE:**
1. **Management Groups Hierarchy**
   - Ubicación: Azure Portal → Management Groups
   - Capturar: Vista completa de la jerarquía de Management Groups (pemex, pemex-platform, pemex-landingzones, etc.)
   - Nombre sugerido: `01-management-groups-hierarchy.png`

2. **RBAC Role Assignments**
   - Ubicación: Azure Portal → Management Groups → Access control (IAM)
   - Capturar: Asignaciones de roles a nivel de Management Groups
   - Nombre sugerido: `02-rbac-role-assignments.png`

3. **User Assigned Managed Identity**
   - Ubicación: Azure Portal → Resource Groups → Pemex-mgmt → Managed Identities
   - Capturar: Configuración de `id-amba-prod-001`
   - Nombre sugerido: `03-managed-identity-config.png`

### Networking Architecture Design

**FALTANTE:**
4. **DDoS Protection Configuration**
   - Ubicación: Azure Portal → DDoS protection plans
   - Capturar: Configuración de DDoS Protection Standard habilitado
   - Nombre sugerido: `04-ddos-protection-config.png`

5. **Private DNS Zones**
   - Ubicación: Azure Portal → Private DNS zones
   - Capturar: Lista de Private DNS Zones desplegadas
   - Nombre sugerido: `05-private-dns-zones.png`

6. **Virtual WAN Hub - Configuración Detallada**
   - Ubicación: Azure Portal → Virtual WAN → Hubs
   - Capturar: Configuración detallada del hub (routing, connections, etc.)
   - Nombre sugerido: `06-virtual-wan-hub-details.png`

7. **Azure Firewall - Rules y Policies**
   - Ubicación: Azure Portal → Azure Firewall → Firewall policy
   - Capturar: Reglas de firewall y políticas configuradas
   - Nombre sugerido: `07-azure-firewall-rules.png`

### Resource Organization

**YA EXISTE:**
- Resource Groups y tags (tiene screenshot)
- Naming conventions (tiene screenshot)
- Tagging enforcement (tiene screenshot)

**FALTANTE:**
8. **Azure Policy - Tagging Policies**
   - Ubicación: Azure Portal → Policy → Definitions
   - Capturar: Políticas de tagging implementadas y su estado
   - Nombre sugerido: `08-azure-policy-tagging.png`

9. **Azure Policy - Naming Policies**
   - Ubicación: Azure Portal → Policy → Definitions
   - Capturar: Políticas de naming conventions implementadas
   - Nombre sugerido: `09-azure-policy-naming.png`

### Azure Landing Zone Review Assessment

**FALTANTE:**
10. **ALZ Review - Ejecución en CLI**
    - Ubicación: Terminal/PowerShell ejecutando `az alz review`
    - Capturar: Output de la ejecución del comando ALZ Review
    - Nombre sugerido: `10-alz-review-cli-execution.png`

11. **ALZ Review - Results Dashboard**
    - Ubicación: Azure Portal o resultado JSON visualizado
    - Capturar: Resultados del ALZ Review mostrando multi-regional redundancy
    - Nombre sugerido: `11-alz-review-results.png`

### Automatización y Repetibilidad

**YA EXISTE:**
- Pipeline ejecución (tiene screenshot)
- Deployment status (tiene screenshot)
- CI/CD workflow (tiene screenshot)

**FALTANTE:**
12. **ARM Template Deployment - Success**
    - Ubicación: Azure Portal → Resource Groups → Deployments
    - Capturar: Deployment exitoso del template ALZ con estado "Succeeded"
    - Nombre sugerido: `12-arm-template-deployment-success.png`

13. **Script Execution - PowerShell**
    - Ubicación: PowerShell terminal ejecutando `deploy-alz.ps1`
    - Capturar: Ejecución del script mostrando validación y despliegue
    - Nombre sugerido: `13-powershell-script-execution.png`

14. **GitHub Actions - ARM TTK Results**
    - Ubicación: GitHub Actions → Workflow run → ARM Template Linter job
    - Capturar: Resultados del ARM Template ToolKit mostrando tests pasados
    - Nombre sugerido: `14-arm-ttk-results.png`

---

## 3.2 Plan for Skilling

**FALTANTE:**
15. **Plan de Skilling - Presentation/Document**
    - Ubicación: Documento o presentación del plan de skilling
    - Capturar: Primera página o slide del plan de skilling mostrando roles y habilidades
    - Nombre sugerido: `15-skilling-plan-overview.png`

16. **Plan de Skilling - Roles y Habilidades**
    - Ubicación: Documento del plan de skilling
    - Capturar: Tabla o lista de roles técnicos y habilidades requeridas
    - Nombre sugerido: `16-skilling-roles-skills.png`

17. **Plan de Skilling - Recursos de Capacitación**
    - Ubicación: Documento del plan de skilling
    - Capturar: Lista de recursos de capacitación (Microsoft Learn, certificaciones, etc.)
    - Nombre sugerido: `17-skilling-training-resources.png`

---

## 3.3 Operations Management Tooling

### Azure Monitor

**YA EXISTE:**
- Azure Monitor dashboard (tiene screenshot)
- Log Analytics workspace (tiene screenshot)
- Monitoring configuration (tiene screenshot)

**FALTANTE:**
18. **VM Insights Dashboard**
    - Ubicación: Azure Portal → Virtual Machines → Insights
    - Capturar: Dashboard de VM Insights mostrando métricas y health
    - Nombre sugerido: `18-vm-insights-dashboard.png`

19. **Change Tracking Dashboard**
    - Ubicación: Azure Portal → Automation Accounts → Change Tracking
    - Capturar: Dashboard de Change Tracking mostrando cambios detectados
    - Nombre sugerido: `19-change-tracking-dashboard.png`

20. **Update Management Dashboard**
    - Ubicación: Azure Portal → Automation Accounts → Update Management
    - Capturar: Dashboard de Update Management mostrando estado de actualizaciones
    - Nombre sugerido: `20-update-management-dashboard.png`

21. **Data Collection Rules (DCR)**
    - Ubicación: Azure Portal → Monitor → Data Collection Rules
    - Capturar: Configuración de DCR para VM Insights y Change Tracking
    - Nombre sugerido: `21-data-collection-rules.png`

22. **Monitor Baselines - Alert Rules**
    - Ubicación: Azure Portal → Monitor → Alert rules
    - Capturar: Alertas configuradas para connectivity, identity, management monitoring
    - Nombre sugerido: `22-monitor-baseline-alerts.png`

### Azure Automation

**FALTANTE:**
23. **Azure Automation Account**
    - Ubicación: Azure Portal → Automation Accounts
    - Capturar: Automation Account desplegado con configuración
    - Nombre sugerido: `23-azure-automation-account.png`

24. **AMBA - Azure Monitor Baseline Alerts**
    - Ubicación: Azure Portal → Automation Accounts → Alert rules
    - Capturar: Alertas AMBA configuradas para diferentes servicios
    - Nombre sugerido: `24-amba-alerts-configuration.png`

### Azure Backup / Site Recovery

**FALTANTE:**
25. **Azure Backup Vault**
    - Ubicación: Azure Portal → Backup vaults
    - Capturar: Backup vault configurado con políticas de backup
    - Nombre sugerido: `25-azure-backup-vault.png`

26. **VM Backup Policy**
    - Ubicación: Azure Portal → Backup vaults → Backup policies
    - Capturar: Política de backup para VMs configurada
    - Nombre sugerido: `26-vm-backup-policy.png`

27. **Recovery Services Vault**
    - Ubicación: Azure Portal → Recovery Services vaults
    - Capturar: Recovery Services vault con AMBA habilitado
    - Nombre sugerido: `27-recovery-services-vault.png`

### Microsoft Defender for Cloud

**FALTANTE:**
28. **Defender for Cloud - Overview Dashboard**
    - Ubicación: Azure Portal → Microsoft Defender for Cloud → Overview
    - Capturar: Dashboard principal mostrando secure score y recomendaciones
    - Nombre sugerido: `28-defender-for-cloud-overview.png`

29. **Defender for Cloud - Protections Enabled**
    - Ubicación: Azure Portal → Microsoft Defender for Cloud → Environment settings
    - Capturar: Lista de protecciones habilitadas (Servers, SQL, Key Vault, etc.)
    - Nombre sugerido: `29-defender-protections-enabled.png`

30. **Defender for Cloud - Email Contact Configuration**
    - Ubicación: Azure Portal → Microsoft Defender for Cloud → Settings → Email notifications
    - Capturar: Configuración de email contact: administrador@Pemex.onmicrosoft.com
    - Nombre sugerido: `30-defender-email-contact.png`

### Artefactos de Seguridad y Cumplimiento

**YA EXISTE:**
- Security scan results (tiene screenshot)
- Policy compliance (tiene screenshot)

**FALTANTE:**
31. **TruffleHog - Security Scan Details**
    - Ubicación: GitHub Actions → Workflow run → Security Scanning job
    - Capturar: Detalles del escaneo de TruffleHog mostrando resultados
    - Nombre sugerido: `31-trufflehog-scan-details.png`

32. **SBOM Generation - Syft Output**
    - Ubicación: GitHub Actions → Workflow run → Generate SBOM job
    - Capturar: Output de la generación de SBOM con Syft
    - Nombre sugerido: `32-sbom-generation-output.png`

33. **SBOM - Artifact Download**
    - Ubicación: GitHub Actions → Workflow run → Artifacts
    - Capturar: Artifact de SBOM disponible para descarga
    - Nombre sugerido: `33-sbom-artifact-available.png`

34. **Azure Policy - Compliance Dashboard**
    - Ubicación: Azure Portal → Policy → Compliance
    - Capturar: Dashboard de cumplimiento de políticas mostrando estado de compliance
    - Nombre sugerido: `34-azure-policy-compliance-dashboard.png`

35. **Azure Policy - Policy Assignments**
    - Ubicación: Azure Portal → Policy → Assignments
    - Capturar: Lista de asignaciones de políticas a Management Groups
    - Nombre sugerido: `35-azure-policy-assignments.png`

36. **GitHub Actions - Pipeline YAML Security Tasks**
    - Ubicación: GitHub → Repository → .github/workflows/deploy-alz.yml
    - Capturar: Sección del YAML mostrando security scanning tasks
    - Nombre sugerido: `36-pipeline-yaml-security-tasks.png`

37. **GitHub Actions - Artifacts Generated**
    - Ubicación: GitHub Actions → Workflow run → Artifacts section
    - Capturar: Lista de artifacts generados (security-scan-results, deployment-artifacts, policy-compliance, sbom)
    - Nombre sugerido: `37-github-actions-artifacts.png`

---

## Resumen de Screenshots Faltantes

### Por Sección:

**3.1 Repeatable Deployment:** 14 screenshots faltantes
- Identity Management: 3
- Networking: 4
- Resource Organization: 2
- ALZ Review: 2
- Automatización: 3

**3.2 Plan for Skilling:** 3 screenshots faltantes
- Plan overview: 1
- Roles y habilidades: 1
- Recursos de capacitación: 1

**3.3 Operations Management:** 20 screenshots faltantes
- Azure Monitor: 5
- Azure Automation: 2
- Azure Backup: 3
- Defender for Cloud: 3
- Artefactos de Seguridad: 7

**TOTAL: 37 screenshots faltantes**

---

## Prioridad de Captura

### Alta Prioridad (Críticos para cumplimiento):
1. Management Groups Hierarchy
2. ALZ Review Results
3. Azure Policy Compliance Dashboard
4. Defender for Cloud Overview
5. Plan de Skilling (si existe documentación)

### Media Prioridad (Importantes para evidencia completa):
6. VM Insights Dashboard
7. Azure Automation Account
8. Azure Backup Vault
9. ARM Template Deployment Success
10. Policy Assignments

### Baja Prioridad (Complementarios):
11. Resto de screenshots para evidencia visual completa

---

## Notas para Captura

1. **Formato:** PNG preferido, JPG aceptable
2. **Resolución:** Mínimo 1920x1080 para legibilidad
3. **Sanitización:** Asegurar que no haya PII (Personally Identifiable Information) visible
4. **Nombres:** Usar formato consistente: `##-descripcion-corta.png`
5. **Ubicación:** Guardar en carpeta `images/`
6. **Timestamps:** Incluir fecha en nombre si es relevante para evidencia temporal

---

**Última Actualización:** Diciembre 2025

