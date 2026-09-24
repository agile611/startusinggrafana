# Práctica 5 - Alertas

Esta práctica introduce la creación y validación de reglas de alerta en Grafana utilizando métricas recopiladas por Prometheus y Node Exporter.

El alumno aprenderá a detectar problemas de disponibilidad, CPU, memoria y almacenamiento. También comprobará los estados de una alerta, configurará etiquetas y anotaciones, probará notificaciones y verificará la recuperación de las condiciones anómalas.

Todas las pruebas deben realizarse únicamente en un entorno de laboratorio autorizado. No se deben detener servicios ni generar carga sobre sistemas de producción.

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar la finalidad de una regla de alerta.
- Diferenciar una métrica de una condición de alerta.
- Crear reglas de alerta en Grafana.
- Utilizar consultas PromQL como base de una alerta.
- Configurar condiciones y umbrales.
- Configurar intervalos de evaluación.
- Configurar periodos de duración.
- Comprender los estados `Normal`, `Pending` y `Alerting`.
- Definir el comportamiento ante ausencia de datos.
- Definir el comportamiento ante errores de consulta.
- Añadir etiquetas a las alertas.
- Añadir anotaciones descriptivas.
- Crear una alerta de disponibilidad.
- Crear una alerta de CPU.
- Crear una alerta de memoria.
- Crear una alerta de almacenamiento.
- Validar las reglas antes de activarlas.
- Probar alertas en un entorno controlado.
- Comprobar la recuperación de una alerta.
- Diagnosticar alertas que no se activan.
- Diagnosticar alertas que no generan notificaciones.
- Documentar las reglas y las pruebas realizadas.

## Introducción

Una alerta permite detectar automáticamente una condición que requiere atención.

Un dashboard ayuda a observar los datos, pero exige que una persona revise la información. Una alerta, en cambio, evalúa una condición y puede avisar cuando se produce un problema.

El flujo general es:

```text
Métrica
    |
    v
Consulta PromQL
    |
    v
Condición
    |
    v
Periodo de evaluación
    |
    v
Regla de alerta
    |
    v
Notificación
    |
    v
Investigación y recuperación
```

Una alerta bien diseñada debe responder a estas preguntas:

```text
¿Qué problema se ha detectado?

¿En qué servidor ocurre?

¿Qué recurso está afectado?

¿Qué equipo debe actuar?

¿Cuándo comenzó?

¿Cuánto tiempo lleva activo?

¿Qué acción se recomienda?

¿Cuándo se ha recuperado?
```

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Grafana operativo.
- Prometheus configurado como fuente de datos.
- Node Exporter disponible.
- Consultas PromQL validadas.
- Dashboard operativo creado.
- Permisos para crear reglas de alerta.
- Permisos para consultar el historial de alertas.
- Un entorno de laboratorio autorizado.
- Un contacto de notificación de pruebas, si está disponible.
- Un directorio para guardar evidencias.

Registrar:

```text
Alumno:

Grupo:

Fecha:

URL de Grafana:

URL de Prometheus:

Fuente de datos:

Dashboard operativo:

Instancia de laboratorio:

Entorno:

Contacto de pruebas:
```

El entorno debe identificarse mediante:

```text
environment = laboratory
```

## Conceptos fundamentales

### Regla de alerta

Una regla de alerta está formada por varios elementos:

```text
Consulta
Condición
Reducción
Umbral
Intervalo de evaluación
Duración
Etiquetas
Anotaciones
Comportamiento ante errores
```

Ejemplo conceptual:

```text
Si la CPU supera el 90 %
durante cinco minutos,
crear una alerta de severidad warning
para el equipo de sistemas.
```

### Consulta

La consulta obtiene los datos de Prometheus.

Ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Condición

La condición compara el resultado de la consulta con un umbral.

Ejemplo:

```text
Mayor que 90
```

### Reducción

La reducción transforma una serie temporal en un valor que pueda compararse.

Ejemplos:

```text
Last
Mean
Min
Max
```

Para una alerta de disponibilidad suele utilizarse:

```text
Last
```

### Umbral

El umbral determina cuándo se considera que existe un problema.

Ejemplos:

```text
CPU > 90
Memoria > 90
Almacenamiento > 80
up == 0
```

### Intervalo de evaluación

Indica cada cuánto tiempo se evalúa la regla.

Ejemplos:

```text
30 segundos
1 minuto
5 minutos
```

### Duración

Indica cuánto tiempo debe mantenerse la condición antes de activar la alerta.

Ejemplos:

```text
1 minuto
5 minutos
10 minutos
```

La duración evita alertas provocadas por cambios breves.

## Estados de una alerta

### Normal

La condición no se cumple.

Ejemplo:

```text
CPU = 42 %
Umbral = 90 %
Estado = Normal
```

### Pending

La condición se cumple, pero todavía no ha transcurrido el periodo de duración configurado.

Ejemplo:

```text
CPU = 94 %
Duración configurada = 5 minutos
Tiempo transcurrido = 2 minutos
Estado = Pending
```

### Alerting

La condición se ha mantenido durante el tiempo configurado.

Ejemplo:

```text
CPU = 94 %
Duración configurada = 5 minutos
Tiempo transcurrido = 5 minutos
Estado = Alerting
```

### Recovering o Normal posterior

La condición deja de cumplirse y la alerta vuelve a un estado normal.

Ejemplo:

```text
CPU = 45 %
Umbral = 90 %
Estado = Normal
```

### Diagrama de estados

```text
Normal
   |
   | La condición se cumple
   v
Pending
   |
   | Transcurre la duración
   v
Alerting
   |
   | La condición deja de cumplirse
   v
Normal
```

## Etiquetas y anotaciones

### Etiquetas

Las etiquetas clasifican la alerta y permiten seleccionar una política de notificación.

Etiquetas recomendadas:

```text
alertname
severity
team
service
environment
resource
```

Ejemplo:

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

### Anotaciones

Las anotaciones describen el problema y ayudan a investigar.

Ejemplo:

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

### Diferencia entre etiquetas y anotaciones

| Elemento | Finalidad | Ejemplo |
|---|---|---|
| Etiqueta | Clasificar y enrutar | `severity=warning` |
| Anotación | Explicar el incidente | `summary=CPU elevada` |

## Reglas de seguridad

Las pruebas deben ejecutarse únicamente en máquinas de laboratorio.

No se debe:

```text
Detener servicios de producción.
Generar carga sobre sistemas reales.
Enviar notificaciones a contactos no autorizados.
Modificar reglas críticas.
Eliminar archivos para provocar una alerta.
Cambiar firewalls sin autorización.
Compartir credenciales.
```

Las pruebas de disponibilidad deben incluir:

```text
Autorización
Anotación
Hora de inicio
Hora de recuperación
Evidencia
Limpieza final
```

## Preparación del directorio de evidencias

Crear los directorios:

```bash
mkdir -p ~/proyecto-final-grafana/evidencias/alertas
mkdir -p ~/proyecto-final-grafana/evidencias/notificaciones
mkdir -p ~/proyecto-final-grafana/evidencias/recuperaciones
mkdir -p ~/proyecto-final-grafana/informe
```

Crear un registro:

```bash
cat > ~/proyecto-final-grafana/evidencias/alertas/registro-practica-5.txt <<'EOF'
Alumno:

Grupo:

Fecha:

Entorno:

Reglas creadas:

Contactos:

Políticas:

Pruebas de activación:

Pruebas de recuperación:

Problemas:

Resultado final:
EOF
```

## Sesión 1: revisar las alertas antes de crearlas

### Objetivo

Planificar las reglas antes de configurarlas en Grafana.

### Actividad

Completar la siguiente tabla:

| Regla | Métrica | Umbral | Duración | Severidad | Equipo |
|---|---|---:|---|---|---|
| NodeExporterDown | | | | | |
| HighCPUUsage | | | | | |
| HighMemoryUsage | | | | | |
| FilesystemUsageHigh | | | | | |

### Propuesta de referencia

```text
NodeExporterDown:
up == 0 durante 1 minuto

HighCPUUsage:
CPU > 90 % durante 5 minutos

HighMemoryUsage:
Memoria > 90 % durante 5 minutos

FilesystemUsageHigh:
Almacenamiento > 80 % durante 10 minutos
```

### Preguntas

```text
¿Qué alerta debe ser crítica?

¿Qué alertas pueden ser warning?

¿Qué alertas podrían generar ruido?

¿Qué duración debe tener cada regla?

¿Qué equipo debe recibir cada alerta?
```

### Registro

```text
Regla:

Problema detectado:

Consulta:

Umbral:

Duración:

Severidad:

Equipo:

Acción esperada:
```

## Sesión 2: validar las consultas de las alertas

### Objetivo

Comprobar que cada consulta devuelve datos antes de crear la regla.

### Disponibilidad

```promql
up{job="node_exporter"}
```

### CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento

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

### Registro

```text
Regla:

Consulta:

¿Devuelve datos?:

Número de series:

Etiquetas:

Valor actual:

Unidad:

Resultado:
```

### Resultado esperado

Todas las consultas deben estar validadas antes de utilizarse en una regla.

## Sesión 3: crear la alerta de disponibilidad

### Objetivo

Detectar que Node Exporter deja de responder.

### Nombre

```text
NodeExporterDown-Laboratory
```

### Consulta

```promql
up{job="node_exporter"}
```

### Configuración recomendada

```text
Reducción:
Last

Condición:
Igual a 0

Intervalo de evaluación:
30 segundos

Duración:
1 minuto
```

### Etiquetas

```text
alertname = NodeExporterDown-Laboratory
severity = critical
team = systems
service = node_exporter
environment = laboratory
resource = availability
```

### Anotaciones

```text
summary = Node Exporter no disponible en {{ $labels.instance }}

description = El objetivo {{ $labels.instance }}
no responde a Prometheus en el entorno de laboratorio.

runbook_url = https://example.com/runbooks/node-exporter-down
```

### Procedimiento

1. Acceder a la sección de alertas.
2. Crear una nueva regla.
3. Introducir el nombre.
4. Seleccionar Prometheus.
5. Introducir la consulta.
6. Configurar la reducción `Last`.
7. Configurar la condición `Equal to 0`.
8. Configurar el intervalo.
9. Configurar la duración.
10. Añadir las etiquetas.
11. Añadir las anotaciones.
12. Guardar la regla.
13. Confirmar el estado inicial.

### Registro

```text
Nombre:

Consulta:

Reducción:

Condición:

Intervalo:

Duración:

Etiquetas:

Anotaciones:

Estado inicial:

Resultado:
```

## Sesión 4: crear la alerta de CPU

### Objetivo

Detectar un uso de CPU elevado y sostenido.

### Nombre

```text
HighCPUUsage-Laboratory
```

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Configuración recomendada

```text
Reducción:
Last

Condición:
Mayor que 90

Intervalo de evaluación:
1 minuto

Duración:
5 minutos
```

### Etiquetas

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

### Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

### Justificación

La duración de cinco minutos evita generar una alerta por un pico breve que desaparece rápidamente.

### Registro

```text
Nombre:

Consulta:

Umbral:

Intervalo:

Duración:

Etiquetas:

Anotaciones:

Justificación de la duración:

Estado inicial:
```

## Sesión 5: crear la alerta de memoria

### Objetivo

Detectar un uso elevado de memoria.

### Nombre

```text
HighMemoryUsage-Laboratory
```

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Configuración recomendada

```text
Reducción:
Last

Condición:
Mayor que 90

Intervalo de evaluación:
1 minuto

Duración:
5 minutos
```

### Etiquetas

```text
alertname = HighMemoryUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = memory
```

### Anotaciones

```text
summary = Memoria elevada en {{ $labels.instance }}

description = La memoria utilizada en {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-memory
```

### Registro

```text
Nombre:

Consulta:

Umbral:

Intervalo:

Duración:

Etiquetas:

Anotaciones:

Estado inicial:

Resultado:
```

## Sesión 6: crear la alerta de almacenamiento

### Objetivo

Detectar una ocupación elevada del sistema de ficheros raíz.

### Nombre

```text
FilesystemUsageHigh-Laboratory
```

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

### Configuración recomendada

```text
Reducción:
Last

Condición:
Mayor que 80

Intervalo de evaluación:
5 minutos

Duración:
10 minutos
```

### Etiquetas

```text
alertname = FilesystemUsageHigh-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = filesystem
mountpoint = /
```

### Anotaciones

```text
summary = Almacenamiento elevado en {{ $labels.instance }}

description = El sistema de ficheros raíz de
{{ $labels.instance }} supera el 80 % de utilización.

runbook_url = https://example.com/runbooks/filesystem-full
```

### Registro

```text
Nombre:

Consulta:

Punto de montaje:

Umbral:

Intervalo:

Duración:

Etiquetas:

Anotaciones:

Estado inicial:

Resultado:
```

## Sesión 7: revisar el comportamiento ante ausencia de datos

### Objetivo

Definir qué debe ocurrir si una consulta no devuelve datos.

### Situaciones posibles

```text
No data:
La consulta no devuelve ninguna serie.

Error:
La consulta no puede ejecutarse.

Normal:
La condición no se cumple.

Alerting:
La condición se cumple.
```

### Actividad

Para cada regla, revisar las opciones de:

```text
No data
Error
Missing series
```

La configuración exacta depende de la versión de Grafana.

### Recomendación para la práctica

Documentar explícitamente el comportamiento elegido:

```text
Si no hay datos:

Si existe un error de consulta:

Si desaparece una serie:

Motivo:
```

### Preguntas

```text
¿La ausencia de datos debe considerarse un problema?

¿Puede confundirse No data con un valor cero?

¿Qué diferencia existe entre target DOWN y consulta sin datos?

¿Qué comportamiento sería más seguro para una alerta de disponibilidad?
```

## Sesión 8: revisar las etiquetas y anotaciones

### Objetivo

Comprobar que las alertas contienen información útil.

### Actividad

Revisar cada regla y comprobar que incluye:

```text
alertname
severity
team
service
environment
resource
summary
description
```

### Tabla de revisión

| Regla | `alertname` | `severity` | `team` | `environment` | `resource` |
|---|---|---|---|---|---|
| NodeExporterDown | | | | | |
| HighCPUUsage | | | | | |
| HighMemoryUsage | | | | | |
| FilesystemUsageHigh | | | | | |

### Registro de anotaciones

```text
Regla:

Summary:

Description:

Instancia incluida:

Runbook:

Resultado:
```

### Criterio

Una persona que reciba la alerta debe poder identificar el problema sin abrir inmediatamente la consulta original.

## Sesión 9: crear una alerta de prueba

### Objetivo

Aprender el ciclo de estados sin tener que provocar un problema real.

### Consulta de ejemplo

```promql
vector(1)
```

Esta consulta devuelve siempre el valor `1`.

Configurar una condición:

```text
Valor igual a 1
```

Utilizar una duración breve solo para la práctica:

```text
10 segundos
```

Nombre:

```text
TestAlert-Laboratory
```

Etiquetas:

```text
alertname = TestAlert-Laboratory
severity = info
team = training
service = grafana
environment = laboratory
resource = test
```

### Actividad

1. Crear la regla.
2. Observar el estado `Normal`.
3. Esperar la evaluación.
4. Observar `Pending`.
5. Esperar la duración.
6. Observar `Alerting`.
7. Desactivar o eliminar la regla de prueba.
8. Registrar la transición.

### Registro

```text
Hora en Normal:

Hora en Pending:

Hora en Alerting:

Duración configurada:

Hora de eliminación o desactivación:

Resultado:
```

### Limpieza

La regla de prueba debe eliminarse o dejarse desactivada según las instrucciones del instructor.

## Sesión 10: probar la alerta de disponibilidad

### Objetivo

Comprobar la activación y recuperación de `NodeExporterDown-Laboratory`.

Esta tarea debe realizarse únicamente sobre una máquina de laboratorio.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba NodeExporterDown

Descripción:
Se detendrá temporalmente Node Exporter
para comprobar la activación y recuperación de la alerta.

Referencia:
LAB-ALERT-001
```

Comprobar el estado inicial:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Observar los estados

```text
Normal
   |
   v
Pending
   |
   v
Alerting
```

Consultar:

```promql
up{job="node_exporter"}
```

Resultado esperado durante la interrupción:

```text
0
```

### Registro de activación

```text
Hora de detención:

Valor inicial de up:

Hora de Pending:

Hora de Alerting:

Instancia afectada:

Notificación recibida:

Contacto utilizado:
```

### Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

Consultar:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

### Registro de recuperación

```text
Hora de recuperación:

Hora de Normal:

Notificación de recuperación:

Duración total:

Resultado:
```

## Sesión 11: probar la alerta de CPU

### Objetivo

Comprobar el efecto de una condición sostenida de CPU.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba de CPU

Descripción:
Se ejecutará una prueba de carga autorizada
para validar HighCPUUsage-Laboratory.
```

Consultar el valor inicial:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Generar carga

Solo si el entorno lo permite y el instructor lo autoriza:

```bash
stress-ng --cpu 1 --timeout 60s
```

La regla está configurada con:

```text
Umbral:
90 %

Duración:
5 minutos
```

Una prueba de 60 segundos puede no activar la alerta. Esto permite demostrar que la duración evita notificaciones por picos breves.

### Observar

```text
Valor de CPU:

Duración por encima del umbral:

Estado:

Notificación:

Resultado:
```

### Registro

```text
Valor inicial:

Valor máximo:

Hora de inicio de carga:

Hora de finalización:

Tiempo por encima del umbral:

Estado alcanzado:

Resultado esperado:

Resultado observado:
```

## Sesión 12: probar la alerta de memoria

### Objetivo

Comprobar el comportamiento de una alerta de memoria sin poner en riesgo el servidor.

### Preparación

Consultar:

```promql
node_memory_MemTotal_bytes
```

```promql
node_memory_MemAvailable_bytes
```

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Registrar:

```text
Memoria total:

Memoria disponible:

Porcentaje utilizado:

Umbral:

Resultado:
```

### Prueba controlada

Solo se podrá generar carga de memoria si:

- El instructor lo autoriza.
- La máquina pertenece al laboratorio.
- Existe una forma segura de detener la carga.
- Se conoce la memoria disponible.
- No se pone en riesgo el sistema.

No se debe consumir toda la memoria del servidor.

### Alternativa sin carga

Si no es seguro activar la alerta:

```text
Validar la consulta.
Validar la condición.
Documentar el procedimiento de activación.
Explicar cómo se comprobaría la recuperación.
```

## Sesión 13: probar la alerta de almacenamiento

### Objetivo

Comprobar la configuración de la alerta de almacenamiento sin eliminar archivos importantes.

### Consultar el valor actual

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

### Registro inicial

```text
Punto de montaje:

Valor actual:

Umbral:

Duración:

Estado:
```

### Prueba recomendada

En lugar de llenar el sistema de ficheros real, se puede:

- Utilizar una máquina virtual desechable.
- Utilizar un volumen de laboratorio.
- Utilizar una métrica de prueba autorizada.
- Documentar la activación de forma teórica.
- Validar la consulta sin forzar la condición.

No se deben eliminar archivos críticos ni llenar un sistema de producción.

## Sesión 14: observar el ciclo de recuperación

### Objetivo

Verificar que una alerta vuelve a estado normal cuando desaparece la condición.

### Actividad

Para cada alerta probada, completar:

| Alerta | Estado inicial | Estado de activación | Estado final | Notificación de recuperación |
|---|---|---|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

### Preguntas

```text
¿La recuperación fue automática?

¿Cuánto tiempo tardó?

¿Se recibió una notificación?

¿La notificación identificaba la instancia?

¿El dashboard reflejó el cambio?
```

### Registro

```text
Regla:

Condición inicial:

Condición que provocó la alerta:

Hora de activación:

Hora de recuperación:

Duración:

Resultado:
```

## Sesión 15: configurar un contacto de notificación

### Objetivo

Crear un destino de laboratorio para recibir alertas.

### Nombre recomendado

```text
laboratory-observability
```

### Tipos posibles

```text
Correo de formación
Webhook de pruebas
Canal colaborativo autorizado
Sistema ITSM de laboratorio
```

### Datos del contacto

```text
Nombre:

Tipo:

Destino:

Entorno:

Finalidad:

Responsable:

Fecha de creación:
```

No incluir tokens ni secretos en las evidencias.

### Probar el contacto

1. Crear el contacto.
2. Guardar la configuración.
3. Ejecutar una prueba.
4. Comprobar la recepción.
5. Registrar la hora.
6. Guardar una evidencia sin secretos.

### Registro

```text
Contacto:

Prueba realizada:

Hora de envío:

Hora de recepción:

Resultado:

Observaciones:
```

## Sesión 16: crear una política de notificación

### Objetivo

Enviar las alertas del entorno de laboratorio al contacto correcto.

### Coincidencia

```text
environment = laboratory
```

### Contacto

```text
laboratory-observability
```

### Agrupación

```text
group_by:
- alertname
- instance
```

### Temporización de laboratorio

```text
group_wait:
10 segundos

group_interval:
1 minuto

repeat_interval:
5 minutos
```

### Registro

```text
Coincidencia:

Contacto:

Agrupación:

group_wait:

group_interval:

repeat_interval:

Resultado:
```

### Preguntas

```text
¿Qué ocurriría si una alerta no coincide con esta política?

¿Qué diferencia existe entre group_wait y repeat_interval?

¿Por qué no conviene utilizar notificaciones demasiado frecuentes?

¿Qué contacto debería recibir una alerta crítica?
```

## Sesión 17: asociar alertas con políticas

### Objetivo

Comprobar que las etiquetas permiten enrutar correctamente las alertas.

### Regla de prueba

Utilizar:

```text
environment = laboratory
severity = warning
```

Comprobar que coincide con la política de advertencias.

Para una alerta crítica:

```text
environment = laboratory
severity = critical
```

Comprobar que se dirige al contacto correspondiente.

### Registro

```text
Alerta:

Etiquetas:

Política coincidente:

Contacto seleccionado:

Resultado:
```

## Sesión 18: comprobar una alerta silenciada

### Objetivo

Verificar que una alerta puede evaluarse sin enviar notificaciones durante un mantenimiento.

### Crear el silencio

Coincidencias:

```text
alertname = NodeExporterDown-Laboratory
instance = server-01:9100
environment = laboratory
```

Configuración:

```text
Inicio:
Hora actual

Fin:
20 minutos después

Comentario:
Mantenimiento autorizado de Node Exporter en laboratorio.
Referencia: LAB-SILENCE-001.
```

### Procedimiento

1. Crear una anotación de mantenimiento.
2. Crear el silencio.
3. Confirmar que está activo.
4. Detener Node Exporter.
5. Comprobar que la alerta se evalúa.
6. Comprobar que la alerta aparece en Grafana.
7. Confirmar que no se envía notificación.
8. Iniciar Node Exporter.
9. Comprobar la recuperación.
10. Revisar el estado final del silencio.

### Registro

```text
Silencio:

Coincidencias:

Inicio:

Fin:

Alerta afectada:

Estado de la alerta:

Notificación suprimida:

Recuperación:

Resultado:
```

## Sesión 19: diagnosticar una alerta que no se activa

### Situación

```text
El dashboard muestra un valor alto,
pero la alerta permanece en Normal.
```

### Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar el valor actual.
3. Revisar el umbral.
4. Revisar la reducción.
5. Revisar la duración.
6. Revisar el intervalo de evaluación.
7. Comprobar si la regla está pausada.
8. Revisar la fuente de datos.
9. Comprobar las etiquetas.
10. Revisar los logs si existe un error.
11. Registrar la causa.

### Posibles causas

```text
El valor no supera realmente el umbral.
La condición no ha durado suficiente tiempo.
La regla está pausada.
La consulta devuelve una instancia diferente.
La reducción no es la esperada.
La regla utiliza otra fuente de datos.
La consulta no devuelve datos.
La unidad o el umbral son incorrectos.
```

### Registro

```text
Regla:

Consulta:

Valor observado:

Umbral:

Reducción:

Duración:

Estado:

Causa:

Corrección:

Resultado:
```

## Sesión 20: diagnosticar una alerta que permanece en Pending

### Situación

```text
La alerta está en Pending durante mucho tiempo.
```

### Comprobar

```text
¿La condición sigue cumpliéndose?

¿Cuál es la duración configurada?

¿El intervalo de evaluación funciona?

¿La consulta cambia entre evaluaciones?

¿La serie desaparece temporalmente?

¿Existe un reinicio de la regla?

¿La hora del sistema es correcta?
```

### Posibles causas

```text
La condición deja de cumplirse antes de completar la duración.
El valor fluctúa alrededor del umbral.
La duración es demasiado larga.
La regla se reinicia o se edita.
La consulta devuelve valores intermitentes.
```

### Registro

```text
Regla:

Hora de entrada en Pending:

Duración configurada:

Valor mínimo durante Pending:

Valor máximo durante Pending:

Causa:

Resultado:
```

## Sesión 21: diagnosticar una alerta sin notificación

### Situación

```text
La alerta está en Alerting,
pero el contacto no recibe el mensaje.
```

### Comprobaciones

Revisar:

- Etiquetas de la alerta.
- Política de notificación.
- Contacto seleccionado.
- Prueba independiente del contacto.
- Silenciamientos activos.
- Agrupación.
- Intervalo de repetición.
- Estado del receptor externo.
- Logs de Grafana.

### Registro

```text
Alerta:

Estado:

Etiquetas:

Política esperada:

Política utilizada:

Contacto esperado:

Contacto utilizado:

Silencio activo:

Error:

Corrección:

Resultado:
```

## Sesión 22: diagnosticar una alerta demasiado ruidosa

### Situación

```text
La alerta se activa y recupera continuamente.
```

### Posibles causas

```text
El umbral está demasiado cerca del valor normal.
La duración es demasiado corta.
La métrica fluctúa alrededor del umbral.
La consulta no está suficientemente agregada.
El intervalo de evaluación es demasiado corto.
Existe un comportamiento normal que no se ha considerado.
```

### Actividad

Analizar:

```text
Valor mínimo:

Valor máximo:

Frecuencia de activaciones:

Duración media:

Umbral actual:

Duración actual:

Propuesta de mejora:
```

### Posibles mejoras

```text
Aumentar la duración.
Ajustar el umbral.
Utilizar una media temporal.
Filtrar una instancia concreta.
Revisar el intervalo de evaluación.
Añadir contexto operativo.
```

## Sesión 23: diagnosticar una alerta que no se recupera

### Situación

```text
La condición parece normal,
pero la alerta continúa activa.
```

### Comprobar

```text
¿La consulta sigue devolviendo un valor alto?

¿La serie correcta se está evaluando?

¿Existe otra instancia afectada?

¿La reducción utiliza el valor esperado?

¿La fuente de datos está actualizada?

¿La alerta está mostrando un estado antiguo?

¿Existe un error de recuperación?
```

### Registro

```text
Regla:

Valor actual:

Instancia:

Valor esperado:

Estado observado:

Causa:

Corrección:

Resultado:
```

## Sesión 24: revisar el comportamiento ante errores

### Objetivo

Documentar cómo se comporta una regla cuando Prometheus no responde o la consulta falla.

### Situaciones

```text
Prometheus no disponible.
Fuente de datos inaccesible.
Consulta inválida.
Métrica inexistente.
Serie ausente.
Timeout.
```

### Actividad

No es necesario provocar un error real si el entorno no lo permite.

Documentar:

```text
Situación:

Comportamiento configurado:

Riesgo:

Comportamiento recomendado:

Justificación:
```

### Ejemplo

```text
Situación:
La consulta no devuelve datos.

Comportamiento configurado:
No data.

Riesgo:
Puede ocultar una caída del target.

Comportamiento recomendado:
Revisar la diferencia entre ausencia de datos y valor cero.

Justificación:
La disponibilidad debe investigarse de forma separada.
```

## Sesión 25: revisar nombres y convenciones

### Objetivo

Aplicar nombres consistentes a las reglas.

### Convención recomendada

```text
<Problema>-<Entorno>
```

Ejemplos:

```text
NodeExporterDown-Laboratory
HighCPUUsage-Laboratory
HighMemoryUsage-Laboratory
FilesystemUsageHigh-Laboratory
```

### Actividad

Revisar:

```text
¿El nombre identifica el problema?

¿Incluye el entorno?

¿Es fácil de buscar?

¿Evita espacios innecesarios?

¿Es consistente con las demás reglas?
```

### Registro

```text
Nombre original:

Nombre revisado:

Motivo del cambio:

Resultado:
```

## Sesión 26: crear un registro de pruebas

### Objetivo

Documentar el comportamiento de cada regla.

### Tabla de pruebas

| Regla | Estado inicial | Condición aplicada | Estado final | Recuperación |
|---|---|---|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

### Registro detallado

```text
Regla:

Fecha:

Hora de inicio:

Condición aplicada:

Valor inicial:

Valor durante la prueba:

Estado Pending:

Estado Alerting:

Hora de notificación:

Hora de recuperación:

Resultado:
```

## Sesión 27: preparar evidencias

### Objetivo

Guardar pruebas claras de la configuración y el funcionamiento.

### Capturas recomendadas

```text
01-reglas-listadas.png
02-regla-disponibilidad.png
03-regla-cpu.png
04-regla-memoria.png
05-regla-almacenamiento.png
06-etiquetas.png
07-anotaciones.png
08-contacto.png
09-politica.png
10-alerta-normal.png
11-alerta-pending.png
12-alerta-alerting.png
13-notificacion-recibida.png
14-alerta-recuperada.png
15-silencio-activo.png
16-dashboard-con-alerta.png
```

### Revisión de seguridad

Antes de entregar:

- Ocultar contraseñas.
- Ocultar tokens.
- Ocultar claves API.
- Ocultar direcciones privadas innecesarias.
- Ocultar información personal.
- Confirmar que las pruebas pertenecen al laboratorio.
- No incluir configuraciones de contactos reales.

## Sesión 28: completar el informe

### Objetivo

Documentar las reglas, las pruebas y los resultados.

### Plantilla

```markdown
# Informe - Práctica 5

## Identificación

Alumno:

Grupo:

Fecha:

Entorno:

## Objetivo

Crear y probar reglas de alerta para disponibilidad,
CPU, memoria y almacenamiento.

## Reglas creadas

### NodeExporterDown-Laboratory

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

### HighCPUUsage-Laboratory

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

### HighMemoryUsage-Laboratory

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

### FilesystemUsageHigh-Laboratory

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

## Notificaciones

Contacto:

Política:

Resultado de la prueba:

## Pruebas

### Activación

Regla:

Condición:

Estado Normal:

Estado Pending:

Estado Alerting:

Notificación:

### Recuperación

Hora:

Estado final:

Notificación de recuperación:

## Silenciamientos

Coincidencias:

Motivo:

Duración:

Resultado:

## Diagnóstico

Problemas encontrados:

Causas:

Correcciones:

## Evidencias

Listado de capturas y ficheros.

## Conclusiones

Valoración de las reglas y mejoras propuestas.
```

## Ejemplo de regla completa

### Nombre

```text
HighCPUUsage-Laboratory
```

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Condición

```text
Último valor mayor que 90
```

### Evaluación

```text
Intervalo:
1 minuto

Duración:
5 minutos
```

### Etiquetas

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

### Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

### Interpretación

```text
Si la CPU supera el 90 % durante cinco minutos,
la regla pasa de Pending a Alerting.
La alerta se asigna al equipo systems y utiliza
el contacto configurado para el entorno laboratory.
```

## Errores frecuentes

### Crear una alerta con una consulta no validada

Problema:

```text
La regla se crea, pero no devuelve series.
```

Solución:

```text
Ejecutar primero la consulta en Explore.
Comprobar las etiquetas.
Comprobar el rango temporal.
Comprobar la fuente de datos.
```

### Confundir umbral visual y condición de alerta

Problema:

```text
El panel cambia a rojo,
pero no existe ninguna alerta.
```

Solución:

```text
Configurar una regla de alerta independiente.
```

Los umbrales de un panel sirven para visualización. No siempre crean una regla de alerta.

### Utilizar una duración demasiado corta

Problema:

```text
La alerta se activa por picos breves.
```

Solución:

```text
Aumentar la duración.
Utilizar una consulta más estable.
Revisar el umbral.
```

### Utilizar una duración demasiado larga

Problema:

```text
El problema se detecta tarde.
```

Solución:

```text
Reducir la duración.
Revisar la criticidad del recurso.
Ajustar el intervalo de evaluación.
```

### No incluir la instancia en las anotaciones

Problema:

```text
La notificación indica que hay CPU elevada,
pero no identifica el servidor.
```

Solución:

```text
Utilizar {{ $labels.instance }}.
```

### Utilizar etiquetas inconsistentes

Problema:

```text
La alerta no coincide con la política.
```

Ejemplo incorrecto:

```text
env = lab
```

si la política espera:

```text
environment = laboratory
```

Solución:

```text
Utilizar nombres y valores coherentes.
```

### No distinguir `No data` de valor cero

Problema:

```text
Una consulta sin datos se interpreta como que el recurso está al 0 %.
```

Solución:

```text
Revisar la configuración de ausencia de datos.
Utilizar una alerta específica de disponibilidad.
Documentar el comportamiento.
```

## Criterios de aceptación

La práctica se considera completada cuando:

- Se han validado las consultas.
- Se ha creado una alerta de disponibilidad.
- Se ha creado una alerta de CPU.
- Se ha creado una alerta de memoria.
- Se ha creado una alerta de almacenamiento.
- Las reglas tienen nombres coherentes.
- Las reglas tienen umbrales justificados.
- Las reglas tienen intervalos definidos.
- Las reglas tienen duraciones definidas.
- Las reglas tienen etiquetas.
- Las reglas tienen anotaciones.
- Se ha comprobado el estado inicial.
- Se ha probado al menos una activación.
- Se ha comprobado al menos una recuperación.
- Se ha probado un contacto de laboratorio, si está disponible.
- Se ha configurado una política de notificación, si está disponible.
- Se ha documentado el comportamiento ante ausencia de datos.
- Se ha documentado al menos un diagnóstico.
- Las evidencias están organizadas.
- No se han expuesto credenciales.
- El entorno queda en un estado estable.

## Lista de comprobación final

### Reglas

```text
[ ] La alerta de disponibilidad existe.
[ ] La alerta de CPU existe.
[ ] La alerta de memoria existe.
[ ] La alerta de almacenamiento existe.
[ ] Los nombres son coherentes.
[ ] Las consultas devuelven datos.
[ ] Los umbrales están documentados.
[ ] Las duraciones están justificadas.
```

### Etiquetas

```text
[ ] Existe alertname.
[ ] Existe severity.
[ ] Existe team.
[ ] Existe service.
[ ] Existe environment.
[ ] Existe resource.
[ ] Los valores son coherentes.
```

### Anotaciones

```text
[ ] Existe summary.
[ ] Existe description.
[ ] Se identifica la instancia.
[ ] Existe un procedimiento o runbook, si procede.
```

### Estados

```text
[ ] Se ha comprobado Normal.
[ ] Se ha observado Pending.
[ ] Se ha observado Alerting.
[ ] Se ha comprobado la recuperación.
```

### Notificaciones

```text
[ ] Existe un contacto de laboratorio.
[ ] El contacto se ha probado.
[ ] Existe una política.
[ ] La alerta coincide con la política.
[ ] Se ha documentado la entrega.
```

### Seguridad

```text
[ ] Las pruebas se han realizado en laboratorio.
[ ] No se han detenido servicios de producción.
[ ] No se ha generado carga no autorizada.
[ ] No se han compartido credenciales.
[ ] Se han revisado las capturas.
```

## Puntos clave

- Una alerta debe representar una condición accionable.
- La consulta debe validarse antes de crear la regla.
- El umbral debe tener una justificación.
- La duración ayuda a evitar falsos positivos.
- `Normal`, `Pending` y `Alerting` representan fases diferentes.
- Las etiquetas clasifican y enrutan las alertas.
- Las anotaciones explican el problema.
- La instancia afectada debe aparecer en la notificación.
- Los umbrales visuales del dashboard no sustituyen a las reglas de alerta.
- La ausencia de datos debe analizarse de forma explícita.
- Una alerta activa no garantiza que la notificación se haya entregado.
- Una notificación puede retrasarse por agrupación o repetición.
- Las pruebas deben incluir activación y recuperación.
- Los silenciamientos deben utilizarse durante actividades planificadas.
- Las alertas críticas deben diferenciarse de las advertencias.
- Las políticas dependen de etiquetas coherentes.
- Las reglas deben ser fáciles de buscar y mantener.
- Una alerta demasiado sensible puede generar ruido.
- Una alerta demasiado permisiva puede detectar el problema demasiado tarde.
- La documentación y las evidencias forman parte de la práctica.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre una métrica y una alerta?
2. ¿Qué elementos forman una regla de alerta?
3. ¿Qué función cumple la reducción `Last`?
4. ¿Qué diferencia existe entre `Normal`, `Pending` y `Alerting`?
5. ¿Por qué se utiliza una duración en una alerta?
6. ¿Qué alerta debe tener normalmente severidad `critical`?
7. ¿Qué etiquetas deben incluir las reglas?
8. ¿Qué diferencia existe entre etiquetas y anotaciones?
9. ¿Por qué debe incluirse `{{ $labels.instance }}` en una anotación?
10. ¿Qué consulta utilizarías para detectar que Node Exporter no responde?
11. ¿Qué consulta utilizarías para detectar CPU superior al 90 %?
12. ¿Qué consulta utilizarías para detectar memoria superior al 90 %?
13. ¿Qué consulta utilizarías para detectar almacenamiento superior al 80 %?
14. ¿Qué revisarías si una alerta nunca pasa de `Normal`?
15. ¿Qué revisarías si una alerta permanece en `Pending`?
16. ¿Qué revisarías si la alerta está en `Alerting`, pero no llega ninguna notificación?
17. ¿Qué diferencia existe entre una alerta silenciada y una alerta resuelta?
18. ¿Por qué es importante documentar el comportamiento ante ausencia de datos?
19. ¿Qué riesgos tiene generar carga sobre un sistema no autorizado?
20. ¿Qué evidencias deben guardarse de una activación y una recuperación?
21. ¿Qué puede provocar una alerta demasiado ruidosa?
22. ¿Qué puede provocar una alerta que tarda demasiado en activarse?
23. ¿Cómo comprobarías que una política coincide con una alerta?
24. ¿Qué elementos deben revisarse antes de entregar la práctica?
25. ¿Qué características debe cumplir una alerta útil?

## Resultado esperado

Al finalizar la práctica, el alumno deberá disponer de un conjunto de reglas de alerta documentadas y validadas:

```text
NodeExporterDown-Laboratory
HighCPUUsage-Laboratory
HighMemoryUsage-Laboratory
FilesystemUsageHigh-Laboratory
```

Cada regla debe incluir:

```text
Consulta
Condición
Umbral
Intervalo
Duración
Etiquetas
Anotaciones
Comportamiento ante ausencia de datos
Estado inicial
Resultado de las pruebas
```

El flujo completado será:

```text
Validar la consulta
        |
        v
Definir el umbral
        |
        v
Definir la duración
        |
        v
Crear la regla
        |
        v
Añadir etiquetas
        |
        v
Añadir anotaciones
        |
        v
Revisar ausencia de datos
        |
        v
Configurar notificaciones
        |
        v
Probar la activación
        |
        v
Observar Pending
        |
        v
Observar Alerting
        |
        v
Recibir la notificación
        |
        v
Resolver la condición
        |
        v
Comprobar la recuperación
        |
        v
Guardar evidencias
        |
        v
Documentar el resultado
```

El alumno debe poder explicar:

```text
Qué detecta cada regla.

Qué consulta utiliza.

Qué umbral se ha elegido.

Por qué se ha elegido esa duración.

Qué equipo es responsable.

Qué información contiene la notificación.

Cómo se ha comprobado la activación.

Cómo se ha comprobado la recuperación.

Qué problemas se han encontrado.

Cómo se han corregido.
```

Esta práctica completa el ciclo básico de detección. En la siguiente fase del proyecto se integrarán alertas, contactos, políticas, anotaciones y silenciamientos para construir un flujo operativo completo.