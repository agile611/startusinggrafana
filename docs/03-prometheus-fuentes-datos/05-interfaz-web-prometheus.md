# Interfaz web de Prometheus

La interfaz web de Prometheus permite consultar métricas, ejecutar expresiones PromQL, revisar los objetivos de *scraping* y comprobar el estado general del servidor.

Durante esta práctica se utilizará la interfaz web para:

- Acceder a Prometheus.
- Ejecutar consultas sencillas.
- Consultar métricas en formato tabla.
- Representar métricas como gráficos.
- Revisar los objetivos configurados.
- Comprobar el estado de los *targets*.
- Consultar la configuración cargada.
- Revisar información de ejecución y compilación.
- Utilizar la API HTTP desde la terminal.
- Diagnosticar problemas básicos de monitorización.

La interfaz web no sustituye a Grafana. Prometheus proporciona una interfaz sencilla para consultar y verificar datos; Grafana se utilizará posteriormente para construir dashboards más completos.

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Acceder a la interfaz web de Prometheus.
- Identificar las principales secciones de la interfaz.
- Ejecutar consultas PromQL.
- Diferenciar entre una consulta instantánea y una consulta temporal.
- Cambiar entre las vistas de tabla y gráfico.
- Consultar la métrica `up`.
- Consultar métricas propias de Prometheus.
- Consultar métricas procedentes de Node Exporter.
- Filtrar métricas mediante etiquetas.
- Revisar los objetivos de *scraping*.
- Interpretar los estados `UP` y `DOWN`.
- Consultar la configuración activa.
- Consultar la información de compilación.
- Utilizar la API HTTP de Prometheus.
- Exportar resultados de consultas desde la terminal.
- Diagnosticar por qué una consulta no devuelve datos.

---

## Introducción

Prometheus incluye una interfaz web accesible normalmente en el puerto `9090`.

Desde el propio servidor:

```text
http://localhost:9090
```

Desde otro equipo de la red:

```text
http://<IP-DE-PROMETHEUS>:9090
```

Ejemplo:

```text
http://192.168.1.50:9090
```

La interfaz permite ejecutar consultas PromQL y observar los resultados sin necesidad de instalar Grafana.

El flujo básico es:

```text
Usuario
   |
   | Navegador web
   v
Interfaz de Prometheus
   |
   | Consulta PromQL
   v
Motor de consultas
   |
   v
Series temporales almacenadas
```

---

# Requisitos previos

Antes de comenzar, Prometheus debe estar instalado y activo.

## Comprobar el servicio

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

## Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

## Comprobar el endpoint de salud

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

## Comprobar el endpoint de preparación

```bash
curl http://localhost:9090/-/ready
```

Resultado esperado:

```text
Prometheus is Ready.
```

## Comprobar la consulta `up`

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

Si `jq` está instalado:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

---

# Acceso a la interfaz web

## Desde el propio servidor

Abrir un navegador y acceder a:

```text
http://localhost:9090
```

## Desde otro equipo

Consultar la dirección IP del servidor:

```bash
hostname -I
```

Ejemplo:

```text
192.168.1.50
```

Acceder desde el navegador:

```text
http://192.168.1.50:9090
```

## Problemas de acceso remoto

Si la interfaz funciona con `localhost` pero no desde otro equipo, comprobar:

- La dirección IP utilizada.
- El puerto `9090`.
- La dirección de escucha de Prometheus.
- Las reglas del cortafuegos.
- La conectividad entre ambos equipos.
- La red de la máquina virtual.
- La configuración de NAT o *bridge*.

Comprobar la dirección de escucha:

```bash
sudo ss -lntp | grep ':9090'
```

Si aparece:

```text
127.0.0.1:9090
```

Prometheus solo acepta conexiones desde el propio equipo.

Si aparece:

```text
0.0.0.0:9090
```

Prometheus acepta conexiones IPv4 desde las interfaces disponibles, siempre que el cortafuegos lo permita.

---

# Elementos principales de la interfaz

La interfaz puede variar ligeramente según la versión instalada, pero normalmente incluye las siguientes áreas:

| Sección | Función |
|---|---|
| Query | Ejecutar consultas PromQL |
| Graph | Representar series temporales |
| Table | Mostrar resultados en formato tabla |
| Targets | Consultar objetivos de *scraping* |
| Service Discovery | Consultar mecanismos de descubrimiento |
| Rules | Consultar reglas de grabación y alerta |
| Configuration | Consultar la configuración cargada |
| Status | Consultar información del servidor |
| Runtime & Build Information | Consultar versión y datos de ejecución |
| TSDB Status | Consultar información de la base de datos temporal |

---

# Área de consultas

La sección de consultas permite introducir expresiones PromQL y observar los resultados.

Una consulta sencilla es:

```promql
up
```

Esta consulta devuelve el estado de los objetivos que Prometheus está monitorizando.

Ejemplo conceptual:

```text
up{instance="localhost:9090", job="prometheus"}       1
up{instance="localhost:9100", job="node_exporter"}    1
```

## Resultado `1`

Indica que Prometheus pudo recopilar correctamente métricas del objetivo.

## Resultado `0`

Indica que Prometheus no pudo recopilar correctamente métricas del objetivo.

---

# Primeras consultas PromQL

## Consultar todos los objetivos

```promql
up
```

## Consultar únicamente Prometheus

```promql
up{job="prometheus"}
```

## Consultar únicamente Node Exporter

```promql
up{job="node_exporter"}
```

## Consultar objetivos caídos

```promql
up == 0
```

## Consultar información de compilación

```promql
prometheus_build_info
```

## Consultar memoria utilizada por el proceso de Prometheus

```promql
process_resident_memory_bytes
```

## Consultar el tiempo de inicio del proceso

```promql
process_start_time_seconds
```

## Consultar el número de series en memoria

```promql
prometheus_tsdb_head_series
```

## Consultar muestras añadidas

```promql
prometheus_tsdb_head_samples_appended_total
```

---

# Vista de tabla

La vista de tabla muestra el resultado actual de una consulta.

Por ejemplo:

```promql
up
```

Puede devolver:

| Métrica | Etiquetas | Valor |
|---|---|---:|
| `up` | `job="prometheus", instance="localhost:9090"` | 1 |
| `up` | `job="node_exporter", instance="localhost:9100"` | 1 |

La vista de tabla es útil para:

- Consultar valores instantáneos.
- Revisar etiquetas.
- Comparar objetivos.
- Comprobar estados.
- Confirmar que una métrica existe.
- Detectar valores inesperados.

## Actividad

Ejecutar:

```promql
up
```

Anotar:

- Nombre del trabajo.
- Dirección de la instancia.
- Valor devuelto.
- Estado del objetivo.

Completar:

| Job | Instance | Valor | Interpretación |
|---|---|---:|---|
| | | | |
| | | | |

---

# Vista gráfica

La vista gráfica representa la evolución de una métrica a lo largo del tiempo.

Ejecutar:

```promql
process_resident_memory_bytes
```

Después:

1. Seleccionar la vista gráfica.
2. Elegir un rango temporal.
3. Observar la evolución de la métrica.
4. Mover el cursor sobre el gráfico.
5. Comparar los valores en distintos momentos.

Las métricas de tipo *gauge* suelen ser apropiadas para observar valores que suben y bajan, como:

- Memoria disponible.
- Carga del sistema.
- Espacio libre.
- Memoria utilizada por un proceso.

Las métricas de tipo *counter* representan valores acumulativos. Para observar su velocidad de cambio se utiliza normalmente `rate()`.

Ejemplo:

```promql
rate(prometheus_tsdb_head_samples_appended_total[5m])
```

---

# Consultas instantáneas y consultas temporales

## Consulta instantánea

Una consulta instantánea devuelve el valor más reciente disponible.

Ejemplo:

```promql
up
```

Resultado conceptual:

```text
up = 1
```

## Consulta temporal

Una consulta temporal devuelve los valores de una métrica durante un intervalo.

Ejemplo:

```promql
process_resident_memory_bytes
```

Al visualizarla como gráfico, se observa su evolución en el tiempo.

## Seleccionar el rango temporal

En la interfaz se puede seleccionar un rango como:

- Últimos 5 minutos.
- Últimos 15 minutos.
- Última hora.
- Últimas 6 horas.
- Últimas 24 horas.
- Rango personalizado.

El rango temporal debe ser coherente con la frecuencia de recopilación. Si el intervalo de *scraping* es de 15 segundos, un rango de 5 minutos debería contener aproximadamente 20 muestras por objetivo, aunque el número exacto puede variar.

---

# Consultas con etiquetas

Las etiquetas permiten filtrar las series.

## Filtrar por `job`

```promql
up{job="node_exporter"}
```

## Filtrar por `instance`

```promql
up{instance="localhost:9100"}
```

## Filtrar por varias etiquetas

```promql
node_cpu_seconds_total{
  job="node_exporter",
  mode="idle"
}
```

## Excluir una etiqueta

```promql
node_network_receive_bytes_total{
  device!="lo"
}
```

## Utilizar expresiones regulares

```promql
node_network_receive_bytes_total{
  device=~"en.*"
}
```

## Excluir mediante una expresión regular

```promql
node_network_receive_bytes_total{
  device!~"lo|docker.*|veth.*"
}
```

---

# Consultas de Node Exporter

Estas consultas requieren que Node Exporter esté instalado, activo y configurado como objetivo de Prometheus.

## Métricas de CPU

Consultar todas las métricas de CPU:

```promql
node_cpu_seconds_total
```

Consultar el tiempo de CPU en modo inactivo:

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

Calcular el uso aproximado de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Métricas de memoria

Consultar la memoria total:

```promql
node_memory_MemTotal_bytes
```

Consultar la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Calcular el porcentaje de memoria utilizado:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Métricas del sistema de ficheros

Consultar el espacio disponible:

```promql
node_filesystem_avail_bytes
```

Consultar únicamente el sistema de ficheros raíz:

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

Excluir sistemas virtuales:

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

Calcular el porcentaje utilizado:

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

## Métricas de red

Consultar bytes recibidos:

```promql
node_network_receive_bytes_total
```

Excluir la interfaz de loopback:

```promql
node_network_receive_bytes_total{
  device!="lo"
}
```

Calcular el tráfico recibido:

```promql
rate(node_network_receive_bytes_total{
  device!="lo"
}[5m])
```

Calcular el tráfico enviado:

```promql
rate(node_network_transmit_bytes_total{
  device!="lo"
}[5m])
```

## Métrica de disponibilidad

```promql
up{job="node_exporter"}
```

---

# Sección Targets

La sección **Targets** muestra los objetivos configurados y el resultado del último *scraping*.

Información habitual:

- Job.
- Instance.
- Estado de salud.
- URL de scraping.
- Último scraping.
- Duración del último scraping.
- Último error.
- Etiquetas descubiertas.

Ejemplo conceptual:

| Job | Instance | Estado | URL | Último error |
|---|---|---|---|---|
| prometheus | `localhost:9090` | UP | `/metrics` | Ninguno |
| node_exporter | `localhost:9100` | UP | `/metrics` | Ninguno |

## Estados habituales

### UP

El objetivo respondió correctamente y Prometheus pudo recopilar sus métricas.

### DOWN

Prometheus no pudo realizar correctamente el *scraping*.

Posibles causas:

- Servicio detenido.
- Puerto incorrecto.
- Dirección incorrecta.
- Problema de red.
- Cortafuegos.
- Endpoint no disponible.
- Error de configuración.
- Protocolo incorrecto.

### UNKNOWN

El estado todavía no se ha determinado o no existe información suficiente.

## Actividad

1. Abrir la sección **Targets**.
2. Localizar el job `prometheus`.
3. Localizar el job `node_exporter`.
4. Anotar el estado.
5. Anotar la URL de *scraping*.
6. Consultar el último error.
7. Comparar esta información con la métrica `up`.

---

# Sección Service Discovery

La sección **Service Discovery** muestra la información obtenida durante el descubrimiento de servicios.

En una configuración sencilla con `static_configs`, la información será limitada. Sin embargo, esta sección resulta más útil cuando se utilizan mecanismos como:

- DNS.
- Kubernetes.
- Consul.
- File-based discovery.
- Servicios de nube.

En un laboratorio con objetivos estáticos, el alumno debe identificar:

- El job configurado.
- El target descubierto.
- Las etiquetas asociadas.
- Las etiquetas antes y después del proceso de relabeling, si procede.

---

# Sección Rules

La sección **Rules** muestra las reglas configuradas en Prometheus.

Las reglas pueden ser:

- Reglas de grabación.
- Reglas de alerta.

En una instalación inicial puede no existir ninguna regla.

## Consultar reglas mediante la API

```bash
curl -s http://localhost:9090/api/v1/rules | jq
```

## Consultar alertas activas

```bash
curl -s http://localhost:9090/api/v1/alerts | jq
```

Si no hay reglas configuradas, el resultado será vacío o no contendrá reglas activas.

---

# Sección Configuration

La sección **Configuration** muestra la configuración que Prometheus tiene cargada.

Permite revisar:

- Intervalo de *scraping*.
- Intervalo de evaluación.
- Trabajos configurados.
- Objetivos.
- Etiquetas.
- Configuraciones de descubrimiento.

También puede consultarse la configuración desde la API:

```bash
curl -s http://localhost:9090/api/v1/status/config
```

Mostrarla con formato legible:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

Comparar con el fichero local:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

> La configuración cargada por Prometheus es la que está utilizando el proceso. El fichero local puede haber cambiado sin que el servicio se haya reiniciado o recargado.

---

# Sección Status

La sección **Status** proporciona información sobre el estado interno de Prometheus.

Puede incluir accesos a:

- Runtime & Build Information.
- Command-Line Flags.
- Configuration.
- Rules.
- Targets.
- Service Discovery.
- TSDB Status.

---

# Runtime & Build Information

Esta sección muestra información de compilación y ejecución.

Datos habituales:

- Versión de Prometheus.
- Versión de Go.
- Sistema operativo.
- Arquitectura.
- Revisión del código.
- Fecha de compilación.
- Tiempo de ejecución.

Consultar desde la API:

```bash
curl -s http://localhost:9090/api/v1/status/buildinfo | jq
```

Ejemplo conceptual:

```json
{
  "status": "success",
  "data": {
    "version": "3.5.0",
    "revision": "....",
    "branch": "release-3.5",
    "goVersion": "go1.24.x",
    "platform": "linux/amd64"
  }
}
```

---

# Command-Line Flags

Esta sección muestra las opciones con las que se inició Prometheus.

También se puede consultar el proceso:

```bash
ps -ef | grep '[p]rometheus'
```

Consultar la unidad de `systemd`:

```bash
systemctl show prometheus -p ExecStart
```

Estas opciones permiten comprobar:

- Fichero de configuración.
- Directorio de datos.
- Directorio de consolas.
- Opciones web.
- Parámetros de almacenamiento.

---

# TSDB Status

La sección **TSDB Status** muestra información sobre la base de datos de series temporales.

Puede incluir datos relacionados con:

- Número de series.
- Número de etiquetas.
- Nombres de métricas.
- Cardinalidad.
- Bloques de almacenamiento.

También pueden consultarse métricas internas:

```promql
prometheus_tsdb_head_series
```

```promql
prometheus_tsdb_head_chunks
```

```promql
prometheus_tsdb_head_samples_appended_total
```

Una cantidad excesiva de series puede incrementar el uso de memoria y almacenamiento. En un laboratorio pequeño, el número de series suele ser reducido.

---

# API HTTP de Prometheus

La interfaz web utiliza la API HTTP para consultar información.

## Consulta instantánea

Endpoint:

```text
/api/v1/query
```

Ejemplo:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

Mostrar solo las métricas y valores:

```bash
curl -sG http://localhost:9090/api/v1/query \
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

## Consulta de rango temporal

Endpoint:

```text
/api/v1/query_range
```

Ejemplo:

```bash
START=$(date -d '15 minutes ago' +%s)
END=$(date +%s)

curl -sG http://localhost:9090/api/v1/query_range \
  --data-urlencode 'query=up' \
  --data-urlencode "start=$START" \
  --data-urlencode "end=$END" \
  --data-urlencode 'step=15' \
  | jq
```

## Consultar objetivos

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

## Consultar la configuración

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

## Consultar reglas

```bash
curl -s http://localhost:9090/api/v1/rules | jq
```

## Consultar alertas

```bash
curl -s http://localhost:9090/api/v1/alerts | jq
```

---

# Sesiones prácticas

## Sesión 1: acceder a la interfaz

### Objetivo

Acceder a Prometheus y reconocer su interfaz.

### Pasos

1. Comprobar que el servicio está activo:

```bash
systemctl is-active prometheus
```

2. Abrir:

```text
http://localhost:9090
```

3. Identificar:
   - Área de consultas.
   - Selector de rango temporal.
   - Vista de tabla.
   - Vista gráfica.
   - Menú de estado.
   - Sección de objetivos.

### Actividades

1. Anota la URL utilizada.
2. Anota la versión de Prometheus.
3. Identifica la sección **Targets**.
4. Identifica la sección **Configuration**.
5. Identifica la sección **Runtime & Build Information**.

---

## Sesión 2: ejecutar la consulta `up`

### Objetivo

Comprobar la disponibilidad de los objetivos.

### Consulta

```promql
up
```

### Actividades

1. Ejecuta la consulta.
2. Cambia a la vista de tabla.
3. Anota todos los jobs.
4. Anota todas las instancias.
5. Anota el valor de cada serie.
6. Cambia a la vista gráfica.
7. Explica qué significa cada valor.

Completar:

| Job | Instance | Valor | Estado |
|---|---|---:|---|
| | | | |
| | | | |

---

## Sesión 3: consultar métricas de Prometheus

### Objetivo

Consultar métricas internas del propio Prometheus.

### Consultas

```promql
prometheus_build_info
```

```promql
process_resident_memory_bytes
```

```promql
process_cpu_seconds_total
```

```promql
prometheus_tsdb_head_series
```

```promql
prometheus_tsdb_head_samples_appended_total
```

### Actividades

1. Ejecuta cada consulta.
2. Indica si devuelve un valor o una serie temporal.
3. Observa las etiquetas.
4. Representa `process_resident_memory_bytes` como gráfico.
5. Explica qué información proporciona `prometheus_build_info`.

---

## Sesión 4: consultar Node Exporter

### Objetivo

Consultar métricas del sistema operativo desde la interfaz web.

### Requisitos

Node Exporter debe estar:

- Instalado.
- Activo.
- Configurado en Prometheus.
- En estado `UP`.

### Consultas

```promql
node_memory_MemTotal_bytes
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_cpu_seconds_total
```

```promql
node_filesystem_avail_bytes
```

```promql
node_network_receive_bytes_total
```

### Actividades

1. Ejecuta cada consulta.
2. Identifica las etiquetas disponibles.
3. Consulta la memoria disponible.
4. Consulta el espacio libre.
5. Consulta las interfaces de red.
6. Cambia entre tabla y gráfico.
7. Anota las métricas que no devuelvan datos.

---

## Sesión 5: filtrar por etiquetas

### Objetivo

Utilizar selectores de etiquetas.

### Consultas

```promql
up{job="node_exporter"}
```

```promql
node_cpu_seconds_total{mode="idle"}
```

```promql
node_network_receive_bytes_total{device!="lo"}
```

```promql
node_filesystem_avail_bytes{mountpoint="/"}
```

```promql
node_network_receive_bytes_total{device=~"en.*"}
```

### Actividades

1. Ejecuta la consulta sin filtros.
2. Añade un filtro por `job`.
3. Añade un filtro por `device`.
4. Añade un filtro por `mountpoint`.
5. Compara el número de series obtenidas.
6. Explica la diferencia entre `=` y `=~`.

---

## Sesión 6: calcular el uso de CPU

### Objetivo

Construir una consulta derivada para calcular el uso de CPU.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Explicación

1. `node_cpu_seconds_total` es un contador.
2. `mode="idle"` selecciona el tiempo de CPU inactiva.
3. `rate(...[5m])` calcula la velocidad de cambio durante cinco minutos.
4. `avg by (instance)` calcula el promedio por instancia.
5. Se multiplica por `100` para convertirlo en porcentaje.
6. Se resta a `100` para obtener el uso aproximado.

### Actividades

1. Ejecuta la consulta.
2. Cambia el rango temporal.
3. Representa el resultado en un gráfico.
4. Provoca carga controlada en el sistema.
5. Observa el cambio en el gráfico.

Para generar carga temporal de forma controlada:

```bash
for i in 1 2; do
  yes > /dev/null &
done
```

Consultar los procesos `yes`:

```bash
pgrep yes
```

Detenerlos:

```bash
pkill yes
```

> Esta actividad debe ejecutarse únicamente en el laboratorio y durante un periodo corto.

---

## Sesión 7: calcular el uso de memoria

### Objetivo

Calcular el porcentaje aproximado de memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Actividades

1. Ejecuta la consulta.
2. Observa el resultado en tabla.
3. Cambia a gráfico.
4. Comprueba las unidades.
5. Explica la diferencia entre memoria total y memoria disponible.
6. Compara el resultado con:

```bash
free -h
```

---

## Sesión 8: consultar los objetivos

### Objetivo

Relacionar la interfaz **Targets** con la métrica `up`.

### Pasos

1. Abrir la sección **Targets**.
2. Localizar el job `prometheus`.
3. Localizar el job `node_exporter`.
4. Anotar la URL de scraping.
5. Anotar el estado.
6. Consultar:

```promql
up
```

7. Comparar ambos resultados.

### Actividad de diagnóstico

Detener temporalmente Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Esperar varios intervalos de scraping y consultar:

```promql
up{job="node_exporter"}
```

Después iniciar de nuevo:

```bash
sudo systemctl start node_exporter
```

Comprobar el estado:

```bash
systemctl is-active node_exporter
```

Esperar a que el objetivo vuelva a aparecer como `UP`.

---

## Sesión 9: consultar la configuración cargada

### Objetivo

Comparar la configuración del disco con la configuración que Prometheus está utilizando.

### Desde la terminal

```bash
sudo cat /etc/prometheus/prometheus.yml
```

### Desde la API

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

### Desde la interfaz

1. Abrir la sección **Status**.
2. Entrar en **Configuration**.
3. Revisar el contenido.
4. Compararlo con el fichero local.

### Actividades

1. Identifica el intervalo de *scraping*.
2. Identifica los jobs.
3. Identifica los targets.
4. Comprueba si existe alguna diferencia.
5. Explica qué ocurre si se modifica el fichero pero no se recarga Prometheus.

---

## Sesión 10: utilizar la API desde la terminal

### Objetivo

Consultar desde la terminal la misma información que aparece en la interfaz web.

### Consultar `up`

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Consultar el uso de memoria

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)' \
  | jq
```

### Mostrar valores en formato tabular

```bash
curl -sG http://localhost:9090/api/v1/query \
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

### Actividades

1. Ejecuta una consulta desde la interfaz.
2. Ejecuta la misma consulta desde la API.
3. Compara los resultados.
4. Explica la estructura de la respuesta JSON.
5. Identifica el nombre de la métrica, las etiquetas y el valor.

---

# Diagnóstico básico

## La página no carga

Comprobar el servicio:

```bash
systemctl status prometheus
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9090'
```

Probar con `curl`:

```bash
curl -v http://localhost:9090
```

Consultar los registros:

```bash
sudo journalctl -u prometheus --no-pager -n 50
```

## La página carga, pero una consulta no devuelve datos

Comprobar primero:

```promql
up
```

Después:

```promql
prometheus_build_info
```

Si Node Exporter está instalado:

```promql
node_memory_MemAvailable_bytes
```

Comprobar el endpoint directamente:

```bash
curl http://localhost:9100/metrics
```

Comprobar los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

Posibles causas:

- Nombre incorrecto de la métrica.
- Target no configurado.
- Target en estado `DOWN`.
- Etiqueta incorrecta.
- Rango temporal demasiado corto.
- Node Exporter detenido.
- Prometheus todavía no ha realizado el primer scraping.

## La métrica existe en Node Exporter, pero no en Prometheus

Comprobar:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

Después:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [.health, .lastError]
    | @tsv
  '
```

Revisar:

- Configuración de `scrape_configs`.
- Puerto `9100`.
- Estado de Node Exporter.
- Tiempo transcurrido desde el reinicio.
- Logs de Prometheus.

## La vista gráfica no muestra líneas

Comprobar:

- Que la consulta devuelve datos.
- Que el rango temporal incluye muestras.
- Que Prometheus lleva suficiente tiempo activo.
- Que la métrica es adecuada para una consulta temporal.
- Que no se ha seleccionado un rango futuro.
- Que el objetivo está disponible.

## La interfaz funciona en el servidor, pero no remotamente

Comprobar la dirección de escucha:

```bash
sudo ss -lntp | grep ':9090'
```

Comprobar el cortafuegos:

```bash
sudo ufw status
```

Probar desde el equipo remoto:

```bash
curl http://<IP-DE-PROMETHEUS>:9090/-/healthy
```

---

# Ejemplo de sesión completa

```console
$ systemctl is-active prometheus
active

$ curl http://localhost:9090/-/healthy
Prometheus is Healthy.

$ curl -sG http://localhost:9090/api/v1/query \
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
prometheus      localhost:9090  1
node_exporter   localhost:9100  1
```

En el navegador se ejecutan las siguientes consultas:

```promql
up
```

```promql
prometheus_build_info
```

```promql
node_memory_MemAvailable_bytes
```

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Resultado esperado:

- Prometheus aparece como disponible.
- Node Exporter aparece como disponible.
- Las métricas internas de Prometheus devuelven datos.
- Las métricas de Node Exporter devuelven datos.
- Las consultas calculadas muestran valores numéricos.
- La vista gráfica representa la evolución temporal.

---

# Actividad integradora

## Objetivo

Utilizar la interfaz web para verificar toda la cadena de monitorización.

## Tareas

1. Acceder a la interfaz web.
2. Ejecutar la consulta `up`.
3. Identificar todos los jobs.
4. Identificar todas las instancias.
5. Consultar una métrica interna de Prometheus.
6. Consultar una métrica de Node Exporter.
7. Filtrar una métrica por etiquetas.
8. Calcular el uso de memoria.
9. Calcular el uso de CPU.
10. Revisar la sección **Targets**.
11. Revisar la sección **Configuration**.
12. Revisar la información de compilación.
13. Consultar la API HTTP.
14. Guardar capturas o resultados como evidencias.

## Evidencias

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/interfaz-prometheus
```

Guardar los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq \
  > ~/laboratorio-grafana/evidencias/interfaz-prometheus/targets.json
```

Guardar la configuración cargada:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml' \
  > ~/laboratorio-grafana/evidencias/interfaz-prometheus/configuracion-cargada.yml
```

Guardar la información de compilación:

```bash
curl -s http://localhost:9090/api/v1/status/buildinfo \
  | jq \
  > ~/laboratorio-grafana/evidencias/interfaz-prometheus/buildinfo.json
```

Guardar el resultado de `up`:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq \
  > ~/laboratorio-grafana/evidencias/interfaz-prometheus/query-up.json
```

Guardar una consulta de memoria:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/interfaz-prometheus/query-memoria.json
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Acceso web | | |
| Consulta `up` | | |
| Métrica de Prometheus | | |
| Métrica de Node Exporter | | |
| Filtro por etiquetas | | |
| Uso de CPU | | |
| Uso de memoria | | |
| Targets | | |
| Configuration | | |
| Build Information | | |
| API HTTP | | |

---

# Puntos clave

- La interfaz web de Prometheus está disponible normalmente en el puerto `9090`.
- La consulta `up` permite comprobar la disponibilidad de los objetivos.
- La vista de tabla muestra valores y etiquetas.
- La vista gráfica muestra la evolución temporal de las series.
- PromQL permite seleccionar, filtrar y transformar métricas.
- Las etiquetas permiten distinguir diferentes series temporales.
- La sección **Targets** muestra el estado del *scraping*.
- La sección **Configuration** muestra la configuración cargada.
- **Runtime & Build Information** muestra información de la versión y ejecución.
- La API HTTP permite automatizar consultas desde la terminal.
- Una métrica disponible en Node Exporter no necesariamente está disponible todavía en Prometheus.
- Los objetivos deben estar en estado `UP` para recopilar métricas correctamente.
- `rate()` permite calcular la velocidad de cambio de los contadores.
- Un rango temporal demasiado corto puede dificultar la interpretación de un gráfico.
- Grafana se utilizará posteriormente para crear dashboards más completos.
- La interfaz web de Prometheus es especialmente útil para verificar y diagnosticar.

---

# Preguntas de comprobación

1. ¿En qué puerto escucha normalmente la interfaz web de Prometheus?
2. ¿Qué URL se utiliza para acceder desde el propio servidor?
3. ¿Qué consulta permite comprobar la disponibilidad de los objetivos?
4. ¿Qué significa un valor `up = 1`?
5. ¿Qué significa un valor `up = 0`?
6. ¿Qué diferencia existe entre la vista de tabla y la vista gráfica?
7. ¿Qué información muestra la sección **Targets**?
8. ¿Qué información muestra la sección **Configuration**?
9. ¿Qué información muestra **Runtime & Build Information**?
10. ¿Para qué sirve la sección **TSDB Status**?
11. ¿Cómo se filtra una métrica por el job `node_exporter`?
12. ¿Cómo se excluye la interfaz `lo` de una consulta?
13. ¿Para qué sirve `rate()`?
14. ¿Por qué se utiliza `[5m]` en algunas consultas?
15. ¿Qué diferencia existe entre una consulta instantánea y una consulta temporal?
16. ¿Qué endpoint permite comprobar la salud de Prometheus?
17. ¿Qué endpoint permite consultar los objetivos mediante la API?
18. ¿Por qué una consulta puede no devolver datos aunque la interfaz funcione?
19. ¿Qué comprobarías si Node Exporter aparece como `DOWN`?
20. ¿Por qué Grafana no sustituye a la interfaz de consultas de Prometheus?
21. ¿Cómo consultarías la configuración cargada desde la terminal?
22. ¿Cómo consultarías la información de compilación?
23. ¿Qué diferencia existe entre una métrica y una serie temporal?
24. ¿Qué función cumplen las etiquetas?
25. ¿Qué pasos seguirías para diagnosticar un gráfico vacío?

---

# Criterios de finalización

La práctica se considera completada cuando el alumno puede:

- Acceder a la interfaz web de Prometheus.
- Ejecutar la consulta `up`.
- Interpretar sus resultados.
- Consultar métricas internas de Prometheus.
- Consultar métricas de Node Exporter.
- Filtrar métricas mediante etiquetas.
- Cambiar entre tabla y gráfico.
- Consultar los objetivos configurados.
- Identificar un objetivo `UP` y uno `DOWN`.
- Consultar la configuración cargada.
- Consultar la información de compilación.
- Utilizar la API HTTP.
- Calcular el uso de CPU.
- Calcular el uso de memoria.
- Explicar por qué una consulta puede no devolver datos.
- Guardar evidencias de las comprobaciones realizadas.

El recorrido que debe dominar el alumno es:

```text
Acceso a Prometheus
        |
        v
Ejecución de una consulta PromQL
        |
        v
Interpretación de valores y etiquetas
        |
        v
Comprobación de Targets
        |
        v
Diagnóstico del scraping
        |
        v
Consulta de métricas de Node Exporter
        |
        v
Preparación de consultas para Grafana
```