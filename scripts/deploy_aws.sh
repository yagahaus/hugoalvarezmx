#!/usr/bin/env bash
# ==============================================================================
# deploy_aws.sh
# ------------------------------------------------------------------------------
# Script local supervisado para compilar y sincronizar el sitio de Astro
# hacia AWS S3 + CloudFront para el dominio hugoalvarez.mx.
#
# Uso:
#   ./scripts/deploy_aws.sh [opciones]
# ==============================================================================

set -euo pipefail

# Colores y formatos
BOLD=$'\033[1m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[0;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
RESET=$'\033[0m'

# Configuración
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${REPO_DIR}/dist"
AWS_PROFILE="${AWS_PROFILE:-dmv0}"
AWS_REGION="${AWS_REGION:-us-east-1}"
S3_BUCKET="${S3_BUCKET:-hugoalvarez-mx-web-prod}"
CLOUDFRONT_DIST_ID="${CLOUDFRONT_DIST_ID:-}"

SKIP_BUILD=false
DRY_RUN=false

imprimir_ayuda() {
    cat << EOF
${BOLD}Uso:${RESET} $(basename "$0") [opciones]

${BOLD}Opciones:${RESET}
  -b, --skip-build    Omite el paso de compilación (sincroniza el dist/ existente)
  -d, --dry-run       Muestra los archivos que se transferirían sin aplicar cambios
  -h, --help          Muestra esta ayuda

${BOLD}Variables de Entorno:${RESET}
  AWS_PROFILE         Perfil de AWS CLI (por defecto: dmv0)
  S3_BUCKET           Bucket de destino (por defecto: hugoalvarez-mx-web-prod)
  CLOUDFRONT_DIST_ID  ID de distribución para invalidación de caché
EOF
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--skip-build) SKIP_BUILD=true; shift ;;
        -d|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) imprimir_ayuda; exit 0 ;;
        *) echo "${RED}Opción no reconocida: $1${RESET}"; imprimir_ayuda; exit 1 ;;
    esac
done

echo "${CYAN}${BOLD}=== Despliegue de hugoalvarez.mx a AWS S3 + CloudFront ===${RESET}"
echo "Directorio: ${REPO_DIR}"
echo "Perfil AWS: ${AWS_PROFILE}"
echo "Bucket S3 : ${S3_BUCKET}"
echo ""

# 1. Compilación
if [ "$SKIP_BUILD" = false ]; then
    echo "${BLUE}==> 1. Compilando sitio estático con Astro...${RESET}"
    cd "${REPO_DIR}"
    npm run build
    echo "${GREEN}✔ Compilación completada con éxito en ${DIST_DIR}.${RESET}"
else
    echo "${YELLOW}==> 1. Omitiendo compilación (--skip-build). Usando ${DIST_DIR}.${RESET}"
fi

if [ ! -d "${DIST_DIR}" ]; then
    echo "${RED}Error: El directorio de build ${DIST_DIR} no existe. Ejecuta npm run build primero.${RESET}"
    exit 1
fi

# 2. Sincronización a S3
DRY_RUN_FLAG=""
if [ "$DRY_RUN" = true ]; then
    DRY_RUN_FLAG="--dry-run"
    echo "${YELLOW}==> MODO DRY-RUN: No se aplicarán cambios reales en AWS.${RESET}"
fi

echo "${BLUE}==> 2. Sincronizando activos estáticos a S3 (Caché Inmutable)...${RESET}"
aws s3 sync "${DIST_DIR}/" "s3://${S3_BUCKET}/" \
    --delete \
    --exclude "*.html" \
    --cache-control "public, max-age=31536000, immutable" \
    --profile "${AWS_PROFILE}" \
    --region "${AWS_REGION}" \
    ${DRY_RUN_FLAG}

echo "${BLUE}==> 3. Sincronizando archivos HTML a S3 (Caché Dinámica / Revalidar)...${RESET}"
aws s3 sync "${DIST_DIR}/" "s3://${S3_BUCKET}/" \
    --include "*.html" \
    --cache-control "public, max-age=0, must-revalidate" \
    --profile "${AWS_PROFILE}" \
    --region "${AWS_REGION}" \
    ${DRY_RUN_FLAG}

# 3. Invalidación CloudFront
if [ -n "${CLOUDFRONT_DIST_ID}" ] && [ "$DRY_RUN" = false ]; then
    echo "${BLUE}==> 4. Creando invalidación de caché en CloudFront (${CLOUDFRONT_DIST_ID})...${RESET}"
    aws cloudfront create-invalidation \
        --distribution-id "${CLOUDFRONT_DIST_ID}" \
        --paths "/*" \
        --profile "${AWS_PROFILE}"
    echo "${GREEN}✔ Invalidación de caché creada exitosamente.${RESET}"
fi

echo ""
echo "${GREEN}${BOLD}✔ Despliegue finalizado con éxito para hugoalvarez.mx.${RESET}"
