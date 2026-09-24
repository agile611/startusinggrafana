# Panel Time series

El panel **Time series** de Grafana permite representar la evolución de una o varias métricas a lo largo del tiempo.

Es una de las visualizaciones más utilizadas en monitorización porque permite identificar:

- Tendencias.
- Picos de consumo.
- Caídas repentinas.
- Periodos de inactividad.
- Comparaciones entre instancias.
- Cambios antes y después de una incidencia.
- Comportamientos repetitivos.
- Evolución de los recursos durante un intervalo.

A diferencia de un panel Stat o Gauge, que suelen centrarse en el valor actual, un panel Time series muestra cómo ha cambiado el valor durante un periodo determinado.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Time series.
- Diferenciar un Time series de un Stat, Gauge y Bar Gauge.
- Crear un panel Time series desde cero.
- Representar métricas de Prometheus a lo largo del tiempo.
- Configurar el rango temporal del panel.
- Configurar el intervalo de refresco.
- Representar una o varias series.
- Configurar líneas, puntos y áreas.
- Configurar ejes y unidades.
- Configurar escalas lineales y logarítmicas.
- Configurar leyendas.
- Configurar colores por serie.
- Utilizar consultas PromQL con `rate()`.
- Representar CPU, memoria, disco y red.
- Comparar varias instancias.
- Utilizar agregaciones y filtros.
- Interpretar huecos y valores ausentes.
- Identificar problemas de resolución temporal.
- Diagnosticar un panel sin datos.
- Crear dashboards útiles para analizar tendencias.
- Documentar las consultas y opciones utilizadas.

---

## Introducción

Un panel Time series representa valores asociados a instantes temporales.

El flujo general es:

```text
Métricas de Prometheus
        |
        v
Consulta PromQL
        |
        v
Muestras temporales
        |
        v
Eje temporal
        |
        v
Líneas, puntos o áreas
        |
        v
Panel Time series
```

Ejemplo de una métrica de carga:

```promql
node_load1
```

Prometheus puede devolver muestras como:

```text
2026-09-24 17:00:00    0.42
2026-09-24 17:01:00    0.51
2026-09-24 17:02:00    0.87
2026-09-24 17:03:00    0.63
```

Grafana representa esos valores mediante una línea:

```text
Carga
 1.0 |                 ╭╮
 0.8 |          ╭──────╯╰╮
 0.6 |     ╭────╯        ╰─
 0.4 |─────╯
 0.2 |
     +----------------------------> Tiempo
```

El panel Time series permite responder preguntas como:

```text
¿Cuándo aumentó la CPU?
¿La memoria está creciendo?
¿El tráfico se ha mantenido estable?
¿Cuándo comenzó la incidencia?
¿La disponibilidad se recuperó?
```

---

## Cuándo utilizar un panel Time series

El panel Time series es apropiado cuando se necesita:

- Analizar una evolución temporal.
- Comparar una métrica entre varios servidores.
- Detectar picos y valles.
- Observar el efecto de una acción.
- Identificar una tendencia gradual.
- Analizar una incidencia.
- Comparar periodos.
- Mostrar datos de contadores mediante `rate()`.

### Ejemplos adecuados

#### Uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

#### Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

#### Carga del sistema

```promql
node_load1
```

#### Tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

#### Espacio utilizado

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

---

## Cuándo no utilizar un panel Time series

No suele ser la mejor opción cuando se necesita:

- Mostrar únicamente un valor actual.
- Crear una tarjeta de resumen.
- Comparar muchos valores en una lista.
- Mostrar el estado textual de un servicio.
- Representar una única capacidad mediante un indicador.
- Consultar etiquetas y valores detallados.

En esos casos pueden ser más adecuadas otras visualizaciones:

| Necesidad | Visualización recomendada |
|---|---|
| Valor actual | Stat |
| Valor frente a límites | Gauge |
| Comparación de valores actuales | Bar Gauge |
| Datos con etiquetas | Table |
| Distribución de valores | Heatmap |
| Texto explicativo | Text |

Una combinación habitual en un dashboard es:

```text
Stat: valor actual
Time series: evolución temporal
Table: detalle por instancia
```

---

## Diferencia entre Time series y Stat

El panel Stat muestra principalmente el valor actual o reducido.

El panel Time series muestra cómo varía el valor.

### Stat

Consulta:

```promql
node_load1
```

Resultado:

```text
0.42
```

Pregunta que responde:

```text
¿Cuál es la carga actual?
```

### Time series

Consulta:

```promql
node_load1
```

Pregunta que responde:

```text
¿Cómo ha evolucionado la carga durante la última hora?
```

Ambos paneles pueden utilizar la misma consulta, pero ofrecen información diferente.

---

## Diferencia entre Time series y Gauge

El Gauge muestra un valor dentro de un rango.

El Time series muestra la evolución temporal.

### Gauge

Adecuado para:

```text
Uso actual de memoria: 73 %
```

### Time series

Adecuado para:

```text
Uso de memoria durante las últimas 24 horas
```

El Gauge permite interpretar rápidamente el estado actual.

El Time series permite estudiar la tendencia y localizar cuándo se produjeron los cambios.

---

## Diferencia entre Time series y Bar Gauge

El Bar Gauge compara valores actuales o reducidos.

El Time series muestra el comportamiento de esos valores a lo largo del tiempo.

### Bar Gauge

```text
server-01  35 %
server-02  78 %
server-03  91 %
```

### Time series

```text
Uso de CPU de server-01, server-02 y server-03 durante la última hora
```

Una visualización no sustituye necesariamente a la otra. En dashboards operativos pueden utilizarse juntas.

---

## Anatomía de un panel Time series

Un panel Time series contiene normalmente:

```text
+------------------------------------------------------+
| Uso de CPU por instancia                             |
|                                                      |
| 100 |                         ╭──╮                  |
|  80 |              ╭──────────╯  ╰─╮               |
|  60 |──────╭───────╯                ╰────           |
|  40 |      ╰────────────────────────────           |
|   0 +------------------------------------------     |
|       17:00       17:15       17:30       17:45     |
|                                                      |
| server-01    server-02    server-03                 |
+------------------------------------------------------+
```

### Eje temporal

Muestra el periodo representado.

Ejemplos:

```text
Últimos 15 minutos
Última hora
Últimas 6 horas
Últimas 24 horas
Últimos 7 días
```

### Eje vertical

Muestra los valores de la métrica.

Ejemplos:

```text
0 - 100 %
0 - 10 GiB
0 - 1 MB/s
```

### Serie

Cada línea, área o conjunto de puntos representa una serie.

Una serie puede corresponder a:

- Una instancia.
- Un job.
- Una interfaz.
- Un punto de montaje.
- Una métrica.
- Una aplicación.

### Leyenda

Identifica cada serie.

Ejemplos:

```text
server-01:9100
server-02:9100
server-03:9100
```

### Tooltip

Al colocar el cursor sobre el gráfico, Grafana muestra los valores de las series en ese instante.

### Umbrales

Pueden aparecer como líneas o regiones horizontales para indicar límites operativos.

---

## Crear un panel Time series

### Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir una consulta PromQL.
6. Seleccionar la visualización `Time series`.
7. Configurar la unidad.
8. Configurar la leyenda.
9. Configurar líneas, puntos o áreas.
10. Configurar el eje vertical.
11. Configurar los umbrales.
12. Seleccionar el rango temporal.
13. Revisar los datos.
14. Guardar el panel.
15. Guardar el dashboard.

### Consulta inicial recomendada

Para una primera prueba:

```promql
node_load1
```

Configuración:

```text
Título: Carga del sistema
Visualización: Time series
Unidad: None
Rango temporal: Last 1 hour
```

---

## Consultas PromQL para Time series

### Uso de CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Uso global de CPU

```promql
100 - (
  avg(
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

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

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

### Tráfico recibido por instancia

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Tráfico enviado por instancia

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

### Tráfico recibido por interfaz

```promql
sum by (device) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Paquetes recibidos

```promql
sum by (instance) (
  rate(node_network_receive_packets_total{
    device!="lo"
  }[5m])
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

### Disponibilidad

```promql
avg by (job) (
  up
)
```

### Número de objetivos disponibles

```promql
sum(up)
```

Esta consulta devuelve un único valor y, por tanto, suele ser más apropiada para un Stat que para un Time series. Aun así, puede utilizarse para observar cómo cambia la cantidad de objetivos disponibles.

---

## Uso de `rate()` en series temporales

Muchas métricas de Node Exporter son contadores acumulativos.

Ejemplo:

```promql
node_network_receive_bytes_total
```

Este valor aumenta con el tiempo.

Para obtener una velocidad, utilizar:

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

La expresión calcula el ritmo medio de crecimiento durante los últimos cinco minutos.

### Ejemplos

#### Bytes recibidos por segundo

```promql
rate(node_network_receive_bytes_total[5m])
```

#### Bytes enviados por segundo

```promql
rate(node_network_transmit_bytes_total[5m])
```

#### CPU utilizada

```promql
rate(node_cpu_seconds_total{mode!="idle"}[5m])
```

Para representar un porcentaje de CPU, suele ser preferible calcular el tiempo idle y restarlo de `100`.

---

## Configurar el rango temporal

El rango temporal define qué intervalo se muestra.

### Rangos habituales

```text
Last 5 minutes
Last 15 minutes
Last 30 minutes
Last 1 hour
Last 6 hours
Last 12 hours
Last 24 hours
Last 7 days
```

### Elegir un rango adecuado

| Objetivo | Rango recomendado |
|---|---|
| Comprobar una incidencia actual | 15 minutos - 1 hora |
| Analizar una sesión | 1 - 6 horas |
| Revisar la jornada | 12 - 24 horas |
| Analizar capacidad | 7 - 30 días |
| Analizar tendencias largas | Varias semanas o meses |

Un rango demasiado corto puede ocultar tendencias.

Un rango demasiado largo puede comprimir los detalles y dificultar la interpretación.

---

## Configurar la frecuencia de actualización

Grafana puede actualizar automáticamente los datos.

Intervalos habituales:

```text
5 seconds
10 seconds
30 seconds
1 minute
5 minutes
15 minutes
```

### Recomendaciones

- Utilizar intervalos cortos para incidencias activas.
- Utilizar intervalos más largos para análisis de capacidad.
- No actualizar más rápido que la frecuencia de scraping sin necesidad.
- Evitar intervalos muy cortos en dashboards con muchas consultas.
- Comprobar la carga sobre Prometheus.

Si Prometheus realiza scraping cada 15 segundos, actualizar Grafana cada 1 segundo normalmente no aporta información adicional.

---

## Configurar líneas, puntos y áreas

### Líneas

Son la representación habitual.

Adecuadas para:

- CPU.
- Memoria.
- Carga.
- Tráfico.
- Latencia.

### Puntos

Los puntos permiten identificar muestras individuales.

Son útiles cuando:

- La frecuencia de muestreo es baja.
- Se necesita comprobar la existencia de muestras.
- Se quieren destacar eventos concretos.

### Áreas

Las áreas pueden utilizarse para destacar la magnitud de una métrica.

Son útiles para:

- Tráfico.
- Consumo de recursos.
- Series acumuladas.
- Gráficos apilados.

### Recomendación

No utilizar áreas apiladas cuando las series no sean sumables o comparables.

Por ejemplo, apilar porcentajes de CPU de varios servidores puede producir una interpretación engañosa.

---

## Configurar el grosor de línea

El grosor debe facilitar la lectura sin ocultar otras series.

Recomendación general:

```text
Una serie: grosor medio o alto
Varias series: grosor fino o medio
Muchas series: utilizar colores y leyenda con cuidado
```

Un grosor excesivo puede hacer que las líneas se mezclen.

---

## Configurar la interpolación

La interpolación define cómo se conectan los puntos.

Opciones habituales:

- Lineal.
- Suavizada.
- Escalonada.
- Sin conexión.

### Lineal

Une los puntos mediante líneas rectas.

Adecuada para la mayoría de métricas.

### Suavizada

Genera curvas visualmente más suaves.

Debe utilizarse con cuidado porque puede sugerir valores intermedios que no fueron medidos realmente.

### Escalonada

Mantiene un valor hasta que aparece una nueva muestra.

Puede ser adecuada para:

- Estados.
- Valores discretos.
- Cambios de configuración.
- Estados de servicio.

### Sin conexión

Puede utilizarse cuando no se desea inferir valores entre muestras.

---

## Configurar los ejes

### Unidad del eje

La unidad debe coincidir con la métrica.

Ejemplos:

```text
Percent (0-100)
Bytes (IEC)
bytes/sec
seconds
Celsius
None
```

### Mínimo y máximo

Para porcentajes:

```text
Mínimo: 0
Máximo: 100
```

Para otras métricas:

```text
Mínimo: Automático
Máximo: Automático
```

### Eje izquierdo y derecho

Puede utilizarse un segundo eje cuando se comparan métricas con escalas diferentes.

Ejemplo:

- CPU en porcentaje.
- Tráfico en bytes por segundo.

Sin embargo, los ejes dobles pueden dificultar la lectura.

### Recomendación

Utilizar ejes separados únicamente cuando la comparación sea necesaria y esté claramente documentada.

---

## Configurar una escala logarítmica

Una escala logarítmica puede ser útil cuando los valores abarcan varios órdenes de magnitud.

Ejemplo:

```text
1
10
100
1000
```

Puede ser adecuada para:

- Latencias muy variables.
- Tamaños de respuesta.
- Métricas con grandes diferencias.
- Distribuciones de valores.

No suele ser adecuada para:

- Porcentajes.
- Disponibilidad.
- Estados.
- Valores que pueden ser cero o negativos.

La escala logarítmica debe indicarse claramente para evitar interpretaciones incorrectas.

---

## Configurar la leyenda

La leyenda permite identificar cada serie.

### Ejemplo por instancia

Consulta:

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

### Ejemplo por interfaz

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

### Ejemplo por job

Consulta:

```promql
avg by (job) (
  up
)
```

Nombre recomendado:

```text
{{job}}
```

### Buenas prácticas

- Mostrar únicamente las etiquetas necesarias.
- Evitar nombres excesivamente largos.
- Utilizar la misma convención en todos los paneles.
- Incluir la instancia si se comparan servidores.
- Incluir la interfaz si se comparan interfaces.

---

## Configurar colores

Los colores deben ayudar a identificar las series y los estados.

### Colores por serie

Adecuados cuando se comparan:

```text
server-01
server-02
server-03
```

Cada serie recibe un color diferente.

### Colores por umbral

Adecuados cuando se muestran estados:

```text
0 - 70 %: verde
70 - 90 %: amarillo
90 - 100 %: rojo
```

### Recomendación

Si el objetivo principal es comparar instancias, utilizar colores por serie.

Si el objetivo principal es identificar estados, utilizar colores basados en umbrales.

---

## Configurar umbrales

Los umbrales pueden aparecer como líneas o regiones horizontales.

### CPU

```text
70 %: advertencia
90 %: crítico
```

### Memoria

```text
70 %: advertencia
90 %: crítico
```

### Almacenamiento

```text
80 %: advertencia
90 %: crítico
```

### Disponibilidad

```text
90 %: advertencia
99 %: normal
```

### Ejemplo conceptual

```text
100 % ─────────────────────────────
 90 % ───────────────────── Rojo
 70 % ───────────── Amarillo
  0 % ───── Verde
```

Los umbrales deben documentarse y adaptarse al entorno.

---

## Configurar transformaciones

Las transformaciones permiten modificar los datos antes de representarlos.

Pueden utilizarse para:

- Renombrar campos.
- Ocultar campos.
- Combinar consultas.
- Filtrar datos.
- Ordenar resultados.
- Crear campos calculados.
- Organizar tablas resultantes.

### Ejemplos de uso

- Cambiar un nombre largo por uno breve.
- Ocultar etiquetas innecesarias.
- Combinar datos de CPU y memoria.
- Filtrar una instancia concreta.
- Ordenar series por valor.

### Precaución

Las transformaciones pueden dificultar el diagnóstico si no están documentadas.

La consulta original y las transformaciones deben tener un propósito claro.

---

## Comparar varias instancias

### Consulta de CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Cada instancia aparece como una serie independiente.

### Configuración

```text
Título: Uso de CPU por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Leyenda: {{instance}}
```

### Interpretación

- Una línea estable indica un consumo constante.
- Picos repetidos pueden indicar cargas periódicas.
- Una línea permanentemente elevada puede indicar saturación.
- Una línea ausente puede indicar falta de datos o caída del objetivo.

---

## Representar estados en el tiempo

La métrica `up` puede representarse como una serie temporal.

### Consulta

```promql
up{job="node_exporter"}
```

### Interpretación

```text
1 = disponible
0 = no disponible
```

### Configuración recomendada

```text
Título: Disponibilidad de Node Exporter
Unidad: None
Interpolación: Staircase o escalonada
Min: 0
Max: 1
```

La interpolación escalonada representa mejor los cambios discretos entre `0` y `1`.

### Actividad

Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Esperar al siguiente scraping y observar el cambio.

Volver a iniciar:

```bash
sudo systemctl start node_exporter
```

Observar la recuperación.

---

## Ejemplo completo 1: Time series de CPU

### Objetivo

Mostrar el uso de CPU por instancia durante la última hora.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Configuración

```text
Título: Uso de CPU por instancia
Visualización: Time series
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Rango temporal: Last 1 hour
Leyenda: {{instance}}
```

### Descripción

```text
Porcentaje medio de CPU utilizada por instancia durante los últimos cinco minutos.
La serie muestra su evolución durante el rango temporal seleccionado.
```

### Umbrales

```text
70 %: advertencia
90 %: crítico
```

---

## Ejemplo completo 2: Time series de memoria

### Objetivo

Mostrar la evolución del porcentaje de memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Configuración

```text
Título: Evolución del uso de memoria
Visualización: Time series
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Rango temporal: Last 6 hours
Leyenda: {{instance}}
```

### Descripción

```text
Porcentaje de memoria utilizada por instancia durante las últimas seis horas.
Los incrementos sostenidos pueden indicar una fuga de memoria o un aumento
progresivo de la carga.
```

### Interpretación

- Una línea estable indica un consumo constante.
- Una subida gradual puede indicar crecimiento de procesos.
- Picos breves pueden corresponder a tareas puntuales.
- Una subida continua requiere investigación.

---

## Ejemplo completo 3: Time series de red

### Objetivo

Representar el tráfico recibido y enviado.

### Consulta A: tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Consulta B: tráfico enviado

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

### Configuración

```text
Título: Tráfico de red por instancia
Visualización: Time series
Unidad: bytes/sec
Mínimo: 0
Decimales: 1
Leyenda: {{instance}}
```

### Nombres de las consultas

```text
A: Recibido - {{instance}}
B: Enviado - {{instance}}
```

### Descripción

```text
Velocidad media de tráfico recibido y enviado durante los últimos cinco minutos.
Se excluye la interfaz de loopback.
```

---

## Ejemplo completo 4: Time series de almacenamiento

### Objetivo

Observar la evolución del espacio utilizado en el sistema de ficheros raíz.

### Consulta

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

### Configuración

```text
Título: Evolución del uso del sistema de ficheros raíz
Visualización: Time series
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Rango temporal: Last 24 hours
```

### Descripción

```text
Porcentaje de espacio utilizado en el sistema de ficheros raíz.
Una tendencia ascendente sostenida puede indicar que el disco se está llenando.
```

---

## Ejemplo de sesión 1: crear un Time series básico

### Objetivo

Crear un gráfico de la carga del sistema.

### Pasos

1. Acceder a Grafana:

```text
http://localhost:3000
```

2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir:

```promql
node_load1
```

6. Seleccionar `Time series`.
7. Configurar el título:

```text
Carga del sistema
```

8. Configurar la unidad como `None`.
9. Seleccionar el rango temporal `Last 1 hour`.
10. Activar la leyenda.
11. Guardar el panel.
12. Guardar el dashboard.

### Actividades

1. Cambia el rango a `Last 15 minutes`.
2. Cambia el rango a `Last 24 hours`.
3. Compara la cantidad de detalle.
4. Activa los puntos.
5. Cambia el grosor de la línea.
6. Añade una descripción.

---

## Ejemplo de sesión 2: representar CPU por instancia

### Objetivo

Crear un gráfico con una línea por instancia.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Pasos

1. Crear un panel Time series.
2. Introducir la consulta.
3. Configurar:

```text
Título: Uso de CPU por instancia
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
Leyenda: {{instance}}
```

4. Añadir los umbrales:

```text
70
90
```

5. Activar el tooltip compartido.
6. Guardar el panel.

### Actividades

1. Identifica las líneas de cada instancia.
2. Determina cuál presenta el pico más alto.
3. Genera carga:

```bash
yes > /dev/null &
```

4. Observa el gráfico.
5. Detén la carga:

```bash
pkill yes
```

6. Explica el tiempo necesario para observar la recuperación.

---

## Ejemplo de sesión 3: comparar CPU y memoria

### Objetivo

Crear un gráfico con dos consultas relacionadas.

### Consulta A: CPU

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Consulta B: memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Configuración

```text
Título: CPU y memoria del servidor
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

### Actividades

1. Añade las dos consultas.
2. Configura nombres:
   - `CPU`
   - `Memoria`
3. Utiliza colores diferentes.
4. Comprueba que ambas métricas comparten escala.
5. Genera carga de CPU.
6. Observa si la memoria también cambia.
7. Explica por qué no necesariamente deben evolucionar igual.

---

## Ejemplo de sesión 4: representar disponibilidad

### Objetivo

Observar las caídas y recuperaciones de Node Exporter.

### Consulta

```promql
up{job="node_exporter"}
```

### Configuración

```text
Título: Disponibilidad de Node Exporter
Unidad: None
Mínimo: 0
Máximo: 1
Interpolación: Escalonada
Leyenda: {{instance}}
```

### Pasos

1. Crear el panel.
2. Introducir la consulta.
3. Seleccionar una ventana de 15 minutos.
4. Confirmar que el valor inicial es `1`.
5. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

6. Esperar al siguiente ciclo de scraping.
7. Observar el cambio a `0`.
8. Iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

9. Observar el cambio a `1`.

### Actividades

1. Anota las horas aproximadas de caída y recuperación.
2. Explica el efecto del intervalo de scraping.
3. Cambia la interpolación a lineal.
4. Compara la interpretación.
5. Restaura la interpolación escalonada.

---

## Ejemplo de sesión 5: representar tráfico de red

### Objetivo

Mostrar el tráfico recibido y enviado por instancia.

### Consulta A

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

### Consulta B

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

### Pasos

1. Crear un panel Time series.
2. Añadir las dos consultas.
3. Configurar:

```text
Título: Tráfico de red
Unidad: bytes/sec
Mínimo: 0
Leyenda: {{instance}}
```

4. Configurar nombres:
   - `Recibido - {{instance}}`
   - `Enviado - {{instance}}`
5. Generar tráfico mediante una actividad de red autorizada.
6. Observar el gráfico.
7. Consultar las estadísticas:

```bash
ip -s link
```

### Actividades

1. Identifica la diferencia entre tráfico recibido y enviado.
2. Explica por qué se excluye `lo`.
3. Cambia la consulta para mostrar el tráfico por interfaz.
4. Compara la cantidad de series.

---

## Ejemplo de sesión 6: analizar el almacenamiento

### Objetivo

Observar si el uso del sistema de ficheros aumenta con el tiempo.

### Consulta

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

### Pasos

1. Crear un panel Time series.
2. Configurar la unidad como porcentaje.
3. Configurar el eje entre `0` y `100`.
4. Seleccionar `Last 24 hours`.
5. Añadir umbrales en `80` y `90`.
6. Comparar con:

```bash
df -h /
```

### Actividades

1. Describe la tendencia.
2. Comprueba si existen picos.
3. Explica qué significaría una subida continua.
4. Añade una descripción operativa.
5. Guarda una captura.

---

## Ejemplo de sesión 7: utilizar el tooltip

### Objetivo

Consultar los valores exactos de varias series en el mismo instante.

### Pasos

1. Abrir el panel de CPU.
2. Colocar el cursor sobre una zona del gráfico.
3. Revisar los valores de cada serie.
4. Activar el modo de tooltip compartido.
5. Comparar los valores de todas las instancias.
6. Desplazar el cursor hacia un pico.

### Actividades

1. Identifica la instancia con mayor valor.
2. Anota la hora del pico.
3. Compara esa hora con otros paneles.
4. Explica cómo el tooltip ayuda durante una incidencia.

---

## Ejemplo de sesión 8: trabajar con `topk()`

### Objetivo

Mostrar únicamente las instancias con mayor uso de CPU.

### Consulta

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

### Pasos

1. Crear un panel Time series.
2. Introducir la consulta.
3. Configurar la unidad como porcentaje.
4. Seleccionar `Last 6 hours`.
5. Activar la leyenda.
6. Guardar el panel.

### Actividades

1. Compara la consulta con la versión sin `topk()`.
2. Cambia `5` por `3`.
3. Explica por qué las instancias mostradas pueden cambiar a lo largo del tiempo.
4. Valora si esta consulta es adecuada para un dashboard operativo.

---

## Ejemplo de sesión 9: diagnosticar un panel sin datos

### Objetivo

Diferenciar un problema de consulta, fuente de datos o rango temporal.

### Consulta incorrecta

```promql
metrica_temporal_inexistente
```

### Pasos

1. Crear un panel Time series.
2. Introducir la consulta incorrecta.
3. Observar el resultado.
4. Abrir el inspector.
5. Revisar la consulta ejecutada.
6. Revisar los datos devueltos.
7. Probar:

```promql
up
```

8. Probar:

```promql
node_load1
```

9. Revisar el rango temporal.
10. Restaurar una consulta válida.

### Actividades

Documentar:

- Consulta original.
- Resultado observado.
- Mensaje de error.
- Diagnóstico.
- Solución.
- Evidencia capturada.

---

## Ejemplo de sesión 10: comparar datos con la API de Prometheus

### Objetivo

Comprobar que los valores del gráfico coinciden con los datos devueltos por Prometheus.

### Consulta de CPU

```bash
curl -sG \
  http://localhost:9090/api/v1/query_range \
  --data-urlencode '
    query=100 - (
      avg by (instance) (
        rate(node_cpu_seconds_total{mode="idle"}[5m])
      ) * 100
    )
  ' \
  --data-urlencode 'start=-1h' \
  --data-urlencode 'end=now' \
  --data-urlencode 'step=60' \
  | jq
```

Según la versión y el shell utilizado, puede ser necesario proporcionar marcas temporales absolutas para `start` y `end`.

### Consulta instantánea

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

### Actividades

1. Compara el valor más reciente con Grafana.
2. Comprueba el número de series.
3. Revisa las etiquetas.
4. Explica la diferencia entre `query` y `query_range`.
5. Guarda el resultado como evidencia.

---

## Configurar paneles con varias consultas

Un panel Time series puede contener varias consultas.

### Ejemplo

#### Consulta A: CPU

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

#### Consulta B: memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

#### Consulta C: carga

```promql
node_load1
```

### Precaución

CPU y memoria pueden compartir una escala de porcentajes.

La carga del sistema utiliza otra escala y puede requerir:

- Otro eje.
- Otro panel.
- Una transformación.
- Una visualización separada.

Una organización más clara sería:

```text
Panel 1: CPU y memoria
Panel 2: carga del sistema
```

---

## Configurar paneles con ejes diferentes

Si se representan métricas con unidades diferentes, utilizar ejes separados con precaución.

Ejemplo:

```text
CPU: porcentaje
Tráfico: bytes/sec
```

Opciones:

- Utilizar dos paneles.
- Asignar una métrica al eje derecho.
- Utilizar transformaciones.
- Normalizar los valores.

### Recomendación

Para formación y operación, dos paneles separados suelen ser más fáciles de interpretar que un gráfico con dos escalas.

---

## Configurar series apiladas

El apilamiento coloca las series unas encima de otras.

Puede ser útil cuando las series son sumables.

Ejemplo:

```text
Tráfico recibido por interfaz
```

No suele ser adecuado para comparar directamente el uso de CPU de varios servidores, porque la suma visual puede sugerir un porcentaje global que no representa correctamente el sistema.

### Utilizar apilamiento cuando:

- Las series representan partes de un total.
- Se desea observar una suma.
- Todas las series utilizan la misma unidad.
- La suma tiene significado operativo.

### Evitar apilamiento cuando:

- Se comparan instancias independientes.
- Se utilizan porcentajes de sistemas diferentes.
- La suma no representa una magnitud válida.

---

## Configurar valores nulos y huecos

En una serie temporal pueden existir intervalos sin datos.

Esto puede ocurrir por:

- Fallo de scraping.
- Reinicio de un exporter.
- Pérdida de conectividad.
- Consulta incorrecta.
- Métrica que deja de existir.
- Rango temporal sin muestras.

Grafana puede:

- Dejar el hueco.
- Conectar los puntos.
- Mostrar cero.
- Mantener el último valor.

### Recomendación

No convertir automáticamente los huecos en cero sin comprender el significado.

Un hueco puede indicar:

```text
No hay datos
```

No necesariamente:

```text
El valor es cero
```

---

## Configurar puntos y muestras

Los puntos muestran las muestras individuales.

Son útiles para comprobar:

- Frecuencia de scraping.
- Datos irregulares.
- Huecos.
- Valores atípicos.
- Métricas discretas.

Para métricas de alta frecuencia y muchas series, mostrar puntos puede saturar visualmente el gráfico.

### Recomendación

- Utilizar puntos en diagnósticos.
- Ocultarlos en dashboards con muchas series.
- Mantenerlos cuando la frecuencia de muestreo sea baja.
- Revisar el resultado en varios rangos temporales.

---

## Configurar alertas visuales mediante umbrales

Los umbrales pueden mostrarse como líneas horizontales.

Ejemplo para CPU:

```text
70 %: advertencia
90 %: crítico
```

El panel puede mostrar:

```text
Línea amarilla en 70
Línea roja en 90
```

Esto ayuda a relacionar la tendencia con los límites operativos.

Los umbrales visuales no sustituyen a una regla de alerta. Una alerta debe configurarse y evaluarse según las necesidades del entorno.

---

## Buenas prácticas

### Elegir un rango temporal adecuado

No analizar una tendencia de horas con un rango de cinco minutos.

### Utilizar nombres de series claros

Ejemplo:

```text
CPU - server-01
Memoria - server-01
Recibido - server-01
```

### Evitar demasiadas series

Si hay demasiadas líneas:

- Filtrar instancias.
- Utilizar `topk()`.
- Crear varios paneles.
- Agrupar por job.
- Utilizar un Bar Gauge.
- Separar por entorno.

### Utilizar las unidades correctas

Un valor sin unidad puede ser ambiguo.

### Configurar la leyenda

La leyenda debe ayudar a identificar el origen de cada serie.

### No utilizar escalas engañosas

Para porcentajes, comenzar el eje en `0` suele ser más claro.

### Documentar las consultas

La descripción debe explicar:

- Qué representa cada serie.
- Qué intervalo utiliza `rate()`.
- Qué etiquetas se filtran.
- Qué unidad se muestra.
- Qué significan los umbrales.

### Combinar resumen y tendencia

Una estructura eficaz:

```text
Fila superior: Stats y Gauges
Fila central: Time series
Fila inferior: tablas y detalles
```

### Revisar el rendimiento

El número de series y el rango temporal afectan al rendimiento.

---

## Problemas habituales

### El panel no muestra datos

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
- Estado de los targets.
- Variables.
- Etiquetas.
- Inspector.
- Intervalo de scraping.

### La línea aparece plana

Posibles causas:

- La métrica realmente es estable.
- El rango temporal es demasiado amplio.
- La resolución no muestra los detalles.
- Los valores varían muy poco.
- La consulta está agregando demasiado.

Probar:

```text
Un rango temporal más corto
Más decimales
Puntos visibles
Una consulta menos agregada
```

### La línea tiene picos inesperados

Comprobar:

- La consulta.
- El intervalo de `rate()`.
- Reinicios del exporter.
- Cambios de carga.
- Etiquetas.
- Transformaciones.
- El rango temporal.

### La gráfica tiene demasiadas líneas

Aplicar:

```promql
topk(
  5,
  <consulta>
)
```

o filtrar:

```promql
{instance=~"$instance"}
```

También se puede agrupar:

```promql
sum by (job) (...)
```

### Los colores no se distinguen

Posibles soluciones:

- Reducir el número de series.
- Configurar colores manualmente.
- Mejorar la leyenda.
- Separar el panel.
- Utilizar un Bar Gauge.
- Utilizar una tabla.

### Los valores no coinciden con el sistema operativo

Posibles causas:

- Diferencia temporal.
- Fórmula distinta.
- Métricas diferentes.
- Memoria cacheada.
- Exclusión de interfaces.
- Redondeo.
- Diferencia entre porcentaje y proporción.

### La métrica de red aparece como un contador

Si se muestra:

```promql
node_network_receive_bytes_total
```

se verá un valor acumulado.

Para mostrar velocidad:

```promql
rate(node_network_receive_bytes_total[5m])
```

### La CPU supera el 100 %

Posibles causas:

- No se ha promediado por CPU.
- Se están sumando porcentajes de varios procesadores.
- Se está utilizando una consulta sin la agregación adecuada.
- La unidad o el máximo no corresponden.

Consulta recomendada:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Aparecen huecos

Comprobar:

- Estado del target.
- Intervalo de scraping.
- Reinicios de servicios.
- Rango temporal.
- Consulta.
- Retención de datos.
- Configuración de valores nulos.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-time-series
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-time-series/consultas-promql.txt <<'EOF'
CPU por instancia:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria utilizada:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Carga del sistema:
node_load1

Tráfico recibido:
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)

Tráfico enviado:
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)

Uso de almacenamiento:
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

Disponibilidad de Node Exporter:
up{job="node_exporter"}
EOF
```

Consultar una serie temporal desde la API:

```bash
curl -sG \
  http://localhost:9090/api/v1/query_range \
  --data-urlencode \
  'query=node_load1' \
  --data-urlencode 'start=-1h' \
  --data-urlencode 'end=now' \
  --data-urlencode 'step=60' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-time-series/carga-ultima-hora.json
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-time-series/informe.txt <<'EOF'
Práctica: Panel Time series

Dashboard utilizado:

Paneles creados:

Métricas representadas:

Rangos temporales utilizados:

Intervalos de actualización:

Unidades configuradas:

Leyendas configuradas:

Umbrales configurados:

Pruebas de carga realizadas:

Prueba de caída de Node Exporter:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-time-series-carga.png
02-time-series-cpu.png
03-time-series-memoria.png
04-time-series-red.png
05-time-series-almacenamiento.png
06-time-series-disponibilidad.png
07-time-series-topk.png
08-time-series-sin-datos.png
09-time-series-dashboard-final.png
```

---

## Práctica integradora

### Objetivo

Crear un dashboard temporal para analizar la evolución de los principales recursos de un servidor.

### Panel 1: CPU

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
Título: Evolución del uso de CPU
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Leyenda: {{instance}}
Rango: Last 1 hour
```

### Panel 2: memoria

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
Título: Evolución del uso de memoria
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Leyenda: {{instance}}
Rango: Last 6 hours
```

### Panel 3: almacenamiento

Consulta:

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

Configuración:

```text
Título: Evolución del uso del sistema de ficheros
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Rango: Last 24 hours
```

### Panel 4: tráfico de red

Consulta A:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Consulta B:

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

Configuración:

```text
Título: Evolución del tráfico de red
Unidad: bytes/sec
Mínimo: 0
Leyenda: {{instance}}
Rango: Last 1 hour
```

### Panel 5: disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Configuración:

```text
Título: Disponibilidad de Node Exporter
Mínimo: 0
Máximo: 1
Leyenda: {{instance}}
Interpolación: Escalonada
Rango: Last 30 minutes
```

### Tareas

1. Crear los cinco paneles.
2. Seleccionar Time series.
3. Configurar las unidades.
4. Configurar las leyendas.
5. Configurar los límites.
6. Configurar los umbrales.
7. Revisar distintos rangos temporales.
8. Generar carga de CPU.
9. Observar la evolución.
10. Detener Node Exporter.
11. Observar el cambio a `0`.
12. Iniciar Node Exporter.
13. Observar la recuperación.
14. Comparar tráfico recibido y enviado.
15. Utilizar el inspector.
16. Exportar el dashboard.
17. Guardar las evidencias.
18. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Panel de CPU creado | | |
| Panel de memoria creado | | |
| Panel de almacenamiento creado | | |
| Panel de red creado | | |
| Panel de disponibilidad creado | | |
| Rango temporal configurado | | |
| Actualización automática configurada | | |
| Unidad configurada | | |
| Leyenda configurada | | |
| Umbrales configurados | | |
| Ejes configurados | | |
| Prueba de carga realizada | | |
| Prueba de caída realizada | | |
| Recuperación comprobada | | |
| Consulta `topk()` realizada | | |
| Inspector utilizado | | |
| Dashboard exportado | | |
| Evidencias guardadas | | |

---

## Puntos clave

- El panel Time series representa la evolución temporal de una o varias métricas.
- Es adecuado para analizar tendencias, picos, caídas y recuperaciones.
- Una línea representa normalmente una serie.
- La leyenda identifica el origen de cada serie.
- El rango temporal determina el contexto visible.
- El intervalo de actualización debe ser coherente con el scraping.
- `rate()` permite calcular velocidades a partir de contadores.
- La CPU, memoria, red y almacenamiento pueden representarse mediante series temporales.
- Un Stat muestra principalmente el valor actual.
- Un Gauge muestra el valor frente a un rango.
- Un Bar Gauge compara valores actuales.
- Un Time series muestra cómo cambian los valores.
- Los porcentajes suelen utilizar una escala de `0` a `100`.
- Los huecos no deben interpretarse automáticamente como cero.
- La interpolación escalonada es adecuada para estados discretos como `up`.
- Demasiadas series reducen la legibilidad.
- `topk()` permite limitar el número de series mostradas.
- Los ejes dobles deben utilizarse con precaución.
- El apilamiento solo debe utilizarse cuando la suma de series tenga significado.
- Los umbrales visuales ayudan a interpretar la tendencia, pero no sustituyen a las alertas.
- El inspector ayuda a diagnosticar consultas y datos.
- Un dashboard eficaz combina valores actuales, tendencias y detalles.

---

## Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Time series?
2. ¿Qué diferencia existe entre un Time series y un Stat?
3. ¿Qué diferencia existe entre un Time series y un Gauge?
4. ¿Qué diferencia existe entre un Time series y un Bar Gauge?
5. ¿Qué representa cada línea del gráfico?
6. ¿Para qué sirve la leyenda?
7. ¿Qué rango temporal elegirías para analizar una incidencia reciente?
8. ¿Qué rango temporal elegirías para analizar capacidad?
9. ¿Qué función cumple `rate()`?
10. ¿Por qué no se debe mostrar directamente un contador de red como una velocidad?
11. ¿Qué consulta utilizarías para representar la CPU por instancia?
12. ¿Qué consulta utilizarías para representar el tráfico recibido?
13. ¿Qué unidad utilizarías para el uso de CPU?
14. ¿Qué unidad utilizarías para el tráfico de red?
15. ¿Qué representa el valor `1` de la métrica `up`?
16. ¿Qué representa el valor `0` de la métrica `up`?
17. ¿Por qué puede ser adecuada la interpolación escalonada para `up`?
18. ¿Qué problemas produce mostrar demasiadas series?
19. ¿Cómo limitarías el número de series?
20. ¿Qué función cumple `topk()`?
21. ¿Cuándo utilizarías una escala logarítmica?
22. ¿Por qué deben utilizarse con cuidado los ejes dobles?
23. ¿Qué diferencia existe entre un hueco y un valor cero?
24. ¿Qué revisarías si un panel Time series aparece vacío?
25. ¿Qué evidencias guardarías después de la práctica?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear gráficos temporales claros y útiles para analizar el comportamiento de un sistema.

El proceso completo será:

```text
Seleccionar una métrica
        |
        v
Determinar su dimensión temporal
        |
        v
Crear una consulta PromQL
        |
        v
Seleccionar Time series
        |
        v
Configurar rango temporal
        |
        v
Configurar unidad y ejes
        |
        v
Configurar leyenda y colores
        |
        v
Añadir umbrales
        |
        v
Controlar series y resolución
        |
        v
Analizar tendencias y anomalías
        |
        v
Guardar y documentar
```

El resultado final debe ser un dashboard capaz de mostrar no solo el valor actual de las métricas, sino también su evolución, sus cambios y los posibles indicios de una incidencia.