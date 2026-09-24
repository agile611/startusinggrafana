# Tareas

Las tareas de este proyecto final organizan el trabajo necesario para construir, probar y documentar una solución de observabilidad con Grafana, Prometheus y Node Exporter.

El alumno deberá avanzar de forma progresiva:

```text
Preparar el entorno
        |
        v
Validar los servicios
        |
        v
Comprobar las métricas
        |
        v
Crear consultas PromQL
        |
        v
Construir el dashboard
        |
        v
Configurar alertas
        |
        v
Configurar notificaciones
        |
        v
Crear anotaciones
        |
        v
Probar fallos controlados
        |
        v
Analizar recuperaciones
        |
        v
Documentar y entregar
```

Todas las tareas deben realizarse en un entorno de laboratorio autorizado. No se deben detener servicios ni generar carga sobre sistemas de producción.

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Organizar el trabajo de un proyecto de observabilidad.
- Preparar un plan de tareas reproducible.
- Validar el entorno antes de realizar cambios.
- Comprobar el funcionamiento de Grafana, Prometheus y Node Exporter.
- Validar una fuente de datos de Prometheus.
- Ejecutar consultas PromQL.
- Crear un dashboard operativo.
- Añadir variables y filtros.
- Diseñar reglas de alerta.
- Configurar etiquetas y anotaciones.
- Crear contactos de notificación.
- Configurar políticas de notificación.
- Crear anotaciones operativas.
- Configurar silenciamientos.
- Ejecutar pruebas de activación y recuperación.
- Diagnosticar problemas habituales.
- Organizar evidencias.
- Preparar la entrega final.
- Documentar decisiones, problemas y soluciones.

## Introducción

Un proyecto de observabilidad debe ejecutarse siguiendo un orden lógico.

No es recomendable comenzar creando alertas sin comprobar antes que:

- Prometheus está recopilando métricas.
- Grafana puede consultar la fuente de datos.
- Las consultas devuelven valores correctos.
- Los nombres de las etiquetas son coherentes.
- El alumno tiene permisos suficientes.
- Existe un contacto de laboratorio.
- Las pruebas se pueden realizar de forma segura.

Las tareas se agrupan en seis fases:

```text
Fase 1: Preparación
Fase 2: Validación
Fase 3: Construcción
Fase 4: Alertas y notificaciones
Fase 5: Pruebas
Fase 6: Documentación y entrega
```

## Plan general de trabajo

| Fase | Tareas principales | Resultado |
|---|---|---|
| Preparación | Identificar entorno, permisos y recursos | Entorno documentado |
| Validación | Comprobar servicios, fuente y métricas | Plataforma operativa |
| Construcción | Crear consultas y dashboard | Dashboard funcional |
| Alertas | Crear reglas, contactos y políticas | Alertas configuradas |
| Pruebas | Activar condiciones y comprobar recuperaciones | Evidencias técnicas |
| Entrega | Organizar documentación y limpiar entorno | Proyecto entregable |

## Fase 1: preparación

### Tarea 1: identificar el entorno

Registrar los datos principales:

```text
Alumno:

Grupo:

Fecha de inicio:

Fecha prevista de finalización:

Nombre del host:

Dirección IP:

Sistema operativo:

Versión del sistema:

Entorno:

Responsable del laboratorio:
```

El entorno debe estar identificado como:

```text
laboratory
```

### Tarea 2: comprobar los recursos

Verificar que la máquina dispone de recursos suficientes:

```text
CPU disponible:

Memoria disponible:

Almacenamiento disponible:

Conectividad:

Acceso administrativo:

Acceso web:

Acceso a terminal:
```

Comprobar el almacenamiento:

```bash
df -h
```

Comprobar la memoria:

```bash
free -h
```

Comprobar la CPU:

```bash
nproc
```

Comprobar la información del sistema:

```bash
hostnamectl
```

### Tarea 3: comprobar los permisos

El alumno debe verificar que puede realizar las operaciones necesarias:

```text
Consultar métricas:

Abrir Explore:

Crear un dashboard:

Editar un dashboard:

Crear una regla:

Crear una anotación:

Crear un silencio:

Crear o utilizar un contacto:

Consultar el historial:
```

Registrar los problemas de permisos:

```text
Operación:

Resultado:

Mensaje de error:

Persona responsable:

Corrección:

Resultado posterior:
```

### Tarea 4: crear la estructura de evidencias

Crear los directorios:

```bash
mkdir -p ~/proyecto-final-grafana
mkdir -p ~/proyecto-final-grafana/evidencias
mkdir -p ~/proyecto-final-grafana/evidencias/entorno
mkdir -p ~/proyecto-final-grafana/evidencias/promql
mkdir -p ~/proyecto-final-grafana/evidencias/dashboard
mkdir -p ~/proyecto-final-grafana/evidencias/alertas
mkdir -p ~/proyecto-final-grafana/evidencias/anotaciones
mkdir -p ~/proyecto-final-grafana/evidencias/notificaciones
mkdir -p ~/proyecto-final-grafana/evidencias/silencios
mkdir -p ~/proyecto-final-grafana/informe
```

Crear un registro general:

```bash
cat > ~/proyecto-final-grafana/evidencias/registro-general.txt <<'EOF'
Alumno:

Grupo:

Fecha de inicio:

Fecha de finalización:

Sistema operativo:

Versión de Grafana:

Versión de Prometheus:

Versión de Node Exporter:

Dashboard creado:

Reglas creadas:

Contactos creados:

Políticas creadas:

Anotaciones creadas:

Silenciamientos creados:

Problemas encontrados:

Resultado final:
EOF
```

## Fase 2: validación del entorno

### Tarea 5: comprobar Node Exporter

Comprobar el estado del servicio:

```bash
sudo systemctl status node_exporter
```

Comprobar el endpoint de métricas:

```bash
curl http://localhost:9100/metrics
```

Filtrar algunas métricas:

```bash
curl -s http://localhost:9100/metrics | grep node_cpu_seconds_total
```

```bash
curl -s http://localhost:9100/metrics | grep node_memory_MemTotal_bytes
```

```bash
curl -s http://localhost:9100/metrics | grep node_filesystem_size_bytes
```

Registrar:

```text
Estado del servicio:

Puerto:

Endpoint:

Métricas encontradas:

Resultado:
```

### Tarea 6: comprobar Prometheus

Comprobar el servicio:

```bash
sudo systemctl status prometheus
```

Comprobar la interfaz:

```bash
curl -I http://localhost:9090
```

Ejecutar una consulta mediante la API:

```bash
curl 'http://localhost:9090/api/v1/query?query=up'
```

Comprobar los targets:

```text
http://localhost:9090/targets
```

Registrar:

```text
Estado del servicio:

URL:

Job de Node Exporter:

Instance:

Health:

Último scrape:

Último error:

Resultado:
```

### Tarea 7: comprobar Grafana

Comprobar el servicio:

```bash
sudo systemctl status grafana-server
```

Comprobar el acceso local:

```bash
curl -I http://localhost:3000
```

Abrir Grafana en el navegador y registrar:

```text
URL:

Usuario:

Rol:

Acceso correcto:

Observaciones:
```

### Tarea 8: validar la fuente de datos

Realizar las siguientes acciones:

1. Acceder a Grafana.
2. Abrir la sección de fuentes de datos.
3. Seleccionar Prometheus.
4. Revisar la URL.
5. Ejecutar la prueba de conexión.
6. Guardar la evidencia.
7. Registrar el resultado.

Ficha de la fuente:

```text
Nombre:

Tipo:

URL:

Método de acceso:

Estado:

Fecha de comprobación:

Observaciones:
```

### Tarea 9: comprobar la conectividad

Comprobar los puertos habituales:

```bash
ss -lntp
```

Probar los endpoints:

```bash
curl http://localhost:3000
curl http://localhost:9090
curl http://localhost:9100/metrics
```

Si los componentes están en máquinas diferentes:

```bash
curl http://DIRECCION_PROMETHEUS:9090
curl http://DIRECCION_NODE_EXPORTER:9100/metrics
```

Registrar:

```text
Componente:

Origen:

Destino:

Puerto:

Resultado:

Problema:
```

## Fase 3: consultas y dashboard

### Tarea 10: validar la consulta de disponibilidad

Abrir:

```text
Explore → Prometheus
```

Ejecutar:

```promql
up{job="node_exporter"}
```

Interpretar:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

Registrar:

```text
Consulta:

Número de series:

Instancias:

Valor actual:

Resultado:
```

### Tarea 11: validar la consulta de CPU

Ejecutar:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Comprobar:

```text
¿Devuelve datos?

¿Qué unidad utiliza?

¿Cuántas instancias aparecen?

¿El valor está entre 0 y 100?

¿El resultado es razonable?
```

Registrar:

```text
Valor mínimo:

Valor máximo:

Instancia:

Unidad:

Resultado:
```

### Tarea 12: validar la consulta de memoria

Ejecutar:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Comprobar:

```text
¿Devuelve datos?

¿La unidad es porcentual?

¿Aparece la etiqueta instance?

¿El resultado es razonable?
```

### Tarea 13: validar la consulta de almacenamiento

Ejecutar:

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

Comprobar:

```text
¿Aparece el sistema de ficheros raíz?

¿Se excluyen tmpfs y overlay?

¿La unidad es porcentual?

¿Aparecen resultados duplicados?

¿El valor es razonable?
```

### Tarea 14: documentar las consultas

Crear un fichero:

```bash
cat > ~/proyecto-final-grafana/evidencias/promql/consultas.md <<'EOF'
# Consultas PromQL

## Disponibilidad

```promql
up{job="node_exporter"}
```

## CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Almacenamiento

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
EOF
```

### Tarea 15: crear el dashboard inicial

Crear un dashboard llamado:

```text
Proyecto final - Primer dashboard
```

Añadir los siguientes paneles:

| Panel | Consulta | Visualización |
|---|---|---|
| Disponibilidad | `up{job="node_exporter"}` | Stat |
| CPU | Consulta de CPU | Time series |
| Memoria | Consulta de memoria | Gauge |
| Almacenamiento | Consulta de almacenamiento | Gauge |

Configurar:

```text
Rango temporal:
Últimos 30 minutos

Actualización:
30 segundos o 1 minuto
```

Registrar:

```text
Nombre:

URL:

Número de paneles:

Rango temporal:

Intervalo de actualización:

Resultado:
```

### Tarea 16: mejorar el dashboard

Renombrar el dashboard:

```text
Proyecto final - Dashboard operativo
```

Añadir la descripción:

```text
Dashboard operativo para supervisar disponibilidad,
CPU, memoria y almacenamiento del entorno de laboratorio.
```

Configurar títulos:

```text
Disponibilidad de objetivos
CPU utilizada por instancia
Memoria utilizada por instancia
Almacenamiento utilizado por sistema de ficheros
```

Configurar unidades:

```text
CPU:
Percent (0-100)

Memoria:
Percent (0-100)

Almacenamiento:
Percent (0-100)

Disponibilidad:
none
```

Configurar umbrales visuales:

```text
CPU:
0-80 = verde
80-90 = amarillo
90-100 = rojo

Memoria:
0-80 = verde
80-90 = amarillo
90-100 = rojo

Almacenamiento:
0-70 = verde
70-80 = amarillo
80-100 = rojo
```

### Tarea 17: añadir una variable de instancia

Crear una variable llamada:

```text
instance
```

Utilizar una consulta equivalente a:

```promql
label_values(up{job="node_exporter"}, instance)
```

Aplicar la variable a la consulta de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

Aplicar la variable a la consulta de memoria:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance=~"$instance"
  }
  /
  node_memory_MemTotal_bytes{
    instance=~"$instance"
  }
)
```

Aplicar la variable a la consulta de disponibilidad:

```promql
up{
  job="node_exporter",
  instance=~"$instance"
}
```

Probar:

1. Seleccionar una instancia.
2. Revisar los paneles.
3. Seleccionar todas las instancias.
4. Comparar los resultados.
5. Comprobar que no aparecen series inesperadas.

Registrar:

```text
Nombre de la variable:

Consulta:

Valores disponibles:

Filtro seleccionado:

Resultado:
```

## Fase 4: reglas y notificaciones

### Tarea 18: diseñar las reglas de alerta

Completar la tabla antes de crear las reglas:

| Regla | Consulta | Condición | Duración | Severidad |
|---|---|---|---|---|
| NodeExporterDown | | | | |
| HighCPUUsage | | | | |
| HighMemoryUsage | | | | |
| FilesystemUsageHigh | | | | |

Propuesta:

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

### Tarea 19: crear la alerta de disponibilidad

Nombre:

```text
NodeExporterDown-Laboratory
```

Consulta:

```promql
up{job="node_exporter"}
```

Configuración:

```text
Reducción:
Last

Condición:
Igual a 0

Intervalo:
30 segundos

Duración:
1 minuto
```

Etiquetas:

```text
alertname = NodeExporterDown-Laboratory
severity = critical
team = systems
service = node_exporter
environment = laboratory
resource = availability
```

Anotaciones:

```text
summary = Node Exporter no disponible en {{ $labels.instance }}

description = El objetivo {{ $labels.instance }}
no responde a Prometheus en el entorno de laboratorio.

runbook_url = https://example.com/runbooks/node-exporter-down
```

Registrar:

```text
Nombre:

Consulta:

Reducción:

Condición:

Duración:

Etiquetas:

Anotaciones:

Estado inicial:
```

### Tarea 20: crear la alerta de CPU

Nombre:

```text
HighCPUUsage-Laboratory
```

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración:

```text
Reducción:
Last

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos
```

Etiquetas:

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

Anotaciones:

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

Justificación:

```text
La duración de cinco minutos evita generar una alerta
por un pico breve que no representa necesariamente
un problema sostenido.
```

### Tarea 21: crear la alerta de memoria

Nombre:

```text
HighMemoryUsage-Laboratory
```

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración:

```text
Reducción:
Last

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos
```

Etiquetas:

```text
alertname = HighMemoryUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = memory
```

Anotaciones:

```text
summary = Memoria elevada en {{ $labels.instance }}

description = La memoria utilizada en {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-memory
```

### Tarea 22: crear la alerta de almacenamiento

Nombre:

```text
FilesystemUsageHigh-Laboratory
```

Consulta:

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

Configuración:

```text
Reducción:
Last

Condición:
Mayor que 80

Intervalo:
5 minutos

Duración:
10 minutos
```

Etiquetas:

```text
alertname = FilesystemUsageHigh-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = filesystem
mountpoint = /
```

Anotaciones:

```text
summary = Almacenamiento elevado en {{ $labels.instance }}

description = El sistema de ficheros raíz de
{{ $labels.instance }} supera el 80 % de utilización.

runbook_url = https://example.com/runbooks/filesystem-full
```

### Tarea 23: crear un contacto de laboratorio

Crear un contacto llamado:

```text
laboratory-observability
```

Utilizar uno de estos destinos:

- Correo de formación.
- Webhook de pruebas.
- Canal colaborativo autorizado.
- Sistema ITSM de laboratorio.

Probar el contacto y registrar:

```text
Nombre:

Tipo:

Destino general:

Fecha de prueba:

Resultado:

Tiempo de entrega:

Observaciones:
```

No guardar tokens, contraseñas ni claves en el registro.

### Tarea 24: crear una política de notificación

Crear una política para las alertas del laboratorio.

Coincidencia:

```text
environment = laboratory
```

Contacto:

```text
laboratory-observability
```

Agrupación:

```text
group_by:
- alertname
- instance
```

Temporización de laboratorio:

```text
group_wait:
10 segundos

group_interval:
1 minuto

repeat_interval:
5 minutos
```

Registrar:

```text
Coincidencia:

Contacto:

Agrupación:

group_wait:

group_interval:

repeat_interval:

Resultado:
```

## Fase 5: anotaciones y pruebas

### Tarea 25: crear anotaciones operativas

Crear una anotación de inicio:

```text
Título:
Inicio del proyecto final

Descripción:
Comienza la configuración del entorno de observabilidad.
```

Etiquetas:

```text
event = project-start
environment = laboratory
team = training
```

Crear una anotación de prueba de carga:

```text
Título:
Inicio de prueba de carga

Descripción:
Se inicia una prueba controlada sobre el servidor de laboratorio.
```

Etiquetas:

```text
event = load-test
environment = laboratory
```

Crear una anotación de mantenimiento:

```text
Título:
Mantenimiento de Node Exporter

Descripción:
Se detendrá temporalmente Node Exporter para validar
la alerta de disponibilidad.
```

Etiquetas:

```text
event = maintenance
environment = laboratory
service = node_exporter
```

### Tarea 26: probar la alerta de disponibilidad

Antes de la prueba, comprobar:

```text
Estado inicial:
Normal
```

Crear una anotación:

```text
Título:
Inicio de prueba de disponibilidad

Descripción:
Se detendrá Node Exporter para validar
NodeExporterDown-Laboratory.
```

Detener Node Exporter únicamente en el laboratorio:

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

Hora de notificación:

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

Hora de notificación de recuperación:

Duración total:

Resultado:
```

### Tarea 27: probar la alerta de CPU

Crear una anotación:

```text
Título:
Prueba controlada de CPU

Descripción:
Se inicia una carga controlada para validar
HighCPUUsage-Laboratory.
```

Consultar el estado actual:

```bash
top
```

Si está autorizado:

```bash
stress-ng --cpu 1 --timeout 60s
```

La regla utiliza:

```text
Umbral:
90 %

Duración:
5 minutos
```

Registrar:

```text
Valor máximo observado:

Duración por encima del umbral:

Estado alcanzado:

¿Se notificó?:

¿Era el resultado esperado?:

Explicación:
```

Una prueba de 60 segundos puede no activar la alerta. Esto permite comprobar el efecto del periodo de duración.

### Tarea 28: probar la alerta de memoria

Antes de realizar cualquier prueba, registrar:

```text
Memoria total:

Memoria disponible:

Porcentaje utilizado:
```

Si el instructor autoriza una prueba controlada, utilizar una carga limitada.

No se debe consumir toda la memoria del sistema.

Registrar:

```text
Valor observado:

Estado de la alerta:

Duración de la condición:

Notificación:

Recuperación:

Resultado:
```

Si no es seguro activar la condición, documentar la consulta y explicar cómo se probaría en un entorno controlado.

### Tarea 29: probar el silenciamiento

Crear un silencio para:

```text
alertname = NodeExporterDown-Laboratory
instance = server-01:9100
environment = laboratory
```

Configurar:

```text
Inicio:
Hora actual

Fin:
20 minutos después

Comentario:
Mantenimiento autorizado de Node Exporter en laboratorio.
Referencia: LAB-NODE-001.
```

Procedimiento:

1. Confirmar que el silencio está activo.
2. Detener Node Exporter.
3. Comprobar que la regla se evalúa.
4. Comprobar que la alerta aparece en Grafana.
5. Comprobar que la notificación queda suprimida.
6. Iniciar Node Exporter.
7. Comprobar la recuperación.
8. Revisar el estado del silencio.

Registrar:

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

### Tarea 30: comprobar una alerta sin coincidencia

Utilizar una alerta con:

```text
alertname = TestUnmatchedAlert
team = unknown
severity = warning
environment = laboratory
```

Procedimiento:

1. Revisar las políticas.
2. Confirmar que no existe una ruta para `team=unknown`.
3. Activar la alerta.
4. Comprobar el contacto utilizado.
5. Revisar la política predeterminada.
6. Crear una ruta específica.
7. Repetir la prueba.
8. Comparar los resultados.

Registrar:

```text
Contacto inicial:

Política utilizada:

Ruta creada:

Contacto posterior:

Diferencia observada:

Conclusión:
```

## Fase 6: diagnóstico y documentación

### Tarea 31: diagnosticar una alerta que no se activa

Situación:

```text
El dashboard muestra CPU elevada,
pero la alerta permanece en Normal.
```

Comprobar:

- Consulta en Explore.
- Valor actual.
- Umbral.
- Reducción.
- Duración.
- Intervalo de evaluación.
- Estado de la regla.
- Etiquetas.
- Errores de consulta.
- Política de ausencia de datos.

Posibles causas:

```text
El valor no supera realmente el umbral.
La condición todavía no ha durado lo suficiente.
La consulta devuelve otra instancia.
La reducción no es adecuada.
La regla está pausada.
La consulta no devuelve datos.
La unidad es incorrecta.
```

Registrar:

```text
Regla:

Valor observado:

Umbral:

Reducción:

Duración:

Estado:

Causa:

Corrección:

Resultado:
```

### Tarea 32: diagnosticar una alerta sin notificación

Situación:

```text
La alerta está en Alerting,
pero el contacto no recibe ningún mensaje.
```

Revisar:

- Etiquetas.
- Política.
- Contacto.
- Silenciamientos.
- Agrupación.
- Repetición.
- Logs de Grafana.
- Estado del receptor externo.

Registrar:

```text
Alerta:

Estado:

Política coincidente:

Contacto esperado:

Contacto utilizado:

Silencio:

Error:

Corrección:

Resultado:
```

### Tarea 33: reconstruir la línea temporal

Completar:

```text
Hora:

Evento:

Métrica:

Estado de alerta:

Notificación:

Acción:
```

Ejemplo:

```text
18:00 - Inicio de prueba de carga
18:02 - La CPU aumenta
18:05 - Se supera el umbral
18:05 - La alerta pasa a Pending
18:10 - La alerta pasa a Alerting
18:11 - Se recibe la notificación
18:12 - Finaliza la prueba
18:16 - La CPU vuelve a la normalidad
18:17 - La alerta se recupera
```

### Tarea 34: preparar las evidencias

Guardar capturas con nombres ordenados:

```text
01-entorno-validado.png
02-fuente-prometheus.png
03-target-node-exporter.png
04-consulta-up.png
05-consulta-cpu.png
06-consulta-memoria.png
07-consulta-almacenamiento.png
08-dashboard-inicial.png
09-dashboard-operativo.png
10-variable-instance.png
11-regla-disponibilidad.png
12-regla-cpu.png
13-regla-memoria.png
14-regla-almacenamiento.png
15-anotacion-mantenimiento.png
16-contacto-notificacion.png
17-politica-notificacion.png
18-alerta-pending.png
19-alerta-alerting.png
20-notificacion-recibida.png
21-silencio-activo.png
22-alerta-resolved.png
23-dashboard-final.png
```

Revisar antes de entregar:

```text
¿La captura demuestra una acción concreta?

¿Se identifica el entorno?

¿Se ven las etiquetas necesarias?

¿Se ocultan los secretos?

¿La captura es legible?

¿La fecha o la hora son relevantes?
```

### Tarea 35: realizar la limpieza final

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

Revisar:

- Servicios detenidos.
- Procesos de carga.
- Reglas temporales.
- Contactos de laboratorio.
- Políticas de prueba.
- Silenciamientos activos.
- Anotaciones.
- Dashboards.
- Cambios no documentados.

Registrar:

```text
Node Exporter:

Prometheus:

Grafana:

Servicios restaurados:

Procesos de carga detenidos:

Silenciamientos restantes:

Reglas temporales eliminadas:

Contactos temporales eliminados:

Entorno limpio:

Validación del instructor:
```

## Lista de comprobación final

### Entorno

```text
[ ] La máquina de laboratorio está identificada.
[ ] Grafana está operativo.
[ ] Prometheus está operativo.
[ ] Node Exporter está operativo.
[ ] El endpoint de métricas responde.
[ ] El target aparece como UP.
[ ] La fuente de datos funciona.
```

### Consultas

```text
[ ] La consulta de disponibilidad funciona.
[ ] La consulta de CPU funciona.
[ ] La consulta de memoria funciona.
[ ] La consulta de almacenamiento funciona.
[ ] Las unidades están documentadas.
[ ] Las consultas están guardadas.
```

### Dashboard

```text
[ ] Existe un dashboard inicial.
[ ] Existe un dashboard operativo.
[ ] Los títulos son claros.
[ ] Las unidades son correctas.
[ ] Los umbrales visuales están configurados.
[ ] Existe una variable de instancia.
[ ] Las anotaciones aparecen.
[ ] El dashboard se ha guardado.
```

### Alertas

```text
[ ] Existe una alerta de disponibilidad.
[ ] Existe una alerta de CPU.
[ ] Existe una alerta de memoria.
[ ] Existe una alerta de almacenamiento.
[ ] Las etiquetas son coherentes.
[ ] Las anotaciones son descriptivas.
[ ] Las duraciones están justificadas.
```

### Notificaciones

```text
[ ] Existe un contacto de laboratorio.
[ ] El contacto se ha probado.
[ ] Existe una política.
[ ] La política coincide con environment=laboratory.
[ ] Se ha probado una notificación.
[ ] Se ha comprobado una recuperación.
```

### Silenciamientos

```text
[ ] Existe un silencio controlado.
[ ] El silencio tiene coincidencias específicas.
[ ] Tiene una hora de inicio.
[ ] Tiene una hora de finalización.
[ ] Tiene un comentario.
[ ] Se ha comprobado su alcance.
[ ] Se ha revisado al finalizar.
```

### Entrega

```text
[ ] Las evidencias están organizadas.
[ ] Las credenciales están ocultas.
[ ] La memoria técnica está completa.
[ ] Los problemas están documentados.
[ ] Las soluciones están documentadas.
[ ] El entorno está limpio.
[ ] Se ha realizado la validación final.
```

## Estructura de la entrega

La entrega recomendada es:

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
│   ├── promql/
│   ├── dashboard/
│   ├── alertas/
│   ├── anotaciones/
│   ├── notificaciones/
│   └── silencios/
├── informe/
│   └── memoria-tecnica.md
└── README.md
```

### Contenido del README

```text
Nombre del alumno:

Grupo:

Descripción del proyecto:

Entorno utilizado:

Requisitos:

Tareas realizadas:

Dashboard principal:

Reglas creadas:

Contacto de notificación:

Pruebas realizadas:

Limitaciones:

Resultado final:
```

## Puntos clave

- Las tareas deben ejecutarse en un orden lógico.
- La preparación precede a la configuración.
- La validación precede a la creación de dashboards y alertas.
- Las consultas PromQL deben probarse antes de reutilizarlas.
- Las reglas deben tener umbrales y duraciones justificadas.
- Las etiquetas permiten organizar y enrutar alertas.
- Las anotaciones aportan contexto operativo.
- Las notificaciones deben utilizar contactos de laboratorio.
- Los silenciamientos deben ser específicos y temporales.
- Las pruebas deben incluir activación y recuperación.
- Los errores deben investigarse mediante evidencias.
- La documentación debe registrar decisiones y resultados.
- La limpieza final forma parte del proyecto.
- Ninguna tarea debe poner en riesgo los sistemas de producción.
- Las credenciales nunca deben aparecer en las evidencias.
- El proyecto debe poder reproducirse a partir de la documentación.
- Una tarea no está completa hasta que su resultado queda registrado.

## Preguntas de comprobación

1. ¿Por qué es importante organizar las tareas por fases?
2. ¿Qué debe comprobarse antes de crear un dashboard?
3. ¿Qué debe comprobarse antes de crear una alerta?
4. ¿Qué función cumple la validación de Node Exporter?
5. ¿Cómo se comprueba que Prometheus recopila métricas?
6. ¿Qué consulta utilizarías para comprobar la disponibilidad?
7. ¿Qué diferencia existe entre una consulta y una regla de alerta?
8. ¿Qué información debe documentarse para cada regla?
9. ¿Qué etiquetas se deben utilizar en las alertas?
10. ¿Qué función cumple una política de notificación?
11. ¿Cómo probarías un contacto de laboratorio?
12. ¿Qué condiciones debe cumplir un silenciamiento?
13. ¿Qué revisarías si una alerta no se activa?
14. ¿Qué revisarías si una alerta se activa, pero no genera una notificación?
15. ¿Por qué debe comprobarse la recuperación?
16. ¿Qué información debe contener una evidencia?
17. ¿Qué tareas deben realizarse antes de entregar el proyecto?
18. ¿Qué elementos deben eliminarse o revisarse durante la limpieza?
19. ¿Cómo documentarías una limitación del entorno?
20. ¿Qué características debe tener una tarea correctamente completada?

## Resultado esperado

El proyecto se considera correctamente realizado cuando el alumno completa este flujo:

```text
Identificar el entorno
        |
        v
Comprobar requisitos
        |
        v
Validar servicios
        |
        v
Validar métricas
        |
        v
Crear consultas
        |
        v
Construir el dashboard
        |
        v
Crear reglas de alerta
        |
        v
Configurar notificaciones
        |
        v
Crear anotaciones
        |
        v
Probar fallos controlados
        |
        v
Comprobar recuperaciones
        |
        v
Diagnosticar problemas
        |
        v
Guardar evidencias
        |
        v
Limpiar el entorno
        |
        v
Preparar la entrega
```

Una tarea está completada cuando:

- Se ha ejecutado en el entorno adecuado.
- El resultado se ha comprobado.
- Los problemas se han registrado.
- Las correcciones se han documentado.
- La evidencia correspondiente está guardada.
- No quedan cambios temporales sin revisar.
- La información puede ser entendida por otra persona.

La finalidad del proyecto no es completar una lista de comandos, sino demostrar que el alumno sabe organizar un proceso técnico completo: preparar, validar, construir, probar, diagnosticar y documentar una solución de observabilidad.