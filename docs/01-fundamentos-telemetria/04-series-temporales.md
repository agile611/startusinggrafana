# Series temporales

## Objetivos

Al finalizar esta sección podrás:

- Explicar qué es una serie temporal y cómo se estructura.
- Identificar el significado de las etiquetas asociadas a una métrica.
- Diferenciar entre una métrica, una muestra y una serie temporal.
- Comprender cómo almacena Prometheus los datos de monitorización.
- Utilizar consultas PromQL básicas sobre series temporales.
- Reconocer los riesgos de generar demasiadas series temporales.

## Introducción

Una **serie temporal** es una secuencia de valores registrados a lo largo del tiempo.

En monitorización, cada valor representa el estado de una métrica en un instante concreto. Por ejemplo:

- El porcentaje de uso de CPU.
- La memoria disponible.
- El número de solicitudes HTTP.
- La temperatura de un servidor.
- El número de errores de una aplicación.
- El estado de un servicio.

Una métrica aislada proporciona información limitada. Sin embargo, cuando se almacenan sus valores sucesivos, es posible observar su evolución.

Por ejemplo, el uso de CPU de un servidor podría registrarse de esta forma:

```text
10:00 → 24 %
10:01 → 31 %
10:02 → 45 %
10:03 → 72 %
10:04 → 68 %
```

Estos valores permiten analizar tendencias, detectar anomalías y generar alertas.

Prometheus está diseñado para almacenar y consultar datos como series temporales. Grafana utiliza posteriormente esas series para construir gráficos, paneles y alertas visuales.

## Contenido

### ¿Qué es una serie temporal?

Una serie temporal está formada por tres elementos principales:

1. Un nombre de métrica.
2. Un conjunto de etiquetas.
3. Una secuencia de muestras con marca temporal.

Un ejemplo de métrica de Prometheus es:

```text
node_memory_MemAvailable_bytes{
  instance="192.168.1.50:9100",
  job="node"
}
```

El nombre de la métrica es:

```text
node_memory_MemAvailable_bytes
```

Las etiquetas son:

```text
instance="192.168.1.50:9100"
job="node"
```

Cada valor registrado en un momento determinado constituye una muestra:

```text
node_memory_MemAvailable_bytes{
  instance="192.168.1.50:9100",
  job="node"
} 4294967296
```

El número final representa el valor de la métrica en ese instante.

Conceptualmente, una muestra puede representarse como:

```text
métrica + etiquetas + marca temporal + valor
```

### Ejemplo de muestras sucesivas

Supongamos que Prometheus recopila el uso de CPU cada 15 segundos:

```text
node_cpu_usage_percent{
  instance="192.168.1.50:9100",
  job="node"
} 18.4 10:00:00

node_cpu_usage_percent{
  instance="192.168.1.50:9100",
  job="node"
} 22.7 10:00:15

node_cpu_usage_percent{
  instance="192.168.1.50:9100",
  job="node"
} 35.2 10:00:30

node_cpu_usage_percent{
  instance="192.168.1.50:9100",
  job="node"
} 41.8 10:00:45
```

Aunque el nombre y las etiquetas sean iguales, cada registro corresponde a un momento diferente.

Todos ellos forman una única serie temporal:

```text
node_cpu_usage_percent{
  instance="192.168.1.50:9100",
  job="node"
}
```

### Nombre de métrica

El nombre identifica qué se está midiendo.

Algunos ejemplos habituales son:

```text
node_cpu_seconds_total
node_memory_MemAvailable_bytes
node_filesystem_avail_bytes
http_requests_total
process_resident_memory_bytes
```

Los nombres de las métricas suelen proporcionar información sobre:

- El componente observado.
- El tipo de dato.
- La unidad de medida.
- El comportamiento de la métrica.

Por ejemplo:

```text
node_memory_MemAvailable_bytes
```

puede interpretarse como:

- `node`: métrica relacionada con el sistema.
- `memory`: información de memoria.
- `MemAvailable`: memoria disponible.
- `bytes`: unidad de medida en bytes.

Los nombres deben ser claros y coherentes. Una nomenclatura uniforme facilita el mantenimiento y la creación de consultas.

### Etiquetas

Las etiquetas permiten diferenciar varias series que comparten el mismo nombre de métrica.

Por ejemplo:

```text
http_requests_total{
  method="GET",
  status="200",
  handler="/api/users"
}
```

Esta métrica puede tener otras series asociadas:

```text
http_requests_total{
  method="POST",
  status="201",
  handler="/api/users"
}
```

```text
http_requests_total{
  method="GET",
  status="500",
  handler="/api/users"
}
```

Todas utilizan el mismo nombre:

```text
http_requests_total
```

Pero cada combinación de etiquetas representa una serie temporal distinta.

Las etiquetas pueden describir:

- El servidor.
- El puerto.
- El servicio.
- El entorno.
- El método HTTP.
- El código de respuesta.
- El nombre de la instancia.
- La región.
- El dispositivo.
- El punto de montaje.

### Identidad de una serie temporal

En Prometheus, una serie temporal queda identificada por la combinación de:

- Nombre de la métrica.
- Nombre de cada etiqueta.
- Valor de cada etiqueta.

Estas dos series son diferentes:

```text
up{job="node", instance="server-a:9100"}
```

```text
up{job="node", instance="server-b:9100"}
```

También son diferentes:

```text
http_requests_total{method="GET", status="200"}
```

```text
http_requests_total{method="GET", status="500"}
```

La combinación de etiquetas debe ser suficientemente descriptiva, pero no debe generar un número innecesario de series.

### Marcas temporales

Cada muestra debe asociarse a un instante.

Por ejemplo:

```text
node_memory_MemAvailable_bytes 4294967296 1710000000000
```

La marca temporal permite conocer cuándo se registró el valor.

En la interfaz de Prometheus y en Grafana, las marcas temporales se utilizan para:

- Ordenar los valores.
- Dibujar gráficos.
- Calcular cambios.
- Analizar tendencias.
- Comparar periodos.
- Detectar interrupciones.
- Evaluar reglas de alerta.

Si una métrica deja de actualizarse, la ausencia de nuevas muestras puede indicar:

- Que el servicio está detenido.
- Que el exporter no responde.
- Que existe un problema de red.
- Que la configuración de scraping es incorrecta.
- Que el proceso ya no genera datos.

### Intervalo de recopilación

Prometheus recopila métricas mediante intervalos de scraping.

Por ejemplo:

```yaml
global:
  scrape_interval: 15s
```

Esta configuración indica que Prometheus intentará recopilar las métricas cada 15 segundos.

Un intervalo corto permite observar cambios rápidamente, pero aumenta:

- El número de solicitudes.
- El volumen de datos.
- El consumo de almacenamiento.
- La carga sobre Prometheus y los exporters.

Un intervalo largo reduce el consumo, pero puede ocultar cambios breves.

La elección debe adaptarse a la naturaleza de la métrica:

| Tipo de dato | Intervalo orientativo |
|---|---:|
| Estado de un servicio | 15-30 segundos |
| Uso general de CPU | 15-30 segundos |
| Métricas de infraestructura | 15-60 segundos |
| Procesos de larga duración | 30-60 segundos |
| Eventos muy rápidos | Puede requerir instrumentación específica |
| Trabajos por lotes | Puede ser adecuado utilizar Pushgateway |

No existe un intervalo universalmente correcto. Debe elegirse teniendo en cuenta la frecuencia del cambio y la importancia operativa de la métrica.

### Resolución y retención

La **resolución** indica con qué frecuencia se registran los valores.

Si una métrica se recopila cada 15 segundos, se obtiene una resolución aproximada de 15 segundos.

La **retención** indica durante cuánto tiempo se conservan los datos.

Por ejemplo:

```text
Resolución: 15 segundos
Retención: 30 días
```

Esto significa que Prometheus intentará almacenar muestras aproximadamente cada 15 segundos durante los últimos 30 días.

La retención influye en:

- El espacio de almacenamiento.
- La capacidad de analizar históricos.
- El rendimiento de las consultas.
- El coste de la infraestructura.

Una retención más larga no siempre es la mejor opción. Las métricas de alta resolución pueden ocupar mucho espacio con el paso del tiempo.

### Tipos de métricas y series temporales

Prometheus dispone de varios tipos de métricas.

#### Counter

Un `counter` representa un valor que normalmente aumenta con el tiempo.

Ejemplos:

```text
http_requests_total
node_cpu_seconds_total
errors_total
```

Un contador puede reiniciarse cuando se reinicia el proceso que lo genera.

Para analizar la velocidad de cambio de un contador se utilizan funciones como:

```promql
rate(http_requests_total[5m])
```

No debe interpretarse directamente un contador como una velocidad. Un valor de:

```text
http_requests_total 150000
```

indica el total acumulado, no el número de solicitudes por segundo.

#### Gauge

Un `gauge` representa un valor que puede aumentar o disminuir.

Ejemplos:

```text
node_memory_MemAvailable_bytes
node_load1
temperature_celsius
```

Para consultar el valor actual de un `gauge`:

```promql
node_memory_MemAvailable_bytes
```

Para obtener el promedio de los últimos cinco minutos:

```promql
avg_over_time(node_memory_MemAvailable_bytes[5m])
```

#### Histogram

Un `histogram` permite analizar la distribución de valores, como la duración de solicitudes.

Ejemplos de componentes de un histograma:

```text
http_request_duration_seconds_bucket
http_request_duration_seconds_sum
http_request_duration_seconds_count
```

Puede utilizarse para calcular percentiles aproximados, como el percentil 95:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

#### Summary

Un `summary` calcula determinados valores estadísticos en el cliente o en la aplicación.

Puede incluir:

- Número total de observaciones.
- Suma de los valores.
- Cuantiles configurados.

Los `summary` y los `histogram` tienen características diferentes. La elección depende de si se necesitan agregaciones entre instancias y de cómo se desea calcular la distribución.

### Cardinalidad

La **cardinalidad** es el número de series temporales diferentes generadas por una métrica.

Por ejemplo, esta métrica tiene una serie por cada combinación de `method` y `status`:

```text
http_requests_total{
  method="GET",
  status="200"
}
```

```text
http_requests_total{
  method="GET",
  status="500"
}
```

```text
http_requests_total{
  method="POST",
  status="201"
}
```

Si una etiqueta puede tener muchos valores distintos, la cardinalidad puede crecer rápidamente.

Una mala práctica sería utilizar identificadores únicos como etiquetas:

```text
http_requests_total{
  user_id="982734982"
}
```

```text
http_requests_total{
  request_id="a8f12c..."
}
```

Cada usuario o solicitud puede generar una serie nueva. En aplicaciones con mucho tráfico, esto puede producir miles o millones de series.

Una cardinalidad excesiva puede provocar:

- Mayor consumo de memoria.
- Mayor uso de disco.
- Consultas más lentas.
- Mayor tiempo de compactación.
- Dificultades para mantener Prometheus estable.

Las etiquetas deben representar categorías controladas y reutilizables.

Ejemplos normalmente adecuados:

```text
method="GET"
status="200"
environment="production"
region="eu-west"
```

Ejemplos potencialmente peligrosos:

```text
user_id="..."
request_id="..."
session_id="..."
timestamp="..."
```

### Consultar series temporales con PromQL

Para consultar todas las series de una métrica:

```promql
up
```

Para filtrar por una etiqueta:

```promql
up{job="node"}
```

Para seleccionar una instancia concreta:

```promql
up{instance="192.168.1.50:9100"}
```

Para seleccionar varios valores:

```promql
up{job=~"node|prometheus"}
```

Para excluir una etiqueta:

```promql
up{job!="node"}
```

Para comprobar la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Para convertir bytes a gigabytes:

```promql
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

Para consultar el número de series que contiene una métrica:

```promql
count(http_requests_total)
```

Para agrupar por código de estado:

```promql
sum by (status) (
  rate(http_requests_total[5m])
)
```

Para agrupar por instancia:

```promql
sum by (instance) (
  rate(http_requests_total[5m])
)
```

Las consultas pueden seleccionar una instantánea concreta o un intervalo de tiempo.

### Instant vector y range vector

PromQL distingue entre varios tipos de datos.

Un **instant vector** contiene el último valor disponible de un conjunto de series:

```promql
up
```

Un **range vector** contiene los valores registrados durante un intervalo:

```promql
up[5m]
```

El selector:

```promql
[5m]
```

indica que se deben considerar las muestras de los últimos cinco minutos.

Las funciones como `rate` necesitan normalmente un rango:

```promql
rate(node_cpu_seconds_total[5m])
```

Esto permite calcular la velocidad media de cambio durante ese periodo.

### Valores ausentes y series obsoletas

Una serie temporal puede dejar de recibir muestras.

Esto puede suceder cuando:

- Un servidor se apaga.
- Un contenedor se elimina.
- Un exporter deja de responder.
- Cambia la configuración de descubrimiento.
- Una etiqueta deja de utilizarse.
- El objetivo deja de existir.

Es importante distinguir entre:

- Una métrica cuyo valor es cero.
- Una métrica que no existe.
- Una métrica cuyo objetivo no responde.

Por ejemplo:

```text
up = 0
```

indica normalmente que el objetivo fue detectado, pero el scraping falló.

En cambio, la ausencia total de la serie puede indicar que Prometheus ya no conoce ese objetivo o que la serie no se ha generado.

## Ejemplo

### Analizar el uso de CPU de un servidor

Node Exporter expone la métrica:

```text
node_cpu_seconds_total
```

Esta métrica es un contador que registra el tiempo acumulado que las CPU han pasado en cada estado.

Ejemplos de estados:

```text
mode="idle"
mode="user"
mode="system"
mode="iowait"
```

Una consulta para calcular el porcentaje aproximado de CPU utilizada es:

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

La consulta funciona de la siguiente forma:

1. Selecciona las series de tiempo de CPU en estado `idle`.
2. Calcula la velocidad de cambio durante los últimos cinco minutos.
3. Agrupa el resultado por instancia.
4. Calcula la proporción de CPU no inactiva.
5. Multiplica el resultado por 100 para obtener un porcentaje.

Si el resultado es:

```text
37.5
```

significa que el uso medio estimado de CPU durante el periodo analizado es aproximadamente del:

```text
37,5 %
```

### Analizar la memoria disponible

Node Exporter expone la memoria disponible en bytes:

```promql
node_memory_MemAvailable_bytes
```

Para mostrarla en gigabytes:

```promql
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

Para obtener la memoria disponible media durante los últimos diez minutos:

```promql
avg_over_time(
  node_memory_MemAvailable_bytes[10m]
) / 1024 / 1024 / 1024
```

Para calcular el porcentaje de memoria disponible:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Para calcular el porcentaje de memoria utilizada:

```promql
100 *
(
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Estas consultas permiten crear paneles de tipo:

- Time series.
- Stat.
- Gauge.
- Bar gauge.

### Analizar solicitudes HTTP

Supongamos que una aplicación expone la métrica:

```text
http_requests_total
```

con las siguientes etiquetas:

```text
method
status
handler
```

Para calcular solicitudes por segundo:

```promql
sum(
  rate(http_requests_total[5m])
)
```

Para agrupar por código de estado:

```promql
sum by (status) (
  rate(http_requests_total[5m])
)
```

Para analizar solo los errores del servidor:

```promql
sum(
  rate(http_requests_total{
    status=~"5.."
  }[5m])
)
```

Para calcular el porcentaje de errores:

```promql
100 *
sum(
  rate(http_requests_total{
    status=~"5.."
  }[5m])
)
/
sum(
  rate(http_requests_total[5m])
)
```

El resultado muestra la proporción de solicitudes con respuestas de error `5xx`.

### Representar una serie temporal en Grafana

Para crear un panel básico en Grafana:

1. Accede a Grafana.
2. Abre un dashboard existente o crea uno nuevo.
3. Añade un panel.
4. Selecciona Prometheus como fuente de datos.
5. Introduce una consulta PromQL.
6. Selecciona la visualización `Time series`.
7. Define el intervalo de tiempo.
8. Configura la unidad del eje vertical.
9. Guarda el panel.

Para un panel de CPU, una consulta adecuada sería:

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

En Grafana conviene configurar:

```text
Unidad: Percent (0-100)
Leyenda: {{instance}}
Visualización: Time series
```

Para un panel de memoria:

```text
Unidad: Bytes (IEC)
Visualización: Time series
```

La elección de la unidad es importante. Una consulta que devuelve bytes no debería representarse como porcentaje, y una consulta que devuelve una proporción no debería mostrarse como temperatura. Las métricas también merecen una etiqueta de unidad digna.

## Puntos clave

- Una serie temporal registra valores a lo largo del tiempo.
- Cada muestra contiene un valor y una marca temporal.
- Una serie se identifica mediante el nombre de la métrica y sus etiquetas.
- Dos series con el mismo nombre, pero con etiquetas diferentes, son series distintas.
- Prometheus almacena datos en forma de series temporales.
- El intervalo de scraping determina aproximadamente la frecuencia de recopilación.
- La resolución indica la frecuencia de las muestras.
- La retención indica durante cuánto tiempo se conservan los datos.
- Los `counter` normalmente aumentan y se analizan con funciones como `rate`.
- Los `gauge` pueden aumentar o disminuir.
- Los histogramas permiten estudiar distribuciones de valores.
- La cardinalidad es el número de series temporales generadas.
- Las etiquetas con valores ilimitados pueden producir una cardinalidad excesiva.
- `up` permite comprobar la disponibilidad de un objetivo.
- Un valor cero no es lo mismo que una serie inexistente.
- Grafana utiliza consultas PromQL para representar las series en paneles.
- Las unidades deben configurarse correctamente en las visualizaciones.

## Preguntas de comprobación

1. ¿Qué es una serie temporal?
2. ¿Qué elementos identifican una serie temporal en Prometheus?
3. ¿Qué diferencia existe entre una muestra y una serie temporal?
4. ¿Qué función cumplen las etiquetas?
5. ¿Qué representan las marcas temporales?
6. ¿Qué efecto tiene configurar un `scrape_interval` de `15s`?
7. ¿Qué ventajas e inconvenientes tiene utilizar un intervalo de scraping muy corto?
8. ¿Qué es la retención de datos?
9. ¿Qué diferencia existe entre un `counter` y un `gauge`?
10. ¿Por qué se utiliza `rate` con una métrica de tipo `counter`?
11. ¿Qué es la cardinalidad?
12. ¿Por qué `request_id` puede ser una etiqueta peligrosa?
13. ¿Qué indica normalmente la métrica `up`?
14. ¿Qué diferencia existe entre `up = 0` y una serie que no existe?
15. ¿Qué consulta utilizarías para calcular solicitudes por segundo?
16. ¿Qué consulta utilizarías para obtener la memoria disponible en gigabytes?
17. ¿Qué tipo de visualización de Grafana resulta adecuada para observar la evolución de una métrica?
18. ¿Por qué es importante configurar correctamente la unidad de un panel?
19. ¿Qué problema puede aparecer si se conservan durante mucho tiempo métricas de alta resolución?
20. ¿Qué relación existe entre una métrica, sus etiquetas y la cardinalidad?
```