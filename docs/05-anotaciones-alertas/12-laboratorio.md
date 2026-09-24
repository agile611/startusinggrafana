# Laboratorio - Anotaciones y alertas

Este laboratorio integra los conceptos estudiados en el módulo de **anotaciones y alertas de Grafana**.

Durante la práctica, el alumno creará reglas de alerta, registrará eventos mediante anotaciones, configurará notificaciones, utilizará silenciamientos y comprobará el ciclo completo de una incidencia:

```text
Métrica
   |
   v
Consulta PromQL
   |
   v
Regla de alerta
   |
   v
Evaluación
   |
   v
Pending
   |
   v
Alerting
   |
   v
Notificación
   |
   v
Investigación
   |
   v
Recuperación
   |
   v
Normal
```

El laboratorio está diseñado para realizarse en un entorno controlado. Las acciones que detienen servicios o generan carga deben ejecutarse únicamente sobre máquinas de prácticas autorizadas.

---

### Objetivos

Al finalizar este laboratorio, el alumno podrá:

- Verificar el estado de un entorno Grafana y Prometheus.
- Validar consultas PromQL en Explore.
- Crear reglas de alerta para disponibilidad, CPU, memoria y almacenamiento.
- Configurar expresiones, reducciones, umbrales y duraciones.
- Añadir etiquetas y anotaciones descriptivas.
- Crear anotaciones manuales sobre un dashboard.
- Consultar el historial de estados de una alerta.
- Crear contactos de notificación.
- Configurar políticas de notificación.
- Comprobar el envío de alertas a un canal autorizado.
- Probar notificaciones de activación y recuperación.
- Crear silenciamientos temporales.
- Comprobar el alcance de un silenciamiento.
- Diagnosticar reglas que no se activan.
- Diagnosticar alertas en estado `No data`.
- Revisar alertas desde la lista de alertas.
- Correlacionar cambios operativos con métricas y alertas.
- Documentar todas las pruebas realizadas.
- Elaborar un informe final de la práctica.

---

## Introducción

La observabilidad no consiste únicamente en mostrar gráficos. Una plataforma útil debe ayudar a responder preguntas como:

```text
¿Qué está ocurriendo?

¿Cuándo comenzó?

¿Qué servicio está afectado?

¿La situación es nueva o recurrente?

¿Hubo un despliegue antes del problema?

¿Se envió una notificación?

¿Se trata de un problema real o de ruido?

¿Cuándo se resolvió?
```

En este laboratorio se utilizarán tres elementos principales:

### Alertas

Detectan situaciones anómalas mediante reglas basadas en métricas.

Ejemplo:

```text
Si la CPU supera el 90 % durante cinco minutos,
activar una alerta.
```

### Anotaciones

Registran acontecimientos operativos en una línea temporal.

Ejemplos:

```text
Despliegue de una nueva versión.
Inicio de una prueba de carga.
Mantenimiento programado.
Rollback de una aplicación.
```

### Notificaciones

Informan al equipo responsable cuando una alerta cambia de estado.

Ejemplo:

```text
[FIRING] HighCPUUsage en server-01
```

La combinación de estos elementos permite construir una línea temporal completa:

```text
18:00 - Despliegue de una aplicación
18:03 - Aumento de la latencia
18:05 - Alerta de latencia en Pending
18:10 - Alerta en Alerting
18:11 - Notificación enviada
18:15 - Rollback
18:18 - Alerta resuelta
```

---

## Escenario del laboratorio

El laboratorio utilizará un servidor de prácticas supervisado por Prometheus y visualizado en Grafana.

### Componentes

```text
Node Exporter
    |
    v
Prometheus
    |
    v
Grafana
    |
    v
Alertas y notificaciones
```

### Servicios esperados

| Componente | Función |
|---|---|
| Node Exporter | Expone métricas del sistema |
| Prometheus | Recopila y almacena métricas |
| Grafana | Visualiza métricas y gestiona alertas |
| Contacto de notificación | Recibe los avisos |
| Dashboard | Muestra el estado del sistema |

Los nombres de servicios, puertos y rutas pueden variar según el entorno de formación.

---

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Acceso a Grafana.
- Permisos para consultar dashboards.
- Permisos para crear reglas de alerta.
- Permisos para crear anotaciones.
- Permisos para crear contactos de laboratorio.
- Acceso a Prometheus desde Grafana.
- Node Exporter instalado o una fuente de métricas equivalente.
- Un contacto de correo, webhook o canal de laboratorio.
- Una máquina de prácticas autorizada.
- Acceso a una terminal, si se realizarán pruebas de servicio o carga.

### Comprobar la versión

Desde Grafana:

1. Acceder al menú de ayuda.
2. Consultar la información de la instancia.
3. Registrar la versión utilizada.

```text
Versión de Grafana:

Versión de Prometheus:

Sistema operativo:

Fecha de la práctica:

Alumno:

Grupo:
```

La interfaz puede presentar diferencias según la versión instalada.

---

## Reglas de seguridad

Este laboratorio debe realizarse únicamente en un entorno autorizado.

### No ejecutar sobre producción

No detener servicios ni generar carga en sistemas reales.

Incorrecto:

```bash
sudo systemctl stop node_exporter
```

sobre un servidor de producción.

Correcto:

```text
Ejecutar la acción únicamente en la máquina de laboratorio asignada.
```

### No utilizar credenciales reales

No incluir en la documentación:

```text
Contraseñas
Tokens
Claves API
Secretos SMTP
URLs con credenciales
Cabeceras de autenticación
```

### No crear notificaciones reales sin autorización

Utilizar:

- Direcciones de laboratorio.
- Contactos de formación.
- Webhooks de prueba.
- Canales controlados.
- Sistemas ITSM de laboratorio.

### No automatizar acciones destructivas

El laboratorio no debe ejecutar acciones como:

```text
Borrar archivos automáticamente.
Reiniciar servidores de producción.
Modificar reglas de firewall.
Detener bases de datos.
Eliminar recursos.
```

---

## Estructura de evidencias

Crear un directorio de trabajo:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador
```

Crear subdirectorios:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/consultas
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/reglas
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/anotaciones
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/notificaciones
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/silencios
mkdir -p ~/laboratorio-grafana/evidencias/laboratorio-integrador/informe
```

Crear un registro general:

```bash
cat > ~/laboratorio-grafana/evidencias/laboratorio-integrador/registro-general.txt <<'EOF'
Alumno:

Grupo:

Fecha:

Versión de Grafana:

Versión de Prometheus:

Entorno:

Host de laboratorio:

Reglas creadas:

Anotaciones creadas:

Contacto utilizado:

Política utilizada:

Silencio creado:

Problemas encontrados:

Resultado final:

Firma o validación del instructor:
EOF
```

---

## Fase 1: comprobar el entorno

### Objetivo

Verificar que Grafana, Prometheus y Node Exporter funcionan antes de crear reglas.

### Comprobar Node Exporter

En la máquina de laboratorio:

```bash
sudo systemctl status node_exporter
```

Si el servicio utiliza otro nombre, consultar el procedimiento del entorno.

Comprobar que el puerto está escuchando:

```bash
ss -lntp
```

La salida debe mostrar el puerto configurado para Node Exporter, habitualmente el `9100`.

### Comprobar Prometheus

Si Prometheus se ejecuta como servicio:

```bash
sudo systemctl status prometheus
```

Si se ejecuta mediante contenedor:

```bash
docker ps
docker logs prometheus --tail 50
```

### Comprobar Grafana

```bash
sudo systemctl status grafana-server
```

o:

```bash
docker ps
docker logs grafana --tail 50
```

### Registrar el resultado

```text
Node Exporter:

Prometheus:

Grafana:

Conectividad entre componentes:

Observaciones:
```

---

## Fase 2: validar la fuente de datos

### Objetivo

Comprobar que Grafana puede consultar Prometheus.

### Pasos

1. Acceder a Grafana.
2. Abrir **Connections** o **Data sources**.
3. Seleccionar Prometheus.
4. Ejecutar la prueba de conexión.
5. Confirmar que la fuente está disponible.

### Resultado esperado

```text
Data source is working
```

El texto exacto puede variar según la versión.

### Si la prueba falla

Comprobar:

- URL de Prometheus.
- Resolución DNS.
- Conectividad de red.
- Credenciales, si existen.
- Estado del servicio Prometheus.
- Restricciones de firewall.
- Logs de Grafana.
- Logs de Prometheus.

---

## Fase 3: validar consultas PromQL

### Objetivo

Comprobar que las consultas devuelven datos antes de utilizarlas en reglas.

Abrir:

```text
Explore → Prometheus
```

---

### Consulta 1: disponibilidad

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

Registrar:

```text
Número de series:

Valor actual:

Etiqueta job:

Etiqueta instance:
```

---

### Consulta 2: CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Resultado esperado:

```text
Porcentaje de CPU utilizado por instancia.
```

Comprobar:

```text
¿El valor está entre 0 y 100?

¿Aparece la etiqueta instance?

¿Hay una serie por instancia?

¿El valor coincide aproximadamente con el sistema?
```

---

### Consulta 3: memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Resultado esperado:

```text
Porcentaje de memoria utilizada.
```

---

### Consulta 4: memoria disponible

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Resultado esperado:

```text
Porcentaje de memoria disponible.
```

---

### Consulta 5: almacenamiento utilizado

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

Resultado esperado:

```text
Porcentaje utilizado del sistema de ficheros raíz.
```

---

### Registrar las consultas

Guardar las consultas en un fichero:

```bash
cat > ~/laboratorio-grafana/evidencias/laboratorio-integrador/consultas/consultas-promql.txt <<'EOF'
Disponibilidad:
up{job="node_exporter"}

CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria utilizada:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Memoria disponible:
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Almacenamiento utilizado:
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

---

## Fase 4: crear un dashboard de laboratorio

### Objetivo

Crear un dashboard que permita observar las métricas utilizadas por las alertas.

Crear un dashboard llamado:

```text
Laboratorio - Anotaciones y alertas
```

### Panel 1: disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Configuración recomendada:

```text
Título:
Disponibilidad de Node Exporter

Unidad:
none

Visualización:
Stat o Time series
```

---

### Panel 2: CPU

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
Título:
CPU utilizada por instancia

Unidad:
Percent (0-100)

Umbral visual:
80 = amarillo
90 = rojo
```

---

### Panel 3: memoria

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
Título:
Memoria utilizada

Unidad:
Percent (0-100)
```

---

### Panel 4: almacenamiento

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
Título:
Almacenamiento utilizado

Unidad:
Percent (0-100)
```

---

### Guardar el dashboard

Guardar el dashboard con:

```text
Nombre:
Laboratorio - Anotaciones y alertas
```

Copiar su URL:

```text
URL del dashboard:
```

La URL se utilizará posteriormente en las anotaciones y notificaciones.

---

## Fase 5: crear anotaciones manuales

### Objetivo

Registrar eventos operativos para relacionarlos con las métricas.

Crear una anotación de inicio de práctica:

```text
Título:
Inicio de práctica de observabilidad

Descripción:
Comienzo del laboratorio sobre anotaciones y alertas.
```

Añadir etiquetas:

```text
event = lab-start
environment = laboratory
team = training
```

### Crear una anotación de prueba de carga

```text
Título:
Inicio de prueba de carga

Descripción:
Se inicia una prueba de carga controlada sobre la máquina de laboratorio.
```

Etiquetas:

```text
event = load-test
environment = laboratory
```

### Crear una anotación de mantenimiento

```text
Título:
Mantenimiento de laboratorio

Descripción:
Se detendrá temporalmente Node Exporter para probar la alerta de disponibilidad.
```

Etiquetas:

```text
event = maintenance
service = node_exporter
environment = laboratory
```

### Comprobar las anotaciones

1. Abrir el dashboard.
2. Seleccionar un rango temporal que incluya las anotaciones.
3. Confirmar que aparecen sobre los paneles.
4. Seleccionar una anotación.
5. Revisar su título, descripción y etiquetas.

### Registrar

```text
Anotación de inicio creada:

Anotación de carga creada:

Anotación de mantenimiento creada:

Anotaciones visibles en el dashboard:

Observaciones:
```

---

## Fase 6: crear la alerta de disponibilidad

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

### Expresión

Utilizar el último valor disponible:

```text
Reduce:
Last
```

### Condición

```text
Valor igual a 0
```

### Evaluación

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
dashboard_url = URL_DEL_DASHBOARD_DE_LABORATORIO
```

Sustituir `URL_DEL_DASHBOARD_DE_LABORATORIO` por la URL real, si procede.

### Ausencia de datos

Para esta alerta, decidir y documentar el comportamiento ante ausencia de datos:

```text
No data:
Alerting o No data
```

La elección depende del diseño del laboratorio. Lo importante es justificarla.

### Crear la regla

1. Abrir **Alerting**.
2. Seleccionar **Alert rules**.
3. Crear una regla.
4. Introducir la consulta.
5. Configurar la reducción.
6. Configurar la condición.
7. Añadir la duración.
8. Añadir etiquetas.
9. Añadir anotaciones.
10. Guardar.

---

## Fase 7: crear la alerta de CPU

### Objetivo

Detectar un uso sostenido de CPU superior al 90 %.

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

### Reducción

```text
Last
```

### Condición

```text
Mayor que 90
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
dashboard_url = URL_DEL_DASHBOARD_DE_LABORATORIO
```

### Crear la regla

1. Validar la consulta en Explore.
2. Crear la regla.
3. Configurar el umbral.
4. Configurar la duración.
5. Añadir etiquetas.
6. Añadir anotaciones.
7. Guardar.
8. Confirmar que aparece en estado `Normal`.

---

## Fase 8: crear la alerta de memoria

### Objetivo

Detectar un uso de memoria superior al 90 %.

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

### Reducción

```text
Last
```

### Condición

```text
Mayor que 90
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
alertname = HighMemoryUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = memory
```

### Anotaciones

```text
summary = Uso de memoria elevado en {{ $labels.instance }}

description = La memoria utilizada en {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-memory
dashboard_url = URL_DEL_DASHBOARD_DE_LABORATORIO
```

---

## Fase 9: crear la alerta de almacenamiento

### Objetivo

Detectar una ocupación del sistema de ficheros superior al 80 %.

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

### Reducción

```text
Last
```

### Condición

```text
Mayor que 80
```

### Evaluación

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
summary = Sistema de ficheros con ocupación elevada

description = El sistema de ficheros raíz de
{{ $labels.instance }} supera el 80 % de uso.

runbook_url = https://example.com/runbooks/filesystem-full
dashboard_url = URL_DEL_DASHBOARD_DE_LABORATORIO
```

---

## Fase 10: revisar la lista de alertas

### Objetivo

Consultar el estado de todas las reglas creadas.

Acceder a:

```text
Alerting → Alert rules
```

Comprobar:

```text
NodeExporterDown-Laboratory
HighCPUUsage-Laboratory
HighMemoryUsage-Laboratory
FilesystemUsageHigh-Laboratory
```

### Tabla de control

| Regla | Estado inicial | Consulta válida | Etiquetas completas | Anotaciones |
|---|---|---|---|---|
| NodeExporterDown-Laboratory | | | | |
| HighCPUUsage-Laboratory | | | | |
| HighMemoryUsage-Laboratory | | | | |
| FilesystemUsageHigh-Laboratory | | | | |

### Filtrar por estado

Probar los filtros:

```text
Normal
Pending
Alerting
No data
Error
```

Registrar:

```text
Número de reglas normales:

Número de reglas pendientes:

Número de reglas activas:

Número de reglas sin datos:

Número de reglas con error:
```

---

## Fase 11: crear un contacto de notificación

### Objetivo

Crear un destino de laboratorio para recibir alertas.

Utilizar uno de los siguientes canales:

- Correo de laboratorio.
- Webhook de laboratorio.
- Canal colaborativo autorizado.
- Sistema ITSM de prácticas.

### Ejemplo de contacto

```text
Nombre:
laboratory-systems

Tipo:
Correo electrónico o webhook

Entorno:
laboratory

Finalidad:
Pruebas del laboratorio de alertas
```

No utilizar contactos de producción.

### Probar el contacto

1. Crear el contacto.
2. Guardar.
3. Ejecutar una prueba.
4. Comprobar la recepción.
5. Registrar el resultado.

```text
Contacto:

Tipo:

Fecha de prueba:

Resultado:

Tiempo de entrega:

Problemas:
```

---

## Fase 12: crear políticas de notificación

### Objetivo

Enviar las alertas del laboratorio al contacto de formación.

### Coincidencias

```text
environment = laboratory
```

### Contacto

```text
laboratory-systems
```

### Configuración de agrupación

Para la primera prueba, utilizar:

```text
group_by:
- alertname
- instance
```

### Temporización de laboratorio

Utilizar valores breves únicamente en el entorno de prácticas:

```text
group_wait:
10 segundos

group_interval:
1 minuto

repeat_interval:
5 minutos
```

Estos valores son adecuados para acelerar las pruebas, pero no deben copiarse automáticamente a producción.

### Crear la política

1. Abrir **Alerting**.
2. Acceder a las políticas.
3. Crear una ruta.
4. Añadir la coincidencia `environment=laboratory`.
5. Seleccionar el contacto.
6. Configurar agrupación.
7. Guardar.
8. Documentar.

---

## Fase 13: probar la alerta de disponibilidad

### Objetivo

Comprobar el ciclo completo de una alerta de disponibilidad.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba Node Exporter

Descripción:
Se detendrá Node Exporter de laboratorio
para validar la alerta NodeExporterDown-Laboratory.
```

### Comprobar el estado inicial

```text
Regla:
NodeExporterDown-Laboratory

Estado esperado:
Normal
```

### Detener Node Exporter

Ejecutar únicamente en la máquina de laboratorio:

```bash
sudo systemctl stop node_exporter
```

### Observar el ciclo

En Grafana:

```text
Normal
   |
   v
Pending
   |
   v
Alerting
```

Comprobar:

- Hora de inicio de `Pending`.
- Hora de entrada en `Alerting`.
- Instancia afectada.
- Etiquetas.
- Anotaciones.
- Notificación recibida.

### Iniciar Node Exporter

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

### Registro

```text
Hora de detención:

Hora de Pending:

Hora de Alerting:

Hora de recepción:

Hora de inicio del servicio:

Hora de recuperación:

Hora de recepción de recuperación:

Resultado:
```

---

## Fase 14: probar la alerta de CPU

### Objetivo

Comprobar que la duración evita alertas por picos breves.

### Preparación

Crear una anotación:

```text
Título:
Inicio de prueba de carga

Descripción:
Se ejecuta una carga controlada para probar HighCPUUsage-Laboratory.
```

### Generar carga controlada

En la máquina de laboratorio:

```bash
stress-ng --cpu 1 --timeout 60s
```

Si `stress-ng` no está instalado, utilizar el mecanismo aprobado por el instructor.

### Observar el comportamiento

La regla está configurada con:

```text
Umbral:
90 %

Duración:
5 minutos
```

Es posible que una prueba de 60 segundos no sea suficiente para alcanzar `Alerting`.

Esto permite observar que:

```text
CPU elevada durante un periodo breve
    → Pending o Normal
```

Para una prueba de activación, utilizar una carga controlada y autorizada con una duración compatible con el laboratorio.

### Registrar

```text
Valor máximo:

Tiempo por encima del umbral:

Estado observado:

¿Se envió notificación?:

Motivo:

Resultado:
```

---

## Fase 15: comparar reducciones

### Objetivo

Comprender la diferencia entre `Last`, `Mean` y `Max`.

Utilizar la consulta de CPU.

### Configuraciones

Crear expresiones de prueba:

```text
Configuración A:
Reducción = Last
Umbral = 90

Configuración B:
Reducción = Mean
Umbral = 80

Configuración C:
Reducción = Max
Umbral = 95
```

### Actividad

1. Ejecutar la consulta en Explore.
2. Observar la serie.
3. Registrar el último valor.
4. Registrar el promedio.
5. Registrar el máximo.
6. Generar una carga breve.
7. Comparar los estados.
8. Explicar las diferencias.

### Registro

```text
Último valor:

Valor medio:

Valor máximo:

Regla que se activó primero:

Regla que permaneció normal:

Explicación:
```

---

## Fase 16: probar una alerta multidimensional

### Objetivo

Comprobar que una alerta identifica la instancia concreta afectada.

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
Nombre:
HighCPUUsageByInstance-Laboratory

Condición:
Mayor que 90

Duración:
5 minutos
```

### Anotación

```text
summary = CPU elevada en {{ $labels.instance }}

description = La instancia {{ $labels.instance }}
supera el umbral configurado.
```

### Actividades

1. Confirmar cuántas instancias devuelve la consulta.
2. Activar carga en una instancia.
3. Revisar la lista de alertas.
4. Identificar la instancia en estado `Alerting`.
5. Revisar el mensaje recibido.
6. Confirmar que la instancia aparece en la notificación.

### Resultado esperado

```text
server-01:9100 → Normal
server-02:9100 → Alerting
```

La salida concreta depende de las instancias disponibles.

---

## Fase 17: probar una alerta `No data`

### Objetivo

Diferenciar entre un valor cero y la ausencia de datos.

### Consulta

```promql
up{job="node_exporter"}
```

### Procedimiento

1. Ejecutar la consulta mientras Node Exporter funciona.
2. Detener Node Exporter.
3. Observar si aparece `up=0` o si desaparece la serie.
4. Revisar la política de ausencia de datos.
5. Consultar la alerta en la lista.
6. Registrar el estado.
7. Volver a iniciar el servicio.

### Registro

```text
Estado con servicio activo:

Resultado de la consulta:

Estado con servicio detenido:

Resultado de la consulta:

Estado de la alerta:

Política No data:

Interpretación:
```

---

## Fase 18: crear un silenciamiento

### Objetivo

Suprimir temporalmente las notificaciones durante una actividad conocida.

### Preparación

Crear una anotación:

```text
Título:
Mantenimiento de laboratorio

Descripción:
Se detendrá temporalmente Node Exporter
para probar un silenciamiento.
```

### Crear el silencio

Coincidencias:

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
Práctica de mantenimiento autorizada.
Se valida el silenciamiento de NodeExporterDown-Laboratory.
```

### Activar la alerta

```bash
sudo systemctl stop node_exporter
```

Comprobar:

```text
La alerta se evalúa.
La alerta puede aparecer como Alerting.
El silencio está activo.
La notificación queda suprimida.
```

### Recuperar

```bash
sudo systemctl start node_exporter
```

### Registrar

```text
Silencio:

Coincidencias:

Inicio:

Fin:

Alerta afectada:

Notificación durante el silencio:

Estado de la alerta:

Hora de recuperación:

Resultado:
```

---

## Fase 19: comprobar el alcance del silencio

### Objetivo

Comprobar que un silencio específico no afecta a otras instancias.

### Preparación

Silenciar únicamente:

```text
instance = server-01:9100
```

### Actividad

1. Activar una alerta en `server-01`.
2. Activar la misma alerta en `server-02`, si existe.
3. Revisar los estados.
4. Revisar las notificaciones.
5. Comprobar qué instancia quedó silenciada.
6. Documentar el resultado.

### Resultado esperado

```text
server-01:
Notificación suprimida.

server-02:
Notificación entregada.
```

Si el entorno solo tiene una instancia, documentar la limitación.

---

## Fase 20: revisar anotaciones y alertas juntas

### Objetivo

Correlacionar eventos operativos con cambios en las métricas.

### Línea temporal esperada

```text
18:00 - Inicio de prueba de carga
18:01 - Anotación visible
18:02 - CPU comienza a aumentar
18:05 - CPU supera el umbral
18:05 - Alerta Pending
18:10 - Alerta Alerting
18:11 - Notificación recibida
18:12 - Fin de prueba de carga
18:16 - CPU vuelve a valores normales
18:17 - Alerta Normal
```

### Actividad

1. Abrir el dashboard.
2. Seleccionar el rango temporal completo.
3. Revisar las anotaciones.
4. Revisar la serie de CPU.
5. Revisar la línea de alerta.
6. Comparar los tiempos.
7. Escribir una conclusión.

### Conclusión

```text
La anotación de la prueba de carga permite relacionar
el aumento de CPU con una actividad conocida.
La alerta se activó después de mantenerse la condición
durante el periodo configurado.
```

---

## Fase 21: diagnosticar una alerta que no se activa

### Objetivo

Investigar una regla que permanece en `Normal`.

### Situación

```text
El panel muestra CPU elevada,
pero HighCPUUsage-Laboratory no se activa.
```

### Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar la unidad.
3. Comprobar el umbral.
4. Comprobar la reducción.
5. Comprobar la duración.
6. Comprobar el estado de la regla.
7. Comprobar el grupo de evaluación.
8. Comprobar las etiquetas.
9. Revisar los logs si existe un error.
10. Documentar la causa.

### Causas posibles

```text
El valor no supera realmente el umbral.
La duración no ha transcurrido.
La regla utiliza una reducción incorrecta.
La consulta devuelve otra instancia.
La alerta está pausada.
El umbral utiliza una unidad incorrecta.
La consulta no devuelve datos.
```

### Registro

```text
Regla:

Valor observado:

Umbral:

Reducción:

Duración:

Estado:

Causa:

Corrección:

Resultado posterior:
```

---

## Fase 22: diagnosticar una alerta sin notificación

### Objetivo

Investigar una alerta que aparece como `Alerting`, pero no genera ningún mensaje.

### Procedimiento

1. Confirmar que la regla está activa.
2. Revisar sus etiquetas.
3. Revisar la política coincidente.
4. Confirmar el contacto.
5. Revisar si existe un silencio.
6. Revisar la agrupación.
7. Revisar el intervalo de repetición.
8. Probar el contacto directamente.
9. Revisar los logs.
10. Registrar la causa.

### Posibles causas

```text
La alerta no coincide con la política.
El contacto no funciona.
Existe un silencio activo.
La notificación está agrupada.
El intervalo de repetición todavía no ha transcurrido.
El destinatario es incorrecto.
La integración externa devuelve un error.
```

---

## Fase 23: probar una ruta sin coincidencia

### Objetivo

Comprobar el comportamiento de una alerta que no coincide con ninguna política específica.

### Crear una alerta de prueba

Utilizar etiquetas como:

```text
alertname = TestUnmatchedAlert
team = unknown
environment = laboratory
severity = warning
```

### Actividad

1. Crear una política para `environment=laboratory`.
2. Crear una alerta con `team=unknown`.
3. Activarla.
4. Comprobar el contacto utilizado.
5. Revisar la política predeterminada.
6. Añadir una ruta específica.
7. Repetir la prueba.
8. Comparar los resultados.

### Registro

```text
Política inicial:

Contacto inicial:

Ruta añadida:

Contacto posterior:

Resultado:
```

---

## Fase 24: probar la recuperación

### Objetivo

Comprobar que el sistema informa tanto de la activación como de la resolución.

### Procedimiento

1. Confirmar el estado `Normal`.
2. Activar una condición.
3. Esperar `Alerting`.
4. Confirmar la notificación.
5. Resolver la condición.
6. Esperar `Normal`.
7. Confirmar la notificación de recuperación.
8. Comparar ambos mensajes.

### Tabla

| Evento | Hora en Grafana | Hora de recepción | Resultado |
|---|---|---|---|
| Activación | | | |
| Recuperación | | | |

### Revisar en el mensaje

```text
Estado:
FIRING o RESOLVED

Nombre de la alerta:

Instancia:

Severidad:

Valor:

Hora:

Descripción:

Runbook:
```

---

## Fase 25: revisar el historial de estados

### Objetivo

Reconstruir la evolución de una alerta.

### Ejemplo

```text
18:00 - Normal
18:05 - Pending
18:10 - Alerting
18:16 - Normal
```

### Actividad

Para cada alerta probada, registrar:

```text
Estado inicial:

Hora de Pending:

Hora de Alerting:

Hora de recuperación:

Duración total:

Número de notificaciones:

Silencio aplicado:

Observaciones:
```

### Análisis

Responder:

```text
¿La duración configurada fue adecuada?

¿La alerta se activó demasiado pronto?

¿La alerta tardó demasiado?

¿La notificación llegó al contacto correcto?

¿La recuperación fue clara?

¿La regla generó ruido?
```

---

## Fase 26: elaborar el informe operativo

### Resumen general

```text
Fecha:

Alumno:

Grupo:

Entorno:

Periodo de la práctica:

Número de reglas creadas:

Número de anotaciones creadas:

Número de alertas activadas:

Número de recuperaciones:

Número de notificaciones:

Número de silenciamientos:

Resultado general:
```

### Incidencias observadas

| Alerta | Instancia | Inicio | Recuperación | Causa | Acción |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

### Problemas de configuración

| Problema | Causa | Corrección | Resultado |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

### Conclusión del alumno

```text
¿Qué regla fue más fácil de configurar?

¿Qué problema fue más difícil de diagnosticar?

¿Qué diferencia existe entre una alerta y una anotación?

¿Qué utilidad tuvo el silenciamiento?

¿Qué mejora aplicarías al sistema?
```

---

## Fase 27: limpieza del entorno

Al finalizar:

1. Confirmar que Node Exporter está funcionando.
2. Confirmar que Prometheus recibe métricas.
3. Confirmar que Grafana está operativo.
4. Revisar las reglas creadas.
5. Eliminar reglas temporales.
6. Revisar contactos de laboratorio.
7. Eliminar o dejar expirar silenciamientos.
8. Revisar políticas de prueba.
9. Eliminar anotaciones que no deban conservarse.
10. Guardar las evidencias.
11. Informar al instructor.
12. Confirmar que no quedan cambios no documentados.

### Comprobar el servicio

```bash
sudo systemctl status node_exporter
```

### Comprobar la consulta

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

---

## Plantilla final de evaluación

### Reglas

| Regla | Creada | Probada | Activación | Recuperación |
|---|---|---|---|---|
| NodeExporterDown-Laboratory | | | | |
| HighCPUUsage-Laboratory | | | | |
| HighMemoryUsage-Laboratory | | | | |
| FilesystemUsageHigh-Laboratory | | | | |

### Anotaciones

| Anotación | Creada | Visible | Comentario |
|---|---|---|---|
| Inicio de práctica | | | |
| Prueba de carga | | | |
| Mantenimiento | | | |

### Notificaciones

| Prueba | Contacto | Enviada | Recibida | Observaciones |
|---|---|---|---|---|
| Contacto directo | | | | |
| CPU | | | | |
| Disponibilidad | | | | |
| Recuperación | | | | |

### Silenciamientos

| Silencio | Alcance | Activo | Suprimió | Revisado |
|---|---|---|---|---|
| | | | | |
| | | | | |

---

## Criterios de evaluación

| Criterio | Puntuación |
|---|---:|
| Verificación inicial del entorno | 1 |
| Validación de consultas | 1 |
| Creación de reglas | 2 |
| Configuración de expresiones y condiciones | 1 |
| Etiquetas y anotaciones | 1 |
| Configuración de notificaciones | 1 |
| Prueba de activación y recuperación | 1 |
| Uso correcto de silenciamientos | 1 |
| Documentación e informe final | 1 |
| **Total** | **10** |

### Indicadores de una práctica correcta

- Las consultas devuelven datos válidos.
- Las reglas tienen nombres descriptivos.
- Las unidades y umbrales son coherentes.
- Las etiquetas permiten enrutar las alertas.
- Las anotaciones incluyen contexto.
- Las notificaciones llegan al contacto esperado.
- Las alertas pasan por los estados esperados.
- Las recuperaciones se comprueban.
- Los silenciamientos tienen alcance limitado.
- El entorno queda limpio al finalizar.

---

## Puntos clave

- El laboratorio integra consultas, reglas, anotaciones, notificaciones y silenciamientos.
- Las consultas deben validarse antes de crear reglas.
- Una regla debe tener un objetivo operativo claro.
- Las expresiones y condiciones deben utilizar unidades coherentes.
- Las etiquetas permiten clasificar y enrutar alertas.
- Las anotaciones proporcionan contexto temporal.
- El estado `Pending` ayuda a evitar alertas por picos breves.
- El estado `Alerting` indica que la condición se ha mantenido.
- Una alerta `Normal` no significa que nunca haya existido un problema.
- La recuperación debe probarse igual que la activación.
- Las políticas conectan las etiquetas con los contactos.
- Una alerta activa no garantiza que la notificación haya llegado.
- Los silenciamientos suprimen notificaciones, pero no resuelven problemas.
- Los silenciamientos deben tener una duración y un motivo.
- La lista de alertas permite investigar el estado global.
- Las anotaciones ayudan a correlacionar cambios y métricas.
- Las pruebas deben ejecutarse en un entorno autorizado.
- Las credenciales nunca deben incluirse en las evidencias.
- Los contactos de laboratorio deben estar separados de producción.
- Las reglas ruidosas deben corregirse, no silenciarse indefinidamente.
- Un buen laboratorio comprueba activación, notificación, investigación y recuperación.
- La limpieza final evita dejar configuraciones temporales activas.
- La documentación es parte del resultado técnico.
- Una alerta útil debe permitir actuar sobre un problema concreto.
- La observabilidad mejora cuando las métricas, los eventos y las alertas se analizan juntos.

---

## Preguntas de comprobación

1. ¿Qué componentes se integran en este laboratorio?
2. ¿Por qué deben validarse las consultas antes de crear reglas?
3. ¿Qué diferencia existe entre una métrica y una alerta?
4. ¿Qué función cumple una anotación?
5. ¿Qué diferencia existe entre `Pending` y `Alerting`?
6. ¿Qué diferencia existe entre una alerta activa y una alerta notificada?
7. ¿Qué información deben contener las etiquetas?
8. ¿Qué función cumplen las políticas de notificación?
9. ¿Qué ocurre si una alerta no coincide con ninguna política específica?
10. ¿Qué diferencia existe entre un silencio y una regla deshabilitada?
11. ¿Por qué un silencio debe tener una fecha de finalización?
12. ¿Cómo comprobarías que un silencio tiene el alcance correcto?
13. ¿Qué revisarías si una alerta no se activa?
14. ¿Qué revisarías si una alerta está activa, pero no llega la notificación?
15. ¿Cómo probarías una alerta de disponibilidad?
16. ¿Cómo probarías una alerta de CPU?
17. ¿Cómo distinguirías entre un valor cero y la ausencia de datos?
18. ¿Por qué es importante conservar la etiqueta `instance`?
19. ¿Qué relación existe entre una anotación de despliegue y una alerta de latencia?
20. ¿Qué información incluirías en un informe operativo?
21. ¿Qué acciones de limpieza deben realizarse al terminar?
22. ¿Qué evidencias deben guardarse?
23. ¿Qué riesgos existen al ejecutar pruebas de carga?
24. ¿Por qué no deben utilizarse credenciales reales durante la práctica?
25. ¿Qué características debe tener una implementación completa de alertas?

---

## Resultado esperado

Al finalizar el laboratorio, el alumno debe haber construido y probado un flujo completo de observabilidad:

```text
Validar la fuente de datos
        |
        v
Validar las consultas
        |
        v
Crear el dashboard
        |
        v
Añadir anotaciones
        |
        v
Crear reglas de alerta
        |
        v
Configurar etiquetas
        |
        v
Configurar contactos
        |
        v
Configurar políticas
        |
        v
Activar una condición
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
Investigar el contexto
        |
        v
Aplicar un silenciamiento si procede
        |
        v
Resolver la condición
        |
        v
Comprobar la recuperación
        |
        v
Revisar el historial
        |
        v
Documentar el resultado
        |
        v
Limpiar el entorno
```

La práctica está completada correctamente cuando:

- Grafana consulta Prometheus sin errores.
- Las consultas devuelven datos esperados.
- Las reglas se activan con condiciones controladas.
- Las anotaciones aparecen en el dashboard.
- Las etiquetas permiten identificar el recurso y el equipo.
- Las políticas enrutan las alertas correctamente.
- Las notificaciones llegan a un contacto de laboratorio.
- Las recuperaciones se observan y documentan.
- Los silenciamientos afectan únicamente al alcance previsto.
- Los problemas se diagnostican con un procedimiento ordenado.
- El entorno queda limpio.
- El informe final contiene evidencias suficientes.

El objetivo no es únicamente conseguir que una alerta cambie a `Alerting`. El objetivo es demostrar que todo el ciclo funciona: detectar, contextualizar, notificar, investigar, silenciar cuando corresponde, recuperar y documentar. Ahí es donde la monitorización deja de ser un conjunto de gráficos y se convierte en una herramienta operativa.