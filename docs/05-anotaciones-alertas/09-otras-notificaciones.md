# Otras formas de notificación

Además del correo electrónico, Grafana puede enviar alertas mediante distintos canales de comunicación e integración.

Estos canales permiten adaptar la respuesta al tipo de alerta:

- Un canal colaborativo para avisos de severidad media.
- Un sistema de guardia para incidentes críticos.
- Un webhook para automatizaciones.
- Un sistema de gestión de incidencias.
- Una aplicación de mensajería.
- Un servicio externo de escalado.
- Una plataforma interna de operaciones.

La disponibilidad exacta de las integraciones depende de la versión de Grafana, la edición utilizada, los complementos instalados y los servicios autorizados por la organización.

El flujo general es:

```text
Regla de alerta
      |
      v
Etiquetas
      |
      v
Política de notificación
      |
      v
Contacto de notificación
      |
      v
Integración externa
      |
      v
Mensaje, incidencia o automatización
```

Una integración no debe seleccionarse únicamente porque sea técnicamente posible. También deben evaluarse:

- La urgencia de la alerta.
- La responsabilidad del destinatario.
- La privacidad de los datos.
- La disponibilidad del canal.
- La trazabilidad.
- El coste operativo.
- La posibilidad de automatizar una respuesta.
- El riesgo de generar ruido.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar por qué existen varios canales de notificación.
- Diferenciar un correo de un webhook y de un sistema de guardia.
- Identificar integraciones habituales de Grafana.
- Crear un contacto de tipo webhook.
- Crear un contacto para un canal colaborativo.
- Comprender el funcionamiento de una integración con un sistema de incidencias.
- Relacionar una severidad con un canal de notificación.
- Configurar una política para alertas críticas.
- Probar una integración externa en un entorno de laboratorio.
- Interpretar respuestas HTTP de un webhook.
- Diagnosticar errores de autenticación.
- Diagnosticar errores de conectividad.
- Proteger tokens, claves y URLs privadas.
- Evitar enviar información sensible a canales inadecuados.
- Comprobar la recepción de una notificación.
- Comprobar la creación de una incidencia.
- Revisar el comportamiento de una alerta recuperada.
- Documentar una integración.
- Elegir el canal más adecuado para cada tipo de alerta.

---

# Introducción

No todas las alertas deben enviarse por el mismo canal.

Una alerta informativa puede aparecer en un canal colaborativo sin interrumpir al equipo de guardia.

Una alerta crítica de disponibilidad puede necesitar un sistema de escalado que avise a la persona de guardia.

Una alerta destinada a generar una tarea puede enviarse mediante un webhook a una plataforma de incidencias.

## Ejemplo

```text
severity=info
    → canal de observabilidad

severity=warning
    → canal del equipo de sistemas

severity=critical
    → sistema de guardia y gestión de incidencias
```

La clasificación debe definirse mediante etiquetas.

```text
severity = critical
team = systems
service = payments
environment = production
```

La política de notificación utiliza esas etiquetas para seleccionar el contacto adecuado.

---

# Tipos de notificación

## Webhook

Un webhook envía una petición HTTP a una URL.

```text
Grafana
   |
   | POST HTTPS
   v
Endpoint externo
```

Puede utilizarse para:

- Crear incidencias.
- Ejecutar automatizaciones.
- Publicar mensajes.
- Registrar eventos.
- Activar procesos internos.
- Integrar herramientas propias.

## Canales colaborativos

Algunas organizaciones utilizan herramientas colaborativas para comunicar alertas a equipos.

Ejemplos:

- Slack.
- Microsoft Teams.
- Mattermost.
- Google Chat.
- Discord, cuando esté autorizado.

Son adecuados para:

- Alertas de laboratorio.
- Avisos de severidad media.
- Coordinación durante una incidencia.
- Comunicación entre equipos.
- Seguimiento de problemas no urgentes.

## Sistemas de guardia

Las plataformas de guardia permiten avisar a personas según turnos y reglas de escalado.

Ejemplos:

- PagerDuty.
- Opsgenie.
- Servicios equivalentes.

Son adecuados para:

- Incidentes críticos.
- Servicios disponibles continuamente.
- Alertas que requieren respuesta inmediata.
- Escalado si la primera persona no responde.

## Sistemas de gestión de incidencias

Permiten crear, actualizar y cerrar incidencias.

Ejemplos:

- Jira Service Management.
- ServiceNow.
- Sistemas internos.
- Plataformas ITSM compatibles.

Son adecuados para:

- Registrar el incidente.
- Asignar responsables.
- Mantener trazabilidad.
- Gestionar acuerdos de nivel de servicio.
- Documentar acciones y resolución.

## Integraciones personalizadas

Una organización puede disponer de un receptor propio.

Ejemplos:

```text
https://automation.example.com/hooks/grafana
https://incidents.example.com/api/alerts
https://operations.example.com/events
```

La integración debe estar documentada y protegida.

---

# Diferencia entre los canales

| Canal | Uso principal | Ventaja | Riesgo |
|---|---|---|---|
| Correo | Avisos y resúmenes | Sencillo y universal | Puede retrasarse o ignorarse |
| Webhook | Automatización | Flexible | Requiere desarrollo y seguridad |
| Chat | Coordinación | Visible para el equipo | Puede generar ruido |
| Guardia | Incidentes críticos | Escalado y turnos | Puede provocar fatiga |
| ITSM | Gestión formal | Trazabilidad | Configuración más compleja |
| Integración propia | Procesos internos | Adaptación total | Mantenimiento interno |

La elección correcta depende del contexto operativo y no solo de las funciones disponibles.

---

# Webhooks

## Qué es un webhook

Un webhook es un mecanismo mediante el cual Grafana envía información a una aplicación externa cuando una alerta cumple una condición.

Normalmente se utiliza una petición HTTP `POST`.

```text
POST /hooks/grafana HTTP/1.1
Host: automation.example.com
Content-Type: application/json
Authorization: Bearer TOKEN
```

El contenido suele enviarse en formato JSON.

## Flujo de un webhook

```text
Alerta activa
      |
      v
Política coincidente
      |
      v
Contacto webhook
      |
      v
Petición HTTPS
      |
      v
Servidor externo
      |
      v
Respuesta HTTP
```

## Respuestas habituales

| Código | Interpretación |
|---|---|
| `200` | Petición procesada correctamente |
| `201` | Recurso creado |
| `202` | Petición aceptada para procesamiento posterior |
| `400` | Datos incorrectos |
| `401` | Autenticación ausente o incorrecta |
| `403` | Acceso no permitido |
| `404` | Endpoint inexistente |
| `409` | Conflicto con un recurso existente |
| `429` | Límite de peticiones superado |
| `500` | Error interno del receptor |
| `503` | Servicio no disponible |

El significado exacto depende del sistema receptor.

---

# Payload de un webhook

Un payload es el contenido que Grafana envía al receptor.

El formato puede variar según la integración.

## Ejemplo conceptual

```json
{
  "status": "firing",
  "alerts": [
    {
      "status": "firing",
      "labels": {
        "alertname": "HighCPUUsage",
        "severity": "warning",
        "team": "systems",
        "instance": "server-01:9100"
      },
      "annotations": {
        "summary": "CPU elevada en server-01:9100",
        "description": "La CPU supera el 90 % durante cinco minutos."
      },
      "startsAt": "2026-09-24T18:00:00Z",
      "endsAt": "0001-01-01T00:00:00Z"
    }
  ],
  "externalURL": "https://grafana.example.com"
}
```

El payload real puede tener más campos.

## Información útil

Un receptor suele necesitar:

- Estado.
- Nombre de la alerta.
- Etiquetas.
- Anotaciones.
- Hora de inicio.
- Hora de finalización.
- Instancia afectada.
- Enlace a Grafana.
- Enlace al runbook.
- Identificador de la alerta.

---

# Seguridad de los webhooks

Los webhooks deben considerarse interfaces externas.

## Riesgos

- URL expuesta.
- Token robado.
- Endpoint sin autenticación.
- Comunicación sin cifrado.
- Repetición de peticiones.
- Datos sensibles en el payload.
- Receptor vulnerable.
- Falta de validación del origen.
- Permisos excesivos.

## Buenas prácticas

- Utilizar HTTPS.
- Autenticar las peticiones.
- Validar el contenido recibido.
- Limitar el acceso por red cuando sea posible.
- Utilizar tokens con permisos mínimos.
- Rotar las credenciales.
- Evitar credenciales dentro de la URL.
- Registrar los eventos sin guardar secretos.
- Controlar el tamaño del payload.
- Proteger el endpoint frente a abusos.

## Ejemplo incorrecto

```text
https://example.com/hooks/grafana?token=secreto-real
```

## Ejemplo preferible

```text
https://example.com/hooks/grafana
```

La credencial debe configurarse mediante cabeceras o un mecanismo seguro.

---

# Probar un webhook

## Objetivo

Comprobar que Grafana puede comunicarse con un receptor autorizado.

## Pasos

1. Crear un endpoint de laboratorio.
2. Crear el contacto webhook.
3. Configurar la URL.
4. Configurar la autenticación.
5. Guardar el contacto.
6. Ejecutar la prueba.
7. Revisar la respuesta HTTP.
8. Revisar los logs del receptor.
9. Comprobar el payload.
10. Activar una alerta de laboratorio.
11. Confirmar la recepción.
12. Registrar el resultado.

## Registro

```text
Nombre del contacto:

Endpoint:

Método:

Autenticación:

Fecha:

Código HTTP:

Payload recibido:

Resultado:

Problemas encontrados:

Corrección:
```

No guardar tokens ni cabeceras sensibles en el registro.

---

# Canales colaborativos

Los canales colaborativos permiten que un equipo vea las alertas en una conversación compartida.

## Ejemplo conceptual

```text
Canal:
#operaciones-laboratorio

Mensaje:
[FIRING] HighCPUUsage
server-01:9100 supera el 90 % de CPU.
```

## Ventajas

- Visibilidad compartida.
- Respuesta rápida del equipo.
- Contexto en la conversación.
- Posibilidad de añadir comentarios.
- Integración con herramientas de trabajo.

## Riesgos

- Exceso de mensajes.
- Alertas importantes mezcladas con avisos menores.
- Falta de seguimiento formal.
- Información sensible expuesta.
- Dependencia de una plataforma externa.

## Recomendaciones

- Crear canales separados por equipo o entorno.
- No enviar todas las alertas al mismo canal.
- Utilizar severidades coherentes.
- Incluir enlaces a dashboards y runbooks.
- Mantener el canal moderado.
- No utilizar un canal de chat como sustituto de un sistema de incidencias cuando se requiere trazabilidad.

---

# Microsoft Teams, Slack y herramientas similares

La configuración concreta depende de la integración disponible.

## Procedimiento general

1. Crear un canal de destino.
2. Obtener el mecanismo de integración autorizado.
3. Crear el contacto en Grafana.
4. Configurar la URL o los parámetros requeridos.
5. Guardar el contacto.
6. Ejecutar una prueba.
7. Comprobar el mensaje.
8. Activar una alerta de laboratorio.
9. Revisar el formato.
10. Documentar el resultado.

## Información que debe aparecer

```text
Estado:
FIRING o RESOLVED

Alerta:
HighCPUUsage

Severidad:
warning

Instancia:
server-01:9100

Descripción:
CPU superior al 90 %

Enlaces:
Dashboard y runbook
```

Los nombres de los campos y el aspecto visual dependen de la plataforma.

---

# Sistemas de guardia

## Qué es un sistema de guardia

Un sistema de guardia administra turnos, escalados y confirmaciones.

El flujo puede ser:

```text
Alerta crítica
      |
      v
Persona de guardia
      |
      v
Sin confirmación
      |
      v
Segundo nivel
      |
      v
Equipo responsable
```

## Cuándo utilizarlo

- Caídas de servicios críticos.
- Pérdida de disponibilidad.
- Incidentes de seguridad.
- Problemas con impacto económico.
- Incumplimiento de un SLA.
- Alertas que requieren respuesta fuera del horario laboral.

## Cuándo no utilizarlo

- Métricas informativas.
- Picos breves.
- Alertas sin acción definida.
- Alertas de laboratorio.
- Problemas que pueden revisarse durante el horario normal.

## Fatiga de alertas

Si el sistema de guardia recibe demasiadas alertas, las personas pueden:

- Ignorar avisos.
- Confirmar sin investigar.
- Desactivar notificaciones.
- Perder alertas importantes.
- Sufrir interrupciones innecesarias.

Por eso, solo deben llegar al sistema de guardia las alertas que requieran una respuesta urgente.

---

# Integraciones con sistemas de incidencias

Una integración con un sistema ITSM puede:

- Crear una incidencia.
- Añadir comentarios.
- Asignar un equipo.
- Actualizar una incidencia existente.
- Cambiar su estado.
- Cerrar la incidencia al recuperarse la alerta.

## Flujo de ejemplo

```text
Alerta activa
      |
      v
Crear incidencia INC-1042
      |
      v
Asignar a systems
      |
      v
Investigar
      |
      v
Alerta recuperada
      |
      v
Añadir comentario de recuperación
      |
      v
Cerrar o resolver INC-1042
```

## Precaución: duplicados

Si Grafana reenvía una alerta o la integración no reconoce el identificador, pueden crearse varias incidencias para el mismo problema.

El receptor debe utilizar un identificador estable cuando sea posible.

Ejemplo conceptual:

```text
alertname + instance + service
```

---

# Integraciones con sistemas de guardia e incidencias

Una alerta puede enviarse a varios destinos.

## Ejemplo

```text
severity=critical
    → sistema de guardia
    → sistema ITSM

severity=warning
    → canal de sistemas

severity=info
    → dashboard o resumen
```

No es necesario enviar cada alerta a todos los canales.

La política debe evitar duplicar mensajes innecesariamente.

## Ejemplo de rutas

| Condición | Destino |
|---|---|
| `severity=info` | Canal de observabilidad |
| `severity=warning` | Canal del equipo |
| `severity=critical` | Guardia e ITSM |
| `environment=laboratory` | Contacto de formación |

---

# Etiquetas para enrutar notificaciones

Las etiquetas deben representar información útil para seleccionar el canal.

## Ejemplo

```text
severity = critical
team = platform
service = payments
environment = production
notification = oncall
```

Una política podría buscar:

```text
severity = critical
environment = production
```

y enviar la alerta al sistema de guardia.

## Etiquetas recomendadas

```text
severity
team
service
environment
region
notification
urgency
```

## No utilizar etiquetas ambiguas

Evitar:

```text
important = yes
send = true
route = maybe
```

Es mejor utilizar valores claros:

```text
severity = critical
notification = oncall
```

---

# Notificaciones según la severidad

## Información

```text
severity = info
```

Canales adecuados:

- Dashboard.
- Canal de observabilidad.
- Resumen por correo.
- Registro interno.

## Advertencia

```text
severity = warning
```

Canales adecuados:

- Canal del equipo.
- Correo.
- Sistema de seguimiento.
- Incidencia no urgente.

## Crítica

```text
severity = critical
```

Canales adecuados:

- Sistema de guardia.
- Incidencia prioritaria.
- Canal de operaciones.
- Correo de escalado.

La severidad debe corresponder a una acción concreta.

---

# Plantillas de mensajes

Un mensaje consistente facilita la lectura en cualquier canal.

## Plantilla conceptual

```text
Estado: {{ estado }}
Alerta: {{ nombre }}
Severidad: {{ severity }}
Equipo: {{ team }}
Servicio: {{ service }}
Entorno: {{ environment }}
Instancia: {{ instance }}

Resumen:
{{ summary }}

Descripción:
{{ description }}

Inicio:
{{ startsAt }}

Dashboard:
{{ dashboardURL }}

Runbook:
{{ runbookURL }}
```

La sintaxis real de las variables depende de Grafana y del tipo de integración.

## Mensaje breve para chat

```text
[FIRING] HighCPUUsage
server-01:9100 supera el 90 % de CPU.
Equipo: systems
Severidad: warning
Runbook: https://example.com/runbooks/high-cpu
```

## Mensaje para una incidencia

```text
Título:
[critical] NodeExporterDown en server-01:9100

Descripción:
El objetivo no responde a Prometheus.

Equipo:
systems

Entorno:
production

Inicio:
2026-09-24 18:10

Acción:
Consultar el runbook de disponibilidad.
```

---

# Agrupación y repetición

Cuando se activan varias alertas, Grafana puede agruparlas.

## Ejemplo

```text
HighCPUUsage:
- server-01
- server-02
- server-03
```

## Ventajas

- Reduce mensajes.
- Facilita identificar un incidente común.
- Evita saturar los canales.

## Riesgos

- Puede ocultar una alerta concreta.
- Puede retrasar la entrega.
- Puede dificultar la correlación.
- Puede crear una incidencia demasiado amplia.

## Pruebas necesarias

Comprobar:

```text
¿Las alertas se agrupan por servicio?

¿Se agrupan por instancia?

¿Se agrupan por severidad?

¿Se envían repetidamente?

¿La recuperación se incluye en el grupo?
```

---

# Recuperaciones

Una integración puede recibir tanto activaciones como recuperaciones.

## Activación

```text
[FIRING] HighApplicationLatency
```

## Recuperación

```text
[RESOLVED] HighApplicationLatency
```

## Sistemas de incidencias

La recuperación puede:

- Añadir un comentario.
- Cambiar la prioridad.
- Resolver la incidencia.
- Cerrar automáticamente el ticket.
- Dejar la incidencia abierta para revisión.

La acción debe definirse con cuidado. No siempre es adecuado cerrar automáticamente una incidencia crítica.

---

# Automatizaciones mediante webhook

Un webhook puede activar una automatización.

## Ejemplos

- Crear una incidencia.
- Publicar un mensaje.
- Añadir una entrada en un sistema de cambios.
- Ejecutar un flujo de aprobación.
- Actualizar una CMDB.
- Registrar un evento.
- Activar una función interna.

## Precaución

Una alerta no debería ejecutar automáticamente acciones destructivas sin controles.

Ejemplo peligroso:

```text
Alerta de disco lleno
    |
    v
Borrar archivos automáticamente
```

Antes de automatizar una acción se deben considerar:

- Falsos positivos.
- Permisos.
- Reversibilidad.
- Auditoría.
- Aprobación.
- Impacto del error.
- Condiciones de seguridad.

---

# Ejemplo de sesión 1: crear un webhook de laboratorio

## Objetivo

Enviar una alerta a un receptor HTTP controlado.

## Requisitos

- Endpoint de laboratorio.
- URL HTTPS.
- Método de autenticación.
- Acceso al receptor.
- Permisos para crear contactos.

## Pasos

1. Preparar el endpoint.
2. Crear un contacto de tipo webhook.
3. Introducir la URL.
4. Configurar la autenticación.
5. Guardar.
6. Ejecutar la prueba.
7. Revisar el código HTTP.
8. Revisar el payload.
9. Activar una alerta de laboratorio.
10. Confirmar la recepción.
11. Documentar el resultado.

## Registro

```text
Nombre del contacto:

Endpoint:

Tipo de autenticación:

Código de la prueba:

Nombre de la alerta:

Payload recibido:

Resultado:

Observaciones:
```

No guardar el token.

---

# Ejemplo de sesión 2: diagnosticar un webhook con error `401`

## Objetivo

Investigar un error de autenticación.

## Situación

```text
La prueba del webhook devuelve HTTP 401.
```

## Pasos

1. Confirmar la URL.
2. Revisar el mecanismo de autenticación.
3. Comprobar el nombre de la cabecera.
4. Revisar la credencial mediante el almacén seguro.
5. Comprobar la fecha de caducidad.
6. Revisar los permisos del token.
7. Probar de nuevo.
8. Revisar los logs del receptor.
9. Rotar la credencial si se ha expuesto.
10. Documentar la corrección.

## Registro

```text
Código inicial:

Mecanismo de autenticación:

Causa:

Corrección:

Código posterior:

Credencial rotada:

Resultado:
```

---

# Ejemplo de sesión 3: diagnosticar un webhook con error `404`

## Objetivo

Corregir una URL de endpoint incorrecta.

## Situación

```text
La prueba devuelve HTTP 404.
```

## Posibles causas

```text
Ruta incorrecta.
Nombre del servicio incorrecto.
Entorno equivocado.
Endpoint eliminado.
Versión incorrecta de la API.
```

## Pasos

1. Revisar el host.
2. Revisar la ruta.
3. Confirmar el entorno.
4. Consultar la documentación del receptor.
5. Probar la URL desde un cliente autorizado.
6. Corregir el contacto.
7. Ejecutar una nueva prueba.
8. Registrar el resultado.

---

# Ejemplo de sesión 4: enviar alertas a un canal colaborativo

## Objetivo

Publicar una alerta de laboratorio en un canal compartido.

## Configuración conceptual

```text
Canal:
#laboratorio-observabilidad

Contacto:
laboratory-chat

Regla:
HighCPUUsage

Etiquetas:
environment = laboratory
team = systems
severity = warning
```

## Pasos

1. Crear el canal.
2. Obtener el mecanismo de integración autorizado.
3. Crear el contacto.
4. Probar el contacto.
5. Crear o revisar la política.
6. Activar la alerta.
7. Revisar el mensaje.
8. Comprobar que el entorno aparece claramente.
9. Resolver la alerta.
10. Revisar el mensaje de recuperación.

## Preguntas de análisis

```text
¿El mensaje se entiende sin abrir Grafana?

¿Aparecen la instancia y la severidad?

¿Existe un enlace al runbook?

¿El canal recibe demasiados mensajes?

¿La recuperación se distingue de la activación?
```

---

# Ejemplo de sesión 5: enrutar por severidad

## Objetivo

Enviar cada severidad a un canal distinto.

## Contactos

```text
laboratory-info-channel
laboratory-warning-channel
laboratory-critical-channel
```

## Políticas

```text
severity=info
    → laboratory-info-channel

severity=warning
    → laboratory-warning-channel

severity=critical
    → laboratory-critical-channel
```

## Pasos

1. Crear los contactos.
2. Probar cada contacto.
3. Crear las políticas.
4. Crear una regla de prueba con severidad `info`.
5. Comprobar el canal.
6. Cambiar a `warning`.
7. Comprobar el canal.
8. Cambiar a `critical`.
9. Comprobar el canal.
10. Documentar el resultado.

## Tabla

| Severidad | Contacto esperado | Contacto recibido | Resultado |
|---|---|---|---|
| `info` | | | |
| `warning` | | | |
| `critical` | | | |

---

# Ejemplo de sesión 6: crear una incidencia mediante webhook

## Objetivo

Enviar una alerta a un sistema de gestión de incidencias de laboratorio.

## Escenario

```text
Alerta:
NodeExporterDown

Severidad:
critical

Acción esperada:
Crear una incidencia
```

## Pasos

1. Preparar un proyecto de laboratorio.
2. Crear un contacto webhook.
3. Configurar el endpoint de creación.
4. Probar la integración.
5. Crear una política para `severity=critical`.
6. Activar la alerta.
7. Comprobar que se crea la incidencia.
8. Revisar el título.
9. Revisar la descripción.
10. Resolver la alerta.
11. Comprobar si se añade un comentario o se actualiza el ticket.
12. Documentar el resultado.

## Registro

```text
Identificador de la incidencia:

Título:

Equipo asignado:

Prioridad:

Hora de creación:

Hora de recuperación:

Acción al recuperarse:

Resultado:
```

---

# Ejemplo de sesión 7: evitar incidencias duplicadas

## Objetivo

Comprobar que una misma alerta no crea varias incidencias innecesarias.

## Escenario

La alerta permanece activa y se envían varias notificaciones de repetición.

## Actividades

1. Activar una alerta de laboratorio.
2. Observar el primer evento.
3. Esperar una repetición.
4. Revisar si se crea una nueva incidencia.
5. Comprobar el identificador utilizado.
6. Revisar la lógica del receptor.
7. Proponer un mecanismo de deduplicación.

## Claves posibles

```text
alertname + instance + service
```

o:

```text
fingerprint de la instancia de alerta
```

## Resultado esperado

Las repeticiones deben actualizar la incidencia existente o ignorarse de forma controlada, no crear una incidencia nueva para el mismo problema.

---

# Ejemplo de sesión 8: probar una alerta crítica en un sistema de guardia

## Objetivo

Comprobar el camino de una alerta crítica.

## Configuración conceptual

```text
Regla:
NodeExporterDown

Severidad:
critical

Entorno:
laboratory

Contacto:
laboratory-oncall
```

## Pasos

1. Crear el contacto de laboratorio.
2. Configurar la política de severidad crítica.
3. Confirmar el turno de prueba.
4. Activar la alerta.
5. Comprobar que llega al primer destinatario.
6. Confirmar la alerta, si la plataforma lo permite.
7. Verificar que no se activa un escalado innecesario.
8. Recuperar el servicio.
9. Comprobar el evento de resolución.
10. Documentar la prueba.

No realizar pruebas de escalado en producción sin autorización.

---

# Ejemplo de sesión 9: revisar una automatización peligrosa

## Objetivo

Identificar riesgos en una integración que ejecuta acciones automáticas.

## Situación

```text
Alerta de espacio insuficiente
    |
    v
Webhook
    |
    v
Borrado automático de archivos
```

## Preguntas

```text
¿Qué ocurre si la métrica es incorrecta?

¿Qué ocurre si el webhook se repite?

¿La acción es reversible?

¿Existe una aprobación?

¿Se registra lo que se ha borrado?

¿La alerta puede activarse por un falso positivo?

¿La automatización tiene permisos excesivos?
```

## Conclusión

Las acciones automáticas deben diseñarse con:

- Permisos mínimos.
- Límites.
- Confirmaciones.
- Registro.
- Pruebas.
- Mecanismos de recuperación.
- Revisión humana cuando el impacto sea alto.

---

# Ejemplo de sesión 10: comparar canales

## Objetivo

Elegir el canal más adecuado para diferentes situaciones.

## Situaciones

```text
1. CPU al 75 % durante dos minutos.
2. Servidor de pagos no disponible.
3. Error puntual en un entorno de laboratorio.
4. Incidencia crítica fuera del horario laboral.
5. Informe diario de alertas resueltas.
6. Creación automática de un ticket.
```

## Actividad

Asignar un canal:

| Situación | Canal recomendado | Justificación |
|---|---|---|
| CPU al 75 % durante dos minutos | | |
| Servidor de pagos no disponible | | |
| Error puntual en laboratorio | | |
| Incidencia crítica fuera de horario | | |
| Informe diario | | |
| Creación automática de ticket | | |

## Resultado esperado

El alumno debe justificar la elección según:

- Urgencia.
- Audiencia.
- Necesidad de escalado.
- Trazabilidad.
- Automatización.
- Riesgo de ruido.

---

# Diagnóstico general

## La integración no recibe nada

Comprobar:

- La regla está activa.
- La política coincide.
- El contacto es correcto.
- No existe un silencio.
- La integración está habilitada.
- El endpoint es accesible.
- La configuración se guardó.

## El canal recibe demasiados mensajes

Comprobar:

- Umbral.
- Duración.
- Agrupación.
- Repetición.
- Número de instancias.
- Severidad.
- Reglas duplicadas.

## El mensaje no tiene contexto

Comprobar:

- Anotaciones.
- Etiquetas.
- Plantillas.
- Variables.
- Enlaces.
- Nombre de la instancia.

## El sistema externo crea duplicados

Comprobar:

- Identificador de la alerta.
- Deduplificación.
- Repeticiones.
- Agrupación.
- Reintentos.
- Comportamiento del receptor.

## El canal rechaza la petición

Comprobar:

- Código HTTP.
- Autenticación.
- Permisos.
- Formato del payload.
- URL.
- Restricciones de red.
- Estado del servicio receptor.

## La alerta crítica llega a un canal incorrecto

Comprobar:

- Etiqueta `severity`.
- Etiqueta `team`.
- Etiqueta `environment`.
- Orden de las políticas.
- Política predeterminada.
- Contacto seleccionado.

---

# Seguridad y privacidad

Las notificaciones pueden contener información operativa sensible.

## Datos que deben revisarse

- Nombres de servidores.
- Direcciones IP.
- URLs internas.
- Nombres de usuarios.
- Mensajes de error.
- Información de clientes.
- Datos de aplicaciones.
- Rutas internas.
- Identificadores de incidencias.

## Recomendaciones

- Enviar solo la información necesaria.
- Utilizar canales aprobados.
- No publicar secretos.
- No incluir tokens en URLs.
- Evitar datos personales innecesarios.
- Separar canales públicos e internos.
- Revisar quién puede leer el canal.
- Aplicar cifrado en tránsito.
- Auditar integraciones.
- Rotar credenciales.

## No incluir en una alerta

```text
Contraseñas
Tokens
Claves privadas
Cookies
Credenciales de bases de datos
Contenido completo de solicitudes
Datos personales no necesarios
```

---

# Gestión de credenciales

Las integraciones pueden utilizar:

- Tokens.
- Claves API.
- Usuarios y contraseñas.
- Firmas.
- Certificados.
- Secretos compartidos.

## Buenas prácticas

- Utilizar un almacén de secretos.
- Aplicar permisos mínimos.
- Establecer caducidad.
- Rotar credenciales.
- Revocar credenciales antiguas.
- No reutilizar tokens entre entornos.
- Registrar la fecha de rotación.
- Auditar el uso.

## Documentación segura

Correcto:

```text
Contacto:
production-oncall-webhook

Credencial:
Gestionada por el almacén de secretos de producción

Última rotación:
2026-09-01

Propietario:
Equipo de operaciones
```

Incorrecto:

```text
Token:
abc123-token-real
```

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/otras-notificaciones
```

Crear una plantilla general:

```bash
cat > ~/laboratorio-grafana/evidencias/otras-notificaciones/integracion.txt <<'EOF'
Nombre de la integración:

Tipo:

Entorno:

Propietario:

Equipo destinatario:

Finalidad:

Regla asociada:

Etiquetas utilizadas:

Política asociada:

Fecha de la prueba:

Resultado:

Código HTTP, si procede:

Problemas encontrados:

Corrección:

Fecha de revisión:
EOF
```

Crear una plantilla de webhook:

```bash
cat > ~/laboratorio-grafana/evidencias/otras-notificaciones/webhook.txt <<'EOF'
Nombre del contacto:

Endpoint, sin credenciales:

Método:

Tipo de autenticación:

Código de respuesta:

Nombre de la alerta:

Estado:

Payload recibido, sin secretos:

Resultado:

Observaciones:
EOF
```

Crear una plantilla de rutas:

```bash
cat > ~/laboratorio-grafana/evidencias/otras-notificaciones/rutas.txt <<'EOF'
Severidad:

Equipo:

Entorno:

Contacto esperado:

Contacto utilizado:

Canal recibido:

Resultado:

Explicación:
EOF
```

Capturas recomendadas:

```text
01-contacto-webhook.png
02-prueba-webhook.png
03-respuesta-http.png
04-canal-colaborativo.png
05-politica-por-severidad.png
06-alerta-critical.png
07-incidencia-creada.png
08-incidencia-actualizada.png
09-alerta-resolved.png
10-rutas-documentadas.png
```

Antes de guardar capturas, ocultar:

```text
Tokens
Claves API
Contraseñas
URLs privadas
Cabeceras de autenticación
Datos personales innecesarios
```

---

# Práctica integradora

## Objetivo

Configurar varias rutas de notificación y comprobar que cada alerta utiliza el canal adecuado.

## Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Una regla de disponibilidad.
- Una regla de CPU.
- Un receptor webhook de laboratorio o canal colaborativo autorizado.
- Permisos para crear contactos y políticas.
- Entorno controlado.

---

## Tarea 1: crear contactos

Crear tres contactos:

```text
laboratory-info-channel
laboratory-warning-channel
laboratory-critical-webhook
```

Asignar:

```text
info:
Canal colaborativo de laboratorio

warning:
Canal del equipo de sistemas

critical:
Webhook de gestión de incidencias
```

---

## Tarea 2: crear políticas

Configurar las rutas:

```text
severity=info
    → laboratory-info-channel

severity=warning
    → laboratory-warning-channel

severity=critical
    → laboratory-critical-webhook
```

Añadir el entorno:

```text
environment = laboratory
```

---

## Tarea 3: preparar las reglas

### Regla de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Etiquetas:

```text
severity = warning
team = systems
environment = laboratory
resource = cpu
```

### Regla de disponibilidad

```promql
up{job="node_exporter"}
```

Condición:

```text
Igual a 0
```

Etiquetas:

```text
severity = critical
team = systems
environment = laboratory
resource = availability
```

---

## Tarea 4: probar la alerta de CPU

1. Confirmar la regla.
2. Activar una carga controlada.
3. Esperar el estado `Alerting`.
4. Comprobar el canal de advertencias.
5. Revisar el contenido.
6. Resolver la alerta.
7. Comprobar el evento de recuperación.

---

## Tarea 5: probar la alerta crítica

1. Confirmar que Node Exporter está funcionando.
2. Detener el servicio:

```bash
sudo systemctl stop node_exporter
```

3. Esperar el estado `Alerting`.
4. Comprobar el webhook o sistema de incidencias.
5. Registrar el identificador generado.
6. Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

7. Comprobar la actualización o resolución.
8. Documentar el resultado.

---

## Tarea 6: revisar las rutas

Para cada alerta, verificar:

```text
Regla:

Severidad:

Equipo:

Entorno:

Política coincidente:

Contacto seleccionado:

Canal recibido:

Resultado:

Acción de recuperación:
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Contacto informativo creado | | |
| Contacto de advertencia creado | | |
| Contacto crítico creado | | |
| Prueba del canal informativo | | |
| Prueba del canal de advertencia | | |
| Prueba del webhook crítico | | |
| Política `info` creada | | |
| Política `warning` creada | | |
| Política `critical` creada | | |
| Regla de CPU activada | | |
| Alerta de CPU llegó al canal correcto | | |
| Recuperación de CPU observada | | |
| Regla de disponibilidad activada | | |
| Incidencia creada | | |
| Incidencia actualizada o resuelta | | |
| Etiquetas verificadas | | |
| Rutas documentadas | | |
| Credenciales protegidas | | |
| Evidencias guardadas | | |

---

# Buenas prácticas

## Elegir el canal según la urgencia

No todas las alertas necesitan interrumpir a una persona de guardia.

## Mantener las rutas simples

Una ruta clara es más fácil de entender y diagnosticar.

## Evitar duplicados

No enviar la misma alerta a demasiados canales sin una razón operativa.

## Utilizar etiquetas consistentes

Las políticas dependen de las etiquetas.

## Probar los contactos individualmente

Antes de investigar una regla, comprobar que el contacto funciona.

## Probar el flujo completo

Una prueba de contacto no sustituye una prueba de regla, política y canal.

## Incluir contexto

El receptor debe saber:

- Qué ocurre.
- Dónde ocurre.
- Cuándo comenzó.
- Qué severidad tiene.
- Qué debe revisar.

## Utilizar runbooks

Un enlace a un procedimiento reduce el tiempo de respuesta.

## Configurar recuperaciones

La resolución permite confirmar que la situación ha mejorado.

## Controlar la agrupación

Agrupar reduce el ruido, pero no debe ocultar recursos afectados.

## Proteger los secretos

Nunca incluir tokens ni claves en capturas o documentos.

## Revisar integraciones externas

Los servicios cambian sus APIs, permisos y formatos.

## Documentar propietarios

Cada integración debe tener una persona o equipo responsable.

## Revisar contactos obsoletos

Eliminar endpoints retirados y rotar credenciales antiguas.

## No automatizar acciones destructivas sin control

Toda automatización debe ser reversible, auditable y limitada.

---

# Errores frecuentes

## La alerta no llega al canal esperado

Comprobar:

- Etiquetas.
- Política.
- Orden de las políticas.
- Contacto.
- Entorno.
- Silenciamientos.
- Agrupación.

## El webhook devuelve `401`

Comprobar:

- Token.
- Cabecera.
- Permisos.
- Caducidad.
- Método de autenticación.

## El webhook devuelve `404`

Comprobar:

- URL.
- Ruta.
- Entorno.
- Servicio receptor.
- Versión de la API.

## El webhook devuelve `429`

Comprobar:

- Límite de peticiones.
- Repeticiones.
- Número de alertas.
- Agrupación.
- Capacidad del receptor.

## El webhook devuelve `500`

Comprobar:

- Logs del receptor.
- Formato del payload.
- Campos obligatorios.
- Dependencias externas.
- Estado del servicio.

## Se crean incidencias duplicadas

Comprobar:

- Identificador de deduplicación.
- Reintentos.
- Repeticiones.
- Agrupación.
- Lógica del receptor.

## El mensaje contiene datos sensibles

Comprobar:

- Anotaciones.
- Plantillas.
- Etiquetas.
- Logs.
- Datos incluidos por defecto.
- Permisos del canal.

## El sistema de guardia genera demasiado ruido

Comprobar:

- Severidades.
- Duraciones.
- Umbrales.
- Alertas duplicadas.
- Reglas no accionables.
- Agrupación.

## La incidencia no se actualiza al recuperarse

Comprobar:

- Identificador de la alerta.
- Estado `resolved`.
- Permisos de actualización.
- Endpoint de recuperación.
- Lógica del sistema ITSM.

---

# Puntos clave

- Grafana puede enviar alertas mediante canales distintos del correo.
- Los webhooks permiten integrar Grafana con aplicaciones externas.
- Los canales colaborativos facilitan la comunicación del equipo.
- Los sistemas de guardia están destinados principalmente a incidentes urgentes.
- Los sistemas ITSM proporcionan trazabilidad y gestión formal.
- La política de notificación decide qué contacto se utiliza.
- Las etiquetas son fundamentales para enrutar alertas.
- Un webhook debe utilizar HTTPS y autenticación.
- Las credenciales deben almacenarse de forma segura.
- Los códigos HTTP ayudan a diagnosticar fallos de integración.
- Un `401` suele indicar un problema de autenticación.
- Un `404` suele indicar una URL o ruta incorrecta.
- Un `429` suele indicar demasiadas peticiones.
- Un `5xx` suele indicar un problema en el receptor.
- Los sistemas de incidencias deben evitar duplicados.
- Las notificaciones de recuperación permiten actualizar el estado del incidente.
- Las alertas críticas no deben mezclarse con avisos informativos.
- El sistema de guardia no debe recibir alertas que no requieran intervención urgente.
- Los canales colaborativos pueden generar ruido si no se controlan.
- Las integraciones automáticas deben limitar sus permisos.
- Las acciones destructivas requieren controles adicionales.
- El payload debe incluir información útil, pero no secretos.
- Los contactos de laboratorio y producción deben estar separados.
- Toda integración debe probarse, documentarse y revisarse periódicamente.
- La elección del canal debe basarse en la acción que se espera del destinatario.

---

# Preguntas de comprobación

1. ¿Por qué puede ser necesario utilizar varios canales de notificación?
2. ¿Qué es un webhook?
3. ¿Qué diferencia existe entre un webhook y un correo electrónico?
4. ¿Cuándo utilizarías un canal colaborativo?
5. ¿Cuándo utilizarías un sistema de guardia?
6. ¿Cuándo utilizarías un sistema de gestión de incidencias?
7. ¿Qué significa una respuesta HTTP `401`?
8. ¿Qué significa una respuesta HTTP `404`?
9. ¿Qué significa una respuesta HTTP `429`?
10. ¿Qué puede indicar un error HTTP `500`?
11. ¿Cómo evitarías crear incidencias duplicadas?
12. ¿Qué etiquetas utilizarías para enrutar alertas por severidad?
13. ¿Qué diferencia existe entre una alerta activa y una incidencia creada?
14. ¿Qué información debería incluir un payload?
15. ¿Qué información no debe incluirse en un payload?
16. ¿Por qué es importante utilizar HTTPS?
17. ¿Qué revisarías si una alerta llega a un canal incorrecto?
18. ¿Qué ventajas tiene una notificación de recuperación?
19. ¿Qué riesgos tiene enviar demasiadas alertas a un sistema de guardia?
20. ¿Cómo probarías un webhook?
21. ¿Cómo comprobarías que un sistema ITSM actualiza una incidencia?
22. ¿Qué controles aplicarías antes de automatizar una acción?
23. ¿Por qué deben separarse los contactos de laboratorio y producción?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener una integración de notificación segura y mantenible?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de seleccionar, configurar y probar diferentes canales de notificación.

El flujo final será:

```text
Clasificar la alerta
      |
      v
Asignar etiquetas
      |
      v
Seleccionar la política
      |
      v
Elegir el contacto
      |
      v
Probar la integración
      |
      v
Activar una alerta de laboratorio
      |
      v
Comprobar la entrega
      |
      v
Comprobar la recuperación
      |
      v
Revisar errores y duplicados
      |
      v
Documentar el resultado
```

Una integración está correctamente configurada cuando:

- Utiliza el canal adecuado para la severidad.
- La política coincide con las etiquetas.
- El contacto puede entregar mensajes.
- El receptor autentica correctamente la petición.
- El payload contiene información suficiente.
- No se exponen secretos.
- Las alertas se deduplican correctamente.
- Las recuperaciones se procesan de forma adecuada.
- Las incidencias se actualizan cuando corresponde.
- Las acciones automáticas tienen controles.
- El propietario y el procedimiento están documentados.

La mejor integración no es la que envía más mensajes. Es la que entrega la información adecuada, al equipo adecuado, por el canal adecuado y en el momento en que puede convertirse en una acción útil.