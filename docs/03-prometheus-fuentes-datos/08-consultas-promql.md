# Consultas PromQL

PromQL, abreviatura de **Prometheus Query Language**, es el lenguaje utilizado para consultar, filtrar, transformar y agrupar las métricas almacenadas en Prometheus.

En esta práctica se utilizarán métricas de:

- Prometheus.
- Node Exporter.
- CPU.
- Memoria.
- Sistemas de ficheros.
- Interfaces de red.
- Disponibilidad de objetivos.

El recorrido será:

```text
Métrica almacenada
        |
        v
Selector PromQL
        |
        v
Filtros y etiquetas
        |
        v
Funciones y operadores
        |
        v
Resultado numérico o serie temporal
        |
        v
Tabla, gráfico o dashboard
```

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar qué es PromQL.
- Consultar una métrica instantánea.
- Consultar una serie temporal.
- Filtrar métricas mediante etiquetas.
- Utilizar operadores aritméticos y lógicos.
- Utilizar selectores de igualdad y expresiones regulares.
- Diferenciar entre métricas `counter` y `gauge`.
- Utilizar funciones como `rate()`, `irate()`, `avg()`, `sum()` y `count()`.
- Agrupar resultados mediante `by` y `without`.
- Calcular porcentajes de CPU, memoria y almacenamiento.
- Consultar tráfico de red.
- Utilizar rangos temporales.
- Combinar varias métricas en una expresión.
- Consultar Prometheus desde la interfaz web.
- Consultar Prometheus mediante la API HTTP.
- Diagnosticar consultas que no devuelven datos.
- Preparar consultas para paneles de Grafana.

---

## Introducción

Prometheus almacena métricas como **series temporales**.

Cada serie está formada por:

- Un nombre de métrica.
- Un conjunto de etiquetas.
- Un valor.
- Una marca temporal.

Ejemplo:

```text
node_memory_MemAvailable_bytes{
  instance="localhost:9100",
  job="node_exporter"
} 2414534656
```

En este ejemplo:

- `node_memory_MemAvailable_bytes` es el nombre de la métrica.
- `instance` identifica el objetivo.
- `job` identifica el trabajo.
- `2414534656` es el valor actual.
- Prometheus asocia el valor a una marca temporal.

Una consulta PromQL puede devolver:

- Un único valor.
- Varias series.
- Una tabla.
- Una serie temporal.
- Un resultado booleano.
- Un valor calculado a partir de varias métricas.

---

## Requisitos previos

Antes de comenzar, Prometheus debe estar activo y debe haber objetivos disponibles.

### Comprobar Prometheus

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

### Comprobar Node Exporter

Si Node Exporter se instaló manualmente:

```bash
systemctl is-active node_exporter
```

Si se instaló mediante el paquete de Ubuntu:

```bash
systemctl is-active prometheus-node-exporter
```

Resultado esperado:

```text
active
```

### Comprobar los objetivos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

Resultado esperado:

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

### Comprobar la consulta básica

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

---

## Acceder al editor de PromQL

Abrir la interfaz web:

```text
http://localhost:9090
```

En la sección de consultas se puede:

1. Introducir una expresión PromQL.
2. Ejecutarla.
3. Consultar el resultado como tabla.
4. Consultar el resultado como gráfico.
5. Cambiar el rango temporal.
6. Revisar las etiquetas devueltas.

La primera consulta recomendada es:

```promql
up
```

---

## Tipos de consultas

### Consulta de una métrica

Una consulta sencilla consiste en escribir el nombre de una métrica:

```promql
up
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_load1
```

```promql
node_filesystem_avail_bytes
```

### Consulta instantánea

Una consulta instantánea devuelve el valor más reciente disponible.

Ejemplo:

```promql
up
```

Resultado conceptual:

```text
up{instance="localhost:9090",job="prometheus"} 1
up{instance="localhost:9100",job="node_exporter"} 1
```

### Consulta de rango

Una consulta de rango devuelve la evolución temporal de una o varias series.

En la interfaz web se puede seleccionar:

- Últimos 5 minutos.
- Últimos 15 minutos.
- Última hora.
- Últimas 6 horas.
- Últimas 24 horas.
- Rango personalizado.

La consulta puede ser la misma:

```promql
node_memory_MemAvailable_bytes
```

La diferencia está en el tipo de ejecución y en el intervalo temporal seleccionado.

---

## Selectores de métricas

### Selector simple

```promql
up
```

Este selector devuelve todas las series cuyo nombre de métrica es `up`.

### Selector con etiquetas

```promql
up{
  job="node_exporter"
}
```

También puede escribirse en una sola línea:

```promql
up{job="node_exporter"}
```

### Varias etiquetas

```promql
node_cpu_seconds_total{
  job="node_exporter",
  mode="idle"
}
```

### Seleccionar una instancia

```promql
up{
  instance="localhost:9100"
}
```

### Seleccionar un dispositivo

```promql
node_network_receive_bytes_total{
  device="ens33"
}
```

---

## Operadores de etiquetas

PromQL admite cuatro operadores principales para seleccionar etiquetas.

| Operador | Significado | Ejemplo |
|---|---|---|
| `=` | Igual | `job="node_exporter"` |
| `!=` | Distinto | `device!="lo"` |
| `=~` | Coincide con una expresión regular | `device=~"en.*"` |
| `!~` | No coincide con una expresión regular | `device!~"lo|docker.*"` |

### Igualdad exacta

```promql
up{job="node_exporter"}
```

### Desigualdad

```promql
node_network_receive_bytes_total{
  device!="lo"
}
```

### Expresión regular

```promql
node_network_receive_bytes_total{
  device=~"en.*"
}
```

### Exclusión mediante expresión regular

```promql
node_network_receive_bytes_total{
  device!~"lo|docker.*|veth.*"
}
```

---

## Etiquetas habituales de Node Exporter

| Etiqueta | Significado |
|---|---|
| `job` | Trabajo de Prometheus |
| `instance` | Objetivo consultado |
| `cpu` | Identificador de CPU |
| `mode` | Modo de CPU |
| `device` | Dispositivo o interfaz |
| `mountpoint` | Punto de montaje |
| `fstype` | Tipo de sistema de ficheros |

Consultar las etiquetas de CPU:

```promql
node_cpu_seconds_total
```

Consultar las etiquetas de red:

```promql
node_network_receive_bytes_total
```

Consultar las etiquetas de almacenamiento:

```promql
node_filesystem_size_bytes
```

---

## La métrica `up`

La métrica `up` indica si Prometheus pudo realizar correctamente el último *scraping*.

```promql
up
```

Interpretación:

| Valor | Significado |
|---:|---|
| `1` | El objetivo respondió correctamente |
| `0` | El objetivo no respondió correctamente |

### Consultar todos los objetivos

```promql
up
```

### Consultar Node Exporter

```promql
up{job="node_exporter"}
```

### Consultar Prometheus

```promql
up{job="prometheus"}
```

### Buscar objetivos caídos

```promql
up == 0
```

Esta expresión devuelve únicamente las series cuyo valor sea `0`.

### Contar objetivos

```promql
count(up)
```

### Contar objetivos disponibles

```promql
sum(up)
```

### Calcular el porcentaje de disponibilidad

```promql
100 * avg(up)
```

### Consultar un objetivo concreto

```promql
up{instance="localhost:9100"}
```

---

## Tipos de métricas

### Gauge

Un `gauge` representa un valor que puede aumentar o disminuir.

Ejemplos:

```promql
node_memory_MemAvailable_bytes
```

```promql
node_load1
```

```promql
node_filesystem_avail_bytes
```

```promql
process_resident_memory_bytes
```

Estos valores pueden cambiar en cualquier dirección.

### Counter

Un `counter` representa un valor acumulativo.

Normalmente aumenta con el tiempo y vuelve a comenzar cuando se reinicia el proceso o el sistema.

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

```promql
prometheus_tsdb_head_samples_appended_total
```

Para obtener la velocidad de cambio de un `counter` se utilizan funciones como:

```promql
rate()
```

```promql
irate()
```

---

## Rangos temporales

Las funciones que calculan cambios necesitan un rango temporal.

Ejemplo:

```promql
rate(node_cpu_seconds_total[5m])
```

El selector `[5m]` significa:

```text
Utilizar los datos de los últimos cinco minutos.
```

Rangos habituales:

| Rango | Significado |
|---|---|
| `[30s]` | Últimos 30 segundos |
| `[1m]` | Último minuto |
| `[5m]` | Últimos 5 minutos |
| `[15m]` | Últimos 15 minutos |
| `[1h]` | Última hora |
| `[1d]` | Último día |

Ejemplos:

```promql
rate(node_network_receive_bytes_total[1m])
```

```promql
rate(node_network_receive_bytes_total[5m])
```

```promql
rate(node_network_receive_bytes_total[15m])
```

Un rango demasiado corto puede producir resultados inestables o insuficientes. Un rango más largo suaviza las variaciones, pero responde más lentamente a los cambios.

---

## Operadores aritméticos

PromQL permite realizar cálculos con métricas.

Operadores principales:

| Operador | Función |
|---|---|
| `+` | Suma |
| `-` | Resta |
| `*` | Multiplicación |
| `/` | División |
| `%` | Módulo |
| `^` | Potencia |

### Restar métricas

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Dividir métricas

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Convertir a porcentaje

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Calcular memoria utilizada

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

---

## Operadores de comparación

PromQL admite las siguientes comparaciones:

| Operador | Función |
|---|---|
| `==` | Igual |
| `!=` | Distinto |
| `>` | Mayor que |
| `<` | Menor que |
| `>=` | Mayor o igual |
| `<=` | Menor o igual |

### Objetivos caídos

```promql
up == 0
```

### Memoria superior al 80 %

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
) > 80
```

### Sistemas de ficheros superiores al 90 %

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
) > 90
```

Estas consultas devuelven únicamente las series que cumplen la condición.

---

## Funciones de agregación

### `sum()`

Suma los valores de varias series.

```promql
sum(node_network_receive_bytes_total)
```

Suma el tráfico recibido por instancia:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### `avg()`

Calcula la media:

```promql
avg(node_load1)
```

Media del tiempo de CPU inactiva por instancia:

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### `min()`

Devuelve el valor mínimo:

```promql
min(node_memory_MemAvailable_bytes)
```

### `max()`

Devuelve el valor máximo:

```promql
max(node_memory_MemAvailable_bytes)
```

### `count()`

Cuenta las series:

```promql
count(up)
```

Cuenta las series de CPU:

```promql
count(node_cpu_seconds_total)
```

---

## Agrupación con `by`

La cláusula `by` permite definir las etiquetas que deben conservarse en el resultado.

### Media por instancia

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
)
```

### Suma por interfaz

```promql
sum by (device) (
  rate(node_network_receive_bytes_total[5m])
)
```

### Suma por instancia y dispositivo

```promql
sum by (instance, device) (
  rate(node_network_receive_bytes_total[5m])
)
```

### Media por modo de CPU

```promql
avg by (mode) (
  rate(node_cpu_seconds_total[5m])
)
```

---

## Agrupación con `without`

`without` elimina determinadas etiquetas del resultado y conserva las demás.

Ejemplo:

```promql
sum without (cpu, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

Esta consulta elimina las etiquetas `cpu` y `mode` del resultado.

Comparación:

```promql
sum by (instance) (
  rate(node_cpu_seconds_total[5m])
)
```

```promql
sum without (cpu, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

Ambas consultas pueden producir resultados parecidos, pero `by` y `without` expresan la intención de forma diferente.

---

## Uso de CPU

La métrica principal es:

```promql
node_cpu_seconds_total
```

Esta métrica es un contador y se divide por modo:

- `idle`
- `user`
- `system`
- `iowait`
- `irq`
- `softirq`
- `steal`
- Otros modos disponibles

### Tiempo de CPU inactiva

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Porcentaje de CPU inactiva

```promql
100 * (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  )
)
```

### Porcentaje de CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Uso de CPU por núcleo

```promql
100 - (
  rate(node_cpu_seconds_total{
    mode="idle"
  }[5m]) * 100
)
```

Esta consulta conserva las etiquetas de cada CPU.

### Uso de CPU del sistema

```promql
100 * avg by (instance) (
  rate(node_cpu_seconds_total{
    mode="system"
  }[5m])
)
```

### Uso de CPU de usuario

```promql
100 * avg by (instance) (
  rate(node_cpu_seconds_total{
    mode="user"
  }[5m])
)
```

---

## Uso de memoria

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

### Memoria utilizada en bytes

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Porcentaje de memoria utilizado

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Porcentaje de memoria disponible

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Memoria utilizada en gibibytes

```promql
(
  node_memory_MemTotal_bytes
  -
  node_memory_MemAvailable_bytes
) / 1024 / 1024 / 1024
```

En Grafana se recomienda configurar la unidad del panel como:

```text
bytes
```

o:

```text
gibibytes
```

---

## Uso de sistemas de ficheros

### Tamaño total

```promql
node_filesystem_size_bytes
```

### Espacio disponible

```promql
node_filesystem_avail_bytes
```

### Espacio libre

```promql
node_filesystem_free_bytes
```

### Consultar la raíz

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

### Excluir sistemas virtuales

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Uso en bytes

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
-
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

### Sistemas de ficheros con más del 80 % de uso

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
) > 80
```

### Agrupar por punto de montaje

```promql
max by (instance, mountpoint) (
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
)
```

---

## Tráfico de red

Las métricas de tráfico son contadores.

### Bytes recibidos

```promql
node_network_receive_bytes_total
```

### Bytes enviados

```promql
node_network_transmit_bytes_total
```

### Tráfico recibido por segundo

```promql
rate(node_network_receive_bytes_total[5m])
```

### Tráfico enviado por segundo

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Excluir loopback

```promql
rate(node_network_receive_bytes_total{
  device!="lo"
}[5m])
```

### Sumar tráfico recibido por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Sumar tráfico enviado por instancia

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

### Tráfico total recibido y enviado

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
+
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

---

## `rate()` e `irate()`

### `rate()`

`rate()` calcula la velocidad media de cambio de un contador durante un intervalo.

```promql
rate(node_network_receive_bytes_total[5m])
```

Es apropiada para:

- Dashboards.
- Gráficos estables.
- Consultas de tendencias.
- Reglas de alerta.

### `irate()`

`irate()` calcula una velocidad utilizando las muestras más recientes del rango.

```promql
irate(node_network_receive_bytes_total[5m])
```

Es más sensible a cambios rápidos y puede resultar más irregular.

### Comparación

| Función | Comportamiento | Uso habitual |
|---|---|---|
| `rate()` | Más estable | Dashboards y alertas |
| `irate()` | Más sensible | Cambios rápidos y análisis puntual |

---

## Tiempo de actividad

### Tiempo de actividad en segundos

```promql
node_time_seconds
-
node_boot_time_seconds
```

### Tiempo de actividad en días

```promql
(
  node_time_seconds
  -
  node_boot_time_seconds
) / 86400
```

### Tiempo de actividad de Prometheus

```promql
time()
-
process_start_time_seconds{job="prometheus"}
```

---

## Carga del sistema

### Carga a un minuto

```promql
node_load1
```

### Carga a cinco minutos

```promql
node_load5
```

### Carga a quince minutos

```promql
node_load15
```

### Comparar la carga con el número de CPUs

```promql
node_load1
/
count by (instance) (
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

La interpretación de la carga depende del número de CPUs disponibles. Una carga de `2` no significa lo mismo en un sistema con dos CPUs que en uno con dieciséis.

---

## Operadores lógicos y de conjunto

PromQL permite utilizar operadores como:

- `and`
- `or`
- `unless`

### Objetivos disponibles de Node Exporter

```promql
up{job="node_exporter"} == 1
```

### Objetivos caídos de Node Exporter

```promql
up{job="node_exporter"} == 0
```

### Combinar condiciones

```promql
(
  up{job="node_exporter"} == 1
)
and
(
  node_memory_MemAvailable_bytes > 0
)
```

### Utilizar `or`

```promql
up{job="node_exporter"} == 0
or
up{job="prometheus"} == 0
```

### Utilizar `unless`

```promql
up unless up{job="node_exporter"}
```

Los operadores de conjunto deben utilizarse comprendiendo las etiquetas de las series implicadas.

---

## Comparación entre series

Cuando se combinan métricas, PromQL utiliza las etiquetas para relacionar las series.

### División directa

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Ambas métricas deben compartir etiquetas compatibles.

### Agrupación previa

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total[5m])
)
```

La agrupación permite obtener un resultado con etiquetas conocidas y facilita operaciones posteriores.

### Ignorar etiquetas

En casos más avanzados pueden utilizarse modificadores como:

```promql
ignoring(device)
```

o:

```promql
on(instance)
```

Ejemplo conceptual:

```promql
rate(node_network_receive_bytes_total[5m])
  / ignoring(device)
sum by (instance) (
  rate(node_network_receive_bytes_total[5m])
)
```

Estos modificadores deben utilizarse con cuidado, porque una combinación incorrecta puede producir resultados vacíos o duplicados.

---

## Métricas de Prometheus

### Información de compilación

```promql
prometheus_build_info
```

### Series actuales

```promql
prometheus_tsdb_head_series
```

### Muestras añadidas

```promql
prometheus_tsdb_head_samples_appended_total
```

### Memoria del proceso

```promql
process_resident_memory_bytes{job="prometheus"}
```

### CPU del proceso

```promql
rate(process_cpu_seconds_total{job="prometheus"}[5m])
```

### Tiempo de actividad de Prometheus

```promql
time()
-
process_start_time_seconds{job="prometheus"}
```

### Objetivos disponibles

```promql
sum(up)
```

### Objetivos totales

```promql
count(up)
```

---

## Consultas para Grafana

Las siguientes consultas pueden utilizarse como base para paneles.

### Panel de disponibilidad

```promql
up{job="node_exporter"}
```

Tipo recomendado:

```text
Stat
```

Unidad:

```text
none
```

### Panel de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Tipo recomendado:

```text
Time series
```

Unidad:

```text
Percent (0-100)
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

Tipo recomendado:

```text
Gauge
```

Unidad:

```text
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

Tipo recomendado:

```text
Gauge
```

Unidad:

```text
Percent (0-100)
```

### Panel de tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Tipo recomendado:

```text
Time series
```

Unidad:

```text
bytes/sec
```

### Panel de carga

```promql
node_load1
```

Tipo recomendado:

```text
Time series
```

Unidad:

```text
none
```

---

## Consultar PromQL mediante la API

### Consulta instantánea

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Mostrar job, instancia y valor

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq -r '
    .data.result[]
    | [
        .metric.job,
        .metric.instance,
        .value[1]
      ]
    | @tsv
  '
```

### Consultar el uso de memoria

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)' \
  | jq
```

### Consultar un rango temporal

```bash
START=$(date -d '15 minutes ago' +%s)
END=$(date +%s)

curl -sG http://localhost:9090/api/v1/query_range \
  --data-urlencode 'query=up' \
  --data-urlencode "start=$START" \
  --data-urlencode "end=$END" \
  --data-urlencode 'step=15' \
  | jq
```

### Guardar una consulta

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq \
  > query-up.json
```

---

# Sesiones prácticas

## Sesión 1: ejecutar consultas básicas

### Objetivo

Familiarizarse con el editor de consultas.

### Consultas

```promql
up
```

```promql
prometheus_build_info
```

```promql
process_resident_memory_bytes{job="prometheus"}
```

```promql
node_memory_MemAvailable_bytes
```

### Actividades

1. Ejecuta cada consulta.
2. Cambia entre tabla y gráfico.
3. Anota cuántas series devuelve cada una.
4. Identifica las etiquetas.
5. Indica si la métrica procede de Prometheus o de Node Exporter.

Completar:

| Consulta | Número de series | Tipo de información |
|---|---:|---|
| `up` | | |
| `prometheus_build_info` | | |
| `process_resident_memory_bytes` | | |
| `node_memory_MemAvailable_bytes` | | |

---

## Sesión 2: practicar filtros de etiquetas

### Objetivo

Filtrar resultados utilizando etiquetas.

### Consultas

```promql
up{job="node_exporter"}
```

```promql
up{job="prometheus"}
```

```promql
node_cpu_seconds_total{mode="idle"}
```

```promql
node_network_receive_bytes_total{device!="lo"}
```

```promql
node_network_receive_bytes_total{device=~"en.*"}
```

### Actividades

1. Ejecuta la consulta sin filtros.
2. Añade un filtro por `job`.
3. Añade un filtro por `mode`.
4. Excluye la interfaz `lo`.
5. Utiliza una expresión regular.
6. Explica la diferencia entre `=` y `=~`.

---

## Sesión 3: analizar la métrica `up`

### Objetivo

Comprobar el estado de los objetivos mediante PromQL.

### Consultas

```promql
up
```

```promql
up == 1
```

```promql
up == 0
```

```promql
count(up)
```

```promql
sum(up)
```

```promql
100 * avg(up)
```

### Actividades

1. Cuenta los objetivos configurados.
2. Cuenta los objetivos disponibles.
3. Calcula el porcentaje de disponibilidad.
4. Detén temporalmente Node Exporter:

```bash
sudo systemctl stop node_exporter
```

5. Si utilizas el paquete de Ubuntu, ejecuta:

```bash
sudo systemctl stop prometheus-node-exporter
```

6. Espera varios intervalos de *scraping*.
7. Ejecuta:

```promql
up{job="node_exporter"}
```

8. Inicia de nuevo el servicio:

```bash
sudo systemctl start node_exporter
```

9. Si utilizas el paquete de Ubuntu:

```bash
sudo systemctl start prometheus-node-exporter
```

10. Comprueba la recuperación.

---

## Sesión 4: calcular el uso de memoria

### Objetivo

Crear consultas derivadas a partir de dos métricas.

### Consultas

Memoria total:

```promql
node_memory_MemTotal_bytes
```

Memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Memoria utilizada:

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

Porcentaje disponible:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Porcentaje utilizado:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Porcentaje redondeado:

```promql
round(
  100 * (
    1 -
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  ),
  0.1
)
```

### Actividades

1. Ejecuta cada consulta.
2. Compara el resultado con:

```bash
free -h
```

3. Comprueba las unidades.
4. Explica la diferencia entre memoria libre y memoria disponible.
5. Indica qué consulta utilizarías en un panel de Grafana.

---

## Sesión 5: calcular el uso de CPU

### Objetivo

Calcular el porcentaje de CPU utilizada.

### Paso 1: consultar la métrica original

```promql
node_cpu_seconds_total
```

### Paso 2: filtrar el tiempo inactivo

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Paso 3: calcular la velocidad de cambio

```promql
rate(node_cpu_seconds_total{
  mode="idle"
}[5m])
```

### Paso 4: agrupar por instancia

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{
    mode="idle"
  }[5m])
)
```

### Paso 5: calcular el uso

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

### Actividades

1. Ejecuta las consultas en orden.
2. Explica qué cambia en cada paso.
3. Observa el resultado como gráfico.
4. Genera carga temporal:

```bash
yes > /dev/null &
yes > /dev/null &
```

5. Comprueba el uso de CPU.
6. Detén los procesos:

```bash
pkill yes
```

7. Observa la recuperación del gráfico.

> Esta actividad debe realizarse únicamente en un entorno de laboratorio.

---

## Sesión 6: analizar el almacenamiento

### Objetivo

Calcular el espacio utilizado por los sistemas de ficheros.

### Consultas

```promql
node_filesystem_size_bytes
```

```promql
node_filesystem_avail_bytes
```

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

Uso de `/`:

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

### Actividades

1. Consulta los sistemas de ficheros.
2. Identifica el punto de montaje raíz.
3. Excluye sistemas virtuales.
4. Compara el resultado con:

```bash
df -h /
```

5. Añade un umbral conceptual:

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
) > 80
```

---

## Sesión 7: analizar la red

### Objetivo

Consultar el tráfico de red y calcular su velocidad.

### Consultas

```promql
node_network_receive_bytes_total
```

```promql
node_network_transmit_bytes_total
```

```promql
rate(node_network_receive_bytes_total[5m])
```

```promql
rate(node_network_transmit_bytes_total[5m])
```

Excluir loopback:

```promql
rate(node_network_receive_bytes_total{
  device!="lo"
}[5m])
```

Agrupar por interfaz:

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Actividades

1. Identifica las interfaces.
2. Excluye `lo`.
3. Calcula el tráfico recibido.
4. Calcula el tráfico enviado.
5. Genera tráfico mediante una descarga o navegación controlada.
6. Observa el cambio en el gráfico.
7. Compara con:

```bash
ip -s link
```

---

## Sesión 8: utilizar agregaciones

### Objetivo

Practicar `sum`, `avg`, `min`, `max` y `count`.

### Consultas

```promql
count(node_cpu_seconds_total)
```

```promql
avg(node_load1)
```

```promql
min(node_memory_MemAvailable_bytes)
```

```promql
max(node_memory_MemAvailable_bytes)
```

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Actividades

1. Cuenta las series de CPU.
2. Calcula la carga media.
3. Consulta el mínimo de memoria disponible.
4. Consulta el máximo de memoria disponible.
5. Suma el tráfico por instancia.
6. Explica qué etiquetas se conservan en cada resultado.

---

## Sesión 9: utilizar `rate()` e `irate()`

### Objetivo

Comparar dos funciones utilizadas con contadores.

### Consultas

```promql
rate(node_network_receive_bytes_total[5m])
```

```promql
irate(node_network_receive_bytes_total[5m])
```

### Actividades

1. Ejecuta ambas consultas.
2. Represéntalas en gráficos.
3. Compara la estabilidad de los resultados.
4. Explica cuál utilizarías en un dashboard.
5. Explica cuál puede mostrar cambios más bruscos.

---

## Sesión 10: preparar consultas para Grafana

### Objetivo

Crear consultas reutilizables en paneles.

### Panel de disponibilidad

```promql
up{job="node_exporter"}
```

### Panel de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
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

### Panel de disco

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

### Panel de red

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Actividades

1. Ejecuta cada consulta en Prometheus.
2. Comprueba que devuelve datos.
3. Anota las unidades.
4. Identifica las etiquetas del resultado.
5. Copia las consultas para utilizarlas posteriormente en Grafana.

---

# Diagnóstico de consultas

## La consulta no devuelve datos

Comprobar primero:

```promql
up
```

Después:

```promql
prometheus_build_info
```

Y, si Node Exporter está instalado:

```promql
node_memory_MemAvailable_bytes
```

Posibles causas:

- El nombre de la métrica es incorrecto.
- Node Exporter está detenido.
- El target está en estado `DOWN`.
- La etiqueta no existe.
- La etiqueta está escrita incorrectamente.
- El rango temporal no contiene muestras.
- El objetivo todavía no ha sido consultado.
- La métrica no está disponible en esa versión.

---

## Comprobar las métricas disponibles

Desde Node Exporter:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_'
```

Desde Prometheus:

```promql
{__name__=~"node_memory_.*"}
```

Consultar nombres de métricas mediante la API:

```bash
curl -s http://localhost:9090/api/v1/label/__name__/values \
  | jq -r '.data[]' \
  | grep '^node_memory_'
```

---

## Comprobar las etiquetas

Consultar una métrica amplia:

```promql
node_network_receive_bytes_total
```

Observar las etiquetas devueltas:

- `device`.
- `instance`.
- `job`.

Si una consulta utiliza:

```promql
device="eth0"
```

pero el sistema utiliza `ens33`, el resultado puede estar vacío.

---

## El resultado contiene demasiadas series

Reducir la consulta mediante:

- Filtros.
- Agregaciones.
- `sum by`.
- `avg by`.
- Exclusión de interfaces.
- Exclusión de sistemas de ficheros.

Ejemplo:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

---

## El resultado parece incorrecto

Comprobar:

1. El tipo de métrica.
2. Si es un `counter` o un `gauge`.
3. Si se necesita `rate()`.
4. El rango temporal.
5. Las etiquetas.
6. Las unidades.
7. La agrupación utilizada.
8. La compatibilidad de etiquetas entre métricas.

No se debe aplicar `rate()` a una métrica que ya representa un valor instantáneo, como:

```promql
node_memory_MemAvailable_bytes
```

---

## El gráfico aparece vacío

Comprobar:

- El rango temporal.
- El intervalo de *scraping*.
- El estado del target.
- La sintaxis de la consulta.
- La existencia de la métrica.
- Que no se está consultando un rango futuro.
- Que Prometheus lleva suficiente tiempo recopilando datos.

---

# Ejemplo de sesión completa

```console
$ systemctl is-active prometheus
active

$ systemctl is-active node_exporter
active

$ curl -sG http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    | jq -r '
      .data.result[]
      | [
          .metric.job,
          .metric.instance,
          .value[1]
        ]
      | @tsv
    '
prometheus      localhost:9090  1
node_exporter   localhost:9100  1
```

En la interfaz web se ejecutan las siguientes consultas:

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

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

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

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Resultado esperado:

- `up` devuelve `1`.
- La memoria devuelve un valor numérico.
- El uso de CPU se muestra como porcentaje.
- El uso de `/` se muestra como porcentaje.
- El tráfico de red se muestra como bytes por segundo.
- Las consultas devuelven series temporales cuando se visualizan como gráficos.

---

# Actividad integradora

## Objetivo

Crear y documentar un conjunto de consultas PromQL para monitorizar un servidor Linux.

## Consultas obligatorias

### Disponibilidad

```promql
up{job="node_exporter"}
```

### Uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Uso de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Uso del sistema de ficheros raíz

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

### Tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Tareas

1. Ejecutar cada consulta en Prometheus.
2. Comprobar que devuelve datos.
3. Identificar las unidades.
4. Identificar las etiquetas.
5. Ejecutar cada consulta en la API HTTP.
6. Guardar los resultados.
7. Preparar las consultas para Grafana.
8. Explicar el significado de cada consulta.
9. Indicar qué consulta utilizarías para una alerta.
10. Documentar cualquier problema encontrado.

---

## Guardar evidencias

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/promql
```

Guardar la consulta `up`:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq \
  > ~/laboratorio-grafana/evidencias/promql/up.json
```

Guardar el uso de memoria:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/promql/memoria.json
```

Guardar el uso de CPU:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/promql/cpu.json
```

Crear un fichero con las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/promql/consultas.txt <<'EOF'
Disponibilidad:
up{job="node_exporter"}

Uso de CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Uso de memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Uso del sistema de ficheros:
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
EOF
```

---

## Tabla de resultados

| Consulta | ¿Devuelve datos? | Unidad | Tipo de métrica | Observaciones |
|---|---|---|---|---|
| `up{job="node_exporter"}` | | | | |
| Uso de CPU | | `%` | | |
| Uso de memoria | | `%` | | |
| Uso de `/` | | `%` | | |
| Tráfico recibido | | `bytes/sec` | | |
| Carga del sistema | | | | |

---

# Puntos clave

- PromQL es el lenguaje de consultas de Prometheus.
- Una consulta puede devolver una o varias series temporales.
- Las etiquetas permiten filtrar y clasificar las series.
- `=` selecciona una coincidencia exacta.
- `=~` permite utilizar expresiones regulares.
- `up` indica si un objetivo está disponible.
- Los `gauge` representan valores que pueden subir o bajar.
- Los `counter` representan valores acumulativos.
- `rate()` calcula la velocidad media de cambio de un contador.
- `irate()` responde más rápidamente a cambios recientes.
- `sum()` suma series.
- `avg()` calcula medias.
- `count()` cuenta series.
- `by` define las etiquetas que se conservan en una agregación.
- Los porcentajes se calculan mediante operaciones aritméticas.
- Las métricas de CPU y red suelen requerir `rate()`.
- Las métricas de memoria y capacidad suelen consultarse directamente.
- Las consultas deben probarse antes de incorporarlas a Grafana.
- Una consulta vacía puede deberse a un nombre incorrecto, una etiqueta incorrecta o un objetivo no disponible.
- El rango temporal debe ser adecuado para la frecuencia de recopilación.
- Las unidades deben configurarse correctamente en los dashboards.

---

# Preguntas de comprobación

1. ¿Qué significa PromQL?
2. ¿Para qué sirve PromQL?
3. ¿Qué es una serie temporal?
4. ¿Qué información contiene una serie temporal?
5. ¿Qué consulta permite comprobar la disponibilidad de los objetivos?
6. ¿Qué diferencia existe entre `=` y `=~`?
7. ¿Qué diferencia existe entre un `gauge` y un `counter`?
8. ¿Para qué sirve `rate()`?
9. ¿Cuándo utilizarías `irate()`?
10. ¿Qué función cumple `sum()`?
11. ¿Qué función cumple `avg()`?
12. ¿Qué función cumple `count()`?
13. ¿Qué finalidad tiene `by`?
14. ¿Cómo calcularías el porcentaje de memoria utilizado?
15. ¿Cómo calcularías el uso de CPU?
16. ¿Por qué `node_cpu_seconds_total` suele utilizarse con `rate()`?
17. ¿Por qué no se aplica normalmente `rate()` a `node_memory_MemAvailable_bytes`?
18. ¿Cómo excluirías la interfaz `lo`?
19. ¿Cómo consultarías solamente el sistema de ficheros raíz?
20. ¿Qué puede provocar que una consulta no devuelva datos?
21. ¿Cómo consultarías Prometheus desde la terminal?
22. ¿Qué diferencia existe entre una consulta instantánea y una consulta de rango?
23. ¿Qué rango temporal utilizarías para calcular el uso de CPU?
24. ¿Qué consulta utilizarías para mostrar el tráfico recibido?
25. ¿Qué consulta utilizarías como panel de disponibilidad en Grafana?

---

# Criterios de finalización

La práctica se considera completada cuando el alumno puede:

- Ejecutar consultas básicas.
- Consultar métricas de Prometheus.
- Consultar métricas de Node Exporter.
- Filtrar por `job`.
- Filtrar por `instance`.
- Filtrar por `device`.
- Utilizar expresiones regulares.
- Interpretar la métrica `up`.
- Diferenciar `gauge` y `counter`.
- Utilizar `rate()`.
- Calcular el uso de CPU.
- Calcular el uso de memoria.
- Calcular el uso de almacenamiento.
- Calcular el tráfico de red.
- Utilizar agregaciones.
- Consultar mediante la API HTTP.
- Diagnosticar una consulta sin resultados.
- Preparar consultas para Grafana.
- Guardar las evidencias de las consultas.

El flujo que debe dominar el alumno es:

```text
Seleccionar una métrica
        |
        v
Filtrar mediante etiquetas
        |
        v
Aplicar una función o un operador
        |
        v
Agrupar el resultado
        |
        v
Interpretar la unidad
        |
        v
Representar en tabla, gráfico o dashboard
```