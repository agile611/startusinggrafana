# Transformaciones

Las **transformaciones** de Grafana permiten modificar los datos devueltos por una o varias consultas antes de mostrarlos en un panel.

Una transformación puede:

- Renombrar campos.
- Ocultar columnas.
- Filtrar filas.
- Ordenar resultados.
- Combinar consultas.
- Convertir series temporales en tablas.
- Crear campos calculados.
- Agrupar valores.
- Unir resultados.
- Limitar el número de registros.
- Convertir etiquetas en columnas.
- Preparar los datos para una visualización concreta.

El flujo general es:

```text
Consulta
   |
   v
Datos devueltos por la fuente
   |
   v
Transformaciones
   |
   v
Visualización
```

Una transformación no modifica los datos originales almacenados en Prometheus. Solo modifica el resultado que recibe el panel.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es una transformación en Grafana.
- Diferenciar una transformación de una consulta PromQL.
- Acceder al editor de transformaciones.
- Renombrar campos.
- Ocultar campos innecesarios.
- Ordenar resultados.
- Filtrar filas.
- Limitar el número de resultados.
- Convertir etiquetas en campos.
- Convertir datos temporales en filas y columnas.
- Unir resultados de varias consultas.
- Concatenar resultados.
- Crear campos calculados.
- Calcular diferencias, sumas y porcentajes.
- Reducir una serie temporal a un único valor.
- Utilizar transformaciones con paneles Table.
- Utilizar transformaciones con paneles Stat.
- Utilizar transformaciones con paneles Bar Gauge.
- Diagnosticar errores producidos por transformaciones.
- Comprender el orden de ejecución de las transformaciones.
- Documentar transformaciones aplicadas a un panel.
- Aplicar transformaciones sin ocultar información importante.

---

## Introducción

Las fuentes de datos devuelven datos en un formato que no siempre coincide con la visualización deseada.

Por ejemplo, una consulta Prometheus puede devolver:

```text
instance="server-01:9100"
job="node_exporter"
Value=73.42
```

Sin transformación, el panel puede mostrar un nombre largo y poco cómodo.

Después de aplicar transformaciones, puede mostrarse:

| Servidor | CPU |
|---|---:|
| server-01 | 73.42 % |

La transformación no ha cambiado la métrica original. Solo ha cambiado la forma en que Grafana la presenta.

### Ejemplo conceptual

```text
Resultado original:
{instance="server-01:9100", job="node_exporter"} 73.42

Transformaciones:
1. Convertir etiquetas en campos.
2. Renombrar instance como Servidor.
3. Ocultar job.
4. Redondear CPU.
5. Ordenar por CPU.

Resultado final:
Servidor      CPU
server-01     73.4 %
```

---

## Consulta, transformación y visualización

Estos tres elementos cumplen funciones diferentes.

### Consulta

Obtiene datos de la fuente.

Ejemplo:

```promql
up
```

### Transformación

Modifica la estructura o el contenido del resultado.

Ejemplos:

- Renombrar `instance`.
- Ocultar `job`.
- Ordenar por valor.
- Crear una columna calculada.

### Visualización

Representa el resultado.

Ejemplos:

- Table.
- Stat.
- Gauge.
- Bar Gauge.
- Time series.

El flujo completo es:

```text
PromQL:
up
   |
   v
Resultado:
instance, job, Value
   |
   v
Transformación:
renombrar, ocultar y ordenar
   |
   v
Visualización:
Table
```

---

## Cuándo utilizar transformaciones

Las transformaciones son apropiadas cuando:

- La consulta devuelve datos correctos, pero poco legibles.
- Se necesitan combinar consultas.
- Se desea ocultar campos técnicos.
- Se necesita preparar una tabla.
- Se quiere calcular una columna adicional.
- Se desea ordenar o filtrar resultados.
- Se necesita adaptar una consulta a una visualización.
- La operación no resulta sencilla o cómoda en PromQL.

### Ejemplos

- Convertir `instance` en una columna visible.
- Mostrar solo los cinco servidores con más CPU.
- Unir CPU y memoria en una tabla.
- Calcular la diferencia entre dos consultas.
- Reducir una serie temporal al último valor.
- Crear una columna `Estado`.
- Ocultar etiquetas internas.

---

## Cuándo no utilizar transformaciones

No conviene utilizar transformaciones cuando:

- La operación puede expresarse claramente en PromQL.
- La transformación oculta la lógica de cálculo.
- Se aplica demasiada lógica en el panel.
- El resultado se vuelve difícil de mantener.
- El mismo cálculo se necesita en muchos dashboards.
- Se produce una gran cantidad de datos innecesarios.
- La transformación aumenta excesivamente el coste de Grafana.

### Regla práctica

Utilizar PromQL para:

- Filtrar métricas.
- Agregar series.
- Calcular tasas.
- Calcular porcentajes.
- Reducir el volumen de datos.

Utilizar transformaciones para:

- Preparar la presentación.
- Renombrar campos.
- Ordenar resultados.
- Unir resultados.
- Ocultar columnas.
- Crear estructuras para una visualización concreta.

---

## Acceder al editor de transformaciones

Procedimiento general:

1. Abrir un dashboard.
2. Editar un panel.
3. Acceder a la pestaña **Transformations**.
4. Seleccionar **Add transformation**.
5. Elegir una transformación.
6. Configurar sus opciones.
7. Revisar la vista previa.
8. Añadir otra transformación si es necesario.
9. Guardar el panel.
10. Guardar el dashboard.

La interfaz exacta puede variar según la versión de Grafana.

### Orden de las transformaciones

Las transformaciones se ejecutan en el orden en que aparecen.

Ejemplo:

```text
1. Convertir etiquetas en campos.
2. Filtrar filas.
3. Renombrar campos.
4. Ordenar resultados.
5. Ocultar columnas.
```

Cambiar el orden puede cambiar el resultado.

---

## Resultado de datos y data frames

Grafana trabaja internamente con estructuras de datos llamadas **data frames**.

Un data frame puede contener:

- Campos.
- Tipos.
- Valores.
- Etiquetas.
- Timestamps.
- Metadatos.

Ejemplo conceptual:

```text
Frame:
  Time
  instance
  job
  Value
```

Una transformación puede:

- Añadir campos.
- Eliminar campos.
- Cambiar tipos.
- Cambiar nombres.
- Convertir filas en columnas.
- Combinar varios frames.

Comprender esta estructura ayuda a interpretar por qué una transformación funciona en una tabla, pero no produce el resultado esperado en un gráfico temporal.

---

## Transformación: Organize fields by name

La transformación **Organize fields by name** permite organizar los campos de un resultado.

Puede utilizarse para:

- Cambiar el orden de las columnas.
- Renombrar columnas.
- Ocultar columnas.
- Mostrar únicamente los campos necesarios.

### Resultado original

| Time | instance | job | Value |
|---|---|---|---:|
| 17:00 | server-01:9100 | node_exporter | 73.42 |

### Resultado organizado

| Servidor | CPU |
|---|---:|
| server-01:9100 | 73.42 |

### Operaciones habituales

```text
Renombrar instance → Servidor
Renombrar Value → CPU
Ocultar Time
Ocultar job
Reordenar columnas
```

### Cuándo utilizarla

- Paneles Table.
- Tablas de inventario.
- Resultados con muchas etiquetas.
- Paneles operativos.
- Paneles que deben mostrar solo unas pocas columnas.

---

## Transformación: Filter fields by name

Permite incluir o excluir campos por nombre o patrón.

### Ejemplo

Resultado:

```text
Time
instance
job
mode
Value
```

Con un filtro se pueden mostrar únicamente:

```text
instance
Value
```

### Utilidad

- Ocultar timestamps.
- Ocultar etiquetas técnicas.
- Mostrar solo columnas relevantes.
- Reducir el ruido visual.

### Precaución

No ocultar campos necesarios para identificar correctamente los valores.

Por ejemplo, ocultar `instance` en un resultado con varios servidores puede hacer imposible saber a qué servidor pertenece cada valor.

---

## Transformación: Rename by regex

Permite cambiar nombres utilizando expresiones regulares.

### Ejemplo

Campo original:

```text
server-01:9100
```

Nombre deseado:

```text
server-01
```

Se puede utilizar una expresión que elimine el puerto.

Conceptualmente:

```text
Expresión:
:(.*)$

Sustitución:
```

### Otro ejemplo

Campo original:

```text
node_cpu_seconds_total
```

Nombre deseado:

```text
CPU
```

### Cuándo utilizarla

- Simplificar nombres largos.
- Eliminar puertos.
- Normalizar nombres.
- Cambiar prefijos.
- Crear etiquetas más legibles.

### Precauciones

- Probar la expresión con varios valores.
- Comprobar que no se eliminan partes importantes.
- Documentar la expresión.
- Revisar el resultado si aparecen nombres duplicados.

---

## Transformación: Filter data by values

Permite filtrar filas según el valor de un campo.

### Ejemplo

Supongamos una tabla:

| Servidor | CPU |
|---|---:|
| server-01 | 45 |
| server-02 | 82 |
| server-03 | 94 |

Filtrar:

```text
CPU mayor que 80
```

Resultado:

| Servidor | CPU |
|---|---:|
| server-02 | 82 |
| server-03 | 94 |

### Usos habituales

- Mostrar servidores con CPU elevada.
- Mostrar discos por encima de un umbral.
- Mostrar únicamente errores.
- Ocultar interfaces sin tráfico.
- Filtrar servicios concretos.

### Diferencia con PromQL

Filtrar en PromQL suele reducir los datos antes de que lleguen a Grafana.

Filtrar mediante transformación actúa después de recibirlos.

Para grandes volúmenes, suele ser más eficiente filtrar en PromQL.

---

## Transformación: Limit

Permite limitar el número de filas mostradas.

### Ejemplo

Resultado original:

```text
20 servidores
```

Aplicar:

```text
Limit: 5
```

Resultado:

```text
5 filas
```

### Importante

El resultado depende del orden aplicado.

#### Orden incorrecto

```text
1. Limitar a 5.
2. Ordenar por CPU.
```

En este caso pueden mostrarse cinco servidores que no son los de mayor CPU.

#### Orden recomendado

```text
1. Ordenar por CPU descendente.
2. Limitar a 5.
```

Resultado:

```text
Los cinco servidores con mayor CPU
```

---

## Transformación: Sort by

Permite ordenar filas según uno o varios campos.

### Ejemplo

| Servidor | CPU |
|---|---:|
| server-01 | 45 |
| server-02 | 82 |
| server-03 | 94 |

Orden descendente:

| Servidor | CPU |
|---|---:|
| server-03 | 94 |
| server-02 | 82 |
| server-01 | 45 |

### Usos

- Mostrar primero los valores críticos.
- Ordenar por nombre.
- Ordenar por memoria.
- Ordenar por almacenamiento.
- Ordenar por latencia.

### Combinación habitual

```text
1. Convertir etiquetas en campos.
2. Ordenar por valor descendente.
3. Limitar a 5.
4. Organizar campos.
```

---

## Transformación: Reduce

La transformación **Reduce** convierte varios valores en un valor reducido.

Reducciones habituales:

- Last.
- Last not null.
- First.
- Mean.
- Min.
- Max.
- Sum.
- Count.
- Range.

### Ejemplo

Serie temporal:

```text
17:00 → 42
17:05 → 51
17:10 → 67
```

Aplicar:

```text
Reduce: Last
```

Resultado:

```text
67
```

Aplicar:

```text
Reduce: Mean
```

Resultado:

```text
53.3
```

### Usos habituales

- Crear un Stat a partir de una serie temporal.
- Mostrar el último valor.
- Calcular un promedio.
- Obtener el máximo de un intervalo.
- Crear una tabla resumen.

### Precaución

El método de reducción debe coincidir con el significado del panel.

Por ejemplo:

- Disponibilidad actual: `Last`.
- CPU máxima del intervalo: `Max`.
- CPU media del intervalo: `Mean`.
- Número de muestras: `Count`.

---

## Transformación: Labels to fields

Convierte etiquetas de una serie en campos o columnas.

### Resultado original

```text
{instance="server-01:9100", job="node_exporter"} 73.4
```

### Después de convertir etiquetas

| instance | job | Value |
|---|---|---:|
| server-01:9100 | node_exporter | 73.4 |

### Usos

- Crear tablas.
- Mostrar etiquetas como columnas.
- Preparar datos para unir consultas.
- Mostrar instancias y valores.
- Convertir resultados Prometheus en estructura tabular.

### Ejemplo de resultado final

| Servidor | Job | CPU |
|---|---|---:|
| server-01:9100 | node_exporter | 73.4 |
| server-02:9100 | node_exporter | 82.1 |

Después se puede utilizar **Organize fields by name** para:

```text
instance → Servidor
Value → CPU
```

---

## Transformación: Series to rows

Convierte series en una tabla de filas.

### Resultado original

Varias series temporales:

```text
CPU{instance="server-01"}
CPU{instance="server-02"}
```

### Resultado conceptual

| Metric | Time | Value |
|---|---|---:|
| CPU server-01 | 17:00 | 42 |
| CPU server-01 | 17:05 | 51 |
| CPU server-02 | 17:00 | 62 |
| CPU server-02 | 17:05 | 74 |

### Usos

- Inspeccionar datos temporales.
- Crear una tabla de muestras.
- Analizar series individualmente.
- Preparar datos para otras transformaciones.

### Precaución

Puede generar muchas filas si el rango temporal es grande.

---

## Transformación: Time series to table

Convierte datos de series temporales en una tabla.

### Ejemplo

Consulta:

```promql
node_load1
```

Resultado temporal:

```text
Time                  server-01
17:00                 0.42
17:05                 0.51
17:10                 0.63
```

Después de la transformación:

| Time | server-01 |
|---|---:|
| 17:00 | 0.42 |
| 17:05 | 0.51 |
| 17:10 | 0.63 |

### Usos

- Revisar valores concretos.
- Exportar datos.
- Crear tablas de auditoría.
- Preparar datos para cálculos.

---

## Transformación: Join by field

Combina resultados utilizando un campo común.

### Consulta A: CPU

```promql
100 - (
  avg by (instance) (
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

Ambas consultas pueden compartir:

```text
instance
```

### Resultado combinado

| instance | CPU | Memoria |
|---|---:|---:|
| server-01:9100 | 42 | 61 |
| server-02:9100 | 78 | 74 |

### Tipos de unión

Según la versión pueden existir opciones como:

- Inner join.
- Outer join.
- Join by field.
- Join by labels.

### Diferencia conceptual

#### Inner join

Muestra solo los elementos presentes en ambos resultados.

#### Outer join

Puede conservar elementos aunque falten en uno de los resultados.

### Precauciones

- El campo de unión debe tener el mismo nombre.
- Los valores deben coincidir.
- Las etiquetas deben estar disponibles.
- Diferencias como `server-01` frente a `server-01:9100` pueden impedir la unión.

---

## Transformación: Concatenate fields

Combina campos o resultados en una estructura común.

Puede utilizarse para:

- Unir tablas.
- Añadir filas.
- Combinar resultados con la misma estructura.
- Construir una tabla común.

### Ejemplo

Consulta A:

| Servidor | CPU |
|---|---:|
| server-01 | 42 |

Consulta B:

| Servidor | CPU |
|---|---:|
| server-02 | 78 |

Resultado concatenado:

| Servidor | CPU |
|---|---:|
| server-01 | 42 |
| server-02 | 78 |

### Diferencia con Join

```text
Join:
Combina columnas usando una clave común.

Concatenate:
Añade resultados con una estructura compatible.
```

---

## Transformación: Add field from calculation

Permite crear un campo calculado a partir de otros campos.

### Ejemplo

Si una tabla contiene:

| CPU | Memoria |
|---:|---:|
| 42 | 61 |

Se puede crear:

```text
Promedio de recursos = (CPU + Memoria) / 2
```

Resultado:

| CPU | Memoria | Promedio |
|---:|---:|---:|
| 42 | 61 | 51.5 |

### Operaciones posibles

Según la versión y la configuración:

- Suma.
- Resta.
- Multiplicación.
- División.
- Diferencia.
- Porcentaje.
- Operaciones binarias.
- Operaciones entre campos.

### Ejemplo de porcentaje

Si se dispone de:

```text
Disponible
Total
```

Calcular:

```text
100 * Disponible / Total
```

### Precauciones

- Comprobar las unidades.
- Evitar dividir entre cero.
- Comprobar valores nulos.
- Documentar la fórmula.
- No crear campos con nombres ambiguos.

---

## Transformación: Group by

Agrupa filas según uno o varios campos.

### Ejemplo original

| Servicio | Estado | Valor |
|---|---|---:|
| api | UP | 1 |
| api | UP | 1 |
| web | UP | 1 |
| web | DOWN | 0 |

Agrupar por:

```text
Servicio
```

Puede permitir calcular:

- Count.
- Sum.
- Mean.
- Min.
- Max.

Resultado conceptual:

| Servicio | Count | Sum |
|---|---:|---:|
| api | 2 | 2 |
| web | 2 | 1 |

### Usos

- Agrupar instancias por servicio.
- Contar estados.
- Calcular valores por equipo.
- Resumir resultados.

---

## Transformación: Convert field type

Permite cambiar el tipo de un campo.

Ejemplos:

```text
Texto → Número
Número → Texto
Texto → Tiempo
```

### Problema habitual

Una tabla puede contener:

```text
CPU = "73.4"
```

como texto en lugar de número.

En ese caso, ordenar puede producir:

```text
100
20
73.4
```

porque se ordena alfabéticamente.

Convertir el campo a número permite ordenar correctamente:

```text
100
73.4
20
```

### Precauciones

- Comprobar el formato original.
- Revisar separadores decimales.
- Revisar unidades incluidas en el texto.
- No intentar convertir valores como `73.4 %` directamente sin limpiar el símbolo.

---

## Transformación: Config from query results

Permite utilizar el resultado de una consulta para configurar propiedades de otro panel.

Puede utilizarse para obtener dinámicamente:

- Umbrales.
- Límites.
- Unidades.
- Colores.
- Configuración por campo.
- Rangos.

La disponibilidad y el comportamiento exacto dependen de la versión de Grafana y del tipo de panel.

### Ejemplo conceptual

Una consulta devuelve:

| Métrica | Warning | Critical |
|---|---:|---:|
| CPU | 70 | 90 |

Otra consulta utiliza esos valores para configurar el panel.

### Precauciones

- Documentar la consulta de configuración.
- Comprobar qué campos se utilizan.
- Revisar el comportamiento cuando falta un valor.
- Evitar configuraciones difíciles de mantener.

---

## Transformación: Partition by values

Divide los datos en grupos según el valor de un campo.

### Ejemplo

Tabla:

| Entorno | Servidor | CPU |
|---|---|---:|
| Producción | server-01 | 72 |
| Producción | server-02 | 83 |
| Laboratorio | lab-01 | 34 |

Particionar por:

```text
Entorno
```

Resultado conceptual:

```text
Frame Producción:
server-01  72
server-02  83

Frame Laboratorio:
lab-01      34
```

### Usos

- Separar producción y laboratorio.
- Crear grupos por equipo.
- Separar servicios.
- Generar varios resultados visuales.

---

## Transformación: Group to nested tables

Puede organizar datos relacionados en estructuras anidadas o agrupadas.

Es útil cuando se necesita:

- Presentar información por grupo.
- Separar equipos.
- Mostrar una estructura jerárquica.
- Preparar tablas complejas.

Debe utilizarse con moderación porque las estructuras demasiado complejas dificultan la lectura y el mantenimiento.

---

## Transformaciones y múltiples consultas

Un panel puede tener varias consultas:

```text
A: CPU
B: Memoria
C: Almacenamiento
```

Las transformaciones pueden aplicarse:

- A todas las consultas.
- A una consulta concreta.
- A un frame concreto.
- A los resultados combinados.

### Ejemplo

```text
Consulta A:
CPU por instancia

Consulta B:
Memoria por instancia

Transformaciones:
1. Labels to fields.
2. Join by field usando instance.
3. Rename fields.
4. Sort by CPU.
5. Organize fields.
```

Resultado:

| Servidor | CPU | Memoria |
|---|---:|---:|
| server-02 | 82 | 74 |
| server-01 | 42 | 61 |

---

## Ejemplo completo 1: tabla de CPU por instancia

### Objetivo

Crear una tabla legible con el uso de CPU por instancia.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Transformaciones

#### 1. Labels to fields

Convertir `instance` en una columna.

#### 2. Organize fields by name

Configurar:

```text
instance → Servidor
Value → CPU
```

Ocultar:

```text
Time
job
```

#### 3. Sort by

Ordenar:

```text
CPU descendente
```

### Resultado

| Servidor | CPU |
|---|---:|
| server-02:9100 | 82.1 |
| server-01:9100 | 42.3 |

---

## Ejemplo completo 2: cinco servidores con más CPU

### Objetivo

Mostrar únicamente los servidores con mayor uso.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Transformaciones

```text
1. Labels to fields.
2. Organize fields by name.
3. Sort by CPU descendente.
4. Limit a 5.
```

### Resultado

```text
Se muestran los cinco servidores con mayor CPU.
```

### Alternativa con PromQL

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

### Comparación

```text
topk() en PromQL:
Reduce datos antes de enviarlos a Grafana.

Sort + Limit:
Recibe todos los datos y los procesa en Grafana.
```

Para grandes volúmenes, `topk()` suele ser más eficiente.

---

## Ejemplo completo 3: tabla de CPU y memoria

### Objetivo

Combinar CPU y memoria en una única tabla.

### Consulta A: CPU

```promql
100 - (
  avg by (instance) (
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

### Transformaciones

```text
1. Labels to fields.
2. Join by field usando instance.
3. Organize fields by name.
4. Rename fields.
5. Sort by CPU descendente.
```

### Resultado

| Servidor | CPU | Memoria |
|---|---:|---:|
| server-02:9100 | 82.1 | 74.5 |
| server-01:9100 | 42.3 | 61.2 |

### Descripción

```text
Comparación de CPU y memoria por instancia.
Los resultados se unen mediante la etiqueta instance.
```

---

## Ejemplo completo 4: crear un campo de estado

### Objetivo

Añadir una columna textual según el valor de disponibilidad.

### Consulta

```promql
up
```

### Resultado original

| instance | Value |
|---|---:|
| server-01:9100 | 1 |
| server-02:9100 | 0 |

### Transformaciones posibles

1. Labels to fields.
2. Rename fields.
3. Add field from calculation o Value mappings, según la versión.
4. Crear o representar el estado.

### Resultado deseado

| Servidor | Estado |
|---|---|
| server-01:9100 | UP |
| server-02:9100 | DOWN |

Si la transformación no permite convertir directamente `1` y `0` en texto, utilizar los **Value mappings** de la visualización Table o Stat.

---

## Ejemplo completo 5: calcular diferencia entre servidores

### Objetivo

Comparar el uso de CPU de dos instancias.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Transformaciones

1. Convertir etiquetas en campos.
2. Filtrar o seleccionar dos servidores.
3. Reducir cada serie al último valor.
4. Utilizar `Add field from calculation`.
5. Calcular:

```text
CPU servidor A - CPU servidor B
```

### Resultado conceptual

```text
CPU server-01: 42 %
CPU server-02: 78 %

Diferencia: 36 puntos porcentuales
```

### Precaución

La diferencia debe interpretarse como diferencia de puntos porcentuales, no como porcentaje relativo, salvo que se calcule explícitamente.

---

## Ejemplo completo 6: transformar una serie temporal en Stat

### Objetivo

Mostrar en un panel Stat el último valor de una métrica temporal.

### Consulta

```promql
node_load1
```

### Transformación

```text
Reduce
Método: Last not null
```

### Visualización

```text
Stat
```

### Resultado

```text
0.82
```

### Variantes

```text
Last: valor actual
Mean: valor medio del intervalo
Max: pico del intervalo
Min: valor mínimo
```

---

## Ejemplo completo 7: tabla de uso de almacenamiento

### Objetivo

Crear una tabla de sistemas de ficheros ordenados por ocupación.

### Consulta

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

### Transformaciones

```text
1. Labels to fields.
2. Organize fields.
3. Rename mountpoint → Punto de montaje.
4. Rename instance → Servidor.
5. Rename Value → Uso.
6. Sort by Uso descendente.
7. Filter data by values si se desea mostrar Uso > 80.
```

### Resultado

| Servidor | Punto de montaje | Uso |
|---|---|---:|
| server-02:9100 | /var | 92.3 |
| server-01:9100 | / | 81.7 |

---

## Ejemplo de sesión 1: renombrar y ocultar campos

### Objetivo

Crear una tabla legible a partir de una consulta Prometheus.

### Pasos

1. Crear un panel nuevo.
2. Introducir:

```promql
up
```

3. Seleccionar la visualización `Table`.
4. Abrir **Transformations**.
5. Añadir `Labels to fields`.
6. Añadir `Organize fields by name`.
7. Renombrar:

```text
instance → Servidor
job → Servicio
Value → Estado
```

8. Ocultar:

```text
Time
```

9. Guardar el panel.

### Actividades

1. Añade una columna de estado legible.
2. Ordena por servidor.
3. Compara la tabla original con la transformada.
4. Explica qué campos se han eliminado y por qué.

---

## Ejemplo de sesión 2: ordenar y limitar resultados

### Objetivo

Mostrar los tres servidores con mayor uso de CPU.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Pasos

1. Crear un panel Table.
2. Añadir la consulta.
3. Añadir `Labels to fields`.
4. Añadir `Organize fields by name`.
5. Renombrar `Value` como `CPU`.
6. Añadir `Sort by`.
7. Ordenar `CPU` de forma descendente.
8. Añadir `Limit`.
9. Establecer:

```text
Limit: 3
```

10. Guardar el panel.

### Actividades

1. Cambia el límite a `5`.
2. Cambia el orden a ascendente.
3. Explica qué servidores aparecen.
4. Repite el ejercicio utilizando `topk(3, ...)` en PromQL.
5. Compara ambos enfoques.

---

## Ejemplo de sesión 3: unir CPU y memoria

### Objetivo

Crear una tabla que muestre dos recursos por instancia.

### Consulta A

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Consulta B

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Pasos

1. Crear un panel Table.
2. Añadir las dos consultas.
3. Añadir `Labels to fields`.
4. Comprobar que ambas consultas tienen `instance`.
5. Añadir `Join by field`.
6. Seleccionar `instance`.
7. Añadir `Organize fields by name`.
8. Renombrar:
   - `instance` → `Servidor`
   - `Value A` → `CPU`
   - `Value B` → `Memoria`
9. Guardar el panel.

### Actividades

1. Ordena por CPU.
2. Oculta campos duplicados.
3. Añade almacenamiento como tercera consulta.
4. Explica qué ocurre si una instancia no aparece en una de las consultas.

---

## Ejemplo de sesión 4: crear un campo calculado

### Objetivo

Crear una columna de promedio de CPU y memoria.

### Datos de partida

| Servidor | CPU | Memoria |
|---|---:|---:|
| server-01 | 42 | 61 |
| server-02 | 78 | 74 |

### Pasos

1. Crear la tabla de CPU y memoria.
2. Añadir `Add field from calculation`.
3. Seleccionar una operación binaria o fórmula.
4. Utilizar:

```text
(CPU + Memoria) / 2
```

5. Nombrar el nuevo campo:

```text
Promedio de recursos
```

### Resultado

| Servidor | CPU | Memoria | Promedio |
|---|---:|---:|---:|
| server-01 | 42 | 61 | 51.5 |
| server-02 | 78 | 74 | 76 |

### Actividades

1. Crea el campo calculado.
2. Ordena por promedio.
3. Explica las limitaciones de promediar CPU y memoria.
4. Propón un nombre alternativo que evite interpretarlo como una métrica oficial.

---

## Ejemplo de sesión 5: reducir una serie temporal

### Objetivo

Mostrar el último valor de la carga del sistema.

### Consulta

```promql
node_load1
```

### Pasos

1. Crear un panel.
2. Introducir la consulta.
3. Seleccionar `Stat`.
4. Añadir la transformación `Reduce`.
5. Seleccionar:

```text
Last not null
```

6. Configurar la unidad como `None`.
7. Guardar el panel.

### Actividades

1. Cambia la reducción a `Mean`.
2. Cambia la reducción a `Max`.
3. Compara los resultados.
4. Explica qué reducción sería más útil para:
   - Valor actual.
   - Pico de carga.
   - Valor medio.

---

## Ejemplo de sesión 6: filtrar valores elevados

### Objetivo

Mostrar únicamente los sistemas de ficheros con más del 80 % de uso.

### Consulta

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

### Pasos

1. Crear un panel Table.
2. Añadir la consulta.
3. Convertir etiquetas en campos.
4. Renombrar `Value` como `Uso`.
5. Añadir `Filter data by values`.
6. Configurar:

```text
Campo: Uso
Condición: mayor que
Valor: 80
```

7. Guardar el panel.

### Actividades

1. Cambia el filtro a `90`.
2. Comprueba qué sistemas desaparecen.
3. Compara este filtro con una consulta PromQL que utilice:

```promql
> 80
```

4. Explica cuál reduciría antes el volumen de datos.

---

## Ejemplo de sesión 7: convertir tipos de campo

### Objetivo

Corregir un campo numérico que se interpreta como texto.

### Datos iniciales

```text
"9"
"80"
"100"
"20"
```

Orden textual:

```text
100
20
80
9
```

Orden numérico:

```text
9
20
80
100
```

### Pasos

1. Crear o utilizar una tabla.
2. Identificar el campo interpretado como texto.
3. Añadir `Convert field type`.
4. Seleccionar tipo:

```text
Number
```

5. Añadir `Sort by`.
6. Ordenar de forma ascendente.
7. Comprobar el resultado.

### Actividades

1. Documenta el problema inicial.
2. Convierte el campo.
3. Ordena de nuevo.
4. Explica por qué cambió el resultado.

---

## Ejemplo de sesión 8: diagnosticar una transformación incorrecta

### Objetivo

Analizar un panel cuyo resultado no coincide con la consulta.

### Situación

La consulta devuelve:

```text
CPU por instancia
```

Pero el panel muestra una única fila.

### Procedimiento

1. Revisar la consulta.
2. Revisar los datos originales.
3. Revisar el orden de las transformaciones.
4. Comprobar si se ha aplicado `Reduce`.
5. Comprobar si se ha aplicado `Limit`.
6. Revisar si se han ocultado campos de identificación.
7. Eliminar temporalmente las transformaciones.
8. Añadirlas una por una.
9. Guardar el resultado correcto.

### Actividades

Documentar:

```text
Consulta:
Resultado esperado:
Resultado observado:
Transformación problemática:
Corrección:
Resultado final:
```

---

## Ejemplo de sesión 9: inspeccionar los datos intermedios

### Objetivo

Comprender el resultado después de cada transformación.

### Pasos

1. Crear un panel con una consulta sencilla.
2. Añadir una transformación.
3. Revisar la vista previa.
4. Añadir una segunda transformación.
5. Revisar de nuevo.
6. Repetir el proceso.
7. Anotar los cambios de campos y filas.

### Actividades

Crear la secuencia:

```text
Consulta up
   |
   v
Labels to fields
   |
   v
Organize fields
   |
   v
Sort by
   |
   v
Limit
```

Anotar:

- Campos iniciales.
- Campos después de convertir etiquetas.
- Campos ocultos.
- Orden aplicado.
- Número final de filas.

---

## Ejemplo de sesión 10: exportar un panel transformado

### Objetivo

Conservar un dashboard con transformaciones documentadas.

### Pasos

1. Crear una tabla de CPU y memoria.
2. Añadir las transformaciones.
3. Revisar el resultado.
4. Añadir una descripción al panel:

```text
Las etiquetas se convierten en campos, las consultas se unen
por instance y las filas se ordenan por CPU descendente.
```

5. Guardar el panel.
6. Exportar el dashboard.
7. Validar el JSON:

```bash
jq empty dashboard-transformaciones.json
```

8. Importar una copia.
9. Comprobar que las transformaciones se conservan.

### Actividades

1. Exporta el dashboard.
2. Importa una copia.
3. Compara las transformaciones.
4. Documenta cualquier diferencia.

---

## Orden recomendado de transformaciones

Una secuencia habitual para construir una tabla es:

```text
1. Ejecutar consultas.
2. Convertir etiquetas en campos.
3. Unir resultados.
4. Renombrar campos.
5. Crear cálculos.
6. Filtrar valores.
7. Ordenar filas.
8. Limitar resultados.
9. Ocultar campos.
10. Elegir la visualización.
```

### Ejemplo

```text
Consultas CPU y memoria
        |
        v
Labels to fields
        |
        v
Join by field: instance
        |
        v
Add field from calculation
        |
        v
Filter data by values
        |
        v
Sort by CPU
        |
        v
Limit 5
        |
        v
Organize fields
        |
        v
Table
```

El orden puede variar según el resultado deseado.

---

## Transformaciones y rendimiento

Las transformaciones se ejecutan en Grafana después de obtener los datos.

Esto tiene varias consecuencias:

- Prometheus puede enviar más datos de los necesarios.
- Grafana puede consumir más memoria.
- El navegador puede procesar más filas.
- El panel puede tardar más en cargar.
- Una transformación compleja puede dificultar el diagnóstico.

### Mejorar el rendimiento

Preferir PromQL para:

```text
Filtros
Agregaciones
topk()
rate()
sum()
avg()
max()
```

Ejemplo:

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

Es preferible a descargar cientos de series y aplicar:

```text
Sort by
Limit
```

en el navegador.

### Recomendación

Reducir los datos en la fuente y utilizar transformaciones para la presentación final.

---

## Buenas prácticas

### Mantener pocas transformaciones

Un panel con muchas transformaciones puede ser difícil de mantener.

### Nombrar claramente los campos

Utilizar:

```text
CPU
Memoria
Almacenamiento
Servidor
Estado
```

Evitar:

```text
Value
Value #A
Field 3
Columna nueva
```

### Documentar el orden

Indicar por qué se utiliza cada transformación.

### Revisar los datos originales

Antes de modificar el resultado, comprobar qué devuelve la consulta.

### Probar una transformación cada vez

Esto facilita localizar errores.

### Utilizar PromQL cuando sea más eficiente

Especialmente para:

- Agregaciones.
- Filtros grandes.
- `topk()`.
- Cálculos sobre contadores.
- Restricciones por etiquetas.

### No ocultar campos necesarios

Conservar siempre una identificación clara del recurso.

### Comprobar unidades

Una transformación puede producir un campo nuevo sin unidad evidente.

### Revisar valores nulos

Los valores nulos pueden afectar:

- Ordenación.
- Cálculos.
- Reducciones.
- Uniones.
- Filtros.

### Guardar después de probar

No guardar configuraciones experimentales sin comprobar el resultado.

---

## Problemas habituales

### La transformación no cambia el resultado

Comprobar:

- Que se aplica al frame correcto.
- Que el campo seleccionado existe.
- Que la consulta devuelve datos.
- Que la transformación es compatible con el tipo de datos.
- Que no existe otra transformación posterior que deshaga el resultado.

### La unión no combina los resultados

Comprobar:

- Que ambas consultas tienen el campo de unión.
- Que el nombre coincide.
- Que los valores coinciden.
- Que no existen diferencias de formato.
- Que una consulta no devuelve `server-01` y otra `server-01:9100`.
- Que el tipo del campo es el mismo.

### Se pierden filas después de un Join

Posibles causas:

- Se utiliza una unión interna.
- Faltan valores en una consulta.
- La clave no coincide.
- Existen duplicados.
- Se ha aplicado un filtro anterior.

### El orden numérico es incorrecto

Posibles causas:

- El campo es texto.
- El número contiene unidades.
- El separador decimal no se interpreta correctamente.
- El campo tiene valores nulos.

Solución:

```text
Convert field type → Number
```

### El panel muestra demasiadas filas

Aplicar:

- Filtros en PromQL.
- Agregaciones.
- `topk()`.
- `Limit`.
- Rangos temporales más cortos.
- Exclusión de etiquetas.

### La transformación Reduce muestra un valor inesperado

Comprobar:

- Método de reducción.
- Rango temporal.
- Valores nulos.
- Series seleccionadas.
- Aplicación a todos los frames.
- Diferencia entre `Last`, `Mean`, `Max` y `Sum`.

### El cálculo devuelve valores incorrectos

Comprobar:

- Unidades.
- Campos seleccionados.
- División entre cero.
- Valores nulos.
- Orden de las operaciones.
- Escala del resultado.

### La tabla pierde la identificación del servidor

Se ha ocultado o eliminado el campo `instance`.

Restaurar:

```text
instance
```

o crear un campo equivalente antes de ocultar columnas.

### La transformación funciona en una versión, pero no en otra

Las transformaciones disponibles y su configuración pueden variar.

Comprobar:

- Versión de Grafana.
- Nombre de la transformación.
- Compatibilidad del panel.
- Documentación de la versión instalada.
- Exportación JSON.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/transformaciones
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/transformaciones/consultas-promql.txt <<'EOF'
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

Disponibilidad:
up

Uso de almacenamiento:
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
EOF
```

Guardar el orden de transformaciones:

```bash
cat > ~/laboratorio-grafana/evidencias/transformaciones/orden.txt <<'EOF'
Panel: CPU y memoria por instancia

1. Labels to fields
2. Join by field: instance
3. Organize fields by name
4. Rename fields
5. Sort by CPU descendente
6. Limit: 5
EOF
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/transformaciones/informe.txt <<'EOF'
Práctica: Transformaciones

Dashboard utilizado:

Paneles transformados:

Consultas utilizadas:

Transformaciones utilizadas:

Orden de las transformaciones:

Campos renombrados:

Campos ocultos:

Filtros utilizados:

Cálculos realizados:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-resultado-sin-transformar.png
02-labels-to-fields.png
03-organize-fields.png
04-join-cpu-memoria.png
05-sort-limit.png
06-campo-calculado.png
07-filtro-valores.png
08-panel-final.png
```

---

## Práctica integradora

### Objetivo

Crear una tabla operativa con CPU, memoria y almacenamiento por instancia.

### Consulta A: CPU

```promql
100 - (
  avg by (instance) (
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

### Consulta C: almacenamiento

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

### Transformaciones

Aplicar una secuencia equivalente a:

```text
1. Labels to fields.
2. Join by field.
3. Organize fields by name.
4. Rename fields.
5. Sort by CPU descendente.
6. Filter data by values si procede.
7. Limit a 5.
```

### Resultado esperado

| Servidor | CPU | Memoria | Almacenamiento |
|---|---:|---:|---:|
| server-02:9100 | 82.1 | 74.5 | 88.2 |
| server-01:9100 | 42.3 | 61.2 | 73.4 |

### Tareas

1. Crear un panel Table.
2. Añadir las tres consultas.
3. Convertir etiquetas en campos.
4. Unir los resultados por instancia.
5. Renombrar los campos.
6. Ocultar campos innecesarios.
7. Ordenar por CPU.
8. Filtrar servidores con almacenamiento superior al 80 %.
9. Limitar el resultado a cinco filas.
10. Añadir una descripción del panel.
11. Comprobar los datos originales.
12. Exportar el dashboard.
13. Importar una copia.
14. Verificar que las transformaciones se conservan.
15. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Consulta de CPU creada | | |
| Consulta de memoria creada | | |
| Consulta de almacenamiento creada | | |
| Etiquetas convertidas en campos | | |
| Resultados unidos | | |
| Campos renombrados | | |
| Campos ocultos | | |
| Filas ordenadas | | |
| Valores filtrados | | |
| Resultado limitado | | |
| Campo calculado creado | | |
| Panel guardado | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Transformaciones comprobadas | | |
| Evidencias guardadas | | |

---

## Puntos clave

- Las transformaciones modifican los resultados antes de visualizarlos.
- No cambian los datos originales de Prometheus.
- Las consultas obtienen datos y las transformaciones preparan su presentación.
- El orden de las transformaciones es importante.
- `Labels to fields` convierte etiquetas en columnas.
- `Organize fields by name` permite renombrar, ocultar y ordenar campos.
- `Sort by` ordena filas.
- `Limit` limita el número de resultados.
- `Filter data by values` filtra filas según sus valores.
- `Reduce` convierte una serie en un valor reducido.
- `Join by field` combina resultados mediante una clave común.
- `Add field from calculation` crea campos calculados.
- `Convert field type` corrige campos numéricos interpretados como texto.
- Las transformaciones pueden utilizarse con tablas, Stats, Gauges y otros paneles.
- Para grandes volúmenes, suele ser más eficiente filtrar y agregar en PromQL.
- Se debe conservar una identificación clara del recurso.
- Los cálculos deben documentar sus unidades y fórmulas.
- Los valores nulos pueden afectar a filtros, ordenaciones y cálculos.
- Un panel con demasiadas transformaciones puede ser difícil de mantener.
- La vista previa debe revisarse después de cada transformación.
- Las transformaciones forman parte de la configuración exportada del dashboard.

---

## Preguntas de comprobación

1. ¿Qué es una transformación en Grafana?
2. ¿Qué diferencia existe entre una consulta y una transformación?
3. ¿Qué diferencia existe entre una transformación y una visualización?
4. ¿Qué utilidad tiene `Labels to fields`?
5. ¿Qué operaciones permite realizar `Organize fields by name`?
6. ¿Para qué sirve `Sort by`?
7. ¿Para qué sirve `Limit`?
8. ¿Qué diferencia existe entre filtrar en PromQL y filtrar con una transformación?
9. ¿Qué función cumple `Reduce`?
10. ¿Qué diferencia existe entre `Last`, `Mean` y `Max`?
11. ¿Qué función cumple `Join by field`?
12. ¿Qué condiciones deben cumplirse para unir dos consultas?
13. ¿Qué función cumple `Add field from calculation`?
14. ¿Por qué puede ser necesario convertir un campo de texto a número?
15. ¿Qué problemas puede producir ocultar el campo `instance`?
16. ¿Por qué es importante el orden de las transformaciones?
17. ¿Cómo mostrarías los cinco servidores con mayor CPU?
18. ¿Cuándo sería preferible utilizar `topk()` en PromQL?
19. ¿Qué revisarías si un Join pierde filas?
20. ¿Qué revisarías si una ordenación numérica es incorrecta?
21. ¿Qué revisarías si una transformación no cambia el resultado?
22. ¿Qué problemas pueden producir los valores nulos?
23. ¿Cómo documentarías una transformación compleja?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener un panel con transformaciones bien diseñado?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de adaptar los resultados de las consultas a las necesidades de cada visualización.

El proceso completo será:

```text
Crear la consulta
        |
        v
Revisar el resultado original
        |
        v
Convertir etiquetas en campos si es necesario
        |
        v
Unir resultados relacionados
        |
        v
Crear cálculos adicionales
        |
        v
Filtrar resultados
        |
        v
Ordenar filas
        |
        v
Limitar el número de registros
        |
        v
Renombrar y ocultar campos
        |
        v
Seleccionar la visualización
        |
        v
Guardar y documentar
```

El resultado final debe ser un panel claro, eficiente y mantenible, en el que las transformaciones estén justificadas y permitan convertir resultados técnicos en información útil para la operación y el aprendizaje.