# Selector de rango de tiempo

## Objetivos

Al finalizar esta sección podrás:

- Identificar la función del selector de rango de tiempo de Grafana.
- Seleccionar intervalos relativos y absolutos.
- Utilizar intervalos predefinidos y personalizados.
- Aplicar un rango temporal a todo un dashboard.
- Comprender la relación entre el rango temporal y la frecuencia de actualización.
- Comparar diferentes periodos de tiempo.
- Identificar problemas relacionados con la zona horaria y la disponibilidad de datos.
- Utilizar rangos temporales adecuados para operaciones, análisis e informes.

## Introducción

El selector de rango de tiempo permite definir el periodo que se mostrará en los paneles de un dashboard.

Por ejemplo, se pueden consultar:

```text
Últimos 5 minutos
Última hora
Últimas 24 horas
Últimos 7 días
Un periodo absoluto concreto
```

El rango temporal seleccionado se aplica normalmente a todos los paneles del dashboard. De esta forma, las visualizaciones muestran los datos correspondientes al mismo periodo.

Una configuración típica puede ser:

```text
Desde: now-6h
Hasta: now
```

Este rango representa las últimas seis horas.

También se puede utilizar un intervalo absoluto:

```text
Desde: 2026-09-22 08:00:00
Hasta: 2026-09-22 14:00:00
```

Los rangos relativos son apropiados para dashboards operativos porque se actualizan automáticamente. Los rangos absolutos resultan útiles para analizar incidentes, elaborar informes o comparar exactamente el mismo periodo entre varias personas.

El selector suele encontrarse en la parte superior derecha de la interfaz del dashboard.

## Contenido

### Localizar el selector de rango

Para utilizar el selector:

1. Abre un dashboard.
2. Localiza el control que muestra el intervalo actual.
3. Haz clic sobre el intervalo.
4. Selecciona una opción predefinida o introduce un rango personalizado.
5. Aplica la selección.

El texto mostrado puede variar según la versión y el idioma de Grafana.

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

En una interfaz traducida pueden aparecer como:

```text
Últimos 5 minutos
Últimos 15 minutos
Últimos 30 minutos
Última hora
Últimas 6 horas
Últimas 12 horas
Últimas 24 horas
Últimos 7 días
Últimos 30 días
```

### Rangos relativos predefinidos

Los rangos relativos se calculan respecto al momento actual.

Ejemplos:

```text
now-5m a now
```

Últimos cinco minutos.

```text
now-1h a now
```

Última hora.

```text
now-6h a now
```

Últimas seis horas.

```text
now-24h a now
```

Últimas veinticuatro horas.

```text
now-7d a now
```

Últimos siete días.

```text
now-30d a now
```

Últimos treinta días.

Cuando el dashboard se actualiza, Grafana vuelve a calcular estos límites tomando como referencia el momento actual.

### Rangos absolutos

Un rango absoluto utiliza una fecha y una hora concretas.

Ejemplo:

```text
Desde: 2026-09-22 08:00:00
Hasta: 2026-09-22 14:00:00
```

Este intervalo siempre representa el mismo periodo, aunque el dashboard se abra más tarde.

Los rangos absolutos son útiles para:

- Investigar incidentes.
- Comparar resultados entre equipos.
- Elaborar informes.
- Analizar una ventana de mantenimiento.
- Revisar el comportamiento después de un cambio.
- Documentar una interrupción de servicio.

Cuando se comparte un rango absoluto, también debe documentarse la zona horaria:

```text
Inicio: 2026-09-22 08:00:00
Fin: 2026-09-22 14:00:00
Zona horaria: Europe/Madrid
```

### Definir un rango personalizado

El selector permite introducir manualmente el inicio y el final del intervalo.

Ejemplo relativo:

```text
Desde: now-90m
Hasta: now
```

Este rango muestra los últimos noventa minutos.

Ejemplo absoluto:

```text
Desde: 2026-09-22 10:00:00
Hasta: 2026-09-22 11:30:00
```

También puede definirse un rango relativo cerrado:

```text
Desde: now-2h
Hasta: now-1h
```

Este intervalo representa el periodo comprendido entre hace dos horas y hace una hora.

El uso de un intervalo cerrado puede ser útil cuando se desea excluir los datos más recientes, que podrían estar incompletos o todavía en proceso de recopilación.

### Expresiones relativas habituales

Grafana utiliza expresiones relativas para representar intervalos dinámicos.

| Expresión | Significado |
|---|---|
| `now` | Momento actual |
| `now-30s` | Hace treinta segundos |
| `now-15m` | Hace quince minutos |
| `now-1h` | Hace una hora |
| `now-6h` | Hace seis horas |
| `now-1d` | Hace un día |
| `now-7d` | Hace siete días |
| `now-1w` | Hace una semana |
| `now-1M` | Hace un mes |
| `now-1y` | Hace un año |

Ejemplo:

```text
Desde: now-12h
Hasta: now
```

Representa las últimas doce horas.

Las unidades más utilizadas son:

```text
s  segundos
m  minutos
h  horas
d  días
w  semanas
M  meses
Q  trimestres
y  años
```

Para periodos operativos exactos suele ser más predecible utilizar horas, días o semanas.

### Redondear el intervalo

Las expresiones de redondeo permiten alinear el rango con el comienzo de una unidad temporal.

Ejemplos:

```text
now/d
```

Comienzo del día actual.

```text
now/w
```

Comienzo de la semana actual.

```text
now/M
```

Comienzo del mes actual.

```text
now/y
```

Comienzo del año actual.

Ejemplo:

```text
Desde: now/d
Hasta: now
```

Este rango representa desde el comienzo del día actual hasta el momento actual.

Otro ejemplo:

```text
Desde: now-7d/d
Hasta: now/d
```

Este rango permite trabajar con límites alineados con días completos.

El resultado puede depender de la zona horaria configurada. Por ese motivo, los informes deben documentar siempre la zona horaria utilizada.

### Aplicar el rango al dashboard

Una vez seleccionado el intervalo, Grafana lo aplica normalmente a todos los paneles del dashboard.

Ejemplo:

```text
Dashboard:
Desde: now-6h
Hasta: now
```

Los paneles consultarán los datos correspondientes a las últimas seis horas.

Esto permite comparar en el mismo contexto:

```text
Panel de CPU
Panel de memoria
Panel de disco
Panel de red
Panel de disponibilidad
```

Si un panel tiene una configuración temporal propia, puede comportarse de forma diferente al resto del dashboard.

### Rango temporal específico de un panel

En algunos casos, un panel puede utilizar un rango temporal diferente al del dashboard.

Por ejemplo:

```text
Dashboard:
Últimas 24 horas
```

```text
Panel de detalle:
Últimos 30 minutos
```

Esta configuración resulta útil cuando:

- El dashboard proporciona una visión general.
- Un panel concreto necesita más detalle.
- Se desea observar una métrica reciente.
- Se necesita representar una alerta o evento próximo.

Debe documentarse esta diferencia para evitar interpretaciones incorrectas.

### Frecuencia de actualización

El selector de rango y la frecuencia de actualización son configuraciones diferentes.

Ejemplo:

```text
Rango temporal: últimas 6 horas
Actualización: cada 1 minuto
```

Grafana muestra seis horas de datos y vuelve a consultar la fuente cada minuto.

Otro ejemplo:

```text
Rango temporal: últimas 15 minutos
Actualización: cada 10 segundos
```

Esta configuración puede ser adecuada para una monitorización casi en tiempo real, siempre que la fuente de datos recopile información con suficiente frecuencia.

La actualización automática puede desactivarse si se desea mantener la vista fija.

### Elegir una frecuencia adecuada

La frecuencia de actualización debe tener en cuenta:

- Frecuencia de recopilación.
- Latencia de la fuente de datos.
- Número de paneles.
- Complejidad de las consultas.
- Capacidad del servidor.
- Número de usuarios.
- Importancia operativa del dashboard.

Ejemplos orientativos:

| Tipo de dashboard | Rango habitual | Actualización orientativa |
|---|---|---|
| Operaciones en tiempo real | Últimos 15 minutos | 5-15 segundos |
| Estado de infraestructura | Últimas 6 horas | 30-60 segundos |
| Análisis de rendimiento | Últimas 24 horas | 1-5 minutos |
| Informe diario | Últimos 7 días | Manual |
| Tendencia mensual | Últimos 30 días | Manual o 5-15 minutos |

Estos valores son orientativos. La configuración real debe ajustarse al comportamiento de la fuente de datos.

### Navegar por el tiempo

El selector de rango suele incluir controles para desplazarse hacia atrás o hacia delante.

Estas funciones permiten:

- Ir al periodo anterior.
- Avanzar hacia un periodo posterior.
- Retroceder manteniendo la misma duración.
- Volver al momento actual.

Por ejemplo, si el rango actual es:

```text
now-6h a now
```

Al desplazarse hacia atrás una ventana, se puede consultar:

```text
now-12h a now-6h
```

La duración del intervalo se mantiene, pero el periodo cambia.

Esta función resulta útil para revisar periodos consecutivos sin introducir manualmente las fechas.

### Volver al momento actual

Después de consultar un periodo histórico, es necesario volver al tiempo actual para continuar con la monitorización.

Utiliza la opción equivalente a:

```text
Now
```

o:

```text
Ir al momento actual
```

Esta acción restablece el rango relativo seleccionado.

Por ejemplo:

```text
Desde: now-6h
Hasta: now
```

Si el dashboard estaba mostrando un intervalo histórico, volver a `now` devuelve la vista a las últimas seis horas.

### Comparar periodos

El selector de rango puede utilizarse junto con el desplazamiento de tiempo para comparar periodos equivalentes.

Ejemplo:

```text
Rango del dashboard:
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

Los periodos comparados son:

```text
Periodo actual:
now-24h a now

Periodo anterior:
now-48h a now-24h
```

Las comparaciones deben utilizar:

- La misma duración.
- La misma consulta.
- Los mismos filtros.
- La misma fuente de datos.
- Una granularidad equivalente.

### Zona horaria

La zona horaria puede modificar la interpretación de los límites del intervalo.

Esto es especialmente importante cuando se utilizan:

```text
now/d
now/w
now/M
now/y
```

Comprueba la zona horaria del sistema:

```bash
timedatectl
```

Ejemplo:

```text
Time zone: Europe/Madrid (CEST, +0200)
```

Comprueba la hora actual:

```bash
date
```

Una política de zona horaria debe estar documentada para:

- Dashboards.
- Informes.
- Alertas.
- Incidentes.
- Comparaciones entre regiones.

En infraestructuras distribuidas, utilizar UTC puede facilitar la correlación entre sistemas. Para usuarios locales, la zona horaria del navegador puede resultar más intuitiva.

### Disponibilidad de datos

El selector de rango no puede mostrar datos que no existen en la fuente.

Un panel puede aparecer vacío cuando:

- El rango es demasiado antiguo.
- La retención no cubre el periodo.
- El exporter estaba detenido.
- La fuente de datos no responde.
- El servicio aún no había comenzado a recopilar métricas.
- Se han modificado las etiquetas.
- La consulta contiene filtros incorrectos.
- Hay una diferencia de zona horaria.
- Se ha seleccionado una fuente de datos equivocada.

Comprueba que Prometheus responde:

```bash
curl http://localhost:9090/-/ready
```

Comprueba la conexión con Grafana desde la interfaz de fuentes de datos.

Si el periodo seleccionado está fuera de la retención, será necesario elegir un intervalo más reciente o revisar la política de almacenamiento.

### Rango de tiempo y PromQL

El rango elegido en Grafana se transmite a Prometheus como el periodo de consulta.

Ejemplo:

```text
Rango del dashboard:
Desde: now-1h
Hasta: now
```

Consulta:

```promql
rate(node_cpu_seconds_total[5m])
```

En este caso:

- El dashboard muestra una hora de resultados.
- La función `rate` utiliza una ventana de cinco minutos.
- La consulta se evalúa en distintos puntos del intervalo.
- El resultado depende de los datos disponibles en cada punto.

El rango del dashboard y la ventana de una consulta PromQL no son equivalentes.

```text
Rango visible:
now-1h a now

Ventana de cálculo:
[5m]
```

### Intervalo mínimo

Grafana permite establecer un intervalo mínimo para evitar consultas excesivamente detalladas.

Por ejemplo:

```text
Min interval: 1m
```

Esto impide que el panel solicite datos con una resolución inferior a un minuto.

El intervalo mínimo puede ayudar a:

- Reducir el número de puntos.
- Disminuir la carga de Prometheus.
- Mejorar el tiempo de respuesta.
- Evitar consultas innecesariamente precisas.
- Adaptar la resolución a la frecuencia de recopilación.

El intervalo mínimo no debe ser inferior a la frecuencia real de recopilación salvo que exista una razón concreta.

### Paneles con diferentes rangos

Un dashboard puede contener paneles con distintas necesidades temporales.

Ejemplo:

```text
Dashboard:
Últimas 24 horas
```

```text
Panel 1: disponibilidad de las últimas 24 horas
Panel 2: errores de los últimos 30 minutos
Panel 3: carga de CPU de las últimas 6 horas
```

Esta flexibilidad es útil, pero puede confundir a los usuarios.

Para mantener la claridad:

- Utiliza títulos explícitos.
- Añade descripciones a los paneles.
- Documenta el intervalo específico.
- Evita diferencias innecesarias.
- Indica si existe desplazamiento temporal.

Ejemplos de títulos claros:

```text
Errores HTTP - últimos 30 minutos
Uso de CPU - últimas 6 horas
Disponibilidad - últimas 24 horas
```

### Rangos recomendados según el objetivo

#### Operación en tiempo real

```text
Rango: últimos 15 minutos
Actualización: 5-15 segundos
```

Adecuado para:

- Incidentes activos.
- Estado de servicios.
- Tráfico actual.
- Errores recientes.

#### Supervisión de infraestructura

```text
Rango: últimas 6 horas
Actualización: 1 minuto
```

Adecuado para:

- CPU.
- Memoria.
- Disco.
- Red.
- Estado de exporters.

#### Análisis diario

```text
Rango: últimas 24 horas
Actualización: 1-5 minutos
```

Adecuado para:

- Tendencias diarias.
- Comparación de cargas.
- Picos de consumo.
- Errores acumulados.

#### Análisis semanal

```text
Rango: últimos 7 días
Actualización: manual o cada 5-15 minutos
```

Adecuado para:

- Tendencias.
- Comparación entre días.
- Capacidad.
- Comportamiento de aplicaciones.

#### Informes históricos

```text
Rango: fechas absolutas
Actualización: manual
```

Adecuado para:

- Informes.
- Auditorías.
- Incidentes cerrados.
- Comparaciones reproducibles.

### Buenas prácticas

Para utilizar correctamente el selector de rango:

- Selecciona un intervalo coherente con el objetivo del dashboard.
- Utiliza rangos relativos en dashboards operativos.
- Utiliza rangos absolutos en investigaciones.
- Documenta la zona horaria.
- Comprueba la retención disponible.
- Ajusta la frecuencia de actualización.
- No actualices con más frecuencia de la necesaria.
- Utiliza un intervalo mínimo razonable.
- Verifica la disponibilidad de datos.
- Documenta los paneles con rangos específicos.
- Utiliza el desplazamiento para comparar periodos equivalentes.
- Comprueba la consulta antes de interpretar un panel vacío.
- Evita rangos muy amplios con consultas demasiado detalladas.
- Mantén una nomenclatura clara en dashboards e informes.

## Ejemplo

### Seleccionar las últimas seis horas

1. Abre el dashboard.
2. Haz clic en el selector de rango.
3. Selecciona:

```text
Last 6 hours
```

El intervalo será equivalente a:

```text
Desde: now-6h
Hasta: now
```

Configura una actualización de:

```text
1m
```

Esta configuración resulta adecuada para un dashboard general de infraestructura.

### Seleccionar un periodo absoluto

Supongamos que se desea analizar un incidente producido el 22 de septiembre de 2026.

Configura:

```text
Desde: 2026-09-22 10:00:00
Hasta: 2026-09-22 11:30:00
```

Documenta la selección:

```text
Incidente: INC-1042
Inicio: 2026-09-22 10:00:00
Fin: 2026-09-22 11:30:00
Zona horaria: Europe/Madrid
Dashboard: Producción / API
```

Este rango permanecerá fijo aunque el dashboard se abra posteriormente.

### Comparar las últimas 24 horas con el día anterior

Selecciona:

```text
Desde: now-24h
Hasta: now
```

Configura dos paneles:

```text
Panel actual:
Desplazamiento: ninguno
```

```text
Panel anterior:
Desplazamiento: 24h
```

El primer panel mostrará:

```text
now-24h a now
```

El segundo mostrará:

```text
now-48h a now-24h
```

Ambos paneles deben utilizar la misma consulta.

### Analizar un periodo cerrado

Para evitar datos incompletos recientes, utiliza:

```text
Desde: now-2h
Hasta: now-1h
```

Este rango excluye la última hora.

Puede resultar útil cuando:

- Existe retraso en la recopilación.
- Las consultas recientes todavía no están completas.
- Se desea analizar un periodo cerrado.
- Se comparan datos ya consolidados.

### Configurar un dashboard operativo

Configuración:

```text
Rango temporal: Últimas 6 horas
Actualización: Cada 1 minuto
Zona horaria: Europe/Madrid
```

Paneles:

```text
├── Estado de objetivos
├── Uso de CPU
├── Memoria disponible
├── Espacio libre
├── Tráfico de red
└── Errores de aplicación
```

Consulta de disponibilidad:

```promql
up
```

Consulta de memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Consulta de carga del sistema:

```promql
node_load1
```

El dashboard debe mostrar información reciente sin generar consultas más frecuentes que la capacidad de recopilación de las fuentes.

### Diagnosticar un panel vacío

Si un panel no muestra datos:

1. Comprueba el rango temporal seleccionado.
2. Selecciona un rango más reciente.
3. Comprueba que la fuente de datos es correcta.
4. Ejecuta la consulta en el explorador.
5. Verifica la conexión con Prometheus.
6. Comprueba las etiquetas utilizadas.
7. Revisa la retención de datos.
8. Comprueba la zona horaria.
9. Revisa los logs de Grafana y Prometheus.

Desde el servidor de Grafana:

```bash
curl http://localhost:9090/-/ready
```

Comprueba el servicio de Grafana:

```bash
sudo systemctl status grafana-server
```

Consulta los logs:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

## Puntos clave

- El selector de rango define el periodo temporal mostrado en un dashboard.
- Puede utilizar intervalos relativos o absolutos.
- Los intervalos relativos utilizan expresiones como `now-6h` y `now-7d`.
- Los intervalos absolutos utilizan fechas y horas concretas.
- Los rangos relativos se recalculan al actualizar el dashboard.
- Los rangos absolutos permanecen fijos.
- El rango seleccionado se aplica normalmente a todos los paneles.
- Un panel puede tener una configuración temporal específica.
- La frecuencia de actualización es diferente del rango temporal.
- La frecuencia de actualización debe ser coherente con la frecuencia de recopilación.
- Un intervalo mínimo puede reducir la carga de las consultas.
- Las expresiones `now/d`, `now/w` y `now/M` permiten alinear los límites temporales.
- La zona horaria influye especialmente en los rangos redondeados.
- La retención de la fuente limita la antigüedad de los datos consultables.
- Un panel vacío no siempre significa que Grafana esté fallando.
- Los rangos absolutos son adecuados para informes e investigaciones reproducibles.
- Los rangos relativos son adecuados para dashboards operativos.
- Los paneles comparativos deben utilizar periodos equivalentes.
- La ventana temporal de PromQL no es igual al rango visible del dashboard.
- Los títulos de los paneles deben indicar su rango cuando sea diferente al general.
- La configuración temporal debe documentarse en dashboards utilizados para operaciones o auditorías.

## Preguntas de comprobación

1. ¿Qué función cumple el selector de rango de tiempo?
2. ¿Qué diferencia existe entre un rango relativo y uno absoluto?
3. ¿Qué periodo representa el intervalo `now-6h` a `now`?
4. ¿Qué ocurre con un rango relativo cuando se actualiza el dashboard?
5. ¿Cuándo resulta más adecuado utilizar un rango absoluto?
6. ¿Qué significa la expresión `now/d`?
7. ¿Por qué es importante documentar la zona horaria?
8. ¿Qué diferencia existe entre el rango temporal y la frecuencia de actualización?
9. ¿Qué factores deben tenerse en cuenta al elegir la frecuencia de actualización?
10. ¿Para qué sirve establecer un intervalo mínimo?
11. ¿Qué puede provocar que un panel aparezca vacío?
12. ¿Cómo comprobarías que Prometheus está disponible?
13. ¿Cómo compararías las últimas 24 horas con las 24 horas anteriores?
14. ¿Qué rango utilizarías para analizar el periodo entre hace dos horas y hace una hora?
15. ¿Por qué no es recomendable actualizar un dashboard con demasiada frecuencia?
16. ¿Qué diferencia existe entre el rango del dashboard y una ventana como `[5m]` en PromQL?
17. ¿Qué ventajas ofrecen los rangos relativos en dashboards operativos?
18. ¿Qué información debe documentarse al analizar un incidente?
19. ¿Por qué un panel puede necesitar un rango diferente al del dashboard?
20. ¿Qué pasos seguirías para diagnosticar un panel sin datos?