# Práctica 1 - Primer dashboard

Esta práctica introduce la creación de un dashboard básico en Grafana utilizando Prometheus como fuente de datos.

El alumno comprobará que la fuente de datos funciona, ejecutará consultas PromQL y construirá varios paneles para visualizar la disponibilidad, la CPU, la memoria y el almacenamiento de un servidor de laboratorio.

La práctica constituye el primer paso del proyecto final. El objetivo no es crear todavía un dashboard completo de producción, sino aprender a organizar información técnica de forma clara, legible y útil.

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Acceder a Grafana.
- Comprobar que Prometheus está configurado como fuente de datos.
- Ejecutar consultas PromQL desde Explore.
- Consultar la disponibilidad de un objetivo.
- Consultar el uso de CPU.
- Consultar el uso de memoria.
- Consultar el uso del almacenamiento.
- Crear un dashboard nuevo.
- Crear paneles de tipo Stat, Gauge y Time series.
- Configurar títulos descriptivos.
- Configurar unidades correctas.
- Configurar rangos temporales.
- Configurar intervalos de actualización.
- Añadir umbrales visuales.
- Guardar un dashboard.
- Compartir la URL de un dashboard.
- Documentar las consultas utilizadas.
- Preparar evidencias de la práctica.
- Diagnosticar errores básicos de visualización.

## Introducción

Un dashboard permite reunir varias métricas en una única vista.

Sin un dashboard, el operador tendría que ejecutar consultas individuales para responder a preguntas como:

```text
¿Está disponible el servidor?

¿Cuánto CPU está utilizando?

¿Cuánta memoria queda disponible?

¿Cuánto espacio ocupa el sistema de ficheros?

¿La situación está mejorando o empeorando?
```

Un dashboard bien diseñado debe permitir responder rápidamente a estas preguntas.

La arquitectura de esta práctica será:

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
Dashboard
```

El flujo de trabajo será:

```text
Comprobar la fuente de datos
        |
        v
Ejecutar una consulta
        |
        v
Validar el resultado
        |
        v
Crear un panel
        |
        v
Configurar la visualización
        |
        v
Guardar el dashboard
        |
        v
Documentar la evidencia
```

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Una instancia de Grafana accesible.
- Una instancia de Prometheus operativa.
- Node Exporter instalado o disponible.
- Una fuente de datos de tipo Prometheus.
- Permisos para consultar datos.
- Permisos para crear dashboards.
- Acceso a un navegador web.
- Un entorno de laboratorio autorizado.

Registrar los datos básicos:

```text
Alumno:

Grupo:

Fecha:

URL de Grafana:

URL de Prometheus:

Nombre de la fuente de datos:

Servidor supervisado:

Entorno:
```

El entorno debe identificarse como:

```text
laboratory
```

## Arquitectura de la práctica

### Grafana

Grafana será la interfaz utilizada para:

- Ejecutar consultas.
- Crear paneles.
- Crear dashboards.
- Configurar unidades.
- Configurar umbrales.
- Guardar evidencias.

### Prometheus

Prometheus será la fuente de datos consultada por Grafana.

Prometheus almacena las series temporales recopiladas desde Node Exporter.

### Node Exporter

Node Exporter expone métricas del sistema, como:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes
node_filesystem_size_bytes
node_filesystem_avail_bytes
```

### Dashboard

El dashboard reunirá los paneles necesarios para obtener una visión básica del servidor.

## Paneles que se crearán

El dashboard incluirá inicialmente estos paneles:

| Panel | Información | Visualización recomendada |
|---|---|---|
| Disponibilidad | Estado del objetivo | Stat |
| CPU | Porcentaje utilizado | Time series |
| Memoria | Porcentaje utilizado | Gauge |
| Almacenamiento | Porcentaje utilizado | Gauge |

La distribución recomendada será:

```text
+--------------------------------------------------+
| Disponibilidad de Node Exporter                  |
+--------------------------------------------------+
| CPU utilizada                                   |
+--------------------------------------------------+
| Memoria utilizada     | Almacenamiento utilizado |
+--------------------------------------------------+
```

## Sesión 1: acceder a Grafana

### Objetivo

Comprobar que el alumno puede acceder a la interfaz de Grafana.

### Procedimiento

1. Abrir un navegador web.
2. Introducir la URL de Grafana.
3. Iniciar sesión con la cuenta de laboratorio.
4. Confirmar que aparece la página principal.
5. Revisar el menú lateral.
6. Registrar la versión, si está disponible.

### Registro

```text
URL utilizada:

Usuario:

Acceso correcto:

Versión de Grafana:

Fecha:

Observaciones:
```

### Resultado esperado

El alumno debe poder acceder a Grafana y visualizar la página principal sin errores.

## Sesión 2: comprobar la fuente de datos

### Objetivo

Confirmar que Grafana tiene una fuente de datos de Prometheus disponible.

### Procedimiento

1. Acceder a la configuración de Grafana.
2. Abrir la sección de fuentes de datos.
3. Seleccionar la fuente de Prometheus.
4. Revisar el nombre.
5. Revisar la URL.
6. Ejecutar la prueba de conexión.
7. Registrar el resultado.

### Datos de la fuente

```text
Nombre:

Tipo:

URL:

Método de acceso:

Estado de la conexión:

Fecha de prueba:

Resultado:
```

### Resultado esperado

La prueba de conexión debe finalizar correctamente.

### Diagnóstico

Si la fuente no funciona, revisar:

- Que Prometheus esté activo.
- Que la URL sea correcta.
- Que el puerto sea accesible.
- Que Grafana pueda resolver el nombre del servidor.
- Que no exista un bloqueo de red.
- Que la fuente esté guardada.
- Que los logs no muestren errores.

## Sesión 3: abrir Explore

### Objetivo

Ejecutar consultas PromQL antes de crear el dashboard.

### Procedimiento

1. Abrir la sección **Explore**.
2. Seleccionar la fuente de datos de Prometheus.
3. Introducir una consulta.
4. Ejecutar la consulta.
5. Cambiar entre las vistas disponibles.
6. Revisar los resultados.

### Consulta inicial

```promql
up
```

### Interpretación

```text
1 = objetivo disponible
0 = objetivo no disponible
```

### Registro

```text
Consulta:

Número de series:

Valor:

Etiquetas observadas:

Resultado:
```

## Sesión 4: consultar la disponibilidad

### Objetivo

Comprobar el estado de Node Exporter.

### Consulta

```promql
up{job="node_exporter"}
```

### Resultado esperado

La consulta debe devolver una o varias series con un valor similar a:

```text
1
```

Ejemplo:

```text
up{instance="server-01:9100", job="node_exporter"} 1
```

### Interpretación

```text
1 = Node Exporter responde correctamente
0 = Node Exporter no responde
```

### Revisar las etiquetas

Comprobar si aparecen:

```text
instance
job
```

### Registro

```text
Consulta:

Instancia:

Job:

Valor:

Estado interpretado:

Resultado:
```

### Problemas habituales

#### La consulta no devuelve datos

Comprobar:

- El nombre del job.
- Las etiquetas disponibles.
- El estado del target en Prometheus.
- La fuente de datos seleccionada.
- El rango temporal.

#### El valor es cero

Comprobar:

- El estado de Node Exporter.
- La configuración de Prometheus.
- La dirección del target.
- Los errores del último scrape.

## Sesión 5: consultar la CPU

### Objetivo

Mostrar el porcentaje aproximado de CPU utilizada por instancia.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Explicación

La métrica `node_cpu_seconds_total` es acumulativa. Por eso se utiliza:

```promql
rate(...[5m])
```

para calcular la velocidad media de cambio durante los últimos cinco minutos.

El modo `idle` representa el tiempo en el que la CPU no está ejecutando trabajo.

La fórmula:

```text
100 - porcentaje de CPU inactiva
```

proporciona una aproximación del porcentaje de CPU utilizada.

### Resultado esperado

El resultado debe ser un valor comprendido aproximadamente entre:

```text
0 y 100
```

### Registro

```text
Consulta:

Instancia:

Valor mínimo:

Valor máximo:

Unidad:

Resultado:
```

### Comprobaciones

```text
¿Aparece la etiqueta instance?

¿El resultado es numérico?

¿El valor está entre 0 y 100?

¿El valor cambia con el tiempo?

¿La consulta devuelve una serie por instancia?
```

## Sesión 6: consultar la memoria

### Objetivo

Mostrar el porcentaje aproximado de memoria utilizada.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Explicación

La consulta calcula la memoria utilizada mediante:

```text
1 - memoria disponible / memoria total
```

Después multiplica el resultado por 100 para mostrar un porcentaje.

### Resultado esperado

```text
0 = memoria sin utilizar
100 = memoria completamente utilizada
```

El valor real dependerá de la actividad del servidor.

### Registro

```text
Consulta:

Instancia:

Memoria total:

Memoria disponible:

Porcentaje utilizado:

Unidad:

Resultado:
```

### Comprobaciones

```text
¿La consulta devuelve datos?

¿Aparece la etiqueta instance?

¿La unidad es porcentual?

¿El resultado es razonable?

¿La memoria disponible es menor que la memoria total?
```

## Sesión 7: consultar el almacenamiento

### Objetivo

Mostrar el porcentaje utilizado del sistema de ficheros raíz.

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

### Explicación

La consulta calcula el porcentaje utilizado mediante:

```text
1 - espacio disponible / espacio total
```

Se filtra el punto de montaje raíz:

```text
mountpoint="/"
```

También se excluyen algunos tipos de sistema de ficheros que pueden generar resultados poco relevantes:

```text
fstype!~"tmpfs|overlay"
```

### Resultado esperado

La consulta debe devolver un porcentaje aproximado de ocupación.

### Registro

```text
Consulta:

Instancia:

Punto de montaje:

Tipo de sistema de ficheros:

Porcentaje utilizado:

Unidad:

Resultado:
```

### Comprobaciones

```text
¿Aparece el punto de montaje raíz?

¿Se excluyen tmpfs y overlay?

¿Aparece más de una serie inesperada?

¿El porcentaje es razonable?

¿La consulta devuelve datos?
```

## Sesión 8: documentar las consultas

### Objetivo

Guardar las consultas utilizadas en el dashboard.

Crear el directorio:

```bash
mkdir -p ~/proyecto-final-grafana/evidencias/promql
```

Crear el fichero:

```bash
cat > ~/proyecto-final-grafana/evidencias/promql/consultas-primer-dashboard.md <<'EOF'
# Consultas del primer dashboard

## Disponibilidad

```promql
up{job="node_exporter"}
```

## CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Almacenamiento

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
EOF
```

Además de la consulta, documentar:

```text
Finalidad:

Unidad:

Panel en el que se utiliza:

Etiquetas esperadas:

Resultado de la prueba:
```

## Sesión 9: crear el dashboard

### Objetivo

Crear el dashboard que reunirá los paneles de la práctica.

### Procedimiento

1. Acceder a la sección de dashboards.
2. Crear un dashboard nuevo.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir la consulta de disponibilidad.
6. Configurar la visualización.
7. Guardar el panel.
8. Añadir los paneles restantes.
9. Guardar el dashboard completo.

### Nombre inicial

```text
Proyecto final - Primer dashboard
```

### Descripción

```text
Dashboard inicial para visualizar la disponibilidad,
CPU, memoria y almacenamiento del entorno de laboratorio.
```

### Configuración general

```text
Rango temporal:
Últimos 30 minutos

Intervalo de actualización:
30 segundos o 1 minuto

Fuente de datos:
Prometheus
```

### Registro

```text
Nombre del dashboard:

URL:

Fuente de datos:

Rango temporal:

Intervalo de actualización:

Número de paneles:

Resultado:
```

## Sesión 10: crear el panel de disponibilidad

### Objetivo

Crear un panel que muestre si Node Exporter está disponible.

### Consulta

```promql
up{job="node_exporter"}
```

### Visualización

Utilizar:

```text
Stat
```

### Configuración

```text
Título:
Disponibilidad de Node Exporter

Unidad:
none

Valor mínimo:
0

Valor máximo:
1
```

### Umbrales visuales

```text
0 = rojo
1 = verde
```

La configuración exacta de los umbrales puede variar según la versión de Grafana.

### Interpretación del panel

```text
1 = disponible
0 = no disponible
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Umbrales:

Resultado:
```

## Sesión 11: crear el panel de CPU

### Objetivo

Mostrar la evolución del uso de CPU.

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

### Configuración

```text
Título:
CPU utilizada por instancia

Unidad:
Percent (0-100)

Leyenda:
Visible

Rango temporal:
Últimos 30 minutos
```

### Umbrales visuales

```text
0-80 = verde
80-90 = amarillo
90-100 = rojo
```

### Comprobaciones

```text
¿La leyenda identifica la instancia?

¿La unidad aparece como porcentaje?

¿El eje vertical tiene una escala comprensible?

¿La serie cambia con el tiempo?

¿El panel se entiende sin abrir Explore?
```

### Registro

```text
Título:

Consulta:

Visualización:

Unidad:

Instancias mostradas:

Umbrales:

Resultado:
```

## Sesión 12: crear el panel de memoria

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

### Visualización

Utilizar:

```text
Gauge
```

También puede utilizarse:

```text
Time series
```

### Configuración

```text
Título:
Memoria utilizada por instancia

Unidad:
Percent (0-100)

Valor mínimo:
0

Valor máximo:
100
```

### Umbrales visuales

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

## Sesión 13: crear el panel de almacenamiento

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

### Configuración

```text
Título:
Almacenamiento utilizado en /

Unidad:
Percent (0-100)

Valor mínimo:
0

Valor máximo:
100
```

### Umbrales visuales

```text
0-70 = verde
70-80 = amarillo
80-100 = rojo
```

### Registro

```text
Título:

Consulta:

Punto de montaje:

Visualización:

Unidad:

Valor actual:

Umbrales:

Resultado:
```

## Sesión 14: organizar el dashboard

### Objetivo

Distribuir los paneles para facilitar la lectura.

### Distribución recomendada

```text
+--------------------------------------------------+
| Disponibilidad de Node Exporter                  |
+--------------------------------------------------+
| CPU utilizada por instancia                     |
+-------------------------+------------------------+
| Memoria utilizada       | Almacenamiento         |
+-------------------------+------------------------+
```

### Actividad

1. Colocar la disponibilidad en la parte superior.
2. Colocar la CPU en una posición visible.
3. Colocar memoria y almacenamiento en la misma fila.
4. Ajustar el tamaño de los paneles.
5. Alinear los paneles.
6. Revisar los títulos.
7. Guardar el dashboard.

### Preguntas

```text
¿La disponibilidad se ve inmediatamente?

¿Los paneles tienen un tamaño equilibrado?

¿La información importante está arriba?

¿Las unidades son visibles?

¿La leyenda ocupa demasiado espacio?
```

## Sesión 15: añadir una variable de instancia

### Objetivo

Permitir seleccionar una instancia desde el dashboard.

### Crear la variable

Nombre:

```text
instance
```

Consulta:

```promql
label_values(up{job="node_exporter"}, instance)
```

Si la función no está disponible, utilizar el mecanismo equivalente de la versión instalada.

### Aplicar la variable a CPU

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

### Aplicar la variable a memoria

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

### Aplicar la variable a disponibilidad

```promql
up{
  job="node_exporter",
  instance=~"$instance"
}
```

### Aplicar la variable a almacenamiento

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

### Pruebas

1. Seleccionar una instancia.
2. Revisar los paneles.
3. Seleccionar todas las instancias.
4. Comprobar que cambian los valores.
5. Revisar la leyenda.
6. Confirmar que no aparecen datos de otra instancia.

### Registro

```text
Nombre de la variable:

Consulta:

Valores disponibles:

Instancia seleccionada:

Resultado:

Problemas:
```

## Sesión 16: añadir una anotación manual

### Objetivo

Registrar un evento operativo en el dashboard.

Crear una anotación con:

```text
Título:
Inicio de la práctica 1

Descripción:
Se inicia la construcción del primer dashboard
del proyecto final en el entorno de laboratorio.
```

Etiquetas:

```text
event = practice-start
environment = laboratory
module = project-final
```

### Comprobar

1. Guardar la anotación.
2. Abrir el dashboard.
3. Seleccionar un rango temporal que incluya la anotación.
4. Confirmar que aparece sobre los paneles.
5. Abrir el detalle de la anotación.

### Registro

```text
Título:

Descripción:

Etiquetas:

Hora:

Visible en el dashboard:

Resultado:
```

## Sesión 17: revisar el dashboard con diferentes rangos temporales

### Objetivo

Comprobar cómo cambia la visualización según el periodo seleccionado.

### Rangos recomendados

```text
Últimos 5 minutos
Últimos 15 minutos
Últimos 30 minutos
Última hora
Últimas 6 horas
```

### Actividad

1. Seleccionar cada rango.
2. Observar el panel de CPU.
3. Observar el panel de memoria.
4. Observar el panel de almacenamiento.
5. Comprobar la visibilidad de la anotación.
6. Registrar las diferencias.

### Registro

```text
Rango temporal:

Panel de CPU:

Panel de memoria:

Panel de almacenamiento:

Anotación visible:

Observaciones:
```

### Preguntas

```text
¿Qué rango permite ver mejor un pico de CPU?

¿Qué rango permite identificar una tendencia?

¿Qué rango es más útil para una investigación rápida?

¿Qué ocurre con las anotaciones al cambiar el periodo?
```

## Sesión 18: revisar el intervalo de actualización

### Objetivo

Comprobar que el dashboard actualiza los datos automáticamente.

### Configuración

Utilizar inicialmente:

```text
Intervalo:
30 segundos
```

### Actividad

1. Abrir el dashboard.
2. Observar la hora de actualización.
3. Esperar un intervalo.
4. Comprobar que los paneles se actualizan.
5. Cambiar temporalmente a un minuto.
6. Comparar el comportamiento.

### Registro

```text
Intervalo utilizado:

Hora inicial:

Hora de actualización:

Paneles actualizados:

Resultado:
```

### Consideración operativa

Un intervalo demasiado corto puede aumentar la carga sobre Grafana y Prometheus. Un intervalo demasiado largo puede retrasar la visualización de cambios.

## Sesión 19: diagnosticar un panel sin datos

### Situación

```text
El panel aparece vacío o muestra No data.
```

### Procedimiento

1. Abrir la edición del panel.
2. Copiar la consulta.
3. Ejecutarla en Explore.
4. Comprobar la fuente de datos.
5. Revisar el rango temporal.
6. Revisar las etiquetas.
7. Revisar los filtros.
8. Revisar la variable seleccionada.
9. Comprobar la unidad.
10. Guardar el resultado.

### Posibles causas

```text
La fuente de datos es incorrecta.
La consulta no devuelve series.
El nombre del job es diferente.
La instancia seleccionada no existe.
El rango temporal es demasiado corto.
La variable no tiene valores.
La métrica no está disponible.
```

### Registro

```text
Panel:

Consulta:

Fuente de datos:

Rango temporal:

Variable:

Error observado:

Causa:

Corrección:

Resultado:
```

## Sesión 20: diagnosticar una unidad incorrecta

### Situación

```text
El panel muestra un valor numérico,
pero la unidad no es comprensible.
```

### Ejemplos de errores

```text
CPU mostrada como bytes.
Memoria mostrada como valor decimal sin porcentaje.
Almacenamiento mostrado como número absoluto.
Disponibilidad mostrada como porcentaje cuando debería ser 0 o 1.
```

### Procedimiento

1. Identificar la unidad real de la consulta.
2. Revisar el formato del panel.
3. Seleccionar la unidad correcta.
4. Guardar el panel.
5. Revisar la leyenda.
6. Documentar el cambio.

### Registro

```text
Panel:

Unidad inicial:

Unidad correcta:

Motivo:

Resultado:
```

## Sesión 21: revisar la legibilidad

### Objetivo

Evaluar el dashboard desde el punto de vista de un operador.

### Lista de comprobación

```text
[ ] Los títulos son claros.
[ ] No hay títulos duplicados.
[ ] Las unidades son correctas.
[ ] Las leyendas identifican las instancias.
[ ] Los colores tienen significado.
[ ] Los paneles importantes están arriba.
[ ] No hay demasiados paneles.
[ ] Las anotaciones son visibles.
[ ] El rango temporal es comprensible.
[ ] La información se entiende rápidamente.
```

### Actividad

Pedir a otro alumno que observe el dashboard durante un minuto y responda:

```text
¿Qué servidor está disponible?

¿Qué porcentaje de CPU utiliza?

¿Qué porcentaje de memoria utiliza?

¿Qué sistema de ficheros está representado?

¿Existe alguna señal visual de riesgo?
```

Si no puede responder, mejorar la organización del dashboard.

## Sesión 22: guardar y compartir el dashboard

### Objetivo

Guardar correctamente el resultado de la práctica.

### Procedimiento

1. Guardar el dashboard.
2. Copiar la URL.
3. Comprobar que la URL funciona.
4. Revisar los permisos de acceso.
5. Exportar el dashboard si está permitido.
6. Guardar el fichero de exportación.
7. Registrar la información.

### Registro

```text
Nombre:

UID:

URL:

Fuente de datos:

Fecha de guardado:

Fichero exportado:

Permisos:

Resultado:
```

## Sesión 23: preparar las evidencias

### Objetivo

Guardar capturas y documentos que demuestren el trabajo realizado.

Crear el directorio:

```bash
mkdir -p ~/proyecto-final-grafana/evidencias/dashboard
```

### Capturas recomendadas

```text
01-fuente-prometheus.png
02-consulta-disponibilidad.png
03-consulta-cpu.png
04-consulta-memoria.png
05-consulta-almacenamiento.png
06-dashboard-inicial.png
07-panel-disponibilidad.png
08-panel-cpu.png
09-panel-memoria.png
10-panel-almacenamiento.png
11-variable-instance.png
12-anotacion-dashboard.png
13-dashboard-final.png
```

### Revisión de seguridad

Antes de entregar las capturas:

- Ocultar contraseñas.
- Ocultar tokens.
- Ocultar claves API.
- Ocultar cookies.
- Ocultar URLs privadas.
- Confirmar que el entorno es de laboratorio.

## Sesión 24: completar el informe de la práctica

### Objetivo

Documentar las decisiones y los resultados.

### Plantilla

```markdown
# Informe - Práctica 1

## Identificación

Alumno:

Grupo:

Fecha:

Entorno:

## Objetivo

Crear un primer dashboard en Grafana
utilizando Prometheus como fuente de datos.

## Fuente de datos

Nombre:

Tipo:

URL:

Resultado de la prueba:

## Consultas utilizadas

### Disponibilidad

Consulta:

Finalidad:

Resultado:

### CPU

Consulta:

Finalidad:

Resultado:

### Memoria

Consulta:

Finalidad:

Resultado:

### Almacenamiento

Consulta:

Finalidad:

Resultado:

## Dashboard

Nombre:

URL:

Paneles creados:

Variable utilizada:

Rango temporal:

Intervalo de actualización:

## Problemas encontrados

Problema:

Causa:

Corrección:

Resultado:

## Evidencias

Listado de capturas y documentos.

## Conclusiones

Descripción de lo aprendido y mejoras propuestas.
```

## Ejemplo de resultado final

El dashboard puede presentar una distribución similar a:

```text
+--------------------------------------------------+
| Disponibilidad de Node Exporter: 1               |
+--------------------------------------------------+
| CPU utilizada por instancia                     |
| server-01:9100       24 %                        |
+-------------------------+------------------------+
| Memoria utilizada       | Almacenamiento         |
| 42 %                    | 61 %                   |
+-------------------------+------------------------+
```

Ejemplo de interpretación:

```text
Node Exporter está disponible.

La CPU se encuentra en un nivel normal.

La memoria utilizada no supera el umbral de advertencia.

El almacenamiento está por debajo del límite configurado.

El dashboard permite consultar la instancia seleccionada.
```

## Criterios de aceptación

La práctica se considera completada cuando:

- Grafana es accesible.
- Prometheus está configurado como fuente de datos.
- La fuente de datos responde correctamente.
- La consulta de disponibilidad devuelve datos.
- La consulta de CPU devuelve datos.
- La consulta de memoria devuelve datos.
- La consulta de almacenamiento devuelve datos.
- Se ha creado un dashboard.
- El dashboard contiene los cuatro paneles.
- Los paneles tienen títulos claros.
- Las unidades son correctas.
- Los umbrales visuales están configurados.
- La variable de instancia funciona, si el entorno la permite.
- Se ha creado una anotación.
- El dashboard se ha guardado.
- Las evidencias están organizadas.
- No se han incluido credenciales.
- Los problemas encontrados están documentados.

## Puntos clave

- Un dashboard reúne información operativa en una sola vista.
- Las consultas deben validarse antes de crear paneles.
- La fuente de datos debe comprobarse antes de investigar una consulta.
- La disponibilidad puede representarse mediante `up`.
- La CPU requiere calcular el porcentaje de tiempo no inactivo.
- La memoria puede expresarse como porcentaje utilizado.
- El almacenamiento debe filtrarse para evitar series irrelevantes.
- Cada panel debe tener un título descriptivo.
- Las unidades deben corresponder al resultado de la consulta.
- Los umbrales visuales ayudan a interpretar los valores.
- Una variable permite reutilizar el dashboard para varias instancias.
- Las anotaciones aportan contexto temporal.
- Un rango temporal demasiado corto puede ocultar tendencias.
- Un intervalo de actualización demasiado corto puede aumentar la carga.
- Un panel vacío debe investigarse desde la consulta y la fuente de datos.
- Las evidencias deben demostrar acciones concretas.
- El dashboard debe poder ser entendido por otra persona.
- La legibilidad es una característica técnica, no solo estética.
- La documentación debe incluir consultas, resultados y problemas.
- El primer dashboard servirá como base para el dashboard operativo.

## Preguntas de comprobación

1. ¿Qué función cumple un dashboard?
2. ¿Qué fuente de datos se utiliza en esta práctica?
3. ¿Qué consulta permite comprobar la disponibilidad de Node Exporter?
4. ¿Qué significa que la métrica `up` tenga el valor `1`?
5. ¿Qué significa que la métrica `up` tenga el valor `0`?
6. ¿Por qué se utiliza `rate` en la consulta de CPU?
7. ¿Qué representa el modo `idle`?
8. ¿Cómo se calcula el porcentaje de memoria utilizada?
9. ¿Por qué se filtra `mountpoint="/"` en la consulta de almacenamiento?
10. ¿Por qué se excluyen algunos sistemas de ficheros?
11. ¿Qué visualización es adecuada para mostrar un valor único de disponibilidad?
12. ¿Qué visualización es adecuada para mostrar una evolución temporal?
13. ¿Qué unidad debe utilizarse para CPU, memoria y almacenamiento?
14. ¿Qué función cumple una variable de dashboard?
15. ¿Qué revisarías si un panel muestra `No data`?
16. ¿Qué revisarías si un panel utiliza una unidad incorrecta?
17. ¿Por qué es importante configurar un intervalo de actualización?
18. ¿Qué información debe contener una anotación?
19. ¿Qué evidencias debes guardar de esta práctica?
20. ¿Cuándo se considera completado el primer dashboard?

## Resultado esperado

Al finalizar la práctica, el alumno deberá disponer de un dashboard funcional con la siguiente estructura:

```text
Dashboard:
Proyecto final - Primer dashboard
```

Paneles:

```text
Disponibilidad de Node Exporter
CPU utilizada por instancia
Memoria utilizada por instancia
Almacenamiento utilizado en /
```

El flujo completado será:

```text
Acceder a Grafana
        |
        v
Comprobar Prometheus
        |
        v
Ejecutar consultas PromQL
        |
        v
Validar los resultados
        |
        v
Crear el dashboard
        |
        v
Añadir los paneles
        |
        v
Configurar unidades y umbrales
        |
        v
Añadir una variable
        |
        v
Crear una anotación
        |
        v
Guardar el dashboard
        |
        v
Preparar las evidencias
        |
        v
Documentar el resultado
```

El alumno debe ser capaz de explicar qué muestra cada panel, qué consulta utiliza, qué unidad representa y qué decisiones ha tomado para organizar la información.

Este primer dashboard será la base para las siguientes prácticas, en las que se añadirán alertas, notificaciones, silenciamientos y pruebas operativas.