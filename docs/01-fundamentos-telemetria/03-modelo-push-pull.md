# Modelo push y pull

## Objetivos

Al finalizar esta sección podrás:

- Explicar las diferencias entre los modelos **push** y **pull**.
- Identificar qué componente inicia la comunicación en cada modelo.
- Comprender cómo recopila Prometheus las métricas.
- Reconocer cuándo puede ser conveniente utilizar cada modelo.
- Identificar las ventajas y limitaciones de `Pushgateway`.
- Analizar ejemplos sencillos de configuración y consulta.

## Introducción

En un sistema de monitorización existen varias formas de transportar las métricas desde el sistema observado hasta la plataforma que las almacena y visualiza.

Los dos modelos más habituales son:

- **Pull**: el sistema de monitorización solicita las métricas periódicamente.
- **Push**: el sistema observado envía las métricas al sistema de monitorización.

La diferencia principal está en **quién inicia la comunicación**.

En el modelo *pull*, el servidor de monitorización pregunta:

> «¿Qué métricas tienes ahora?»

En el modelo *push*, el sistema observado envía los datos:

> «Estas son mis métricas actuales».

Prometheus utiliza normalmente el modelo **pull**, aunque puede integrarse con sistemas externos que utilizan *push*.

## Contenido

### Modelo pull

En el modelo *pull*, el sistema central de monitorización consulta periódicamente los componentes supervisados.

En una arquitectura típica con Prometheus:

1. Prometheus inicia la conexión.
2. Consulta el endpoint HTTP de métricas.
3. El servicio devuelve los valores actuales.
4. Prometheus almacena las métricas junto con sus etiquetas.
5. Grafana consulta posteriormente los datos almacenados.

El flujo puede representarse así:

```text
Prometheus ──────── consulta ────────> Exporter
Prometheus <─────── métricas ───────── Exporter
```

Un endpoint de métricas suele estar disponible en una ruta como:

```text
http://servidor:9100/metrics
```

Por ejemplo, **Node Exporter** expone métricas relacionadas con:

- CPU.
- Memoria.
- Sistema de archivos.
- Red.
- Carga del sistema.
- Procesos.
- Tiempo de actividad.

#### Ventajas del modelo pull

- Prometheus controla la frecuencia de recopilación.
- Es sencillo comprobar si un objetivo está disponible.
- Se puede detectar que un servicio deja de responder.
- La configuración de scraping está centralizada.
- El sistema observado no necesita conocer dónde está Prometheus.
- Es fácil consultar manualmente el endpoint de métricas.

#### Limitaciones del modelo pull

- Prometheus debe poder alcanzar el objetivo por red.
- Puede ser complicado monitorizar sistemas detrás de redes privadas.
- Los trabajos muy breves pueden terminar antes de ser consultados.
- Es necesario mantener una configuración de objetivos actualizada.

### Modelo push

En el modelo *push*, el sistema observado inicia la comunicación y envía las métricas hacia un receptor.

El flujo puede representarse así:

```text
Aplicación ──────── métricas ────────> Receptor
Aplicación <─────── respuesta ──────── Receptor
```

Un receptor puede ser:

- Un gateway de métricas.
- Un agente de monitorización.
- Un servicio de ingesta.
- Una API específica de observabilidad.

En este modelo, el productor decide cuándo enviar los datos y, en algunos casos, también decide qué métricas incluir.

#### Ventajas del modelo push

- Resulta útil cuando el receptor no puede acceder directamente al sistema observado.
- Se adapta bien a trabajos de corta duración.
- Puede funcionar en redes donde solo se permiten conexiones salientes.
- El sistema productor controla cuándo envía las métricas.
- Es habitual en determinadas arquitecturas serverless y de procesamiento por lotes.

#### Limitaciones del modelo push

- Puede ser más difícil saber si un productor ha dejado de enviar datos.
- Los datos pueden quedar obsoletos si no se controla su antigüedad.
- El productor debe conocer la dirección del receptor.
- Una mala configuración puede generar demasiadas solicitudes.
- Es necesario gestionar la autenticación y la disponibilidad del receptor.
- Puede complicar la deduplicación y el control de etiquetas.

### Comparación entre push y pull

| Característica | Modelo pull | Modelo push |
|---|---|---|
| Quién inicia la comunicación | El sistema de monitorización | El sistema observado |
| Ejemplo habitual | Prometheus consulta Node Exporter | Una aplicación envía métricas a un gateway |
| Control de frecuencia | Lo controla Prometheus | Lo controla el productor |
| Detección de disponibilidad | Suele ser directa mediante el scraping | Requiere controlar la antigüedad de los datos |
| Trabajos breves | Menos adecuado | Más adecuado |
| Redes privadas | Puede ser complicado | Puede ser más sencillo |
| Configuración | Centralizada en el monitor | Repartida entre los productores |
| Riesgo principal | No poder alcanzar el objetivo | No detectar que el productor dejó de enviar datos |

La elección del modelo depende de la red, la duración de los procesos, el nivel de control disponible y la arquitectura de la aplicación.

## Prometheus y el modelo pull

Prometheus está diseñado principalmente para trabajar con el modelo *pull*.

La configuración de los objetivos se realiza mediante `scrape_configs`. Por ejemplo:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node"
    static_configs:
      - targets:
          - "localhost:9100"
```

Esta configuración indica que Prometheus debe:

- Crear un trabajo llamado `node`.
- Consultar el objetivo `localhost:9100`.
- Acceder normalmente a su endpoint `/metrics`.
- Recopilar las métricas cada 15 segundos.

Una vez recopiladas, las métricas se almacenan como series temporales.

Por ejemplo:

```text
node_cpu_seconds_total{instance="localhost:9100",mode="idle"}
```

El valor de la métrica representa el estado observado en un momento determinado.

### Comprobar un objetivo

Prometheus proporciona la métrica:

```promql
up
```

Su significado habitual es:

```text
up = 1
```

El objetivo respondió correctamente durante la última recopilación.

```text
up = 0
```

El objetivo no respondió correctamente durante la última recopilación.

También puede consultarse un objetivo concreto:

```promql
up{job="node"}
```

Para obtener el porcentaje de objetivos disponibles:

```promql
100 * avg(up)
```

## Pushgateway

**Pushgateway** permite que determinados procesos envíen métricas a un punto intermedio que posteriormente será consultado por Prometheus.

El flujo sería:

```text
Trabajo breve ─── push ───> Pushgateway <─── pull ─── Prometheus
```

Este modelo híbrido puede ser útil para:

- Trabajos programados.
- Scripts de mantenimiento.
- Procesos por lotes.
- Tareas que terminan antes del siguiente scraping.

Sin embargo, Pushgateway no debe utilizarse automáticamente para todas las métricas.

### Precauciones con Pushgateway

Las métricas enviadas a Pushgateway pueden permanecer almacenadas aunque el proceso original ya haya terminado o haya dejado de funcionar.

Por eso es importante:

- Eliminar métricas obsoletas.
- Utilizar etiquetas adecuadas.
- Evitar etiquetas con valores cambiantes constantemente.
- No usarlo como sustituto general del modelo pull.
- Controlar la antigüedad de los datos.
- Evitar generar una cantidad excesiva de series temporales.

Un ejemplo conceptual de envío sería:

```bash
echo 'backup_completed 1' \
  | curl --data-binary @- \
    http://pushgateway:9091/metrics/job/backup
```

La métrica enviada podría aparecer en Prometheus con etiquetas similares a:

```text
backup_completed{job="backup"}
```

El diseño exacto debe adaptarse al proceso y a la forma en que se desea identificar sus ejecuciones.

## Ejemplo

### Ejemplo con Node Exporter y Prometheus

Supongamos que tenemos un servidor Ubuntu con Node Exporter escuchando en el puerto `9100`.

Node Exporter expone las métricas en:

```text
http://localhost:9100/metrics
```

La configuración de Prometheus sería:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "servidor-ubuntu"
    static_configs:
      - targets:
          - "192.168.1.50:9100"
```

El flujo completo sería:

```text
Servidor Ubuntu
      │
      │ Node Exporter expone /metrics
      ▼
http://192.168.1.50:9100/metrics
      ▲
      │ Prometheus consulta cada 15 segundos
      │
Prometheus
      │
      │ PromQL
      ▼
Grafana
```

Una consulta básica para comprobar el estado del objetivo sería:

```promql
up{job="servidor-ubuntu"}
```

Para calcular el uso aproximado de CPU:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      job="servidor-ubuntu",
      mode="idle"
    }[5m])
  )
)
```

En este caso:

- Node Exporter no envía activamente los datos a Prometheus.
- Prometheus inicia la conexión.
- Prometheus recopila las métricas mediante scraping.
- Grafana consulta Prometheus para representarlas.

### Ejemplo conceptual con un trabajo breve

Imaginemos un script que realiza una copia de seguridad y termina en pocos segundos.

Si Prometheus consulta cada 15 segundos, puede ocurrir que el trabajo comience y finalice entre dos consultas. En ese caso, Prometheus podría no llegar a observarlo.

Una alternativa sería enviar una métrica al finalizar:

```text
backup_completed 1
```

El flujo sería:

```text
Script de backup ─── push ───> Pushgateway
                                  ▲
                                  │ pull
                                  │
                              Prometheus
```

Para que este diseño sea fiable, también habría que registrar información como:

- Hora de finalización.
- Nombre del trabajo.
- Servidor que lo ejecutó.
- Resultado de la ejecución.
- Duración.
- Estado de éxito o error.

Por ejemplo:

```text
backup_last_success_timestamp_seconds
backup_duration_seconds
backup_failed
```

Una métrica de éxito aislada no siempre es suficiente. También debe controlarse si el valor sigue siendo reciente.

## Puntos clave

- En el modelo **pull**, el sistema de monitorización solicita las métricas.
- En el modelo **push**, el sistema observado envía las métricas.
- Prometheus utiliza principalmente el modelo pull.
- Node Exporter expone métricas; Prometheus las recopila.
- La métrica `up` permite comprobar si un objetivo respondió correctamente.
- El modelo pull facilita el control centralizado de la frecuencia de scraping.
- El modelo push puede ser útil para trabajos breves o redes con conexiones salientes.
- Pushgateway combina el envío desde el productor con la consulta posterior de Prometheus.
- Pushgateway no debe utilizarse como sustituto universal del modelo pull.
- Las métricas enviadas deben tener etiquetas estables y una política clara de limpieza.
- Es importante controlar la antigüedad de los datos en cualquier arquitectura basada en push.
- Una arquitectura de monitorización puede combinar ambos modelos según las necesidades de cada componente.

## Preguntas de comprobación

1. ¿Quién inicia la comunicación en el modelo pull?
2. ¿Quién inicia la comunicación en el modelo push?
3. ¿Qué modelo utiliza normalmente Prometheus?
4. ¿Qué función cumple Node Exporter?
5. ¿Qué representa el valor `up = 1` en Prometheus?
6. ¿Qué representa el valor `up = 0`?
7. ¿Por qué un trabajo de corta duración puede no ser detectado mediante pull?
8. ¿Qué problema intenta resolver Pushgateway?
9. ¿Por qué las métricas almacenadas en Pushgateway pueden quedar obsoletas?
10. ¿Qué ventajas ofrece el modelo pull frente al modelo push?
11. ¿En qué tipo de red puede ser útil el modelo push?
12. ¿Qué precauciones deben tomarse al definir etiquetas en un sistema push?
13. ¿Qué componente consulta habitualmente el endpoint `/metrics` de Node Exporter?
14. ¿Qué componente puede utilizar PromQL para visualizar las métricas?
15. ¿Por qué no conviene utilizar Pushgateway para sustituir todas las recopilaciones de Prometheus?