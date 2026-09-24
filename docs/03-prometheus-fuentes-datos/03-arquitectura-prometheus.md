# Arquitectura de Prometheus

Prometheus es una plataforma de monitorización basada en **series temporales**. Su función principal es recopilar métricas de diferentes objetivos, almacenarlas y permitir su consulta mediante PromQL.

En este bloque se utilizará una arquitectura formada por:

```text
Sistema operativo
        |
        v
Node Exporter
        |
        | Scraping HTTP
        v
Prometheus
        |
        | Consultas PromQL
        v
Grafana
        |
        v
Dashboards
```

La arquitectura sigue normalmente un modelo **pull**: Prometheus consulta periódicamente los endpoints de métricas de los sistemas monitorizados.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la función de Prometheus dentro de una plataforma de monitorización.
- Identificar los componentes principales de la arquitectura.
- Diferenciar entre Prometheus, Node Exporter y Grafana.
- Explicar el modelo de recopilación *pull*.
- Diferenciar entre un `job`, un `target`, una métrica y una serie temporal.
- Comprender la función de las etiquetas.
- Identificar el endpoint `/metrics`.
- Interpretar la métrica `up`.
- Consultar los objetivos configurados en Prometheus.
- Consultar la API HTTP de Prometheus.
- Comprender el recorrido de una métrica desde el sistema operativo hasta Grafana.
- Diagnosticar dónde puede producirse un error en la cadena de monitorización.

---

## Introducción

Una plataforma de monitorización debe responder a preguntas como:

- ¿Está disponible un servidor?
- ¿Cuánto CPU está utilizando?
- ¿Cuánta memoria queda disponible?
- ¿Qué sistemas de ficheros están próximos a llenarse?
- ¿Qué cantidad de tráfico circula por una interfaz de red?
- ¿Desde cuándo está funcionando un servicio?
- ¿Cuándo comenzó a degradarse el rendimiento?

Prometheus responde a estas preguntas recopilando valores medibles llamados **métricas**.

Una métrica es un valor asociado a un nombre y, opcionalmente, a un conjunto de etiquetas.

Ejemplo:

```text
node_memory_MemAvailable_bytes 2147483648
```

Esta métrica indica la memoria disponible expresada en bytes.

Una métrica con etiquetas puede tener esta forma:

```text
node_network_receive_bytes_total{
  device="ens33",
  instance="localhost:9100",
  job="node_exporter"
} 123456789
```

Las etiquetas permiten distinguir distintas series. Por ejemplo, el tráfico recibido puede medirse por cada interfaz de red.

---

# Componentes de la arquitectura

## Prometheus

Prometheus es el componente central de la plataforma.

Sus funciones principales son:

- Consultar objetivos de monitorización.
- Recopilar métricas periódicamente.
- Almacenar muestras como series temporales.
- Asociar etiquetas a los datos.
- Ejecutar consultas PromQL.
- Evaluar reglas de grabación.
- Evaluar reglas de alerta.
- Exponer una API HTTP.
- Proporcionar una interfaz web.

Prometheus escucha normalmente en el puerto:

```text
9090
```

URL habitual:

```text
http://localhost:9090
```

### Flujo interno simplificado

```text
Configuración
      |
      v
Descubrimiento de objetivos
      |
      v
Scraping
      |
      v
Procesamiento de etiquetas
      |
      v
Almacenamiento local
      |
      v
Consultas PromQL
```

---

## Node Exporter

Node Exporter es un componente que expone métricas del sistema operativo.

Recopila información como:

- Tiempo de CPU.
- Memoria.
- Sistemas de ficheros.
- Interfaces de red.
- Tiempo de actividad.
- Procesos.
- Información del kernel.
- Carga del sistema.

Node Exporter no suele enviar los datos directamente a Prometheus. En su lugar, publica un endpoint HTTP que Prometheus consulta.

Endpoint habitual:

```text
http://localhost:9100/metrics
```

Puerto habitual:

```text
9100
```

Ejemplo de consulta:

```bash
curl http://localhost:9100/metrics
```

Ejemplo de respuesta:

```text
# HELP node_memory_MemAvailable_bytes Memory information field MemAvailable_bytes.
# TYPE node_memory_MemAvailable_bytes gauge
node_memory_MemAvailable_bytes 2.147483648e+09
```

La respuesta contiene:

- Comentarios de ayuda.
- Tipo de métrica.
- Nombre de la métrica.
- Etiquetas, si existen.
- Valor actual.

---

## Exporters

Un *exporter* es un componente que transforma información de un sistema en métricas que Prometheus puede consultar.

No todos los sistemas exponen métricas en el formato de Prometheus. Un exporter actúa como adaptador.

Ejemplos:

| Exporter | Sistema monitorizado |
|---|---|
| Node Exporter | Sistema operativo |
| MySQL Exporter | MySQL |
| PostgreSQL Exporter | PostgreSQL |
| Blackbox Exporter | HTTP, DNS, ICMP y TCP |
| SNMP Exporter | Dispositivos de red mediante SNMP |
| Windows Exporter | Servidores Windows |

El patrón general es:

```text
Sistema o aplicación
          |
          v
Exporter
          |
          v
Endpoint /metrics
          |
          v
Prometheus
```

---

## Grafana

Grafana es la herramienta utilizada para visualizar los datos almacenados en Prometheus.

Grafana no sustituye a Prometheus:

- Prometheus recopila y almacena métricas.
- Grafana consulta y representa esas métricas.
- PromQL se utiliza para obtener los datos desde Prometheus.
- Grafana puede utilizar otras fuentes de datos además de Prometheus.

Puerto habitual:

```text
3000
```

URL habitual:

```text
http://localhost:3000
```

Flujo entre Grafana y Prometheus:

```text
Usuario
   |
   v
Grafana
   |
   | Consulta PromQL
   v
Prometheus
   |
   | Devuelve series temporales
   v
Grafana muestra un panel
```

---

# Modelo de recopilación

## Modelo pull

Prometheus utiliza normalmente un modelo *pull*. Esto significa que Prometheus inicia la conexión con el objetivo y solicita sus métricas.

```text
Prometheus ---- HTTP GET /metrics ----> Node Exporter
Prometheus <--- Respuesta con métricas -- Node Exporter
```

La configuración determina:

- Qué objetivos se consultan.
- Cada cuánto tiempo se consultan.
- Qué etiquetas se asignan.
- Qué protocolo y ruta se utilizan.

Ventajas del modelo *pull*:

- Prometheus controla el intervalo de recopilación.
- Es sencillo comprobar si un objetivo responde.
- La configuración está centralizada.
- Se puede detectar si un objetivo está caído.
- No es necesario configurar cada exporter para enviar datos.

## Modelo push

En un modelo *push*, el sistema monitorizado inicia la comunicación y envía los datos hacia otro componente.

```text
Aplicación ---- métricas ----> Receptor
```

Prometheus no utiliza normalmente este modelo para la monitorización habitual. Sin embargo, existen mecanismos complementarios, como Pushgateway, para casos concretos.

### Comparación

| Característica | Modelo pull | Modelo push |
|---|---|---|
| Quién inicia la conexión | Prometheus | Sistema monitorizado |
| Configuración principal | Prometheus | Cliente o emisor |
| Detección de objetivos caídos | Directa mediante `up` | Requiere mecanismos adicionales |
| Uso habitual en Prometheus | Sí | Casos específicos |

---

# Jobs y targets

## Job

Un `job` es un grupo lógico de objetivos relacionados.

Ejemplo:

```yaml
job_name: node_exporter
```

Este trabajo agrupa objetivos que exponen métricas del sistema operativo.

Otros ejemplos:

```yaml
job_name: prometheus
```

```yaml
job_name: database
```

```yaml
job_name: web_servers
```

## Target

Un `target` es un endpoint concreto que Prometheus consulta.

Ejemplo:

```yaml
targets:
  - localhost:9100
```

Un mismo `job` puede contener varios objetivos:

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - server-01.example.local:9100
        - server-02.example.local:9100
        - server-03.example.local:9100
```

Representación:

```text
Job: linux_servers
├── server-01.example.local:9100
├── server-02.example.local:9100
└── server-03.example.local:9100
```

## Ejemplo de configuración

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

En este ejemplo:

| Elemento | Valor |
|---|---|
| Job | `node_exporter` |
| Target | `localhost:9100` |
| Protocolo | HTTP |
| Ruta predeterminada | `/metrics` |
| Puerto | `9100` |

---

# Scraping

El *scraping* es el proceso mediante el cual Prometheus consulta un endpoint de métricas.

La secuencia es:

1. Prometheus lee su configuración.
2. Identifica los objetivos.
3. Espera el intervalo configurado.
4. Realiza una petición HTTP.
5. Lee las métricas devueltas.
6. Aplica etiquetas.
7. Almacena las muestras.
8. Actualiza el estado del objetivo.

Configuración básica:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

La propiedad `scrape_interval` indica cada cuánto tiempo se consulta un objetivo.

Ejemplo:

```yaml
global:
  scrape_interval: 30s
```

En este caso, Prometheus intentará recopilar las métricas cada treinta segundos.

## Intervalo global e intervalo específico

Es posible definir un intervalo global:

```yaml
global:
  scrape_interval: 15s
```

Y sobrescribirlo para un trabajo concreto:

```yaml
scrape_configs:
  - job_name: node_exporter
    scrape_interval: 10s
    static_configs:
      - targets:
          - localhost:9100
```

El intervalo específico del trabajo tiene prioridad sobre el intervalo global.

---

# Modelo de datos

## Series temporales

Prometheus almacena los datos como series temporales.

Una serie se identifica mediante:

- El nombre de la métrica.
- El conjunto de etiquetas.

Ejemplo:

```text
node_memory_MemAvailable_bytes{
  instance="localhost:9100",
  job="node_exporter"
}
```

Cada muestra contiene:

- Un valor.
- Una marca temporal.

Representación conceptual:

```text
Métrica + etiquetas + tiempo + valor
```

Ejemplo:

```text
Nombre:     node_memory_MemAvailable_bytes
Instancia:  localhost:9100
Job:        node_exporter
Timestamp:  2026-09-24 16:30:00
Valor:      2147483648
```

## Etiquetas

Las etiquetas permiten añadir contexto a una métrica.

Ejemplo:

```text
node_cpu_seconds_total{
  cpu="0",
  mode="idle",
  instance="localhost:9100",
  job="node_exporter"
}
```

En este caso:

- `cpu="0"` identifica el procesador.
- `mode="idle"` identifica el modo de CPU.
- `instance="localhost:9100"` identifica el objetivo.
- `job="node_exporter"` identifica el trabajo.

## Etiquetas habituales

| Etiqueta | Significado |
|---|---|
| `job` | Trabajo al que pertenece el objetivo |
| `instance` | Dirección del objetivo |
| `device` | Dispositivo, interfaz o recurso |
| `mountpoint` | Punto de montaje |
| `mode` | Modo de una métrica |
| `cpu` | Identificador de procesador |

---

# Tipos de métricas

Prometheus utiliza varios tipos de métricas.

## Counter

Un `counter` representa un valor acumulativo que normalmente solo aumenta.

Ejemplo:

```text
node_network_receive_bytes_total
```

Los contadores pueden reiniciarse cuando se reinicia el proceso o el sistema.

Para calcular una velocidad de cambio se utiliza normalmente `rate()`:

```promql
rate(node_network_receive_bytes_total[5m])
```

## Gauge

Un `gauge` representa un valor que puede aumentar o disminuir.

Ejemplos:

```text
node_memory_MemAvailable_bytes
```

```text
node_load1
```

```text
node_filesystem_avail_bytes
```

## Histogram

Un histograma agrupa observaciones en intervalos.

Se utiliza habitualmente para estudiar distribuciones, como latencias de peticiones.

## Summary

Un `summary` calcula determinados cuantiles en el cliente que genera la métrica.

En las primeras prácticas se trabajará principalmente con:

- `counter`.
- `gauge`.

---

# La métrica `up`

La métrica `up` es una métrica especial que indica si Prometheus ha podido recopilar métricas de un objetivo.

Ejemplo:

```promql
up
```

Resultado conceptual:

```text
up{instance="localhost:9090",job="prometheus"} 1
up{instance="localhost:9100",job="node_exporter"} 1
```

Interpretación:

| Valor | Significado |
|---:|---|
| `1` | El objetivo respondió correctamente |
| `0` | El objetivo no respondió correctamente |

Filtrar Node Exporter:

```promql
up{job="node_exporter"}
```

Filtrar una instancia:

```promql
up{instance="localhost:9100"}
```

Consultar objetivos caídos:

```promql
up == 0
```

Contar objetivos disponibles:

```promql
sum(up)
```

Contar objetivos caídos:

```promql
count(up == 0)
```

> La métrica `up` indica si Prometheus pudo realizar el scraping. No significa necesariamente que todos los componentes internos del objetivo funcionen correctamente.

---

# Configuración mínima

Un fichero de configuración básico puede ser:

```yaml
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
```

## Elementos de la configuración

### `global`

Define valores generales:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

- `scrape_interval`: frecuencia de recopilación.
- `evaluation_interval`: frecuencia de evaluación de reglas.

### `scrape_configs`

Contiene la configuración de los trabajos:

```yaml
scrape_configs:
  - job_name: node_exporter
```

### `job_name`

Identifica el trabajo:

```yaml
job_name: node_exporter
```

### `static_configs`

Define objetivos estáticos:

```yaml
static_configs:
  - targets:
      - localhost:9100
```

### `targets`

Lista de endpoints que deben consultarse:

```yaml
targets:
  - localhost:9100
  - server-02:9100
```

---

# Etiquetas externas y personalizadas

Es posible añadir etiquetas a los objetivos mediante `labels`.

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          team: sistemas
```

Las etiquetas pueden utilizarse en las consultas:

```promql
up{environment="laboratorio"}
```

```promql
node_memory_MemAvailable_bytes{team="sistemas"}
```

También se pueden definir etiquetas externas para identificar una instalación de Prometheus:

```yaml
global:
  external_labels:
    environment: laboratorio
    region: madrid
```

---

# Service discovery

En un laboratorio pequeño se pueden definir los objetivos manualmente:

```yaml
static_configs:
  - targets:
      - localhost:9100
```

En entornos más grandes, los objetivos pueden descubrirse automáticamente mediante mecanismos como:

- DNS.
- Kubernetes.
- Consul.
- EC2.
- Azure.
- Google Cloud.
- Ficheros.
- Otros sistemas de descubrimiento.

Ejemplo conceptual mediante fichero:

```yaml
scrape_configs:
  - job_name: linux_servers
    file_sd_configs:
      - files:
          - /etc/prometheus/targets/*.yml
```

El descubrimiento permite evitar la modificación constante del fichero principal de Prometheus cuando se incorporan nuevos servidores.

---

# Recorrido completo de una métrica

Consideremos la métrica de memoria disponible.

## Paso 1: el sistema operativo genera el dato

El sistema operativo conoce la memoria total y disponible.

```text
Memoria disponible: 2 GiB
```

## Paso 2: Node Exporter expone la métrica

```text
node_memory_MemAvailable_bytes 2147483648
```

## Paso 3: Prometheus realiza el scraping

Prometheus consulta:

```text
http://localhost:9100/metrics
```

## Paso 4: Prometheus añade etiquetas

```text
node_memory_MemAvailable_bytes{
  instance="localhost:9100",
  job="node_exporter"
} 2147483648
```

## Paso 5: Prometheus almacena la muestra

La muestra se guarda con su valor y marca temporal.

## Paso 6: PromQL consulta el dato

```promql
node_memory_MemAvailable_bytes
```

## Paso 7: Grafana representa el resultado

Grafana puede mostrar el dato como:

- Valor instantáneo.
- Serie temporal.
- Indicador.
- Tabla.
- Gráfico de área.
- Panel de capacidad.

---

# Ejemplo completo

## Arquitectura del laboratorio

```text
Servidor Ubuntu: 192.168.1.50

+---------------------------------------------------+
|                                                   |
|  Node Exporter                                    |
|  192.168.1.50:9100/metrics                       |
|                                                   |
|  Prometheus                                       |
|  192.168.1.50:9090                               |
|                                                   |
|  Grafana                                          |
|  192.168.1.50:3000                               |
|                                                   |
+---------------------------------------------------+
```

## Configuración

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

## Comprobación de Node Exporter

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

Ejemplo:

```text
node_memory_MemAvailable_bytes 2.147483648e+09
```

## Comprobación del objetivo

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .labels.instance,
        .health
      ]
    | @tsv
  '
```

Ejemplo:

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

## Consulta desde PromQL

```promql
node_memory_MemAvailable_bytes
```

## Consulta filtrada

```promql
node_memory_MemAvailable_bytes{
  job="node_exporter"
}
```

## Consulta para Grafana

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Esta consulta calcula un porcentaje aproximado de memoria utilizada.

---

# Sesiones prácticas

## Sesión 1: identificar los componentes

### Objetivo

Reconocer los componentes que forman la arquitectura del laboratorio.

### Actividad

Completar la tabla:

| Componente | Función | Puerto | ¿Inicia la conexión? |
|---|---|---:|---|
| Prometheus | | 9090 | |
| Node Exporter | | 9100 | |
| Grafana | | 3000 | |

### Preguntas

1. ¿Qué componente recopila las métricas?
2. ¿Qué componente expone las métricas?
3. ¿Qué componente visualiza los datos?
4. ¿Qué componente inicia normalmente el scraping?

---

## Sesión 2: consultar el endpoint de Node Exporter

### Objetivo

Comprobar que Node Exporter expone métricas HTTP.

### Comandos

```bash
curl -I http://localhost:9100/metrics
```

Mostrar las primeras líneas:

```bash
curl -s http://localhost:9100/metrics | head -n 20
```

Buscar métricas de CPU:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

Buscar métricas de memoria:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_' \
  | head
```

Buscar métricas de red:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_network_' \
  | head
```

### Ejemplo de sesión

```console
$ curl -I http://localhost:9100/metrics
HTTP/1.1 200 OK
Content-Type: text/plain; version=0.0.4; charset=utf-8

$ curl -s http://localhost:9100/metrics | grep '^node_memory_' | head
node_memory_MemTotal_bytes 4.10437632e+09
node_memory_MemFree_bytes 6.291456e+08
node_memory_MemAvailable_bytes 2.414534656e+09
```

### Actividades

1. Comprueba que el endpoint responde con código `200`.
2. Localiza tres métricas de CPU.
3. Localiza tres métricas de memoria.
4. Localiza tres métricas de red.
5. Identifica las etiquetas presentes.
6. Explica la diferencia entre `MemFree` y `MemAvailable`.

---

## Sesión 3: inspeccionar los objetivos configurados

### Objetivo

Comprobar los `jobs`, `targets` y estados detectados por Prometheus.

### Consultar todos los objetivos

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

### Mostrar la información relevante

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | {
        job: .labels.job,
        instance: .labels.instance,
        health: .health,
        scrapeUrl: .scrapeUrl,
        lastError: .lastError
      }
  '
```

### Mostrar solo los objetivos caídos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.health != "up")
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

### Actividades

1. Cuenta cuántos objetivos hay.
2. Anota el nombre de cada `job`.
3. Anota la dirección de cada `target`.
4. Comprueba el estado de salud.
5. Indica qué error aparece cuando un objetivo está caído.
6. Relaciona cada objetivo con su puerto.

---

## Sesión 4: experimentar con `up`

### Objetivo

Utilizar `up` para comprobar la disponibilidad de los objetivos.

### Consultas

```promql
up
```

```promql
up{job="prometheus"}
```

```promql
up{job="node_exporter"}
```

```promql
up == 0
```

```promql
sum(up)
```

```promql
count(up)
```

### Actividades

1. Ejecuta `up`.
2. Identifica los objetivos disponibles.
3. Detén temporalmente Node Exporter:

```bash
sudo systemctl stop node_exporter
```

4. Espera varios intervalos de scraping.
5. Ejecuta:

```promql
up{job="node_exporter"}
```

6. Inicia de nuevo el servicio:

```bash
sudo systemctl start node_exporter
```

7. Comprueba cuándo vuelve a aparecer como disponible.

> Esta práctica debe realizarse únicamente en el entorno de laboratorio. Detener un exporter en un servidor de producción puede generar alertas o pérdida de información.

---

## Sesión 5: seguir una métrica

### Objetivo

Seguir el recorrido de una métrica desde Node Exporter hasta Prometheus.

### Paso 1: consultar directamente Node Exporter

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

### Paso 2: consultar Prometheus mediante la API

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_memory_MemAvailable_bytes' \
  | jq
```

### Paso 3: mostrar únicamente el valor

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_memory_MemAvailable_bytes' \
  | jq -r '.data.result[] | [.metric.instance, .value[1]] | @tsv'
```

### Ejemplo de respuesta

```text
localhost:9100    2414534656
```

### Paso 4: consultar la misma métrica en PromQL

```promql
node_memory_MemAvailable_bytes
```

### Actividades

1. Compara el valor de Node Exporter con el valor de Prometheus.
2. Explica por qué puede existir una pequeña diferencia temporal.
3. Identifica las etiquetas añadidas por Prometheus.
4. Explica qué representa `value[1]` en la respuesta de la API.

---

## Sesión 6: analizar etiquetas

### Objetivo

Comprender cómo las etiquetas identifican una serie temporal.

### Consulta

```promql
node_cpu_seconds_total
```

Observar especialmente:

```text
cpu
mode
instance
job
```

### Filtrar por modo

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Filtrar por procesador

```promql
node_cpu_seconds_total{
  cpu="0"
}
```

### Filtrar por trabajo

```promql
node_cpu_seconds_total{
  job="node_exporter"
}
```

### Combinar filtros

```promql
node_cpu_seconds_total{
  job="node_exporter",
  cpu="0",
  mode="idle"
}
```

### Actividades

1. Consulta todas las series de CPU.
2. Filtra el procesador `0`.
3. Filtra el modo `idle`.
4. Combina ambos filtros.
5. Explica por qué cada combinación representa una serie diferente.

---

## Sesión 7: comprobar el modelo pull

### Objetivo

Observar que Prometheus consulta a Node Exporter.

### Paso 1: consultar Node Exporter

```bash
curl -s http://localhost:9100/metrics | head
```

### Paso 2: revisar la configuración

```bash
sudo grep -A8 -B2 'node_exporter' /etc/prometheus/prometheus.yml
```

### Paso 3: consultar el objetivo

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .scrapeUrl,
        .lastScrape,
        .lastScrapeDuration,
        .health
      ]
    | @tsv
  '
```

### Actividades

1. Identifica la URL de scraping.
2. Identifica el momento del último scraping.
3. Identifica la duración del último scraping.
4. Comprueba el estado.
5. Explica qué componente inicia la petición HTTP.

---

# Diagnóstico de la arquitectura

## Caso 1: Node Exporter no responde

### Síntoma

```bash
curl http://localhost:9100/metrics
```

Devuelve un error de conexión.

### Comprobaciones

```bash
systemctl status node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
sudo journalctl -u node_exporter --no-pager -n 50
```

### Posibles causas

- El servicio está detenido.
- El binario no existe.
- El puerto está ocupado.
- Hay un error en la unidad de `systemd`.
- El cortafuegos bloquea la conexión.
- Node Exporter está escuchando en otra dirección.

---

## Caso 2: Node Exporter responde, pero Prometheus lo muestra como `down`

### Comprobaciones

```bash
curl http://localhost:9100/metrics
```

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [.health, .lastError, .scrapeUrl]
    | @tsv
  '
```

### Posibles causas

- El target está mal escrito.
- El puerto es incorrecto.
- La dirección no es accesible desde Prometheus.
- Hay un error de configuración YAML.
- El objetivo utiliza HTTPS cuando debería utilizar HTTP.
- El cortafuegos bloquea el puerto.

---

## Caso 3: Grafana no muestra datos

### Comprobaciones

1. Verificar que Prometheus responde:

```bash
curl http://localhost:9090/-/healthy
```

2. Verificar que existen datos:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

3. Verificar la fuente de datos en Grafana.
4. Comprobar que la URL es correcta.
5. Comprobar que se utiliza el puerto `9090`.
6. Ejecutar primero la consulta:

```promql
up
```

### Error habitual

Si Grafana y Prometheus están en máquinas diferentes, esta URL puede ser incorrecta:

```text
http://localhost:9090
```

Debe utilizarse una dirección accesible desde el servidor de Grafana:

```text
http://<IP-DE-PROMETHEUS>:9090
```

---

# Actividad integradora

## Objetivo

Representar y comprobar la arquitectura completa del laboratorio.

### Tareas

1. Dibuja la arquitectura del laboratorio.
2. Identifica todos los componentes.
3. Anota los puertos.
4. Comprueba que Node Exporter responde.
5. Comprueba que Prometheus puede realizar scraping.
6. Comprueba la métrica `up`.
7. Consulta una métrica de memoria.
8. Conecta Grafana con Prometheus.
9. Ejecuta una consulta desde Grafana.
10. Documenta cualquier error encontrado.

### Diagrama que debe completar el alumno

```text
________________________
        |
        | ________________________
        v
________________________
        |
        | ________________________
        v
________________________
        |
        | ________________________
        v
________________________
```

### Tabla de resultados

| Comprobación | Comando o consulta | Resultado |
|---|---|---|
| Node Exporter responde | | |
| Prometheus está saludable | | |
| Target de Node Exporter | | |
| `up{job="node_exporter"}` | | |
| Métrica de memoria | | |
| Fuente de datos de Grafana | | |
| Consulta desde Grafana | | |

---

# Puntos clave

- Prometheus es el componente central de recopilación y consulta.
- Node Exporter expone métricas del sistema operativo.
- Grafana visualiza los datos obtenidos desde Prometheus.
- Prometheus utiliza normalmente un modelo de recopilación *pull*.
- Un `job` agrupa objetivos relacionados.
- Un `target` es un endpoint concreto.
- El endpoint habitual de métricas es `/metrics`.
- La métrica `up` indica si el último scraping fue correcto.
- Un valor `up = 1` indica que el objetivo respondió.
- Un valor `up = 0` indica que el objetivo no respondió correctamente.
- Las etiquetas identifican y clasifican las series temporales.
- `counter` representa valores acumulativos.
- `gauge` representa valores que pueden subir o bajar.
- `rate()` se utiliza habitualmente con contadores.
- Prometheus almacena muestras asociadas a marcas temporales.
- La API HTTP permite consultar objetivos y métricas.
- Grafana necesita conectividad con Prometheus.
- Un fallo puede producirse en el exporter, en la red, en Prometheus o en Grafana.
- La arquitectura debe verificarse de extremo a extremo.
- Una métrica visible en Node Exporter no garantiza que ya esté disponible en Prometheus.

---

# Preguntas de comprobación

1. ¿Qué función cumple Prometheus?
2. ¿Qué función cumple Node Exporter?
3. ¿Qué función cumple Grafana?
4. ¿Qué significa que Prometheus utilice un modelo *pull*?
5. ¿Qué es un `job`?
6. ¿Qué es un `target`?
7. ¿Qué endpoint expone normalmente Node Exporter?
8. ¿Qué puerto utiliza normalmente Prometheus?
9. ¿Qué puerto utiliza normalmente Node Exporter?
10. ¿Qué indica la métrica `up`?
11. ¿Qué diferencia existe entre `up = 1` y `up = 0`?
12. ¿Qué es una serie temporal?
13. ¿Para qué sirven las etiquetas?
14. ¿Qué diferencia existe entre un `counter` y un `gauge`?
15. ¿Por qué se utiliza `rate()` con algunas métricas?
16. ¿Qué información contiene una muestra?
17. ¿Qué componente inicia normalmente la petición HTTP de scraping?
18. ¿Qué puede provocar que un target aparezca como `down`?
19. ¿Por qué una métrica puede aparecer en Node Exporter pero no en Prometheus?
20. ¿Por qué Grafana no debe utilizar `localhost` para acceder a Prometheus cuando están en equipos diferentes?
21. ¿Qué comando permite consultar los objetivos de Prometheus?
22. ¿Qué comando permite comprobar el endpoint de Node Exporter?
23. ¿Qué consulta muestra todos los objetivos disponibles?
24. ¿Qué consulta muestra únicamente los objetivos caídos?
25. ¿Qué componente almacena las series temporales?

---

# Criterios de finalización

La sección se considera superada cuando el alumno puede:

- Dibujar la arquitectura de Prometheus.
- Explicar la función de cada componente.
- Identificar los puertos principales.
- Explicar el modelo *pull*.
- Diferenciar `job` y `target`.
- Consultar el endpoint `/metrics`.
- Consultar la API de objetivos.
- Interpretar la métrica `up`.
- Identificar etiquetas de una serie.
- Seguir una métrica desde Node Exporter hasta Grafana.
- Diagnosticar un objetivo en estado `down`.
- Explicar por qué Grafana necesita acceder a Prometheus.

El recorrido completo que debe comprender el alumno es:

```text
Sistema operativo
        |
        v
Node Exporter expone métricas
        |
        v
Prometheus realiza scraping
        |
        v
Prometheus almacena muestras
        |
        v
PromQL consulta las series
        |
        v
Grafana representa los resultados
        |
        v
El usuario interpreta el estado del sistema
```