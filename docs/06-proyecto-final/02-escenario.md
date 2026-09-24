# Escenario del proyecto

El proyecto final consiste en diseñar e implantar una solución básica de observabilidad para una organización ficticia que necesita supervisar sus servidores, detectar problemas y recibir información útil cuando se produce un incidente.

La solución se construirá utilizando **Grafana**, **Prometheus** y **Node Exporter**. Durante el proyecto, el alumno trabajará con métricas, consultas PromQL, dashboards, reglas de alerta, anotaciones, notificaciones y silenciamientos.

El escenario está diseñado para integrar los conocimientos adquiridos durante el curso mediante sesiones prácticas progresivas.

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Comprender el contexto técnico y operativo del proyecto final.
- Identificar los componentes de la arquitectura de monitorización.
- Relacionar Grafana, Prometheus y Node Exporter.
- Determinar qué métricas deben supervisarse.
- Identificar los riesgos operativos del escenario.
- Definir requisitos funcionales de observabilidad.
- Definir requisitos técnicos del proyecto.
- Proponer reglas de alerta para distintos tipos de problemas.
- Diseñar un dashboard orientado a operaciones.
- Relacionar alertas con equipos responsables.
- Documentar un mantenimiento o un despliegue mediante anotaciones.
- Probar situaciones de fallo en un entorno controlado.
- Analizar la recuperación de un servicio.
- Preparar evidencias del trabajo realizado.
- Explicar las decisiones técnicas adoptadas.

## Introducción

La organización del escenario dispone de varios servidores que ejecutan servicios internos y aplicaciones de negocio.

Actualmente, el equipo técnico tiene dificultades para responder a las siguientes preguntas:

```text
¿Está disponible el servidor?

¿Está funcionando el agente de métricas?

¿La CPU se encuentra en niveles normales?

¿Existe suficiente memoria?

¿Cuánto espacio queda en el almacenamiento?

¿Cuándo comenzó el problema?

¿Quién debe recibir la alerta?

¿Se ha realizado algún mantenimiento recientemente?

¿El problema se ha resuelto?
```

Para responder a estas preguntas, se implantará una plataforma de monitorización.

El flujo de información será:

```text
Servidor supervisado
        |
        v
Node Exporter
        |
        v
Prometheus
        |
        v
Grafana
        |
        +--> Dashboards
        |
        +--> Consultas PromQL
        |
        +--> Alertas
        |
        +--> Notificaciones
        |
        +--> Anotaciones
```

El alumno trabajará inicialmente con un entorno de laboratorio. Las pruebas de parada de servicios o generación de carga se realizarán únicamente sobre máquinas autorizadas.

## Organización ficticia

La organización del escenario se denomina:

```text
ObservaLab
```

ObservaLab ofrece servicios internos para sus empleados y necesita mejorar la visibilidad sobre su infraestructura.

### Equipos

La organización cuenta con los siguientes equipos:

| Equipo | Responsabilidad |
|---|---|
| Sistemas | Servidores, sistema operativo y recursos físicos |
| Aplicaciones | Servicios y aplicaciones internas |
| Redes | Conectividad y disponibilidad de red |
| Operaciones | Supervisión y gestión de incidencias |
| Formación | Entorno de prácticas y documentación |

### Entornos

Se utilizan tres entornos:

```text
laboratory
staging
production
```

Cada entorno debe tratarse de forma diferente.

| Entorno | Finalidad | Notificaciones |
|---|---|---|
| `laboratory` | Prácticas y pruebas | Contactos de formación |
| `staging` | Validación previa | Equipo responsable |
| `production` | Servicios reales | Equipo de guardia |

Durante este proyecto se trabajará exclusivamente con el entorno:

```text
environment = laboratory
```

## Arquitectura del escenario

La arquitectura mínima estará formada por:

### Servidor supervisado

Es la máquina que genera las métricas del sistema.

Puede proporcionar información sobre:

- CPU.
- Memoria.
- Almacenamiento.
- Tiempo de actividad.
- Estado de procesos.
- Red.
- Sistema operativo.

### Node Exporter

Node Exporter expone métricas del sistema en un endpoint HTTP.

Ejemplo:

```text
http://localhost:9100/metrics
```

Algunas métricas habituales son:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes
node_filesystem_size_bytes
node_filesystem_avail_bytes
```

### Prometheus

Prometheus consulta periódicamente el endpoint de Node Exporter y almacena las métricas.

Su función principal es:

```text
Recopilar
Almacenar
Consultar
Evaluar series temporales
```

### Grafana

Grafana consulta Prometheus y permite:

- Crear dashboards.
- Ejecutar consultas.
- Definir reglas de alerta.
- Configurar contactos.
- Gestionar políticas.
- Crear anotaciones.
- Consultar históricos.
- Investigar incidentes.

## Situación inicial

Antes del proyecto, ObservaLab presenta los siguientes problemas:

- No existe un dashboard operativo común.
- Las métricas se consultan de forma manual.
- No hay alertas para la caída de Node Exporter.
- El equipo no recibe notificaciones automáticas.
- No se registran mantenimientos en los dashboards.
- Los problemas de CPU se detectan tarde.
- No existe una documentación uniforme.
- Las pruebas no dejan evidencias consistentes.

El proyecto debe resolver estos problemas mediante una solución sencilla y reproducible.

## Requisitos funcionales

La solución debe permitir:

- Consultar la disponibilidad de los objetivos.
- Mostrar el uso de CPU.
- Mostrar el uso de memoria.
- Mostrar el uso del almacenamiento.
- Filtrar por instancia.
- Crear alertas de disponibilidad.
- Crear alertas de CPU.
- Crear alertas de memoria.
- Crear alertas de almacenamiento.
- Enviar notificaciones a un contacto de laboratorio.
- Registrar anotaciones operativas.
- Crear silenciamientos temporales.
- Comprobar la recuperación de las alertas.
- Consultar el historial de estados.
- Documentar las pruebas realizadas.

## Requisitos técnicos

El entorno debe contar con:

- Una máquina virtual o servidor de prácticas.
- Grafana.
- Prometheus.
- Node Exporter.
- Una fuente de datos configurada.
- Acceso al navegador.
- Acceso a una terminal.
- Permisos suficientes para crear dashboards.
- Permisos suficientes para crear reglas.
- Un contacto de notificación controlado.
- Un sistema para guardar evidencias.

## Etiquetas del proyecto

Todas las reglas de alerta deberán utilizar etiquetas coherentes.

### Etiquetas obligatorias

```text
alertname
severity
team
service
environment
resource
```

### Ejemplo

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

### Valores recomendados

```text
severity:
info
warning
critical

team:
systems
application
network
operations

environment:
laboratory
staging
production

resource:
availability
cpu
memory
filesystem
network
```

Una nomenclatura consistente facilita el filtrado, el enrutamiento y el diagnóstico.

## Alertas previstas

El proyecto debe incluir, como mínimo, las siguientes alertas:

| Alerta | Condición | Severidad |
|---|---|---|
| `NodeExporterDown-Laboratory` | El objetivo no responde | `critical` |
| `HighCPUUsage-Laboratory` | CPU superior al 90 % | `warning` |
| `HighMemoryUsage-Laboratory` | Memoria superior al 90 % | `warning` |
| `FilesystemUsageHigh-Laboratory` | Almacenamiento superior al 80 % | `warning` |

## Dashboard previsto

El dashboard operativo deberá incluir, como mínimo:

- Disponibilidad de los objetivos.
- CPU utilizada por instancia.
- Memoria utilizada por instancia.
- Almacenamiento utilizado.
- Variable para seleccionar una instancia.
- Rangos temporales.
- Leyendas.
- Unidades.
- Umbrales visuales.
- Anotaciones visibles.

## Flujo operativo esperado

El comportamiento esperado será:

```text
Una métrica supera un umbral
        |
        v
La regla evalúa la condición
        |
        v
La alerta pasa a Pending
        |
        v
La condición se mantiene
        |
        v
La alerta pasa a Alerting
        |
        v
La política selecciona un contacto
        |
        v
Se envía la notificación
        |
        v
El equipo investiga
        |
        v
La condición desaparece
        |
        v
La alerta vuelve a Normal
```

## Sesión 1: analizar el escenario

### Objetivo

Comprender las necesidades de ObservaLab antes de realizar cambios técnicos.

### Actividad

Leer el escenario y responder:

```text
¿Qué problemas tiene actualmente la organización?

¿Qué equipos deben recibir información?

¿Qué métricas son prioritarias?

¿Qué alertas deben ser críticas?

¿Qué alertas pueden ser advertencias?

¿Qué información debe aparecer en un dashboard?

¿Qué actividades deben registrarse como anotaciones?
```

### Registro

```text
Problema principal:

Equipo responsable:

Métrica relacionada:

Alerta propuesta:

Severidad:

Acción esperada:
```

### Resultado esperado

El alumno debe ser capaz de relacionar cada problema con:

```text
Una métrica
Una regla
Un equipo
Un nivel de severidad
Una acción
```

## Sesión 2: dibujar la arquitectura

### Objetivo

Representar los componentes y el flujo de datos.

### Actividad

Completar el siguiente esquema:

```text
Servidor de laboratorio
        |
        v
____________________
        |
        v
____________________
        |
        v
____________________
        |
        +--> ____________________
        |
        +--> ____________________
        |
        +--> ____________________
```

### Preguntas

```text
¿Qué componente expone las métricas?

¿Qué componente las recopila?

¿Qué componente las visualiza?

¿Dónde se ejecutan las consultas PromQL?

¿Dónde se configuran las alertas?

¿Dónde se registran las anotaciones?
```

### Resultado esperado

```text
Servidor
    → Node Exporter
    → Prometheus
    → Grafana
    → Dashboards, alertas y anotaciones
```

## Sesión 3: identificar los responsables

### Objetivo

Asignar cada alerta al equipo adecuado.

### Actividad

Completar la tabla:

| Situación | Equipo responsable | Severidad | Acción |
|---|---|---|---|
| Node Exporter no responde | | | |
| CPU superior al 90 % | | | |
| Memoria superior al 90 % | | | |
| Disco superior al 80 % | | | |
| Error de una aplicación | | | |
| Pérdida de conectividad | | | |

### Resultado esperado

Una posible clasificación sería:

```text
Node Exporter no responde
    → systems
    → critical
    → investigar disponibilidad

CPU elevada
    → systems
    → warning
    → revisar procesos y carga

Memoria elevada
    → systems
    → warning
    → revisar consumo y procesos

Almacenamiento elevado
    → systems
    → warning
    → revisar crecimiento y limpieza
```

La clasificación puede adaptarse a las responsabilidades definidas por el instructor.

## Sesión 4: preparar el entorno

### Objetivo

Verificar que la infraestructura del laboratorio está disponible.

### Comprobaciones

Node Exporter:

```bash
sudo systemctl status node_exporter
```

Prometheus:

```bash
sudo systemctl status prometheus
```

Grafana:

```bash
sudo systemctl status grafana-server
```

Si se utilizan contenedores:

```bash
docker ps
```

Comprobar puertos:

```bash
ss -lntp
```

Comprobar las métricas:

```bash
curl http://localhost:9100/metrics
```

### Registro

```text
Node Exporter:

Prometheus:

Grafana:

Puerto de Node Exporter:

Endpoint de métricas:

Resultado:

Observaciones:
```

### Resultado esperado

```text
Node Exporter está activo.
Prometheus está activo.
Grafana está activo.
El endpoint de métricas responde.
```

## Sesión 5: validar la conexión con Prometheus

### Objetivo

Confirmar que Grafana puede consultar la fuente de datos.

### Procedimiento

1. Acceder a Grafana.
2. Abrir la sección de fuentes de datos.
3. Seleccionar Prometheus.
4. Ejecutar la prueba de conexión.
5. Confirmar el resultado.
6. Registrar los datos principales.

### Registro

```text
Nombre de la fuente:

Tipo:

URL:

Estado:

Fecha:

Observaciones:
```

### Diagnóstico

Si la conexión falla, revisar:

- URL.
- Puerto.
- Estado de Prometheus.
- DNS.
- Red.
- Firewall.
- Logs de Grafana.
- Logs de Prometheus.

## Sesión 6: seleccionar las métricas del proyecto

### Objetivo

Determinar qué métricas se utilizarán en dashboards y alertas.

### Actividad

Relacionar cada necesidad con una métrica.

| Necesidad | Métrica o consulta | Panel | Alerta |
|---|---|---|---|
| Disponibilidad | | | |
| CPU | | | |
| Memoria | | | |
| Almacenamiento | | | |
| Instancia | | | |

### Consultas de referencia

Disponibilidad:

```promql
up{job="node_exporter"}
```

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Memoria:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Almacenamiento:

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

## Sesión 7: diseñar el dashboard antes de crearlo

### Objetivo

Planificar la distribución de los paneles.

### Actividad

Dibujar un esquema:

```text
+--------------------------------------------------+
| Disponibilidad de objetivos                      |
+-------------------------+------------------------+
| CPU por instancia       | Memoria por instancia  |
+-------------------------+------------------------+
| Almacenamiento          | Estado de alertas     |
+-------------------------+------------------------+
| Anotaciones y eventos                            |
+--------------------------------------------------+
```

### Preguntas

```text
¿Qué información debe verse inmediatamente?

¿Qué panel debe ocupar la primera posición?

¿Qué paneles requieren unidad porcentual?

¿Qué paneles deben incluir una leyenda?

¿Qué paneles necesitan una variable?
```

### Resultado esperado

El dashboard debe priorizar:

1. Disponibilidad.
2. Alertas activas.
3. Recursos críticos.
4. Contexto temporal.
5. Detalle por instancia.

## Sesión 8: definir las reglas de alerta

### Objetivo

Diseñar las alertas antes de implementarlas.

### Actividad

Completar la tabla:

| Alerta | Consulta | Umbral | Duración | Severidad |
|---|---|---:|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

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
¿Por qué la alerta de disponibilidad tiene severidad crítica?

¿Por qué la CPU necesita una duración?

¿Por qué el almacenamiento puede utilizar una duración mayor?

¿Qué alerta generaría más impacto operativo?
```

## Sesión 9: diseñar el modelo de etiquetas

### Objetivo

Definir las etiquetas que utilizarán las reglas.

### Actividad

Completar las etiquetas de cada alerta.

#### Disponibilidad

```text
alertname = NodeExporterDown-Laboratory
severity =
team =
service =
environment =
resource =
```

#### CPU

```text
alertname = HighCPUUsage-Laboratory
severity =
team =
service =
environment =
resource =
```

#### Memoria

```text
alertname = HighMemoryUsage-Laboratory
severity =
team =
service =
environment =
resource =
```

#### Almacenamiento

```text
alertname = FilesystemUsageHigh-Laboratory
severity =
team =
service =
environment =
resource =
mountpoint =
```

### Resultado esperado

Las etiquetas deben permitir identificar:

```text
Qué ocurre
Dónde ocurre
A quién corresponde
En qué entorno
Qué recurso está afectado
```

## Sesión 10: definir el flujo de notificaciones

### Objetivo

Determinar qué contacto utilizará cada tipo de alerta.

### Contactos

Crear contactos de laboratorio con nombres descriptivos:

```text
laboratory-systems-warning
laboratory-systems-critical
laboratory-observability
```

### Políticas

Propuesta:

```text
environment = laboratory
severity = warning
    → laboratory-systems-warning

environment = laboratory
severity = critical
    → laboratory-systems-critical
```

### Actividad

Completar:

| Entorno | Severidad | Contacto | Justificación |
|---|---|---|---|
| `laboratory` | `warning` | | |
| `laboratory` | `critical` | | |
| `production` | `critical` | | |

Durante el proyecto no se deben crear contactos reales de producción.

## Sesión 11: crear el escenario de mantenimiento

### Objetivo

Planificar una actividad conocida que pueda generar alertas.

### Escenario

Se realizará un mantenimiento de Node Exporter en el servidor de laboratorio.

Durante el mantenimiento:

- Node Exporter dejará de responder.
- Prometheus observará la pérdida del objetivo.
- La regla de disponibilidad podrá activarse.
- Se utilizará un silenciamiento.
- Se creará una anotación.
- Se comprobará la recuperación.

### Datos del mantenimiento

```text
Nombre:
Mantenimiento de Node Exporter

Entorno:
laboratory

Servicio:
node_exporter

Responsable:
systems

Inicio:

Fin:

Motivo:

Referencia:
```

### Preguntas

```text
¿Qué alerta se espera?

¿Qué alerta no debería silenciarse?

¿Qué equipo debe conocer la actividad?

¿Qué anotación debe crearse?

¿Cuándo debe finalizar el silencio?
```

## Sesión 12: ejecutar una prueba de disponibilidad

### Objetivo

Probar el comportamiento del sistema cuando Node Exporter deja de responder.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba de disponibilidad

Descripción:
Se detendrá Node Exporter en el entorno de laboratorio
para validar la alerta de disponibilidad.
```

Comprobar el estado inicial:

```text
Normal
```

Detener el servicio en el laboratorio:

```bash
sudo systemctl stop node_exporter
```

Observar:

```text
Normal
   |
   v
Pending
   |
   v
Alerting
```

Registrar:

```text
Hora de detención:

Hora de Pending:

Hora de Alerting:

Notificación recibida:

Contacto utilizado:

Instancia afectada:
```

Recuperar el servicio:

```bash
sudo systemctl start node_exporter
```

Observar:

```text
Alerting
   |
   v
Normal
```

Registrar:

```text
Hora de recuperación:

Notificación de recuperación:

Duración total:

Resultado:
```

## Sesión 13: probar el silenciamiento

### Objetivo

Comprobar que una alerta puede seguir evaluándose sin generar notificaciones durante un mantenimiento conocido.

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
Referencia: LAB-NODE-001.
```

### Ejecutar la prueba

1. Confirmar que el silencio está activo.
2. Detener Node Exporter.
3. Comprobar que la alerta se evalúa.
4. Comprobar que la notificación queda suprimida.
5. Revisar el estado en Grafana.
6. Iniciar Node Exporter.
7. Comprobar la recuperación.
8. Revisar el estado del silencio.

### Registro

```text
Silencio:

Coincidencias:

Inicio:

Fin:

Estado:

Alerta afectada:

Notificación suprimida:

Hora de recuperación:

Resultado:
```

## Sesión 14: probar una carga de CPU

### Objetivo

Comprobar el efecto de una carga controlada sobre la alerta de CPU.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba de carga de CPU

Descripción:
Se ejecutará una carga controlada en el servidor de laboratorio
para validar la alerta HighCPUUsage-Laboratory.
```

Consultar la carga actual:

```bash
top
```

Si el entorno lo permite:

```bash
stress-ng --cpu 1 --timeout 60s
```

La alerta utiliza:

```text
Umbral:
90 %

Duración:
5 minutos
```

Una prueba de 60 segundos puede no activar la alerta. Esto permite observar el efecto de la duración.

### Registro

```text
Valor inicial:

Valor máximo:

Tiempo por encima del umbral:

Estado final:

Notificación:

Resultado:

Explicación:
```

No generar carga sobre sistemas que no pertenezcan al laboratorio.

## Sesión 15: analizar la recuperación

### Objetivo

Verificar que la recuperación queda registrada correctamente.

### Actividad

Para cada alerta activada, completar:

| Alerta | Hora de activación | Hora de recuperación | Duración | Notificación |
|---|---|---|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

### Preguntas

```text
¿La alerta se recuperó automáticamente?

¿Llegó una notificación de recuperación?

¿El contacto era el esperado?

¿La recuperación apareció en el dashboard?

¿El silencio seguía activo?
```

## Sesión 16: investigar una alerta sin coincidencia

### Objetivo

Comprobar el comportamiento de una alerta que no coincide con una política específica.

### Etiquetas de prueba

```text
alertname = TestUnmatchedAlert
team = unknown
severity = warning
environment = laboratory
```

### Procedimiento

1. Revisar las políticas existentes.
2. Confirmar que no existe una ruta para `team=unknown`.
3. Activar la alerta de prueba.
4. Comprobar el contacto utilizado.
5. Revisar la política predeterminada.
6. Crear una ruta específica.
7. Repetir la prueba.
8. Comparar los resultados.

### Registro

```text
Contacto inicial:

Política utilizada:

Ruta creada:

Contacto posterior:

Diferencia observada:

Conclusión:
```

## Sesión 17: diagnosticar una alerta que no se activa

### Situación

```text
El dashboard muestra CPU elevada,
pero la alerta permanece en Normal.
```

### Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar el valor actual.
3. Comprobar el umbral.
4. Comprobar la reducción.
5. Comprobar la duración.
6. Comprobar el intervalo de evaluación.
7. Comprobar el estado de la regla.
8. Revisar las etiquetas.
9. Comprobar si existe un error de consulta.
10. Registrar la causa.

### Posibles causas

```text
El valor no supera realmente el umbral.
La condición todavía no ha durado lo suficiente.
La consulta devuelve otra instancia.
La reducción no es adecuada.
La regla está pausada.
La consulta no devuelve datos.
La unidad del umbral es incorrecta.
```

### Registro

```text
Regla:

Valor observado:

Umbral:

Reducción:

Duración:

Estado:

Causa identificada:

Corrección:

Resultado:
```

## Sesión 18: diagnosticar una alerta sin notificación

### Situación

```text
La alerta aparece como Alerting,
pero el contacto no recibe ningún mensaje.
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
- Logs de Grafana.
- Estado de la integración externa.

### Registro

```text
Alerta:

Estado:

Política coincidente:

Contacto esperado:

Contacto utilizado:

Silencio:

Error observado:

Corrección:

Resultado:
```

## Sesión 19: relacionar eventos y métricas

### Objetivo

Analizar la relación entre una anotación operativa y una alerta.

### Línea temporal de ejemplo

```text
18:00 - Inicio de prueba de carga
18:02 - La CPU comienza a aumentar
18:05 - La CPU supera el umbral
18:05 - La alerta entra en Pending
18:10 - La alerta pasa a Alerting
18:11 - Se recibe la notificación
18:12 - Finaliza la prueba
18:16 - La CPU vuelve a valores normales
18:17 - La alerta se recupera
```

### Registro

```text
Hora:

Evento:

Métrica observada:

Estado de la alerta:

Notificación:

Acción realizada:
```

### Conclusión esperada

La anotación permite relacionar el aumento de la métrica con una actividad conocida. La duración de la alerta ayuda a diferenciar un pico breve de un problema sostenido.

## Sesión 20: preparar las evidencias

### Objetivo

Guardar pruebas claras y ordenadas del trabajo realizado.

### Capturas recomendadas

```text
01-entorno-validado.png
02-fuente-prometheus.png
03-consulta-up.png
04-consulta-cpu.png
05-dashboard-inicial.png
06-dashboard-operativo.png
07-variable-instance.png
08-regla-disponibilidad.png
09-regla-cpu.png
10-regla-memoria.png
11-regla-almacenamiento.png
12-anotacion-mantenimiento.png
13-contacto-notificacion.png
14-politica-notificacion.png
15-alerta-pending.png
16-alerta-alerting.png
17-notificacion-recibida.png
18-silencio-activo.png
19-alerta-resolved.png
20-dashboard-final.png
```

### Información que debe ocultarse

Antes de entregar las capturas:

- Ocultar tokens.
- Ocultar contraseñas.
- Ocultar claves API.
- Ocultar información personal innecesaria.
- Ocultar URLs privadas.
- Ocultar cabeceras de autenticación.
- Confirmar que los datos pertenecen al laboratorio.

## Sesión 21: realizar la limpieza final

### Objetivo

Dejar el entorno en un estado estable y documentado.

### Comprobaciones

Comprobar Node Exporter:

```bash
sudo systemctl status node_exporter
```

Comprobar la métrica:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

### Revisar

- Reglas temporales.
- Contactos de laboratorio.
- Políticas de prueba.
- Silenciamientos activos.
- Anotaciones.
- Dashboards.
- Servicios detenidos.
- Procesos de carga.
- Cambios no documentados.

### Registro

```text
Node Exporter:

Prometheus:

Grafana:

Silenciamientos restantes:

Reglas temporales eliminadas:

Contactos temporales eliminados:

Entorno limpio:

Validación del instructor:
```

## Entregables del escenario

El alumno deberá entregar:

- Descripción del escenario.
- Diagrama de arquitectura.
- Dashboard operativo.
- Consultas PromQL.
- Reglas de alerta.
- Etiquetas y anotaciones.
- Contacto de notificación.
- Política de notificación.
- Evidencias de activación.
- Evidencias de recuperación.
- Evidencia del silenciamiento.
- Registro de problemas y soluciones.
- Memoria técnica.
- Conclusiones personales.

### Estructura de la entrega

```text
entrega-proyecto-final/
├── dashboard/
│   └── dashboard-operativo.json
├── consultas/
│   └── consultas-promql.md
├── reglas/
│   └── reglas-alerta.md
├── evidencias/
│   ├── entorno/
│   ├── dashboard/
│   ├── alertas/
│   ├── notificaciones/
│   └── silencios/
├── informe/
│   └── memoria-tecnica.md
└── README.md
```

### Información del README

```text
Nombre del alumno:

Grupo:

Descripción del escenario:

Arquitectura utilizada:

Requisitos:

Cómo reproducir la práctica:

Dashboard principal:

Reglas creadas:

Contacto de notificación:

Limitaciones:

Resultado final:
```

## Puntos clave

- El escenario representa una necesidad realista de observabilidad.
- Grafana, Prometheus y Node Exporter cumplen funciones diferentes.
- Prometheus recopila y almacena las métricas.
- Node Exporter expone información del sistema.
- Grafana permite consultar, visualizar y alertar.
- El entorno de laboratorio debe mantenerse separado de producción.
- Las métricas deben relacionarse con necesidades operativas.
- Las alertas deben tener una finalidad concreta.
- Las etiquetas deben seguir una convención coherente.
- La severidad debe reflejar la importancia del problema.
- Las anotaciones aportan contexto temporal.
- Los silenciamientos deben utilizarse durante actividades conocidas.
- Las notificaciones deben llegar al equipo adecuado.
- Las pruebas deben incluir activación y recuperación.
- Una alerta activa no siempre implica que se haya enviado una notificación.
- Una alerta silenciada puede seguir apareciendo en Grafana.
- Las evidencias forman parte del resultado técnico.
- La limpieza final evita dejar servicios o configuraciones temporales activas.
- La documentación debe permitir reproducir el escenario.
- El objetivo final es detectar, contextualizar, notificar, investigar y recuperar.

## Preguntas de comprobación

1. ¿Qué problema pretende resolver la organización ficticia?
2. ¿Qué funciones desempeñan Node Exporter, Prometheus y Grafana?
3. ¿Qué métricas se utilizarán en el proyecto?
4. ¿Qué diferencia existe entre el entorno de laboratorio y el de producción?
5. ¿Qué equipo debería recibir una alerta de disponibilidad?
6. ¿Por qué la caída de Node Exporter puede considerarse una alerta crítica?
7. ¿Por qué una alerta de CPU debe tener un periodo de duración?
8. ¿Qué etiquetas debe incluir una regla de alerta?
9. ¿Qué información debe aparecer en un dashboard operativo?
10. ¿Qué función cumplen las anotaciones?
11. ¿En qué situación sería adecuado crear un silenciamiento?
12. ¿Qué revisarías si la alerta aparece como `Alerting`, pero no llega ninguna notificación?
13. ¿Qué revisarías si la consulta no devuelve datos?
14. ¿Cómo comprobarías que un silencio solo afecta a una instancia?
15. ¿Qué acciones deben realizarse después de una prueba de disponibilidad?
16. ¿Por qué deben ocultarse las credenciales en las evidencias?
17. ¿Qué información debe contener el diagrama de arquitectura?
18. ¿Qué problemas pueden aparecer si las etiquetas no son consistentes?
19. ¿Qué evidencias demostrarían que una alerta se activó y se recuperó?
20. ¿Qué elementos deben revisarse durante la limpieza final?

## Resultado esperado

El alumno debe ser capaz de describir y construir una solución que siga este flujo:

```text
Identificar la necesidad
        |
        v
Definir la arquitectura
        |
        v
Seleccionar las métricas
        |
        v
Validar Prometheus y Grafana
        |
        v
Crear el dashboard
        |
        v
Definir las reglas
        |
        v
Añadir etiquetas y anotaciones
        |
        v
Configurar las notificaciones
        |
        v
Probar una condición de fallo
        |
        v
Observar la alerta
        |
        v
Investigar el evento
        |
        v
Aplicar un silenciamiento si procede
        |
        v
Recuperar el servicio
        |
        v
Comprobar la recuperación
        |
        v
Guardar evidencias
        |
        v
Limpiar el entorno
        |
        v
Documentar las conclusiones
```

El escenario se considera correctamente resuelto cuando:

- La arquitectura está documentada.
- Los servicios funcionan en el entorno de laboratorio.
- Prometheus recopila métricas.
- Grafana consulta los datos.
- El dashboard muestra información útil.
- Las alertas tienen etiquetas coherentes.
- Las políticas enrutan las notificaciones correctamente.
- Las anotaciones aportan contexto.
- Los silenciamientos tienen un alcance limitado.
- Las activaciones y recuperaciones están comprobadas.
- Las evidencias son suficientes.
- El entorno queda limpio.
- La documentación permite reproducir la solución.

El proyecto no debe limitarse a demostrar que una alerta cambia de estado. Debe mostrar que el alumno comprende el contexto operativo completo: qué se supervisa, por qué se supervisa, quién debe actuar, cómo se registra el evento y cómo se confirma la recuperación del servicio.