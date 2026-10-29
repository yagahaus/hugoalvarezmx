---
name: aws-infra-ops
description: >-
  Manage AWS cloud infrastructure (Route 53, S3, CloudFront) for the Hugo Álvarez campaign
  using AWS CLI with profile dmv0. Use when creating hosted zones, managing DNS records for
  hugoalvarez.mx and dimedia.dev, syncing static sites/assets to S3 buckets, invalidating
  CloudFront caches, or configuring hybrid deployments with tlon_cloud.
---

# ☁️ AWS Infrastructure Operations (`aws-infra-ops`)

Esta skill proporciona los procedimientos, runbooks y sintaxis canónica de `aws-cli` para gestionar la infraestructura cloud de la campaña del **Ing. Hugo César Álvarez Carbajal** (Proyecto `MKT 499`).

---

## 🏛️ 1. Entorno de Ejecución y Credenciales

* **Binario:** `aws` en PATH (`aws-cli/2.x`).
* **Perfil Obligatorio:** `--profile dmv0` (Credenciales maestras de infraestructura de DiMedia).
* **Región por Defecto:** `us-east-1` (crítica para CloudFront y certificados ACM globales).

---

## 🌐 2. Topología y Convención de Dominios

| Dominio / Patrón | Propósito | Destino Tecnológico |
| :--- | :--- | :--- |
| **`hugoalvarez.mx`** *(raíz)* | Sitio público oficial y portal principal de campaña. | AWS CloudFront + S3 (Estático) |
| **`brand.hugoalvarez.mx`** | Identidad de marca, blog y convocatorias oficiales. | AWS CloudFront + S3 o `tlon_cloud` |
| **`registro.hugoalvarez.mx`** | Formulario público de voluntariado vecinal. | `tlon_cloud` (`209.38.142.8`) vía Traefik v3 |
| **`app.hugoalvarez.mx`** / **`crm...`** | Suite del CRM Electoral Municipal. | `tlon_cloud` (`209.38.142.8`) vía Traefik v3 |
| **`assets.hugoalvarez.mx`** | CDN de recursos multimedia, fotos en alta y videos. | AWS CloudFront + S3 |
| **`*.hugo.dimedia.dev`** | **QA, Pre-producción y Staging:** Validación previa. | `tlon_cloud` (`209.38.142.8`) |
| **`hugo.dimedia.dev/directorio`** | **Producción Interna / Privada:** Directorio de coordinación. | `tlon_cloud` (acceso restringido) |

---

## 📡 3. Runbooks de Route 53 (Gestión de DNS)

### 3.1. Crear Zona Alojada para `hugoalvarez.mx`
```bash
aws route53 create-hosted-zone \
  --name "hugoalvarez.mx" \
  --caller-reference "$(date +%s)" \
  --hosted-zone-config Comment="Dominio oficial de campaña Hugo Alvarez - MKT 499" \
  --profile dmv0
```

### 3.2. Consultar Name Servers para Delegación (en GoDaddy o Registrar)
```bash
# Obtener los 4 servidores de nombres asignados por AWS:
aws route53 list-resource-record-sets \
  --hosted-zone-id "<HOSTED_ZONE_ID>" \
  --query "ResourceRecordSets[?Type=='NS'].ResourceRecords[].Value" \
  --output text \
  --profile dmv0
```
> [!IMPORTANT]
> Los 4 Name Servers devueltos deben sustituir a los actuales (`ns55.domaincontrol.com` / `ns56.domaincontrol.com`) en el panel del registrador del dominio.

### 3.3. Crear Registro `A` apuntando a `tlon_cloud` (Servicios Dinámicos)
Para subdominios que se resuelven en el VPS (`209.38.142.8`):
```bash
cat << 'EOF' > /tmp/record-tlon.json
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "registro.hugoalvarez.mx.",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          { "Value": "209.38.142.8" }
        ]
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets \
  --hosted-zone-id "<HOSTED_ZONE_ID>" \
  --change-batch file:///tmp/record-tlon.json \
  --profile dmv0
rm /tmp/record-tlon.json
```

---

## 📦 4. Runbooks de S3 y CloudFront (Sitios Estáticos y Multimedia)

### 4.1. Crear Bucket S3 para Sitio Estático o Assets
```bash
# Bucket para build estático (Astro):
aws s3api create-bucket \
  --bucket hugoalvarez-mx-web-prod \
  --region us-east-1 \
  --profile dmv0

# Bucket para multimedia / assets:
aws s3api create-bucket \
  --bucket hugoalvarez-mx-assets-prod \
  --region us-east-1 \
  --profile dmv0
```

### 4.2. Sincronizar Build Estático (ej. Proyecto Astro)
```bash
# Sincronización diferencial con borrado de huérfanos y compresión:
aws s3 sync /Users/tlon/dev-repos/hugoalvarez/dist/ s3://hugoalvarez-mx-web-prod/ \
  --delete \
  --cache-control "public, max-age=31536000, immutable" \
  --exclude "*.html" \
  --profile dmv0

# HTML con cache baja para reflejar actualizaciones inmediatas:
aws s3 sync /Users/tlon/dev-repos/hugoalvarez/dist/ s3://hugoalvarez-mx-web-prod/ \
  --include "*.html" \
  --cache-control "public, max-age=0, must-revalidate" \
  --profile dmv0
```

### 4.3. Invalidación de Caché en CloudFront
Cada vez que se despliegue una nueva versión de estáticos:
```bash
aws cloudfront create-invalidation \
  --distribution-id "<DISTRIBUTION_ID>" \
  --paths "/*" \
  --profile dmv0
```

---

## 🛡️ 5. Reglas de Oro

1. **Uso estricto de `--profile dmv0`:** Jamás ejecutar comandos de AWS sin especificar el perfil para evitar escrituras en cuentas incorrectas.
2. **TTL Cortos en Periodo de Campaña:** Para registros dinámicos y de prueba, utilizar TTLs de 60 a 300 segundos para facilitar cambios rápidos.
3. **Desacoplamiento Estático vs. Dinámico:** Lo estático (Astro, imágenes, branding) va a S3 + CloudFront; lo transaccional y relacional (FastAPI, PostgreSQL, CRM) va a `tlon_cloud`.
4. **Verificación DNS:** Validar siempre la propagación antes de emitir certificados:
   ```bash
   dig @8.8.8.8 <subdominio>.hugoalvarez.mx A +short
   ```
