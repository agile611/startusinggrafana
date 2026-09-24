# Laboratorio - Fundamentos de telemetría

## Objetivos

Al finalizar este laboratorio podrás:

- Identificar los componentes básicos de una arquitectura de telemetría.
- Instalar y comprobar Node Exporter en Ubuntu.
- Configurar Prometheus para recopilar métricas mediante el modelo *pull*.
- Consultar series temporales utilizando PromQL.
- Analizar el efecto del intervalo de muestreo.
- Configurar una política básica de retención de datos.
- Crear consultas agregadas y reglas de grabación.
- Conectar Grafana con Prometheus.
- Crear un dashboard básico de monitorización.
- Verificar el estado de los objetivos y detectar problemas de recopilación.

## Introducción

En este laboratorio se pondrán en práctica los conceptos estudiados en el módulo de fundamentos de telemetría.

Se construirá una arquitectura sencilla formada por:

```text
Ubuntu
  │
  │ Métricas del sistema
  ▼
Node Exporter
  │
  │ Endpoint /metrics
  ▼
Prometheus
  │
  │ Consultas PromQL
  ▼
Grafana
  │
  ▼
Dashboard de monitorización
```

Durante el ejercicio se trabajará con los siguientes conceptos:

- Modelo *pull*.
- Exporters.
- Series temporales.
- Etiquetas.
- Muestreo.
- Retención.
- Agregación.
- *Downsampling*.
- Consultas PromQL.
- Visualización en Grafana.

El laboratorio está planteado para un entorno Ubuntu. Los nombres de host, las direcciones IP y las rutas pueden adaptarse a la infraestructura disponible.

## Contenido

### Arquitectura del laboratorio

Utilizaremos los siguientes componentes:

| Componente | Función | Puerto habitual |
|---|---|---:|
| Node Exporter | Expone métricas del sistema operativo | `9100` |
| Prometheus | Recopila y almacena métricas | `9090` |
| Grafana | Consulta y visualiza métricas | `3000` |

La arquitectura lógica será:

```text
Prometheus ───── scraping ─────> Node Exporter
     │
     │ PromQL
     ▼
 Grafana
```

En este laboratorio, Prometheus iniciará las conexiones contra Node Exporter. Por tanto, se utilizará el modelo **pull**.

### Requisitos previos

Antes de comenzar, comprueba que dispones de:

- Una máquina Ubuntu con acceso administrativo mediante `sudo`.
- Conexión a Internet para descargar los componentes.
- Al menos 2 GB de memoria RAM disponibles.
- Al menos 10 GB de espacio libre.
- Un navegador web.
- Acceso a los puertos `3000`, `9090` y `9100`, según la topología utilizada.

Comprueba la versión del sistema:

```bash
lsb_release -a
```

Comprueba la arquitectura del sistema:

```bash
uname -m
```

Comprueba el espacio disponible:

```bash
df -h
```

Comprueba la memoria disponible:

```bash
free -h
```

Actualiza la información de paquetes:

```bash
sudo apt update
```

Instala algunas herramientas útiles:

```bash
sudo apt install -y \
  curl \
  wget \
  tar \
  gzip \
  ca-certificates \
  prometheus
```

La instalación mediante paquetes puede proporcionar una versión diferente de la utilizada en otros entornos. Comprueba siempre las rutas y los nombres de los servicios instalados:

```bash
systemctl list-unit-files | grep -E "prometheus|grafana|node"
```

### Instalar Node Exporter

Node Exporter recopila métricas del sistema operativo y las expone mediante HTTP.

Crea un usuario específico:

```bash
sudo useradd \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

Descarga una versión de Node Exporter desde la página oficial de releases de Prometheus.

Ejemplo:

```bash
cd /tmp

VERSION="1.8.2"

wget \
  "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz"
```

Extrae el archivo:

```bash
tar xvf \
  "node_exporter-${VERSION}.linux-amd64.tar.gz"
```

Instala el binario:

```bash
sudo install \
  -m 0755 \
  "node_exporter-${VERSION}.linux-amd64/node_exporter" \
  /usr/local/bin/node_exporter
```

Comprueba que funciona:

```bash
/usr/local/bin/node_exporter --version
```

### Crear el servicio de Node Exporter

Crea una unidad systemd:

```bash
sudo nano /etc/systemd/system/node_exporter.service
```

Contenido:

```ini
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Recarga las unidades:

```bash
sudo systemctl daemon-reload
```

Activa el servicio para que se inicie automáticamente:

```bash
sudo systemctl enable node_exporter
```

Inicia Node Exporter:

```bash
sudo systemctl start node_exporter
```

Comprueba el estado:

```bash
sudo systemctl status node_exporter
```

Comprueba que escucha en el puerto `9100`:

```bash
sudo ss -lntp | grep 9100
```

Consulta el endpoint de métricas:

```bash
curl http://localhost:9100/metrics
```

Filtra algunas métricas conocidas:

```bash
curl -s http://localhost:9100/metrics \
  | grep -E "^node_cpu_seconds_total|^node_memory_MemAvailable_bytes|^node_filesystem_avail_bytes" \
  | head -20
```

La salida debe contener métricas similares a:

```text
node_cpu_seconds_total{cpu="0",mode="idle"} ...
node_memory_MemAvailable_bytes ...
node_filesystem_avail_bytes ...
```

### Comprobar la disponibilidad de Node Exporter

Comprueba que el endpoint responde con código HTTP `200`:

```bash
curl -o /dev/null \
  -s \
  -w "%{http_code}\n" \
  http://localhost:9100/metrics
```

El resultado esperado es:

```text
200
```

Si no responde, revisa:

```bash
sudo systemctl status node_exporter
```

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

También puedes comprobar si el firewall está activo:

```bash
sudo ufw status
```

Si Prometheus está instalado en otro servidor, Node Exporter debe ser accesible desde ese servidor. No es suficiente con que responda únicamente a través de `localhost`.

### Configurar Prometheus

Realiza una copia de seguridad del fichero de configuración:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

Edita la configuración:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Utiliza una configuración mínima como esta:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets:
          - "localhost:9090"

  - job_name: "node"
    static_configs:
      - targets:
          - "localhost:9100"
```

Esta configuración indica que:

- Prometheus recopilará métricas cada 15 segundos.
- Las reglas se evaluarán cada 15 segundos.
- Prometheus se monitorizará a sí mismo.
- Node Exporter se identificará con el trabajo `node`.

Comprueba la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

El resultado esperado debe indicar que la configuración es válida.

Reinicia Prometheus:

```bash
sudo systemctl restart prometheus
```

Comprueba el estado:

```bash
sudo systemctl status prometheus
```

Consulta los logs:

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

Comprueba que Prometheus escucha en el puerto `9090`:

```bash
sudo ss -lntp | grep 9090
```

### Consultar Prometheus

Abre en el navegador:

```text
http://localhost:9090
```

Si Prometheus está instalado en otro servidor:

```text
http://DIRECCION_IP:9090
```

Comprueba que el servicio está preparado:

```bash
curl http://localhost:9090/-/ready
```

La respuesta esperada es similar a:

```text
Prometheus is Ready.
```

Accede a:

```text
Status → Targets
```

Deberían aparecer al menos estos objetivos:

```text
prometheus
node
```

El estado esperado es:

```text
UP
```

Si un objetivo aparece como `DOWN`, selecciona el enlace correspondiente y revisa el error mostrado.

### Consultar la métrica `up`

En la interfaz de Prometheus ejecuta:

```promql
up
```

La respuesta debería incluir:

```text
up{instance="localhost:9090",job="prometheus"} 1
up{instance="localhost:9100",job="node"} 1
```

El valor:

```text
1
```

indica que el objetivo respondió correctamente durante el último scraping.

Consulta únicamente Node Exporter:

```promql
up{job="node"}
```

Consulta objetivos que no responden:

```promql
up == 0
```

Calcula el porcentaje global de disponibilidad:

```promql
100 * avg(up)
```

Calcula la disponibilidad agrupada por trabajo:

```promql
100 * avg by (job) (up)
```

### Explorar las series temporales

Consulta la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Convierte el valor a gigabytes:

```promql
node_memory_MemAvailable_bytes
/ 1024
/ 1024
/ 1024
```

Consulta la memoria total:

```promql
node_memory_MemTotal_bytes
```

Calcula el porcentaje de memoria utilizada:

```promql
100 *
(
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Consulta la carga del sistema:

```promql
node_load1
```

Consulta el número de series relacionadas con Node Exporter:

```promql
count({job="node"})
```

Consulta las series de CPU:

```promql
node_cpu_seconds_total
```

Consulta únicamente el tiempo de CPU en modo inactivo:

```promql
node_cpu_seconds_total{mode="idle"}
```

Observa cómo las etiquetas `instance`, `job`, `cpu` y `mode` identifican distintas series temporales.

### Calcular el uso de CPU

`node_cpu_seconds_total` es un contador. Para calcular su velocidad de cambio se utiliza `rate`.

Consulta el porcentaje de CPU utilizado:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

La consulta:

1. Selecciona las series de CPU en modo `idle`.
2. Calcula la tasa media durante cinco minutos.
3. Agrupa el resultado por instancia.
4. Calcula la proporción no inactiva.
5. Convierte el resultado a porcentaje.

Para calcular el uso por CPU:

```promql
100 *
(
  1 -
  rate(node_cpu_seconds_total{
    mode="idle"
  }[5m])
)
```

Para calcular el uso medio por instancia:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

### Analizar el muestreo

El intervalo configurado en Prometheus es:

```yaml
scrape_interval: 15s
```

Por tanto, cada objetivo debería recibir aproximadamente cuatro consultas por minuto.

Puedes observar el número de muestras recientes de Prometheus:

```promql
rate(prometheus_tsdb_head_samples_appended_total[5m])
```

Consulta la duración de las operaciones de scraping:

```promql
scrape_duration_seconds
```

Consulta el número de muestras devueltas por cada scraping:

```promql
scrape_samples_scraped
```

Consulta el número de muestras almacenadas:

```promql
scrape_samples_post_metric_relabeling
```

Estas métricas permiten analizar:

- Cuánto tarda cada scraping.
- Cuántas métricas devuelve cada objetivo.
- Si el volumen de datos cambia con el tiempo.
- Si un exporter está generando demasiadas series.

### Configurar una retención de laboratorio

Para un laboratorio pequeño se puede utilizar una retención de 15 días.

Comprueba cómo se inicia Prometheus:

```bash
systemctl cat prometheus
```

También puedes localizar el proceso:

```bash
ps aux | grep '[p]rometheus'
```

La unidad debe incluir un parámetro similar a:

```text
--storage.tsdb.retention.time=15d
```

Si deseas establecer además un límite de tamaño:

```text
--storage.tsdb.retention.size=5GB
```

La configuración conceptual sería:

```text
--storage.tsdb.path=/var/lib/prometheus
--storage.tsdb.retention.time=15d
--storage.tsdb.retention.size=5GB
```

Después de modificar la unidad:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprueba los argumentos activos:

```bash
ps aux | grep '[p]rometheus'
```

Comprueba el tamaño actual de la TSDB:

```bash
sudo du -sh /var/lib/prometheus
```

Comprueba el espacio disponible:

```bash
df -h /var/lib/prometheus
```

No elimines manualmente ficheros del directorio de datos mientras Prometheus esté en ejecución.

### Crear una regla de grabación

Las reglas de grabación permiten almacenar el resultado de consultas frecuentes.

Crea el directorio de reglas:

```bash
sudo mkdir -p /etc/prometheus/rules
```

Crea el fichero:

```bash
sudo nano /etc/prometheus/rules/laboratorio.yml
```

Contenido:

```yaml
groups:
  - name: laboratorio
    interval: 1m

    rules:
      - record: instance:node_cpu_usage:ratio5m
        expr: |
          1 -
          avg by (instance) (
            rate(node_cpu_seconds_total{
              mode="idle"
            }[5m])
          )

      - record: instance:node_memory_available:bytes
        expr: |
          node_memory_MemAvailable_bytes

      - record: job:up:count
        expr: |
          count by (job) (up)
```

Incluye el fichero en `/etc/prometheus/prometheus.yml`:

```yaml
rule_files:
  - /etc/prometheus/rules/*.yml
```

La configuración completa puede quedar así:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - /etc/prometheus/rules/*.yml

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets:
          - "localhost:9090"

  - job_name: "node"
    static_configs:
      - targets:
          - "localhost:9100"
```

Comprueba las reglas:

```bash
promtool check rules \
  /etc/prometheus/rules/laboratorio.yml
```

Comprueba la configuración completa:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Reinicia Prometheus:

```bash
sudo systemctl restart prometheus
```

Consulta las nuevas series:

```promql
instance:node_cpu_usage:ratio5m
```

```promql
instance:node_memory_available:bytes
```

```promql
job:up:count
```

### Analizar el downsampling

Consulta el promedio de carga de los últimos cinco minutos:

```promql
avg_over_time(node_load1[5m])
```

Consulta el máximo de carga de los últimos cinco minutos:

```promql
max_over_time(node_load1[5m])
```

Consulta el mínimo de memoria disponible durante los últimos diez minutos:

```promql
min_over_time(
  node_memory_MemAvailable_bytes[10m]
)
```

Consulta la memoria disponible media:

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[10m]
)
```

Compara el promedio y el mínimo:

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[10m]
)
```

```promql
min_over_time(
  node_memory_MemAvailable_bytes[10m]
)
```

El promedio muestra una tendencia general.

El mínimo permite detectar periodos de presión de memoria que podrían quedar ocultos en el promedio.

### Instalar Grafana

Instala Grafana siguiendo el método definido para el laboratorio.

Una vez instalado, inicia el servicio:

```bash
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

Comprueba el puerto:

```bash
sudo ss -lntp | grep 3000
```

Accede desde el navegador:

```text
http://localhost:3000
```

Si Grafana está instalado en otro servidor:

```text
http://DIRECCION_IP:3000
```

Completa el acceso inicial y cambia las credenciales predeterminadas.

### Añadir Prometheus como fuente de datos

En Grafana:

1. Abre **Connections** o **Data sources**.
2. Selecciona **Add new data source**.
3. Elige **Prometheus**.
4. Introduce la URL de Prometheus.
5. Selecciona acceso mediante servidor.
6. Pulsa **Save & test**.

Si ambos servicios están en el mismo servidor:

```text
http://localhost:9090
```

Si están en servidores diferentes:

```text
http://192.168.1.50:9090
```

Si se ejecutan en Docker Compose:

```text
http://prometheus:9090
```

La URL debe ser accesible desde Grafana, no necesariamente desde el navegador del usuario.

### Crear el dashboard del laboratorio

Crea un dashboard nuevo con los siguientes paneles:

| Panel | Consulta | Visualización |
|---|---|---|
| Estado de objetivos | `up` | Stat o Table |
| Uso de CPU | Consulta de CPU | Time series |
| Memoria disponible | `node_memory_MemAvailable_bytes` | Time series |
| Carga del sistema | `node_load1` | Time series |
| Series activas | `prometheus_tsdb_head_series` | Stat |
| Muestras por segundo | `rate(prometheus_tsdb_head_samples_appended_total[5m])` | Time series |

### Panel de estado de objetivos

Consulta:

```promql
up
```

Configuración:

```text
Título: Estado de los objetivos
Visualización: Table
```

Incluye las etiquetas:

```text
job
instance
```

El valor esperado para objetivos disponibles es:

```text
1
```

### Panel de uso de CPU

Consulta:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

Configuración:

```text
Título: Uso de CPU
Visualización: Time series
Unidad: Percent (0-100)
Leyenda: {{instance}}
```

### Panel de memoria disponible

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Configuración:

```text
Título: Memoria disponible
Visualización: Time series
Unidad: Bytes (IEC)
Leyenda: {{instance}}
```

### Panel de carga del sistema

Consulta:

```promql
node_load1
```

Configuración:

```text
Título: Carga del sistema
Visualización: Time series
Leyenda: {{instance}}
```

### Panel de series activas

Consulta:

```promql
prometheus_tsdb_head_series
```

Configuración:

```text
Título: Series activas
Visualización: Stat
```

### Panel de muestras por segundo

Consulta:

```promql
rate(
  prometheus_tsdb_head_samples_appended_total[5m]
)
```

Configuración:

```text
Título: Muestras almacenadas por segundo
Visualización: Time series
Unidad: samples/sec
```

### Crear una variable de instancia

En la configuración del dashboard, crea una variable llamada:

```text
instance
```

Utiliza la etiqueta `instance` de la métrica `up` como origen de valores.

Después, modifica la consulta de CPU:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  )
)
```

Modifica la consulta de memoria:

```promql
node_memory_MemAvailable_bytes{
  instance=~"$instance"
}
```

Configura la variable para permitir:

```text
Multi-value: activado
Include All option: activado
```

Comprueba que puedes seleccionar:

- Una instancia concreta.
- Varias instancias.
- Todas las instancias.

### Crear una alerta básica

Crea una regla de alerta para detectar un objetivo no disponible.

Expresión:

```promql
up == 0
```

Condición recomendada:

```text
La expresión debe mantenerse durante 2 minutos.
```

Etiquetas:

```text
severity: warning
```

Anotaciones:

```text
summary: Objetivo no disponible
description: El objetivo {{ $labels.instance }} no responde.
```

Para probar la alerta, detén temporalmente Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Comprueba desde Prometheus:

```promql
up{job="node"}
```

El resultado debería cambiar a:

```text
0
```

Después de que transcurra la duración configurada, la alerta debería activarse.

Vuelve a iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

Comprueba el estado:

```bash
sudo systemctl status node_exporter
```

Verifica que el objetivo vuelve a estar disponible:

```promql
up{job="node"}
```

El resultado esperado es:

```text
1
```

## Ejemplo

### Investigación de un aumento de CPU

Supongamos que el panel de Grafana muestra un aumento del uso de CPU.

Primero se consulta el valor actual:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

Después se consulta el máximo reciente:

```promql
max_over_time(
  (
    100 *
    (
      1 -
      avg by (instance) (
        rate(node_cpu_seconds_total{
          mode="idle"
        }[5m])
      )
    )
  )[15m:]
)
```

También se consulta la carga del sistema:

```promql
node_load1
```

Y la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

La investigación puede seguir este orden:

1. Comprobar si el objetivo está disponible.
2. Revisar el uso de CPU.
3. Revisar la carga del sistema.
4. Revisar la memoria disponible.
5. Comparar el momento del incidente con otros paneles.
6. Consultar logs del sistema.
7. Determinar si el problema fue puntual o persistente.

En Ubuntu se pueden consultar procesos con mayor consumo:

```bash
top
```

También se puede utilizar:

```bash
htop
```

si está instalado.

Consultar los últimos mensajes del sistema:

```bash
sudo journalctl --since "15 minutes ago"
```

### Investigación de un objetivo caído

Si un panel muestra que `up` vale `0`:

```promql
up{job="node"}
```

Comprueba desde el servidor de Prometheus:

```bash
curl http://localhost:9100/metrics
```

Si Node Exporter está en otro servidor:

```bash
curl http://DIRECCION_IP:9100/metrics
```

Comprueba el estado del servicio:

```bash
sudo systemctl status node_exporter
```

Consulta los logs:

```bash
sudo journalctl -u node_exporter -n 100 --no-pager
```

Comprueba la escucha del puerto:

```bash
sudo ss -lntp | grep 9100
```

Comprueba la conectividad desde Prometheus:

```bash
nc -vz DIRECCION_IP 9100
```

Si el servicio está activo, el endpoint responde y el puerto es accesible, revisa la configuración de Prometheus:

```yaml
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets:
          - "DIRECCION_IP:9100"
```

Después de corregir la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Entregables

Al finalizar el laboratorio, entrega o conserva los siguientes elementos:

- Fichero de configuración de Prometheus.
- Fichero de reglas de grabación.
- Captura o exportación del dashboard de Grafana.
- Resultado de la comprobación de `promtool`.
- Consulta PromQL utilizada para el uso de CPU.
- Consulta PromQL utilizada para la memoria.
- Evidencia de que Node Exporter aparece como `UP`.
- Evidencia de la alerta de objetivo no disponible.
- Respuestas a las preguntas de comprobación.
- Breve explicación de la arquitectura implementada.

Una estructura de entrega posible sería:

```text
laboratorio-fundamentos-telemetria/
├── prometheus.yml
├── rules/
│   └── laboratorio.yml
├── dashboards/
│   └── fundamentos-telemetria.json
├── evidencias/
│   ├── targets-up.png
│   ├── dashboard-cpu.png
│   ├── alerta-node-down.png
│   └── promtool-check.png
└── respuestas.md
```

### Criterios de evaluación

| Criterio | Resultado esperado |
|---|---|
| Node Exporter | Está instalado y responde en `/metrics` |
| Prometheus | Está activo y recopila métricas |
| Configuración | Es válida según `promtool` |
| Objetivos | Aparecen en estado `UP` |
| PromQL | Las consultas devuelven datos |
| Muestreo | Se comprende el efecto de `scrape_interval` |
| Retención | Existe una política configurada |
| Reglas | Se ha creado al menos una regla de grabación |
| Grafana | Está conectado a Prometheus |
| Dashboard | Contiene paneles de CPU, memoria y disponibilidad |
| Alertas | Se ha probado una alerta básica |
| Documentación | Se explican los pasos y resultados |

## Puntos clave

- Node Exporter expone métricas del sistema operativo.
- Prometheus recopila las métricas mediante el modelo *pull*.
- Grafana consulta Prometheus utilizando PromQL.
- El endpoint `/metrics` permite comprobar las métricas expuestas.
- La métrica `up` permite verificar la disponibilidad de un objetivo.
- Un valor `up = 1` indica que el último scraping fue correcto.
- Un valor `up = 0` indica que el objetivo no respondió correctamente.
- `scrape_interval` determina la frecuencia de recopilación.
- Las series temporales se identifican mediante nombres y etiquetas.
- `rate` permite calcular la velocidad de cambio de un contador.
- `avg_over_time`, `min_over_time` y `max_over_time` resumen ventanas temporales.
- La retención limita el tiempo o el tamaño de los datos almacenados.
- Las reglas de grabación permiten conservar resultados de consultas frecuentes.
- Las reglas de grabación generan nuevas series y utilizan almacenamiento.
- Grafana no almacena normalmente las métricas principales.
- Las fuentes de datos conectan Grafana con sistemas como Prometheus.
- Las variables permiten reutilizar un dashboard para varias instancias.
- Las alertas deben probarse provocando de forma controlada una condición de error.
- Los logs y las comprobaciones de red son esenciales para diagnosticar fallos.
- Una arquitectura de telemetría debe vigilar tanto los sistemas monitorizados como la propia plataforma de monitorización.

## Preguntas de comprobación

1. ¿Qué función cumple Node Exporter?
2. ¿Qué protocolo utiliza Prometheus para recopilar las métricas de Node Exporter?
3. ¿En qué puerto escucha normalmente Node Exporter?
4. ¿En qué puerto escucha normalmente Prometheus?
5. ¿En qué puerto escucha normalmente Grafana?
6. ¿Qué diferencia existe entre un exporter y Prometheus?
7. ¿Qué indica la métrica `up`?
8. ¿Qué significa que `up{job="node"}` devuelva el valor `0`?
9. ¿Qué parámetro define el intervalo de scraping?
10. ¿Qué efecto tendría cambiar `scrape_interval` de `15s` a `60s`?
11. ¿Por qué se utiliza `rate` con `node_cpu_seconds_total`?
12. ¿Qué diferencia existe entre `avg_over_time` y `max_over_time`?
13. ¿Qué función cumple una política de retención?
14. ¿Qué es una regla de grabación?
15. ¿Por qué una regla de grabación puede aumentar el almacenamiento utilizado?
16. ¿Qué problema puede aparecer si Prometheus no puede acceder al endpoint `/metrics`?
17. ¿Por qué `localhost` puede ser incorrecto en una instalación basada en contenedores?
18. ¿Qué consulta utilizarías para calcular el porcentaje de CPU utilizada?
19. ¿Qué consulta utilizarías para comprobar los objetivos caídos?
20. ¿Qué ventajas ofrece utilizar una variable de instancia en Grafana?
21. ¿Qué pasos seguirías para investigar un objetivo con estado `DOWN`?
22. ¿Cómo comprobarías que Prometheus está preparado para recibir consultas?
23. ¿Qué diferencia existe entre la fuente de datos de Grafana y un panel?
24. ¿Qué precauciones deben tomarse al detener un exporter para probar una alerta?
25. Describe el recorrido de una métrica desde Node Exporter hasta un panel de Grafana.