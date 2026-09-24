# Laboratorio - Dashboards y visualización

Este laboratorio integra los principales conceptos de la sección de dashboards y visualización de Grafana.

Durante la práctica, el alumno creará un dashboard operativo utilizando diferentes tipos de paneles, consultas PromQL, transformaciones, variables, documentación y, si está disponible, un plugin de panel.

El laboratorio está diseñado para trabajar con:

- Grafana.
- Prometheus.
- Node Exporter.
- Métricas de infraestructura.
- Paneles estándar de Grafana.
- Transformaciones.
- Variables de dashboard.
- Paneles Text y Canvas.
- Exportación e importación de dashboards.
- Diagnóstico de errores.

El objetivo no es únicamente crear gráficos. El objetivo es construir un dashboard **comprensible, documentado, reutilizable y útil para la operación**.

---

### Objetivos

Al finalizar este laboratorio, el alumno podrá:

- Crear un dashboard completo en Grafana.
- Configurar una fuente de datos Prometheus.
- Utilizar consultas PromQL de infraestructura.
- Crear paneles Stat, Gauge, Bar Gauge, Time series, Table, Heatmap, Text y Canvas.
- Configurar unidades, títulos, descripciones y umbrales.
- Crear variables de dashboard.
- Utilizar transformaciones.
- Comparar valores actuales y tendencias.
- Documentar el propósito del dashboard.
- Crear una vista visual de la infraestructura.
- Analizar disponibilidad, CPU, memoria, almacenamiento y red.
- Simular una incidencia controlada.
- Observar el cambio de las métricas.
- Diagnosticar paneles sin datos.
- Exportar el dashboard.
- Importar una copia del dashboard.
- Documentar las dependencias y las consultas.
- Evaluar la calidad y mantenibilidad del resultado.
- Comprender cuándo utilizar paneles integrados o plugins.

---

## Introducción

Un dashboard de monitorización debe responder rápidamente a preguntas operativas como:

```text
¿Los objetivos están disponibles?
¿Qué servidor consume más CPU?
¿Cuánta memoria está utilizada?
¿Qué sistemas de ficheros están cerca del límite?
¿Cómo ha evolucionado el consumo?
¿Existe tráfico de red?
¿Se ha producido una degradación reciente?
¿Qué procedimiento debe seguirse ante una incidencia?
```

En este laboratorio se construirá un dashboard con la siguiente estructura:

```text
+------------------------------------------------------+
| Portada y documentación                              |
+------------------------------------------------------+
| Disponibilidad       | Objetivos monitorizados       |
+------------------------------------------------------+
| CPU por instancia    | Memoria por instancia         |
+------------------------------------------------------+
| Uso de disco         | Carga del sistema             |
+------------------------------------------------------+
| Tendencia de CPU                                    |
+------------------------------------------------------+
| Tráfico de red                                      |
+------------------------------------------------------+
| Tabla operativa de recursos                          |
+------------------------------------------------------+
| Canvas de infraestructura                            |
+------------------------------------------------------+
| Procedimiento y conclusiones                         |
+------------------------------------------------------+
```

La estructura puede adaptarse al entorno de prácticas.

---

## Arquitectura del laboratorio

La arquitectura mínima recomendada es:

```text
+-------------+       +-------------+
| Grafana     | ----> | Prometheus  |
+-------------+       +-------------+
                             |
                             v
                     +---------------+
                     | Node Exporter|
                     +---------------+
                             |
                             v
                     +---------------+
                     | Servidor Linux|
                     +---------------+
```

### Componentes

#### Grafana

Se utiliza para:

- Crear dashboards.
- Consultar Prometheus.
- Configurar paneles.
- Crear variables.
- Aplicar transformaciones.
- Exportar e importar dashboards.

#### Prometheus

Se utiliza para:

- Recoger métricas.
- Almacenar series temporales.
- Ejecutar consultas PromQL.
- Proporcionar los datos a Grafana.

#### Node Exporter

Se utiliza para exponer métricas del sistema operativo:

- CPU.
- Memoria.
- Disco.
- Sistema de ficheros.
- Red.
- Carga del sistema.
- Tiempo de actividad.

---

## Requisitos previos

Antes de comenzar, comprobar:

- Grafana está iniciado.
- Prometheus está iniciado.
- Node Exporter está iniciado.
- Grafana puede acceder a Prometheus.
- Prometheus está recogiendo métricas.
- El alumno tiene permisos para crear dashboards.
- Existe un entorno de laboratorio autorizado.

### Comprobar servicios

Los nombres pueden variar según la instalación.

```bash
sudo systemctl status grafana-server
```

```bash
sudo systemctl status prometheus
```

```bash
sudo systemctl status node_exporter
```

### Comprobar Node Exporter

```bash
curl http://localhost:9100/metrics
```

La respuesta debe contener métricas como:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_filesystem_size_bytes
node_network_receive_bytes_total
```

### Comprobar Prometheus

Abrir:

```text
http://localhost:9090
```

Ejecutar:

```promql
up
```

El objetivo monitorizado debe devolver:

```text
1
```

Interpretación:

```text
1 = disponible
0 = no disponible
```

---

## Preparar el directorio de evidencias

Crear un directorio para conservar las evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-dashboards
```

Crear un fichero inicial:

```bash
cat > ~/laboratorio-grafana/evidencias/laboratorio-dashboards/informe.txt <<'EOF'
Laboratorio: Dashboards y visualización

Alumno:

Fecha:

Entorno:

URL de Grafana:

URL de Prometheus:

Fuente de datos utilizada:

Dashboard creado:

Paneles creados:

Variables creadas:

Transformaciones utilizadas:

Pruebas realizadas:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

---

## Fase 1: comprobar la fuente de datos

### Objetivo

Verificar que Grafana puede consultar Prometheus.

### Pasos

1. Acceder a Grafana.
2. Abrir la configuración.
3. Acceder a **Data sources**.
4. Seleccionar Prometheus.
5. Comprobar la URL configurada.
6. Ejecutar la prueba de conexión.
7. Confirmar que la fuente de datos responde correctamente.

La URL puede ser similar a:

```text
http://localhost:9090
```

o:

```text
http://prometheus:9090
```

La URL depende de la arquitectura utilizada.

### Actividades

1. Anota el nombre de la fuente de datos.
2. Anota su tipo.
3. Anota la URL.
4. Guarda una captura de la conexión correcta.
5. Comprueba la consulta:

```promql
up
```

### Evidencia

Guardar:

```text
01-fuente-datos-prometheus.png
```

---

## Fase 2: crear el dashboard

### Objetivo

Crear el dashboard principal del laboratorio.

### Pasos

1. Crear un dashboard nuevo.
2. Asignar el nombre:

```text
Laboratorio - Dashboards y visualización
```

3. Seleccionar la fuente de datos Prometheus.
4. Configurar un rango temporal inicial:

```text
Last 1 hour
```

5. Configurar una actualización automática razonable:

```text
30s
```

6. Guardar el dashboard.
7. Añadir una descripción general.

### Descripción recomendada

```text
Dashboard de prácticas para analizar disponibilidad,
CPU, memoria, almacenamiento, red y evolución temporal
de un entorno Linux monitorizado mediante Prometheus.
```

### Actividades

1. Crea el dashboard.
2. Guarda una primera versión.
3. Comprueba el nombre.
4. Comprueba el rango temporal.
5. Registra la URL o el identificador del dashboard.

---

## Fase 3: crear variables de dashboard

### Objetivo

Permitir que el usuario seleccione dinámicamente un objetivo o una instancia.

Las variables evitan tener que modificar manualmente cada consulta.

---

### Variable `job`

Crear una variable llamada:

```text
job
```

Consulta posible:

```promql
label_values(up, job)
```

Según la versión de Grafana, la consulta de variables puede utilizar un editor o una sintaxis equivalente.

Valores habituales:

```text
node_exporter
prometheus
```

---

### Variable `instance`

Crear una variable llamada:

```text
instance
```

Consulta posible:

```promql
label_values(up{job=~"$job"}, instance)
```

Configurar:

```text
Multi-value: activado
Include All option: activado
```

### Actividades

1. Crea la variable `job`.
2. Crea la variable `instance`.
3. Comprueba los valores disponibles.
4. Selecciona una instancia.
5. Selecciona varias instancias.
6. Selecciona `All`.
7. Documenta el resultado.

### Evidencia

Guardar:

```text
02-variables-dashboard.png
```

---

## Fase 4: panel Text de portada

### Objetivo

Crear una portada que explique el dashboard.

### Contenido

```markdown
## Laboratorio - Dashboards y visualización

Este dashboard permite analizar el estado y el rendimiento
de los servidores Linux del entorno de prácticas.

### Fuente de datos

- Prometheus
- Node Exporter

### Métricas principales

- Disponibilidad.
- CPU.
- Memoria.
- Almacenamiento.
- Carga del sistema.
- Tráfico de red.

### Orden recomendado de lectura

1. Comprobar la disponibilidad.
2. Revisar los recursos actuales.
3. Analizar las tendencias.
4. Consultar la tabla operativa.
5. Revisar el Canvas de infraestructura.
6. Seguir el procedimiento si se detecta una anomalía.

> Los datos representan un entorno de laboratorio.
> No utilizar estos umbrales directamente en producción.
```

### Pasos

1. Añadir un panel.
2. Seleccionar `Text`.
3. Seleccionar Markdown.
4. Introducir el contenido.
5. Colocar el panel en la parte superior.
6. Ajustar su anchura.
7. Guardar el panel.

### Actividades

1. Añade el nombre del alumno.
2. Añade la instancia seleccionada:

```markdown
**Instancia seleccionada:** `$instance`
```

3. Añade un enlace a la documentación de Grafana.
4. Añade una tabla con la información del entorno.

### Evidencia

Guardar:

```text
03-panel-text-portada.png
```

---

## Fase 5: panel Stat de disponibilidad

### Objetivo

Mostrar el número de objetivos disponibles.

### Consulta

```promql
sum(up{job=~"$job"})
```

### Configuración

```text
Título: Objetivos disponibles
Visualización: Stat
Unidad: None
```

### Umbrales conceptuales

```text
Verde: todos los objetivos disponibles
Amarillo: disponibilidad parcial
Rojo: ningún objetivo disponible
```

Si se desea mostrar el total de objetivos, crear una segunda consulta:

```promql
count(up{job=~"$job"})
```

El resultado puede configurarse como texto auxiliar o utilizarse en un panel adicional.

### Actividades

1. Crea el panel Stat.
2. Utiliza la variable `$job`.
3. Configura el título.
4. Añade una descripción:

```text
Número de objetivos disponibles para el job seleccionado.
```

5. Comprueba el valor.
6. Detén temporalmente un exporter en el laboratorio.
7. Observa el cambio.
8. Inicia de nuevo el exporter.

### Evidencia

Guardar:

```text
04-panel-stat-disponibilidad.png
```

---

## Fase 6: panel Stat de disponibilidad porcentual

### Objetivo

Mostrar el porcentaje de objetivos disponibles.

### Consulta

```promql
100 * avg(up{job=~"$job"})
```

### Configuración

```text
Título: Disponibilidad
Visualización: Stat
Unidad: Percent (0-100)
```

### Umbrales

```text
Verde: 100
Amarillo: >= 90 y < 100
Rojo: < 90
```

### Actividades

1. Crea el panel.
2. Configura la unidad.
3. Configura los umbrales.
4. Añade la descripción:

```text
Porcentaje de objetivos disponibles para el job seleccionado.
```

5. Prueba el comportamiento con un objetivo detenido.
6. Documenta el valor antes y después.

---

## Fase 7: panel Gauge de CPU

### Objetivo

Mostrar el uso actual de CPU.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle",
        instance=~"$instance"
      }[5m]
    )
  ) * 100
)
```

### Configuración

```text
Título: Uso de CPU
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

### Umbrales

```text
Verde: 0 - 69
Amarillo: 70 - 89
Rojo: 90 - 100
```

### Actividades

1. Crea el panel.
2. Utiliza la variable `$instance`.
3. Configura la unidad como porcentaje.
4. Configura los umbrales.
5. Genera carga controlada en el laboratorio.
6. Observa el valor.
7. Detén la carga.
8. Observa la recuperación.

### Carga controlada

Utilizar únicamente en un entorno autorizado.

Una herramienta habitual es:

```bash
stress-ng --cpu 1 --timeout 60s
```

Si `stress-ng` no está instalado, seguir el procedimiento definido por el instructor.

### Evidencias

Guardar:

```text
05-cpu-normal.png
06-cpu-durante-carga.png
07-cpu-recuperacion.png
```

---

## Fase 8: panel Bar Gauge de CPU por instancia

### Objetivo

Comparar el uso de CPU entre instancias.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle",
        instance=~"$instance"
      }[5m]
    )
  ) * 100
)
```

### Configuración

```text
Título: CPU por instancia
Visualización: Bar Gauge
Unidad: Percent (0-100)
Orientación: Horizontal
```

### Recomendaciones

- Mostrar el nombre de la instancia.
- Ordenar de mayor a menor.
- Configurar umbrales.
- Limitar el número de instancias si el entorno es grande.
- Utilizar nombres legibles.

### Actividades

1. Crea el panel.
2. Selecciona varias instancias.
3. Ordena los valores.
4. Identifica la instancia con mayor CPU.
5. Añade una descripción.
6. Compara el resultado con el Gauge individual.

---

## Fase 9: panel Gauge de memoria

### Objetivo

Mostrar el porcentaje de memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  (
    node_memory_MemAvailable_bytes{
      instance=~"$instance"
    }
    /
    node_memory_MemTotal_bytes{
      instance=~"$instance"
    }
  )
)
```

### Configuración

```text
Título: Memoria utilizada
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

### Umbrales

```text
Verde: 0 - 69
Amarillo: 70 - 89
Rojo: 90 - 100
```

### Actividades

1. Crea el panel.
2. Configura los umbrales.
3. Selecciona una instancia.
4. Selecciona todas las instancias.
5. Comprueba cómo se comporta el panel con varias series.
6. Ajusta la consulta o crea un panel por instancia si es necesario.

---

## Fase 10: panel Bar Gauge de memoria por instancia

### Objetivo

Comparar el consumo de memoria.

### Consulta

```promql
100 * (
  1 -
  (
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
)
```

### Configuración

```text
Título: Memoria por instancia
Visualización: Bar Gauge
Unidad: Percent (0-100)
```

### Actividades

1. Crea el panel.
2. Ordena por valor descendente.
3. Identifica la instancia con mayor uso.
4. Configura los umbrales.
5. Añade una transformación para mejorar los nombres si es necesario.

---

## Fase 11: panel Time series de CPU

### Objetivo

Analizar la evolución temporal del uso de CPU.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle",
        instance=~"$instance"
      }[5m]
    )
  ) * 100
)
```

### Configuración

```text
Título: Evolución de CPU
Visualización: Time series
Unidad: Percent (0-100)
Rango temporal: Last 1 hour
```

### Recomendaciones

- Utilizar una línea por instancia.
- Configurar el eje vertical entre `0` y `100`.
- Añadir una leyenda.
- Utilizar colores diferenciados.
- Mostrar puntos o líneas según el objetivo.
- Revisar el intervalo de consulta.

### Actividades

1. Crea el panel.
2. Selecciona varias instancias.
3. Cambia el rango temporal a 15 minutos.
4. Cambia el rango a 6 horas.
5. Genera carga controlada.
6. Observa la evolución.
7. Identifica el inicio y el final de la carga.

---

## Fase 12: panel Time series de memoria

### Objetivo

Analizar la evolución de la memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  (
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
)
```

### Configuración

```text
Título: Evolución de memoria
Visualización: Time series
Unidad: Percent (0-100)
```

### Actividades

1. Crea el panel.
2. Selecciona varias instancias.
3. Añade una descripción.
4. Configura una línea de referencia en el 80 %.
5. Configura otra línea de referencia en el 90 %.
6. Interpreta la tendencia.

---

## Fase 13: panel Time series de almacenamiento

### Objetivo

Analizar la evolución del uso de los sistemas de ficheros.

### Consulta

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    fstype!~"tmpfs|overlay"
  }
)
```

### Configuración

```text
Título: Uso de sistemas de ficheros
Visualización: Time series
Unidad: Percent (0-100)
```

### Recomendaciones

Filtrar, si es necesario:

```promql
mountpoint="/"
```

Consulta para el sistema de ficheros raíz:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

### Actividades

1. Crea el panel.
2. Muestra únicamente `/`.
3. Después, muestra todos los puntos de montaje.
4. Identifica los sistemas con mayor uso.
5. Explica por qué se excluyen `tmpfs` y `overlay`.

---

## Fase 14: panel de red

### Objetivo

Mostrar el tráfico recibido y transmitido.

### Tráfico recibido

```promql
rate(
  node_network_receive_bytes_total{
    instance=~"$instance",
    device!~"lo"
  }[5m]
)
```

### Tráfico transmitido

```promql
rate(
  node_network_transmit_bytes_total{
    instance=~"$instance",
    device!~"lo"
  }[5m]
)
```

### Configuración

```text
Título: Tráfico de red
Visualización: Time series
Unidad: bytes/sec
```

### Recomendaciones

- Excluir la interfaz `lo`.
- Filtrar interfaces virtuales si es necesario.
- Separar tráfico recibido y transmitido.
- Revisar los nombres de las interfaces.
- Utilizar una leyenda clara.

### Actividades

1. Crea el panel.
2. Añade el tráfico recibido.
3. Añade el tráfico transmitido.
4. Genera tráfico controlado en el laboratorio.
5. Observa el cambio.
6. Identifica la interfaz con actividad.

---

## Fase 15: panel Table de disponibilidad

### Objetivo

Crear una tabla con el estado de cada objetivo.

### Consulta

```promql
up{job=~"$job", instance=~"$instance"}
```

### Visualización

```text
Table
```

### Transformaciones

Aplicar:

```text
1. Labels to fields.
2. Organize fields by name.
```

Renombrar:

```text
instance → Instancia
job → Servicio
Value → Estado
```

Ocultar:

```text
Time
```

### Resultado esperado

| Instancia | Servicio | Estado |
|---|---|---:|
| server-01:9100 | node_exporter | 1 |
| server-02:9100 | node_exporter | 1 |

### Actividades

1. Crea el panel.
2. Renombra los campos.
3. Oculta los campos innecesarios.
4. Configura los mapas de valores:

```text
1 → UP
0 → DOWN
```

5. Configura colores.
6. Detén un exporter.
7. Comprueba el cambio.

---

## Fase 16: tabla de CPU y memoria

### Objetivo

Crear una tabla operativa combinando dos consultas.

### Consulta A: CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Consulta B: memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Transformaciones

```text
1. Labels to fields.
2. Join by field utilizando instance.
3. Organize fields by name.
4. Rename fields.
5. Sort by CPU descendente.
```

### Resultado esperado

| Instancia | CPU | Memoria |
|---|---:|---:|
| server-02:9100 | 82.1 | 74.5 |
| server-01:9100 | 42.3 | 61.2 |

### Actividades

1. Crea las dos consultas.
2. Une los resultados.
3. Renombra los campos.
4. Ordena por CPU.
5. Añade una columna calculada:

```text
Promedio de recursos = (CPU + Memoria) / 2
```

6. Explica por qué este promedio es únicamente un indicador orientativo.

---

## Fase 17: panel Heatmap opcional

### Objetivo

Crear un Heatmap a partir de una métrica de histograma.

Este panel requiere que Prometheus disponga de una métrica con buckets.

### Buscar histogramas

```promql
{__name__=~".*_bucket"}
```

### Ejemplo de métrica

```promql
http_request_duration_seconds_bucket
```

### Consulta

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket[5m]
  )
)
```

### Configuración

```text
Título: Distribución de latencias
Visualización: Heatmap
Unidad: Seconds
```

### Actividades

1. Busca una métrica `_bucket`.
2. Comprueba sus valores de `le`.
3. Confirma que existe `+Inf`.
4. Crea el Heatmap.
5. Identifica la zona de mayor densidad.
6. Calcula el percentil 95:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(
      http_request_duration_seconds_bucket[5m]
    )
  )
)
```

7. Compara el percentil con el Heatmap.
8. Documenta si el laboratorio dispone de un histograma real.

Si no existe una métrica de histograma, documentar la limitación y continuar con el resto de la práctica.

---

## Fase 18: panel Canvas

### Objetivo

Crear una vista visual de la infraestructura.

### Diseño propuesto

```text
+------------------------------------------------------+
| Infraestructura de laboratorio                       |
+------------------------------------------------------+
|                                                      |
| +------------+       +-------------+                 |
| | Grafana    | ----> | Prometheus  |                 |
| | UP         |       | UP          |                 |
| +------------+       +-------------+                 |
|                              |                       |
|                      +-------+-------+               |
|                      |               |               |
|                      v               v               |
|                +-----------+   +-----------+          |
|                | Servidor 1|   | Servidor 2|          |
|                | UP        |   | UP        |          |
|                | CPU: 42 % |   | CPU: 78 % |          |
|                +-----------+   +-----------+          |
|                                                      |
+------------------------------------------------------+
```

### Elementos

Añadir:

- Título.
- Formas para los componentes.
- Textos.
- Líneas o conexiones.
- Estados.
- Valores de CPU.
- Leyenda de colores.

### Consultas

Estado de Prometheus:

```promql
up{job="prometheus"}
```

Estado de Node Exporter:

```promql
up{job="node_exporter"}
```

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Actividades

1. Crea el Canvas.
2. Añade los componentes.
3. Añade las conexiones.
4. Configura los estados.
5. Añade la CPU de los servidores.
6. Detén un exporter.
7. Cambia el color del componente afectado.
8. Inicia de nuevo el exporter.
9. Comprueba la recuperación.

---

## Fase 19: panel Text de procedimiento

### Objetivo

Añadir instrucciones operativas al dashboard.

### Contenido

```markdown
## Procedimiento ante una incidencia

### 1. Disponibilidad

Comprueba el panel de objetivos y la consulta:

```promql
up
```

### 2. Recursos

Revisa:

- CPU.
- Memoria.
- Almacenamiento.
- Red.

### 3. Tendencia

Amplía el rango temporal para identificar
cuándo comenzó el problema.

### 4. Sistema

Ejecuta únicamente las comprobaciones autorizadas:

```bash
uptime
free -h
df -h
```

### 5. Documentación

Registra:

- Hora.
- Instancia.
- Métrica afectada.
- Valor observado.
- Acción realizada.
- Resultado.
```

### Actividades

1. Añade el panel al final del dashboard.
2. Colócalo cerca de los paneles de recursos.
3. Añade un enlace a un runbook si existe.
4. Comprueba que los comandos son adecuados para el laboratorio.

---

## Fase 20: plugin de panel opcional

### Objetivo

Conocer cómo integrar un plugin de panel en un dashboard.

Esta fase debe realizarse únicamente con un plugin aprobado por el instructor.

### Actividades

1. Consultar los plugins disponibles.
2. Seleccionar un plugin de panel aprobado.
3. Registrar:
   - Nombre.
   - Identificador.
   - Versión.
   - Firma.
   - Compatibilidad.
4. Instalarlo en laboratorio.
5. Reiniciar Grafana si es necesario.
6. Revisar los logs.
7. Crear un panel de prueba.
8. Utilizar la consulta:

```promql
100 * avg(up)
```

9. Configurar la unidad.
10. Exportar el dashboard.
11. Documentar la dependencia.

### Información que debe registrarse

```markdown
### Plugin utilizado

Nombre:

Identificador:

Versión:

Estado de firma:

Fuente de instalación:

Versión de Grafana:

Panel creado:

Consulta utilizada:

Problemas encontrados:

Solución:
```

No instalar plugins no verificados en producción.

---

## Fase 21: pruebas controladas

### Objetivo

Observar cómo responde el dashboard ante diferentes situaciones.

Todas las pruebas deben ejecutarse en un entorno autorizado.

---

### Prueba A: detener Node Exporter

Detener:

```bash
sudo systemctl stop node_exporter
```

Esperar al menos un intervalo de scraping y revisar:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
0
```

Comprobar:

- Panel de disponibilidad.
- Tabla de objetivos.
- Canvas.
- Paneles de CPU y memoria.
- Comportamiento de `No data`.

Iniciar de nuevo:

```bash
sudo systemctl start node_exporter
```

---

### Prueba B: carga de CPU

Ejecutar:

```bash
stress-ng --cpu 1 --timeout 60s
```

Comprobar:

- Gauge de CPU.
- Bar Gauge.
- Time series.
- Canvas.
- Umbrales.

---

### Prueba C: tráfico de red

Generar tráfico únicamente según las reglas del laboratorio.

Observar:

- Tráfico recibido.
- Tráfico transmitido.
- Interfaz utilizada.
- Evolución temporal.

---

### Prueba D: cambio de rango temporal

Comparar:

```text
Last 15 minutes
Last 1 hour
Last 6 hours
Last 24 hours
```

Documentar:

- Qué detalle aparece.
- Qué información se comprime.
- Qué rango resulta más útil.
- Qué rango genera más datos.

---

## Fase 22: diagnóstico de un panel sin datos

### Objetivo

Aprender a resolver problemas de visualización.

### Procedimiento general

1. Abrir el panel.
2. Revisar la consulta.
3. Ejecutarla en Explore.
4. Comprobar la fuente de datos.
5. Comprobar las variables.
6. Revisar el rango temporal.
7. Revisar las etiquetas.
8. Revisar las transformaciones.
9. Abrir el inspector.
10. Revisar los logs si procede.

### Ejemplo de consulta incorrecta

```promql
metric_que_no_existe
```

### Corrección

Utilizar una métrica real:

```promql
up
```

### Documentación del problema

```text
Panel afectado:

Consulta inicial:

Resultado observado:

Causa:

Corrección aplicada:

Resultado final:
```

### Actividades

1. Crea una consulta incorrecta de forma intencionada.
2. Observa el resultado.
3. Diagnostica el problema.
4. Corrige la consulta.
5. Completa el registro.

---

## Fase 23: revisar el dashboard

### Lista de comprobación visual

Comprobar:

- Los títulos son claros.
- Las unidades son correctas.
- Las leyendas son legibles.
- Los colores tienen significado.
- No existen paneles superpuestos.
- Las variables funcionan.
- Las tablas muestran la identificación del recurso.
- Los valores no están truncados.
- El Canvas es legible.
- El panel Text está actualizado.
- Los enlaces funcionan.
- No existen secretos.
- No hay consultas innecesarias.

### Lista de comprobación técnica

Comprobar:

- La fuente de datos responde.
- Las consultas devuelven datos.
- Las transformaciones están justificadas.
- Los umbrales coinciden con la documentación.
- Los paneles aceptan varias instancias.
- Las variables funcionan con `All`.
- El rango temporal es adecuado.
- El dashboard carga en un tiempo razonable.
- Las dependencias están documentadas.
- El JSON puede exportarse.

---

## Fase 24: exportar el dashboard

### Objetivo

Guardar una copia del dashboard.

### Pasos

1. Abrir el menú del dashboard.
2. Seleccionar la opción de compartir o exportar.
3. Exportar la definición JSON.
4. Guardar el archivo como:

```text
laboratorio-dashboards-visualizacion.json
```

5. Crear una copia en el directorio de evidencias.

```bash
cp laboratorio-dashboards-visualizacion.json \
  ~/laboratorio-grafana/evidencias/laboratorio-dashboards/
```

6. Validar el JSON:

```bash
jq empty \
  ~/laboratorio-grafana/evidencias/laboratorio-dashboards/laboratorio-dashboards-visualizacion.json
```

### Comprobar referencias

Buscar paneles Canvas:

```bash
grep -n '"canvas"' \
  laboratorio-dashboards-visualizacion.json
```

Buscar paneles Text:

```bash
grep -n '"text"' \
  laboratorio-dashboards-visualizacion.json
```

Buscar un plugin concreto:

```bash
grep -n "ID_DEL_PLUGIN" \
  laboratorio-dashboards-visualizacion.json
```

---

## Fase 25: importar una copia

### Objetivo

Comprobar que el dashboard puede restaurarse.

### Pasos

1. Crear un dashboard nuevo o utilizar otra instancia de laboratorio.
2. Seleccionar **Import dashboard**.
3. Cargar el archivo JSON.
4. Seleccionar la fuente de datos Prometheus.
5. Confirmar la importación.
6. Revisar los paneles.
7. Revisar las variables.
8. Revisar las transformaciones.
9. Revisar el Canvas.
10. Revisar los paneles que dependan de plugins.

### Actividades

Comparar el dashboard original y el restaurado:

| Elemento | Original | Restaurado | Observaciones |
|---|---|---|---|
| Panel Text | | | |
| Variables | | | |
| Paneles Stat | | | |
| Gauges | | | |
| Time series | | | |
| Tables | | | |
| Heatmap | | | |
| Canvas | | | |
| Plugins | | | |
| Transformaciones | | | |

---

## Fase 26: documentar el dashboard

Crear un panel Text o un fichero externo con las dependencias.

### Contenido recomendado

```markdown
## Dependencias del dashboard

### Grafana

Versión utilizada:

### Fuente de datos

- Prometheus

### Exporter

- Node Exporter

### Variables

- `job`
- `instance`

### Paneles

- Stat de disponibilidad.
- Gauge de CPU.
- Bar Gauge de CPU por instancia.
- Gauge de memoria.
- Time series de CPU.
- Time series de memoria.
- Time series de red.
- Table de disponibilidad.
- Table de recursos.
- Canvas de infraestructura.
- Text de documentación.

### Transformaciones

- Labels to fields.
- Organize fields by name.
- Join by field.
- Sort by.
- Limit.
- Reduce.

### Plugins

Indicar si se utiliza alguno.

### Rango temporal recomendado

```text
Last 1 hour
```

### Actualización

```text
30s
```
```

---

## Sesión práctica completa 1: crear el dashboard mínimo

### Objetivo

Crear una primera versión funcional.

### Tareas

1. Comprobar Prometheus.
2. Crear el dashboard.
3. Añadir la variable `job`.
4. Añadir la variable `instance`.
5. Crear un panel Text.
6. Crear un Stat de disponibilidad.
7. Crear un Gauge de CPU.
8. Crear un Gauge de memoria.
9. Guardar el dashboard.

### Resultado esperado

```text
Dashboard funcional con:
- Variables.
- Documentación.
- Disponibilidad.
- CPU.
- Memoria.
```

### Evidencias

```text
01-dashboard-minimo.png
02-variables.png
03-paneles-basicos.png
```

---

## Sesión práctica completa 2: ampliar el dashboard

### Objetivo

Añadir tendencias y tablas operativas.

### Tareas

1. Crear Time series de CPU.
2. Crear Time series de memoria.
3. Crear Time series de disco.
4. Crear Time series de red.
5. Crear Table de disponibilidad.
6. Crear Table de CPU y memoria.
7. Aplicar transformaciones.
8. Ordenar las tablas.
9. Limitar resultados.
10. Guardar el dashboard.

### Resultado esperado

```text
Dashboard con:
- Valores actuales.
- Tendencias.
- Tablas operativas.
```

---

## Sesión práctica completa 3: crear el Canvas

### Objetivo

Representar visualmente la infraestructura.

### Tareas

1. Crear un panel Canvas.
2. Añadir Prometheus.
3. Añadir Grafana.
4. Añadir un servidor.
5. Añadir un Node Exporter.
6. Crear conexiones.
7. Añadir estados.
8. Añadir CPU.
9. Añadir una leyenda.
10. Probar un estado `DOWN`.
11. Guardar el panel.

### Resultado esperado

```text
Vista visual de alto nivel de la infraestructura.
```

---

## Sesión práctica completa 4: investigar una incidencia

### Objetivo

Utilizar el dashboard para analizar una incidencia simulada.

### Escenario

Uno de los objetivos deja de estar disponible.

### Procedimiento

1. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

2. Esperar el siguiente intervalo de scraping.
3. Revisar el Stat de disponibilidad.
4. Revisar la tabla de objetivos.
5. Identificar la instancia afectada.
6. Revisar el Canvas.
7. Consultar Prometheus:

```promql
up
```

8. Revisar el servicio:

```bash
sudo systemctl status node_exporter
```

9. Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

10. Confirmar la recuperación.
11. Documentar el incidente.

### Informe

```text
Hora de inicio:

Instancia afectada:

Valor de up antes:

Valor de up durante la incidencia:

Causa simulada:

Acción realizada:

Hora de recuperación:

Resultado:
```

---

## Sesión práctica completa 5: analizar carga de CPU

### Objetivo

Observar el comportamiento del dashboard ante una carga controlada.

### Pasos

1. Registrar el valor inicial de CPU.
2. Ejecutar:

```bash
stress-ng --cpu 1 --timeout 60s
```

3. Observar el Gauge.
4. Observar el Bar Gauge.
5. Observar el Time series.
6. Capturar el dashboard durante la carga.
7. Esperar a que finalice.
8. Observar la recuperación.
9. Comparar los valores.

### Preguntas

1. ¿Qué panel muestra el valor actual?
2. ¿Qué panel muestra la tendencia?
3. ¿Qué panel permite comparar instancias?
4. ¿Qué umbral se ha superado?
5. ¿Cuánto tardó en reflejarse el cambio?
6. ¿Cuánto tardó en recuperarse?

---

## Sesión práctica completa 6: solucionar un panel incorrecto

### Objetivo

Diagnosticar una consulta o transformación incorrecta.

### Situación

La tabla de CPU no muestra el nombre de las instancias.

### Procedimiento

1. Abrir el panel.
2. Revisar el resultado original.
3. Comprobar si se ha ocultado `instance`.
4. Revisar `Organize fields by name`.
5. Volver a mostrar el campo.
6. Renombrarlo como `Instancia`.
7. Revisar la tabla.
8. Guardar la corrección.

### Informe

```text
Problema:

Transformación responsable:

Campo afectado:

Corrección:

Resultado:
```

---

## Sesión práctica completa 7: comparar paneles

### Objetivo

Comprender qué información aporta cada visualización.

### Utilizar la métrica de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Crear los paneles

```text
Stat
Gauge
Bar Gauge
Time series
Table
Canvas
```

### Comparar

| Panel | Información principal |
|---|---|
| Stat | Valor resumido |
| Gauge | Valor frente a límites |
| Bar Gauge | Comparación |
| Time series | Evolución |
| Table | Detalle estructurado |
| Canvas | Contexto visual |

### Actividades

1. Coloca los paneles en el mismo dashboard.
2. Utiliza la misma unidad.
3. Compara su utilidad.
4. Explica cuál utilizarías para una alerta.
5. Explica cuál utilizarías para un informe.
6. Explica cuál utilizarías para investigar una tendencia.

---

## Sesión práctica completa 8: evaluar la calidad del dashboard

### Objetivo

Revisar el dashboard como si fuera a entregarse a otro equipo.

### Criterios

#### Claridad

- ¿Los títulos son comprensibles?
- ¿Las unidades están visibles?
- ¿Los colores tienen significado?
- ¿El orden de los paneles es lógico?

#### Corrección

- ¿Las consultas son válidas?
- ¿Los cálculos son correctos?
- ¿Las variables funcionan?
- ¿Los umbrales coinciden?

#### Mantenibilidad

- ¿Las consultas están documentadas?
- ¿Las transformaciones están justificadas?
- ¿Las dependencias están registradas?
- ¿Los plugins están identificados?

#### Seguridad

- ¿Existen secretos?
- ¿Los enlaces son adecuados?
- ¿Las imágenes contienen información sensible?
- ¿Los permisos son correctos?

#### Rendimiento

- ¿Carga rápidamente?
- ¿Hay demasiadas consultas?
- ¿Se solicitan demasiadas series?
- ¿El rango temporal es razonable?

---

## Rúbrica de evaluación

| Criterio | Insuficiente | Básico | Correcto | Excelente |
|---|---|---|---|---|
| Fuente de datos | No configurada | Configurada parcialmente | Funciona | Documentada y comprobada |
| Variables | No existen | Una variable | Funcionan correctamente | Incluyen filtros y `All` |
| Disponibilidad | No creada | Muestra datos | Tiene umbrales | Incluye tabla y pruebas |
| CPU | No creada | Valor actual | Valor y tendencia | Comparación y prueba de carga |
| Memoria | No creada | Valor actual | Tiene unidad | Incluye tendencia y umbrales |
| Almacenamiento | No creado | Consulta parcial | Panel funcional | Filtra sistemas irrelevantes |
| Red | No creada | Datos parciales | Recibido y transmitido | Interpreta interfaces |
| Transformaciones | No utilizadas | Uso parcial | Correctas | Documentadas y ordenadas |
| Canvas | No creado | Diseño incompleto | Vista funcional | Vista clara e interactiva |
| Text | No creado | Texto básico | Documenta el dashboard | Incluye procedimiento y dependencias |
| Heatmap | No creado | Intento parcial | Funciona con histograma | Comparado con percentiles |
| Plugins | Sin documentación | Revisados | Utilizados correctamente | Dependencias y seguridad documentadas |
| Exportación | No realizada | Archivo creado | Importación correcta | Recuperación verificada |
| Informe | Incompleto | Parcial | Completo | Claro y reproducible |

---

## Entregables

El alumno debe entregar:

```text
1. Dashboard de Grafana.
2. Exportación JSON.
3. Informe de prácticas.
4. Consultas PromQL.
5. Capturas de pantalla.
6. Registro de variables.
7. Registro de transformaciones.
8. Documentación de plugins, si se utilizan.
9. Evidencia de una incidencia simulada.
10. Conclusiones.
```

### Estructura recomendada

```text
entrega/
├── dashboard/
│   └── laboratorio-dashboards-visualizacion.json
├── consultas/
│   └── consultas-promql.txt
├── evidencias/
│   ├── 01-fuente-datos-prometheus.png
│   ├── 02-variables-dashboard.png
│   ├── 03-panel-text-portada.png
│   ├── 04-panel-stat-disponibilidad.png
│   ├── 05-cpu-normal.png
│   ├── 06-cpu-durante-carga.png
│   ├── 07-cpu-recuperacion.png
│   ├── 08-dashboard-final.png
│   └── 09-incidencia.png
├── documentacion/
│   ├── dependencias.md
│   └── transformaciones.md
└── informe.txt
```

---

## Consultas de referencia

### Disponibilidad

```promql
up
```

### Objetivos disponibles

```promql
sum(up)
```

### Porcentaje de disponibilidad

```promql
100 * avg(up)
```

### CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento utilizado

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

### Carga del sistema

```promql
node_load1
```

### Tráfico recibido

```promql
rate(
  node_network_receive_bytes_total{
    device!="lo"
  }[5m]
)
```

### Tráfico transmitido

```promql
rate(
  node_network_transmit_bytes_total{
    device!="lo"
  }[5m]
)
```

### Buscar histogramas

```promql
{__name__=~".*_bucket"}
```

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Grafana disponible | | |
| Prometheus disponible | | |
| Node Exporter disponible | | |
| Fuente de datos comprobada | | |
| Dashboard creado | | |
| Variable `job` creada | | |
| Variable `instance` creada | | |
| Panel Text creado | | |
| Stat de disponibilidad creado | | |
| Gauge de CPU creado | | |
| Bar Gauge de CPU creado | | |
| Gauge de memoria creado | | |
| Time series de CPU creado | | |
| Time series de memoria creado | | |
| Panel de disco creado | | |
| Panel de red creado | | |
| Tabla de disponibilidad creada | | |
| Tabla de recursos creada | | |
| Transformaciones aplicadas | | |
| Canvas creado | | |
| Heatmap probado | | |
| Plugin revisado | | |
| Incidencia simulada | | |
| Carga de CPU simulada | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Evidencias guardadas | | |
| Informe completado | | |

---

## Puntos clave

- Un dashboard debe facilitar la interpretación de las métricas.
- La fuente de datos debe comprobarse antes de crear paneles.
- Las variables permiten reutilizar un dashboard con diferentes instancias.
- Stat muestra valores resumidos.
- Gauge muestra valores frente a umbrales.
- Bar Gauge facilita la comparación.
- Time series muestra la evolución temporal.
- Table muestra información detallada.
- Heatmap representa distribuciones cuando existen histogramas.
- Text documenta el propósito, las unidades y los procedimientos.
- Canvas ofrece una vista visual personalizada.
- Las transformaciones preparan los datos para la visualización.
- Los plugins deben instalarse únicamente cuando aportan valor.
- Las pruebas controladas ayudan a comprobar que el dashboard responde.
- Los paneles deben probarse con estados normales, caídos y sin datos.
- Las consultas PromQL deben estar documentadas.
- Las unidades y los umbrales deben ser coherentes.
- Las tablas deben conservar la identificación del recurso.
- El dashboard debe poder exportarse e importarse.
- Las dependencias deben documentarse.
- No se deben incluir secretos ni información sensible.
- La sencillez mejora la mantenibilidad.
- Un dashboard útil no es el que tiene más paneles, sino el que permite tomar decisiones con menos esfuerzo.

---

## Preguntas de comprobación

1. ¿Qué componentes forman la arquitectura del laboratorio?
2. ¿Qué función cumple Prometheus?
3. ¿Qué función cumple Node Exporter?
4. ¿Qué consulta permite comprobar la disponibilidad?
5. ¿Qué significa el valor `1` en la métrica `up`?
6. ¿Qué diferencia existe entre un Stat y un Gauge?
7. ¿Cuándo utilizarías un Bar Gauge?
8. ¿Qué información muestra un Time series?
9. ¿Qué utilidad tiene una tabla operativa?
10. ¿Qué consulta permite calcular el uso de CPU?
11. ¿Qué consulta permite calcular el uso de memoria?
12. ¿Por qué se excluyen `tmpfs` y `overlay` en algunas consultas de disco?
13. ¿Qué función cumple una variable de dashboard?
14. ¿Qué ocurre cuando se selecciona `All`?
15. ¿Qué utilidad tiene un panel Text?
16. ¿Qué utilidad tiene un panel Canvas?
17. ¿Qué diferencia existe entre una consulta y una transformación?
18. ¿Por qué es importante el orden de las transformaciones?
19. ¿Qué debe comprobarse antes de utilizar un plugin?
20. ¿Qué pasos realizarías si un panel no muestra datos?
21. ¿Cómo simularías la caída de un objetivo en el laboratorio?
22. ¿Cómo comprobarías la recuperación?
23. ¿Qué evidencias deben entregarse?
24. ¿Por qué debe exportarse el dashboard?
25. ¿Qué información debe incluir la documentación de dependencias?
26. ¿Qué riesgos existen al incluir secretos en un dashboard?
27. ¿Qué criterios utilizarías para evaluar la calidad del dashboard?
28. ¿Qué panel utilizarías para analizar una tendencia?
29. ¿Qué panel utilizarías para comparar instancias?
30. ¿Qué panel utilizarías para representar la topología de la infraestructura?

---

## Resultado esperado

Al finalizar el laboratorio, el alumno debe haber creado un dashboard funcional, documentado y reproducible.

El proceso completo será:

```text
Comprobar la arquitectura
        |
        v
Configurar la fuente de datos
        |
        v
Crear variables
        |
        v
Añadir documentación
        |
        v
Crear paneles de disponibilidad
        |
        v
Crear paneles de recursos
        |
        v
Crear tendencias
        |
        v
Crear tablas
        |
        v
Aplicar transformaciones
        |
        v
Crear Canvas
        |
        v
Probar Heatmap y plugins
        |
        v
Simular incidencias
        |
        v
Diagnosticar errores
        |
        v
Exportar e importar
        |
        v
Documentar y evaluar
```

El resultado final debe ser un dashboard capaz de mostrar:

```text
Qué está funcionando
Qué recurso presenta mayor consumo
Cómo evoluciona el sistema
Qué instancia está afectada
Qué procedimiento debe seguirse
Cómo recuperar el dashboard
Qué dependencias necesita
```

Un buen dashboard no sustituye al análisis técnico, pero permite comenzar ese análisis con información clara, ordenada y contextualizada.