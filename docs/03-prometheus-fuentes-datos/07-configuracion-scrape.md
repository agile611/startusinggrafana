# Configuración de scraping

La configuración de *scraping* define cómo Prometheus descubre y consulta los objetivos que proporcionan métricas.

En este bloque se configurará Prometheus para consultar:

- El propio Prometheus.
- Node Exporter.
- Uno o varios servidores adicionales, como ejercicio opcional.

El flujo será:

```text
Node Exporter
      |
      | HTTP GET /metrics
      v
Prometheus
      |
      | Almacena las muestras
      v
Consultas PromQL
      |
      v
Grafana
```

Prometheus utiliza normalmente un modelo **pull**. Esto significa que Prometheus inicia periódicamente una petición HTTP hacia cada objetivo configurado.

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar qué significa realizar *scraping*.
- Diferenciar entre un `job` y un `target`.
- Identificar la estructura del fichero `prometheus.yml`.
- Configurar intervalos de recopilación.
- Añadir objetivos mediante `static_configs`.
- Añadir etiquetas personalizadas a los objetivos.
- Validar la configuración con `promtool`.
- Reiniciar o recargar Prometheus de forma segura.
- Comprobar los objetivos desde la interfaz web.
- Consultar los objetivos mediante la API HTTP.
- Interpretar los estados `up` y `down`.
- Consultar la métrica `up`.
- Diagnosticar errores de conexión y configuración.
- Configurar objetivos locales y remotos.
- Comprender el uso básico de `relabel_configs`.
- Documentar la configuración aplicada.

---

## Introducción

Prometheus no recopila métricas automáticamente de todos los servicios de una red. Es necesario indicarle qué objetivos debe consultar y con qué frecuencia.

Esta información se define normalmente en:

```text
/etc/prometheus/prometheus.yml
```

Una configuración sencilla puede ser:

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

En este ejemplo:

- Prometheus consulta sus propias métricas en `localhost:9090`.
- Prometheus consulta Node Exporter en `localhost:9100`.
- La consulta se realiza cada 15 segundos.
- Cada grupo de objetivos se identifica mediante un `job_name`.

---

# Conceptos fundamentales

## Scraping

El *scraping* es el proceso mediante el cual Prometheus solicita métricas a un objetivo.

```text
Prometheus ---- GET /metrics ----> Node Exporter
Prometheus <--- métricas ---------- Node Exporter
```

La respuesta contiene métricas en formato compatible con Prometheus:

```text
# HELP node_memory_MemAvailable_bytes Memory information field.
# TYPE node_memory_MemAvailable_bytes gauge
node_memory_MemAvailable_bytes 2.414534656e+09
```

## Job

Un `job` agrupa objetivos relacionados.

Ejemplo:

```yaml
job_name: node_exporter
```

Este trabajo puede contener uno o varios servidores Linux.

## Target

Un `target` es un endpoint concreto que Prometheus consulta.

Ejemplo:

```yaml
targets:
  - localhost:9100
```

La relación es:

```text
Job: node_exporter
├── localhost:9100
├── server-02:9100
└── server-03:9100
```

## Instance

Prometheus añade normalmente la etiqueta `instance` para identificar el objetivo consultado.

Ejemplo:

```text
instance="localhost:9100"
```

## Endpoint

El endpoint habitual de métricas es:

```text
/metrics
```

Por tanto, si el target es:

```text
localhost:9100
```

la URL completa suele ser:

```text
http://localhost:9100/metrics
```

---

# Fichero de configuración

El fichero principal se encuentra normalmente en:

```text
/etc/prometheus/prometheus.yml
```

Consultar su contenido:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

Mostrarlo con números de línea:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml
```

Crear una copia de seguridad:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%Y%m%d-%H%M%S).bak"
```

---

# Estructura global

Una configuración puede contener estas secciones:

```yaml
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s

rule_files:
  - /etc/prometheus/rules/*.yml

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - localhost:9093
```

En las primeras prácticas se utilizarán principalmente:

- `global`.
- `scrape_configs`.
- `job_name`.
- `static_configs`.
- `targets`.
- `labels`.
- `relabel_configs`.

---

# Configuración global

## `scrape_interval`

Define cada cuánto tiempo Prometheus consulta los objetivos.

```yaml
global:
  scrape_interval: 15s
```

Ejemplos de intervalos:

```yaml
scrape_interval: 5s
```

```yaml
scrape_interval: 30s
```

```yaml
scrape_interval: 1m
```

Un intervalo corto proporciona datos más frecuentes, pero puede aumentar:

- El número de peticiones.
- El uso de CPU.
- El uso de memoria.
- El número de muestras almacenadas.
- El consumo de red.

## `scrape_timeout`

Define cuánto tiempo espera Prometheus una respuesta:

```yaml
global:
  scrape_timeout: 10s
```

El tiempo de espera debe ser inferior al intervalo de recopilación.

Configuración incorrecta:

```yaml
global:
  scrape_interval: 10s
  scrape_timeout: 15s
```

## `evaluation_interval`

Define cada cuánto tiempo se evalúan las reglas:

```yaml
global:
  evaluation_interval: 15s
```

Estas reglas pueden ser:

- Reglas de grabación.
- Reglas de alerta.

---

# Configuración de trabajos

## Trabajo básico

```yaml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
```

## Trabajo para Node Exporter

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

## Varios trabajos

```yaml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100

  - job_name: grafana
    static_configs:
      - targets:
          - localhost:3000
```

> Grafana no expone necesariamente un endpoint de métricas en el puerto `3000`. Este ejemplo solo muestra la estructura de varios trabajos. Para monitorizar Grafana correctamente se debe configurar su endpoint de métricas correspondiente.

---

# Configuración recomendada para el laboratorio

La configuración mínima del laboratorio será:

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

Guardar la configuración:

```bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
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
EOF
```

---

# Objetivos estáticos

La sección `static_configs` permite definir objetivos manualmente.

## Un objetivo

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100
```

## Varios objetivos

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - server-01.example.local:9100
        - server-02.example.local:9100
        - server-03.example.local:9100
```

## Objetivos mediante direcciones IP

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - 192.168.1.51:9100
        - 192.168.1.52:9100
        - 192.168.1.53:9100
```

## Agrupar objetivos por etiquetas

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - server-01.example.local:9100
        - server-02.example.local:9100
      labels:
        environment: laboratorio
        operating_system: linux
```

La etiqueta se aplicará a los objetivos de ese grupo.

---

# Etiquetas personalizadas

Las etiquetas añaden información contextual a las métricas.

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          datacenter: madrid
          role: monitoring
```

La métrica `up` podría aparecer así:

```text
up{
  datacenter="madrid",
  environment="laboratorio",
  instance="localhost:9100",
  job="node_exporter",
  role="monitoring"
} 1
```

Consultar mediante PromQL:

```promql
up{environment="laboratorio"}
```

```promql
up{role="monitoring"}
```

```promql
node_memory_MemAvailable_bytes{
  datacenter="madrid"
}
```

## Recomendaciones para las etiquetas

Utilizar etiquetas para describir:

- Entorno.
- Ubicación.
- Rol.
- Sistema operativo.
- Equipo responsable.

Evitar incluir como etiquetas:

- Valores que cambien continuamente.
- Identificadores únicos innecesarios.
- Texto libre.
- Datos personales.
- Información secreta.
- Valores con una cardinalidad excesiva.

---

# Etiquetas externas

Las etiquetas externas identifican el servidor Prometheus o el entorno desde el que se generan las métricas.

```yaml
global:
  external_labels:
    environment: laboratorio
    region: madrid
    prometheus: prometheus-01
```

Estas etiquetas se utilizan especialmente en:

- Federación.
- Alertmanager.
- Entornos con varios servidores Prometheus.
- Identificación de origen.

Ejemplo completo:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

  external_labels:
    environment: laboratorio
    region: madrid

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
```

---

# Rutas y protocolos

## Ruta predeterminada

La ruta habitual es:

```text
/metrics
```

Por tanto:

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100
```

equivale normalmente a:

```text
http://localhost:9100/metrics
```

## Definir una ruta personalizada

Algunas aplicaciones exponen las métricas en otra ruta:

```yaml
- job_name: aplicacion
  metrics_path: /prometheus
  static_configs:
    - targets:
        - localhost:8080
```

La URL consultada será:

```text
http://localhost:8080/prometheus
```

## Utilizar HTTPS

```yaml
- job_name: aplicacion_https
  scheme: https
  static_configs:
    - targets:
        - app.example.local:8443
```

## Utilizar parámetros

```yaml
- job_name: blackbox
  metrics_path: /probe
  params:
    module:
      - http_2xx
  static_configs:
    - targets:
        - https://example.org
```

---

# Validar la configuración

La configuración debe validarse antes de reiniciar Prometheus.

## Validación básica

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax
```

## Validar una copia temporal

```bash
cp /etc/prometheus/prometheus.yml /tmp/prometheus.yml
```

```bash
promtool check config /tmp/prometheus.yml
```

## Mostrar los errores de sintaxis

Si existe un error, mostrar el fichero con números de línea:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml
```

Revisar especialmente:

- Indentación.
- Guiones de las listas.
- Dos puntos.
- Nombres de las propiedades.
- Comillas.
- Espacios.
- Anidamiento de `static_configs`.
- Anidamiento de `targets`.

---

# Aplicar los cambios

Existen dos métodos habituales:

- Reiniciar Prometheus.
- Recargar la configuración.

## Reiniciar el servicio

```bash
sudo systemctl restart prometheus
```

Comprobar:

```bash
systemctl is-active prometheus
```

Consultar los registros:

```bash
sudo journalctl -u prometheus \
  --since "1 minute ago" \
  --no-pager
```

## Recargar mediante la API

Si Prometheus se ha iniciado con la opción adecuada, puede recargarse la configuración mediante:

```bash
curl -X POST http://localhost:9090/-/reload
```

También puede utilizarse:

```bash
curl -X POST http://localhost:9090/-/reload \
  -i
```

El endpoint de recarga debe estar habilitado con:

```text
--web.enable-lifecycle
```

Consultar las opciones del servicio:

```bash
systemctl show prometheus -p ExecStart
```

Si la opción no está presente, utilizar `systemctl restart`.

## Recargar mediante `systemctl reload`

Dependiendo de la unidad de servicio, puede existir una acción de recarga:

```bash
sudo systemctl reload prometheus
```

Si no está definida, aparecerá un error. En ese caso:

```bash
sudo systemctl restart prometheus
```

---

# Comprobar la configuración cargada

Consultar la configuración que Prometheus está utilizando:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

Compararla con el fichero local:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

La configuración cargada puede no coincidir con el fichero local si:

- Se ha editado el fichero sin recargar Prometheus.
- La recarga ha fallado.
- Se ha modificado otro fichero.
- El servicio utiliza una ruta diferente.
- La unidad de `systemd` apunta a otra configuración.

Comprobar la ruta utilizada por el proceso:

```bash
systemctl show prometheus -p ExecStart
```

---

# Consultar los objetivos

## Desde la interfaz web

Abrir:

```text
http://localhost:9090
```

Acceder a la sección:

```text
Status → Targets
```

## Desde la API

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

Mostrar información resumida:

```bash
curl -s http://localhost:9090/api/v1/targets \
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

Ejemplo:

```text
prometheus      localhost:9090  up  http://localhost:9090/metrics  null
node_exporter   localhost:9100  up  http://localhost:9100/metrics  null
```

## Mostrar solo los objetivos activos

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

## Mostrar los objetivos caídos

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

---

# Estados de los objetivos

## `up`

El objetivo respondió correctamente al último *scraping*.

Ejemplo:

```text
node_exporter localhost:9100 up
```

## `down`

Prometheus no pudo recopilar correctamente las métricas.

Posibles causas:

- Servicio detenido.
- Puerto incorrecto.
- Nombre DNS incorrecto.
- Dirección IP incorrecta.
- Error de red.
- Cortafuegos.
- Endpoint incorrecto.
- Protocolo incorrecto.
- Error TLS.

## `unknown`

Prometheus todavía no dispone de información suficiente sobre el objetivo.

Esto puede ocurrir:

- Inmediatamente después de iniciar Prometheus.
- Antes del primer intervalo de *scraping*.
- Durante una recarga.
- En configuraciones de descubrimiento dinámico.

---

# Métrica `up`

La métrica `up` permite consultar el resultado del último *scraping*.

```promql
up
```

Consultar Node Exporter:

```promql
up{job="node_exporter"}
```

Consultar objetivos caídos:

```promql
up == 0
```

Contar objetivos disponibles:

```promql
sum(up)
```

Contar objetivos:

```promql
count(up)
```

Porcentaje de objetivos disponibles:

```promql
100 * avg(up)
```

Consultar por entorno:

```promql
up{environment="laboratorio"}
```

---

# Relabeling básico

`relabel_configs` permite modificar etiquetas antes de que las métricas se almacenen.

Se utiliza para:

- Renombrar etiquetas.
- Añadir etiquetas.
- Eliminar etiquetas.
- Filtrar objetivos.
- Transformar información de descubrimiento.

## Añadir una etiqueta fija

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100
      labels:
        environment: laboratorio

  relabel_configs:
    - target_label: team
      replacement: sistemas
```

## Cambiar el nombre del job

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100

  relabel_configs:
    - target_label: service
      replacement: linux-node
```

## Eliminar un target mediante `drop`

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - server-01:9100
        - server-02:9100
        - server-03:9100

  relabel_configs:
    - source_labels:
        - __address__
      regex: server-03:9100
      action: drop
```

En este ejemplo, `server-03:9100` no será consultado.

> El relabeling es potente, pero una regla incorrecta puede eliminar objetivos o modificar etiquetas inesperadamente. Debe validarse siempre mediante la sección **Targets**.

---

# `relabel_configs` y `metric_relabel_configs`

## `relabel_configs`

Se ejecuta sobre los objetivos antes de realizar el *scraping*.

Puede cambiar:

- La dirección.
- El esquema.
- La ruta.
- Las etiquetas del objetivo.
- La inclusión o exclusión del target.

## `metric_relabel_configs`

Se ejecuta sobre las métricas después del *scraping* y antes de almacenarlas.

Ejemplo:

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100

  metric_relabel_configs:
    - source_labels:
        - __name__
      regex: "node_network_.*"
      action: drop
```

Esta configuración descartaría las métricas cuyo nombre empiece por `node_network_`.

No se debe utilizar para resolver problemas de forma indiscriminada, porque una regla puede eliminar datos necesarios para dashboards o alertas.

---

# Configuración de un objetivo remoto

Si Node Exporter se encuentra en otro servidor:

```yaml
- job_name: node_exporter_remote
  static_configs:
    - targets:
        - 192.168.1.60:9100
```

Antes de reiniciar Prometheus, comprobar desde el servidor Prometheus:

```bash
curl http://192.168.1.60:9100/metrics
```

Si la prueba funciona:

```bash
promtool check config /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus
```

Comprobar el target:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter_remote")
    | [
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

## Importante sobre `localhost`

Si Prometheus está en el servidor `monitoring-01` y Node Exporter está en `server-02`, esta configuración es incorrecta:

```yaml
targets:
  - localhost:9100
```

`localhost` hace referencia al equipo donde se ejecuta Prometheus, no al servidor remoto.

La configuración correcta sería:

```yaml
targets:
  - server-02:9100
```

o:

```yaml
targets:
  - 192.168.1.60:9100
```

---

# Configuración con nombres DNS

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - node-01.example.local:9100
        - node-02.example.local:9100
```

Comprobar la resolución desde el servidor Prometheus:

```bash
getent hosts node-01.example.local
```

```bash
getent hosts node-02.example.local
```

Comprobar el endpoint:

```bash
curl http://node-01.example.local:9100/metrics
```

---

# Sesiones prácticas

## Sesión 1: revisar la configuración actual

### Objetivo

Identificar la configuración que utiliza Prometheus.

### Comandos

```bash
sudo cat /etc/prometheus/prometheus.yml
```

```bash
sudo nl -ba /etc/prometheus/prometheus.yml
```

```bash
systemctl show prometheus -p ExecStart
```

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

### Actividades

1. Identifica el `scrape_interval`.
2. Identifica el `evaluation_interval`.
3. Anota los jobs configurados.
4. Anota los targets.
5. Compara la configuración del disco con la configuración cargada.
6. Explica qué puede ocurrir si ambas son diferentes.

---

## Sesión 2: configurar Prometheus y Node Exporter

### Objetivo

Configurar el scraping de Node Exporter.

### Configuración

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

### Validar

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### Aplicar

```bash
sudo systemctl restart prometheus
```

### Comprobar

```bash
systemctl is-active prometheus
```

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [.labels.job, .labels.instance, .health]
    | @tsv
  '
```

### Resultado esperado

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

---

## Sesión 3: practicar con intervalos

### Objetivo

Observar el efecto del intervalo de *scraping*.

### Configurar un intervalo corto

```yaml
global:
  scrape_interval: 5s
```

Validar:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reiniciar:

```bash
sudo systemctl restart prometheus
```

Consultar el último scraping:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .lastScrape,
        .lastScrapeDuration,
        .health
      ]
    | @tsv
  '
```

Después restaurar el valor habitual:

```yaml
global:
  scrape_interval: 15s
```

### Actividades

1. Observa cuánto tarda en aparecer un nuevo valor.
2. Compara los tiempos con un intervalo de 15 segundos.
3. Explica la relación entre frecuencia y número de muestras.
4. Explica por qué no conviene utilizar siempre intervalos muy pequeños.

---

## Sesión 4: añadir etiquetas

### Objetivo

Añadir contexto a los objetivos monitorizados.

### Configuración

```yaml
- job_name: node_exporter
  static_configs:
    - targets:
        - localhost:9100
      labels:
        environment: laboratorio
        role: monitoring
        location: madrid
```

Validar y aplicar:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

Consultar:

```promql
up{environment="laboratorio"}
```

```promql
up{role="monitoring"}
```

### Actividades

1. Añade tres etiquetas.
2. Comprueba que aparecen en la métrica `up`.
3. Filtra por una etiqueta.
4. Filtra por dos etiquetas.
5. Explica qué utilidad tendrían estas etiquetas en un entorno con muchos servidores.

---

## Sesión 5: provocar y diagnosticar un `DOWN`

### Objetivo

Observar el comportamiento de Prometheus cuando un objetivo deja de responder.

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

Esperar más de un intervalo de *scraping*.

### Consultar el objetivo

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

### Consultar PromQL

```promql
up{job="node_exporter"}
```

### Iniciar Node Exporter

```bash
sudo systemctl start node_exporter
```

Comprobar:

```bash
systemctl is-active node_exporter
```

Esperar al siguiente scraping y volver a consultar:

```promql
up{job="node_exporter"}
```

### Actividades

1. Anota el estado inicial.
2. Anota el estado durante la interrupción.
3. Copia el mensaje de error.
4. Anota el tiempo necesario para recuperar el estado `UP`.
5. Explica la relación entre el intervalo de scraping y la detección del fallo.

---

## Sesión 6: configurar un target remoto

### Objetivo

Configurar un Node Exporter situado en otro equipo.

### Comprobar desde Prometheus

```bash
curl http://<IP-DEL-SERVIDOR-REMOTO>:9100/metrics
```

Ejemplo:

```bash
curl http://192.168.1.60:9100/metrics
```

### Añadir el target

```yaml
- job_name: node_exporter_remoto
  static_configs:
    - targets:
        - 192.168.1.60:9100
      labels:
        environment: laboratorio
        role: remote-node
```

### Validar y aplicar

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Comprobar

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter_remoto")
    | [
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

### Actividades

1. Comprueba la conectividad entre los servidores.
2. Añade el objetivo remoto.
3. Valida la configuración.
4. Comprueba el estado.
5. Explica por qué `localhost:9100` no serviría para ese objetivo remoto.

---

## Sesión 7: filtrar objetivos con relabeling

### Objetivo

Comprender cómo se puede excluir un objetivo antes del scraping.

### Configuración

```yaml
- job_name: linux_servers
  static_configs:
    - targets:
        - server-01:9100
        - server-02:9100
        - server-03:9100

  relabel_configs:
    - source_labels:
        - __address__
      regex: server-03:9100
      action: drop
```

### Actividades

1. Identifica el objetivo excluido.
2. Valida la configuración.
3. Reinicia Prometheus.
4. Comprueba la sección **Targets**.
5. Explica la diferencia entre que un target esté `DOWN` y que haya sido eliminado por `drop`.

---

## Sesión 8: comparar configuración y estado

### Objetivo

Comprobar que la configuración declarada coincide con el estado observado.

### Comandos

```bash
sudo cat /etc/prometheus/prometheus.yml
```

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [.labels.job, .labels.instance, .health]
    | @tsv
  '
```

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq -r '
    .data.result[]
    | [.metric.job, .metric.instance, .value[1]]
    | @tsv
  '
```

### Actividades

1. Compara los jobs del fichero con los de la API.
2. Compara los targets configurados con los objetivos activos.
3. Compara `health` con la métrica `up`.
4. Explica posibles diferencias.

---

# Diagnóstico de problemas

## Error de sintaxis YAML

### Síntoma

Prometheus no inicia después de editar la configuración.

### Comprobar

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl status prometheus
```

```bash
sudo journalctl -u prometheus \
  --no-pager \
  -n 50
```

### Revisar

- Indentación.
- Guiones.
- Dos puntos.
- Nombres de propiedades.
- Dirección de los bloques.
- Espacios.

Configuración incorrecta:

```yaml
scrape_configs:
- job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

Configuración correcta:

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

## Target `DOWN`

### Comprobar el endpoint directamente

```bash
curl http://localhost:9100/metrics
```

### Comprobar el servicio

```bash
systemctl is-active node_exporter
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar la configuración

```bash
sudo grep -A8 -B2 'node_exporter' \
  /etc/prometheus/prometheus.yml
```

### Consultar el error desde la API

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | .lastError
  '
```

## Target inexistente

Si el objetivo no aparece en **Targets**, revisar:

- El nombre del job.
- La indentación.
- La ubicación dentro de `scrape_configs`.
- La configuración cargada.
- Si Prometheus se ha reiniciado o recargado.
- La ruta que utiliza `ExecStart`.

## `localhost` apunta al equipo equivocado

Si Grafana y Prometheus están en equipos diferentes:

```text
Grafana → localhost:9090
```

significa que Grafana intenta conectar con el propio servidor donde se ejecuta Grafana.

Si Node Exporter está en otro servidor:

```yaml
targets:
  - localhost:9100
```

significa que Prometheus intenta conectar con el propio servidor donde se ejecuta Prometheus.

Utilizar la IP o el nombre DNS del servidor remoto:

```yaml
targets:
  - 192.168.1.60:9100
```

## La configuración no se ha aplicado

Comprobar la configuración cargada:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml'
```

Comprobar el proceso:

```bash
systemctl show prometheus -p ExecStart
```

Aplicar mediante reinicio:

```bash
sudo systemctl restart prometheus
```

Consultar los registros:

```bash
sudo journalctl -u prometheus \
  --since "1 minute ago" \
  --no-pager
```

---

# Buenas prácticas

- Realizar una copia antes de editar.
- Validar siempre con `promtool`.
- Aplicar cambios de forma controlada.
- Comprobar la configuración cargada.
- Revisar la sección **Targets**.
- Consultar la métrica `up`.
- Utilizar nombres claros para los jobs.
- Mantener intervalos razonables.
- Utilizar etiquetas coherentes.
- Evitar etiquetas de alta cardinalidad.
- No almacenar secretos en etiquetas.
- Separar objetivos por función.
- Documentar los targets remotos.
- Proteger el acceso a los endpoints de métricas.
- Revisar los registros después de cada cambio.
- Probar primero en el laboratorio.

---

# Informe de configuración

Crear un directorio para las evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/scraping
```

Guardar la configuración local:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  ~/laboratorio-grafana/evidencias/scraping/prometheus.yml
```

Guardar la configuración cargada:

```bash
curl -s http://localhost:9090/api/v1/status/config \
  | jq -r '.data.yaml' \
  > ~/laboratorio-grafana/evidencias/scraping/configuracion-cargada.yml
```

Guardar los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq \
  > ~/laboratorio-grafana/evidencias/scraping/targets.json
```

Guardar un resumen de objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
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
  ' \
  > ~/laboratorio-grafana/evidencias/scraping/targets-resumen.tsv
```

Guardar la consulta `up`:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq \
  > ~/laboratorio-grafana/evidencias/scraping/query-up.json
```

Guardar la validación:

```bash
promtool check config /etc/prometheus/prometheus.yml \
  > ~/laboratorio-grafana/evidencias/scraping/validacion.txt \
  2>&1
```

Guardar los registros recientes:

```bash
sudo journalctl -u prometheus \
  --since "15 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/scraping/prometheus-logs.txt
```

---

# Ejemplo de sesión completa

```console
$ sudo cp /etc/prometheus/prometheus.yml \
    /etc/prometheus/prometheus.yml.bak

$ sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
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

$ promtool check config /etc/prometheus/prometheus.yml
Checking /etc/prometheus/prometheus.yml
 SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax

$ sudo systemctl restart prometheus

$ systemctl is-active prometheus
active

$ curl -s http://localhost:9090/api/v1/targets \
    | jq -r '
      .data.activeTargets[]
      | [.labels.job, .labels.instance, .health, .lastError]
      | @tsv
    '
prometheus      localhost:9090  up
node_exporter   localhost:9100  up

$ curl -sG http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up{job="node_exporter"}' \
    | jq -r '.data.result[] | .value[1]'
1
```

---

# Actividad integradora

## Objetivo

Configurar y verificar el *scraping* de Prometheus sobre Node Exporter.

## Tareas

1. Comprobar que Node Exporter responde en el puerto `9100`.
2. Crear una copia de seguridad de `prometheus.yml`.
3. Configurar el job `prometheus`.
4. Configurar el job `node_exporter`.
5. Definir un intervalo de 15 segundos.
6. Añadir etiquetas de entorno y función.
7. Validar la configuración.
8. Reiniciar Prometheus.
9. Comprobar el estado del servicio.
10. Consultar los objetivos desde la API.
11. Comprobar la métrica `up`.
12. Acceder a la sección **Targets**.
13. Consultar la configuración cargada.
14. Detener temporalmente Node Exporter.
15. Observar el estado `DOWN`.
16. Iniciar Node Exporter.
17. Comprobar la recuperación a `UP`.
18. Guardar las evidencias.

## Resultado esperado

```text
Configuración válida: sí
Servicio Prometheus: activo
Job prometheus: up
Job node_exporter: up
Métrica up{job="node_exporter"}: 1
Configuración cargada: correcta
Objetivo DOWN detectado durante la prueba: sí
Objetivo recuperado: sí
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Fichero validado | | |
| Prometheus activo | | |
| Job `prometheus` | | |
| Job `node_exporter` | | |
| Target `localhost:9090` | | |
| Target `localhost:9100` | | |
| Métrica `up` | | |
| Etiquetas personalizadas | | |
| Prueba `DOWN` | | |
| Recuperación a `UP` | | |
| Configuración cargada | | |
| Evidencias guardadas | | |

---

# Puntos clave

- El *scraping* es la recopilación periódica de métricas por parte de Prometheus.
- La configuración principal se encuentra normalmente en `prometheus.yml`.
- Un `job` agrupa objetivos relacionados.
- Un `target` es un endpoint concreto.
- `static_configs` permite declarar objetivos manualmente.
- `scrape_interval` define la frecuencia de recopilación.
- `scrape_timeout` define el tiempo máximo de espera.
- La ruta habitual de métricas es `/metrics`.
- La métrica `up` indica el resultado del último *scraping*.
- Una configuración debe validarse antes de reiniciar Prometheus.
- `promtool check config` detecta errores de configuración.
- La sección **Targets** permite revisar el estado de los objetivos.
- La API `/api/v1/targets` permite consultar los objetivos desde la terminal.
- `localhost` siempre hace referencia al equipo que realiza la conexión.
- Las etiquetas proporcionan contexto a las métricas.
- Las etiquetas con demasiados valores diferentes pueden aumentar la cardinalidad.
- `relabel_configs` puede modificar o descartar objetivos.
- `metric_relabel_configs` puede modificar o descartar métricas antes de almacenarlas.
- Los cambios deben comprobarse en la configuración cargada.
- Los registros ayudan a localizar errores de conexión y sintaxis.

---

# Preguntas de comprobación

1. ¿Qué significa realizar *scraping*?
2. ¿Qué componente inicia normalmente la conexión?
3. ¿Qué es un `job`?
4. ¿Qué es un `target`?
5. ¿Qué función cumple `scrape_interval`?
6. ¿Qué función cumple `scrape_timeout`?
7. ¿Qué ruta utiliza normalmente Node Exporter?
8. ¿Qué diferencia existe entre `static_configs` y `targets`?
9. ¿Qué indica la métrica `up`?
10. ¿Qué significa que un target esté `DOWN`?
11. ¿Qué comando permite validar la configuración?
12. ¿Qué comando permite consultar los objetivos?
13. ¿Qué diferencia existe entre reiniciar y recargar Prometheus?
14. ¿Qué significa `localhost` en una configuración de scraping?
15. ¿Cómo configurarías un Node Exporter remoto?
16. ¿Para qué sirven las etiquetas personalizadas?
17. ¿Qué riesgo tienen las etiquetas de alta cardinalidad?
18. ¿Qué función cumple `relabel_configs`?
19. ¿Qué diferencia existe entre `relabel_configs` y `metric_relabel_configs`?
20. ¿Qué comprobarías si un target no aparece en la sección **Targets**?
21. ¿Qué comprobarías si un target aparece como `DOWN`?
22. ¿Cómo consultarías la configuración cargada por Prometheus?
23. ¿Por qué debe hacerse una copia de seguridad antes de editar?
24. ¿Qué relación existe entre `scrape_interval` y la detección de fallos?
25. ¿Qué pasos seguirías para comprobar la recuperación de un target?

---

# Criterios de finalización

La práctica se considera completada cuando:

- Se ha identificado el fichero de configuración.
- Se ha realizado una copia de seguridad.
- Se ha configurado el job de Prometheus.
- Se ha configurado el job de Node Exporter.
- Se ha definido un intervalo de *scraping*.
- La configuración es válida.
- Prometheus está activo.
- Los objetivos aparecen en la sección **Targets**.
- Los objetivos correctos aparecen como `UP`.
- La métrica `up` devuelve el resultado esperado.
- Se han añadido y consultado etiquetas personalizadas.
- Se ha probado un objetivo en estado `DOWN`.
- Se ha comprobado su recuperación.
- Se ha consultado la configuración cargada.
- Se han revisado los registros.
- Se han guardado las evidencias.

La comprobación final puede ejecutarse con:

```bash
printf '%-40s ' "Configuración válida"
promtool check config /etc/prometheus/prometheus.yml \
  >/dev/null 2>&1 \
  && echo "sí" \
  || echo "no"

printf '%-40s %s\n' \
  "Prometheus activo" \
  "$(systemctl is-active prometheus)"

printf '%-40s ' "Node Exporter accesible"
curl -fsS http://localhost:9100/metrics \
  >/dev/null \
  && echo "sí" \
  || echo "no"

printf '%-40s ' "Target node_exporter"
curl -fsS http://localhost:9090/api/v1/query \
  --get \
  --data-urlencode 'query=up{job="node_exporter"}' \
  | jq -e '.data.result[0].value[1] == "1"' \
  >/dev/null \
  && echo "up" \
  || echo "no disponible"

printf '%-40s ' "Configuración cargada"
curl -fsS http://localhost:9090/api/v1/status/config \
  | jq -e '.data.yaml != null' \
  >/dev/null \
  && echo "sí" \
  || echo "no"
```

Resultado esperado:

```text
Configuración válida                     sí
Prometheus activo                        active
Node Exporter accesible                  sí
Target node_exporter                     up
Configuración cargada                    sí
```

El flujo completo que debe comprender el alumno es:

```text
Editar prometheus.yml
        |
        v
Validar con promtool
        |
        v
Reiniciar o recargar Prometheus
        |
        v
Comprobar la configuración cargada
        |
        v
Consultar Targets
        |
        v
Comprobar la métrica up
        |
        v
Consultar métricas mediante PromQL
```