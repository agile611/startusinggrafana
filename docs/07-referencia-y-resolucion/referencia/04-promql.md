# Consultas PromQL

PromQL, abreviatura de Prometheus Query Language, es el lenguaje utilizado para consultar, seleccionar, transformar y agregar métricas almacenadas en Prometheus.

Durante el curso se utilizará PromQL para analizar métricas de Node Exporter y construir paneles operativos en Grafana. Las consultas permitirán responder preguntas como:

- ¿Está disponible un servicio?
- ¿Qué porcentaje de CPU está utilizando el equipo?
- ¿Cuánta memoria queda disponible?
- ¿Qué espacio libre existe en el sistema de archivos?
- ¿Cuál es el tráfico de red?
- ¿Qué targets están caídos?
- ¿Cómo ha evolucionado una métrica durante los últimos minutos?

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Comprender la estructura de una métrica de Prometheus.
- Ejecutar consultas instantáneas en la interfaz web de Prometheus.
- Utilizar selectores de métricas y etiquetas.
- Diferenciar entre vectores instantáneos y vectores de rango.
- Utilizar operadores aritméticos, de comparación y lógicos.
- Calcular porcentajes de CPU, memoria y almacenamiento.
- Utilizar funciones como `rate`, `irate`, `increase`, `avg_over_time` y `max_over_time`.
- Agrupar resultados mediante `sum`, `avg`, `min`, `max` y `count`.
- Filtrar resultados con etiquetas.
- Detectar targets disponibles y no disponibles.
- Integrar consultas PromQL en Grafana.
- Crear consultas reutilizables para dashboards y alertas.
- Diagnosticar errores habituales de sintaxis y de interpretación.

## Introducción

Prometheus almacena datos como series temporales. Cada serie está formada por:

- Un nombre de métrica.
- Un conjunto de etiquetas.
- Una secuencia de valores asociados a marcas de tiempo.

Una serie temporal puede representarse conceptualmente así:

```text
nombre_de_metrica{etiqueta="valor"} valor
```

Ejemplo:

```text
up{job="node_exporter", instance="localhost:9100"} 1
```

En este ejemplo:

- `up` es el nombre de la métrica.
- `job` e `instance` son etiquetas.
- `node_exporter` y `localhost:9100` son valores de etiquetas.
- `1` indica que el target está disponible.

Si el target no está disponible, Prometheus normalmente mostrará:

```text
up{job="node_exporter", instance="localhost:9100"} 0
```

## Acceso a la interfaz de Prometheus

La interfaz web de Prometheus suele estar disponible en:

```text
http://localhost:9090
```

Para ejecutar una consulta:

1. Abre Prometheus en el navegador.
2. Accede a la sección **Query** o **Graph**.
3. Escribe una consulta en el campo de expresión.
4. Ejecuta la consulta.
5. Selecciona la vista de tabla o gráfico.
6. Revisa las etiquetas y los valores devueltos.

### Comprobar que Prometheus está disponible

Desde la terminal:

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Ejecutar una consulta mediante la API

La API HTTP de Prometheus permite ejecutar consultas desde la terminal.

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

Si `jq` está instalado:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

## Estructura de una métrica

### Nombre de métrica

Una consulta sencilla puede contener únicamente el nombre de una métrica:

```promql
up
```

Esta consulta devuelve el estado de todos los targets conocidos por Prometheus.

Otros ejemplos:

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

```promql
node_load1
```

### Etiquetas

Las etiquetas permiten diferenciar distintas series que comparten el mismo nombre de métrica.

Ejemplo:

```promql
up{job="node_exporter"}
```

Esta consulta devuelve únicamente las series cuyo valor de `job` sea `node_exporter`.

Otro ejemplo:

```promql
node_memory_MemAvailable_bytes{instance="localhost:9100"}
```

### Selector exacto

El operador `=` selecciona etiquetas con un valor exacto:

```promql
up{job="node_exporter"}
```

### Selector distinto

El operador `!=` excluye las series cuyo valor coincide:

```promql
up{job!="node_exporter"}
```

### Expresión regular positiva

El operador `=~` selecciona valores que coinciden con una expresión regular:

```promql
up{job=~"node_exporter|prometheus"}
```

Seleccionar varias instancias:

```promql
up{instance=~"server01:9100|server02:9100"}
```

### Expresión regular negativa

El operador `!~` excluye los valores que coinciden con una expresión regular:

```promql
up{job!~"pushgateway|blackbox"}
```

### Combinar varias etiquetas

```promql
up{
  job="node_exporter",
  instance="localhost:9100"
}
```

Las etiquetas dentro de un selector se separan mediante comas.

## Tipos de datos de PromQL

PromQL trabaja con varios tipos de datos principales.

### Vector instantáneo

Un vector instantáneo contiene una muestra por cada serie seleccionada en un momento concreto.

Ejemplo:

```promql
up
```

También:

```promql
node_load1
```

### Vector de rango

Un vector de rango contiene las muestras de una serie durante un intervalo de tiempo.

Se indica entre corchetes:

```promql
node_cpu_seconds_total[5m]
```

Las unidades de tiempo más utilizadas son:

| Unidad | Significado |
|---|---|
| `s` | Segundos |
| `m` | Minutos |
| `h` | Horas |
| `d` | Días |
| `w` | Semanas |
| `y` | Años |

Ejemplos:

```promql
up[10m]
```

```promql
node_network_receive_bytes_total[1h]
```

### Escalar

Un escalar es un valor numérico sin etiquetas.

Ejemplo:

```promql
100
```

También puede obtenerse mediante funciones:

```promql
scalar(count(up))
```

### Cadena

PromQL admite cadenas en contextos concretos, aunque las consultas operativas habituales utilizan principalmente vectores y escalares.

## Consultas básicas

### Consultar todos los targets

```promql
up
```

### Consultar Node Exporter

```promql
up{job="node_exporter"}
```

### Consultar una métrica concreta

```promql
node_load1
```

### Consultar la memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Consultar la memoria total

```promql
node_memory_MemTotal_bytes
```

### Consultar el espacio disponible

```promql
node_filesystem_avail_bytes
```

### Consultar el tamaño total del sistema de archivos

```promql
node_filesystem_size_bytes
```

### Consultar el tiempo de actividad

```promql
node_time_seconds - node_boot_time_seconds
```

### Consultar información de la máquina

```promql
node_uname_info
```

## Operadores aritméticos

PromQL permite utilizar operadores matemáticos.

| Operador | Operación |
|---|---|
| `+` | Suma |
| `-` | Resta |
| `*` | Multiplicación |
| `/` | División |
| `%` | Módulo |
| `^` | Potencia |

### Convertir bytes a gigabytes

```promql
node_memory_MemTotal_bytes / 1024 / 1024 / 1024
```

También puedes utilizar una aproximación decimal:

```promql
node_memory_MemTotal_bytes / 1e9
```

### Calcular memoria utilizada

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Calcular memoria utilizada en porcentaje

```promql
(
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) * 100
```

### Calcular memoria disponible en porcentaje

```promql
(
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) * 100
```

### Convertir bytes por segundo a megabytes por segundo

```promql
rate(node_network_receive_bytes_total[5m])
/ 1024 / 1024
```

## Operadores de comparación

Los operadores de comparación permiten filtrar o evaluar valores.

| Operador | Significado |
|---|---|
| `==` | Igual |
| `!=` | Distinto |
| `>` | Mayor que |
| `<` | Menor que |
| `>=` | Mayor o igual que |
| `<=` | Menor o igual que |

### Targets caídos

```promql
up == 0
```

### Targets disponibles

```promql
up == 1
```

### Memoria disponible inferior al 20 %

```promql
(
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) * 100 < 20
```

### Sistemas de archivos con menos del 15 % libre

```promql
(
  node_filesystem_avail_bytes
  /
  node_filesystem_size_bytes
) * 100 < 15
```

### CPU con carga elevada

```promql
node_load1 > 2
```

El valor adecuado depende del número de CPU y de las características del equipo. Un umbral fijo no debe interpretarse sin contexto.

## Operadores lógicos

### Operador `and`

Devuelve las series que cumplen ambas condiciones:

```promql
up == 0 and up{job="node_exporter"}
```

### Operador `or`

Devuelve las series que cumplen una condición u otra:

```promql
up{job="node_exporter"} or up{job="prometheus"}
```

### Operador `unless`

Devuelve las series de la primera expresión que no tengan correspondencia en la segunda:

```promql
up unless up{job="node_exporter"}
```

## Métricas de disponibilidad

### Métrica `up`

La métrica `up` es una de las métricas más importantes de Prometheus.

```promql
up
```

Interpretación:

| Valor | Significado |
|---:|---|
| `1` | El scraping ha funcionado |
| `0` | El scraping ha fallado |

### Comprobar Node Exporter

```promql
up{job="node_exporter"}
```

### Contar targets disponibles

```promql
count(up == 1)
```

### Contar targets caídos

```promql
count(up == 0)
```

### Calcular el porcentaje de targets disponibles

```promql
100 * sum(up) / count(up)
```

### Calcular la disponibilidad de Node Exporter

```promql
100 *
sum(up{job="node_exporter"})
/
count(up{job="node_exporter"})
```

### Mostrar únicamente targets caídos

```promql
up{job="node_exporter"} == 0
```

### Consultar el último error de scraping

La información detallada del último error se consulta normalmente mediante la interfaz de targets o la API de Prometheus:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

## Métricas de CPU

Node Exporter expone la métrica:

```promql
node_cpu_seconds_total
```

Esta métrica es un contador acumulativo. Por ese motivo, normalmente se consulta mediante `rate` o `irate`.

### CPU por modo

```promql
rate(node_cpu_seconds_total[5m])
```

La consulta devuelve series diferenciadas por etiquetas como:

```text
cpu
mode
instance
job
```

### CPU en modo idle

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Porcentaje de CPU utilizada

Una consulta habitual es:

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

La consulta:

1. Calcula la tasa de tiempo en modo `idle`.
2. Obtiene la media entre las CPU.
3. Resta el resultado a `1`.
4. Multiplica por `100`.

### CPU utilizada por instancia

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

### CPU utilizada por núcleo

```promql
100 * (
  1 -
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### CPU utilizada por modo

```promql
100 *
sum by (instance, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

### Uso de CPU durante un intervalo corto

```promql
100 * (
  1 -
  avg by (instance) (
    irate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

`irate` reacciona más rápidamente a cambios recientes, pero puede ser más inestable que `rate`. Para dashboards operativos suele ser preferible `rate`.

## Métricas de memoria

### Memoria total

```promql
node_memory_MemTotal_bytes
```

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Memoria libre

```promql
node_memory_MemFree_bytes
```

`MemFree` y `MemAvailable` no significan exactamente lo mismo. Para estimar la memoria utilizable por el sistema suele ser más adecuado utilizar `MemAvailable`.

### Memoria utilizada

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Memoria utilizada en porcentaje

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Memoria disponible en porcentaje

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Memoria utilizada en gigabytes

```promql
(
  node_memory_MemTotal_bytes
  -
  node_memory_MemAvailable_bytes
) / 1024 / 1024 / 1024
```

### Memoria disponible en gigabytes

```promql
node_memory_MemAvailable_bytes
/ 1024 / 1024 / 1024
```

## Métricas de almacenamiento

Node Exporter proporciona métricas de sistemas de archivos.

### Espacio disponible

```promql
node_filesystem_avail_bytes
```

### Espacio libre para usuarios no privilegiados

```promql
node_filesystem_avail_bytes
```

### Tamaño total del sistema de archivos

```promql
node_filesystem_size_bytes
```

### Espacio utilizado

```promql
node_filesystem_size_bytes
-
node_filesystem_avail_bytes
```

### Porcentaje utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes
  /
  node_filesystem_size_bytes
)
```

### Porcentaje libre

```promql
100 *
node_filesystem_avail_bytes
/
node_filesystem_size_bytes
```

### Filtrar un punto de montaje

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

### Filtrar por sistema de archivos

```promql
node_filesystem_avail_bytes{
  fstype="ext4"
}
```

### Excluir sistemas de archivos virtuales

```promql
node_filesystem_avail_bytes{
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Excluir dispositivos temporales

```promql
node_filesystem_avail_bytes{
  device!~"rootfs|tmpfs"
}
```

### Porcentaje utilizado de la raíz

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Filtrar valores no válidos

En algunos sistemas aparecen sistemas de archivos con tamaño cero. Para evitar divisiones problemáticas:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/"
  }
)
and
node_filesystem_size_bytes{
  mountpoint="/"
} > 0
```

## Métricas de red

Las métricas de tráfico de red suelen ser contadores acumulativos.

### Bytes recibidos

```promql
node_network_receive_bytes_total
```

### Bytes transmitidos

```promql
node_network_transmit_bytes_total
```

### Tráfico recibido por segundo

```promql
rate(node_network_receive_bytes_total[5m])
```

### Tráfico transmitido por segundo

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Tráfico recibido en megabytes por segundo

```promql
rate(node_network_receive_bytes_total[5m])
/ 1024 / 1024
```

### Filtrar una interfaz

```promql
rate(
  node_network_receive_bytes_total{
    device="eth0"
  }[5m]
)
```

En algunos entornos la interfaz puede llamarse:

```text
ens33
enp0s3
eth0
wlan0
```

Consultar las interfaces disponibles:

```promql
node_network_receive_bytes_total
```

### Excluir interfaces virtuales

```promql
rate(
  node_network_receive_bytes_total{
    device!~"lo|docker.*|veth.*|br-.*"
  }[5m]
)
```

### Errores de recepción

```promql
rate(node_network_receive_errs_total[5m])
```

### Paquetes descartados

```promql
rate(node_network_receive_drop_total[5m])
```

## Métricas de carga

### Carga de un minuto

```promql
node_load1
```

### Carga de cinco minutos

```promql
node_load5
```

### Carga de quince minutos

```promql
node_load15
```

### Comparar carga con el número de CPU

```promql
node_load1
/
count by (instance) (
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

Una carga superior al número de CPU puede indicar una presión importante, aunque debe interpretarse junto con el uso de CPU, la memoria y la espera de disco.

## Métricas de tiempo y actividad

### Tiempo actual del sistema

```promql
node_time_seconds
```

### Momento de arranque

```promql
node_boot_time_seconds
```

### Tiempo de actividad

```promql
node_time_seconds - node_boot_time_seconds
```

### Tiempo de actividad en horas

```promql
(
  node_time_seconds
  -
  node_boot_time_seconds
) / 3600
```

### Tiempo de actividad en días

```promql
(
  node_time_seconds
  -
  node_boot_time_seconds
) / 86400
```

## Funciones de PromQL

### `rate`

Calcula la tasa media por segundo de un contador durante un intervalo.

```promql
rate(
  node_cpu_seconds_total[5m]
)
```

Es adecuada para:

- Uso de CPU.
- Tráfico de red.
- Operaciones de disco.
- Errores acumulativos.
- Peticiones por segundo.

### `irate`

Calcula una tasa basada principalmente en las muestras más recientes:

```promql
irate(
  node_cpu_seconds_total[5m]
)
```

Es más sensible a cambios rápidos y puede mostrar más variaciones.

### `increase`

Calcula cuánto ha aumentado un contador durante un intervalo:

```promql
increase(
  node_network_receive_bytes_total[1h]
)
```

La consulta indica cuántos bytes se han recibido aproximadamente durante la última hora.

### `delta`

Calcula la diferencia entre el primer y el último valor de una métrica de tipo gauge:

```promql
delta(
  node_load1[15m]
)
```

### `avg_over_time`

Calcula la media de una métrica durante un intervalo:

```promql
avg_over_time(
  node_load1[15m]
)
```

### `min_over_time`

Obtiene el valor mínimo:

```promql
min_over_time(
  node_load1[1h]
)
```

### `max_over_time`

Obtiene el valor máximo:

```promql
max_over_time(
  node_load1[1h]
)
```

### `last_over_time`

Obtiene la última muestra disponible dentro de un intervalo:

```promql
last_over_time(
  node_load1[15m]
)
```

### `count_over_time`

Cuenta las muestras existentes durante un intervalo:

```promql
count_over_time(
  node_load1[1h]
)
```

## Agregaciones

Las agregaciones permiten resumir varias series.

### `sum`

Suma los valores:

```promql
sum(up)
```

### `avg`

Calcula la media:

```promql
avg(node_load1)
```

### `min`

Obtiene el valor mínimo:

```promql
min(node_load1)
```

### `max`

Obtiene el valor máximo:

```promql
max(node_load1)
```

### `count`

Cuenta las series:

```promql
count(up)
```

### `count_values`

Cuenta cuántas series tienen cada valor:

```promql
count_values("estado", up)
```

### Agrupar mediante `by`

Calcular la disponibilidad por trabajo:

```promql
sum by (job) (up)
```

Contar targets por trabajo:

```promql
count by (job) (up)
```

Calcular la media de carga por instancia:

```promql
avg by (instance) (node_load1)
```

### Agrupar mediante `without`

Excluir determinadas etiquetas de la agrupación:

```promql
sum without (cpu, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

## Operadores vectoriales y coincidencia de etiquetas

PromQL debe saber cómo relacionar las series cuando se combinan dos expresiones.

### Comparar expresiones con etiquetas compatibles

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Si ambas métricas comparten las mismas etiquetas relevantes, Prometheus puede relacionarlas automáticamente.

### Utilizar `on`

Indicar las etiquetas utilizadas para hacer coincidir las series:

```promql
rate(node_cpu_seconds_total[5m])
  / on (instance)
count by (instance) (
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

### Utilizar `ignoring`

Ignorar determinadas etiquetas al hacer la coincidencia:

```promql
rate(node_cpu_seconds_total[5m])
  / ignoring (cpu, mode)
node_cpu_seconds_total
```

Debe utilizarse con cuidado. Una coincidencia incorrecta puede producir resultados vacíos o combinaciones inesperadas.

### Utilizar `group_left`

Permite conservar etiquetas adicionales de la expresión derecha cuando existe una relación de uno a muchos.

Ejemplo conceptual:

```promql
metric_a
  * on (instance)
  group_left(label_extra)
metric_b
```

No es necesario utilizar `group_left` en las consultas básicas del curso, pero resulta útil en métricas con metadatos adicionales.

## Funciones de etiquetas

### `label_replace`

Permite crear o modificar etiquetas a partir de otras etiquetas.

Ejemplo:

```promql
label_replace(
  up,
  "servidor",
  "$1",
  "instance",
  "([^:]+):.*"
)
```

Esta consulta crea una etiqueta `servidor` a partir del nombre anterior a los dos puntos de `instance`.

### `label_join`

Combina varias etiquetas en una nueva etiqueta:

```promql
label_join(
  up,
  "destino",
  ":",
  "job",
  "instance"
)
```

Estas funciones son útiles para adaptar las etiquetas a una visualización o a una convención de nombres.

## Consultas para dashboards

### Panel de disponibilidad

```promql
up
```

Unidad recomendada:

```text
none
```

Valores posibles:

```text
0 = DOWN
1 = UP
```

### Panel de CPU

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

Unidad recomendada:

```text
percent (0-100)
```

### Panel de memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Unidad recomendada:

```text
percent (0-100)
```

### Panel de memoria disponible

```promql
node_memory_MemAvailable_bytes
```

Unidad recomendada:

```text
bytes
```

### Panel de almacenamiento utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

Unidad recomendada:

```text
percent (0-100)
```

### Panel de carga del sistema

```promql
node_load1
```

Unidad recomendada:

```text
none
```

### Panel de tráfico recibido

```promql
rate(
  node_network_receive_bytes_total{
    device!~"lo|docker.*|veth.*|br-.*"
  }[5m]
)
```

Unidad recomendada:

```text
bytes/sec
```

### Panel de tráfico transmitido

```promql
rate(
  node_network_transmit_bytes_total{
    device!~"lo|docker.*|veth.*|br-.*"
  }[5m]
)
```

Unidad recomendada:

```text
bytes/sec
```

## Variables de Grafana

Las variables permiten reutilizar un dashboard para varias instancias, trabajos o dispositivos.

### Variable de instancias

En Grafana, una consulta habitual para una variable de instancia es:

```promql
label_values(up, instance)
```

En versiones recientes de Grafana también puede utilizarse una consulta basada en Prometheus:

```promql
query_result(up)
```

La sintaxis disponible depende de la versión y del editor de variables.

### Variable de trabajos

```promql
label_values(up, job)
```

### Variable de dispositivos

```promql
label_values(node_network_receive_bytes_total, device)
```

### Utilizar una variable en una consulta

Si la variable se llama `instance`:

```promql
up{instance="$instance"}
```

Si permite selección múltiple:

```promql
up{instance=~"$instance"}
```

Para una variable de trabajo:

```promql
up{job=~"$job"}
```

### Consulta de CPU con variables

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle",
        instance=~"$instance"
      }[5m]
    )
  )
)
```

## Consultas para alertas

### Target no disponible

```promql
up{job="node_exporter"} == 0
```

### Memoria disponible baja

```promql
(
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) * 100 < 20
```

### Almacenamiento casi lleno

```promql
(
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
) * 100 < 15
```

### CPU elevada durante varios minutos

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
) > 80
```

El tiempo durante el cual debe mantenerse la condición se configura en la regla de alerta, no necesariamente dentro de la consulta.

### Carga elevada respecto al número de CPU

```promql
node_load1
>
count by (instance) (
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

Esta consulta es orientativa. La interpretación de la carga debe considerar el tipo de sistema y la actividad que está realizando.

## Diferencia entre métricas gauge y counter

### Gauge

Un gauge puede subir o bajar.

Ejemplos:

```promql
node_load1
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

Los gauges suelen consultarse directamente:

```promql
node_load1
```

### Counter

Un counter aumenta de forma acumulativa y puede reiniciarse cuando se reinicia el proceso.

Ejemplos:

```promql
node_cpu_seconds_total
```

```promql
node_network_receive_bytes_total
```

```promql
node_network_transmit_bytes_total
```

Los counters suelen analizarse mediante:

```promql
rate(metric[5m])
```

o:

```promql
increase(metric[1h])
```

No es recomendable interpretar directamente el valor acumulado de un counter como una tasa actual.

## Consultas de diagnóstico

### Verificar si existe una métrica

```promql
node_memory_MemAvailable_bytes
```

Si no devuelve resultados:

- Node Exporter puede no estar disponible.
- La métrica puede tener otro nombre.
- Prometheus puede no estar realizando scraping.
- El target puede estar configurado con otro job.
- La métrica puede no estar expuesta por la versión instalada.

### Consultar todas las métricas de Node Exporter

Desde la terminal:

```bash
curl -s http://localhost:9100/metrics
```

Buscar nombres relacionados con memoria:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_memory_" \
  | head -30
```

Buscar nombres relacionados con disco:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_filesystem_" \
  | head -30
```

### Comprobar los nombres de las métricas en Prometheus

En la interfaz de Prometheus puedes utilizar el explorador de métricas para consultar los nombres disponibles.

También puedes obtener las etiquetas y series mediante la API:

```bash
curl -s http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

### Consultar las etiquetas de una métrica

```bash
curl -sG http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=node_load1' \
  | jq
```

### Consultar los targets activos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets'
```

## Errores habituales

### Utilizar una métrica que no existe

Consulta:

```promql
node_memory_available_bytes
```

Si la métrica no existe, revisa el nombre real:

```promql
node_memory_MemAvailable_bytes
```

Los nombres de las métricas distinguen mayúsculas y minúsculas.

### Olvidar el intervalo en `rate`

Incorrecto:

```promql
rate(node_cpu_seconds_total)
```

Correcto:

```promql
rate(node_cpu_seconds_total[5m])
```

### Aplicar `rate` a un gauge

No suele ser correcto aplicar `rate` directamente a:

```promql
node_memory_MemAvailable_bytes
```

Esta métrica es un gauge y debe consultarse directamente o mediante una función temporal apropiada.

### Dividir series incompatibles

Una consulta puede devolver resultados vacíos si las etiquetas de las métricas no coinciden.

Comprueba primero cada parte:

```promql
node_memory_MemAvailable_bytes
```

```promql
node_memory_MemTotal_bytes
```

Después combina ambas:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### No filtrar sistemas de archivos

Una consulta general puede incluir `tmpfs`, `overlay` u otros sistemas virtuales:

```promql
node_filesystem_size_bytes
```

Es preferible filtrar los sistemas relevantes:

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Utilizar un intervalo demasiado corto

Una consulta como esta puede resultar inestable:

```promql
rate(node_cpu_seconds_total[30s])
```

En muchos entornos es preferible:

```promql
rate(node_cpu_seconds_total[5m])
```

### Confundir valor instantáneo con histórico

La vista de tabla muestra el valor en un instante. La vista de gráfico muestra la evolución de la consulta durante un intervalo de tiempo.

## Buenas prácticas para escribir consultas

- Utiliza nombres de métricas exactos.
- Comprueba primero la métrica sin filtros.
- Añade etiquetas progresivamente.
- Usa nombres de etiquetas coherentes.
- Aplica `rate` a counters.
- Usa ventanas de tiempo razonables.
- Filtra sistemas de archivos virtuales.
- Comprueba las unidades del resultado.
- Utiliza `by` para conservar las etiquetas necesarias.
- Evita conservar cardinalidad innecesaria.
- Divide las consultas complejas en partes durante el diagnóstico.
- Comprueba que el resultado no esté vacío.
- Documenta los umbrales utilizados.
- Valida las consultas en Prometheus antes de incorporarlas a Grafana.
- No asumas que una métrica existe en todas las instalaciones.
- Comprueba la versión de Node Exporter si faltan métricas.

## Sesión práctica 1: comprobar la disponibilidad

En esta sesión se comprobará el estado de los targets configurados.

### Objetivo

Ejecutar consultas básicas sobre la métrica `up`.

### Consultar todos los targets

```promql
up
```

### Filtrar Node Exporter

```promql
up{job="node_exporter"}
```

### Contar targets

```promql
count(up)
```

### Contar targets disponibles

```promql
count(up == 1)
```

### Contar targets caídos

```promql
count(up == 0)
```

### Calcular el porcentaje de disponibilidad

```promql
100 * sum(up) / count(up)
```

### Actividad controlada

En el entorno de laboratorio:

1. Ejecuta `up{job="node_exporter"}`.
2. Anota el valor inicial.
3. Detén Node Exporter:

```bash
sudo systemctl stop node_exporter
```

4. Espera varios intervalos de scraping.
5. Ejecuta de nuevo:

```promql
up{job="node_exporter"}
```

6. Comprueba que el valor cambia a `0`.
7. Inicia el servicio:

```bash
sudo systemctl start node_exporter
```

8. Espera a que Prometheus vuelva a realizar scraping.
9. Comprueba que el valor vuelve a `1`.

### Preguntas de análisis

- ¿Qué valor tenía el target inicialmente?
- ¿Cuánto tardó en pasar a `0`?
- ¿Cuánto tardó en volver a `1`?
- ¿Qué relación existe entre el intervalo de scraping y el tiempo observado?
- ¿Qué mensaje aparece en la página de targets de Prometheus?

## Sesión práctica 2: analizar CPU

### Objetivo

Construir una consulta para medir el porcentaje de CPU utilizada.

### Consultar la métrica base

```promql
node_cpu_seconds_total
```

### Consultar únicamente el modo idle

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Calcular la tasa del modo idle

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Calcular el porcentaje utilizado

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

### Actividad de generación de carga

En el laboratorio, abre una segunda terminal y ejecuta durante unos segundos:

```bash
yes > /dev/null
```

En otra terminal, observa el dashboard o ejecuta la consulta de CPU.

Detén la carga con:

```text
Ctrl + C
```

### Preguntas de análisis

- ¿Qué ocurre con el porcentaje de CPU mientras se ejecuta `yes`?
- ¿Qué ocurre después de detenerlo?
- ¿Qué diferencia existe entre `rate` e `irate`?
- ¿Qué ventana temporal produce un gráfico más estable?
- ¿Qué valor devuelve la consulta cuando el equipo está en reposo?

## Sesión práctica 3: analizar memoria

### Objetivo

Calcular la memoria total, disponible y utilizada.

### Consultar la memoria total

```promql
node_memory_MemTotal_bytes
```

### Consultar la memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Calcular la memoria utilizada

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Calcular el porcentaje utilizado

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Calcular el porcentaje disponible

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Convertir la memoria utilizada a gigabytes

```promql
(
  node_memory_MemTotal_bytes
  -
  node_memory_MemAvailable_bytes
) / 1024 / 1024 / 1024
```

### Comparar con Ubuntu

Desde la terminal:

```bash
free -h
```

Compara los resultados con las consultas de Prometheus.

### Preguntas de análisis

- ¿La memoria total de Prometheus coincide aproximadamente con `free -h`?
- ¿Por qué puede existir una pequeña diferencia?
- ¿Qué métrica es más adecuada para estimar la memoria disponible?
- ¿Cuál es el porcentaje actual de memoria utilizada?

## Sesión práctica 4: analizar almacenamiento

### Objetivo

Calcular el espacio utilizado y disponible en el sistema de archivos raíz.

### Consultar los sistemas de archivos

```promql
node_filesystem_size_bytes
```

### Consultar la raíz

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

### Consultar el espacio disponible

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

### Calcular el porcentaje utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/"
  }
)
```

### Excluir sistemas virtuales

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Comparar con Ubuntu

Desde la terminal:

```bash
df -h /
```

### Crear una condición de alerta

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
) > 80
```

### Preguntas de análisis

- ¿Qué sistema de archivos corresponde a `/`?
- ¿Qué valor devuelve `df -h /`?
- ¿Qué sistemas virtuales aparecen en Node Exporter?
- ¿Por qué conviene excluirlos?
- ¿Qué umbral utilizarías para una alerta de almacenamiento?

## Sesión práctica 5: analizar tráfico de red

### Objetivo

Medir el tráfico recibido y transmitido por una interfaz.

### Consultar las interfaces

```promql
node_network_receive_bytes_total
```

### Identificar una interfaz concreta

```promql
node_network_receive_bytes_total{
  device="eth0"
}
```

Sustituye `eth0` por el nombre real de la interfaz.

### Calcular tráfico recibido

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

### Calcular tráfico transmitido

```promql
rate(
  node_network_transmit_bytes_total[5m]
)
```

### Excluir interfaces virtuales

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total{
      device!~"lo|docker.*|veth.*|br-.*"
    }[5m]
  )
)
```

### Convertir a megabytes por segundo

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total{
      device!~"lo|docker.*|veth.*|br-.*"
    }[5m]
  )
) / 1024 / 1024
```

### Generar tráfico de prueba

Desde otra terminal puedes realizar una petición al endpoint de métricas:

```bash
for i in {1..100}; do
  curl -s http://localhost:9100/metrics > /dev/null
done
```

Observa el gráfico de tráfico de red y comprueba si aparece alguna variación.

### Preguntas de análisis

- ¿Qué interfaces existen?
- ¿Cuál es la interfaz principal?
- ¿Qué diferencia existe entre bytes recibidos y transmitidos?
- ¿Por qué se utiliza `rate`?
- ¿Qué interfaces conviene excluir del dashboard?

## Sesión práctica 6: crear un dashboard operativo

### Objetivo

Construir un dashboard en Grafana utilizando consultas PromQL verificadas.

### Panel de disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Configuración recomendada:

```text
Tipo de panel: Stat
Unidad: none
Valor mínimo: 0
Valor máximo: 1
```

### Panel de CPU

Consulta:

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

Configuración recomendada:

```text
Tipo de panel: Time series o Gauge
Unidad: percent (0-100)
```

### Panel de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración recomendada:

```text
Tipo de panel: Gauge
Unidad: percent (0-100)
```

### Panel de almacenamiento

Consulta:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

Configuración recomendada:

```text
Tipo de panel: Gauge
Unidad: percent (0-100)
```

### Panel de carga

Consulta:

```promql
node_load1
```

Configuración recomendada:

```text
Tipo de panel: Time series
Unidad: none
```

### Validación del dashboard

Comprueba que:

- Los paneles muestran datos.
- Las unidades son correctas.
- Las etiquetas identifican la instancia.
- Los valores se actualizan.
- Los umbrales están documentados.
- No aparecen sistemas de archivos irrelevantes.
- La consulta sigue funcionando con el intervalo temporal seleccionado.

## Sesión práctica 7: construir una consulta compleja paso a paso

### Objetivo

Construir una consulta de porcentaje de CPU sin escribirla completa desde el principio.

### Paso 1: localizar la métrica

```promql
node_cpu_seconds_total
```

### Paso 2: seleccionar el modo idle

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Paso 3: calcular la tasa

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Paso 4: agrupar por instancia

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### Paso 5: calcular la parte utilizada

```promql
1 -
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### Paso 6: convertir a porcentaje

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

### Preguntas de análisis

- ¿Qué devuelve cada paso?
- ¿Qué etiquetas se conservan después de `avg by (instance)`?
- ¿Por qué se resta el porcentaje idle a `1`?
- ¿Por qué se multiplica por `100`?
- ¿Qué sucedería si se utilizara `sum` en lugar de `avg`?

## Sesión práctica 8: crear consultas para alertas

### Objetivo

Preparar consultas que puedan utilizarse como condiciones de alerta.

### Alerta de Node Exporter caído

```promql
up{job="node_exporter"} == 0
```

### Alerta de CPU elevada

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
) > 80
```

### Alerta de memoria baja

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) < 20
```

### Alerta de almacenamiento elevado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
) > 80
```

### Procedimiento

1. Ejecuta la consulta en Prometheus.
2. Comprueba que devuelve datos.
3. Comprueba la unidad del resultado.
4. Define el umbral.
5. Configura el tiempo de permanencia.
6. Añade etiquetas de severidad.
7. Añade una descripción.
8. Prueba la condición en el laboratorio.
9. Documenta el resultado.

## Catálogo de consultas

### Disponibilidad

```promql
up
```

```promql
up{job="node_exporter"}
```

```promql
up == 0
```

```promql
100 * sum(up) / count(up)
```

### CPU

```promql
node_cpu_seconds_total
```

```promql
rate(node_cpu_seconds_total[5m])
```

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

### Memoria

```promql
node_memory_MemTotal_bytes
```

```promql
node_memory_MemAvailable_bytes
```

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento

```promql
node_filesystem_size_bytes{mountpoint="/"}
```

```promql
node_filesystem_avail_bytes{mountpoint="/"}
```

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{mountpoint="/"}
  /
  node_filesystem_size_bytes{mountpoint="/"}
)
```

### Red

```promql
rate(node_network_receive_bytes_total[5m])
```

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Carga

```promql
node_load1
```

```promql
node_load5
```

```promql
node_load15
```

### Actividad

```promql
node_time_seconds - node_boot_time_seconds
```

```promql
(
  node_time_seconds
  -
  node_boot_time_seconds
) / 3600
```

## Puntos clave

- PromQL es el lenguaje de consulta de Prometheus.
- Una serie temporal está formada por una métrica, etiquetas, valores y marcas temporales.
- `up` permite comprobar la disponibilidad de un target.
- El valor `1` indica normalmente que el scraping ha funcionado.
- El valor `0` indica que el scraping ha fallado.
- Las etiquetas permiten filtrar y distinguir series.
- `=` selecciona una etiqueta con coincidencia exacta.
- `=~` utiliza expresiones regulares.
- Un vector instantáneo representa valores en un momento concreto.
- Un vector de rango representa valores durante un intervalo.
- `rate` se utiliza principalmente con counters.
- `irate` reacciona más rápidamente, pero puede ser más inestable.
- Los gauges suelen consultarse directamente.
- `sum`, `avg`, `min`, `max` y `count` permiten agregar series.
- `by` conserva las etiquetas indicadas en una agregación.
- Las consultas deben validarse en Prometheus antes de utilizarse en Grafana.
- Las unidades del panel deben corresponder al resultado de la consulta.
- Los sistemas de archivos virtuales deben filtrarse en las consultas de almacenamiento.
- Las consultas complejas deben construirse y validarse paso a paso.
- Los umbrales de alerta deben documentarse y justificarse.

## Preguntas de comprobación

1. ¿Qué significa la métrica `up`?
2. ¿Qué diferencia existe entre los valores `0` y `1` de `up`?
3. ¿Qué función cumplen las etiquetas de una métrica?
4. ¿Qué diferencia existe entre `{job="node_exporter"}` y `{job=~"node_.*"}`?
5. ¿Qué es un vector instantáneo?
6. ¿Qué es un vector de rango?
7. ¿Qué unidades de tiempo pueden utilizarse en un selector de rango?
8. ¿Por qué se aplica `rate` a `node_cpu_seconds_total`?
9. ¿Por qué no se debe aplicar normalmente `rate` a `node_memory_MemAvailable_bytes`?
10. ¿Qué diferencia existe entre `rate` e `irate`?
11. ¿Qué consulta permite calcular la memoria utilizada en porcentaje?
12. ¿Qué consulta permite calcular el porcentaje de CPU utilizado?
13. ¿Por qué se deben excluir algunos sistemas de archivos en una consulta de almacenamiento?
14. ¿Qué función cumple `sum by (instance)`?
15. ¿Qué diferencia existe entre `by` y `without`?
16. ¿Qué ocurre si una consulta utiliza una métrica inexistente?
17. ¿Cómo comprobarías si Node Exporter expone una métrica concreta?
18. ¿Qué consulta permite mostrar targets caídos?
19. ¿Qué factores deben tenerse en cuenta al elegir una ventana para `rate`?
20. ¿Qué pasos seguirías para validar una consulta antes de incorporarla a Grafana?