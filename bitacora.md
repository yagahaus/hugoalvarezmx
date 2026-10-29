# Bitácora de Desarrollo — Hugo Álvarez MX (`hugoalvarezmx`)

Repositorio del portal web oficial de campaña del **Ing. Hugo César Álvarez Carbajal** y evento ciudadano **HugoFest Emprendedor** en Salina Cruz, Oaxaca (Proyecto **MKT 499** de DiMedia).

---

## 📅 Registro Cronológico de Hitos y Cambios Técnicos

- **2026-10-28:** Inicialización del Repositorio y Estructura en Astro: Creación de la base del proyecto Astro con componentes de Hero, llamados a la acción, páginas informativas, blog y módulo del evento HugoFest Emprendedor Buen Fin 2026.
- **2026-10-29:** Configuración de Directivas de Agentes de IA, Skills y Plan CI/CD (Rama `develop`): Se establecieron en la rama `develop`: 1) [`AGENTS.md`](AGENTS.md) normativo con blindaje legal no electoral, perfil obligatorio `--profile dmv0` y conexión a OmniFocus/Hookmark/DEVONthink; 2) Incorporación de la suite de skills habituales en `.agents/skills/` (`aws-infra-ops`, `omnifocus-task-ops`, `hookmark-cli`, `devonthink-doc-ops`); 3) Plan técnico de despliegue automatizado en [`docs/plan-despliegue-automatizado.md`](docs/plan-despliegue-automatizado.md) basado en AWS S3 (`hugoalvarez-mx-web-prod`), CloudFront (OAC) y Route 53; 4) Workflow de GitHub Actions en `.github/workflows/deploy.yml`; y 5) Script de sincronización supervisada en [`scripts/deploy_aws.sh`](scripts/deploy_aws.sh). Tarea registrada y completada en OmniFocus (`ianP3GtV1WI`).
