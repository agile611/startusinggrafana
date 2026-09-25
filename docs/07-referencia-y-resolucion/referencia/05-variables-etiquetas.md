# Variables y etiquetas

Las variables y las etiquetas son elementos fundamentales para trabajar con Prometheus y Grafana.

Las etiquetas permiten describir y diferenciar las series temporales. Las variables permiten que un dashboard sea reutilizable y que el alumno pueda seleccionar dinámicamente una instancia, un trabajo, una interfaz de red o un punto de montaje.

En un entorno de observabilidad, una misma métrica puede existir para muchos equipos, servicios o dispositivos. Las etiquetas indican a qué recurso pertenece cada valor.

Por ejemplo:

```promql
node_load1{
  instance="localhost:9100",
  job="node_exporter"
}
```

La métrica es:

```text
node_load1
```

Y las etiquetas son:

```text
instance="localhost:9100"
job="node_exporter"
```

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Diferenciar entre el nombre de una métrica y sus etiquetas.
- Consultar series mediante selectores de etiquetas.
- Utilizar coincidencias exactas y expresiones regulares.
- Identificar las etiquetas habituales de Node Exporter.
- Utilizar etiquetas para filtrar resultados en PromQL.
- Agrupar series mediante etiquetas.
- Crear variables dinámicas en Grafana.
- Utilizar variables de selección única y múltiple.
- Comprender el impacto de la cardinalidad.
- Identificar etiquetas apropiadas para dashboards y alertas.
- Diagnosticar consultas vacías o excesivamente amplias.
- Diseñar dashboards reutilizables para varias instancias.

## Introducción

Prometheus almacena cada serie temporal como una combinación de:

- Nombre de métrica.
- Conjunto de etiquetas.
- Valor.
- Marca temporal.

Por ejemplo:

```text
node_cpu_seconds_total{
  instance="localhost:9100",
  job="node_exporter",
  cpu="0",
  mode="idle"
}
```

Esta serie representa los segundos acumulados que la CPU `0` ha permanecido en modo `idle` en la instancia `localhost:9100`.

Si cambia una de las etiquetas, Prometheus considera que se trata de otra serie temporal.

Estas dos series son diferentes:

```text
node_load1{
  instance="server01:9100",
  job="node_exporter"
}
```

```text
node_load1{
  instance="server02:9100",
  job="node_exporter"
}
```

Aunque utilizan el mismo nombre de métrica, pertenecen a instancias distintas.

## Métricas y etiquetas

### Nombre de métrica

El nombre identifica el tipo de información almacenada.

Ejemplos:

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
node_cpu_seconds_total
```

### Etiquetas

Las etiquetas aportan contexto a la métrica.

Ejemplo:

```promql
node_load1{
  instance="localhost:9100",
  job="node_exporter"
}
```

En este caso:

| Elemento | Valor |
|---|---|
| Métrica | `node_load1` |
| Etiqueta | `instance` |
| Valor | `localhost:9100` |
| Etiqueta | `job` |
| Valor | `node_exporter` |

### Serie temporal completa

Una serie temporal puede representarse así:

```text
métrica + conjunto de etiquetas + valores a lo largo del tiempo
```

Ejemplo:

```text
node_load1{
  instance="localhost:9100",
  job="node_exporter"
}
```

Sus valores podrían ser:

```text
09:00 → 0.12
09:01 → 0.18
09:02 → 0.24
09:03 → 0.20
```

### Diferenciar series

Estas series tienen el mismo nombre, pero representan información diferente:

```text
node_network_receive_bytes_total{
  instance="localhost:9100",
  device="ens33"
}
```

```text
node_network_receive_bytes_total{
  instance="localhost:9100",
  device="lo"
}
```

La primera corresponde a la interfaz `ens33` y la segunda a la interfaz de loopback `lo`.

## Etiquetas habituales

### Etiqueta `job`

Identifica el trabajo o grupo de scraping configurado en Prometheus.

Ejemplo:

```promql
up{job="node_exporter"}
```

Valores habituales:

```text
node_exporter
prometheus
grafana
blackbox
```

El valor depende de la configuración de Prometheus.

### Etiqueta `instance`

Identifica normalmente la dirección del target consultado.

Ejemplo:

```text
instance="localhost:9100"
```

Otros ejemplos:

```text
instance="192.168.1.20:9100"
instance="server01:9100"
instance="prometheus:9090"
```

### Etiqueta `instance` y puerto

La etiqueta `instance` suele incluir el puerto:

```text
localhost:9100
```

Por eso estas dos consultas no son equivalentes:

```promql
up{instance="localhost"}
```

```promql
up{instance="localhost:9100"}
```

La segunda coincide con el formato habitual de Node Exporter.

### Etiqueta `job` frente a `instance`

| Etiqueta | Describe |
|---|---|
| `job` | Tipo o grupo de servicio supervisado |
| `instance` | Dirección concreta del target |

Ejemplo:

```text
job="node_exporter"
instance="server01:9100"
```

### Etiqueta `device`

Identifica una interfaz de red o un dispositivo.

Ejemplo:

```promql
node_network_receive_bytes_total{
  device="ens33"
}
```

Valores habituales:

```text
eth0
ens33
enp0s3
lo
docker0
```

### Etiqueta `mode`

Aparece en métricas de CPU y representa el modo de ejecución.

Ejemplo:

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

Valores habituales:

```text
idle
user
system
iowait
irq
softirq
steal
nice
```

### Etiqueta `cpu`

Identifica el núcleo o procesador lógico.

Ejemplo:

```promql
node_cpu_seconds_total{
  cpu="0"
}
```

### Etiqueta `mountpoint`

Identifica el punto de montaje de un sistema de archivos.

Ejemplo:

```promql
node_filesystem_avail_bytes{
  mountpoint="/"
}
```

Otros valores:

```text
/
/boot
/home
/var
```

### Etiqueta `fstype`

Identifica el tipo de sistema de archivos.

Ejemplo:

```promql
node_filesystem_size_bytes{
  fstype="ext4"
}
```

Valores habituales:

```text
ext4
xfs
tmpfs
overlay
squashfs
```

### Etiqueta `device`

En métricas de sistemas de archivos puede identificar el dispositivo:

```promql
node_filesystem_size_bytes{
  device="/dev/sda2"
}
```

El significado exacto de una etiqueta depende de la métrica consultada.

## Consultar etiquetas existentes

### Consultar una métrica

```promql
up
```

```promql
node_load1
```

```promql
node_network_receive_bytes_total
```

La interfaz de Prometheus mostrará las etiquetas asociadas a cada serie.

### Consultar todas las series de una métrica

```bash
curl -sG http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=node_load1' \
  | jq
```

### Consultar las etiquetas de una métrica

```bash
curl -sG http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=node_cpu_seconds_total' \
  | jq
```

### Consultar todos los nombres de etiquetas

```bash
curl -s http://localhost:9090/api/v1/labels | jq
```

### Consultar todos los valores de una etiqueta

Para consultar los valores de `job`:

```bash
curl -s http://localhost:9090/api/v1/label/job/values \
  | jq
```

Para consultar los valores de `instance`:

```bash
curl -s http://localhost:9090/api/v1/label/instance/values \
  | jq
```

Para consultar los valores de `device`:

```bash
curl -s http://localhost:9090/api/v1/label/device/values \
  | jq
```

### Consultar todos los nombres de métricas

```bash
curl -s http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

Esta consulta puede devolver muchos resultados en un entorno grande.

## Selectores de etiquetas en PromQL

Los selectores permiten elegir únicamente las series que cumplen determinadas condiciones.

### Coincidencia exacta

El operador `=` selecciona un valor concreto:

```promql
up{job="node_exporter"}
```

```promql
up{instance="localhost:9100"}
```

### Coincidencia distinta

El operador `!=` excluye un valor:

```promql
up{job!="node_exporter"}
```

Excluir la interfaz de loopback:

```promql
node_network_receive_bytes_total{
  device!="lo"
}
```

### Coincidencia mediante expresión regular

El operador `=~` selecciona valores que coinciden con una expresión regular:

```promql
up{job=~"node_exporter|prometheus"}
```

Seleccionar varias interfaces:

```promql
node_network_receive_bytes_total{
  device=~"eth0|ens33|enp0s3"
}
```

Seleccionar todas las interfaces cuyo nombre empiece por `en`:

```promql
node_network_receive_bytes_total{
  device=~"en.*"
}
```

### Exclusión mediante expresión regular

El operador `!~` excluye valores que coinciden con una expresión regular:

```promql
node_network_receive_bytes_total{
  device!~"lo|docker.*|veth.*"
}
```

Excluir sistemas de archivos virtuales:

```promql
node_filesystem_size_bytes{
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Combinar etiquetas

```promql
node_cpu_seconds_total{
  instance="localhost:9100",
  mode="idle"
}
```

```promql
node_filesystem_avail_bytes{
  instance="localhost:9100",
  mountpoint="/",
  fstype="ext4"
}
```

Todas las condiciones deben cumplirse.

## Consultas con etiquetas

### Consultar un trabajo concreto

```promql
up{job="node_exporter"}
```

### Consultar una instancia concreta

```promql
up{instance="localhost:9100"}
```

### Consultar CPU de una instancia

```promql
rate(
  node_cpu_seconds_total{
    instance="localhost:9100"
  }[5m]
)
```

### Consultar CPU en modo idle

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Consultar la interfaz principal

```promql
rate(
  node_network_receive_bytes_total{
    device="ens33"
  }[5m]
)
```

Sustituye `ens33` por el nombre real de la interfaz.

### Consultar el sistema de archivos raíz

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Consultar una combinación de trabajo e instancia

```promql
node_load1{
  job="node_exporter",
  instance="localhost:9100"
}
```

## Agregaciones por etiquetas

Las agregaciones permiten resumir varias series conservando las etiquetas necesarias.

### `sum by`

Sumar tráfico por instancia:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

Sumar tráfico por interfaz:

```promql
sum by (device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### `avg by`

Calcular la carga media por instancia:

```promql
avg by (instance) (
  node_load1
)
```

Calcular el uso de CPU por instancia:

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

### `max by`

Obtener la carga máxima por instancia:

```promql
max by (instance) (
  node_load1
)
```

Obtener el uso máximo de almacenamiento por instancia:

```promql
max by (instance) (
  100 * (
    1 -
    node_filesystem_avail_bytes
    /
    node_filesystem_size_bytes
  )
)
```

### `count by`

Contar targets por trabajo:

```promql
count by (job) (
  up
)
```

Contar interfaces por instancia:

```promql
count by (instance) (
  node_network_receive_bytes_total
)
```

### `sum without`

Excluir etiquetas de la agrupación:

```promql
sum without (cpu, mode) (
  rate(
    node_cpu_seconds_total[5m]
  )
)
```

### Elegir las etiquetas de agrupación

Antes de utilizar una agregación, decide qué contexto debe conservarse.

Ejemplo:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

El resultado conserva `instance`, pero ya no diferencia las interfaces.

Si necesitas conservar la interfaz:

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

## Etiquetas y métricas de CPU

### Consultar todos los núcleos

```promql
node_cpu_seconds_total
```

### Filtrar una instancia

```promql
node_cpu_seconds_total{
  instance="localhost:9100"
}
```

### Filtrar un núcleo

```promql
node_cpu_seconds_total{
  cpu="0"
}
```

### Filtrar el modo `idle`

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

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

Este resultado conserva etiquetas como:

```text
instance
job
cpu
```

### CPU utilizada por instancia y modo

```promql
100 *
sum by (instance, mode) (
  rate(
    node_cpu_seconds_total[5m]
  )
)
```

## Etiquetas y métricas de red

### Consultar las interfaces

```promql
node_network_receive_bytes_total
```

### Consultar una interfaz concreta

```promql
node_network_receive_bytes_total{
  device="ens33"
}
```

### Excluir loopback

```promql
node_network_receive_bytes_total{
  device!="lo"
}
```

### Excluir interfaces virtuales

```promql
node_network_receive_bytes_total{
  device!~"lo|docker.*|veth.*|br-.*"
}
```

### Tráfico recibido por interfaz

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

### Tráfico recibido agregado por instancia

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total{
      device!~"lo|docker.*|veth.*|br-.*"
    }[5m]
  )
)
```

### Tráfico recibido por instancia e interfaz

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      device!~"lo|docker.*|veth.*|br-.*"
    }[5m]
  )
)
```

## Etiquetas y sistemas de archivos

### Consultar todos los puntos de montaje

```promql
node_filesystem_size_bytes
```

### Consultar la raíz

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

### Filtrar por tipo de sistema de archivos

```promql
node_filesystem_size_bytes{
  fstype="ext4"
}
```

### Excluir sistemas virtuales

```promql
node_filesystem_size_bytes{
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Consultar un dispositivo concreto

```promql
node_filesystem_size_bytes{
  device="/dev/sda2"
}
```

El nombre real del dispositivo puede variar. Consulta primero las series disponibles.

### Porcentaje utilizado por punto de montaje

```promql
100 * (
  1 -
  node_filesystem_avail_bytes
  /
  node_filesystem_size_bytes
)
```

### Porcentaje utilizado únicamente en `/`

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

### Porcentaje utilizado por instancia y punto de montaje

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

El resultado conserva etiquetas como:

```text
instance
job
mountpoint
device
fstype
```

## Variables en Grafana

Las variables de Grafana permiten seleccionar dinámicamente valores utilizados en las consultas.

Un dashboard con una variable puede funcionar para:

- Varias instancias.
- Varios trabajos.
- Varias interfaces.
- Varios puntos de montaje.
- Varios dispositivos.
- Diferentes entornos.

Sin variables, una consulta puede quedar fijada a una única instancia:

```promql
node_load1{
  instance="localhost:9100"
}
```

Con una variable llamada `instance`:

```promql
node_load1{
  instance="$instance"
}
```

El dashboard podrá cambiar de instancia sin modificar manualmente cada panel.

## Crear una variable de instancia

### Paso 1: abrir la configuración del dashboard

En Grafana:

1. Abre el dashboard.
2. Accede a **Dashboard settings**.
3. Selecciona **Variables**.
4. Pulsa **Add variable**.

### Paso 2: configurar la variable

Utiliza valores similares a:

```text
Name: instance
Label: Instancia
Type: Query
Data source: Prometheus
```

### Paso 3: consultar los valores

Una consulta habitual es:

```promql
label_values(up, instance)
```

En algunas versiones de Grafana, el editor de variables ofrece directamente el selector de etiqueta. En versiones recientes, la sintaxis disponible puede variar según el tipo de consulta y la versión instalada.

### Paso 4: guardar la variable

Guarda la variable y comprueba que aparece en la parte superior del dashboard.

## Crear una variable de trabajo

### Consulta

```promql
label_values(up, job)
```

Configuración recomendada:

```text
Name: job
Label: Trabajo
Type: Query
Data source: Prometheus
```

### Utilizarla en una consulta

```promql
up{
  job="$job"
}
```

Si se permite seleccionar varios trabajos:

```promql
up{
  job=~"$job"
}
```

## Crear una variable de interfaz

### Consulta

```promql
label_values(
  node_network_receive_bytes_total,
  device
)
```

Configuración recomendada:

```text
Name: device
Label: Interfaz
Type: Query
Data source: Prometheus
```

### Utilizarla en un panel

```promql
rate(
  node_network_receive_bytes_total{
    instance=~"$instance",
    device=~"$device"
  }[5m]
)
```

## Crear una variable de punto de montaje

### Consulta

```promql
label_values(
  node_filesystem_size_bytes,
  mountpoint
)
```

### Utilizarla en un panel

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint"
  }
)
```

Puede ser necesario filtrar sistemas de archivos virtuales:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

## Selección única y múltiple

### Selección única

La variable permite seleccionar un único valor:

```text
localhost:9100
```

La consulta puede utilizar:

```promql
instance="$instance"
```

### Selección múltiple

La variable permite seleccionar varios valores:

```text
localhost:9100
server01:9100
server02:9100
```

La consulta debe utilizar una expresión regular:

```promql
instance=~"$instance"
```

No utilices:

```promql
instance="$instance"
```

para una variable múltiple, porque puede no coincidir con varios valores.

### Opción `All`

La opción **Include All option** permite seleccionar todas las instancias.

En ese caso, utiliza:

```promql
instance=~"$instance"
```

La expresión regular generada por Grafana puede ser similar a:

```text
.*
```

## Variables encadenadas

Una variable puede depender del valor seleccionado en otra.

### Variable de instancia

```promql
label_values(up, instance)
```

### Variable de interfaz dependiente de la instancia

```promql
label_values(
  node_network_receive_bytes_total{
    instance=~"$instance"
  },
  device
)
```

### Variable de punto de montaje dependiente de la instancia

```promql
label_values(
  node_filesystem_size_bytes{
    instance=~"$instance"
  },
  mountpoint
)
```

El flujo será:

```text
Seleccionar instancia
        |
        v
Mostrar sus interfaces
        |
        v
Seleccionar una interfaz
```

## Variables constantes

No todas las variables tienen que consultar Prometheus.

Una variable de tipo custom puede contener valores definidos manualmente:

```text
dev
test
produccion
```

Ejemplo:

```text
Name: environment
Type: Custom
Values: laboratorio,preproduccion,produccion
```

Utilización:

```promql
up{
  environment="$environment"
}
```

Esta consulta solo funcionará si la etiqueta `environment` existe en las series.

## Variables de intervalo temporal

Grafana puede utilizar una variable de intervalo para modificar la ventana de consulta.

Ejemplo:

```text
$__rate_interval
```

Consulta:

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[$__rate_interval]
)
```

También puede utilizarse:

```promql
rate(
  node_network_receive_bytes_total[$__rate_interval]
)
```

`$__rate_interval` es útil porque Grafana adapta el intervalo a la resolución temporal del panel.

## Variables integradas de Grafana

Grafana proporciona variables integradas para el intervalo y el tiempo.

Ejemplos:

```text
$__interval
```

```text
$__rate_interval
```

```text
$__range
```

```text
$__from
```

```text
$__to
```

### Utilizar `$__rate_interval`

```promql
rate(
  node_cpu_seconds_total[$__rate_interval]
)
```

### Utilizar `$__interval`

```promql
avg_over_time(
  node_load1[$__interval]
)
```

### Utilizar el rango temporal del dashboard

```promql
increase(
  node_network_receive_bytes_total[$__range]
)
```

La disponibilidad concreta de las variables depende del contexto del panel y de la fuente de datos.

## Dashboards reutilizables

### Panel de CPU con instancia seleccionable

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        instance=~"$instance",
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Panel de memoria con instancia seleccionable

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance=~"$instance"
  }
  /
  node_memory_MemTotal_bytes{
    instance=~"$instance"
  }
)
```

### Panel de almacenamiento con instancia y punto de montaje

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Panel de red con instancia e interfaz

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      instance=~"$instance",
      device=~"$device"
    }[$__rate_interval]
  )
)
```

### Panel de disponibilidad

```promql
up{
  instance=~"$instance",
  job=~"$job"
}
```

## Etiquetas en Grafana

### Mostrar una etiqueta en la leyenda

En un panel de Grafana, puedes utilizar una leyenda como:

```text
{{instance}}
```

Para identificar también la interfaz:

```text
{{instance}} - {{device}}
```

Para CPU por núcleo:

```text
{{instance}} - CPU {{cpu}} - {{mode}}
```

### Ejemplo de nombres de series

Consulta:

```promql
rate(
  node_network_receive_bytes_total{
    instance=~"$instance",
    device=~"$device"
  }[$__rate_interval]
)
```

Leyenda:

```text
Recepción - {{instance}} - {{device}}
```

### Ocultar etiquetas no necesarias

Si el panel muestra demasiadas series:

1. Revisa las etiquetas de la consulta.
2. Utiliza una agregación.
3. Conserva únicamente las etiquetas necesarias.
4. Configura una leyenda clara.

Ejemplo:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[$__rate_interval]
  )
)
```

Esta consulta oculta la separación por interfaz y muestra el total por instancia.

## Cardinalidad

La cardinalidad es el número de series temporales generadas por una métrica y sus combinaciones de etiquetas.

### Ejemplo de cardinalidad baja

```text
up{
  job="node_exporter",
  instance="localhost:9100"
}
```

Si existen diez instancias, se generan aproximadamente diez series para esa métrica.

### Ejemplo de cardinalidad mayor

```text
node_cpu_seconds_total{
  instance="localhost:9100",
  job="node_exporter",
  cpu="0",
  mode="idle"
}
```

La cantidad de series aumenta por la combinación de:

- Instancias.
- CPUs.
- Modos.
- Trabajos.

### Etiquetas controladas

Son ejemplos de etiquetas normalmente adecuadas:

```text
job
instance
device
cpu
mode
mountpoint
fstype
```

### Etiquetas peligrosas

No conviene utilizar como etiquetas valores con una cantidad enorme de posibilidades o que cambien continuamente.

Ejemplos potencialmente peligrosos:

```text
request_id
session_id
timestamp
url_completa
mensaje_de_error
direccion_ip_aleatoria
```

Cada valor diferente puede crear una serie nueva.

### Consecuencias de una cardinalidad elevada

Una cardinalidad excesiva puede producir:

- Mayor consumo de memoria.
- Mayor uso de almacenamiento.
- Consultas más lentas.
- Dashboards más pesados.
- Mayor tiempo de evaluación de reglas.
- Dificultades de mantenimiento.

### Comprobar la cardinalidad conceptual

Cuando diseñes una métrica, responde:

1. ¿Cuántos valores puede tener cada etiqueta?
2. ¿Cuántas combinaciones pueden generarse?
3. ¿Los valores son estables?
4. ¿La etiqueta será necesaria en las consultas?
5. ¿Puede sustituirse por otra información menos variable?

## Etiquetas en reglas de alertas

Las etiquetas de una métrica y las etiquetas de una alerta cumplen funciones distintas.

### Etiquetas de una métrica

Identifican una serie:

```text
job="node_exporter"
instance="localhost:9100"
```

### Etiquetas de una alerta

Clasifican una alerta:

```yaml
labels:
  severity: warning
  team: sistemas
```

### Ejemplo conceptual

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
          summary: Node Exporter no está disponible
          description: El target {{ $labels.instance }} no responde
```

En este ejemplo:

- `job` e `instance` proceden de la métrica.
- `severity` y `servicio` se añaden a la alerta.
- `{{ $labels.instance }}` utiliza una etiqueta de la serie que activó la alerta.

## Etiquetas externas

Prometheus puede añadir etiquetas externas a las métricas o alertas enviadas a otros sistemas.

Ejemplo conceptual:

```yaml
global:
  external_labels:
    entorno: laboratorio
    cluster: observabilidad
```

Estas etiquetas pueden ayudar a distinguir datos procedentes de diferentes Prometheus.

## Relabeling

El relabeling permite modificar etiquetas durante el proceso de descubrimiento o scraping.

Puede utilizarse para:

- Cambiar nombres de etiquetas.
- Añadir etiquetas.
- Eliminar etiquetas.
- Filtrar targets.
- Reescribir direcciones.
- Normalizar valores.

### Ejemplo de añadir una etiqueta al target

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          entorno: laboratorio
          servicio: sistema
```

Después, las consultas pueden filtrar por:

```promql
up{
  entorno="laboratorio"
}
```

### Ejemplo de conservar solo determinados targets

```yaml
relabel_configs:
  - source_labels: [__address__]
    regex: "localhost:9100"
    action: keep
```

### Ejemplo de eliminar una etiqueta

```yaml
metric_relabel_configs:
  - regex: "etiqueta_temporal"
    action: labeldrop
```

El relabeling debe utilizarse con cuidado porque puede modificar la identidad de las series.

## Relabeling de métricas

`metric_relabel_configs` se aplica a las muestras después del scraping y antes de almacenarlas.

Ejemplo conceptual:

```yaml
metric_relabel_configs:
  - source_labels: [device]
    regex: "lo|docker.*|veth.*"
    action: drop
```

Esta configuración puede reducir series que no sean necesarias para el dashboard.

Antes de aplicarla:

1. Identifica las métricas afectadas.
2. Comprueba que no se utilizan en alertas.
3. Valida la configuración.
4. Realiza una copia de seguridad.
5. Reinicia Prometheus.
6. Comprueba las consultas posteriores.

## Diagnóstico de etiquetas

### La consulta no devuelve resultados

Consulta original:

```promql
up{instance="localhost"}
```

Posible problema: el valor real incluye el puerto.

Consulta de diagnóstico:

```promql
up
```

Después revisa la etiqueta `instance` y utiliza el valor real:

```promql
up{instance="localhost:9100"}
```

### No se conoce el nombre de una etiqueta

Consulta todas las etiquetas:

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### No se conocen los valores de una etiqueta

```bash
curl -s http://localhost:9090/api/v1/label/instance/values \
  | jq
```

### La variable de Grafana aparece vacía

Comprueba:

- La fuente de datos seleccionada.
- El nombre exacto de la etiqueta.
- Que la métrica exista.
- Que Prometheus tenga series recientes.
- Que la consulta no contenga un filtro incorrecto.
- Que el dashboard tenga acceso a la fuente de datos.

Prueba primero:

```promql
up
```

Después:

```promql
label_values(up, instance)
```

### La consulta devuelve demasiadas series

Comprueba las etiquetas incluidas:

```promql
node_cpu_seconds_total
```

Después filtra:

```promql
node_cpu_seconds_total{
  instance=~"$instance",
  mode="idle"
}
```

O agrega:

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[$__rate_interval]
  )
)
```

### La selección múltiple no funciona

Incorrecto:

```promql
up{
  instance="$instance"
}
```

Correcto:

```promql
up{
  instance=~"$instance"
}
```

Cuando una variable permite varios valores, normalmente debe utilizarse `=~`.

## Sesión práctica 1: descubrir etiquetas

En esta sesión se identificarán las etiquetas disponibles en el entorno.

### Objetivo

Consultar los nombres y valores de las etiquetas utilizadas por Node Exporter.

### Consultar una métrica básica

```promql
up
```

Anota las etiquetas que aparecen.

### Consultar las etiquetas de CPU

```promql
node_cpu_seconds_total
```

Identifica:

```text
instance
job
cpu
mode
```

### Consultar las etiquetas de red

```promql
node_network_receive_bytes_total
```

Identifica:

```text
instance
job
device
```

### Consultar las etiquetas de almacenamiento

```promql
node_filesystem_size_bytes
```

Identifica:

```text
instance
job
device
fstype
mountpoint
```

### Utilizar la API

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### Consultar valores de `instance`

```bash
curl -s http://localhost:9090/api/v1/label/instance/values \
  | jq
```

### Consultar valores de `device`

```bash
curl -s http://localhost:9090/api/v1/label/device/values \
  | jq
```

### Evidencia

Crea un fichero con los resultados:

```bash
{
  echo "Etiquetas disponibles:"
  curl -s http://localhost:9090/api/v1/labels
  echo
  echo "Valores de instance:"
  curl -s http://localhost:9090/api/v1/label/instance/values
  echo
  echo "Valores de device:"
  curl -s http://localhost:9090/api/v1/label/device/values
} | tee inventario-etiquetas.txt
```

### Preguntas de análisis

- ¿Qué etiquetas aparecen en `up`?
- ¿Qué etiquetas aparecen en las métricas de CPU?
- ¿Qué etiquetas aparecen en las métricas de red?
- ¿Qué valores tiene `instance`?
- ¿Qué interfaces aparecen en `device`?
- ¿Qué sistemas de archivos aparecen en `mountpoint`?

## Sesión práctica 2: filtrar mediante etiquetas

### Objetivo

Practicar los operadores `=`, `!=`, `=~` y `!~`.

### Coincidencia exacta

```promql
up{job="node_exporter"}
```

### Excluir un trabajo

```promql
up{job!="prometheus"}
```

### Seleccionar varias opciones

```promql
up{job=~"node_exporter|prometheus"}
```

### Excluir interfaces virtuales

```promql
node_network_receive_bytes_total{
  device!~"lo|docker.*|veth.*|br-.*"
}
```

### Filtrar la raíz

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

### Combinar filtros

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay|squashfs"
}
```

### Actividad

Para cada consulta, anota:

```text
Consulta:

Número de series devueltas:

Etiquetas presentes:

Primer valor observado:

Interpretación:
```

## Sesión práctica 3: construir variables en Grafana

### Objetivo

Crear un dashboard que permita seleccionar una instancia y una interfaz.

### Crear la variable `instance`

Utiliza:

```text
Name: instance
Label: Instancia
Type: Query
Data source: Prometheus
Query: label_values(up, instance)
```

Activa, si procede:

```text
Multi-value: desactivado
Include All option: activado
```

### Crear la variable `device`

Utiliza:

```text
Name: device
Label: Interfaz
Type: Query
Data source: Prometheus
Query: label_values(
  node_network_receive_bytes_total{
    instance=~"$instance"
  },
  device
)
```

Activa:

```text
Multi-value: activado
Include All option: activado
```

### Crear un panel de tráfico recibido

Utiliza:

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      instance=~"$instance",
      device=~"$device"
    }[$__rate_interval]
  )
)
```

Configura la leyenda como:

```text
Recepción - {{instance}} - {{device}}
```

### Validación

1. Selecciona una instancia.
2. Comprueba la lista de interfaces.
3. Selecciona una interfaz.
4. Comprueba el gráfico.
5. Activa la opción **All**.
6. Comprueba que aparecen varias interfaces.
7. Revisa que la leyenda identifique cada serie.

## Sesión práctica 4: CPU parametrizada

### Objetivo

Crear un panel de CPU reutilizable para varias instancias.

### Crear la variable

Variable:

```text
Name: instance
Label: Instancia
Type: Query
Query: label_values(up, instance)
```

### Crear la consulta

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        instance=~"$instance",
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Configurar el panel

Utiliza:

```text
Tipo: Time series o Gauge
Unidad: percent (0-100)
Leyenda: CPU - {{instance}}
```

### Actividad de carga

En una terminal, ejecuta:

```bash
yes > /dev/null
```

Observa el panel y después detén el proceso:

```text
Ctrl + C
```

### Preguntas de análisis

- ¿La variable cambia correctamente la instancia?
- ¿Qué ocurre al seleccionar **All**?
- ¿La consulta devuelve una serie o varias?
- ¿Qué etiqueta se conserva después de `avg by (instance)`?
- ¿Qué ocurre con el panel al generar carga?

## Sesión práctica 5: almacenamiento por punto de montaje

### Objetivo

Crear un panel que permita elegir un punto de montaje.

### Crear la variable `mountpoint`

Consulta:

```promql
label_values(
  node_filesystem_size_bytes{
    instance=~"$instance",
    fstype!~"tmpfs|overlay|squashfs"
  },
  mountpoint
)
```

Configuración:

```text
Name: mountpoint
Label: Punto de montaje
Type: Query
Multi-value: activado
Include All option: activado
```

### Crear la consulta

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Configurar la leyenda

```text
Uso - {{instance}} - {{mountpoint}}
```

### Validación

Comprueba:

- El valor de `/`.
- El valor de otros puntos de montaje.
- La selección múltiple.
- La opción **All**.
- La exclusión de sistemas virtuales.
- La unidad en porcentaje.

## Sesión práctica 6: etiquetas y agregaciones

### Objetivo

Observar cómo cambia el resultado al conservar o eliminar etiquetas.

### Tráfico por interfaz

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

### Tráfico por instancia e interfaz

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Tráfico total por instancia

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Tráfico total del entorno

```promql
sum(
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Comparación

Completa esta tabla:

| Consulta | Número de series | Etiquetas conservadas |
|---|---:|---|
| `rate(node_network_receive_bytes_total[5m])` | | |
| `sum by (instance, device) (...)` | | |
| `sum by (instance) (...)` | | |
| `sum(...)` | | |

### Preguntas de análisis

- ¿Qué información se pierde al eliminar `device`?
- ¿Qué consulta es adecuada para un panel por interfaz?
- ¿Qué consulta es adecuada para un panel global?
- ¿Qué consulta tiene menor cardinalidad?
- ¿Qué consulta sería más sencilla de representar?

## Sesión práctica 7: diagnosticar una variable vacía

### Objetivo

Resolver una variable de Grafana que no muestra valores.

### Situación inicial

La variable utiliza:

```promql
label_values(up, instancia)
```

Pero no devuelve resultados.

### Paso 1: comprobar la métrica

```promql
up
```

### Paso 2: revisar el nombre real de la etiqueta

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### Paso 3: consultar valores de `instance`

```bash
curl -s http://localhost:9090/api/v1/label/instance/values \
  | jq
```

### Paso 4: corregir la consulta

```promql
label_values(up, instance)
```

El problema era que la etiqueta correcta se llama `instance`, no `instancia`.

### Paso 5: comprobar filtros

Una consulta demasiado restrictiva también puede devolver cero resultados:

```promql
label_values(
  up{
    job="nombre-inexistente"
  },
  instance
)
```

Prueba con:

```promql
label_values(up, instance)
```

### Registro de diagnóstico

```text
Variable:

Consulta inicial:

Resultado inicial:

Comprobación realizada:

Nombre correcto de la etiqueta:

Consulta corregida:

Resultado final:

Causa del problema:
```

## Sesión práctica 8: diseñar un dashboard reutilizable

### Objetivo

Crear un dashboard con variables y paneles reutilizables.

### Variables

Crea estas variables:

```text
instance
job
device
mountpoint
```

### Panel de disponibilidad

```promql
up{
  instance=~"$instance",
  job=~"$job"
}
```

Leyenda:

```text
{{job}} - {{instance}}
```

### Panel de CPU

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        instance=~"$instance",
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Panel de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance=~"$instance"
  }
  /
  node_memory_MemTotal_bytes{
    instance=~"$instance"
  }
)
```

### Panel de almacenamiento

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint=~"$mountpoint",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Panel de red

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      instance=~"$instance",
      device=~"$device"
    }[$__rate_interval]
  )
)
```

### Lista de comprobación

Comprueba que:

- Las variables muestran valores.
- La selección de instancia funciona.
- La selección múltiple funciona.
- La opción **All** funciona.
- Los paneles actualizan sus datos.
- Las leyendas son comprensibles.
- Las unidades son correctas.
- No aparecen interfaces virtuales innecesarias.
- Los puntos de montaje son reconocibles.
- El dashboard funciona con más de una instancia.

## Buenas prácticas

- Utiliza nombres de etiquetas coherentes.
- Filtra por `instance` y `job` cuando existan varias fuentes.
- Utiliza `=~` para variables múltiples.
- Utiliza `=` para variables de selección única.
- Comprueba los valores reales de las etiquetas antes de crear una variable.
- No confundas `instance` con el nombre DNS del equipo.
- Recuerda que `instance` suele incluir el puerto.
- Conserva únicamente las etiquetas necesarias en las agregaciones.
- Evita crear etiquetas con valores que cambien continuamente.
- Controla la cardinalidad.
- Utiliza nombres descriptivos para las variables.
- Añade una etiqueta visible a cada variable.
- Define valores por defecto razonables.
- Comprueba el comportamiento de la opción **All**.
- Utiliza `$__rate_interval` para consultas `rate` en Grafana.
- Revisa las leyendas de los paneles.
- Documenta el significado de cada etiqueta.
- Valida las consultas directamente en Prometheus antes de utilizarlas en Grafana.

## Errores frecuentes

### Utilizar un nombre de etiqueta incorrecto

Incorrecto:

```promql
up{instancia="localhost:9100"}
```

Correcto:

```promql
up{instance="localhost:9100"}
```

### Omitir el puerto de `instance`

Incorrecto:

```promql
up{instance="localhost"}
```

Correcto, si ese es el valor real:

```promql
up{instance="localhost:9100"}
```

### Utilizar `=` con una variable múltiple

Incorrecto:

```promql
up{
  instance="$instance"
}
```

Correcto:

```promql
up{
  instance=~"$instance"
}
```

### Agregar eliminando demasiado contexto

Esta consulta muestra únicamente un valor global:

```promql
sum(
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

Si necesitas distinguir instancias:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

Si necesitas distinguir instancias e interfaces:

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### No filtrar interfaces virtuales

Una consulta de red puede incluir:

```text
lo
docker0
veth...
br-...
```

Utiliza:

```promql
device!~"lo|docker.*|veth.*|br-.*"
```

### No filtrar sistemas de archivos virtuales

Utiliza:

```promql
fstype!~"tmpfs|overlay|squashfs"
```

### Crear etiquetas de alta cardinalidad

Evita utilizar como etiquetas:

```text
request_id
session_id
timestamp
url_completa
```

Estas etiquetas pueden generar una cantidad excesiva de series.

## Tabla rápida de operadores de etiquetas

| Operador | Función | Ejemplo |
|---|---|---|
| `=` | Coincidencia exacta | `{job="node_exporter"}` |
| `!=` | Excluir valor exacto | `{device!="lo"}` |
| `=~` | Coincidencia regular | `{device=~"en.*"}` |
| `!~` | Excluir expresión regular | `{fstype!~"tmpfs|overlay"}` |

## Tabla rápida de etiquetas

| Etiqueta | Uso habitual | Ejemplo |
|---|---|---|
| `job` | Trabajo de scraping | `job="node_exporter"` |
| `instance` | Target concreto | `instance="localhost:9100"` |
| `device` | Interfaz o dispositivo | `device="ens33"` |
| `cpu` | Núcleo lógico | `cpu="0"` |
| `mode` | Modo de CPU | `mode="idle"` |
| `mountpoint` | Punto de montaje | `mountpoint="/"` |
| `fstype` | Tipo de sistema de archivos | `fstype="ext4"` |

## Tabla rápida de variables de Grafana

| Variable | Consulta habitual | Uso |
|---|---|---|
| `instance` | `label_values(up, instance)` | Seleccionar equipo |
| `job` | `label_values(up, job)` | Seleccionar trabajo |
| `device` | `label_values(node_network_receive_bytes_total, device)` | Seleccionar interfaz |
| `mountpoint` | `label_values(node_filesystem_size_bytes, mountpoint)` | Seleccionar punto de montaje |

## Puntos clave

- Una serie temporal está definida por una métrica y un conjunto de etiquetas.
- El nombre de la métrica identifica el tipo de información.
- Las etiquetas proporcionan contexto.
- `job` identifica el trabajo de scraping.
- `instance` identifica normalmente el target y su puerto.
- `device` suele identificar una interfaz o dispositivo.
- `mode` identifica el modo de CPU.
- `mountpoint` identifica un punto de montaje.
- `fstype` identifica el tipo de sistema de archivos.
- `=` realiza coincidencias exactas.
- `=~` permite expresiones regulares.
- Las variables múltiples de Grafana suelen requerir `=~`.
- `by` permite conservar determinadas etiquetas al agregar.
- Una cardinalidad elevada puede afectar al rendimiento.
- Las etiquetas deben ser estables, útiles y controladas.
- Las variables hacen que los dashboards sean reutilizables.
- `$__rate_interval` resulta útil en consultas `rate` dentro de Grafana.
- Antes de crear una variable, comprueba que la etiqueta y sus valores existan.
- Una consulta vacía puede deberse a un nombre incorrecto, un filtro demasiado restrictivo o la ausencia de datos.
- Las etiquetas de una métrica y las etiquetas de una alerta no son exactamente lo mismo.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre el nombre de una métrica y una etiqueta?
2. ¿Qué información suele representar la etiqueta `job`?
3. ¿Qué información suele representar la etiqueta `instance`?
4. ¿Por qué `localhost` y `localhost:9100` pueden ser valores diferentes de `instance`?
5. ¿Qué función cumple la etiqueta `device`?
6. ¿Qué función cumple la etiqueta `mode`?
7. ¿Qué diferencia existe entre `=` y `=~`?
8. ¿Qué operador utilizarías para excluir las interfaces `lo` y `docker0`?
9. ¿Qué operador debes utilizar normalmente con una variable múltiple de Grafana?
10. ¿Qué función cumple `sum by (instance)`?
11. ¿Qué información se pierde al utilizar `sum(...)` sin `by`?
12. ¿Qué es la cardinalidad?
13. ¿Por qué `request_id` puede ser una etiqueta problemática?
14. ¿Qué consulta utilizarías para conocer las instancias disponibles?
15. ¿Qué consulta utilizarías para conocer las interfaces de red?
16. ¿Por qué una variable de Grafana puede aparecer vacía?
17. ¿Qué diferencia existe entre una variable de selección única y una variable múltiple?
18. ¿Qué etiquetas conviene conservar en un panel de tráfico por interfaz?
19. ¿Qué etiquetas conviene conservar en un panel de tráfico total por instancia?
20. ¿Qué pasos seguirías para diagnosticar una consulta que no devuelve datos?