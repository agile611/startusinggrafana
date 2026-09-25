# Problemas con Node Exporter

Esta página explica cómo diagnosticar y resolver los problemas más habituales de Node Exporter en un entorno Linux con Prometheus y Grafana.

Node Exporter expone métricas del sistema operativo para que Prometheus pueda recopilarlas. Cuando deja de funcionar, Prometheus suele mostrar el target como `DOWN` y las consultas de Grafana pueden quedarse sin datos.

El flujo de monitorización es:

```text
Sistema operativo
        |
        v
Node Exporter
        |
        | HTTP :9100/metrics
        v
Prometheus
        |
        | PromQL
        v
Grafana
```

Un problema puede aparecer en cualquiera de estos puntos:

- El binario no está instalado.
- La arquitectura del binario es incorrecta.
- El servicio no existe.
- El servicio está detenido.
- El puerto `9100` está ocupado.
- El endpoint `/metrics` no responde.
- El firewall bloquea el acceso.
- El usuario del servicio no tiene permisos.
- Prometheus apunta a una dirección incorrecta.
- El target aparece como `DOWN`.
- Las métricas no se exponen como se esperaba.
- El sistema tiene poco espacio o poca memoria.

> **Advertencia:** realiza las prácticas en una máquina virtual o en un entorno de laboratorio. Antes de modificar la unidad de `systemd`, crea una copia de seguridad y documenta el estado inicial.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Explicar la función de Node Exporter.
- Comprobar si Node Exporter está instalado.
- Consultar la versión del binario.
- Comprobar la arquitectura del sistema.
- Verificar el estado del servicio.
- Consultar los registros de `systemd`.
- Comprobar el puerto `9100`.
- Probar el endpoint `/metrics`.
- Diagnosticar problemas de permisos.
- Diagnosticar problemas de usuario y grupo.
- Identificar errores de arquitectura.
- Detectar conflictos de puertos.
- Comprobar la conectividad desde Prometheus.
- Diagnosticar un target `DOWN`.
- Comprobar la configuración de collectors.
- Validar la recuperación del servicio.
- Documentar una incidencia técnica.

## Introducción

Node Exporter es un exporter que expone métricas relacionadas con el sistema operativo.

Entre las métricas más habituales se encuentran:

```text
node_cpu_seconds_total
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes
node_filesystem_size_bytes
node_filesystem_avail_bytes
node_network_receive_bytes_total
node_network_transmit_bytes_total
node_load1
node_uname_info
```

Node Exporter no almacena las métricas. Su función es exponerlas mediante HTTP. Prometheus se encarga de consultarlas y almacenarlas.

La dirección habitual del endpoint es:

```text
http://localhost:9100/metrics
```

Una configuración típica de Prometheus contiene:

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

Si Node Exporter no responde, Prometheus no podrá recopilar las métricas.

## Funcionamiento de Node Exporter

### Proceso de exposición

Node Exporter realiza las siguientes tareas:

1. Lee información del sistema operativo.
2. Activa los collectors configurados.
3. Convierte la información en métricas Prometheus.
4. Escucha peticiones HTTP.
5. Devuelve las métricas en `/metrics`.

### Puerto habitual

El puerto por defecto es:

```text
9100/tcp
```

### Endpoint principal

```text
http://localhost:9100/metrics
```

### Comprobación básica

```bash
curl -I http://localhost:9100/metrics
```

Consultar las primeras métricas:

```bash
curl -s http://localhost:9100/metrics | head
```

Consultar métricas de CPU:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_cpu_" \
  | head
```

Consultar métricas de memoria:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_memory_" \
  | head
```

Consultar métricas de sistemas de archivos:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_filesystem_" \
  | head
```

## Identificar el método de instalación

El diagnóstico depende de cómo se haya instalado Node Exporter.

### Instalación mediante paquete

Comprueba los paquetes instalados:

```bash
dpkg -l | grep -E \
  "node-exporter|node_exporter"
```

Consulta la política del paquete:

```bash
apt policy prometheus-node-exporter
```

El nombre del paquete puede variar según la distribución.

### Instalación mediante binario

Busca el ejecutable:

```bash
command -v node_exporter
```

Busca en rutas habituales:

```bash
sudo find /usr /opt /usr/local \
  -type f \
  -name "node_exporter" \
  -executable \
  2>/dev/null
```

### Instalación mediante contenedor

Consulta los contenedores:

```bash
docker ps -a
```

Filtra por nombre:

```bash
docker ps -a \
  --format "{{.ID}}\t{{.Names}}\t{{.Status}}" \
  | grep -i node
```

Consulta los registros:

```bash
docker logs NOMBRE_DEL_CONTENEDOR
```

### Comprobar el servicio utilizado

El nombre habitual es:

```text
node_exporter
```

Pero algunas distribuciones utilizan:

```text
prometheus-node-exporter
```

Comprueba las unidades disponibles:

```bash
systemctl list-unit-files \
  | grep -E \
  "node_exporter|node-exporter|prometheus-node-exporter"
```

También:

```bash
systemctl list-units \
  --all \
  | grep -E \
  "node_exporter|node-exporter|prometheus-node-exporter"
```

## Comprobar la instalación

### Localizar el ejecutable

```bash
command -v node_exporter
```

Si no aparece ninguna ruta, prueba:

```bash
sudo find / -type f \
  -name "node_exporter" \
  -executable \
  2>/dev/null
```

### Consultar la versión

```bash
node_exporter --version
```

Si el binario está en otra ruta:

```bash
/usr/local/bin/node_exporter --version
```

### Consultar el tipo de binario

```bash
file "$(command -v node_exporter)"
```

Una salida posible:

```text
ELF 64-bit LSB pie executable, x86-64
```

### Consultar la arquitectura del sistema

```bash
uname -m
```

Resultados habituales:

```text
x86_64
```

```text
aarch64
```

### Comparar arquitecturas

El binario y el sistema deben ser compatibles.

Ejemplo:

```text
Sistema: x86_64
Binario: x86-64
Resultado: compatible
```

Ejemplo de problema:

```text
Sistema: aarch64
Binario: x86-64
Resultado: incompatible
```

## Comprobar el servicio

### Consultar el estado

Si el servicio se llama `node_exporter`:

```bash
systemctl status node_exporter
```

Si se llama `prometheus-node-exporter`:

```bash
systemctl status prometheus-node-exporter
```

### Comprobar si está activo

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
active
```

### Comprobar si se inicia automáticamente

```bash
systemctl is-enabled node_exporter
```

Resultado esperado:

```text
enabled
```

### Iniciar Node Exporter

```bash
sudo systemctl start node_exporter
```

### Reiniciar Node Exporter

```bash
sudo systemctl restart node_exporter
```

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Activar el inicio automático

```bash
sudo systemctl enable node_exporter
```

Activar e iniciar simultáneamente:

```bash
sudo systemctl enable --now node_exporter
```

### Recargar las unidades de `systemd`

Si se ha creado o modificado una unidad:

```bash
sudo systemctl daemon-reload
```

Después:

```bash
sudo systemctl restart node_exporter
```

## Consultar la unidad de systemd

### Mostrar la unidad

```bash
systemctl cat node_exporter
```

### Consultar la ruta de la unidad

```bash
systemctl show node_exporter \
  -p FragmentPath
```

### Consultar el comando de inicio

```bash
systemctl show node_exporter \
  -p ExecStart
```

### Consultar el usuario y el grupo

```bash
systemctl show node_exporter \
  -p User \
  -p Group
```

### Consultar todas las propiedades importantes

```bash
systemctl show node_exporter \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath \
  -p WorkingDirectory \
  -p Restart
```

### Ejemplo de unidad

Una unidad de ejemplo puede tener esta estructura:

```ini
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

La ubicación real puede variar:

```text
/etc/systemd/system/node_exporter.service
```

```text
/lib/systemd/system/node_exporter.service
```

```text
/usr/lib/systemd/system/node_exporter.service
```

## Consultar los registros

### Últimas líneas

```bash
sudo journalctl -u node_exporter \
  -n 50 \
  --no-pager
```

### Registros desde el último arranque

```bash
sudo journalctl -u node_exporter \
  -b \
  --no-pager
```

### Seguir los registros en tiempo real

```bash
sudo journalctl -u node_exporter -f
```

Detener la salida:

```text
Ctrl + C
```

### Consultar únicamente errores

```bash
sudo journalctl -u node_exporter \
  -p err \
  --since "30 minutes ago" \
  --no-pager
```

### Buscar mensajes relevantes

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  | grep -i -E \
  "error|failed|fatal|permission|denied|address|listen"
```

### Consultar los registros del último arranque

```bash
sudo journalctl -u node_exporter \
  --since "today" \
  --no-pager
```

## Comprobar el puerto 9100

### Utilizar `ss`

```bash
sudo ss -lntp | grep ':9100'
```

Una salida correcta puede ser:

```text
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=1234,fd=3))
```

### Utilizar `lsof`

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

### Utilizar `fuser`

```bash
sudo fuser -v 9100/tcp
```

### Identificar el proceso

Si el PID es `1234`:

```bash
ps -fp 1234
```

Consultar el comando completo:

```bash
sudo tr '\0' ' ' < /proc/1234/cmdline
echo
```

### Interpretar la dirección de escucha

#### `127.0.0.1:9100`

Node Exporter solo acepta conexiones locales:

```text
127.0.0.1:9100
```

Prometheus debe ejecutarse en el mismo equipo para acceder directamente.

#### `0.0.0.0:9100`

Node Exporter acepta conexiones IPv4 en las interfaces disponibles:

```text
0.0.0.0:9100
```

El firewall debe seguir limitando los orígenes permitidos.

#### `[::]:9100`

Node Exporter escucha mediante IPv6:

```text
[::]:9100
```

La accesibilidad dependerá de la configuración IPv6 y del firewall.

## Probar el endpoint `/metrics`

### Comprobar las cabeceras

```bash
curl -I http://localhost:9100/metrics
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

### Consultar el endpoint completo

```bash
curl -v http://localhost:9100/metrics
```

### Consultar solo las primeras líneas

```bash
curl -s http://localhost:9100/metrics \
  | head -20
```

### Comprobar el código HTTP

```bash
curl -s -o /dev/null \
  -w "Código HTTP: %{http_code}\n" \
  http://localhost:9100/metrics
```

### Buscar una métrica concreta

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_load1 "
```

### Consultar la información del sistema

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_uname_info"
```

### Consultar las métricas expuestas

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_" \
  | cut -d' ' -f1 \
  | sed 's/{.*//' \
  | sort -u \
  | head -50
```

## Problemas de conexión local

### El endpoint devuelve `Connection refused`

Comprueba:

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
sudo journalctl -u node_exporter \
  -n 100 \
  --no-pager
```

Posibles causas:

- El servicio está detenido.
- Node Exporter no está instalado.
- El puerto configurado no es `9100`.
- El proceso se ha detenido.
- Existe un error en los parámetros de inicio.

### El endpoint devuelve `Connection timed out`

Comprueba:

```bash
sudo ss -lntp | grep ':9100'
```

```bash
sudo ufw status verbose
```

Si la petición se realiza desde otro equipo:

```bash
nc -vz DIRECCION_IP_NODE_EXPORTER 9100
```

Posibles causas:

- Firewall.
- Ruta de red incorrecta.
- Dirección IP incorrecta.
- Node Exporter escucha solo en `localhost`.
- El equipo no está disponible.

### El endpoint devuelve `404 Not Found`

Comprueba que se utiliza la ruta correcta:

```text
/metrics
```

Consulta:

```bash
curl -I http://localhost:9100/metrics
```

No utilices una ruta incorrecta como:

```text
/node_exporter
```

### El endpoint devuelve contenido vacío

Comprueba:

```bash
curl -s http://localhost:9100/metrics | wc -l
```

Consulta los registros:

```bash
sudo journalctl -u node_exporter \
  -n 100 \
  --no-pager
```

Revisa los collectors habilitados y deshabilitados.

## Problemas de permisos

### Consultar el usuario del servicio

```bash
systemctl show node_exporter \
  -p User \
  -p Group
```

### Comprobar si el usuario existe

```bash
getent passwd node_exporter
```

```bash
getent group node_exporter
```

### Comprobar permisos del binario

```bash
ls -l /usr/local/bin/node_exporter
```

### Comprobar si es ejecutable

```bash
test -x /usr/local/bin/node_exporter \
  && echo "El binario es ejecutable" \
  || echo "El binario no es ejecutable"
```

### Dar permiso de ejecución

Solo si corresponde:

```bash
sudo chmod 755 /usr/local/bin/node_exporter
```

### Comprobar ejecución como usuario del servicio

```bash
sudo -u node_exporter \
  /usr/local/bin/node_exporter \
  --version
```

### Error `Permission denied`

Comprueba:

```bash
ls -l /usr/local/bin/node_exporter
```

```bash
namei -l /usr/local/bin/node_exporter
```

Posibles causas:

- Falta el permiso de ejecución.
- Algún directorio de la ruta no permite el acceso.
- El sistema de archivos está montado con `noexec`.
- El usuario no puede acceder al binario.
- Existe una política de seguridad que bloquea la ejecución.

### Comprobar si el sistema de archivos utiliza `noexec`

```bash
findmnt -no TARGET,OPTIONS \
  /usr/local/bin
```

## Problemas de usuario y grupo

### Crear un usuario de sistema

Solo si la instalación lo requiere:

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

### Comprobar el usuario

```bash
id node_exporter
```

### Consultar la unidad

```bash
systemctl cat node_exporter
```

Comprueba que estas líneas correspondan a un usuario existente:

```ini
User=node_exporter
Group=node_exporter
```

### Error de usuario inexistente

Un mensaje como:

```text
Failed at step USER spawning
```

puede indicar que el usuario definido en la unidad no existe.

Comprueba:

```bash
getent passwd node_exporter
```

Si no existe, revisa el procedimiento de instalación antes de crearlo manualmente.

### Probar el servicio con el usuario configurado

```bash
sudo -u node_exporter \
  /usr/local/bin/node_exporter
```

Detén el proceso con:

```text
Ctrl + C
```

## Problemas de arquitectura

### Consultar la arquitectura del sistema

```bash
uname -m
```

### Consultar la arquitectura del binario

```bash
file /usr/local/bin/node_exporter
```

### Error `Exec format error`

Este error suele indicar que el binario no es compatible con la arquitectura del sistema.

Comprueba:

```bash
uname -m
```

```bash
file /usr/local/bin/node_exporter
```

### Ejemplos de correspondencia

| Sistema | Binario compatible habitual |
|---|---|
| `x86_64` | `linux-amd64` |
| `aarch64` | `linux-arm64` |
| `armv7l` | `linux-armv7` |

Consulta siempre los nombres exactos publicados por la versión utilizada.

## Problemas de descargas

### Comprobar el fichero descargado

```bash
file node_exporter.tar.gz
```

### Comprobar el tamaño

```bash
ls -lh node_exporter.tar.gz
```

### Consultar el contenido antes de extraer

```bash
tar -tzf node_exporter.tar.gz
```

### Comprobar la suma SHA-256

```bash
sha256sum node_exporter.tar.gz
```

Compara el resultado con la suma publicada por el proyecto.

### Error: no es un archivo gzip

Si aparece:

```text
gzip: stdin: not in gzip format
```

comprueba:

```bash
file node_exporter.tar.gz
```

Si muestra:

```text
HTML document
```

se ha descargado probablemente una página web o un mensaje de error.

### Descargar mediante `curl`

```bash
curl -fL \
  -o node_exporter.tar.gz \
  URL_DEL_ARCHIVO
```

Después:

```bash
file node_exporter.tar.gz
```

```bash
tar -tzf node_exporter.tar.gz
```

## Problemas de configuración del servicio

### Consultar los argumentos de inicio

```bash
systemctl show node_exporter \
  -p ExecStart
```

### Parámetros habituales

Algunos parámetros frecuentes son:

```text
--web.listen-address=:9100
--web.telemetry-path=/metrics
--collector.systemd
--collector.processes
--no-collector.wifi
```

La disponibilidad de collectors y opciones depende de la versión instalada.

### Cambiar la dirección de escucha

Ejemplo:

```text
--web.listen-address=0.0.0.0:9100
```

### Cambiar el endpoint de métricas

Ejemplo:

```text
--web.telemetry-path=/metrics
```

Si se modifica esta ruta, Prometheus debe utilizar la misma ruta mediante la configuración de scraping.

### Consultar la ayuda

```bash
node_exporter --help
```

Si está instalado en otra ruta:

```bash
/usr/local/bin/node_exporter --help
```

### Validar una unidad de systemd

```bash
systemd-analyze verify \
  /etc/systemd/system/node_exporter.service
```

### Recargar y reiniciar

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl restart node_exporter
```

### Comprobar el resultado

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

## Problemas con collectors

Los collectors son componentes que recopilan grupos concretos de métricas.

### Consultar collectors en la ayuda

```bash
node_exporter --help \
  | grep -E \
  "collector|disable"
```

### Buscar collectors en las métricas

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_scrape_collector"
```

### Comprobar métricas del sistema de archivos

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_filesystem_" \
  | head
```

### Comprobar métricas de red

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_network_" \
  | head
```

### Comprobar métricas de systemd

Si el collector está habilitado:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_systemd_" \
  | head
```

### Problemas habituales

- El collector no está habilitado.
- El collector no es compatible con la versión.
- El usuario no tiene permisos para leer la información.
- El sistema no dispone del recurso consultado.
- El nombre de la métrica no coincide con el esperado.
- El collector genera errores durante el scraping.

### Consultar errores del exporter

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  | grep -i collector
```

## Problemas de firewall

### Consultar UFW

```bash
sudo ufw status verbose
```

### Permitir Node Exporter desde Prometheus

Sustituye la dirección por la del servidor Prometheus:

```bash
sudo ufw allow from DIRECCION_IP_PROMETHEUS \
  to any port 9100 \
  proto tcp
```

### Consultar las reglas

```bash
sudo ufw status numbered
```

### Comprobar desde Prometheus

```bash
curl -I \
  http://DIRECCION_IP_NODE_EXPORTER:9100/metrics
```

### No abrir el puerto globalmente sin necesidad

Evita utilizar como primera opción:

```bash
sudo ufw allow 9100/tcp
```

Es preferible permitir únicamente el origen necesario.

## Problemas de red y DNS

### Consultar interfaces

```bash
ip -br addr
```

### Consultar rutas

```bash
ip route
```

### Probar conectividad

```bash
ping -c 4 DIRECCION_IP_NODE_EXPORTER
```

### Probar resolución DNS

```bash
getent hosts node-exporter.ejemplo.local
```

```bash
resolvectl query node-exporter.ejemplo.local
```

### Probar por nombre

```bash
curl -I \
  http://node-exporter.ejemplo.local:9100/metrics
```

### Probar por IP

```bash
curl -I \
  http://192.168.1.50:9100/metrics
```

Si funciona por IP, pero no por nombre, revisa:

- DNS.
- `/etc/hosts`.
- El nombre del target.
- La configuración de red.
- La resolución desde el servidor Prometheus.

## Configuración de Prometheus para Node Exporter

### Configuración local

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

### Configuración mediante IP

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - 192.168.1.50:9100
```

### Configuración mediante nombre DNS

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - node-exporter.ejemplo.local:9100
```

### Configuración con etiquetas

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - 192.168.1.50:9100
        labels:
          entorno: laboratorio
          ubicacion: aula-01
```

Consulta:

```promql
up{
  entorno="laboratorio"
}
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Comprobar el target

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

## Diagnosticar un target `DOWN`

### Consultar el estado

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[] | {
      job: .labels.job,
      instance: .labels.instance,
      health: .health,
      lastError: .lastError,
      lastScrape: .lastScrape
    }'
```

### Comprobar la consulta `up`

```promql
up{job="node_exporter"}
```

### Comprobar el servicio en el target

```bash
systemctl is-active node_exporter
```

### Comprobar el puerto en el target

```bash
sudo ss -lntp | grep ':9100'
```

### Probar desde el servidor Prometheus

```bash
curl -I \
  http://DIRECCION_IP_NODE_EXPORTER:9100/metrics
```

### Revisar el error mostrado por Prometheus

El campo `lastError` puede mostrar mensajes como:

```text
connection refused
```

```text
context deadline exceeded
```

```text
no route to host
```

```text
server returned HTTP status 404
```

### Interpretación de errores

| Error | Posible causa |
|---|---|
| `connection refused` | Servicio detenido o puerto incorrecto |
| `context deadline exceeded` | Firewall, red lenta o servicio bloqueado |
| `no route to host` | Ruta de red inexistente |
| `server returned 404` | Ruta de métricas incorrecta |
| `could not resolve host` | Problema DNS |
| `permission denied` | Permisos del proceso o del sistema |

## Consultas PromQL para validar Node Exporter

### Comprobar disponibilidad

```promql
up{job="node_exporter"}
```

### Consultar la carga del sistema

```promql
node_load1{
  job="node_exporter"
}
```

### Consultar memoria total

```promql
node_memory_MemTotal_bytes{
  job="node_exporter"
}
```

### Consultar memoria disponible

```promql
node_memory_MemAvailable_bytes{
  job="node_exporter"
}
```

### Calcular porcentaje de memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    job="node_exporter"
  }
  /
  node_memory_MemTotal_bytes{
    job="node_exporter"
  }
)
```

### Consultar CPU en modo idle

```promql
rate(
  node_cpu_seconds_total{
    job="node_exporter",
    mode="idle"
  }[5m]
)
```

### Calcular uso de CPU

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        job="node_exporter",
        mode="idle"
      }[5m]
    )
  )
)
```

### Consultar el tamaño del sistema de archivos

```promql
node_filesystem_size_bytes{
  job="node_exporter",
  mountpoint="/"
}
```

### Calcular porcentaje utilizado de `/`

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    job="node_exporter",
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    job="node_exporter",
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

## Sesión práctica 1: inventario inicial

### Objetivo

Recopilar información del sistema y de Node Exporter antes de modificar nada.

### Crear el directorio de trabajo

```bash
mkdir -p ~/laboratorio/problemas-node-exporter
cd ~/laboratorio/problemas-node-exporter
```

### Generar un inventario

```bash
{
  echo "===== INVENTARIO DE NODE EXPORTER ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== SISTEMA ====="
  lsb_release -ds 2>/dev/null || true
  uname -m
  uname -r
  echo

  echo "===== BINARIO ====="
  command -v node_exporter || true
  node_exporter --version 2>&1 || true
  echo

  echo "===== USUARIO ====="
  getent passwd node_exporter || true
  getent group node_exporter || true
  echo

  echo "===== SERVICIO ====="
  systemctl is-active node_exporter 2>/dev/null || true
  systemctl is-enabled node_exporter 2>/dev/null || true
  echo

  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':9100' || true
  echo

  echo "===== ENDPOINT ====="
  curl -sS -o /dev/null \
    -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
    --max-time 5 \
    http://localhost:9100/metrics \
    || true
  echo

  echo "===== ESPACIO ====="
  df -h
} | tee inventario-node-exporter.txt
```

### Revisar el informe

```bash
less inventario-node-exporter.txt
```

### Preguntas de análisis

- ¿Existe el binario?
- ¿Qué versión está instalada?
- ¿Existe el usuario del servicio?
- ¿Está activo el servicio?
- ¿El puerto `9100` está en escucha?
- ¿El endpoint devuelve un código `200`?
- ¿Hay espacio suficiente?

## Sesión práctica 2: Node Exporter está detenido

### Objetivo

Detectar y recuperar un servicio detenido.

### Comprobar el estado

```bash
systemctl is-active node_exporter
```

### Consultar el estado detallado

```bash
systemctl status node_exporter
```

### Consultar los registros

```bash
sudo journalctl -u node_exporter \
  -n 100 \
  --no-pager
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Iniciar el servicio

```bash
sudo systemctl start node_exporter
```

### Validar

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -I http://localhost:9100/metrics
```

### Comprobar desde Prometheus

```promql
up{job="node_exporter"}
```

### Preguntas de análisis

- ¿Cuál era el estado inicial?
- ¿El servicio se inició correctamente?
- ¿El puerto comenzó a estar en escucha?
- ¿El endpoint devolvió `200 OK`?
- ¿Cuánto tardó Prometheus en mostrar el target como `UP`?

## Sesión práctica 3: diagnosticar un error de arquitectura

### Objetivo

Identificar un binario incompatible con el sistema.

### Consultar la arquitectura

```bash
uname -m
```

### Consultar el binario

```bash
file /usr/local/bin/node_exporter
```

### Intentar consultar la versión

```bash
/usr/local/bin/node_exporter --version
```

### Consultar el registro del servicio

```bash
sudo journalctl -u node_exporter \
  -n 100 \
  --no-pager
```

### Identificar el error

Busca mensajes como:

```text
Exec format error
```

o:

```text
cannot execute binary file
```

### Documentar la comparación

```text
Arquitectura del sistema:

Arquitectura del binario:

Resultado:

Error observado:

Causa probable:
```

### Validación

El binario correcto debe:

```bash
file /usr/local/bin/node_exporter
```

y ejecutarse correctamente:

```bash
/usr/local/bin/node_exporter --version
```

## Sesión práctica 4: resolver un conflicto de puerto

### Objetivo

Identificar qué proceso utiliza el puerto `9100`.

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Identificar el proceso

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

### Consultar el proceso

```bash
ps -fp PID
```

### Comprobar procesos duplicados

```bash
ps aux | grep "[n]ode_exporter"
```

### Comprobar unidades duplicadas

```bash
systemctl list-unit-files \
  | grep -E \
  "node_exporter|node-exporter"
```

### Analizar las opciones

Determina si:

- Existe una segunda instancia.
- Se ha ejecutado Node Exporter manualmente.
- Otra aplicación utiliza el puerto.
- Hay una instalación antigua.
- El servicio utiliza un puerto diferente.

### Recuperar el servicio

Después de resolver el conflicto:

```bash
sudo systemctl restart node_exporter
```

### Validar

```bash
systemctl is-active node_exporter
```

```bash
curl -I http://localhost:9100/metrics
```

## Sesión práctica 5: diagnosticar permisos del binario

### Objetivo

Comprobar cómo los permisos de ejecución afectan al servicio.

> Realiza esta práctica únicamente en una máquina virtual o entorno de laboratorio.

### Consultar los permisos originales

```bash
ls -l /usr/local/bin/node_exporter
```

### Crear una copia del binario

```bash
sudo cp /usr/local/bin/node_exporter \
  /usr/local/bin/node_exporter.bak
```

### Retirar temporalmente el permiso de ejecución

```bash
sudo chmod 644 /usr/local/bin/node_exporter
```

### Reiniciar el servicio

```bash
sudo systemctl restart node_exporter
```

### Consultar el estado

```bash
systemctl status node_exporter
```

### Consultar los registros

```bash
sudo journalctl -u node_exporter \
  -n 50 \
  --no-pager
```

### Restaurar el permiso

```bash
sudo chmod 755 /usr/local/bin/node_exporter
```

### Validar

```bash
sudo systemctl restart node_exporter
```

```bash
systemctl is-active node_exporter
```

```bash
curl -I http://localhost:9100/metrics
```

### Preguntas de análisis

- ¿Qué permiso se eliminó?
- ¿Qué mensaje mostró `systemd`?
- ¿El usuario del servicio podía ejecutar el binario?
- ¿Qué permiso permitió recuperar el servicio?

## Sesión práctica 6: comprobar un target remoto

### Objetivo

Diagnosticar la comunicación entre Prometheus y Node Exporter en equipos diferentes.

### Escenario

Servidor Prometheus:

```text
192.168.1.10
```

Servidor Node Exporter:

```text
192.168.1.20
```

### Probar desde Prometheus

```bash
ping -c 4 192.168.1.20
```

```bash
nc -vz 192.168.1.20 9100
```

```bash
curl -I \
  http://192.168.1.20:9100/metrics
```

### Comprobar Node Exporter en el servidor remoto

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar el firewall remoto

```bash
sudo ufw status verbose
```

Permitir únicamente el servidor Prometheus:

```bash
sudo ufw allow from 192.168.1.10 \
  to any port 9100 \
  proto tcp
```

### Configurar el target

En Prometheus:

```yaml
scrape_configs:
  - job_name: node_exporter_remoto
    static_configs:
      - targets:
          - 192.168.1.20:9100
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Consultar el estado

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Preguntas de análisis

- ¿El servidor Prometheus podía resolver la dirección?
- ¿El puerto `9100` estaba accesible?
- ¿El firewall permitía el origen correcto?
- ¿El target remoto aparece como `UP`?
- ¿Qué diferencia existe entre una prueba local y una prueba desde Prometheus?

## Sesión práctica 7: comprobar collectors

### Objetivo

Identificar qué grupos de métricas están disponibles.

### Consultar métricas de CPU

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_cpu_" \
  | head -20
```

### Consultar métricas de memoria

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_memory_" \
  | head -20
```

### Consultar métricas de red

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_network_" \
  | head -20
```

### Consultar métricas de disco

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_disk_" \
  | head -20
```

### Consultar métricas de filesystem

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_filesystem_" \
  | head -20
```

### Crear un inventario de métricas

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_" \
  | sed 's/{.*//' \
  | sed 's/ .*//' \
  | sort -u \
  | tee metricas-node-exporter.txt
```

### Analizar el resultado

Indica si existen métricas para:

```text
CPU:

Memoria:

Red:

Discos:

Sistemas de archivos:

Carga:

Información del sistema:
```

## Sesión práctica 8: verificar Prometheus después de recuperar Node Exporter

### Objetivo

Observar el ciclo completo de recuperación.

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Consultar el endpoint

```bash
curl -I http://localhost:9100/metrics
```

La petición debería fallar mientras el servicio esté detenido.

### Consultar Prometheus

```promql
up{job="node_exporter"}
```

Después de uno o varios intervalos de scraping, el valor debería cambiar a:

```text
0
```

### Consultar el target

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[] | {
      instance: .labels.instance,
      health: .health,
      lastError: .lastError
    }'
```

### Iniciar Node Exporter

```bash
sudo systemctl start node_exporter
```

### Comprobar el endpoint

```bash
curl -I http://localhost:9100/metrics
```

### Consultar Prometheus de nuevo

```promql
up{job="node_exporter"}
```

El valor debería volver a:

```text
1
```

### Preguntas de análisis

- ¿Cuánto tardó el target en pasar a `DOWN`?
- ¿Qué error apareció en `lastError`?
- ¿Cuánto tardó en recuperarse?
- ¿Qué diferencia hay entre el estado del servicio y el estado del target?
- ¿Qué intervalo de scraping estaba configurado?

## Sesión práctica 9: construir un informe de diagnóstico

### Objetivo

Documentar una incidencia completa de Node Exporter.

### Crear el directorio

```bash
mkdir -p ~/laboratorio/informe-node-exporter
cd ~/laboratorio/informe-node-exporter
```

### Generar el informe

```bash
{
  echo "===== INFORME DE NODE EXPORTER ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== SISTEMA ====="
  lsb_release -ds 2>/dev/null || true
  uname -m
  uname -r
  echo

  echo "===== VERSION ====="
  node_exporter --version 2>&1 || true
  echo

  echo "===== SERVICIO ====="
  systemctl is-active node_exporter 2>/dev/null || true
  systemctl is-enabled node_exporter 2>/dev/null || true
  echo

  echo "===== UNIDAD ====="
  systemctl show node_exporter \
    -p User \
    -p Group \
    -p ExecStart \
    -p FragmentPath
  echo

  echo "===== PROCESO ====="
  ps aux | grep "[n]ode_exporter" || true
  echo

  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':9100' || true
  echo

  echo "===== ENDPOINT ====="
  curl -sS \
    -o /dev/null \
    -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
    --max-time 5 \
    http://localhost:9100/metrics \
    || true
  echo

  echo "===== METRICAS ====="
  curl -sS \
    --max-time 5 \
    http://localhost:9100/metrics \
    | grep -E "^node_(cpu|memory|load|filesystem)_" \
    | head -20 \
    || true
  echo

  echo "===== ESPACIO ====="
  df -h
  echo

  echo "===== REGISTROS ====="
  sudo journalctl -u node_exporter \
    -n 50 \
    --no-pager
} | tee informe-node-exporter.txt
```

### Revisar el informe

```bash
less informe-node-exporter.txt
```

## Diagnóstico automatizado

### Crear un script

```bash
nano diagnostico-node-exporter.sh
```

Contenido:

```bash
#!/usr/bin/env bash

set -u

echo "===== DIAGNÓSTICO DE NODE EXPORTER ====="
echo "Fecha: $(date)"
echo "Equipo: $(hostname)"
echo

echo "===== SISTEMA ====="
uname -m
uname -r
echo

echo "===== BINARIO ====="
command -v node_exporter || true
node_exporter --version 2>&1 || true
echo

echo "===== USUARIO ====="
getent passwd node_exporter || true
getent group node_exporter || true
echo

echo "===== SERVICIO ====="
systemctl is-active node_exporter 2>/dev/null || true
systemctl is-enabled node_exporter 2>/dev/null || true
echo

echo "===== PROCESO ====="
ps aux | grep "[n]ode_exporter" || true
echo

echo "===== PUERTO 9100 ====="
sudo ss -lntp | grep ':9100' || true
echo

echo "===== ENDPOINT ====="
curl -sS -o /dev/null \
  -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
  --max-time 5 \
  http://localhost:9100/metrics \
  || true
echo

echo "===== METRICAS ====="
curl -sS \
  --max-time 5 \
  http://localhost:9100/metrics \
  | grep "^node_" \
  | head -20 \
  || true
echo

echo "===== ESPACIO ====="
df -h
echo

echo "===== REGISTROS ====="
sudo journalctl -u node_exporter \
  -n 30 \
  --no-pager \
  2>/dev/null || true
```

### Conceder permisos

```bash
chmod +x diagnostico-node-exporter.sh
```

### Ejecutar el script

```bash
./diagnostico-node-exporter.sh
```

### Guardar la salida

```bash
./diagnostico-node-exporter.sh \
  | tee diagnostico-node-exporter.txt
```

## Lista de comprobación rápida

```text
[ ] Node Exporter está instalado.
[ ] El binario existe.
[ ] La arquitectura es compatible.
[ ] El binario es ejecutable.
[ ] La versión se puede consultar.
[ ] El usuario del servicio existe.
[ ] El grupo del servicio existe.
[ ] La unidad systemd existe.
[ ] El servicio está activo.
[ ] El servicio se inicia automáticamente.
[ ] El puerto 9100 está en escucha.
[ ] La dirección de escucha es correcta.
[ ] El endpoint /metrics responde.
[ ] Las métricas node_* aparecen.
[ ] El firewall permite el acceso necesario.
[ ] Prometheus puede alcanzar el endpoint.
[ ] El target aparece como UP.
[ ] La consulta up devuelve 1.
[ ] No hay errores relevantes en los registros.
```

## Tabla de síntomas y comprobaciones

| Síntoma | Primera comprobación | Comprobación adicional |
|---|---|---|
| El comando no existe | `command -v node_exporter` | Buscar el binario |
| El servicio no existe | `systemctl list-unit-files` | Revisar el método de instalación |
| El servicio está detenido | `systemctl status` | Consultar `journalctl` |
| `Exec format error` | `uname -m` y `file` | Descargar la arquitectura correcta |
| `Permission denied` | `ls -l` | Revisar usuario y ruta |
| `Connection refused` | `ss -lntp` | Estado del servicio |
| `Connection timed out` | `ufw` y `nc` | Rutas y firewall |
| Puerto ocupado | `ss` o `lsof` | Procesos duplicados |
| Endpoint `404` | URL utilizada | Parámetro `--web.telemetry-path` |
| Target `DOWN` | API de targets | Endpoint desde Prometheus |
| Métricas ausentes | `curl /metrics` | Collectors y versión |
| Grafana sin datos | Fuente de datos | Consulta `up` |
| Servicio activo sin métricas | `curl /metrics` | Registros y collectors |

## Buenas prácticas

- Comprueba la versión y la arquitectura antes de instalar.
- Descarga Node Exporter desde una fuente fiable.
- Verifica la suma de comprobación del archivo.
- Utiliza un usuario de sistema sin acceso interactivo.
- No ejecutes Node Exporter como `root` sin una razón justificada.
- Protege el puerto `9100` mediante el firewall.
- Permite el acceso únicamente desde los servidores Prometheus necesarios.
- Comprueba el endpoint local antes de diagnosticar Prometheus.
- Prueba el endpoint desde el servidor Prometheus.
- No confundas `localhost` con otro equipo.
- Consulta los registros antes de realizar cambios.
- Crea una copia de seguridad de la unidad antes de modificarla.
- Ejecuta `systemctl daemon-reload` después de cambiar una unidad.
- Valida el servicio después de cada modificación.
- Controla el espacio disponible del sistema.
- No utilices permisos `777`.
- No borres datos o binarios como primera medida.
- Documenta el estado inicial y el resultado final.
- Utiliza PromQL para verificar que las métricas se almacenan.
- Comprueba tanto el servicio como el target de Prometheus.

## Puntos clave

- Node Exporter expone métricas del sistema operativo.
- El puerto habitual es `9100`.
- El endpoint principal es `/metrics`.
- Node Exporter no almacena las métricas.
- Prometheus consulta y almacena las métricas expuestas.
- `systemctl status node_exporter` muestra el estado del servicio.
- `journalctl -u node_exporter` muestra los registros.
- `ss -lntp` permite comprobar el puerto y el proceso.
- `curl` permite probar el endpoint sin utilizar el navegador.
- `file` y `uname -m` permiten comprobar la compatibilidad de arquitectura.
- `127.0.0.1` solo acepta conexiones locales.
- Un target remoto requiere conectividad y reglas de firewall adecuadas.
- Un target `DOWN` debe investigarse desde el servidor Prometheus.
- El usuario del servicio debe poder ejecutar el binario.
- Los collectors determinan qué grupos de métricas se exponen.
- Un servicio activo no garantiza que el endpoint funcione.
- Prometheus debe poder acceder al endpoint `/metrics`.
- La consulta `up` permite comprobar la disponibilidad del target.
- Las configuraciones y unidades deben respaldarse antes de modificarse.
- Toda incidencia debe registrar síntoma, pruebas, causa, solución y validación.

## Preguntas de comprobación

1. ¿Qué función cumple Node Exporter?
2. ¿Cuál es el puerto habitual de Node Exporter?
3. ¿Qué endpoint expone las métricas?
4. ¿Qué diferencia existe entre Node Exporter y Prometheus?
5. ¿Qué comando permite comprobar si el servicio está activo?
6. ¿Qué comando permite consultar los registros del servicio?
7. ¿Qué comando permite comprobar si el puerto `9100` está en escucha?
8. ¿Qué significa que Node Exporter escuche en `127.0.0.1:9100`?
9. ¿Qué diferencia existe entre `Connection refused` y `Connection timed out`?
10. ¿Cómo comprobarías si el binario es compatible con la arquitectura del sistema?
11. ¿Qué puede provocar un error `Exec format error`?
12. ¿Qué comprobarías ante un error `Permission denied`?
13. ¿Cómo comprobarías que el usuario `node_exporter` existe?
14. ¿Qué comprobarías si el puerto `9100` está ocupado?
15. ¿Qué pasos seguirías para diagnosticar un target `DOWN`?
16. ¿Por qué debes probar el endpoint desde el servidor Prometheus?
17. ¿Qué función cumplen los collectors?
18. ¿Qué consulta PromQL permite comprobar la disponibilidad de Node Exporter?
19. ¿Qué diferencias existen entre el estado del servicio y el estado del target?
20. ¿Qué información debe incluir un informe de una incidencia de Node Exporter?