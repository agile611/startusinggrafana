# Fundamentos de telemetría

Este bloque presenta los conceptos necesarios para comprender la monitorización moderna basada en métricas y la visualización de datos mediante Grafana.

La telemetría permite recopilar información sobre el estado y el comportamiento de sistemas, aplicaciones y servicios. Estos datos pueden utilizarse para detectar problemas, analizar tendencias, validar cambios y mejorar la operación de una infraestructura.

## Objetivos

Al finalizar este bloque podrás:

- Explicar qué es la telemetría y diferenciar métricas, logs, trazas y eventos.
- Diferenciar los modelos de recopilación push y pull.
- Interpretar una serie temporal mediante sus valores, marcas temporales y etiquetas.
- Comprender la relación entre muestreo, retención y almacenamiento.
- Explicar el concepto de downsampling.
- Identificar el papel de Grafana y de las fuentes de datos.
- Consultar e interpretar métricas básicas de un sistema Linux.

## Contenidos

1. Conceptos generales de telemetría.
2. Modelos push y pull.
3. Series temporales.
4. Intervalos de muestreo.
5. Retención de datos.
6. Downsampling.
7. Grafana y fuentes de datos.

## Prácticas relacionadas

- Identificación de métricas de un sistema Ubuntu.
- Interpretación de nombres y etiquetas de métricas.
- Comparación entre diferentes intervalos de muestreo.
- Consulta de métricas mediante Prometheus.
- Visualización de métricas en Grafana.
- Análisis básico de CPU, memoria, disco y red.

## Resultado esperado

Al finalizar el bloque, podrás seguir el recorrido completo de una métrica:

```text
Sistema monitorizado
        ↓
Agente o exporter
        ↓
Prometheus
        ↓
Consulta PromQL
        ↓
Grafana
        ↓
Panel visual
```
```

---

# 3. Guion docente de la sesión

## Parte 1 — Introducción y motivación

**Duración:** 15 minutos.

### Objetivo

Mostrar que la monitorización no consiste simplemente en “mirar gráficos”, sino en recopilar, almacenar, consultar e interpretar datos.

### Explicación para el alumnado

Puedes comenzar con esta introducción:

> Cuando un sistema falla, normalmente no basta con saber que algo ha dejado de funcionar. Necesitamos conocer cuándo empezó el problema, qué componentes están afectados, cómo ha evolucionado y si existe un patrón que permita anticiparlo.

Después plantea estas preguntas:

- ¿Cómo sabemos si un servidor está saturado?
- ¿Cómo detectamos que el disco se está llenando?
- ¿Cómo sabemos si una aplicación responde lentamente?
- ¿Cómo distinguimos un problema puntual de una tendencia?
- ¿Qué datos necesitamos para investigar un incidente?

### Ejemplo inicial

Muestra una situación sencilla:

```text
A las 10:00 la CPU estaba al 25 %.
A las 10:05 estaba al 40 %.
A las 10:10 estaba al 85 %.
A las 10:15 estaba al 98 %.
```

Pregunta al alumnado:

- ¿Qué está ocurriendo?
- ¿Se trata de un valor aislado o de una tendencia?
- ¿Qué información adicional necesitaríamos?
- ¿Qué acción tomaríamos?

### Idea clave

Una métrica aislada puede ser útil, pero una secuencia de valores a lo largo del tiempo permite observar:

- Tendencias.
- Picos.
- Caídas.
- Comportamientos periódicos.
- Cambios después de una modificación.

---

## Parte 2 — Qué es la telemetría

**Duración:** 25 minutos.

### Explicación

La telemetría es la recopilación y transmisión de datos desde un sistema hacia una plataforma capaz de almacenarlos, consultarlos y visualizarlos.

En observabilidad suelen distinguirse cuatro tipos principales de información:

| Tipo | Qué representa | Ejemplo |
|---|---|---|
| Métrica | Un valor medible | Uso de CPU del 75 % |
| Log | Un registro de actividad | Error al conectar con la base de datos |
| Traza | El recorrido de una petición | Petición HTTP de 250 ms |
| Evento | Algo que sucede en un momento concreto | Reinicio de un servicio |

### Ejemplo práctico: una misma incidencia

Supón que una aplicación responde lentamente.

#### Métrica

```text
http_request_duration_seconds = 2.4
```

Indica que las peticiones tardan más de lo normal.

#### Log

```text
ERROR database connection timeout
```

Indica que se ha producido un error de conexión.

#### Traza

```text
Cliente → API → Servicio de usuarios → Base de datos
```

Permite localizar qué parte de la petición es lenta.

#### Evento

```text
10:35 — Se reinicia el servicio grafana-server
```

Indica una acción concreta ocurrida en un instante.

### Actividad rápida para el alumnado

Clasificar los siguientes elementos:

```text
1. El disco está ocupado al 82 %.
2. El servicio nginx se ha reiniciado.
3. La petición ha tardado 1,8 segundos.
4. ERROR: no se pudo abrir el fichero de configuración.
5. La petición pasó por cuatro microservicios.
```

Solución:

```text
1. Métrica
2. Evento
3. Métrica
4. Log
5. Traza
```

### Mensaje importante

Las métricas responden principalmente a:

- **Cuánto**.
- **Cuándo**.
- **Con qué frecuencia**.
- **Cómo evoluciona**.

Los logs aportan más contexto textual, pero suelen ser más costosos de almacenar y consultar.

---

## Parte 3 — Modelo push y modelo pull

**Duración:** 25 minutos.

### Modelo pull

En el modelo *pull*, el sistema de monitorización consulta periódicamente al componente monitorizado.

```text
Prometheus ───── consulta ─────> Exporter
Prometheus <──── devuelve ────── Exporter
```

Ejemplo:

```text
Prometheus consulta:
http://servidor:9100/metrics
```

El exporter responde con métricas:

```text
node_cpu_seconds_total{cpu="0",mode="idle"} 12345.6
```

### Modelo push

En el modelo *push*, el componente monitorizado envía los datos hacia el sistema receptor.

```text
Aplicación ───── envía métricas ─────> Recolector
```

Se utiliza habitualmente cuando:

- El componente no puede ser consultado directamente.
- Se trata de trabajos temporales.
- El sistema está detrás de una red restringida.
- Se utiliza un agente intermediario.

### Comparación

| Característica | Pull | Push |
|---|---|---|
| Quién inicia la comunicación | Sistema de monitorización | Sistema monitorizado |
| Ejemplo | Prometheus consulta un exporter | Un agente envía métricas |
| Ventaja | Control centralizado | Adecuado para sistemas efímeros |
| Riesgo | El endpoint debe ser accesible | El receptor debe aceptar datos |
| Uso habitual | Servidores y servicios permanentes | Jobs y agentes |

### Demostración con Prometheus

Si Prometheus está instalado, muestra su configuración:

```bash
sudo grep -n "scrape_interval\|job_name\|targets" \
  /etc/prometheus/prometheus.yml
```

Una configuración típica puede contener:

```yaml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node
    static_configs:
      - targets:
          - localhost:9100
```

Explica:

- `job_name` identifica el grupo de objetivos.
- `targets` contiene los endpoints.
- Prometheus consulta esos objetivos periódicamente.

### Pregunta para el alumnado

> Si Prometheus deja de consultar un exporter, ¿qué tipo de información podríamos observar?

Respuestas esperadas:

- La métrica deja de actualizarse.
- Puede aparecer una alerta de objetivo caído.
- El último valor puede permanecer almacenado, pero ya no representa el estado actual.
- La ausencia de datos también puede ser una señal operativa.

---

## Parte 4 — Series temporales

**Duración:** 30 minutos.

### Explicación

Una serie temporal es una secuencia de valores asociados a instantes concretos.

Ejemplo:

```text
cpu_usage_percent{host="ubuntu-01",cpu="0"} 42.5
```

Esta métrica contiene:

- Nombre: `cpu_usage_percent`.
- Etiqueta `host`: `ubuntu-01`.
- Etiqueta `cpu`: `0`.
- Valor actual: `42.5`.
- Unidad conceptual: porcentaje.

Una serie temporal se puede representar como:

```text
nombre_metrica{etiquetas} valor
```

### Ejemplo con varias series

```text
http_requests_total{method="GET",status="200"} 1500
http_requests_total{method="GET",status="500"} 12
http_requests_total{method="POST",status="200"} 430
```

Aunque todas utilizan el mismo nombre, las etiquetas generan series diferentes.

### Actividad para el alumnado

Pide que identifiquen las partes de esta métrica:

```text
node_filesystem_avail_bytes{
  device="/dev/sda2",
  fstype="ext4",
  instance="localhost:9100",
  job="node",
  mountpoint="/"
} 18446744073
```

Deben identificar:

- Nombre de la métrica.
- Dispositivo.
- Sistema de ficheros.
- Instancia.
- Trabajo.
- Punto de montaje.
- Valor.

### Comprobación con Node Exporter

Si Node Exporter está activo:

```bash
curl -s http://127.0.0.1:9100/metrics | head -20
```

Para localizar métricas de CPU:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

Para localizar métricas de memoria:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_memory_' \
  | head
```

Para localizar métricas de disco:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_filesystem_' \
  | head
```

### Advertencia importante

No todas las métricas representan porcentajes.

Ejemplos:

```text
node_cpu_seconds_total
```

Es un contador acumulado en segundos.

```text
node_memory_MemAvailable_bytes
```

Es una cantidad de memoria disponible expresada en bytes.

```text
node_load1
```

Representa la carga media del sistema durante un minuto.

---

## Parte 5 — Muestreo

**Duración:** 20 minutos.

### Explicación

El intervalo de muestreo indica cada cuánto se recopila una métrica.

Ejemplos:

- Cada 5 segundos.
- Cada 15 segundos.
- Cada 30 segundos.
- Cada 1 minuto.

Un intervalo corto permite observar cambios rápidos, pero genera más datos.

Un intervalo largo reduce el almacenamiento, pero puede ocultar picos breves.

### Ejemplo

Supón que la CPU cambia así:

```text
Hora      CPU
10:00     20 %
10:01     25 %
10:02     95 %
10:03     30 %
10:04     28 %
```

Si recogemos datos cada minuto, detectamos el pico.

Pero si recogemos datos cada cinco minutos, podríamos obtener:

```text
10:00     28 %
10:05     30 %
```

El pico del 95 % habría desaparecido de la observación.

### Actividad

Pide al alumnado que responda:

1. ¿Qué intervalo usarías para monitorizar una CPU?
2. ¿Qué intervalo usarías para comprobar disponibilidad?
3. ¿Qué intervalo usarías para observar una cola de mensajes?
4. ¿Qué problema tiene utilizar siempre un intervalo de un segundo?

Respuestas razonables:

- CPU: entre 5 y 15 segundos.
- Disponibilidad: entre 15 y 60 segundos.
- Cola de mensajes: depende de la velocidad de cambio.
- Un segundo: aumenta el volumen de datos, el coste y la carga de consulta.

### Configuración de ejemplo

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

Puedes mostrarla con:

```bash
sudo grep -n "interval" /etc/prometheus/prometheus.yml
```

---

## Parte 6 — Retención y downsampling

**Duración:** 20 minutos.

### Retención

La retención indica cuánto tiempo se conservan los datos.

Ejemplos:

- 24 horas.
- 15 días.
- 90 días.
- 1 año.

La retención debe equilibrar:

- Necesidad de análisis histórico.
- Espacio disponible.
- Rendimiento.
- Requisitos legales o de auditoría.

### Pregunta para el alumnado

> ¿Necesitamos guardar con resolución de cinco segundos todos los datos de los últimos cinco años?

La respuesta habitual es no.

Para los datos recientes puede ser útil una resolución alta. Para los datos antiguos suele bastar con una visión agregada.

### Downsampling

El *downsampling* consiste en reducir la resolución de los datos históricos.

Ejemplo:

```text
Datos recientes:
  Un valor cada 15 segundos

Datos antiguos:
  Un valor medio cada 5 minutos
```

Se pueden calcular:

- Media.
- Mínimo.
- Máximo.
- Percentiles.
- Número de eventos.

### Ejemplo conceptual

Datos originales:

```text
10:00:00  20
10:00:15  22
10:00:30  25
10:00:45  30
10:01:00  28
```

Agregación de un minuto:

```text
10:00      media: 25
```

La agregación ocupa menos espacio, pero ya no conserva cada valor individual.

---

## Parte 7 — Grafana y las fuentes de datos

**Duración:** 20 minutos.

### Explicación

Grafana no suele ser el sistema que recopila directamente las métricas. Su función principal es:

- Conectarse a una fuente de datos.
- Ejecutar consultas.
- Mostrar resultados.
- Crear paneles.
- Configurar alertas y dashboards.

El flujo habitual es:

```text
Node Exporter
      ↓
Prometheus
      ↓
Consulta PromQL
      ↓
Grafana
      ↓
Panel visual
```

### Demostración en Grafana

En Grafana:

1. Accede a la interfaz web.
2. Abre **Connections**.
3. Selecciona **Data sources**.
4. Abre la fuente de datos de Prometheus.
5. Ejecuta **Save & test**.
6. Comprueba que la conexión funciona.

La URL puede ser:

```text
http://localhost:9090
```

o:

```text
http://127.0.0.1:9090
```

### Primera consulta PromQL

En **Explore**, selecciona Prometheus y ejecuta:

```promql
up
```

Interpretación:

```text
up = 1
```

El objetivo está disponible.

```text
up = 0
```

El objetivo está configurado, pero no responde correctamente.

### Otras consultas

Carga de sistema:

```promql
node_load1
```

Memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Tiempo desde el arranque:

```promql
node_time_seconds - node_boot_time_seconds
```

CPU aproximada utilizada:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Aclara que esta última consulta utiliza `rate` porque `node_cpu_seconds_total` es un contador acumulado.

---

# 4. Práctica guiada para el alumnado

## Práctica 1 — Identificar el estado del sistema

**Duración:** 20 minutos.

Cada alumno ejecutará:

```bash
hostname
uptime
free -h
df -h
ip -br addr
```

Debe registrar:

| Dato | Resultado |
|---|---|
| Nombre del equipo | |
| Tiempo encendido | |
| Carga del sistema | |
| Memoria total | |
| Memoria disponible | |
| Espacio libre en `/` | |
| Dirección IP | |

### Interpretación

El alumnado debe responder:

- ¿Cuánto tiempo lleva encendido el sistema?
- ¿La carga parece elevada?
- ¿Cuánta memoria está disponible?
- ¿Qué porcentaje del disco está ocupado?
- ¿Qué datos son métricas?
- ¿Qué datos son información de configuración?

---

## Práctica 2 — Consultar Node Exporter

Comprobar el servicio:

```bash
systemctl is-active node-exporter
```

Comprobar el endpoint:

```bash
curl -I http://127.0.0.1:9100/metrics
```

La respuesta esperada:

```text
HTTP/1.1 200 OK
```

Contar las métricas expuestas:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep -v '^#' \
  | wc -l
```

Buscar métricas concretas:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_load'
```

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_filesystem_avail_bytes'
```

### Entrega

Cada alumno debe seleccionar tres métricas y documentarlas:

```text
Nombre:
Tipo:
Valor:
Etiquetas:
Unidad:
Qué representa:
```

---

## Práctica 3 — Consultar Prometheus

Acceder a:

```text
http://localhost:9090
```

Ejecutar estas consultas:

```promql
up
```

```promql
node_load1
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

```promql
count(node_cpu_seconds_total)
```

### Preguntas

1. ¿Cuántos objetivos están activos?
2. ¿Qué valor tiene la carga de un minuto?
3. ¿Cuánta memoria está disponible?
4. ¿Qué sistemas de ficheros aparecen?
5. ¿Cuántas series de CPU existen?

---

## Práctica 4 — Crear una visualización en Grafana

En Grafana:

1. Abrir **Dashboards**.
2. Crear un dashboard nuevo.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Ejecutar esta consulta:

```promql
node_load1
```

6. Seleccionar la visualización **Time series**.
7. Añadir un título:

```text
Carga media del sistema
```

8. Guardar el dashboard.

Crear un segundo panel con:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Título:

```text
Uso estimado de CPU
```

Crear un tercer panel:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Título:

```text
Memoria utilizada
```

---

# 5. Sesión de comprobación para el docente

Antes de la clase, comprueba que todo funciona.

## Comprobar servicios

```bash
systemctl is-active prometheus
systemctl is-active node-exporter
systemctl is-active grafana-server
```

Los tres deberían devolver:

```text
active
```

## Comprobar puertos

```bash
sudo ss -tulpn | grep -E ':3000|:9090|:9100'
```

Resultado esperado aproximado:

```text
LISTEN ... :3000 ... grafana
LISTEN ... :9090 ... prometheus
LISTEN ... :9100 ... node_exporter
```

## Comprobar endpoints

```bash
curl -I http://127.0.0.1:3000
curl -I http://127.0.0.1:9090
curl -I http://127.0.0.1:9100/metrics
```

## Comprobar Prometheus

```bash
curl -s http://127.0.0.1:9090/-/ready
```

Respuesta esperada:

```text
Prometheus Server is Ready.
```

## Comprobar Node Exporter

```bash
curl -s http://127.0.0.1:9100/metrics | head
```

Debe devolver líneas similares a:

```text
# HELP go_gc_duration_seconds A summary of the pause duration...
# TYPE go_gc_duration_seconds summary
```

## Comprobar Grafana

```bash
curl -s -o /dev/null -w "%{http_code}\n" \
  http://127.0.0.1:3000/login
```

Respuesta esperada:

```text
200
```

---

# 6. Problemas frecuentes durante la práctica

## Node Exporter no responde

Comprobar:

```bash
systemctl status node-exporter
```

Revisar el puerto:

```bash
sudo ss -tulpn | grep 9100
```

Consultar logs:

```bash
sudo journalctl -u node-exporter -n 50 --no-pager
```

## Prometheus muestra `up = 0`

Comprobar el endpoint desde el servidor Prometheus:

```bash
curl -I http://127.0.0.1:9100/metrics
```

Revisar la configuración:

```bash
sudo grep -n -A8 -B2 "node" \
  /etc/prometheus/prometheus.yml
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reiniciar Prometheus después de modificarla:

```bash
sudo systemctl restart prometheus
```

## Grafana no muestra datos

Comprobar:

1. Que Prometheus está activo.
2. Que Node Exporter responde.
3. Que `up` devuelve `1`.
4. Que la URL de la fuente de datos es correcta.
5. Que el intervalo temporal incluye datos recientes.
6. Que la consulta no contiene etiquetas incorrectas.

## Los valores parecen demasiado grandes

Explicar las unidades:

- Bytes: dividir por $$1024$$ para KiB, $$1024^2$$ para MiB.
- Segundos acumulados: utilizar `rate`.
- Contadores: no interpretarlos directamente como valores instantáneos.
- Porcentajes: comprobar si el valor está entre $$0$$ y $$100$$.

---

# 7. Actividad de cierre y evaluación

## Preguntas de repaso

1. ¿Qué diferencia existe entre una métrica y un log?
2. ¿Quién inicia la comunicación en el modelo pull?
3. ¿Qué representa una etiqueta?
4. ¿Por qué una métrica puede tener varias series temporales?
5. ¿Qué ocurre si el intervalo de muestreo es demasiado grande?
6. ¿Qué problema resuelve la retención?
7. ¿Qué objetivo tiene el downsampling?
8. ¿Qué función cumple Grafana?
9. ¿Qué indica `up = 1`?
10. ¿Por qué se utiliza `rate` con algunas métricas de CPU?

## Actividad final

Cada alumno debe entregar:

```text
1. Tres métricas obtenidas desde Node Exporter.
2. Una explicación de sus etiquetas.
3. Una consulta PromQL.
4. Una captura o descripción de un panel de Grafana.
5. Una conclusión sobre el estado del sistema.
```

### Ejemplo de conclusión

> El sistema monitorizado está disponible porque la consulta `up` devuelve `1`. La carga media se mantiene estable y la memoria disponible no presenta una reducción significativa. La métrica `node_cpu_seconds_total` es un contador acumulado, por lo que se ha utilizado `rate` para calcular una velocidad de consumo durante los últimos cinco minutos.