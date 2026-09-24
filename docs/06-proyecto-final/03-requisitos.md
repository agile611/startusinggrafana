# Requisitos

Los requisitos definen las condiciones técnicas, operativas y documentales necesarias para realizar el proyecto final de observabilidad.

El alumno deberá preparar un entorno controlado con Grafana, Prometheus y Node Exporter. Sobre este entorno construirá dashboards, consultas PromQL, reglas de alerta, notificaciones, anotaciones y silenciamientos.

El proyecto debe ejecutarse únicamente en una máquina virtual, servidor de prácticas o entorno específicamente autorizado. No se deben realizar pruebas de parada de servicios ni generación de carga sobre sistemas de producción.

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Identificar los requisitos técnicos del proyecto.
- Identificar los requisitos funcionales de la solución.
- Preparar una máquina de laboratorio.
- Comprobar que Grafana está instalado y operativo.
- Comprobar que Prometheus está instalado y operativo.
- Comprobar que Node Exporter expone métricas.
- Validar la comunicación entre los componentes.
- Comprobar los permisos necesarios.
- Preparar un canal de notificación de pruebas.
- Organizar las evidencias del proyecto.
- Aplicar medidas básicas de seguridad.
- Diferenciar requisitos obligatorios y opcionales.
- Documentar las limitaciones del entorno.
- Verificar que el entorno está preparado antes de comenzar las prácticas.

## Introducción

Una solución de observabilidad necesita algo más que instalar una herramienta.

Antes de crear dashboards o alertas es necesario comprobar que:

- La máquina de laboratorio está disponible.
- Las métricas se están generando.
- Prometheus puede recopilarlas.
- Grafana puede consultarlas.
- El alumno tiene permisos suficientes.
- Existe un contacto de notificación controlado.
- Las pruebas se pueden realizar sin afectar a otros sistemas.
- Las evidencias se pueden guardar de forma segura.

El proyecto se organizará en cuatro grupos de requisitos:

```text
Requisitos de infraestructura
        |
        v
Requisitos de software
        |
        v
Requisitos funcionales
        |
        v
Requisitos de seguridad y documentación
```

## Requisitos de infraestructura

### Máquina de laboratorio

El alumno deberá disponer de una máquina virtual o servidor de prácticas con:

- Sistema operativo Linux.
- Acceso administrativo controlado.
- Conectividad de red.
- Espacio suficiente para instalar los componentes.
- Recursos suficientes para ejecutar Grafana, Prometheus y Node Exporter.
- Acceso desde el navegador.
- Acceso a una terminal.

La máquina debe estar claramente identificada.

```text
Nombre del host:

Dirección IP:

Sistema operativo:

Versión del sistema:

Entorno:

Responsable:

Fecha de preparación:
```

### Recursos recomendados

Los recursos mínimos dependen del número de servicios y métricas. Para una práctica básica se recomienda disponer, como referencia, de:

| Recurso | Recomendación |
|---|---|
| CPU | 2 vCPU |
| Memoria | 4 GB RAM |
| Almacenamiento | 20 GB disponibles |
| Red | Acceso a la red del laboratorio |
| Sistema | Linux actualizado |

Estos valores son orientativos. El instructor puede adaptarlos a la infraestructura disponible.

### Acceso administrativo

El alumno debe poder ejecutar las operaciones necesarias para consultar el entorno y realizar las prácticas.

Ejemplos:

```bash
sudo systemctl status node_exporter
sudo systemctl status prometheus
sudo systemctl status grafana-server
```

No es necesario que todos los alumnos tengan permisos administrativos ilimitados. Es preferible conceder únicamente los permisos necesarios.

## Requisitos de software

### Grafana

Grafana debe estar instalado y accesible.

Comprobar el servicio:

```bash
sudo systemctl status grafana-server
```

Comprobar el acceso local:

```bash
curl -I http://localhost:3000
```

La interfaz web suele estar disponible en:

```text
http://localhost:3000
```

La URL puede variar según la configuración del laboratorio.

Registrar:

```text
Versión de Grafana:

URL:

Estado del servicio:

Usuario de acceso:

Fuente de datos configurada:
```

### Prometheus

Prometheus debe estar instalado y ejecutándose.

Comprobar el servicio:

```bash
sudo systemctl status prometheus
```

Comprobar la interfaz:

```bash
curl -I http://localhost:9090
```

Comprobar la API de consulta:

```bash
curl http://localhost:9090/api/v1/query?query=up
```

El resultado debe indicar si la consulta se ha procesado correctamente.

Registrar:

```text
Versión de Prometheus:

URL:

Estado del servicio:

Puerto:

Targets configurados:

Observaciones:
```

### Node Exporter

Node Exporter debe estar instalado en el servidor que se desea supervisar.

Comprobar el servicio:

```bash
sudo systemctl status node_exporter
```

Comprobar el endpoint de métricas:

```bash
curl http://localhost:9100/metrics
```

El resultado debería incluir métricas como:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes
node_filesystem_size_bytes
node_filesystem_avail_bytes
```

Registrar:

```text
Versión de Node Exporter:

Estado del servicio:

Puerto:

Endpoint:

Métricas disponibles:

Observaciones:
```

## Requisitos de conectividad

Los componentes deben poder comunicarse.

### Flujo de comunicación

```text
Node Exporter
    |
    | Exposición HTTP de métricas
    v
Prometheus
    |
    | Consultas HTTP o API
    v
Grafana
    |
    | Notificaciones
    v
Contacto de laboratorio
```

### Puertos habituales

| Componente | Puerto habitual | Función |
|---|---:|---|
| Grafana | 3000 | Interfaz web |
| Prometheus | 9090 | Consultas y almacenamiento |
| Node Exporter | 9100 | Exposición de métricas |

Los puertos pueden cambiar según el diseño del entorno.

### Comprobar puertos

```bash
ss -lntp
```

También se puede comprobar la conectividad desde el servidor:

```bash
curl http://localhost:3000
curl http://localhost:9090
curl http://localhost:9100/metrics
```

Si los componentes se encuentran en máquinas diferentes, utilizar los nombres o direcciones correspondientes:

```bash
curl http://prometheus:9090
curl http://node-exporter:9100/metrics
```

## Requisitos de Grafana

### Acceso a la interfaz

El alumno debe poder acceder a Grafana mediante un navegador.

Registrar:

```text
URL de Grafana:

Navegador utilizado:

Usuario:

Rol asignado:

Resultado del acceso:
```

No guardar contraseñas en la documentación.

### Permisos necesarios

El alumno debería disponer de permisos para:

- Consultar dashboards.
- Crear dashboards.
- Editar dashboards propios.
- Consultar la fuente de datos.
- Ejecutar consultas en Explore.
- Crear reglas de alerta.
- Crear o utilizar contactos de laboratorio.
- Crear políticas de notificación.
- Crear anotaciones.
- Crear silenciamientos.
- Consultar el historial de alertas.

Los permisos exactos pueden variar según el modelo de seguridad utilizado.

### Fuente de datos

Grafana debe tener configurada una fuente de datos de tipo Prometheus.

Registrar:

```text
Nombre de la fuente:

Tipo:

URL:

Método de acceso:

Estado:

Fecha de prueba:
```

## Requisitos de Prometheus

### Target de Node Exporter

Prometheus debe tener configurado el target de Node Exporter.

Consultar la página de targets:

```text
http://localhost:9090/targets
```

El target debería aparecer como disponible.

Estados habituales:

```text
UP
DOWN
UNKNOWN
```

### Comprobar desde la API

```bash
curl http://localhost:9090/api/v1/targets
```

Revisar:

```text
job:

instance:

health:

lastScrape:

lastError:
```

### Resultado esperado

```text
job:
node_exporter

health:
up

lastError:
vacío o sin error
```

## Requisitos funcionales

La solución final deberá permitir realizar las siguientes operaciones.

### Consultar disponibilidad

Utilizar una consulta equivalente a:

```promql
up{job="node_exporter"}
```

Interpretación:

```text
1 = objetivo disponible
0 = objetivo no disponible
```

### Consultar CPU

Utilizar una consulta equivalente a:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La consulta debe devolver el porcentaje aproximado de CPU utilizada por instancia.

### Consultar memoria

Utilizar una consulta equivalente a:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

La consulta debe devolver el porcentaje aproximado de memoria utilizada.

### Consultar almacenamiento

Utilizar una consulta equivalente a:

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

La consulta debe excluir sistemas de ficheros que no sean relevantes para la práctica.

### Crear un dashboard

El dashboard deberá incluir como mínimo:

- Estado de disponibilidad.
- CPU utilizada.
- Memoria utilizada.
- Almacenamiento utilizado.
- Instancia supervisada.
- Unidades correctas.
- Leyendas claras.
- Rango temporal configurable.
- Anotaciones visibles.

### Crear alertas

El alumno deberá crear, como mínimo:

- Una alerta de disponibilidad.
- Una alerta de CPU.
- Una alerta de memoria.
- Una alerta de almacenamiento.

### Configurar notificaciones

El alumno deberá configurar un contacto de laboratorio y una política de notificación.

El contacto puede utilizar:

- Correo de formación.
- Webhook de pruebas.
- Canal colaborativo autorizado.
- Sistema ITSM de laboratorio.

### Registrar eventos

El alumno deberá crear anotaciones para representar:

- Inicio de la práctica.
- Prueba de carga.
- Mantenimiento.
- Recuperación del servicio.
- Despliegue de prueba, si procede.

### Utilizar silenciamientos

El alumno deberá crear al menos un silenciamiento controlado para una actividad planificada.

El silenciamiento debe incluir:

- Coincidencias específicas.
- Inicio.
- Fin.
- Motivo.
- Alcance limitado.

## Requisitos de las alertas

### Alerta de disponibilidad

Configuración recomendada:

```text
Nombre:
NodeExporterDown-Laboratory

Consulta:
up{job="node_exporter"}

Condición:
Último valor igual a 0

Intervalo:
30 segundos

Duración:
1 minuto

Severidad:
critical
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

### Alerta de CPU

Configuración recomendada:

```text
Nombre:
HighCPUUsage-Laboratory

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos

Severidad:
warning
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

### Alerta de memoria

Configuración recomendada:

```text
Nombre:
HighMemoryUsage-Laboratory

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos

Severidad:
warning
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

### Alerta de almacenamiento

Configuración recomendada:

```text
Nombre:
FilesystemUsageHigh-Laboratory

Condición:
Mayor que 80

Intervalo:
5 minutos

Duración:
10 minutos

Severidad:
warning
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

## Requisitos de etiquetas y anotaciones

### Etiquetas obligatorias

Cada regla debe incluir como mínimo:

```text
alertname
severity
team
service
environment
resource
```

### Anotaciones obligatorias

Cada regla debe incluir:

```text
summary
description
```

Se recomienda añadir:

```text
runbook_url
dashboard_url
```

### Ejemplo

```text
summary:
CPU elevada en {{ $labels.instance }}

description:
La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url:
https://example.com/runbooks/high-cpu
```

## Requisitos de notificación

### Contacto de laboratorio

El contacto debe tener un nombre descriptivo:

```text
laboratory-observability
```

Registrar:

```text
Nombre:

Tipo:

Finalidad:

Equipo destinatario:

Fecha de creación:

Prueba realizada:

Resultado:
```

### Política de notificación

La política mínima puede utilizar:

```text
environment = laboratory
```

Contacto:

```text
laboratory-observability
```

Configuración de laboratorio:

```text
group_by:
- alertname
- instance

group_wait:
10 segundos

group_interval:
1 minuto

repeat_interval:
5 minutos
```

Los valores anteriores están pensados para prácticas. No deben utilizarse directamente en producción sin una revisión operativa.

## Requisitos de seguridad

### Uso exclusivo del laboratorio

Todas las pruebas deben realizarse en recursos autorizados.

No se debe:

```text
Detener servicios de producción.
Generar carga en servidores reales.
Crear alertas sobre contactos reales.
Modificar reglas de firewall sin autorización.
Eliminar archivos.
Exponer credenciales.
```

### Protección de credenciales

No incluir en la entrega:

- Contraseñas.
- Tokens.
- Claves API.
- Claves privadas.
- Cookies.
- Cabeceras de autenticación.
- URLs con credenciales.
- Secretos SMTP.

### Contactos autorizados

Las notificaciones deberán enviarse únicamente a:

```text
Contactos de formación.
Webhooks de pruebas.
Canales internos autorizados.
Sistemas ITSM de laboratorio.
```

### Separación de entornos

Todas las reglas del proyecto deberán incluir:

```text
environment = laboratory
```

Esta etiqueta permite distinguir las alertas de prácticas de las alertas de otros entornos.

## Requisitos de documentación

El alumno deberá documentar:

- Arquitectura.
- Versiones.
- Direcciones utilizadas.
- Consultas PromQL.
- Paneles creados.
- Alertas configuradas.
- Etiquetas.
- Anotaciones.
- Contactos.
- Políticas.
- Silenciamientos.
- Pruebas.
- Problemas.
- Soluciones.
- Limitaciones.
- Limpieza final.

### Registro del entorno

```text
Alumno:

Grupo:

Fecha de inicio:

Fecha de finalización:

Sistema operativo:

Versión de Grafana:

Versión de Prometheus:

Versión de Node Exporter:

URL de Grafana:

URL de Prometheus:

Nombre de la fuente de datos:

Contacto utilizado:

Observaciones:
```

## Requisitos de evidencias

Las evidencias deben demostrar que la configuración funciona.

### Evidencias recomendadas

```text
01-servicios-activos.png
02-fuente-prometheus.png
03-target-node-exporter.png
04-consulta-disponibilidad.png
05-consulta-cpu.png
06-consulta-memoria.png
07-consulta-almacenamiento.png
08-dashboard-inicial.png
09-dashboard-operativo.png
10-alerta-disponibilidad.png
11-alerta-cpu.png
12-alerta-memoria.png
13-alerta-almacenamiento.png
14-contacto-notificacion.png
15-politica-notificacion.png
16-alerta-pending.png
17-alerta-alerting.png
18-notificacion-recibida.png
19-silencio-activo.png
20-alerta-resuelta.png
21-dashboard-final.png
```

### Organización recomendada

```text
evidencias/
├── entorno/
├── promql/
├── dashboard/
├── alertas/
├── notificaciones/
├── silencios/
└── informe/
```

### Revisión de capturas

Antes de entregar una captura, comprobar:

```text
¿Se entiende qué se está demostrando?

¿Se ve el nombre de la regla?

¿Se ven las etiquetas relevantes?

¿Se ocultan los secretos?

¿La fecha o la hora son visibles?

¿La captura pertenece al laboratorio?
```

## Sesión 1: revisar los requisitos

### Objetivo

Identificar qué requisitos están disponibles y cuáles deben prepararse.

### Actividad

Completar la tabla:

| Requisito | Disponible | Pendiente | Observaciones |
|---|---|---|---|
| Máquina de laboratorio | | | |
| Grafana | | | |
| Prometheus | | | |
| Node Exporter | | | |
| Fuente de datos | | | |
| Acceso web | | | |
| Acceso de terminal | | | |
| Contacto de pruebas | | | |
| Permisos de alertas | | | |
| Directorio de evidencias | | | |

### Resultado esperado

El alumno debe conocer el estado inicial del entorno antes de comenzar la configuración.

## Sesión 2: comprobar los servicios

### Objetivo

Verificar que los servicios principales están disponibles.

### Procedimiento

```bash
sudo systemctl status node_exporter
sudo systemctl status prometheus
sudo systemctl status grafana-server
```

Si se utilizan contenedores:

```bash
docker ps
```

Comprobar los puertos:

```bash
ss -lntp
```

Comprobar los endpoints:

```bash
curl http://localhost:9100/metrics
curl http://localhost:9090
curl http://localhost:3000
```

### Registro

```text
Servicio:

Comando utilizado:

Estado:

Respuesta:

Problema encontrado:

Corrección:

Resultado:
```

## Sesión 3: comprobar la fuente de datos

### Objetivo

Validar la conexión entre Grafana y Prometheus.

### Procedimiento

1. Acceder a Grafana.
2. Abrir las fuentes de datos.
3. Seleccionar Prometheus.
4. Comprobar la URL.
5. Ejecutar la prueba de conexión.
6. Registrar el resultado.

### Diagnóstico

Si la fuente no funciona:

```text
¿Prometheus está activo?

¿La URL es correcta?

¿El puerto responde?

¿Grafana puede resolver el nombre?

¿Existe un firewall?

¿Aparece un error en los logs?
```

## Sesión 4: validar las métricas

### Objetivo

Comprobar que Prometheus dispone de las métricas necesarias.

### Consultas

```promql
up
```

```promql
up{job="node_exporter"}
```

```promql
node_cpu_seconds_total
```

```promql
node_memory_MemTotal_bytes
```

```promql
node_filesystem_size_bytes
```

### Registro

```text
Consulta:

¿Devuelve datos?:

Número de series:

Etiquetas:

Valor observado:

Resultado:
```

## Sesión 5: comprobar permisos

### Objetivo

Verificar que el alumno puede realizar las operaciones del proyecto.

### Comprobar

```text
¿Puede abrir Grafana?

¿Puede abrir Explore?

¿Puede crear un dashboard?

¿Puede guardar un dashboard?

¿Puede crear una regla?

¿Puede editar una regla propia?

¿Puede crear anotaciones?

¿Puede crear un silenciamiento?

¿Puede probar un contacto?
```

### Registro

| Operación | Permitida | Error | Acción |
|---|---|---|---|
| Consultar datos | | | |
| Crear dashboard | | | |
| Crear alerta | | | |
| Crear anotación | | | |
| Crear silencio | | | |
| Probar contacto | | | |

## Sesión 6: preparar la estructura de trabajo

### Objetivo

Crear el espacio donde se guardarán las evidencias y documentos.

```bash
mkdir -p ~/proyecto-final-grafana
mkdir -p ~/proyecto-final-grafana/evidencias
mkdir -p ~/proyecto-final-grafana/evidencias/entorno
mkdir -p ~/proyecto-final-grafana/evidencias/promql
mkdir -p ~/proyecto-final-grafana/evidencias/dashboard
mkdir -p ~/proyecto-final-grafana/evidencias/alertas
mkdir -p ~/proyecto-final-grafana/evidencias/notificaciones
mkdir -p ~/proyecto-final-grafana/evidencias/silencios
mkdir -p ~/proyecto-final-grafana/informe
```

Crear un registro:

```bash
cat > ~/proyecto-final-grafana/evidencias/registro-requisitos.txt <<'EOF'
Alumno:

Grupo:

Fecha:

Entorno:

Sistema operativo:

Grafana:

Prometheus:

Node Exporter:

Fuente de datos:

Contacto de laboratorio:

Permisos verificados:

Problemas:

Resultado:
EOF
```

## Sesión 7: identificar limitaciones

### Objetivo

Documentar las restricciones del entorno antes de comenzar.

### Posibles limitaciones

```text
Solo existe una instancia.
No se puede generar carga.
No se permite detener Node Exporter.
No existe un canal de notificación real.
No se dispone de almacenamiento suficiente.
El alumno no puede crear contactos.
La versión de Grafana no incluye alguna función.
No hay acceso a producción.
```

### Registro

```text
Limitación:

Impacto:

Alternativa:

Autorización:

Resultado:
```

### Ejemplo

```text
Limitación:
Solo existe una instancia de Node Exporter.

Impacto:
No se puede probar el comportamiento entre varios servidores.

Alternativa:
Utilizar varias etiquetas y documentar la limitación.

Resultado:
La práctica se realiza sobre una única instancia.
```

## Sesión 8: comprobar el endpoint de métricas

### Objetivo

Confirmar que Node Exporter expone las métricas necesarias.

### Comando

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

### Registro

```text
Métrica:

Existe:

Valor o serie:

Resultado:
```

## Sesión 9: validar Prometheus

### Objetivo

Confirmar que Prometheus recopila las métricas de Node Exporter.

### Procedimiento

1. Abrir la página de targets.
2. Localizar el job de Node Exporter.
3. Revisar el estado.
4. Revisar el último scrape.
5. Revisar los errores.
6. Registrar la información.

### Registro

```text
Job:

Instance:

Health:

Last scrape:

Last error:

Resultado:
```

### Resultado esperado

```text
Health:
up

Last error:
sin errores
```

## Sesión 10: validar Grafana

### Objetivo

Confirmar que Grafana puede utilizar la fuente de datos.

### Procedimiento

1. Abrir Explore.
2. Seleccionar Prometheus.
3. Ejecutar:

```promql
up
```

4. Cambiar a la consulta:

```promql
up{job="node_exporter"}
```

5. Confirmar que aparecen las series.
6. Guardar una captura.

### Registro

```text
Consulta:

Resultado:

Fuente utilizada:

Número de series:

Captura guardada:

Observaciones:
```

## Requisitos de aceptación

El entorno se considera preparado cuando cumple todos estos puntos:

- La máquina de laboratorio está identificada.
- Grafana está accesible.
- Prometheus está accesible.
- Node Exporter está activo.
- El endpoint de métricas responde.
- Prometheus muestra el target como disponible.
- Grafana puede consultar Prometheus.
- El alumno puede crear o editar dashboards.
- El alumno puede realizar las prácticas previstas.
- Existe un contacto de notificación de laboratorio.
- Se ha creado el directorio de evidencias.
- Las limitaciones están documentadas.
- No se utilizan sistemas de producción.

## Requisitos de entrega

La entrega deberá incluir como mínimo:

### Documentación

- Descripción del entorno.
- Versiones utilizadas.
- Arquitectura.
- Requisitos disponibles.
- Limitaciones.
- Procedimiento de configuración.
- Procedimiento de pruebas.
- Diagnóstico de problemas.
- Conclusiones.

### Configuración

- Dashboard.
- Consultas PromQL.
- Reglas de alerta.
- Etiquetas.
- Anotaciones.
- Contacto de notificación.
- Política de notificación.
- Silenciamiento.

### Evidencias

- Servicios funcionando.
- Fuente de datos validada.
- Targets disponibles.
- Consultas ejecutadas.
- Dashboard creado.
- Alertas configuradas.
- Alertas activadas.
- Notificaciones recibidas.
- Alertas recuperadas.
- Silenciamiento comprobado.
- Entorno limpiado.

## Puntos clave

- Los requisitos deben verificarse antes de comenzar la configuración.
- Grafana, Prometheus y Node Exporter deben estar disponibles.
- Prometheus debe poder recopilar métricas de Node Exporter.
- Grafana debe poder consultar Prometheus.
- El alumno necesita permisos suficientes para realizar el proyecto.
- Los puertos y URLs deben estar documentados.
- El entorno de laboratorio debe estar separado de producción.
- Las consultas PromQL deben validarse antes de crear dashboards o alertas.
- Las alertas deben tener etiquetas y anotaciones coherentes.
- Las notificaciones deben utilizar contactos autorizados.
- Las evidencias no deben contener secretos.
- Las limitaciones deben documentarse.
- Los requisitos funcionales indican qué debe hacer la solución.
- Los requisitos técnicos indican con qué recursos se construirá.
- Los requisitos de seguridad protegen el entorno y la información.
- La preparación del entorno es parte del proyecto.
- La solución debe poder reproducirse a partir de la documentación.
- Un requisito no verificado puede convertirse en un error durante la práctica.
- La limpieza y la revisión final también forman parte de la aceptación.

## Preguntas de comprobación

1. ¿Qué componentes técnicos son necesarios para realizar el proyecto?
2. ¿Qué función cumple Node Exporter?
3. ¿Qué función cumple Prometheus?
4. ¿Qué función cumple Grafana?
5. ¿Qué puerto utiliza habitualmente Node Exporter?
6. ¿Cómo comprobarías que Node Exporter expone métricas?
7. ¿Cómo comprobarías que Prometheus recopila datos?
8. ¿Cómo verificarías que Grafana puede consultar Prometheus?
9. ¿Qué permisos necesita el alumno?
10. ¿Qué diferencia existe entre un requisito funcional y uno técnico?
11. ¿Por qué debe utilizarse un entorno de laboratorio?
12. ¿Qué información no debe aparecer en la documentación?
13. ¿Qué etiquetas deberían incluir las reglas?
14. ¿Qué alertas mínimas debe crear el alumno?
15. ¿Qué información debe incluir un contacto de laboratorio?
16. ¿Qué evidencias demostrarían que el entorno está preparado?
17. ¿Qué harías si el target de Node Exporter aparece como `DOWN`?
18. ¿Qué harías si Grafana no puede consultar Prometheus?
19. ¿Cómo documentarías una limitación del entorno?
20. ¿Qué condiciones deben cumplirse para aceptar el entorno?

## Resultado esperado

Al finalizar esta sección, el alumno debe haber comprobado que el entorno cumple los requisitos necesarios para realizar el proyecto.

El flujo de validación será:

```text
Identificar la máquina
        |
        v
Comprobar el sistema operativo
        |
        v
Comprobar Node Exporter
        |
        v
Comprobar Prometheus
        |
        v
Comprobar Grafana
        |
        v
Validar la conectividad
        |
        v
Validar las métricas
        |
        v
Validar la fuente de datos
        |
        v
Comprobar los permisos
        |
        v
Preparar las evidencias
        |
        v
Documentar las limitaciones
        |
        v
Aceptar el entorno
```

El entorno estará preparado cuando:

- Todos los servicios necesarios estén disponibles.
- Las métricas sean accesibles.
- Prometheus muestre los targets correctamente.
- Grafana consulte la fuente de datos sin errores.
- El alumno tenga los permisos necesarios.
- Las pruebas puedan realizarse de forma segura.
- Exista un contacto de notificación de laboratorio.
- La estructura de evidencias esté creada.
- Las restricciones estén documentadas.
- No exista riesgo de afectar a producción.

La preparación correcta evita que los problemas de infraestructura se confundan con errores de consultas, dashboards o alertas. En observabilidad, comprobar los cimientos antes de construir la casa ahorra bastante excavación posterior.