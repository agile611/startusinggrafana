# Proyecto final

El proyecto final integra los conocimientos adquiridos durante el curso para construir una solución completa de observabilidad con Grafana, Prometheus y Node Exporter.

Durante el proyecto, el alumno preparará un entorno de monitorización, validará métricas con PromQL, creará dashboards operativos, configurará alertas, probará notificaciones y documentará los resultados.

El objetivo no es únicamente completar varias tareas aisladas. El alumno debe demostrar que puede diseñar un flujo completo:

```text
Preparar el entorno
        |
        v
Recopilar métricas
        |
        v
Consultar datos con PromQL
        |
        v
Crear dashboards
        |
        v
Definir alertas
        |
        v
Configurar notificaciones
        |
        v
Probar fallos controlados
        |
        v
Analizar la recuperación
        |
        v
Documentar la solución
```

El proyecto debe realizarse únicamente en un entorno de laboratorio autorizado. No se deben detener servicios ni generar carga sobre sistemas de producción.

## Objetivos

Al finalizar este bloque, el alumno podrá:

- Preparar un entorno básico de observabilidad.
- Comprobar el funcionamiento de Grafana, Prometheus y Node Exporter.
- Validar que Prometheus recopila métricas correctamente.
- Utilizar consultas PromQL para analizar el sistema.
- Crear un dashboard operativo.
- Diseñar paneles útiles para sistemas y aplicaciones.
- Configurar variables y filtros en un dashboard.
- Crear reglas de alerta basadas en métricas.
- Definir umbrales y periodos de duración.
- Añadir etiquetas y anotaciones a las alertas.
- Configurar contactos de notificación.
- Crear políticas de notificación.
- Probar alertas de disponibilidad, CPU, memoria y almacenamiento.
- Comprobar los estados `Normal`, `Pending` y `Alerting`.
- Verificar la recuperación de una alerta.
- Crear anotaciones manuales sobre cambios y mantenimientos.
- Utilizar silenciamientos durante actividades planificadas.
- Diagnosticar problemas de consultas, alertas y notificaciones.
- Preparar evidencias técnicas.
- Elaborar una memoria final del proyecto.
- Presentar una solución ordenada, reproducible y mantenible.

## Contenidos

El proyecto se divide en las siguientes áreas:

- Preparación del escenario.
- Revisión de requisitos.
- Instalación o validación de Node Exporter.
- Comprobación de Prometheus.
- Comprobación de Grafana.
- Validación de la fuente de datos.
- Consultas básicas con PromQL.
- Consultas de disponibilidad.
- Consultas de CPU.
- Consultas de memoria.
- Consultas de almacenamiento.
- Primer dashboard.
- Dashboard operativo.
- Variables y filtros.
- Reglas de alerta.
- Etiquetas y anotaciones.
- Contactos de notificación.
- Políticas de notificación.
- Silenciamientos.
- Pruebas de activación.
- Pruebas de recuperación.
- Diagnóstico de errores.
- Documentación y entrega.

## Escenario del proyecto

Una organización ficticia desea implantar una plataforma básica de observabilidad para supervisar sus servidores.

El equipo necesita:

- Consultar el estado de los servidores.
- Detectar caídas de servicios.
- Identificar un uso elevado de CPU.
- Detectar problemas de memoria.
- Controlar la ocupación del almacenamiento.
- Visualizar las métricas desde un dashboard.
- Recibir notificaciones cuando exista un problema.
- Relacionar los incidentes con mantenimientos y despliegues.
- Disponer de evidencias para revisar las acciones realizadas.

La infraestructura del laboratorio estará formada por:

```text
Servidor de prácticas
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
        +--> Alertas
        |
        +--> Notificaciones
        |
        +--> Anotaciones
```

## Resultado final esperado

El alumno deberá entregar una solución que incluya:

- Un entorno funcional.
- Un dashboard operativo.
- Consultas PromQL documentadas.
- Reglas de alerta configuradas.
- Contactos de notificación de laboratorio.
- Políticas de notificación.
- Anotaciones de eventos.
- Pruebas de activación y recuperación.
- Un silenciamiento controlado.
- Evidencias de las pruebas.
- Una memoria técnica.

## Prácticas relacionadas

Las prácticas del proyecto deben realizarse en el orden siguiente:

1. Primer dashboard.
2. Node Exporter.
3. Consultas PromQL.
4. Dashboard operativo.
5. Alertas.
6. Integración final.
7. Documentación y entrega.

La secuencia recomendada es:

```text
05-practica-01-primer-dashboard.md
06-practica-02-node-exporter.md
07-practica-03-promql.md
08-practica-04-dashboard-operativo.md
09-practica-05-alertas.md
10-entregables.md
11-criterios-evaluacion.md
```

## Requisitos técnicos

Antes de comenzar, el alumno debe disponer de:

- Una máquina virtual o servidor de laboratorio.
- Acceso administrativo controlado.
- Grafana instalado.
- Prometheus instalado.
- Node Exporter instalado o disponible.
- Acceso a la interfaz web de Grafana.
- Permisos para consultar datos.
- Permisos para crear dashboards.
- Permisos para crear reglas de alerta.
- Permisos para crear contactos de laboratorio.
- Un canal de notificación de pruebas.
- Una terminal para ejecutar comprobaciones.
- Un navegador web actualizado.

Registrar la información del entorno:

```text
Alumno:

Grupo:

Fecha:

Sistema operativo:

Dirección o nombre del host:

Versión de Grafana:

Versión de Prometheus:

Versión de Node Exporter:

URL de Grafana:

URL de Prometheus:

Contacto de laboratorio:
```

## Reglas de seguridad

El proyecto se ejecutará en un entorno controlado.

No se deben realizar las siguientes acciones sobre producción:

```text
Detener servicios.
Generar carga artificial.
Modificar reglas de firewall.
Cambiar configuraciones críticas.
Crear notificaciones reales.
Eliminar archivos.
Reiniciar servidores sin autorización.
```

Las credenciales no deben aparecer en:

- Capturas de pantalla.
- Ficheros Markdown.
- Logs compartidos.
- Informes.
- Comandos copiados.
- Evidencias entregadas.

Las notificaciones deben utilizar contactos de laboratorio.

## Estructura de directorios recomendada

Crear una estructura de trabajo:

```bash
mkdir -p ~/proyecto-final-grafana
mkdir -p ~/proyecto-final-grafana/evidencias
mkdir -p ~/proyecto-final-grafana/evidencias/dashboard
mkdir -p ~/proyecto-final-grafana/evidencias/promql
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

## Sesión 1: comprobar el entorno

### Objetivo

Verificar que todos los componentes necesarios están disponibles.

### Comprobación de servicios

Comprobar Node Exporter:

```bash
sudo systemctl status node_exporter
```

Comprobar Prometheus:

```bash
sudo systemctl status prometheus
```

Comprobar Grafana:

```bash
sudo systemctl status grafana-server
```

Si los servicios se ejecutan mediante contenedores:

```bash
docker ps
```

Comprobar los puertos en escucha:

```bash
ss -lntp
```

Comprobar la conectividad con Node Exporter:

```bash
curl http://localhost:9100/metrics
```

El resultado debe contener métricas como:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_filesystem_size_bytes
```

### Registro

```text
Node Exporter:

Prometheus:

Grafana:

Puerto de Node Exporter:

Conectividad:

Observaciones:
```

### Resultado esperado

```text
Los servicios están activos.
Node Exporter expone métricas.
Prometheus está disponible.
Grafana puede abrirse desde el navegador.
```

## Sesión 2: comprobar la fuente de datos

### Objetivo

Confirmar que Grafana puede consultar Prometheus.

### Procedimiento

1. Acceder a Grafana.
2. Abrir la sección de fuentes de datos.
3. Seleccionar Prometheus.
4. Ejecutar la prueba de conexión.
5. Confirmar que la fuente funciona.
6. Registrar el resultado.

### Datos de la fuente

```text
Nombre:

Tipo:

URL:

Estado de conexión:

Fecha de comprobación:

Observaciones:
```

### Diagnóstico

Si la prueba falla, revisar:

- URL de Prometheus.
- Estado del servicio.
- Resolución de nombres.
- Conectividad de red.
- Restricciones de firewall.
- Logs de Grafana.
- Logs de Prometheus.

## Sesión 3: validar consultas PromQL

### Objetivo

Comprobar que las métricas necesarias están disponibles.

Abrir:

```text
Explore → Prometheus
```

### Disponibilidad general

```promql
up
```

### Disponibilidad de Node Exporter

```promql
up{job="node_exporter"}
```

Interpretar los valores:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

### CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento utilizado

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

### Guardar las consultas

```bash
cat > ~/proyecto-final-grafana/evidencias/promql/consultas.txt <<'EOF'
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

### Registro

```text
Consulta:

¿Devuelve datos?:

Número de series:

Etiquetas observadas:

Unidad:

Observaciones:
```

## Sesión 4: crear el primer dashboard

### Objetivo

Construir un dashboard básico con las métricas principales.

Crear un dashboard llamado:

```text
Proyecto final - Primer dashboard
```

### Panel de disponibilidad

```promql
up{job="node_exporter"}
```

Configuración:

```text
Título:
Disponibilidad de Node Exporter

Visualización:
Stat

Unidad:
none
```

### Panel de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración:

```text
Título:
CPU utilizada

Visualización:
Time series

Unidad:
Percent (0-100)
```

### Panel de memoria

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
Título:
Memoria utilizada

Visualización:
Gauge o Time series

Unidad:
Percent (0-100)
```

### Panel de almacenamiento

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
Título:
Almacenamiento utilizado

Visualización:
Gauge

Unidad:
Percent (0-100)
```

### Registro

Guardar el dashboard y registrar:

```text
Nombre:

URL:

Número de paneles:

Rango temporal utilizado:

Intervalo de actualización:

Observaciones:
```

## Sesión 5: crear un dashboard operativo

### Objetivo

Transformar el primer dashboard en una vista útil para operaciones.

### Configuración general

Renombrar el dashboard como:

```text
Proyecto final - Dashboard operativo
```

Añadir una descripción:

```text
Dashboard operativo para supervisar disponibilidad,
CPU, memoria y almacenamiento de los servidores de laboratorio.
```

### Títulos de los paneles

Configurar los paneles con títulos claros:

```text
Disponibilidad de objetivos
CPU utilizada por instancia
Memoria utilizada por instancia
Almacenamiento utilizado por sistema de ficheros
```

### Umbrales visuales

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

### Revisión

Revisar:

- Títulos.
- Unidades.
- Leyendas.
- Etiquetas.
- Rangos temporales.
- Colores.
- Enlaces.
- Legibilidad.

### Registro

```text
Panel mejorado:

Cambio aplicado:

Motivo:

Resultado:
```

## Sesión 6: añadir variables al dashboard

### Objetivo

Permitir seleccionar una instancia desde el dashboard.

Crear una variable llamada:

```text
instance
```

### Consulta de la variable

```promql
label_values(up{job="node_exporter"}, instance)
```

Si la función no está disponible en la versión utilizada, consultar las etiquetas mediante el mecanismo equivalente del datasource.

### Consulta de CPU con variable

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

### Consulta de memoria con variable

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

### Consulta de disponibilidad con variable

```promql
up{
  job="node_exporter",
  instance=~"$instance"
}
```

### Pruebas

1. Seleccionar una instancia.
2. Comprobar que cambian los paneles.
3. Seleccionar todas las instancias.
4. Comprobar que se muestran todas.
5. Revisar que no aparecen series inesperadas.

### Registro

```text
Variable:

Consulta:

Valores disponibles:

Filtro aplicado:

Resultado:
```

## Sesión 7: crear una alerta de disponibilidad

### Objetivo

Detectar que Node Exporter deja de responder.

### Configuración

Nombre:

```text
NodeExporterDown-Laboratory
```

Consulta:

```promql
up{job="node_exporter"}
```

Condición:

```text
Último valor igual a 0
```

Evaluación:

```text
Intervalo:
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

Guardar la regla y comprobar que empieza en estado `Normal`.

### Registro

```text
Nombre:

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

Estado inicial:
```

## Sesión 8: crear una alerta de CPU

### Objetivo

Detectar un uso sostenido de CPU superior al 90 %.

### Configuración

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

Condición:

```text
Último valor mayor que 90
```

Evaluación:

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

### Justificación de la duración

La duración evita generar una alerta por un pico breve que no representa necesariamente un problema sostenido.

## Sesión 9: crear una alerta de memoria

### Objetivo

Detectar un uso de memoria superior al 90 %.

### Configuración

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

Condición:

```text
Último valor mayor que 90
```

Evaluación:

```text
Intervalo:
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

## Sesión 10: crear una alerta de almacenamiento

### Objetivo

Detectar un uso elevado del sistema de ficheros raíz.

### Configuración

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

Condición:

```text
Último valor mayor que 80
```

Evaluación:

```text
Intervalo:
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

## Sesión 11: crear anotaciones operativas

### Objetivo

Registrar eventos que puedan explicar cambios en las métricas.

### Anotación de inicio

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

### Anotación de despliegue

```text
Título:
Despliegue de aplicación de prueba

Descripción:
Se despliega una versión de prueba para observar
su posible impacto en las métricas del servidor.
```

Etiquetas:

```text
event = deployment
environment = laboratory
service = demo-app
```

### Anotación de prueba de carga

```text
Título:
Inicio de prueba de carga

Descripción:
Se ejecuta una carga controlada sobre la máquina de prácticas.
```

Etiquetas:

```text
event = load-test
environment = laboratory
```

### Anotación de mantenimiento

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

Comprobar que las anotaciones aparecen en el dashboard.

## Sesión 12: crear un contacto de notificación

### Objetivo

Configurar un destino de laboratorio.

Utilizar un correo, webhook o canal colaborativo autorizado.

### Ejemplo

```text
Nombre:
laboratory-observability

Tipo:
Canal de laboratorio

Finalidad:
Recibir las alertas del proyecto final
```

### Procedimiento

1. Acceder a la configuración de alertas.
2. Crear un contacto.
3. Introducir los datos del canal.
4. Guardar.
5. Ejecutar una prueba.
6. Comprobar la recepción.
7. Registrar el resultado.

No incluir credenciales en el informe.

### Registro

```text
Nombre del contacto:

Tipo:

Fecha de creación:

Prueba ejecutada:

Resultado:

Tiempo aproximado de entrega:

Observaciones:
```

## Sesión 13: crear una política de notificación

### Objetivo

Enviar las alertas del entorno de laboratorio al contacto creado.

### Configuración

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

Crear la ruta y guardar.

Probar con una alerta de laboratorio.

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

## Sesión 14: probar el ciclo de disponibilidad

### Objetivo

Comprobar la activación, notificación y recuperación de una alerta.

### Preparación

Crear primero una anotación:

```text
Título:
Inicio de prueba de disponibilidad

Descripción:
Se detendrá Node Exporter para validar
NodeExporterDown-Laboratory.
```

Comprobar el estado inicial:

```text
Normal
```

### Detener Node Exporter

Detener Node Exporter únicamente en la máquina de laboratorio:

```bash
sudo systemctl stop node_exporter
```

Observar el ciclo:

```text
Normal
   |
   v
Pending
   |
   v
Alerting
```

### Registro de la activación

```text
Hora de detención:

Hora de Pending:

Hora de Alerting:

Hora de recepción de la notificación:

Instancia afectada:

Contacto utilizado:
```

### Recuperar el servicio

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

Hora de recepción de la recuperación:

Duración total:

Resultado:
```

## Sesión 15: probar la alerta de CPU

### Objetivo

Observar el comportamiento de una alerta con periodo de duración.

Crear una anotación:

```text
Título:
Prueba controlada de CPU

Descripción:
Se inicia una prueba de carga para validar
HighCPUUsage-Laboratory.
```

Consultar el estado actual:

```bash
top
```

Si la herramienta está disponible, generar carga controlada:

```bash
stress-ng --cpu 1 --timeout 60s
```

La alerta está configurada con:

```text
Umbral:
90 %

Duración:
5 minutos
```

Una carga de solo 60 segundos puede no activar la alerta. Esto permite comprobar que la duración evita alertas por picos breves.

### Registro

```text
Valor máximo observado:

Duración por encima del umbral:

Estado alcanzado:

¿Se notificó?:

¿Era el resultado esperado?:

Explicación:
```

Si el instructor autoriza una prueba de activación completa, utilizar una duración compatible con el periodo configurado.

## Sesión 16: probar una alerta de memoria

### Objetivo

Validar la regla de memoria sin poner en riesgo el sistema.

Antes de generar carga, registrar:

```text
Memoria total:

Memoria disponible:

Porcentaje utilizado:
```

Si el entorno lo permite y el instructor lo autoriza, utilizar una prueba limitada.

No se debe consumir toda la memoria del sistema.

Observar:

```text
Valor de memoria:

Estado de la alerta:

Duración de la condición:

Notificación:

Recuperación:
```

Si no es seguro generar la condición, documentar la prueba de consulta y explicar cómo se activaría en un entorno controlado.

## Sesión 17: probar un silenciamiento

### Objetivo

Verificar que una alerta puede seguir evaluándose sin enviar notificaciones durante una actividad conocida.

Crear una anotación:

```text
Título:
Inicio de mantenimiento de laboratorio

Descripción:
Se detendrá Node Exporter para validar un silenciamiento temporal.
```

### Crear el silencio

Crear un silencio con estas coincidencias:

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
Mantenimiento autorizado del laboratorio.
Prueba de silenciamiento asociada al proyecto final.
```

### Activar la alerta

```bash
sudo systemctl stop node_exporter
```

Comprobar:

```text
La regla se evalúa.
La alerta aparece como activa.
El silencio está activo.
La notificación queda suprimida.
```

### Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

### Registro

```text
Silencio creado:

Coincidencias:

Inicio:

Fin:

Alerta afectada:

Estado de la alerta:

Notificación suprimida:

Hora de recuperación:

Resultado:
```

## Sesión 18: comprobar una alerta sin coincidencia

### Objetivo

Investigar qué ocurre cuando una alerta no encuentra una política específica.

Utilizar una alerta con estas etiquetas:

```text
alertname = TestUnmatchedAlert
team = unknown
severity = warning
environment = laboratory
```

### Procedimiento

1. Revisar las políticas existentes.
2. Confirmar que no existe una ruta para `team=unknown`.
3. Activar la alerta.
4. Comprobar el contacto utilizado.
5. Revisar la política predeterminada.
6. Crear una ruta específica.
7. Repetir la prueba.
8. Comparar ambos resultados.

### Registro

```text
Contacto inicial:

Política utilizada:

Ruta creada:

Contacto posterior:

Diferencia observada:

Conclusión:
```

## Sesión 19: diagnosticar una alerta que no se activa

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
La reducción no es la adecuada.
La regla está pausada.
La consulta no devuelve datos.
La unidad del umbral es incorrecta.
```

### Plantilla

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

## Sesión 20: diagnosticar una alerta sin notificación

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

### Posibles causas

```text
La alerta no coincide con la política.
El contacto está mal configurado.
Existe un silencio activo.
La alerta está agrupada con otra.
Todavía no ha transcurrido repeat_interval.
El canal externo rechaza la petición.
La alerta se envía a otro contacto.
```

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

## Sesión 21: reconstruir una línea temporal

### Objetivo

Relacionar anotaciones, métricas, alertas y acciones.

### Ejemplo esperado

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

### Registro de la línea temporal

```text
Hora:

Evento:

Métrica observada:

Estado de la alerta:

Notificación:

Acción realizada:
```

### Conclusión

```text
La anotación permitió relacionar el aumento de la métrica
con una actividad conocida. La duración de la alerta evitó
notificar un cambio breve o confirmó que el problema era sostenido.
```

## Sesión 22: revisar el historial de alertas

Para cada regla, registrar:

```text
Nombre:

Estado inicial:

Hora de Pending:

Hora de Alerting:

Hora de recuperación:

Duración total:

Número de notificaciones:

Silenciamiento aplicado:

Causa de activación:

Resultado:
```

Comparar:

```text
¿La alerta tardó demasiado en activarse?

¿El periodo de duración fue adecuado?

¿La notificación llegó al equipo correcto?

¿La recuperación fue clara?

¿La alerta generó ruido?

¿La consulta necesita mejoras?
```

## Sesión 23: preparar las evidencias

Guardar capturas con nombres ordenados:

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

Antes de guardar las capturas:

- Ocultar tokens.
- Ocultar contraseñas.
- Ocultar claves API.
- Ocultar información personal innecesaria.
- Ocultar URLs privadas.
- Revisar que los datos pertenecen al laboratorio.

## Sesión 24: realizar la limpieza final

### Comprobación de Node Exporter

```bash
sudo systemctl status node_exporter
```

### Comprobación de la métrica

```promql
up{job="node_exporter"}
```

El resultado esperado es:

```text
1
```

### Revisión

Revisar:

- Reglas temporales.
- Contactos de laboratorio.
- Políticas de prueba.
- Silenciamientos activos.
- Anotaciones.
- Dashboards.
- Servicios detenidos.
- Procesos de carga.
- Cambios no documentados.

Eliminar únicamente los elementos que no deban conservarse para la evaluación.

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

## Entregables

El alumno deberá entregar:

- Dashboard exportado o compartido.
- Consultas PromQL utilizadas.
- Lista de reglas de alerta.
- Etiquetas y anotaciones de las reglas.
- Contacto de notificación utilizado.
- Política de notificación.
- Evidencias de activación.
- Evidencias de recuperación.
- Evidencia del silenciamiento.
- Registro de problemas y soluciones.
- Memoria técnica.
- Conclusiones personales.

### Estructura recomendada

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

### Contenido del README

El fichero `README.md` debe incluir:

```text
Nombre del alumno:

Grupo:

Descripción del proyecto:

Requisitos utilizados:

Cómo reproducir la práctica:

Dashboard principal:

Reglas creadas:

Contacto de notificación:

Limitaciones:

Resultado final:
```

## Plantilla de memoria técnica

```markdown
# Memoria técnica - Proyecto final

## Identificación

Alumno:

Grupo:

Fecha:

Entorno:

## Objetivo

Descripción del objetivo del proyecto.

## Arquitectura

Descripción de Grafana, Prometheus y Node Exporter.

## Consultas

Listado de consultas PromQL y finalidad.

## Dashboard

Descripción de los paneles creados.

## Alertas

Listado de reglas, umbrales, duraciones y etiquetas.

## Notificaciones

Contacto, política y pruebas realizadas.

## Anotaciones

Eventos registrados y finalidad.

## Silenciamientos

Alcance, duración y motivo.

## Pruebas

Activación, notificación, recuperación y diagnóstico.

## Problemas encontrados

Descripción de errores y correcciones.

## Seguridad

Medidas aplicadas para proteger el entorno y las credenciales.

## Conclusiones

Valoración final y mejoras propuestas.
```

## Criterios de evaluación

| Criterio | Puntuación |
|---|---:|
| Preparación y validación del entorno | 1 |
| Consultas PromQL | 1 |
| Primer dashboard | 1 |
| Dashboard operativo | 1 |
| Reglas de alerta | 2 |
| Notificaciones y políticas | 1 |
| Anotaciones y silenciamientos | 1 |
| Evidencias y diagnóstico | 1 |
| Memoria técnica y presentación | 1 |
| **Total** | **10** |

### Criterios de calidad

La solución debe cumplir estos criterios:

- Las consultas devuelven datos válidos.
- Los paneles tienen títulos claros.
- Las unidades son coherentes.
- Las reglas tienen umbrales justificados.
- Las duraciones evitan falsos positivos.
- Las etiquetas son consistentes.
- Las notificaciones llegan al contacto esperado.
- Las recuperaciones se comprueban.
- Los silenciamientos son específicos.
- Las evidencias son legibles.
- La documentación permite reproducir la práctica.
- No se utilizan credenciales reales en la entrega.
- El entorno queda limpio al finalizar.

## Puntos clave

- El proyecto final integra todos los contenidos del curso.
- Las consultas deben validarse antes de crear reglas.
- Los dashboards deben servir para investigar, no solo para decorar.
- Las alertas deben ser accionables.
- Los umbrales deben tener una justificación.
- La duración evita alertas por picos breves.
- Las etiquetas permiten clasificar y enrutar alertas.
- Las anotaciones ayudan a relacionar eventos y métricas.
- Una alerta activa no garantiza que la notificación se haya entregado.
- Los silenciamientos suprimen notificaciones, pero no resuelven problemas.
- Las pruebas deben incluir activación y recuperación.
- Los contactos de laboratorio deben estar separados de producción.
- Los problemas deben diagnosticarse mediante evidencias.
- Los cambios temporales deben documentarse.
- La limpieza final forma parte del proyecto.
- La memoria técnica debe explicar las decisiones adoptadas.
- Un proyecto reproducible es más valioso que una configuración que solo funciona una vez.

## Preguntas de comprobación

1. ¿Qué componentes forman la arquitectura del proyecto?
2. ¿Por qué se deben validar las consultas antes de crear alertas?
3. ¿Qué diferencia existe entre una métrica y una alerta?
4. ¿Qué función cumple un dashboard operativo?
5. ¿Qué diferencia existe entre `Normal`, `Pending` y `Alerting`?
6. ¿Por qué una alerta debe tener una duración?
7. ¿Qué información deben aportar las etiquetas?
8. ¿Qué información deben aportar las anotaciones?
9. ¿Qué diferencia existe entre un contacto y una política de notificación?
10. ¿Qué revisarías si una alerta está activa, pero no llega ningún mensaje?
11. ¿Qué revisarías si una alerta nunca se activa?
12. ¿Qué diferencia existe entre una alerta silenciada y una alerta resuelta?
13. ¿Cómo comprobarías que un silenciamiento tiene el alcance correcto?
14. ¿Por qué deben separarse los entornos de laboratorio y producción?
15. ¿Qué evidencias incluirías en la entrega?
16. ¿Qué información debe contener la memoria técnica?
17. ¿Qué acciones deben realizarse antes de finalizar el laboratorio?
18. ¿Qué riesgos existen al generar carga en un servidor?
19. ¿Cómo relacionarías una anotación de despliegue con una alerta de latencia?
20. ¿Qué mejoras aplicarías a la solución después de completar el proyecto?

## Resultado esperado

El proyecto se considera completado cuando el alumno demuestra el siguiente flujo:

```text
El entorno está preparado
        |
        v
Prometheus recopila métricas
        |
        v
Grafana consulta los datos
        |
        v
El dashboard muestra información útil
        |
        v
Las alertas detectan condiciones anómalas
        |
        v
Las etiquetas clasifican los eventos
        |
        v
Las políticas enrutan las notificaciones
        |
        v
Las anotaciones aportan contexto
        |
        v
Los silenciamientos controlan actividades conocidas
        |
        v
Las alertas se activan y recuperan
        |
        v
Los problemas se diagnostican
        |
        v
Las evidencias se organizan
        |
        v
La memoria técnica documenta el resultado
        |
        v
El entorno queda limpio
```

Una solución de calidad no se limita a mostrar una métrica o activar una alerta. Debe permitir comprender qué ocurre, identificar el recurso afectado, informar al equipo responsable, relacionar el problema con los eventos operativos y demostrar cómo se recuperó el servicio.