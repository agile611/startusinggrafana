# Dashboards y visualización

Este bloque aborda la creación, configuración y personalización de dashboards y paneles en Grafana.

A lo largo del bloque, el alumno aprenderá a transformar las métricas recopiladas por Prometheus en una interfaz visual clara y útil para la monitorización.

El recorrido será:

```text
Métricas de Prometheus
        |
        v
Consultas PromQL
        |
        v
Paneles de Grafana
        |
        v
Dashboards
        |
        v
Monitorización visual
```

Grafana permite representar información mediante distintos tipos de visualización, aplicar unidades y umbrales, organizar paneles, transformar resultados y ampliar sus capacidades mediante plugins.

---

## Objetivos

Al finalizar este bloque, el alumno podrá:

- Explicar la diferencia entre un dashboard y un panel.
- Crear, guardar, editar y organizar dashboards.
- Crear paneles a partir de consultas PromQL.
- Seleccionar una visualización adecuada para cada tipo de dato.
- Configurar paneles de tipo Stat, Gauge, Bar Gauge, Time series, Heatmap, Text y Canvas.
- Configurar títulos, descripciones, leyendas y enlaces.
- Definir unidades, decimales y umbrales.
- Utilizar rangos temporales y variables de dashboard.
- Aplicar transformaciones a los resultados de las consultas.
- Crear dashboards orientados a la monitorización de servidores.
- Utilizar plugins de paneles de forma controlada.
- Diagnosticar paneles sin datos.
- Exportar y documentar dashboards.
- Construir un dashboard integrador utilizando Prometheus y Node Exporter.

---

## Prerrequisitos

Antes de comenzar este bloque, el alumno debe conocer:

- El funcionamiento básico de Grafana.
- El concepto de fuente de datos.
- La configuración de Prometheus en Grafana.
- El funcionamiento de Node Exporter.
- Los conceptos básicos de PromQL.
- Las métricas de CPU, memoria, almacenamiento y red.
- El acceso a la interfaz web de Grafana.

Comprobar que los servicios están activos:

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active node_exporter
```

```bash
systemctl is-active grafana-server
```

Resultado esperado:

```text
active
active
active
```

Comprobar que Prometheus responde:

```bash
curl http://localhost:9090/-/healthy
```

Comprobar que Node Exporter responde:

```bash
curl -I http://localhost:9100/metrics
```

Comprobar que Grafana responde:

```bash
curl -s http://localhost:3000/api/health | jq
```

---

# Conceptos principales

## Dashboard

Un dashboard es una página formada por varios paneles relacionados.

Puede representar, por ejemplo:

- Estado general de servidores.
- Uso de CPU.
- Memoria.
- Almacenamiento.
- Tráfico de red.
- Disponibilidad de servicios.
- Latencia.
- Errores.
- Alertas.

Un dashboard eficaz debe responder rápidamente a preguntas como:

- ¿Está disponible el sistema?
- ¿Existe algún objetivo caído?
- ¿Qué recurso está saturado?
- ¿Desde cuándo se produce el problema?
- ¿Qué servidores están afectados?
- ¿La situación está mejorando o empeorando?

## Panel

Un panel es una visualización individual dentro de un dashboard.

Ejemplos:

- Un panel Stat para mostrar el número de objetivos activos.
- Un panel Gauge para mostrar el porcentaje de memoria utilizada.
- Un panel Time series para representar la CPU durante la última hora.
- Un panel Text para documentar el propósito del dashboard.

## Consulta

La consulta obtiene los datos de la fuente de datos.

Ejemplo:

```promql
up
```

## Visualización

La visualización define cómo se muestran los resultados.

Ejemplos:

- Tabla.
- Gráfico temporal.
- Indicador.
- Histograma.
- Barra.
- Texto.
- Canvas.

## Umbral

Un umbral define un punto a partir del cual un valor cambia de color o se considera problemático.

Ejemplo:

```text
CPU inferior al 70 %: normal
CPU entre el 70 % y el 90 %: advertencia
CPU superior al 90 %: crítico
```

---

# Arquitectura del bloque

```text
04-dashboards-visualizacion/
│
├── 01-index.md
├── 02-conceptos-dashboards.md
├── 03-lista-dashboards.md
├── 04-manipulacion-paneles.md
├── 05-panel-stat.md
├── 06-panel-gauge.md
├── 07-panel-bar-gauge.md
├── 08-panel-time-series.md
├── 09-panel-heatmap.md
├── 10-panel-texto.md
├── 11-panel-canvas.md
├── 12-transformaciones.md
├── 13-plugins-paneles.md
└── 14-laboratorio.md
```

---

# Contenidos

## 1. Conceptos de dashboards

📄 [02-conceptos-dashboards.md](02-conceptos-dashboards.md)

En esta sección se estudian los conceptos fundamentales:

- Qué es un dashboard.
- Qué es un panel.
- Cómo se organiza la información.
- Cómo seleccionar una visualización.
- Cómo configurar unidades.
- Cómo configurar umbrales.
- Cómo utilizar rangos temporales.
- Cómo diseñar dashboards legibles.
- Principios básicos de visualización.
- Errores frecuentes de diseño.

---

## 2. Lista de dashboards

📄 [03-lista-dashboards.md](03-lista-dashboards.md)

En esta sección se trabaja con la gestión de dashboards:

- Crear dashboards.
- Abrir dashboards.
- Buscar dashboards.
- Organizar carpetas.
- Marcar dashboards como favoritos.
- Importar dashboards.
- Exportar dashboards.
- Copiar dashboards.
- Eliminar dashboards.
- Gestionar permisos básicos.
- Guardar versiones.

---

## 3. Manipulación de paneles

📄 [04-manipulacion-paneles.md](04-manipulacion-paneles.md)

En esta sección se aprende a:

- Crear paneles.
- Editar paneles.
- Mover paneles.
- Redimensionar paneles.
- Duplicar paneles.
- Eliminar paneles.
- Cambiar títulos.
- Añadir descripciones.
- Añadir enlaces.
- Configurar consultas.
- Configurar opciones generales.
- Guardar modificaciones.

---

## 4. Panel Stat

📄 [05-panel-stat.md](05-panel-stat.md)

El panel Stat muestra un valor resumido.

Ejemplos:

- Objetivos disponibles.
- Número de servidores.
- Estado de un servicio.
- Memoria disponible.
- Total de alertas.

Consulta de ejemplo:

```promql
sum(up)
```

Otra consulta:

```promql
100 * avg(up)
```

---

## 5. Panel Gauge

📄 [06-panel-gauge.md](06-panel-gauge.md)

El panel Gauge muestra un valor dentro de un rango visual.

Ejemplos:

- Uso de CPU.
- Uso de memoria.
- Uso de almacenamiento.
- Porcentaje de disponibilidad.

Consulta de ejemplo:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

---

## 6. Panel Bar Gauge

📄 [07-panel-bar-gauge.md](07-panel-bar-gauge.md)

El panel Bar Gauge facilita la comparación entre varias series.

Ejemplos:

- Uso de CPU por instancia.
- Uso de memoria por servidor.
- Espacio utilizado por punto de montaje.
- Tráfico por interfaz.

Consulta de ejemplo:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay"
  }
)
```

---

## 7. Panel Time series

📄 [08-panel-time-series.md](08-panel-time-series.md)

El panel Time series representa la evolución de una métrica a lo largo del tiempo.

Ejemplos:

- CPU durante la última hora.
- Memoria durante el día.
- Tráfico de red.
- Número de series.
- Latencia.
- Errores.

Consulta de ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

---

## 8. Panel Heatmap

📄 [09-panel-heatmap.md](09-panel-heatmap.md)

El panel Heatmap permite observar distribuciones de valores a lo largo del tiempo.

Es especialmente útil para:

- Latencias.
- Distribuciones.
- Histogramas.
- Tiempos de respuesta.
- Concentración de valores.
- Análisis de comportamiento.

---

## 9. Panel de texto

📄 [10-panel-texto.md](10-panel-texto.md)

El panel Text permite añadir información contextual al dashboard.

Puede utilizarse para:

- Documentar el dashboard.
- Explicar las métricas.
- Añadir instrucciones.
- Mostrar enlaces.
- Incluir advertencias.
- Definir el significado de los colores.

Ejemplo:

```markdown
## Monitorización de servidores

Este dashboard muestra:

- Disponibilidad de los objetivos.
- Uso de CPU.
- Uso de memoria.
- Uso del sistema de ficheros.
- Tráfico de red.

## Interpretación de colores

- Verde: estado normal.
- Amarillo: advertencia.
- Rojo: estado crítico.
```

---

## 10. Panel Canvas

📄 [11-panel-canvas.md](11-panel-canvas.md)

El panel Canvas permite crear diseños visuales personalizados.

Puede utilizarse para:

- Mapas de infraestructura.
- Diagramas.
- Vista general de servicios.
- Representación visual de servidores.
- Diseños con texto, formas e indicadores.
- Paneles operativos personalizados.

---

## 11. Transformaciones

📄 [12-transformaciones.md](12-transformaciones.md)

Las transformaciones modifican los datos obtenidos por una consulta antes de representarlos.

Se pueden utilizar para:

- Renombrar campos.
- Ocultar campos.
- Filtrar datos.
- Ordenar resultados.
- Combinar consultas.
- Reducir resultados.
- Crear campos calculados.
- Preparar datos para una visualización concreta.

Flujo:

```text
Consulta PromQL
      |
      v
Resultado original
      |
      v
Transformación
      |
      v
Resultado preparado
      |
      v
Visualización
```

---

## 12. Plugins y paneles

📄 [13-plugins-paneles.md](13-plugins-paneles.md)

Esta sección introduce la ampliación de Grafana mediante plugins.

Se estudiará:

- Qué es un plugin.
- Tipos de plugins.
- Plugins de paneles.
- Plugins de fuentes de datos.
- Plugins de aplicaciones.
- Instalación.
- Actualización.
- Eliminación.
- Compatibilidad.
- Seguridad.
- Plugins oficiales y de terceros.

---

## 13. Laboratorio integrador

📄 [14-laboratorio.md](14-laboratorio.md)

El laboratorio final integra todos los contenidos del bloque.

El alumno deberá construir un dashboard de monitorización utilizando Prometheus y Node Exporter.

---

# Sesión práctica 1: comprobar el entorno

## Objetivo

Comprobar que Grafana puede utilizar la fuente de datos Prometheus.

## Comandos

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active node_exporter
```

```bash
systemctl is-active grafana-server
```

```bash
curl http://localhost:9090/-/healthy
```

```bash
curl -I http://localhost:9100/metrics
```

```bash
curl -s http://localhost:3000/api/health | jq
```

## Actividades

1. Comprueba los tres servicios.
2. Anota las versiones.
3. Comprueba los puertos.
4. Accede a Grafana.
5. Comprueba que existe la fuente de datos Prometheus.
6. Ejecuta una consulta básica:

```promql
up
```

---

# Sesión práctica 2: crear el primer dashboard

## Objetivo

Crear un dashboard y añadir un panel de disponibilidad.

## Pasos

1. Acceder a:

```text
http://localhost:3000
```

2. Abrir **Dashboards**.
3. Crear un dashboard nuevo.
4. Añadir un panel.
5. Seleccionar Prometheus como fuente de datos.
6. Introducir:

```promql
up
```

7. Seleccionar la visualización **Table**.
8. Establecer el título:

```text
Estado de los objetivos
```

9. Guardar el dashboard.

## Actividades

1. Anota el nombre del dashboard.
2. Comprueba qué objetivos aparecen.
3. Comprueba el valor de cada objetivo.
4. Explica el significado de `1` y `0`.
5. Guarda una captura del panel.

---

# Sesión práctica 3: crear un dashboard de recursos

## Objetivo

Crear un dashboard con cuatro paneles de monitorización.

## Panel de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Visualización:

```text
Time series
```

Unidad:

```text
Percent (0-100)
```

Título:

```text
Uso de CPU
```

## Panel de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Visualización:

```text
Gauge
```

Unidad:

```text
Percent (0-100)
```

Título:

```text
Uso de memoria
```

## Panel de almacenamiento

Consulta:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

Visualización:

```text
Gauge
```

Unidad:

```text
Percent (0-100)
```

Título:

```text
Uso del sistema de ficheros raíz
```

## Panel de carga

Consulta:

```promql
node_load1
```

Visualización:

```text
Time series
```

Título:

```text
Carga del sistema
```

## Actividades

1. Crea los cuatro paneles.
2. Configura los títulos.
3. Configura las unidades.
4. Configura la leyenda.
5. Ajusta el rango temporal.
6. Guarda el dashboard.
7. Comprueba que todos los paneles muestran datos.

---

# Sesión práctica 4: configurar umbrales

## Objetivo

Aplicar colores según el nivel de utilización de un recurso.

## Panel de memoria

Utilizar la consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configurar los umbrales:

| Valor | Color | Interpretación |
|---:|---|---|
| 0 | Verde | Estado normal |
| 70 | Amarillo | Advertencia |
| 90 | Rojo | Estado crítico |

## Panel de almacenamiento

Utilizar la misma lógica para el sistema de ficheros.

Configurar:

```text
0 - 70: verde
70 - 90: amarillo
90 - 100: rojo
```

## Actividades

1. Configura los umbrales.
2. Cambia la unidad a porcentaje.
3. Comprueba el color actual.
4. Explica qué ocurriría al superar el 90 %.
5. Documenta los valores utilizados.

---

# Sesión práctica 5: añadir un panel de texto

## Objetivo

Documentar el propósito y la interpretación del dashboard.

Crear un panel de texto con:

```markdown
# Monitorización del servidor

Este dashboard muestra el estado general del servidor monitorizado mediante Prometheus y Node Exporter.

## Paneles incluidos

- Disponibilidad de los objetivos.
- Uso de CPU.
- Uso de memoria.
- Uso del sistema de ficheros.
- Carga del sistema.
- Tráfico de red.

## Interpretación

- Verde: estado normal.
- Amarillo: requiere revisión.
- Rojo: situación crítica.

## Fuente de datos

Prometheus.
```

## Actividades

1. Añade el panel de texto.
2. Utiliza títulos y listas.
3. Colócalo en la parte superior del dashboard.
4. Comprueba que el contenido se visualiza correctamente.
5. Guarda el dashboard.

---

# Sesión práctica 6: observar una caída

## Objetivo

Comprobar cómo cambia el dashboard cuando Node Exporter deja de responder.

## Pasos

Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Esperar varios intervalos de recopilación.

Consultar:

```promql
up{job="node_exporter"}
```

Comprobar los paneles:

- Disponibilidad.
- CPU.
- Memoria.
- Almacenamiento.
- Red.

Iniciar de nuevo el servicio:

```bash
sudo systemctl start node_exporter
```

Esperar al siguiente scraping.

Consultar:

```promql
up{job="node_exporter"}
```

## Actividades

1. Observa el cambio del panel de disponibilidad.
2. Anota qué paneles dejan de recibir datos.
3. Comprueba el mensaje del objetivo en Prometheus.
4. Inicia Node Exporter.
5. Comprueba la recuperación.
6. Explica por qué algunos paneles pueden mostrar datos históricos aunque el objetivo esté actualmente caído.

---

# Sesión práctica 7: utilizar transformaciones

## Objetivo

Preparar los resultados de una consulta para una visualización más clara.

Utilizar una consulta como:

```promql
up
```

Aplicar transformaciones para:

- Renombrar campos.
- Ocultar campos innecesarios.
- Ordenar resultados.
- Mostrar solo `job`, `instance` y `Value`.
- Cambiar el nombre de una columna.
- Filtrar objetivos concretos.

## Actividades

1. Crea un panel de tabla.
2. Ejecuta la consulta `up`.
3. Abre la sección de transformaciones.
4. Oculta las columnas que no sean necesarias.
5. Renombra `Value` como `Estado`.
6. Ordena por `job`.
7. Guarda el panel.
8. Comprueba que la tabla es más clara.

---

# Sesión práctica 8: exportar el dashboard

## Objetivo

Guardar una copia reutilizable del dashboard.

## Pasos

1. Abrir el dashboard.
2. Abrir el menú de opciones.
3. Seleccionar la opción de compartir o exportar.
4. Exportar el JSON.
5. Guardar el fichero con un nombre descriptivo.

Ejemplo:

```text
dashboard-monitorizacion-servidor.json
```

Crear un directorio de entregables:

```bash
mkdir -p ~/laboratorio-grafana/entregables
```

Guardar el fichero:

```text
~/laboratorio-grafana/entregables/dashboard-monitorizacion-servidor.json
```

## Actividades

1. Exporta el dashboard.
2. Comprueba que el fichero existe.
3. Revisa el contenido JSON.
4. Identifica la fuente de datos.
5. Identifica los paneles.
6. Comprueba las consultas PromQL.
7. Documenta el procedimiento de importación.

---

# Dashboard final recomendado

El dashboard final debe incluir al menos los siguientes paneles:

| Panel | Visualización | Consulta |
|---|---|---|
| Estado de objetivos | Table o Stat | `up` |
| Uso de CPU | Time series | Consulta de CPU |
| Uso de memoria | Gauge | Consulta de memoria |
| Uso de almacenamiento | Gauge | Consulta de filesystem |
| Carga del sistema | Time series | `node_load1` |
| Tráfico recibido | Time series | Consulta de red |
| Descripción | Text | Markdown |

## Distribución sugerida

```text
+------------------------------------------------------+
|              Descripción del dashboard               |
+----------------------+-------------------------------+
| Estado objetivos     | Uso de memoria                |
+----------------------+-------------------------------+
| Uso de CPU           | Uso de almacenamiento         |
+----------------------+-------------------------------+
| Carga del sistema    | Tráfico recibido              |
+----------------------+-------------------------------+
```

---

# Buenas prácticas de diseño

## Mostrar primero la información más importante

La parte superior del dashboard debe mostrar:

- Disponibilidad.
- Estado general.
- Alertas.
- Indicadores críticos.

## Utilizar títulos claros

Evitar títulos genéricos como:

```text
Panel 1
```

Utilizar:

```text
Uso de memoria del servidor
```

## Configurar correctamente las unidades

Ejemplos:

| Dato | Unidad |
|---|---|
| CPU | Porcentaje |
| Memoria | Porcentaje o bytes |
| Almacenamiento | Porcentaje o bytes |
| Tráfico | Bytes por segundo |
| Tiempo | Segundos |
| Disponibilidad | Ninguna o porcentaje |

## Evitar demasiados colores

Los colores deben comunicar estados, no decorar el panel.

Una convención sencilla:

```text
Verde: normal
Amarillo: advertencia
Rojo: crítico
```

## Mantener una jerarquía visual

Organizar los paneles de esta forma:

```text
Estado general
        |
        v
Recursos principales
        |
        v
Detalle operativo
        |
        v
Información adicional
```

## Documentar el dashboard

Añadir un panel de texto con:

- Propósito.
- Fuente de datos.
- Significado de los colores.
- Intervalo temporal.
- Descripción de las métricas.
- Responsable.
- Fecha de actualización.

---

# Problemas habituales

## El panel no muestra datos

Comprobar:

```promql
up
```

Después comprobar:

```promql
node_memory_MemAvailable_bytes
```

Revisar:

- Fuente de datos.
- Consulta.
- Rango temporal.
- Estado del target.
- Etiquetas.
- Variables.
- Transformaciones.

## La unidad es incorrecta

Una métrica de bytes puede aparecer como un número grande si no se configura la unidad.

Por ejemplo:

```promql
node_memory_MemAvailable_bytes
```

Debe mostrarse como:

```text
bytes
```

o:

```text
gibibytes
```

## El panel muestra demasiadas series

Aplicar:

- Filtros.
- Agregaciones.
- Transformaciones.
- Exclusión de interfaces.
- Selección de una instancia.

Ejemplo:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## El gráfico aparece plano

Posibles causas:

- La métrica cambia poco.
- El rango temporal es demasiado amplio.
- El rango temporal es demasiado corto.
- La consulta no utiliza `rate()` cuando debería.
- La unidad no está configurada.
- El panel está agregando demasiadas series.

## El dashboard es difícil de leer

Revisar:

- Títulos.
- Tamaño de los paneles.
- Colores.
- Unidades.
- Número de series.
- Leyendas.
- Orden de los paneles.
- Rango temporal.
- Paneles innecesarios.

---

# Evidencias del bloque

Crear un directorio de evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/bloque-4
```

Guardar la información del sistema:

```bash
{
  echo "===== BLOQUE 4 ====="
  echo "Fecha: $(date)"
  echo "Hostname: $(hostname)"
  echo
  echo "===== SERVICIOS ====="
  systemctl is-active prometheus
  systemctl is-active node_exporter
  systemctl is-active grafana-server
  echo
  echo "===== VERSIONES ====="
  prometheus --version 2>&1
  node_exporter --version 2>&1
  echo
  echo "===== SALUD ====="
  curl -s http://localhost:9090/-/healthy
  echo
  curl -s http://localhost:3000/api/health
} | tee \
  ~/laboratorio-grafana/evidencias/bloque-4/estado-inicial.txt
```

Guardar las consultas PromQL:

```bash
cat > ~/laboratorio-grafana/evidencias/bloque-4/consultas-promql.txt <<'EOF'
Disponibilidad:
up

Uso de CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Uso de memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Uso del sistema de ficheros:
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)

Carga:
node_load1

Tráfico recibido:
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
EOF
```

Guardar el estado de los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq \
  > ~/laboratorio-grafana/evidencias/bloque-4/targets.json
```

Guardar la configuración cargada:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml' \
  > ~/laboratorio-grafana/evidencias/bloque-4/configuracion-cargada.yml
```

---

# Práctica final del bloque

## Objetivo

Crear un dashboard de monitorización de un servidor Linux utilizando las métricas de Prometheus y Node Exporter.

## Requisitos

El dashboard debe incluir:

1. Un título descriptivo.
2. Un panel de texto.
3. Un panel de disponibilidad.
4. Un panel de uso de CPU.
5. Un panel de uso de memoria.
6. Un panel de almacenamiento.
7. Un panel de carga.
8. Un panel de tráfico de red.
9. Unidades configuradas.
10. Umbrales configurados.
11. Una distribución ordenada.
12. Una descripción del dashboard.
13. Una fuente de datos Prometheus.
14. Consultas PromQL válidas.

## Tareas

1. Crear el dashboard.
2. Nombrarlo:

```text
Monitorización de servidor Linux
```

3. Añadir el panel de texto.
4. Añadir el panel de disponibilidad.
5. Añadir el panel de CPU.
6. Añadir el panel de memoria.
7. Añadir el panel de almacenamiento.
8. Añadir el panel de carga.
9. Añadir el panel de red.
10. Configurar unidades.
11. Configurar umbrales.
12. Ajustar tamaños.
13. Guardar el dashboard.
14. Exportarlo como JSON.
15. Detener Node Exporter.
16. Observar el comportamiento.
17. Iniciar Node Exporter.
18. Comprobar la recuperación.
19. Guardar capturas.
20. Crear un informe final.

---

# Criterios de evaluación

| Criterio | Puntuación |
|---|---:|
| Organización del dashboard | 1 punto |
| Panel de texto y documentación | 1 punto |
| Panel de disponibilidad | 1 punto |
| Panel de CPU | 1,5 puntos |
| Panel de memoria | 1,5 puntos |
| Panel de almacenamiento | 1 punto |
| Paneles de carga y red | 1 punto |
| Unidades y umbrales | 1 punto |
| Exportación y evidencias | 0,5 puntos |
| **Total** | **10 puntos** |

## Requisitos para superar el bloque

El dashboard debe:

- Mostrar datos reales.
- Utilizar Prometheus como fuente de datos.
- Contener consultas PromQL válidas.
- Tener títulos comprensibles.
- Utilizar unidades adecuadas.
- Mostrar correctamente los umbrales.
- Ser legible.
- Incluir documentación.
- Haber sido probado con un objetivo disponible y uno caído.
- Estar exportado y documentado.

---

# Entregables

La entrega debe contener:

```text
bloque-4-entrega/
├── dashboard-monitorizacion-servidor.json
├── consultas-promql.txt
├── informe.md
└── evidencias/
    ├── estado-inicial.txt
    ├── targets.json
    ├── configuracion-cargada.yml
    ├── captura-dashboard.png
    ├── captura-target-up.png
    ├── captura-target-down.png
    └── captura-recuperacion.png
```

El informe debe incluir:

- Nombre del dashboard.
- Fuente de datos utilizada.
- Descripción de los paneles.
- Consultas PromQL.
- Unidades configuradas.
- Umbrales utilizados.
- Resultado de la prueba de caída.
- Resultado de la recuperación.
- Problemas encontrados.
- Soluciones aplicadas.
- Conclusiones.

---

# Preguntas de comprobación

1. ¿Qué diferencia existe entre un dashboard y un panel?
2. ¿Qué función cumple una fuente de datos?
3. ¿Qué visualización utilizarías para mostrar un único valor?
4. ¿Qué visualización utilizarías para representar la evolución temporal de una métrica?
5. ¿Qué visualización utilizarías para comparar varias instancias?
6. ¿Qué visualización puede utilizarse para representar un porcentaje frente a un rango?
7. ¿Qué consulta utilizarías para mostrar la disponibilidad?
8. ¿Qué consulta utilizarías para calcular el uso de CPU?
9. ¿Qué consulta utilizarías para calcular el uso de memoria?
10. ¿Qué consulta utilizarías para calcular el espacio utilizado?
11. ¿Por qué se utiliza `rate()` con algunas métricas?
12. ¿Qué función cumplen los umbrales?
13. ¿Qué unidad utilizarías para el tráfico de red?
14. ¿Qué unidad utilizarías para la memoria?
15. ¿Qué información incluirías en un panel de texto?
16. ¿Qué función cumplen las transformaciones?
17. ¿Qué precauciones deben tomarse al instalar plugins?
18. ¿Qué comprobarías si un panel no muestra datos?
19. ¿Qué ocurre con los paneles cuando Node Exporter está detenido?
20. ¿Por qué pueden seguir apareciendo datos históricos después de una caída?
21. ¿Qué evidencias deben incluirse en la entrega?
22. ¿Qué características debe tener un dashboard bien diseñado?
23. ¿Por qué no conviene utilizar demasiados colores?
24. ¿Qué ventajas tiene exportar un dashboard como JSON?
25. ¿Qué elementos debe contener el dashboard final?

---

# Puntos clave

- Un dashboard agrupa paneles relacionados.
- Un panel representa una consulta o conjunto de datos.
- Cada visualización debe seleccionarse según el tipo de información.
- Los paneles Stat son adecuados para valores resumidos.
- Los paneles Gauge son útiles para porcentajes y rangos.
- Los paneles Bar Gauge permiten comparar varios valores.
- Los paneles Time series muestran la evolución temporal.
- Los Heatmaps muestran distribuciones y concentraciones.
- Los paneles Text documentan el dashboard.
- Canvas permite crear diseños visuales personalizados.
- Las transformaciones preparan los datos para su visualización.
- Los plugins amplían las capacidades de Grafana.
- Las unidades deben corresponder al significado de la métrica.
- Los umbrales deben estar documentados.
- La información más importante debe aparecer en la parte superior.
- Los dashboards deben ser legibles y no excesivamente complejos.
- La consulta `up` es una comprobación inicial fundamental.
- Un panel vacío no siempre significa que Grafana esté desconectado.
- El dashboard debe probarse en situaciones normales y de error.
- La documentación y las evidencias forman parte del resultado técnico.

---

# Navegación del módulo

1. [Conceptos de dashboards](02-conceptos-dashboards.md)
2. [Lista de dashboards](03-lista-dashboards.md)
3. [Manipulación de paneles](04-manipulacion-paneles.md)
4. [Panel Stat](05-panel-stat.md)
5. [Panel Gauge](06-panel-gauge.md)
6. [Panel Bar Gauge](07-panel-bar-gauge.md)
7. [Panel Time series](08-panel-time-series.md)
8. [Panel Heatmap](09-panel-heatmap.md)
9. [Panel de texto](10-panel-texto.md)
10. [Panel Canvas](11-panel-canvas.md)
11. [Transformaciones](12-transformaciones.md)
12. [Plugins y paneles](13-plugins-paneles.md)
13. [Laboratorio integrador](14-laboratorio.md)

---

# Resultado final esperado

Al finalizar el bloque, el alumno debe comprender el siguiente flujo:

```text
Consultar métricas con PromQL
        |
        v
Crear un panel
        |
        v
Seleccionar una visualización
        |
        v
Configurar unidades y umbrales
        |
        v
Organizar el dashboard
        |
        v
Aplicar transformaciones
        |
        v
Probar situaciones normales y de error
        |
        v
Exportar y documentar el resultado
```

El producto final será un dashboard de Grafana funcional, legible y documentado para monitorizar un servidor Linux mediante Prometheus y Node Exporter.