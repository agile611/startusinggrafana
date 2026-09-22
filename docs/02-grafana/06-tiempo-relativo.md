# Tiempo relativo y desplazamiento de tiempo

## Objetivos

Al finalizar esta sección podrás:

- Comprender qué es un intervalo de tiempo relativo en Grafana.
- Utilizar expresiones como `now-1h` y `now-7d`.
- Seleccionar intervalos relativos desde el selector de tiempo.
- Aplicar desplazamientos de tiempo para comparar periodos.
- Diferenciar entre rango temporal, tiempo relativo y desplazamiento.
- Comparar los datos actuales con los de una hora, un día o una semana anterior.
- Identificar los efectos del tiempo relativo en dashboards, paneles y alertas.
- Evitar errores habituales relacionados con la zona horaria y la disponibilidad de datos.

## Introducción

Grafana representa los datos dentro de un intervalo temporal.

Por ejemplo:

```text
Desde: hace 6 horas
Hasta: ahora
```

Este intervalo puede expresarse mediante valores absolutos:

```text
Desde: 2026-09-22 08:00:00
Hasta: 2026-09-22 14:00:00
```

o mediante valores relativos:

```text
Desde: now-6h
Hasta: now
```

El uso de tiempos relativos permite que un dashboard se mantenga actualizado sin modificar manualmente las fechas.

Cada vez que se carga el dashboard, Grafana calcula de nuevo la expresión relativa tomando como referencia el momento actual.

```text
now
│
├── now-5m    Hace cinco minutos
├── now-1h    Hace una hora
├── now-6h    Hace seis horas
├── now-1d    Hace un día
└── now-7d    Hace siete días
```

El desplazamiento de tiempo permite mover el intervalo temporal de un panel hacia el pasado o, según la configuración, realizar comparaciones entre periodos.

Por ejemplo, un panel puede mostrar:

- Las métricas actuales.
- Las métricas del mismo periodo del día anterior.
- Las métricas de la semana anterior.
- Dos periodos equivalentes para comparar tendencias.

## Contenido

### El concepto `now`

Grafana utiliza `now` como referencia para representar el momento actual.

Ejemplos:

```text
now
```

Representa el momento actual.

```text
now-5m
```

Representa el momento actual menos cinco minutos.

```text
now-1h
```

Representa el momento actual menos una hora.

```text
now-24h
```

Representa el momento actual menos veinticuatro horas.

```text
now-7d
```

Representa el momento actual menos siete días.

Las expresiones relativas se calculan cuando Grafana consulta los datos.

### Unidades de tiempo

Las expresiones relativas utilizan unidades de tiempo.

| Unidad | Significado | Ejemplo |
|---|---|---|
| `s` | Segundos | `now-30s` |
| `m` | Minutos | `now-15m` |
| `h` | Horas | `now-6h` |
| `d` | Días | `now-2d` |
| `w` | Semanas | `now-1w` |
| `M` | Meses | `now-1M` |
| `Q` | Trimestres | `now-1Q` |
| `y` | Años | `now-1y` |

Ejemplos:

```text
now-30s
now-15m
now-2h
now-3d
now-2w
now-1M
now-1y
```

La interpretación de meses, trimestres y años puede depender del calendario. Para intervalos exactos suele ser más predecible utilizar horas, días o semanas.

### Rangos relativos

Un rango temporal se define normalmente mediante dos valores:

```text
Desde
Hasta
```

Ejemplo:

```text
Desde: now-6h
Hasta: now
```

Este rango representa las últimas seis horas.

Otros ejemplos:

```text
Desde: now-15m
Hasta: now
```

Representa los últimos quince minutos.

```text
Desde: now-24h
Hasta: now
```

Representa las últimas veinticuatro horas.

```text
Desde: now-7d
Hasta: now
```

Representa los últimos siete días.

```text
Desde: now-30d
Hasta: now
```

Representa los últimos treinta días.

### Seleccionar un tiempo relativo desde Grafana

Para seleccionar un intervalo relativo:

1. Abre un dashboard.
2. Localiza el selector de rango temporal.
3. Haz clic sobre el intervalo actual.
4. Selecciona una opción, como `Last 5 minutes`, `Last 6 hours` o `Last 7 days`.
5. Aplica el intervalo seleccionado.

Algunas opciones habituales son:

```text
Last 5 minutes
Last 15 minutes
Last 30 minutes
Last 1 hour
Last 6 hours
Last 12 hours
Last 24 hours
Last 7 days
Last 30 days
```

La interfaz puede mostrar estos valores en el idioma configurado o en inglés, según la versión y las preferencias de Grafana.

### Introducir un rango personalizado

Además de las opciones predefinidas, se puede utilizar un rango personalizado.

Ejemplo:

```text
Desde: now-90m
Hasta: now
```

Este rango muestra los últimos noventa minutos.

Otro ejemplo:

```text
Desde: now-36h
Hasta: now
```

Este rango muestra las últimas treinta y seis horas.

También se puede definir un rango relativo que no termine exactamente en el momento actual:

```text
Desde: now-2h
Hasta: now-1h
```

Este rango representa el periodo comprendido entre hace dos horas y hace una hora.

```text
Tiempo actual
│
├───────────────┬───────────────┬───────────────
                │               │
              now-2h          now-1h          now
                └── Intervalo ──┘
```

Este tipo de rango resulta útil para analizar un periodo cerrado y evitar que los datos más recientes estén todavía incompletos.

### Redondeo temporal

Grafana permite redondear una referencia temporal a una unidad concreta.

Ejemplos:

```text
now/d
```

Redondea al inicio del día actual.

```text
now/w
```

Redondea al inicio de la semana actual.

```text
now/M
```

Redondea al inicio del mes actual.

```text
now/y
```

Redondea al inicio del año actual.

Ejemplos de rangos:

```text
Desde: now/d
Hasta: now
```

Representa desde el comienzo del día actual hasta el momento actual.

```text
Desde: now-7d/d
Hasta: now/d
```

Representa un periodo alineado con límites diarios.

```text
Desde: now-1M/M
Hasta: now/M
```

Representa el mes natural anterior, dependiendo de la interpretación de los límites del calendario.

El redondeo es especialmente útil para informes diarios, mensuales o semanales.

### Tiempo relativo frente a tiempo absoluto

Un tiempo absoluto utiliza fechas concretas:

```text
Desde: 2026-09-20 00:00:00
Hasta: 2026-09-21 00:00:00
```

Un tiempo relativo utiliza expresiones dinámicas:

```text
Desde: now-24h
Hasta: now
```

| Tipo | Ejemplo | Uso habitual |
|---|---|---|
| Absoluto | `2026-09-20 00:00` | Analizar un periodo histórico concreto |
| Relativo | `now-24h` a `now` | Dashboards operativos |
| Redondeado | `now/d` | Informes diarios |
| Desplazado | `now-1d` | Comparar con un periodo anterior |

Los intervalos relativos son adecuados para dashboards que deben actualizarse continuamente.

Los intervalos absolutos son adecuados para investigaciones históricas o informes que deben conservar exactamente el mismo periodo.

### Actualización automática

Un dashboard puede actualizarse automáticamente cada cierto intervalo.

Ejemplos de frecuencia:

```text
5s
10s
30s
1m
5m
15m
```

La frecuencia de actualización debe ser coherente con:

- La frecuencia de recopilación de las métricas.
- La latencia de la fuente de datos.
- El coste de las consultas.
- La capacidad del servidor.
- La importancia operativa del dashboard.

No es recomendable actualizar un dashboard cada cinco segundos si las métricas solo se recopilan cada minuto.

Una frecuencia excesiva puede provocar:

- Muchas consultas.
- Mayor uso de CPU.
- Mayor carga en Prometheus.
- Respuestas más lentas.
- Límites de consulta.
- Consumo innecesario de red.

### Intervalo de actualización y rango temporal

El rango temporal y la frecuencia de actualización son conceptos distintos.

Ejemplo:

```text
Rango temporal: últimos 6 horas
Actualización: cada 1 minuto
```

Grafana mostrará seis horas de datos y volverá a consultar el origen cada minuto.

Otro ejemplo:

```text
Rango temporal: últimos 15 minutos
Actualización: cada 5 segundos
```

Este intervalo puede ser adecuado para monitorización casi en tiempo real, siempre que la fuente recopile datos con suficiente frecuencia.

Una configuración razonable debe considerar:

```text
Frecuencia de recopilación ≤ Frecuencia de actualización
```

Si la fuente solo genera datos cada sesenta segundos, actualizar Grafana cada cinco segundos no proporcionará información nueva en la mayoría de las consultas.

### Tiempo relativo en PromQL

Cuando Grafana consulta Prometheus, el rango temporal se transmite a Prometheus.

Una consulta como:

```promql
rate(node_cpu_seconds_total[5m])
```

se evaluará repetidamente dentro del rango seleccionado en Grafana.

El intervalo de consulta del dashboard determina los momentos en los que Prometheus calcula la expresión.

Ejemplo:

```text
Rango de Grafana: now-1h a now
Consulta: rate(node_cpu_seconds_total[5m])
```

Grafana solicitará a Prometheus los resultados de la consulta para los puntos comprendidos en la última hora.

La ventana `[5m]` de PromQL es distinta del rango temporal del dashboard:

- `now-1h` a `now` define el periodo visible.
- `[5m]` define la ventana utilizada por la función `rate`.

### Tiempo relativo y resolución

Un rango amplio puede contener muchos puntos de datos.

Por ejemplo:

```text
Rango: 30 días
Intervalo de consulta: 10 segundos
```

Este diseño podría generar un número elevado de puntos y consultas costosas.

Grafana suele ajustar el intervalo de consulta en función de:

- Anchura del panel.
- Rango temporal.
- Resolución configurada.
- Número de puntos máximos.
- Fuente de datos.
- Consulta utilizada.

Para evitar consultas innecesariamente costosas:

- Utiliza rangos adecuados.
- Evita intervalos demasiado pequeños.
- Ajusta el intervalo mínimo.
- Usa funciones de agregación cuando corresponda.
- Limita la cantidad de series.
- Revisa las consultas complejas.

### Desplazamiento de tiempo

El desplazamiento de tiempo permite mover la ventana temporal de un panel respecto al rango general del dashboard.

Supongamos que el dashboard utiliza:

```text
Desde: now-6h
Hasta: now
```

Si se aplica un desplazamiento de un día, el panel puede consultar:

```text
Desde: now-1d-6h
Hasta: now-1d
```

De esta forma, el panel muestra el mismo intervalo de seis horas, pero correspondiente al día anterior.

Representación:

```text
Periodo actual:
now-6h ├──────────────────────────────┤ now

Periodo desplazado un día:
now-1d-6h ├───────────────────────────┤ now-1d
```

Esto permite comparar:

- Hoy frente a ayer.
- Esta semana frente a la semana anterior.
- Este mes frente al mes anterior.
- Antes y después de un cambio.
- Dos periodos de funcionamiento equivalentes.

### Configurar un desplazamiento en un panel

El desplazamiento suele configurarse en las opciones de tiempo del panel.

Procedimiento general:

1. Abre el dashboard.
2. Selecciona un panel.
3. Abre el menú de edición.
4. Accede a las opciones de consulta o de tiempo.
5. Localiza la opción **Time shift** o **Desplazamiento de tiempo**.
6. Introduce un valor, como:
   ```text
   1d
   ```
7. Guarda el panel.
8. Compara los resultados con otro panel sin desplazamiento.

La ubicación exacta de la opción puede variar según la versión de Grafana y el tipo de panel.

Ejemplos de desplazamiento:

```text
1h
6h
1d
7d
1w
30d
```

Un valor de:

```text
1d
```

suele utilizarse para consultar el mismo intervalo del día anterior.

Un valor de:

```text
7d
```

suele utilizarse para consultar el mismo periodo de la semana anterior.

### Tiempo relativo del panel

Además del desplazamiento, un panel puede definir un rango relativo propio.

Por ejemplo, el dashboard puede utilizar:

```text
Últimas 24 horas
```

y un panel concreto puede utilizar:

```text
Últimos 30 minutos
```

Esta configuración permite que un panel tenga un rango diferente al resto del dashboard.

Ejemplos:

```text
Panel general:
Desde: now-24h
Hasta: now
```

```text
Panel de detalle:
Desde: now-15m
Hasta: now
```

El panel de detalle puede mostrar datos recientes con mayor precisión sin cambiar el rango de los demás paneles.

### Comparación entre periodos

Una forma habitual de comparar periodos es utilizar dos paneles:

```text
Panel 1: periodo actual
Panel 2: periodo desplazado un día
```

Ejemplo:

```text
Panel actual:
Rango: dashboard
Desplazamiento: ninguno
```

```text
Panel anterior:
Rango: dashboard
Desplazamiento: 1d
```

Otra posibilidad consiste en mostrar dos series en un mismo panel, siempre que la fuente de datos y la consulta permitan realizar la comparación.

La comparación debe utilizar periodos equivalentes:

- Misma duración.
- Misma granularidad.
- Misma consulta.
- Mismos filtros.
- Mismas etiquetas.
- Mismo tratamiento de valores ausentes.

### Comparar hoy con ayer

Supongamos que el dashboard muestra las últimas seis horas.

Configuración:

```text
Dashboard:
Desde: now-6h
Hasta: now
```

Panel actual:

```text
Time shift: vacío
```

Panel del día anterior:

```text
Time shift: 1d
```

Interpretación:

```text
Panel actual:
[Hace 6 horas, ahora]

Panel anterior:
[Hace 30 horas, hace 24 horas]
```

Ambos paneles muestran intervalos de seis horas, pero separados por un día.

### Comparar esta semana con la anterior

Configuración:

```text
Dashboard:
Desde: now-7d
Hasta: now
```

Panel de la semana actual:

```text
Time shift: vacío
```

Panel de la semana anterior:

```text
Time shift: 7d
```

Interpretación:

```text
Semana actual:
[now-7d, now]

Semana anterior:
[now-14d, now-7d]
```

Esta comparación puede ser útil para analizar:

- Tráfico.
- Solicitudes.
- Errores.
- Consumo de recursos.
- Número de usuarios.
- Rendimiento de aplicaciones.

### Desplazamiento y datos ausentes

Un desplazamiento de tiempo requiere que existan datos en el periodo desplazado.

Por ejemplo, si Prometheus solo conserva datos de las últimas veinticuatro horas, no será posible consultar correctamente un desplazamiento de siete días.

Comprueba la retención configurada en Prometheus y en la fuente de datos.

Los datos también pueden faltar por:

- Servicio detenido.
- Exporter no disponible.
- Error de red.
- Cambio de etiquetas.
- Reinicio de la fuente.
- Retención insuficiente.
- Consulta incorrecta.
- Diferencias de zona horaria.

Un panel vacío no siempre significa que Grafana esté fallando. Puede indicar que el periodo solicitado no contiene datos.

### Zona horaria

La zona horaria influye en la interpretación de los límites de día, semana, mes y año.

Por ejemplo:

```text
now/d
```

puede alinearse con el inicio del día según la zona horaria utilizada.

Para evitar confusiones:

- Sincroniza la hora del sistema.
- Define una política de zona horaria.
- Utiliza UTC en entornos distribuidos cuando sea conveniente.
- Verifica la zona horaria del usuario.
- Comprueba la zona horaria del dashboard.
- Documenta la zona horaria de los informes.

Comprueba la hora del servidor:

```bash
date
```

Comprueba la configuración completa:

```bash
timedatectl
```

### Tiempo relativo en alertas

Las reglas de alerta utilizan sus propias ventanas de evaluación.

Por ejemplo:

```promql
avg_over_time(
  node_load1[5m]
) > 4
```

La ventana `[5m]` indica que la consulta utiliza los últimos cinco minutos para calcular el promedio.

Esto no debe confundirse con el rango temporal visible de un dashboard.

Las alertas deben considerar:

- Ventana de evaluación.
- Intervalo de evaluación.
- Duración de la condición.
- Retraso de la fuente de datos.
- Retención.
- Zona horaria para las notificaciones.
- Ausencia de datos.

Un dashboard puede mostrar las últimas veinticuatro horas mientras una alerta evalúa únicamente los últimos cinco minutos.

### Tiempo absoluto para investigaciones

Los rangos relativos son adecuados para operaciones diarias, pero una investigación de incidentes suele necesitar rangos absolutos.

Ejemplo:

```text
Desde: 2026-09-22 10:00:00
Hasta: 2026-09-22 11:30:00
```

Un rango absoluto permite que varias personas analicen exactamente el mismo periodo.

Es recomendable documentar:

- Fecha y hora de inicio.
- Fecha y hora de finalización.
- Zona horaria.
- Dashboard utilizado.
- Filtros aplicados.
- Consultas relevantes.
- Identificador del incidente.

Ejemplo:

```text
Incidente INC-1042
Inicio: 2026-09-22 10:00:00
Fin: 2026-09-22 11:30:00
Zona horaria: Europe/Madrid
Dashboard: Producción / API
```

### Buenas prácticas

Para utilizar correctamente los tiempos relativos:

- Utiliza `now` para dashboards dinámicos.
- Utiliza rangos absolutos en investigaciones reproducibles.
- Elige una frecuencia de actualización coherente con la fuente.
- Evita intervalos demasiado pequeños.
- Comprueba la retención de los datos.
- Documenta la zona horaria.
- Utiliza desplazamientos con periodos equivalentes.
- Verifica que existen datos en el periodo comparado.
- No confundas el rango del dashboard con la ventana de PromQL.
- Revisa el comportamiento alrededor de cambios de horario.
- Utiliza nombres claros para paneles comparativos.
- Evita aplicar desplazamientos diferentes sin documentarlos.

## Ejemplo

### Mostrar las últimas seis horas

Configura el selector de tiempo del dashboard:

```text
Desde: now-6h
Hasta: now
```

Este rango muestra los datos comprendidos entre hace seis horas y el momento actual.

Una consulta PromQL de ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

La consulta calcula el porcentaje aproximado de uso de CPU dentro del intervalo visible.

### Mostrar el mismo periodo del día anterior

Dashboard:

```text
Desde: now-6h
Hasta: now
```

Panel actual:

```text
Desplazamiento: ninguno
```

Panel del día anterior:

```text
Desplazamiento: 1d
```

La comparación será:

```text
Periodo actual:
now-6h a now

Periodo anterior:
now-1d-6h a now-1d
```

Los dos paneles deben utilizar:

- La misma consulta.
- Los mismos filtros.
- La misma fuente de datos.
- El mismo tipo de visualización.

### Mostrar las últimas veinticuatro horas

Selecciona:

```text
Desde: now-24h
Hasta: now
```

Configura una actualización razonable:

```text
Actualizar cada: 1m
```

Esta configuración puede ser adecuada para un dashboard operativo de infraestructura.

Si el servidor tiene muchos paneles, revisa el consumo de recursos y evita que todas las consultas sean innecesariamente complejas.

### Comparar las últimas veinticuatro horas con el periodo anterior

Utiliza el rango:

```text
Desde: now-24h
Hasta: now
```

Panel actual:

```text
Desplazamiento: ninguno
```

Panel anterior:

```text
Desplazamiento: 24h
```

Los periodos consultados serán:

```text
Periodo actual:
now-24h a now

Periodo anterior:
now-48h a now-24h
```

Esta configuración permite comparar dos intervalos consecutivos de veinticuatro horas.

### Utilizar un intervalo cerrado

Para analizar un periodo que ya ha terminado:

```text
Desde: now-2h
Hasta: now-1h
```

Este rango excluye la última hora y puede ser útil cuando los datos más recientes aún no están completos.

Por ejemplo:

```text
Periodo analizado:
Entre hace dos horas y hace una hora
```

Este enfoque puede reducir las diferencias provocadas por:

- Retrasos de recopilación.
- Procesamiento pendiente.
- Métricas todavía incompletas.
- Retrasos de red.

### Definir un dashboard de operación

Configuración recomendada:

```text
Rango temporal: now-6h a now
Actualización: 1m
Zona horaria: local o UTC documentada
```

Paneles:

```text
├── Estado de objetivos
├── Uso de CPU
├── Memoria disponible
├── Espacio de almacenamiento
├── Tráfico de red
└── Errores de aplicación
```

Para el panel de estado:

```promql
up
```

Para la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Para el espacio disponible:

```promql
node_filesystem_avail_bytes{
  fstype!~"tmpfs|overlay"
}
```

El rango temporal debe ser suficientemente amplio para detectar tendencias, pero no tan amplio que oculte cambios recientes.

## Puntos clave

- `now` representa el momento actual en Grafana.
- Las expresiones como `now-1h` representan intervalos relativos.
- Un rango temporal tiene un inicio y un final.
- `now-6h` a `now` representa las últimas seis horas.
- Los rangos relativos se recalculan cada vez que se actualiza el dashboard.
- Los rangos absolutos utilizan fechas y horas concretas.
- El redondeo temporal utiliza expresiones como `now/d`, `now/w` o `now/M`.
- La frecuencia de actualización es diferente del rango temporal.
- El desplazamiento de tiempo mueve el intervalo de un panel a otro periodo.
- Un desplazamiento de `1d` suele utilizarse para comparar con el día anterior.
- Un desplazamiento de `7d` suele utilizarse para comparar con la semana anterior.
- El periodo desplazado debe contener datos disponibles.
- La retención de la fuente de datos limita el intervalo que puede consultarse.
- La zona horaria influye en los límites de días, semanas y meses.
- El rango visible del dashboard no es igual que la ventana temporal de una consulta PromQL.
- La ventana `[5m]` de PromQL define el periodo utilizado por una función como `rate`.
- Los rangos absolutos son apropiados para investigaciones e informes reproducibles.
- La frecuencia de actualización debe ser coherente con la frecuencia de recopilación.
- Un intervalo demasiado pequeño puede aumentar innecesariamente la carga del sistema.
- Los paneles comparativos deben utilizar consultas, filtros y periodos equivalentes.
- Un panel vacío puede deberse a la ausencia de datos y no a un fallo de Grafana.

## Preguntas de comprobación

1. ¿Qué representa el valor `now` en Grafana?
2. ¿Qué periodo representa el rango `now-6h` a `now`?
3. ¿Qué diferencia existe entre un tiempo relativo y uno absoluto?
4. ¿Qué significa la expresión `now-1d`?
5. ¿Para qué se utiliza la expresión `now/d`?
6. ¿Qué diferencia existe entre rango temporal y frecuencia de actualización?
7. ¿Qué ocurre cuando se selecciona un rango relativo y se actualiza el dashboard?
8. ¿Qué es un desplazamiento de tiempo?
9. ¿Qué periodo consulta un panel con un desplazamiento de `1d` si el dashboard muestra las últimas seis horas?
10. ¿Cómo compararías las últimas veinticuatro horas con el periodo anterior?
11. ¿Por qué puede aparecer vacío un panel con un desplazamiento de siete días?
12. ¿Qué relación existe entre el desplazamiento y la retención de datos?
13. ¿Qué diferencia existe entre `now-1h` y `now-1h/d`?
14. ¿Qué representa la ventana `[5m]` en una consulta PromQL?
15. ¿Por qué no es recomendable actualizar Grafana cada cinco segundos si las métricas se recopilan cada minuto?
16. ¿Cuándo es preferible utilizar un intervalo absoluto?
17. ¿Por qué es importante documentar la zona horaria?
18. ¿Qué elementos deben mantenerse iguales al comparar dos periodos?
19. ¿Qué rango usarías para analizar el periodo comprendido entre hace dos horas y hace una hora?
20. ¿Qué comprobaciones realizarías si un panel con desplazamiento no muestra datos?
```