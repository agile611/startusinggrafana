# Laboratorio: Prometheus, Node Exporter y Grafana

Este laboratorio integra los componentes principales de una plataforma de monitorización:

- **Prometheus**: recopila y almacena métricas.
- **Node Exporter**: expone métricas del sistema operativo.
- **Grafana**: consulta Prometheus y representa la información.
- **PromQL**: permite consultar y transformar las métricas.

Durante la práctica se construirá el siguiente flujo:

```text
Sistema operativo
        |
        v
Node Exporter
        |
        | HTTP /metrics
        v
Prometheus
        |
        | PromQL / API HTTP
        v
Grafana
        |
        v
Dashboards
```

El objetivo no es únicamente ejecutar comandos. El alumno debe ser capaz de **explicar qué componente participa en cada paso**, comprobar el funcionamiento de la plataforma y diagnosticar los problemas más habituales.

---

## Objetivos

Al finalizar este laboratorio, el alumno podrá:

- Explicar la función de Prometheus, Node Exporter y Grafana.
- Comprobar el estado de los servicios implicados.
- Verificar los puertos utilizados por cada componente.
- Comprobar el endpoint `/metrics` de Node Exporter.
- Configurar Prometheus para realizar *scraping* de Node Exporter.
- Validar el fichero `prometheus.yml`.
- Consultar los objetivos desde Prometheus.
- Interpretar la métrica `up`.
- Ejecutar consultas PromQL.
- Calcular el uso de CPU.
- Calcular el uso de memoria.
- Calcular el uso del sistema de ficheros.
- Consultar el tráfico de red.
- Añadir Prometheus como fuente de datos en Grafana.
- Crear un dashboard básico.
- Crear paneles de disponibilidad, CPU, memoria y almacenamiento.
- Diagnosticar objetivos en estado `DOWN`.
- Identificar errores de conectividad entre Grafana y Prometheus.
- Configurar una fuente de datos mediante *provisioning*.
- Guardar evidencias de la instalación y configuración.
- Documentar el resultado final del laboratorio.

---

## Arquitectura y componentes

## Introducción

Una plataforma de monitorización está formada por varias piezas especializadas.

### Prometheus

Prometheus consulta periódicamente los endpoints de métricas configurados, almacena los datos como series temporales y permite consultarlos mediante PromQL.

Su puerto habitual es:

```text
9090
```

URL local:

```text
http://localhost:9090
```

### Node Exporter

Node Exporter recopila información del sistema operativo Linux y la expone mediante HTTP.

Su puerto habitual es:

```text
9100
```

Endpoint de métricas:

```text
http://localhost:9100/metrics
```

### Grafana

Grafana consulta Prometheus y utiliza los resultados para crear dashboards y paneles.

Su puerto habitual es:

```text
3000
```

URL local:

```text
http://localhost:3000
```

### Flujo de trabajo

```text
1. Node Exporter expone métricas.
2. Prometheus consulta /metrics.
3. Prometheus almacena las muestras.
4. PromQL consulta los datos almacenados.
5. Grafana ejecuta consultas PromQL.
6. Grafana representa los resultados.
```

## Arquitectura del laboratorio

```text
+----------------------------------------------------------+
| Servidor Linux                                           |
|                                                          |
|  Node Exporter                                          |
|  http://localhost:9100/metrics                          |
|              |                                           |
|              v                                           |
|  Prometheus                                              |
|  http://localhost:9090                                  |
|              |                                           |
|              v                                           |
|  Grafana                                                 |
|  http://localhost:3000                                  |
+----------------------------------------------------------+
```

## Puertos utilizados

| Componente | Puerto | Función |
|---|---:|---|
| Prometheus | `9090` | Interfaz web y API |
| Node Exporter | `9100` | Endpoint de métricas |
| Grafana | `3000` | Interfaz web y API |

---

# Requisitos previos

Antes de comenzar, comprobar que se dispone de:

- Un servidor Linux.
- Un usuario con permisos de `sudo`.
- Conectividad de red.
- Prometheus instalado.
- Node Exporter instalado.
- Grafana instalado.
- Un navegador web.
- Al menos 2 GB de memoria disponible.
- Los puertos `9090`, `9100` y `3000` disponibles.
- La hora del sistema sincronizada.

## Comprobar la distribución

```bash
lsb_release -ds
```

También puede utilizarse:

```bash
cat /etc/os-release
```

## Comprobar la arquitectura

```bash
uname -m
```

## Comprobar la memoria

```bash
free -h
```

## Comprobar el espacio disponible

```bash
df -h /
```

## Comprobar la hora

```bash
timedatectl status
```

## Comprobar los puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)'
```

Si alguno de los puertos no aparece, el servicio correspondiente puede estar detenido o configurado con otro puerto.

---

# Variables utilizadas

Durante el laboratorio se utilizarán estas variables:

```bash
export PROMETHEUS_URL="http://localhost:9090"
export NODE_EXPORTER_URL="http://localhost:9100"
export GRAFANA_URL="http://localhost:3000"
```

Comprobarlas:

```bash
echo "$PROMETHEUS_URL"
echo "$NODE_EXPORTER_URL"
echo "$GRAFANA_URL"
```

---

# Comprobación inicial de los servicios

## Comprobar Prometheus

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

Comprobar el endpoint de salud:

```bash
curl "$PROMETHEUS_URL/-/healthy"
```

Resultado esperado:

```text
Prometheus is Healthy.
```

Comprobar el endpoint de preparación:

```bash
curl "$PROMETHEUS_URL/-/ready"
```

Resultado esperado:

```text
Prometheus is Ready.
```

## Comprobar Node Exporter

Si Node Exporter se instaló manualmente:

```bash
systemctl is-active node_exporter
```

Si se instaló mediante el paquete de Ubuntu:

```bash
systemctl is-active prometheus-node-exporter
```

Comprobar el endpoint:

```bash
curl -I "$NODE_EXPORTER_URL/metrics"
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

## Comprobar Grafana

```bash
systemctl is-active grafana-server
```

Resultado esperado:

```text
active
```

Comprobar la API:

```bash
curl -s "$GRAFANA_URL/api/health" | jq
```

Resultado conceptual:

```json
{
  "database": "ok",
  "version": "...",
  "commit": "..."
}
```

---

# Sesión 1: comprobar la instalación

## Objetivo

Verificar que los tres componentes están instalados y activos.

## Comprobar los servicios

```bash
systemctl is-active prometheus
```

Para una instalación manual de Node Exporter:

```bash
systemctl is-active node_exporter
```

Para una instalación mediante APT:

```bash
systemctl is-active prometheus-node-exporter
```

Comprobar Grafana:

```bash
systemctl is-active grafana-server
```

## Consultar las versiones

```bash
prometheus --version
```

```bash
node_exporter --version
```

Consultar la versión de Grafana mediante la API:

```bash
curl -s "$GRAFANA_URL/api/health" \
  | jq -r '.version'
```

## Consultar los puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)'
```

## Actividades

1. Anota el estado de cada servicio.
2. Anota las versiones.
3. Anota los puertos en escucha.
4. Identifica el proceso asociado a cada puerto.
5. Explica qué función cumple cada componente.

Completar:

| Componente | Servicio | Puerto | Estado |
|---|---|---:|---|
| Prometheus | | | |
| Node Exporter | | | |
| Grafana | | | |

---

# Sesión 2: comprobar Node Exporter

## Objetivo

Comprobar que Node Exporter expone métricas del sistema operativo.

## Consultar las primeras líneas

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | head -n 20
```

## Buscar métricas de CPU

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | grep '^node_cpu_seconds_total' \
  | head
```

## Buscar métricas de memoria

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | grep '^node_memory_' \
  | head
```

## Buscar métricas de almacenamiento

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | grep '^node_filesystem_' \
  | head
```

## Buscar métricas de red

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | grep '^node_network_' \
  | head
```

## Actividades

1. Localiza una métrica de CPU.
2. Localiza una métrica de memoria.
3. Localiza una métrica de disco.
4. Localiza una métrica de red.
5. Anota las etiquetas que aparecen.
6. Explica la diferencia entre una línea `HELP`, una línea `TYPE` y una muestra.

Completar:

| Categoría | Métrica encontrada | Etiquetas |
|---|---|---|
| CPU | | |
| Memoria | | |
| Disco | | |
| Red | | |

---

# Sesión 3: configurar el scraping

## Objetivo

Configurar Prometheus para consultar Node Exporter.

## Crear una copia de seguridad

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%Y%m%d-%H%M%S).bak"
```

## Crear la configuración

```bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
---
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          role: monitoring
EOF
```

Mostrar el fichero:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

## Validar la configuración

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
SUCCESS
```

El texto exacto puede variar según la versión de Prometheus.

## Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

Comprobar:

```bash
systemctl is-active prometheus
```

Consultar los registros recientes:

```bash
sudo journalctl -u prometheus \
  --since "1 minute ago" \
  --no-pager
```

---

# Sesión 4: comprobar los objetivos

## Objetivo

Comprobar que Prometheus ha cargado los objetivos y puede consultarlos.

## Comprobar desde la interfaz web

Abrir:

```text
http://localhost:9090
```

Acceder a:

```text
Status → Targets
```

Comprobar que aparecen:

```text
prometheus
node_exporter
```

Ambos deben aparecer como:

```text
UP
```

## Comprobar mediante la API

```bash
curl -s "$PROMETHEUS_URL/api/v1/targets" \
  | jq
```

Mostrar un resumen:

```bash
curl -s "$PROMETHEUS_URL/api/v1/targets" \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .labels.instance,
        .health,
        .scrapeUrl,
        .lastError
      ]
    | @tsv
  '
```

Resultado conceptual:

```text
prometheus      localhost:9090  up  http://localhost:9090/metrics
node_exporter   localhost:9100  up  http://localhost:9100/metrics
```

## Actividades

1. Anota los jobs.
2. Anota las instancias.
3. Comprueba la URL de *scraping*.
4. Comprueba el estado.
5. Comprueba que no hay errores.
6. Comprueba que aparecen las etiquetas personalizadas.

---

# Sesión 5: consultar la métrica `up`

## Objetivo

Utilizar PromQL para comprobar la disponibilidad de los objetivos.

## Consultar todos los objetivos

```promql
up
```

Resultado conceptual:

```text
up{instance="localhost:9090",job="prometheus"} 1
up{instance="localhost:9100",job="node_exporter"} 1
```

## Consultar únicamente Node Exporter

```promql
up{job="node_exporter"}
```

## Consultar los objetivos caídos

```promql
up == 0
```

## Contar los objetivos

```promql
count(up)
```

## Contar los objetivos disponibles

```promql
sum(up)
```

## Calcular el porcentaje de disponibilidad

```promql
100 * avg(up)
```

## Consultar mediante la API

```bash
curl -sG "$PROMETHEUS_URL/api/v1/query" \
  --data-urlencode 'query=up' \
  | jq
```

Mostrar únicamente job, instancia y valor:

```bash
curl -sG "$PROMETHEUS_URL/api/v1/query" \
  --data-urlencode 'query=up' \
  | jq -r '
    .data.result[]
    | [
        .metric.job,
        .metric.instance,
        .value[1]
      ]
    | @tsv
  '
```

---

# Sesión 6: practicar consultas PromQL

## Objetivo

Consultar métricas de Prometheus y Node Exporter.

## Métricas de Prometheus

```promql
prometheus_build_info
```

```promql
process_resident_memory_bytes{job="prometheus"}
```

```promql
prometheus_tsdb_head_series
```

```promql
rate(process_cpu_seconds_total{job="prometheus"}[5m])
```

## Métricas de memoria

```promql
node_memory_MemTotal_bytes
```

```promql
node_memory_MemAvailable_bytes
```

## Métricas de carga

```promql
node_load1
```

```promql
node_load5
```

```promql
node_load15
```

## Métricas de red

```promql
node_network_receive_bytes_total
```

```promql
node_network_transmit_bytes_total
```

## Actividades

1. Ejecuta cada consulta.
2. Cambia entre las vistas **Table** y **Graph**.
3. Identifica qué métricas son `gauge`.
4. Identifica qué métricas son `counter`.
5. Anota las etiquetas de cada resultado.
6. Indica qué consultas son apropiadas para un gráfico temporal.

---

# Sesión 7: calcular el uso de CPU

## Objetivo

Construir una consulta PromQL para calcular el porcentaje de CPU utilizado.

## Consultar el contador de CPU

```promql
node_cpu_seconds_total
```

## Filtrar el modo inactivo

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

## Calcular la velocidad de cambio

```promql
rate(node_cpu_seconds_total{
  mode="idle"
}[5m])
```

## Calcular la media por instancia

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{
    mode="idle"
  }[5m])
)
```

## Calcular el porcentaje de CPU utilizado

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

## Generar carga temporal

Ejecutar únicamente en el entorno de laboratorio:

```bash
yes > /dev/null &
yes > /dev/null &
```

Comprobar los procesos:

```bash
pgrep yes
```

Detener los procesos:

```bash
pkill yes
```

## Actividades

1. Ejecuta la consulta de uso de CPU.
2. Visualízala como gráfico.
3. Genera carga durante un periodo corto.
4. Observa el aumento del uso.
5. Detén la carga.
6. Observa la recuperación.
7. Explica por qué se utiliza `rate()`.

---

# Sesión 8: calcular el uso de memoria

## Objetivo

Calcular el porcentaje de memoria utilizada.

## Memoria total

```promql
node_memory_MemTotal_bytes
```

## Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

## Memoria utilizada en bytes

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

## Porcentaje disponible

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

## Porcentaje utilizado

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Comparar con el sistema operativo

```bash
free -h
```

## Actividades

1. Ejecuta las consultas.
2. Compara los resultados con `free -h`.
3. Configura la unidad como porcentaje.
4. Representa el porcentaje utilizado como un indicador.
5. Explica por qué el resultado puede cambiar entre consultas.

---

# Sesión 9: calcular el uso del sistema de ficheros

## Objetivo

Calcular el porcentaje de espacio utilizado en el sistema de ficheros raíz.

## Consultar el tamaño total

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

## Consultar el espacio disponible

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

## Calcular el porcentaje utilizado

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

## Comparar con el sistema operativo

```bash
df -h /
```

## Buscar sistemas con más del 80 % de uso

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
) > 80
```

## Actividades

1. Identifica el sistema de ficheros raíz.
2. Excluye `tmpfs`.
3. Excluye `overlay`.
4. Compara la consulta con `df -h`.
5. Configura la unidad del panel como porcentaje.
6. Explica por qué se excluyen algunos tipos de sistemas de ficheros.

---

# Sesión 10: consultar el tráfico de red

## Objetivo

Calcular el tráfico recibido y enviado por las interfaces.

## Bytes recibidos

```promql
node_network_receive_bytes_total
```

## Bytes enviados

```promql
node_network_transmit_bytes_total
```

## Tráfico recibido por segundo

```promql
rate(node_network_receive_bytes_total[5m])
```

## Tráfico enviado por segundo

```promql
rate(node_network_transmit_bytes_total[5m])
```

## Excluir la interfaz de loopback

```promql
rate(node_network_receive_bytes_total{
  device!="lo"
}[5m])
```

## Sumar tráfico por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Comparar con el sistema operativo

```bash
ip -s link
```

## Actividades

1. Identifica las interfaces disponibles.
2. Excluye `lo`.
3. Representa el tráfico recibido.
4. Representa el tráfico enviado.
5. Configura la unidad como `bytes/sec`.
6. Explica por qué se utiliza `rate()`.

---

# Sesión 11: añadir Prometheus como fuente de datos en Grafana

## Objetivo

Configurar Grafana para consultar Prometheus.

## Acceder a Grafana

Abrir:

```text
http://localhost:3000
```

## Crear la fuente de datos

Acceder a:

```text
Connections → Data sources
```

Seleccionar:

```text
Add new data source → Prometheus
```

Configurar:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server o Proxy
```

Activar:

```text
Set as default
```

Pulsar:

```text
Save & test
```

## Resultado esperado

Grafana debe mostrar un mensaje indicando que la API de Prometheus responde correctamente.

## Actividades

1. Anota el nombre de la fuente.
2. Anota la URL.
3. Anota el modo de acceso.
4. Comprueba si es la fuente predeterminada.
5. Guarda una captura de la prueba correcta.
6. Explica a qué equipo apunta `localhost`.

---

# Sesión 12: crear un dashboard básico

## Objetivo

Crear un dashboard con información de disponibilidad y recursos.

Crear un dashboard nuevo y añadir los siguientes paneles.

## Panel de disponibilidad de los objetivos

Consulta:

```promql
up
```

Visualización recomendada:

```text
Table
```

Título:

```text
Estado de los objetivos
```

## Panel de uso de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Visualización recomendada:

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

## Panel de uso de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Visualización recomendada:

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

## Panel de uso del sistema de ficheros

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

Visualización recomendada:

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

## Panel de carga del sistema

Consulta:

```promql
node_load1
```

Visualización recomendada:

```text
Time series
```

Título:

```text
Carga del sistema
```

## Panel de tráfico recibido

Consulta:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Visualización recomendada:

```text
Time series
```

Unidad:

```text
bytes/sec
```

Título:

```text
Tráfico recibido
```

## Actividades

1. Crea los seis paneles.
2. Selecciona Prometheus como fuente.
3. Configura las unidades.
4. Guarda el dashboard.
5. Comprueba que los paneles muestran datos.
6. Anota el nombre del dashboard.

---

# Sesión 13: probar un objetivo en estado `DOWN`

## Objetivo

Comprobar cómo detecta Prometheus la caída de Node Exporter.

## Comprobar el estado inicial

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

## Detener Node Exporter

Si se instaló manualmente:

```bash
sudo systemctl stop node_exporter
```

Si se instaló mediante APT:

```bash
sudo systemctl stop prometheus-node-exporter
```

Esperar más de un intervalo de *scraping*.

## Consultar el estado

```promql
up{job="node_exporter"}
```

Consultar el objetivo desde la API:

```bash
curl -s "$PROMETHEUS_URL/api/v1/targets" \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

## Iniciar Node Exporter

Si se instaló manualmente:

```bash
sudo systemctl start node_exporter
```

Si se instaló mediante APT:

```bash
sudo systemctl start prometheus-node-exporter
```

Comprobar el servicio:

```bash
systemctl is-active node_exporter
```

Si se utiliza APT:

```bash
systemctl is-active prometheus-node-exporter
```

Esperar al siguiente *scraping*.

## Verificar la recuperación

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

## Actividades

1. Anota el estado inicial.
2. Anota el error durante la interrupción.
3. Anota el tiempo aproximado de detección.
4. Anota el tiempo aproximado de recuperación.
5. Explica la relación con `scrape_interval`.

---

# Sesión 14: diagnosticar una conexión incorrecta en Grafana

## Objetivo

Diferenciar un problema de conexión de un problema de consulta.

## Probar una URL incorrecta

Editar temporalmente la fuente de datos y sustituir:

```text
http://localhost:9090
```

por:

```text
http://localhost:9999
```

Pulsar:

```text
Save & test
```

Debe aparecer un error de conexión.

## Restaurar la URL

Volver a configurar:

```text
http://localhost:9090
```

Pulsar:

```text
Save & test
```

## Probar una consulta inexistente

En un panel ejecutar:

```promql
metrica_que_no_existe
```

Esta consulta puede no devolver datos, pero la fuente puede estar funcionando correctamente.

## Probar una consulta válida

```promql
up
```

## Actividades

1. Compara el error de conexión con una consulta vacía.
2. Explica cómo se diagnostica cada caso.
3. Utiliza el inspector del panel.
4. Comprueba la API de Prometheus directamente.
5. Documenta las diferencias.

---

# Configurar la fuente mediante provisioning

## Objetivo

Crear la fuente de datos automáticamente mediante un fichero YAML.

## Crear el directorio

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

## Crear el fichero

```bash
sudo tee /etc/grafana/provisioning/datasources/prometheus.yml > /dev/null <<'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
EOF
```

## Reiniciar Grafana

```bash
sudo systemctl restart grafana-server
```

Comprobar:

```bash
systemctl is-active grafana-server
```

Acceder a:

```text
Connections → Data sources
```

Comprobar que aparece:

```text
Prometheus
```

## Actividades

1. Crea el fichero de provisioning.
2. Reinicia Grafana.
3. Comprueba que la fuente existe.
4. Comprueba su UID.
5. Comprueba que es la fuente predeterminada.
6. Consulta los registros de Grafana.

## Consultar errores de provisioning

```bash
sudo journalctl -u grafana-server \
  --since "5 minutes ago" \
  --no-pager
```

Revisar el fichero:

```bash
sudo cat /etc/grafana/provisioning/datasources/prometheus.yml
```

---

# Diagnóstico de problemas

## Prometheus no está activo

Comprobar:

```bash
sudo systemctl status prometheus
```

Consultar los registros:

```bash
sudo journalctl -u prometheus \
  --no-pager \
  -n 100
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9090'
```

## Node Exporter no está activo

Para una instalación manual:

```bash
sudo systemctl status node_exporter
```

Para una instalación mediante APT:

```bash
sudo systemctl status prometheus-node-exporter
```

Consultar los registros de una instalación manual:

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  -n 100
```

Consultar los registros de una instalación mediante APT:

```bash
sudo journalctl -u prometheus-node-exporter \
  --no-pager \
  -n 100
```

Comprobar el endpoint:

```bash
curl -v http://localhost:9100/metrics
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9100'
```

## El target aparece como `DOWN`

Comprobar directamente Node Exporter:

```bash
curl http://localhost:9100/metrics
```

Comprobar la configuración:

```bash
sudo grep -A10 -B2 'node_exporter' \
  /etc/prometheus/prometheus.yml
```

Consultar el último error:

```bash
curl -s "$PROMETHEUS_URL/api/v1/targets" \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | .lastError
  '
```

Posibles causas:

- Puerto incorrecto.
- Servicio detenido.
- Dirección incorrecta.
- Firewall.
- Error de YAML.
- Prometheus no se ha reiniciado.
- Node Exporter escucha solo en otra interfaz.
- Grafana y Prometheus utilizan redes diferentes.

## Grafana no conecta con Prometheus

Comprobar Prometheus desde el servidor de Grafana:

```bash
curl http://localhost:9090/-/healthy
```

Si están en servidores separados:

```bash
curl http://IP_DEL_SERVIDOR_PROMETHEUS:9090/-/healthy
```

Comprobar la conectividad:

```bash
nc -vz IP_DEL_SERVIDOR_PROMETHEUS 9090
```

Consultar los registros:

```bash
sudo journalctl -u grafana-server \
  --no-pager \
  -n 100
```

Revisar:

- URL.
- Puerto.
- Nombre DNS.
- Red de contenedores.
- Firewall.
- Modo de acceso.
- TLS.
- Autenticación.

## Grafana conecta, pero el panel está vacío

Comprobar:

```promql
up
```

Después:

```promql
prometheus_build_info
```

Y:

```promql
node_memory_MemAvailable_bytes
```

Revisar:

- Fuente seleccionada.
- Consulta.
- Rango temporal.
- Variables del dashboard.
- Filtros.
- Unidades.
- Estado de los targets.

---

# Evidencias del laboratorio

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador
```

## Guardar información del sistema

```bash
{
  echo "===== SISTEMA ====="
  echo "Fecha: $(date)"
  echo "Hostname: $(hostname)"
  echo "Sistema: $(lsb_release -ds)"
  echo "Arquitectura: $(uname -m)"
  echo "Kernel: $(uname -r)"
} | tee \
  ~/laboratorio-grafana/evidencias/laboratorio-integrador/sistema.txt
```

## Guardar los estados de los servicios

```bash
{
  echo "===== PROMETHEUS ====="
  systemctl is-active prometheus
  systemctl is-enabled prometheus
  echo
  echo "===== NODE EXPORTER MANUAL ====="
  systemctl is-active node_exporter 2>/dev/null || true
  systemctl is-enabled node_exporter 2>/dev/null || true
  echo
  echo "===== NODE EXPORTER APT ====="
  systemctl is-active prometheus-node-exporter 2>/dev/null || true
  systemctl is-enabled prometheus-node-exporter 2>/dev/null || true
  echo
  echo "===== GRAFANA ====="
  systemctl is-active grafana-server
  systemctl is-enabled grafana-server
} | tee \
  ~/laboratorio-grafana/evidencias/laboratorio-integrador/servicios.txt
```

## Guardar los puertos

```bash
sudo ss -lntp \
  | grep -E ':(3000|9090|9100)' \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/puertos.txt
```

## Guardar la configuración de Prometheus

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  ~/laboratorio-grafana/evidencias/laboratorio-integrador/prometheus.yml
```

## Guardar los objetivos

```bash
curl -s "$PROMETHEUS_URL/api/v1/targets" \
  | jq \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/targets.json
```

## Guardar la consulta `up`

```bash
curl -sG "$PROMETHEUS_URL/api/v1/query" \
  --data-urlencode 'query=up' \
  | jq \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/query-up.json
```

## Guardar la salud de Grafana

```bash
curl -s "$GRAFANA_URL/api/health" \
  | jq \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/grafana-health.json
```

## Guardar una muestra de Node Exporter

```bash
curl -s "$NODE_EXPORTER_URL/metrics" \
  | head -n 100 \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/node-exporter-sample.txt
```

## Guardar los registros

```bash
sudo journalctl -u prometheus \
  --since "30 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/prometheus.log
```

Para una instalación manual de Node Exporter:

```bash
sudo journalctl -u node_exporter \
  --since "30 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/node-exporter.log
```

Para una instalación mediante APT:

```bash
sudo journalctl -u prometheus-node-exporter \
  --since "30 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/node-exporter.log
```

```bash
sudo journalctl -u grafana-server \
  --since "30 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/laboratorio-integrador/grafana.log
```

---

# Script de comprobación final

El siguiente script detecta automáticamente si Node Exporter utiliza la unidad manual o la unidad instalada mediante APT.

## Crear el script

```bash
cat > /tmp/comprobar-laboratorio.sh <<'EOF'
#!/usr/bin/env bash

set -u

echo "===== COMPROBACIÓN DEL LABORATORIO ====="
echo

check_service() {
  local service="$1"

  printf '%-35s ' "$service"

  if systemctl is-active --quiet "$service"; then
    echo "ACTIVO"
  else
    echo "NO ACTIVO"
  fi
}

check_http() {
  local name="$1"
  local url="$2"

  printf '%-35s ' "$name"

  if curl -fsS "$url" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "ERROR"
  fi
}

check_service prometheus

if systemctl is-active --quiet node_exporter; then
  check_service node_exporter
else
  check_service prometheus-node-exporter
fi

check_service grafana-server

check_http "Prometheus saludable" \
  "http://localhost:9090/-/healthy"

check_http "Prometheus preparado" \
  "http://localhost:9090/-/ready"

check_http "Node Exporter /metrics" \
  "http://localhost:9100/metrics"

check_http "API de Grafana" \
  "http://localhost:3000/api/health"

printf '%-35s ' "Configuración Prometheus"

if promtool check config \
    /etc/prometheus/prometheus.yml \
    >/dev/null 2>&1; then
  echo "VÁLIDA"
else
  echo "INVÁLIDA"
fi

printf '%-35s ' "Consulta up"

if curl -fsS -G \
    http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    | jq -e '.status == "success"' \
    >/dev/null 2>&1; then
  echo "OK"
else
  echo "ERROR"
fi

printf '%-35s ' "Target node_exporter"

if curl -fsS -G \
    http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up{job="node_exporter"}' \
    | jq -e '
        .data.result
        | length > 0
        and .[0].value[1] == "1"
      ' \
    >/dev/null 2>&1; then
  echo "UP"
else
  echo "DOWN O SIN DATOS"
fi
EOF
```

## Dar permisos de ejecución

```bash
chmod +x /tmp/comprobar-laboratorio.sh
```

## Ejecutar el script

```bash
/tmp/comprobar-laboratorio.sh
```

Resultado esperado:

```text
===== COMPROBACIÓN DEL LABORATORIO =====

prometheus                         ACTIVO
node_exporter                      ACTIVO
grafana-server                     ACTIVO
Prometheus saludable               OK
Prometheus preparado               OK
Node Exporter /metrics             OK
API de Grafana                     OK
Configuración Prometheus           VÁLIDA
Consulta up                        OK
Target node_exporter               UP
```

---

# Ejemplo de sesión completa

```console
$ systemctl is-active prometheus
active

$ systemctl is-active node_exporter
active

$ systemctl is-active grafana-server
active

$ curl http://localhost:9090/-/healthy
Prometheus is Healthy.

$ curl -I http://localhost:9100/metrics
HTTP/1.1 200 OK

$ curl -s http://localhost:3000/api/health \
    | jq -r '.database'
ok

$ promtool check config /etc/prometheus/prometheus.yml
Checking /etc/prometheus/prometheus.yml
 SUCCESS: configuration is valid

$ curl -s http://localhost:9090/api/v1/targets \
    | jq -r '
      .data.activeTargets[]
      | [.labels.job, .labels.instance, .health]
      | @tsv
    '
prometheus      localhost:9090  up
node_exporter   localhost:9100  up

$ curl -sG http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    | jq -r '
      .data.result[]
      | [.metric.job, .metric.instance, .value[1]]
      | @tsv
    '
prometheus      localhost:9090  1
node_exporter   localhost:9100  1
```

En Grafana se crea una fuente de datos:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server o Proxy
Default: Yes
```

Después se crea un dashboard con los paneles:

```text
Estado de los objetivos
Uso de CPU
Uso de memoria
Uso del sistema de ficheros raíz
Carga del sistema
Tráfico recibido
```

---

# Actividad integradora

## Objetivo

Construir una plataforma funcional de monitorización con Prometheus, Node Exporter y Grafana.

## Parte 1: servicios

1. Comprobar el estado de Prometheus.
2. Comprobar el estado de Node Exporter.
3. Comprobar el estado de Grafana.
4. Comprobar los puertos `3000`, `9090` y `9100`.

## Parte 2: Node Exporter

5. Consultar `/metrics`.
6. Localizar métricas de CPU.
7. Localizar métricas de memoria.
8. Localizar métricas de disco.
9. Localizar métricas de red.

## Parte 3: Prometheus

10. Configurar el job `prometheus`.
11. Configurar el job `node_exporter`.
12. Añadir etiquetas personalizadas.
13. Validar la configuración.
14. Reiniciar Prometheus.
15. Comprobar los objetivos.
16. Consultar la métrica `up`.

## Parte 4: PromQL

17. Consultar el uso de CPU.
18. Consultar el uso de memoria.
19. Consultar el uso de `/`.
20. Consultar el tráfico recibido.
21. Consultar la carga del sistema.

## Parte 5: Grafana

22. Añadir Prometheus como fuente de datos.
23. Probar la conexión.
24. Establecer la fuente como predeterminada.
25. Crear un dashboard.
26. Crear al menos cuatro paneles.
27. Configurar las unidades.
28. Guardar el dashboard.

## Parte 6: diagnóstico

29. Detener Node Exporter.
30. Observar el estado `DOWN`.
31. Consultar el mensaje de error.
32. Iniciar Node Exporter.
33. Comprobar la recuperación.
34. Provocar temporalmente un error de conexión en Grafana.
35. Restaurar la configuración.
36. Documentar las comprobaciones.

---

# Entregables

El alumno debe entregar:

- Fichero `prometheus.yml`.
- Evidencia de los servicios activos.
- Evidencia del endpoint `/metrics`.
- Evidencia de los objetivos en estado `UP`.
- Resultado de la consulta `up`.
- Consultas PromQL utilizadas.
- Capturas del dashboard.
- Resultado del diagnóstico de un target `DOWN`.
- Informe de comprobación final.
- Explicación breve de la arquitectura.

Estructura recomendada:

```text
laboratorio-prometheus-grafana/
├── prometheus.yml
├── consultas-promql.txt
├── dashboard/
│   └── dashboard-exportado.json
├── evidencias/
│   ├── servicios.txt
│   ├── puertos.txt
│   ├── targets.json
│   ├── query-up.json
│   ├── grafana-health.json
│   ├── prometheus.log
│   ├── node-exporter.log
│   └── grafana.log
└── informe.md
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Prometheus activo | | |
| Node Exporter activo | | |
| Grafana activo | | |
| Puerto `9090` | | |
| Puerto `9100` | | |
| Puerto `3000` | | |
| Endpoint `/metrics` | | |
| Configuración válida | | |
| Target Prometheus | | |
| Target Node Exporter | | |
| Consulta `up` | | |
| Consulta de CPU | | |
| Consulta de memoria | | |
| Consulta de almacenamiento | | |
| Fuente de datos creada | | |
| Conexión de Grafana | | |
| Dashboard creado | | |
| Prueba `DOWN` realizada | | |
| Recuperación verificada | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Node Exporter expone métricas del sistema operativo.
- Prometheus recopila y almacena las métricas.
- Grafana consulta Prometheus y representa los resultados.
- PromQL es el lenguaje de consulta de Prometheus.
- El endpoint de Node Exporter es normalmente `/metrics`.
- Prometheus utiliza normalmente el puerto `9090`.
- Node Exporter utiliza normalmente el puerto `9100`.
- Grafana utiliza normalmente el puerto `3000`.
- La configuración de *scraping* se encuentra en `prometheus.yml`.
- `promtool check config` permite validar la configuración.
- La sección **Targets** muestra el estado del *scraping*.
- La métrica `up` indica si el último *scraping* fue correcto.
- Los contadores suelen requerir `rate()` para calcular velocidades.
- Las métricas de CPU, memoria, disco y red pueden transformarse mediante PromQL.
- Grafana necesita una fuente de datos configurada.
- La URL de Prometheus debe ser accesible desde Grafana.
- `localhost` depende del equipo o contenedor que realiza la conexión.
- El modo de acceso `Server` o `Proxy` es adecuado para este laboratorio.
- El inspector de Grafana ayuda a diagnosticar consultas.
- Una buena documentación debe incluir configuración, evidencias y resultados.

---

# Preguntas de comprobación

1. ¿Qué función cumple Node Exporter?
2. ¿Qué función cumple Prometheus?
3. ¿Qué función cumple Grafana?
4. ¿Qué componente inicia normalmente el *scraping*?
5. ¿Qué endpoint expone Node Exporter?
6. ¿Qué puerto utiliza normalmente Prometheus?
7. ¿Qué puerto utiliza normalmente Node Exporter?
8. ¿Qué puerto utiliza normalmente Grafana?
9. ¿Qué función cumple `prometheus.yml`?
10. ¿Qué comando permite validar la configuración de Prometheus?
11. ¿Qué información muestra la sección **Targets**?
12. ¿Qué significa `up = 1`?
13. ¿Qué significa `up = 0`?
14. ¿Por qué se utiliza `rate()` con `node_cpu_seconds_total`?
15. ¿Cómo calcularías el porcentaje de memoria utilizado?
16. ¿Cómo calcularías el uso del sistema de ficheros raíz?
17. ¿Cómo excluirías la interfaz `lo`?
18. ¿Qué es una fuente de datos en Grafana?
19. ¿Qué URL utilizarías si Grafana y Prometheus están en el mismo servidor?
20. ¿Qué problema puede producirse al utilizar `localhost` en contenedores?
21. ¿Qué diferencia existe entre un error de conexión y una consulta sin resultados?
22. ¿Cómo comprobarías que Grafana puede consultar Prometheus?
23. ¿Qué pasos seguirías si Node Exporter aparece como `DOWN`?
24. ¿Qué pasos seguirías para comprobar la recuperación de un objetivo?
25. ¿Qué evidencias incluirías en el informe final?

---

# Criterios de evaluación

| Criterio | Puntuación |
|---|---:|
| Comprobación inicial de los servicios | 1 punto |
| Verificación de Node Exporter | 1 punto |
| Configuración correcta del *scraping* | 2 puntos |
| Validación y diagnóstico en Prometheus | 1 punto |
| Consultas PromQL | 2 puntos |
| Configuración de Grafana | 1 punto |
| Creación del dashboard | 1 punto |
| Documentación y evidencias | 1 punto |
| **Total** | **10 puntos** |

## El laboratorio se considera superado cuando

- Los tres servicios están activos.
- Node Exporter responde en `/metrics`.
- Prometheus consulta correctamente Node Exporter.
- Los objetivos aparecen como `UP`.
- La consulta `up` devuelve valores correctos.
- Se han ejecutado consultas de CPU, memoria, almacenamiento y red.
- Grafana tiene configurada la fuente de datos Prometheus.
- El dashboard muestra datos.
- Se ha realizado una prueba de caída y recuperación.
- Las evidencias son reproducibles y están documentadas.

---

# Comprobación final

Ejecutar:

```bash
/tmp/comprobar-laboratorio.sh
```

Resultado esperado:

```text
===== COMPROBACIÓN DEL LABORATORIO =====

prometheus                         ACTIVO
node_exporter                      ACTIVO
grafana-server                     ACTIVO
Prometheus saludable               OK
Prometheus preparado               OK
Node Exporter /metrics             OK
API de Grafana                     OK
Configuración Prometheus           VÁLIDA
Consulta up                        OK
Target node_exporter               UP
```

El flujo completo del laboratorio es:

```text
Instalar Node Exporter
        |
        v
Exponer /metrics
        |
        v
Configurar scraping en Prometheus
        |
        v
Validar targets y métrica up
        |
        v
Ejecutar consultas PromQL
        |
        v
Añadir Prometheus en Grafana
        |
        v
Crear paneles
        |
        v
Probar errores y recuperación
        |
        v
Guardar evidencias
```