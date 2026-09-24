# Entregables

Los entregables constituyen la evidencia final del proyecto de observabilidad con Grafana, Prometheus y Node Exporter.

El alumno deberá presentar una solución funcional, reproducible y documentada. No basta con mostrar una captura del dashboard: la entrega debe demostrar que el entorno fue validado, las consultas fueron comprobadas, las alertas fueron configuradas y las pruebas de activación y recuperación se realizaron de forma controlada.

La entrega final debe responder a estas preguntas:

```text
¿Qué se ha configurado?

¿Por qué se ha configurado así?

¿Cómo se ha validado?

¿Qué resultados se han obtenido?

¿Qué problemas han aparecido?

¿Cómo se han resuelto?

¿Qué evidencias demuestran el trabajo?

¿En qué estado queda el entorno?
```

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Identificar los elementos que debe entregar.
- Organizar una entrega técnica.
- Exportar o documentar un dashboard.
- Documentar consultas PromQL.
- Documentar reglas de alerta.
- Documentar contactos y políticas de notificación.
- Documentar anotaciones y silenciamientos.
- Preparar evidencias técnicas.
- Redactar una memoria final.
- Elaborar un registro de pruebas.
- Ocultar credenciales y secretos.
- Revisar la calidad de las capturas.
- Comprobar que el entorno queda limpio.
- Explicar los problemas encontrados.
- Relacionar cada evidencia con un requisito.
- Preparar un README reproducible.
- Revisar la entrega antes de enviarla.
- Justificar las decisiones técnicas adoptadas.

## Introducción

Una solución de observabilidad debe poder ser revisada por otra persona.

Para ello, la entrega debe incluir tanto la configuración como las pruebas realizadas.

El resultado esperado se organiza en varias categorías:

```text
Configuración
    |
    v
Consultas y reglas
    |
    v
Pruebas
    |
    v
Evidencias
    |
    v
Memoria técnica
    |
    v
Revisión y limpieza
```

La entrega debe ser clara, ordenada y segura.

No se deben incluir:

- Contraseñas.
- Tokens.
- Claves API.
- Claves privadas.
- Cookies.
- Cabeceras de autenticación.
- Credenciales SMTP.
- Webhooks reales.
- Información sensible de producción.
- Capturas con secretos visibles.

## Resultado final esperado

El alumno deberá entregar:

- Un dashboard operativo.
- Las consultas PromQL utilizadas.
- Las reglas de alerta configuradas.
- Las etiquetas y anotaciones de las reglas.
- Los contactos de laboratorio.
- Las políticas de notificación.
- Las anotaciones operativas.
- Los silenciamientos de prueba.
- Las evidencias de activación.
- Las evidencias de recuperación.
- Una memoria técnica.
- Un README con instrucciones.
- Un registro de problemas y soluciones.
- Una comprobación final del entorno.

## Estructura recomendada de la entrega

La estructura de directorios recomendada es:

```text
entrega-proyecto-final/
├── README.md
├── dashboard/
│   ├── dashboard-operativo.json
│   └── descripcion-dashboard.md
├── consultas/
│   ├── consultas-promql.md
│   └── registro-consultas.txt
├── alertas/
│   ├── reglas-alerta.md
│   ├── etiquetas-anotaciones.md
│   └── pruebas-alertas.md
├── notificaciones/
│   ├── contactos.md
│   └── politicas.md
├── anotaciones/
│   └── eventos-operativos.md
├── silencios/
│   └── silenciamientos.md
├── evidencias/
│   ├── entorno/
│   ├── promql/
│   ├── dashboard/
│   ├── alertas/
│   ├── notificaciones/
│   ├── recuperaciones/
│   └── silencios/
└── informe/
    └── memoria-tecnica.md
```

Los nombres pueden adaptarse a las instrucciones del instructor, pero deben mantenerse consistentes.

## Entregable 1: README

### Objetivo

El fichero `README.md` debe ofrecer una visión general del proyecto y explicar cómo revisar la entrega.

### Contenido mínimo

El README debe incluir:

- Nombre del alumno.
- Grupo.
- Fecha.
- Descripción del proyecto.
- Arquitectura utilizada.
- Requisitos.
- Estructura de directorios.
- Cómo reproducir la solución.
- Dashboard principal.
- Reglas creadas.
- Pruebas realizadas.
- Limitaciones.
- Resultado final.

### Plantilla

```markdown
# Proyecto final de observabilidad

## Identificación

Alumno:

Grupo:

Fecha:

## Descripción

Descripción breve de la solución creada con Grafana,
Prometheus y Node Exporter.

## Arquitectura

Descripción del flujo entre los componentes.

## Requisitos

Listado de software, permisos y recursos utilizados.

## Dashboard

Nombre:

URL o referencia:

Fichero exportado:

## Consultas

Ubicación de los ficheros PromQL.

## Alertas

Listado de reglas creadas.

## Notificaciones

Descripción del contacto y de la política de laboratorio.

## Pruebas

Resumen de las pruebas de activación y recuperación.

## Evidencias

Ubicación de las capturas y registros.

## Limitaciones

Limitaciones conocidas del laboratorio.

## Resultado

Descripción del estado final del proyecto.
```

## Entregable 2: información del entorno

### Objetivo

Documentar las versiones y direcciones utilizadas.

### Ficha del entorno

```text
Alumno:

Grupo:

Fecha de inicio:

Fecha de finalización:

Entorno:

Nombre del host:

Dirección IP o nombre:

Sistema operativo:

Versión de Grafana:

Versión de Prometheus:

Versión de Node Exporter:

URL de Grafana:

URL de Prometheus:

Puerto de Node Exporter:

Nombre de la fuente de datos:

Contacto de laboratorio:

Observaciones:
```

### Consideraciones

La información debe referirse al entorno de laboratorio.

Si la entrega se comparte fuera del aula, se deben anonimizar:

- Direcciones IP internas.
- Nombres reales de servidores.
- Dominios privados.
- Identidades de usuarios.
- Información de la organización.

## Entregable 3: arquitectura

### Objetivo

Representar el flujo de datos de la solución.

### Diagrama mínimo

```text
Servidor de laboratorio
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
        +--> Dashboard operativo
        |
        +--> Reglas de alerta
        |
        +--> Notificaciones
        |
        +--> Anotaciones
        |
        +--> Silenciamientos
```

### Información que debe acompañar al diagrama

```text
Componente:

Función:

Dirección:

Puerto:

Dependencias:

Observaciones:
```

### Ejemplo

| Componente | Función | Puerto | Dependencia |
|---|---|---:|---|
| Node Exporter | Expone métricas del sistema | 9100 | Sistema operativo |
| Prometheus | Recopila y almacena métricas | 9090 | Node Exporter |
| Grafana | Consulta y visualiza datos | 3000 | Prometheus |

## Entregable 4: dashboard operativo

### Objetivo

Entregar el dashboard creado y documentar su funcionamiento.

### Información mínima

```text
Nombre:

Descripción:

UID, si procede:

URL:

Fuente de datos:

Rango temporal predeterminado:

Intervalo de actualización:

Variables:

Número de paneles:
```

### Paneles esperados

El dashboard debe incluir, como mínimo:

- Disponibilidad.
- CPU.
- Memoria.
- Almacenamiento.
- Una variable de instancia.
- Umbrales visuales.
- Anotaciones visibles.

### Tabla de paneles

| Panel | Consulta | Visualización | Unidad |
|---|---|---|---|
| Disponibilidad | `up{job="node_exporter"}` | Stat | `none` |
| CPU | Consulta de CPU | Time series | Percent |
| Memoria | Consulta de memoria | Gauge | Percent |
| Almacenamiento | Consulta de filesystem | Gauge | Percent |

### Exportación del dashboard

Si Grafana permite exportar el dashboard:

1. Abrir la configuración del dashboard.
2. Seleccionar la opción de exportación.
3. Incluir las variables, si procede.
4. Descargar el fichero JSON.
5. Guardarlo en el directorio `dashboard/`.
6. Revisar que no contiene secretos.
7. Registrar el nombre del fichero.

Nombre recomendado:

```text
dashboard-operativo.json
```

### Registro

```text
Dashboard:

Fecha de exportación:

Fichero:

Variables incluidas:

Fuente de datos:

Secretos revisados:

Resultado:
```

## Entregable 5: consultas PromQL

### Objetivo

Documentar todas las consultas utilizadas en Explore, los paneles y las alertas.

### Consultas mínimas

#### Disponibilidad

```promql
up{job="node_exporter"}
```

#### CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

#### Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

#### Almacenamiento

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

### Ficha de cada consulta

```text
Nombre:

Necesidad operativa:

Consulta:

Métrica principal:

Filtros:

Funciones utilizadas:

Agregaciones:

Unidad:

Panel o alerta donde se utiliza:

Resultado observado:

Observaciones:
```

### Ejemplo documentado

```text
Nombre:
CPU utilizada por instancia

Necesidad operativa:
Identificar servidores con un uso elevado de CPU.

Consulta:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Métrica principal:
node_cpu_seconds_total

Filtros:
mode="idle"

Funciones utilizadas:
rate

Agregación:
avg by (instance)

Unidad:
Percent (0-100)

Uso:
Panel de CPU y alerta HighCPUUsage-Laboratory

Resultado:
La consulta devuelve una serie por instancia.
```

## Entregable 6: reglas de alerta

### Objetivo

Documentar la configuración completa de cada alerta.

### Alertas mínimas

```text
NodeExporterDown-Laboratory
HighCPUUsage-Laboratory
HighMemoryUsage-Laboratory
FilesystemUsageHigh-Laboratory
```

### Ficha de una regla

```text
Nombre:

Descripción:

Fuente de datos:

Consulta:

Reducción:

Operador:

Umbral:

Intervalo de evaluación:

Duración:

Comportamiento ante ausencia de datos:

Comportamiento ante errores:

Estado inicial:

Resultado:
```

### Tabla resumen

| Regla | Condición | Duración | Severidad | Recurso |
|---|---|---|---|---|
| `NodeExporterDown-Laboratory` | `up == 0` | 1 minuto | `critical` | Availability |
| `HighCPUUsage-Laboratory` | CPU > 90 % | 5 minutos | `warning` | CPU |
| `HighMemoryUsage-Laboratory` | Memoria > 90 % | 5 minutos | `warning` | Memory |
| `FilesystemUsageHigh-Laboratory` | Disco > 80 % | 10 minutos | `warning` | Filesystem |

### Ejemplo de alerta

```text
Nombre:
HighCPUUsage-Laboratory

Consulta:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Reducción:
Last

Operador:
Greater than

Umbral:
90

Intervalo:
1 minuto

Duración:
5 minutos

Severidad:
warning

Resultado:
La regla se crea en estado Normal.
```

## Entregable 7: etiquetas y anotaciones

### Objetivo

Demostrar que las alertas contienen información suficiente para clasificarlas y comprenderlas.

### Etiquetas obligatorias

Cada alerta deberá incluir, como mínimo:

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

### Anotaciones recomendadas

```text
summary
description
runbook_url
dashboard_url
```

### Ejemplo

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

### Tabla de revisión

| Regla | `alertname` | `severity` | `team` | `environment` | `resource` |
|---|---|---|---|---|---|
| NodeExporterDown | | | | | |
| HighCPUUsage | | | | | |
| HighMemoryUsage | | | | | |
| FilesystemUsageHigh | | | | | |

## Entregable 8: contactos de notificación

### Objetivo

Documentar los contactos de laboratorio sin revelar información sensible.

### Información que debe incluirse

```text
Nombre del contacto:

Tipo:

Finalidad:

Entorno:

Equipo destinatario:

Fecha de creación:

Prueba realizada:

Resultado:
```

### Información que no debe incluirse

No incluir:

- Tokens.
- Contraseñas.
- Claves API.
- URLs completas con secretos.
- Direcciones personales no autorizadas.
- Configuración de producción.

### Ejemplo

```text
Nombre:
laboratory-observability

Tipo:
Webhook de pruebas

Finalidad:
Recibir alertas del proyecto final

Entorno:
laboratory

Prueba:
Mensaje de prueba enviado desde Grafana

Resultado:
Recepción confirmada
```

## Entregable 9: políticas de notificación

### Objetivo

Documentar cómo se enrutan las alertas.

### Configuración de referencia

```text
Coincidencia:
environment = laboratory

Contacto:
laboratory-observability

Agrupación:
alertname, instance

group_wait:
10 segundos

group_interval:
1 minuto

repeat_interval:
5 minutos
```

### Ficha de política

```text
Nombre:

Etiquetas de coincidencia:

Contacto:

Agrupación:

Tiempo de espera inicial:

Intervalo entre grupos:

Intervalo de repetición:

Resultado de la prueba:
```

### Ejemplo de rutas

```text
environment = laboratory
severity = warning
    → laboratory-systems-warning

environment = laboratory
severity = critical
    → laboratory-systems-critical
```

La política debe utilizar las mismas etiquetas que las reglas. Una diferencia como esta puede impedir el enrutamiento:

```text
Alerta:
env = lab

Política:
environment = laboratory
```

## Entregable 10: anotaciones operativas

### Objetivo

Documentar eventos que proporcionan contexto a las métricas.

### Anotaciones mínimas

Se recomienda incluir:

- Inicio del proyecto.
- Inicio de una prueba.
- Mantenimiento.
- Recuperación.
- Despliegue de laboratorio, si procede.

### Ficha de anotación

```text
Título:

Descripción:

Etiquetas:

Fecha:

Hora:

Dashboard relacionado:

Motivo:

Resultado:
```

### Ejemplo

```text
Título:
Mantenimiento de Node Exporter

Descripción:
Se detendrá temporalmente Node Exporter para validar
la alerta de disponibilidad en el entorno de laboratorio.

Etiquetas:
event = maintenance
environment = laboratory
service = node_exporter

Dashboard relacionado:
Proyecto final - Dashboard operativo

Resultado:
La anotación aparece en el rango temporal de la prueba.
```

## Entregable 11: silenciamientos

### Objetivo

Documentar los silenciamientos utilizados durante actividades planificadas.

### Información mínima

```text
Nombre o referencia:

Coincidencias:

Inicio:

Fin:

Comentario:

Alerta afectada:

Motivo:

Resultado:
```

### Ejemplo

```text
Referencia:
LAB-SILENCE-001

Coincidencias:
alertname = NodeExporterDown-Laboratory
instance = server-01:9100
environment = laboratory

Inicio:
Fecha y hora de inicio

Fin:
20 minutos después

Comentario:
Mantenimiento autorizado de Node Exporter en laboratorio.

Resultado:
La alerta se evalúa, pero la notificación queda suprimida.
```

### Revisión

El silenciamiento debe ser:

- Específico.
- Temporal.
- Justificado.
- Asociado a una actividad conocida.
- Revisado al finalizar.
- Limitado al entorno de laboratorio.

## Entregable 12: pruebas de activación

### Objetivo

Demostrar que las reglas pueden detectar condiciones anómalas.

### Registro de activación

```text
Regla:

Condición provocada:

Valor inicial:

Umbral:

Hora de inicio:

Hora de Pending:

Hora de Alerting:

Notificación enviada:

Contacto utilizado:

Resultado:
```

### Ejemplo

```text
Regla:
NodeExporterDown-Laboratory

Condición provocada:
Detención autorizada de Node Exporter

Valor inicial:
up = 1

Valor durante la prueba:
up = 0

Estado observado:
Normal → Pending → Alerting

Notificación:
Recibida en el contacto de laboratorio

Resultado:
Prueba correcta
```

### Evidencias recomendadas

```text
alerta-normal.png
alerta-pending.png
alerta-alerting.png
notificacion-recibida.png
```

## Entregable 13: pruebas de recuperación

### Objetivo

Demostrar que las alertas vuelven a estado normal cuando desaparece la condición.

### Registro de recuperación

```text
Regla:

Condición inicial:

Acción de recuperación:

Hora de recuperación del recurso:

Hora de recuperación de la alerta:

Estado final:

Notificación de recuperación:

Resultado:
```

### Ejemplo

```text
Regla:
NodeExporterDown-Laboratory

Condición inicial:
Node Exporter detenido

Acción:
Inicio del servicio

Hora de recuperación:
Hora registrada en el sistema

Estado final:
Normal

Notificación:
Recuperación recibida

Resultado:
Prueba correcta
```

### Tabla resumen

| Regla | Hora de activación | Hora de recuperación | Duración | Resultado |
|---|---|---|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

## Entregable 14: diagnóstico de problemas

### Objetivo

Documentar los errores encontrados y las soluciones aplicadas.

### Plantilla de problema

```text
Problema:

Fecha:

Componente afectado:

Síntoma:

Comando o consulta utilizada:

Mensaje de error:

Causa:

Corrección:

Validación posterior:

Evidencia relacionada:
```

### Ejemplo

```text
Problema:
El target de Node Exporter aparecía como DOWN.

Componente afectado:
Prometheus y Node Exporter.

Síntoma:
La métrica up devolvía 0.

Mensaje de error:
connection refused.

Causa:
Node Exporter estaba detenido.

Corrección:
Se inició el servicio en la máquina de laboratorio.

Validación posterior:
El target volvió a UP y up devolvió 1.

Evidencia:
target-down.png y target-recovered.png
```

### Problemas habituales

| Problema | Causa posible | Evidencia |
|---|---|---|
| Panel sin datos | Consulta o etiqueta incorrecta | Captura de Explore |
| Target `DOWN` | Servicio detenido | Página de targets |
| Alerta sin notificación | Política no coincidente | Configuración de rutas |
| Alerta ruidosa | Duración insuficiente | Historial de estados |
| Datos duplicados | Filtros insuficientes | Resultado PromQL |
| Unidad incorrecta | Configuración del panel | Panel editado |

## Entregable 15: evidencias técnicas

### Objetivo

Demostrar visualmente las tareas realizadas.

### Evidencias del entorno

```text
01-servicios-activos.png
02-versiones.png
03-puertos.png
04-endpoint-metrics.png
05-target-up.png
```

### Evidencias de PromQL

```text
06-consulta-up.png
07-consulta-cpu.png
08-consulta-memoria.png
09-consulta-almacenamiento.png
```

### Evidencias del dashboard

```text
10-dashboard-inicial.png
11-dashboard-operativo.png
12-variable-instance.png
13-umbrales.png
14-anotaciones-dashboard.png
```

### Evidencias de alertas

```text
15-regla-disponibilidad.png
16-regla-cpu.png
17-regla-memoria.png
18-regla-almacenamiento.png
19-alerta-pending.png
20-alerta-alerting.png
21-alerta-resolved.png
```

### Evidencias de notificaciones

```text
22-contacto.png
23-politica.png
24-notificacion-recibida.png
25-notificacion-recuperacion.png
```

### Evidencias de silenciamientos

```text
26-silencio-creado.png
27-silencio-activo.png
28-alerta-silenciada.png
```

### Revisión de cada captura

Cada captura debe responder a estas preguntas:

```text
¿Qué se está demostrando?

¿Se identifica la regla o el panel?

¿Se ve el estado?

¿Se aprecia la fecha o la hora?

¿La imagen es legible?

¿Se han ocultado los secretos?

¿Pertenece al laboratorio?
```

## Sesión 1: preparar la estructura de entrega

### Objetivo

Crear los directorios donde se guardarán los documentos.

```bash
mkdir -p ~/entrega-proyecto-final
mkdir -p ~/entrega-proyecto-final/dashboard
mkdir -p ~/entrega-proyecto-final/consultas
mkdir -p ~/entrega-proyecto-final/alertas
mkdir -p ~/entrega-proyecto-final/notificaciones
mkdir -p ~/entrega-proyecto-final/anotaciones
mkdir -p ~/entrega-proyecto-final/silencios
mkdir -p ~/entrega-proyecto-final/evidencias/entorno
mkdir -p ~/entrega-proyecto-final/evidencias/promql
mkdir -p ~/entrega-proyecto-final/evidencias/dashboard
mkdir -p ~/entrega-proyecto-final/evidencias/alertas
mkdir -p ~/entrega-proyecto-final/evidencias/notificaciones
mkdir -p ~/entrega-proyecto-final/evidencias/recuperaciones
mkdir -p ~/entrega-proyecto-final/evidencias/silencios
mkdir -p ~/entrega-proyecto-final/informe
```

### Registro

```text
Directorio creado:

Subdirectorios:

Permisos:

Resultado:
```

## Sesión 2: recopilar los ficheros existentes

### Objetivo

Localizar los documentos y evidencias generados durante las prácticas.

### Actividad

Revisar el directorio de trabajo:

```bash
find ~/proyecto-final-grafana -maxdepth 4 -type f | sort
```

Buscar:

```text
Consultas PromQL:

Capturas:

Registros:

Exportaciones JSON:

Informes:

Problemas documentados:
```

### Registro

```text
Número de ficheros:

Número de capturas:

Dashboards encontrados:

Reglas documentadas:

Problemas documentados:

Ficheros pendientes:
```

## Sesión 3: crear el registro de entregables

### Objetivo

Controlar el estado de cada elemento de la entrega.

### Tabla

| Entregable | Estado | Ubicación | Revisado |
|---|---|---|---|
| README | | | |
| Dashboard | | | |
| Consultas PromQL | | | |
| Reglas | | | |
| Etiquetas | | | |
| Anotaciones | | | |
| Contactos | | | |
| Políticas | | | |
| Silenciamientos | | | |
| Evidencias | | | |
| Memoria técnica | | | |

### Registro en fichero

```bash
cat > ~/entrega-proyecto-final/registro-entregables.txt <<'EOF'
Entregable:

Estado:

Ubicación:

Revisado por:

Fecha:

Observaciones:
EOF
```

## Sesión 4: revisar el dashboard exportado

### Objetivo

Confirmar que el dashboard exportado contiene la configuración necesaria.

### Comprobaciones

Revisar:

```text
Nombre del dashboard:

Paneles:

Consultas:

Variables:

Unidades:

Umbrales:

Anotaciones:

Fuente de datos:

Secretos:
```

### Actividad

Abrir el fichero JSON en un editor de texto y comprobar:

```text
¿Existe información sensible?

¿Aparecen credenciales?

¿La variable instance está incluida?

¿Las consultas están presentes?

¿El dashboard puede importarse?
```

### Registro

```text
Fichero:

Tamaño:

Fecha:

Variables incluidas:

Secretos encontrados:

Acción aplicada:

Resultado:
```

## Sesión 5: revisar las consultas

### Objetivo

Comprobar que cada consulta documentada coincide con la utilizada.

### Actividad

Para cada consulta:

1. Copiar la consulta desde el documento.
2. Ejecutarla en Explore.
3. Compararla con el panel o la alerta.
4. Revisar la unidad.
5. Revisar las etiquetas.
6. Guardar la evidencia.

### Registro

```text
Consulta:

Documento:

Panel o alerta:

Coincide:

Unidad correcta:

Resultado:

Observaciones:
```

## Sesión 6: revisar las reglas de alerta

### Objetivo

Comprobar que las reglas documentadas coinciden con Grafana.

### Actividad

Para cada regla:

1. Revisar el nombre.
2. Revisar la consulta.
3. Revisar el umbral.
4. Revisar la duración.
5. Revisar las etiquetas.
6. Revisar las anotaciones.
7. Revisar el estado.
8. Comparar con el informe.

### Registro

```text
Regla:

Nombre correcto:

Consulta correcta:

Umbral correcto:

Duración correcta:

Etiquetas correctas:

Anotaciones correctas:

Estado:

Resultado:
```

## Sesión 7: revisar los contactos y las políticas

### Objetivo

Confirmar que las alertas se enrutan al contacto correcto.

### Actividad

Comprobar:

```text
Nombre del contacto:

Tipo:

Prueba realizada:

Política coincidente:

Etiquetas necesarias:

Agrupación:

Intervalo de repetición:

Resultado:
```

No incluir en la entrega:

```text
Token:

Contraseña:

Clave API:

URL privada completa:
```

## Sesión 8: revisar las pruebas

### Objetivo

Comprobar que cada prueba tiene un resultado documentado.

### Tabla de pruebas

| Prueba | Preparación | Acción | Resultado esperado | Resultado observado |
|---|---|---|---|---|
| Disponibilidad | | | | |
| CPU | | | | |
| Memoria | | | | |
| Almacenamiento | | | | |
| Recuperación | | | | |
| Silenciamiento | | | | |

### Registro

```text
Nombre de la prueba:

Objetivo:

Entorno:

Condición inicial:

Acción:

Estado observado:

Notificación:

Recuperación:

Evidencia:

Resultado:
```

## Sesión 9: revisar la seguridad de las evidencias

### Objetivo

Evitar que la entrega contenga información sensible.

### Actividad

Revisar capturas, documentos y ficheros:

```bash
grep -RniE 'password|passwd|token|secret|api[_-]?key|authorization' \
  ~/entrega-proyecto-final 2>/dev/null
```

Este comando puede producir falsos positivos. Cada resultado debe revisarse manualmente.

### Comprobar nombres sospechosos

```bash
find ~/entrega-proyecto-final -type f \
  | grep -iE 'secret|password|private|credential'
```

### Revisar manualmente

```text
¿Aparecen contraseñas?

¿Aparecen tokens?

¿Aparecen claves API?

¿Aparecen URLs con parámetros secretos?

¿Aparecen correos personales?

¿Aparecen datos de producción?
```

### Registro

```text
Revisión realizada:

Ficheros revisados:

Secretos encontrados:

Acciones de ocultación:

Resultado:
```

## Sesión 10: completar la memoria técnica

### Objetivo

Redactar la explicación completa del proyecto.

### Estructura recomendada

```markdown
# Memoria técnica del proyecto final

## Identificación

Alumno:

Grupo:

Fecha:

## Resumen ejecutivo

Descripción breve de la solución.

## Objetivos

Objetivos técnicos y operativos.

## Arquitectura

Componentes y flujo de datos.

## Entorno

Sistema operativo y versiones.

## Preparación

Comprobaciones e instalación.

## Consultas PromQL

Consultas y finalidad.

## Dashboard

Paneles, variables y diseño.

## Alertas

Reglas, umbrales, duraciones y etiquetas.

## Notificaciones

Contactos y políticas de laboratorio.

## Anotaciones

Eventos registrados.

## Silenciamientos

Alcance y motivo.

## Pruebas

Activación, notificación y recuperación.

## Diagnóstico

Problemas y soluciones.

## Seguridad

Medidas aplicadas.

## Limitaciones

Restricciones del entorno.

## Conclusiones

Valoración final y mejoras.
```

## Sesión 11: redactar las conclusiones

### Objetivo

Valorar la solución y proponer mejoras.

### Preguntas orientativas

```text
¿Qué parte del proyecto ha sido más sencilla?

¿Qué parte ha requerido más diagnóstico?

¿Qué consulta ha sido más importante?

¿Qué alerta ha sido más crítica?

¿Las duraciones elegidas son adecuadas?

¿Las notificaciones han llegado correctamente?

¿Qué mejoras aplicarías en producción?

¿Qué limitaciones tiene el laboratorio?

¿Qué tareas automatizarías?
```

### Registro

```text
Aprendizaje principal:

Problema más importante:

Solución más relevante:

Limitación:

Mejora propuesta:

Conclusión:
```

## Sesión 12: realizar la revisión final

### Objetivo

Comprobar que la entrega está completa antes de enviarla.

### Lista de revisión

```text
[ ] El README existe.
[ ] El dashboard está documentado.
[ ] El dashboard está exportado o descrito.
[ ] Las consultas están guardadas.
[ ] Las reglas están documentadas.
[ ] Las etiquetas están documentadas.
[ ] Las anotaciones están documentadas.
[ ] Los contactos están documentados sin secretos.
[ ] Las políticas están documentadas.
[ ] Los silenciamientos están documentados.
[ ] Las pruebas de activación están documentadas.
[ ] Las pruebas de recuperación están documentadas.
[ ] Los problemas están documentados.
[ ] Las capturas están organizadas.
[ ] Las credenciales están ocultas.
[ ] La memoria técnica está completa.
[ ] El entorno ha sido revisado.
[ ] No quedan servicios detenidos.
[ ] No quedan cargas ejecutándose.
[ ] No quedan silenciamientos inesperados.
```

## Sesión 13: limpiar el entorno

### Objetivo

Dejar el laboratorio en un estado estable.

### Comprobar Node Exporter

```bash
sudo systemctl status node_exporter
```

### Comprobar Prometheus

```bash
sudo systemctl status prometheus
```

### Comprobar Grafana

```bash
sudo systemctl status grafana-server
```

### Comprobar la disponibilidad

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

### Revisar procesos de carga

```bash
ps aux | grep -E '[s]tress|[s]tress-ng'
```

### Revisar silenciamientos

Comprobar que:

```text
No quedan silenciamientos temporales no documentados.

Los silenciamientos de la práctica han expirado o se han eliminado.

No existen rutas temporales innecesarias.

No hay reglas de prueba activas sin justificación.
```

### Registro

```text
Node Exporter:

Prometheus:

Grafana:

Procesos de carga:

Reglas de prueba:

Silenciamientos:

Contactos temporales:

Estado final:

Validación del instructor:
```

## Ejemplo de entrega completa

### Estructura

```text
entrega-proyecto-final/
├── README.md
├── dashboard/
│   ├── dashboard-operativo.json
│   └── descripcion-dashboard.md
├── consultas/
│   ├── consultas-promql.md
│   └── registro-consultas.txt
├── alertas/
│   ├── reglas-alerta.md
│   ├── etiquetas-anotaciones.md
│   └── pruebas-alertas.md
├── notificaciones/
│   ├── contactos.md
│   └── politicas.md
├── anotaciones/
│   └── eventos-operativos.md
├── silencios/
│   └── silenciamientos.md
├── evidencias/
│   ├── entorno/
│   ├── promql/
│   ├── dashboard/
│   ├── alertas/
│   ├── notificaciones/
│   ├── recuperaciones/
│   └── silencios/
└── informe/
    └── memoria-tecnica.md
```

### Resumen del resultado

```text
Entorno:
Laboratory

Dashboard:
Proyecto final - Dashboard operativo

Paneles:
Disponibilidad, CPU, memoria, almacenamiento y carga

Variable:
instance

Alertas:
Disponibilidad, CPU, memoria y almacenamiento

Notificaciones:
Contacto de laboratorio probado

Anotaciones:
Inicio, mantenimiento y pruebas

Silenciamiento:
Creado y comprobado

Pruebas:
Activación y recuperación documentadas

Resultado:
Solución funcional y documentada
```

## Criterios de evaluación

| Criterio | Puntuación |
|---|---:|
| Organización de la entrega | 1 |
| Validación del entorno | 1 |
| Consultas PromQL | 1 |
| Dashboard operativo | 1 |
| Reglas de alerta | 2 |
| Notificaciones y políticas | 1 |
| Pruebas y recuperaciones | 1 |
| Evidencias técnicas | 1 |
| Memoria y conclusiones | 1 |
| **Total** | **10** |

### Calidad de la documentación

La documentación debe:

- Ser clara.
- Mantener una estructura coherente.
- Utilizar nombres consistentes.
- Explicar las decisiones técnicas.
- Diferenciar configuración y resultado.
- Incluir evidencias suficientes.
- Evitar información sensible.
- Permitir reproducir el proyecto.

### Calidad de las evidencias

Las evidencias deben:

- Mostrar la acción realizada.
- Mostrar el resultado.
- Ser legibles.
- Estar ordenadas.
- Tener nombres descriptivos.
- Corresponder con el informe.
- No contener credenciales.
- Pertenecer al entorno de laboratorio.

## Puntos clave

- La entrega debe demostrar el trabajo realizado, no solo describirlo.
- El README debe explicar cómo revisar el proyecto.
- El dashboard debe estar exportado o suficientemente documentado.
- Las consultas PromQL deben incluir finalidad y unidad.
- Las reglas deben incluir condiciones, duraciones, etiquetas y anotaciones.
- Los contactos deben documentarse sin revelar secretos.
- Las políticas deben relacionarse con las etiquetas.
- Las anotaciones deben aportar contexto temporal.
- Los silenciamientos deben tener alcance, motivo e intervalo.
- Las pruebas deben incluir activación y recuperación.
- Los problemas deben documentarse junto con sus soluciones.
- Las capturas deben ser legibles y relevantes.
- La memoria técnica debe explicar las decisiones tomadas.
- La limpieza final forma parte del entregable.
- El entorno no debe quedar con servicios detenidos.
- No se deben entregar credenciales ni configuraciones sensibles.
- Una buena entrega permite reproducir y revisar el proyecto.
- Las evidencias deben estar relacionadas con los requisitos.
- La revisión final debe hacerse antes de comprimir o enviar los ficheros.
- La solución debe distinguir claramente entre laboratorio y producción.

## Preguntas de comprobación

1. ¿Qué elementos debe incluir la entrega final?
2. ¿Qué función cumple el fichero `README.md`?
3. ¿Qué información debe contener la ficha del entorno?
4. ¿Qué debe mostrar el diagrama de arquitectura?
5. ¿Qué información debe documentarse para cada consulta PromQL?
6. ¿Qué información debe documentarse para cada alerta?
7. ¿Qué diferencia existe entre etiquetas y anotaciones?
8. ¿Qué información puede documentarse sobre un contacto sin revelar secretos?
9. ¿Qué debe incluir una política de notificación?
10. ¿Qué información debe contener un silenciamiento?
11. ¿Qué evidencias demuestran que una alerta se activó?
12. ¿Qué evidencias demuestran que una alerta se recuperó?
13. ¿Cómo documentarías un problema de conectividad?
14. ¿Qué información debe ocultarse antes de entregar las capturas?
15. ¿Por qué debe exportarse o documentarse el dashboard?
16. ¿Qué debe comprobarse durante la limpieza final?
17. ¿Qué harías si encuentras un token dentro de una captura?
18. ¿Cómo comprobarías que la entrega está completa?
19. ¿Qué diferencia existe entre configuración, prueba y resultado?
20. ¿Qué características debe tener una memoria técnica?
21. ¿Por qué deben relacionarse las evidencias con los requisitos?
22. ¿Qué riesgos existen si quedan servicios detenidos?
23. ¿Qué información debe aparecer en las conclusiones?
24. ¿Cómo comprobarías que el entorno pertenece al laboratorio?
25. ¿Qué condiciones deben cumplirse para aceptar la entrega?

## Resultado esperado

La entrega final deberá estar organizada, documentada y lista para ser revisada.

El flujo completado será:

```text
Recopilar configuraciones
        |
        v
Recopilar consultas
        |
        v
Recopilar reglas
        |
        v
Recopilar contactos y políticas
        |
        v
Recopilar anotaciones y silenciamientos
        |
        v
Guardar evidencias
        |
        v
Redactar la memoria
        |
        v
Revisar la seguridad
        |
        v
Comprobar la limpieza
        |
        v
Preparar el README
        |
        v
Revisar la entrega
        |
        v
Enviar el proyecto
```

La entrega se considera completa cuando:

- El dashboard está disponible y documentado.
- Las consultas PromQL están guardadas.
- Las alertas están descritas.
- Las etiquetas y anotaciones están documentadas.
- Los contactos y políticas están identificados.
- Las pruebas de activación y recuperación están registradas.
- Los silenciamientos están justificados.
- Las evidencias son suficientes.
- La memoria técnica está completa.
- Las credenciales están protegidas.
- El entorno queda limpio.
- Otra persona puede comprender y reproducir la solución.

El entregable final debe mostrar no solo que las herramientas funcionan, sino que el alumno sabe construir una solución de observabilidad mantenible: recopilar datos, visualizarlos, detectar problemas, notificar al equipo adecuado, documentar las acciones y demostrar la recuperación.