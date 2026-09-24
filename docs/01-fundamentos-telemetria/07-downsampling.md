# Downsampling

## Objetivos

Al finalizar esta sección podrás:

- Explicar qué es el *downsampling* y por qué se utiliza.
- Diferenciar entre datos originales, agregación y reducción de resolución.
- Comprender cómo ayuda el *downsampling* a conservar históricos durante más tiempo.
- Identificar qué información puede perderse al reducir la resolución.
- Utilizar funciones PromQL para resumir datos en ventanas de tiempo.
- Crear reglas de grabación para almacenar resultados agregados.
- Comprender las limitaciones del *downsampling* nativo en Prometheus.
- Diseñar una estrategia de resolución diferente para datos recientes e históricos.

## Introducción

El **downsampling** consiste en reducir la cantidad o resolución de los datos almacenados, normalmente agrupando varias muestras originales en valores representativos.

Por ejemplo, una métrica puede recopilarse cada 15 segundos:

```text
10:00:00 → 20
10:00:15 → 24
10:00:30 → 31
10:00:45 → 29
10:01:00 → 35
```

Estos datos tienen una resolución de 15 segundos.

Mediante *downsampling*, pueden resumirse en una muestra cada minuto:

```text
10:00 → promedio: 26
10:01 → promedio: 34
```

La reducción de resolución permite:

- Disminuir el espacio de almacenamiento.
- Acelerar las consultas sobre periodos largos.
- Conservar históricos durante más tiempo.
- Reducir la cantidad de datos transferidos.
- Mejorar la visualización de tendencias.

Sin embargo, el *downsampling* también puede ocultar información. Un pico que duró pocos segundos puede desaparecer cuando se calcula un promedio de varios minutos.

Por este motivo, el *downsampling* debe aplicarse de forma planificada. Los datos recientes suelen conservarse con alta resolución, mientras que los datos antiguos pueden almacenarse con una resolución menor.

## Contenido

### Datos originales y datos reducidos

Supongamos que una métrica se recopila cada 15 segundos durante una hora.

El número aproximado de muestras será:

```text
60 minutos × 60 segundos / 15 segundos = 240 muestras
```

Si esos datos se resumen en intervalos de cinco minutos:

```text
60 minutos / 5 minutos = 12 muestras
```

El número de valores se reduce considerablemente:

```text
Datos originales: 240 muestras
Datos resumidos: 12 muestras
```

La reducción puede conservar diferentes valores representativos:

- Promedio.
- Mínimo.
- Máximo.
- Suma.
- Último valor.
- Percentil.
- Tasa media de cambio.

La función elegida depende del tipo de métrica y del objetivo del análisis.

### Por qué se utiliza

El *downsampling* resulta especialmente útil cuando se consultan periodos amplios.

Por ejemplo:

```text
Últimas 6 horas: resolución de 15 segundos
Últimos 30 días: resolución de 5 minutos
Últimos 12 meses: resolución de 1 hora
```

No suele ser necesario mostrar cada muestra de 15 segundos cuando se representa un año completo en una pantalla de pocos píxeles de ancho.

El *downsampling* permite conservar la tendencia general sin procesar todos los datos originales en cada consulta.

### Ventajas

Las principales ventajas son:

- **Menor consumo de almacenamiento**: se conservan menos muestras.
- **Consultas más rápidas**: hay menos datos que leer y procesar.
- **Menor tráfico de red**: se transfieren menos valores.
- **Históricos más largos**: se pueden conservar datos durante meses o años.
- **Mejor escalabilidad**: disminuye la presión sobre el sistema de métricas.
- **Visualizaciones más manejables**: los gráficos no necesitan procesar millones de puntos.

### Limitaciones

El *downsampling* no conserva toda la información original.

Puede provocar:

- Pérdida de picos breves.
- Pérdida de valores mínimos o máximos si no se almacenan explícitamente.
- Menor precisión temporal.
- Imposibilidad de investigar ciertos incidentes antiguos.
- Interpretaciones incorrectas si se utiliza la agregación inadecuada.
- Dificultades para calcular posteriormente algunos percentiles.

Por ejemplo, estos valores:

```text
10:00:00 → 10
10:00:15 → 10
10:00:30 → 100
10:00:45 → 10
```

tienen un promedio de:

```text
32,5
```

Si solo se conserva el promedio, puede parecer que existió una carga moderada y estable. Sin embargo, durante 15 segundos se produjo un pico del 100.

Para conservar mejor el comportamiento, también podrían almacenarse:

```text
Promedio: 32,5
Mínimo: 10
Máximo: 100
```

### Funciones de agregación

Las funciones de agregación combinan datos de varias series o muestras.

Algunas funciones habituales de PromQL son:

```promql
avg
```

Calcula el promedio.

```promql
min
```

Obtiene el valor mínimo.

```promql
max
```

Obtiene el valor máximo.

```promql
sum
```

Suma los valores.

```promql
count
```

Cuenta el número de series o elementos.

Ejemplos:

```promql
avg by (instance) (
  node_memory_MemAvailable_bytes
)
```

```promql
max by (instance) (
  node_load1
)
```

```promql
sum by (status) (
  rate(http_requests_total[5m])
)
```

La cláusula `by` indica las etiquetas que se conservarán en el resultado.

### Funciones sobre ventanas de tiempo

PromQL permite calcular valores resumidos sobre una ventana de tiempo.

#### Promedio

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Calcula el promedio de la memoria disponible durante los últimos cinco minutos.

#### Mínimo

```promql
min_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Obtiene el valor mínimo registrado durante la ventana.

#### Máximo

```promql
max_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Obtiene el valor máximo registrado durante la ventana.

#### Último valor

```promql
last_over_time(
  node_memory_MemAvailable_bytes[5m]
)
```

Devuelve el último valor disponible en la ventana.

#### Suma

```promql
sum_over_time(
  metric_name[5m]
)
```

Suma los valores registrados durante la ventana.

Esta función debe utilizarse con precaución. No siempre tiene sentido sumar directamente una métrica. En muchos casos es preferible utilizar `rate` o `increase`, especialmente con contadores.

### Promedio, mínimo y máximo

La función adecuada depende de la pregunta que se quiera responder.

| Objetivo | Agregación recomendada |
|---|---|
| Conocer el comportamiento medio | `avg_over_time` |
| Detectar picos | `max_over_time` |
| Detectar valores mínimos | `min_over_time` |
| Conocer el valor más reciente | `last_over_time` |
| Acumular valores | `sum_over_time` |
| Medir el incremento de un contador | `increase` |
| Medir la velocidad de un contador | `rate` |

Por ejemplo:

```promql
avg_over_time(
  node_load1[1h]
)
```

responde a:

> ¿Cuál fue la carga media durante la última hora?

En cambio:

```promql
max_over_time(
  node_load1[1h]
)
```

responde a:

> ¿Cuál fue el máximo de carga alcanzado durante la última hora?

No son intercambiables. El promedio es útil para tendencias, mientras que el máximo resulta más apropiado para detectar saturaciones.

### Downsampling de un gauge

Un *gauge* puede aumentar o disminuir. Algunos ejemplos son:

```text
node_memory_MemAvailable_bytes
node_load1
temperature_celsius
```

Para obtener el promedio de memoria disponible durante los últimos 15 minutos:

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[15m]
)
```

Para conservar el mínimo de memoria disponible:

```promql
min_over_time(
  node_memory_MemAvailable_bytes[15m]
)
```

Para detectar el pico de carga del sistema:

```promql
max_over_time(
  node_load1[15m]
)
```

En métricas de capacidad, conservar el mínimo puede ser más importante que conservar el promedio. Por ejemplo, una memoria disponible normalmente alta puede haber sufrido un descenso peligroso durante unos segundos.

### Downsampling de un counter

Un `counter` representa un valor acumulado que normalmente aumenta.

Ejemplos:

```text
http_requests_total
node_cpu_seconds_total
errors_total
```

Para calcular el incremento de solicitudes durante la última hora:

```promql
increase(
  http_requests_total[1h]
)
```

Para calcular la tasa media de solicitudes por segundo:

```promql
rate(
  http_requests_total[5m]
)
```

No se debe aplicar normalmente `avg_over_time` directamente sobre un contador para medir actividad. El valor absoluto del contador depende del tiempo que lleve funcionando el proceso.

Para guardar una tasa agregada por instancia:

```promql
sum by (instance) (
  rate(http_requests_total[5m])
)
```

Para obtener el número total de solicitudes por código de estado:

```promql
sum by (status) (
  increase(http_requests_total[1h])
)
```

### Downsampling de histogramas

Los histogramas se utilizan para analizar distribuciones, como la duración de las solicitudes.

Una métrica de histograma puede generar series como:

```text
http_request_duration_seconds_bucket
http_request_duration_seconds_sum
http_request_duration_seconds_count
```

Para calcular el percentil 95:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

Para estudiar un periodo más largo:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[1h])
  )
)
```

Es importante conservar la etiqueta `le`, porque representa el límite superior de cada intervalo del histograma.

Una agregación incorrecta puede destruir la información necesaria para calcular los cuantiles. Por ejemplo, no se debe eliminar `le` antes de aplicar `histogram_quantile`.

### Downsampling y reglas de grabación

Una consulta PromQL resume datos durante el momento en que se ejecuta, pero no necesariamente crea una nueva serie histórica.

Para almacenar el resultado de una consulta se pueden utilizar **reglas de grabación**.

Ejemplo:

```yaml
groups:
  - name: downsampling
    interval: 5m
    rules:
      - record: instance:node_cpu_usage:avg5m
        expr: |
          1 -
          avg by (instance) (
            rate(node_cpu_seconds_total{
              mode="idle"
            }[5m])
          )
```

Esta regla:

- Se evalúa cada cinco minutos.
- Calcula el uso medio de CPU durante una ventana de cinco minutos.
- Crea una nueva serie llamada `instance:node_cpu_usage:avg5m`.
- Conserva el resultado como una métrica adicional.

La nueva serie puede consultarse con:

```promql
instance:node_cpu_usage:avg5m
```

Las reglas de grabación mejoran el rendimiento de consultas repetidas, pero también generan nuevas series y ocupan almacenamiento.

### Ejemplo de reglas de grabación

Para conservar el uso máximo de CPU por instancia:

```yaml
groups:
  - name: downsampling
    interval: 5m
    rules:
      - record: instance:node_cpu_usage:max5m
        expr: |
          max_over_time(
            (
              1 -
              avg by (instance) (
                rate(node_cpu_seconds_total{
                  mode="idle"
                }[5m])
              )
            )[5m:]
          )
```

Para conservar la memoria disponible media:

```yaml
      - record: instance:memory_available:avg5m
        expr: |
          avg by (instance) (
            avg_over_time(
              node_memory_MemAvailable_bytes[5m]
            )
          )
```

Para conservar el número de solicitudes por segundo:

```yaml
      - record: job:http_requests:rate5m
        expr: |
          sum by (job) (
            rate(http_requests_total[5m])
          )
```

Los nombres de las reglas deben ser claros y coherentes.

Una convención habitual es:

```text
nivel:metrica:operacion
```

Por ejemplo:

```text
instance:node_cpu_usage:avg5m
job:http_requests:rate5m
```

### Qué hace y qué no hace una regla de grabación

Una regla de grabación:

- Ejecuta una consulta periódicamente.
- Almacena sus resultados.
- Crea una nueva serie temporal.
- Puede acelerar dashboards y alertas.

Una regla de grabación no:

- Recupera datos que ya fueron eliminados.
- Reduce automáticamente todas las métricas existentes.
- Sustituye una política de retención.
- Garantiza que se conserven los picos.
- Elimina las series originales.

Si la regla se ejecuta cada cinco minutos, solo registrará sus propios resultados cada cinco minutos. Las métricas originales seguirán existiendo mientras su propia retención lo permita.

### Downsampling consultado frente a downsampling persistente

Existen dos formas principales de resumir datos.

#### Downsampling durante la consulta

Se calcula el resumen cuando se ejecuta la consulta:

```promql
avg_over_time(
  node_load1[5m]
)
```

Ventajas:

- No crea necesariamente nuevas series.
- Es flexible.
- Permite cambiar la ventana fácilmente.
- No requiere una configuración adicional.

Limitaciones:

- La consulta puede ser costosa.
- Los datos originales deben seguir disponibles.
- No reduce el almacenamiento de las métricas originales.
- Puede tardar más en periodos muy amplios.

#### Downsampling persistente

Se almacena previamente el resultado mediante reglas de grabación o un sistema externo:

```yaml
groups:
  - name: agregadas
    interval: 5m
    rules:
      - record: instance:node_load1:avg5m
        expr: |
          avg_over_time(
            node_load1[5m]
          )
```

Ventajas:

- Las consultas posteriores son más rápidas.
- Permite consultar datos resumidos durante más tiempo.
- Reduce el trabajo repetido.
- Facilita construir dashboards estables.

Limitaciones:

- Consume almacenamiento adicional.
- La resolución queda determinada por la regla.
- Puede perder información.
- Requiere planificar nombres y etiquetas.
- Las reglas deben mantenerse junto con la configuración.

### Downsampling y Prometheus

Prometheus almacena los datos en su TSDB local y proporciona funciones para resumir valores durante las consultas.

Sin embargo, el servidor Prometheus por sí solo no convierte automáticamente todo el histórico en varias resoluciones permanentes.

Para implementar una estrategia completa de largo plazo se suelen combinar:

- Retención local.
- Reglas de grabación.
- Agregaciones en las consultas.
- Almacenamiento remoto.
- Sistemas externos compatibles con Prometheus.
- Políticas diferenciadas de conservación.

Por ejemplo:

```text
Prometheus local:
- Datos originales
- Últimos 15 días
- Resolución de 15 segundos

Almacenamiento histórico:
- Datos resumidos
- Varios meses o años
- Resolución de 5 minutos o 1 hora
```

La tecnología concreta para el almacenamiento histórico dependerá de los requisitos de capacidad, disponibilidad y consulta.

### Estrategia de varias resoluciones

Una estrategia habitual es conservar diferentes resoluciones según la antigüedad:

| Antigüedad | Resolución | Uso principal |
|---|---:|---|
| 0-7 días | 15 segundos | Investigación de incidentes |
| 7-30 días | 1 minuto | Análisis operativo |
| 30-180 días | 5 minutos | Tendencias |
| Más de 180 días | 1 hora | Capacidad e históricos |

La resolución alta es útil para investigar incidentes recientes.

La resolución baja suele ser suficiente para responder preguntas como:

- ¿Ha aumentado el uso de CPU durante los últimos seis meses?
- ¿Cuál ha sido la tendencia de memoria?
- ¿Cómo ha evolucionado el tráfico?
- ¿Qué meses han tenido más errores?

No todas las métricas deben conservar las mismas resoluciones. Los datos de latencia, errores y capacidad pueden requerir políticas diferentes.

### Qué valores conservar

La función de agregación debe elegirse según el comportamiento de la métrica.

#### CPU

Puede ser útil conservar:

- Promedio.
- Máximo.
- Percentil.

#### Memoria

Puede ser útil conservar:

- Promedio.
- Mínimo.
- Máximo.

El mínimo puede revelar periodos de presión de memoria que el promedio ocultaría.

#### Latencia

Puede ser útil conservar:

- Percentil 50.
- Percentil 90.
- Percentil 95.
- Percentil 99.
- Máximo.

El promedio por sí solo puede ocultar una degradación que afecta a una parte de las solicitudes.

#### Tráfico

Puede ser útil conservar:

- Tasa media.
- Tasa máxima.
- Total acumulado.
- Distribución por servicio o ruta.

#### Errores

Puede ser útil conservar:

- Tasa de errores.
- Total de errores.
- Máximo de errores por intervalo.
- Porcentaje respecto al total de solicitudes.

### Problemas habituales

#### Perder picos

Si solo se conserva el promedio, los valores extremos pueden desaparecer.

Solución:

- Conservar también el máximo.
- Utilizar percentiles.
- Mantener alta resolución para periodos recientes.

#### Agregar etiquetas incorrectamente

Si se eliminan etiquetas importantes, se mezclan series que deberían analizarse por separado.

Ejemplo incorrecto:

```promql
sum(rate(http_requests_total[5m]))
```

Esta consulta puede ser correcta si solo se necesita el total global, pero no si se necesita distinguir por:

- Servicio.
- Código de estado.
- Instancia.
- Método.
- Región.

Ejemplo con agrupación:

```promql
sum by (service, status) (
  rate(http_requests_total[5m])
)
```

#### Crear demasiadas reglas

Cada regla de grabación genera nuevas series.

Una gran cantidad de reglas puede:

- Aumentar la cardinalidad.
- Consumir más almacenamiento.
- Complicar el mantenimiento.
- Incrementar el tiempo de evaluación.
- Generar resultados duplicados.

Las reglas deben representar consultas útiles y repetidas.

#### Confundir una ventana con una retención

Esta consulta:

```promql
avg_over_time(node_load1[5m])
```

utiliza una ventana de cinco minutos. No significa que los datos se conserven durante cinco minutos.

La retención se configura de forma independiente:

```bash
--storage.tsdb.retention.time=15d
```

La ventana indica cuántos datos se utilizan en el cálculo. La retención indica cuánto tiempo permanecen disponibles.

#### Utilizar la resolución baja para investigar incidentes

Los datos reducidos son adecuados para tendencias, pero pueden ser insuficientes para analizar un incidente concreto.

Por eso conviene conservar los datos recientes con una resolución mayor y reducirla solo cuando los datos sean antiguos.

## Ejemplo

### Crear una regla de grabación para CPU

Supongamos que se desea almacenar el uso medio de CPU por instancia.

Crear o editar un fichero de reglas:

```text
/etc/prometheus/rules/downsampling.yml
```

Contenido:

```yaml
groups:
  - name: downsampling
    interval: 5m

    rules:
      - record: instance:node_cpu_usage:avg5m
        expr: |
          1 -
          avg by (instance) (
            rate(node_cpu_seconds_total{
              mode="idle"
            }[5m])
          )
```

En `prometheus.yml` se incluye el fichero:

```yaml
rule_files:
  - /etc/prometheus/rules/*.yml
```

Después se comprueba la configuración:

```bash
promtool check rules /etc/prometheus/rules/downsampling.yml
```

También puede comprobarse el fichero principal:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reiniciar Prometheus:

```bash
sudo systemctl restart prometheus
```

La nueva serie se consulta con:

```promql
instance:node_cpu_usage:avg5m
```

El resultado tendrá aproximadamente una muestra cada cinco minutos.

### Crear varias resoluciones

Se pueden crear reglas con distintos intervalos de evaluación:

```yaml
groups:
  - name: downsampling_1m
    interval: 1m

    rules:
      - record: instance:node_cpu_usage:avg1m
        expr: |
          1 -
          avg by (instance) (
            rate(node_cpu_seconds_total{
              mode="idle"
            }[5m])
          )

  - name: downsampling_5m
    interval: 5m

    rules:
      - record: instance:node_cpu_usage:avg5m
        expr: |
          avg_over_time(
            instance:node_cpu_usage:avg1m[5m]
          )

  - name: downsampling_1h
    interval: 1h

    rules:
      - record: instance:node_cpu_usage:avg1h
        expr: |
          avg_over_time(
            instance:node_cpu_usage:avg5m[1h]
          )
```

En este diseño:

```text
instance:node_cpu_usage:avg1m
```

conserva una resolución aproximada de un minuto.

```text
instance:node_cpu_usage:avg5m
```

resume los datos de cinco minutos.

```text
instance:node_cpu_usage:avg1h
```

resume los datos de una hora.

La cadena de agregaciones debe diseñarse cuidadosamente. Las reglas posteriores dependen de que las series anteriores estén disponibles y se evalúen correctamente.

### Crear un panel de Grafana

Para mostrar datos recientes:

```promql
instance:node_cpu_usage:avg1m
```

Para mostrar una tendencia de varios meses:

```promql
instance:node_cpu_usage:avg1h
```

En Grafana se puede seleccionar la consulta según el periodo:

| Periodo seleccionado | Serie recomendada |
|---|---|
| Últimas 6 horas | `instance:node_cpu_usage:avg1m` |
| Últimos 7 días | `instance:node_cpu_usage:avg5m` |
| Últimos 6 meses | `instance:node_cpu_usage:avg1h` |

La selección puede hacerse mediante paneles diferentes, variables o una estrategia de consulta adaptada al sistema de almacenamiento.

### Conservar promedio y máximo

Para evitar perder picos, se pueden conservar dos series:

```yaml
groups:
  - name: cpu_resumen
    interval: 5m

    rules:
      - record: instance:node_cpu_usage:avg5m
        expr: |
          avg_over_time(
            (
              1 -
              avg by (instance) (
                rate(node_cpu_seconds_total{
                  mode="idle"
                }[5m])
              )
            )[5m:]
          )

      - record: instance:node_cpu_usage:max5m
        expr: |
          max_over_time(
            (
              1 -
              avg by (instance) (
                rate(node_cpu_seconds_total{
                  mode="idle"
                }[5m])
              )
            )[5m:]
          )
```

En Grafana se pueden representar ambas:

```promql
instance:node_cpu_usage:avg5m
```

```promql
instance:node_cpu_usage:max5m
```

La primera muestra la tendencia media.

La segunda ayuda a detectar picos que quedarían ocultos al utilizar únicamente el promedio.

### Resumir solicitudes HTTP

Para conservar el tráfico por servicio y código de estado:

```yaml
groups:
  - name: http_resumen
    interval: 5m

    rules:
      - record: service:http_requests:rate5m
        expr: |
          sum by (service) (
            rate(http_requests_total[5m])
          )

      - record: service:http_errors:rate5m
        expr: |
          sum by (service) (
            rate(http_requests_total{
              status=~"5.."
            }[5m])
          )
```

Para calcular posteriormente el porcentaje de errores:

```promql
100 *
service:http_errors:rate5m
/
service:http_requests:rate5m
```

Si se necesita evitar divisiones entre cero:

```promql
100 *
service:http_errors:rate5m
/
clamp_min(
  service:http_requests:rate5m,
  1
)
```

La función `clamp_min` evita que el denominador sea inferior a uno.

## Puntos clave

- El *downsampling* reduce la resolución o cantidad de datos almacenados.
- Permite conservar históricos durante más tiempo.
- Los datos recientes suelen necesitar una resolución mayor.
- Los datos antiguos pueden resumirse para analizar tendencias.
- El promedio reduce el ruido, pero puede ocultar picos.
- El mínimo es útil para detectar valores peligrosamente bajos.
- El máximo es útil para detectar saturaciones y picos.
- Los percentiles son importantes para analizar latencias.
- `avg_over_time`, `min_over_time` y `max_over_time` resumen ventanas temporales.
- `rate` e `increase` son apropiadas para analizar contadores.
- Una consulta sobre una ventana no almacena automáticamente un nuevo histórico.
- Las reglas de grabación permiten persistir resultados de consultas.
- Las reglas de grabación generan nuevas series y consumen almacenamiento.
- El *downsampling* no recupera información que nunca fue recopilada.
- Una ventana de consulta no es lo mismo que un periodo de retención.
- Las etiquetas deben conservarse solo cuando sean necesarias para el análisis.
- El *downsampling* durante la consulta es flexible, pero puede ser costoso.
- El *downsampling* persistente acelera las consultas, pero requiere planificación.
- Una estrategia de varias resoluciones puede combinar datos de 1 minuto, 5 minutos y 1 hora.
- Siempre debe conservarse suficiente resolución para investigar incidentes recientes.
- Los datos resumidos son adecuados para tendencias, capacidad e informes históricos.

## Preguntas de comprobación

1. ¿Qué es el *downsampling*?
2. ¿Por qué se utiliza el *downsampling* en sistemas de monitorización?
3. ¿Qué diferencia existe entre los datos originales y los datos reducidos?
4. ¿Qué información puede perderse al calcular únicamente un promedio?
5. ¿Cuándo puede ser más útil conservar el máximo que el promedio?
6. ¿Qué función PromQL calcula el promedio de una ventana temporal?
7. ¿Qué función permite obtener el máximo durante una ventana?
8. ¿Qué diferencia existe entre `rate` e `increase`?
9. ¿Qué es una regla de grabación?
10. ¿Una consulta con `avg_over_time` almacena automáticamente los resultados?
11. ¿Qué ventajas ofrece el *downsampling* persistente?
12. ¿Qué inconvenientes tienen las reglas de grabación?
13. ¿Por qué no conviene eliminar todas las etiquetas al agregar series?
14. ¿Qué significa conservar varias resoluciones?
15. ¿Qué resolución utilizarías para investigar un incidente ocurrido hace diez minutos?
16. ¿Qué resolución podría ser suficiente para analizar una tendencia de seis meses?
17. ¿Por qué los percentiles son importantes en las métricas de latencia?
18. ¿Qué diferencia existe entre una ventana de consulta y la retención de datos?
19. ¿Puede el *downsampling* recuperar un pico que nunca fue registrado?
20. ¿Qué estrategia de *downsampling* aplicarías a un entorno de laboratorio?