# Condiciones y expresiones

Las **condiciones y expresiones** permiten transformar los datos obtenidos de una consulta en una decisión evaluable por Grafana.

Una consulta puede devolver una serie temporal, varias series o una tabla de valores. Para utilizar esos datos en una regla de alerta, normalmente es necesario:

1. Ejecutar una consulta.
2. Reducir los resultados a un valor evaluable.
3. Aplicar una condición.
4. Comparar el resultado con un umbral.
5. Determinar el estado de la alerta.

El flujo habitual es:

```text
Consulta A
   |
   v
Datos temporales
   |
   v
Expresión de reducción
   |
   v
Valor único
   |
   v
Condición o umbral
   |
   v
Estado de alerta
```

Ejemplo:

```text
Consulta A:
Uso de CPU

Reducción:
Último valor

Condición:
Mayor que 90

Duración:
5 minutos

Resultado:
Alerta de CPU elevada
```

Las opciones exactas pueden cambiar según la versión de Grafana y el tipo de regla utilizado. Sin embargo, los conceptos de consulta, reducción, expresión, condición y umbral son aplicables de forma general.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la diferencia entre una consulta, una expresión y una condición.
- Comprender por qué una serie temporal debe reducirse antes de evaluarse.
- Utilizar expresiones matemáticas en reglas de alerta.
- Utilizar expresiones de reducción como `Last`, `Mean`, `Min`, `Max` y `Sum`.
- Configurar condiciones basadas en umbrales.
- Comparar valores con operadores como `>`, `<`, `>=`, `<=` e `=`.
- Crear alertas a partir de una sola consulta.
- Crear alertas que utilicen varias consultas.
- Combinar consultas mediante expresiones matemáticas.
- Calcular porcentajes con expresiones.
- Utilizar expresiones para comparar dos métricas.
- Comprender la diferencia entre valor actual, promedio, mínimo y máximo.
- Detectar ausencia de datos mediante expresiones.
- Identificar errores frecuentes de unidades.
- Probar condiciones en Grafana Explore.
- Diagnosticar una regla que no se activa debido a una expresión incorrecta.
- Documentar consultas, expresiones, umbrales y resultados.

---

# Introducción

Una consulta PromQL suele devolver datos a lo largo del tiempo.

Por ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

El resultado puede contener muchos valores:

```text
10:00 → 45 %
10:01 → 48 %
10:02 → 52 %
10:03 → 91 %
10:04 → 93 %
```

Una regla de alerta necesita saber cómo interpretar esos datos.

Puede utilizar:

- El último valor.
- El promedio.
- El valor máximo.
- El valor mínimo.
- La suma.
- Una expresión matemática.
- Una comparación con otra consulta.

Por ejemplo:

```text
Último valor > 90
```

o:

```text
Promedio de los últimos 5 minutos > 90
```

o:

```text
Máximo de los últimos 5 minutos > 95
```

Cada opción responde a una pregunta diferente.

---

# Diferencia entre consulta, expresión y condición

## Consulta

Obtiene datos desde una fuente como Prometheus.

Ejemplo:

```promql
up{job="node_exporter"}
```

## Expresión

Transforma uno o varios resultados.

Ejemplo conceptual:

```text
Promedio de la consulta A
```

Otro ejemplo:

```text
Consulta A / Consulta B * 100
```

## Condición

Determina si el resultado debe considerarse problemático.

Ejemplo:

```text
El resultado es mayor que 90
```

## Regla completa

```text
Consulta:
Uso de CPU

Expresión:
Obtener el último valor

Condición:
Mayor que 90

Duración:
Durante 5 minutos
```

La consulta proporciona los datos.

La expresión prepara o transforma los datos.

La condición decide si se activa la alerta.

---

# Componentes de una evaluación

Una regla puede representarse así:

```text
Consulta A
    |
    v
Expresión B: reducción
    |
    v
Expresión C: comparación
    |
    v
Resultado verdadero o falso
    |
    v
Estado de la alerta
```

En algunas versiones de Grafana, las consultas y expresiones aparecen identificadas con letras:

```text
A: consulta principal
B: reducción de A
C: condición sobre B
```

Ejemplo:

```text
A = consulta de CPU
B = último valor de A
C = B > 90
```

Cuando existen varias consultas:

```text
A = errores
B = peticiones totales
C = A / B * 100
D = C > 5
```

La nomenclatura exacta puede variar, pero la lógica es la misma.

---

# Series temporales y valores únicos

## Serie temporal

Una serie temporal contiene valores asociados a instantes.

```text
10:00 → 40
10:01 → 43
10:02 → 45
10:03 → 92
10:04 → 94
```

## Valor único

Una condición suele necesitar un valor representativo.

Ejemplos:

```text
Último valor = 94
Promedio = 62,8
Máximo = 94
Mínimo = 40
```

La expresión de reducción transforma la serie temporal en un resultado evaluable.

## Ejemplo

```text
Serie temporal:
40, 43, 45, 92, 94

Last:
94

Mean:
62,8

Max:
94

Min:
40
```

La elección de la reducción cambia el comportamiento de la alerta.

---

# Expresiones de reducción

Una reducción resume varios valores en uno solo.

## `Last`

Utiliza el último valor disponible.

```text
40, 43, 45, 92, 94 → 94
```

Es útil cuando interesa conocer el estado actual.

Ejemplos:

- Disponibilidad actual.
- Uso actual de memoria.
- Estado actual de un servicio.
- Temperatura actual.

## `Mean`

Calcula el promedio.

```text
40, 43, 45, 92, 94 → 62,8
```

Es útil cuando interesa conocer el comportamiento medio.

Ejemplos:

- Uso medio de CPU.
- Latencia media.
- Carga media.
- Tasa media de errores.

## `Max`

Selecciona el valor máximo.

```text
40, 43, 45, 92, 94 → 94
```

Es útil para detectar picos.

Ejemplos:

- Pico de latencia.
- Pico de consumo.
- Máximo número de errores.
- Máxima utilización de una capacidad.

## `Min`

Selecciona el valor mínimo.

```text
40, 43, 45, 92, 94 → 40
```

Es útil para detectar valores demasiado bajos.

Ejemplos:

- Memoria disponible.
- Espacio libre.
- Tasa de peticiones.
- Nivel de batería.

## `Sum`

Suma los valores.

```text
40 + 43 + 45 + 92 + 94 = 314
```

Debe utilizarse con cuidado. La suma de valores temporales puede no tener un significado operativo.

Es más útil cuando los valores representan cantidades acumulables o series separadas.

---

# Elegir la reducción adecuada

La pregunta operativa determina la reducción.

| Pregunta | Reducción habitual |
|---|---|
| ¿Cuál es el valor actual? | `Last` |
| ¿Cuál ha sido el promedio? | `Mean` |
| ¿Se produjo algún pico? | `Max` |
| ¿Cuál fue el valor mínimo? | `Min` |
| ¿Cuál es el total acumulado? | `Sum` |

## Ejemplo: CPU

```text
Último valor > 90 %
```

Detecta el estado actual.

```text
Promedio > 90 %
```

Detecta un uso elevado sostenido en el rango evaluado.

```text
Máximo > 95 %
```

Detecta incluso un pico breve.

No existe una reducción universalmente correcta. Debe elegirse según el problema que se pretende detectar.

---

# Condiciones y operadores

Una condición compara un valor con otro.

## Mayor que

```text
Valor > 90
```

Se activa cuando el valor es superior a 90.

## Mayor o igual que

```text
Valor >= 90
```

Se activa cuando el valor es 90 o superior.

## Menor que

```text
Valor < 10
```

Se activa cuando el valor es inferior a 10.

## Menor o igual que

```text
Valor <= 10
```

Se activa cuando el valor es 10 o inferior.

## Igual a

```text
Valor = 0
```

Se activa cuando el valor es exactamente cero.

## Diferente de

```text
Valor != 1
```

Puede utilizarse para detectar cualquier estado distinto del esperado.

La disponibilidad exacta de algunos operadores depende de la interfaz y del tipo de expresión.

---

# Umbrales y unidades

Uno de los errores más frecuentes consiste en utilizar un umbral con una unidad incorrecta.

## Ejemplo de porcentaje

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Resultado:

```text
0 a 100
```

Umbral correcto:

```text
Mayor que 90
```

## Ejemplo de proporción

Consulta:

```promql
1 - (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Resultado:

```text
0 a 1
```

Umbral equivalente:

```text
Mayor que 0.90
```

Estas dos consultas pueden representar lo mismo, pero utilizan escalas diferentes.

## Ejemplo de segundos

Consulta:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket[5m])
  )
)
```

Resultado:

```text
Segundos
```

Umbral:

```text
Mayor que 1
```

No debe configurarse como `1000` salvo que la consulta se convierta explícitamente a milisegundos.

---

# Consulta A y reducción B

Una configuración frecuente puede expresarse así:

```text
A: consulta PromQL
B: reducción de A
C: condición sobre B
```

## Ejemplo

### Consulta A

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Expresión B

```text
Reduce A utilizando Last
```

### Condición C

```text
B > 90
```

### Resultado

```text
Si el último valor de CPU es superior a 90,
la condición es verdadera.
```

---

# Ejemplo con `Mean`

## Consulta A

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Expresión B

```text
Reduce A utilizando Mean
```

## Condición C

```text
B > 80
```

## Interpretación

La alerta se activa cuando el promedio de la CPU evaluada supera el 80 %.

Esta configuración es menos sensible a un único pico, pero puede ocultar picos importantes.

---

# Ejemplo con `Max`

## Consulta A

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Expresión B

```text
Reduce A utilizando Max
```

## Condición C

```text
B > 95
```

## Interpretación

La alerta se activa si en el rango evaluado se alcanza un pico superior al 95 %.

Esta configuración puede generar más alertas si la métrica presenta picos breves.

---

# Expresiones matemáticas

Las expresiones matemáticas permiten combinar consultas.

## Estructura general

```text
Consulta A
Consulta B
Expresión C = A / B
Condición D = C > umbral
```

## Ejemplo: porcentaje de errores

Consulta A: errores HTTP 5xx.

```promql
sum(
  rate(http_requests_total{status=~"5.."}[5m])
)
```

Consulta B: peticiones totales.

```promql
sum(
  rate(http_requests_total[5m])
)
```

Expresión matemática:

```text
A / B * 100
```

Condición:

```text
Resultado > 5
```

Interpretación:

```text
Activar si el porcentaje de errores supera el 5 %.
```

La consulta debe protegerse contra divisiones por cero cuando sea necesario.

---

# Ejemplo: porcentaje de errores directamente en PromQL

El cálculo también puede realizarse en una única consulta:

```promql
100 *
sum(
  rate(http_requests_total{status=~"5.."}[5m])
)
/
sum(
  rate(http_requests_total[5m])
)
```

La alternativa de separar las consultas puede resultar más clara cuando:

- Se desea visualizar cada componente.
- Se reutilizan las consultas.
- Se necesita depurar el cálculo.
- Se quiere explicar el proceso durante una clase.

La alternativa de una sola consulta puede ser más compacta.

---

# Comparar dos métricas

Las expresiones permiten comparar dos valores.

## Ejemplo: memoria disponible

Consulta A:

```promql
node_memory_MemAvailable_bytes
```

Consulta B:

```promql
node_memory_MemTotal_bytes
```

Expresión:

```text
A / B * 100
```

Condición:

```text
Resultado < 10
```

Interpretación:

```text
Activar si la memoria disponible es inferior al 10 %.
```

## Ejemplo: espacio libre

Consulta A:

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

Consulta B:

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

Expresión:

```text
A / B * 100
```

Condición:

```text
Resultado < 20
```

Interpretación:

```text
Activar si queda menos del 20 % de espacio libre.
```

---

# Correspondencia entre series

Cuando se combinan consultas, las series deben poder relacionarse.

Por ejemplo:

```text
Consulta A:
instance=server-01

Consulta B:
instance=server-01
```

Grafana y Prometheus deben poder identificar que ambas series pertenecen a la misma instancia.

## Problema frecuente

```text
Consulta A:
instance=server-01, device=sda

Consulta B:
instance=server-01
```

Las etiquetas no coinciden completamente. La operación puede producir resultados inesperados o no devolver datos.

## Recomendación

Antes de combinar consultas:

1. Revisar las etiquetas.
2. Utilizar agregaciones coherentes.
3. Mantener la misma dimensión.
4. Comprobar el resultado en Explore.
5. Evitar combinar series incompatibles.

---

# Agregaciones y etiquetas

Las agregaciones modifican las etiquetas de las series.

## Ejemplo

```promql
sum by (instance) (
  rate(http_requests_total[5m])
)
```

Conserva:

```text
instance
```

## Otra agregación

```promql
sum (
  rate(http_requests_total[5m])
)
```

Elimina las dimensiones y produce un valor global.

## Consecuencia

Si la alerta necesita identificar el servicio o la instancia, no se deben eliminar esas etiquetas sin necesidad.

## Ejemplo recomendado

```promql
sum by (instance, service) (
  rate(http_requests_total[5m])
)
```

Resultado:

```text
instance=server-01, service=api
```

Esto permite mostrar mensajes como:

```text
La API de server-01 presenta un problema.
```

---

# Expresiones lógicas

Las condiciones pueden combinar varios criterios.

Ejemplos conceptuales:

```text
CPU > 90 Y memoria > 90
```

```text
Disponibilidad = 0 O tasa de errores > 5
```

```text
Latencia > 1 segundo Y peticiones por segundo > 10
```

El soporte exacto de operadores lógicos depende de la versión, la fuente de datos y el editor utilizado.

Cuando la lógica es compleja, puede ser más sencillo expresar la condición directamente en PromQL.

## Ejemplo conceptual en PromQL

```promql
(
  cpu_usage > 90
)
and
(
  memory_usage > 90
)
```

La sintaxis y la correspondencia entre series deben validarse en Prometheus antes de utilizarla en una regla.

---

# Expresiones de ausencia

A veces no se desea evaluar el valor de una métrica, sino comprobar si existe.

## Ejemplo conceptual con `absent`

```promql
absent(up{job="node_exporter"})
```

Interpretación aproximada:

```text
Si no existe ninguna serie coincidente,
la consulta devuelve un resultado.
```

También puede utilizarse una regla basada en:

```promql
up{job="node_exporter"} == 0
```

La elección depende de si se desea detectar:

- Un objetivo conocido que devuelve `0`.
- La ausencia completa de una serie.
- La pérdida de la fuente de datos.
- Una consulta que no devuelve resultados.

Es importante distinguir entre:

```text
Objetivo disponible: up = 1
Objetivo no disponible: up = 0
No existe la serie: ausencia de datos
```

---

# Expresiones de tiempo

Las consultas pueden incluir rangos temporales.

Ejemplo:

```promql
rate(node_cpu_seconds_total[5m])
```

El rango `[5m]` indica la ventana utilizada para calcular la tasa.

Esto no es necesariamente lo mismo que la duración de la alerta.

## Diferencia

```text
[5m] en PromQL:
Ventana de datos utilizada por la función.

Duración de la alerta:
Tiempo durante el cual la condición debe mantenerse.
```

Ejemplo:

```text
rate(...[5m])
Duración: 5 minutos
```

La consulta utiliza cinco minutos de datos y la regla exige que el resultado supere el umbral durante cinco minutos.

Son dos configuraciones diferentes.

---

# Condiciones instantáneas y sostenidas

## Condición instantánea

Se evalúa el valor actual.

```text
Last > 90
```

Puede activarse rápidamente ante un pico.

## Condición media

Se evalúa el promedio.

```text
Mean > 90
```

Es más estable, pero puede ocultar valores extremos.

## Condición sostenida

Se utiliza una condición instantánea junto con una duración:

```text
Last > 90 durante 5 minutos
```

Suele ser una alternativa equilibrada para muchos recursos.

---

# Ejemplo completo: alerta de CPU con reducción

## Objetivo

Activar una alerta si la CPU supera el 90 % durante cinco minutos.

## Consulta A

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Expresión B

```text
Reducir A utilizando Last
```

## Condición C

```text
B > 90
```

## Configuración temporal

```text
Intervalo de evaluación: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = cpu
environment = laboratory
```

## Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.
```

## Interpretación

```text
A obtiene la serie de CPU.
B selecciona el último valor.
C comprueba si B es superior a 90.
La duración evita alertar por un pico aislado.
```

---

# Ejemplo completo: porcentaje de errores

## Objetivo

Activar una alerta si el porcentaje de respuestas HTTP 5xx supera el 5 %.

## Consulta A: errores

```promql
sum by (service) (
  rate(http_requests_total{status=~"5.."}[5m])
)
```

## Consulta B: total de peticiones

```promql
sum by (service) (
  rate(http_requests_total[5m])
)
```

## Expresión C

```text
100 * A / B
```

## Condición D

```text
D > 5
```

## Configuración temporal

```text
Intervalo de evaluación: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = critical
team = application
resource = error-rate
```

## Anotaciones

```text
summary = Tasa de errores elevada en {{ $labels.service }}

description = El servicio {{ $labels.service }}
supera el 5 % de respuestas HTTP 5xx.
```

## Precaución

Si `B` es cero, la división puede producir un resultado no válido. Debe comprobarse el comportamiento de la consulta y de la fuente de datos.

---

# Ejemplo completo: memoria disponible

## Objetivo

Activar una alerta si queda menos del 10 % de memoria disponible.

## Consulta A

```promql
node_memory_MemAvailable_bytes
```

## Consulta B

```promql
node_memory_MemTotal_bytes
```

## Expresión C

```text
100 * A / B
```

## Condición D

```text
D < 10
```

## Configuración

```text
Intervalo de evaluación: 1 minuto
Duración: 5 minutos
```

## Interpretación

```text
A = memoria disponible
B = memoria total
C = porcentaje disponible
D = condición de memoria insuficiente
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
```

---

# Ejemplo completo: almacenamiento libre

## Objetivo

Activar una alerta si queda menos del 20 % de espacio libre.

## Consulta A

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

## Consulta B

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

## Expresión C

```text
100 * A / B
```

## Condición D

```text
D < 20
```

## Anotaciones

```text
summary = Poco espacio libre en {{ $labels.instance }}

description = El punto de montaje {{ $labels.mountpoint }}
tiene menos del 20 % de espacio disponible.
```

La misma situación también puede expresarse como porcentaje utilizado:

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

En ese caso, la condición equivalente sería:

```text
Mayor que 80
```

---

# Ejemplo de sesión 1: comparar reducciones

## Objetivo

Observar cómo cambia una alerta según la reducción seleccionada.

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Configuraciones

Crear tres reglas de laboratorio o tres expresiones de prueba:

```text
Configuración A:
Reducción = Last
Umbral = 90

Configuración B:
Reducción = Mean
Umbral = 80

Configuración C:
Reducción = Max
Umbral = 95
```

## Pasos

1. Ejecutar la consulta en Explore.
2. Revisar la serie temporal.
3. Identificar los valores máximo, mínimo y medio.
4. Crear la expresión con `Last`.
5. Crear la expresión con `Mean`.
6. Crear la expresión con `Max`.
7. Generar una carga controlada.
8. Observar las diferencias.
9. Registrar qué regla se activa primero.
10. Explicar el motivo.

## Registro

```text
Valor máximo observado:

Valor mínimo observado:

Valor medio observado:

Último valor observado:

Regla que se activó primero:

Regla que no se activó:

Explicación:
```

---

# Ejemplo de sesión 2: calcular un porcentaje con dos consultas

## Objetivo

Crear una condición basada en la relación entre errores y peticiones totales.

## Consulta A

```promql
sum by (service) (
  rate(http_requests_total{status=~"5.."}[5m])
)
```

## Consulta B

```promql
sum by (service) (
  rate(http_requests_total[5m])
)
```

## Expresión C

```text
100 * A / B
```

## Condición

```text
C > 5
```

## Pasos

1. Validar la consulta de errores.
2. Validar la consulta total.
3. Comprobar que ambas conservan la etiqueta `service`.
4. Crear la expresión matemática.
5. Revisar la unidad resultante.
6. Configurar el umbral.
7. Añadir una duración de cinco minutos.
8. Crear la regla.
9. Probar con tráfico de laboratorio.
10. Revisar el resultado.

## Preguntas de análisis

```text
¿Qué valor devuelve A?

¿Qué valor devuelve B?

¿Qué unidad tiene C?

¿Qué ocurre si B es cero?

¿Qué etiquetas se conservan?

¿La condición representa un porcentaje o una proporción?
```

---

# Ejemplo de sesión 3: investigar un error de unidad

## Objetivo

Diagnosticar una alerta que se activa con demasiada frecuencia.

## Situación

```text
La alerta de memoria se activa aunque la memoria utilizada
parece estar alrededor del 70 %.
```

## Consulta utilizada

```promql
1 - (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Umbral configurado

```text
Mayor que 70
```

## Problema

La consulta devuelve una proporción entre `0` y `1`, pero el umbral se ha configurado como si el resultado fuese un porcentaje entre `0` y `100`.

## Correcciones posibles

### Opción A: cambiar la consulta

```promql
100 * (
  1 - (
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
)
```

Mantener:

```text
Umbral = 70
```

### Opción B: cambiar el umbral

Mantener la consulta original y utilizar:

```text
Umbral = 0.70
```

## Actividades

1. Ejecutar la consulta.
2. Observar su rango de valores.
3. Identificar la unidad.
4. Corregir la consulta o el umbral.
5. Comprobar que la alerta se comporta correctamente.
6. Documentar la solución aplicada.

---

# Ejemplo de sesión 4: comparar `Last`, `Mean` y `Max`

## Objetivo

Comprender qué pregunta responde cada reducción.

## Datos de ejemplo

```text
Valores:
40, 42, 44, 95, 45
```

## Resultados

```text
Last = 45
Mean = 53,2
Max = 95
Min = 40
```

## Actividades

1. Calcular manualmente cada reducción.
2. Configurar una condición `> 90`.
3. Determinar qué reducción activa la alerta.
4. Explicar por qué.
5. Relacionar cada reducción con un caso operativo.

## Resultado esperado

```text
Last:
No activa, porque el último valor es 45.

Mean:
No activa, porque el promedio es 53,2.

Max:
Activa, porque el máximo es 95.
```

## Debate técnico

```text
¿Es correcto alertar por un único pico?

¿Debería utilizarse una duración?

¿Es mejor `Max` o `Last` para este caso?

¿Qué tipo de servicio justificaría cada opción?
```

---

# Ejemplo de sesión 5: detectar ausencia de datos

## Objetivo

Diferenciar un valor cero de la ausencia de una serie.

## Consulta

```promql
up{job="node_exporter"}
```

## Casos

```text
Caso A:
up = 1

Caso B:
up = 0

Caso C:
No existe ninguna serie
```

## Actividades

1. Ejecutar la consulta con el objetivo funcionando.
2. Detener Node Exporter.
3. Observar si aparece `up = 0`.
4. Eliminar o modificar temporalmente la coincidencia de la consulta.
5. Observar el comportamiento cuando no existen series.
6. Comparar:
   - Valor normal.
   - Valor cero.
   - Ausencia de datos.
7. Documentar qué política corresponde a cada caso.

## Registro

```text
Estado del servicio:

Resultado de la consulta:

Estado de Grafana:

Interpretación:

Acción recomendada:
```

---

# Ejemplo de sesión 6: combinar series por instancia

## Objetivo

Comprobar que dos consultas pueden combinarse correctamente.

## Consulta A

```promql
node_memory_MemAvailable_bytes
```

## Consulta B

```promql
node_memory_MemTotal_bytes
```

## Expresión C

```text
100 * A / B
```

## Pasos

1. Ejecutar A.
2. Revisar sus etiquetas.
3. Ejecutar B.
4. Revisar sus etiquetas.
5. Confirmar que ambas contienen `instance`.
6. Crear la expresión.
7. Comprobar el porcentaje por instancia.
8. Añadir la condición `< 10`.
9. Verificar que la alerta identifica la instancia correcta.

## Error inducido

Modificar una de las consultas para agregar por una etiqueta diferente:

```promql
sum(node_memory_MemAvailable_bytes) by (job)
```

Observar qué ocurre al combinarla con una consulta agrupada por `instance`.

## Conclusión

Las consultas que se combinan deben tener una estructura compatible y conservar dimensiones comunes.

---

# Ejemplo de sesión 7: crear una expresión de carga relativa

## Objetivo

Comparar la carga del sistema con el número de CPUs.

## Consulta A

```promql
node_load1
```

## Consulta B

```promql
count by (instance) (
  node_cpu_seconds_total{mode="idle"}
)
```

## Expresión C

```text
A / B
```

## Condición

```text
C > 1
```

## Interpretación

La carga de un minuto supera aproximadamente la capacidad equivalente a una CPU por unidad disponible.

La consulta puede necesitar ajustes según las etiquetas del entorno.

## Actividades

1. Ejecutar A.
2. Ejecutar B.
3. Comprobar las etiquetas.
4. Crear la expresión.
5. Revisar la unidad.
6. Generar carga controlada.
7. Observar el valor normalizado.
8. Documentar las limitaciones de la métrica.

---

# Ejemplo de sesión 8: combinar una condición con una duración

## Objetivo

Diferenciar la expresión que evalúa el valor de la duración de la regla.

## Configuración

```text
Consulta:
Uso de CPU

Reducción:
Last

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos
```

## Secuencia

```text
10:00 → 92 % → Pending
10:01 → 93 % → Pending
10:02 → 91 % → Pending
10:03 → 89 % → Normal
```

## Actividades

1. Crear la regla.
2. Generar un pico breve.
3. Comprobar que no llega a `Alerting`.
4. Mantener el valor elevado.
5. Comprobar la activación.
6. Explicar por qué la expresión y la duración son mecanismos diferentes.

---

# Ejemplo de sesión 9: diagnosticar una expresión incorrecta

## Objetivo

Corregir una expresión que produce un resultado inesperado.

## Situación

Se desea calcular el porcentaje de errores:

```text
Errores / Peticiones totales * 100
```

## Expresión incorrecta

```text
A / B
```

## Problema

El resultado es una proporción entre `0` y `1`, pero el umbral está configurado como:

```text
Mayor que 5
```

## Correcciones posibles

### Opción A

```text
100 * A / B
```

Umbral:

```text
Mayor que 5
```

### Opción B

```text
A / B
```

Umbral:

```text
Mayor que 0.05
```

## Actividades

1. Ejecutar ambas expresiones.
2. Comparar los valores.
3. Identificar las unidades.
4. Elegir una representación.
5. Documentar la decisión.

---

# Evaluación ante valores nulos o ausentes

Una expresión puede encontrarse con:

- Series vacías.
- Valores nulos.
- Cero como divisor.
- Etiquetas incompatibles.
- Series con distinta frecuencia.
- Datos retrasados.
- Valores no numéricos.

## Recomendaciones

- Validar cada consulta por separado.
- Comprobar el resultado de cada expresión.
- Evitar divisiones por cero.
- Utilizar filtros adecuados.
- Revisar las etiquetas.
- Probar periodos con y sin datos.
- Documentar el comportamiento esperado.

## Ejemplo de riesgo

```text
A = 0
B = 0
C = A / B
```

El resultado puede ser indefinido o no evaluable.

La expresión debe diseñarse teniendo en cuenta este escenario.

---

# Condiciones con varias series

Una consulta puede devolver una serie por:

- Instancia.
- Servicio.
- Método.
- Código de respuesta.
- Punto de montaje.
- Región.
- Entorno.

## Ejemplo

```promql
sum by (instance, service) (
  rate(http_requests_total[5m])
)
```

Resultado:

```text
server-01, api → 120 req/s
server-01, frontend → 80 req/s
server-02, api → 95 req/s
```

Una expresión debe conservar la dimensión necesaria para identificar el resultado.

## Preguntas

```text
¿La alerta debe generarse por instancia?

¿Debe generarse por servicio?

¿Debe existir una alerta global?

¿Se deben agrupar las series?

¿Qué etiquetas aparecerán en la notificación?
```

---

# Alerta global frente a alerta por instancia

## Alerta global

```promql
sum(
  rate(http_requests_total{status=~"5.."}[5m])
)
```

Detecta un problema agregado.

Ventaja:

- Menos alertas.

Desventaja:

- Puede ocultar qué servicio o instancia origina el problema.

## Alerta por instancia

```promql
sum by (instance) (
  rate(http_requests_total{status=~"5.."}[5m])
)
```

Detecta el problema por instancia.

Ventaja:

- Mayor precisión.

Desventaja:

- Puede generar más alertas.

La elección depende del objetivo operativo.

---

# Buenas prácticas

## Validar cada paso por separado

Probar:

```text
Consulta A
Consulta B
Expresión C
Condición D
```

No intentar diagnosticar toda la cadena al mismo tiempo.

## Documentar las unidades

Ejemplo:

```text
Consulta A: bytes
Consulta B: bytes
Expresión C: porcentaje
Condición D: menor que 10 %
```

## Conservar etiquetas necesarias

No agregar todas las series si la alerta necesita identificar una instancia.

## Elegir la reducción según el objetivo

```text
Estado actual → Last
Tendencia media → Mean
Pico → Max
Valor mínimo → Min
```

## Evitar expresiones innecesariamente complejas

Una expresión difícil de entender también será difícil de mantener.

## Proteger las divisiones

Comprobar qué ocurre cuando el denominador vale cero.

## Probar escenarios anómalos

Probar:

- Valores normales.
- Valores altos.
- Valores bajos.
- Ausencia de datos.
- Datos retrasados.
- Varias series.
- Etiquetas incompatibles.

## Separar la consulta de la duración

La ventana de PromQL y la duración de la alerta responden a preguntas diferentes.

## Utilizar nombres claros

Ejemplo:

```text
A = error_rate
B = request_rate
C = error_percentage
```

Cuando la interfaz permite asignar nombres descriptivos, utilizarlos.

## Revisar los resultados en Explore

Explore es útil para comprobar el comportamiento de las consultas antes de convertirlas en reglas.

---

# Errores frecuentes

## El umbral utiliza una unidad incorrecta

Problema:

```text
Consulta devuelve 0.85
Umbral configurado: 90
```

Solución:

- Multiplicar por 100, o
- Cambiar el umbral a `0.90`.

## La expresión devuelve un resultado vacío

Posibles causas:

- Consultas sin series.
- Etiquetas incompatibles.
- Rango temporal incorrecto.
- Filtros demasiado restrictivos.
- Fuente de datos sin información.

## Se pierde la instancia afectada

Causa habitual:

```promql
sum(
  rate(node_cpu_seconds_total[5m])
)
```

La agregación elimina la etiqueta `instance`.

Solución:

```promql
sum by (instance) (
  rate(node_cpu_seconds_total[5m])
)
```

La consulta exacta debe adaptarse al caso de uso.

## La alerta se activa por un pico breve

Posibles soluciones:

- Cambiar `Max` por `Last`.
- Utilizar `Mean`.
- Añadir una duración.
- Revisar el umbral.
- Suavizar la consulta.

## La alerta no se activa aunque el valor parece elevado

Comprobar:

- Reducción elegida.
- Rango temporal.
- Unidad.
- Umbral.
- Series evaluadas.
- Duración.
- Estado de la regla.

## Se combinan series incompatibles

Comprobar:

- Etiquetas comunes.
- Agregaciones.
- Dimensiones.
- Cardinalidad.
- Correspondencia entre instancias.

## Se confunde `[5m]` con la duración de la alerta

`[5m]` es una ventana utilizada por PromQL.

La duración indica cuánto tiempo debe cumplirse la condición.

## Se utiliza `Max` sin evaluar el ruido

`Max` detecta picos, pero puede generar alertas por eventos breves y normales.

## Se utiliza `Mean` para detectar situaciones críticas

Un promedio puede ocultar un pico grave.

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/condiciones-expresiones
```

Crear una plantilla de documentación:

```bash
cat > ~/laboratorio-grafana/evidencias/condiciones-expresiones/registro.txt <<'EOF'
Nombre de la práctica:

Objetivo:

Consulta A:

Consulta B:

Expresión utilizada:

Reducción:

Condición:

Umbral:

Unidad:

Intervalo de evaluación:

Duración:

Etiquetas conservadas:

Comportamiento con ausencia de datos:

Resultado esperado:

Resultado observado:

Problemas encontrados:

Corrección aplicada:

Conclusión:
EOF
```

Guardar ejemplos de consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/condiciones-expresiones/consultas.txt <<'EOF'
CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria disponible:
node_memory_MemAvailable_bytes

Memoria total:
node_memory_MemTotal_bytes

Errores HTTP:
sum by (service) (
  rate(http_requests_total{status=~"5.."}[5m])
)

Peticiones totales:
sum by (service) (
  rate(http_requests_total[5m])
)
EOF
```

Capturas recomendadas:

```text
01-consulta-a-validada.png
02-consulta-b-validada.png
03-expresion-matematica.png
04-reduccion-last.png
05-reduccion-mean.png
06-reduccion-max.png
07-condicion-configurada.png
08-resultado-normal.png
09-resultado-pending.png
10-resultado-alerting.png
11-error-de-unidades.png
12-expresion-corregida.png
```

---

# Práctica integradora

## Objetivo

Crear una regla de alerta utilizando dos consultas, una expresión matemática, una reducción y una condición.

El escenario será el cálculo del porcentaje de errores HTTP.

## Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Una aplicación que exponga `http_requests_total`.
- Etiquetas `service` y `status`.
- Permisos para crear reglas.
- Entorno de laboratorio.

---

## Tarea 1: crear la consulta de errores

```promql
sum by (service) (
  rate(http_requests_total{status=~"5.."}[5m])
)
```

Validar:

```text
¿Devuelve datos?

¿Qué servicios aparecen?

¿Qué unidad tiene el resultado?

¿Se conserva la etiqueta service?
```

---

## Tarea 2: crear la consulta total

```promql
sum by (service) (
  rate(http_requests_total[5m])
)
```

Validar:

```text
¿Devuelve datos?

¿Coincide la etiqueta service con la consulta anterior?

¿El resultado es mayor o igual que la tasa de errores?
```

---

## Tarea 3: crear la expresión matemática

```text
100 * A / B
```

Donde:

```text
A = tasa de errores
B = tasa total de peticiones
```

Validar:

```text
¿El resultado está expresado como porcentaje?

¿El valor está entre 0 y 100?

¿Qué ocurre cuando no hay peticiones?

¿Qué ocurre si A es cero?
```

---

## Tarea 4: configurar la condición

```text
Condición:
Resultado mayor que 5
```

Configuración temporal:

```text
Evaluación: cada 1 minuto
Duración: 5 minutos
```

---

## Tarea 5: añadir etiquetas

```text
severity = critical
team = application
resource = error-rate
environment = laboratory
```

---

## Tarea 6: añadir anotaciones

```text
summary = Tasa de errores elevada en {{ $labels.service }}

description = El servicio {{ $labels.service }}
supera el 5 % de respuestas HTTP 5xx durante cinco minutos.

runbook_url = https://example.com/runbooks/http-error-rate
```

---

## Tarea 7: probar la regla

1. Validar las consultas.
2. Crear la expresión.
3. Configurar la reducción si es necesaria.
4. Configurar el umbral.
5. Guardar la regla.
6. Generar errores controlados en laboratorio.
7. Observar el estado `Pending`.
8. Mantener la condición durante cinco minutos.
9. Observar el estado `Alerting`.
10. Detener los errores.
11. Comprobar la recuperación.
12. Guardar las evidencias.

---

# Práctica adicional: comparación de memoria disponible

## Objetivo

Crear una alerta calculando el porcentaje de memoria disponible mediante dos consultas.

## Consulta A

```promql
node_memory_MemAvailable_bytes
```

## Consulta B

```promql
node_memory_MemTotal_bytes
```

## Expresión C

```text
100 * A / B
```

## Condición

```text
C < 10
```

## Actividades

1. Validar A.
2. Validar B.
3. Comprobar las etiquetas.
4. Crear C.
5. Comprobar la unidad.
6. Configurar el umbral.
7. Añadir una duración de cinco minutos.
8. Probar una situación de laboratorio autorizada.
9. Comprobar la recuperación.
10. Documentar el resultado.

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Consulta A validada | | |
| Consulta B validada | | |
| Etiquetas comparadas | | |
| Expresión creada | | |
| Unidad confirmada | | |
| Reducción configurada | | |
| Condición configurada | | |
| Umbral configurado | | |
| Intervalo configurado | | |
| Duración configurada | | |
| Estado `Normal` observado | | |
| Estado `Pending` observado | | |
| Estado `Alerting` observado | | |
| Recuperación observada | | |
| Ausencia de datos probada | | |
| Error de unidad identificado | | |
| Expresión corregida | | |
| Evidencias guardadas | | |
| Documentación completada | | |

---

# Puntos clave

- Una consulta obtiene datos.
- Una expresión transforma uno o varios resultados.
- Una condición determina si el resultado representa un problema.
- Una serie temporal puede necesitar una reducción antes de evaluarse.
- `Last` representa el último valor.
- `Mean` representa el promedio.
- `Max` detecta el valor máximo.
- `Min` detecta el valor mínimo.
- `Sum` calcula una suma y debe utilizarse con un significado claro.
- La elección de la reducción modifica el comportamiento de la alerta.
- Un umbral debe utilizar la misma unidad que el resultado evaluado.
- Una proporción entre `0` y `1` no es igual que un porcentaje entre `0` y `100`.
- Las consultas combinadas deben tener etiquetas compatibles.
- Las agregaciones pueden eliminar etiquetas necesarias.
- `[5m]` en PromQL es una ventana de consulta, no la duración de una alerta.
- La duración determina cuánto tiempo debe mantenerse una condición.
- Las expresiones matemáticas permiten calcular porcentajes y relaciones.
- Las divisiones deben protegerse frente a denominadores iguales a cero.
- Las expresiones deben probarse con datos normales y anómalos.
- Las consultas deben validarse individualmente antes de combinarlas.
- Las alertas deben conservar las etiquetas necesarias para identificar el recurso.
- Una expresión clara es más fácil de mantener y diagnosticar.
- La ausencia de datos debe tratarse de forma explícita.
- Una regla compleja debe documentar cada paso de su evaluación.

---

# Preguntas de comprobación

1. ¿Qué diferencia existe entre una consulta y una expresión?
2. ¿Qué función cumple una condición?
3. ¿Por qué es necesario reducir una serie temporal en algunos casos?
4. ¿Qué diferencia existe entre `Last`, `Mean`, `Min` y `Max`?
5. ¿Cuándo utilizarías `Max` en lugar de `Last`?
6. ¿Qué significa que una consulta devuelva una proporción entre `0` y `1`?
7. ¿Cómo convertirías una proporción en un porcentaje?
8. ¿Qué diferencia existe entre `[5m]` y una duración de alerta de cinco minutos?
9. ¿Por qué deben ser compatibles las etiquetas de dos consultas combinadas?
10. ¿Qué problema puede causar una división entre cero?
11. ¿Cómo calcularías un porcentaje de errores HTTP?
12. ¿Cómo calcularías el porcentaje de memoria disponible?
13. ¿Qué ocurre si una agregación elimina la etiqueta `instance`?
14. ¿Qué diferencia existe entre una alerta global y una alerta por instancia?
15. ¿Qué revisarías si una expresión devuelve datos vacíos?
16. ¿Qué revisarías si una alerta utiliza un umbral incorrecto?
17. ¿Cómo detectarías una ausencia completa de series?
18. ¿Qué reducción utilizarías para detectar un pico breve?
19. ¿Qué reducción utilizarías para detectar un valor medio sostenido?
20. ¿Cómo probarías una condición con varias consultas?
21. ¿Qué información debe documentarse para una expresión?
22. ¿Qué ocurre si las consultas combinadas tienen dimensiones diferentes?
23. ¿Por qué es importante validar cada consulta por separado?
24. ¿Cómo diferenciarías un valor cero de la ausencia de datos?
25. ¿Qué características debe tener una expresión mantenible?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de construir una evaluación completa utilizando consultas, expresiones, reducciones y condiciones.

El flujo final será:

```text
Crear la consulta A
        |
        v
Crear la consulta B, si es necesaria
        |
        v
Validar cada consulta
        |
        v
Comprobar etiquetas y unidades
        |
        v
Crear una expresión matemática o de reducción
        |
        v
Obtener un valor evaluable
        |
        v
Aplicar la condición
        |
        v
Configurar el umbral
        |
        v
Configurar el intervalo
        |
        v
Configurar la duración
        |
        v
Probar valores normales
        |
        v
Probar valores anómalos
        |
        v
Probar ausencia de datos
        |
        v
Documentar el resultado
```

Una regla basada en expresiones está correctamente configurada cuando:

- Cada consulta devuelve los datos esperados.
- Las series tienen etiquetas compatibles.
- Las unidades están documentadas.
- La reducción responde al objetivo operativo.
- La expresión produce un resultado comprensible.
- El umbral utiliza la escala correcta.
- La condición se activa cuando corresponde.
- La duración evita falsos positivos.
- La recuperación funciona.
- Los casos de ausencia de datos y errores están contemplados.

Las expresiones no son únicamente operaciones matemáticas. Son la forma de convertir datos de monitorización en decisiones operativas claras y verificables.