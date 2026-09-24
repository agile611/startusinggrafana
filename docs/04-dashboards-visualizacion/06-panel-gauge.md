# Panel Gauge

El panel **Gauge** de Grafana representa un valor dentro de un rango definido.

Su aspecto visual permite identificar rápidamente si una métrica se encuentra en una zona normal, de advertencia o crítica.

Es especialmente útil para mostrar:

- Uso de CPU.
- Uso de memoria.
- Uso del sistema de ficheros.
- Porcentaje de disponibilidad.
- Porcentaje de errores.
- Capacidad utilizada.
- Temperatura.
- Nivel de ocupación.
- Progreso hacia un límite.

Un Gauge no solo muestra el valor actual. También permite situarlo visualmente entre un mínimo y un máximo.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Gauge.
- Diferenciar un Gauge de un Stat y un Time series.
- Crear un panel Gauge desde cero.
- Utilizar consultas PromQL para calcular porcentajes.
- Configurar valores mínimos y máximos.
- Configurar unidades y decimales.
- Configurar umbrales.
- Seleccionar esquemas de color.
- Representar el uso de CPU.
- Representar el uso de memoria.
- Representar el uso de almacenamiento.
- Representar la disponibilidad de los objetivos.
- Interpretar correctamente el indicador.
- Diagnosticar un Gauge sin datos.
- Identificar errores de escala.
- Comparar un Gauge con un panel Bar Gauge.
- Integrar varios Gauges en un dashboard operativo.

---

## Introducción

El panel Gauge muestra un valor dentro de una escala.

El flujo general es:

```text
Métricas de Prometheus
        |
        v
Consulta PromQL
        |
        v
Valor calculado
        |
        v
Escala mínima y máxima
        |
        v
Umbrales y colores
        |
        v
Panel Gauge
```

Ejemplo:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

La consulta puede devolver:

```text
73.4
```

El panel Gauge puede representarlo como:

```text
73.4 %
```

dentro de una escala:

```text
0 % ------------------------- 100 %
          73.4 %
```

Con umbrales:

```text
0 - 70 %:   Verde
70 - 90 %:  Amarillo
90 - 100 %: Rojo
```

Esto permite interpretar rápidamente el estado del recurso.

---

## Cuándo utilizar un panel Gauge

El Gauge es apropiado cuando:

- El valor actual es importante.
- Existe un rango conocido.
- Se desea comparar el valor con límites.
- El dato puede expresarse como porcentaje.
- Se necesita una indicación visual inmediata.
- Los umbrales tienen significado operativo.

### Ejemplos adecuados

```promql
100 * avg(up)
```

Porcentaje de disponibilidad.

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Porcentaje de memoria utilizada.

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

Porcentaje de espacio utilizado.

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Porcentaje de CPU utilizada.

---

## Cuándo no utilizar un panel Gauge

El Gauge no suele ser la mejor opción cuando se necesita:

- Analizar una tendencia temporal detallada.
- Comparar muchas instancias.
- Mostrar decenas de series.
- Consultar etiquetas y valores en detalle.
- Representar una distribución.
- Mostrar texto explicativo.
- Analizar picos ocurridos durante un periodo largo.

En esos casos pueden ser más adecuadas otras visualizaciones:

| Necesidad | Visualización recomendada |
|---|---|
| Valor actual resumido | Stat |
| Evolución temporal | Time series |
| Comparación entre elementos | Bar Gauge |
| Etiquetas y valores | Table |
| Distribución de valores | Heatmap |
| Documentación | Text |

---

## Diferencia entre Gauge y Stat

Ambos pueden mostrar un valor actual, pero el Gauge da más importancia a la relación entre el valor y su escala.

| Característica | Stat | Gauge |
|---|---|---|
| Mostrar un valor actual | Sí | Sí |
| Mostrar porcentaje | Sí | Sí |
| Mostrar relación con un rango | Limitada | Principal función |
| Mostrar umbrales | Mediante color | Mediante escala y color |
| Mostrar una sparkline | Sí | No es su objetivo principal |
| Mostrar muchos elementos | Limitado | Bar Gauge suele ser mejor |
| Uso como indicador visual | Alto | Muy alto |

### Ejemplo con el mismo dato

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Como Stat:

```text
Memoria utilizada: 73.4 %
```

Como Gauge:

```text
0 % ----------- 73.4 % ---------------- 100 %
       verde       amarillo       rojo
```

El Stat destaca el número.

El Gauge destaca la posición del número dentro de un rango.

---

## Diferencia entre Gauge y Bar Gauge

El Gauge suele estar orientado a un valor individual.

El Bar Gauge es más adecuado para comparar varios valores.

### Gauge

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Uso:

```text
Memoria utilizada en un servidor
```

### Bar Gauge

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Uso:

```text
Memoria utilizada por varias instancias
```

Si la consulta devuelve varias series, un Bar Gauge puede ofrecer una comparación más clara que un único Gauge.

---

## Anatomía de un panel Gauge

Un panel Gauge puede incluir:

```text
+--------------------------------------+
| Uso de memoria                       |
|                                      |
|              73.4 %                  |
|           [ indicador ]              |
|                                      |
| 0 %              70 %       100 %    |
+--------------------------------------+
```

### Valor actual

Es el resultado de la consulta.

Ejemplo:

```text
73.4
```

### Unidad

Indica cómo debe interpretarse el valor.

Ejemplo:

```text
Percent (0-100)
```

### Valor mínimo

Define el inicio de la escala.

Para un porcentaje:

```text
0
```

### Valor máximo

Define el final de la escala.

Para un porcentaje:

```text
100
```

### Umbrales

Dividen la escala en zonas.

Ejemplo:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Colores

Representan visualmente el estado del valor.

Una convención habitual es:

```text
Verde: normal
Amarillo: advertencia
Rojo: crítico
```

### Decimales

Controlan la precisión mostrada.

Ejemplo:

```text
73.4 %
```

en lugar de:

```text
73.438291 %
```

---

## Crear un panel Gauge

### Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir una consulta PromQL.
6. Seleccionar la visualización `Gauge`.
7. Configurar la unidad.
8. Definir el mínimo.
9. Definir el máximo.
10. Configurar los umbrales.
11. Configurar los decimales.
12. Añadir una descripción.
13. Revisar el resultado.
14. Guardar el panel.
15. Guardar el dashboard.

### Consulta inicial recomendada

Para una primera prueba:

```promql
100 * avg(up)
```

Configuración:

```text
Título: Disponibilidad global
Visualización: Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

---

## Configurar la escala

### Escala de porcentaje

Para valores expresados entre 0 y 100:

```text
Mínimo: 0
Máximo: 100
```

Ejemplos:

- CPU.
- Memoria.
- Almacenamiento.
- Disponibilidad.
- Porcentaje de errores.

### Escala de proporción

Una consulta como esta devuelve un valor entre 0 y 1:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Si se utiliza esta consulta, la unidad debe configurarse como una proporción o la consulta debe multiplicarse por `100`.

Opción recomendada:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Unidad:

```text
Percent (0-100)
```

### Escala de bytes

Para mostrar memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

La escala no debe fijarse automáticamente entre `0` y `100`.

Utilizar:

```text
Unidad: Bytes (IEC)
Mínimo: 0
Máximo: Automático
```

### Escala de carga

Para la carga del sistema:

```promql
node_load1
```

La carga no es un porcentaje.

Configuración recomendada:

```text
Unidad: None
Mínimo: 0
Máximo: Automático
```

El máximo puede depender de la capacidad del sistema y del objetivo del dashboard.

---

## Configurar unidades

### Uso de CPU

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
Unidad: Percent (0-100)
```

### Uso de memoria

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
Unidad: Percent (0-100)
```

### Uso de almacenamiento

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
Unidad: Percent (0-100)
```

### Disponibilidad

Consulta:

```promql
100 * avg(up)
```

Configuración:

```text
Unidad: Percent (0-100)
```

### Temperatura

Si existe una métrica de temperatura:

```promql
node_hwmon_temp_celsius
```

Configuración:

```text
Unidad: Celsius
```

### Tráfico de red

Consulta:

```promql
sum(
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Configuración:

```text
Unidad: bytes/sec
```

---

## Configurar umbrales

Los umbrales determinan el estado visual del Gauge.

### Uso de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

Interpretación:

```text
0 - 69.99 %    Uso normal
70 - 89.99 %   Uso elevado
90 - 100 %     Uso crítico
```

### Uso de memoria

Umbrales habituales:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Uso de almacenamiento

Los discos pueden requerir umbrales más estrictos:

```text
0      Verde
80     Amarillo
90     Rojo
```

### Disponibilidad

Para una disponibilidad global:

```text
0      Rojo
90     Amarillo
99     Verde
```

### Importancia de documentar los umbrales

Los valores deben estar justificados.

No siempre los mismos umbrales son válidos para todos los sistemas:

- Un servidor de desarrollo.
- Un servidor de producción.
- Un sistema con poco almacenamiento.
- Un sistema de procesamiento intensivo.
- Un equipo con alta disponibilidad.

---

## Configurar colores

Los colores deben expresar estados, no decorar el panel.

Convención habitual:

```text
Verde: situación normal
Amarillo: advertencia
Rojo: situación crítica
```

### Ejemplo

```text
Uso de memoria: 45 % → verde
Uso de memoria: 78 % → amarillo
Uso de memoria: 94 % → rojo
```

### Errores frecuentes

No se debe:

- Utilizar rojo para todos los valores altos sin analizar el contexto.
- Usar colores diferentes para el mismo significado.
- Mezclar escalas entre paneles.
- Utilizar colores sin documentarlos.
- Confundir ausencia de datos con estado normal.

---

## Configurar decimales

Los decimales dependen de la métrica.

| Métrica | Decimales recomendados |
|---|---:|
| CPU | 1 |
| Memoria | 1 |
| Almacenamiento | 1 |
| Disponibilidad | 1 o 2 |
| Carga | 2 |
| Temperatura | 1 |
| Tráfico | 1 o 2 |

Ejemplo:

```text
Uso de CPU: 73.4 %
```

es más fácil de leer que:

```text
Uso de CPU: 73.438291 %
```

---

## Configurar el modo de visualización

El Gauge puede configurarse con distintos estilos visuales.

Según la versión de Grafana, pueden estar disponibles opciones como:

- Gauge radial.
- Barra.
- Indicador horizontal.
- Indicador vertical.
- Arco.
- Escala con valor central.

La selección debe depender del espacio disponible y de la cantidad de información.

### Gauge radial

Adecuado para:

- Paneles pequeños.
- Indicadores individuales.
- Porcentajes.
- Uso de memoria.

### Barra horizontal

Adecuada para:

- Paneles más anchos.
- Comparaciones sencillas.
- Integración con otros indicadores.

### Escala con valor

Adecuada cuando:

- Los límites deben ser muy visibles.
- El valor actual necesita contexto.
- Se quiere facilitar la lectura del rango.

---

## Configurar el texto del Gauge

El Gauge puede mostrar:

- Valor.
- Unidad.
- Nombre.
- Valor y nombre.
- Texto personalizado mediante mapas de valores.

### Solo valor

```text
73.4 %
```

### Valor y nombre

```text
Memoria utilizada: 73.4 %
```

### Nombre del campo

Para una consulta agrupada:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Se puede mostrar:

```text
{{instance}}
```

Esto resulta útil cuando se trabaja con una instancia concreta.

---

## Consultas PromQL para Gauge

### Disponibilidad global

```promql
100 * avg(up)
```

### Disponibilidad de Node Exporter

```promql
100 * avg(up{job="node_exporter"})
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

### Uso de memoria por instancia

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

### Carga del sistema

```promql
node_load1
```

### Temperatura

Si Node Exporter expone la métrica:

```promql
node_hwmon_temp_celsius
```

### Tráfico recibido

```promql
sum(
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

---

## Ejemplo completo 1: Gauge de disponibilidad

### Objetivo

Mostrar el porcentaje global de objetivos disponibles.

### Consulta

```promql
100 * avg(up)
```

### Configuración

```text
Título: Disponibilidad global
Visualización: Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

### Umbrales

```text
0      Rojo
90     Amarillo
99     Verde
```

### Descripción

```text
Porcentaje de objetivos disponibles en el último scraping.
Los objetivos con valor 1 se consideran disponibles.
```

### Resultado esperado

Si todos los objetivos están activos:

```text
100.0 %
```

---

## Ejemplo completo 2: Gauge de CPU

### Objetivo

Mostrar el porcentaje de CPU utilizado.

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
Título: Uso de CPU
Visualización: Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

### Umbrales

```text
0      Verde
70     Amarillo
90     Rojo
```

### Descripción

```text
Porcentaje medio de CPU utilizada durante los últimos cinco minutos.
El cálculo se realiza a partir del tiempo de CPU en modo idle.
```

### Consideración

Si la consulta devuelve una serie por instancia, el Gauge puede mostrar varios resultados o aplicar una reducción.

Para mostrar una única instancia:

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Para mantener el detalle por instancia, puede ser más adecuado utilizar:

```text
Bar Gauge
```

o:

```text
Time series
```

---

## Ejemplo completo 3: Gauge de memoria

### Objetivo

Mostrar el porcentaje de memoria utilizada.

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
Título: Uso de memoria
Visualización: Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

### Umbrales

```text
0      Verde
70     Amarillo
90     Rojo
```

### Descripción

```text
Porcentaje de memoria utilizada por el sistema.
Los valores superiores al 90 % deben investigarse.
```

---

## Ejemplo completo 4: Gauge de almacenamiento

### Objetivo

Mostrar el uso del sistema de ficheros raíz.

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
Título: Uso del sistema de ficheros raíz
Visualización: Gauge
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

### Umbrales

```text
0      Verde
80     Amarillo
90     Rojo
```

### Comparación con el sistema operativo

```bash
df -h /
```

### Descripción

```text
Porcentaje de espacio utilizado en el sistema de ficheros raíz.
Se excluyen los tipos tmpfs y overlay.
```

---

## Ejemplo completo 5: Gauge de capacidad disponible

Un Gauge también puede utilizarse para mostrar capacidad disponible en vez de capacidad utilizada.

### Consulta

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Configuración

```text
Título: Memoria disponible
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

### Umbrales

En este caso, un valor alto suele ser positivo:

```text
0      Rojo
10     Amarillo
30     Verde
```

La interpretación depende del sentido de la métrica.

Para memoria disponible:

```text
Valor bajo: problema
Valor alto: situación normal
```

Para memoria utilizada:

```text
Valor bajo: situación normal
Valor alto: problema
```

Es fundamental que el título y la descripción indiquen si se está mostrando:

```text
Uso
```

o:

```text
Disponibilidad
```

---

## Ejemplo de sesión 1: crear un Gauge básico

### Objetivo

Crear un Gauge para representar la disponibilidad global.

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
100 * avg(up)
```

6. Seleccionar la visualización `Gauge`.
7. Configurar:

```text
Título: Disponibilidad global
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

8. Configurar los umbrales:

```text
0      Rojo
90     Amarillo
99     Verde
```

9. Guardar el panel.
10. Guardar el dashboard.

### Actividades

1. Anota el valor mostrado.
2. Comprueba el resultado directamente en Prometheus.
3. Explica la posición del indicador.
4. Describe el significado de cada color.
5. Añade una descripción al panel.

---

## Ejemplo de sesión 2: crear un Gauge de memoria

### Objetivo

Representar el porcentaje de memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Pasos

1. Crear un panel nuevo.
2. Seleccionar Prometheus.
3. Introducir la consulta.
4. Seleccionar `Gauge`.
5. Configurar:

```text
Título: Uso de memoria
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

6. Configurar:

```text
0      Verde
70     Amarillo
90     Rojo
```

7. Guardar el panel.
8. Guardar el dashboard.

### Actividades

1. Comprueba la memoria utilizada con:

```bash
free -h
```

2. Compara el resultado.
3. Explica posibles diferencias.
4. Cambia temporalmente la unidad.
5. Restaura la configuración correcta.

---

## Ejemplo de sesión 3: crear un Gauge de CPU

### Objetivo

Representar el uso actual de CPU.

### Consulta

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Pasos

1. Crear un Gauge.
2. Introducir la consulta.
3. Configurar:

```text
Título: Uso medio de CPU
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

4. Configurar umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

5. Guardar el panel.

### Generar carga

Ejecutar:

```bash
yes > /dev/null &
```

Observar el Gauge y detener la carga:

```bash
pkill yes
```

### Actividades

1. Anota el valor inicial.
2. Genera carga.
3. Observa el cambio.
4. Comprueba el color.
5. Detén la carga.
6. Observa la recuperación.
7. Explica el uso de `rate()`.

---

## Ejemplo de sesión 4: crear un Gauge de almacenamiento

### Objetivo

Mostrar el porcentaje utilizado en `/`.

### Pasos

1. Crear un panel Gauge.
2. Introducir:

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

3. Configurar:

```text
Título: Uso del sistema de ficheros raíz
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
Decimales: 1
```

4. Configurar umbrales:

```text
0      Verde
80     Amarillo
90     Rojo
```

5. Comparar con:

```bash
df -h /
```

### Actividades

1. Identifica el valor mostrado.
2. Compara PromQL con `df -h`.
3. Explica por qué se excluyen `tmpfs` y `overlay`.
4. Añade una descripción.
5. Guarda una captura.

---

## Ejemplo de sesión 5: comparar escalas incorrectas y correctas

### Objetivo

Observar los problemas producidos por una escala incorrecta.

### Consulta

```promql
100 * avg(up)
```

### Configuración incorrecta

```text
Mínimo: 0
Máximo: 1
Unidad: Percent (0-100)
```

El Gauge puede mostrar una representación incorrecta porque la consulta devuelve valores entre `0` y `100`, pero la escala termina en `1`.

### Configuración correcta

```text
Mínimo: 0
Máximo: 100
Unidad: Percent (0-100)
```

### Actividades

1. Configura intencionadamente la escala incorrecta.
2. Observa el resultado.
3. Corrige el máximo.
4. Comprueba el cambio.
5. Explica la relación entre:
   - Consulta.
   - Unidad.
   - Escala.
   - Umbrales.

---

## Ejemplo de sesión 6: comparar uso y disponibilidad

### Objetivo

Comprender que una misma métrica puede tener interpretaciones diferentes según la consulta.

### Panel 1: memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Título:

```text
Memoria utilizada
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Panel 2: memoria disponible

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Título:

```text
Memoria disponible
```

Umbrales:

```text
0      Rojo
10     Amarillo
30     Verde
```

### Actividades

1. Crea ambos Gauges.
2. Colócalos juntos.
3. Compara los valores.
4. Comprueba que uno es aproximadamente el complemento del otro.
5. Explica por qué los umbrales deben invertirse.
6. Añade descripciones claras.

---

## Ejemplo de sesión 7: comparar Gauge y Bar Gauge

### Objetivo

Determinar qué visualización es más adecuada para uno o varios servidores.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Panel Gauge

Utilizarlo cuando:

```text
Solo se necesita mostrar un valor agregado.
```

### Panel Bar Gauge

Utilizarlo cuando:

```text
Se desea comparar el uso de CPU por instancia.
```

### Actividades

1. Crea un Gauge con una consulta agregada.
2. Crea un Bar Gauge con una serie por instancia.
3. Configura los mismos umbrales.
4. Compara ambos paneles.
5. Justifica cuál es más adecuado para:
   - Un resumen general.
   - Comparar servidores.
   - Analizar la evolución temporal.

---

## Ejemplo de sesión 8: diagnosticar un Gauge sin datos

### Objetivo

Identificar un problema de consulta o de conectividad.

### Consulta incorrecta

```promql
metrica_inexistente_para_gauge
```

### Pasos

1. Crear un panel Gauge.
2. Introducir la consulta incorrecta.
3. Observar el resultado.
4. Abrir el inspector del panel.
5. Revisar los datos devueltos.
6. Probar:

```promql
up
```

7. Probar:

```promql
node_memory_MemAvailable_bytes
```

8. Restaurar la consulta original.

### Actividades

Diferenciar entre:

```text
Valor 0
Sin datos
Error de consulta
Error de conexión
```

Documentar:

- Consulta utilizada.
- Resultado.
- Error observado.
- Diagnóstico.
- Solución aplicada.

---

## Ejemplo de sesión 9: crear un bloque de Gauges

### Objetivo

Crear un resumen visual de los recursos principales.

Crear los siguientes paneles:

| Panel | Consulta | Unidad |
|---|---|---|
| Disponibilidad global | `100 * avg(up)` | Percent |
| Uso de CPU | Consulta de CPU | Percent |
| Uso de memoria | Consulta de memoria | Percent |
| Uso de almacenamiento | Consulta de filesystem | Percent |

### Distribución

```text
+----------------------+-------------------------------+
| Disponibilidad       | Uso de CPU                    |
+----------------------+-------------------------------+
| Uso de memoria       | Uso de almacenamiento         |
+----------------------+-------------------------------+
```

### Actividades

1. Crea los cuatro Gauges.
2. Utiliza una escala de 0 a 100.
3. Configura umbrales coherentes.
4. Utiliza títulos descriptivos.
5. Añade descripciones.
6. Comprueba el dashboard en pantalla completa.
7. Guarda una captura.

---

## Ejemplo de sesión 10: verificar los valores mediante la API

### Objetivo

Comparar el valor mostrado en Grafana con el valor devuelto por Prometheus.

### Disponibilidad

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * avg(up)' \
  | jq
```

### Memoria utilizada

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)' \
  | jq
```

### Almacenamiento utilizado

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 * (1 - node_filesystem_avail_bytes{mountpoint="/",fstype!~"tmpfs|overlay"} / node_filesystem_size_bytes{mountpoint="/",fstype!~"tmpfs|overlay"})' \
  | jq
```

### Actividades

1. Ejecuta las consultas.
2. Compara los valores con Grafana.
3. Explica pequeñas diferencias temporales.
4. Comprueba que las unidades coinciden.
5. Guarda los resultados como evidencia.

---

## Buenas prácticas

### Utilizar siempre una escala coherente

Si la consulta devuelve porcentajes entre `0` y `100`:

```text
Mínimo: 0
Máximo: 100
```

### Explicar si el valor representa uso o disponibilidad

No es lo mismo:

```text
Memoria utilizada
```

que:

```text
Memoria disponible
```

Los umbrales pueden ser opuestos.

### Configurar títulos descriptivos

Utilizar:

```text
Uso de CPU
Uso de memoria
Uso del sistema de ficheros raíz
Disponibilidad global
```

### Mantener los mismos umbrales cuando las métricas sean comparables

Por ejemplo, CPU y memoria pueden utilizar:

```text
0      Verde
70     Amarillo
90     Rojo
```

Aunque los umbrales deben ajustarse al contexto.

### Combinar Gauges con Time series

El Gauge muestra el estado actual.

El Time series muestra la evolución.

Una combinación recomendada:

```text
Gauge: uso actual
Time series: tendencia de la última hora
```

### Evitar demasiados Gauges

Un dashboard lleno de indicadores puede resultar visualmente pesado.

Mostrar únicamente los indicadores principales.

### Documentar la unidad

El usuario debe saber si el valor representa:

- Porcentaje.
- Bytes.
- Bytes por segundo.
- Grados.
- Carga.
- Número absoluto.

### Probar valores normales y críticos

El panel debe revisarse con:

- Valor bajo.
- Valor intermedio.
- Valor alto.
- Objetivo caído.
- Sin datos.

---

## Problemas habituales

### El Gauge aparece vacío

Comprobar:

```promql
up
```

Después:

```promql
node_memory_MemAvailable_bytes
```

Revisar:

- Fuente de datos.
- Consulta.
- Rango temporal.
- Estado de los targets.
- Variables.
- Etiquetas.
- Inspector del panel.

### El indicador supera el máximo

Posibles causas:

- La consulta devuelve un porcentaje entre `0` y `1`, pero la unidad espera `0` a `100`.
- El máximo está configurado incorrectamente.
- La consulta no se ha multiplicado por `100`.
- Se ha aplicado una transformación incorrecta.

Ejemplo de ratio:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Ejemplo de porcentaje:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

### Todo aparece en rojo

Comprobar:

- Umbrales.
- Escala.
- Orden de los colores.
- Valor mínimo.
- Valor máximo.
- Tipo de métrica.

### El color parece invertido

Puede ocurrir cuando se muestra disponibilidad en lugar de uso.

Para uso:

```text
Valor alto: peor
```

Para disponibilidad:

```text
Valor alto: mejor
```

Los umbrales deben adaptarse al sentido del indicador.

### El Gauge muestra varias series

La consulta devuelve varios resultados.

Soluciones:

- Agregar la consulta.
- Filtrar por instancia.
- Utilizar Bar Gauge.
- Utilizar Time series.
- Configurar una reducción.

Ejemplo agregado:

```promql
avg(
  100 - (
    rate(node_cpu_seconds_total{mode="idle"}[5m]) * 100
  )
)
```

### La unidad no coincide con la consulta

Revisar si la consulta devuelve:

```text
0 - 1
```

o:

```text
0 - 100
```

No utilizar una unidad de porcentaje de 0 a 100 con una consulta que devuelve una proporción de 0 a 1 sin configurar correctamente la escala.

### El Gauge no muestra una tendencia

El Gauge no está diseñado para mostrar una evolución temporal detallada.

Utilizar un panel:

```text
Time series
```

como complemento.

### El valor parece antiguo

Comprobar:

- Última muestra.
- Estado del target.
- Intervalo de scraping.
- Rango temporal.
- Uso de datos no nulos.
- Fecha y hora del sistema.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-gauge
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-gauge/consultas-promql.txt <<'EOF'
Disponibilidad global:
100 * avg(up)

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

Carga del sistema:
node_load1

Tráfico recibido:
sum(
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
EOF
```

Guardar el resultado de la disponibilidad:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * avg(up)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-gauge/disponibilidad.json
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-gauge/informe.txt <<'EOF'
Práctica: Panel Gauge

Dashboard utilizado:

Gauges creados:

Consultas utilizadas:

Unidades configuradas:

Valores mínimos:

Valores máximos:

Umbrales configurados:

Prueba con carga de CPU:

Prueba de caída de Node Exporter:

Resultado de la recuperación:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-gauge-disponibilidad.png
02-gauge-cpu.png
03-gauge-memoria.png
04-gauge-almacenamiento.png
05-gauge-escala-correcta.png
06-gauge-escala-incorrecta.png
07-gauge-sin-datos.png
08-gauge-dashboard-final.png
```

---

## Práctica integradora

### Objetivo

Crear un dashboard compuesto por Gauges que muestre el estado actual de los principales recursos de un servidor Linux.

### Panel 1: disponibilidad

Consulta:

```promql
100 * avg(up)
```

Configuración:

```text
Título: Disponibilidad global
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Umbrales:

```text
0      Rojo
90     Amarillo
99     Verde
```

### Panel 2: CPU

Consulta:

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración:

```text
Título: Uso de CPU
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Panel 3: memoria

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
Título: Uso de memoria
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Panel 4: almacenamiento

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
Título: Uso del sistema de ficheros raíz
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Umbrales:

```text
0      Verde
80     Amarillo
90     Rojo
```

### Distribución propuesta

```text
+----------------------+-------------------------------+
| Disponibilidad       | Uso de CPU                    |
+----------------------+-------------------------------+
| Uso de memoria       | Uso de almacenamiento         |
+----------------------+-------------------------------+
```

### Tareas

1. Crear los cuatro Gauges.
2. Configurar las consultas.
3. Configurar las unidades.
4. Configurar los valores mínimos y máximos.
5. Configurar los umbrales.
6. Añadir títulos descriptivos.
7. Añadir descripciones.
8. Comparar los valores con el sistema operativo.
9. Generar carga de CPU.
10. Observar los cambios.
11. Detener Node Exporter.
12. Observar el Gauge de disponibilidad.
13. Iniciar Node Exporter.
14. Comprobar la recuperación.
15. Guardar capturas.
16. Exportar el dashboard.
17. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Gauge de disponibilidad creado | | |
| Gauge de CPU creado | | |
| Gauge de memoria creado | | |
| Gauge de almacenamiento creado | | |
| Fuente de datos correcta | | |
| Unidad configurada | | |
| Valor mínimo configurado | | |
| Valor máximo configurado | | |
| Umbrales configurados | | |
| Descripciones añadidas | | |
| Escala comprobada | | |
| Prueba de CPU realizada | | |
| Prueba de caída realizada | | |
| Recuperación comprobada | | |
| Dashboard exportado | | |
| Evidencias guardadas | | |

---

## Puntos clave

- El panel Gauge representa un valor dentro de un rango.
- Es adecuado para porcentajes, capacidades y niveles de utilización.
- La consulta, la unidad y la escala deben ser coherentes.
- Un porcentaje puede expresarse entre `0` y `100`.
- Una proporción puede expresarse entre `0` y `1`.
- Si la consulta devuelve una proporción, debe ajustarse la unidad o multiplicarse por `100`.
- Los valores mínimos y máximos definen la escala visual.
- Los umbrales dividen la escala en estados.
- El significado de los colores debe documentarse.
- Uso y disponibilidad tienen interpretaciones opuestas.
- Un Gauge es adecuado para un valor individual.
- Un Bar Gauge es más adecuado para comparar varias series.
- Un Time series es más adecuado para analizar tendencias.
- Los Gauges deben utilizar títulos descriptivos.
- Los decimales deben limitarse a la precisión necesaria.
- Un Gauge vacío puede deberse a una consulta, una fuente o un target con problemas.
- `0`, `No data` y `Error` representan situaciones diferentes.
- Los umbrales visuales no sustituyen necesariamente a las alertas.
- El dashboard debe probarse con valores normales y situaciones de error.
- La documentación de unidades, escalas y umbrales facilita el mantenimiento.

---

## Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Gauge?
2. ¿Qué diferencia existe entre un Gauge y un Stat?
3. ¿Qué diferencia existe entre un Gauge y un Bar Gauge?
4. ¿Qué diferencia existe entre un Gauge y un Time series?
5. ¿Qué tipo de métricas son adecuadas para un Gauge?
6. ¿Qué unidad utilizarías para representar el uso de CPU?
7. ¿Qué valores mínimos y máximos utilizarías para un porcentaje?
8. ¿Qué ocurre si una consulta devuelve valores entre `0` y `1` pero el Gauge está configurado entre `0` y `100`?
9. ¿Cómo convertirías una proporción en un porcentaje?
10. ¿Qué función cumplen los umbrales?
11. ¿Qué colores utilizarías para normal, advertencia y crítico?
12. ¿Por qué los umbrales de memoria utilizada y memoria disponible pueden ser diferentes?
13. ¿Qué consulta utilizarías para calcular el uso de memoria?
14. ¿Qué consulta utilizarías para calcular el uso del sistema de ficheros?
15. ¿Por qué se excluyen normalmente `tmpfs` y `overlay`?
16. ¿Qué revisarías si el Gauge aparece vacío?
17. ¿Qué revisarías si el Gauge aparece siempre en rojo?
18. ¿Qué diferencias existen entre `0`, `No data` y `Error`?
19. ¿Cuándo utilizarías un Bar Gauge en lugar de un Gauge?
20. ¿Cuándo utilizarías un Time series en lugar de un Gauge?
21. ¿Qué información incluirías en la descripción del panel?
22. ¿Por qué es importante configurar correctamente la unidad?
23. ¿Cómo comprobarías el valor mostrado por Grafana desde la terminal?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener un Gauge bien configurado?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear y configurar paneles Gauge coherentes y útiles.

El proceso completo será:

```text
Seleccionar una métrica
        |
        v
Crear una consulta PromQL
        |
        v
Determinar la escala del resultado
        |
        v
Seleccionar Gauge
        |
        v
Configurar unidad
        |
        v
Configurar mínimo y máximo
        |
        v
Configurar umbrales y colores
        |
        v
Añadir título y descripción
        |
        v
Probar valores normales y críticos
        |
        v
Guardar y documentar
```

El resultado final debe ser un conjunto de indicadores Gauge que permita conocer rápidamente el estado actual de la disponibilidad, la CPU, la memoria y el almacenamiento del sistema monitorizado.