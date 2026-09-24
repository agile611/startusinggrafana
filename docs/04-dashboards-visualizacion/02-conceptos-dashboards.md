# Conceptos de dashboards

Un dashboard es una interfaz visual que reúne información relevante para facilitar la supervisión y el análisis de un sistema.

En Grafana, un dashboard se construye combinando paneles, consultas, visualizaciones, variables, rangos temporales, unidades y umbrales.

El objetivo no es mostrar el mayor número posible de métricas, sino presentar la información necesaria de forma clara y útil.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es un dashboard.
- Diferenciar entre dashboard, panel, consulta y visualización.
- Identificar los componentes principales de un dashboard.
- Seleccionar una visualización adecuada para cada tipo de dato.
- Configurar títulos, descripciones, unidades y leyendas.
- Utilizar rangos temporales.
- Configurar umbrales y colores.
- Interpretar correctamente los valores mostrados.
- Diseñar dashboards claros y fáciles de utilizar.
- Identificar errores habituales de diseño.
- Crear un dashboard básico con métricas de Prometheus y Node Exporter.

---

## Introducción

Grafana permite convertir métricas almacenadas en fuentes de datos como Prometheus en representaciones visuales.

El flujo general es:

```text
Fuente de datos
      |
      v
Consulta
      |
      v
Resultado
      |
      v
Visualización
      |
      v
Panel
      |
      v
Dashboard
```

Por ejemplo:

```text
Prometheus
      |
      v
Consulta PromQL: up
      |
      v
Resultado: 1 o 0
      |
      v
Panel Stat
      |
      v
Estado de los objetivos
```

Un dashboard bien diseñado debe ayudar a responder preguntas operativas:

- ¿El sistema está disponible?
- ¿Hay algún objetivo caído?
- ¿Qué servidor consume más CPU?
- ¿La memoria está cerca del límite?
- ¿Cuánto espacio queda en disco?
- ¿Desde cuándo se produce el problema?
- ¿El problema afecta a un único servidor o a varios?

Un dashboard no debe ser una colección desordenada de gráficos. Cada panel debe tener un propósito concreto.

---

## Componentes de un dashboard

## Dashboard

El dashboard es el contenedor principal.

Puede incluir:

- Paneles.
- Consultas.
- Variables.
- Rangos temporales.
- Enlaces.
- Anotaciones.
- Descripciones.
- Configuración de actualización.
- Permisos.

Ejemplo de nombre:

```text
Monitorización de servidores Linux
```

## Panel

Un panel es una unidad visual dentro del dashboard.

Ejemplos:

- Estado de los objetivos.
- Uso de CPU.
- Uso de memoria.
- Espacio utilizado.
- Tráfico de red.
- Carga del sistema.

Cada panel puede tener:

- Una o varias consultas.
- Una visualización.
- Un título.
- Una descripción.
- Una unidad.
- Umbrales.
- Una leyenda.
- Transformaciones.

## Consulta

La consulta obtiene datos desde la fuente configurada.

Ejemplo:

```promql
up
```

Esta consulta devuelve el estado de los objetivos monitorizados por Prometheus.

Otro ejemplo:

```promql
node_load1
```

Esta consulta devuelve la carga del sistema durante el último minuto.

## Visualización

La visualización define cómo se muestran los datos.

Algunas visualizaciones habituales son:

| Visualización | Uso recomendado |
|---|---|
| Stat | Mostrar un valor resumido |
| Gauge | Mostrar un valor frente a un rango |
| Bar Gauge | Comparar varios valores |
| Time series | Mostrar evolución temporal |
| Table | Mostrar datos tabulares |
| Heatmap | Mostrar distribuciones |
| Text | Añadir documentación |
| Canvas | Crear diseños personalizados |

## Fuente de datos

La fuente de datos es el sistema desde el que Grafana obtiene la información.

En este curso se utilizará principalmente:

```text
Prometheus
```

URL habitual:

```text
http://localhost:9090
```

La fuente de datos debe estar configurada antes de crear paneles con métricas.

## Rango temporal

El rango temporal determina qué periodo se consulta.

Ejemplos:

```text
Last 5 minutes
Last 15 minutes
Last 1 hour
Last 6 hours
Last 24 hours
Last 7 days
```

Un gráfico puede parecer vacío porque el rango temporal no contiene datos.

## Unidad

La unidad indica cómo debe interpretarse un valor.

Ejemplos:

| Métrica | Unidad recomendada |
|---|---|
| Uso de CPU | Percent (0-100) |
| Uso de memoria | Percent (0-100) |
| Memoria disponible | Bytes |
| Tráfico de red | Bytes/sec |
| Duración | Seconds |
| Temperatura | Celsius |
| Disponibilidad | None o Percent |

## Umbral

Un umbral define los límites entre distintos estados.

Ejemplo para el uso de memoria:

```text
0 - 70 %: normal
70 - 90 %: advertencia
90 - 100 %: crítico
```

Los umbrales suelen representarse mediante colores:

```text
Verde    Estado normal
Amarillo Advertencia
Rojo     Estado crítico
```

## Leyenda

La leyenda identifica las series representadas en un panel.

Una leyenda puede mostrar:

- Instancia.
- Job.
- Interfaz de red.
- Punto de montaje.
- Nombre de la métrica.
- Valor actual.
- Valor mínimo.
- Valor máximo.
- Promedio.

Una leyenda mal configurada puede dificultar la interpretación del gráfico.

---

## Diferencia entre métrica, consulta y panel

Estos conceptos están relacionados, pero no son equivalentes.

```text
Métrica:
node_memory_MemAvailable_bytes

Consulta:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Panel:
Uso de memoria

Visualización:
Gauge
```

La métrica es el dato original.

La consulta puede transformar o calcular un valor nuevo.

El panel contiene la consulta y muestra el resultado.

La visualización determina la forma en que se presenta.

---

## Tipos de información

## Valores individuales

Son valores que representan una situación actual.

Ejemplos:

- Objetivos disponibles.
- Porcentaje actual de memoria.
- Número de alertas.
- Estado de un servicio.

Visualizaciones apropiadas:

```text
Stat
Gauge
```

Consulta de ejemplo:

```promql
sum(up)
```

## Evolución temporal

Representa cómo cambia una métrica durante un periodo.

Ejemplos:

- CPU durante la última hora.
- Memoria durante las últimas seis horas.
- Tráfico de red.
- Carga del sistema.

Visualización apropiada:

```text
Time series
```

Consulta de ejemplo:

```promql
node_load1
```

## Comparación entre elementos

Permite comparar varias instancias, interfaces o sistemas de ficheros.

Ejemplos:

- CPU por servidor.
- Memoria por instancia.
- Tráfico por interfaz.
- Uso de disco por punto de montaje.

Visualizaciones apropiadas:

```text
Bar Gauge
Table
Time series
```

Consulta de ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Datos tabulares

Muestran filas y columnas con etiquetas y valores.

Visualización apropiada:

```text
Table
```

Consulta de ejemplo:

```promql
up
```

---

## Principios de diseño

## Mostrar primero la información importante

La parte superior del dashboard debe contener la información más relevante:

1. Disponibilidad.
2. Estado general.
3. Recursos críticos.
4. Problemas activos.
5. Detalle operativo.

Ejemplo:

```text
+------------------------------------------------------+
| Estado general y disponibilidad                      |
+----------------------+-------------------------------+
| Uso de CPU           | Uso de memoria                |
+----------------------+-------------------------------+
| Uso de almacenamiento| Carga del sistema             |
+----------------------+-------------------------------+
| Tráfico de red       | Información del sistema      |
+----------------------+-------------------------------+
```

## Utilizar títulos descriptivos

Evitar:

```text
Panel 1
Panel 2
Consulta A
```

Utilizar:

```text
Uso de CPU por instancia
Memoria utilizada
Estado de los objetivos
Espacio utilizado en /
```

## Utilizar unidades adecuadas

Un valor como:

```text
7340032000
```

es difícil de interpretar.

Con una unidad adecuada puede mostrarse como:

```text
6.84 GiB
```

La unidad no modifica el dato. Solo mejora su representación.

## Mantener una convención de colores

Utilizar colores consistentes:

```text
Verde: estado normal
Amarillo: advertencia
Rojo: estado crítico
Gris: sin datos o no aplicable
```

No se deben utilizar colores sin significado claro.

## Evitar la saturación de información

Un dashboard con demasiados paneles puede ser difícil de interpretar.

Es preferible:

- Utilizar menos paneles.
- Agrupar información relacionada.
- Ocultar detalles poco importantes.
- Crear dashboards especializados.
- Utilizar variables para cambiar el contexto.

## Añadir contexto

Un panel de texto puede explicar:

- Qué se está monitorizando.
- Qué significa cada color.
- Qué fuente de datos se utiliza.
- Qué rango temporal es recomendable.
- Qué hacer cuando aparece un valor crítico.

---

## Ejemplos de consultas PromQL

## Estado de los objetivos

```promql
up
```

Interpretación:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

## Número de objetivos disponibles

```promql
sum(up)
```

## Porcentaje de disponibilidad

```promql
100 * avg(up)
```

## Uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La consulta calcula el porcentaje de tiempo que no está en modo inactivo.

## Uso de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Uso del sistema de ficheros raíz

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

## Carga del sistema

```promql
node_load1
```

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

---

## Ejemplo de diseño

## Objetivo

Crear un dashboard llamado:

```text
Monitorización de servidor Linux
```

El dashboard tendrá los siguientes paneles:

| Orden | Panel | Visualización |
|---:|---|---|
| 1 | Descripción | Text |
| 2 | Estado de los objetivos | Table |
| 3 | Uso de CPU | Time series |
| 4 | Uso de memoria | Gauge |
| 5 | Uso del sistema de ficheros | Gauge |
| 6 | Carga del sistema | Time series |
| 7 | Tráfico recibido | Time series |

## Distribución propuesta

```text
+------------------------------------------------------+
| Descripción del dashboard                            |
+------------------------------------------------------+
| Estado de los objetivos                              |
+----------------------+-------------------------------+
| Uso de CPU           | Uso de memoria                |
+----------------------+-------------------------------+
| Uso de filesystem    | Carga del sistema             |
+----------------------+-------------------------------+
| Tráfico recibido     | Tráfico enviado               |
+----------------------+-------------------------------+
```

## Panel de descripción

Contenido:

```markdown
## Monitorización de servidor Linux

Este dashboard muestra el estado y el uso de recursos del servidor.

## Métricas incluidas

- Disponibilidad de los objetivos.
- Uso de CPU.
- Uso de memoria.
- Uso del sistema de ficheros.
- Carga del sistema.
- Tráfico de red.

## Colores

- Verde: estado normal.
- Amarillo: advertencia.
- Rojo: situación crítica.

## Fuente de datos

Prometheus.
```

---

## Ejemplo de sesión 1: comprobar el entorno

## Objetivo

Comprobar que los servicios necesarios están activos antes de trabajar con Grafana.

## Comandos

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active node_exporter
```

```bash
systemctl is-active grafana-server
```

```bash
curl http://localhost:9090/-/healthy
```

```bash
curl -I http://localhost:9100/metrics
```

```bash
curl -s http://localhost:3000/api/health | jq
```

## Resultado esperado

```text
active
active
active
Prometheus is Healthy.
HTTP/1.1 200 OK
```

La API de Grafana debe devolver un resultado con la base de datos en estado:

```json
{
  "database": "ok"
}
```

## Actividades

1. Comprueba el estado de los servicios.
2. Anota el resultado de cada comando.
3. Comprueba que Prometheus responde.
4. Comprueba que Node Exporter expone métricas.
5. Comprueba que Grafana responde.
6. Accede a Grafana desde el navegador.

---

## Ejemplo de sesión 2: comprobar la fuente de datos

## Objetivo

Comprobar que Grafana tiene configurada una fuente de datos Prometheus.

## Pasos

1. Acceder a:

```text
http://localhost:3000
```

2. Ir a:

```text
Connections → Data sources
```

3. Seleccionar la fuente Prometheus.
4. Revisar la URL configurada.
5. Pulsar **Save & test**.

La URL habitual será:

```text
http://localhost:9090
```

## Actividades

1. Anota el nombre de la fuente.
2. Anota la URL.
3. Comprueba si está configurada como predeterminada.
4. Comprueba que la prueba de conexión es correcta.
5. Explica por qué Grafana necesita una fuente de datos.

---

## Ejemplo de sesión 3: crear un dashboard básico

## Objetivo

Crear un dashboard con un panel de disponibilidad.

## Pasos

1. Ir a **Dashboards**.
2. Crear un dashboard nuevo.
3. Añadir un panel.
4. Seleccionar Prometheus.
5. Introducir la consulta:

```promql
up
```

6. Seleccionar la visualización:

```text
Table
```

7. Configurar el título:

```text
Estado de los objetivos
```

8. Guardar el panel.
9. Guardar el dashboard con el nombre:

```text
Monitorización de servidor Linux
```

## Actividades

1. Comprueba cuántos objetivos aparecen.
2. Identifica el job de Prometheus.
3. Identifica el job de Node Exporter.
4. Comprueba sus valores.
5. Explica el significado de cada valor.
6. Guarda una captura del panel.

---

## Ejemplo de sesión 4: comparar visualizaciones

## Objetivo

Comprobar que la misma consulta puede representarse mediante distintas visualizaciones.

Utilizar la consulta:

```promql
up
```

Probar las visualizaciones:

```text
Table
Stat
Gauge
Bar Gauge
Time series
```

## Actividades

Para cada visualización, responder:

1. ¿Se entiende correctamente el resultado?
2. ¿Es adecuada para esta consulta?
3. ¿Qué información muestra mejor?
4. ¿Qué información se pierde?
5. ¿En qué situación utilizarías esa visualización?

## Resultado esperado

La visualización `Table` suele ser adecuada para identificar los objetivos y sus etiquetas.

La visualización `Stat` puede ser adecuada para mostrar el número total de objetivos disponibles:

```promql
sum(up)
```

La visualización `Gauge` puede utilizarse para mostrar el porcentaje de disponibilidad:

```promql
100 * avg(up)
```

---

## Ejemplo de sesión 5: configurar unidades y umbrales

## Objetivo

Mostrar el uso de memoria como porcentaje y aplicar colores según su valor.

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Visualización

```text
Gauge
```

## Unidad

```text
Percent (0-100)
```

## Umbrales

```text
0     Verde
70    Amarillo
90    Rojo
```

## Actividades

1. Crea el panel.
2. Introduce la consulta.
3. Selecciona Gauge.
4. Configura la unidad.
5. Configura los umbrales.
6. Añade el título:

```text
Uso de memoria
```

7. Añade una descripción:

```text
Porcentaje de memoria utilizada en el servidor monitorizado.
```

8. Comprueba el color actual.
9. Explica qué ocurriría al superar el 90 %.

---

## Ejemplo de sesión 6: crear un panel temporal

## Objetivo

Representar la evolución del uso de CPU.

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
Visualización: Time series
Unidad: Percent (0-100)
Título: Uso de CPU
Rango temporal: Last 1 hour
```

## Actividades

1. Crea el panel.
2. Ejecuta la consulta.
3. Cambia el rango temporal.
4. Comprueba la leyenda.
5. Configura la unidad.
6. Genera carga temporal:

```bash
yes > /dev/null &
```

7. Observa el gráfico.
8. Detén el proceso:

```bash
pkill yes
```

9. Observa la recuperación.
10. Explica por qué se utiliza `rate()`.

---

## Ejemplo de sesión 7: organizar un dashboard

## Objetivo

Crear una organización visual clara.

Utilizar los siguientes paneles:

```text
Estado de los objetivos
Uso de CPU
Uso de memoria
Uso del sistema de ficheros
Carga del sistema
Tráfico recibido
Tráfico enviado
Descripción
```

## Actividades

1. Coloca la descripción en la parte superior.
2. Coloca la disponibilidad debajo de la descripción.
3. Agrupa CPU y memoria.
4. Agrupa almacenamiento y carga.
5. Coloca la red en la parte inferior.
6. Ajusta el tamaño de los paneles.
7. Evita que los títulos queden cortados.
8. Comprueba que el dashboard se entiende sin abrir los paneles.
9. Guarda los cambios.

---

## Ejemplo de sesión 8: comprobar un problema de datos

## Objetivo

Diferenciar entre un problema de Grafana, un problema de Prometheus y un problema de Node Exporter.

## Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

Esperar más de un intervalo de scraping.

## Consultar el estado

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
0
```

## Consultar el objetivo mediante la API

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

## Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

Esperar al siguiente scraping y volver a consultar:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

## Actividades

1. Anota el estado inicial.
2. Detén Node Exporter.
3. Comprueba cuándo aparece `DOWN`.
4. Consulta el error.
5. Inicia el servicio.
6. Comprueba la recuperación.
7. Explica qué paneles dejan de mostrar datos actuales.
8. Explica por qué pueden continuar apareciendo datos históricos.

---

## Ejemplo de sesión 9: aplicar una transformación

## Objetivo

Mostrar en una tabla únicamente la información relevante.

## Consulta

```promql
up
```

## Pasos

1. Crear un panel de tipo Table.
2. Ejecutar la consulta.
3. Abrir la sección **Transformations**.
4. Ocultar columnas innecesarias.
5. Mantener:

```text
job
instance
Value
```

6. Renombrar `Value` como:

```text
Estado
```

7. Ordenar por `job`.
8. Guardar el panel.

## Actividades

1. Compara el resultado antes y después de la transformación.
2. Explica qué columnas se han ocultado.
3. Explica por qué una transformación puede mejorar la legibilidad.
4. Comprueba que la transformación no elimina los datos originales de Prometheus.

---

## Buenas prácticas

## Utilizar nombres consistentes

Usar nombres claros y homogéneos:

```text
Uso de CPU
Uso de memoria
Uso del sistema de ficheros
Carga del sistema
Tráfico recibido
Tráfico enviado
```

## Configurar descripciones

Una descripción debe explicar:

- Qué representa el panel.
- Qué unidad utiliza.
- Qué periodo se consulta.
- Qué significa un valor elevado.
- Qué acción debe realizarse.

## Evitar consultas innecesariamente complejas

Una consulta debe ser suficientemente clara para que otro administrador pueda mantenerla.

## Usar agregaciones cuando sea necesario

Si una consulta devuelve demasiadas series, utilizar una agregación.

Ejemplo:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

## Filtrar datos irrelevantes

Excluir interfaces o sistemas de ficheros que no aporten información útil:

```promql
device!="lo"
```

```promql
fstype!~"tmpfs|overlay"
```

## Utilizar rangos temporales apropiados

Para observar actividad reciente:

```text
Last 15 minutes
```

Para analizar tendencias:

```text
Last 24 hours
```

Para estudiar cambios históricos:

```text
Last 7 days
```

## Diseñar para la acción

Cada panel debe ayudar a:

- Detectar un problema.
- Comprender el problema.
- Comparar el problema.
- Decidir una acción.

---

## Errores habituales

## Mostrar un valor sin unidad

Un valor como:

```text
0.734
```

puede ser ambiguo.

Debe aclararse si representa:

- Una proporción.
- Un porcentaje.
- Segundos.
- Bytes.
- Bytes por segundo.

## Usar una visualización inadecuada

Un Gauge no suele ser la mejor opción para representar una evolución temporal.

Un Time series no siempre es la mejor opción para mostrar un único valor actual.

## Mostrar demasiadas series

Un gráfico con cientos de series puede resultar ilegible.

En ese caso:

- Filtrar.
- Agrupar.
- Utilizar una tabla.
- Separar el dashboard.
- Añadir variables.

## No documentar los colores

El usuario debe conocer el significado de cada color.

## Colocar todos los paneles al mismo nivel

La distribución debe reflejar la importancia de la información.

## No probar los casos de error

Un dashboard debe probarse cuando:

- El objetivo está disponible.
- El objetivo está caído.
- No hay datos.
- La consulta es incorrecta.
- La fuente de datos no responde.

---

## Puntos clave

- Un dashboard agrupa información relacionada.
- Un panel es una visualización individual.
- Una consulta obtiene o calcula los datos.
- La visualización determina cómo se representan los datos.
- La fuente de datos proporciona la información a Grafana.
- Los paneles deben tener títulos descriptivos.
- Las unidades deben corresponder al significado de los datos.
- Los umbrales permiten comunicar estados.
- Los colores deben utilizarse con un significado coherente.
- La información más importante debe aparecer en la parte superior.
- Un dashboard debe ser claro, legible y accionable.
- La consulta `up` es una comprobación inicial fundamental.
- `rate()` permite calcular velocidades de cambio a partir de contadores.
- Las transformaciones modifican la presentación del resultado, no la métrica original.
- Los rangos temporales influyen directamente en los datos visibles.
- Un panel sin datos requiere comprobar la consulta, la fuente y los objetivos.
- Un dashboard debe probarse tanto en situaciones normales como de error.
- La documentación forma parte del diseño técnico del dashboard.

---

## Preguntas de comprobación

1. ¿Qué es un dashboard?
2. ¿Qué diferencia existe entre un dashboard y un panel?
3. ¿Qué función cumple una fuente de datos?
4. ¿Qué función cumple una consulta?
5. ¿Qué función cumple una visualización?
6. ¿Para qué utilizarías un panel Stat?
7. ¿Para qué utilizarías un panel Gauge?
8. ¿Para qué utilizarías un panel Time series?
9. ¿Para qué utilizarías un panel Table?
10. ¿Qué significa el valor `1` en la consulta `up`?
11. ¿Qué significa el valor `0` en la consulta `up`?
12. ¿Qué unidad utilizarías para mostrar el uso de CPU?
13. ¿Qué unidad utilizarías para mostrar el tráfico de red?
14. ¿Qué función cumplen los umbrales?
15. ¿Qué significado pueden tener los colores verde, amarillo y rojo?
16. ¿Por qué es importante utilizar títulos descriptivos?
17. ¿Qué problema puede producir un rango temporal incorrecto?
18. ¿Por qué puede ser necesario utilizar una agregación?
19. ¿Qué función cumple una transformación?
20. ¿Qué comprobarías si un panel no muestra datos?
21. ¿Qué consulta utilizarías para comprobar la disponibilidad?
22. ¿Qué consulta utilizarías para mostrar la carga del sistema?
23. ¿Por qué se utiliza `rate()` en la consulta de CPU?
24. ¿Qué paneles colocarías en la parte superior de un dashboard?
25. ¿Qué características debe tener un dashboard bien diseñado?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de diseñar un dashboard básico siguiendo este proceso:

```text
Definir el objetivo
        |
        v
Seleccionar las métricas
        |
        v
Crear las consultas
        |
        v
Elegir las visualizaciones
        |
        v
Configurar unidades y umbrales
        |
        v
Organizar los paneles
        |
        v
Añadir documentación
        |
        v
Probar datos normales y errores
        |
        v
Guardar y revisar el dashboard
```

El resultado debe ser un dashboard que permita comprender rápidamente el estado del sistema sin necesidad de inspeccionar manualmente cada métrica.