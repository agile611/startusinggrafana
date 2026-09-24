# Práctica 3 - Consultas PromQL

PromQL es el lenguaje de consultas de Prometheus. Permite seleccionar métricas, filtrar series, calcular tasas, agrupar resultados y construir indicadores útiles para dashboards y alertas.

En esta práctica, el alumno trabajará con métricas de Node Exporter y aprenderá a transformar datos básicos en información operativa:

```text
Métricas originales
        |
        v
Filtros por etiquetas
        |
        v
Funciones y operadores
        |
        v
Agregaciones
        |
        v
Indicadores útiles
        |
        v
Dashboards y alertas
```

Las consultas deben ejecutarse únicamente sobre el entorno de laboratorio. Antes de utilizar una consulta en una alerta, es necesario comprobar que devuelve datos correctos, que las unidades son coherentes y que las etiquetas identifican correctamente el recurso supervisado.

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar qué es PromQL.
- Diferenciar una métrica de una consulta.
- Ejecutar consultas instantáneas.
- Ejecutar consultas de rango temporal.
- Seleccionar métricas mediante nombres.
- Filtrar series mediante etiquetas.
- Utilizar operadores de igualdad y desigualdad.
- Utilizar expresiones regulares en etiquetas.
- Diferenciar métricas de tipo gauge y counter.
- Utilizar `rate` para calcular tasas.
- Utilizar `increase` para calcular incrementos.
- Utilizar funciones de agregación.
- Utilizar operadores aritméticos.
- Calcular CPU utilizada.
- Calcular memoria utilizada.
- Calcular almacenamiento utilizado.
- Consultar la disponibilidad de un target.
- Detectar series ausentes.
- Comparar métricas entre instancias.
- Preparar consultas para dashboards.
- Preparar consultas para alertas.
- Diagnosticar consultas sin datos.
- Detectar resultados duplicados.
- Documentar consultas y unidades.
- Validar consultas antes de utilizarlas en producción.

## Introducción

Prometheus almacena métricas como series temporales.

Cada serie está formada por:

```text
Nombre de la métrica
Etiquetas
Valores
Marcas de tiempo
```

Ejemplo:

```text
node_memory_MemTotal_bytes{
  instance="server-01:9100",
  job="node_exporter"
}
```

El nombre de la métrica es:

```text
node_memory_MemTotal_bytes
```

Las etiquetas son:

```text
instance="server-01:9100"
job="node_exporter"
```

El valor representa la memoria total del servidor.

PromQL permite consultar esa información y convertirla en indicadores más fáciles de interpretar.

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Prometheus operativo.
- Node Exporter disponible.
- Grafana o la interfaz web de Prometheus.
- Acceso a Explore.
- Una fuente de datos de Prometheus configurada.
- Permisos para ejecutar consultas.
- Un entorno de laboratorio autorizado.
- Un directorio para guardar evidencias.

Registrar:

```text
Alumno:

Grupo:

Fecha:

URL de Prometheus:

URL de Grafana:

Fuente de datos:

Job de Node Exporter:

Instancia:

Entorno:
```

El entorno utilizado debe ser:

```text
laboratory
```

## Acceso a PromQL

### Prometheus

Prometheus dispone de una interfaz web donde se pueden ejecutar consultas.

URL habitual:

```text
http://localhost:9090
```

En la sección de consultas se puede elegir entre:

```text
Instant
Graph
Range
```

La disponibilidad exacta de estas opciones depende de la versión instalada.

### Grafana Explore

En Grafana:

```text
Explore → Seleccionar Prometheus
```

Desde Explore se pueden:

- Ejecutar consultas.
- Cambiar el rango temporal.
- Cambiar la resolución.
- Visualizar tablas.
- Visualizar series temporales.
- Inspeccionar etiquetas.
- Copiar consultas.
- Guardar evidencias.

## Conceptos fundamentales

### Métrica

Una métrica es un nombre que representa un dato medido.

Ejemplos:

```promql
up
```

```promql
node_memory_MemTotal_bytes
```

```promql
node_filesystem_avail_bytes
```

### Serie temporal

Una serie temporal es una métrica concreta con un conjunto determinado de etiquetas.

Ejemplo:

```text
node_memory_MemTotal_bytes{
  instance="server-01:9100",
  job="node_exporter"
}
```

Otra instancia genera otra serie:

```text
node_memory_MemTotal_bytes{
  instance="server-02:9100",
  job="node_exporter"
}
```

### Etiqueta

Una etiqueta proporciona contexto sobre la serie.

Etiquetas habituales:

```text
job
instance
cpu
mode
mountpoint
fstype
device
interface
```

### Selector de etiqueta

Permite filtrar series.

Ejemplo:

```promql
up{job="node_exporter"}
```

### Consulta instantánea

Devuelve el valor más reciente disponible.

Ejemplo:

```promql
up
```

### Consulta de rango

Devuelve valores a lo largo de un periodo.

Ejemplo:

```promql
up[15m]
```

Los selectores de rango se utilizan normalmente dentro de funciones como:

```promql
rate(node_cpu_seconds_total[5m])
```

## Tipos de métricas

### Gauge

Un gauge representa un valor que puede subir o bajar.

Ejemplos:

```text
node_memory_MemAvailable_bytes
node_filesystem_avail_bytes
node_load1
```

Un gauge puede consultarse directamente:

```promql
node_load1
```

### Counter

Un counter representa un valor acumulativo que normalmente aumenta.

Ejemplos:

```text
node_cpu_seconds_total
node_network_receive_bytes_total
node_network_transmit_bytes_total
```

Para obtener una tasa a partir de un counter se utilizan funciones como:

```promql
rate()
```

o:

```promql
irate()
```

### Histogram y summary

Prometheus también admite histogramas y summaries. No son el objetivo principal de esta práctica, pero pueden aparecer en otros exporters.

Ejemplos de nombres relacionados:

```text
_request_duration_seconds_bucket
_request_duration_seconds_sum
_request_duration_seconds_count
```

## Sintaxis básica de PromQL

### Consultar una métrica

```promql
up
```

### Consultar una métrica concreta

```promql
node_memory_MemTotal_bytes
```

### Filtrar por una etiqueta

```promql
up{job="node_exporter"}
```

### Filtrar por varias etiquetas

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype="ext4"
}
```

### Excluir una etiqueta

```promql
up{job!="node_exporter"}
```

### Utilizar una expresión regular

```promql
up{instance=~"server-.*"}
```

### Excluir mediante una expresión regular

```promql
node_filesystem_size_bytes{
  fstype!~"tmpfs|overlay"
}
```

## Sesión 1: consultar métricas básicas

### Objetivo

Comprobar que Prometheus dispone de las métricas principales.

### Consultas

```promql
up
```

```promql
node_cpu_seconds_total
```

```promql
node_memory_MemTotal_bytes
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_size_bytes
```

```promql
node_filesystem_avail_bytes
```

### Actividad

Para cada consulta, registrar:

```text
Consulta:

¿Devuelve datos?:

Número de series:

Etiquetas observadas:

Valor aproximado:

Unidad:

Resultado:
```

### Resultado esperado

Las consultas deben devolver datos si Node Exporter está correctamente configurado y Prometheus ha realizado al menos un scrape.

## Sesión 2: consultar la disponibilidad

### Objetivo

Comprobar el estado de los targets supervisados.

### Consulta general

```promql
up
```

### Consulta de Node Exporter

```promql
up{job="node_exporter"}
```

### Interpretación

```text
1 = target disponible
0 = target no disponible
```

### Consultar una instancia concreta

```promql
up{instance="server-01:9100"}
```

Sustituir la instancia por una etiqueta existente en el entorno.

### Consultar varios servidores mediante expresión regular

```promql
up{instance=~"server-01:9100|server-02:9100"}
```

### Registro

```text
Consulta:

Job:

Instancia:

Valor:

Estado interpretado:

Resultado:
```

## Sesión 3: practicar operadores de etiquetas

### Objetivo

Aprender a seleccionar y excluir series mediante etiquetas.

### Igualdad

```promql
up{job="node_exporter"}
```

Selecciona las series cuyo `job` es exactamente `node_exporter`.

### Desigualdad

```promql
up{job!="prometheus"}
```

Selecciona las series cuyo `job` no es `prometheus`.

### Expresión regular

```promql
up{instance=~"server-.*"}
```

Selecciona las instancias cuyo nombre empieza por `server-`.

### Expresión regular negativa

```promql
up{instance!~"server-test-.*"}
```

Excluye las instancias cuyo nombre empieza por `server-test-`.

### Varias etiquetas

```promql
up{
  job="node_exporter",
  environment="laboratory"
}
```

### Actividad

Ejecutar las consultas y comparar:

```text
¿Qué series devuelve cada consulta?

¿Qué etiquetas cambian?

¿Qué filtro reduce más el resultado?

¿Qué ocurre si se utiliza una etiqueta inexistente?
```

## Sesión 4: consultar etiquetas disponibles

### Objetivo

Descubrir qué valores de etiquetas existen en las métricas.

### Consulta de ejemplo

```promql
up{job="node_exporter"}
```

Revisar las etiquetas mostradas en el resultado.

Etiquetas habituales:

```text
job
instance
environment
team
```

### Consultar una métrica con etiquetas de CPU

```promql
node_cpu_seconds_total
```

Revisar:

```text
cpu
mode
instance
job
```

### Consultar una métrica de almacenamiento

```promql
node_filesystem_size_bytes
```

Revisar:

```text
device
fstype
mountpoint
instance
job
```

### Actividad

Completar:

| Métrica | Etiqueta | Valores observados |
|---|---|---|
| `up` | `job` | |
| `up` | `instance` | |
| `node_cpu_seconds_total` | `mode` | |
| `node_filesystem_size_bytes` | `fstype` | |
| `node_filesystem_size_bytes` | `mountpoint` | |

## Sesión 5: calcular CPU utilizada

### Objetivo

Transformar el contador de CPU en un porcentaje de uso.

### Consulta principal

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Explicación paso a paso

Seleccionar el tiempo de CPU inactiva:

```promql
node_cpu_seconds_total{mode="idle"}
```

Calcular la tasa media de los últimos cinco minutos:

```promql
rate(
  node_cpu_seconds_total{mode="idle"}[5m]
)
```

Agrupar por instancia:

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

Convertir a porcentaje de tiempo inactivo:

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
```

Obtener el porcentaje utilizado:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Consulta por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance="server-01:9100"
    }[5m])
  ) * 100
)
```

### Consulta por todos los modos

```promql
sum by (instance, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

Esta consulta ayuda a analizar cuánto tiempo se dedica a cada modo de CPU.

### Registro

```text
Instancia:

CPU utilizada:

Periodo de cálculo:

Unidad:

Número de series:

Resultado:
```

## Sesión 6: experimentar con `rate`

### Objetivo

Comprender cómo cambia el resultado al modificar el periodo de cálculo.

### Consultas

```promql
rate(node_cpu_seconds_total{mode="idle"}[1m])
```

```promql
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

```promql
rate(node_cpu_seconds_total{mode="idle"}[15m])
```

### Actividad

Comparar:

```text
¿Con qué periodo fluctúa más el resultado?

¿Con qué periodo es más estable?

¿Qué periodo sería adecuado para un dashboard?

¿Qué periodo sería adecuado para una alerta?
```

### Interpretación

- Un periodo corto reacciona antes, pero puede ser más variable.
- Un periodo largo suaviza más los cambios, pero puede retrasar la detección.
- La elección depende del objetivo de la consulta.

## Sesión 7: utilizar `irate`

### Objetivo

Comparar `rate` e `irate`.

### Consulta con `rate`

```promql
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

### Consulta con `irate`

```promql
irate(node_cpu_seconds_total{mode="idle"}[5m])
```

### Diferencia general

```text
rate:
Calcula una tasa promedio sobre el periodo.

irate:
Utiliza las muestras más recientes y reacciona más rápidamente.
```

### Actividad

Representar ambas consultas en un panel de tipo Time series.

Registrar:

```text
Consulta más estable:

Consulta más reactiva:

Diferencia observada:

Consulta preferida para dashboard:

Consulta preferida para alerta:

Justificación:
```

## Sesión 8: calcular memoria utilizada

### Objetivo

Calcular la memoria utilizada en porcentaje.

### Memoria total

```promql
node_memory_MemTotal_bytes
```

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Memoria utilizada en bytes

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

### Consulta por instancia

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance="server-01:9100"
  }
  /
  node_memory_MemTotal_bytes{
    instance="server-01:9100"
  }
)
```

### Registro

```text
Memoria total:

Memoria disponible:

Memoria utilizada:

Porcentaje utilizado:

Instancia:

Resultado:
```

### Comprobaciones

```text
¿La memoria disponible es menor que la total?

¿El porcentaje está entre 0 y 100?

¿Aparece la instancia correcta?

¿Hay valores ausentes?

¿El resultado es coherente con el sistema?
```

## Sesión 9: calcular almacenamiento utilizado

### Objetivo

Calcular el porcentaje ocupado de un sistema de ficheros.

### Tamaño total

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Espacio disponible

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Porcentaje utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

### Agrupar por instancia y punto de montaje

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay"
  }
)
```

El resultado conserva las etiquetas del sistema de ficheros, como:

```text
instance
mountpoint
fstype
device
```

### Registro

```text
Instancia:

Punto de montaje:

Sistema de ficheros:

Tamaño:

Disponible:

Porcentaje utilizado:

Resultado:
```

## Sesión 10: excluir sistemas de ficheros irrelevantes

### Objetivo

Evitar que las consultas incluyan sistemas de ficheros temporales o virtuales.

### Consultar todos los sistemas

```promql
node_filesystem_size_bytes
```

### Excluir tipos concretos

```promql
node_filesystem_size_bytes{
  fstype!~"tmpfs|overlay"
}
```

### Excluir puntos de montaje

```promql
node_filesystem_size_bytes{
  mountpoint!~"/run|/proc|/sys"
}
```

### Combinar filtros

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Actividad

Comparar el número de series:

```text
Consulta sin filtros:

Consulta con fstype:

Consulta con mountpoint:

Consulta con ambos filtros:

Diferencia:
```

## Sesión 11: practicar funciones de agregación

### Objetivo

Agrupar series y reducir la cantidad de resultados.

### `sum`

Sumar valores:

```promql
sum(node_memory_MemTotal_bytes)
```

Sumar por instancia:

```promql
sum by (instance) (
  node_memory_MemTotal_bytes
)
```

### `avg`

Calcular el promedio:

```promql
avg(
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

Promedio por instancia:

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### `min`

Obtener el valor mínimo:

```promql
min(
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

### `max`

Obtener el valor máximo:

```promql
max(
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

### `count`

Contar series:

```promql
count(up{job="node_exporter"})
```

### Actividad

Ejecutar las consultas y documentar:

```text
Función:

Consulta:

Número de resultados:

Etiquetas conservadas:

Interpretación:
```

## Sesión 12: utilizar `by` y `without`

### Objetivo

Comprender cómo se conservan o eliminan etiquetas al agregar series.

### Agrupar por instancia

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### Agrupar por instancia y modo

```promql
sum by (instance, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

### Eliminar una etiqueta concreta

```promql
sum without (cpu) (
  rate(node_cpu_seconds_total[5m])
)
```

### Actividad

Comparar:

```text
¿Qué etiquetas aparecen con by(instance)?

¿Qué etiquetas desaparecen con without(cpu)?

¿Cuál es adecuada para un panel por instancia?

¿Cuál es adecuada para un análisis detallado?
```

## Sesión 13: practicar operadores aritméticos

### Objetivo

Utilizar operaciones matemáticas en PromQL.

### Suma

```promql
node_memory_MemTotal_bytes
+
node_memory_SwapTotal_bytes
```

### Resta

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Multiplicación

```promql
node_load1 * 100
```

### División

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Porcentaje

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Comparación

```promql
node_load1 > 1
```

### Comparación con filtro

```promql
(
  100 * (
    1 -
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
) > 90
```

### Registro

```text
Operador:

Consulta:

Resultado:

Unidad:

Interpretación:
```

## Sesión 14: consultar carga del sistema

### Objetivo

Consultar la carga del sistema mediante las métricas de Node Exporter.

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

### Comparar con el número de CPU

```promql
node_load1
/
count by (instance) (
  node_cpu_seconds_total{mode="idle"}
)
```

Esta consulta ofrece una relación aproximada entre la carga de un minuto y el número de CPUs.

### Actividad

Registrar:

```text
Carga de un minuto:

Carga de cinco minutos:

Carga de quince minutos:

Número de CPUs:

Relación carga/CPU:

Interpretación:
```

La carga del sistema no debe interpretarse como un porcentaje de CPU sin tener en cuenta el número de procesadores y el tipo de trabajo.

## Sesión 15: consultar información del sistema

### Objetivo

Obtener información sobre el sistema operativo y el kernel.

### Consulta

```promql
node_uname_info
```

### Revisar etiquetas

Según la versión y el entorno, pueden aparecer:

```text
domainname
machine
nodename
release
sysname
version
```

### Información de compilación de Node Exporter

```promql
node_exporter_build_info
```

### Actividad

Completar:

```text
Nombre del host:

Sistema operativo:

Versión del kernel:

Arquitectura:

Versión de Node Exporter:

Resultado:
```

## Sesión 16: consultar métricas de red

### Objetivo

Identificar las métricas de tráfico de red.

### Bytes recibidos

```promql
node_network_receive_bytes_total
```

### Bytes transmitidos

```promql
node_network_transmit_bytes_total
```

### Tasa de recepción

```promql
rate(node_network_receive_bytes_total[5m])
```

### Tasa de transmisión

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Excluir la interfaz de loopback

```promql
rate(node_network_receive_bytes_total{
  device!="lo"
}[5m])
```

### Agrupar por instancia y dispositivo

```promql
sum by (instance, device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Registro

```text
Instancia:

Interfaz:

Recepción:

Transmisión:

Unidad:

Resultado:
```

## Sesión 17: utilizar `increase`

### Objetivo

Calcular cuánto ha aumentado un contador durante un periodo.

### Incremento de CPU

```promql
increase(node_cpu_seconds_total[1h])
```

### Incremento de bytes recibidos

```promql
increase(node_network_receive_bytes_total[1h])
```

### Diferencia con `rate`

```text
rate:
Calcula una tasa media por segundo.

increase:
Calcula el incremento total durante el periodo.
```

### Actividad

Comparar:

```promql
rate(node_network_receive_bytes_total[1h])
```

```promql
increase(node_network_receive_bytes_total[1h])
```

Registrar:

```text
Tasa media:

Incremento total:

Periodo:

Unidad de cada resultado:

Interpretación:
```

## Sesión 18: detectar condiciones con comparaciones

### Objetivo

Crear consultas que indiquen si un valor supera un umbral.

### CPU superior al 90 %

```promql
(
  100 - (
    avg by (instance) (
      rate(node_cpu_seconds_total{mode="idle"}[5m])
    ) * 100
  )
) > 90
```

### Memoria superior al 90 %

```promql
(
  100 * (
    1 -
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
) > 90
```

### Almacenamiento superior al 80 %

```promql
(
  100 * (
    1 -
    node_filesystem_avail_bytes{
      mountpoint="/",
      fstype!~"tmpfs|overlay"
    }
    /
    node_filesystem_size_bytes{
      mountpoint="/",
      fstype!~"tmpfs|overlay"
    }
  )
) > 80
```

### Actividad

Registrar:

```text
Consulta:

Umbral:

Series que cumplen la condición:

Series que no cumplen la condición:

Resultado:
```

### Consideración

Una consulta que devuelve una serie cuando se cumple una condición puede utilizarse como base de una alerta. Antes de crear la alerta se debe definir también la duración y el comportamiento ante ausencia de datos.

## Sesión 19: utilizar `absent`

### Objetivo

Detectar la ausencia total de una métrica o serie.

### Ejemplo

```promql
absent(up{job="node_exporter"})
```

Interpretación:

```text
Sin resultado = existe al menos una serie coincidente
Valor 1 = no existe ninguna serie coincidente
```

### Comprobar una instancia concreta

```promql
absent(up{instance="server-01:9100"})
```

### Actividad

1. Ejecutar la consulta con una instancia existente.
2. Ejecutar la consulta con una instancia inventada.
3. Comparar los resultados.
4. Documentar la interpretación.

### Registro

```text
Instancia consultada:

Existe:

Resultado de absent:

Interpretación:
```

### Advertencia

`absent` detecta ausencia de series, pero no sustituye siempre a la métrica `up`. Para comprobar la disponibilidad de un target, normalmente es más claro utilizar:

```promql
up{job="node_exporter"}
```

## Sesión 20: utilizar `absent_over_time`

### Objetivo

Detectar si no existen muestras durante un periodo.

### Consulta

```promql
absent_over_time(
  up{job="node_exporter"}[10m]
)
```

### Interpretación

```text
Sin resultado = existen muestras en el periodo
Valor 1 = no existen muestras en el periodo
```

### Actividad

Registrar:

```text
Periodo:

Consulta:

Resultado:

¿Existen muestras?:

Interpretación:
```

## Sesión 21: utilizar funciones temporales

### Objetivo

Analizar cambios recientes en una métrica.

### Valor actual

```promql
node_load1
```

### Valor máximo en una hora

```promql
max_over_time(node_load1[1h])
```

### Valor mínimo en una hora

```promql
min_over_time(node_load1[1h])
```

### Promedio en una hora

```promql
avg_over_time(node_load1[1h])
```

### Último valor disponible

```promql
last_over_time(node_load1[1h])
```

### Actividad

Comparar:

```text
Valor actual:

Máximo:

Mínimo:

Promedio:

Diferencia entre actual y máximo:

Interpretación:
```

## Sesión 22: practicar consultas por instancia

### Objetivo

Construir consultas que funcionen con una o varias instancias.

### CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria por instancia

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Disponibilidad por instancia

```promql
up{job="node_exporter"}
```

### Filtrar una instancia

```promql
up{
  job="node_exporter",
  instance=~"server-01:9100"
}
```

### Actividad

Completar:

```text
Número de instancias disponibles:

Instancia con mayor CPU:

Instancia con mayor memoria:

Instancia con mayor almacenamiento:

Instancias no disponibles:

Resultado:
```

## Sesión 23: detectar resultados duplicados

### Situación

Una consulta devuelve varias series cuando se esperaba una sola.

### Ejemplo

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

Puede devolver varias series si existen diferentes tipos de sistema de ficheros o etiquetas adicionales.

### Revisar etiquetas

Examinar:

```text
instance
device
fstype
mountpoint
job
```

### Filtrar con más precisión

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Actividad

Comparar:

```text
Número de series inicial:

Etiquetas diferentes:

Filtro añadido:

Número de series final:

Resultado:
```

### Posible solución

Utilizar filtros adecuados o una agregación:

```promql
max by (instance, mountpoint) (
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

La agregación debe utilizarse solo después de comprender por qué existen varias series.

## Sesión 24: construir consultas para dashboards

### Objetivo

Preparar consultas con unidades y etiquetas adecuadas para paneles.

### Panel de disponibilidad

```promql
up{job="node_exporter"}
```

Configuración recomendada:

```text
Visualización:
Stat

Unidad:
none

Rango:
0-1
```

### Panel de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración recomendada:

```text
Visualización:
Time series

Unidad:
Percent (0-100)

Leyenda:
instance
```

### Panel de memoria

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
Visualización:
Gauge o Time series

Unidad:
Percent (0-100)
```

### Panel de almacenamiento

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

Configuración recomendada:

```text
Visualización:
Gauge

Unidad:
Percent (0-100)
```

## Sesión 25: construir consultas para alertas

### Objetivo

Preparar consultas que puedan utilizarse en reglas de alerta.

### Disponibilidad

```promql
up{job="node_exporter"}
```

Condición:

```text
Último valor igual a 0
```

### CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Condición:

```text
Último valor mayor que 90
```

### Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Condición:

```text
Último valor mayor que 90
```

### Almacenamiento

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

Condición:

```text
Último valor mayor que 80
```

### Registro

```text
Regla:

Consulta:

Reducción:

Operador:

Umbral:

Unidad:

Duración propuesta:

Etiquetas:
```

## Sesión 26: añadir filtros de laboratorio

### Objetivo

Limitar las consultas al entorno de prácticas.

Si las métricas incluyen la etiqueta `environment`, utilizar:

```promql
up{
  job="node_exporter",
  environment="laboratory"
}
```

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      environment="laboratory"
    }[5m])
  ) * 100
)
```

### Consideración

No todas las instalaciones de Node Exporter añaden automáticamente la etiqueta `environment`. Puede añadirse desde la configuración de Prometheus mediante etiquetas estáticas.

Ejemplo:

```yaml
static_configs:
  - targets:
      - "server-01:9100"
    labels:
      environment: "laboratory"
```

## Sesión 27: utilizar consultas en Grafana

### Objetivo

Comprobar que las consultas funcionan tanto en Prometheus como en Grafana.

### Procedimiento

1. Ejecutar la consulta en Prometheus.
2. Registrar el resultado.
3. Abrir Grafana Explore.
4. Seleccionar Prometheus.
5. Ejecutar la misma consulta.
6. Comparar los resultados.
7. Crear un panel temporal.
8. Guardar la evidencia.

### Consultas de comparación

```promql
up{job="node_exporter"}
```

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Registro

```text
Consulta:

Resultado en Prometheus:

Resultado en Grafana:

Diferencias:

Causa de las diferencias:

Conclusión:
```

## Sesión 28: diagnosticar una consulta sin datos

### Situación

```text
La consulta no devuelve ninguna serie.
```

### Procedimiento

1. Comprobar el nombre de la métrica.
2. Consultar la métrica sin filtros.
3. Revisar el nombre del job.
4. Revisar la etiqueta `instance`.
5. Comprobar el rango temporal.
6. Comprobar que Prometheus ha realizado scrapes.
7. Revisar la página de targets.
8. Revisar la fuente de datos de Grafana.
9. Ejecutar una consulta simple como `up`.
10. Registrar la causa.

### Ejemplo de diagnóstico

Consulta problemática:

```promql
up{job="node-exporter"}
```

Consulta corregida:

```promql
up{job="node_exporter"}
```

La diferencia está en el nombre exacto del job.

### Registro

```text
Consulta original:

Resultado:

Métrica sin filtros:

Job observado:

Etiqueta incorrecta:

Consulta corregida:

Resultado final:
```

## Sesión 29: diagnosticar una consulta con valores extraños

### Situación

```text
La consulta devuelve valores negativos,
superiores a 100 o con una unidad inesperada.
```

### Posibles causas

```text
Se ha utilizado una métrica incorrecta.
Se ha interpretado un counter como gauge.
Falta una multiplicación por 100.
Se ha invertido una división.
La consulta mezcla series incompatibles.
Las etiquetas no coinciden.
Se ha elegido una unidad incorrecta en Grafana.
```

### Actividad

Revisar la consulta:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Esta consulta devuelve una proporción entre 0 y 1.

Para convertirla en porcentaje:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Para calcular memoria utilizada:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Registro

```text
Consulta:

Valor inicial:

Unidad inicial:

Problema:

Corrección:

Valor final:

Unidad final:
```

## Sesión 30: guardar las consultas

### Objetivo

Documentar las consultas realizadas durante la práctica.

Crear un directorio:

```bash
mkdir -p ~/proyecto-final-grafana/evidencias/promql
```

Crear un fichero:

```bash
cat > ~/proyecto-final-grafana/evidencias/promql/consultas-practica-3.md <<'EOF'
# Consultas PromQL - Práctica 3

## Disponibilidad

```promql
up{job="node_exporter"}
```

## CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Almacenamiento utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

## Carga de un minuto

```promql
node_load1
```

## Tráfico recibido

```promql
rate(node_network_receive_bytes_total[5m])
```

## Observaciones

Consulta:

Finalidad:

Unidad:

Etiquetas:

Resultado:
EOF
```

## Sesión 31: preparar una línea temporal de métricas

### Objetivo

Analizar cómo evolucionan las métricas durante un periodo.

### Consultas

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Memoria:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Carga:

```promql
node_load1
```

### Procedimiento

1. Seleccionar un rango de treinta minutos.
2. Ejecutar cada consulta como serie temporal.
3. Identificar valores máximos.
4. Identificar valores mínimos.
5. Comparar las tendencias.
6. Registrar cualquier evento conocido.
7. Añadir una anotación si procede.

### Registro

```text
Rango temporal:

Métrica:

Valor mínimo:

Valor máximo:

Tendencia:

Evento relacionado:

Interpretación:
```

## Sesión 32: comparar dos instancias

### Objetivo

Comparar el comportamiento de dos servidores de laboratorio.

### CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria por instancia

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Actividad

Registrar:

```text
Instancia con mayor CPU:

Instancia con menor CPU:

Instancia con mayor memoria:

Instancia con menor memoria:

¿Alguna supera los umbrales?:

Conclusión:
```

## Sesión 33: diseñar una consulta para un dashboard

### Objetivo

Convertir una necesidad operativa en una consulta PromQL.

### Necesidad

```text
Mostrar el porcentaje de CPU utilizado
por cada instancia de Node Exporter.
```

### Razonamiento

1. Seleccionar la métrica de CPU.
2. Filtrar el modo `idle`.
3. Calcular la tasa.
4. Agrupar por `instance`.
5. Convertir a porcentaje utilizado.

### Consulta resultante

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Actividad

Diseñar consultas para:

```text
Mostrar la memoria utilizada por instancia.

Mostrar el almacenamiento utilizado en /.

Mostrar si Node Exporter está disponible.

Mostrar la tasa de tráfico recibido por interfaz.
```

### Registro

```text
Necesidad:

Métrica inicial:

Filtros:

Funciones:

Agregación:

Consulta final:

Unidad:

Visualización recomendada:
```

## Sesión 34: diseñar una consulta para una alerta

### Objetivo

Convertir un requisito de monitorización en una consulta evaluable.

### Requisito

```text
Alertar cuando la memoria utilizada supere el 90 %.
```

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Condición

```text
Resultado mayor que 90
```

### Duración propuesta

```text
5 minutos
```

### Etiquetas

```text
alertname = HighMemoryUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = memory
```

### Actividad

Diseñar el mismo esquema para:

```text
Node Exporter no disponible.

CPU superior al 90 %.

Almacenamiento superior al 80 %.
```

## Registro de consultas

Para cada consulta, utilizar esta plantilla:

```text
Nombre:

Necesidad operativa:

Consulta:

Tipo de métrica:

Funciones utilizadas:

Filtros:

Agregaciones:

Unidad:

Número esperado de series:

Resultado observado:

Uso previsto:

Observaciones:
```

## Ejemplo completo

### Necesidad

```text
Conocer el porcentaje de CPU utilizado por cada servidor
durante los últimos cinco minutos.
```

### Métrica original

```promql
node_cpu_seconds_total
```

### Filtro

```promql
node_cpu_seconds_total{mode="idle"}
```

### Tasa

```promql
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

### Agregación

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### Conversión a porcentaje inactivo

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
```

### Conversión a porcentaje utilizado

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Resultado documentado

```text
La consulta calcula la tasa media de CPU inactiva durante cinco minutos,
la agrupa por instancia y resta el porcentaje inactivo a 100 para obtener
una aproximación del porcentaje de CPU utilizada.
```

## Errores frecuentes

### Confundir un counter con un gauge

Incorrecto para calcular CPU utilizada:

```promql
node_cpu_seconds_total
```

La métrica es acumulativa. Para obtener una tasa, utilizar:

```promql
rate(node_cpu_seconds_total[5m])
```

### Utilizar una etiqueta incorrecta

Incorrecto:

```promql
up{job="node-exporter"}
```

si el job real es:

```text
node_exporter
```

Correcto:

```promql
up{job="node_exporter"}
```

### Olvidar el filtro `mode="idle"`

Una consulta que mezcla todos los modos de CPU no representa directamente la CPU inactiva:

```promql
rate(node_cpu_seconds_total[5m])
```

Para calcular CPU utilizada mediante tiempo inactivo:

```promql
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

### Olvidar la multiplicación por 100

Esta consulta devuelve una proporción:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Para mostrar un porcentaje:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### No agrupar las series

Una consulta de CPU sin agregación puede devolver una serie por CPU lógica:

```promql
rate(node_cpu_seconds_total{mode="idle"}[5m])
```

Para obtener un resultado por instancia:

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### No filtrar sistemas de ficheros

Consultar todos los sistemas de ficheros puede producir resultados duplicados o poco útiles.

Utilizar filtros:

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

## Criterios de aceptación

La práctica se considera completada cuando:

- El alumno puede acceder a Prometheus o Grafana Explore.
- Las consultas básicas devuelven datos.
- El alumno puede filtrar por etiquetas.
- El alumno comprende `rate`.
- El alumno puede calcular CPU utilizada.
- El alumno puede calcular memoria utilizada.
- El alumno puede calcular almacenamiento utilizado.
- El alumno puede utilizar agregaciones.
- El alumno puede interpretar unidades.
- El alumno puede detectar una consulta sin datos.
- El alumno puede identificar resultados duplicados.
- Las consultas están documentadas.
- Las consultas se han validado en el entorno de laboratorio.
- Las evidencias están organizadas.
- No se han incluido credenciales.
- El alumno puede explicar la finalidad de cada consulta.

## Puntos clave

- PromQL es el lenguaje de consulta de Prometheus.
- Una serie temporal está formada por una métrica, etiquetas, valores y marcas de tiempo.
- Las etiquetas permiten filtrar y clasificar series.
- `up` permite consultar la disponibilidad de un target.
- Los gauges pueden subir y bajar libremente.
- Los counters representan valores acumulativos.
- `rate` calcula una tasa media a partir de un counter.
- `irate` reacciona más rápidamente a los cambios recientes.
- `increase` calcula el incremento total durante un periodo.
- `sum`, `avg`, `min`, `max` y `count` permiten agregar series.
- `by` conserva las etiquetas indicadas.
- `without` elimina las etiquetas indicadas durante la agregación.
- Las consultas deben producir unidades comprensibles.
- CPU, memoria y almacenamiento requieren transformaciones para expresarse como porcentajes.
- Las consultas de almacenamiento deben filtrar sistemas de ficheros irrelevantes.
- Una consulta sin datos puede indicar un problema de métrica, etiqueta, target o rango temporal.
- Una consulta con resultados duplicados puede necesitar filtros o agregaciones.
- Las consultas de dashboards y alertas deben validarse antes de guardarse.
- La duración de una alerta no forma parte de PromQL, sino de la configuración de la regla.
- La documentación debe incluir finalidad, consulta, unidad y resultado.

## Preguntas de comprobación

1. ¿Qué es PromQL?
2. ¿Qué elementos forman una serie temporal?
3. ¿Qué función cumplen las etiquetas?
4. ¿Qué diferencia existe entre una consulta instantánea y una consulta de rango?
5. ¿Qué diferencia existe entre un gauge y un counter?
6. ¿Por qué se utiliza `rate` con `node_cpu_seconds_total`?
7. ¿Qué representa el modo `idle` de la métrica de CPU?
8. ¿Cómo se calcula el porcentaje de CPU utilizada?
9. ¿Cómo se calcula el porcentaje de memoria utilizada?
10. ¿Por qué se utiliza `mountpoint="/"` en la consulta de almacenamiento?
11. ¿Por qué se excluyen `tmpfs` y `overlay`?
12. ¿Qué diferencia existe entre `rate` e `irate`?
13. ¿Qué diferencia existe entre `rate` e `increase`?
14. ¿Qué función cumple `avg by (instance)`?
15. ¿Qué diferencia existe entre `by` y `without`?
16. ¿Qué ocurre si se utiliza una etiqueta que no existe?
17. ¿Qué revisarías si una consulta no devuelve datos?
18. ¿Qué revisarías si una consulta devuelve demasiadas series?
19. ¿Qué función cumple `absent`?
20. ¿Qué diferencia existe entre una consulta para dashboard y una consulta para alerta?
21. ¿Qué información debe documentarse para cada consulta?
22. ¿Por qué debe validarse una consulta antes de crear una alerta?
23. ¿Qué errores pueden producir valores superiores a 100?
24. ¿Qué consulta utilizarías para comprobar que Node Exporter está disponible?
25. ¿Qué resultado demostraría que la práctica se ha completado?

## Resultado esperado

Al finalizar la práctica, el alumno deberá haber creado y validado un conjunto de consultas PromQL para analizar el entorno de laboratorio.

Consultas mínimas:

### Disponibilidad

```promql
up{job="node_exporter"}
```

### CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento utilizado

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

El flujo completado será:

```text
Acceder a Prometheus o Grafana
        |
        v
Consultar métricas básicas
        |
        v
Revisar etiquetas
        |
        v
Filtrar series
        |
        v
Aplicar funciones
        |
        v
Agrupar resultados
        |
        v
Calcular indicadores
        |
        v
Validar unidades
        |
        v
Preparar consultas para dashboards
        |
        v
Preparar consultas para alertas
        |
        v
Diagnosticar errores
        |
        v
Guardar evidencias
        |
        v
Documentar el resultado
```

El alumno debe poder explicar qué hace cada parte de una consulta, qué unidad devuelve, qué etiquetas conserva y cómo se utilizaría en un dashboard o una regla de alerta.

Estas consultas constituirán la base técnica para la siguiente práctica, dedicada a la creación de un dashboard operativo con variables, filtros, paneles y umbrales visuales.