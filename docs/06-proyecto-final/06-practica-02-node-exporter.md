# Práctica 2 - Node Exporter

Node Exporter es un agente que expone métricas del sistema operativo para que Prometheus pueda recopilarlas.

En esta práctica, el alumno instalará o validará Node Exporter en un entorno de laboratorio, comprobará que el servicio funciona, revisará las métricas expuestas y verificará que Prometheus puede recopilarlas correctamente.

La práctica también introduce conceptos importantes como:

- *Targets* de Prometheus.
- Jobs e instancias.
- Endpoint `/metrics`.
- Estado `UP` y `DOWN`.
- Etiquetas de las series temporales.
- Diagnóstico de errores de recopilación.
- Validación mediante comandos y consultas PromQL.

Todas las actividades deben realizarse únicamente sobre máquinas autorizadas. No se debe instalar, detener ni modificar Node Exporter en sistemas de producción sin autorización expresa.

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar la función de Node Exporter.
- Diferenciar Node Exporter de Prometheus.
- Comprobar si Node Exporter está instalado.
- Comprobar si Node Exporter está activo.
- Identificar el puerto de escucha.
- Consultar el endpoint `/metrics`.
- Reconocer métricas de CPU, memoria, disco y red.
- Revisar las etiquetas de una métrica.
- Instalar Node Exporter en un entorno Linux de laboratorio.
- Crear o revisar una unidad de `systemd`.
- Configurar el arranque automático del servicio.
- Validar la conectividad desde Prometheus.
- Identificar un target `UP`.
- Identificar un target `DOWN`.
- Diagnosticar errores habituales.
- Consultar métricas desde Prometheus.
- Documentar el resultado de la práctica.
- Preparar evidencias técnicas sin exponer secretos.

## Introducción

Prometheus no obtiene automáticamente todas las métricas de un servidor. Necesita que un componente las exponga en un formato que pueda consultar.

Node Exporter cumple esa función:

```text
Sistema operativo
        |
        v
Node Exporter
        |
        | HTTP /metrics
        v
Prometheus
        |
        v
Grafana
```

Node Exporter no almacena las métricas a largo plazo ni crea dashboards. Su función principal es:

```text
Leer información del sistema
        |
        v
Convertirla en métricas
        |
        v
Exponerlas mediante HTTP
```

El endpoint habitual es:

```text
http://localhost:9100/metrics
```

Prometheus consulta periódicamente ese endpoint y guarda los valores como series temporales.

## Arquitectura de la práctica

### Componentes

La práctica utiliza los siguientes componentes:

| Componente | Función |
|---|---|
| Sistema operativo | Genera información sobre recursos y actividad |
| Node Exporter | Expone métricas del sistema |
| Prometheus | Recopila y almacena las métricas |
| Grafana | Visualiza y consulta las métricas |

### Flujo de recopilación

```text
Node Exporter expone métricas
        |
        v
Prometheus realiza un scrape
        |
        v
Prometheus almacena las series
        |
        v
Grafana consulta Prometheus
```

### Puertos habituales

| Servicio | Puerto habitual | Uso |
|---|---:|---|
| Node Exporter | 9100 | Endpoint de métricas |
| Prometheus | 9090 | Interfaz y API |
| Grafana | 3000 | Interfaz web |

Los puertos pueden cambiar según la configuración del laboratorio.

## Conceptos fundamentales

### Endpoint `/metrics`

Es la dirección HTTP desde la que Node Exporter expone las métricas.

Ejemplo:

```text
http://192.0.2.10:9100/metrics
```

Una respuesta correcta contiene líneas similares a:

```text
# HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
# TYPE node_memory_MemTotal_bytes gauge
node_memory_MemTotal_bytes 4.294967296e+09
```

### Scrape

Un *scrape* es una consulta que Prometheus realiza contra un endpoint de métricas.

Ejemplo:

```text
Prometheus → http://server-01:9100/metrics
```

Si el endpoint responde correctamente, el target suele aparecer como:

```text
UP
```

### Target

Un *target* es un endpoint que Prometheus supervisa.

Ejemplo:

```text
job = node_exporter
instance = server-01:9100
```

### Job

Un *job* agrupa targets con una función común.

Ejemplo:

```text
job = node_exporter
```

Puede contener varios servidores:

```text
server-01:9100
server-02:9100
server-03:9100
```

### Instance

La etiqueta `instance` identifica normalmente una dirección y un puerto concretos.

Ejemplo:

```text
instance = server-01:9100
```

### Estado `UP`

El estado `UP` indica que Prometheus ha podido consultar el endpoint correctamente.

En PromQL se representa habitualmente mediante:

```promql
up{job="node_exporter"}
```

Interpretación:

```text
1 = target disponible
0 = target no disponible
```

### Estado `DOWN`

El estado `DOWN` indica que Prometheus no ha podido consultar correctamente el endpoint.

Las causas pueden ser:

- Servicio detenido.
- Puerto incorrecto.
- Dirección incorrecta.
- Firewall.
- Error de red.
- Error DNS.
- Configuración incorrecta.
- Endpoint inaccesible.

## Requisitos previos

Antes de comenzar, el alumno debe disponer de:

- Una máquina Linux de laboratorio.
- Acceso a una terminal.
- Permisos administrativos controlados.
- Prometheus instalado o accesible.
- Grafana instalado o accesible.
- Conectividad entre Prometheus y el servidor supervisado.
- Un directorio para guardar evidencias.
- Autorización para instalar o modificar Node Exporter.

Registrar los datos del entorno:

```text
Alumno:

Grupo:

Fecha:

Nombre del servidor:

Dirección IP:

Sistema operativo:

Versión del sistema:

Entorno:

Prometheus:

Grafana:

Responsable del laboratorio:
```

## Preparación del entorno

### Crear el directorio de trabajo

```bash
mkdir -p ~/proyecto-final-grafana
mkdir -p ~/proyecto-final-grafana/evidencias/node-exporter
mkdir -p ~/proyecto-final-grafana/informe
```

### Crear un registro de la práctica

```bash
cat > ~/proyecto-final-grafana/evidencias/node-exporter/registro-practica-2.txt <<'EOF'
# Registro - Práctica 2

Alumno:

Grupo:

Fecha:

Servidor:

Dirección IP:

Sistema operativo:

Versión de Node Exporter:

Puerto:

Estado inicial:

Estado final:

Target en Prometheus:

Problemas encontrados:

Correcciones:

Resultado:
EOF
```

## Sesión 1: comprobar el sistema operativo

### Objetivo

Identificar la máquina donde se ejecutará o validará Node Exporter.

### Comandos

Consultar el nombre del host:

```bash
hostname
```

Consultar información del sistema:

```bash
hostnamectl
```

Consultar la versión del kernel:

```bash
uname -a
```

Consultar la distribución:

```bash
cat /etc/os-release
```

Consultar la arquitectura:

```bash
uname -m
```

### Registro

```text
Nombre del host:

Distribución:

Versión:

Kernel:

Arquitectura:

Dirección IP:

Resultado:
```

### Resultado esperado

El alumno debe conocer exactamente en qué máquina está trabajando y confirmar que pertenece al entorno de laboratorio.

## Sesión 2: comprobar si Node Exporter está instalado

### Objetivo

Determinar si Node Exporter ya está disponible.

### Comprobar el servicio

```bash
sudo systemctl status node_exporter
```

En algunos entornos, el servicio puede utilizar otro nombre:

```bash
sudo systemctl status node-exporter
```

### Buscar el binario

```bash
command -v node_exporter
```

También se puede buscar en ubicaciones habituales:

```bash
find /usr/local/bin /usr/bin -name 'node_exporter' 2>/dev/null
```

### Comprobar la versión

```bash
node_exporter --version
```

### Comprobar procesos

```bash
ps aux | grep '[n]ode_exporter'
```

### Registro

```text
Nombre del servicio:

Binario encontrado:

Versión:

Proceso activo:

Estado:

Resultado:
```

### Interpretación

| Resultado | Interpretación |
|---|---|
| Servicio activo | Node Exporter está ejecutándose |
| Servicio inactivo | Está instalado, pero detenido |
| Servicio inexistente | No hay una unidad con ese nombre |
| Binario encontrado | Puede instalarse manualmente |
| Binario no encontrado | Es necesario instalarlo |

## Sesión 3: comprobar el puerto 9100

### Objetivo

Comprobar si Node Exporter está escuchando en el puerto habitual.

### Comando

```bash
ss -lntp | grep ':9100'
```

También se puede utilizar:

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

### Resultado esperado

Una salida posible sería:

```text
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=1234,fd=3))
```

### Interpretación

- `LISTEN` indica que existe un proceso escuchando.
- `9100` es el puerto utilizado.
- `node_exporter` identifica el proceso.
- `0.0.0.0` indica que escucha en todas las interfaces IPv4.

### Registro

```text
Puerto:

Dirección de escucha:

Proceso:

PID:

Resultado:
```

## Sesión 4: consultar el endpoint local

### Objetivo

Comprobar que Node Exporter responde mediante HTTP.

### Comando

```bash
curl http://localhost:9100/metrics
```

La salida puede ser extensa. Para revisar solo algunas métricas:

```bash
curl -s http://localhost:9100/metrics | grep '^node_cpu_seconds_total'
```

```bash
curl -s http://localhost:9100/metrics | grep '^node_memory_MemTotal_bytes'
```

```bash
curl -s http://localhost:9100/metrics | grep '^node_filesystem_size_bytes'
```

### Comprobar el código HTTP

```bash
curl -I http://localhost:9100/metrics
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

### Guardar una muestra

```bash
curl -s http://localhost:9100/metrics \
  | grep -E '^node_(cpu_seconds_total|memory_MemTotal_bytes|filesystem_size_bytes)' \
  > ~/proyecto-final-grafana/evidencias/node-exporter/metrics-muestra.txt
```

### Registro

```text
URL:

Código HTTP:

Métrica de CPU disponible:

Métrica de memoria disponible:

Métrica de almacenamiento disponible:

Resultado:
```

## Sesión 5: identificar métricas básicas

### Objetivo

Reconocer las métricas que se utilizarán en el resto del curso.

### CPU

```promql
node_cpu_seconds_total
```

Esta métrica es un contador acumulativo del tiempo de CPU.

Etiquetas habituales:

```text
cpu
instance
job
mode
```

Ejemplo:

```text
node_cpu_seconds_total{
  cpu="0",
  instance="server-01:9100",
  job="node_exporter",
  mode="idle"
}
```

### Memoria total

```promql
node_memory_MemTotal_bytes
```

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Tamaño del sistema de ficheros

```promql
node_filesystem_size_bytes
```

### Espacio disponible

```promql
node_filesystem_avail_bytes
```

### Tiempo de actividad

```promql
node_time_seconds
```

### Información del sistema

```promql
node_uname_info
```

### Red

```promql
node_network_receive_bytes_total
```

```promql
node_network_transmit_bytes_total
```

### Actividad

Completar la tabla:

| Necesidad | Métrica | Tipo aproximado | Etiquetas |
|---|---|---|---|
| CPU | | | |
| Memoria total | | | |
| Memoria disponible | | | |
| Disco total | | | |
| Disco disponible | | | |
| Sistema operativo | | | |
| Red recibida | | | |

## Sesión 6: instalar Node Exporter desde un paquete

### Objetivo

Instalar Node Exporter utilizando el gestor de paquetes del sistema, si está disponible.

El procedimiento exacto depende de la distribución y de la versión del paquete.

### Debian o Ubuntu

Buscar el paquete:

```bash
apt-cache search node-exporter
```

Actualizar el índice de paquetes, si está autorizado:

```bash
sudo apt update
```

Instalar:

```bash
sudo apt install prometheus-node-exporter
```

Comprobar el servicio:

```bash
sudo systemctl status prometheus-node-exporter
```

En algunas distribuciones, el nombre del servicio puede ser:

```bash
sudo systemctl status node_exporter
```

### RHEL, Rocky, AlmaLinux o Fedora

Buscar paquetes disponibles:

```bash
dnf search node-exporter
```

Instalar si el repositorio autorizado lo proporciona:

```bash
sudo dnf install node_exporter
```

Comprobar el servicio:

```bash
sudo systemctl status node_exporter
```

### Registro

```text
Distribución:

Comando de instalación:

Paquete:

Versión:

Nombre del servicio:

Resultado:
```

### Nota

Si el laboratorio ya incluye Node Exporter, no es necesario reinstalarlo. En ese caso, se debe documentar la instalación existente y continuar con la validación.

## Sesión 7: instalar Node Exporter mediante un binario

### Objetivo

Conocer el procedimiento general para instalar Node Exporter cuando no existe un paquete disponible.

Esta sesión debe realizarse únicamente con un binario proporcionado por el instructor o descargado desde una fuente autorizada.

### Variables de ejemplo

Sustituir la versión por la proporcionada en el laboratorio:

```bash
export NODE_EXPORTER_VERSION="X.Y.Z"
export NODE_EXPORTER_ARCHIVE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
```

### Crear un usuario de servicio

```bash
sudo useradd \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

Si el usuario ya existe, el comando puede devolver un aviso. No se debe crear un segundo usuario con un nombre diferente sin documentarlo.

### Crear el directorio de instalación

```bash
sudo mkdir -p /opt/node_exporter
```

### Copiar el binario

Después de obtener el binario autorizado:

```bash
sudo cp node_exporter /opt/node_exporter/node_exporter
```

Asignar permisos:

```bash
sudo chown root:root /opt/node_exporter/node_exporter
sudo chmod 0755 /opt/node_exporter/node_exporter
```

### Comprobar la versión

```bash
/opt/node_exporter/node_exporter --version
```

### Registro

```text
Versión:

Ruta de instalación:

Usuario de servicio:

Permisos:

Resultado:
```

## Sesión 8: crear una unidad de systemd

### Objetivo

Configurar Node Exporter como un servicio gestionado por `systemd`.

Crear el fichero:

```bash
sudo nano /etc/systemd/system/node_exporter.service
```

Contenido de ejemplo:

```ini
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/opt/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target
```

Recargar las unidades:

```bash
sudo systemctl daemon-reload
```

Activar el servicio para el arranque:

```bash
sudo systemctl enable node_exporter
```

Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

Comprobar el estado:

```bash
sudo systemctl status node_exporter
```

### Resultado esperado

El servicio debe aparecer como:

```text
Active: active (running)
```

### Registro

```text
Fichero creado:

Usuario:

Grupo:

Comando ExecStart:

Servicio habilitado:

Servicio iniciado:

Resultado:
```

## Sesión 9: revisar los logs de Node Exporter

### Objetivo

Consultar los mensajes del servicio y detectar errores.

### Consultar los logs recientes

```bash
sudo journalctl -u node_exporter --no-pager -n 50
```

### Seguir los logs en tiempo real

```bash
sudo journalctl -u node_exporter -f
```

Salir con:

```text
Ctrl+C
```

### Consultar desde el último arranque

```bash
sudo journalctl -u node_exporter -b
```

### Buscar errores

```bash
sudo journalctl -u node_exporter --no-pager \
  | grep -iE 'error|fail|warn'
```

### Posibles mensajes

```text
Address already in use
Permission denied
ExecStart failed
No such file or directory
Failed to start
```

### Registro

```text
Fecha:

Mensaje:

Nivel:

Causa probable:

Acción realizada:

Resultado:
```

## Sesión 10: verificar el arranque automático

### Objetivo

Comprobar que Node Exporter se iniciará automáticamente después de reiniciar la máquina.

### Comprobar si está habilitado

```bash
systemctl is-enabled node_exporter
```

Resultado esperado:

```text
enabled
```

### Comprobar el estado actual

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
active
```

### Verificar la configuración sin reiniciar

```bash
systemctl cat node_exporter
```

### Registro

```text
Habilitado:

Activo:

Unidad revisada:

Resultado:
```

No reiniciar la máquina si el instructor no lo ha autorizado.

## Sesión 11: revisar las opciones de Node Exporter

### Objetivo

Consultar las opciones disponibles sin modificar todavía la configuración.

Ejecutar:

```bash
node_exporter --help
```

Si el binario está en otra ruta:

```bash
/opt/node_exporter/node_exporter --help
```

### Revisar el puerto

Buscar la opción relacionada con la dirección de escucha:

```text
--web.listen-address
```

Ejemplo:

```text
--web.listen-address=:9100
```

### Revisar el endpoint de métricas

Buscar:

```text
--web.telemetry-path
```

El valor habitual es:

```text
/metrics
```

### Actividad

Registrar:

```text
Dirección de escucha por defecto:

Puerto por defecto:

Ruta de métricas:

Collectors disponibles:

Resultado:
```

## Sesión 12: comprobar los collectors

### Objetivo

Identificar qué grupos de métricas están habilitados.

Node Exporter utiliza *collectors* para obtener información de diferentes áreas del sistema.

Algunos collectors habituales son:

```text
cpu
filesystem
loadavg
meminfo
netdev
os
time
uname
```

### Consultar las métricas relacionadas

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_exporter_build_info'
```

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem'
```

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory'
```

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_network'
```

### Registro

```text
Collector o grupo:

Métrica observada:

Disponible:

Finalidad:

Resultado:
```

### Consideración

No se deben activar collectors adicionales sin comprender su función y sin comprobar el impacto que pueden tener en el entorno.

## Sesión 13: validar el acceso remoto

### Objetivo

Comprobar que el endpoint puede ser consultado desde el servidor de Prometheus.

Esta sesión debe realizarse solo si Node Exporter y Prometheus están en máquinas distintas.

### Desde el servidor de Prometheus

```bash
curl http://DIRECCION_NODE_EXPORTER:9100/metrics
```

Comprobar solo las cabeceras:

```bash
curl -I http://DIRECCION_NODE_EXPORTER:9100/metrics
```

### Comprobar resolución de nombre

```bash
getent hosts NOMBRE_NODE_EXPORTER
```

### Comprobar conectividad TCP

Si está disponible:

```bash
nc -vz DIRECCION_NODE_EXPORTER 9100
```

### Registro

```text
Origen:

Destino:

Nombre resuelto:

Puerto:

Código HTTP:

Conectividad TCP:

Resultado:
```

### Diagnóstico

Si falla la conexión, revisar:

- Dirección IP.
- Nombre DNS.
- Puerto configurado.
- Firewall local.
- Firewall de red.
- Dirección de escucha.
- Ruta de red.
- Estado del servicio.

## Sesión 14: configurar el target en Prometheus

### Objetivo

Añadir Node Exporter a la configuración de Prometheus.

La configuración puede encontrarse en una ruta similar a:

```text
/etc/prometheus/prometheus.yml
```

Antes de editar, realizar una copia de seguridad:

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.backup
```

Añadir un job de ejemplo:

```yaml
scrape_configs:
  - job_name: "node_exporter"
    static_configs:
      - targets:
          - "server-01:9100"
        labels:
          environment: "laboratory"
          team: "systems"
```

Si se utiliza una dirección IP:

```yaml
scrape_configs:
  - job_name: "node_exporter"
    static_configs:
      - targets:
          - "192.0.2.10:9100"
        labels:
          environment: "laboratory"
          team: "systems"
```

### Validar la configuración

La herramienta concreta depende de la instalación. Si está disponible:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
SUCCESS
```

### Recargar Prometheus

Si el servicio utiliza `systemd`:

```bash
sudo systemctl reload prometheus
```

Si no admite recarga:

```bash
sudo systemctl restart prometheus
```

El reinicio debe realizarse únicamente en el entorno de laboratorio y siguiendo las instrucciones del instructor.

### Comprobar el servicio

```bash
sudo systemctl status prometheus
```

### Registro

```text
Fichero modificado:

Copia de seguridad:

Job:

Target:

Etiquetas:

Validación:

Recarga o reinicio:

Resultado:
```

## Sesión 15: comprobar el target en Prometheus

### Objetivo

Confirmar que Prometheus puede recopilar las métricas.

### Procedimiento

1. Abrir la interfaz de Prometheus.
2. Acceder a la página de targets.
3. Buscar el job `node_exporter`.
4. Revisar el target.
5. Revisar el estado de salud.
6. Revisar el último scrape.
7. Revisar el último error.

URL habitual:

```text
http://localhost:9090/targets
```

### Estados esperados

```text
State:
UP

Health:
up

Last scrape:
reciente

Last error:
vacío
```

### Registro

```text
Job:

Instance:

State:

Health:

Last scrape:

Last error:

Labels:

Resultado:
```

## Sesión 16: consultar Node Exporter desde Prometheus

### Objetivo

Comprobar que las métricas ya están almacenadas en Prometheus.

### Consultas

Disponibilidad:

```promql
up{job="node_exporter"}
```

Información de compilación:

```promql
node_exporter_build_info
```

CPU:

```promql
node_cpu_seconds_total
```

Memoria:

```promql
node_memory_MemTotal_bytes
```

Sistema de ficheros:

```promql
node_filesystem_size_bytes
```

Información del sistema:

```promql
node_uname_info
```

### Registro

```text
Consulta:

¿Devuelve datos?:

Número de series:

Instancia:

Job:

Resultado:
```

## Sesión 17: practicar filtros por etiquetas

### Objetivo

Aprender a seleccionar métricas concretas mediante etiquetas.

### Filtrar por job

```promql
up{job="node_exporter"}
```

### Filtrar por instancia

```promql
up{instance="server-01:9100"}
```

### Filtrar por modo de CPU

```promql
node_cpu_seconds_total{mode="idle"}
```

### Filtrar por sistema de ficheros

```promql
node_filesystem_size_bytes{mountpoint="/"}
```

### Excluir sistemas de ficheros

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Registro

```text
Consulta:

Filtro:

Series devueltas:

Resultado:

Observaciones:
```

## Sesión 18: calcular CPU a partir de Node Exporter

### Objetivo

Utilizar las métricas de Node Exporter para obtener una métrica más útil.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Consulta por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance="server-01:9100"
    }[5m])
  ) * 100
)
```

### Consulta por modo

```promql
sum by (instance, mode) (
  rate(node_cpu_seconds_total[5m])
)
```

### Actividad

Comparar:

```text
El valor de idle.

El valor de CPU utilizada.

El número de instancias.

El número de CPUs.

La evolución durante cinco minutos.
```

## Sesión 19: calcular memoria a partir de Node Exporter

### Objetivo

Utilizar las métricas de memoria para obtener valores absolutos y porcentuales.

### Memoria total

```promql
node_memory_MemTotal_bytes
```

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Memoria utilizada en bytes

```promql
node_memory_MemTotal_bytes
-
node_memory_MemAvailable_bytes
```

### Memoria utilizada en porcentaje

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Actividad

Registrar:

```text
Memoria total:

Memoria disponible:

Memoria utilizada:

Porcentaje utilizado:

Resultado:
```

## Sesión 20: calcular almacenamiento a partir de Node Exporter

### Objetivo

Obtener el porcentaje utilizado de un sistema de ficheros.

### Tamaño total

```promql
node_filesystem_size_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Espacio disponible

```promql
node_filesystem_avail_bytes{
  mountpoint="/",
  fstype!~"tmpfs|overlay"
}
```

### Porcentaje utilizado

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

### Actividad

Registrar:

```text
Punto de montaje:

Sistema de ficheros:

Tamaño total:

Espacio disponible:

Porcentaje utilizado:

Resultado:
```

## Sesión 21: detener y recuperar Node Exporter

### Objetivo

Observar cómo cambia el estado del target cuando el servicio se detiene.

Esta tarea debe realizarse únicamente en una máquina de laboratorio autorizada.

### Comprobar el estado inicial

```bash
sudo systemctl is-active node_exporter
```

Comprobar desde Prometheus:

```promql
up{job="node_exporter"}
```

El valor esperado es:

```text
1
```

### Crear una anotación

```text
Título:
Inicio de prueba de Node Exporter

Descripción:
Se detendrá temporalmente Node Exporter
para observar el estado del target en Prometheus.
```

### Detener el servicio

```bash
sudo systemctl stop node_exporter
```

### Comprobar el endpoint

```bash
curl -I http://localhost:9100/metrics
```

El endpoint debería dejar de responder correctamente.

### Comprobar Prometheus

Revisar:

```text
http://localhost:9090/targets
```

Consultar:

```promql
up{job="node_exporter"}
```

El valor esperado será:

```text
0
```

### Registrar

```text
Hora de detención:

Estado del servicio:

Respuesta HTTP:

Estado del target:

Valor de up:

Mensaje de error:

Resultado:
```

### Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

Comprobar:

```bash
sudo systemctl is-active node_exporter
```

Consultar nuevamente:

```promql
up{job="node_exporter"}
```

El valor esperado será:

```text
1
```

### Registrar la recuperación

```text
Hora de recuperación:

Estado del servicio:

Estado del target:

Valor de up:

Tiempo hasta la recuperación:

Resultado:
```

## Sesión 22: simular un error de puerto

### Objetivo

Comprender cómo afecta un puerto incorrecto al estado del target.

Esta tarea debe realizarse con cuidado y solo en el entorno de laboratorio.

### Escenario

Node Exporter escucha en:

```text
server-01:9100
```

Prometheus está configurado temporalmente con:

```text
server-01:9191
```

### Actividad

1. Registrar la configuración original.
2. Cambiar el puerto únicamente en el laboratorio.
3. Validar la configuración.
4. Recargar Prometheus.
5. Revisar el estado del target.
6. Registrar el error.
7. Restaurar el puerto correcto.
8. Recargar Prometheus.
9. Confirmar la recuperación.

### Registro

```text
Target original:

Puerto incorrecto:

Estado observado:

Último error:

Corrección aplicada:

Estado final:

Resultado:
```

### Limpieza obligatoria

Restaurar el target correcto:

```yaml
targets:
  - "server-01:9100"
```

Comprobar que el target vuelva a:

```text
UP
```

## Sesión 23: diagnosticar un target `DOWN`

### Situación

```text
Prometheus muestra el target de Node Exporter como DOWN.
```

### Procedimiento

#### Comprobar el servicio

```bash
sudo systemctl status node_exporter
```

#### Comprobar el proceso

```bash
ps aux | grep '[n]ode_exporter'
```

#### Comprobar el puerto

```bash
ss -lntp | grep ':9100'
```

#### Probar localmente

```bash
curl -I http://localhost:9100/metrics
```

#### Probar remotamente

```bash
curl -I http://DIRECCION_NODE_EXPORTER:9100/metrics
```

#### Revisar la configuración de Prometheus

```bash
grep -A10 -B2 'node_exporter' /etc/prometheus/prometheus.yml
```

#### Revisar los logs de Prometheus

```bash
sudo journalctl -u prometheus --no-pager -n 50
```

### Posibles errores

| Error | Posible causa |
|---|---|
| `connection refused` | Servicio detenido o puerto incorrecto |
| `connection timed out` | Firewall o problema de red |
| `no such host` | Error de DNS o nombre |
| `404 Not Found` | Ruta del endpoint incorrecta |
| `context deadline exceeded` | Endpoint lento o inaccesible |
| `server returned HTTP status 500` | Error en el endpoint |

### Registro

```text
Target:

Estado:

Último error:

Servicio:

Puerto:

Prueba local:

Prueba remota:

Causa:

Corrección:

Resultado:
```

## Sesión 24: diagnosticar un puerto ocupado

### Situación

El servicio no inicia y los logs muestran:

```text
address already in use
```

### Comprobar el proceso que utiliza el puerto

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

También:

```bash
sudo ss -lntp | grep ':9100'
```

### Actividad

1. Identificar el proceso.
2. Determinar si pertenece a Node Exporter.
3. Comprobar si existe una segunda instancia.
4. No detener procesos desconocidos.
5. Consultar al instructor si es necesario.
6. Registrar la solución.

### Registro

```text
Puerto:

Proceso:

PID:

Servicio relacionado:

Causa:

Acción autorizada:

Resultado:
```

## Sesión 25: diagnosticar un problema de permisos

### Situación

El servicio no puede iniciar o no puede acceder a un recurso.

### Revisar el estado

```bash
sudo systemctl status node_exporter
```

### Revisar logs

```bash
sudo journalctl -u node_exporter --no-pager -n 50
```

### Revisar el fichero de unidad

```bash
systemctl cat node_exporter
```

### Revisar permisos del binario

```bash
ls -l /opt/node_exporter/node_exporter
```

### Revisar el usuario

```bash
id node_exporter
```

### Registro

```text
Recurso:

Usuario:

Permisos actuales:

Error:

Permisos esperados:

Corrección:

Resultado:
```

No se deben conceder permisos excesivos para resolver un error sin analizar antes la causa.

## Sesión 26: revisar el rendimiento básico

### Objetivo

Observar el impacto básico de Node Exporter.

Consultar el proceso:

```bash
ps -o pid,ppid,user,%cpu,%mem,etime,cmd \
  -C node_exporter
```

Consultar con `top`:

```bash
top -p "$(pgrep -o node_exporter)"
```

Consultar el tamaño de la respuesta:

```bash
curl -s http://localhost:9100/metrics | wc -c
```

### Registro

```text
PID:

CPU utilizada:

Memoria utilizada:

Tiempo activo:

Tamaño aproximado de /metrics:

Observaciones:
```

La finalidad es observar el servicio, no realizar una prueba de carga.

## Sesión 27: guardar evidencias

### Objetivo

Preparar evidencias de la instalación y validación.

### Capturas recomendadas

```text
01-servicio-node-exporter.png
02-version-node-exporter.png
03-puerto-9100.png
04-endpoint-metrics.png
05-target-up.png
06-consulta-up.png
07-consulta-cpu.png
08-consulta-memoria.png
09-consulta-filesystem.png
10-target-down.png
11-target-recuperado.png
12-logs-node-exporter.png
```

### Ficheros recomendados

```text
metrics-muestra.txt
registro-practica-2.txt
diagnostico-target.md
configuracion-target.yml
```

### Revisión de seguridad

No incluir:

- Contraseñas.
- Tokens.
- Claves privadas.
- Credenciales.
- Direcciones sensibles innecesarias.
- Configuraciones de producción.
- Información personal no necesaria.

## Sesión 28: completar el informe

### Objetivo

Documentar las tareas realizadas y los resultados obtenidos.

### Plantilla

```markdown
# Informe - Práctica 2

## Identificación

Alumno:

Grupo:

Fecha:

Servidor:

Entorno:

## Objetivo

Validar o instalar Node Exporter y comprobar
la recopilación de métricas mediante Prometheus.

## Sistema

Sistema operativo:

Versión:

Arquitectura:

Nombre del host:

Dirección IP:

## Node Exporter

Versión:

Ruta del binario:

Nombre del servicio:

Puerto:

Endpoint:

Estado inicial:

Estado final:

## Métricas verificadas

- node_cpu_seconds_total
- node_memory_MemTotal_bytes
- node_memory_MemAvailable_bytes
- node_filesystem_size_bytes
- node_filesystem_avail_bytes

## Prometheus

Job:

Instance:

Estado del target:

Último scrape:

Último error:

## Pruebas

### Consulta local del endpoint

Comando:

Resultado:

### Consulta desde Prometheus

Consulta:

Resultado:

### Prueba de parada

Acción:

Estado observado:

Recuperación:

Resultado:

## Problemas encontrados

Problema:

Causa:

Corrección:

Resultado:

## Evidencias

Listado de capturas y ficheros.

## Conclusiones

Descripción de lo aprendido y mejoras propuestas.
```

## Ejemplo completo de validación

### Estado del servicio

```bash
$ sudo systemctl is-active node_exporter
active
```

### Puerto

```bash
$ ss -lntp | grep ':9100'
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=1234,fd=3))
```

### Endpoint

```bash
$ curl -I http://localhost:9100/metrics
HTTP/1.1 200 OK
```

### Consulta de Prometheus

```promql
up{job="node_exporter"}
```

Resultado:

```text
up{
  instance="server-01:9100",
  job="node_exporter"
} 1
```

### Interpretación

```text
Node Exporter está activo.

El puerto 9100 está escuchando.

El endpoint /metrics responde.

Prometheus puede consultar el target.

La métrica up tiene el valor 1.

El servidor está preparado para las siguientes prácticas.
```

## Ejemplo de diagnóstico

### Situación

Prometheus muestra:

```text
State: DOWN
Last error: connection refused
```

### Investigación

Comprobar el servicio:

```bash
sudo systemctl is-active node_exporter
```

Resultado:

```text
inactive
```

Revisar el servicio:

```bash
sudo systemctl status node_exporter
```

Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

Comprobar:

```bash
sudo systemctl is-active node_exporter
```

Resultado:

```text
active
```

Volver a Prometheus y comprobar:

```text
State: UP
```

### Conclusión documentada

```text
El target aparecía como DOWN porque Node Exporter estaba detenido.
El servicio se inició en el entorno de laboratorio y Prometheus
volvió a recopilar métricas correctamente.
```

## Criterios de aceptación

La práctica se considera completada cuando:

- La máquina de laboratorio está identificada.
- Node Exporter está instalado o validado.
- El servicio está activo.
- El puerto está documentado.
- El endpoint `/metrics` responde.
- Las métricas principales están disponibles.
- Prometheus tiene configurado el target.
- El target aparece como `UP`.
- La consulta `up` devuelve el valor esperado.
- Se han consultado métricas de CPU.
- Se han consultado métricas de memoria.
- Se han consultado métricas de almacenamiento.
- Se ha realizado al menos una prueba de diagnóstico.
- Se ha comprobado la recuperación del servicio.
- Las evidencias están organizadas.
- No se han expuesto credenciales.
- El informe está completo.
- El entorno se ha dejado en un estado estable.

## Puntos clave

- Node Exporter expone métricas del sistema mediante HTTP.
- El endpoint habitual es `/metrics`.
- El puerto habitual es `9100`.
- Prometheus realiza scrapes periódicos contra Node Exporter.
- El estado `UP` indica que el target responde correctamente.
- El estado `DOWN` indica un problema de recopilación.
- La métrica `up` permite consultar la disponibilidad desde PromQL.
- Las etiquetas `job` e `instance` identifican el origen de una métrica.
- Node Exporter no sustituye a Prometheus.
- Prometheus no sustituye a Grafana.
- El servicio debe comprobarse antes de investigar Prometheus.
- La conectividad debe probarse desde el servidor de Prometheus.
- Un puerto incorrecto puede provocar un target `DOWN`.
- Un firewall puede impedir el acceso al endpoint.
- Los logs ayudan a identificar errores de inicio y ejecución.
- El servicio debe ejecutarse con un usuario adecuado.
- No se deben conceder permisos excesivos.
- Las pruebas de parada deben realizarse solo en laboratorio.
- La recuperación debe comprobarse después de cada prueba.
- La documentación debe incluir versión, puerto, target y resultado.

## Preguntas de comprobación

1. ¿Qué función cumple Node Exporter?
2. ¿Qué diferencia existe entre Node Exporter y Prometheus?
3. ¿Qué diferencia existe entre Prometheus y Grafana?
4. ¿Cuál es el endpoint habitual de Node Exporter?
5. ¿Cuál es el puerto habitual de Node Exporter?
6. ¿Qué significa que un target esté en estado `UP`?
7. ¿Qué significa que un target esté en estado `DOWN`?
8. ¿Qué representa la métrica `up`?
9. ¿Qué información proporciona la etiqueta `job`?
10. ¿Qué información proporciona la etiqueta `instance`?
11. ¿Cómo comprobarías si el servicio está activo?
12. ¿Cómo comprobarías si el puerto 9100 está escuchando?
13. ¿Cómo comprobarías que `/metrics` responde?
14. ¿Qué revisarías si aparece `connection refused`?
15. ¿Qué revisarías si aparece `connection timed out`?
16. ¿Qué puede provocar un error `no such host`?
17. ¿Cómo comprobarías que Prometheus recopila métricas?
18. ¿Por qué es importante validar la configuración antes de recargar Prometheus?
19. ¿Qué riesgos tiene detener Node Exporter en un sistema no autorizado?
20. ¿Qué evidencias deben incluirse en la entrega?
21. ¿Por qué debe utilizarse un usuario de servicio?
22. ¿Qué información debe contener el informe de esta práctica?
23. ¿Cómo comprobarías que Node Exporter se inicia automáticamente?
24. ¿Qué pasos seguirías para diagnosticar un target `DOWN`?
25. ¿Qué resultado demostraría que la práctica se ha completado correctamente?

## Resultado esperado

Al finalizar la práctica, el alumno deberá disponer de un Node Exporter operativo y validado.

El flujo completado será:

```text
Identificar el servidor
        |
        v
Comprobar el sistema operativo
        |
        v
Comprobar Node Exporter
        |
        v
Comprobar el puerto 9100
        |
        v
Consultar /metrics
        |
        v
Identificar métricas
        |
        v
Configurar el servicio
        |
        v
Configurar Prometheus
        |
        v
Comprobar el target
        |
        v
Ejecutar consultas PromQL
        |
        v
Probar un fallo controlado
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
Qué es Node Exporter.

Qué métricas expone.

En qué puerto escucha.

Cómo lo consulta Prometheus.

Qué significa el estado UP.

Qué significa el estado DOWN.

Cómo se diagnostica un error.

Cómo se comprueba la recuperación.
```

Node Exporter será la base de las siguientes prácticas. Una vez que el agente expone métricas y Prometheus puede recopilarlas, será posible construir consultas más completas, crear dashboards operativos y definir alertas sobre CPU, memoria, almacenamiento y disponibilidad.