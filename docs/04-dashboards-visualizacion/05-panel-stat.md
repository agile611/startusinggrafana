# Panel Stat

El panel **Stat** de Grafana permite representar un valor resumido de forma destacada.

Es adecuado para mostrar el estado actual de una métrica, un contador, un porcentaje o un indicador principal. Su objetivo es que el usuario pueda interpretar rápidamente una situación sin analizar un gráfico completo.

Ejemplos de información apropiada para un panel Stat:

- Número de objetivos disponibles.
- Porcentaje de disponibilidad.
- Cantidad de alertas activas.
- Memoria disponible.
- Número de servidores monitorizados.
- Estado de un servicio.
- Valor actual de una métrica.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Stat.
- Diferenciar un panel Stat de un Gauge o un Time series.
- Crear un panel Stat desde cero.
- Seleccionar una fuente de datos.
- Introducir consultas PromQL.
- Configurar la reducción de series.
- Mostrar el valor actual, mínimo, máximo o promedio.
- Configurar unidades y decimales.
- Configurar colores y umbrales.
- Utilizar mapas de valores.
- Configurar el texto de un panel Stat.
- Mostrar una mini-gráfica de tendencia.
- Configurar el comportamiento ante valores nulos.
- Interpretar los estados `No data`, `Null` y `Error`.
- Crear indicadores de disponibilidad.
- Crear indicadores de capacidad.
- Diagnosticar un panel Stat sin datos.
- Integrar paneles Stat en un dashboard operativo.

---

## Introducción

Un panel Stat muestra principalmente un valor reducido.

El flujo habitual es:

```text
Métricas de Prometheus
        |
        v
Consulta PromQL
        |
        v
Una o varias series
        |
        v
Reducción del resultado
        |
        v
Valor mostrado
        |
        v
Panel Stat
```

Por ejemplo, la consulta:

```promql
sum(up)
```

puede devolver:

```text
2
```

El panel Stat puede mostrar:

```text
2
```

con el título:

```text
Objetivos disponibles
```

Otro ejemplo:

```promql
100 * avg(up)
```

puede devolver:

```text
100
```

El panel Stat puede mostrarlo como:

```text
100 %
```

con el título:

```text
Disponibilidad global
```

El panel Stat está pensado para responder rápidamente a una pregunta concreta:

```text
¿Cuál es el valor actual?
```

No es la mejor visualización para analizar en detalle cómo ha evolucionado una métrica. Para eso suele ser más adecuado un panel **Time series**.

---

## Cuándo utilizar un panel Stat

El panel Stat es apropiado cuando:

- Se necesita mostrar un único valor.
- El valor actual es más importante que su evolución.
- Se quiere destacar un indicador principal.
- Se desea crear una tarjeta de resumen.
- El resultado debe interpretarse rápidamente.
- La métrica puede resumirse mediante una agregación.
- Se desea mostrar una tendencia pequeña junto al valor actual.

### Ejemplos adecuados

```promql
sum(up)
```

Número de objetivos disponibles.

```promql
count(up)
```

Número total de objetivos conocidos.

```promql
100 * avg(up)
```

Porcentaje medio de disponibilidad.

```promql
node_load1
```

Carga actual del sistema.

```promql
node_memory_MemAvailable_bytes
```

Memoria disponible.

```promql
count(node_cpu_seconds_total{mode="idle"})
```

Número de series de CPU en modo idle.

---

## Cuándo no utilizar un panel Stat

No suele ser la mejor opción cuando se necesita:

- Analizar una tendencia detallada.
- Comparar muchos puntos temporales.
- Mostrar muchas series.
- Observar picos y caídas.
- Consultar etiquetas de forma extensa.
- Ver la distribución de valores.
- Representar una relación compleja entre variables.

Para esos casos pueden ser más apropiados:

| Necesidad | Visualización recomendada |
|---|---|
| Evolución temporal | Time series |
| Comparación entre servidores | Bar Gauge o Table |
| Valor frente a un rango | Gauge |
| Datos con etiquetas | Table |
| Distribución | Heatmap |
| Texto contextual | Text |

---

## Anatomía de un panel Stat

Un panel Stat puede incluir los siguientes elementos:

```text
+--------------------------------------+
| Título                               |
|                                      |
|              85 %                    |
|                                      |
|     tendencia o sparkline            |
|                                      |
| Descripción o unidad                 |
+--------------------------------------+
```

### Título

Identifica el indicador.

Ejemplos:

```text
Objetivos disponibles
Disponibilidad global
Memoria libre
Carga del sistema
Alertas activas
```

### Valor principal

Es el dato más importante del panel.

Ejemplos:

```text
2
100 %
4.25 GiB
0
```

### Unidad

Aclara cómo debe interpretarse el valor.

Ejemplos:

```text
%
bytes
GiB
seconds
none
```

### Decimales

Controlan la precisión visual.

Ejemplo:

```text
85.4 %
```

en lugar de:

```text
85.437829 %
```

### Sparkline

Una sparkline es una pequeña representación de la evolución temporal del valor.

Permite mostrar:

- Si el valor está aumentando.
- Si está disminuyendo.
- Si permanece estable.
- Si ha tenido picos recientes.

La sparkline proporciona contexto, pero no sustituye a un gráfico temporal detallado.

### Umbrales

Cambian el color del valor según su magnitud.

Ejemplo:

```text
0     Verde
70    Amarillo
90    Rojo
```

### Mapa de valores

Permite sustituir valores numéricos por texto.

Ejemplo:

```text
1 → ACTIVO
0 → CAÍDO
```

### Texto de valor

Puede configurarse para mostrar:

- El valor.
- El nombre de la métrica.
- El nombre corto.
- El nombre y el valor.
- Un texto definido mediante un mapa de valores.

---

## Diferencia entre Stat y Gauge

Ambos pueden mostrar un valor resumido, pero tienen objetivos diferentes.

| Característica | Stat | Gauge |
|---|---|---|
| Valor resumido | Muy adecuado | Adecuado |
| Comparación con un rango | Mediante color | Visual y explícita |
| Mostrar valor actual | Sí | Sí |
| Mostrar mini-tendencia | Sí | Normalmente no es su función principal |
| Mostrar límites | Mediante configuración | Parte central de la visualización |
| Comparar muchos elementos | Limitado | Bar Gauge suele ser mejor |
| Uso en tarjetas de resumen | Muy adecuado | Menos habitual |

### Ejemplo

Para mostrar el número de objetivos:

```promql
sum(up)
```

Utilizar:

```text
Stat
```

Para mostrar el porcentaje de memoria utilizado con relación a un rango de 0 a 100:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Puede utilizarse:

```text
Gauge
```

---

## Diferencia entre Stat y Time series

El panel Stat muestra principalmente el valor reducido actual.

El panel Time series muestra cómo cambia el valor a lo largo del tiempo.

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

Una buena práctica consiste en utilizar ambos paneles cuando se necesita resumen y contexto:

```text
Panel Stat: valor actual
Panel Time series: evolución temporal
```

---

## Crear un panel Stat

### Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar la fuente de datos Prometheus.
5. Introducir una consulta.
6. Seleccionar la visualización `Stat`.
7. Configurar el cálculo del valor.
8. Configurar la unidad.
9. Configurar los decimales.
10. Configurar los umbrales.
11. Añadir una descripción.
12. Revisar el resultado.
13. Guardar el panel.
14. Guardar el dashboard.

### Consulta inicial

Para una primera prueba, utilizar:

```promql
sum(up)
```

Configuración recomendada:

```text
Título: Objetivos disponibles
Visualización: Stat
Unidad: None
Decimales: 0
```

---

## Configurar la reducción de datos

Una consulta puede devolver varias series o varios valores.

El panel Stat necesita decidir qué valor debe mostrar.

Para ello se utiliza una reducción.

### Reducciones habituales

| Reducción | Función |
|---|---|
| Last | Último valor |
| Last not null | Último valor que no sea nulo |
| Mean | Promedio |
| Min | Valor mínimo |
| Max | Valor máximo |
| Sum | Suma |
| Count | Número de valores |
| First | Primer valor |
| Range | Diferencia entre máximo y mínimo |

### Ejemplo con varias series

Consulta:

```promql
up
```

Puede devolver:

```text
prometheus      1
node_exporter   1
```

Si el panel utiliza `Last`, mostrará uno de los últimos valores.

Si se desea mostrar el total disponible, es más claro modificar la consulta:

```promql
sum(up)
```

La consulta ya devuelve un único valor:

```text
2
```

### Recomendación

Cuando sea posible, preparar el resultado desde PromQL.

Ejemplos:

```promql
sum(up)
```

```promql
100 * avg(up)
```

```promql
max(node_load1)
```

Esto hace que el propósito del panel sea más explícito.

---

## Configurar el valor actual

Para mostrar el valor más reciente, utilizar una reducción equivalente a:

```text
Last
```

o:

```text
Last not null
```

### Diferencia

#### Last

Muestra el último valor recibido, aunque pueda ser nulo según el resultado.

#### Last not null

Busca el último valor disponible que no sea nulo.

Para indicadores operativos suele ser preferible:

```text
Last not null
```

Sin embargo, no debe ocultarse indefinidamente la ausencia de datos. Un panel que conserva un valor antiguo puede dar una falsa sensación de normalidad.

---

## Configurar la unidad

### Disponibilidad como número

Consulta:

```promql
sum(up)
```

Unidad:

```text
None
```

### Disponibilidad como porcentaje

Consulta:

```promql
100 * avg(up)
```

Unidad:

```text
Percent (0-100)
```

### Memoria disponible

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Unidad:

```text
Bytes (IEC)
```

### Carga del sistema

Consulta:

```promql
node_load1
```

Unidad:

```text
None
```

### Tráfico de red

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

---

## Configurar decimales

La cantidad de decimales debe adaptarse al dato.

### Ejemplos

```text
Objetivos disponibles: 0 decimales
Disponibilidad: 1 o 2 decimales
Carga del sistema: 2 decimales
Memoria: automático
Tráfico: 1 o 2 decimales
```

### Ejemplo incorrecto

```text
Disponibilidad global: 99.837492 %
```

### Ejemplo recomendado

```text
Disponibilidad global: 99.8 %
```

Los decimales innecesarios dificultan la lectura y no siempre aportan precisión útil.

---

## Configurar colores y umbrales

El panel Stat puede cambiar de color según:

- Umbral.
- Valor de texto.
- Estado.
- Configuración fija.

### Ejemplo: disponibilidad

Consulta:

```promql
100 * avg(up)
```

Configuración:

```text
0      Rojo
90     Amarillo
99     Verde
```

Interpretación:

```text
0 - 89.99 %    Crítico
90 - 98.99 %   Advertencia
99 - 100 %     Normal
```

### Ejemplo: objetivos disponibles

Consulta:

```promql
sum(up)
```

Si se conoce el número esperado de objetivos, se pueden definir umbrales.

Supongamos que se esperan dos objetivos:

```text
0      Rojo
1      Amarillo
2      Verde
```

### Ejemplo: uso de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Umbrales:

```text
0      Verde
70     Amarillo
90     Rojo
```

### Consideración importante

Los umbrales de un panel comunican visualmente un estado, pero no sustituyen necesariamente una regla de alerta.

---

## Configurar mapas de valores

Los mapas de valores permiten presentar un valor técnico como un texto comprensible.

### Mapa básico de disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Mapa:

```text
1 → UP
0 → DOWN
```

El panel puede mostrar:

```text
UP
```

o:

```text
DOWN
```

### Mapa con colores

Configurar:

```text
UP   → verde
DOWN → rojo
```

### Ventajas

- Mejora la interpretación.
- Reduce la dependencia de números.
- Facilita la lectura para usuarios no técnicos.
- Permite crear indicadores operativos.

### Precauciones

- El mapa debe cubrir los valores esperados.
- Los valores no contemplados deben tener un comportamiento claro.
- No se debe ocultar información importante.
- Debe documentarse el significado de cada estado.

---

## Configurar el nombre del campo

Cuando la consulta devuelve una serie con etiquetas, el panel puede mostrar un nombre automático poco claro.

Ejemplo:

```text
{instance="localhost:9100", job="node_exporter"}
```

Es preferible configurar un nombre más comprensible:

```text
Node Exporter
```

o utilizar una plantilla basada en etiquetas:

```text
{{job}}
```

Para una consulta agrupada por instancia:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Se puede utilizar:

```text
{{instance}}
```

---

## Configurar una sparkline

La sparkline muestra una pequeña tendencia junto al valor principal.

Es útil para detectar:

- Incrementos recientes.
- Descensos.
- Oscilaciones.
- Cambios bruscos.
- Estabilidad.

### Ejemplo

Consulta:

```promql
node_load1
```

Configuración:

```text
Visualización: Stat
Sparkline: Activada
Título: Carga actual del sistema
Unidad: None
Decimales: 2
```

La sparkline no debe interpretarse como un sustituto de un gráfico temporal.

Para analizar con detalle la evolución, utilizar un panel Time series.

---

## Configurar el texto mostrado

El panel Stat puede mostrar diferentes combinaciones de información.

Opciones habituales:

```text
Value
Name
Value and name
```

### Solo valor

```text
2
```

Útil cuando el título del panel ya explica el significado.

### Nombre y valor

```text
Objetivos disponibles: 2
```

Útil cuando el panel se consulta fuera del contexto habitual.

### Texto mediante mapa de valores

```text
UP
```

Útil para representar estados.

---

## Configurar el comportamiento ante ausencia de datos

Un panel Stat puede encontrarse en diferentes situaciones.

### Valor cero

El valor real es `0`.

Ejemplo:

```promql
sum(up)
```

Resultado:

```text
0
```

Esto no significa necesariamente que no haya datos. Significa que la suma de los valores es cero.

### Sin datos

La consulta no devuelve ninguna serie.

Ejemplo:

```promql
metrica_que_no_existe
```

### Valor nulo

Existe una serie, pero el valor no está disponible en el punto consultado.

### Error

La consulta, la fuente de datos o la conexión producen un error.

### Importancia operativa

No se debe confundir:

```text
0
```

con:

```text
No data
```

Por ejemplo:

- `0 objetivos disponibles` puede ser un resultado válido.
- `No data` puede indicar un problema de consulta o conectividad.

---

## Consultas para paneles Stat

### Objetivos disponibles

```promql
sum(up)
```

### Objetivos totales

```promql
count(up)
```

### Objetivos caídos

```promql
count(up == 0)
```

### Porcentaje de disponibilidad

```promql
100 * avg(up)
```

### Objetivos de Node Exporter disponibles

```promql
sum(up{job="node_exporter"})
```

### Estado de Node Exporter

```promql
up{job="node_exporter"}
```

### Memoria disponible

```promql
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

### Carga de un minuto

```promql
node_load1
```

### Carga de cinco minutos

```promql
node_load5
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
sum(
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

---

## Ejemplo completo 1: objetivos disponibles

### Objetivo

Crear un panel Stat que muestre cuántos objetivos están disponibles.

### Consulta

```promql
sum(up)
```

### Configuración

```text
Título: Objetivos disponibles
Visualización: Stat
Unidad: None
Decimales: 0
Reducción: Last
```

### Umbrales

Si se esperan dos objetivos:

```text
0      Rojo
1      Amarillo
2      Verde
```

### Descripción

```text
Número de objetivos cuyo último scraping ha sido correcto.
El valor se obtiene sumando la métrica up.
```

### Resultado esperado

```text
2
```

---

## Ejemplo completo 2: disponibilidad global

### Objetivo

Mostrar la disponibilidad global como porcentaje.

### Consulta

```promql
100 * avg(up)
```

### Configuración

```text
Título: Disponibilidad global
Visualización: Stat
Unidad: Percent (0-100)
Decimales: 1
Min: 0
Max: 100
```

### Umbrales

```text
0      Rojo
90     Amarillo
99     Verde
```

### Descripción

```text
Porcentaje medio de objetivos disponibles en el último scraping.
```

### Resultado esperado

```text
100.0 %
```

si todos los objetivos están disponibles.

---

## Ejemplo completo 3: uso de memoria

### Objetivo

Mostrar el porcentaje actual de memoria utilizada.

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
Título: Memoria utilizada
Visualización: Stat
Unidad: Percent (0-100)
Decimales: 1
Min: 0
Max: 100
Sparkline: Activada
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
Los valores superiores al 90 % requieren una revisión del consumo de memoria.
```

---

## Ejemplo completo 4: estado textual de Node Exporter

### Objetivo

Mostrar `UP` o `DOWN` en lugar de `1` o `0`.

### Consulta

```promql
up{job="node_exporter"}
```

### Configuración

```text
Título: Estado de Node Exporter
Visualización: Stat
```

### Mapa de valores

```text
1 → UP
0 → DOWN
```

### Colores

```text
UP   → Verde
DOWN → Rojo
```

### Descripción

```text
Estado del último scraping realizado sobre Node Exporter.
UP indica que Prometheus ha podido consultar el endpoint de métricas.
DOWN indica que el último scraping ha fallado.
```

---

## Ejemplo completo 5: carga del sistema

### Objetivo

Mostrar la carga actual del sistema.

### Consulta

```promql
node_load1
```

### Configuración

```text
Título: Carga del sistema
Visualización: Stat
Unidad: None
Decimales: 2
Sparkline: Activada
```

### Descripción

```text
Carga media del sistema durante el último minuto.
Este valor no es un porcentaje de CPU.
```

### Consideración

La carga del sistema debe interpretarse teniendo en cuenta el número de CPU disponibles.

Consultar el número de CPU:

```promql
count(
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

Esta consulta puede devolver una serie por CPU y por instancia. Para calcular el número de CPU por instancia:

```promql
count by (instance) (
  node_cpu_seconds_total{
    mode="idle"
  }
)
```

---

## Ejemplo de sesión 1: crear un Stat básico

### Objetivo

Crear un panel que muestre el número de objetivos disponibles.

### Pasos

1. Acceder a Grafana:

```text
http://localhost:3000
```

2. Abrir un dashboard existente o crear uno nuevo.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir:

```promql
sum(up)
```

6. Seleccionar la visualización `Stat`.
7. Configurar el título:

```text
Objetivos disponibles
```

8. Configurar la unidad como `None`.
9. Configurar los decimales a `0`.
10. Guardar el panel.
11. Guardar el dashboard.

### Actividades

1. Anota el valor mostrado.
2. Compáralo con la consulta:

```promql
up
```

3. Comprueba cuántas series devuelve `up`.
4. Explica por qué `sum(up)` devuelve un único valor.
5. Añade una descripción al panel.

---

## Ejemplo de sesión 2: crear una disponibilidad porcentual

### Objetivo

Crear un panel Stat que muestre la disponibilidad global.

### Consulta

```promql
100 * avg(up)
```

### Pasos

1. Añadir un panel nuevo.
2. Seleccionar Prometheus.
3. Introducir la consulta.
4. Seleccionar `Stat`.
5. Configurar:

```text
Título: Disponibilidad global
Unidad: Percent (0-100)
Decimales: 1
Min: 0
Max: 100
```

6. Configurar umbrales:

```text
0      Rojo
90     Amarillo
99     Verde
```

7. Activar la sparkline.
8. Guardar el panel.
9. Guardar el dashboard.

### Actividades

1. Comprueba el valor actual.
2. Detén Node Exporter:

```bash
sudo systemctl stop node_exporter
```

3. Espera al siguiente scraping.
4. Observa el valor.
5. Inicia Node Exporter:

```bash
sudo systemctl start node_exporter
```

6. Comprueba la recuperación.
7. Explica cómo cambia el color.

---

## Ejemplo de sesión 3: configurar un mapa de valores

### Objetivo

Representar el estado de Node Exporter como `UP` o `DOWN`.

### Consulta

```promql
up{job="node_exporter"}
```

### Pasos

1. Crear un panel Stat.
2. Introducir la consulta.
3. Configurar el título:

```text
Estado de Node Exporter
```

4. Crear el mapa:

```text
1 → UP
0 → DOWN
```

5. Configurar colores:

```text
UP   → Verde
DOWN → Rojo
```

6. Guardar el panel.

### Actividades

1. Comprueba el estado inicial.
2. Detén Node Exporter.
3. Espera al siguiente scraping.
4. Comprueba que aparece `DOWN`.
5. Inicia Node Exporter.
6. Comprueba que vuelve a aparecer `UP`.
7. Documenta el tiempo aproximado de detección.

---

## Ejemplo de sesión 4: añadir una sparkline

### Objetivo

Mostrar el valor actual y una tendencia reciente.

### Consulta

```promql
node_load1
```

### Pasos

1. Crear un panel Stat.
2. Introducir la consulta.
3. Seleccionar la visualización Stat.
4. Configurar:

```text
Título: Carga actual
Unidad: None
Decimales: 2
Sparkline: Activada
```

5. Guardar el panel.
6. Generar carga temporal:

```bash
yes > /dev/null &
```

7. Observar la sparkline.
8. Detener la carga:

```bash
pkill yes
```

9. Observar la recuperación.

### Actividades

1. Describe la forma de la sparkline.
2. Indica si el valor aumenta o disminuye.
3. Explica qué información aporta la sparkline.
4. Explica qué información adicional ofrecería un Time series.

---

## Ejemplo de sesión 5: comparar Stat y Gauge

### Objetivo

Comparar dos formas de representar el mismo indicador.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Panel 1: Stat

```text
Título: Memoria utilizada
Visualización: Stat
Unidad: Percent (0-100)
Decimales: 1
```

### Panel 2: Gauge

```text
Título: Memoria utilizada
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

### Actividades

1. Crea ambos paneles.
2. Colócalos juntos.
3. Configura los mismos umbrales.
4. Compara la legibilidad.
5. Explica cuál elegirías para:
   - Un resumen ejecutivo.
   - Un dashboard operativo.
   - Un análisis de capacidad.
6. Justifica la respuesta.

---

## Ejemplo de sesión 6: diagnosticar un Stat sin datos

### Objetivo

Identificar la causa de un panel Stat vacío.

### Consulta incorrecta

```promql
metrica_de_prueba_inexistente
```

### Pasos

1. Crear un panel Stat.
2. Introducir la consulta incorrecta.
3. Observar el resultado.
4. Abrir el inspector del panel.
5. Revisar la consulta ejecutada.
6. Revisar la respuesta.
7. Sustituir la consulta por:

```promql
up
```

8. Comprobar que aparecen datos.
9. Guardar el panel corregido.

### Actividades

Explicar la diferencia entre:

```text
Valor 0
No data
Error
```

Comprobar también:

```promql
sum(up)
```

y:

```promql
count(up)
```

Documentar qué representa cada resultado.

---

## Ejemplo de sesión 7: crear varios indicadores

### Objetivo

Crear un bloque de indicadores resumidos.

Crear los siguientes paneles Stat:

| Título | Consulta | Unidad |
|---|---|---|
| Objetivos disponibles | `sum(up)` | None |
| Disponibilidad global | `100 * avg(up)` | Percent |
| Memoria utilizada | Consulta de memoria | Percent |
| Carga del sistema | `node_load1` | None |
| Tráfico recibido | Consulta de red | bytes/sec |

### Distribución

```text
+----------------------+----------------------+----------------------+
| Objetivos disponibles| Disponibilidad global| Memoria utilizada    |
+----------------------+----------------------+----------------------+
| Carga del sistema    | Tráfico recibido     | Estado Node Exporter |
+----------------------+----------------------+----------------------+
```

### Actividades

1. Crea los paneles.
2. Configura los títulos.
3. Configura las unidades.
4. Configura los decimales.
5. Configura los umbrales.
6. Activa sparklines donde sea útil.
7. Ordena los indicadores.
8. Comprueba que todos muestran datos.
9. Guarda el dashboard.

---

## Ejemplo de sesión 8: utilizar un Stat con una variable

### Objetivo

Crear un panel que cambie según la instancia seleccionada.

### Crear la variable

Crear una variable de dashboard llamada:

```text
instance
```

Consulta de variable:

```promql
label_values(up, instance)
```

Según la versión y la configuración de Grafana, puede ser necesario utilizar una consulta compatible con el editor de variables.

### Consulta del panel

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

### Configuración

```text
Título: Memoria utilizada - $instance
Visualización: Stat
Unidad: Percent (0-100)
```

### Actividades

1. Crea la variable.
2. Comprueba las instancias disponibles.
3. Crea el panel.
4. Cambia de instancia.
5. Observa cómo cambia el valor.
6. Comprueba el comportamiento con `All`.
7. Documenta el uso de la variable.

---

## Ejemplo de sesión 9: verificar el valor desde la API de Prometheus

### Objetivo

Comparar el valor mostrado en Grafana con el valor devuelto por Prometheus.

### Consultar objetivos disponibles

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=sum(up)' \
  | jq
```

### Consultar disponibilidad

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * avg(up)' \
  | jq
```

### Mostrar únicamente el valor

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=sum(up)' \
  | jq -r '.data.result[0].value[1]'
```

### Actividades

1. Consulta el valor desde Grafana.
2. Consulta el valor desde la API.
3. Compara ambos resultados.
4. Explica posibles pequeñas diferencias temporales.
5. Documenta la comprobación.

---

## Buenas prácticas

### Utilizar una consulta que devuelva un resultado claro

Un panel Stat funciona mejor cuando la consulta devuelve un único valor.

Ejemplo:

```promql
sum(up)
```

Es más claro que mostrar directamente muchas series y depender de una reducción poco evidente.

### Configurar la unidad

Nunca dejar ambiguo un porcentaje, una cantidad de memoria o una velocidad de red.

### No ocultar problemas con valores antiguos

Si se utiliza `Last not null`, revisar qué ocurre cuando la fuente deja de enviar datos.

Un valor antiguo puede parecer actual si no se comunica correctamente su antigüedad.

### Utilizar títulos operativos

El título debe permitir entender el panel sin abrirlo.

### Utilizar umbrales coherentes

Aplicar una misma convención en todos los paneles del dashboard.

### Activar sparklines con moderación

Las sparklines son útiles para añadir contexto, pero no deben sustituir a un análisis temporal detallado.

### No mostrar demasiados Stat juntos

Un conjunto excesivo de indicadores puede saturar visualmente el dashboard.

Agrupar únicamente los indicadores más importantes.

### Combinar Stat con otras visualizaciones

Una buena combinación puede ser:

```text
Stat: valor actual
Time series: tendencia
Table: detalle por instancia
```

---

## Problemas habituales

### El Stat muestra `No data`

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
- Variables.
- Etiquetas.
- Estado de los targets.
- Inspector del panel.

### El Stat muestra cero

Determinar si el cero es válido.

Ejemplo:

```promql
sum(up)
```

Si todos los objetivos están caídos, el resultado puede ser:

```text
0
```

Esto es diferente de una consulta sin resultados.

### El Stat muestra un valor inesperado

Comprobar:

- Reducción.
- Agregación.
- Unidad.
- Decimales.
- Filtros.
- Rango temporal.
- Variables.

### El Stat muestra demasiados valores

La consulta puede devolver varias series.

Soluciones:

```promql
sum(up)
```

```promql
avg(up)
```

```promql
max(node_load1)
```

También se puede configurar una reducción, pero conviene comprender primero las series devueltas.

### El color no cambia

Revisar:

- Que los umbrales estén activados.
- Que el modo de color utilice los umbrales.
- Que los valores estén en la misma escala.
- Que la consulta devuelva un porcentaje si los umbrales están definidos de 0 a 100.
- Que el panel no utilice un mapa de valores que sobrescriba el comportamiento esperado.

### La unidad aparece duplicada

Ejemplo:

```text
85 % %
```

Comprobar que:

- La consulta no añade texto manualmente.
- La unidad está configurada una sola vez.
- El mapa de valores no incluye el símbolo `%`.

### La sparkline no aparece

Revisar:

- Que la consulta devuelva datos temporales.
- Que el rango temporal tenga muestras.
- Que la sparkline esté activada.
- Que el panel no esté configurado únicamente para una consulta instantánea.
- Que el resultado no sea exclusivamente un valor calculado sin historial.

### El Stat muestra datos antiguos

Revisar:

- Timestamp de la última muestra.
- Intervalo de scraping.
- Estado del target.
- Uso de `Last not null`.
- Rango temporal.
- Disponibilidad de la fuente de datos.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-stat
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-stat/consultas-promql.txt <<'EOF'
Objetivos disponibles:
sum(up)

Objetivos totales:
count(up)

Objetivos caídos:
count(up == 0)

Disponibilidad global:
100 * avg(up)

Estado de Node Exporter:
up{job="node_exporter"}

Uso de memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
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

Guardar una consulta desde la API:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=sum(up)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-stat/resultado-sum-up.json
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-stat/informe.txt <<'EOF'
Práctica: Panel Stat

Dashboard utilizado:

Paneles creados:

Consultas utilizadas:

Unidades configuradas:

Umbrales configurados:

Mapas de valores utilizados:

Sparklines configuradas:

Prueba de caída realizada:

Resultado de la recuperación:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-stat-objetivos-disponibles.png
02-stat-disponibilidad.png
03-stat-memoria.png
04-stat-estado-node-exporter.png
05-stat-con-sparkline.png
06-stat-sin-datos.png
07-stat-dashboard-final.png
```

---

## Práctica integradora

### Objetivo

Crear un conjunto de paneles Stat para resumir el estado de un servidor Linux.

### Paneles obligatorios

#### Panel 1: objetivos disponibles

```promql
sum(up)
```

Configuración:

```text
Título: Objetivos disponibles
Unidad: None
Decimales: 0
```

#### Panel 2: disponibilidad global

```promql
100 * avg(up)
```

Configuración:

```text
Título: Disponibilidad global
Unidad: Percent (0-100)
Decimales: 1
Min: 0
Max: 100
```

#### Panel 3: uso de memoria

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
Título: Memoria utilizada
Unidad: Percent (0-100)
Decimales: 1
Min: 0
Max: 100
```

#### Panel 4: estado de Node Exporter

```promql
up{job="node_exporter"}
```

Configuración:

```text
Título: Estado de Node Exporter
Mapa: 1 = UP, 0 = DOWN
```

#### Panel 5: carga del sistema

```promql
node_load1
```

Configuración:

```text
Título: Carga actual del sistema
Unidad: None
Decimales: 2
Sparkline: Activada
```

### Tareas

1. Crear los cinco paneles.
2. Configurar los títulos.
3. Configurar las unidades.
4. Configurar los decimales.
5. Configurar los umbrales.
6. Crear el mapa de valores de Node Exporter.
7. Activar una sparkline.
8. Organizar los paneles.
9. Detener Node Exporter.
10. Observar los cambios.
11. Iniciar Node Exporter.
12. Comprobar la recuperación.
13. Exportar el dashboard.
14. Guardar las evidencias.
15. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Panel de objetivos creado | | |
| Panel de disponibilidad creado | | |
| Panel de memoria creado | | |
| Panel de Node Exporter creado | | |
| Panel de carga creado | | |
| Fuente de datos correcta | | |
| Unidad configurada | | |
| Decimales configurados | | |
| Umbrales configurados | | |
| Mapa de valores configurado | | |
| Sparkline configurada | | |
| Paneles organizados | | |
| Prueba de caída realizada | | |
| Recuperación comprobada | | |
| Dashboard exportado | | |
| Evidencias guardadas | | |

---

## Puntos clave

- El panel Stat muestra principalmente un valor resumido.
- Es adecuado para indicadores actuales y tarjetas de resumen.
- Una consulta que devuelve un único valor suele ser más fácil de interpretar.
- `sum(up)` muestra el número de objetivos disponibles.
- `100 * avg(up)` muestra un porcentaje medio de disponibilidad.
- La reducción determina qué valor se representa cuando existen varias muestras.
- `Last not null` puede ser útil, pero puede ocultar la antigüedad del dato.
- Las unidades deben corresponder al significado de la métrica.
- Los decimales deben limitarse a la precisión necesaria.
- Los umbrales permiten cambiar el color según el valor.
- Los mapas de valores permiten mostrar textos como `UP` y `DOWN`.
- Las sparklines aportan contexto temporal resumido.
- Un Stat no sustituye a un panel Time series.
- `0`, `No data` y `Error` son situaciones diferentes.
- El panel debe probarse con datos disponibles y con objetivos caídos.
- La consulta, la fuente de datos y el rango temporal deben revisarse ante un panel vacío.
- Los paneles Stat funcionan bien como resumen superior de un dashboard.
- La información detallada debe mostrarse mediante otras visualizaciones.
- La documentación del panel facilita su mantenimiento.
- Los cambios importantes deben guardarse y exportarse cuando sea necesario.

---

## Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Stat?
2. ¿Qué tipo de información representa mejor?
3. ¿Qué diferencia existe entre un panel Stat y un Gauge?
4. ¿Qué diferencia existe entre un panel Stat y un Time series?
5. ¿Qué consulta utilizarías para contar los objetivos disponibles?
6. ¿Qué consulta utilizarías para calcular la disponibilidad global?
7. ¿Qué función cumple una reducción?
8. ¿Qué diferencia existe entre `Last` y `Last not null`?
9. ¿Qué unidad utilizarías para un porcentaje de memoria?
10. ¿Qué unidad utilizarías para la memoria disponible en bytes?
11. ¿Qué función cumplen los umbrales?
12. ¿Qué es un mapa de valores?
13. ¿Cómo representarías los valores `1` y `0` como `UP` y `DOWN`?
14. ¿Qué utilidad tiene una sparkline?
15. ¿Qué diferencia existe entre `0` y `No data`?
16. ¿Qué revisarías si el panel Stat aparece vacío?
17. ¿Qué problemas puede producir una consulta con varias series?
18. ¿Cuándo utilizarías `sum(up)` en lugar de `up`?
19. ¿Por qué no conviene utilizar demasiados decimales?
20. ¿Qué elementos configurarías antes de guardar un panel Stat?
21. ¿Qué comprobarías al detener Node Exporter?
22. ¿Qué información incluirías en la descripción de un panel Stat?
23. ¿Qué paneles combinarías con un Stat para aportar contexto?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener un buen indicador Stat?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear indicadores resumidos y configurarlos correctamente.

El proceso completo será:

```text
Seleccionar una métrica
        |
        v
Crear una consulta PromQL
        |
        v
Reducir el resultado
        |
        v
Seleccionar Stat
        |
        v
Configurar unidad y decimales
        |
        v
Configurar umbrales
        |
        v
Añadir mapa de valores o sparkline
        |
        v
Probar datos normales y errores
        |
        v
Guardar y documentar
```

El resultado final debe ser un conjunto de paneles Stat claros, legibles y útiles para conocer rápidamente el estado actual de la plataforma monitorizada.