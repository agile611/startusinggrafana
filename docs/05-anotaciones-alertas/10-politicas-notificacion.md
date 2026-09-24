# Políticas de notificación

Las **políticas de notificación** determinan cómo se enrutan las alertas hacia los contactos adecuados.

Una regla de alerta detecta una condición. Un contacto define un destino. La política conecta ambos elementos mediante etiquetas y decide:

- Qué alertas se envían.
- A qué contacto se envían.
- Cómo se agrupan.
- Cuándo se envían.
- Cuándo se repiten.
- Cómo se gestionan las recuperaciones.
- Qué ocurre cuando ninguna política coincide.

El flujo completo es:

```text
Regla de alerta
      |
      v
Etiquetas
      |
      v
Coincidencia con una política
      |
      v
Contacto de notificación
      |
      v
Agrupación y temporización
      |
      v
Mensaje enviado
```

Ejemplo:

```text
Regla:
HighCPUUsage

Etiquetas:
severity=warning
team=systems
environment=production

Política coincidente:
team=systems
environment=production

Contacto:
systems-production-email

Resultado:
La alerta se envía al equipo de sistemas.
```

Las opciones y nombres de la interfaz pueden variar según la versión de Grafana, pero los conceptos de etiquetas, rutas, contactos, agrupación y temporización son comunes al modelo de alertas unificadas.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es una política de notificación.
- Diferenciar una regla, una etiqueta, una política y un contacto.
- Comprender el funcionamiento de una ruta de notificación.
- Crear una política basada en etiquetas.
- Configurar políticas para distintos equipos.
- Configurar políticas según la severidad.
- Configurar políticas según el entorno.
- Configurar una política para un servicio concreto.
- Comprender el uso de políticas anidadas.
- Utilizar coincidencias exactas.
- Utilizar coincidencias por expresión regular cuando sea necesario.
- Configurar un contacto predeterminado.
- Comprender el comportamiento de una alerta sin coincidencia.
- Configurar la agrupación de alertas.
- Comprender `group_by`.
- Configurar tiempos de espera y repetición.
- Probar el enrutamiento de una alerta.
- Diagnosticar una alerta enviada al contacto incorrecto.
- Diagnosticar una alerta que no genera notificación.
- Evitar rutas ambiguas o solapadas.
- Documentar una política de notificación.
- Diseñar una estructura de políticas mantenible.

---

# Introducción

En una plataforma de monitorización, no todas las alertas deben llegar al mismo destinatario.

Por ejemplo:

```text
Alertas de infraestructura
    → equipo de sistemas

Alertas de aplicaciones
    → equipo de desarrollo

Alertas críticas de producción
    → equipo de guardia

Alertas de laboratorio
    → contacto de formación
```

Una política de notificación permite expresar estas reglas de enrutamiento.

## Ejemplo de clasificación

```text
severity = info
    → canal de observabilidad

severity = warning
    → equipo responsable

severity = critical
    → sistema de guardia
```

La política no evalúa directamente la métrica. La consulta y la regla ya han determinado que existe una alerta.

La política recibe una alerta con etiquetas como:

```text
alertname = HighCPUUsage
severity = warning
team = systems
service = node_exporter
environment = production
```

A continuación, busca una ruta que coincida con esas etiquetas.

---

# Componentes del enrutamiento

Una política suele incluir los siguientes componentes:

```text
Política raíz
      |
      v
Rutas o políticas hijas
      |
      v
Coincidencias por etiquetas
      |
      v
Contacto de notificación
      |
      v
Agrupación
      |
      v
Temporización
```

## Política raíz

Es el punto de entrada del árbol de notificaciones.

Puede definir:

- Contacto predeterminado.
- Configuración general.
- Rutas generales.
- Comportamiento para alertas sin coincidencia.

## Ruta o política hija

Es una regla más específica dentro del árbol.

Ejemplo:

```text
Si team=systems
    → contacto-systems
```

## Coincidencia

Define qué etiquetas debe tener una alerta para utilizar una ruta.

Ejemplo:

```text
team = systems
```

## Contacto

Define el destino final:

```text
systems@example.com
```

## Agrupación

Determina qué alertas se envían juntas.

Ejemplo:

```text
Agrupar por:
alertname
instance
```

## Temporización

Determina cuándo se envía la notificación y cuándo se repite.

---

# Regla, etiqueta, política y contacto

| Elemento | Función | Ejemplo |
|---|---|---|
| Regla | Detecta una condición | CPU mayor que 90 % |
| Etiqueta | Clasifica la alerta | `team=systems` |
| Política | Decide la ruta | Alertas del equipo de sistemas |
| Contacto | Define el destinatario | `systems@example.com` |
| Notificación | Mensaje enviado | Correo de CPU elevada |

## Ejemplo completo

### Regla

```text
HighCPUUsage
```

### Etiquetas

```text
severity = warning
team = systems
environment = laboratory
```

### Política

```text
team = systems
environment = laboratory
```

### Contacto

```text
laboratory-systems-email
```

### Resultado

```text
La alerta se entrega al contacto de laboratorio del equipo de sistemas.
```

---

# Etiquetas utilizadas en las políticas

Las etiquetas son la base del enrutamiento.

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
notification
```

## Ejemplo

```text
alertname = NodeExporterDown
severity = critical
team = systems
service = node_exporter
environment = production
resource = availability
instance = server-01:9100
```

## Convenciones

Es recomendable utilizar valores consistentes:

```text
severity = info
severity = warning
severity = critical
```

Evitar variaciones como:

```text
severity = warn
severity = WARNING
severity = high
severity = importante
```

Una convención común facilita:

- Las políticas.
- Las búsquedas.
- Los dashboards.
- Las notificaciones.
- La documentación.
- El mantenimiento.

---

# Coincidencias de etiquetas

Una política puede coincidir utilizando diferentes operadores.

## Igualdad

```text
team = systems
```

La ruta coincide cuando la etiqueta `team` tiene exactamente el valor `systems`.

## Desigualdad

```text
environment != laboratory
```

La ruta coincide cuando el entorno no es `laboratory`.

Debe utilizarse con cuidado, porque puede incluir más alertas de las esperadas.

## Expresión regular

Ejemplo conceptual:

```text
service =~ api|frontend
```

Coincide con servicios cuyo valor sea `api` o `frontend`.

## Negación mediante expresión regular

Ejemplo conceptual:

```text
service !~ test-.*
```

Excluye servicios cuyo nombre empiece por `test-`.

La sintaxis concreta depende de la versión y de la interfaz de Grafana.

## Recomendación

Preferir coincidencias simples y explícitas:

```text
team = systems
environment = production
```

Utilizar expresiones regulares solo cuando aporten una ventaja clara.

---

# Coincidencias múltiples

Una ruta puede utilizar varias etiquetas.

Ejemplo:

```text
team = systems
severity = critical
environment = production
```

La alerta debe cumplir todas las condiciones para coincidir con la ruta.

## Ejemplo

Alerta:

```text
team = systems
severity = critical
environment = production
```

Resultado:

```text
Coincide con:
team=systems
severity=critical
environment=production
```

Otra alerta:

```text
team = systems
severity = warning
environment = production
```

Resultado:

```text
No coincide con la política crítica.
```

Puede coincidir con una política general de advertencias.

---

# Política raíz y rutas hijas

Una estructura habitual es:

```text
Política raíz
├── Producción
│   ├── Críticas
│   └── Advertencias
├── Laboratorio
└── Aplicaciones
```

## Ejemplo conceptual

```text
Política raíz
Contacto predeterminado: default-email

├── environment=production
│   ├── severity=critical
│   │   └── production-oncall
│   └── severity=warning
│       └── production-team-email
│
├── environment=laboratory
│   └── laboratory-email
│
└── team=application
    └── application-team-email
```

La estructura exacta debe probarse para confirmar cómo se comporta la evaluación de rutas en la versión instalada.

---

# Orden y especificidad de las políticas

Cuando existen varias rutas, es importante evitar ambigüedades.

## Rutas generales y específicas

Ruta general:

```text
team = systems
```

Ruta específica:

```text
team = systems
severity = critical
environment = production
```

La ruta específica debe evaluarse de forma que las alertas críticas de producción no terminen únicamente en la ruta general.

## Recomendación

Organizar las rutas desde las condiciones más específicas hasta las más generales:

```text
1. environment=production, severity=critical
2. environment=production, severity=warning
3. team=systems
4. contacto predeterminado
```

La interfaz puede ofrecer opciones como:

- Continuar evaluando otras rutas.
- Detenerse tras la primera coincidencia.
- Utilizar una ruta predeterminada.
- Evaluar políticas anidadas.

Estas opciones deben comprenderse y probarse antes de utilizarlas.

---

# Política predeterminada

La política predeterminada se utiliza cuando una alerta no coincide con una ruta específica.

## Ejemplo

```text
Política predeterminada:
default-observability-email
```

Una alerta con estas etiquetas:

```text
alertname = UnknownAlert
team = unknown
environment = laboratory
```

podría utilizar el contacto predeterminado.

## Buenas prácticas

El contacto predeterminado debería:

- Ser supervisado.
- Permitir detectar errores de clasificación.
- No ser un canal de guardia salvo que esté justificado.
- Estar documentado.
- Tener un destinatario responsable.

## Riesgo

Si la política predeterminada es demasiado amplia, puede ocultar problemas de diseño.

Por ejemplo:

```text
Todas las alertas desconocidas → equipo de guardia
```

Esto puede generar ruido y fatiga.

---

# Alertas sin coincidencia

Una alerta puede no coincidir con ninguna política específica.

Posibles comportamientos:

- Se envía al contacto predeterminado.
- Se continúa con otra ruta.
- No se genera el resultado esperado.
- Se envía a un contacto incorrecto.
- Se produce un error de configuración.

## Diagnóstico

1. Revisar las etiquetas de la alerta.
2. Revisar los nombres de las etiquetas.
3. Revisar los valores.
4. Revisar la política raíz.
5. Revisar las rutas hijas.
6. Comprobar el contacto predeterminado.
7. Probar con una alerta de laboratorio.

---

# Enrutamiento por equipo

## Objetivo

Enviar las alertas al equipo responsable.

### Etiquetas

```text
team = systems
```

### Política

```text
Coincidencia:
team=systems

Contacto:
systems-email
```

### Otro equipo

```text
team = application
```

### Política

```text
Coincidencia:
team=application

Contacto:
application-email
```

## Ventajas

- Responsabilidad clara.
- Menos mensajes irrelevantes.
- Mejor distribución del trabajo.
- Facilita la investigación.

## Riesgo

Si una alerta no tiene la etiqueta `team`, puede utilizar el contacto predeterminado o una ruta incorrecta.

---

# Enrutamiento por severidad

## Ejemplo

```text
severity = info
    → observability-channel

severity = warning
    → responsible-team-email

severity = critical
    → on-call-system
```

## Criterio operativo

| Severidad | Significado | Contacto habitual |
|---|---|---|
| `info` | Información | Canal o resumen |
| `warning` | Revisión necesaria | Equipo responsable |
| `critical` | Intervención urgente | Guardia o escalado |

La organización debe definir qué significa cada nivel.

No se debe marcar todo como `critical`, porque se perdería la capacidad de priorización.

---

# Enrutamiento por entorno

## Etiquetas

```text
environment = laboratory
environment = staging
environment = production
```

## Ejemplo

```text
environment= laboratory
    → laboratory-email

environment=staging
    → staging-team-email

environment=production
    → production-oncall
```

## Importancia

Separar los entornos evita:

- Enviar pruebas a producción.
- Despertar a la guardia por problemas de laboratorio.
- Mezclar datos de varios entornos.
- Confundir prioridades.
- Generar incidencias incorrectas.

---

# Enrutamiento por servicio

## Ejemplo

```text
service = payments
    → payments-oncall

service = api
    → application-team

service = database
    → database-team
```

## Recomendación

Utilizar nombres de servicio estables y documentados.

Evitar valores ambiguos:

```text
service = backend
service = app
service = service1
```

Preferir nombres reconocibles:

```text
service = payments-api
service = customer-portal
service = postgresql
```

---

# Enrutamiento por combinación de etiquetas

Una política puede usar varias dimensiones.

## Ejemplo

```text
team = application
service = payments
severity = critical
environment = production
```

Resultado:

```text
payments-production-oncall
```

Esto permite crear rutas muy precisas, pero aumenta la complejidad.

## Recomendación

Crear políticas específicas solo cuando exista una necesidad operativa clara.

Una estructura excesivamente compleja puede provocar:

- Dificultad de diagnóstico.
- Rutas duplicadas.
- Alertas sin coincidencia.
- Mantenimiento costoso.
- Errores de prioridad.

---

# Agrupación de alertas

La agrupación permite enviar varias alertas en un mismo mensaje.

## Ejemplo sin agrupación

```text
Mensaje 1:
CPU elevada en server-01

Mensaje 2:
CPU elevada en server-02

Mensaje 3:
CPU elevada en server-03
```

## Ejemplo agrupado

```text
CPU elevada en varias instancias:

- server-01
- server-02
- server-03
```

## Ventajas

- Reduce el ruido.
- Facilita identificar incidentes comunes.
- Evita saturar los canales.
- Mejora la lectura de problemas relacionados.

## Riesgos

- Puede ocultar una instancia importante.
- Puede retrasar el primer aviso.
- Puede agrupar alertas no relacionadas.
- Puede dificultar el seguimiento individual.

---

# `group_by`

`group_by` define las etiquetas utilizadas para agrupar alertas.

## Agrupar por alerta

```text
group_by:
- alertname
```

Todas las instancias de la misma alerta se agrupan.

## Agrupar por alerta e instancia

```text
group_by:
- alertname
- instance
```

Cada instancia mantiene su propio grupo.

## Agrupar por equipo y severidad

```text
group_by:
- team
- severity
```

Las alertas del mismo equipo y severidad se agrupan.

## Elegir la agrupación

| Objetivo | Agrupación posible |
|---|---|
| Un mensaje por tipo de alerta | `alertname` |
| Un mensaje por recurso | `alertname`, `instance` |
| Un mensaje por equipo | `team` |
| Separar prioridades | `team`, `severity` |
| Separar entornos | `environment`, `severity` |

Las etiquetas elegidas deben conservar la información necesaria para actuar.

---

# Tiempos de notificación

Las políticas pueden incluir varios tiempos.

## `group_wait`

Tiempo que Grafana espera antes de enviar el primer mensaje de un grupo.

Objetivo:

- Dar tiempo a que lleguen alertas relacionadas.
- Evitar mensajes separados para eventos simultáneos.

Ejemplo:

```text
group_wait = 30 segundos
```

## `group_interval`

Tiempo mínimo antes de enviar una actualización de un grupo existente.

Objetivo:

- Agrupar cambios adicionales.
- Reducir mensajes repetidos.

Ejemplo:

```text
group_interval = 5 minutos
```

## `repeat_interval`

Tiempo después del cual se puede repetir una alerta que continúa activa.

Objetivo:

- Recordar un problema no resuelto.
- Evitar que una alerta crítica desaparezca del radar.

Ejemplo:

```text
repeat_interval = 4 horas
```

Los valores adecuados dependen de la urgencia y del canal.

---

# Ejemplo de temporización

Configuración:

```text
group_wait = 30 segundos
group_interval = 5 minutos
repeat_interval = 4 horas
```

Secuencia:

```text
10:00:00 - Primera alerta activa
10:00:30 - Se envía el primer mensaje
10:02:00 - Llega otra alerta del mismo grupo
10:05:00 - Se envía una actualización agrupada
14:00:00 - Se repite el aviso si sigue activa
```

La secuencia exacta puede variar según la configuración y el estado del grupo.

---

# Elegir los tiempos

## Alertas críticas

Pueden utilizar:

```text
group_wait corto
group_interval corto
repeat_interval moderado
```

Ejemplo:

```text
group_wait = 10 segundos
group_interval = 1 minuto
repeat_interval = 30 minutos
```

## Alertas de advertencia

Pueden utilizar:

```text
group_wait moderado
group_interval moderado
repeat_interval largo
```

Ejemplo:

```text
group_wait = 1 minuto
group_interval = 10 minutos
repeat_interval = 4 horas
```

## Alertas informativas

Pueden utilizar:

```text
group_wait largo
group_interval largo
repeat_interval amplio
```

O incluso no repetirse.

La configuración debe probarse para evitar tanto el silencio excesivo como la saturación.

---

# Recuperaciones en las políticas

Las políticas pueden incluir notificaciones cuando una alerta se resuelve.

## Secuencia

```text
Normal
   |
   v
Alerting
   |
   v
Notificación de activación
   |
   v
Normal
   |
   v
Notificación de recuperación
```

## Comprobar

```text
¿La recuperación llega al mismo contacto?

¿La recuperación se agrupa?

¿La recuperación se envía siempre?

¿El sistema ITSM actualiza la incidencia?

¿El canal diferencia FIRING y RESOLVED?
```

La configuración exacta depende de la versión y de la integración.

---

# Políticas para laboratorio y producción

## Ejemplo de árbol

```text
Política raíz
├── environment=laboratory
│   └── laboratory-email
│
├── environment=staging
│   └── staging-team-email
│
└── environment=production
    ├── severity=critical
    │   └── production-oncall
    └── severity=warning
        └── production-team-email
```

## Recomendaciones

- Separar completamente los contactos.
- Añadir siempre la etiqueta `environment`.
- Incluir el entorno en el asunto.
- Probar las rutas en laboratorio.
- No reutilizar contactos de producción para ejercicios.
- Revisar las políticas después de cada cambio.

---

# Ejemplo completo de políticas

## Contactos

```text
laboratory-email
systems-warning-email
production-oncall
application-team-email
```

## Política raíz

```text
Contacto predeterminado:
laboratory-email
```

## Ruta de producción crítica

```text
environment = production
severity = critical

Contacto:
production-oncall
```

## Ruta de sistemas

```text
team = systems
severity = warning

Contacto:
systems-warning-email
```

## Ruta de aplicaciones

```text
team = application

Contacto:
application-team-email
```

## Tabla de resultados

| Etiquetas de la alerta | Contacto esperado |
|---|---|
| `environment=production`, `severity=critical` | `production-oncall` |
| `team=systems`, `severity=warning` | `systems-warning-email` |
| `team=application` | `application-team-email` |
| Sin coincidencia | `laboratory-email` |

El orden y el comportamiento de las rutas deben verificarse en el entorno de Grafana utilizado.

---

# Ejemplo de política para disponibilidad

## Regla

```text
NodeExporterDown
```

## Etiquetas

```text
severity = critical
team = systems
service = node_exporter
environment = production
resource = availability
```

## Política

```text
environment = production
severity = critical
team = systems
```

## Contacto

```text
production-oncall
```

## Resultado

```text
La caída de Node Exporter en producción
se envía al sistema de guardia.
```

---

# Ejemplo de política para CPU

## Regla

```text
HighCPUUsage
```

## Etiquetas

```text
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

## Política

```text
environment = laboratory
team = systems
```

## Contacto

```text
laboratory-email
```

## Resultado

```text
La alerta de CPU del laboratorio
se envía al contacto de formación.
```

---

# Ejemplo de sesión 1: crear una política por equipo

## Objetivo

Enviar las alertas del equipo de sistemas a un contacto concreto.

## Contacto

```text
systems-laboratory-email
```

## Etiqueta de la regla

```text
team = systems
```

## Pasos

1. Crear o revisar el contacto.
2. Acceder a la sección de políticas.
3. Crear una ruta.
4. Añadir la coincidencia:

```text
team = systems
```

5. Seleccionar el contacto.
6. Guardar.
7. Crear o utilizar una alerta con la etiqueta `team=systems`.
8. Activar la alerta en laboratorio.
9. Comprobar el contacto que recibe la notificación.
10. Documentar el resultado.

## Registro

```text
Regla:

Etiquetas:

Política:

Contacto esperado:

Contacto utilizado:

Resultado:

Observaciones:
```

---

# Ejemplo de sesión 2: enrutar por severidad

## Objetivo

Enviar alertas `warning` y `critical` a destinos diferentes.

## Contactos

```text
laboratory-warning
laboratory-critical
```

## Rutas

```text
severity = warning
    → laboratory-warning

severity = critical
    → laboratory-critical
```

## Pasos

1. Crear los contactos.
2. Probar cada contacto.
3. Crear la ruta `warning`.
4. Crear la ruta `critical`.
5. Crear una alerta de prueba con:

```text
severity = warning
```

6. Activarla.
7. Comprobar el destinatario.
8. Cambiar la severidad a:

```text
severity = critical
```

9. Repetir la prueba.
10. Comparar los resultados.

## Tabla

| Severidad | Contacto esperado | Contacto recibido | Resultado |
|---|---|---|---|
| `warning` | | | |
| `critical` | | | |

---

# Ejemplo de sesión 3: enrutar por entorno

## Objetivo

Evitar que una alerta de laboratorio llegue a producción.

## Contactos

```text
laboratory-email
production-oncall
```

## Rutas

```text
environment = laboratory
    → laboratory-email

environment = production
    → production-oncall
```

## Pasos

1. Crear los contactos.
2. Crear las rutas.
3. Crear una alerta con:

```text
environment = laboratory
```

4. Activarla.
5. Confirmar el contacto de laboratorio.
6. Cambiar el valor a:

```text
environment = production
```

7. Repetir la prueba utilizando el procedimiento autorizado.
8. Confirmar el contacto de producción.
9. Revisar que nunca se mezclan los destinos.

## Resultado esperado

```text
laboratory → laboratory-email
production → production-oncall
```

---

# Ejemplo de sesión 4: probar una política sin coincidencia

## Objetivo

Observar qué ocurre cuando ninguna ruta específica coincide.

## Preparación

Crear un contacto predeterminado:

```text
default-observability
```

Crear una regla con etiquetas que no coincidan:

```text
team = unknown
environment = laboratory
```

## Pasos

1. Revisar las rutas existentes.
2. Confirmar que `team=unknown` no coincide.
3. Activar la regla.
4. Comprobar el contacto utilizado.
5. Revisar si se utilizó el contacto predeterminado.
6. Documentar el resultado.
7. Añadir una ruta específica.
8. Repetir la prueba.

## Registro

```text
Etiquetas:

Rutas existentes:

Contacto predeterminado:

Contacto utilizado inicialmente:

Nueva ruta:

Contacto utilizado después:

Conclusión:
```

---

# Ejemplo de sesión 5: probar la agrupación

## Objetivo

Observar cómo se agrupan varias alertas.

## Preparación

Crear una regla multidimensional de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configurar:

```text
group_by:
- alertname
```

## Pasos

1. Activar la alerta en varias instancias.
2. Observar la lista de alertas.
3. Revisar el mensaje recibido.
4. Confirmar que las instancias aparecen agrupadas.
5. Cambiar la agrupación a:

```text
alertname
instance
```

6. Repetir la prueba.
7. Comparar el número y el contenido de los mensajes.

## Preguntas

```text
¿Cuántos mensajes se recibieron?

¿Aparecen todas las instancias?

¿Qué configuración reduce más el ruido?

¿Qué configuración facilita investigar una instancia concreta?
```

---

# Ejemplo de sesión 6: probar los tiempos de agrupación

## Objetivo

Comprender `group_wait`, `group_interval` y `repeat_interval`.

## Configuración de laboratorio

```text
group_wait = 10 segundos
group_interval = 1 minuto
repeat_interval = 5 minutos
```

## Pasos

1. Activar una alerta.
2. Registrar la hora de activación.
3. Registrar la hora del primer mensaje.
4. Activar una segunda alerta del mismo grupo.
5. Registrar la hora de la actualización.
6. Mantener la primera alerta activa.
7. Esperar una repetición.
8. Registrar el resultado.
9. Resolver las alertas.
10. Comprobar la recuperación.

## Registro

```text
Hora de activación:

Hora del primer mensaje:

Hora de la segunda alerta:

Hora de la actualización:

Hora de la repetición:

Hora de recuperación:

Observaciones:
```

Para una práctica real, utilizar tiempos breves únicamente en laboratorio.

---

# Ejemplo de sesión 7: diagnosticar una alerta enviada al contacto incorrecto

## Objetivo

Investigar un error de enrutamiento.

## Situación

```text
Una alerta de producción llega al contacto de laboratorio.
```

## Procedimiento

1. Revisar las etiquetas de la alerta.
2. Confirmar el valor de `environment`.
3. Revisar el orden de las rutas.
4. Revisar la política predeterminada.
5. Comprobar si existe una ruta demasiado general.
6. Comprobar si una ruta específica se está evaluando.
7. Revisar el contacto utilizado.
8. Corregir la política.
9. Repetir la prueba.
10. Documentar la causa.

## Posibles causas

```text
Falta la etiqueta environment.
El valor es production-env en lugar de production.
La ruta de laboratorio es demasiado general.
La ruta crítica no se evalúa.
El contacto predeterminado está mal configurado.
El orden de las políticas es incorrecto.
```

---

# Ejemplo de sesión 8: probar una ruta de recuperación

## Objetivo

Comprobar cómo se gestiona una alerta que vuelve a estado normal.

## Regla

```text
NodeExporterDown
```

## Etiquetas

```text
severity = critical
team = systems
environment = laboratory
```

## Pasos

1. Configurar la política.
2. Activar la alerta.
3. Confirmar la notificación.
4. Recuperar el servicio.
5. Confirmar el cambio a `Normal`.
6. Revisar el contacto utilizado para la recuperación.
7. Comprobar si el sistema externo actualiza el evento.
8. Documentar el resultado.

## Registro

```text
Contacto de activación:

Contacto de recuperación:

Mensaje de activación:

Mensaje de recuperación:

Resultado:
```

---

# Ejemplo de sesión 9: revisar rutas solapadas

## Objetivo

Identificar políticas que pueden coincidir con la misma alerta.

## Rutas

```text
Ruta A:
team = systems

Ruta B:
team = systems
severity = critical

Ruta C:
environment = production
```

## Alerta

```text
team = systems
severity = critical
environment = production
```

La alerta puede coincidir con varias rutas.

## Actividades

1. Dibujar el árbol de políticas.
2. Identificar todas las coincidencias.
3. Revisar el comportamiento configurado.
4. Confirmar si se envía un solo mensaje o varios.
5. Ajustar la estructura si es necesario.
6. Repetir la prueba.
7. Documentar la decisión.

---

# Ejemplo de sesión 10: diseñar una política completa

## Objetivo

Diseñar un árbol de políticas para una organización pequeña.

## Requisitos

- Alertas de laboratorio.
- Alertas de staging.
- Alertas de producción.
- Dos equipos.
- Dos severidades.

## Propuesta

```text
Política raíz
├── environment=laboratory
│   └── laboratory-email
│
├── environment=staging
│   └── staging-email
│
└── environment=production
    ├── team=systems
    │   ├── severity=critical
    │   │   └── systems-oncall
    │   └── severity=warning
    │       └── systems-email
    │
    └── team=application
        ├── severity=critical
        │   └── application-oncall
        └── severity=warning
            └── application-email
```

## Actividad

Crear una tabla con las combinaciones:

| Entorno | Equipo | Severidad | Contacto |
|---|---|---|---|
| laboratory | systems | warning | |
| staging | application | warning | |
| production | systems | critical | |
| production | application | critical | |

---

# Diagnóstico de políticas

## La alerta no llega

Comprobar:

- La regla está activa.
- Las etiquetas existen.
- Los nombres de las etiquetas son correctos.
- La política coincide.
- El contacto funciona.
- No hay silenciamientos.
- La política no está deshabilitada.
- La agrupación no ha retrasado el mensaje.

## La alerta llega al contacto predeterminado

Comprobar:

- La etiqueta esperada existe.
- El valor coincide exactamente.
- La ruta está guardada.
- La ruta pertenece al árbol correcto.
- La expresión regular es válida.
- No existe una ruta más específica o más general que cambie el resultado.

## La alerta llega a varios contactos

Comprobar:

- Rutas solapadas.
- Evaluación de políticas hermanas.
- Opción de continuar evaluando.
- Contactos duplicados.
- Políticas heredadas.
- Agrupación y repetición.

## Se reciben demasiados mensajes

Comprobar:

- `group_by`.
- `group_wait`.
- `group_interval`.
- `repeat_interval`.
- Número de instancias.
- Umbrales de las reglas.
- Reglas duplicadas.
- Severidades mal asignadas.

## La alerta crítica no llega a la guardia

Comprobar:

- `severity=critical`.
- `environment=production`.
- `team` correcto.
- Ruta crítica.
- Contacto de guardia.
- Prueba independiente del contacto.
- Silenciamientos.
- Errores de la integración.

---

# Buenas prácticas

## Diseñar las políticas antes de crearlas

Representar el árbol en papel o en un diagrama:

```text
Raíz
├── Laboratorio
├── Staging
└── Producción
    ├── Sistemas
    └── Aplicaciones
```

## Utilizar etiquetas estables

Las etiquetas deben tener significado operativo y mantenerse en el tiempo.

## Evitar rutas excesivamente complejas

Cada nueva condición aumenta la dificultad de diagnóstico.

## Mantener una política predeterminada segura

Debe permitir detectar alertas mal clasificadas sin generar una interrupción innecesaria.

## Separar los entornos

Nunca depender únicamente del nombre de la alerta para distinguir laboratorio y producción.

## Definir la severidad con criterios claros

Una severidad debe indicar una acción o prioridad concreta.

## Probar las rutas con alertas reales de laboratorio

No asumir que una política funciona solo porque se ha guardado.

## Probar coincidencias y no coincidencias

Ambos casos son importantes.

## Probar agrupación y repetición

Una ruta correcta puede seguir produciendo demasiados mensajes.

## Documentar la finalidad de cada ruta

Ejemplo:

```text
Ruta:
environment=production, severity=critical

Finalidad:
Enviar incidentes críticos de producción al equipo de guardia.
```

## Revisar periódicamente

Comprobar:

- Contactos.
- Destinatarios.
- Equipos.
- Servicios.
- Etiquetas.
- Rutas.
- Silenciamientos.
- Tiempos.
- Integraciones retiradas.

## Aplicar cambios controlados

Las modificaciones de políticas pueden afectar a la respuesta ante incidentes.

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/politicas-notificacion
```

Crear una plantilla de política:

```bash
cat > ~/laboratorio-grafana/evidencias/politicas-notificacion/politica.txt <<'EOF'
Nombre o descripción de la política:

Finalidad:

Ruta:

Etiquetas de coincidencia:

Contacto:

Entorno:

Severidad:

Agrupación:

group_wait:

group_interval:

repeat_interval:

Comportamiento para recuperaciones:

Contacto predeterminado:

Fecha de creación:

Responsable:

Última prueba:

Resultado:

Observaciones:
EOF
```

Crear una tabla de rutas:

```bash
cat > ~/laboratorio-grafana/evidencias/politicas-notificacion/rutas.txt <<'EOF'
Ruta 1:
Coincidencia:
Contacto:
Resultado:

Ruta 2:
Coincidencia:
Contacto:
Resultado:

Ruta 3:
Coincidencia:
Contacto:
Resultado:

Ruta predeterminada:
Contacto:
Resultado:
EOF
```

Crear una plantilla de prueba:

```bash
cat > ~/laboratorio-grafana/evidencias/politicas-notificacion/prueba.txt <<'EOF'
Regla:

Estado inicial:

Etiquetas:

Política esperada:

Contacto esperado:

Contacto utilizado:

Hora de activación:

Hora de recepción:

Hora de recuperación:

Resultado:

Problemas:

Corrección:
EOF
```

Capturas recomendadas:

```text
01-arbol-politicas.png
02-politica-por-equipo.png
03-politica-por-severidad.png
04-politica-por-entorno.png
05-contacto-predeterminado.png
06-configuracion-group-by.png
07-configuracion-temporizacion.png
08-alerta-enrutada.png
09-alerta-sin-coincidencia.png
10-prueba-recuperacion.png
11-tabla-rutas.png
12-politica-documentada.png
```

---

# Práctica integradora

## Objetivo

Diseñar, configurar y probar un árbol de políticas para varios equipos y entornos.

## Requisitos

- Grafana funcionando.
- Varias reglas de alerta.
- Contactos de laboratorio.
- Permisos para crear políticas.
- Reglas con etiquetas consistentes.
- Entorno controlado.

---

## Tarea 1: crear los contactos

Crear o utilizar estos contactos:

```text
laboratory-email
staging-email
systems-warning
systems-oncall
application-warning
application-oncall
```

Probar cada contacto de forma independiente.

---

## Tarea 2: definir las rutas

Utilizar la siguiente estructura:

```text
environment=laboratory
    → laboratory-email

environment=staging
    → staging-email

environment=production, team=systems, severity=warning
    → systems-warning

environment=production, team=systems, severity=critical
    → systems-oncall

environment=production, team=application, severity=warning
    → application-warning

environment=production, team=application, severity=critical
    → application-oncall
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

Etiquetas de prueba:

```text
alertname = HighCPUUsage
team = systems
severity = warning
environment = production
resource = cpu
```

### Regla de disponibilidad

```promql
up{job="node_exporter"}
```

Etiquetas de prueba:

```text
alertname = NodeExporterDown
team = systems
severity = critical
environment = production
resource = availability
```

---

## Tarea 4: probar la alerta de advertencia

1. Activar la regla de CPU en un entorno autorizado.
2. Esperar el estado `Alerting`.
3. Confirmar que se utiliza `systems-warning`.
4. Comprobar el mensaje.
5. Recuperar la alerta.
6. Comprobar la recuperación.
7. Registrar los tiempos.

---

## Tarea 5: probar la alerta crítica

1. Confirmar que Node Exporter funciona.
2. Detenerlo en el laboratorio:

```bash
sudo systemctl stop node_exporter
```

3. Esperar el estado `Alerting`.
4. Confirmar que se utiliza `systems-oncall`.
5. Comprobar el mensaje.
6. Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

7. Comprobar la recuperación.
8. Registrar los resultados.

---

## Tarea 6: probar una alerta sin coincidencia

Crear una alerta con:

```text
team = database
severity = warning
environment = production
```

No crear inicialmente una ruta para `team=database`.

Comprobar:

```text
Contacto utilizado:

¿Se utilizó el contacto predeterminado?

¿Se generó un error?

¿Qué ruta debería crearse?
```

Crear posteriormente una ruta específica y repetir la prueba.

---

## Tarea 7: probar la agrupación

1. Activar la regla de CPU en varias instancias.
2. Configurar:

```text
group_by:
- alertname
```

3. Revisar el número de mensajes.
4. Cambiar a:

```text
group_by:
- alertname
- instance
```

5. Repetir la prueba.
6. Comparar ambos comportamientos.
7. Documentar qué configuración resulta más adecuada.

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Contactos creados | | |
| Contactos probados | | |
| Ruta de laboratorio creada | | |
| Ruta de staging creada | | |
| Ruta crítica de sistemas creada | | |
| Ruta de advertencia de sistemas creada | | |
| Ruta crítica de aplicaciones creada | | |
| Ruta de advertencia de aplicaciones creada | | |
| Alerta de CPU enrutada correctamente | | |
| Alerta de disponibilidad enrutada correctamente | | |
| Alerta sin coincidencia probada | | |
| Contacto predeterminado comprobado | | |
| Agrupación por `alertname` probada | | |
| Agrupación por `instance` probada | | |
| `group_wait` probado | | |
| `group_interval` probado | | |
| `repeat_interval` probado | | |
| Recuperación comprobada | | |
| Rutas documentadas | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Una política de notificación decide cómo se enruta una alerta.
- Las etiquetas conectan las reglas con las políticas.
- El contacto define el destino final.
- Una política puede utilizar rutas generales y específicas.
- Las coincidencias pueden basarse en equipo, severidad, entorno o servicio.
- Las coincidencias múltiples deben diseñarse cuidadosamente.
- Una política predeterminada gestiona alertas sin coincidencia específica.
- El orden y la estructura de las rutas pueden cambiar el resultado.
- Las rutas solapadas pueden producir mensajes duplicados o inesperados.
- `group_by` controla cómo se agrupan las alertas.
- `group_wait` retrasa el primer mensaje de un grupo.
- `group_interval` controla las actualizaciones del grupo.
- `repeat_interval` controla la repetición de alertas activas.
- Las alertas críticas deben enviarse a canales que permitan una respuesta urgente.
- Las alertas de laboratorio no deben llegar a la guardia de producción.
- Las políticas deben probarse con coincidencias y sin coincidencias.
- Las recuperaciones deben comprobarse igual que las activaciones.
- Una política excesivamente compleja es difícil de mantener.
- Una política demasiado general puede enviar alertas al equipo incorrecto.
- Las etiquetas deben seguir una convención común.
- El contacto predeterminado debe estar supervisado y documentado.
- La agrupación reduce ruido, pero no debe ocultar información necesaria.
- Los tiempos de notificación deben adaptarse a la severidad.
- Toda ruta debe tener una finalidad operativa clara.
- Las políticas deben revisarse después de cambios en equipos, servicios o entornos.

---

# Preguntas de comprobación

1. ¿Qué es una política de notificación?
2. ¿Qué diferencia existe entre una política y un contacto?
3. ¿Qué función cumplen las etiquetas?
4. ¿Qué es una ruta de notificación?
5. ¿Qué ocurre cuando varias etiquetas forman parte de una coincidencia?
6. ¿Qué diferencia existe entre una ruta general y una ruta específica?
7. ¿Para qué sirve la política predeterminada?
8. ¿Qué puede ocurrir si una alerta no coincide con ninguna ruta?
9. ¿Cómo enrutarías las alertas críticas de producción?
10. ¿Cómo separarías las alertas de laboratorio y producción?
11. ¿Qué significa `group_by`?
12. ¿Qué diferencia existe entre `group_wait`, `group_interval` y `repeat_interval`?
13. ¿Qué problemas pueden causar las rutas solapadas?
14. ¿Qué revisarías si una alerta llega al contacto incorrecto?
15. ¿Qué revisarías si una alerta no genera ninguna notificación?
16. ¿Por qué es importante probar una alerta sin coincidencia?
17. ¿Qué ventajas tiene agrupar alertas?
18. ¿Qué riesgos tiene agrupar demasiado?
19. ¿Cómo diseñarías rutas diferentes para `warning` y `critical`?
20. ¿Cómo comprobarías una notificación de recuperación?
21. ¿Qué etiquetas utilizarías para separar equipos?
22. ¿Qué información documentarías para cada política?
23. ¿Por qué no debe utilizarse el sistema de guardia para todas las alertas?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener una política de notificación mantenible?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de diseñar y probar políticas de notificación para diferentes equipos, entornos y niveles de severidad.

El flujo final será:

```text
Definir la clasificación
        |
        v
Añadir etiquetas a las reglas
        |
        v
Crear los contactos
        |
        v
Diseñar el árbol de políticas
        |
        v
Configurar rutas específicas
        |
        v
Configurar la ruta predeterminada
        |
        v
Configurar agrupación y tiempos
        |
        v
Probar coincidencias
        |
        v
Probar alertas sin coincidencia
        |
        v
Comprobar activaciones
        |
        v
Comprobar recuperaciones
        |
        v
Documentar el resultado
```

Una política está correctamente configurada cuando:

- Las etiquetas de las reglas son coherentes.
- Cada equipo recibe sus propias alertas.
- Los entornos están separados.
- Las alertas críticas llegan al canal de guardia adecuado.
- Las alertas de laboratorio no llegan a producción.
- Las rutas específicas funcionan.
- La política predeterminada está controlada.
- La agrupación reduce el ruido sin ocultar información.
- Los tiempos de espera y repetición son adecuados.
- Las recuperaciones se procesan correctamente.
- No existen rutas ambiguas sin justificación.
- Las políticas están documentadas y probadas.

Una buena política de notificación transforma una colección de reglas en un sistema de respuesta ordenado: cada alerta llega al equipo correcto, mediante el canal adecuado y con una frecuencia que permite actuar sin convertir la monitorización en una pequeña fábrica de ruido.