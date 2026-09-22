# Muestreo de datos

## Objetivos

Al finalizar esta sección podrás:

- Explicar qué significa muestrear una métrica.
- Comprender la relación entre el intervalo de muestreo y la resolución de los datos.
- Elegir un intervalo de scraping adecuado para distintos tipos de métricas.
- Identificar los efectos de un muestreo demasiado frecuente o demasiado espaciado.
- Diferenciar entre muestreo, agregación y downsampling.
- Reconocer problemas como el aliasing, los datos ausentes y los cambios breves.
- Aplicar buenas prácticas de muestreo en Prometheus y Grafana.

## Introducción

El **muestreo de datos** consiste en medir o registrar una señal en determinados momentos, en lugar de observarla continuamente.

En monitorización, los sistemas no almacenan todos los cambios internos que ocurren en una aplicación o servidor. En su lugar, realizan mediciones periódicas.

Por ejemplo, un sistema puede registrar el uso de CPU cada 15 segundos:

```text
10:00:00 → 21 %
10:00:15 → 28 %
10:00:30 → 35 %
10:00:45 → 31 %
```

Cada registro es una muestra.

El intervalo entre dos muestras consecutivas se denomina **intervalo de muestreo**. En este ejemplo es de 15 segundos.

El muestreo permite controlar:

- La cantidad de datos almacenados.
- El consumo de red.
- La carga sobre los agentes y exporters.
- La precisión temporal de los gráficos.
- La capacidad para detectar cambios rápidos.
- El coste de las consultas y del almacenamiento.

Un intervalo demasiado largo puede ocultar eventos breves. Un intervalo demasiado corto puede generar más datos de los necesarios y aumentar el consumo de recursos.

## Contenido

### ¿Qué es una muestra?

Una muestra es un valor de una métrica registrado en un instante concreto.

Conceptualmente, una muestra contiene:

```text
Nombre de métrica + etiquetas + marca temporal + valor
```

Por ejemplo:

```text
node_memory_MemAvailable_bytes{
  instance="192.168.1.50:9100",
  job="node"
} 4294967296 10:00:00
```

En este caso:

- La métrica es `node_memory_MemAvailable_bytes`.
- La instancia es `192.168.1.50:9100`.
- El trabajo es `node`.
- El valor es `4294967296` bytes.
- La muestra se registró a las `10:00:00`.

Una secuencia de muestras forma una serie temporal.

### Intervalo de muestreo

El intervalo de muestreo es el tiempo que transcurre entre dos mediciones.

Si un sistema recopila datos cada 15 segundos:

```text
Intervalo de muestreo: 15 segundos
Frecuencia aproximada: 4 muestras por minuto
```

Si recopila datos cada 60 segundos:

```text
Intervalo de muestreo: 60 segundos
Frecuencia aproximada: 1 muestra por minuto
```

Un intervalo más corto proporciona más detalle temporal, pero también produce más muestras.

Un intervalo más largo reduce el volumen de datos, pero puede ocultar variaciones rápidas.

### Frecuencia de muestreo

La frecuencia de muestreo indica cuántas muestras se registran durante un periodo de tiempo.

Por ejemplo:

| Intervalo | Muestras aproximadas por minuto | Muestras aproximadas por hora |
|---|---:|---:|
| 5 segundos | 12 | 720 |
| 15 segundos | 4 | 240 |
| 30 segundos | 2 | 120 |
| 60 segundos | 1 | 60 |
| 5 minutos | 0,2 | 12 |

Estas cifras son aproximadas y suponen que no existen errores de recopilación.

Aumentar la frecuencia de muestreo implica:

- Más solicitudes HTTP.
- Más datos transferidos.
- Más muestras almacenadas.
- Más consumo de CPU y memoria.
- Mayor coste en consultas y compactación.

### Muestreo en Prometheus

Prometheus realiza el muestreo mediante el proceso de **scraping**.

Durante un scraping:

1. Prometheus selecciona un objetivo.
2. Solicita su endpoint de métricas.
3. Recibe los valores actuales.
4. Añade una marca temporal.
5. Almacena las muestras.
6. Repite el proceso después del intervalo configurado.

Una configuración básica sería:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node"
    static_configs:
      - targets:
          - "192.168.1.50:9100"
```

La propiedad:

```yaml
scrape_interval: 15s
```

indica que Prometheus intentará recopilar las métricas cada 15 segundos.

También se puede configurar un intervalo específico para un trabajo:

```yaml
global:
  scrape_interval: 30s

scrape_configs:
  - job_name: "node"
    scrape_interval: 15s
    static_configs:
      - targets:
          - "192.168.1.50:9100"

  - job_name: "aplicacion"
    scrape_interval: 5s
    static_configs:
      - targets:
          - "192.168.1.60:8080"
```

En este ejemplo:

- El intervalo general es de 30 segundos.
- Node Exporter se consulta cada 15 segundos.
- La aplicación se consulta cada 5 segundos.

Conviene utilizar intervalos específicos únicamente cuando existe una razón operativa. Configurar todos los trabajos con el intervalo mínimo suele generar datos innecesarios.

### Cómo elegir el intervalo adecuado

El intervalo debe depender de la velocidad de cambio de la métrica y de la importancia de detectar variaciones rápidas.

#### Métricas de infraestructura

Para CPU, memoria, disco y red, suelen ser adecuados intervalos como:

```text
15-30 segundos
```

Estos valores proporcionan un nivel de detalle suficiente para muchas tareas de monitorización.

#### Estado de servicios

Para comprobar si un servicio está disponible, puede utilizarse:

```text
15-60 segundos
```

Si el servicio es crítico y se necesita detectar rápidamente una interrupción, puede ser conveniente un intervalo menor.

#### Aplicaciones de alta actividad

En aplicaciones con muchas solicitudes o cambios rápidos, puede utilizarse:

```text
5-15 segundos
```

Debe verificarse que la aplicación y Prometheus soportan la carga adicional.

#### Trabajos por lotes

Para trabajos que se ejecutan durante mucho tiempo, puede ser suficiente:

```text
30-60 segundos
```

Para trabajos muy breves, el scraping puede no capturar su ejecución. En esos casos pueden utilizarse métricas persistentes o una solución como Pushgateway, aplicando una política adecuada de limpieza.

#### Métricas poco cambiantes

Para valores que cambian lentamente, como la capacidad total de un disco, puede ser suficiente:

```text
1-5 minutos
```

No tiene sentido consultar cada cinco segundos una métrica que solo cambia una vez al día, salvo que exista una necesidad específica.

### Muestreo uniforme y no uniforme

Un muestreo es **uniforme** cuando las muestras se registran aproximadamente con el mismo intervalo.

Ejemplo:

```text
10:00:00
10:00:15
10:00:30
10:00:45
```

Un muestreo es **no uniforme** cuando los intervalos son variables:

```text
10:00:00
10:00:17
10:00:31
10:00:52
```

En sistemas reales, el muestreo puede no ser perfectamente uniforme debido a:

- Carga del servidor.
- Latencia de red.
- Tiempo de respuesta del exporter.
- Reinicios.
- Errores de scraping.
- Problemas de programación de tareas.
- Interrupciones temporales.

Prometheus registra las marcas temporales de las muestras para que las consultas puedan tener en cuenta el momento real de cada valor.

### Detección de datos ausentes

Una recopilación puede fallar por diferentes motivos:

- El exporter está detenido.
- El objetivo no es accesible.
- El puerto está cerrado.
- La red tiene problemas.
- El endpoint tarda demasiado en responder.
- La configuración de Prometheus contiene una dirección incorrecta.
- El servicio devuelve una respuesta inválida.

La métrica:

```promql
up
```

permite comprobar si el último scraping de un objetivo tuvo éxito.

Para consultar el estado de los objetivos de Node Exporter:

```promql
up{job="node"}
```

Para detectar objetivos que no responden:

```promql
up == 0
```

También se puede calcular el porcentaje de disponibilidad de los objetivos:

```promql
100 * avg by (job) (up)
```

Cuando faltan muestras, un gráfico puede mostrar:

- Huecos.
- Líneas discontinuas.
- Valores antiguos.
- Cambios aparentemente bruscos.
- Alertas incorrectas si no se controla la ausencia de datos.

### Muestreo y eventos breves

Un intervalo de muestreo puede no detectar eventos que ocurren entre dos mediciones.

Supongamos que Prometheus consulta cada 60 segundos:

```text
10:00:00 → CPU normal
10:00:30 → Pico de CPU del 100 %
10:01:00 → CPU normal
```

Si solo se realizan mediciones a las `10:00:00` y `10:01:00`, el pico puede no registrarse.

Este problema es especialmente importante para:

- Picos de CPU.
- Latencias breves.
- Errores transitorios.
- Reinicios rápidos.
- Saturaciones momentáneas.
- Caídas de servicios de corta duración.

Para mejorar la detección se puede:

- Reducir el intervalo de scraping.
- Utilizar métricas basadas en contadores.
- Registrar máximos o acumulados.
- Generar eventos persistentes.
- Utilizar logs complementarios.
- Ajustar la duración de las alertas.
- Analizar ventanas de tiempo adecuadas.

### Teorema de Nyquist aplicado a monitorización

En procesamiento de señales, el teorema de Nyquist indica que la frecuencia de muestreo debe ser suficientemente alta para representar correctamente una señal.

Como regla conceptual, una señal debería muestrearse al menos dos veces por cada ciclo de variación que se desea observar.

En monitorización práctica, esta regla no siempre puede aplicarse de forma estricta porque:

- Muchas métricas no son señales periódicas.
- Los eventos pueden ser impredecibles.
- La prioridad suele ser detectar cambios operativos.
- El almacenamiento es limitado.
- Las métricas pueden representar acumulados y no señales continuas.

La idea importante es:

> Si una métrica puede cambiar significativamente entre dos muestras, el intervalo elegido puede ser demasiado largo.

Por ejemplo, si una aplicación puede pasar de funcionamiento normal a saturación y volver a la normalidad en 20 segundos, un intervalo de 60 segundos no será suficiente para observar todos esos cambios.

### Aliasing

El **aliasing** ocurre cuando el muestreo es insuficiente para representar correctamente una variación rápida.

Un sistema puede interpretar una señal rápida como si fuera más lenta, diferente o menos intensa.

En monitorización, esto puede provocar:

- Picos que parecen más pequeños.
- Oscilaciones que no aparecen.
- Variaciones rápidas que parecen estables.
- Lecturas que no representan el comportamiento real.

Para reducir este riesgo:

- Utiliza intervalos más cortos para métricas rápidas.
- No dependas de un único punto de medición.
- Usa contadores y funciones como `rate`.
- Complementa las métricas con logs y trazas.
- Conserva máximos o percentiles cuando sea necesario.

### Intervalo de scraping frente a intervalo de evaluación

En Prometheus existen dos conceptos diferentes:

- **Scrape interval**: frecuencia con la que se recopilan las métricas.
- **Evaluation interval**: frecuencia con la que se evalúan las reglas de grabación y alerta.

Una configuración puede ser:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

El scraping recopila los datos cada 15 segundos.

La evaluación comprueba las reglas cada 15 segundos.

También podrían utilizarse valores diferentes:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 30s
```

En este caso:

- Las métricas se recopilan cada 15 segundos.
- Las reglas se evalúan cada 30 segundos.

Si una alerta depende de detectar rápidamente un evento, ambos intervalos deben revisarse conjuntamente.

### Muestreo y duración de las alertas

El intervalo de muestreo influye directamente en la rapidez con la que puede activarse una alerta.

Por ejemplo:

```yaml
groups:
  - name: sistema
    rules:
      - alert: CPUAlta
        expr: |
          100 *
          (
            1 -
            avg by (instance) (
              rate(node_cpu_seconds_total{
                mode="idle"
              }[5m])
            )
          ) > 80
        for: 2m
```

Esta alerta:

- Consulta el uso de CPU mediante una ventana de cinco minutos.
- Se activa cuando el resultado supera el 80 %.
- Requiere que la condición se mantenga durante dos minutos.

Si el scraping se realiza cada 15 segundos, durante dos minutos se obtendrán aproximadamente ocho muestras.

La condición `for` ayuda a evitar alertas provocadas por cambios breves o valores aislados.

Sin embargo, una duración excesiva puede retrasar la detección de incidentes reales. La configuración debe reflejar el comportamiento esperado del sistema.

### Muestreo, agregación y downsampling

Estos conceptos están relacionados, pero no son equivalentes.

#### Muestreo

Consiste en tomar mediciones en determinados instantes.

Ejemplo:

```text
Registrar el uso de CPU cada 15 segundos.
```

#### Agregación

Consiste en combinar varios valores para obtener un resultado resumido.

Ejemplos:

```text
Calcular la media de CPU.
Calcular el máximo de latencia.
Sumar las solicitudes de todas las instancias.
```

#### Downsampling

Consiste en reducir la resolución de datos ya existentes.

Por ejemplo:

```text
Datos originales: una muestra cada 15 segundos.
Datos resumidos: una muestra media cada 5 minutos.
```

El downsampling puede ayudar a consultar periodos largos sin procesar todas las muestras originales.

Una consulta PromQL que calcula una media en una ventana de tiempo es:

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Una consulta que calcula el máximo durante una ventana es:

```promql
max_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Estas funciones resumen los valores de una ventana, pero no sustituyen necesariamente a un sistema permanente de downsampling.

### Muestreo en Grafana

Grafana puede ajustar la cantidad de puntos solicitados a Prometheus según:

- El intervalo de tiempo seleccionado.
- El ancho del panel.
- La resolución configurada.
- El intervalo mínimo de consulta.
- La función utilizada en la consulta.

Por ejemplo, un panel que muestra las últimas dos horas puede utilizar muchos puntos. Si se amplía el periodo a un año, representar todas las muestras originales sería innecesario y costoso.

Grafana puede enviar consultas con una resolución adaptada al periodo mostrado.

Aun así, el intervalo de scraping original sigue siendo importante. Grafana no puede recuperar un pico que nunca fue registrado por Prometheus.

Esta es una idea fundamental:

> La visualización puede resumir datos existentes, pero no puede reconstruir información que no se muestreó.

### Muestreo y almacenamiento

El número de muestras almacenadas depende de varios factores:

- Número de objetivos.
- Número de métricas por objetivo.
- Número de etiquetas.
- Cardinalidad.
- Intervalo de scraping.
- Tiempo de retención.
- Número de trabajos configurados.

Reducir el intervalo de scraping aumenta rápidamente el volumen de datos.

Antes de utilizar un intervalo muy corto conviene comprobar:

- El número de series activas.
- El consumo de memoria.
- El uso de disco.
- La duración de las consultas.
- La carga sobre los exporters.
- La capacidad de crecimiento del sistema.

No todas las métricas necesitan la misma resolución. Una configuración por trabajos suele ser más eficiente que aplicar el intervalo más pequeño a todo el sistema.

## Ejemplo

### Comparar distintos intervalos de muestreo

Supongamos que queremos monitorizar el uso de CPU de un servidor.

#### Configuración con 60 segundos

```yaml
global:
  scrape_interval: 60s

scrape_configs:
  - job_name: "node"
    static_configs:
      - targets:
          - "192.168.1.50:9100"
```

Ventajas:

- Menor volumen de datos.
- Menor tráfico de red.
- Menor carga sobre Prometheus.

Inconvenientes:

- Puede ocultar picos breves.
- Las alertas pueden tardar más.
- Los gráficos tienen menos detalle.

#### Configuración con 15 segundos

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node"
    static_configs:
      - targets:
          - "192.168.1.50:9100"
```

Ventajas:

- Mejor visibilidad de los cambios.
- Detección más rápida de problemas.
- Más detalle en los gráficos.

Inconvenientes:

- Mayor cantidad de datos.
- Más solicitudes de scraping.
- Mayor consumo de recursos.

#### Configuración con intervalos diferenciados

Una opción equilibrada sería:

```yaml
global:
  scrape_interval: 30s

scrape_configs:
  - job_name: "node"
    scrape_interval: 15s
    static_configs:
      - targets:
          - "192.168.1.50:9100"

  - job_name: "servicio-estable"
    scrape_interval: 60s
    static_configs:
      - targets:
          - "192.168.1.60:8080"

  - job_name: "aplicacion-critica"
    scrape_interval: 5s
    static_configs:
      - targets:
          - "192.168.1.70:9090"
```

En este diseño:

- El valor general es de 30 segundos.
- El servidor recibe una supervisión más frecuente.
- El servicio estable utiliza menos recursos.
- La aplicación crítica se observa cada cinco segundos.

### Detectar un objetivo sin muestras recientes

Para comprobar si un objetivo está disponible:

```promql
up{job="node"}
```

Para encontrar objetivos que no responden:

```promql
up{job="node"} == 0
```

Para detectar objetivos que no han tenido un valor correcto durante los últimos cinco minutos:

```promql
max_over_time(
  up{job="node"}[5m]
) == 0
```

Esta última consulta indica que el objetivo no ha tenido ningún valor igual a `1` durante la ventana analizada.

Una regla de alerta podría ser:

```yaml
groups:
  - name: objetivos
    rules:
      - alert: ExporterNoDisponible
        expr: up{job="node"} == 0
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "Exporter no disponible"
          description: "El objetivo {{ $labels.instance }} no responde."
```

El campo:

```yaml
for: 2m
```

evita generar una alerta por un único fallo momentáneo.

### Detectar un pico de CPU

Con un intervalo de scraping de 15 segundos, se puede calcular el uso de CPU con una ventana de cinco minutos:

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

Para obtener el máximo uso observado durante los últimos cinco minutos:

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
  )[5m:]
)
```

La consulta permite buscar el valor máximo calculado dentro de la ventana seleccionada.

Para una alerta:

```yaml
groups:
  - name: rendimiento
    rules:
      - alert: CPUAlta
        expr: |
          100 *
          (
            1 -
            avg by (instance) (
              rate(node_cpu_seconds_total{
                mode="idle"
              }[5m])
            )
          ) > 85
        for: 3m
        labels:
          severity: warning
        annotations:
          summary: "Uso elevado de CPU"
          description: "La CPU de {{ $labels.instance }} supera el 85 %."
```

Esta regla no reacciona a una muestra aislada. Exige que la condición se mantenga durante tres minutos.

### Diseñar el muestreo para una aplicación

Supongamos una aplicación web con estas necesidades:

- Detectar caídas rápidamente.
- Medir solicitudes por segundo.
- Analizar latencias.
- Mantener controlado el almacenamiento.

Una posible configuración sería:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "aplicacion-web"
    scrape_interval: 10s
    static_configs:
      - targets:
          - "app-01:8080"
          - "app-02:8080"
```

Las métricas podrían incluir:

```text
http_requests_total
http_request_duration_seconds
up
process_resident_memory_bytes
```

Consultas de ejemplo:

```promql
sum by (status) (
  rate(http_requests_total[5m])
)
```

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

```promql
up{job="aplicacion-web"}
```

En este escenario:

- El intervalo de 10 segundos mejora la detección de caídas.
- `rate` suaviza las variaciones de los contadores.
- El histograma permite estudiar la latencia.
- Las etiquetas deben estar limitadas a valores controlados.
- Grafana puede representar los datos con una resolución adecuada al periodo seleccionado.

## Puntos clave

- Muestrear consiste en registrar una métrica en momentos determinados.
- Cada muestra contiene un valor y una marca temporal.
- El intervalo de muestreo determina la separación entre muestras.
- Un intervalo corto ofrece más detalle, pero genera más datos.
- Un intervalo largo reduce el consumo, pero puede ocultar cambios rápidos.
- Prometheus realiza el muestreo mediante scraping.
- `scrape_interval` define con qué frecuencia se consultan los objetivos.
- No todas las métricas necesitan el mismo intervalo de muestreo.
- Los datos ausentes pueden indicar fallos de red, exporters detenidos o problemas de configuración.
- La métrica `up` permite comprobar el resultado del último scraping.
- Los eventos breves pueden no detectarse si ocurren entre dos muestras.
- El aliasing aparece cuando el muestreo es insuficiente para representar una variación rápida.
- Grafana puede resumir datos existentes, pero no recuperar eventos que nunca fueron registrados.
- El muestreo no es lo mismo que la agregación ni que el downsampling.
- El intervalo de evaluación de reglas puede ser distinto del intervalo de scraping.
- Las alertas deben combinar el intervalo de muestreo con una duración `for` adecuada.
- Aumentar la frecuencia de muestreo incrementa el consumo de red, CPU, memoria y almacenamiento.
- La mejor configuración suele utilizar intervalos diferentes según la importancia y velocidad de cambio de cada métrica.

## Preguntas de comprobación

1. ¿Qué es una muestra?
2. ¿Qué diferencia existe entre una muestra y una serie temporal?
3. ¿Qué representa el intervalo de muestreo?
4. ¿Qué ocurre si se reduce el intervalo de scraping?
5. ¿Qué ventajas tiene utilizar un intervalo de muestreo corto?
6. ¿Qué inconvenientes tiene utilizar un intervalo de muestreo demasiado corto?
7. ¿Qué puede ocurrir si el intervalo de muestreo es demasiado largo?
8. ¿Qué propiedad de Prometheus define la frecuencia de scraping?
9. ¿Cómo se puede comprobar si un objetivo respondió correctamente?
10. ¿Por qué un evento breve puede no aparecer en Prometheus?
11. ¿Qué es el aliasing?
12. ¿Qué diferencia existe entre `scrape_interval` y `evaluation_interval`?
13. ¿Qué función cumple el campo `for` en una regla de alerta?
14. ¿Qué diferencia existe entre muestreo, agregación y downsampling?
15. ¿Puede Grafana mostrar un pico que Prometheus nunca registró?
16. ¿Por qué no todas las métricas deberían tener el mismo intervalo de scraping?
17. ¿Qué factores influyen en el volumen de datos almacenados?
18. ¿Qué consulta permite detectar objetivos que no responden?
19. ¿Por qué una métrica basada en un contador puede ser útil para detectar actividad entre muestras?
20. ¿Qué criterios utilizarías para elegir el intervalo de muestreo de una aplicación crítica?
```