---
name: devonthink-doc-ops
description: >-
  Manage documentation, dossier records, group hierarchies, and file archiving in DEVONthink 3
  using the MCP bridge CLI (`dt_mcp.py`) and DEVONthink MCP server. Use when creating group paths,
  filing reference documents, searching records, managing tags, and linking database records.
---

# 🗄️ DEVONthink Document Operations (`devonthink-doc-ops`)

Esta skill proporciona las directivas y runbooks para gestionar la documentación del proyecto `MKT 499` en **DEVONthink 3** vía MCP.

## 🏛️ Entorno de Ejecución
* **Puente MCP CLI:** `python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py <subcomando>`
* **Auditoría e Integridad:** `python3 /Users/tlon/dev-scripts/devonthink/dt_auditoria.py <UUID>`
* **Servidor MCP:** Configurado en `~/.config/mcp/mcp_config.json` (`devonthink`).

## ⚡ Comandos Canónicos de Consulta y Gestión

### 1. Listar bases de datos abiertas y obtener UUIDs
```bash
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py dbs
```

### 2. Explorar grupos y jerarquía
```bash
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py tree <UUID_BASE_O_GRUPO>
```

### 3. Búsqueda de registros y expedientes
```bash
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py search "<término>" <UUID_BASE>
```

### 4. Consultar propiedades de un registro
```bash
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py props <UUID_REGISTRO>
```

### 5. Invocación de herramientas MCP
```bash
# Crear estructura de grupos para este proyecto:
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py call create_group_path '{"databaseUuid": "<UUID>", "groupPath": "02_PROYECTOS/MKT 499"}'

# Crear un registro Markdown dentro del grupo:
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py call create_record '{"databaseUuid": "<UUID>", "parentUuid": "<UUID_GRUPO>", "name": "Ficha Técnica.md", "type": "markdown", "text": "# MKT 499"}'

# Asignar etiquetas normalizadas:
python3 /Users/tlon/dev-scripts/devonthink/dt_mcp.py call set_record_tags '{"uuid": "<UUID_REGISTRO>", "tags": ["mkt", "hugo-sc"]}'
```

## 🛡️ Estándar Arquitectónico Obligatorio
1. **PROHIBIDO manipular `.dtBase2` directamente en el sistema de archivos.**
2. **Prefijos numéricos de dos dígitos (`00_` a `99_`):** Orden cognitivo estricto.
3. **Profundidad máxima de 3 niveles:** `[Base] > [00_Área] > [Subgrupo] > [Documento]`.
4. **Cero documentos en raíz:** Todo archivo debe pertenecer a un grupo específico.
5. **Taxonomía de etiquetas normalizada:** Minúsculas, sin acentos y sin redundancias.
