---
name: hookmark-cli
description: >-
  Interlink files, OmniFocus tasks, DEVONthink records, and macOS resources using the
  Hookmark CLI (`hookapp` / `hook`). Use when creating bidirectional links between documents
  and tasks, generating persistent Markdown links (`hook://file/...`), inspecting attached hooks
  with `hook list`, capturing links from frontmost apps with `hook from`, or searching bookmarks.
---

# 🪝 Hookmark CLI (`hookmark-cli`)

Esta skill proporciona los procedimientos y sintaxis canónica para gestionar enlaces persistentes y bidireccionales en macOS para el proyecto `MKT 499`.

## 🏛️ Configuración y Herramientas
* **Binario:** `/Users/tlon/.local/share/mise/installs/ruby/3.3/bin/hook` (o comando `hook` en PATH).
* **Requisito:** Hookmark.app debe estar en ejecución en macOS.

## ⚡ Patrones Clave de Vinculación en este Proyecto

### Patrón A: Entregable o Script ⟷ Tarea de OmniFocus
Permite conectar un archivo con su tarea de seguimiento en OmniFocus:
```bash
# Vincular archivo con tarea:
hook link "/Users/tlon/dmx-projects/mkt-499-hugo-sc/entregables/<archivo>" "omnifocus:///task/<ID_TAREA>"

# Verificar vínculos:
hook list "/Users/tlon/dmx-projects/mkt-499-hugo-sc/entregables/<archivo>"
```

### Patrón B: Documento o Brief ⟷ Registro en DEVONthink
Conecta un documento del repositorio con su expediente formal archivado en DEVONthink 3:
```bash
hook link "/Users/tlon/dmx-projects/mkt-499-hugo-sc/briefs/<archivo>" "x-devonthink-item://<UUID_REGISTRO>"
```

### Patrón C: Generar Enlace Markdown Persistente (`hook clip -m`)
Genera un enlace universal que no se rompe aunque el archivo o carpeta cambie de ruta:
```bash
# Copia al portapapeles [nombre](hook://file/...):
hook clip -m "/Users/tlon/dmx-projects/mkt-499-hugo-sc"
```

### Patrón D: Captura desde la Aplicación Activa (`hook from -m`)
```bash
hook from -m "OmniFocus"
hook from -m "DEVONthink 3"
```

## 🛡️ Reglas de Oro
1. Usar siempre rutas absolutas canónicas (`/Users/tlon/dmx-projects/mkt-499-hugo-sc/...`).
2. Vincular los archivos una vez ubicados en su carpeta definitiva (`entregables/`, `briefs/`, etc.), no en `_INBOX/`.
3. Verificar siempre el resultado ejecutando `hook list <ruta>`.
