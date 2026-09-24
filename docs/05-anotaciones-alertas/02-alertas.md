# Alertas en Grafana

Las **alertas en Grafana** permiten detectar automáticamente situaciones que requieren atención.

Una alerta evalúa periódicamente una consulta o expresión y determina si se cumple una condición. Cuando la condición permanece activa durante el tiempo configurado, Grafana puede cambiar el estado de la alerta y enviar una notificación.

Ejemplos habituales:

- Un servidor deja de responder.
- El uso de CPU permanece por encima del 90 %.
- La memoria disponible es demasiado baja.
- Un sistema de ficheros supera un límite.
- La latencia de una aplicación aumenta.
- Una métrica deja de enviar datos.
- La tasa de errores supera un umbral.

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
Evaluación periódica
   |
   v
Estado de la alerta
   |
   v
Notificación
```

Las alertas de Grafana forman parte del sistema de **Unified Alerting**, que permite gestionar reglas, contactos, políticas de notificación y silenciamientos desde una estructura común.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es una alerta en Grafana.
- Diferenciar una métrica, una consulta, una condición y una alerta.
- Comprender el funcionamiento de Unified Alerting.
- Crear una regla de alerta.
- Utilizar consultas PromQL en reglas.
- Configurar expresiones y condiciones.
- Configurar un umbral.
- Configurar el intervalo de evaluación.
- Configurar el tiempo de permanencia en estado pendiente.
- Interpretar los estados `Normal`, `Pending`, `Alerting`, `No data` y `Error`.
- Configurar el comportamiento ante ausencia de datos.
- Configurar el comportamiento ante errores de consulta.
- Añadir etiquetas a una regla.
- Añadir anotaciones descriptivas.
- Crear una alerta de disponibilidad.
- Crear una alerta de CPU.
- Crear una alerta de memoria.
- Crear una alerta de almacenamiento.
- Probar una alerta en un entorno de laboratorio.
- Diagnosticar una alerta que no se activa.
- Documentar reglas de alerta y sus dependencias.

---

## Introducción

Una métrica muestra lo que está ocurriendo. Una alerta ayuda a decidir cuándo esa situación requiere atención.

Por ejemplo, una consulta puede devolver:

```promql
up{job="node_exporter"}
```

Resultado:

```text
1
```

El valor `1` indica que el objetivo está disponible.

Una regla puede establecer:

```text
Si el valor es igual a 0 durante un minuto,
activar una alerta.
```

De esta forma:

```text
up = 1
    |
    v
Estado normal

up = 0 durante 1 minuto
    |
    v
Alerta activa
```

Una alerta bien diseñada debe responder a estas preguntas:

```text
¿Qué está ocurriendo?
¿Dónde está ocurriendo?
¿Cuándo comenzó?
¿Qué importancia tiene?
¿Quién debe atenderlo?
¿Qué procedimiento debe seguirse?
```

Por esta razón, una regla debe incluir no solo una consulta y un umbral, sino también etiquetas, anotaciones y una política de notificación adecuada.

---

## Qué es una alerta

Una alerta es una regla que evalúa una condición sobre datos monitorizados.

Su estructura conceptual es:

```text
Consulta
+
Condición
+
Duración
+
Etiquetas
+
Anotaciones
+
Comportamiento ante errores
```

## Ejemplo

```text
Consulta:
Uso de CPU por instancia

Condición:
Mayor que 90 %

Duración:
5 minutos

Etiqueta:
severity=warning

Resultado:
Alerta de CPU elevada
```

La alerta no se activa necesariamente en el primer instante en que el valor supera el umbral. Si se configura una duración, la condición debe mantenerse durante ese periodo.

---

## Diferencia entre métrica, condición y alerta

| Elemento | Ejemplo | Función |
|---|---|---|
| Métrica | Uso de CPU | Medir el sistema |
| Consulta | `rate(...)` | Obtener o calcular datos |
| Condición | CPU mayor que 90 | Determinar si existe un problema |
| Regla | CPU mayor que 90 durante 5 minutos | Definir la alerta |
| Notificación | Enviar un correo | Comunicar el problema |

## Ejemplo completo

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La consulta obtiene el porcentaje de CPU utilizada.

Después se aplica:

```text
Valor > 90
```

Y se configura:

```text
Durante 5 minutos
```

La regla resultante detecta un uso de CPU elevado y sostenido.

---

## Unified Alerting

Grafana Unified Alerting proporciona una estructura común para gestionar alertas.

Sus componentes principales son:

```text
Reglas de alerta
Grupos de evaluación
Contactos de notificación
Políticas de notificación
Silenciamientos
Historial de estados
```

## Regla de alerta

Define qué condición debe evaluarse.

## Grupo de evaluación

Agrupa reglas que se evalúan con una frecuencia determinada.

## Contacto de notificación

Define el destino de los avisos.

Ejemplos:

- Correo electrónico.
- Webhook.
- Canal de mensajería.
- Sistema de incidencias.

## Política de notificación

Decide qué contacto recibe una alerta.

## Silenciamiento

Evita temporalmente el envío de notificaciones que coinciden con determinadas etiquetas.

---

## Crear una regla de alerta

El nombre exacto de las opciones puede variar según la versión de Grafana.

El procedimiento general es:

1. Acceder a Grafana.
2. Abrir la sección **Alerting**.
3. Seleccionar **Alert rules**.
4. Crear una nueva regla.
5. Asignar un nombre.
6. Seleccionar la fuente de datos.
7. Introducir la consulta.
8. Configurar la reducción o expresión necesaria.
9. Definir la condición.
10. Configurar el intervalo de evaluación.
11. Configurar la duración.
12. Añadir etiquetas.
13. Añadir anotaciones.
14. Definir el comportamiento ante ausencia de datos.
15. Definir el comportamiento ante errores.
16. Guardar la regla.
17. Comprobar su estado.

---

## Componentes de una regla

## Nombre

Debe describir claramente el problema.

Buenos ejemplos:

```text
HighCPUUsage
NodeExporterDown
FilesystemUsageHigh
LowMemoryAvailable
HighApplicationLatency
```

Ejemplos poco útiles:

```text
Alerta1
Prueba
Regla nueva
Problema
```

## Consulta

Obtiene el valor que se evaluará.

Ejemplo:

```promql
up{job="node_exporter"}
```

## Expresión o reducción

Convierte el resultado en un valor evaluable.

Ejemplos:

```text
Last
Mean
Max
Min
```

## Condición

Compara el resultado con un umbral.

Ejemplos:

```text
Mayor que 90
Igual a 0
Menor que 10
```

## Evaluación

Indica cada cuánto se ejecuta la regla.

Ejemplo:

```text
Cada 1 minuto
```

## Duración

Indica cuánto tiempo debe mantenerse la condición.

Ejemplo:

```text
Durante 5 minutos
```

## Etiquetas

Clasifican la alerta.

Ejemplo:

```text
severity = warning
team = systems
service = node_exporter
environment = laboratory
```

## Anotaciones

Describen la situación.

Ejemplo:

```text
summary = CPU elevada en {{ $labels.instance }}

description = La instancia {{ $labels.instance }}
supera el 90 % de uso de CPU durante 5 minutos.
```

---

## Estados de una alerta

## Normal

La condición no se cumple.

Ejemplo:

```text
CPU actual: 45 %
Umbral: 90 %
Estado: Normal
```

## Pending

La condición se cumple, pero todavía no ha transcurrido la duración configurada.

Ejemplo:

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Tiempo transcurrido: 2 minutos
Estado: Pending
```

## Alerting o Firing

La condición se ha mantenido durante el periodo configurado.

Ejemplo:

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Tiempo transcurrido: 6 minutos
Estado: Alerting
```

## Recovering o Normalizado

La condición deja de cumplirse y la alerta vuelve al estado normal.

Ejemplo:

```text
CPU actual: 52 %
Umbral: 90 %
Estado: Normal
```

La terminología exacta puede variar según la versión y el contexto.

## No data

La regla no recibe datos suficientes para evaluar la condición.

Posibles causas:

- El objetivo está caído.
- La consulta no devuelve series.
- La métrica no existe.
- El rango es demasiado corto.
- Prometheus no responde.
- Hay un filtro incorrecto.

## Error

La regla no puede evaluarse correctamente.

Posibles causas:

- Error de sintaxis PromQL.
- Fuente de datos inaccesible.
- Expresión incorrecta.
- Permisos insuficientes.
- Configuración incompatible.

---

## Diferencia entre `Pending` y `Alerting`

Supongamos esta configuración:

```text
Condición: CPU > 90 %
Duración: 5 minutos
Evaluación: cada 1 minuto
```

Secuencia:

```text
17:00 - CPU = 92 % → Pending
17:01 - CPU = 93 % → Pending
17:02 - CPU = 94 % → Pending
17:03 - CPU = 92 % → Pending
17:04 - CPU = 91 % → Pending
17:05 - CPU = 93 % → Alerting
```

Si la CPU baja antes de completar los cinco minutos:

```text
17:00 - CPU = 92 % → Pending
17:01 - CPU = 93 % → Pending
17:02 - CPU = 65 % → Normal
```

La alerta no llega a activarse.

La duración ayuda a evitar alertas causadas por picos breves.

---

## Evaluación periódica

Grafana evalúa las reglas según un intervalo definido.

Ejemplos:

```text
Cada 10 segundos
Cada 30 segundos
Cada 1 minuto
Cada 5 minutos
```

El intervalo debe tener sentido para la métrica.

## Ejemplos

### Disponibilidad

```text
Evaluación frecuente
```

Una caída de un servicio debe detectarse rápidamente.

### CPU

```text
Evaluación cada 1 minuto
Duración de 5 minutos
```

Se evita alertar por picos breves.

### Almacenamiento

```text
Evaluación cada 5 minutos
```

El almacenamiento normalmente cambia más lentamente.

---

## Diseñar umbrales

Un umbral debe basarse en:

- Comportamiento normal.
- Capacidad del sistema.
- Objetivo operativo.
- Nivel de riesgo.
- Experiencia histórica.
- Acuerdos de servicio.

## Ejemplo de CPU

```text
Advertencia: 70 %
Crítico: 90 %
```

## Ejemplo de memoria

```text
Advertencia: 80 %
Crítico: 90 %
```

## Ejemplo de almacenamiento

```text
Advertencia: 80 %
Crítico: 90 %
```

## Ejemplo de disponibilidad

```text
Advertencia: < 100 %
Crítico: < 90 %
```

Los umbrales de laboratorio son orientativos. En producción deben ajustarse al comportamiento real del servicio.

---

## Alertas basadas en disponibilidad

## Objetivo

Detectar que un objetivo de Prometheus deja de responder.

## Consulta

```promql
up{job="node_exporter"}
```

## Condición

```text
Igual a 0
```

## Duración

```text
1 minuto
```

## Etiquetas

```text
severity = critical
team = systems
service = node_exporter
```

## Anotaciones

```text
summary = Objetivo no disponible

description = El objetivo {{ $labels.instance }}
no está respondiendo a Prometheus.
```

## Interpretación

```text
up = 1 → Objetivo disponible
up = 0 → Objetivo no disponible
```

---

## Alertas basadas en CPU

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  ) * 100
)
```

## Condición

```text
Valor mayor que 90
```

## Duración

```text
5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = cpu
```

## Anotaciones

```text
summary = Uso de CPU elevado en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante 5 minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

## Consideración

El uso elevado de CPU no siempre indica un problema. Puede ser normal durante:

- Procesamientos planificados.
- Copias de seguridad.
- Compilaciones.
- Procesos batch.
- Ventanas de carga conocidas.

Por eso es importante combinar el umbral con una duración y un contexto operativo.

---

## Alertas basadas en memoria

## Consulta

```promql
100 * (
  1 -
  (
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
)
```

## Condición

```text
Valor mayor que 90
```

## Duración

```text
5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
```

## Anotaciones

```text
summary = Uso de memoria elevado en {{ $labels.instance }}

description = La memoria utilizada en {{ $labels.instance }}
supera el 90 % durante 5 minutos.
```

## Alternativa: memoria disponible

También se puede alertar cuando la memoria disponible cae por debajo de un porcentaje:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Condición:

```text
Menor que 10
```

Este enfoque expresa directamente la memoria disponible.

---

## Alertas basadas en almacenamiento

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

## Condición

```text
Valor mayor que 80
```

## Duración

```text
10 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = filesystem
mountpoint = /
```

## Anotaciones

```text
summary = Disco con ocupación elevada en {{ $labels.instance }}

description = El sistema de ficheros {{ $labels.mountpoint }}
de {{ $labels.instance }} supera el 80 % de uso.
```

## Precauciones

- Excluir sistemas de ficheros temporales.
- Filtrar puntos de montaje relevantes.
- Considerar el crecimiento esperado.
- Revisar el espacio disponible, no solo el porcentaje.
- Evitar alertas sobre sistemas efímeros.

---

## Alertas basadas en carga del sistema

## Consulta

```promql
node_load1
```

La carga debe interpretarse teniendo en cuenta el número de CPUs.

Una comparación más útil puede ser:

```promql
node_load1
/
count by (instance) (
  node_cpu_seconds_total{mode="idle"}
)
```

La consulta exacta puede necesitar ajustes según las etiquetas disponibles.

## Condición conceptual

```text
Carga normalizada mayor que 1
```

La carga no debe interpretarse como un porcentaje sin realizar una conversión adecuada.

---

## Alertas basadas en latencia

Si existe una métrica de histograma:

```promql
http_request_duration_seconds_bucket
```

Se puede calcular el percentil 95:

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(
      http_request_duration_seconds_bucket[5m]
    )
  )
)
```

## Condición

```text
Percentil 95 mayor que 1 segundo
```

## Etiquetas

```text
severity = warning
team = application
resource = latency
```

## Anotaciones

```text
summary = Latencia p95 elevada

description = El percentil 95 de latencia
supera un segundo durante el periodo evaluado.
```

---

## Etiquetas de las alertas

Las etiquetas permiten clasificar, buscar y enrutar reglas.

## Etiquetas recomendadas

```text
alertname
severity
team
service
environment
instance
resource
```

## Ejemplo

```text
alertname = HighCPUUsage
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

## Buenas prácticas

- Utilizar nombres consistentes.
- Utilizar valores sencillos.
- Evitar etiquetas innecesarias.
- No incluir secretos.
- No utilizar nombres ambiguos.
- Documentar las etiquetas.
- Diseñar las políticas teniendo en cuenta estas etiquetas.

---

## Anotaciones de las alertas

Las anotaciones explican el problema en un formato legible.

## `summary`

Debe ser breve.

```text
summary = CPU elevada en {{ $labels.instance }}
```

## `description`

Debe explicar el problema.

```text
description = La CPU de {{ $labels.instance }}
supera el 90 % durante 5 minutos.
```

## `runbook_url`

Puede enlazar a un procedimiento.

```text
runbook_url = https://example.com/runbooks/high-cpu
```

## Ejemplo completo

```text
summary = Sistema de ficheros casi lleno

description = El punto de montaje {{ $labels.mountpoint }}
de {{ $labels.instance }} supera el umbral configurado.

runbook_url = https://example.com/runbooks/filesystem-full
```

La sintaxis exacta de las plantillas puede variar según el campo y la versión de Grafana.

---

## Comportamiento ante ausencia de datos

Cuando una consulta no devuelve datos, Grafana debe aplicar una política.

Opciones habituales:

```text
No data
Normal
Alerting
```

## `No data`

La regla queda en un estado específico de ausencia de datos.

Adecuado cuando:

- La ausencia de datos debe investigarse.
- La fuente puede estar caída.
- Se necesita distinguir datos ausentes de estado normal.

## `Normal`

La ausencia de datos no genera una alerta.

Adecuado cuando:

- La métrica no siempre existe.
- La ausencia es esperada.
- La regla es opcional.

## `Alerting`

La ausencia de datos se considera un problema.

Adecuado cuando:

- La métrica debe existir continuamente.
- La ausencia implica que un sistema dejó de responder.
- La fuente es crítica.

La decisión debe documentarse. No existe una opción universalmente correcta.

---

## Comportamiento ante errores

Un error de consulta no es lo mismo que una condición verdadera.

## Error

La evaluación no pudo realizarse.

Ejemplos:

- PromQL inválido.
- Prometheus inaccesible.
- Fuente de datos mal configurada.
- Expresión incompatible.

## Recomendación

Durante la configuración:

- Revisar los logs.
- Corregir la consulta.
- Probarla en Explore.
- Comprobar la fuente de datos.
- Evitar ocultar errores como si fueran estados normales.

Una regla que no puede evaluar sus datos necesita atención técnica.

---

## Contactos y notificaciones

Una regla puede cambiar de estado sin que necesariamente se envíe un mensaje al destinatario correcto.

Para notificar se necesitan:

```text
Regla
  +
Etiquetas
  +
Contacto
  +
Política de notificación
```

Ejemplo:

```text
Regla:
HighCPUUsage

Etiquetas:
team=systems
severity=warning

Política:
team=systems

Contacto:
equipo-sistemas@example.com
```

Si las etiquetas no coinciden con la política, la alerta puede terminar en la ruta predeterminada.

---

## Probar una alerta

Una alerta debe probarse en un entorno controlado.

## Prueba de disponibilidad

Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Consultar:

```promql
up{job="node_exporter"}
```

Esperar el periodo de evaluación.

Iniciar de nuevo:

```bash
sudo systemctl start node_exporter
```

## Prueba de CPU

Ejecutar únicamente en laboratorio:

```bash
stress-ng --cpu 1 --timeout 60s
```

Observar:

- Valor de CPU.
- Estado de la alerta.
- Duración.
- Notificación.
- Recuperación.

## Prueba de consulta

Antes de crear la regla, ejecutar la consulta en Explore:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Comprobar:

- Que devuelve datos.
- Que las etiquetas son correctas.
- Que la unidad es porcentaje.
- Que el valor puede compararse con el umbral.

---

## Ejemplo de sesión 1: explorar estados de alerta

## Objetivo

Comprender la transición entre estados.

## Configuración

```text
Consulta: up{job="node_exporter"}
Condición: igual a 0
Duración: 1 minuto
Evaluación: cada 30 segundos
```

## Pasos

1. Crear la regla.
2. Confirmar que está en `Normal`.
3. Detener Node Exporter.
4. Esperar la primera evaluación.
5. Observar `Pending` si está configurado.
6. Esperar la duración.
7. Observar `Alerting`.
8. Iniciar Node Exporter.
9. Observar el retorno a `Normal`.

## Actividades

Completar:

```text
Hora de detención:

Primer estado observado:

Hora de activación:

Hora de recuperación:

Tiempo aproximado de recuperación:

Observaciones:
```

---

## Ejemplo de sesión 2: crear una alerta de CPU

## Objetivo

Crear una regla para detectar uso elevado de CPU.

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
Nombre: HighCPUUsage
Condición: mayor que 90
Duración: 5 minutos
Evaluación: cada 1 minuto
```

## Etiquetas

```text
severity = warning
team = systems
resource = cpu
```

## Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU supera el 90 % durante 5 minutos.
```

## Pasos

1. Validar la consulta en Explore.
2. Crear la regla.
3. Configurar la condición.
4. Añadir las etiquetas.
5. Añadir las anotaciones.
6. Guardar.
7. Ejecutar carga controlada.
8. Observar los estados.
9. Detener la carga.
10. Documentar el resultado.

---

## Ejemplo de sesión 3: crear una alerta de disponibilidad

## Objetivo

Detectar un objetivo no disponible.

## Consulta

```promql
up{job="node_exporter"}
```

## Configuración

```text
Nombre: NodeExporterDown
Condición: igual a 0
Duración: 1 minuto
Evaluación: cada 30 segundos
```

## Etiquetas

```text
severity = critical
team = systems
service = node_exporter
```

## Anotaciones

```text
summary = Node Exporter no disponible

description = El objetivo {{ $labels.instance }}
no responde a Prometheus.
```

## Actividades

1. Crea la regla.
2. Detén Node Exporter.
3. Observa la alerta.
4. Revisa la instancia afectada.
5. Inicia el servicio.
6. Comprueba la recuperación.
7. Explica la diferencia entre la caída del exporter y la caída de Prometheus.

---

## Ejemplo de sesión 4: crear una alerta de memoria

## Objetivo

Detectar un porcentaje elevado de memoria utilizada.

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
Nombre: HighMemoryUsage
Condición: mayor que 90
Duración: 5 minutos
Evaluación: cada 1 minuto
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
```

## Actividades

1. Crea la regla.
2. Comprueba la unidad.
3. Revisa el valor en un Gauge.
4. Decide si el umbral es adecuado.
5. Explica por qué `MemAvailable` suele ser más útil que `MemFree`.
6. Documenta el resultado.

---

## Ejemplo de sesión 5: crear una alerta de disco

## Objetivo

Detectar un sistema de ficheros con uso elevado.

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
Nombre: FilesystemUsageHigh
Condición: mayor que 80
Duración: 10 minutos
Evaluación: cada 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = filesystem
mountpoint = /
```

## Actividades

1. Crea la regla.
2. Comprueba la etiqueta `mountpoint`.
3. Revisa si existen otros puntos de montaje.
4. Explica por qué se excluyen sistemas temporales.
5. Añade un enlace a un runbook.

---

## Ejemplo de sesión 6: probar `No data`

## Objetivo

Comprender el comportamiento de una regla cuando desaparecen los datos.

## Consulta

```promql
up{job="node_exporter"}
```

## Pasos

1. Crear una regla basada en la consulta.
2. Configurar el comportamiento ante ausencia de datos.
3. Detener Node Exporter.
4. Esperar varias evaluaciones.
5. Observar si la regla muestra:
   - `No data`.
   - `Normal`.
   - `Alerting`.
6. Comparar los resultados.

## Actividades

1. Repite la prueba con otra política de ausencia de datos.
2. Documenta qué comportamiento es más adecuado para la disponibilidad.
3. Explica por qué la ausencia de datos puede ser un problema.

---

## Ejemplo de sesión 7: diagnosticar una regla que no se activa

## Objetivo

Resolver una regla configurada incorrectamente.

## Situación

La CPU supera el 90 %, pero la alerta permanece en `Normal`.

## Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar el valor real.
3. Revisar la condición.
4. Revisar la unidad.
5. Revisar el umbral.
6. Revisar la duración.
7. Revisar el intervalo de evaluación.
8. Revisar los filtros por etiquetas.
9. Comprobar que la regla está habilitada.
10. Revisar el grupo de evaluación.

## Posibles errores

```text
Umbral configurado como 0.90 en lugar de 90.
Filtro aplicado a una instancia incorrecta.
Duración demasiado larga.
Consulta sin resultados.
La regla está pausada.
```

## Registro

```text
Consulta:

Valor observado:

Condición:

Umbral:

Duración:

Estado original:

Causa:

Corrección:

Estado final:
```

---

## Ejemplo de sesión 8: probar una notificación

## Objetivo

Comprobar que una alerta llega al contacto configurado.

## Requisitos

- Contacto de laboratorio.
- Política de notificación.
- Regla con etiquetas coincidentes.
- Canal de recepción disponible.

## Pasos

1. Crear un contacto.
2. Crear o seleccionar una política.
3. Revisar las etiquetas.
4. Activar una alerta de prueba.
5. Esperar la evaluación.
6. Comprobar la recepción.
7. Revisar el contenido.
8. Comprobar la resolución.
9. Revisar la notificación de recuperación si está configurada.

## Actividades

Documentar:

```text
Contacto:

Política:

Etiquetas de la regla:

Hora de activación:

Hora de recepción:

Contenido correcto:

Notificación de recuperación:

Problemas:
```

---

## Ejemplo de sesión 9: utilizar etiquetas para clasificar alertas

## Objetivo

Clasificar las alertas según equipo y severidad.

## Reglas

### CPU

```text
team = systems
severity = warning
resource = cpu
```

### Disponibilidad

```text
team = systems
severity = critical
resource = availability
```

### Latencia

```text
team = application
severity = warning
resource = latency
```

## Actividades

1. Crea las tres reglas.
2. Revisa las etiquetas.
3. Filtra la lista de alertas por `team`.
4. Filtra por `severity`.
5. Diseña una política para cada equipo.
6. Explica por qué las etiquetas deben ser consistentes.

---

## Ejemplo de sesión 10: crear un silencio temporal

## Objetivo

Evitar notificaciones durante una prueba o mantenimiento.

## Escenario

```text
Se realizará mantenimiento sobre server-01:9100.
```

## Coincidencia

```text
instance = server-01:9100
```

## Motivo

```text
Mantenimiento programado del laboratorio
```

## Duración

```text
30 minutos
```

## Pasos

1. Crear el silencio.
2. Seleccionar la etiqueta.
3. Introducir el motivo.
4. Definir inicio y fin.
5. Guardar.
6. Activar una alerta coincidente.
7. Confirmar que no se recibe la notificación.
8. Revisar la alerta en la interfaz.
9. Esperar o finalizar el silencio.
10. Comprobar el comportamiento posterior.

---

## Buenas prácticas

## Validar la consulta antes de crear la regla

Siempre probar la consulta en Explore.

## Utilizar nombres claros

El nombre debe describir el problema, no la implementación interna.

## Añadir una duración adecuada

La duración evita alertas por fluctuaciones breves.

## Utilizar etiquetas consistentes

Ejemplo:

```text
severity
team
service
environment
resource
```

## Añadir contexto en las anotaciones

La notificación debe ayudar a actuar.

## Utilizar runbooks

Una alerta sin procedimiento puede dejar al operador con un mensaje y ninguna pista.

## Evitar alertas redundantes

No crear varias reglas que detecten exactamente el mismo problema sin una razón clara.

## Revisar el ruido

Analizar periódicamente:

- Alertas repetidas.
- Alertas ignoradas.
- Alertas sin acción.
- Alertas que se resuelven demasiado rápido.
- Alertas que permanecen activas demasiado tiempo.

## Probar recuperación

La regla debe volver a normal cuando la condición deja de cumplirse.

## Gestionar `No data` explícitamente

La ausencia de datos puede ser:

- Un problema.
- Un comportamiento esperado.
- Un error de configuración.

## Mantener los silencios limitados

Los silencios indefinidos ocultan problemas.

---

## Problemas habituales

## La alerta no aparece

Comprobar:

- La regla se ha guardado.
- La regla está habilitada.
- La consulta devuelve datos.
- El grupo de evaluación está activo.
- El usuario tiene permisos.
- La vista está filtrada correctamente.

## La alerta no se activa

Comprobar:

- Condición.
- Umbral.
- Duración.
- Intervalo.
- Unidades.
- Etiquetas.
- Rango de consulta.

## La alerta se activa demasiado pronto

Comprobar:

- Duración configurada.
- Frecuencia de evaluación.
- Ruido de la métrica.
- Agregación.
- Umbral.

## La alerta nunca se resuelve

Comprobar:

- La consulta sigue devolviendo el valor elevado.
- La condición de recuperación.
- El rango temporal.
- La fuente de datos.
- La existencia de un silencio.
- La configuración de la regla.

## Aparece `No data`

Comprobar:

- El objetivo.
- Prometheus.
- La métrica.
- Los filtros.
- Las etiquetas.
- El rango temporal.
- La política de ausencia de datos.

## Aparece `Error`

Comprobar:

- PromQL.
- Expresiones.
- Fuente de datos.
- Logs.
- Permisos.
- Configuración de la regla.

## Llega demasiadas veces la misma notificación

Comprobar:

- Intervalo de repetición.
- Agrupación.
- Política.
- Duración.
- Fluctuaciones de la métrica.
- Regla duplicada.

## La alerta no llega al contacto esperado

Comprobar:

- Etiquetas.
- Política.
- Orden de rutas.
- Contacto predeterminado.
- Silenciamientos.
- Estado de la integración.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/alertas
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/alertas/consultas-promql.txt <<'EOF'
Disponibilidad:
up{job="node_exporter"}

CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Almacenamiento:
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
EOF
```

Guardar un inventario de reglas:

```bash
cat > ~/laboratorio-grafana/evidencias/alertas/reglas.txt <<'EOF'
Regla:

Nombre:

Consulta:

Condición:

Intervalo de evaluación:

Duración:

Etiquetas:

Anotaciones:

Comportamiento ante No data:

Comportamiento ante Error:

Contacto:

Política:

Prueba:

Resultado:
EOF
```

Capturas recomendadas:

```text
01-consulta-disponibilidad.png
02-regla-node-exporter-down.png
03-regla-cpu.png
04-alerta-normal.png
05-alerta-pending.png
06-alerta-firing.png
07-alerta-resuelta.png
08-notificacion-recibida.png
09-no-data.png
10-silencio-activo.png
```

---

## Práctica integradora

## Objetivo

Crear y probar un conjunto básico de alertas para un servidor Linux.

## Regla 1: objetivo no disponible

### Consulta

```promql
up{job="node_exporter"}
```

### Configuración

```text
Nombre: NodeExporterDown
Condición: igual a 0
Evaluación: cada 30 segundos
Duración: 1 minuto
```

### Etiquetas

```text
severity = critical
team = systems
resource = availability
```

### Anotaciones

```text
summary = Objetivo no disponible

description = El objetivo {{ $labels.instance }}
no responde a Prometheus.
```

---

## Regla 2: CPU elevada

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Configuración

```text
Nombre: HighCPUUsage
Condición: mayor que 90
Evaluación: cada 1 minuto
Duración: 5 minutos
```

### Etiquetas

```text
severity = warning
team = systems
resource = cpu
```

### Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU supera el 90 %
durante cinco minutos.
```

---

## Regla 3: memoria elevada

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Configuración

```text
Nombre: HighMemoryUsage
Condición: mayor que 90
Evaluación: cada 1 minuto
Duración: 5 minutos
```

### Etiquetas

```text
severity = warning
team = systems
resource = memory
```

---

## Actividades

1. Crear las tres reglas.
2. Validar las consultas.
3. Configurar los estados.
4. Añadir etiquetas.
5. Añadir anotaciones.
6. Crear un contacto de laboratorio.
7. Configurar una política.
8. Probar la caída de Node Exporter.
9. Probar una carga de CPU.
10. Revisar los estados.
11. Revisar las notificaciones.
12. Crear una anotación manual.
13. Crear un silencio temporal.
14. Comprobar la recuperación.
15. Documentar el resultado.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Consulta de disponibilidad validada | | |
| Consulta de CPU validada | | |
| Consulta de memoria validada | | |
| Regla de disponibilidad creada | | |
| Regla de CPU creada | | |
| Regla de memoria creada | | |
| Etiquetas configuradas | | |
| Anotaciones configuradas | | |
| Intervalos configurados | | |
| Duraciones configuradas | | |
| Contacto creado | | |
| Política creada | | |
| Estado `Normal` observado | | |
| Estado `Pending` observado | | |
| Estado `Alerting` observado | | |
| Estado resuelto observado | | |
| Notificación recibida | | |
| Anotación creada | | |
| Silencio creado | | |
| Silencio revisado | | |
| Evidencias guardadas | | |
| Informe completado | | |

---

## Puntos clave

- Una alerta evalúa una condición sobre datos monitorizados.
- Una métrica no es una alerta.
- Una consulta obtiene o calcula los datos.
- Una condición compara el resultado con un criterio.
- Una duración evita alertas causadas por picos breves.
- `Pending` indica que la condición se cumple, pero aún no ha transcurrido la duración.
- `Alerting` indica que la condición se ha mantenido durante el periodo configurado.
- `No data` indica que no existen datos suficientes para evaluar.
- `Error` indica que la evaluación no pudo completarse correctamente.
- Las etiquetas clasifican y enrutan alertas.
- Las anotaciones explican el problema.
- Las políticas determinan el contacto que recibe una notificación.
- Los silenciamientos deben tener alcance y duración limitados.
- Una consulta debe validarse antes de crear una regla.
- Los umbrales deben basarse en el comportamiento real del sistema.
- Las alertas deben ser accionables.
- Una alerta debe incluir contexto y, cuando sea posible, un runbook.
- Las reglas deben probarse en estados normales y anómalos.
- La ausencia de datos debe configurarse de forma explícita.
- La frecuencia de evaluación debe adaptarse a la métrica.
- El exceso de alertas produce ruido y fatiga operativa.
- Una alerta bien diseñada debe facilitar la investigación y la respuesta.

---

## Preguntas de comprobación

1. ¿Qué es una alerta en Grafana?
2. ¿Qué diferencia existe entre una métrica y una alerta?
3. ¿Qué función cumple una consulta PromQL?
4. ¿Qué es una condición?
5. ¿Qué función cumple la duración de una regla?
6. ¿Qué significa el estado `Pending`?
7. ¿Cuándo una alerta pasa a `Alerting`?
8. ¿Qué significa el estado `No data`?
9. ¿Qué puede provocar un estado `Error`?
10. ¿Qué función cumplen las etiquetas?
11. ¿Qué función cumplen las anotaciones?
12. ¿Qué diferencia existe entre un contacto y una política de notificación?
13. ¿Por qué deben validarse las consultas antes de crear reglas?
14. ¿Cómo crearías una alerta para detectar un objetivo caído?
15. ¿Cómo crearías una alerta para detectar CPU elevada?
16. ¿Por qué una alerta de CPU debería tener una duración?
17. ¿Cómo probarías una alerta de disponibilidad?
18. ¿Qué revisarías si la alerta no se activa?
19. ¿Qué revisarías si la alerta se activa, pero no llega la notificación?
20. ¿Qué comportamiento elegirías ante ausencia de datos para una alerta de disponibilidad?
21. ¿Qué información debe incluir una anotación útil?
22. ¿Qué es un silenciamiento?
23. ¿Por qué los silenciamientos deben tener fecha de finalización?
24. ¿Qué evidencias guardarías en la práctica?
25. ¿Qué características debe cumplir una alerta accionable?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear una regla de alerta completa y comprender su ciclo de vida.

El proceso completo será:

```text
Identificar la métrica
        |
        v
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
Configurar el comportamiento ante errores
        |
        v
Configurar el contacto
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
Comprobar la recuperación
        |
        v
Documentar el resultado
```

El resultado final debe ser una alerta clara, verificable y accionable, capaz de detectar una condición relevante sin generar ruido innecesario.

Una alerta no está terminada cuando aparece en la pantalla de configuración. Está terminada cuando se ha probado, notifica correctamente, se recupera cuando corresponde y permite al operador saber qué hacer después.