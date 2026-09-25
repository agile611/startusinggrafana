# Problemas con alertas

Esta página explica cómo diagnosticar y resolver los problemas más habituales relacionados con las alertas de Prometheus, Alertmanager y Grafana.

Una alerta no depende de un único componente. El flujo completo puede ser:

```text
Métrica del sistema
        |
        v
Node Exporter
        |
        v
Prometheus
        |
        v
Regla de alerta
        |
        v
Alertmanager
        |
        v
Receptor de notificaciones
        |
        v
Correo, webhook, chat o sistema externo
```

Grafana también puede evaluar reglas de alerta mediante su propio sistema de alertas:

```text
Fuente de datos
        |
        v
Regla de alerta de Grafana
        |
        v
Condición
        |
        v
Estado de alerta
        |
        v
Política de notificación
        |
        v
Contacto
```

Por este motivo, una alerta puede fallar en diferentes puntos:

- La métrica no existe.
- El target está `DOWN`.
- La consulta devuelve resultados incorrectos.
- La expresión no tiene datos.
- La regla no se carga.
- La regla no se evalúa.
- El umbral es incorrecto.
- La alerta permanece en `pending`.
- Alertmanager no recibe la alerta.
- La ruta de Alertmanager no coincide.
- El receptor está mal configurado.
- La notificación es rechazada.
- Grafana no puede consultar la fuente de datos.
- El usuario no tiene permisos para ver o modificar alertas.

> **Advertencia:** realiza las prácticas en un entorno de laboratorio. Utiliza destinatarios de prueba y no incluyas contraseñas, tokens, claves API ni direcciones privadas en repositorios o informes públicos.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Explicar el flujo de una alerta.
- Diferenciar una métrica de una regla de alerta.
- Diferenciar una alerta de Prometheus de una alerta de Grafana.
- Crear una regla de alerta sencilla.
- Validar reglas con `promtool`.
- Comprobar el estado de las reglas.
- Comprobar el estado de las alertas.
- Interpretar los estados `inactive`, `pending` y `firing`.
- Diagnosticar alertas que no se activan.
- Diagnosticar alertas que se activan constantemente.
- Comprobar la comunicación entre Prometheus y Alertmanager.
- Revisar rutas y receptores de Alertmanager.
- Diagnosticar problemas de notificaciones.
- Utilizar etiquetas y anotaciones correctamente.
- Probar expresiones PromQL antes de crear alertas.
- Documentar una incidencia relacionada con alertas.

## Introducción

Una alerta representa una condición que requiere atención.

Ejemplos:

- Un servidor no responde.
- El uso de CPU supera un umbral.
- El espacio libre es demasiado bajo.
- Prometheus no puede recopilar métricas.
- Una instancia tiene poca memoria disponible.
- Un servicio permanece detenido durante varios minutos.

Una alerta normalmente contiene:

- Nombre.
- Expresión.
- Duración mínima.
- Etiquetas.
- Anotaciones.
- Estado.
- Información de la serie que la activó.

Ejemplo conceptual:

```yaml
alert: NodeExporterDown
expr: up{job="node_exporter"} == 0
for: 5m
labels:
  severity: critical
annotations:
  summary: Node Exporter no está disponible
```

La expresión determina cuándo se cumple la condición. Las etiquetas clasifican la alerta. Las anotaciones proporcionan información para la persona que recibe la notificación.

## Componentes del sistema de alertas

### Métrica

La métrica proporciona los datos utilizados por la expresión.

Ejemplo:

```promql
up{job="node_exporter"}
```

### Expresión PromQL

La expresión determina si la condición se cumple.

Ejemplo:

```promql
up{job="node_exporter"} == 0
```

### Regla de alerta

La regla combina una expresión con metadatos:

```yaml
- alert: NodeExporterDown
  expr: up{job="node_exporter"} == 0
  for: 5m
  labels:
    severity: critical
```

### Prometheus

Prometheus:

- Evalúa las reglas.
- Consulta las métricas.
- Cambia el estado de las alertas.
- Envía las alertas a Alertmanager.

### Alertmanager

Alertmanager:

- Recibe alertas de Prometheus.
- Agrupa alertas.
- Silencia alertas.
- Inhibe alertas relacionadas.
- Selecciona receptores.
- Envía notificaciones.

### Grafana Alerting

Grafana puede gestionar sus propias reglas de alerta.

Grafana puede:

- Consultar fuentes de datos.
- Evaluar expresiones.
- Crear reglas.
- Gestionar contactos.
- Aplicar políticas de notificación.
- Mostrar el estado de las alertas.

### Receptor

Un receptor es el destino de una notificación.

Ejemplos:

- Correo electrónico.
- Webhook.
- Microsoft Teams.
- Slack.
- PagerDuty.
- OnCall.
- Sistema de tickets.

## Estados de una alerta

### `inactive`

La condición de la alerta no se cumple.

Ejemplo:

```text
up{job="node_exporter"} == 1
```

En este caso, la alerta de caída permanece inactiva.

### `pending`

La condición se cumple, pero todavía no ha transcurrido el período definido en `for`.

Ejemplo:

```yaml
for: 5m
```

Si la expresión se cumple durante dos minutos, la alerta estará en `pending`.

### `firing`

La condición se ha cumplido durante el período requerido y la alerta está activa.

Ejemplo:

```text
La expresión se cumple durante más de cinco minutos.
```

### Transición de estados

```text
inactive
    |
    | La expresión se cumple
    v
pending
    |
    | Transcurre el valor de "for"
    v
firing
    |
    | La expresión deja de cumplirse
    v
inactive
```

Si la expresión deja de cumplirse durante el período `pending`, la alerta vuelve a `inactive`.

## Alertas de Prometheus y alertas de Grafana

### Alertas de Prometheus

Las reglas se almacenan normalmente en ficheros YAML:

```text
/etc/prometheus/rules/
```

Prometheus evalúa las expresiones.

Ejemplo:

```yaml
groups:
  - name: sistema
    rules:
      - alert: NodeExporterDown
        expr: up{job="node_exporter"} == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: Node Exporter no responde
```

### Alertas de Grafana

Las reglas se gestionan desde la interfaz de Grafana o mediante su API y provisioning.

Grafana puede utilizar:

- Prometheus.
- Loki.
- InfluxDB.
- SQL.
- Otras fuentes compatibles.

### Diferencias principales

| Característica | Prometheus | Grafana |
|---|---|---|
| Lugar habitual de configuración | Ficheros YAML | Interfaz, API o provisioning |
| Motor de evaluación | Prometheus | Grafana |
| Gestión de notificaciones | Habitualmente Alertmanager | Contactos y políticas de Grafana |
| Fuente principal del laboratorio | Prometheus | Varias fuentes posibles |
| Validación habitual | `promtool` | Interfaz o API de Grafana |
| Visualización | Interfaz de Prometheus | Alerting de Grafana |

Ambos sistemas pueden utilizar PromQL, pero el proceso de evaluación y notificación no es idéntico.

## Crear una regla de alerta en Prometheus

### Estructura básica

```yaml
groups:
  - name: sistema
    rules:
      - alert: NodeExporterDown
        expr: up{job="node_exporter"} == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: Node Exporter no responde
          description: El target {{ $labels.instance }} no está disponible.
```

### Elementos de la regla

#### `groups`

Agrupa reglas relacionadas:

```yaml
groups:
  - name: sistema
```

#### `name`

Identifica el grupo:

```yaml
name: sistema
```

#### `alert`

Es el nombre de la alerta:

```yaml
alert: NodeExporterDown
```

Utiliza nombres:

- Descriptivos.
- Estables.
- Sin espacios.
- Fáciles de buscar.

#### `expr`

Es la expresión PromQL:

```yaml
expr: up{job="node_exporter"} == 0
```

#### `for`

Indica cuánto tiempo debe cumplirse la expresión:

```yaml
for: 5m
```

#### `labels`

Clasifica la alerta:

```yaml
labels:
  severity: critical
  team: sistemas
```

#### `annotations`

Proporciona información adicional:

```yaml
annotations:
  summary: Node Exporter no responde
  description: El target {{ $labels.instance }} no está disponible.
```

## Crear un fichero de reglas

### Crear el directorio

```bash
sudo mkdir -p /etc/prometheus/rules
```

### Crear el fichero

```bash
sudo nano /etc/prometheus/rules/sistema.yml
```

Contenido:

```yaml
groups:
  - name: sistema
    rules:
      - alert: NodeExporterDown
        expr: up{job="node_exporter"} == 0
        for: 5m
        labels:
          severity: critical
          servicio: node_exporter
        annotations:
          summary: Node Exporter no responde
          description: El target {{ $labels.instance }} no está disponible.
```

### Comprobar los permisos

```bash
sudo stat /etc/prometheus/rules/sistema.yml
```

### Comprobar que Prometheus puede leerlo

```bash
sudo -u prometheus test -r \
  /etc/prometheus/rules/sistema.yml \
  && echo "El fichero es legible" \
  || echo "El fichero no es legible"
```

## Configurar `rule_files`

En `prometheus.yml`, añade la ruta de las reglas:

```yaml
rule_files:
  - /etc/prometheus/rules/*.yml
```

Ejemplo completo:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - /etc/prometheus/rules/*.yml

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

### Validar la configuración principal

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Validar las reglas

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Consultar el estado

```bash
systemctl is-active prometheus
```

## Comprobar las reglas cargadas

### Interfaz web

Abre:

```text
http://localhost:9090/rules
```

La página muestra:

- Nombre del grupo.
- Nombre de la regla.
- Expresión.
- Estado.
- Duración.
- Última evaluación.
- Alertas activas.

### API de reglas

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq
```

### Mostrar las reglas de alerta

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq '.data.groups[].rules[] | select(.type=="alerting")'
```

### Consultar el estado de una regla

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq '.data.groups[].rules[] | {
      name: .name,
      state: .state,
      health: .health,
      lastEvaluation: .lastEvaluation,
      evaluationTime: .evaluationTime
    }'
```

## Comprobar las alertas activas

### Interfaz web

Abre:

```text
http://localhost:9090/alerts
```

### API de alertas

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Mostrar información resumida

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq '.data.alerts[] | {
      labels: .labels,
      annotations: .annotations,
      state: .state,
      value: .value,
      activeAt: .activeAt
    }'
```

### Consulta PromQL de alertas activas

Prometheus expone información de alertas mediante la métrica:

```promql
ALERTS
```

Consultar alertas activas:

```promql
ALERTS{
  alertstate="firing"
}
```

Consultar alertas pendientes:

```promql
ALERTS{
  alertstate="pending"
}
```

Consultar una alerta concreta:

```promql
ALERTS{
  alertname="NodeExporterDown"
}
```

## Problemas al cargar reglas

### La regla no aparece

Comprueba:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

Consulta la configuración efectiva:

```bash
systemctl show prometheus \
  -p ExecStart
```

Comprueba que `rule_files` esté incluido en el fichero correcto.

### La regla aparece como `bad`

Consulta:

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq
```

Consulta los registros:

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

Posibles causas:

- Expresión PromQL incorrecta.
- Fichero no legible.
- Error de YAML.
- Ruta incorrecta.
- Métrica inexistente.
- Función no compatible con la versión instalada.

### La regla aparece, pero no se evalúa

Comprueba:

- `evaluation_interval`.
- Estado de Prometheus.
- Registros.
- Salud del grupo.
- Carga del servidor.
- Errores de la expresión.

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq '.data.groups[] | {
      name: .name,
      evaluationTime: .evaluationTime,
      lastEvaluation: .lastEvaluation,
      health: .health
    }'
```

### Error de permisos

Comprueba:

```bash
sudo -u prometheus test -r \
  /etc/prometheus/rules/sistema.yml \
  && echo "Puede leer las reglas" \
  || echo "No puede leer las reglas"
```

Comprueba todos los directorios de la ruta:

```bash
namei -l /etc/prometheus/rules/sistema.yml
```

## Problemas con la expresión PromQL

### La expresión no devuelve resultados

Prueba primero la consulta sin comparación:

```promql
up{job="node_exporter"}
```

Después:

```promql
up{job="node_exporter"} == 0
```

Si el target está activo, la primera consulta devolverá `1` y la segunda no devolverá series.

Esto es normal: la alerta no debe activarse mientras el target esté disponible.

### La métrica no existe

Consulta las métricas disponibles:

```bash
curl -s \
  http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

Prueba en Prometheus:

```promql
node_load1
```

### La etiqueta no coincide

Consulta las series:

```bash
curl -s http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=up' \
  | jq
```

Comprueba los valores de `job`:

```bash
curl -s \
  http://localhost:9090/api/v1/label/job/values \
  | jq
```

### La expresión devuelve demasiadas series

Ejemplo:

```promql
node_filesystem_avail_bytes < 10737418240
```

Puede crear una alerta por cada combinación de etiquetas.

Filtra o agrupa según el objetivo:

```promql
node_filesystem_avail_bytes{
  fstype!~"tmpfs|overlay|squashfs",
  mountpoint="/"
}
< 10737418240
```

### Expresiones con divisiones

Para porcentaje de memoria usada:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
> 90
```

Para evitar diferencias de etiquetas:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    job="node_exporter"
  }
  /
  node_memory_MemTotal_bytes{
    job="node_exporter"
  }
)
> 90
```

### Expresiones con `rate`

Uso de CPU:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
> 80
```

## Problemas con el período `for`

### La alerta permanece en `pending`

Ejemplo:

```yaml
for: 10m
```

La alerta permanecerá en `pending` hasta que la expresión se cumpla durante diez minutos completos.

Comprueba:

- Hora del sistema.
- Intervalo de evaluación.
- Duración configurada.
- Continuidad de la condición.
- Reinicios de Prometheus.

### La condición se interrumpe

Si la expresión deja de cumplirse brevemente:

```text
firing → inactive
```

o:

```text
pending → inactive
```

El contador de `for` comienza de nuevo.

### Diagnosticar el tiempo pendiente

Consulta:

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq '.data.alerts[] | {
      labels: .labels,
      state: .state,
      activeAt: .activeAt
    }'
```

### Práctica recomendada

En el laboratorio utiliza períodos cortos:

```yaml
for: 30s
```

En producción, el valor debe adaptarse al problema. Un período demasiado corto puede generar alertas inestables.

## Problemas de alertas repetitivas

### La alerta se activa constantemente

Posibles causas:

- El umbral es demasiado bajo.
- La métrica tiene fluctuaciones normales.
- Falta un período `for`.
- La expresión está invertida.
- Los datos no son fiables.
- El target está intermitente.

### Ejemplo inestable

```promql
node_load1 > 1
```

Puede activarse y desactivarse continuamente en un sistema con carga variable.

### Añadir un período

```yaml
expr: node_load1 > 1
for: 5m
```

### Usar una condición más adecuada

El umbral debe tener sentido para el número de CPU y el comportamiento del sistema.

### Alertas duplicadas

Pueden producirse cuando:

- Existen dos reglas iguales.
- Prometheus y Grafana alertan sobre la misma condición.
- Hay dos instancias de Prometheus.
- Alertmanager recibe la misma alerta con etiquetas diferentes.
- El dashboard contiene reglas duplicadas.

Consulta las reglas:

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq '.data.groups[].rules[] | .name'
```

## Etiquetas de las alertas

### Etiquetas de clasificación

Ejemplo:

```yaml
labels:
  severity: warning
  team: sistemas
  servicio: node_exporter
```

Las etiquetas pueden utilizarse para:

- Agrupar alertas.
- Enrutar notificaciones.
- Filtrar alertas.
- Crear silencias.
- Identificar equipos.
- Diferenciar entornos.

### Etiqueta `severity`

Valores habituales:

```text
info
warning
critical
```

Utiliza una convención coherente en todo el entorno.

### Etiqueta `environment`

```yaml
labels:
  environment: laboratorio
```

### Etiqueta `team`

```yaml
labels:
  team: operaciones
```

### Etiquetas heredadas

Una alerta puede conservar etiquetas de la serie original.

Ejemplo:

```yaml
expr: up{job="node_exporter"} == 0
```

La alerta puede conservar:

```text
job
instance
```

## Anotaciones de las alertas

### `summary`

Resume el problema:

```yaml
annotations:
  summary: Node Exporter no responde
```

### `description`

Proporciona detalles:

```yaml
annotations:
  description: El target {{ $labels.instance }} no responde desde hace varios minutos.
```

### `runbook_url`

Enlaza un procedimiento operativo:

```yaml
annotations:
  runbook_url: https://documentacion.ejemplo.local/runbooks/node-exporter-down
```

### Variables disponibles

En las anotaciones pueden utilizarse datos de las etiquetas:

```yaml
annotations:
  summary: CPU elevada en {{ $labels.instance }}
  description: El uso de CPU supera el umbral configurado.
```

### Anotaciones informativas

Incluye:

- Recurso afectado.
- Valor observado.
- Umbral.
- Duración.
- Acción recomendada.
- Enlace al procedimiento.
- Enlace al dashboard.

Ejemplo:

```yaml
annotations:
  summary: Poco espacio en {{ $labels.instance }}
  description: El punto de montaje {{ $labels.mountpoint }} tiene menos del 10% libre.
  runbook_url: https://documentacion.ejemplo.local/runbooks/disk-space
```

## Ejemplos de reglas de alerta

### Node Exporter caído

```yaml
groups:
  - name: disponibilidad
    rules:
      - alert: NodeExporterDown
        expr: up{job="node_exporter"} == 0
        for: 5m
        labels:
          severity: critical
          servicio: node_exporter
        annotations:
          summary: Node Exporter no responde
          description: El target {{ $labels.instance }} no está disponible.
```

### Prometheus caído

Si Prometheus evalúa sus propias reglas, no puede alertar sobre sí mismo cuando está completamente detenido. Esta alerta sirve para detectar problemas relacionados con su target:

```yaml
groups:
  - name: disponibilidad
    rules:
      - alert: PrometheusTargetDown
        expr: up{job="prometheus"} == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: El target de Prometheus está caído
          description: El target {{ $labels.instance }} no responde.
```

### CPU elevada

```yaml
groups:
  - name: sistema
    rules:
      - alert: HighCPUUsage
        expr: |
          100 * (
            1 -
            avg by (instance) (
              rate(
                node_cpu_seconds_total{
                  mode="idle"
                }[5m]
              )
            )
          ) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: CPU elevada en {{ $labels.instance }}
          description: El uso de CPU supera el 80% durante cinco minutos.
```

### Memoria elevada

```yaml
groups:
  - name: sistema
    rules:
      - alert: HighMemoryUsage
        expr: |
          100 * (
            1 -
            node_memory_MemAvailable_bytes
            /
            node_memory_MemTotal_bytes
          ) > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: Memoria elevada en {{ $labels.instance }}
          description: El uso de memoria supera el 90%.
```

### Poco espacio libre

```yaml
groups:
  - name: almacenamiento
    rules:
      - alert: LowFilesystemSpace
        expr: |
          100 * (
            node_filesystem_avail_bytes{
              fstype!~"tmpfs|overlay|squashfs"
            }
            /
            node_filesystem_size_bytes{
              fstype!~"tmpfs|overlay|squashfs"
            }
          ) < 10
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: Poco espacio libre en {{ $labels.instance }}
          description: El punto {{ $labels.mountpoint }} tiene menos del 10% libre.
```

### Sistema de archivos casi lleno

```yaml
groups:
  - name: almacenamiento
    rules:
      - alert: FilesystemAlmostFull
        expr: |
          100 * (
            1 -
            node_filesystem_avail_bytes{
              fstype!~"tmpfs|overlay|squashfs"
            }
            /
            node_filesystem_size_bytes{
              fstype!~"tmpfs|overlay|squashfs"
            }
          ) > 90
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: Sistema de archivos casi lleno
          description: {{ $labels.instance }} tiene {{ $labels.mountpoint }} por encima del 90%.
```

### Carga elevada

```yaml
groups:
  - name: sistema
    rules:
      - alert: HighSystemLoad
        expr: node_load1 > 4
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: Carga elevada en {{ $labels.instance }}
          description: La carga de un minuto supera el umbral configurado.
```

El valor adecuado depende del número de CPUs. En sistemas con diferentes tamaños, conviene normalizar la carga por el número de procesadores.

## Validar reglas con `promtool`

### Validar todas las reglas

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

### Validar un fichero concreto

```bash
promtool check rules \
  /etc/prometheus/rules/sistema.yml
```

### Validar la configuración completa

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Errores habituales

```text
yaml: line 12: did not find expected key
```

Indica un problema de YAML.

```text
field expr not found
```

Indica que falta la expresión.

```text
parse error
```

Indica que la expresión PromQL no se puede interpretar.

## Configurar Alertmanager

### Consultar el servicio

```bash
systemctl status alertmanager
```

### Comprobar el puerto habitual

```bash
sudo ss -lntp | grep ':9093'
```

### Probar la API

```bash
curl -I http://localhost:9093
```

### Comprobar la salud

```bash
curl http://localhost:9093/-/healthy
```

### Consultar los registros

```bash
sudo journalctl -u alertmanager \
  -n 100 \
  --no-pager
```

### Configuración de Prometheus

En `prometheus.yml`:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - localhost:9093
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Comprobar el estado desde Prometheus

En la interfaz:

```text
http://localhost:9090/status
```

También mediante API:

```bash
curl -s http://localhost:9090/api/v1/alertmanagers \
  | jq
```

## Problemas de comunicación con Alertmanager

### Prometheus no muestra Alertmanagers

Comprueba:

```bash
curl -s http://localhost:9090/api/v1/alertmanagers \
  | jq
```

Comprueba la configuración:

```bash
sudo grep -n -A 8 -B 2 \
  "alertmanagers" \
  /etc/prometheus/prometheus.yml
```

### Alertmanager está detenido

```bash
systemctl is-active alertmanager
```

```bash
sudo systemctl start alertmanager
```

### Puerto incorrecto

El puerto habitual es:

```text
9093
```

Comprueba:

```bash
sudo ss -lntp | grep ':9093'
```

### Firewall

Si Prometheus y Alertmanager están en equipos diferentes:

```bash
nc -vz DIRECCION_IP_ALERTMANAGER 9093
```

### Consultar errores de Prometheus

```bash
sudo journalctl -u prometheus \
  --since "15 minutes ago" \
  --no-pager \
  | grep -i -E \
  "alertmanager|notification|error|timeout|refused"
```

## Configurar rutas en Alertmanager

### Estructura básica

```yaml
global:
  resolve_timeout: 5m

route:
  receiver: laboratorio

receivers:
  - name: laboratorio
```

### Enrutar por severidad

```yaml
global:
  resolve_timeout: 5m

route:
  receiver: general

  routes:
    - matchers:
        - severity="critical"
      receiver: criticas

receivers:
  - name: general

  - name: criticas
```

### Agrupar alertas

```yaml
route:
  receiver: general
  group_by:
    - alertname
    - instance
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
```

### Significado de los parámetros

#### `group_by`

Indica las etiquetas utilizadas para agrupar alertas.

#### `group_wait`

Tiempo de espera inicial antes de enviar el primer grupo.

#### `group_interval`

Tiempo mínimo entre grupos nuevos.

#### `repeat_interval`

Intervalo para repetir una alerta que continúa activa.

### Validar Alertmanager

Según la versión instalada, puede utilizarse:

```bash
amtool check-config \
  /etc/alertmanager/alertmanager.yml
```

También puedes consultar la ayuda:

```bash
amtool --help
```

## Problemas de rutas de Alertmanager

### La alerta llega, pero no se notifica

Comprueba:

- Receptor utilizado.
- Coincidencia de labels.
- Orden de las rutas.
- `continue`.
- Reglas de silencio.
- Inhibiciones.
- Estado del receptor.
- Errores del canal externo.

### La ruta no coincide

Ejemplo de alerta:

```yaml
labels:
  severity: critical
```

Matcher correcto:

```yaml
matchers:
  - severity="critical"
```

Si la alerta utiliza:

```yaml
severity: crit
```

no coincidirá con:

```yaml
severity="critical"
```

### Consultar alertas en Alertmanager

```bash
curl -s http://localhost:9093/api/v2/alerts \
  | jq
```

### Mostrar labels de las alertas

```bash
curl -s http://localhost:9093/api/v2/alerts \
  | jq '.[].labels'
```

### Consultar silencios

```bash
curl -s http://localhost:9093/api/v2/silences \
  | jq
```

## Problemas con receptores

### Receptor de webhook

Ejemplo conceptual:

```yaml
receivers:
  - name: webhook-laboratorio
    webhook_configs:
      - url: http://servidor-receptor:8080/alertas
```

Comprueba:

```bash
curl -I http://servidor-receptor:8080/alertas
```

### Problemas habituales del webhook

- URL incorrecta.
- Puerto cerrado.
- Servicio receptor detenido.
- Certificado no válido.
- Error de autenticación.
- Respuesta HTTP no válida.
- Timeout.
- Ruta incorrecta.

### Consultar registros de Alertmanager

```bash
sudo journalctl -u alertmanager \
  --since "15 minutes ago" \
  --no-pager
```

Busca:

```text
webhook
notify
error
timeout
401
403
```

### Receptores de correo

Comprueba:

- Servidor SMTP.
- Puerto.
- TLS.
- Usuario.
- Contraseña.
- Remitente.
- Destinatario.
- Resolución DNS.
- Firewall.

No incluyas credenciales SMTP reales en una configuración compartida.

## Silencios e inhibiciones

### Silencio

Un silencio evita temporalmente una notificación.

La alerta puede continuar activa, pero no se enviará la notificación mientras coincida con el silencio.

### Consultar silencios

```bash
curl -s http://localhost:9093/api/v2/silences \
  | jq
```

### Problema: la alerta está activa, pero no llega

Comprueba:

- Silencios activos.
- Coincidencia de labels.
- Fecha de inicio.
- Fecha de expiración.
- Usuario que creó el silencio.

### Inhibición

Una inhibición evita notificaciones secundarias cuando existe una alerta principal.

Ejemplo conceptual:

```yaml
inhibit_rules:
  - source_matchers:
      - alertname="InstanceDown"
    target_matchers:
      - severity="warning"
    equal:
      - instance
```

Una alerta crítica sobre una instancia puede inhibir alertas de menor importancia de esa misma instancia.

## Problemas con etiquetas y anotaciones

### La alerta no tiene `instance`

Comprueba si la expresión conserva esa etiqueta.

Consulta:

```promql
up{job="node_exporter"}
```

Una agregación como esta puede eliminar etiquetas:

```promql
sum(
  rate(
    node_cpu_seconds_total[5m]
  )
)
```

Si necesitas conservar `instance`:

```promql
sum by (instance) (
  rate(
    node_cpu_seconds_total[5m]
  )
)
```

### La anotación muestra una variable vacía

Ejemplo:

```yaml
description: El servidor {{ $labels.instance }} tiene CPU elevada.
```

Si la expresión no devuelve `instance`, la anotación no podrá mostrarlo.

Comprueba las etiquetas que devuelve la expresión en Prometheus.

### Mostrar el valor observado

En alertas de Prometheus puede utilizarse:

```yaml
annotations:
  description: Valor observado: {{ $value }}
```

Utiliza el formato que corresponda a la versión y al contexto de evaluación.

### Anotaciones demasiado genéricas

Evita:

```yaml
summary: Problema detectado
```

Utiliza:

```yaml
summary: CPU elevada en {{ $labels.instance }}
```

## Alertas de Grafana

### Crear una regla

En Grafana:

1. Accede a **Alerting**.
2. Selecciona **Alert rules**.
3. Pulsa **New alert rule**.
4. Selecciona la fuente de datos.
5. Define la consulta.
6. Añade una condición.
7. Define el período de evaluación.
8. Añade etiquetas.
9. Añade anotaciones.
10. Selecciona una política de notificación.
11. Guarda la regla.

### Consulta de ejemplo

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

### Condición

Ejemplo:

```text
WHEN query(A)
IS ABOVE 80
```

### Estado de la regla

Grafana puede mostrar estados como:

```text
Normal
Pending
Firing
Error
NoData
```

La nomenclatura concreta puede variar según la versión y la configuración de la regla.

### Estado `NoData`

Indica que la consulta no devolvió datos.

Puede configurarse para:

- Tratarlo como normal.
- Tratarlo como alerta.
- Mantener el estado anterior.
- Generar una alerta específica.

### Estado `Error`

Indica que la consulta o la evaluación produjo un error.

Comprueba:

- Fuente de datos.
- Consulta.
- Permisos.
- Red.
- Logs.
- Query Inspector.
- Configuración de la regla.

## Contactos y políticas de notificación en Grafana

### Contact point

Un contact point define dónde se envía la notificación.

Ejemplos:

- Correo.
- Webhook.
- Slack.
- Microsoft Teams.
- PagerDuty.

### Notification policy

Una política determina qué contact point recibe una alerta.

La política puede utilizar labels:

```text
severity=critical
team=sistemas
environment=produccion
```

### Problema: regla en `firing`, pero sin notificación

Comprueba:

- Contact point.
- Notification policy.
- Labels de la alerta.
- Silencios.
- Horarios de mute.
- Estado del canal.
- Logs de Grafana.

## Sesión práctica 1: crear una alerta de Node Exporter caído

### Objetivo

Crear, validar y probar una alerta de disponibilidad.

### Crear el fichero de reglas

```bash
sudo nano /etc/prometheus/rules/disponibilidad.yml
```

Contenido:

```yaml
groups:
  - name: disponibilidad
    rules:
      - alert: NodeExporterDown
        expr: up{job="node_exporter"} == 0
        for: 1m
        labels:
          severity: critical
          servicio: node_exporter
          entorno: laboratorio
        annotations:
          summary: Node Exporter no responde
          description: El target {{ $labels.instance }} no está disponible.
```

### Validar las reglas

```bash
promtool check rules \
  /etc/prometheus/rules/disponibilidad.yml
```

### Validar la configuración completa

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Comprobar la regla

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq
```

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Consultar el estado

```promql
up{job="node_exporter"}
```

### Consultar la alerta

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Observar la transición

Durante el primer minuto:

```text
pending
```

Después:

```text
firing
```

### Recuperar Node Exporter

```bash
sudo systemctl start node_exporter
```

### Comprobar la recuperación

```promql
up{job="node_exporter"}
```

### Preguntas de análisis

- ¿Cuánto tardó la alerta en pasar a `pending`?
- ¿Cuánto tardó en pasar a `firing`?
- ¿Qué etiqueta identificó el target?
- ¿Qué ocurrió al iniciar de nuevo Node Exporter?
- ¿Qué valor tenía `up` en cada estado?

## Sesión práctica 2: probar una alerta de CPU

### Objetivo

Crear una alerta temporal de CPU elevada.

### Crear la regla

```yaml
groups:
  - name: rendimiento
    rules:
      - alert: HighCPUUsage
        expr: |
          100 * (
            1 -
            avg by (instance) (
              rate(
                node_cpu_seconds_total{
                  mode="idle"
                }[5m]
              )
            )
          ) > 20
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: CPU elevada en {{ $labels.instance }}
          description: El uso de CPU supera el 20% durante un minuto.
```

El umbral del `20%` se utiliza únicamente para facilitar la práctica.

### Validar

```bash
promtool check rules \
  /etc/prometheus/rules/rendimiento.yml
```

### Generar carga

En un entorno de laboratorio:

```bash
yes > /dev/null
```

Para detenerlo:

```text
Ctrl + C
```

En otra terminal, puedes consultar:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

### Consultar el estado

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Recuperar el sistema

Detén el proceso de carga:

```text
Ctrl + C
```

Espera a que la expresión deje de cumplirse.

### Preguntas de análisis

- ¿El valor superó el umbral?
- ¿La alerta pasó a `pending`?
- ¿Cuánto tardó en activarse?
- ¿Qué ocurrió al detener la carga?
- ¿El período `for` evitó una activación instantánea?

## Sesión práctica 3: probar una alerta de memoria

### Objetivo

Crear una alerta de memoria con un umbral controlado.

### Regla de laboratorio

```yaml
groups:
  - name: memoria
    rules:
      - alert: HighMemoryUsage
        expr: |
          100 * (
            1 -
            node_memory_MemAvailable_bytes
            /
            node_memory_MemTotal_bytes
          ) > 20
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: Memoria elevada en {{ $labels.instance }}
          description: El uso de memoria supera el 20%.
```

### Validar la expresión directamente

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Validar la regla

```bash
promtool check rules \
  /etc/prometheus/rules/memoria.yml
```

### Observar la alerta

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Ajustar el umbral

En un sistema de laboratorio, el valor real puede no superar el umbral. Prueba temporalmente un umbral adecuado al entorno, documentándolo claramente.

## Sesión práctica 4: comprobar el flujo con Alertmanager

### Objetivo

Verificar que Prometheus envía alertas a Alertmanager.

### Comprobar Alertmanager

```bash
systemctl is-active alertmanager
```

```bash
curl http://localhost:9093/-/healthy
```

### Consultar la configuración de Prometheus

```bash
sudo grep -n -A 8 \
  "alertmanagers" \
  /etc/prometheus/prometheus.yml
```

### Consultar los Alertmanagers conectados

```bash
curl -s http://localhost:9090/api/v1/alertmanagers \
  | jq
```

### Consultar las alertas recibidas

```bash
curl -s http://localhost:9093/api/v2/alerts \
  | jq
```

### Generar una alerta

Detén Node Exporter:

```bash
sudo systemctl stop node_exporter
```

### Consultar Prometheus

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Consultar Alertmanager

```bash
curl -s http://localhost:9093/api/v2/alerts \
  | jq
```

### Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

### Preguntas de análisis

- ¿Prometheus detectó la alerta?
- ¿Alertmanager la recibió?
- ¿Qué labels llegaron a Alertmanager?
- ¿Qué estado tenía la alerta?
- ¿Se produjo una notificación?

## Sesión práctica 5: diagnosticar una alerta que permanece `pending`

### Objetivo

Comprender el funcionamiento de `for`.

### Crear una regla

```yaml
groups:
  - name: practica
    rules:
      - alert: PracticaPending
        expr: up{job="node_exporter"} == 0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: Alerta de práctica
          description: Esta alerta debe permanecer en pending durante cinco minutos.
```

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Consultar la alerta

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Iniciar Node Exporter antes de cinco minutos

```bash
sudo systemctl start node_exporter
```

### Observar el resultado

La alerta debería volver a `inactive` sin llegar a `firing`.

### Repetir con tiempo suficiente

Detén Node Exporter y espera más de cinco minutos:

```bash
sudo systemctl stop node_exporter
```

### Consultar

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Recuperar

```bash
sudo systemctl start node_exporter
```

## Sesión práctica 6: diagnosticar una regla que nunca se activa

### Objetivo

Encontrar un filtro incorrecto en una expresión.

### Regla incorrecta

```yaml
- alert: NodeExporterDown
  expr: up{job="node-exporter"} == 0
  for: 1m
```

El nombre real puede ser:

```text
node_exporter
```

### Consultar los valores reales

```bash
curl -s \
  http://localhost:9090/api/v1/label/job/values \
  | jq
```

### Probar la expresión amplia

```promql
up
```

### Probar el filtro incorrecto

```promql
up{
  job="node-exporter"
}
```

### Probar el filtro correcto

```promql
up{
  job="node_exporter"
}
```

### Corregir la regla

```yaml
- alert: NodeExporterDown
  expr: up{job="node_exporter"} == 0
  for: 1m
```

### Validar y reiniciar

```bash
promtool check rules \
  /etc/prometheus/rules/disponibilidad.yml
```

```bash
sudo systemctl restart prometheus
```

## Sesión práctica 7: diagnosticar una alerta con notificaciones duplicadas

### Objetivo

Identificar por qué se reciben varias notificaciones para el mismo problema.

### Comprobar reglas duplicadas

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq '.data.groups[].rules[] | .name'
```

### Comprobar alertas en Prometheus

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Comprobar alertas en Alertmanager

```bash
curl -s http://localhost:9093/api/v2/alerts \
  | jq
```

### Revisar la agrupación

Consulta la configuración de Alertmanager:

```bash
sudo grep -n -A 20 \
  "^route:" \
  /etc/alertmanager/alertmanager.yml
```

### Posibles causas

- Dos reglas con el mismo objetivo.
- `group_by` insuficiente.
- `repeat_interval` demasiado corto.
- Dos instancias de Prometheus.
- Alertas de Prometheus y Grafana para la misma métrica.
- Diferencias en etiquetas que impiden agrupar.

### Registrar el diagnóstico

```text
Nombre de la alerta:

Número de reglas similares:

Número de alertas en Prometheus:

Número de alertas en Alertmanager:

Labels:

group_by:

repeat_interval:

Causa:

Corrección:
```

## Sesión práctica 8: probar silencios

### Objetivo

Crear y comprobar un silencio temporal en Alertmanager.

### Consultar silencios actuales

```bash
curl -s http://localhost:9093/api/v2/silences \
  | jq
```

### Crear un silencio mediante la interfaz

En Alertmanager:

1. Accede a la interfaz web.
2. Selecciona la alerta.
3. Pulsa **Silence**.
4. Define la duración.
5. Añade el creador.
6. Añade un comentario.
7. Confirma.

### Crear un silencio mediante API

Ejemplo conceptual:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "matchers": [
      {
        "name": "alertname",
        "value": "NodeExporterDown",
        "isRegex": false
      }
    ],
    "startsAt": "2026-09-25T12:00:00Z",
    "endsAt": "2026-09-25T13:00:00Z",
    "createdBy": "laboratorio",
    "comment": "Práctica de mantenimiento"
  }' \
  http://localhost:9093/api/v2/silences
```

Utiliza fechas adecuadas al momento de la práctica.

### Comprobar el silencio

```bash
curl -s http://localhost:9093/api/v2/silences \
  | jq
```

### Preguntas de análisis

- ¿La alerta sigue activa?
- ¿Se ha detenido únicamente la notificación?
- ¿Qué labels coinciden con el silencio?
- ¿Cuándo expira?
- ¿Qué diferencia existe entre un silencio y una inhibición?

## Sesión práctica 9: crear una alerta desde Grafana

### Objetivo

Crear una regla de alerta en Grafana utilizando Prometheus.

### Crear la regla

En Grafana:

1. Abre **Alerting**.
2. Selecciona **Alert rules**.
3. Pulsa **New alert rule**.
4. Introduce un nombre:

```text
CPU elevada en laboratorio
```

5. Selecciona Prometheus.
6. Añade la consulta:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

### Definir la condición

Configura una condición similar a:

```text
WHEN query(A)
IS ABOVE 80
```

### Definir la evaluación

Ejemplo:

```text
Evaluate every: 1m
For: 5m
```

### Añadir labels

```text
severity: warning
team: sistemas
environment: laboratorio
```

### Añadir anotaciones

```text
summary: CPU elevada en {{ $labels.instance }}
description: El uso de CPU supera el 80%.
```

### Guardar

Guarda la regla y revisa su estado en:

```text
Alerting > Alert rules
```

### Validar

Genera carga de laboratorio o utiliza un umbral controlado.

## Sesión práctica 10: crear un informe de alertas

### Objetivo

Documentar todo el flujo de una alerta.

### Crear el directorio

```bash
mkdir -p ~/laboratorio/informe-alertas
cd ~/laboratorio/informe-alertas
```

### Generar información de Prometheus

```bash
{
  echo "===== INFORME DE ALERTAS ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== PROMETHEUS ====="
  systemctl is-active prometheus 2>/dev/null || true
  echo

  echo "===== ALERTMANAGER ====="
  systemctl is-active alertmanager 2>/dev/null || true
  echo

  echo "===== REGLAS ====="
  curl -s http://localhost:9090/api/v1/rules \
    || true
  echo
  echo

  echo "===== ALERTAS PROMETHEUS ====="
  curl -s http://localhost:9090/api/v1/alerts \
    || true
  echo
  echo

  echo "===== ALERTMANAGERS ====="
  curl -s http://localhost:9090/api/v1/alertmanagers \
    || true
  echo
  echo

  echo "===== ALERTAS ALERTMANAGER ====="
  curl -s http://localhost:9093/api/v2/alerts \
    || true
  echo
  echo

  echo "===== SILENCIOS ====="
  curl -s http://localhost:9093/api/v2/silences \
    || true
  echo
  echo

  echo "===== LOGS PROMETHEUS ====="
  sudo journalctl -u prometheus \
    -n 50 \
    --no-pager
  echo

  echo "===== LOGS ALERTMANAGER ====="
  sudo journalctl -u alertmanager \
    -n 50 \
    --no-pager
} | tee informe-alertas.txt
```

### Revisar el informe

```bash
less informe-alertas.txt
```

## Lista de comprobación de Prometheus

```text
[ ] El servicio Prometheus está activo.
[ ] La configuración principal es válida.
[ ] Los ficheros de reglas son legibles.
[ ] Las reglas se validan con promtool.
[ ] Las reglas aparecen en /rules.
[ ] Las expresiones devuelven los resultados esperados.
[ ] El período for está documentado.
[ ] Las alertas aparecen en /alerts.
[ ] Prometheus conoce a Alertmanager.
[ ] El endpoint de Alertmanager responde.
[ ] No hay errores recientes en el journal.
```

## Lista de comprobación de Alertmanager

```text
[ ] Alertmanager está instalado.
[ ] El servicio está activo.
[ ] El puerto 9093 está en escucha.
[ ] La configuración es válida.
[ ] Prometheus puede conectarse.
[ ] Las alertas llegan a Alertmanager.
[ ] Las rutas coinciden con las labels.
[ ] Los receptores están configurados.
[ ] No existen silencios inesperados.
[ ] No existen inhibiciones inesperadas.
[ ] El webhook o SMTP responde.
[ ] El intervalo de repetición es adecuado.
[ ] Los registros no muestran errores.
```

## Lista de comprobación de Grafana Alerting

```text
[ ] La regla existe.
[ ] La fuente de datos es correcta.
[ ] La consulta devuelve datos.
[ ] La condición está bien definida.
[ ] El intervalo de evaluación es adecuado.
[ ] El período de permanencia es adecuado.
[ ] Las labels están configuradas.
[ ] Las anotaciones son claras.
[ ] Existe un contact point.
[ ] Existe una notification policy.
[ ] No existe un mute timing inesperado.
[ ] No existe un silencio inesperado.
[ ] El estado de la regla es conocido.
[ ] Los logs no muestran errores.
```

## Buenas prácticas

- Define nombres de alerta claros y estables.
- Utiliza expresiones que puedan probarse directamente en Prometheus.
- Valida los ficheros con `promtool`.
- Utiliza `for` para evitar alertas transitorias.
- Configura umbrales basados en el comportamiento real.
- Utiliza labels coherentes.
- Separa etiquetas de clasificación y anotaciones descriptivas.
- Incluye el recurso afectado en la anotación.
- Añade enlaces a procedimientos operativos.
- Comprueba la retención y el intervalo de evaluación.
- Evita alertar sobre métricas que no tienen datos fiables.
- No dupliques reglas entre Prometheus y Grafana sin una razón.
- Configura correctamente las rutas de Alertmanager.
- Utiliza `group_by` para evitar notificaciones repetitivas.
- Ajusta `repeat_interval` a la importancia de la alerta.
- Revisa silencios e inhibiciones antes de cambiar reglas.
- Utiliza receptores de prueba durante las prácticas.
- No incluyas credenciales en ficheros compartidos.
- Documenta las pruebas de activación y recuperación.
- Prueba también el estado de resolución de una alerta.
- Comprueba las alertas desde la métrica `ALERTS`.
- Revisa los logs cuando una alerta no se comporte como se espera.

## Tabla de síntomas y comprobaciones

| Síntoma | Primera prueba | Posible causa |
|---|---|---|
| La regla no aparece | `promtool check rules` | Ruta o configuración |
| La regla aparece como `bad` | API de reglas | PromQL o YAML |
| La alerta nunca se activa | Probar la expresión | Filtro incorrecto |
| La alerta permanece `pending` | Revisar `for` | Tiempo insuficiente |
| La alerta se activa constantemente | Revisar umbral | Condición inestable |
| No llega la notificación | Consultar Alertmanager | Ruta o receptor |
| Alertas duplicadas | Revisar reglas y `group_by` | Duplicación |
| Alerta activa sin aviso | Consultar silencios | Silencio o inhibición |
| Webhook no funciona | `curl` al endpoint | Red o autenticación |
| SMTP no funciona | Logs de Alertmanager | Servidor o credenciales |
| Grafana muestra `NoData` | Probar consulta | Fuente o métrica |
| Regla de Grafana en `Error` | Query Inspector | Consulta o permisos |
| La alerta no muestra instancia | Revisar etiquetas | Agregación incorrecta |
| Cambia a `inactive` enseguida | Revisar expresión | Condición intermitente |

## Puntos clave

- Una alerta depende de métricas, expresiones, reglas y notificaciones.
- Prometheus evalúa sus propias reglas y puede enviar alertas a Alertmanager.
- Alertmanager agrupa, enruta, silencia e inhibe alertas.
- Grafana tiene su propio sistema de alertas.
- Los estados habituales son `inactive`, `pending` y `firing`.
- El período `for` evita activar alertas por problemas momentáneos.
- `promtool check rules` valida los ficheros de reglas.
- La interfaz `/rules` muestra el estado de las reglas.
- La interfaz `/alerts` muestra las alertas evaluadas por Prometheus.
- La métrica `ALERTS` permite consultar estados mediante PromQL.
- Una expresión que no devuelve datos no activa una alerta normal.
- Las etiquetas permiten clasificar y enrutar alertas.
- Las anotaciones explican el problema.
- Una agregación puede eliminar etiquetas necesarias para las notificaciones.
- Alertmanager debe recibir las alertas desde Prometheus.
- Una ruta de Alertmanager debe coincidir con las labels reales.
- Los silencios detienen notificaciones, pero no necesariamente la evaluación.
- Las inhibiciones pueden ocultar alertas secundarias.
- Una alerta activa no garantiza que la notificación se haya entregado.
- Toda alerta debe probarse tanto en activación como en recuperación.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre una métrica y una alerta?
2. ¿Qué función cumple una regla de alerta?
3. ¿Qué significan los estados `inactive`, `pending` y `firing`?
4. ¿Qué función cumple el campo `for`?
5. ¿Qué comando permite validar las reglas de Prometheus?
6. ¿Dónde se pueden consultar las reglas cargadas?
7. ¿Dónde se pueden consultar las alertas activas?
8. ¿Qué función cumple Alertmanager?
9. ¿Qué diferencia existe entre una etiqueta y una anotación?
10. ¿Por qué una agregación puede eliminar la etiqueta `instance`?
11. ¿Qué comprobarías si una alerta nunca se activa?
12. ¿Qué comprobarías si una alerta permanece en `pending`?
13. ¿Qué causas pueden provocar alertas repetitivas?
14. ¿Qué diferencia existe entre un silencio y una inhibición?
15. ¿Qué comprobarías si Prometheus genera alertas, pero Alertmanager no las recibe?
16. ¿Qué comprobarías si Alertmanager recibe una alerta, pero no envía la notificación?
17. ¿Qué función cumple `group_by`?
18. ¿Qué información debe contener una anotación útil?
19. ¿Qué diferencias existen entre las alertas de Prometheus y las de Grafana?
20. ¿Qué información debe incluir un informe de una incidencia de alertas?