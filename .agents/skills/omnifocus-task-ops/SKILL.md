---
name: omnifocus-task-ops
description: >-
  Manage project tasks, action items, and project status in OmniFocus on macOS using the
  official OmniFocus CLI (`of`) or AppleScript (`osascript`). Use when listing tasks,
  creating project-assigned tasks, completing action items, or inspecting project state.
---

# 🎯 OmniFocus Task Operations (`omnifocus-task-ops`)

Esta skill define la interacción canónica con **OmniFocus** para el proyecto `MKT 499`.

## 🏛️ Configuración del Proyecto
* **Proyecto OmniFocus:** `MKT PRO499 HUGO-SC`
* **Carpeta OmniFocus:** `DM Proyectos`
* **CLI Principal:** `of` (`/Users/tlon/Library/Application Support/reflex/bun/bin/of`)

## ⚡ Comandos Canónicos de CLI (`of`)

### 1. Listar tareas del proyecto
```bash
# Ver tareas activas:
of task list --project "MKT PRO499 HUGO-SC"

# Ver todas (incluyendo completadas):
of task list --project "MKT PRO499 HUGO-SC" --completed
```

### 2. Crear nueva tarea vinculada al proyecto
```bash
# Creación directa en el proyecto:
of task create "Nombre de la tarea" -p "MKT PRO499 HUGO-SC"

# Con fecha de vencimiento y nota:
of task create "Nombre de la tarea" -p "MKT PRO499 HUGO-SC" --due YYYY-MM-DD --note "Detalles adicionales"
```

### 3. Completar o actualizar una tarea
```bash
of task update <ID_O_NOMBRE> --complete
```

### 4. Inspeccionar detalles
```bash
of task view <ID_O_NOMBRE>
of project view "MKT PRO499 HUGO-SC"
```

## 🍎 Automatización vía AppleScript (`osascript`)
Para manipulaciones por lotes o asignación de propiedades avanzadas no soportadas directamente por el CLI:

```bash
osascript << 'EOF'
tell application "OmniFocus"
    tell default document
        set targetProj to first flattened project whose name is "MKT PRO499 HUGO-SC"
        tell targetProj
            make new task with properties {name:"Tarea desde AppleScript", note:"Detalle técnico"}
        end tell
    end tell
end tell
EOF
```

## 🛡️ Reglas Operativas Obligatorias
1. **Destino obligatorio:** Toda tarea debe crearse explícitamente dentro de `MKT PRO499 HUGO-SC` (`-p "MKT PRO499 HUGO-SC"`). PROHIBIDO enviar tareas al `Inbox` huérfano.
2. **Verificación inmediata:** Tras crear o completar una tarea, verificar su estado ejecutando `of task list --project "MKT PRO499 HUGO-SC"`.
