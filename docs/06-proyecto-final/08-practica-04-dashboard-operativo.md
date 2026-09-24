# Práctica 4 - Dashboard operativo

Esta práctica transforma el primer dashboard en una vista operativa más completa, clara y útil para la supervisión diaria.

El alumno utilizará Grafana y Prometheus para construir un dashboard que permita consultar rápidamente:

- La disponibilidad de los objetivos.
- El uso de CPU.
- El uso de memoria.
- La ocupación del almacenamiento.
- La instancia seleccionada.
- Las tendencias de las métricas.
- Los eventos anotados.
- Los valores que superan determinados umbrales.

El dashboard debe estar diseñado para ayudar a responder preguntas operativas, no únicamente para mostrar gráficos:

```text
¿Qué servidores están disponibles?

¿Cuál consume más CPU?

¿Qué instancia utiliza más memoria?

¿Qué sistema de ficheros se está llenando?

¿Desde cuándo existe el problema?

¿Se ha producido algún mantenimiento o despliegue?
```

Todas las actividades deben realizarse en un entorno de laboratorio autorizado.

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar la finalidad de un dashboard operativo.
- Diferenciar un dashboard inicial de un dashboard operativo.
- Organizar paneles según su importancia.
- Crear paneles de tipo Stat, Gauge, Time series y Table.
- Utilizar consultas PromQL validadas.
- Configurar títulos y descripciones útiles.
- Configurar unidades correctas.
- Configurar leyendas.
- Configurar umbrales visuales.
- Crear una variable para seleccionar instancias.
- Aplicar variables a varias consultas.
- Mostrar valores actuales y tendencias.
- Añadir anotaciones al dashboard.
- Configurar enlaces y descripciones.
- Revisar la legibilidad de los paneles.
- Comparar datos de varias instancias.
- Detectar valores anómalos visualmente.
- Diagnosticar paneles sin datos.
- Exportar o compartir un dashboard.
- Documentar las decisiones de diseño.
- Preparar evidencias técnicas del dashboard.

## Introducción

Un dashboard operativo debe presentar la información más importante de forma rápida y comprensible.

El primer dashboard creado en la práctica anterior servía para validar las consultas y crear los primeros paneles. En esta práctica se mejorará para que pueda utilizarse como una vista de supervisión.

La evolución será:

```text
Primer dashboard
        |
        v
Títulos básicos
        |
        v
Unidades y leyendas
        |
        v
Umbrales visuales
        |
        v
Variables y filtros
        |
        v
Anotaciones
        |
        v
Organización operativa
        |
        v
Dashboard final
```

Un dashboard operativo debe tener una jerarquía visual:

```text
Disponibilidad y estado general
        |
        v
Recursos críticos
        |
        v
Detalle por instancia
        |
        v
Tendencias y contexto
```

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Grafana accesible.
- Prometheus configurado como fuente de datos.
- Node Exporter operativo.
- Consultas PromQL validadas.
- Permisos para crear o editar dashboards.
- Permisos para crear variables.
- Permisos para crear anotaciones.
- Un entorno de laboratorio autorizado.
- Evidencias de la práctica anterior.

Registrar:

```text
Alumno:

Grupo:

Fecha:

URL de Grafana:

Fuente de datos:

Dashboard inicial:

Instancias disponibles:

Entorno:

Observaciones:
```

## Arquitectura del dashboard

### Componentes

El dashboard utilizará:

| Componente | Función |
|---|---|
| Prometheus | Fuente de datos |
| Node Exporter | Métricas del sistema |
| Grafana | Visualización y organización |
| Variable `instance` | Selección del servidor |
| Anotaciones | Contexto operativo |

### Flujo de datos

```text
Servidor de laboratorio
        |
        v
Node Exporter
        |
        v
Prometheus
        |
        v
Grafana
        |
        v
Dashboard operativo
```

## Diseño del dashboard

### Principios de diseño

El dashboard debe cumplir estos principios:

- Mostrar primero la información más importante.
- Utilizar títulos claros.
- Evitar consultas duplicadas.
- Utilizar unidades coherentes.
- Mantener una distribución equilibrada.
- Identificar siempre la instancia.
- Utilizar colores con significado.
- Evitar exceso de elementos visuales.
- Mostrar contexto temporal.
- Facilitar la investigación de problemas.

### Distribución recomendada

```text
+--------------------------------------------------+
| Disponibilidad de objetivos                      |
+-------------------------+------------------------+
| CPU utilizada           | Memoria utilizada      |
+-------------------------+------------------------+
| Almacenamiento          | Carga del sistema     |
+--------------------------------------------------+
| Tendencias de recursos                          |
+--------------------------------------------------+
| Anotaciones y eventos                            |
+--------------------------------------------------+
```

### Información prioritaria

La primera fila debe mostrar información que permita conocer rápidamente el estado general:

```text
Disponibilidad
Alertas activas, si procede
Instancia seleccionada
```

La segunda fila puede mostrar:

```text
CPU
Memoria
```

La tercera fila puede mostrar:

```text
Almacenamiento
Carga del sistema
```

## Consultas principales

### Disponibilidad

```promql
up{job="node_exporter"}
```

Interpretación:

```text
1 = objetivo disponible
0 = objetivo no disponible
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

### Carga del sistema

```promql
node_load1
```

### Memoria disponible en bytes

```promql
node_memory_MemAvailable_bytes
```

## Sesión 1: revisar el dashboard inicial

### Objetivo

Analizar el dashboard creado en la práctica anterior antes de modificarlo.

### Actividad

Abrir el dashboard inicial y revisar:

```text
¿Los títulos son claros?

¿Las unidades son correctas?

¿Las instancias aparecen en las leyendas?

¿Los paneles están ordenados?

¿Se distinguen los valores normales de los anómalos?

¿El rango temporal es adecuado?

¿Las consultas devuelven datos?
```

### Registro

```text
Nombre del dashboard:

Número de paneles:

Panel mejor organizado:

Panel que necesita mejoras:

Problema principal:

Mejora propuesta:

Resultado:
```

### Resultado esperado

El alumno debe identificar al menos tres mejoras necesarias.

## Sesión 2: duplicar o guardar una versión de trabajo

### Objetivo

Evitar perder el dashboard inicial durante las modificaciones.

### Opciones

Según los permisos y la versión de Grafana, se puede:

- Guardar una copia con otro nombre.
- Exportar el dashboard.
- Utilizar una carpeta de laboratorio.
- Crear una nueva versión de trabajo.

### Nombre recomendado

```text
Proyecto final - Dashboard operativo
```

### Descripción

```text
Dashboard operativo para supervisar disponibilidad,
CPU, memoria, almacenamiento y carga de los servidores
del entorno de laboratorio.
```

### Registro

```text
Dashboard original:

Dashboard de trabajo:

URL:

Fecha de copia:

Método utilizado:

Resultado:
```

## Sesión 3: configurar el rango temporal

### Objetivo

Definir un rango temporal adecuado para la supervisión.

### Rango recomendado

```text
Últimos 30 minutos
```

También se pueden probar:

```text
Últimos 5 minutos
Últimos 15 minutos
Última hora
Últimas 6 horas
Últimas 24 horas
```

### Actividad

1. Seleccionar los últimos 5 minutos.
2. Revisar los paneles.
3. Seleccionar los últimos 30 minutos.
4. Revisar las tendencias.
5. Seleccionar las últimas 6 horas.
6. Comparar la cantidad de información.
7. Elegir un rango predeterminado.

### Registro

```text
Rango seleccionado:

Motivo:

Paneles que se visualizan mejor:

Paneles que pierden detalle:

Resultado:
```

### Consideración

Un rango corto permite analizar cambios recientes. Un rango largo ayuda a identificar tendencias, pero puede reducir el detalle visual.

## Sesión 4: configurar el intervalo de actualización

### Objetivo

Hacer que el dashboard actualice sus datos periódicamente.

### Valores recomendados para laboratorio

```text
30 segundos
1 minuto
```

### Actividad

1. Seleccionar un intervalo de 30 segundos.
2. Observar la actualización.
3. Cambiar a un minuto.
4. Comparar el comportamiento.
5. Seleccionar el valor definitivo.

### Registro

```text
Intervalo inicial:

Intervalo final:

Motivo:

Carga observada:

Resultado:
```

### Consideración operativa

Un intervalo demasiado corto puede aumentar la carga sobre Grafana y Prometheus. Un intervalo demasiado largo puede retrasar la detección visual de cambios.

## Sesión 5: mejorar el panel de disponibilidad

### Objetivo

Crear una vista clara del estado de los objetivos.

### Consulta

```promql
up{job="node_exporter"}
```

### Visualización

Utilizar:

```text
Stat
```

### Título

```text
Disponibilidad de objetivos
```

### Unidad

```text
none
```

### Valores

```text
1 = disponible
0 = no disponible
```

### Umbrales

```text
0 = rojo
1 = verde
```

### Texto del valor

Configurar, si la versión de Grafana lo permite:

```text
1 → UP
0 → DOWN
```

También se puede utilizar un mapeo de valores:

```text
1 = Disponible
0 = No disponible
```

### Comprobaciones

```text
¿El panel muestra el estado actual?

¿La instancia aparece identificada?

¿El color verde representa disponibilidad?

¿El valor cero se distingue claramente?

¿El título describe el contenido?
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Mapeo de valores:

Umbrales:

Resultado:
```

## Sesión 6: mejorar el panel de CPU

### Objetivo

Mostrar la evolución del uso de CPU por instancia.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Visualización

Utilizar:

```text
Time series
```

### Título

```text
CPU utilizada por instancia
```

### Unidad

```text
Percent (0-100)
```

### Leyenda

La leyenda debe mostrar al menos:

```text
instance
```

### Umbrales

```text
0-80 = verde
80-90 = amarillo
90-100 = rojo
```

### Opciones recomendadas

```text
Mostrar puntos:
Según necesidad

Escala:
0-100

Leyenda:
Visible

Modo de apilado:
Desactivado
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Leyenda:

Escala:

Umbrales:

Resultado:
```

## Sesión 7: mejorar el panel de memoria

### Objetivo

Mostrar el uso actual y la evolución de la memoria.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Visualización

Se puede utilizar:

```text
Gauge
```

o:

```text
Time series
```

Una posible configuración es:

```text
Gauge para el valor actual.
Time series para observar la evolución.
```

### Título

```text
Memoria utilizada por instancia
```

### Unidad

```text
Percent (0-100)
```

### Rango

```text
Mínimo:
0

Máximo:
100
```

### Umbrales

```text
0-80 = verde
80-90 = amarillo
90-100 = rojo
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Valor actual:

Umbrales:

Resultado:
```

## Sesión 8: mejorar el panel de almacenamiento

### Objetivo

Mostrar la ocupación del sistema de ficheros raíz.

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

### Visualización

Utilizar:

```text
Gauge
```

### Título

```text
Almacenamiento utilizado en /
```

### Unidad

```text
Percent (0-100)
```

### Rango

```text
Mínimo:
0

Máximo:
100
```

### Umbrales

```text
0-70 = verde
70-80 = amarillo
80-100 = rojo
```

### Etiquetas

Si existen varias instancias o sistemas de ficheros, la leyenda debe permitir distinguir:

```text
instance
mountpoint
fstype
```

### Registro

```text
Título:

Consulta:

Punto de montaje:

Unidad:

Leyenda:

Umbrales:

Resultado:
```

## Sesión 9: crear el panel de carga del sistema

### Objetivo

Añadir información adicional sobre la carga del servidor.

### Consulta

```promql
node_load1
```

### Visualización

Utilizar:

```text
Time series
```

o:

```text
Stat
```

### Título

```text
Carga del sistema - 1 minuto
```

### Unidad

```text
none
```

### Consulta complementaria

```promql
node_load5
```

También se puede crear una serie para la carga de quince minutos:

```promql
node_load15
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Instancia:

Valor actual:

Resultado:
```

### Consideración

La carga del sistema no es directamente un porcentaje de CPU. Debe interpretarse junto con el número de procesadores y el tipo de actividad del servidor.

## Sesión 10: crear una variable de instancia

### Objetivo

Permitir seleccionar una instancia desde la parte superior del dashboard.

### Nombre de la variable

```text
instance
```

### Consulta de la variable

En versiones de Grafana que utilizan el editor específico del datasource, puede utilizarse:

```promql
label_values(up{job="node_exporter"}, instance)
```

Si la versión utiliza consultas PromQL estándar para variables, una alternativa puede ser:

```promql
query_result(up{job="node_exporter"})
```

La configuración exacta depende de la versión de Grafana y del datasource.

### Opciones recomendadas

```text
Nombre:
instance

Etiqueta visible:
Instancia

Multi-value:
Activado, si se necesitan varias instancias

Include All:
Activado

Valor inicial:
All
```

### Comprobaciones

```text
¿La variable muestra valores?

¿Los valores contienen las instancias correctas?

¿Aparece la opción All?

¿Se puede seleccionar una sola instancia?

¿Se pueden seleccionar varias?
```

### Registro

```text
Nombre:

Etiqueta:

Consulta:

Valores disponibles:

Multi-value:

Include All:

Resultado:
```

## Sesión 11: aplicar la variable al panel de disponibilidad

### Objetivo

Filtrar el panel de disponibilidad con la instancia seleccionada.

### Consulta

```promql
up{
  job="node_exporter",
  instance=~"$instance"
}
```

### Pruebas

1. Seleccionar una instancia.
2. Comprobar el valor.
3. Seleccionar todas las instancias.
4. Comprobar las series.
5. Revisar la leyenda.
6. Cambiar de instancia.
7. Confirmar que cambia el resultado.

### Registro

```text
Instancia seleccionada:

Valor observado:

Instancias mostradas:

Resultado:

Problemas:
```

## Sesión 12: aplicar la variable al panel de CPU

### Objetivo

Mostrar la CPU de una o varias instancias seleccionadas.

### Consulta

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

### Pruebas

```text
Instancia individual:

Todas las instancias:

Valor máximo:

Valor mínimo:

Leyenda:

Resultado:
```

### Problema habitual

Si se utiliza:

```promql
instance="$instance"
```

la selección múltiple puede no funcionar correctamente.

Para admitir expresiones regulares y selección múltiple, utilizar:

```promql
instance=~"$instance"
```

## Sesión 13: aplicar la variable al panel de memoria

### Objetivo

Filtrar el panel de memoria según la instancia seleccionada.

### Consulta

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

### Comprobaciones

```text
¿El valor cambia al seleccionar una instancia?

¿La leyenda identifica el servidor?

¿El valor está entre 0 y 100?

¿La opción All muestra todas las instancias?
```

### Registro

```text
Instancia:

Valor:

Unidad:

Resultado:

Observaciones:
```

## Sesión 14: aplicar la variable al panel de almacenamiento

### Objetivo

Filtrar el almacenamiento por instancia.

### Consulta

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay",
    instance=~"$instance"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay",
    instance=~"$instance"
  }
)
```

### Comprobaciones

```text
¿Se muestra el sistema de ficheros raíz?

¿La instancia cambia correctamente?

¿Se excluyen tmpfs y overlay?

¿Aparecen resultados duplicados?

¿La unidad es porcentual?
```

## Sesión 15: crear un panel de tabla

### Objetivo

Mostrar un resumen actual por instancia.

### Consulta

Una consulta posible es:

```promql
up{job="node_exporter"}
```

Para enriquecer la tabla, se pueden añadir consultas independientes de:

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
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
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

### Título

```text
Resumen actual por instancia
```

### Columnas recomendadas

```text
Instance
Availability
CPU
Memory
Filesystem
```

### Transformaciones

Según la versión de Grafana, pueden utilizarse transformaciones como:

```text
Join by field
Organize fields
Rename fields
Convert field type
```

### Registro

```text
Panel:

Consultas:

Campos mostrados:

Transformaciones:

Resultado:
```

## Sesión 16: configurar umbrales visuales

### Objetivo

Utilizar colores para facilitar la interpretación de los valores.

### CPU

```text
0-80 = verde
80-90 = amarillo
90-100 = rojo
```

### Memoria

```text
0-80 = verde
80-90 = amarillo
90-100 = rojo
```

### Almacenamiento

```text
0-70 = verde
70-80 = amarillo
80-100 = rojo
```

### Disponibilidad

```text
1 = verde
0 = rojo
```

### Actividad

Para cada panel, registrar:

```text
Panel:

Valor mínimo:

Valor máximo:

Umbral verde:

Umbral amarillo:

Umbral rojo:

Justificación:
```

### Consideración

Los umbrales visuales no sustituyen a las reglas de alerta. Solo ayudan a interpretar el dashboard. Una alerta debe configurarse de forma independiente.

## Sesión 17: añadir descripciones a los paneles

### Objetivo

Documentar la finalidad de cada panel dentro del propio dashboard.

### Ejemplos

#### Disponibilidad

```text
Muestra si los targets de Node Exporter responden
correctamente a las consultas de Prometheus.
```

#### CPU

```text
Muestra el porcentaje aproximado de CPU utilizada
por cada instancia durante los últimos cinco minutos.
```

#### Memoria

```text
Muestra el porcentaje de memoria utilizada
a partir de la memoria disponible y total.
```

#### Almacenamiento

```text
Muestra la ocupación del sistema de ficheros raíz,
excluyendo sistemas temporales o virtuales.
```

### Registro

```text
Panel:

Descripción añadida:

Motivo:

Resultado:
```

## Sesión 18: añadir anotaciones al dashboard

### Objetivo

Relacionar cambios de métricas con eventos operativos.

### Anotación de inicio

```text
Título:
Inicio de revisión del dashboard operativo

Descripción:
Se inicia la revisión y mejora del dashboard
del entorno de laboratorio.
```

Etiquetas:

```text
event = dashboard-review
environment = laboratory
team = training
```

### Anotación de mantenimiento

```text
Título:
Mantenimiento de Node Exporter

Descripción:
Se realizará una prueba controlada de disponibilidad
sobre Node Exporter.
```

Etiquetas:

```text
event = maintenance
environment = laboratory
service = node_exporter
```

### Anotación de carga

```text
Título:
Prueba controlada de CPU

Descripción:
Se ejecutará una actividad autorizada para observar
la evolución de la CPU en el dashboard.
```

Etiquetas:

```text
event = load-test
environment = laboratory
resource = cpu
```

### Comprobar

1. Crear la anotación.
2. Seleccionar un rango temporal adecuado.
3. Abrir el dashboard.
4. Confirmar que aparece la marca temporal.
5. Abrir el detalle.
6. Revisar las etiquetas.

### Registro

```text
Título:

Descripción:

Etiquetas:

Hora:

Visible en los paneles:

Resultado:
```

## Sesión 19: configurar colores y estilos

### Objetivo

Aplicar un estilo consistente a los paneles.

### Reglas de diseño

```text
Verde:
Estado normal

Amarillo:
Advertencia

Rojo:
Situación crítica

Azul o gris:
Información neutral
```

### Actividad

Revisar:

```text
¿El mismo color significa lo mismo en todos los paneles?

¿El rojo se reserva para situaciones importantes?

¿El amarillo indica advertencia?

¿Los colores permiten interpretar el valor sin leer todos los números?

¿El dashboard es legible con diferentes niveles de brillo?
```

### Registro

```text
Panel:

Color normal:

Color de advertencia:

Color crítico:

Motivo:

Resultado:
```

## Sesión 20: revisar las leyendas

### Objetivo

Garantizar que el operador pueda identificar cada serie.

### CPU

La leyenda debe mostrar:

```text
instance
```

### Almacenamiento

La leyenda puede mostrar:

```text
instance
mountpoint
fstype
```

### Actividad

1. Abrir el panel de CPU.
2. Comprobar la leyenda.
3. Abrir el panel de almacenamiento.
4. Comprobar las etiquetas.
5. Ocultar etiquetas innecesarias.
6. Guardar el panel.

### Registro

```text
Panel:

Campos mostrados:

Campos ocultos:

Motivo:

Resultado:
```

## Sesión 21: comparar instancias

### Objetivo

Utilizar el dashboard para comparar servidores.

### Procedimiento

1. Seleccionar todas las instancias.
2. Revisar CPU.
3. Revisar memoria.
4. Revisar almacenamiento.
5. Identificar la instancia con mayor consumo.
6. Seleccionar solo esa instancia.
7. Revisar su evolución temporal.
8. Crear una anotación si existe una causa conocida.

### Registro

```text
Instancia con mayor CPU:

Valor:

Instancia con mayor memoria:

Valor:

Instancia con mayor almacenamiento:

Valor:

Evento relacionado:

Conclusión:
```

## Sesión 22: crear enlaces operativos

### Objetivo

Facilitar el acceso a información relacionada.

### Posibles enlaces

- Dashboard de alertas.
- Dashboard de disponibilidad.
- Página de Prometheus.
- Documentación interna.
- Runbook de CPU.
- Runbook de memoria.
- Runbook de almacenamiento.

### Ejemplo de descripción

```text
Para investigar un valor elevado, revisar primero
las consultas PromQL y después el historial de alertas.
```

### Actividad

Configurar, si el entorno lo permite:

```text
Enlace a Prometheus:

Enlace a otro dashboard:

Enlace a documentación:

Enlace a runbook:
```

No se deben incluir enlaces que expongan credenciales o recursos no autorizados.

## Sesión 23: revisar el comportamiento sin datos

### Objetivo

Definir qué debe mostrar el dashboard cuando una consulta no devuelve datos.

### Posibles estados

```text
No data
N/A
Sin datos
Desconocido
```

### Actividad

Revisar:

```text
¿Qué muestra el panel si el target desaparece?

¿El panel de disponibilidad muestra cero?

¿Los paneles de recursos muestran No data?

¿El operador puede distinguir No data de cero?

¿La configuración puede inducir a error?
```

### Consideración

Un valor cero y la ausencia de datos no significan lo mismo:

```text
0 = existe una serie cuyo valor es cero
No data = no existe ninguna serie válida para mostrar
```

### Registro

```text
Panel:

Estado probado:

Valor mostrado:

Interpretación:

Mejora necesaria:
```

## Sesión 24: realizar una prueba de disponibilidad

### Objetivo

Observar cómo responde el dashboard cuando Node Exporter deja de estar disponible.

Esta prueba debe realizarse exclusivamente en el laboratorio.

### Preparación

Crear una anotación:

```text
Título:
Prueba de disponibilidad en dashboard

Descripción:
Se detendrá Node Exporter para comprobar la visualización
del cambio de estado en el dashboard operativo.
```

Comprobar el estado inicial:

```promql
up{job="node_exporter"}
```

Valor esperado:

```text
1
```

### Ejecutar la prueba

Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Esperar al siguiente scrape y actualizar el dashboard.

### Observar

```text
Panel de disponibilidad:

Panel de CPU:

Panel de memoria:

Panel de almacenamiento:

Estado de las series:

Anotación visible:
```

### Recuperar

```bash
sudo systemctl start node_exporter
```

Comprobar:

```promql
up{job="node_exporter"}
```

Valor esperado:

```text
1
```

### Registro

```text
Hora de detención:

Valor inicial de up:

Valor observado durante la prueba:

Hora de recuperación:

Valor final de up:

Comportamiento del dashboard:

Resultado:
```

## Sesión 25: diagnosticar un panel sin datos

### Situación

```text
Un panel del dashboard muestra No data.
```

### Procedimiento

1. Abrir la edición del panel.
2. Revisar la consulta.
3. Revisar la fuente de datos.
4. Ejecutar la consulta en Explore.
5. Revisar la variable `instance`.
6. Seleccionar `All`.
7. Revisar el rango temporal.
8. Revisar las etiquetas.
9. Comparar con una consulta simple.
10. Registrar la causa.

### Consultas de comprobación

```promql
up
```

```promql
up{job="node_exporter"}
```

### Posibles causas

```text
La variable no tiene valores.
La variable seleccionada no coincide.
El filtro utiliza = en lugar de =~.
La fuente de datos es incorrecta.
El target está DOWN.
La métrica no está disponible.
El rango temporal es demasiado corto.
La etiqueta no existe.
```

### Registro

```text
Panel:

Consulta:

Variable:

Valor seleccionado:

Fuente de datos:

Causa:

Corrección:

Resultado:
```

## Sesión 26: diagnosticar un panel con datos duplicados

### Situación

```text
El panel muestra varias series para el mismo punto de montaje.
```

### Consulta inicial

```promql
node_filesystem_size_bytes{
  mountpoint="/"
}
```

### Revisar etiquetas

```text
instance
device
fstype
mountpoint
job
```

### Consulta más restrictiva

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Actividad

1. Comparar el número de series.
2. Identificar las etiquetas diferentes.
3. Decidir si deben mostrarse todas.
4. Aplicar filtros o una transformación.
5. Documentar la decisión.

### Registro

```text
Número de series inicial:

Etiquetas diferentes:

Filtro aplicado:

Número de series final:

Resultado:
```

## Sesión 27: realizar una revisión operativa

### Objetivo

Evaluar el dashboard como si se utilizara durante una incidencia.

### Situación

```text
El equipo recibe un aviso de que un servidor responde lentamente.
```

### Actividad

Utilizar el dashboard para responder:

```text
¿Qué instancia está afectada?

¿Está disponible Node Exporter?

¿Cuál es su uso de CPU?

¿Cuál es su uso de memoria?

¿Cuál es la ocupación del almacenamiento?

¿Existe una tendencia creciente?

¿Hay una anotación relacionada?

¿Hay otro servidor en mejor estado?
```

### Registro

```text
Instancia investigada:

Disponibilidad:

CPU:

Memoria:

Almacenamiento:

Tendencia:

Anotación relacionada:

Conclusión:

Acción recomendada:
```

## Sesión 28: evaluar la legibilidad con otro alumno

### Objetivo

Comprobar si el dashboard puede entenderse sin explicación adicional.

### Actividad

Pedir a otro alumno que observe el dashboard durante un minuto y responda:

```text
¿Qué instancias aparecen?

¿Cuál está disponible?

¿Qué instancia tiene más CPU?

¿Qué instancia tiene más memoria?

¿Existe algún valor en amarillo o rojo?

¿Qué ocurrió durante el periodo seleccionado?
```

### Criterio

Si el alumno no puede responder rápidamente, revisar:

- Títulos.
- Leyendas.
- Colores.
- Unidades.
- Variables.
- Distribución.
- Rango temporal.

### Registro

```text
Persona que revisa:

Tiempo utilizado:

Pregunta no respondida:

Problema detectado:

Mejora aplicada:

Resultado:
```

## Sesión 29: exportar el dashboard

### Objetivo

Guardar una copia reproducible del dashboard.

### Procedimiento

1. Abrir la configuración del dashboard.
2. Seleccionar la opción de exportación.
3. Incluir las variables si la versión lo permite.
4. Descargar el fichero JSON.
5. Guardarlo en el directorio de la práctica.
6. Revisar que no contiene secretos.
7. Documentar el nombre del fichero.

### Comando de ejemplo

```bash
mkdir -p ~/proyecto-final-grafana/evidencias/dashboard
```

El fichero puede guardarse como:

```text
dashboard-operativo.json
```

### Registro

```text
Nombre del fichero:

Ruta:

Fecha de exportación:

Variables incluidas:

Fuente de datos utilizada:

Secretos revisados:

Resultado:
```

## Sesión 30: preparar las evidencias

### Objetivo

Organizar las evidencias del dashboard operativo.

### Capturas recomendadas

```text
01-dashboard-inicial.png
02-dashboard-renombrado.png
03-fuente-de-datos.png
04-variable-instance.png
05-panel-disponibilidad.png
06-panel-cpu.png
07-panel-memoria.png
08-panel-almacenamiento.png
09-panel-carga.png
10-umbrales-configurados.png
11-anotacion-visible.png
12-dashboard-todas-las-instancias.png
13-dashboard-instancia-seleccionada.png
14-prueba-target-down.png
15-dashboard-recuperado.png
16-dashboard-final.png
```

### Revisión de seguridad

Antes de entregar:

- Ocultar contraseñas.
- Ocultar tokens.
- Ocultar claves API.
- Ocultar cookies.
- Ocultar URLs privadas.
- Confirmar que el entorno es de laboratorio.
- Revisar que el JSON exportado no contiene secretos.

## Sesión 31: completar el informe

### Objetivo

Documentar el diseño y el resultado del dashboard operativo.

### Plantilla

```markdown
# Informe - Práctica 4

## Identificación

Alumno:

Grupo:

Fecha:

Entorno:

## Objetivo

Transformar el primer dashboard en una vista operativa
para supervisar disponibilidad y recursos del laboratorio.

## Fuente de datos

Nombre:

Tipo:

URL:

Resultado de la prueba:

## Diseño

Descripción de la distribución de paneles.

## Variable

Nombre:

Consulta:

Valores:

Configuración multi-value:

Opción All:

## Paneles

### Disponibilidad

Consulta:

Visualización:

Unidad:

Umbrales:

### CPU

Consulta:

Visualización:

Unidad:

Umbrales:

### Memoria

Consulta:

Visualización:

Unidad:

Umbrales:

### Almacenamiento

Consulta:

Visualización:

Unidad:

Umbrales:

### Carga

Consulta:

Visualización:

Unidad:

## Anotaciones

Título:

Descripción:

Etiquetas:

Resultado:

## Pruebas

Prueba realizada:

Estado inicial:

Estado durante la prueba:

Estado final:

Resultado:

## Problemas encontrados

Problema:

Causa:

Corrección:

Resultado:

## Evidencias

Listado de capturas y ficheros.

## Conclusiones

Mejoras aplicadas y mejoras pendientes.
```

## Ejemplo de dashboard operativo

### Configuración general

```text
Nombre:
Proyecto final - Dashboard operativo

Descripción:
Dashboard operativo para supervisar disponibilidad,
CPU, memoria, almacenamiento y carga de los servidores
del entorno de laboratorio.

Rango temporal:
Últimos 30 minutos

Actualización:
30 segundos

Variable:
instance
```

### Panel de disponibilidad

```text
Título:
Disponibilidad de objetivos

Visualización:
Stat

Consulta:
up{job="node_exporter"}

Unidad:
none

Mapeo:
1 = Disponible
0 = No disponible
```

### Panel de CPU

```text
Título:
CPU utilizada por instancia

Visualización:
Time series

Consulta:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Unidad:
Percent (0-100)
```

### Panel de memoria

```text
Título:
Memoria utilizada por instancia

Visualización:
Gauge

Consulta:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Unidad:
Percent (0-100)
```

### Panel de almacenamiento

```text
Título:
Almacenamiento utilizado en /

Visualización:
Gauge

Consulta:
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

Unidad:
Percent (0-100)
```

## Ejemplo de interpretación

Supongamos que el dashboard muestra:

```text
Disponibilidad:
1

CPU:
32 %

Memoria:
57 %

Almacenamiento:
68 %

Carga de un minuto:
0.75
```

Una interpretación posible sería:

```text
Node Exporter está disponible.

La CPU se encuentra en un nivel normal.

La memoria utilizada está por debajo del umbral de advertencia.

El almacenamiento está por debajo del límite amarillo.

La carga del sistema no parece elevada,
pero debe interpretarse junto con el número de CPUs.
```

Supongamos ahora:

```text
Disponibilidad:
0

CPU:
No data

Memoria:
No data

Almacenamiento:
No data
```

La interpretación puede ser:

```text
El target no está disponible o no existen datos recientes.
Debe comprobarse Node Exporter, el target de Prometheus,
la conectividad y el intervalo desde el último scrape.
```

## Criterios de aceptación

La práctica se considera completada cuando:

- Existe un dashboard operativo.
- El dashboard tiene una descripción.
- La distribución de paneles es clara.
- Existe un panel de disponibilidad.
- Existe un panel de CPU.
- Existe un panel de memoria.
- Existe un panel de almacenamiento.
- Existe un panel adicional de carga o resumen.
- Las consultas están validadas.
- Las unidades son correctas.
- Las leyendas identifican las instancias.
- Los umbrales visuales están configurados.
- Existe una variable `instance`.
- La variable permite seleccionar instancias.
- La opción `All` funciona, si está habilitada.
- Las anotaciones aparecen en el dashboard.
- El dashboard se ha probado con distintos rangos temporales.
- Se ha realizado una prueba de disponibilidad o una simulación documentada.
- Se ha comprobado la recuperación.
- Se han guardado evidencias.
- El dashboard se ha exportado o documentado.
- No se han incluido credenciales.
- El informe está completo.

## Lista de comprobación final

### Configuración general

```text
[ ] El dashboard tiene un nombre claro.
[ ] El dashboard tiene una descripción.
[ ] La fuente de datos es correcta.
[ ] El rango temporal es adecuado.
[ ] El intervalo de actualización está configurado.
```

### Paneles

```text
[ ] Existe disponibilidad.
[ ] Existe CPU.
[ ] Existe memoria.
[ ] Existe almacenamiento.
[ ] Existe carga o resumen.
[ ] Los títulos son claros.
[ ] Las unidades son correctas.
[ ] Las leyendas son legibles.
[ ] Los paneles están ordenados.
```

### Variable

```text
[ ] Existe la variable instance.
[ ] La variable devuelve valores.
[ ] La selección individual funciona.
[ ] La selección múltiple funciona, si procede.
[ ] La opción All funciona, si procede.
[ ] Las consultas utilizan =~ cuando es necesario.
```

### Visualización

```text
[ ] Los umbrales están configurados.
[ ] Los colores son coherentes.
[ ] Los valores anómalos se distinguen.
[ ] No se confunde cero con ausencia de datos.
[ ] Las anotaciones son visibles.
```

### Evidencias

```text
[ ] Se ha capturado la variable.
[ ] Se han capturado los paneles.
[ ] Se ha capturado una anotación.
[ ] Se ha capturado una prueba.
[ ] Se ha guardado el dashboard.
[ ] Se ha exportado el JSON.
[ ] No aparecen secretos.
```

## Puntos clave

- Un dashboard operativo debe ayudar a tomar decisiones.
- La disponibilidad debe ocupar una posición visible.
- Los paneles deben tener títulos comprensibles.
- Las unidades deben coincidir con el resultado de las consultas.
- Las leyendas deben identificar las instancias.
- Los umbrales visuales ayudan a interpretar los valores.
- Los umbrales visuales no sustituyen a las alertas.
- Una variable permite reutilizar el dashboard para varias instancias.
- La expresión `=~` facilita los filtros con selección múltiple.
- La opción `All` debe probarse antes de entregar el dashboard.
- Las anotaciones relacionan eventos y métricas.
- Un valor cero no significa lo mismo que `No data`.
- El rango temporal debe adaptarse al objetivo de la investigación.
- El intervalo de actualización debe ser razonable.
- Un dashboard debe evitar información redundante.
- La distribución visual forma parte de la calidad técnica.
- Los paneles deben poder interpretarse sin consultar continuamente la configuración.
- La exportación permite reproducir el dashboard.
- Las pruebas deben demostrar el comportamiento normal y anómalo.
- La documentación debe explicar las decisiones de diseño.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre un dashboard inicial y uno operativo?
2. ¿Qué información debe aparecer en la parte superior del dashboard?
3. ¿Qué visualización es adecuada para mostrar la disponibilidad?
4. ¿Qué visualización es adecuada para mostrar una tendencia temporal?
5. ¿Qué unidad debe utilizarse para CPU, memoria y almacenamiento?
6. ¿Qué función cumplen los umbrales visuales?
7. ¿Por qué los umbrales visuales no sustituyen a las alertas?
8. ¿Qué función cumple la variable `instance`?
9. ¿Por qué se utiliza `instance=~"$instance"`?
10. ¿Qué diferencia existe entre un valor cero y `No data`?
11. ¿Qué problemas pueden causar los rangos temporales demasiado cortos?
12. ¿Qué problemas puede causar un intervalo de actualización demasiado corto?
13. ¿Qué información debe mostrar la leyenda de un panel?
14. ¿Qué función cumplen las anotaciones?
15. ¿Cómo comprobarías que una variable funciona correctamente?
16. ¿Qué revisarías si el panel queda vacío al seleccionar `All`?
17. ¿Cómo investigarías un panel con datos duplicados?
18. ¿Qué información debe contener una descripción de panel?
19. ¿Qué evidencias demostrarían que el dashboard es operativo?
20. ¿Qué elementos revisarías antes de entregar el dashboard?
21. ¿Por qué es conveniente exportar el dashboard?
22. ¿Cómo distinguirías una métrica normal de una situación de riesgo?
23. ¿Qué información utilizarías para investigar un servidor lento?
24. ¿Por qué debe probarse el dashboard con varias instancias?
25. ¿Qué características debe cumplir un dashboard para considerarse operativo?

## Resultado esperado

Al finalizar la práctica, el alumno deberá disponer de un dashboard operativo con una estructura similar a:

```text
Proyecto final - Dashboard operativo
```

Paneles:

```text
Disponibilidad de objetivos
CPU utilizada por instancia
Memoria utilizada por instancia
Almacenamiento utilizado en /
Carga del sistema - 1 minuto
```

Variables:

```text
instance
```

Configuración:

```text
Rango temporal:
Últimos 30 minutos

Actualización:
30 segundos o 1 minuto
```

El flujo completado será:

```text
Revisar el dashboard inicial
        |
        v
Organizar los paneles
        |
        v
Configurar títulos y descripciones
        |
        v
Configurar unidades
        |
        v
Configurar leyendas
        |
        v
Configurar umbrales
        |
        v
Crear la variable instance
        |
        v
Aplicar filtros
        |
        v
Añadir anotaciones
        |
        v
Probar distintos rangos
        |
        v
Simular un cambio de disponibilidad
        |
        v
Comprobar la recuperación
        |
        v
Exportar el dashboard
        |
        v
Guardar evidencias
        |
        v
Documentar el resultado
```

El alumno debe poder explicar:

```text
Qué muestra cada panel.

Qué consulta utiliza cada panel.

Qué unidad representa cada valor.

Qué significan los colores.

Cómo se selecciona una instancia.

Cómo se investigaría un valor anómalo.

Cómo se relaciona una anotación con una métrica.

Qué ocurre cuando no existen datos.

Cómo se ha validado el dashboard.
```

El dashboard operativo será la base para las siguientes prácticas, en las que se configurarán reglas de alerta, contactos de notificación, políticas, pruebas de activación, recuperaciones y silenciamientos.