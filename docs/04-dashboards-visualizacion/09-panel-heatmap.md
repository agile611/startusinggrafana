# Panel Heatmap

El panel **Heatmap** de Grafana permite representar la distribución de valores a lo largo del tiempo.

A diferencia de un panel Time series, que normalmente muestra una línea por serie, un Heatmap muestra cómo se concentran los valores en diferentes intervalos o **buckets**.

Es especialmente útil para analizar:

- Latencias.
- Duración de peticiones.
- Tamaños de respuesta.
- Tiempos de consulta.
- Distribuciones de valores.
- Métricas de tipo histograma.
- Percentiles.
- Comportamientos anómalos.
- Evolución de una distribución a lo largo del tiempo.

Un Heatmap ayuda a responder preguntas como:

```text
¿La mayoría de las peticiones son rápidas?
¿Está aumentando la latencia?
¿Existen dos grupos de valores?
¿Aparecen valores extremos?
¿La distribución se ha desplazado?
```

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad de un panel Heatmap.
- Diferenciar un Heatmap de un Time series.
- Comprender el concepto de distribución.
- Explicar qué es un bucket.
- Identificar métricas de tipo histograma en Prometheus.
- Utilizar métricas con sufijos `_bucket`, `_sum` y `_count`.
- Configurar un panel Heatmap.
- Representar la distribución de latencias.
- Interpretar los colores del mapa.
- Configurar el eje temporal.
- Configurar los rangos de valores.
- Utilizar `histogram_quantile()`.
- Calcular percentiles a partir de histogramas.
- Comparar la distribución de una métrica entre intervalos.
- Diagnosticar un Heatmap sin datos.
- Identificar problemas de unidades y buckets.
- Documentar las consultas utilizadas.
- Crear una práctica reproducible con métricas de ejemplo.

---

## Introducción

Un Heatmap representa la cantidad o densidad de observaciones dentro de diferentes rangos de valores y momentos temporales.

La estructura conceptual es:

```text
Tiempo
  |
  v
+--------------------------------------------------+
|                         ██                       |
|                    ████████                      |
|               █████████████                     |
|          ███████████████                        |
|     █████████████                               |
+--------------------------------------------------+
        Valores o rangos
```

Cada celda del Heatmap representa una cantidad de observaciones.

El color indica la densidad:

```text
Color claro: pocas observaciones
Color intenso: muchas observaciones
```

Una distribución de latencias podría indicar:

```text
0 - 100 ms:   muchas peticiones
100 - 300 ms: algunas peticiones
300 - 1000 ms: pocas peticiones
> 1000 ms:    valores extremos
```

La intensidad del color no representa directamente el valor de la métrica. Representa la cantidad de observaciones dentro de una zona concreta.

---

## Qué es un bucket

Un **bucket** es un intervalo que agrupa valores.

Ejemplo de buckets de latencia:

```text
<= 0.1 segundos
<= 0.25 segundos
<= 0.5 segundos
<= 1 segundo
<= 2.5 segundos
<= 5 segundos
<= 10 segundos
```

Cada bucket cuenta cuántas observaciones son menores o iguales que su límite superior.

En Prometheus, los buckets de un histograma utilizan normalmente la etiqueta:

```text
le
```

`le` significa:

```text
less than or equal
```

Es decir:

```text
menor o igual que
```

Ejemplo:

```text
http_request_duration_seconds_bucket{le="0.5"} 1200
```

Indica que se han observado 1200 peticiones con una duración menor o igual que 0.5 segundos.

---

## Histogramas de Prometheus

Una métrica de tipo histograma suele generar tres familias de series:

### `_bucket`

Cuenta las observaciones acumuladas por intervalo.

Ejemplo:

```text
http_request_duration_seconds_bucket
```

### `_sum`

Suma todos los valores observados.

Ejemplo:

```text
http_request_duration_seconds_sum
```

### `_count`

Cuenta todas las observaciones.

Ejemplo:

```text
http_request_duration_seconds_count
```

### Ejemplo conceptual

```text
http_request_duration_seconds_bucket{le="0.1"}   850
http_request_duration_seconds_bucket{le="0.5"}   1200
http_request_duration_seconds_bucket{le="1"}      1280
http_request_duration_seconds_bucket{le="5"}      1300
http_request_duration_seconds_bucket{le="+Inf"}   1305

http_request_duration_seconds_sum                410.5
http_request_duration_seconds_count              1305
```

Interpretación:

- 850 observaciones duran como máximo 0.1 segundos.
- 1200 observaciones duran como máximo 0.5 segundos.
- 1280 observaciones duran como máximo 1 segundo.
- 1305 observaciones tienen cualquier duración.
- La suma de todas las duraciones es 410.5 segundos.
- Se han observado 1305 peticiones.

---

## Cuándo utilizar un Heatmap

El Heatmap es apropiado cuando:

- Se dispone de una distribución de valores.
- La métrica representa latencias o duraciones.
- Se desea observar percentiles.
- Se necesita analizar valores extremos.
- La distribución cambia con el tiempo.
- Se utilizan histogramas de Prometheus.
- Una línea temporal no muestra suficiente información.

### Ejemplos adecuados

- Latencia de peticiones HTTP.
- Duración de consultas a una base de datos.
- Tiempo de respuesta de una API.
- Tamaño de paquetes.
- Duración de trabajos.
- Tiempo de procesamiento.
- Duración de sesiones.
- Distribución de errores por intervalo.

---

## Cuándo no utilizar un Heatmap

No suele ser la mejor opción cuando se necesita:

- Mostrar un único valor actual.
- Comparar directamente varios servidores.
- Mostrar una tendencia simple.
- Mostrar estados `UP` o `DOWN`.
- Consultar etiquetas y valores detallados.
- Representar una métrica sin distribución.

En esos casos pueden ser más adecuadas otras visualizaciones:

| Necesidad | Visualización recomendada |
|---|---|
| Valor actual | Stat |
| Valor frente a límites | Gauge |
| Comparación entre elementos | Bar Gauge |
| Evolución de una métrica | Time series |
| Valores tabulares | Table |
| Distribución temporal | Heatmap |

---

## Diferencia entre Heatmap y Time series

Un panel Time series muestra normalmente una línea por serie.

Ejemplo:

```text
Latencia media durante una hora
```

El Heatmap muestra cómo se distribuyen las observaciones.

Ejemplo:

```text
Cuántas peticiones estuvieron entre 100 y 200 ms
durante cada intervalo de tiempo
```

### Time series

Puede representar:

```promql
rate(
  http_request_duration_seconds_sum[5m]
)
/
rate(
  http_request_duration_seconds_count[5m]
)
```

Resultado:

```text
Latencia media
```

### Heatmap

Puede representar:

```text
La distribución completa de latencias
```

El promedio puede ocultar valores extremos. El Heatmap conserva más información sobre la distribución.

---

## Diferencia entre Heatmap y percentiles

Un percentil resume una distribución en un único valor.

Ejemplo:

```text
Percentil 95: 0.8 segundos
```

Esto significa que aproximadamente el 95 % de las observaciones están por debajo de 0.8 segundos.

Un Heatmap muestra más contexto:

```text
- Cuántas observaciones hay en cada rango.
- Si la distribución se concentra.
- Si existen varios grupos.
- Si aparecen valores extremos.
- Cómo cambia la distribución con el tiempo.
```

Una combinación útil es:

```text
Heatmap: distribución completa
Time series: percentil 50, 95 y 99
```

---

## Anatomía de un Heatmap

Un Heatmap contiene normalmente:

```text
+------------------------------------------------------+
| Distribución de latencias                            |
|                                                      |
|  5 s |                         ░                    |
|  2 s |                    ▒▒▒▒▒                    |
|  1 s |              ▓▓▓▓▓▓▓▓▓                      |
|500ms |        ███████████████                     |
|100ms |██████████████████████                     |
|      +------------------------------------------    |
|        17:00       17:15       17:30       17:45    |
+------------------------------------------------------+
```

### Eje temporal

Representa cuándo se produjeron las observaciones.

### Eje de valores

Representa los rangos de la métrica.

Ejemplos:

```text
Milisegundos
Segundos
Bytes
Número de elementos
```

### Celdas

Cada celda corresponde a una combinación de:

```text
Intervalo temporal + intervalo de valores
```

### Intensidad

La intensidad del color representa la cantidad de observaciones.

### Buckets

Los límites de los buckets determinan la resolución vertical.

---

## Crear un panel Heatmap

### Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Identificar una métrica de tipo histograma.
6. Introducir una consulta basada en `_bucket`.
7. Seleccionar la visualización `Heatmap`.
8. Configurar el formato de los datos.
9. Configurar la unidad.
10. Configurar los rangos de valores.
11. Configurar el esquema de colores.
12. Revisar el resultado.
13. Guardar el panel.
14. Guardar el dashboard.

### Consulta inicial

Una métrica típica puede ser:

```promql
http_request_duration_seconds_bucket
```

Sin embargo, para representar una distribución temporal suele ser necesario calcular el incremento de cada bucket:

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

La consulta agrupa las observaciones por límite superior `le`.

---

## Consultas de histogramas

### Buckets de latencia

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Buckets por servicio

```promql
sum by (service, le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Buckets por ruta

```promql
sum by (handler, le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Buckets por instancia

```promql
sum by (instance, le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Buckets filtrados por método HTTP

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket{
      method="GET"
    }[5m]
  )
)
```

### Buckets filtrados por servicio

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket{
      service="api"
    }[5m]
  )
)
```

---

## Consultar los percentiles de un histograma

La función `histogram_quantile()` calcula un percentil aproximado a partir de buckets.

### Percentil 50

```promql
histogram_quantile(
  0.50,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

El percentil 50 también se conoce como mediana.

### Percentil 90

```promql
histogram_quantile(
  0.90,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentil 95

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentil 99

```promql
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentiles por servicio

```promql
histogram_quantile(
  0.95,
  sum by (service, le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentiles por instancia

```promql
histogram_quantile(
  0.95,
  sum by (instance, le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

La etiqueta `le` debe conservarse para que `histogram_quantile()` pueda reconstruir la distribución.

---

## Latencia media de un histograma

La media puede calcularse utilizando `_sum` y `_count`.

```promql
rate(http_request_duration_seconds_sum[5m])
/
rate(http_request_duration_seconds_count[5m])
```

Media por servicio:

```promql
sum by (service) (
  rate(http_request_duration_seconds_sum[5m])
)
/
sum by (service) (
  rate(http_request_duration_seconds_count[5m])
)
```

### Limitación

La media no muestra la distribución completa.

Dos sistemas pueden tener la misma media y comportamientos muy diferentes:

```text
Sistema A: la mayoría de las peticiones duran 200 ms
Sistema B: algunas duran 10 ms y otras 390 ms
```

El Heatmap permite observar esa diferencia.

---

## Métricas de ejemplo para practicar

Para practicar un Heatmap se necesita una métrica con buckets.

Ejemplos habituales:

```text
http_request_duration_seconds_bucket
```

```text
http_request_size_bytes_bucket
```

```text
process_cpu_seconds_bucket
```

```text
go_gc_duration_seconds_bucket
```

Las métricas disponibles dependen de:

- La aplicación.
- El exporter.
- La instrumentación.
- El formato de métricas.
- La configuración de Prometheus.

Buscar histogramas:

```promql
{__name__=~".*_bucket"}
```

En Grafana Explore también se puede buscar:

```text
_bucket
```

---

## Crear una métrica de ejemplo con Node Exporter

Node Exporter normalmente no proporciona una métrica HTTP de latencia con buckets lista para usar.

Por ello, para las prácticas se puede utilizar:

- Una aplicación instrumentada.
- Un exporter con histogramas.
- Una métrica de ejemplo.
- Un endpoint de pruebas.
- Prometheus Pushgateway, si forma parte del laboratorio.
- Un servicio de demostración preparado por el instructor.

Antes de crear el Heatmap, comprobar que la métrica existe:

```promql
http_request_duration_seconds_bucket
```

Consultar todas las métricas relacionadas:

```promql
{__name__=~"http_request_duration_seconds.*"}
```

Comprobar los buckets:

```promql
count by (le) (
  http_request_duration_seconds_bucket
)
```

Resultado conceptual:

```text
le="0.1"
le="0.25"
le="0.5"
le="1"
le="2.5"
le="5"
le="+Inf"
```

---

## Configurar el formato de datos

Las versiones de Grafana pueden presentar diferentes opciones para configurar los datos del Heatmap.

Entre las opciones habituales se encuentran:

- Formato de datos temporal.
- Formato de datos tipo Heatmap.
- Buckets en filas.
- Buckets en columnas.
- Campo de tiempo.
- Campo de límite superior.
- Campo de valor.
- Transformaciones de datos.

### Configuración conceptual

```text
Tiempo: timestamp
Bucket: le
Valor: número de observaciones
```

Si Grafana espera datos en formato de Heatmap, normalmente necesita conocer:

```text
El instante temporal
El rango de valores
La cantidad de observaciones
```

La interfaz exacta puede variar según la versión de Grafana y la forma en que la fuente de datos devuelve la consulta.

---

## Configurar la unidad

La unidad debe corresponder a la métrica original.

### Latencia en segundos

Si la métrica es:

```text
http_request_duration_seconds_bucket
```

Utilizar:

```text
Seconds
```

### Latencia en milisegundos

Si la consulta multiplica el resultado por `1000`, utilizar:

```text
Milliseconds
```

Sin embargo, los buckets originales deben estar definidos de forma coherente.

### Tamaño de respuesta

Para:

```text
http_request_size_bytes_bucket
```

Utilizar:

```text
Bytes
```

### Duración de trabajos

Para:

```text
job_duration_seconds_bucket
```

Utilizar:

```text
Seconds
```

---

## Configurar colores

El esquema de colores representa la densidad de observaciones.

Ejemplo conceptual:

```text
Poca densidad: color claro
Densidad media: color intermedio
Mucha densidad: color intenso
```

### Recomendaciones

- Utilizar una escala continua.
- Elegir colores con suficiente contraste.
- Evitar colores que oculten valores bajos.
- Mantener la misma escala al comparar paneles.
- Documentar el significado de la intensidad.
- No interpretar automáticamente un color intenso como error.

Un color intenso significa normalmente:

```text
Muchas observaciones en esa zona
```

No significa necesariamente:

```text
Estado crítico
```

---

## Interpretar un Heatmap de latencia

Supongamos que el gráfico muestra:

```text
La mayor concentración entre 100 ms y 250 ms.
```

Interpretación:

- La mayoría de las peticiones se encuentran en ese intervalo.
- La aplicación tiene un comportamiento relativamente estable.
- Deben revisarse los valores situados por encima de 1 segundo.

Si la zona intensa sube con el tiempo:

```text
La distribución se está desplazando hacia latencias mayores.
```

Si aparecen dos zonas intensas:

```text
Puede haber dos tipos de peticiones,
rutas diferentes o comportamientos separados.
```

Si aparece una cola prolongada hacia valores altos:

```text
Existen valores extremos o peticiones lentas.
```

---

## Ejemplo completo 1: Heatmap de latencia HTTP

### Objetivo

Representar la distribución de duración de las peticiones HTTP.

### Métrica

```promql
http_request_duration_seconds_bucket
```

### Consulta

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Configuración

```text
Título: Distribución de latencias HTTP
Visualización: Heatmap
Unidad: Seconds
Rango temporal: Last 1 hour
```

### Descripción

```text
Distribución temporal de las duraciones de las peticiones HTTP.
Cada bucket representa un intervalo acumulado de latencia.
```

### Interpretación

- La zona más intensa representa el intervalo más frecuente.
- Una concentración cercana a cero indica respuestas rápidas.
- Una expansión hacia valores altos indica mayor variabilidad.
- Una cola superior puede indicar peticiones lentas.

---

## Ejemplo completo 2: Heatmap por servicio

### Objetivo

Analizar la distribución de latencias de cada servicio.

### Consulta

```promql
sum by (service, le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Configuración

```text
Título: Distribución de latencias por servicio
Visualización: Heatmap
Unidad: Seconds
Rango temporal: Last 6 hours
```

### Recomendación

Si el Heatmap resulta difícil de interpretar porque mezcla demasiados servicios:

- Filtrar un servicio.
- Crear un panel por servicio.
- Utilizar una variable de dashboard.
- Utilizar un Time series de percentiles para comparar servicios.

### Consulta filtrada

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket{
      service="$service"
    }[5m]
  )
)
```

---

## Ejemplo completo 3: Heatmap de tamaño de respuesta

### Objetivo

Representar la distribución de tamaños de respuesta HTTP.

### Métrica

```promql
http_response_size_bytes_bucket
```

### Consulta

```promql
sum by (le) (
  rate(http_response_size_bytes_bucket[5m])
)
```

### Configuración

```text
Título: Distribución del tamaño de las respuestas
Visualización: Heatmap
Unidad: Bytes
Rango temporal: Last 1 hour
```

### Interpretación

Puede ayudar a identificar:

- Respuestas pequeñas y constantes.
- Aumentos del tamaño medio.
- Respuestas anormalmente grandes.
- Cambios después de una modificación de la aplicación.

---

## Ejemplo completo 4: Heatmap de duración de trabajos

### Objetivo

Analizar la duración de trabajos procesados por un sistema.

### Métrica

```promql
job_duration_seconds_bucket
```

### Consulta

```promql
sum by (le) (
  rate(job_duration_seconds_bucket[5m])
)
```

### Configuración

```text
Título: Distribución de duración de trabajos
Visualización: Heatmap
Unidad: Seconds
Rango temporal: Last 24 hours
```

### Interpretación

- Una banda estable indica duraciones constantes.
- Una banda que sube indica trabajos más lentos.
- Varias bandas pueden indicar tipos de trabajos distintos.
- Una cola larga indica trabajos excepcionales.

---

## Ejemplo de sesión 1: localizar histogramas

### Objetivo

Identificar qué métricas de tipo histograma existen en Prometheus.

### Pasos

1. Abrir Grafana.
2. Acceder a **Explore**.
3. Seleccionar Prometheus.
4. Ejecutar:

```promql
{__name__=~".*_bucket"}
```

5. Revisar los nombres devueltos.
6. Seleccionar una métrica relacionada con latencia o duración.

### Actividades

1. Anota tres métricas con sufijo `_bucket`.
2. Busca las variantes `_sum` y `_count`.
3. Identifica sus etiquetas.
4. Anota los valores de `le`.
5. Explica qué representa cada bucket.

---

## Ejemplo de sesión 2: comprobar los buckets

### Objetivo

Conocer los intervalos disponibles para una métrica de histograma.

### Consulta

```promql
count by (le) (
  http_request_duration_seconds_bucket
)
```

### Alternativa

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Pasos

1. Ejecutar la consulta.
2. Revisar los valores de `le`.
3. Confirmar que existe el bucket `+Inf`.
4. Anotar el número de buckets.
5. Comprobar si los límites son adecuados para la métrica.

### Actividades

Responder:

1. ¿Cuál es el bucket más pequeño?
2. ¿Cuál es el bucket más grande antes de `+Inf`?
3. ¿Por qué existe `+Inf`?
4. ¿Qué ocurre si los buckets son demasiado amplios?
5. ¿Qué ocurre si hay demasiados buckets?

---

## Ejemplo de sesión 3: crear un Heatmap de latencia

### Objetivo

Crear un Heatmap con la distribución temporal de latencias.

### Consulta

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Pasos

1. Crear un dashboard nuevo.
2. Añadir un panel.
3. Seleccionar Prometheus.
4. Introducir la consulta.
5. Seleccionar `Heatmap`.
6. Configurar:

```text
Título: Distribución de latencias HTTP
Unidad: Seconds
Rango temporal: Last 1 hour
```

7. Ajustar el formato de los datos si la versión de Grafana lo solicita.
8. Seleccionar un esquema de colores.
9. Guardar el panel.
10. Guardar el dashboard.

### Actividades

1. Identifica la zona de mayor densidad.
2. Observa si la distribución se desplaza.
3. Cambia el rango a `Last 15 minutes`.
4. Cambia el rango a `Last 6 hours`.
5. Compara el detalle de ambos rangos.

---

## Ejemplo de sesión 4: comparar Heatmap y percentiles

### Objetivo

Comparar la distribución completa con varios percentiles.

### Panel 1: Heatmap

Consulta:

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Panel 2: percentil 50

```promql
histogram_quantile(
  0.50,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Panel 3: percentil 95

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Panel 4: percentil 99

```promql
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Actividades

1. Coloca los paneles en el mismo dashboard.
2. Compara la zona más intensa del Heatmap con el percentil 50.
3. Compara la parte superior de la distribución con los percentiles 95 y 99.
4. Explica qué información se pierde al mostrar únicamente el promedio.
5. Explica qué información se pierde al mostrar únicamente el percentil 95.

---

## Ejemplo de sesión 5: analizar una distribución por servicio

### Objetivo

Comparar la latencia de varios servicios.

### Consulta

```promql
sum by (service, le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Pasos

1. Crear el panel.
2. Introducir la consulta.
3. Configurar el título:

```text
Distribución de latencias por servicio
```

4. Revisar la cantidad de series.
5. Filtrar un servicio concreto:

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket{
      service="api"
    }[5m]
  )
)
```

6. Crear un panel adicional para otro servicio.
7. Comparar ambos Heatmaps.

### Actividades

1. Identifica el servicio con mayor dispersión.
2. Identifica el servicio con más valores extremos.
3. Compara sus percentiles 95.
4. Explica por qué puede ser preferible un panel por servicio.

---

## Ejemplo de sesión 6: generar actividad para observar cambios

### Objetivo

Observar cómo cambia una distribución cuando se modifica la carga del sistema.

La actividad debe realizarse únicamente en un entorno de laboratorio autorizado.

### Pasos

1. Abrir el Heatmap de latencias.
2. Registrar la distribución inicial.
3. Ejecutar una carga controlada sobre la aplicación de pruebas.
4. Esperar varios intervalos de scraping.
5. Observar el cambio en la distribución.
6. Detener la carga.
7. Observar la recuperación.

### Actividades

1. Captura el Heatmap antes de la carga.
2. Captura el Heatmap durante la carga.
3. Captura el Heatmap después de la carga.
4. Compara la posición de la zona más intensa.
5. Compara el percentil 95.
6. Describe si aparece una cola de valores altos.

---

## Ejemplo de sesión 7: identificar una consulta incorrecta

### Objetivo

Comprender la diferencia entre buckets acumulados y valores por intervalo.

### Consulta inicial:

```promql
http_request_duration_seconds_bucket
```

### Consulta temporal:

```promql
rate(
  http_request_duration_seconds_bucket[5m]
)
```

### Consulta agrupada:

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

### Actividades

1. Ejecuta la primera consulta.
2. Ejecuta la segunda.
3. Ejecuta la tercera.
4. Compara las series devueltas.
5. Explica por qué la tercera consulta es más adecuada para una distribución agregada.
6. Revisa el papel de la etiqueta `le`.

---

## Ejemplo de sesión 8: diagnosticar un Heatmap sin datos

### Objetivo

Diagnosticar un panel Heatmap vacío.

### Consulta incorrecta

```promql
sum by (le) (
  rate(
    metrica_histograma_inexistente_bucket[5m]
  )
)
```

### Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar si devuelve datos.
3. Sustituir la métrica por una métrica real.
4. Revisar el rango temporal.
5. Revisar la existencia de `_bucket`.
6. Revisar la etiqueta `le`.
7. Abrir el inspector del panel.
8. Revisar las transformaciones.
9. Comprobar el formato de datos del Heatmap.

### Actividades

Documentar:

```text
Consulta inicial:
Resultado:
Causa:
Corrección:
Resultado final:
```

---

## Ejemplo de sesión 9: comprobar la media y los percentiles

### Objetivo

Comparar la latencia media con los percentiles.

### Latencia media

```promql
rate(http_request_duration_seconds_sum[5m])
/
rate(http_request_duration_seconds_count[5m])
```

### Percentil 50

```promql
histogram_quantile(
  0.50,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentil 95

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Percentil 99

```promql
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

### Actividades

1. Crea un Time series con las cuatro consultas.
2. Configura la unidad como `Seconds`.
3. Compara los valores.
4. Explica por qué el percentil 95 puede ser mucho mayor que la media.
5. Relaciona el resultado con el Heatmap.

---

## Ejemplo de sesión 10: verificar la métrica mediante la API

### Objetivo

Consultar los buckets directamente desde Prometheus.

### Consulta de buckets

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=sum by (le) (rate(http_request_duration_seconds_bucket[5m]))' \
  | jq
```

### Consulta del percentil 95

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))' \
  | jq
```

### Actividades

1. Compara el resultado de la API con Grafana.
2. Comprueba las etiquetas.
3. Identifica el bucket `+Inf`.
4. Guarda las respuestas como evidencia.
5. Explica la diferencia entre una consulta instantánea y una consulta de rango.

---

## Configurar variables de dashboard

Una variable permite seleccionar el contexto del Heatmap.

### Variable de servicio

Nombre:

```text
service
```

Consulta posible:

```promql
label_values(
  http_request_duration_seconds_bucket,
  service
)
```

La sintaxis disponible puede variar según la versión de Grafana y el editor de variables.

### Consulta del panel

```promql
sum by (le) (
  rate(
    http_request_duration_seconds_bucket{
      service=~"$service"
    }[5m]
  )
)
```

### Actividades

1. Crea la variable `service`.
2. Comprueba los valores disponibles.
3. Crea el Heatmap.
4. Selecciona un servicio.
5. Selecciona varios servicios.
6. Comprueba el comportamiento de `All`.
7. Documenta la variable.

---

## Configurar el intervalo de tiempo

El rango temporal debe adaptarse al análisis.

### Rango corto

```text
Last 15 minutes
```

Útil para:

- Incidencias activas.
- Cambios recientes.
- Pruebas de laboratorio.

### Rango medio

```text
Last 1 hour
Last 6 hours
```

Útil para:

- Analizar una sesión.
- Comparar periodos.
- Observar una tendencia reciente.

### Rango largo

```text
Last 24 hours
Last 7 days
```

Útil para:

- Revisar patrones.
- Analizar ventanas de carga.
- Comparar periodos operativos.

Un rango excesivamente largo puede comprimir la información y dificultar la lectura.

---

## Configurar la resolución

La resolución temporal determina cuántos puntos se calculan.

Una consulta demasiado precisa puede:

- Aumentar la carga sobre Prometheus.
- Generar demasiados datos.
- Hacer más lenta la visualización.
- No aportar información adicional.

Una consulta demasiado poco precisa puede:

- Ocultar picos.
- Suavizar cambios.
- Perder detalles.
- Ocultar periodos cortos de latencia alta.

### Recomendación

El intervalo de consulta debe estar relacionado con:

- La frecuencia de scraping.
- El rango temporal.
- La frecuencia de los eventos.
- La capacidad de Prometheus.
- El nivel de detalle necesario.

---

## Configurar buckets

La calidad del Heatmap depende de los buckets disponibles.

### Pocos buckets

Ventajas:

- Menor coste.
- Visualización más sencilla.
- Menos series.

Inconvenientes:

- Menor precisión.
- Percentiles menos exactos.
- Distribución menos detallada.

### Muchos buckets

Ventajas:

- Mayor resolución.
- Mejor detalle de la distribución.
- Percentiles más precisos.

Inconvenientes:

- Más series.
- Mayor coste de almacenamiento.
- Mayor coste de consulta.
- Visualización potencialmente saturada.

### Ejemplo

Buckets poco detallados:

```text
0.5
1
5
+Inf
```

Buckets más detallados:

```text
0.05
0.1
0.25
0.5
0.75
1
1.5
2.5
5
10
+Inf
```

Los límites deben elegirse según el comportamiento esperado de la métrica.

---

## El bucket `+Inf`

Los histogramas de Prometheus deben incluir un bucket infinito superior:

```text
le="+Inf"
```

Este bucket representa todas las observaciones, independientemente de su valor.

Es necesario para:

- Conocer el total de observaciones.
- Calcular percentiles.
- Completar la distribución.
- Detectar observaciones que superan el mayor límite explícito.

Si falta o está mal configurado, las consultas de histogramas pueden producir resultados incorrectos.

---

## Histograma clásico y Native Histogram

Prometheus puede trabajar con:

- Histogramas clásicos basados en series `_bucket`.
- Native Histograms, según la versión y la configuración.

### Histograma clásico

Utiliza series como:

```text
metric_bucket
metric_sum
metric_count
```

Las consultas utilizan normalmente:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(metric_bucket[5m])
  )
)
```

### Native Histogram

Puede utilizar una representación diferente y requiere que la versión de Prometheus, Grafana y la fuente de datos sean compatibles.

En esta práctica se utilizarán principalmente histogramas clásicos porque permiten observar explícitamente:

```text
Buckets
Etiqueta le
Series acumuladas
Cálculo de percentiles
```

---

## Buenas prácticas

### Confirmar que la métrica es un histograma

Buscar:

```promql
{__name__=~".*_bucket"}
```

### Conservar la etiqueta `le`

Para calcular percentiles:

```promql
sum by (le) (...)
```

No eliminar `le` antes de utilizar `histogram_quantile()`.

### Utilizar `rate()` para contadores

Los buckets clásicos son contadores acumulativos.

Utilizar:

```promql
rate(metric_bucket[5m])
```

o:

```promql
increase(metric_bucket[5m])
```

según el objetivo del análisis.

### Elegir buckets adecuados

Los buckets deben cubrir el rango normal y los valores extremos esperados.

### Documentar las unidades

Indicar si los valores están en:

```text
Segundos
Milisegundos
Bytes
Kilobytes
```

### Comparar con percentiles

El Heatmap debe complementarse con percentiles cuando se necesite una lectura operativa rápida.

### Filtrar etiquetas

Evitar mezclar servicios o rutas que tengan comportamientos muy diferentes sin documentarlo.

### No interpretar el color como severidad automáticamente

La intensidad representa densidad, no necesariamente un estado de alerta.

### Utilizar rangos temporales coherentes

Comparar periodos con suficiente cantidad de observaciones.

### Revisar el número de series

Una consulta excesivamente amplia puede sobrecargar Prometheus y Grafana.

---

## Problemas habituales

### El Heatmap no muestra datos

Comprobar:

```promql
{__name__=~".*_bucket"}
```

Después:

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

Revisar:

- Nombre de la métrica.
- Existencia de `_bucket`.
- Etiqueta `le`.
- Fuente de datos.
- Rango temporal.
- Intervalo de scraping.
- Formato de datos.
- Transformaciones.

### La métrica no tiene `_bucket`

Puede que:

- No sea un histograma.
- Sea un Summary.
- La aplicación no esté instrumentada.
- Se esté utilizando otro nombre.
- La métrica no esté siendo recogida.

Un Summary suele exponer cuantiles directamente, pero no permite reconstruir la misma distribución que un histograma.

### El resultado de `histogram_quantile()` es `NaN`

Posibles causas:

- No existen observaciones.
- El contador no ha aumentado.
- Faltan buckets.
- Falta `+Inf`.
- La consulta agrupa incorrectamente.
- El rango temporal es demasiado corto.

### El percentil parece incorrecto

Comprobar:

- Que se conserva `le`.
- Que se utiliza `rate()` o `increase()`.
- Que los buckets están ordenados.
- Que se agrupa correctamente.
- Que las unidades son correctas.
- Que el rango temporal contiene suficiente tráfico.

### El Heatmap parece una serie temporal normal

Posibles causas:

- Grafana no reconoce correctamente los buckets.
- El formato de datos no está configurado.
- La consulta devuelve un formato incompatible.
- Se ha eliminado la etiqueta `le`.
- Se está utilizando una consulta de percentil en lugar de buckets.

### Todos los colores tienen la misma intensidad

Posibles causas:

- Muy pocas observaciones.
- Escala de color inadecuada.
- Rango temporal demasiado corto.
- Distribución muy concentrada.
- Consulta agregada incorrectamente.
- La métrica no se actualiza.

### El gráfico tiene demasiados datos

Aplicar:

- Filtros por servicio.
- Filtros por ruta.
- Filtros por instancia.
- Rangos temporales más cortos.
- Menor resolución.
- Consultas agrupadas.

### La latencia aparece en una unidad incorrecta

Si la métrica termina en:

```text
_seconds
```

utilizar segundos.

Si se multiplica por:

```promql
1000
```

el resultado pasa a milisegundos y la unidad debe cambiarse.

### La distribución no cambia

Posibles causas:

- No hay suficiente tráfico.
- La aplicación tiene una carga estable.
- El rango temporal es demasiado amplio.
- Se está observando una métrica incorrecta.
- La consulta utiliza un intervalo demasiado largo.
- Los buckets son demasiado amplios.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-heatmap
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-heatmap/consultas-promql.txt <<'EOF'
Localizar histogramas:
{__name__=~".*_bucket"}

Buckets de latencia:
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)

Percentil 50:
histogram_quantile(
  0.50,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)

Percentil 95:
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)

Percentil 99:
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)

Latencia media:
rate(http_request_duration_seconds_sum[5m])
/
rate(http_request_duration_seconds_count[5m])
EOF
```

Consultar los buckets:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=sum by (le) (rate(http_request_duration_seconds_bucket[5m]))' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-heatmap/buckets.json
```

Consultar el percentil 95:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-heatmap/p95.json
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-heatmap/informe.txt <<'EOF'
Práctica: Panel Heatmap

Dashboard utilizado:

Métrica de histograma:

Buckets identificados:

Unidad utilizada:

Rango temporal:

Consultas realizadas:

Percentiles calculados:

Servicio o instancia analizada:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-metricas-histograma.png
02-buckets.png
03-heatmap-latencias.png
04-heatmap-servicio.png
05-percentiles.png
06-heatmap-durante-carga.png
07-heatmap-sin-datos.png
08-heatmap-dashboard-final.png
```

---

## Práctica integradora

### Objetivo

Crear un dashboard para analizar la distribución temporal de latencias de una aplicación.

### Requisitos previos

Debe existir una métrica de histograma como:

```promql
http_request_duration_seconds_bucket
```

Si la métrica utiliza otro nombre, adaptar las consultas.

### Panel 1: Heatmap de latencias

Consulta:

```promql
sum by (le) (
  rate(http_request_duration_seconds_bucket[5m])
)
```

Configuración:

```text
Título: Distribución de latencias HTTP
Unidad: Seconds
Rango temporal: Last 1 hour
```

### Panel 2: percentil 50

```promql
histogram_quantile(
  0.50,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

Título:

```text
Latencia p50
```

Unidad:

```text
Seconds
```

### Panel 3: percentil 95

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

Título:

```text
Latencia p95
```

Unidad:

```text
Seconds
```

### Panel 4: percentil 99

```promql
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

Título:

```text
Latencia p99
```

Unidad:

```text
Seconds
```

### Panel 5: latencia media

```promql
rate(http_request_duration_seconds_sum[5m])
/
rate(http_request_duration_seconds_count[5m])
```

Título:

```text
Latencia media
```

Unidad:

```text
Seconds
```

### Distribución propuesta

```text
+------------------------------------------------------+
| Distribución de latencias HTTP                       |
+------------------------------------------------------+
| Latencia p50       | Latencia p95                    |
+--------------------+---------------------------------+
| Latencia p99       | Latencia media                  |
+--------------------+---------------------------------+
```

### Tareas

1. Localizar la métrica de histograma.
2. Identificar sus buckets.
3. Crear el Heatmap.
4. Configurar la unidad.
5. Crear los paneles de percentiles.
6. Crear el panel de latencia media.
7. Comparar la distribución con los percentiles.
8. Filtrar un servicio concreto.
9. Generar tráfico de prueba.
10. Observar cambios en la distribución.
11. Revisar los valores extremos.
12. Diagnosticar una consulta incorrecta.
13. Utilizar el inspector.
14. Exportar el dashboard.
15. Guardar las evidencias.
16. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Histograma localizado | | |
| Buckets identificados | | |
| Bucket `+Inf` comprobado | | |
| Heatmap creado | | |
| Unidad configurada | | |
| Heatmap interpretado | | |
| Percentil 50 calculado | | |
| Percentil 95 calculado | | |
| Percentil 99 calculado | | |
| Latencia media calculada | | |
| Servicio filtrado | | |
| Prueba de carga realizada | | |
| Cambio de distribución observado | | |
| Consulta incorrecta diagnosticada | | |
| Inspector utilizado | | |
| Dashboard exportado | | |
| Evidencias guardadas | | |

---

## Puntos clave

- Un Heatmap representa la distribución de valores a lo largo del tiempo.
- Cada celda combina un intervalo temporal y un intervalo de valores.
- La intensidad del color representa la densidad de observaciones.
- Un bucket agrupa valores hasta un límite determinado.
- Los histogramas clásicos de Prometheus generan series `_bucket`, `_sum` y `_count`.
- La etiqueta `le` identifica el límite superior de cada bucket.
- El bucket `+Inf` representa todas las observaciones.
- `rate()` permite convertir contadores en tasas de observación.
- `histogram_quantile()` permite calcular percentiles.
- El Heatmap muestra más información que una media aislada.
- Un percentil resume una distribución en un valor.
- La unidad debe corresponder a la métrica original.
- Las latencias expresadas en segundos deben utilizar la unidad `Seconds`.
- Los buckets deben cubrir el rango normal y los valores extremos.
- Demasiados buckets pueden aumentar el coste de consulta.
- Muy pocos buckets reducen la precisión de la distribución.
- La intensidad de color no significa automáticamente estado crítico.
- Es recomendable combinar Heatmap con percentiles.
- La etiqueta `le` debe conservarse al calcular cuantiles.
- Un Heatmap sin datos puede deberse a una métrica inexistente, una consulta incorrecta o una falta de observaciones.
- El formato de datos debe ser compatible con la versión de Grafana.
- El rango temporal debe contener suficientes muestras para que la distribución sea interpretable.

---

## Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Heatmap?
2. ¿Qué diferencia existe entre un Heatmap y un Time series?
3. ¿Qué representa la intensidad del color?
4. ¿Qué es un bucket?
5. ¿Qué significa la etiqueta `le`?
6. ¿Qué información contiene una métrica `_bucket`?
7. ¿Qué información contiene una métrica `_sum`?
8. ¿Qué información contiene una métrica `_count`?
9. ¿Qué función cumple el bucket `+Inf`?
10. ¿Qué función cumple `rate()` en una consulta de histograma?
11. ¿Qué función cumple `histogram_quantile()`?
12. ¿Qué consulta utilizarías para calcular el percentil 95?
13. ¿Por qué debe conservarse la etiqueta `le`?
14. ¿Qué diferencia existe entre una media y un percentil?
15. ¿Qué información adicional proporciona un Heatmap?
16. ¿Qué ocurre si existen demasiados buckets?
17. ¿Qué ocurre si existen muy pocos buckets?
18. ¿Qué revisarías si el Heatmap no muestra datos?
19. ¿Qué puede provocar que un percentil devuelva `NaN`?
20. ¿Cómo buscarías métricas de tipo histograma?
21. ¿Qué unidad utilizarías para una métrica terminada en `_seconds_bucket`?
22. ¿Por qué no debe interpretarse automáticamente un color intenso como una alerta?
23. ¿Qué diferencia existe entre un histograma y un Summary?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué paneles combinarías con un Heatmap en un dashboard de latencias?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de utilizar un Heatmap para analizar distribuciones temporales y no únicamente valores medios.

El proceso completo será:

```text
Localizar una métrica de histograma
        |
        v
Identificar sus buckets
        |
        v
Conservar la etiqueta le
        |
        v
Aplicar rate() o increase()
        |
        v
Agrupar las series correctamente
        |
        v
Seleccionar Heatmap
        |
        v
Configurar unidad y escala
        |
        v
Interpretar la densidad de valores
        |
        v
Comparar con percentiles
        |
        v
Diagnosticar anomalías
        |
        v
Guardar y documentar
```

El resultado final debe ser un dashboard capaz de mostrar cómo se distribuyen las latencias, duraciones o tamaños a lo largo del tiempo, permitiendo detectar desplazamientos de la distribución, valores extremos y degradaciones que podrían quedar ocultas al observar únicamente la media.