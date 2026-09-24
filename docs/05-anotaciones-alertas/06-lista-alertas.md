# Lista de alertas

La **lista de alertas** de Grafana permite consultar, filtrar y analizar las reglas de alerta y sus estados actuales.

Desde esta vista, los operadores pueden identificar:

- Qué alertas existen.
- Qué alertas están activas.
- Qué alertas están pendientes.
- Qué alertas se han resuelto.
- Qué servicio o instancia está afectado.
- Qué equipo es responsable.
- Qué severidad tiene cada alerta.
- Cuándo se evaluó por última vez.
- Cuándo cambió de estado.
- Qué regla originó la alerta.

La lista de alertas es una de las vistas principales para supervisar el estado operativo de una plataforma.

El flujo habitual es:

```text
Crear una regla
      |
      v
Evaluar la regla
      |
      v
Consultar su estado
      |
      v
Filtrar por etiquetas
      |
      v
Abrir el detalle
      |
      v
Investigar el problema
      |
      v
Comprobar la recuperación
```

La ubicación y el nombre exacto de algunas opciones pueden variar según la versión de Grafana.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Acceder a la lista de alertas de Grafana.
- Diferenciar una regla de alerta de una instancia de alerta.
- Interpretar los estados de las alertas.
- Filtrar alertas por estado.
- Filtrar alertas por etiquetas.
- Buscar alertas por nombre.
- Identificar la instancia afectada.
- Consultar la regla que originó una alerta.
- Revisar las consultas y expresiones de una regla.
- Consultar las anotaciones de una alerta.
- Revisar el historial de estados.
- Identificar alertas sin datos.
- Identificar alertas con errores de evaluación.
- Consultar alertas silenciadas.
- Distinguir entre una alerta activa y una alerta notificada.
- Investigar una alerta desde su información detallada.
- Documentar las alertas encontradas.
- Construir una vista operativa de alertas para un equipo.

---

# Introducción

Una plataforma monitorizada puede tener decenas o cientos de reglas de alerta.

Consultar cada regla individualmente no es práctico. La lista de alertas proporciona una vista centralizada del estado de todas ellas.

Ejemplo:

```text
NodeExporterDown       Normal
HighCPUUsage            Alerting
HighMemoryUsage         Normal
FilesystemUsageHigh     Pending
HighApplicationLatency  No data
```

Esta información permite identificar rápidamente qué situaciones requieren atención.

## Ejemplo operativo

Supongamos que un servidor presenta un uso elevado de CPU.

La lista puede mostrar:

```text
Nombre: HighCPUUsage
Estado: Alerting
Instancia: server-01:9100
Severidad: warning
Equipo: systems
Inicio: 2026-09-24 17:45
```

El operador puede abrir el detalle para consultar:

- La consulta utilizada.
- El valor actual.
- El umbral.
- La duración configurada.
- Las etiquetas.
- Las anotaciones.
- El historial de cambios.
- El contacto de notificación.
- Los silenciamientos activos.

---

# Regla e instancia de alerta

Estos conceptos son importantes para interpretar correctamente la lista.

## Regla de alerta

Una regla define la condición que Grafana evalúa.

Ejemplo:

```text
HighCPUUsage
```

La regla puede aplicarse a varias instancias.

## Instancia de alerta

Una instancia representa una evaluación concreta de una regla y un conjunto de etiquetas.

Ejemplo:

```text
Regla: HighCPUUsage

Instancias:
- server-01:9100
- server-02:9100
- server-03:9100
```

Una regla multidimensional puede generar varias instancias:

```text
server-01 → Normal
server-02 → Alerting
server-03 → Normal
```

La regla es la definición general.

La instancia identifica el recurso concreto que presenta el problema.

---

# Acceder a la lista de alertas

El procedimiento habitual es:

1. Acceder a Grafana.
2. Abrir el menú lateral.
3. Seleccionar **Alerting**.
4. Abrir la vista de alertas o reglas.
5. Revisar la lista.
6. Utilizar los filtros disponibles.
7. Abrir una alerta para consultar su detalle.

Según la versión de Grafana, puede existir una separación entre:

```text
Reglas de alerta
Instancias de alerta
Historial de alertas
Contactos
Políticas
Silenciamientos
```

Es importante distinguir entre la vista que muestra las reglas configuradas y la vista que muestra sus estados actuales.

---

# Información habitual de la lista

La lista puede mostrar columnas similares a estas:

| Campo | Descripción |
|---|---|
| Nombre | Nombre de la regla |
| Estado | Estado actual |
| Severidad | Nivel de importancia |
| Equipo | Equipo responsable |
| Servicio | Servicio afectado |
| Instancia | Recurso afectado |
| Última evaluación | Momento de la última evaluación |
| Inicio | Momento en que comenzó el estado |
| Fuente | Origen de los datos |
| Silenciada | Indica si existe un silencio |

La disponibilidad exacta de las columnas depende de la versión y de la configuración de Grafana.

---

# Estados de las alertas

## Normal

La condición de la regla no se cumple.

```text
CPU actual: 45 %
Umbral: 90 %
Estado: Normal
```

Una alerta en estado normal no requiere una acción inmediata.

## Pending

La condición se cumple, pero aún no ha transcurrido la duración configurada.

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Tiempo transcurrido: 2 minutos
Estado: Pending
```

Este estado permite observar si el problema es sostenido o solo un pico temporal.

## Alerting o Firing

La condición se ha mantenido durante el periodo configurado.

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Estado: Alerting
```

Esta alerta requiere revisión según su severidad y el procedimiento operativo correspondiente.

## No data

La regla no recibe datos suficientes para evaluarse.

Posibles causas:

- La consulta no devuelve series.
- El objetivo ha dejado de responder.
- Prometheus no está disponible.
- La métrica no existe.
- Hay un filtro incorrecto.
- La fuente de datos no responde.

## Error

La regla no puede evaluarse correctamente.

Posibles causas:

- Error de sintaxis.
- Expresión incorrecta.
- Fuente de datos inaccesible.
- Problema de permisos.
- Consulta incompatible.

## Normalizada o resuelta

La condición que generó la alerta ha dejado de cumplirse.

```text
CPU actual: 48 %
Umbral: 90 %
Estado: Normal
```

El nombre exacto del estado puede variar según la versión.

---

# Filtrar la lista de alertas

Los filtros ayudan a reducir el número de resultados mostrados.

## Filtrar por estado

Ejemplos:

```text
Alerting
Pending
Normal
No data
Error
```

### Uso

Filtrar por `Alerting` permite concentrarse en las alertas activas.

Filtrar por `Pending` ayuda a observar problemas que todavía no han superado la duración configurada.

Filtrar por `No data` permite investigar pérdidas de visibilidad.

## Filtrar por severidad

Ejemplos:

```text
severity = critical
severity = warning
severity = info
```

## Filtrar por equipo

Ejemplos:

```text
team = systems
team = application
team = database
```

## Filtrar por servicio

Ejemplos:

```text
service = api
service = prometheus
service = node_exporter
```

## Filtrar por entorno

Ejemplos:

```text
environment = laboratory
environment = staging
environment = production
```

## Filtrar por instancia

Ejemplo:

```text
instance = server-01:9100
```

Los nombres de los filtros dependen de las etiquetas utilizadas en las reglas.

---

# Convenciones de etiquetas

Para que los filtros funcionen correctamente, las reglas deben utilizar nombres consistentes.

## Etiquetas recomendadas

```text
alertname
severity
team
service
environment
instance
resource
region
```

## Ejemplo

```text
alertname = HighCPUUsage
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
instance = server-01:9100
```

## Problema de nombres inconsistentes

Estas etiquetas podrían representar conceptos parecidos:

```text
team
owner
responsible_team
```

Si cada regla utiliza un nombre diferente, los filtros y las políticas serán más difíciles de mantener.

Es preferible establecer una convención:

```text
team = systems
```

y utilizarla en todas las reglas.

---

# Buscar alertas

La búsqueda permite localizar una regla concreta por su nombre o por otros datos visibles.

Ejemplos de búsqueda:

```text
HighCPUUsage
NodeExporterDown
FilesystemUsageHigh
server-01
```

La búsqueda puede ayudar a encontrar:

- Todas las alertas de CPU.
- Todas las alertas de una instancia.
- Una regla concreta.
- Alertas asociadas a un servicio.
- Reglas de un equipo.

## Convención de nombres

Utilizar nombres consistentes facilita la búsqueda.

Ejemplos:

```text
HighCPUUsage
HighMemoryUsage
HighDiskUsage
HighApplicationLatency
ApplicationErrorRateHigh
NodeExporterDown
```

Evitar nombres genéricos:

```text
Alerta1
Prueba
Regla nueva
Servidor
```

---

# Consultar el detalle de una alerta

Al abrir una alerta, normalmente se puede consultar:

- Nombre.
- Estado.
- Regla de origen.
- Etiquetas.
- Anotaciones.
- Consulta.
- Expresiones.
- Umbral.
- Duración.
- Intervalo de evaluación.
- Fuente de datos.
- Historial de estados.
- Contacto o política relacionada.
- Silenciamientos coincidentes.

## Información que debe comprobarse

Ante una alerta activa, revisar:

```text
¿Qué regla se activó?
¿Qué instancia está afectada?
¿Qué valor se observó?
¿Cuál era el umbral?
Desde cuándo está activa?
¿Qué severidad tiene?
¿Qué equipo es responsable?
Existe un runbook?
Está silenciada?
Se envió una notificación?
```

---

# Historial de estados

El historial permite conocer cómo ha cambiado una alerta.

## Ejemplo

```text
10:00 - Normal
10:05 - Pending
10:10 - Alerting
10:18 - Normal
```

Esta secuencia proporciona información sobre:

- Momento de inicio.
- Tiempo en estado pendiente.
- Duración del problema.
- Momento de recuperación.
- Frecuencia de repetición.

## Interpretación

```text
Normal → Pending
```

La condición comenzó a cumplirse.

```text
Pending → Alerting
```

La condición se mantuvo durante el periodo configurado.

```text
Alerting → Normal
```

La condición dejó de cumplirse.

## Utilidad operativa

El historial ayuda a:

- Investigar incidentes.
- Comprobar el comportamiento de una regla.
- Medir tiempos de respuesta.
- Detectar alertas inestables.
- Identificar falsos positivos.
- Revisar cambios recientes.

---

# Alertas inestables

Una alerta puede cambiar repetidamente entre estados.

Ejemplo:

```text
10:00 - Normal
10:01 - Pending
10:02 - Normal
10:03 - Pending
10:04 - Normal
```

Este comportamiento puede indicar:

- Umbral demasiado sensible.
- Métrica con mucho ruido.
- Duración demasiado corta.
- Fluctuaciones normales.
- Consulta mal diseñada.
- Datos incompletos.

## Análisis recomendado

1. Revisar la serie temporal.
2. Revisar el umbral.
3. Revisar la duración.
4. Revisar la reducción utilizada.
5. Añadir una anotación si existe un evento conocido.
6. Comparar con el comportamiento histórico.
7. Ajustar la regla si genera ruido.

---

# Alertas silenciadas

Una alerta puede estar activa, pero tener sus notificaciones silenciadas.

Esto significa que:

```text
La regla puede seguir evaluándose,
pero la notificación puede no enviarse.
```

## Comprobar un silencio

Revisar:

- Etiquetas coincidentes.
- Fecha de inicio.
- Fecha de finalización.
- Motivo.
- Usuario que creó el silencio.
- Alcance.
- Regla afectada.

## Ejemplo

```text
Alerta: HighCPUUsage
Estado: Alerting
Silencio: Activo
Motivo: Prueba de carga autorizada
Fin: 18:30
```

La alerta debe seguir siendo visible para evitar que el silencio oculte completamente el problema.

---

# Alertas notificadas y no notificadas

El estado de una alerta y el envío de una notificación son conceptos diferentes.

Una alerta puede estar:

```text
Alerting y notificada
Alerting y silenciada
Alerting sin contacto coincidente
Alerting con error de entrega
```

Por eso, al investigar una alerta, no basta con comprobar su estado. También hay que revisar:

- Políticas.
- Contactos.
- Etiquetas.
- Silenciamientos.
- Agrupación.
- Intervalos de repetición.
- Historial de notificaciones.

---

# Ejemplo de lista de alertas

Una vista simplificada podría ser:

```text
Estado      Nombre                 Instancia       Severidad   Equipo
---------------------------------------------------------------------------
Alerting    HighCPUUsage           server-01:9100  warning     systems
Pending     FilesystemUsageHigh    server-02:9100  warning     systems
Normal      HighMemoryUsage        server-01:9100  warning     systems
No data     NodeExporterDown       server-03:9100  critical    systems
Alerting    HighLatency            api-01          critical    application
```

## Interpretación

```text
HighCPUUsage:
Problema activo en server-01.

FilesystemUsageHigh:
La condición se cumple, pero aún no se ha alcanzado la duración.

HighMemoryUsage:
No existe un problema actual.

NodeExporterDown:
No hay datos suficientes para evaluar correctamente.

HighLatency:
Problema crítico en la aplicación api-01.
```

---

# Ejemplo de sesión 1: revisar alertas activas

## Objetivo

Localizar todas las alertas activas y clasificarlas.

## Pasos

1. Acceder a Grafana.
2. Abrir la lista de alertas.
3. Filtrar por estado `Alerting`.
4. Anotar los nombres visibles.
5. Revisar la severidad.
6. Revisar el equipo responsable.
7. Revisar la instancia afectada.
8. Abrir el detalle de cada alerta.
9. Consultar el historial.
10. Registrar los resultados.

## Plantilla de registro

```text
Nombre:

Estado:

Severidad:

Equipo:

Servicio:

Instancia:

Hora de inicio:

Valor actual:

Umbral:

Silenciada:

Notificación enviada:

Acción recomendada:
```

## Resultado esperado

El alumno debe poder identificar qué alertas requieren atención inmediata y cuáles pertenecen a otros equipos.

---

# Ejemplo de sesión 2: filtrar por severidad

## Objetivo

Encontrar únicamente las alertas críticas.

## Etiqueta utilizada

```text
severity = critical
```

## Pasos

1. Abrir la lista de alertas.
2. Aplicar el filtro de severidad.
3. Seleccionar `critical`.
4. Contar las alertas encontradas.
5. Revisar la instancia afectada.
6. Abrir una alerta.
7. Consultar su anotación.
8. Revisar el runbook.
9. Documentar la acción que debe realizarse.

## Registro

```text
Número de alertas críticas:

Alertas activas:

Alertas pendientes:

Alertas sin datos:

Equipos afectados:

Servicios afectados:
```

---

# Ejemplo de sesión 3: investigar una alerta de CPU

## Objetivo

Analizar una alerta activa de uso elevado de CPU.

## Regla de referencia

```text
Nombre: HighCPUUsage
Condición: CPU mayor que 90 %
Duración: 5 minutos
```

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Pasos

1. Filtrar por `HighCPUUsage`.
2. Abrir la instancia activa.
3. Revisar el valor actual.
4. Revisar el momento de activación.
5. Revisar la duración.
6. Consultar el panel de CPU.
7. Consultar la lista de procesos del servidor, si está autorizado.
8. Revisar las anotaciones del dashboard.
9. Consultar el runbook.
10. Registrar la conclusión.

## Preguntas de análisis

```text
¿La CPU sigue elevada?

¿El valor presenta un pico o una tendencia sostenida?

¿Existe una anotación de despliegue o mantenimiento?

¿La alerta está correctamente etiquetada?

¿Se ha enviado la notificación?

¿Existe un silencio activo?

¿La condición afecta a una sola instancia?
```

---

# Ejemplo de sesión 4: investigar una alerta `Pending`

## Objetivo

Comprender por qué una alerta todavía no está activa.

## Configuración

```text
Condición: CPU > 90 %
Duración: 5 minutos
```

## Secuencia

```text
10:00 - CPU = 92 % → Pending
10:01 - CPU = 93 % → Pending
10:02 - CPU = 89 % → Normal
```

## Pasos

1. Localizar la alerta pendiente.
2. Consultar el tiempo transcurrido.
3. Revisar la duración configurada.
4. Consultar la métrica.
5. Comprobar si el valor continúa por encima del umbral.
6. Determinar si la alerta se activará o volverá a normal.
7. Registrar la observación.

## Resultado esperado

El alumno debe comprender que `Pending` no equivale todavía a una alerta activa.

---

# Ejemplo de sesión 5: investigar una alerta `No data`

## Objetivo

Diagnosticar una alerta que no recibe datos.

## Consulta

```promql
up{job="node_exporter"}
```

## Pasos

1. Filtrar las alertas por `No data`.
2. Abrir la alerta.
3. Revisar la fuente de datos.
4. Ejecutar la consulta en Explore.
5. Comprobar si existen series.
6. Revisar el estado del objetivo.
7. Revisar el endpoint de Prometheus.
8. Comprobar los filtros utilizados.
9. Revisar la configuración ante ausencia de datos.
10. Documentar la causa.

## Posibles causas

```text
Node Exporter detenido.
Prometheus no puede acceder al objetivo.
El nombre del job es incorrecto.
La consulta utiliza una etiqueta inexistente.
La fuente de datos no responde.
La serie ha desaparecido.
```

## Registro

```text
Nombre de la alerta:

Fuente de datos:

Consulta:

Resultado en Explore:

Estado del objetivo:

Causa:

Corrección:

Resultado posterior:
```

---

# Ejemplo de sesión 6: revisar alertas por equipo

## Objetivo

Consultar únicamente las alertas asignadas al equipo de sistemas.

## Etiqueta

```text
team = systems
```

## Pasos

1. Abrir la lista de alertas.
2. Aplicar el filtro `team=systems`.
3. Revisar las alertas activas.
4. Revisar las alertas pendientes.
5. Revisar las alertas con errores.
6. Clasificarlas por severidad.
7. Identificar reglas sin runbook.
8. Registrar las mejoras necesarias.

## Tabla de análisis

| Alerta | Estado | Severidad | Servicio | Runbook | Acción |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

---

# Ejemplo de sesión 7: comparar una alerta con sus anotaciones

## Objetivo

Relacionar el estado de una alerta con eventos operativos.

## Escenario

```text
10:00 - Despliegue de una nueva versión
10:03 - Aumento de la latencia
10:05 - Alerta activa
10:12 - Rollback
10:15 - Alerta resuelta
```

## Pasos

1. Abrir la alerta de latencia.
2. Revisar su hora de activación.
3. Abrir el dashboard correspondiente.
4. Revisar las anotaciones.
5. Comparar los tiempos.
6. Consultar el historial.
7. Formular una hipótesis.
8. Documentar qué evidencias la respaldan.

## Conclusión esperada

La lista de alertas muestra el estado actual y el historial de la regla. Las anotaciones aportan contexto sobre los cambios ocurridos en el sistema.

---

# Ejemplo de sesión 8: analizar una alerta repetitiva

## Objetivo

Detectar una regla que genera alertas con demasiada frecuencia.

## Historial

```text
09:00 - Normal
09:05 - Alerting
09:07 - Normal
09:12 - Alerting
09:14 - Normal
09:19 - Alerting
```

## Pasos

1. Abrir el historial de la alerta.
2. Medir la frecuencia de activación.
3. Consultar la métrica.
4. Revisar las anotaciones.
5. Revisar el umbral.
6. Revisar la duración.
7. Evaluar si el problema es real o ruido.
8. Proponer un ajuste.

## Posibles ajustes

```text
Aumentar la duración.
Cambiar el umbral.
Utilizar Mean en lugar de Max.
Modificar la consulta.
Excluir una ventana de mantenimiento.
Revisar la agregación.
```

Los ajustes deben probarse antes de aplicarse en producción.

---

# Ejemplo de sesión 9: revisar alertas silenciadas

## Objetivo

Identificar alertas activas que no están generando notificaciones.

## Pasos

1. Abrir la lista de alertas.
2. Buscar alertas en estado `Alerting`.
3. Revisar cuáles aparecen como silenciadas.
4. Abrir el detalle del silencio.
5. Revisar las etiquetas coincidentes.
6. Revisar el motivo.
7. Revisar la fecha de finalización.
8. Confirmar si el silencio sigue siendo necesario.
9. Documentar silencios que deben eliminarse o modificarse.

## Registro

```text
Alerta:

Estado:

Motivo del silencio:

Creado por:

Inicio:

Finalización:

Etiquetas coincidentes:

¿Sigue siendo necesario?:

Acción:
```

---

# Ejemplo de sesión 10: construir un informe operativo

## Objetivo

Preparar un resumen de las alertas encontradas durante una sesión.

## Resumen

```text
Fecha:

Periodo analizado:

Persona responsable:

Dashboard consultado:

Número total de alertas:

Alertas activas:

Alertas pendientes:

Alertas normales:

Alertas No data:

Alertas con Error:
```

## Detalle de alertas activas

| Nombre | Instancia | Severidad | Inicio | Causa probable | Acción |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

## Conclusiones

```text
Alertas que requieren intervención:

Alertas que requieren ajuste:

Alertas sin runbook:

Silenciamientos que deben revisarse:

Problemas de notificación:

Acciones recomendadas:
```

---

# Buenas prácticas

## Utilizar etiquetas consistentes

Los filtros solo son útiles si las etiquetas siguen una convención común.

## Revisar primero las alertas críticas

Un orden recomendado es:

```text
1. Alerting + critical
2. Alerting + warning
3. Pending
4. No data
5. Error
6. Normal
```

El orden puede adaptarse al procedimiento operativo.

## No ignorar `No data`

Una alerta sin datos puede indicar una pérdida de visibilidad.

## Revisar el detalle, no solo el nombre

El nombre de una alerta no siempre explica:

- Qué métrica falló.
- Qué valor se obtuvo.
- Qué instancia está afectada.
- Qué consulta se utilizó.
- Qué política se aplicó.

## Revisar la antigüedad

Una alerta activa desde hace mucho tiempo puede indicar:

- Un problema no resuelto.
- Una regla mal configurada.
- Un silencio prolongado.
- Una notificación fallida.
- Un procedimiento inexistente.

## Buscar alertas repetitivas

Las alertas que cambian constantemente de estado deben revisarse.

## No resolver alertas sin investigar

Cambiar el estado visual o eliminar una regla no soluciona necesariamente el problema.

## Mantener los nombres claros

Los nombres deben facilitar la búsqueda y la lectura.

## Revisar los silenciamientos

Todo silencio debe tener:

- Motivo.
- Responsable.
- Alcance.
- Fecha de finalización.

## Documentar las acciones

Una alerta investigada debe dejar un registro suficiente para que otra persona comprenda lo ocurrido.

## Mantener los runbooks actualizados

Un enlace roto en una alerta activa retrasa la respuesta.

---

# Errores frecuentes

## No aparecen alertas esperadas

Comprobar:

- Filtros activos.
- Estado seleccionado.
- Etiquetas.
- Rango temporal.
- Permisos.
- Organización o espacio de trabajo.
- Vista seleccionada.

## Aparecen demasiadas alertas

Comprobar:

- Filtros demasiado amplios.
- Reglas duplicadas.
- Alertas por cada instancia.
- Falta de agrupación.
- Nombres inconsistentes.

## No se identifica la instancia

Comprobar:

- Etiqueta `instance`.
- Agregaciones de la consulta.
- Anotaciones de la regla.
- Series multidimensionales.
- Filtros aplicados.

## La alerta está activa, pero no llega el aviso

Comprobar:

- Contacto.
- Política.
- Etiquetas.
- Silenciamiento.
- Agrupación.
- Intervalo de repetición.
- Errores de entrega.

## Una alerta permanece activa mucho tiempo

Comprobar:

- Métrica.
- Umbral.
- Consulta.
- Recuperación.
- Fuente de datos.
- Runbook.
- Silenciamientos.

## Una alerta cambia demasiado rápido

Comprobar:

- Duración.
- Umbral.
- Reducción.
- Ruido de la métrica.
- Intervalo de evaluación.
- Eventos externos.

## Se confunde una regla con una instancia

Una regla puede tener varias instancias. La investigación debe centrarse en la instancia concreta afectada.

## Se elimina una alerta en lugar de solucionar el problema

Eliminar la regla solo elimina la detección. No corrige la causa del problema.

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/lista-alertas
```

Crear una plantilla de revisión:

```bash
cat > ~/laboratorio-grafana/evidencias/lista-alertas/revision.txt <<'EOF'
Fecha:

Periodo revisado:

Persona responsable:

Alertas activas:

Alertas pendientes:

Alertas No data:

Alertas con Error:

Alerta más antigua:

Alerta más crítica:

Alertas silenciadas:

Problemas de notificación:

Acciones recomendadas:

Observaciones:
EOF
```

Crear una plantilla para una alerta concreta:

```bash
cat > ~/laboratorio-grafana/evidencias/lista-alertas/detalle-alerta.txt <<'EOF'
Nombre:

Regla:

Instancia:

Estado:

Severidad:

Equipo:

Servicio:

Entorno:

Hora de inicio:

Última evaluación:

Valor actual:

Umbral:

Consulta:

Duración:

Contacto:

Política:

Silencio:

Runbook:

Causa probable:

Acción realizada:

Resultado:
EOF
```

Capturas recomendadas:

```text
01-lista-general.png
02-filtro-alerting.png
03-filtro-critical.png
04-detalle-alerta-cpu.png
05-historial-estados.png
06-alerta-no-data.png
07-alerta-silenciada.png
08-filtro-por-equipo.png
09-regla-multidimensional.png
10-informe-operativo.png
```

---

# Práctica integradora

## Objetivo

Revisar el estado de un conjunto de alertas y elaborar un informe operativo.

## Requisitos

- Grafana funcionando.
- Varias reglas de alerta creadas.
- Al menos una regla de disponibilidad.
- Al menos una regla de CPU.
- Un conjunto de etiquetas consistente.
- Permisos para consultar alertas.
- Un entorno de laboratorio.

---

## Tarea 1: revisar la vista general

Abrir la lista de alertas y registrar:

```text
Número total de reglas:

Número de alertas normales:

Número de alertas pendientes:

Número de alertas activas:

Número de alertas No data:

Número de alertas con Error:
```

---

## Tarea 2: filtrar alertas activas

Aplicar el filtro:

```text
Estado = Alerting
```

Para cada alerta, registrar:

```text
Nombre:

Instancia:

Severidad:

Equipo:

Servicio:

Hora de inicio:

Valor actual:

Umbral:
```

---

## Tarea 3: revisar alertas pendientes

Aplicar el filtro:

```text
Estado = Pending
```

Determinar:

- Cuánto tiempo llevan pendientes.
- Cuánto falta para alcanzar la duración.
- Si el valor continúa superando el umbral.
- Si existe alguna anotación relacionada.

---

## Tarea 4: investigar una alerta `No data`

Seleccionar una alerta sin datos y comprobar:

1. Consulta.
2. Fuente de datos.
3. Etiquetas.
4. Estado del objetivo.
5. Resultado en Explore.
6. Política de ausencia de datos.
7. Historial de estados.

---

## Tarea 5: revisar las alertas silenciadas

Identificar:

- Alertas silenciadas.
- Motivo de cada silencio.
- Fecha de finalización.
- Alcance.
- Responsable.
- Necesidad de mantenerlo.

---

## Tarea 6: elaborar el informe

Completar:

```text
Fecha:

Periodo:

Número de alertas revisadas:

Alertas críticas:

Alertas de advertencia:

Alertas pendientes:

Alertas sin datos:

Alertas con errores:

Alertas silenciadas:

Problemas encontrados:

Acciones realizadas:

Acciones pendientes:

Conclusiones:
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Lista de alertas consultada | | |
| Alertas activas identificadas | | |
| Alertas pendientes identificadas | | |
| Alertas `No data` identificadas | | |
| Alertas con errores identificadas | | |
| Filtro por severidad probado | | |
| Filtro por equipo probado | | |
| Filtro por servicio probado | | |
| Detalle de una alerta consultado | | |
| Historial de estados consultado | | |
| Instancia afectada identificada | | |
| Silenciamientos revisados | | |
| Contacto revisado | | |
| Política revisada | | |
| Runbook consultado | | |
| Informe operativo completado | | |
| Evidencias guardadas | | |

---

# Puntos clave

- La lista de alertas proporciona una vista centralizada del estado de las reglas.
- Una regla define la condición; una instancia identifica el recurso afectado.
- Una regla puede generar varias instancias.
- `Normal` indica que la condición no se cumple.
- `Pending` indica que la condición se cumple, pero aún no ha transcurrido la duración.
- `Alerting` indica que la condición se ha mantenido durante el periodo configurado.
- `No data` indica que no existen datos suficientes para evaluar.
- `Error` indica que la evaluación no pudo completarse.
- Los filtros permiten reducir la lista y localizar problemas concretos.
- Las etiquetas deben utilizar una convención consistente.
- La severidad ayuda a priorizar la investigación.
- El historial permite reconstruir los cambios de estado.
- Una alerta activa puede estar silenciada.
- El estado de una alerta no garantiza que la notificación haya llegado.
- Una alerta `No data` requiere investigación.
- Las alertas repetitivas pueden indicar ruido o una regla mal ajustada.
- Una alerta antigua puede indicar un problema sin resolver.
- El detalle de una alerta debe revisarse antes de tomar medidas.
- La instancia afectada debe identificarse correctamente.
- Los silenciamientos deben tener un motivo y una fecha de finalización.
- Los runbooks facilitan la respuesta operativa.
- La lista de alertas debe revisarse durante la operación y después de una incidencia.
- El informe de alertas debe registrar acciones y conclusiones.
- Eliminar una regla no soluciona el problema que detectaba.
- Una lista de alertas útil debe permitir priorizar, investigar y actuar.

---

# Preguntas de comprobación

1. ¿Para qué sirve la lista de alertas?
2. ¿Qué diferencia existe entre una regla y una instancia de alerta?
3. ¿Puede una regla generar varias instancias?
4. ¿Qué significa el estado `Normal`?
5. ¿Qué significa el estado `Pending`?
6. ¿Qué diferencia existe entre `Pending` y `Alerting`?
7. ¿Qué significa el estado `No data`?
8. ¿Qué puede provocar un estado `Error`?
9. ¿Qué filtros utilizarías para localizar alertas críticas?
10. ¿Cómo filtrarías las alertas de un equipo concreto?
11. ¿Por qué son importantes las etiquetas?
12. ¿Qué información revisarías en el detalle de una alerta?
13. ¿Qué información proporciona el historial de estados?
14. ¿Qué diferencia existe entre una alerta activa y una alerta notificada?
15. ¿Cómo comprobarías si una alerta está silenciada?
16. ¿Qué revisarías si una alerta activa no genera notificaciones?
17. ¿Qué revisarías si una alerta aparece como `No data`?
18. ¿Qué puede indicar una alerta que cambia repetidamente entre `Normal` y `Alerting`?
19. ¿Por qué una alerta activa durante mucho tiempo debe investigarse?
20. ¿Qué información incluirías en un informe operativo?
21. ¿Qué función cumple un runbook?
22. ¿Por qué no debe eliminarse una regla solo porque genere ruido?
23. ¿Cómo identificarías la instancia afectada por una alerta?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener una lista de alertas útil para un equipo de operaciones?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de consultar y analizar la lista de alertas de Grafana.

El flujo final será:

```text
Abrir la lista de alertas
        |
        v
Revisar el estado general
        |
        v
Filtrar por estado
        |
        v
Filtrar por severidad y equipo
        |
        v
Identificar la instancia afectada
        |
        v
Abrir el detalle de la alerta
        |
        v
Revisar consulta y umbral
        |
        v
Consultar el historial
        |
        v
Revisar silenciamientos
        |
        v
Comprobar la notificación
        |
        v
Investigar la causa
        |
        v
Registrar la acción
        |
        v
Documentar el resultado
```

Una revisión de alertas está correctamente realizada cuando:

- Se han identificado las alertas activas.
- Se han priorizado por severidad.
- Se ha localizado la instancia afectada.
- Se ha consultado el detalle de la regla.
- Se ha revisado el historial.
- Se han comprobado los silenciamientos.
- Se ha verificado el estado de las notificaciones.
- Se han documentado las acciones.
- Se ha elaborado un informe comprensible.

La lista de alertas no es solo un inventario. Es una herramienta operativa para transformar muchos estados técnicos en una visión clara de los problemas que requieren atención.