# Manipulación de paneles

La manipulación de paneles comprende todas las operaciones necesarias para crear, configurar, organizar, duplicar, mover, redimensionar y eliminar paneles dentro de un dashboard de Grafana.

Un panel no es únicamente un gráfico. Está formado por varios elementos relacionados:

```text
Consulta
   |
   v
Fuente de datos
   |
   v
Transformaciones
   |
   v
Visualización
   |
   v
Opciones del panel
   |
   v
Panel dentro del dashboard
```

Durante esta sección se aprenderá a modificar paneles de forma controlada y a construir dashboards claros, ordenados y fáciles de mantener.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Crear un panel nuevo.
- Seleccionar una fuente de datos.
- Introducir y probar consultas PromQL.
- Cambiar el tipo de visualización.
- Modificar el título de un panel.
- Añadir una descripción.
- Configurar unidades y decimales.
- Configurar umbrales y colores.
- Configurar leyendas.
- Mover paneles dentro de un dashboard.
- Redimensionar paneles.
- Duplicar paneles.
- Copiar paneles entre dashboards.
- Eliminar paneles.
- Deshacer cambios cuando sea posible.
- Guardar correctamente un dashboard.
- Utilizar el inspector de paneles.
- Diagnosticar paneles sin datos.
- Organizar paneles según su importancia.
- Documentar los cambios realizados.
- Exportar un dashboard como copia de seguridad.

---

## Introducción

Un dashboard de Grafana se construye mediante paneles. Cada panel representa una consulta o un conjunto de consultas y muestra el resultado mediante una visualización.

Un panel puede mostrar:

- Un único valor.
- Una serie temporal.
- Una tabla.
- Una comparación entre servidores.
- Un indicador de porcentaje.
- Una distribución de valores.
- Texto explicativo.
- Un diseño visual personalizado.

La manipulación de paneles permite adaptar el dashboard a las necesidades de cada usuario.

Por ejemplo, una consulta de disponibilidad puede mostrarse como:

```promql
up
```

Esta consulta puede representarse mediante:

- Una tabla para conocer cada objetivo.
- Un panel Stat para mostrar el número total de objetivos.
- Un Gauge para mostrar el porcentaje de disponibilidad.
- Un Bar Gauge para comparar varias instancias.

La consulta puede ser la misma, pero la visualización y el objetivo del panel son diferentes.

---

# Ciclo de vida de un panel

El ciclo habitual de un panel es:

```text
Crear
  |
  v
Configurar fuente de datos
  |
  v
Introducir consulta
  |
  v
Seleccionar visualización
  |
  v
Configurar opciones
  |
  v
Probar datos
  |
  v
Organizar posición
  |
  v
Guardar dashboard
  |
  v
Documentar cambios
```

## Crear

Se añade un panel nuevo a un dashboard existente.

## Configurar

Se seleccionan:

- Fuente de datos.
- Consulta.
- Visualización.
- Unidades.
- Umbrales.
- Leyenda.
- Título.
- Descripción.

## Probar

Se comprueba que:

- La consulta es válida.
- El panel muestra datos.
- La unidad es correcta.
- Los colores tienen sentido.
- El rango temporal es adecuado.

## Organizar

Se decide:

- Dónde colocar el panel.
- Qué tamaño debe tener.
- Con qué paneles debe agruparse.
- Qué información debe aparecer antes.

## Guardar

Los cambios deben guardarse en el dashboard.

---

# Partes principales de un panel

## Título

El título identifica el propósito del panel.

Evitar:

```text
Panel nuevo
Consulta 1
Gráfico
```

Utilizar:

```text
Uso de CPU por instancia
Estado de los objetivos
Memoria disponible
Espacio utilizado en /
```

## Descripción

La descripción proporciona contexto adicional.

Ejemplo:

```text
Porcentaje de CPU utilizado durante los últimos cinco minutos.
El cálculo excluye el tiempo de CPU en modo idle.
```

Una descripción útil debe responder:

- ¿Qué representa el panel?
- ¿Qué unidad utiliza?
- ¿Qué rango temporal se emplea?
- ¿Qué significa un valor elevado?
- ¿Qué acción debe realizarse?

## Fuente de datos

La fuente de datos indica de dónde obtiene Grafana la información.

En este módulo se utilizará principalmente:

```text
Prometheus
```

URL habitual:

```text
http://localhost:9090
```

## Consulta

La consulta obtiene los valores que se mostrarán.

Ejemplo:

```promql
node_load1
```

## Visualización

La visualización determina cómo se representan los datos.

Ejemplos:

```text
Stat
Gauge
Bar Gauge
Time series
Table
Heatmap
Text
Canvas
```

## Opciones

Las opciones controlan el aspecto y el comportamiento del panel.

Entre ellas:

- Unidad.
- Decimales.
- Min.
- Max.
- Umbrales.
- Colores.
- Leyenda.
- Ejes.
- Orientación.
- Apilamiento.
- Puntos.
- Líneas.
- Transparencia.

## Transformaciones

Las transformaciones modifican el resultado antes de mostrarlo.

Pueden utilizarse para:

- Renombrar campos.
- Ocultar columnas.
- Filtrar resultados.
- Ordenar datos.
- Combinar consultas.
- Crear campos calculados.

---

# Crear un panel

## Procedimiento general

1. Abrir Grafana.
2. Acceder a un dashboard.
3. Seleccionar la opción para añadir un panel.
4. Seleccionar la fuente de datos.
5. Introducir la consulta.
6. Elegir una visualización.
7. Configurar las opciones.
8. Revisar el resultado.
9. Guardar el panel.
10. Guardar el dashboard.

## Consulta inicial recomendada

Para comprobar que la fuente de datos funciona, utilizar:

```promql
up
```

Esta consulta permite verificar rápidamente si Prometheus está recibiendo métricas.

## Crear un panel de disponibilidad

Configurar:

```text
Título: Estado de los objetivos
Fuente de datos: Prometheus
Consulta: up
Visualización: Table
```

Resultado esperado:

```text
job            instance          Value
prometheus     localhost:9090    1
node_exporter  localhost:9100    1
```

Interpretación:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

---

# Editar un panel

## Acceder al editor

Para editar un panel:

1. Abrir el dashboard.
2. Localizar el panel.
3. Abrir el menú del panel.
4. Seleccionar la opción de edición.

Desde el editor se pueden modificar:

- Consulta.
- Fuente de datos.
- Visualización.
- Título.
- Descripción.
- Unidades.
- Umbrales.
- Leyendas.
- Transformaciones.
- Ejes.
- Colores.
- Rangos.

## Proceso recomendado

Al editar un panel:

```text
1. Revisar la consulta.
2. Confirmar la fuente de datos.
3. Revisar el tipo de visualización.
4. Configurar la unidad.
5. Revisar los umbrales.
6. Probar el resultado.
7. Guardar el panel.
8. Guardar el dashboard.
```

No conviene cambiar muchas opciones sin comprobar el resultado. Es mejor realizar modificaciones pequeñas y verificables.

---

# Modificar el título

Un título debe describir el dato y, cuando sea necesario, el contexto.

## Ejemplos incorrectos

```text
CPU
Memoria
Panel de datos
Gráfico principal
```

## Ejemplos recomendados

```text
Uso de CPU por instancia
Porcentaje de memoria utilizada
Espacio utilizado en el sistema de ficheros raíz
Tráfico recibido por instancia
Estado de los objetivos de Prometheus
```

## Convención recomendada

```text
<Métrica> [por <dimensión>]
```

Ejemplos:

```text
Uso de CPU por instancia
Tráfico recibido por interfaz
Uso de almacenamiento por punto de montaje
Estado de objetivos por job
```

---

# Añadir una descripción

Una descripción puede documentar el significado del panel.

Ejemplo:

```text
Muestra el porcentaje de CPU utilizado durante los últimos cinco minutos.

El cálculo se obtiene a partir de node_cpu_seconds_total y excluye
el tiempo de CPU en modo idle.
```

Otro ejemplo:

```text
Muestra el porcentaje de memoria utilizada.

Valores superiores al 90 % deben investigarse porque pueden provocar
problemas de rendimiento o falta de memoria disponible.
```

## Recomendaciones

- Utilizar frases breves.
- Explicar la unidad.
- Indicar el significado de los valores altos.
- Documentar filtros importantes.
- Indicar si se utiliza una agregación.
- Evitar repetir exactamente el título.

---

# Cambiar la fuente de datos

Un panel puede utilizar una fuente de datos concreta.

Ejemplo:

```text
Fuente actual: Prometheus
Nueva fuente: Prometheus-Laboratorio
```

Al cambiar la fuente de datos, comprobar:

- Que la fuente existe.
- Que está disponible.
- Que contiene las métricas necesarias.
- Que las consultas siguen siendo compatibles.
- Que las variables funcionan.
- Que no se han perdido los datos.

## Problemas habituales

Si el panel queda vacío después de cambiar la fuente:

1. Comprobar la fuente seleccionada.
2. Ejecutar una consulta sencilla:

```promql
up
```

3. Comprobar el rango temporal.
4. Comprobar los objetivos.
5. Revisar las etiquetas.
6. Confirmar que la nueva fuente contiene las métricas necesarias.

---

# Cambiar la visualización

La misma consulta puede representarse de distintas formas.

Utilizar:

```promql
up
```

Probar:

```text
Table
Stat
Gauge
Bar Gauge
Time series
```

## Tabla

Adecuada para consultar etiquetas y valores.

```text
job            instance          Value
prometheus     localhost:9090    1
node_exporter  localhost:9100    1
```

## Stat

Adecuada para mostrar un valor resumido.

Consulta recomendada:

```promql
sum(up)
```

## Gauge

Adecuada para mostrar un valor frente a un rango.

Consulta recomendada:

```promql
100 * avg(up)
```

## Bar Gauge

Adecuada para comparar varias series.

Consulta:

```promql
up
```

## Time series

Adecuada para representar una evolución temporal.

Consulta:

```promql
node_load1
```

## Criterio de selección

| Tipo de dato | Visualización recomendada |
|---|---|
| Un valor actual | Stat |
| Porcentaje frente a límites | Gauge |
| Comparación entre elementos | Bar Gauge |
| Evolución temporal | Time series |
| Etiquetas y valores | Table |
| Documentación | Text |
| Distribución | Heatmap |

---

# Configurar unidades

Las unidades hacen que un valor sea interpretable.

## CPU

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

## Memoria en bytes

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Unidad:

```text
Bytes
```

o:

```text
Bytes (IEC)
```

## Memoria en porcentaje

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

## Tráfico de red

Consulta:

```promql
rate(node_network_receive_bytes_total[5m])
```

Unidad:

```text
bytes/sec
```

## Carga del sistema

Consulta:

```promql
node_load1
```

Unidad:

```text
None
```

La carga no debe confundirse con un porcentaje de CPU.

---

# Configurar decimales

Los decimales deben ajustarse al nivel de precisión necesario.

Ejemplos:

| Tipo de dato | Decimales recomendados |
|---|---:|
| Porcentaje de CPU | 1 o 2 |
| Porcentaje de memoria | 1 o 2 |
| Número de objetivos | 0 |
| Bytes | Automático |
| Carga del sistema | 2 |
| Tráfico de red | 1 o 2 |

No conviene mostrar muchos decimales si no aportan información.

Evitar:

```text
73.4839201847 %
```

Utilizar:

```text
73.5 %
```

---

# Configurar límites mínimos y máximos

Los límites ayudan a que un panel represente correctamente el rango esperado.

Para un porcentaje:

```text
Min: 0
Max: 100
```

Para una disponibilidad:

```text
Min: 0
Max: 100
```

Para un Gauge de CPU:

```text
Min: 0
Max: 100
```

La configuración de límites debe corresponder al significado de la métrica.

No se debe establecer automáticamente un máximo de `100` para una métrica de carga del sistema, porque la carga no representa necesariamente un porcentaje.

---

# Configurar umbrales

## Ejemplo de memoria

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
0     Verde
70    Amarillo
90    Rojo
```

Interpretación:

```text
0 - 69.99 %   Estado normal
70 - 89.99 %  Advertencia
90 - 100 %    Estado crítico
```

## Ejemplo de almacenamiento

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

Umbrales:

```text
0     Verde
80    Amarillo
90    Rojo
```

## Buenas prácticas

- Documentar los umbrales.
- Utilizar la misma convención en todo el dashboard.
- No utilizar rojo para valores normales.
- Revisar si los umbrales dependen del entorno.
- No confundir un umbral visual con una alerta.

---

# Configurar leyendas

La leyenda ayuda a identificar cada serie.

Para una consulta por instancia:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La leyenda puede mostrar:

```text
{{instance}}
```

Para una consulta por interfaz:

```promql
rate(node_network_receive_bytes_total[5m])
```

La leyenda puede mostrar:

```text
{{device}}
```

Una leyenda útil debe mostrar las etiquetas necesarias, pero no todas las etiquetas disponibles.

Evitar leyendas excesivamente largas.

---

# Mover paneles

Los paneles pueden moverse para organizar la distribución del dashboard.

## Criterio de organización

Colocar primero:

1. Estado general.
2. Disponibilidad.
3. Recursos críticos.
4. Tendencias.
5. Detalle.
6. Información adicional.

Ejemplo:

```text
+------------------------------------------------------+
| Descripción                                          |
+------------------------------------------------------+
| Estado de objetivos                                  |
+----------------------+-------------------------------+
| Uso de CPU           | Uso de memoria                |
+----------------------+-------------------------------+
| Almacenamiento       | Carga del sistema             |
+----------------------+-------------------------------+
| Tráfico recibido     | Tráfico enviado               |
+----------------------+-------------------------------+
```

## Recomendaciones

- Agrupar paneles relacionados.
- Mantener una lectura de arriba abajo.
- Evitar saltos visuales.
- Colocar los paneles críticos en la parte superior.
- Separar información operativa y descriptiva.
- Revisar el dashboard en una pantalla de tamaño normal.

---

# Redimensionar paneles

El tamaño del panel debe corresponder a la cantidad de información que muestra.

## Paneles pequeños

Adecuados para:

- Stat.
- Gauge.
- Indicadores sencillos.
- Valores resumidos.

## Paneles medianos

Adecuados para:

- Time series.
- Tablas pequeñas.
- Bar Gauge.
- Gráficos con pocas series.

## Paneles grandes

Adecuados para:

- Series temporales complejas.
- Tablas extensas.
- Heatmaps.
- Paneles Canvas.
- Visualizaciones con varias leyendas.

## Problemas de tamaño

Un panel demasiado pequeño puede provocar:

- Títulos cortados.
- Leyendas ilegibles.
- Ejes ocultos.
- Valores truncados.
- Dificultad para interpretar los datos.

Un panel demasiado grande puede desperdiciar espacio.

---

# Duplicar un panel

Duplicar un panel permite crear otro panel con una configuración similar.

Es útil cuando:

- Se quiere reutilizar una consulta.
- Solo cambia una métrica.
- Solo cambia una etiqueta.
- Se desea comparar CPU y memoria.
- Se quiere crear una versión para otra instancia.

## Procedimiento conceptual

1. Abrir el menú del panel.
2. Seleccionar la opción de duplicar.
3. Cambiar el título.
4. Modificar la consulta.
5. Revisar la visualización.
6. Guardar.

## Ejemplo

Panel original:

```text
Uso de CPU
```

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Panel duplicado:

```text
Uso de memoria
```

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Aunque ambos paneles pueden utilizar un Gauge, sus unidades, títulos y consultas son diferentes.

---

# Copiar un panel entre dashboards

Copiar un panel permite reutilizarlo en otro dashboard.

Antes de copiarlo, comprobar:

- Que la fuente de datos existe en el dashboard destino.
- Que las variables tienen nombres compatibles.
- Que las métricas están disponibles.
- Que los plugins necesarios están instalados.
- Que los umbrales son adecuados para el nuevo contexto.

Un panel copiado puede necesitar ajustes.

No se debe asumir que funcionará sin modificaciones.

---

# Eliminar un panel

Eliminar un panel no elimina la métrica de Prometheus ni borra otros paneles.

Solo elimina la representación del panel dentro del dashboard.

Antes de eliminarlo:

1. Confirmar que es el panel correcto.
2. Revisar si contiene una consulta importante.
3. Exportar el dashboard si se trata de un dashboard relevante.
4. Comprobar si el panel puede archivarse o duplicarse.
5. Confirmar la eliminación.

## Diferencia importante

```text
Eliminar un panel:
Elimina una visualización del dashboard.

Eliminar un dashboard:
Elimina toda la estructura del dashboard.

Eliminar una métrica:
No se realiza desde Grafana.
```

---

# Guardar los cambios

Después de modificar un panel, normalmente hay dos niveles de guardado:

```text
Guardar cambios del panel
        |
        v
Guardar cambios del dashboard
```

Comprobar siempre que:

- El título se conserva.
- La consulta se conserva.
- La visualización se conserva.
- La posición se conserva.
- La fuente de datos es correcta.
- El dashboard aparece sin cambios pendientes.

---

# Deshacer cambios

Cuando se realizan cambios experimentales:

1. Cambiar una sola opción.
2. Observar el resultado.
3. Guardar únicamente si el resultado es correcto.
4. Deshacer o cancelar si no es correcto.
5. Utilizar una copia de seguridad antes de cambios importantes.

No todas las modificaciones pueden deshacerse automáticamente después de cerrar o guardar el dashboard.

Por eso conviene exportar una copia de los dashboards importantes.

---

# Inspector de paneles

El inspector ayuda a comprender qué está ocurriendo dentro de un panel.

Puede mostrar:

- Datos devueltos.
- Consulta ejecutada.
- Tiempo de respuesta.
- Errores.
- Series resultantes.
- Datos transformados.
- JSON del panel.

## Utilidades

El inspector es útil cuando:

- El panel no muestra datos.
- La consulta devuelve resultados inesperados.
- Hay demasiadas series.
- La transformación no produce el resultado esperado.
- La unidad parece incorrecta.
- La consulta tarda demasiado.

## Procedimiento de diagnóstico

```text
1. Abrir el panel.
2. Abrir el inspector.
3. Revisar la consulta.
4. Revisar los datos devueltos.
5. Revisar los errores.
6. Comparar con Prometheus.
7. Corregir la consulta.
8. Guardar el panel.
```

---

# Ejemplo de panel de disponibilidad

## Consulta original

```promql
up
```

## Resultado esperado

```text
up{job="prometheus",instance="localhost:9090"} 1
up{job="node_exporter",instance="localhost:9100"} 1
```

## Configuración como tabla

```text
Título: Estado de los objetivos
Visualización: Table
Unidad: None
```

## Configuración como Stat

Consulta:

```promql
sum(up)
```

```text
Título: Objetivos disponibles
Visualización: Stat
Unidad: None
```

## Configuración como porcentaje

Consulta:

```promql
100 * avg(up)
```

```text
Título: Disponibilidad global
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

---

# Ejemplo de panel de CPU

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
Visualización: Time series
Unidad: Percent (0-100)
Decimales: 1
Rango temporal: Last 1 hour
```

## Descripción

```text
Porcentaje de CPU utilizado por instancia durante los últimos cinco minutos.
```

## Actividad adicional

Generar carga temporal:

```bash
yes > /dev/null &
```

Observar el panel y detener la carga:

```bash
pkill yes
```

---

# Ejemplo de panel de memoria

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
Título: Uso de memoria
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

## Umbrales

```text
0     Verde
70    Amarillo
90    Rojo
```

## Descripción

```text
Porcentaje de memoria utilizada. Los valores superiores al 90 %
requieren una revisión del consumo de procesos y de la memoria disponible.
```

---

# Ejemplo de panel de almacenamiento

## Consulta

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

## Configuración

```text
Título: Uso del sistema de ficheros raíz
Visualización: Gauge
Unidad: Percent (0-100)
Min: 0
Max: 100
```

## Umbrales

```text
0     Verde
80    Amarillo
90    Rojo
```

## Comparación con el sistema operativo

```bash
df -h /
```

El resultado de PromQL y `df -h` puede variar ligeramente debido al momento de consulta y a las diferencias de cálculo.

---

# Ejemplo de panel de red

## Tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Tráfico enviado

```promql
sum by (instance) (
  rate(node_network_transmit_bytes_total{
    device!="lo"
  }[5m])
)
```

## Configuración

```text
Visualización: Time series
Unidad: bytes/sec
Título: Tráfico de red
```

## Descripción

```text
Tráfico de red agregado por instancia. La interfaz de loopback se excluye
para evitar incluir tráfico interno del sistema.
```

---

# Ejemplo de sesión 1: crear un panel desde cero

## Objetivo

Crear un panel de tipo Stat que muestre el número de objetivos disponibles.

## Pasos

1. Abrir Grafana.
2. Acceder al dashboard:

```text
Monitorización de servidor Linux
```

3. Añadir un panel nuevo.
4. Seleccionar la fuente Prometheus.
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
9. Guardar el panel.
10. Guardar el dashboard.

## Actividades

1. Comprueba el valor mostrado.
2. Compáralo con la consulta `up`.
3. Cambia temporalmente la consulta a:

```promql
count(up)
```

4. Explica la diferencia entre `sum(up)` y `count(up)`.
5. Restaura la consulta original.

---

# Ejemplo de sesión 2: editar la visualización

## Objetivo

Cambiar un panel de tabla a Gauge y adaptar su consulta.

## Situación inicial

Panel:

```text
Estado de los objetivos
```

Consulta:

```promql
up
```

Visualización:

```text
Table
```

## Pasos

1. Editar el panel.
2. Cambiar la consulta a:

```promql
100 * avg(up)
```

3. Cambiar la visualización a `Gauge`.
4. Configurar:

```text
Unidad: Percent (0-100)
Min: 0
Max: 100
```

5. Establecer el título:

```text
Disponibilidad global
```

6. Configurar umbrales:

```text
0     Rojo
90    Amarillo
99    Verde
```

7. Guardar el panel.

## Actividades

1. Comprueba el resultado.
2. Detén Node Exporter.
3. Observa el cambio.
4. Inicia Node Exporter.
5. Comprueba la recuperación.
6. Explica si la visualización Gauge ofrece más o menos detalle que la tabla.

---

# Ejemplo de sesión 3: duplicar y modificar un panel

## Objetivo

Crear un panel de memoria a partir de un panel existente.

## Pasos

1. Localizar el panel de CPU.
2. Duplicarlo.
3. Cambiar el título a:

```text
Uso de memoria
```

4. Sustituir la consulta por:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

5. Seleccionar `Gauge`.
6. Configurar la unidad:

```text
Percent (0-100)
```

7. Configurar:

```text
Min: 0
Max: 100
```

8. Añadir umbrales.
9. Guardar el panel.
10. Guardar el dashboard.

## Actividades

1. Comprueba que el panel original de CPU no ha cambiado.
2. Comprueba que el panel duplicado muestra memoria.
3. Revisa título, unidad y umbrales.
4. Añade una descripción.
5. Explica qué elementos se reutilizaron y cuáles se modificaron.

---

# Ejemplo de sesión 4: mover y redimensionar paneles

## Objetivo

Organizar visualmente un dashboard.

## Distribución inicial

Supongamos que todos los paneles están desordenados.

## Organización deseada

```text
+------------------------------------------------------+
| Descripción                                          |
+------------------------------------------------------+
| Objetivos disponibles                                |
+----------------------+-------------------------------+
| Uso de CPU           | Uso de memoria                |
+----------------------+-------------------------------+
| Almacenamiento       | Carga del sistema             |
+----------------------+-------------------------------+
| Tráfico recibido     | Tráfico enviado               |
+----------------------+-------------------------------+
```

## Pasos

1. Colocar el panel de descripción en la parte superior.
2. Colocar el estado de los objetivos debajo.
3. Colocar CPU y memoria en la misma fila.
4. Colocar almacenamiento y carga en la siguiente fila.
5. Colocar tráfico de red al final.
6. Ampliar los paneles temporales.
7. Reducir los paneles Stat y Gauge.
8. Revisar que los títulos sean legibles.
9. Guardar el dashboard.

## Actividades

1. Reorganiza el dashboard.
2. Redimensiona cada panel.
3. Comprueba la lectura en una ventana normal.
4. Comprueba la lectura en pantalla completa.
5. Explica por qué los indicadores resumen pueden ocupar menos espacio.

---

# Ejemplo de sesión 5: diagnosticar un panel sin datos

## Objetivo

Identificar el origen de un panel vacío.

## Consulta de prueba

Introducir deliberadamente:

```promql
metrica_que_no_existe
```

## Observaciones

La fuente de datos puede estar funcionando correctamente aunque esta consulta no devuelva resultados.

## Procedimiento

1. Revisar la fuente de datos.
2. Probar:

```promql
up
```

3. Probar:

```promql
node_memory_MemAvailable_bytes
```

4. Revisar el rango temporal.
5. Abrir el inspector.
6. Revisar los mensajes de error.
7. Restaurar una consulta válida.

## Actividades

1. Describe la diferencia entre:
   - Fuente desconectada.
   - Consulta inválida.
   - Consulta válida sin resultados.
   - Métrica inexistente.
2. Documenta el diagnóstico.
3. Guarda una captura del inspector.
4. Restaura el panel.

---

# Ejemplo de sesión 6: copiar un panel a otro dashboard

## Objetivo

Reutilizar un panel en otro dashboard.

## Pasos

1. Abrir el dashboard de recursos.
2. Seleccionar el panel de uso de memoria.
3. Copiar el panel.
4. Abrir el dashboard de laboratorio.
5. Pegar el panel.
6. Revisar la fuente de datos.
7. Revisar la consulta.
8. Revisar la unidad.
9. Guardar el dashboard destino.

## Actividades

1. Comprueba que el panel funciona en ambos dashboards.
2. Modifica el título solo en el dashboard destino.
3. Comprueba que el original mantiene su título.
4. Explica por qué conviene revisar las variables después de copiar un panel.

---

# Ejemplo de sesión 7: eliminar y recuperar un panel

## Objetivo

Practicar la eliminación controlada de un panel.

## Pasos

1. Exportar el dashboard como JSON.
2. Crear un panel de prueba con:

```promql
up
```

3. Nombrarlo:

```text
Panel temporal
```

4. Guardar el dashboard.
5. Eliminar el panel.
6. Guardar el dashboard.
7. Importar la copia exportada en otro dashboard.
8. Comprobar que el panel temporal sigue existiendo en la copia.

## Actividades

1. Explica por qué se realizó una exportación.
2. Compara el dashboard original y la copia.
3. Comprueba que eliminar el panel no afecta a Prometheus.
4. Documenta el procedimiento de recuperación.

---

# Ejemplo de sesión 8: utilizar el inspector

## Objetivo

Revisar los datos internos de un panel.

## Pasos

1. Abrir un panel de CPU.
2. Abrir el inspector.
3. Revisar la consulta.
4. Revisar los datos devueltos.
5. Revisar las etiquetas.
6. Revisar el tiempo de respuesta.
7. Revisar el resultado transformado, si existe.
8. Cerrar el inspector sin modificar el panel.

## Actividades

1. Anota el número de series devueltas.
2. Identifica las etiquetas principales.
3. Comprueba la unidad original.
4. Compara el resultado con Prometheus.
5. Explica cómo utilizarías el inspector ante un panel vacío.

---

# Buenas prácticas de manipulación

## Realizar cambios pequeños

Modificar una opción cada vez facilita identificar problemas.

## Probar antes de guardar

No guardar cambios incorrectos en dashboards importantes.

## Exportar antes de cambios importantes

Especialmente antes de:

- Modificar muchas consultas.
- Cambiar transformaciones.
- Cambiar variables.
- Reorganizar dashboards críticos.
- Actualizar plugins.

## Utilizar títulos consistentes

Mantener una convención común en todos los paneles.

## Configurar unidades siempre

Un número sin unidad puede inducir a error.

## Documentar transformaciones

Indicar qué datos se ocultan, calculan o agrupan.

## Revisar el comportamiento con diferentes rangos temporales

Un panel puede ser correcto para una hora, pero difícil de interpretar para siete días.

## Comprobar el rendimiento

Consultas muy complejas o demasiados paneles pueden aumentar la carga de Grafana y Prometheus.

## Mantener la legibilidad

El panel debe poder interpretarse rápidamente.

---

# Problemas habituales

## El panel no muestra datos

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
- Estado de los objetivos.
- Etiquetas.
- Variables.
- Transformaciones.

## El título no se actualiza

Comprobar:

- Que el panel se ha guardado.
- Que el dashboard se ha guardado.
- Que no se ha editado otro panel.
- Que no existe un conflicto de versión.

## La consulta devuelve demasiadas series

Utilizar:

- Filtros.
- Agregaciones.
- Variables.
- Transformaciones.

Ejemplo:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## La unidad no corresponde al dato

Revisar:

- La consulta.
- La unidad configurada.
- La escala.
- Si el resultado es un ratio o un porcentaje.

Por ejemplo, esta consulta devuelve un ratio:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Para mostrarlo directamente como porcentaje, multiplicar por `100`:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

## El panel se ve demasiado pequeño

Redimensionarlo y revisar:

- Leyenda.
- Título.
- Ejes.
- Número de series.
- Tamaño de fuente.

## El dashboard tarda en cargar

Posibles causas:

- Muchas consultas.
- Rangos temporales demasiado amplios.
- Consultas complejas.
- Muchas series.
- Actualización demasiado frecuente.
- Transformaciones costosas.
- Fuente de datos sobrecargada.

## Los cambios no aparecen

Comprobar:

- Que el panel se guardó.
- Que el dashboard se guardó.
- Que se está consultando el dashboard correcto.
- Que no se está viendo una copia.
- Que el navegador no muestra una versión antigua.

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/manipulacion-paneles
```

Guardar las consultas utilizadas:

```bash
cat > ~/laboratorio-grafana/evidencias/manipulacion-paneles/consultas.txt <<'EOF'
Disponibilidad:
up

Objetivos disponibles:
sum(up)

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

Uso de filesystem:
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
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
EOF
```

Guardar un registro de actividades:

```bash
cat > ~/laboratorio-grafana/evidencias/manipulacion-paneles/informe.txt <<'EOF'
Práctica: Manipulación de paneles

Dashboard utilizado:

Paneles creados:

Paneles editados:

Paneles duplicados:

Paneles movidos:

Paneles redimensionados:

Paneles copiados:

Paneles eliminados:

Transformaciones utilizadas:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Evidencias recomendadas:

```text
01-panel-creado.png
02-panel-editado.png
03-panel-duplicado.png
04-dashboard-organizado.png
05-inspector-panel.png
06-panel-sin-datos.png
07-panel-recuperado.png
08-dashboard-final.png
```

---

# Práctica integradora

## Objetivo

Crear y organizar un dashboard utilizando distintas operaciones de manipulación de paneles.

## Dashboard de partida

Utilizar o crear:

```text
Monitorización de servidor Linux
```

## Tareas

### Crear paneles

Crear los siguientes paneles:

```text
Estado de los objetivos
Objetivos disponibles
Uso de CPU
Uso de memoria
Uso del sistema de ficheros
Carga del sistema
Tráfico recibido
```

### Configurar paneles

Configurar:

- Títulos.
- Descripciones.
- Fuentes de datos.
- Consultas.
- Visualizaciones.
- Unidades.
- Decimales.
- Límites.
- Umbrales.
- Leyendas.

### Organizar el dashboard

Distribuir los paneles:

```text
Parte superior:
- Estado de los objetivos
- Objetivos disponibles

Zona central:
- Uso de CPU
- Uso de memoria
- Uso del sistema de ficheros

Zona inferior:
- Carga del sistema
- Tráfico recibido
```

### Manipular paneles

Realizar las siguientes operaciones:

1. Duplicar el panel de CPU.
2. Transformarlo en un panel de memoria.
3. Moverlo junto al panel de CPU.
4. Redimensionar ambos paneles.
5. Copiar el panel de disponibilidad a otro dashboard.
6. Eliminar un panel temporal.
7. Exportar el dashboard.
8. Utilizar el inspector.
9. Probar un panel sin datos.
10. Recuperar el panel a partir de una copia.

---

# Tabla de resultados

| Operación | Realizada | Observaciones |
|---|---|---|
| Panel creado | | |
| Fuente de datos seleccionada | | |
| Consulta configurada | | |
| Visualización seleccionada | | |
| Título configurado | | |
| Descripción añadida | | |
| Unidad configurada | | |
| Umbrales configurados | | |
| Leyenda configurada | | |
| Panel movido | | |
| Panel redimensionado | | |
| Panel duplicado | | |
| Panel copiado | | |
| Panel eliminado | | |
| Inspector utilizado | | |
| Dashboard guardado | | |
| Dashboard exportado | | |
| Panel sin datos diagnosticado | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Un panel combina consulta, fuente de datos y visualización.
- La manipulación de paneles permite adaptar un dashboard a las necesidades del usuario.
- Cada panel debe tener un objetivo claro.
- Los títulos deben describir la información mostrada.
- Las descripciones aportan contexto técnico.
- Las unidades son necesarias para interpretar correctamente los valores.
- Los umbrales ayudan a comunicar estados.
- La visualización debe elegirse según el tipo de dato.
- Los paneles importantes deben colocarse en la parte superior.
- Los paneles relacionados deben agruparse.
- Duplicar un panel facilita reutilizar configuraciones.
- Copiar un panel entre dashboards requiere revisar fuentes y variables.
- Eliminar un panel no elimina la métrica de Prometheus.
- El inspector ayuda a diagnosticar consultas y resultados.
- Los cambios importantes deben realizarse después de exportar una copia.
- El dashboard debe guardarse después de modificar paneles.
- Un panel sin datos puede deberse a la consulta, la fuente, el rango temporal o los objetivos.
- Demasiados paneles o consultas complejas pueden afectar al rendimiento.
- La legibilidad es más importante que mostrar muchas métricas.
- La documentación forma parte de la configuración del panel.

---

# Preguntas de comprobación

1. ¿Qué elementos principales forman un panel?
2. ¿Qué diferencia existe entre una consulta y una visualización?
3. ¿Qué pasos seguirías para crear un panel?
4. ¿Por qué es importante utilizar títulos descriptivos?
5. ¿Qué información debe incluir una descripción?
6. ¿Qué visualización utilizarías para mostrar un único valor?
7. ¿Qué visualización utilizarías para representar una evolución temporal?
8. ¿Qué unidad utilizarías para el uso de CPU?
9. ¿Qué unidad utilizarías para el tráfico de red?
10. ¿Qué función cumplen los umbrales?
11. ¿Por qué deben establecerse límites mínimos y máximos?
12. ¿Qué diferencia existe entre duplicar y copiar un panel?
13. ¿Qué ocurre al eliminar un panel?
14. ¿Qué precauciones tomarías antes de eliminarlo?
15. ¿Qué utilidad tiene el inspector de paneles?
16. ¿Qué comprobarías si un panel no muestra datos?
17. ¿Por qué una consulta puede devolver demasiadas series?
18. ¿Cómo reducirías el número de series mostradas?
19. ¿Qué factores pueden hacer que un dashboard tarde en cargar?
20. ¿Por qué es importante guardar el dashboard después de editar un panel?
21. ¿Qué operaciones realizarías antes de modificar un dashboard crítico?
22. ¿Qué paneles colocarías en la parte superior de un dashboard?
23. ¿Por qué no conviene utilizar demasiados colores?
24. ¿Qué elementos revisarías al copiar un panel a otro dashboard?
25. ¿Qué evidencias guardarías después de la práctica?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear y manipular paneles siguiendo un proceso ordenado:

```text
Crear el panel
      |
      v
Seleccionar la fuente de datos
      |
      v
Introducir la consulta
      |
      v
Seleccionar la visualización
      |
      v
Configurar título y descripción
      |
      v
Configurar unidad y umbrales
      |
      v
Probar el resultado
      |
      v
Mover y redimensionar
      |
      v
Guardar el panel
      |
      v
Guardar el dashboard
      |
      v
Exportar y documentar
```

El resultado final debe ser un dashboard organizado, legible y funcional, cuyos paneles puedan ser modificados, reutilizados y diagnosticados de forma controlada.