# Instalación y explotación de Loki

Esta documentación explica cómo instalar y configurar **Grafana Loki directamente en Ubuntu 24.04**, sin utilizar Docker.

El entorno final estará formado por:

- **Prometheus**: almacena métricas.
- **Node Exporter**: expone métricas del sistema operativo.
- **Loki**: almacena y consulta logs.
- **Grafana Alloy**: recopila logs del sistema y los envía a Loki.
- **Grafana**: visualiza métricas y logs.

La arquitectura será:

```text
Métricas:

Sistema operativo
        |
        v
Node Exporter
        |
        v
Prometheus
        |
        v
Grafana
```

```text
Logs:

/var/log/*.log
        |
        v
Grafana Alloy
        |
        v
Loki
        |
        v
Grafana
```

---

## Objetivos

Al finalizar esta guía podrás:

- Instalar Loki sin Docker.
- Crear un usuario dedicado para Loki.
- Configurar el almacenamiento local de logs.
- Crear un servicio `systemd` para Loki.
- Configurar Grafana Alloy como agente de logs.
- Leer logs de Ubuntu desde `/var/log`.
- Enviar logs a Loki.
- Añadir Loki como fuente de datos en Grafana.
- Ejecutar consultas LogQL.
- Crear dashboards de logs.
- Supervisar Loki mediante Prometheus.
- Configurar la retención de logs.
- Realizar copias de seguridad.
- Diagnosticar problemas de conectividad y permisos.

---

## Arquitectura final

### Componentes

| Componente | Función | Puerto |
|---|---|---:|
| Grafana | Visualización de métricas y logs | `3000` |
| Prometheus | Almacenamiento de métricas | `9090` |
| Node Exporter | Métricas del sistema operativo | `9100` |
| Loki | Almacenamiento y consulta de logs | `3100` |
| Grafana Alloy | Recopilación y envío de logs | `12345` opcional |

### Flujo de métricas

```text
Sistema operativo
        |
        v
Node Exporter:9100
        |
        v
Prometheus:9090
        |
        v
Grafana:3000
```

### Flujo de logs

```text
/var/log/syslog
/var/log/auth.log
/var/log/kern.log
        |
        v
Grafana Alloy
        |
        | HTTP Push API
        v
Loki:3100
        |
        v
Grafana:3000
```

---

## Requisitos previos

Antes de comenzar, comprobar que se dispone de:

- Ubuntu 24.04.
- Usuario con permisos de `sudo`.
- Grafana instalado.
- Prometheus instalado.
- Node Exporter instalado.
- Conectividad a Internet para descargar los binarios.
- Al menos 2 GB de memoria libre.
- Al menos 10 GB de espacio disponible.
- Arquitectura `amd64` o equivalente compatible.
- Puertos disponibles:
  - `3000` para Grafana.
  - `9090` para Prometheus.
  - `9100` para Node Exporter.
  - `3100` para Loki.

### Comprobar la versión de Ubuntu

```bash
lsb_release -ds
```

También puede utilizarse:

```bash
cat /etc/os-release
```

Resultado esperado:

```text
Ubuntu 24.04 LTS
```

### Comprobar la arquitectura

```bash
uname -m
```

Valores habituales:

```text
x86_64
```

o:

```text
amd64
```

### Comprobar el espacio disponible

```bash
df -h /
```

### Comprobar la memoria disponible

```bash
free -h
```

### Comprobar los puertos utilizados

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100|3100)'
```

---

## Instalar paquetes necesarios

Actualizar los repositorios:

```bash
sudo apt update
```

Instalar las herramientas necesarias:

```bash
sudo apt install -y \
  curl \
  wget \
  unzip \
  jq \
  ca-certificates \
  rsyslog
```

Reiniciar `rsyslog` para asegurar que Ubuntu escribe los logs tradicionales:

```bash
sudo systemctl enable --now rsyslog
```

Comprobar que existen los ficheros de log:

```bash
ls -lh /var/log/syslog
```

```bash
ls -lh /var/log/auth.log
```

```bash
ls -lh /var/log/kern.log
```

> Dependiendo de la instalación de Ubuntu, algunos ficheros pueden no existir. En ese caso, se utilizarán únicamente los que estén disponibles.

---

## Definir variables de instalación

Crear este directorio primero:

```bash
sudo mkdir -p /opt/observabilidad
```

Estas variables se utilizarán durante el procedimiento:

```bash
export LOKI_VERSION="3.7.8"
export ALLOY_VERSION="1.10.2"
export INSTALL_DIR="/opt/observabilidad"
```

Comprobarlas:

```bash
echo "$LOKI_VERSION"
echo "$ALLOY_VERSION"
echo "$INSTALL_DIR"
```

Las versiones son ejemplos. Antes de instalar en producción, conviene comprobar la versión estable disponible y sustituirlas.

---

## Crear usuarios y grupos del sistema

Crear el usuario de Loki:

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  loki
```

Si el usuario ya existe, el comando puede mostrar un aviso. Comprobarlo:

```bash
id loki
```

Crear el usuario de Alloy:

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  alloy
```

Comprobarlo:

```bash
id alloy
```

Añadir Alloy al grupo `adm`:

```bash
sudo usermod -aG adm alloy
```

El grupo `adm` suele tener permisos de lectura sobre muchos logs del sistema:

```bash
ls -l /var/log/auth.log
```

Resultado habitua (para que se vea el grupo y el propietario del fichero):

```text
-rw-r----- 1 syslog adm ...
```

Crear la estructura de directorios:

```bash
sudo mkdir -p \
  /etc/loki \
  /var/lib/loki \
  /var/log/loki \
  /etc/alloy \
  /var/lib/alloy
```

Asignar propietarios:

```bash
sudo chown -R loki:loki \
  /etc/loki \
  /var/lib/loki \
  /var/log/loki
```

```bash
sudo chown -R alloy:alloy \
  /etc/alloy \
  /var/lib/alloy
```

---

## Instalar Loki sin Docker

### Descargar el binario

Cambiar al directorio temporal:

```bash
cd /tmp
```

Descargar Loki:

```bash
wget \
  "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip" \
  -O loki-linux-amd64.zip
```

Descomprimir:

```bash
unzip -o loki-linux-amd64.zip
```

Comprobar el fichero:

```bash
ls -lh loki-linux-amd64
```

Instalarlo en `/usr/local/bin`:

```bash
sudo install \
  -m 0755 \
  loki-linux-amd64 \
  /usr/local/bin/loki
```

Comprobar la instalación:

```bash
/usr/local/bin/loki --version
```

Resultado conceptual:

```text
loki, version 3.5.0
```

### Comprobar la arquitectura del binario

```bash
file /usr/local/bin/loki
```

Resultado esperado:

```text
ELF 64-bit LSB executable, x86-64
```

### Comprobar el checksum

Si la versión descargada proporciona un fichero de checksums, descargarlo:

```bash
wget \
  "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/SHA256SUMS" \
  -O /tmp/loki-SHA256SUMS
```

Comprobar el binario:

```bash
grep 'loki-linux-amd64.zip' /tmp/loki-SHA256SUMS
```

Calcular el checksum local:

```bash
sha256sum /tmp/loki-linux-amd64.zip
```

Comparar ambos valores antes de continuar.

---

## Configurar Loki

Crear el fichero de configuración:

```bash
sudo nano /etc/loki/config.yml
```

Contenido:

```yaml
---
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: /var/lib/loki

  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules

  replication_factor: 1

  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  filesystem:
    directory: /var/lib/loki/chunks

limits_config:
  allow_structured_metadata: false
  volume_enabled: true

compactor:
  working_directory: /var/lib/loki/compactor
  retention_enabled: false

analytics:
  reporting_enabled: false

ruler:
  alertmanager_url: http://localhost:9093
```

Esta configuración establece:

- Loki escucha en `127.0.0.1:3100`.
- El almacenamiento es local.
- La retención es de 7 días.
- No se utiliza autenticación interna.
- El esquema de almacenamiento es TSDB.
- La replicación es `1`, adecuada para un único servidor.
- Los datos se almacenan en `/var/lib/loki`.

### Crear los directorios de almacenamiento

```bash
sudo mkdir -p \
  /var/lib/loki/chunks \
  /var/lib/loki/rules \
  /var/lib/loki/compactor
```

Asignar permisos:

```bash
sudo chown -R loki:loki /var/lib/loki
```

```bash
sudo chmod 750 /var/lib/loki
```

### Mostrar la configuración

```bash
sudo sed -n '1,240p' /etc/loki/config.yml
```

---

## Crear el servicio systemd de Loki

Crear el fichero:

```bash
sudo nano /etc/systemd/system/loki.service
```

Contenido:

```ini
[Unit]
Description=Grafana Loki
Documentation=https://grafana.com/docs/loki/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=loki
Group=loki

ExecStart=/usr/local/bin/loki \
  -config.file=/etc/loki/config.yml

Restart=on-failure
RestartSec=5s

LimitNOFILE=65536
LimitNPROC=65536

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
ReadWritePaths=/var/lib/loki /var/log/loki

[Install]
WantedBy=multi-user.target
```

Recargar `systemd`:

```bash
sudo systemctl daemon-reload
```

Habilitar Loki para que arranque con el sistema:

```bash
sudo systemctl enable loki
```

Iniciar Loki:

```bash
sudo systemctl start loki
```

Comprobar el estado:

```bash
sudo systemctl status loki --no-pager
```

Comprobar que está activo:

```bash
systemctl is-active loki
```

Resultado esperado:

```text
active
```

---

## Validar el funcionamiento de Loki

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':3100'
```

### Comprobar el endpoint de preparación

```bash
curl http://localhost:3100/ready
```

Resultado esperado:

```text
ready
```

### Consultar la versión

```bash
curl -s \
  http://localhost:3100/loki/api/v1/status/buildinfo \
  | jq
```

### Consultar las métricas de Loki

```bash
curl -s http://localhost:3100/metrics \
  | head -n 30
```

### Consultar las etiquetas disponibles

```bash
curl -s \
  http://localhost:3100/loki/api/v1/labels \
  | jq
```

Al principio puede aparecer una lista vacía porque todavía no se ha enviado ningún log.

### Consultar los logs de Loki

```bash
sudo journalctl -u loki \
  --since "10 minutes ago" \
  --no-pager
```

Seguir los logs en tiempo real:

```bash
sudo journalctl -u loki -f
```

---

## Diagnóstico si Loki no inicia

Consultar el estado completo:

```bash
sudo systemctl status loki --no-pager -l
```

Consultar los últimos registros:

```bash
sudo journalctl -u loki \
  --no-pager \
  -n 100
```

Comprobar permisos:

```bash
sudo -u loki test -w /var/lib/loki \
  && echo "Permisos correctos" \
  || echo "Permisos incorrectos"
```

Comprobar el binario:

```bash
sudo -u loki /usr/local/bin/loki \
  -config.file=/etc/loki/config.yml \
  -verify-config=true
```

Si la versión instalada no admite `-verify-config`, ejecutar:

```bash
sudo -u loki /usr/local/bin/loki \
  -config.file=/etc/loki/config.yml
```

Detenerlo con:

```text
Ctrl + C
```

Revisar el fichero de configuración:

```bash
sudo sed -n '1,240p' /etc/loki/config.yml
```

---

## Instalar Grafana Alloy sin Docker

Loki almacena logs, pero no los recopila directamente. Para leer los logs de Ubuntu se utilizará **Grafana Alloy**.

### Descargar Alloy

Cambiar al directorio temporal:

```bash
cd /tmp
```

Descargar Alloy:

```bash
wget \
  "https://github.com/grafana/alloy/releases/download/v${ALLOY_VERSION}/alloy-linux-amd64.zip" \
  -O alloy-linux-amd64.zip
```

Descomprimir:

```bash
unzip -o alloy-linux-amd64.zip
```

Comprobar los ficheros:

```bash
find . -maxdepth 2 -type f -name '*alloy*' -ls
```

Instalar el binario:

```bash
sudo install \
  -m 0755 \
  alloy-linux-amd64 \
  /usr/local/bin/alloy
```

Comprobar la versión:

```bash
/usr/local/bin/alloy --version
```

Si el nombre del binario extraído es diferente, localizarlo:

```bash
find /tmp -type f -name 'alloy*' -perm -111
```

---

## Configurar Grafana Alloy

Crear el fichero:

```bash
sudo nano /etc/alloy/config.alloy
```

Contenido:

```hcl
logging {
  level  = "info"
  format = "logfmt"
}

local.file_match "system_logs" {
  path_targets = [
    {
      __path__ = "/var/log/syslog",
      job      = "syslog",
      host     = "ubuntu-24-04",
    },
    {
      __path__ = "/var/log/auth.log",
      job      = "auth",
      host     = "ubuntu-24-04",
    },
    {
      __path__ = "/var/log/kern.log",
      job      = "kernel",
      host     = "ubuntu-24-04",
    },
  ]
}

loki.source.file "system_logs" {
  targets    = local.file_match.system_logs.targets
  forward_to = [loki.write.local.receiver]
}

loki.write "local" {
  endpoint {
    url = "http://127.0.0.1:3100/loki/api/v1/push"
  }
}
```

Esta configuración:

- Lee `/var/log/syslog`.
- Lee `/var/log/auth.log`.
- Lee `/var/log/kern.log`.
- Añade las etiquetas `job` y `host`.
- Envía los logs a Loki.
- Utiliza la API de escritura de Loki.

### Comprobar los permisos del fichero

```bash
sudo chown alloy:alloy /etc/alloy/config.alloy
```

```bash
sudo chmod 640 /etc/alloy/config.alloy
```

### Comprobar las rutas de log

```bash
sudo ls -l \
  /var/log/syslog \
  /var/log/auth.log \
  /var/log/kern.log
```

Si alguno no existe, eliminarlo temporalmente de `config.alloy` o instalar el servicio que lo genera.

---

## Validar la configuración de Alloy

Ejecutar:

```bash
sudo -u alloy /usr/local/bin/alloy \
  fmt /etc/alloy/config.alloy
```

Comprobar la configuración:

```bash
sudo -u alloy /usr/local/bin/alloy \
  run \
  /etc/alloy/config.alloy \
  --server.http.listen-addr=127.0.0.1:12345
```

Si Alloy inicia sin errores, detenerlo con:

```text
Ctrl + C
```

Los mensajes de error más habituales están relacionados con:

- Sintaxis HCL.
- Rutas inexistentes.
- Permisos de lectura.
- Dirección incorrecta de Loki.
- Etiquetas mal formadas.

---

## Crear el servicio systemd de Alloy

Crear el fichero:

```bash
sudo nano /etc/systemd/system/alloy.service
```

Contenido:

```ini
[Unit]
Description=Grafana Alloy
Documentation=https://grafana.com/docs/alloy/
After=network-online.target loki.service
Wants=network-online.target
Requires=loki.service

[Service]
Type=simple
User=alloy
Group=alloy

ExecStart=/usr/local/bin/alloy run \
  /etc/alloy/config.alloy \
  --server.http.listen-addr=127.0.0.1:12345 \
  --storage.path=/var/lib/alloy

Restart=on-failure
RestartSec=5s

SupplementaryGroups=adm

LimitNOFILE=65536

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
ReadWritePaths=/var/lib/alloy

[Install]
WantedBy=multi-user.target
```

Recargar `systemd`:

```bash
sudo systemctl daemon-reload
```

Habilitar Alloy:

```bash
sudo systemctl enable alloy
```

Iniciar Alloy:

```bash
sudo systemctl start alloy
```

Comprobar el estado:

```bash
sudo systemctl status alloy --no-pager
```

Comprobar que está activo:

```bash
systemctl is-active alloy
```

Resultado esperado:

```text
active
```

---

## Comprobar Alloy

### Consultar los logs de Alloy

```bash
sudo journalctl -u alloy \
  --since "10 minutes ago" \
  --no-pager
```

Seguir los logs:

```bash
sudo journalctl -u alloy -f
```

### Comprobar el endpoint HTTP

```bash
curl http://localhost:12345/-/ready
```

### Comprobar las métricas de Alloy

```bash
curl -s http://localhost:12345/metrics \
  | head -n 30
```

### Buscar errores

```bash
sudo journalctl -u alloy \
  --since "10 minutes ago" \
  --no-pager \
  | grep -iE 'error|failed|permission|loki'
```

### Comprobar los permisos de lectura

Ejecutar como el usuario de Alloy:

```bash
sudo -u alloy test -r /var/log/syslog \
  && echo "Alloy puede leer syslog" \
  || echo "Alloy no puede leer syslog"
```

```bash
sudo -u alloy test -r /var/log/auth.log \
  && echo "Alloy puede leer auth.log" \
  || echo "Alloy no puede leer auth.log"
```

---

## Generar un log de prueba

Generar un mensaje mediante `logger`:

```bash
logger "Prueba de integración entre Ubuntu, Alloy y Loki"
```

Buscarlo localmente:

```bash
sudo grep -R \
  "Prueba de integración entre Ubuntu, Alloy y Loki" \
  /var/log 2>/dev/null
```

Consultar las etiquetas de Loki:

```bash
curl -s \
  http://localhost:3100/loki/api/v1/labels \
  | jq
```

Deberían aparecer etiquetas como:

```text
job
host
filename
```

---

## Consultar logs mediante la API de Loki

La API de Loki permite realizar consultas sin utilizar Grafana.

### Consultar todos los logs de syslog

```bash
curl -G -s \
  http://localhost:3100/loki/api/v1/query_range \
  --data-urlencode 'query={job="syslog"}' \
  --data-urlencode 'limit=20' \
  | jq
```

### Buscar el mensaje de prueba

```bash
curl -G -s \
  http://localhost:3100/loki/api/v1/query_range \
  --data-urlencode 'query={job="syslog"} |= "Prueba de integración"' \
  --data-urlencode 'limit=20' \
  | jq
```

### Consultar logs de autenticación

```bash
curl -G -s \
  http://localhost:3100/loki/api/v1/query_range \
  --data-urlencode 'query={job="auth"}' \
  --data-urlencode 'limit=20' \
  | jq
```

### Buscar errores

```bash
curl -G -s \
  http://localhost:3100/loki/api/v1/query_range \
  --data-urlencode 'query={job=~".+"} |~ "(?i)error|failed|critical"' \
  --data-urlencode 'limit=20' \
  | jq
```

---

## Añadir Loki a Grafana

Acceder a:

```text
http://localhost:3000
```

Navegar a:

```text
Connections → Data sources
```

Seleccionar:

```text
Add new data source → Loki
```

Configurar:

```text
Name: Loki
URL: http://localhost:3100
Access: Server o Proxy
```

Pulsar:

```text
Save & test
```

Resultado esperado:

```text
Data source connected and labels found
```

### Configuración de la fuente

| Campo | Valor |
|---|---|
| Nombre | `Loki` |
| Tipo | `Loki` |
| URL | `http://localhost:3100` |
| Acceso | `Server` o `Proxy` |
| Predeterminada | No es necesario |

Como Grafana y Loki están instalados directamente en el mismo Ubuntu, Grafana puede acceder a Loki mediante:

```text
http://localhost:3100
```

---

## Configurar Loki mediante provisioning en Grafana

Crear el directorio:

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

Crear el fichero:

```bash
sudo nano /etc/grafana/provisioning/datasources/loki.yml
```

Contenido:

```yaml
apiVersion: 1

datasources:
  - name: Loki
    uid: loki
    type: loki
    access: proxy
    url: http://localhost:3100
    isDefault: false
    editable: true
```

Reiniciar Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprobar:

```bash
systemctl is-active grafana-server
```

Consultar los logs:

```bash
sudo journalctl -u grafana-server \
  --since "5 minutes ago" \
  --no-pager
```

---

## Primeras consultas LogQL

Las consultas LogQL se ejecutan en:

```text
Explore → Loki
```

### Mostrar logs de syslog

```logql
{job="syslog"}
```

### Mostrar logs de autenticación

```logql
{job="auth"}
```

### Mostrar logs del kernel

```logql
{job="kernel"}
```

### Buscar errores

```logql
{job=~".+"} |~ "(?i)error|failed|critical"
```

### Buscar advertencias

```logql
{job=~".+"} |~ "(?i)warning|warn"
```

### Buscar intentos de autenticación fallidos

```logql
{job="auth"} |~ "(Failed password|authentication failure)"
```

### Buscar accesos correctos

```logql
{job="auth"} |= "Accepted"
```

### Mostrar logs de un host

```logql
{host="ubuntu-24-04"}
```

### Buscar el mensaje de prueba

```logql
{job="syslog"} |= "Prueba de integración"
```

---

## Consultas LogQL de agregación

### Contar logs de syslog

```logql
count_over_time(
  {job="syslog"}[5m]
)
```

### Contar errores

```logql
count_over_time(
  {job=~".+"} |~ "(?i)error|failed"[5m]
)
```

### Contar errores por servicio

```logql
sum by (job) (
  count_over_time(
    {job=~".+"} |~ "(?i)error|failed"[5m]
  )
)
```

### Contar logs por servicio

```logql
sum by (job) (
  count_over_time(
    {job=~".+"}[5m]
  )
)
```

### Calcular la tasa de logs

```logql
sum by (job) (
  rate(
    {job=~".+"}[5m]
  )
)
```

---

## Crear un dashboard de logs

Crear un dashboard desde:

```text
Dashboards → New → New dashboard
```

### Panel de logs recientes

Fuente:

```text
Loki
```

Consulta:

```logql
{job=~".+"}
```

Visualización:

```text
Logs
```

Título:

```text
Logs recientes del sistema
```

### Panel de errores recientes

Consulta:

```logql
{job=~".+"} |~ "(?i)error|failed|critical"
```

Visualización:

```text
Logs
```

Título:

```text
Errores recientes
```

### Panel de errores por minuto

Consulta:

```logql
sum(
  count_over_time(
    {job=~".+"} |~ "(?i)error|failed"[5m]
  )
)
```

Visualización:

```text
Time series
```

Título:

```text
Número de errores
```

### Panel de logs por servicio

Consulta:

```logql
sum by (job) (
  count_over_time(
    {job=~".+"}[5m]
  )
)
```

Visualización:

```text
Bar chart
```

Título:

```text
Logs por servicio
```

### Panel de autenticaciones fallidas

Consulta:

```logql
count_over_time(
  {job="auth"} |~ "(Failed password|authentication failure)"[5m]
)
```

Visualización:

```text
Time series
```

Título:

```text
Intentos de autenticación fallidos
```

---

## Supervisar Loki con Prometheus

Loki expone métricas compatibles con Prometheus en:

```text
http://localhost:3100/metrics
```

Comprobarlo:

```bash
curl -s http://localhost:3100/metrics \
  | head -n 30
```

Editar la configuración de Prometheus:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Añadir este job dentro de `scrape_configs`:

```yaml
  - job_name: loki
    static_configs:
      - targets:
          - localhost:3100
        labels:
          environment: laboratorio
          service: loki
```

La configuración completa podría ser:

```yaml
---
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          role: monitoring

  - job_name: loki
    static_configs:
      - targets:
          - localhost:3100
        labels:
          environment: laboratorio
          service: loki
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reiniciar Prometheus:

```bash
sudo systemctl restart prometheus
```

Comprobar el target:

```bash
curl -s \
  http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "loki")
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

Consultar desde PromQL:

```promql
up{job="loki"}
```

```promql
process_resident_memory_bytes{job="loki"}
```

```promql
loki_request_duration_seconds_count
```

---

## Configurar retención de logs

La configuración actual utiliza:

```yaml
limits_config:
  retention_period: 168h
```

Esto equivale a:

```text
7 días
```

### Retención de 24 horas

```yaml
limits_config:
  retention_period: 24h
```

### Retención de 14 días

```yaml
limits_config:
  retention_period: 336h
```

### Retención de 30 días

```yaml
limits_config:
  retention_period: 720h
```

Después de modificar la configuración:

```bash
sudo systemctl restart loki
```

Comprobar:

```bash
systemctl is-active loki
```

### Comprobar el espacio ocupado

```bash
sudo du -sh /var/lib/loki
```

```bash
df -h /var/lib/loki
```

La retención debe ajustarse al espacio disponible. Loki no debería poder llenar completamente la partición del sistema.

---

## Integrar logs de Nginx

Instalar Nginx si no está instalado:

```bash
sudo apt install -y nginx
```

Comprobar sus ficheros de log:

```bash
ls -lh /var/log/nginx
```

Habitualmente:

```text
/var/log/nginx/access.log
/var/log/nginx/error.log
```

Editar la configuración de Alloy:

```bash
sudo nano /etc/alloy/config.alloy
```

Añadir:

```hcl
local.file_match "nginx_logs" {
  path_targets = [
    {
      __path__ = "/var/log/nginx/access.log",
      job      = "nginx_access",
      host     = "ubuntu-24-04",
    },
    {
      __path__ = "/var/log/nginx/error.log",
      job      = "nginx_error",
      host     = "ubuntu-24-04",
    },
  ]
}

loki.source.file "nginx_logs" {
  targets    = local.file_match.nginx_logs.targets
  forward_to = [loki.write.local.receiver]
}
```

Reiniciar Alloy:

```bash
sudo systemctl restart alloy
```

Generar una petición:

```bash
curl http://localhost
```

Consultar los logs de acceso:

```logql
{job="nginx_access"}
```

Consultar los errores:

```logql
{job="nginx_error"}
```

---

## Integrar logs de servicios systemd

Consultar los logs de Grafana:

```bash
journalctl -u grafana-server -n 30
```

Consultar los logs de Prometheus:

```bash
journalctl -u prometheus -n 30
```

Consultar los logs de Loki:

```bash
journalctl -u loki -n 30
```

Para recopilar el journal directamente con Alloy se puede utilizar el componente `loki.source.journal`.

Una configuración conceptual es:

```hcl
loki.source.journal "systemd" {
  forward_to = [loki.write.local.receiver]

  labels = {
    job  = "systemd",
    host = "ubuntu-24-04",
  }
}
```

La lectura del journal requiere que el usuario de Alloy tenga permisos adecuados. Comprobar:

```bash
sudo usermod -aG systemd-journal alloy
```

Cerrar y volver a iniciar la sesión del usuario si se necesita aplicar el cambio.

Reiniciar Alloy:

```bash
sudo systemctl restart alloy
```

Consultar:

```logql
{job="systemd"}
```

Si se producen problemas de permisos, es más sencillo comenzar con los ficheros de `/var/log` y añadir el journal posteriormente.

---

## Alertas con Loki

Grafana puede generar alertas basadas en consultas LogQL.

### Alerta por errores

Consulta:

```logql
sum(
  count_over_time(
    {job=~".+"} |~ "(?i)error|failed|critical"[5m]
  )
) > 0
```

Interpretación:

```text
Se ha detectado al menos un error durante los últimos cinco minutos.
```

### Alerta por autenticaciones fallidas

Consulta:

```logql
sum(
  count_over_time(
    {job="auth"} |~ "(Failed password|authentication failure)"[10m]
  )
) > 5
```

Interpretación:

```text
Se han detectado más de cinco intentos fallidos durante diez minutos.
```

### Datos recomendados para una alerta

Una alerta debería incluir:

- Nombre.
- Severidad.
- Fuente.
- Host.
- Servicio.
- Condición.
- Duración.
- Enlace al dashboard.
- Canal de notificación.

Ejemplo:

```text
Nombre: Errores elevados en Ubuntu
Severidad: Warning
Fuente: Loki
Host: ubuntu-24-04
Condición: Más de 10 errores en 5 minutos
```

---

## Diagnóstico de problemas

### Loki no está activo

Comprobar:

```bash
systemctl is-active loki
```

Consultar el estado:

```bash
sudo systemctl status loki --no-pager -l
```

Consultar los registros:

```bash
sudo journalctl -u loki \
  --no-pager \
  -n 100
```

### Loki no responde en el puerto 3100

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':3100'
```

Comprobar el endpoint:

```bash
curl -v http://localhost:3100/ready
```

Comprobar si el proceso está activo:

```bash
pgrep -a loki
```

### Alloy no está activo

Comprobar:

```bash
systemctl is-active alloy
```

Consultar el estado:

```bash
sudo systemctl status alloy --no-pager -l
```

Consultar los logs:

```bash
sudo journalctl -u alloy \
  --no-pager \
  -n 100
```

### Loki está activo, pero no aparecen logs

Comprobar Alloy:

```bash
systemctl is-active alloy
```

Generar un log de prueba:

```bash
logger "Mensaje de prueba para Loki"
```

Comprobar que el mensaje existe:

```bash
sudo grep -R \
  "Mensaje de prueba para Loki" \
  /var/log 2>/dev/null
```

Comprobar permisos:

```bash
sudo -u alloy test -r /var/log/syslog \
  && echo "Lectura correcta" \
  || echo "Sin permisos"
```

Comprobar las etiquetas:

```bash
curl -s \
  http://localhost:3100/loki/api/v1/labels \
  | jq
```

### Grafana no conecta con Loki

Comprobar Loki:

```bash
curl http://localhost:3100/ready
```

Revisar la URL de Grafana:

```text
http://localhost:3100
```

Consultar los logs de Grafana:

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

### Error de permisos en `/var/log`

Comprobar el grupo del usuario:

```bash
id alloy
```

Debería aparecer:

```text
adm
```

Comprobar los permisos del fichero:

```bash
ls -l /var/log/syslog
```

Si Alloy no pertenece al grupo `adm`:

```bash
sudo usermod -aG adm alloy
```

Reiniciar el servicio:

```bash
sudo systemctl restart alloy
```

### Error de configuración de Alloy

Formatear la configuración:

```bash
sudo -u alloy /usr/local/bin/alloy \
  fmt /etc/alloy/config.alloy
```

Ejecutar temporalmente Alloy en primer plano:

```bash
sudo -u alloy /usr/local/bin/alloy \
  run \
  /etc/alloy/config.alloy \
  --server.http.listen-addr=127.0.0.1:12345
```

Detener con:

```text
Ctrl + C
```

---

## Copias de seguridad

Crear un directorio de copias:

```bash
mkdir -p ~/backup-observabilidad
```

Copiar la configuración de Loki:

```bash
sudo cp \
  /etc/loki/config.yml \
  ~/backup-observabilidad/loki-config.yml
```

Copiar la configuración de Alloy:

```bash
sudo cp \
  /etc/alloy/config.alloy \
  ~/backup-observabilidad/config.alloy
```

Copiar los servicios `systemd`:

```bash
sudo cp \
  /etc/systemd/system/loki.service \
  ~/backup-observabilidad/loki.service
```

```bash
sudo cp \
  /etc/systemd/system/alloy.service \
  ~/backup-observabilidad/alloy.service
```

Comprimir las configuraciones:

```bash
sudo tar -czf \
  ~/backup-observabilidad-$(date +%Y%m%d-%H%M%S).tar.gz \
  /etc/loki \
  /etc/alloy \
  /etc/systemd/system/loki.service \
  /etc/systemd/system/alloy.service
```

### Copiar los datos de Loki

Detener Loki:

```bash
sudo systemctl stop loki
```

Crear la copia:

```bash
sudo tar -czf \
  ~/backup-loki-data-$(date +%Y%m%d-%H%M%S).tar.gz \
  /var/lib/loki
```

Iniciar Loki:

```bash
sudo systemctl start loki
```

Comprobar:

```bash
systemctl is-active loki
```

---

## Operaciones habituales

### Iniciar Loki

```bash
sudo systemctl start loki
```

### Detener Loki

```bash
sudo systemctl stop loki
```

### Reiniciar Loki

```bash
sudo systemctl restart loki
```

### Habilitar Loki en el arranque

```bash
sudo systemctl enable loki
```

### Iniciar Alloy

```bash
sudo systemctl start alloy
```

### Detener Alloy

```bash
sudo systemctl stop alloy
```

### Reiniciar Alloy

```bash
sudo systemctl restart alloy
```

### Habilitar Alloy en el arranque

```bash
sudo systemctl enable alloy
```

### Ver el estado de ambos servicios

```bash
systemctl is-active loki alloy
```

### Seguir los logs de Loki

```bash
sudo journalctl -u loki -f
```

### Seguir los logs de Alloy

```bash
sudo journalctl -u alloy -f
```

---

## Script de comprobación final

Crear el script:

```bash
sudo tee /usr/local/bin/comprobar-loki.sh > /dev/null <<'EOF'
#!/usr/bin/env bash

set -u

echo "===== COMPROBACIÓN DE LOKI Y ALLOY ====="
echo

check_service() {
  local service="$1"

  printf '%-35s ' "$service"

  if systemctl is-active --quiet "$service"; then
    echo "ACTIVO"
  else
    echo "NO ACTIVO"
  fi
}

check_http() {
  local name="$1"
  local url="$2"

  printf '%-35s ' "$name"

  if curl -fsS "$url" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "ERROR"
  fi
}

check_service loki
check_service alloy

check_http "Loki preparado" \
  "http://localhost:3100/ready"

check_http "Métricas de Loki" \
  "http://localhost:3100/metrics"

check_http "API de etiquetas de Loki" \
  "http://localhost:3100/loki/api/v1/labels"

check_http "Alloy preparado" \
  "http://localhost:12345/-/ready"

check_http "Grafana saludable" \
  "http://localhost:3000/api/health"

check_http "Prometheus saludable" \
  "http://localhost:9090/-/healthy"

echo
echo "===== ETIQUETAS DISPONIBLES EN LOKI ====="

curl -fsS \
  "http://localhost:3100/loki/api/v1/labels" \
  | jq

echo
echo "===== TARGET DE LOKI EN PROMETHEUS ====="

curl -fsS \
  "http://localhost:9090/api/v1/targets" \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "loki")
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
EOF
```

Asignar permisos:

```bash
sudo chmod 0755 /usr/local/bin/comprobar-loki.sh
```

Ejecutar:

```bash
sudo /usr/local/bin/comprobar-loki.sh
```

Resultado esperado:

```text
===== COMPROBACIÓN DE LOKI Y ALLOY =====

loki                               ACTIVO
alloy                              ACTIVO
Loki preparado                    OK
Métricas de Loki                  OK
API de etiquetas de Loki          OK
Alloy preparado                   OK
Grafana saludable                 OK
Prometheus saludable              OK
```

---

## Comprobación funcional completa

Ejecutar un log de prueba:

```bash
logger "Loki Ubuntu 24.04: prueba funcional completa"
```

Esperar unos segundos:

```bash
sleep 5
```

Consultar las etiquetas:

```bash
curl -s \
  http://localhost:3100/loki/api/v1/labels \
  | jq
```

Consultar el mensaje:

```bash
curl -G -s \
  http://localhost:3100/loki/api/v1/query_range \
  --data-urlencode \
  'query={job="syslog"} |= "prueba funcional completa"' \
  --data-urlencode 'limit=20' \
  | jq
```

En Grafana, ejecutar:

```logql
{job="syslog"} |= "prueba funcional completa"
```

Si el mensaje aparece, el flujo completo funciona:

```text
logger
  |
  v
/var/log/syslog
  |
  v
Alloy
  |
  v
Loki
  |
  v
Grafana
```

---

## Estructura final del sistema

```text
/etc/loki/
└── config.yml

/etc/alloy/
└── config.alloy

/etc/systemd/system/
├── loki.service
└── alloy.service

/var/lib/loki/
├── chunks/
├── compactor/
├── index_*/
└── rules/

/var/lib/alloy/

/usr/local/bin/
├── loki
└── alloy
```

---

## Resumen de puertos

| Servicio | Dirección | Uso |
|---|---|---|
| Grafana | `127.0.0.1:3000` | Interfaz web |
| Prometheus | `127.0.0.1:9090` | Métricas y API |
| Node Exporter | `127.0.0.1:9100` | Métricas del sistema |
| Loki | `127.0.0.1:3100` | API de logs |
| Alloy | `127.0.0.1:12345` | API y métricas del agente |

Comprobar todos:

```bash
sudo ss -lntp \
  | grep -E ':(3000|9090|9100|3100|12345)'
```

---

## Flujo operativo final

```text
1. Ubuntu genera logs.
2. rsyslog escribe los logs en /var/log.
3. Alloy lee los ficheros.
4. Alloy añade etiquetas.
5. Alloy envía los logs a Loki.
6. Loki almacena los logs.
7. Grafana consulta Loki mediante LogQL.
8. Prometheus supervisa el estado de Loki.
9. Grafana muestra métricas y logs en un mismo dashboard.
```

La arquitectura final queda así:

```text
                         +-------------------+
                         |     Grafana       |
                         |    Puerto 3000    |
                         +---------+---------+
                                   |
                    +--------------+--------------+
                    |                             |
                    v                             v
             +-------------+               +-------------+
             | Prometheus  |               | Loki        |
             | Puerto 9090 |               | Puerto 3100 |
             +------+------+               +------+------+
                    ^                             ^
                    |                             |
                    |                             |
             +------+------+               +------+------+
             | Node        |               | Alloy       |
             | Exporter    |               | Logs        |
             | Puerto 9100 |               | del sistema |
             +-------------+               +-------------+
```

El resultado es una plataforma básica de observabilidad sin Docker:

```text
Node Exporter → Prometheus → métricas
Alloy         → Loki       → logs
Grafana                    → visualización
```
````

## Consideraciones importantes

- Para un laboratorio, el almacenamiento local de Loki es suficiente.
- Para producción, conviene utilizar almacenamiento de objetos y una estrategia de alta disponibilidad.
- Loki no sustituye a Prometheus: almacenan tipos de información diferentes.
- Alloy sustituye a los agentes de recopilación antiguos en instalaciones nuevas.
- El usuario de Alloy necesita permisos de lectura sobre los logs.
- No conviene exponer el puerto `3100` directamente a Internet.
- La retención de `168h` conserva aproximadamente siete días de logs.
- Las etiquetas de Loki deben mantenerse con baja cardinalidad para evitar problemas de rendimiento.