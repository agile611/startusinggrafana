#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-curso-grafana}"

echo "Creando estructura en: ${ROOT_DIR}"

mkdir -p "${ROOT_DIR}"
cd "${ROOT_DIR}"

# -------------------------------------------------------------------
# Funciones auxiliares
# -------------------------------------------------------------------

create_file() {
    local file="$1"

    mkdir -p "$(dirname "${file}")"

    if [[ ! -f "${file}" ]]; then
        touch "${file}"
        echo "Creado: ${file}"
    else
        echo "Existe, no se modifica: ${file}"
    fi
}

create_generic_markdown() {
    local file="$1"
    local title="$2"

    create_file "${file}"

    if [[ ! -s "${file}" ]]; then
        cat > "${file}" <<EOF
# ${title}

## Objetivos

- [Pendiente]
- [Pendiente]

## Introducción

[Pendiente]

## Contenido

[Pendiente]

## Ejemplo

[Pendiente]

## Puntos clave

- [Pendiente]
- [Pendiente]

## Preguntas de comprobación

1. [Pendiente]
2. [Pendiente]
EOF
    fi
}

create_index_markdown() {
    local file="$1"
    local title="$2"
    local description="$3"

    create_file "${file}"

    if [[ ! -s "${file}" ]]; then
        cat > "${file}" <<EOF
# ${title}

${description}

## Objetivos

- [Pendiente]
- [Pendiente]
- [Pendiente]

## Contenidos

- [Pendiente]
- [Pendiente]

## Prácticas relacionadas

- [Pendiente]
EOF
    fi
}

# -------------------------------------------------------------------
# Directorios principales
# -------------------------------------------------------------------

mkdir -p \
    docs \
    assets/images \
    assets/diagrams \
    assets/dashboards \
    assets/alert-rules

# -------------------------------------------------------------------
# README.md
# -------------------------------------------------------------------

cat > README.md <<'EOF'
# Curso de Grafana

Curso práctico de Grafana utilizando Ubuntu 24.04.5 LTS como entorno de laboratorio.

## Duración

- Duración total: 25 horas
- Modalidad: [Pendiente]
- Nivel: [Pendiente]

## Contenidos

- Fundamentos de telemetría
- Instalación y configuración de Grafana
- Prometheus y Node Exporter
- Dashboards y visualización
- Anotaciones y alertas
- Proyecto final

## Entorno

- Ubuntu 24.04.5 LTS
- Grafana: [Versión pendiente]
- Prometheus: [Versión pendiente]
- Node Exporter: [Versión pendiente]

## Documentación

La documentación está disponible en:

[URL de GitHub Pages pendiente]
EOF

# -------------------------------------------------------------------
# mkdocs.yml
# -------------------------------------------------------------------

cat > mkdocs.yml <<'EOF'
site_name: Curso de Grafana
site_description: Curso práctico de Grafana sobre Ubuntu 24.04.5 LTS
site_author: [Pendiente]
site_url: ""

theme:
  name: material
  language: es
  features:
    - navigation.sections
    - navigation.expand
    - content.code.copy
    - content.tabs.link
    - search.suggest
    - search.highlight

markdown_extensions:
  - admonition
  - attr_list
  - pymdownx.details
  - pymdownx.highlight
  - pymdownx.inlinehilite
  - pymdownx.superfences
  - pymdownx.tabbed
  - tables
  - toc:
      permalink: true

nav:
  - Inicio: index.md
  - Objetivos: objetivos.md
  - Requisitos previos: requisitos-previos.md
  - Entorno de laboratorio: entorno-laboratorio.md

  - Bloque 1 - Fundamentos de telemetría:
      - Introducción: 01-fundamentos-telemetria/index.md
      - Conceptos de telemetría: 01-fundamentos-telemetria/telemetria.md
      - Modelo push y pull: 01-fundamentos-telemetria/modelo-push-pull.md
      - Series temporales: 01-fundamentos-telemetria/series-temporales.md
      - Muestreo: 01-fundamentos-telemetria/muestreo.md
      - Retención de datos: 01-fundamentos-telemetria/retencion-datos.md
      - Downsampling: 01-fundamentos-telemetria/downsampling.md
      - Grafana y fuentes de datos: 01-fundamentos-telemetria/grafana-fuentes-datos.md
      - Laboratorio: 01-fundamentos-telemetria/laboratorio.md

  - Bloque 2 - Grafana:
      - Introducción: 02-grafana/index.md
      - Requisitos del sistema: 02-grafana/requisitos-sistema.md
      - Instalación en Ubuntu: 02-grafana/instalacion-ubuntu.md
      - Acceso a Grafana: 02-grafana/acceso-grafana.md
      - Configuración inicial: 02-grafana/configuracion-inicial.md
      - Dashboards, filas y paneles: 02-grafana/dashboards-filas-paneles.md
      - Selector de rango de tiempo: 02-grafana/selector-rango-tiempo.md
      - Tiempo relativo y desplazamiento: 02-grafana/tiempo-relativo.md
      - Laboratorio: 02-grafana/laboratorio.md

  - Bloque 3 - Prometheus y fuentes de datos:
      - Introducción: 03-prometheus-fuentes-datos/index.md
      - Arquitectura de Prometheus: 03-prometheus-fuentes-datos/arquitectura-prometheus.md
      - Instalación de Prometheus: 03-prometheus-fuentes-datos/instalacion-prometheus.md
      - Interfaz web: 03-prometheus-fuentes-datos/interfaz-web-prometheus.md
      - Instalación de Node Exporter: 03-prometheus-fuentes-datos/instalacion-node-exporter.md
      - Configuración de scraping: 03-prometheus-fuentes-datos/configuracion-scrape.md
      - Consultas PromQL: 03-prometheus-fuentes-datos/consultas-promql.md
      - Añadir fuente de datos: 03-prometheus-fuentes-datos/anadir-fuente-datos.md
      - Laboratorio: 03-prometheus-fuentes-datos/laboratorio.md

  - Bloque 4 - Dashboards y visualización:
      - Introducción: 04-dashboards-visualizacion/index.md
      - Conceptos de dashboards: 04-dashboards-visualizacion/conceptos-dashboards.md
      - Panel Time series: 04-dashboards-visualizacion/panel-time-series.md
      - Panel Stat: 04-dashboards-visualizacion/panel-stat.md
      - Panel Gauge: 04-dashboards-visualizacion/panel-gauge.md
      - Panel Bar gauge: 04-dashboards-visualizacion/panel-bar-gauge.md
      - Panel Heatmap: 04-dashboards-visualizacion/panel-heatmap.md
      - Panel de texto: 04-dashboards-visualizacion/panel-texto.md
      - Panel Canvas: 04-dashboards-visualizacion/panel-canvas.md
      - Lista de dashboards: 04-dashboards-visualizacion/lista-dashboards.md
      - Plugins de paneles: 04-dashboards-visualizacion/plugins-paneles.md
      - Transformaciones: 04-dashboards-visualizacion/transformaciones.md
      - Manipulación de paneles: 04-dashboards-visualizacion/manipulacion-paneles.md
      - Laboratorio: 04-dashboards-visualizacion/laboratorio.md

  - Bloque 5 - Anotaciones y alertas:
      - Introducción: 05-anotaciones-alertas/index.md
      - Anotaciones: 05-anotaciones-alertas/anotaciones.md
      - Alertas: 05-anotaciones-alertas/alertas.md
      - Reglas de alerta: 05-anotaciones-alertas/reglas-alerta.md
      - Condiciones y expresiones: 05-anotaciones-alertas/condiciones-expresiones.md
      - Lista de alertas: 05-anotaciones-alertas/lista-alertas.md
      - Contactos de notificación: 05-anotaciones-alertas/contactos-notificacion.md
      - Políticas de notificación: 05-anotaciones-alertas/politicas-notificacion.md
      - Silenciados: 05-anotaciones-alertas/silenciados.md
      - Correo electrónico: 05-anotaciones-alertas/correo-electronico.md
      - Otras notificaciones: 05-anotaciones-alertas/otras-notificaciones.md
      - Laboratorio: 05-anotaciones-alertas/laboratorio.md

  - Bloque 6 - Proyecto final:
      - Introducción: 06-proyecto-final/index.md
      - Escenario: 06-proyecto-final/escenario.md
      - Requisitos: 06-proyecto-final/requisitos.md
      - Tareas: 06-proyecto-final/tareas.md
      - Entregables: 06-proyecto-final/entregables.md
      - Criterios de evaluación: 06-proyecto-final/criterios-evaluacion.md

  - Prácticas:
      - Índice: practicas/index.md
      - Práctica 1 - Primer dashboard: practicas/practica-01-primer-dashboard.md
      - Práctica 2 - Node Exporter: practicas/practica-02-node-exporter.md
      - Práctica 3 - PromQL: practicas/practica-03-promql.md
      - Práctica 4 - Dashboard operativo: practicas/practica-04-dashboard-operativo.md
      - Práctica 5 - Alertas: practicas/practica-05-alertas.md

  - Referencia:
      - Índice: referencia/index.md
      - Comandos de Ubuntu: referencia/comandos-ubuntu.md
      - Consultas PromQL: referencia/promql.md
      - Servicios y puertos: referencia/servicios-puertos.md
      - Rutas y ficheros: referencia/rutas-ficheros.md
      - Variables y etiquetas: referencia/variables-etiquetas.md
      - Enlaces útiles: referencia/enlaces-utiles.md

  - Resolución de problemas:
      - Índice: resolucion-problemas/index.md
      - Instalación: resolucion-problemas/instalacion.md
      - Acceso a Grafana: resolucion-problemas/acceso-grafana.md
      - Prometheus: resolucion-problemas/prometheus.md
      - Node Exporter: resolucion-problemas/node-exporter.md
      - Fuentes de datos: resolucion-problemas/fuentes-datos.md
      - Dashboards: resolucion-problemas/dashboards.md
      - Alertas: resolucion-problemas/alertas.md
EOF

# -------------------------------------------------------------------
# Páginas generales
# -------------------------------------------------------------------

cat > docs/index.md <<'EOF'
# Curso de Grafana

Curso práctico de monitorización y visualización con Grafana sobre Ubuntu 24.04.5 LTS.

## Navegación

- [Objetivos](objetivos.md)
- [Requisitos previos](requisitos-previos.md)
- [Entorno de laboratorio](entorno-laboratorio.md)
- [Bloque 1 - Fundamentos de telemetría](01-fundamentos-telemetria/index.md)
- [Bloque 2 - Grafana](02-grafana/index.md)
- [Bloque 3 - Prometheus y fuentes de datos](03-prometheus-fuentes-datos/index.md)
- [Bloque 4 - Dashboards y visualización](04-dashboards-visualizacion/index.md)
- [Bloque 5 - Anotaciones y alertas](05-anotaciones-alertas/index.md)
- [Bloque 6 - Proyecto final](06-proyecto-final/index.md)
EOF

create_generic_markdown "docs/objetivos.md" "Objetivos del curso"
create_generic_markdown "docs/requisitos-previos.md" "Requisitos previos"

cat > docs/entorno-laboratorio.md <<'EOF'
# Entorno de laboratorio

## Sistema operativo

- Distribución: Ubuntu
- Versión: 24.04.5 LTS
- Hostname: [Pendiente]
- Dirección IP: [Pendiente]

## Componentes

| Componente | Versión | Puerto | Estado |
|---|---:|---:|---|
| Grafana | [Pendiente] | 3000 | [Pendiente] |
| Prometheus | [Pendiente] | 9090 | [Pendiente] |
| Node Exporter | [Pendiente] | 9100 | [Pendiente] |

## Arquitectura

[Diagrama pendiente]

## Usuarios

[Pendiente]

## Verificaciones iniciales

[Pendiente]
EOF

# -------------------------------------------------------------------
# Bloque 1 - Fundamentos de telemetría
# -------------------------------------------------------------------

create_index_markdown \
    "docs/01-fundamentos-telemetria/index.md" \
    "Bloque 1 - Fundamentos de telemetría" \
    "En este bloque se presentan los conceptos necesarios para comprender la monitorización basada en métricas."

for item in \
    "telemetria|Conceptos de telemetría" \
    "modelo-push-pull|Modelo push y pull" \
    "series-temporales|Series temporales" \
    "muestreo|Muestreo de datos" \
    "retencion-datos|Retención de datos" \
    "downsampling|Downsampling" \
    "grafana-fuentes-datos|Grafana y las fuentes de datos"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/01-fundamentos-telemetria/${file}.md" \
        "${title}"
done

create_generic_markdown \
    "docs/01-fundamentos-telemetria/laboratorio.md" \
    "Laboratorio - Fundamentos de telemetría"

# -------------------------------------------------------------------
# Bloque 2 - Grafana
# -------------------------------------------------------------------

create_index_markdown \
    "docs/02-grafana/index.md" \
    "Bloque 2 - Grafana" \
    "Este bloque cubre la instalación, configuración inicial y primeros pasos con Grafana."

for item in \
    "requisitos-sistema|Requisitos del sistema" \
    "instalacion-ubuntu|Instalación de Grafana en Ubuntu 24.04.5 LTS" \
    "acceso-grafana|Acceso a Grafana" \
    "configuracion-inicial|Configuración inicial" \
    "dashboards-filas-paneles|Dashboards, filas y paneles" \
    "selector-rango-tiempo|Selector de rango de tiempo" \
    "tiempo-relativo|Tiempo relativo y desplazamiento de tiempo"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/02-grafana/${file}.md" \
        "${title}"
done

create_generic_markdown \
    "docs/02-grafana/laboratorio.md" \
    "Laboratorio - Instalación y primeros pasos con Grafana"

# -------------------------------------------------------------------
# Bloque 3 - Prometheus y fuentes de datos
# -------------------------------------------------------------------

create_index_markdown \
    "docs/03-prometheus-fuentes-datos/index.md" \
    "Bloque 3 - Prometheus y fuentes de datos" \
    "Este bloque presenta Prometheus, Node Exporter, PromQL y la integración con Grafana."

for item in \
    "arquitectura-prometheus|Arquitectura de Prometheus" \
    "instalacion-prometheus|Instalación de Prometheus" \
    "interfaz-web-prometheus|Interfaz web de Prometheus" \
    "instalacion-node-exporter|Instalación de Node Exporter" \
    "configuracion-scrape|Configuración de scraping" \
    "consultas-promql|Consultas PromQL" \
    "anadir-fuente-datos|Añadir una fuente de datos en Grafana"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/03-prometheus-fuentes-datos/${file}.md" \
        "${title}"
done

create_generic_markdown \
    "docs/03-prometheus-fuentes-datos/laboratorio.md" \
    "Laboratorio - Prometheus, Node Exporter y fuentes de datos"

# -------------------------------------------------------------------
# Bloque 4 - Dashboards y visualización
# -------------------------------------------------------------------

create_index_markdown \
    "docs/04-dashboards-visualizacion/index.md" \
    "Bloque 4 - Dashboards y visualización" \
    "Este bloque aborda la creación y personalización de dashboards y paneles en Grafana."

for item in \
    "conceptos-dashboards|Conceptos de dashboards" \
    "panel-time-series|Panel Time series" \
    "panel-stat|Panel Stat" \
    "panel-gauge|Panel Gauge" \
    "panel-bar-gauge|Panel Bar gauge" \
    "panel-heatmap|Panel Heatmap" \
    "panel-texto|Panel de texto" \
    "panel-canvas|Panel Canvas" \
    "lista-dashboards|Lista de dashboards" \
    "plugins-paneles|Plugins de paneles" \
    "transformaciones|Transformaciones" \
    "manipulacion-paneles|Manipulación de paneles"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/04-dashboards-visualizacion/${file}.md" \
        "${title}"
done

create_generic_markdown \
    "docs/04-dashboards-visualizacion/laboratorio.md" \
    "Laboratorio - Dashboards y visualización"

# -------------------------------------------------------------------
# Bloque 5 - Anotaciones y alertas
# -------------------------------------------------------------------

create_index_markdown \
    "docs/05-anotaciones-alertas/index.md" \
    "Bloque 5 - Anotaciones y alertas" \
    "Este bloque cubre la creación de anotaciones, reglas de alerta y mecanismos de notificación."

for item in \
    "anotaciones|Anotaciones" \
    "alertas|Alertas en Grafana" \
    "reglas-alerta|Reglas de alerta" \
    "condiciones-expresiones|Condiciones y expresiones" \
    "lista-alertas|Lista de alertas" \
    "contactos-notificacion|Contactos de notificación" \
    "politicas-notificacion|Políticas de notificación" \
    "silenciados|Silenciados" \
    "correo-electronico|Correo electrónico" \
    "otras-notificaciones|Otras formas de notificación"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/05-anotaciones-alertas/${file}.md" \
        "${title}"
done

create_generic_markdown \
    "docs/05-anotaciones-alertas/laboratorio.md" \
    "Laboratorio - Anotaciones y alertas"

# -------------------------------------------------------------------
# Bloque 6 - Proyecto final
# -------------------------------------------------------------------

create_index_markdown \
    "docs/06-proyecto-final/index.md" \
    "Bloque 6 - Proyecto final" \
    "El proyecto final integra los conocimientos adquiridos durante el curso."

for item in \
    "escenario|Escenario del proyecto" \
    "requisitos|Requisitos" \
    "tareas|Tareas" \
    "entregables|Entregables" \
    "criterios-evaluacion|Criterios de evaluación"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown \
        "docs/06-proyecto-final/${file}.md" \
        "${title}"
done

# -------------------------------------------------------------------
# Prácticas
# -------------------------------------------------------------------

create_file "docs/practicas/index.md"

cat > docs/practicas/index.md <<'EOF'
# Prácticas

Listado de prácticas independientes o asociadas a los bloques del curso.

- [Práctica 1 - Primer dashboard](practica-01-primer-dashboard.md)
- [Práctica 2 - Node Exporter](practica-02-node-exporter.md)
- [Práctica 3 - Consultas PromQL](practica-03-promql.md)
- [Práctica 4 - Dashboard operativo](practica-04-dashboard-operativo.md)
- [Práctica 5 - Alertas](practica-05-alertas.md)
EOF

for item in \
    "practica-01-primer-dashboard|Práctica 1 - Primer dashboard" \
    "practica-02-node-exporter|Práctica 2 - Node Exporter" \
    "practica-03-promql|Práctica 3 - Consultas PromQL" \
    "practica-04-dashboard-operativo|Práctica 4 - Dashboard operativo" \
    "practica-05-alertas|Práctica 5 - Alertas"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown "docs/practicas/${file}.md" "${title}"
done

# -------------------------------------------------------------------
# Referencia
# -------------------------------------------------------------------

create_file "docs/referencia/index.md"

cat > docs/referencia/index.md <<'EOF'
# Material de referencia

- [Comandos de Ubuntu](comandos-ubuntu.md)
- [Consultas PromQL](promql.md)
- [Servicios y puertos](servicios-puertos.md)
- [Rutas y ficheros](rutas-ficheros.md)
- [Variables y etiquetas](variables-etiquetas.md)
- [Enlaces útiles](enlaces-utiles.md)
EOF

for item in \
    "comandos-ubuntu|Comandos de Ubuntu" \
    "promql|Consultas PromQL" \
    "servicios-puertos|Servicios y puertos" \
    "rutas-ficheros|Rutas y ficheros" \
    "variables-etiquetas|Variables y etiquetas" \
    "enlaces-utiles|Enlaces útiles"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown "docs/referencia/${file}.md" "${title}"
done

# -------------------------------------------------------------------
# Resolución de problemas
# -------------------------------------------------------------------

create_file "docs/resolucion-problemas/index.md"

cat > docs/resolucion-problemas/index.md <<'EOF'
# Resolución de problemas

- [Problemas de instalación](instalacion.md)
- [Problemas de acceso a Grafana](acceso-grafana.md)
- [Problemas con Prometheus](prometheus.md)
- [Problemas con Node Exporter](node-exporter.md)
- [Problemas con las fuentes de datos](fuentes-datos.md)
- [Problemas con dashboards](dashboards.md)
- [Problemas con alertas](alertas.md)
EOF

for item in \
    "instalacion|Problemas de instalación" \
    "acceso-grafana|Problemas de acceso a Grafana" \
    "prometheus|Problemas con Prometheus" \
    "node-exporter|Problemas con Node Exporter" \
    "fuentes-datos|Problemas con las fuentes de datos" \
    "dashboards|Problemas con dashboards" \
    "alertas|Problemas con alertas"
do
    IFS='|' read -r file title <<< "${item}"
    create_generic_markdown "docs/resolucion-problemas/${file}.md" "${title}"
done

echo
echo "Estructura creada correctamente."
echo
echo "Repositorio: ${ROOT_DIR}"
echo "Archivos Markdown: $(find docs -type f -name '*.md' | wc -l)"
echo
echo "Siguiente paso:"
echo "  cd ${ROOT_DIR}"
echo "  git init"

