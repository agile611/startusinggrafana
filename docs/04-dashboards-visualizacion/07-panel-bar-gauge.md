# Panel Bar Gauge

El panel **Bar Gauge** de Grafana permite comparar visualmente varios valores mediante barras horizontales o verticales.

Es especialmente útil cuando una consulta devuelve varias series y se necesita identificar rápidamente:

- Qué servidor consume más CPU.
- Qué instancia utiliza más memoria.
- Qué sistema de ficheros está más lleno.
- Qué interfaz genera más tráfico.
- Qué servicio presenta una mayor latencia.
- Qué objetivos tienen valores diferentes.

Mientras que un panel Gauge suele centrarse en un valor individual, el Bar Gauge está diseñado para mostrar varios valores dentro de una misma visualización.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Bar Gauge.
- Diferenciar un Bar Gauge de un Gauge, Stat y Time series.
- Crear un panel Bar Gauge desde cero.
- Comparar varias series en un mismo panel.
- Utilizar consultas PromQL agrupadas por instancia.
- Configurar orientación horizontal o vertical.
- Configurar unidades, decimales y límites.
- Configurar umbrales y colores.
- Ordenar las barras.
- Mostrar etiquetas comprensibles.
- Filtrar interfaces y sistemas de ficheros.
- Comparar el uso de CPU entre instancias.
- Comparar el uso de memoria entre servidores.
- Comparar el espacio utilizado por punto de montaje.
- Diagnosticar un Bar Gauge sin datos.
- Identificar problemas provocados por demasiadas series.
- Integrar un Bar Gauge en un dashboard operativo.

---

# Introducción

El panel Bar Gauge transforma cada serie devuelta por una consulta en una barra.

El flujo general es:

```text
Métricas de Prometheus
        |
        v
Consulta PromQL
        |
        v
Varias series
        |
        v
Una barra por serie
        |
        v
Ordenación, unidades y umbrales
        |
        v
Panel Bar Gauge
```

Por ejemplo, una consulta de CPU puede devolver:

```text
instance="server-01:9100"  35.4
instance="server-02:9100"  78.2
instance="server-03:9100"  91.7
```

El Bar Gauge puede representarlo así:

```text
server-01:9100  ███████░░░░░░░░░░░░░░░░░░░ 35.4 %
server-02:9100  ███████████████░░░░░░░░░░░░ 78.2 %
server-03:9100  ██████████████████░░░░░░░░░ 91.7 %
```

Esta representación permite identificar rápidamente el valor más alto y el más bajo.

---

# Cuándo utilizar un Bar Gauge

El Bar Gauge es apropiado cuando:

- Se desean comparar varias series.
- Cada serie representa una instancia, interfaz o recurso.
- Existe un rango común para todos los valores.
- Se necesita identificar valores altos o bajos.
- La consulta devuelve una cantidad moderada de series.
- Los umbrales son aplicables a todas las series.

## Ejemplos adecuados

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

### Uso de sistemas de ficheros

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

### Tráfico recibido por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

---

# Cuándo no utilizar un Bar Gauge

No suele ser la mejor opción cuando se necesita:

- Analizar una tendencia temporal.
- Mostrar cientos de series.
- Consultar etiquetas detalladas.
- Representar una única métrica sin comparación.
- Mostrar una distribución estadística.
- Analizar picos ocurridos durante un periodo largo.

En esos casos pueden ser más adecuadas otras visualizaciones:

| Necesidad | Visualización recomendada |
|---|---|
| Un único valor | Stat |
| Un valor frente a un rango | Gauge |
| Evolución temporal | Time series |
| Muchas etiquetas y valores | Table |
| Distribución de valores | Heatmap |
| Documentación | Text |

---

# Diferencia entre Bar Gauge y Gauge

Ambos paneles utilizan barras o escalas, pero su propósito principal es diferente.

| Característica | Gauge | Bar Gauge |
|---|---|---|
| Valor individual | Muy adecuado | Posible |
| Comparación de varias series | Limitada | Muy adecuada |
| Vista resumida | Sí | Sí |
| Barra por valor | Normalmente una | Una por cada serie |
| CPU por servidor | Menos adecuado | Muy adecuado |
| Memoria de un servidor | Adecuado | Posible |
| Uso de disco por servidor | Limitado | Muy adecuado |
| Identificación del valor máximo | Menos directa | Muy clara |

## Ejemplo

Para mostrar la memoria de un único servidor:

```text
Gauge
```

Para comparar la memoria de varios servidores:

```text
Bar Gauge
```

---

# Diferencia entre Bar Gauge y Stat

El panel Stat resume una métrica en un valor principal.

El Bar Gauge conserva la comparación entre varias series.

## Stat

Consulta:

```promql
avg(
  100 - (
    rate(node_cpu_seconds_total{mode="idle"}[5m]) * 100
  )
)
```

Resultado:

```text
62.4 %
```

Pregunta que responde:

```text
¿Cuál es el uso medio de CPU?
```

## Bar Gauge

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Resultado:

```text
server-01:9100  35.4 %
server-02:9100  78.2 %
server-03:9100  91.7 %
```

Pregunta que responde:

```text
¿Qué servidor consume más CPU?
```

---

# Diferencia entre Bar Gauge y Time series

El Bar Gauge muestra una comparación actual o reducida.

El Time series muestra la evolución temporal.

## Bar Gauge

```text
server-01  35 %
server-02  78 %
server-03  91 %
```

Útil para:

```text
Comparar el estado actual de varios servidores.
```

## Time series

```text
Uso de CPU de cada servidor durante la última hora.
```

Útil para:

```text
Analizar cuándo aumentó o disminuyó la CPU.
```

Una combinación habitual es:

```text
Bar Gauge: comparación actual
Time series: evolución histórica
```

---

# Anatomía de un panel Bar Gauge

Un Bar Gauge puede tener una estructura similar a esta:

```text
+------------------------------------------------------+
| Uso de CPU por instancia                             |
+------------------------------------------------------+
| server-03:9100  ████████████████████░░░░  91.7 %     |
| server-02:9100  ████████████████░░░░░░░░  78.2 %     |
| server-01:9100  ███████░░░░░░░░░░░░░░░░░░ 35.4 %     |
+------------------------------------------------------+
```

## Serie

Cada barra corresponde a una serie devuelta por la consulta.

Ejemplos:

- Una instancia.
- Una interfaz.
- Un punto de montaje.
- Un job.
- Un servicio.

## Nombre de la serie

Debe permitir identificar el elemento representado.

Ejemplo:

```text
server-01:9100
```

## Valor

Es el resultado actual o reducido de la serie.

Ejemplo:

```text
78.2 %
```

## Unidad

Aclara cómo debe interpretarse el valor.

Ejemplos:

```text
Percent (0-100)
bytes/sec
Bytes (IEC)
Celsius
```

## Escala

Define el rango común de las barras.

Para porcentajes:

```text
Mínimo: 0
Máximo: 100
```

## Umbrales

Permiten utilizar colores según el valor.

Ejemplo:

```text
0      Verde
70     Amarillo
90     Rojo
```

## Orden

Las barras pueden ordenarse:

- Ascendente.
- Descendente.
- Por nombre.
- Por valor actual.
- Por valor máximo.
- Por valor mínimo.

Para localizar rápidamente el recurso más utilizado, el orden descendente suele ser útil.

---

# Crear un panel Bar Gauge

## Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir una consulta que devuelva varias series.
6. Seleccionar la visualización `Bar Gauge`.
7. Configurar la orientación.
8. Configurar la unidad.
9. Configurar el mínimo y el máximo.
10. Configurar los umbrales.
11. Configurar el orden.
12. Configurar los nombres de las series.
13. Revisar el resultado.
14. Guardar el panel.
15. Guardar el dashboard.

## Consulta inicial recomendada

Para comparar CPU por instancia:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración recomendada:

```text
Título: Uso de CPU por instancia
Visualización: Bar Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Orden: Descendente por valor
```

---

# Consultas PromQL para Bar Gauge

## Uso de CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Cada barra representa una instancia.

## Uso de CPU por job

```promql
100 - (
  avg by (job) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Cada barra representa un job.

## Memoria utilizada por instancia

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Si existe más de una instancia, Grafana puede mostrar una barra por instancia.

## Memoria disponible por instancia

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

## Uso del sistema de ficheros por punto de montaje

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

## Uso del sistema de ficheros raíz por instancia

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

## Tráfico recibido por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Tráfico enviado por instancia

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

## Tráfico recibido por interfaz

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Carga media por instancia

```promql
avg by (instance) (
  node_load1
)
```

---

# Agrupaciones en PromQL

La agrupación determina qué representa cada barra.

## Agrupar por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total[5m])
)
```

Resultado conceptual:

```text
instance="server-01:9100"
instance="server-02:9100"
```

## Agrupar por interfaz

```promql
sum by (device) (
  rate(node_network_receive_bytes_total[5m])
)
```

Resultado conceptual:

```text
device="eth0"
device="ens18"
device="wlan0"
```

## Agrupar por job

```promql
sum by (job) (
  up
)
```

Resultado conceptual:

```text
job="prometheus"
job="node_exporter"
```

## Agrupar por instancia y punto de montaje

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

Si se desea controlar explícitamente la agregación:

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

# Configurar orientación

El Bar Gauge puede utilizar diferentes orientaciones según el diseño del dashboard.

## Orientación horizontal

Es adecuada cuando:

- Los nombres de las series son largos.
- Se desea mostrar el nombre a la izquierda.
- El panel ocupa un espacio ancho.
- Se comparan servidores.

Ejemplo:

```text
server-01:9100  ████████████░░░░░░░░  55 %
server-02:9100  █████████████████░░░  82 %
```

## Orientación vertical

Es adecuada cuando:

- El panel es estrecho y alto.
- Los nombres son cortos.
- Se desea crear una fila de indicadores.
- Se comparan pocas series.

Ejemplo conceptual:

```text
  90 %     70 %     40 %
   |        |        |
  ███      ███      ███
 server1  server2  server3
```

## Recomendación

Utilizar orientación horizontal cuando los nombres de las instancias, interfaces o puntos de montaje sean largos.

---

# Configurar unidades

## CPU por instancia

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Unidad:

```text
Percent (0-100)
```

## Memoria por instancia

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Unidad:

```text
Percent (0-100)
```

## Almacenamiento

Consulta:

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

Unidad:

```text
Percent (0-100)
```

## Tráfico de red

Consulta:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Unidad:

```text
bytes/sec
```

## Memoria disponible en bytes

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Unidad:

```text
Bytes (IEC)
```

## Temperatura

Consulta:

```promql
node_hwmon_temp_celsius
```

Unidad:

```text
Celsius
```

---

# Configurar límites

Los límites deben ser compatibles con la consulta.

## Porcentajes

```text
Mínimo: 0
Máximo: 100
```

Aplicable a:

- CPU.
- Memoria.
- Almacenamiento.
- Disponibilidad.
- Porcentaje de errores.

## Tráfico de red

Para tráfico de red, puede ser preferible utilizar:

```text
Mínimo: 0
Máximo: Automático
```

o establecer un máximo conocido según el enlace.

## Carga del sistema

La carga no debe configurarse automáticamente como porcentaje.

Utilizar:

```text
Unidad: None
Mínimo: 0
Máximo: Automático
```

---

# Configurar umbrales

## CPU por servidor

```text
0      Verde
70     Amarillo
90     Rojo
```

## Memoria por servidor

```text
0      Verde
70     Amarillo
90     Rojo
```

## Almacenamiento por punto de montaje

```text
0      Verde
80     Amarillo
90     Rojo
```

## Tráfico de red

Los umbrales de tráfico dependen de:

- Capacidad del enlace.
- Tipo de interfaz.
- Ancho de banda contratado.
- Tráfico normal.
- Horario.
- Aplicación.
- Entorno.

No es recomendable utilizar automáticamente los mismos umbrales que para CPU y memoria.

## Disponibilidad

```text
0      Rojo
90     Amarillo
99     Verde
```

---

# Ordenar las barras

El orden debe facilitar la interpretación.

## Orden descendente por valor

Adecuado para detectar los valores más altos:

```text
server-03  91.7 %
server-02  78.2 %
server-01  35.4 %
```

## Orden ascendente por valor

Adecuado para detectar los valores más bajos:

```text
server-01  35.4 %
server-02  78.2 %
server-03  91.7 %
```

## Orden alfabético

Adecuado cuando se necesita localizar una instancia concreta:

```text
server-01
server-02
server-03
```

## Recomendación

Para dashboards operativos, el orden descendente suele ser el más útil cuando se monitorizan consumos.

---

# Configurar nombres de series

Una consulta puede generar nombres largos.

Ejemplo:

```text
{device="eth0", instance="server-01:9100", job="node_exporter"}
```

Puede ser más legible mostrar solo:

```text
eth0
```

o:

```text
server-01
```

## Nombres por instancia

Consulta agrupada:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Nombre recomendado:

```text
{{instance}}
```

## Nombres por interfaz

Consulta:

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Nombre recomendado:

```text
{{device}}
```

## Nombres por punto de montaje

Consulta:

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

Nombre recomendado:

```text
{{instance}} - {{mountpoint}}
```

---

# Controlar demasiadas series

Un Bar Gauge funciona mejor con un número moderado de barras.

Si la consulta devuelve demasiadas series, aplicar filtros o agregaciones.

## Filtrar una instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance="localhost:9100"
    }[5m])
  ) * 100
)
```

## Filtrar interfaces

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device=~"eth0|ens18"
  }[5m])
)
```

## Excluir interfaces

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo",
    device!~"docker.*|veth.*"
  }[5m])
)
```

## Mostrar los cinco valores más altos

PromQL permite utilizar:

```promql
topk(
  5,
  100 - (
    avg by (instance) (
      rate(node_cpu_seconds_total{mode="idle"}[5m])
    ) * 100
  )
)
```

## Mostrar los cinco valores más bajos

```promql
bottomk(
  5,
  100 - (
    avg by (instance) (
      rate(node_cpu_seconds_total{mode="idle"}[5m])
    ) * 100
  )
)
```

---

# Ejemplo completo 1: CPU por instancia

## Objetivo

Comparar el porcentaje de CPU utilizado por varias instancias.

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Configuración

```text
Título: Uso de CPU por instancia
Visualización: Bar Gauge
Orientación: Horizontal
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Orden: Descendente por valor
```

## Umbrales

```text
0      Verde
70     Amarillo
90     Rojo
```

## Descripción

```text
Porcentaje medio de CPU utilizada por instancia durante los últimos cinco minutos.
Las barras se ordenan de mayor a menor consumo.
```

---

# Ejemplo completo 2: memoria por instancia

## Objetivo

Comparar el porcentaje de memoria utilizada en varios servidores.

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Configuración

```text
Título: Uso de memoria por instancia
Visualización: Bar Gauge
Orientación: Horizontal
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Orden: Descendente por valor
```

## Umbrales

```text
0      Verde
70     Amarillo
90     Rojo
```

## Descripción

```text
Porcentaje de memoria utilizada por cada instancia monitorizada.
```

---

# Ejemplo completo 3: almacenamiento por punto de montaje

## Objetivo

Identificar los sistemas de ficheros con mayor ocupación.

## Consulta

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

## Configuración

```text
Título: Uso de almacenamiento
Visualización: Bar Gauge
Orientación: Horizontal
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Orden: Descendente por valor
```

## Nombres

```text
{{instance}} - {{mountpoint}}
```

## Umbrales

```text
0      Verde
80     Amarillo
90     Rojo
```

## Descripción

```text
Porcentaje de espacio utilizado por punto de montaje.
Se excluyen los sistemas tmpfs y overlay.
```

---

# Ejemplo completo 4: tráfico recibido por interfaz

## Objetivo

Comparar el tráfico recibido por las interfaces de red.

## Consulta

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Configuración

```text
Título: Tráfico recibido por interfaz
Visualización: Bar Gauge
Orientación: Horizontal
Unidad: bytes/sec
Mínimo: 0
Máximo: Automático
Decimales: 1
Orden: Descendente por valor
```

## Nombres

```text
{{device}}
```

## Descripción

```text
Velocidad media de recepción por interfaz durante los últimos cinco minutos.
La interfaz de loopback se excluye.
```

---

# Ejemplo de sesión 1: crear un Bar Gauge de CPU

## Objetivo

Comparar el uso de CPU de las instancias monitorizadas.

## Pasos

1. Acceder a Grafana:

```text
http://localhost:3000
```

2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

6. Seleccionar la visualización `Bar Gauge`.
7. Configurar:

```text
Título: Uso de CPU por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Orientación: Horizontal
```

8. Configurar los umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

9. Ordenar de mayor a menor.
10. Guardar el panel.
11. Guardar el dashboard.

## Actividades

1. Identifica la instancia con mayor uso.
2. Identifica la instancia con menor uso.
3. Comprueba los colores.
4. Cambia el orden a ascendente.
5. Vuelve a ordenar de forma descendente.
6. Añade una descripción.
7. Guarda una captura.

---

# Ejemplo de sesión 2: crear un Bar Gauge de memoria

## Objetivo

Comparar la memoria utilizada en las instancias.

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Pasos

1. Crear un panel Bar Gauge.
2. Introducir la consulta.
3. Configurar:

```text
Título: Uso de memoria por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Orientación: Horizontal
```

4. Configurar:

```text
0      Verde
70     Amarillo
90     Rojo
```

5. Ordenar de mayor a menor.
6. Guardar el panel.

## Actividades

1. Identifica la instancia con más memoria utilizada.
2. Compara el resultado con `free -h`.
3. Comprueba si todas las instancias tienen la misma cantidad de memoria.
4. Explica si una comparación basada únicamente en porcentajes puede ocultar diferencias de capacidad.
5. Añade un segundo panel con memoria disponible en bytes.

---

# Ejemplo de sesión 3: crear un Bar Gauge de almacenamiento

## Objetivo

Identificar los sistemas de ficheros más llenos.

## Consulta

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

## Pasos

1. Crear un panel Bar Gauge.
2. Introducir la consulta.
3. Seleccionar orientación horizontal.
4. Configurar:

```text
Título: Uso de almacenamiento por punto de montaje
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

5. Configurar los umbrales:

```text
0      Verde
80     Amarillo
90     Rojo
```

6. Configurar el nombre:

```text
{{instance}} - {{mountpoint}}
```

7. Ordenar de mayor a menor.
8. Guardar el panel.

## Actividades

1. Identifica los sistemas de ficheros con mayor uso.
2. Comprueba el sistema raíz con:

```bash
df -h /
```

3. Explica por qué se excluyen `tmpfs` y `overlay`.
4. Filtra únicamente el punto de montaje `/`.
5. Compara el resultado antes y después del filtro.

---

# Ejemplo de sesión 4: crear un Bar Gauge de red

## Objetivo

Comparar el tráfico recibido por las interfaces de red.

## Consulta

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Configuración

```text
Título: Tráfico recibido por interfaz
Unidad: bytes/sec
Mínimo: 0
Máximo: Automático
Decimales: 1
Orientación: Horizontal
Orden: Descendente por valor
```

## Actividades

1. Crea el panel.
2. Identifica la interfaz con mayor tráfico.
3. Excluye interfaces virtuales:

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo",
    device!~"docker.*|veth.*"
  }[5m])
)
```

4. Compara ambos resultados.
5. Consulta las estadísticas del sistema:

```bash
ip -s link
```

6. Explica por qué `rate()` es necesario.

---

# Ejemplo de sesión 5: comparar orientación horizontal y vertical

## Objetivo

Determinar qué orientación facilita más la lectura.

## Pasos

1. Crear un Bar Gauge de CPU por instancia.
2. Utilizar orientación horizontal.
3. Guardar una captura.
4. Cambiar a orientación vertical.
5. Guardar otra captura.
6. Comparar ambos resultados.

## Actividades

Responder:

1. ¿Qué orientación muestra mejor los nombres largos?
2. ¿Cuál aprovecha mejor un panel ancho?
3. ¿Cuál es más útil para pocas series?
4. ¿Cuál elegirías para las interfaces de red?
5. ¿Cuál elegirías para servidores con nombres largos?

---

# Ejemplo de sesión 6: mostrar los cinco servidores con más CPU

## Objetivo

Reducir el número de barras y destacar los valores más altos.

## Consulta

```promql
topk(
  5,
  100 - (
    avg by (instance) (
      rate(node_cpu_seconds_total{mode="idle"}[5m])
    ) * 100
  )
)
```

## Configuración

```text
Título: Cinco instancias con mayor uso de CPU
Visualización: Bar Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Orden: Descendente por valor
```

## Actividades

1. Ejecuta la consulta.
2. Comprueba cuántas barras aparecen.
3. Compara con la consulta sin `topk()`.
4. Explica cuándo es útil limitar el número de resultados.
5. Cambia el valor de `5` a `3`.
6. Observa el resultado.

---

# Ejemplo de sesión 7: diagnosticar demasiadas barras

## Objetivo

Identificar una consulta que devuelve demasiadas series.

## Consulta inicial

```promql
node_network_receive_bytes_total
```

Esta consulta puede devolver muchas series porque incluye:

- Instancia.
- Interfaz.
- Tipo de métrica.
- Otras etiquetas.

## Consulta mejorada

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Actividades

1. Ejecuta la primera consulta.
2. Observa el número de barras.
3. Ejecuta la consulta agrupada.
4. Compara la legibilidad.
5. Explica qué información se ha conservado.
6. Explica qué información se ha agregado.
7. Utiliza el inspector del panel.

---

# Ejemplo de sesión 8: diagnosticar un Bar Gauge sin datos

## Objetivo

Diferenciar un problema de visualización de un problema de consulta.

## Consulta incorrecta

```promql
metrica_que_no_existe
```

## Pasos

1. Crear un panel Bar Gauge.
2. Introducir la consulta incorrecta.
3. Observar el resultado.
4. Abrir el inspector.
5. Revisar la respuesta.
6. Probar:

```promql
up
```

7. Probar una consulta de varias series:

```promql
node_load1
```

8. Restaurar la consulta de CPU.

## Actividades

Documentar:

- Consulta utilizada.
- Resultado observado.
- Mensaje de error.
- Diagnóstico.
- Solución aplicada.

---

# Ejemplo de sesión 9: utilizar una variable de instancia

## Objetivo

Permitir que el usuario seleccione la instancia que desea analizar.

## Crear la variable

Crear una variable de dashboard llamada:

```text
instance
```

Consulta de variable:

```promql
label_values(up, instance)
```

La sintaxis disponible puede variar según la versión y el editor de variables utilizado.

## Consulta del panel

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

## Configuración

```text
Título: Uso de CPU de la instancia seleccionada
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

## Actividades

1. Crea la variable.
2. Comprueba las instancias disponibles.
3. Crea el Bar Gauge.
4. Selecciona una instancia.
5. Selecciona varias instancias.
6. Comprueba la opción `All`.
7. Documenta el comportamiento.

---

# Ejemplo de sesión 10: verificar resultados mediante la API

## Objetivo

Comparar los valores mostrados en Grafana con la API de Prometheus.

## Consultar CPU por instancia

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode '
    query=100 - (
      avg by (instance) (
        rate(node_cpu_seconds_total{mode="idle"}[5m])
      ) * 100
    )
  ' \
  | jq
```

## Consultar memoria por instancia

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode '
    query=100 * (
      1 -
      node_memory_MemAvailable_bytes
      /
      node_memory_MemTotal_bytes
    )
  ' \
  | jq
```

## Mostrar nombres y valores

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode '
    query=100 - (
      avg by (instance) (
        rate(node_cpu_seconds_total{mode="idle"}[5m])
      ) * 100
    )
  ' \
  | jq -r '
    .data.result[]
    | [
        .metric.instance,
        .value[1]
      ]
    | @tsv
  '
```

## Actividades

1. Ejecuta la consulta desde la terminal.
2. Ejecuta la misma consulta en Grafana.
3. Compara los valores.
4. Explica posibles diferencias temporales.
5. Guarda el resultado como evidencia.

---

# Buenas prácticas

## Utilizar una agrupación clara

La consulta debe agrupar los datos según la comparación que se desea realizar.

Ejemplos:

```promql
sum by (instance) (...)
```

```promql
sum by (device) (...)
```

```promql
max by (instance, mountpoint) (...)
```

## Limitar el número de series

Un Bar Gauge con demasiadas barras es difícil de leer.

Utilizar:

```promql
topk(5, ...)
```

o filtros por etiquetas.

## Ordenar de forma útil

Para identificar problemas, ordenar de mayor a menor.

## Utilizar nombres cortos y claros

Mostrar:

```text
server-01
```

en lugar de:

```text
{instance="server-01:9100",job="node_exporter"}
```

## Mantener una escala común

Cuando se comparan barras, todas deben utilizar una escala coherente.

Para porcentajes:

```text
0 - 100
```

## No comparar métricas incompatibles

No colocar en el mismo Bar Gauge:

- Porcentajes.
- Bytes por segundo.
- Segundos.
- Temperaturas.

Cada panel debe utilizar valores comparables.

## Documentar la consulta

La descripción debe indicar:

- Qué representa cada barra.
- Cómo se agrupan las series.
- Qué unidad se utiliza.
- Qué periodo calcula `rate()`.
- Qué interfaces o sistemas se excluyen.

## Combinar con otras visualizaciones

Una distribución eficaz puede ser:

```text
Bar Gauge: comparación actual
Time series: evolución temporal
Table: etiquetas y detalle
```

---

# Problemas habituales

## El Bar Gauge no muestra datos

Comprobar:

```promql
up
```

Después:

```promql
node_load1
```

Revisar:

- Fuente de datos.
- Consulta.
- Rango temporal.
- Estado de los objetivos.
- Etiquetas.
- Variables.
- Inspector.

## Solo aparece una barra

Posibles causas:

- La consulta agrega todas las series.
- Solo existe una instancia.
- Se ha utilizado `sum()` sin `by`.
- Se ha filtrado una única instancia.
- La fuente de datos solo contiene un objetivo.

Ejemplo que produce un único valor:

```promql
sum(
  rate(node_network_receive_bytes_total[5m])
)
```

Ejemplo que conserva una barra por instancia:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total[5m])
)
```

## Aparecen demasiadas barras

Aplicar:

- Filtros.
- Agregaciones.
- `topk()`.
- Exclusiones de interfaces.
- Exclusiones de sistemas de ficheros.
- Variables.

## Las barras tienen nombres ilegibles

Configurar:

- Alias.
- Nombres basados en etiquetas.
- Transformaciones.
- Campos visibles.
- Agrupaciones más claras.

## Todas las barras aparecen con el mismo color

Revisar:

- Umbrales.
- Modo de color.
- Escala.
- Valores devueltos.
- Tipo de unidad.

## Las barras tienen escalas incorrectas

Comprobar:

- Unidad.
- Mínimo.
- Máximo.
- Si la consulta devuelve `0 - 1` o `0 - 100`.
- Si se ha aplicado una transformación.

## El orden no es útil

Cambiar el orden:

```text
Descendente por valor
Ascendente por valor
Alfabético
```

Para incidencias, normalmente es útil mostrar primero los valores más altos.

## El tráfico aparece como cero

Posibles causas:

- No hay tráfico durante el periodo.
- El rango temporal es demasiado corto.
- La interfaz está inactiva.
- Se ha excluido la interfaz utilizada.
- La consulta utiliza una etiqueta incorrecta.
- No se ha aplicado `rate()` a un contador.

Comprobar:

```bash
ip -s link
```

## El uso de disco aparece duplicado

Puede haber varias series para el mismo punto de montaje debido a etiquetas adicionales.

Utilizar una agregación controlada:

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

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-bar-gauge
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-bar-gauge/consultas-promql.txt <<'EOF'
CPU por instancia:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria por instancia:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Almacenamiento por punto de montaje:
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

Tráfico recibido por interfaz:
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)

Cinco instancias con mayor CPU:
topk(
  5,
  100 - (
    avg by (instance) (
      rate(node_cpu_seconds_total{mode="idle"}[5m])
    ) * 100
  )
)
EOF
```

Guardar el resultado de CPU por instancia:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode '
    query=100 - (
      avg by (instance) (
        rate(node_cpu_seconds_total{mode="idle"}[5m])
      ) * 100
    )
  ' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-bar-gauge/cpu-por-instancia.json
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-bar-gauge/informe.txt <<'EOF'
Práctica: Panel Bar Gauge

Dashboard utilizado:

Paneles creados:

Métricas comparadas:

Agrupaciones utilizadas:

Orientación utilizada:

Unidades configuradas:

Mínimos y máximos:

Umbrales configurados:

Orden utilizado:

Filtros aplicados:

Prueba con topk:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-bar-gauge-cpu.png
02-bar-gauge-memoria.png
03-bar-gauge-almacenamiento.png
04-bar-gauge-red.png
05-bar-gauge-orientacion-horizontal.png
06-bar-gauge-orientacion-vertical.png
07-bar-gauge-topk.png
08-bar-gauge-demasiadas-series.png
09-bar-gauge-dashboard-final.png
```

---

# Práctica integradora

## Objetivo

Crear un dashboard que compare los recursos utilizados por varias instancias.

## Panel 1: CPU por instancia

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración:

```text
Título: Uso de CPU por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Orden: Descendente por valor
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

## Panel 2: memoria por instancia

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración:

```text
Título: Uso de memoria por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Orden: Descendente por valor
```

## Panel 3: almacenamiento

Consulta:

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

Configuración:

```text
Título: Uso de almacenamiento
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Orden: Descendente por valor
```

## Panel 4: tráfico recibido

Consulta:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Configuración:

```text
Título: Tráfico recibido por instancia
Unidad: bytes/sec
Mínimo: 0
Máximo: Automático
Orden: Descendente por valor
```

## Distribución propuesta

```text
+------------------------------------------------------+
| Uso de CPU por instancia                             |
+------------------------------------------------------+
| Uso de memoria por instancia                        |
+------------------------------------------------------+
| Uso de almacenamiento                                |
+------------------------------------------------------+
| Tráfico recibido por instancia                       |
+------------------------------------------------------+
```

## Tareas

1. Crear los cuatro paneles.
2. Utilizar Bar Gauge en todos ellos.
3. Configurar las unidades.
4. Configurar los límites.
5. Configurar los umbrales.
6. Ordenar las barras de mayor a menor.
7. Configurar nombres comprensibles.
8. Excluir interfaces irrelevantes.
9. Excluir sistemas de ficheros virtuales.
10. Comparar los resultados con el sistema operativo.
11. Crear una consulta `topk()` para CPU.
12. Diagnosticar una consulta con demasiadas series.
13. Utilizar el inspector.
14. Guardar capturas.
15. Exportar el dashboard.
16. Completar el informe.

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Bar Gauge de CPU creado | | |
| Bar Gauge de memoria creado | | |
| Bar Gauge de almacenamiento creado | | |
| Bar Gauge de red creado | | |
| Consulta agrupada correctamente | | |
| Orientación configurada | | |
| Unidad configurada | | |
| Mínimo configurado | | |
| Máximo configurado | | |
| Umbrales configurados | | |
| Orden descendente configurado | | |
| Nombres de series corregidos | | |
| Interfaces filtradas | | |
| Sistemas virtuales excluidos | | |
| Consulta `topk()` realizada | | |
| Consulta con demasiadas series diagnosticada | | |
| Inspector utilizado | | |
| Dashboard exportado | | |
| Evidencias guardadas | | |

---

# Puntos clave

- El panel Bar Gauge permite comparar varias series mediante barras.
- Cada barra representa una serie devuelta por la consulta.
- La agrupación PromQL determina qué representa cada barra.
- `sum by (instance)` conserva una barra por instancia.
- `sum by (device)` conserva una barra por interfaz.
- El Bar Gauge es especialmente útil para comparar recursos.
- La orientación horizontal facilita la lectura de nombres largos.
- Los porcentajes suelen utilizar una escala de `0` a `100`.
- Las unidades deben coincidir con el resultado de la consulta.
- Los umbrales deben adaptarse a la métrica.
- El orden descendente ayuda a localizar los valores más altos.
- `topk()` permite mostrar únicamente los valores principales.
- Demasiadas series reducen la legibilidad.
- Los filtros y las agregaciones ayudan a controlar el número de barras.
- Los nombres de las series deben ser breves y comprensibles.
- `rate()` es necesario para calcular velocidades a partir de contadores.
- Un Bar Gauge muestra principalmente una comparación actual o reducida.
- Un Time series es más adecuado para analizar tendencias.
- Un Gauge es más apropiado para un valor individual.
- La documentación de la consulta y los filtros facilita el mantenimiento.

---

# Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Bar Gauge?
2. ¿Qué diferencia existe entre un Bar Gauge y un Gauge?
3. ¿Qué diferencia existe entre un Bar Gauge y un Stat?
4. ¿Qué diferencia existe entre un Bar Gauge y un Time series?
5. ¿Qué representa cada barra?
6. ¿Qué función cumple `sum by (instance)`?
7. ¿Qué función cumple `sum by (device)`?
8. ¿Qué consulta utilizarías para comparar el uso de CPU por instancia?
9. ¿Qué consulta utilizarías para comparar el tráfico recibido por interfaz?
10. ¿Por qué se utiliza `rate()` con las métricas de red?
11. ¿Qué orientación elegirías para nombres de servidor largos?
12. ¿Qué escala utilizarías para porcentajes?
13. ¿Qué problemas puede producir una consulta con demasiadas series?
14. ¿Cómo reducirías el número de barras?
15. ¿Qué función cumple `topk()`?
16. ¿Qué filtros aplicarías a las interfaces de red?
17. ¿Por qué se excluyen habitualmente `tmpfs` y `overlay`?
18. ¿Qué revisarías si solo aparece una barra?
19. ¿Qué revisarías si aparecen demasiadas barras?
20. ¿Qué revisarías si el Bar Gauge no muestra datos?
21. ¿Cómo configurarías los nombres de las series?
22. ¿Por qué es importante ordenar las barras?
23. ¿Qué unidad utilizarías para el tráfico de red?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener un Bar Gauge bien diseñado?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear comparaciones visuales entre varias series.

El proceso completo será:

```text
Seleccionar una métrica
        |
        v
Identificar la dimensión de comparación
        |
        v
Agrupar las series con PromQL
        |
        v
Seleccionar Bar Gauge
        |
        v
Configurar nombres y orientación
        |
        v
Configurar unidad y escala
        |
        v
Configurar umbrales
        |
        v
Ordenar y filtrar resultados
        |
        v
Probar valores normales y extremos
        |
        v
Guardar y documentar
```

El resultado final debe ser un panel Bar Gauge capaz de mostrar, de forma clara y ordenada, qué instancia, interfaz o recurso presenta el valor más alto, más bajo o más próximo a un límite.