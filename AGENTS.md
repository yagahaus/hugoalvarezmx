# Instrucciones y Reglas Operativas para Agentes de IA

Este espacio de trabajo corresponde al repositorio **`hugoalvarezmx`**, el sitio web oficial de la campaña del **Ing. Hugo César Álvarez Carbajal** y la plataforma del evento **HugoFest Emprendedor** en Salina Cruz, Oaxaca (proyecto vinculado a **MKT 499** de DiMedia).

Todo agente de IA (**Antigravity**, **Agy**, **Claude Code**, **Kiro CLI**, etc.) que opere en este repositorio debe seguir obligatoriamente las siguientes directivas:

---

## 🎯 1. Contexto y Propósito del Proyecto

* **Objetivo:** Portal web público de alta velocidad y disponibilidad para la proyección de imagen, comunicados oficiales, artículos de blog y registro/información del evento ciudadano **HugoFest Emprendedor**.
* **Cliente / Referente:** Ing. Hugo César Álvarez Carbajal.
* **Dominio Oficial en Producción:** [https://hugoalvarez.mx/](https://hugoalvarez.mx/)
* **Infraestructura Cloud:** AWS S3 + CloudFront + Route 53 (Hosted Zone `Z04813761RU9V5EPD9HNX`).
* **Estrategia de Ramas:**
  * **`develop` (Rama Activa de Trabajo):** Todo desarrollo, integración de contenido, nuevos componentes y configuración de agentes se realiza y commitea en esta rama.
  * **`main` (Rama de Producción):** Reservada para releases estables que detonan el despliegue automático a producción.

---

## 🛡️ 2. Directriz de Blindaje Legal y Comunicación (Fase No Electoral)

* **Estatus Normativo Actual:** Actualmente **NO nos encontramos en periodo electoral oficial**.
* **Prohibición Estricta:** Todo contenido, titular, copy, publicación de blog, metadato SEO o diseño gráfico **debe excluir categóricamente cualquier alusión político-electoral** (prohibidos llamados al voto, solicitud de apoyo para cargos públicos, mención de partidos políticos o candidaturas).
* **Enfoque Estratégico Autorizado:** Promoción del **liderazgo comunitario, social, deportivo, fomento económico y apoyo a emprendedores locales del Ing. Hugo Álvarez**.

---

## 💻 3. Stack Tecnológico y Comandos de Desarrollo

* **Framework:** **Astro** (generador de sitios estáticos SSG de alto rendimiento).
* **Entorno Node:** Node.js `>= 22.12.0` (gestión recomendada con `fnm` o `nvm`).
* **Estilos y Fuentes:** Tipografías corporativas *Montserrat* y *Space Mono*; colores base `#FF8000` (acento naranja oficial), `#212121` (carbón), `#fff7f0` (fondo cálido) y `#ffffff`.
* **Datos Desacoplados:** Archivos de configuración y contenido en `src/data/settings.json` y `src/data/hugofest.json`.

### Comandos Canónicos:
```bash
# 1. Instalar dependencias
npm install

# 2. Servidor local de desarrollo
npm run dev
# Disponible en: http://localhost:4321/

# 3. Compilación para producción (genera directorio dist/)
npm run build

# 4. Previsualización del build estático local
npm run preview
```

---

## ☁️ 4. Infraestructura de Despliegue en AWS (Perfil `dmv0`)

* **Perfil Obligatorio de AWS CLI:** Toda operación de infraestructura debe ejecutarse con `--profile dmv0`.
* **Prohibición de Credenciales Quemadas:** Jamás commitear Access Keys o Secret Keys en el repositorio.
* **Bucket S3 de Producción:** `hugoalvarez-mx-web-prod` (región `us-east-1`).
* **Distribución CloudFront:** CDN global con certificado SSL en ACM (`us-east-1`) y Origin Access Control (OAC).
* **Despliegue Automatizado (CI/CD):**
  * Configurado mediante GitHub Actions en `.github/workflows/deploy.yml` al hacer merge a `main`.
  * Script local supervisado alternativo: `scripts/deploy_aws.sh`.
  * Consulta el plan detallado en [`docs/plan-despliegue-automatizado.md`](docs/plan-despliegue-automatizado.md).
* **Runbook completo:** Consulta [`.agents/skills/aws-infra-ops/SKILL.md`](.agents/skills/aws-infra-ops/SKILL.md).

---

## 🎯 5. Gestión de Tareas en OmniFocus (Obligatorio)

Toda planificación, seguimiento y registro de pendientes se realiza en **OmniFocus**:
* **Proyecto asignado en OmniFocus:** `MKT PRO499 HUGO-SC`
* **Carpeta:** `DM Proyectos`
* **Herramienta principal (CLI):** `of` (`/Users/tlon/Library/Application Support/reflex/bun/bin/of`)
  - Listar pendientes: `of task list --project "MKT PRO499 HUGO-SC"`
  - Crear tarea: `of task create "<Título>" -p "MKT PRO499 HUGO-SC" [--note "<Nota>"]`
  - Completar tarea: `of task update <id|nombre> --complete`
* **Regla estricta:** PROHIBIDO crear tareas en el `Inbox` huérfano.
* **Runbook completo:** Consulta [`.agents/skills/omnifocus-task-ops/SKILL.md`](.agents/skills/omnifocus-task-ops/SKILL.md).

---

## 🪝 6. Enlaces Bidireccionales con Hookmark CLI

Todo entregable, diseño o documento maestro debe conectarse bidireccionalmente:
* **Herramienta:** Hookmark CLI (`hook` en PATH).
* **Vincular archivo con tarea:** `hook link "<ruta_archivo>" "omnifocus:///task/<ID_TAREA>"`
* **Vincular con DEVONthink:** `hook link "<ruta_archivo>" "x-devonthink-item://<UUID>"`
* **Prohibición estricta de URIs crudas:** En minutas, notas y respuestas, utilizar siempre enlaces listos para Markdown con título descriptivo.
* **Runbook completo:** Consulta [`.agents/skills/hookmark-cli/SKILL.md`](.agents/skills/hookmark-cli/SKILL.md).

---

## 🗄️ 7. Documentación y Archivo en DEVONthink 3 (vía MCP)

* **Herramienta oficial:** `python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py <subcomando>`
* **Base asignada:** `🙎🏽‍♂️ MKT 499 HUGO` (`C9AA35CA-EB86-4DCC-8601-A8C38FE3BD88`).
* **Grupo destino:** `06_SISTEMAS_Y_CRM / WEBSITES`.
* **Runbook completo:** Consulta [`.agents/skills/devonthink-doc-ops/SKILL.md`](.agents/skills/devonthink-doc-ops/SKILL.md).

---

## 📂 8. Trazabilidad y Bitácora del Repositorio

* **`bitacora.md`:** Todo hito, cambio arquitectónico o despliegue relevante debe quedar registrado cronológicamente con fecha, descripción técnica y commit asociado.
