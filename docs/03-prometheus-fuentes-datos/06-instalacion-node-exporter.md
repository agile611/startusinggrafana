# Instalación de Node Exporter

Node Exporter es un agente que expone métricas del sistema operativo en un formato que Prometheus puede consultar.

Durante esta práctica se instalará Node Exporter como un servicio de `systemd`. Después se comprobará que publica métricas del servidor mediante el endpoint HTTP:

```text
http://localhost:9100/metrics
```

El recorrido será:

```text
Descarga del binario
        |
        v
Creación del usuario de servicio
        |
        v
Instalación del binario
        |
        v
Creación del servicio systemd
        |
        v
Inicio del servicio
        |
        v
Comprobación del endpoint /metrics
        |
        v
Configuración de Prometheus
```

Node Exporter no almacena métricas ni crea dashboards. Su función es **recopilar información del sistema y exponerla** para que Prometheus pueda realizar el *scraping*.

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar la función de Node Exporter.
- Identificar las métricas principales del sistema operativo.
- Descargar una versión concreta de Node Exporter.
- Crear un usuario de servicio sin acceso interactivo.
- Instalar el binario de Node Exporter.
- Crear una unidad de `systemd`.
- Iniciar y detener el servicio.
- Habilitar el inicio automático.
- Comprobar el puerto `9100`.
- Consultar el endpoint `/metrics`.
- Buscar métricas de CPU, memoria, disco y red.
- Consultar los registros del servicio.
- Diagnosticar errores básicos de instalación.
- Configurar Prometheus para consultar Node Exporter.
- Comprobar el estado del objetivo mediante la métrica `up`.
- Documentar las evidencias de la instalación.

---

## Introducción

Prometheus necesita consultar endpoints que expongan métricas. Node Exporter proporciona ese endpoint para el sistema operativo Linux.

La arquitectura será:

```text
+---------------------+
| Servidor Ubuntu     |
|                     |
|  Node Exporter      |
|  Puerto 9100        |
|                     |
|  Prometheus         |
|  Puerto 9090        |
|                     |
|  Grafana            |
|  Puerto 3000        |
+---------------------+
```

El flujo de datos es:

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
        | PromQL
        v
Grafana
```

Node Exporter consulta información del sistema mediante interfaces como:

- `/proc`
- `/sys`
- Sistemas de ficheros montados
- Información del kernel
- Interfaces de red
- Estadísticas de procesos y dispositivos

Después transforma esa información en métricas con nombres como:

```text
node_cpu_seconds_total
node_memory_MemAvailable_bytes
node_filesystem_avail_bytes
node_network_receive_bytes_total
```

---

# Métricas proporcionadas

## CPU

```text
node_cpu_seconds_total
```

Esta métrica indica el tiempo acumulado de CPU, normalmente separado por:

- CPU.
- Modo.
- Instancia.
- Job.

Ejemplo:

```text
node_cpu_seconds_total{
  cpu="0",
  mode="idle"
} 12345.67
```

## Memoria

Memoria total:

```text
node_memory_MemTotal_bytes
```

Memoria disponible:

```text
node_memory_MemAvailable_bytes
```

Memoria libre:

```text
node_memory_MemFree_bytes
```

## Sistemas de ficheros

Tamaño total:

```text
node_filesystem_size_bytes
```

Espacio disponible:

```text
node_filesystem_avail_bytes
```

Espacio libre:

```text
node_filesystem_free_bytes
```

## Red

Bytes recibidos:

```text
node_network_receive_bytes_total
```

Bytes enviados:

```text
node_network_transmit_bytes_total
```

Estado de una interfaz:

```text
node_network_up
```

## Sistema

Tiempo de actividad:

```text
node_time_seconds - node_boot_time_seconds
```

Carga del sistema:

```text
node_load1
```

Información del sistema:

```text
node_uname_info
```

---

# Requisitos previos

Antes de comenzar, comprobar que:

- Ubuntu está instalado.
- El sistema tiene arquitectura compatible.
- Se dispone de un usuario con `sudo`.
- Existe conectividad a Internet.
- El puerto `9100` está disponible.
- Prometheus está instalado o se instalará posteriormente.
- La hora del sistema está sincronizada.

## Comprobar el sistema operativo

```bash
lsb_release -ds
```

## Comprobar la arquitectura

```bash
uname -m
```

Arquitecturas habituales:

```text
x86_64
aarch64
armv7l
```

Equivalencias para los paquetes:

| Salida de `uname -m` | Arquitectura del paquete |
|---|---|
| `x86_64` | `amd64` |
| `aarch64` | `arm64` |
| `armv7l` | `armv7` |

En esta práctica se utilizará principalmente:

```text
linux-amd64
```

## Comprobar permisos administrativos

```bash
sudo -v
```

## Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100' || true
```

Si no aparece ninguna salida, el puerto probablemente está disponible.

## Comprobar la hora

```bash
timedatectl status
```

---

# Preparar las variables

La versión debe ser la indicada para el curso o laboratorio. En el siguiente ejemplo se utiliza una variable para evitar repetir el número de versión.

```bash
export NODE_EXPORTER_VERSION="1.8.2"
export NODE_EXPORTER_ARCH="amd64"
export NODE_EXPORTER_PLATFORM="linux-${NODE_EXPORTER_ARCH}"
export NODE_EXPORTER_PACKAGE="node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}.tar.gz"
export NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_PACKAGE}"
```

Comprobar los valores:

```bash
echo "$NODE_EXPORTER_VERSION"
echo "$NODE_EXPORTER_PLATFORM"
echo "$NODE_EXPORTER_PACKAGE"
echo "$NODE_EXPORTER_URL"
```

Ejemplo:

```console
$ echo "$NODE_EXPORTER_PACKAGE"
node_exporter-1.8.2.linux-amd64.tar.gz
```

Comprobar la URL:

```bash
curl -I "$NODE_EXPORTER_URL"
```

Descargar el paquete:

```bash
cd /tmp
curl -fLO "$NODE_EXPORTER_URL"
```

Comprobar el archivo:

```bash
ls -lh "/tmp/$NODE_EXPORTER_PACKAGE"
```

> La versión utilizada debe comprobarse antes de la práctica. Si el laboratorio define otra versión, sustituye el valor de `NODE_EXPORTER_VERSION`.

---

# Crear el usuario de servicio

Node Exporter debe ejecutarse con un usuario específico y sin acceso interactivo.

Crear el usuario:

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

Comprobar que existe:

```bash
getent passwd node_exporter
```

Ejemplo:

```console
$ getent passwd node_exporter
node_exporter:x:995:995::/home/node_exporter:/usr/sbin/nologin
```

Consultar el identificador:

```bash
id node_exporter
```

Ejemplo:

```text
uid=995(node_exporter) gid=995(node_exporter) groups=995(node_exporter)
```

## Explicación de las opciones

| Opción | Función |
|---|---|
| `--system` | Crea un usuario de sistema |
| `--no-create-home` | No crea un directorio personal |
| `--shell /usr/sbin/nologin` | Impide el inicio de sesión interactivo |

Comprobar el shell:

```bash
getent passwd node_exporter | cut -d: -f7
```

Resultado esperado:

```text
/usr/sbin/nologin
```

---

# Extraer el paquete

Extraer el archivo descargado:

```bash
cd /tmp
tar -xzf "$NODE_EXPORTER_PACKAGE"
```

Definir el directorio extraído:

```bash
export NODE_EXPORTER_DIR="/tmp/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}"
```

Comprobarlo:

```bash
ls -ld "$NODE_EXPORTER_DIR"
```

Listar el contenido:

```bash
find "$NODE_EXPORTER_DIR" \
  -maxdepth 1 \
  -type f \
  -printf '%f\n'
```

El paquete contiene normalmente:

```text
node_exporter
LICENSE
NOTICE
```

---

# Instalar el binario

Instalar el binario en `/usr/local/bin`:

```bash
sudo install \
  -m 0755 \
  "$NODE_EXPORTER_DIR/node_exporter" \
  /usr/local/bin/node_exporter
```

Comprobar la ubicación:

```bash
command -v node_exporter
```

Resultado esperado:

```text
/usr/local/bin/node_exporter
```

Consultar la versión:

```bash
node_exporter --version
```

Ejemplo:

```console
$ node_exporter --version
node_exporter, version 1.8.2
  branch: ...
  revision: ...
  build user: ...
  build date: ...
  go version: ...
  platform: linux/amd64
```

Consultar las opciones disponibles:

```bash
node_exporter --help
```

---

# Crear el servicio systemd

Crear la unidad:

```bash
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

Restart=on-failure
RestartSec=5s

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
```

## Explicación de la unidad

| Directiva | Función |
|---|---|
| `User=node_exporter` | Ejecuta el proceso con el usuario de servicio |
| `Group=node_exporter` | Utiliza el grupo del servicio |
| `ExecStart` | Define el binario que se ejecutará |
| `Restart=on-failure` | Reinicia el servicio si termina con error |
| `NoNewPrivileges` | Impide obtener nuevos privilegios |
| `ProtectSystem` | Protege partes del sistema de ficheros |
| `ProtectHome` | Protege los directorios personales |
| `PrivateTmp` | Utiliza un directorio temporal privado |

Comprobar el contenido:

```bash
systemctl cat node_exporter
```

---

# Recargar systemd e iniciar el servicio

Después de crear la unidad:

```bash
sudo systemctl daemon-reload
```

Habilitar el inicio automático:

```bash
sudo systemctl enable node_exporter
```

Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

Consultar el estado:

```bash
sudo systemctl status node_exporter
```

Comprobar con un comando breve:

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
active
```

Comprobar el inicio automático:

```bash
systemctl is-enabled node_exporter
```

Resultado esperado:

```text
enabled
```

---

# Gestionar el servicio

## Iniciar

```bash
sudo systemctl start node_exporter
```

## Detener

```bash
sudo systemctl stop node_exporter
```

## Reiniciar

```bash
sudo systemctl restart node_exporter
```

## Consultar el estado

```bash
sudo systemctl status node_exporter
```

## Comprobar si está activo

```bash
systemctl is-active node_exporter
```

## Comprobar si está habilitado

```bash
systemctl is-enabled node_exporter
```

## Consultar el usuario de ejecución

```bash
systemctl show node_exporter \
  -p User \
  -p Group
```

Resultado esperado:

```text
User=node_exporter
Group=node_exporter
```

---

# Comprobar el puerto

Node Exporter utiliza normalmente el puerto `9100`.

Consultar los puertos en escucha:

```bash
sudo ss -lntp | grep ':9100'
```

Ejemplo:

```text
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=...,fd=...))
```

Consultar el proceso:

```bash
ps -ef | grep '[n]ode_exporter'
```

Identificar el proceso que utiliza el puerto:

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

---

# Consultar el endpoint de métricas

## Comprobar la respuesta HTTP

```bash
curl -I http://localhost:9100/metrics
```

Resultado esperado:

```text
HTTP/1.1 200 OK
Content-Type: text/plain; version=0.0.4; charset=utf-8
```

## Consultar las primeras líneas

```bash
curl -s http://localhost:9100/metrics | head -n 20
```

Ejemplo:

```text
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0.000012
go_gc_duration_seconds{quantile="0.25"} 0.000018
go_gc_duration_seconds{quantile="0.5"} 0.000022
```

Node Exporter también expone métricas propias del proceso, como las que comienzan por:

```text
go_
process_
promhttp_
```

Las métricas del sistema suelen comenzar por:

```text
node_
```

## Contar las líneas de métricas

```bash
curl -s http://localhost:9100/metrics | wc -l
```

## Mostrar únicamente nombres de métricas

```bash
curl -s http://localhost:9100/metrics \
  | grep -v '^#' \
  | sed 's/{.*//' \
  | awk '{print $1}' \
  | sort -u \
  | head -n 50
```

---

# Consultar métricas del sistema

## CPU

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

## Memoria

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_' \
  | head
```

## Sistemas de ficheros

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem_' \
  | head
```

## Red

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_network_' \
  | head
```

## Carga del sistema

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_load'
```

## Tiempo de actividad

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_boot_time_seconds'
```

---

# Consultar métricas concretas

## Memoria total

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemTotal_bytes'
```

Ejemplo:

```text
node_memory_MemTotal_bytes 4.10437632e+09
```

## Memoria disponible

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

## Interfaces de red

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_network_up'
```

Ejemplo:

```text
node_network_up{device="ens33"} 1
node_network_up{device="lo"} 1
```

## Sistemas de ficheros montados

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem_size_bytes' \
  | head
```

Las etiquetas más importantes suelen ser:

- `device`
- `fstype`
- `mountpoint`

---

# Coleccionistas de Node Exporter

Node Exporter organiza sus métricas mediante *collectors*.

Consultar los colectores disponibles:

```bash
node_exporter --help \
  | grep -A5 -B2 'collector'
```

Algunos colectores habituales son:

| Collector | Información |
|---|---|
| `cpu` | Tiempo de CPU |
| `filesystem` | Sistemas de ficheros |
| `loadavg` | Carga del sistema |
| `meminfo` | Memoria |
| `netdev` | Interfaces de red |
| `os` | Información del sistema operativo |
| `stat` | Estadísticas del kernel |
| `time` | Hora del sistema |
| `uname` | Información del kernel |
| `vmstat` | Estadísticas de memoria virtual |

La mayoría están habilitados por defecto.

## Activar un collector

Para activar un collector concreto, se puede añadir una opción a `ExecStart`.

Ejemplo:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --collector.systemd
```

Después de modificar la unidad:

```bash
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
```

## Desactivar un collector

Ejemplo:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --no-collector.arp
```

No se deben desactivar colectores sin comprender qué métricas dejarán de estar disponibles.

---

# Escuchar en una dirección concreta

Por defecto, Node Exporter suele escuchar en todas las interfaces disponibles.

Consultar la ayuda:

```bash
node_exporter --help | grep 'web.listen-address'
```

Para escuchar únicamente en el propio equipo:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=127.0.0.1:9100
```

Para escuchar en todas las interfaces IPv4:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=0.0.0.0:9100
```

Después de cambiar la dirección:

```bash
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
```

Comprobar:

```bash
sudo ss -lntp | grep ':9100'
```

> Escuchar en todas las interfaces facilita el acceso remoto, pero también aumenta la superficie de exposición. En un entorno real se debe limitar el acceso mediante red, cortafuegos o controles adicionales.

---

# Textfile collector

Node Exporter puede leer métricas adicionales desde ficheros de texto mediante el *textfile collector*.

Crear el directorio:

```bash
sudo mkdir -p /var/lib/node_exporter/textfile_collector
```

Asignar permisos:

```bash
sudo chown -R \
  node_exporter:node_exporter \
  /var/lib/node_exporter
```

Modificar la unidad:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --collector.textfile.directory=/var/lib/node_exporter/textfile_collector
```

Aplicar los cambios:

```bash
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
```

Crear una métrica de ejemplo:

```bash
sudo tee /var/lib/node_exporter/textfile_collector/laboratorio.prom > /dev/null <<'EOF'
# HELP laboratorio_estado Estado del laboratorio.
# TYPE laboratorio_estado gauge
laboratorio_estado 1
EOF
```

Comprobar que aparece:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^laboratorio_estado'
```

Resultado esperado:

```text
laboratorio_estado 1
```

## Recomendaciones para el textfile collector

- Escribir primero en un fichero temporal.
- Moverlo después al directorio definitivo.
- Evitar escribir parcialmente un fichero `.prom`.
- Utilizar nombres descriptivos.
- Mantener una sintaxis válida.
- No incluir secretos ni contraseñas.

Ejemplo de escritura segura:

```bash
cat > /tmp/laboratorio.prom.tmp <<'EOF'
# HELP laboratorio_comprobacion Resultado de una comprobacion.
# TYPE laboratorio_comprobacion gauge
laboratorio_comprobacion 1
EOF

sudo mv \
  /tmp/laboratorio.prom.tmp \
  /var/lib/node_exporter/textfile_collector/laboratorio.prom
```

---

# Configurar Prometheus

Una vez instalado Node Exporter, Prometheus debe configurarse para consultarlo.

Editar la configuración:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Añadir:

```yaml
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reiniciar Prometheus:

```bash
sudo systemctl restart prometheus
```

Comprobar el estado:

```bash
systemctl is-active prometheus
```

Consultar los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

Resultado esperado:

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

Consultar desde PromQL:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

---

# Verificar la integración

## Comprobar Node Exporter directamente

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

## Comprobar el objetivo en Prometheus

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .labels.job,
        .labels.instance,
        .health,
        .scrapeUrl,
        .lastError
      ]
    | @tsv
  '
```

## Consultar una métrica desde Prometheus

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_memory_MemAvailable_bytes' \
  | jq
```

## Consultar `up`

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up{job="node_exporter"}' \
  | jq
```

---

# Sesiones prácticas

## Sesión 1: revisar los requisitos

### Objetivo

Comprobar que el sistema está preparado para instalar Node Exporter.

### Comandos

```bash
lsb_release -ds
```

```bash
uname -m
```

```bash
sudo -v
```

```bash
sudo ss -lntp | grep ':9100' || true
```

```bash
df -h /
```

### Actividades

1. Anota la distribución.
2. Anota la arquitectura.
3. Comprueba que tienes permisos de `sudo`.
4. Comprueba si el puerto `9100` está disponible.
5. Comprueba el espacio libre.
6. Explica qué problemas pueden producirse si el puerto ya está ocupado.

---

## Sesión 2: crear el usuario de servicio

### Objetivo

Crear un usuario dedicado para Node Exporter.

### Comandos

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

```bash
getent passwd node_exporter
```

```bash
id node_exporter
```

### Actividades

1. Comprueba que el usuario existe.
2. Comprueba su UID y GID.
3. Comprueba su shell.
4. Explica por qué no debe utilizarse el usuario personal del alumno.
5. Explica por qué el shell es `/usr/sbin/nologin`.

---

## Sesión 3: descargar e instalar el binario

### Objetivo

Instalar Node Exporter en `/usr/local/bin`.

### Comandos

```bash
export NODE_EXPORTER_VERSION="1.8.2"
export NODE_EXPORTER_ARCH="amd64"
export NODE_EXPORTER_PLATFORM="linux-${NODE_EXPORTER_ARCH}"
export NODE_EXPORTER_PACKAGE="node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}.tar.gz"
export NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_PACKAGE}"
```

```bash
cd /tmp
curl -fLO "$NODE_EXPORTER_URL"
```

```bash
tar -xzf "$NODE_EXPORTER_PACKAGE"
```

```bash
export NODE_EXPORTER_DIR="/tmp/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}"
```

```bash
sudo install \
  -m 0755 \
  "$NODE_EXPORTER_DIR/node_exporter" \
  /usr/local/bin/node_exporter
```

### Comprobaciones

```bash
command -v node_exporter
```

```bash
node_exporter --version
```

### Actividades

1. Anota la versión instalada.
2. Comprueba la arquitectura del binario.
3. Comprueba los permisos.
4. Explica por qué se utiliza `/usr/local/bin`.

---

## Sesión 4: crear el servicio systemd

### Objetivo

Crear una unidad que permita gestionar Node Exporter.

### Comando

```bash
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

Restart=on-failure
RestartSec=5s

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
```

### Aplicar la unidad

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl enable node_exporter
```

```bash
sudo systemctl start node_exporter
```

### Comprobaciones

```bash
systemctl is-enabled node_exporter
```

```bash
systemctl is-active node_exporter
```

```bash
sudo systemctl status node_exporter
```

### Actividades

1. Comprueba que la unidad existe.
2. Comprueba que el servicio está habilitado.
3. Comprueba que está activo.
4. Consulta el usuario de ejecución.
5. Consulta el comando `ExecStart`.

---

## Sesión 5: consultar el endpoint `/metrics`

### Objetivo

Comprobar que Node Exporter expone métricas HTTP.

### Comandos

```bash
curl -I http://localhost:9100/metrics
```

```bash
curl -s http://localhost:9100/metrics | head -n 20
```

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_' \
  | head
```

### Actividades

1. Comprueba el código HTTP.
2. Localiza las líneas `HELP`.
3. Localiza las líneas `TYPE`.
4. Busca cinco métricas que comiencen por `node_`.
5. Identifica las etiquetas de una métrica.
6. Explica la diferencia entre una métrica `gauge` y una métrica `counter`.

---

## Sesión 6: estudiar las métricas del sistema

### Objetivo

Relacionar las métricas con la información del sistema operativo.

### CPU

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head -n 20
```

### Memoria

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_Mem'
```

### Disco

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem_' \
  | head -n 20
```

### Red

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_network_' \
  | head -n 20
```

### Comparar con comandos del sistema

Memoria:

```bash
free -h
```

Disco:

```bash
df -h
```

Interfaces:

```bash
ip -s link
```

Carga:

```bash
uptime
```

### Actividades

1. Compara la memoria del comando `free` con las métricas expuestas.
2. Compara el espacio de `/` con las métricas de filesystem.
3. Identifica el nombre de la interfaz principal.
4. Identifica la métrica equivalente a la carga del sistema.
5. Explica por qué los valores pueden no coincidir exactamente en el mismo instante.

---

## Sesión 7: configurar Prometheus

### Objetivo

Configurar Prometheus para consultar Node Exporter.

### Editar la configuración

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Añadir:

```yaml
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

La configuración completa puede ser:

```yaml
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
```

### Validar y reiniciar

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

```bash
systemctl is-active prometheus
```

### Consultar los objetivos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | [
        .labels.job,
        .labels.instance,
        .health,
        .lastError
      ]
    | @tsv
  '
```

### Actividades

1. Añade el target de Node Exporter.
2. Valida el YAML.
3. Reinicia Prometheus.
4. Comprueba que el target aparece como `up`.
5. Explica qué sucede si el puerto se escribe como `9010`.

---

## Sesión 8: comprobar `up`

### Objetivo

Utilizar PromQL para comprobar la disponibilidad de Node Exporter.

### Consultas

```promql
up
```

```promql
up{job="node_exporter"}
```

```promql
up == 0
```

### Prueba controlada

Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

Esperar al menos un intervalo de *scraping* y consultar:

```promql
up{job="node_exporter"}
```

También consultar los objetivos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [.health, .lastError]
    | @tsv
  '
```

Iniciar de nuevo el servicio:

```bash
sudo systemctl start node_exporter
```

Comprobar:

```bash
systemctl is-active node_exporter
```

### Actividades

1. Anota el valor de `up` antes de detener el servicio.
2. Anota el valor durante la interrupción.
3. Anota el valor después de iniciar el servicio.
4. Explica cuánto tiempo tarda en detectarse el cambio.
5. Explica por qué el valor no cambia necesariamente de forma inmediata.

---

## Sesión 9: utilizar el textfile collector

### Objetivo

Crear una métrica personalizada adicional.

### Crear el directorio

```bash
sudo mkdir -p /var/lib/node_exporter/textfile_collector
```

```bash
sudo chown -R \
  node_exporter:node_exporter \
  /var/lib/node_exporter
```

### Modificar la unidad

Editar:

```bash
sudo systemctl edit --full node_exporter
```

Cambiar `ExecStart`:

```ini
ExecStart=/usr/local/bin/node_exporter \
  --collector.textfile.directory=/var/lib/node_exporter/textfile_collector
```

Aplicar:

```bash
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
```

### Crear una métrica

```bash
cat > /tmp/laboratorio_estado.prom.tmp <<'EOF'
# HELP laboratorio_estado Estado del laboratorio.
# TYPE laboratorio_estado gauge
laboratorio_estado 1
EOF
```

Moverla al directorio:

```bash
sudo mv \
  /tmp/laboratorio_estado.prom.tmp \
  /var/lib/node_exporter/textfile_collector/laboratorio_estado.prom
```

Comprobar:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^laboratorio_estado'
```

Consultar desde Prometheus:

```promql
laboratorio_estado
```

### Actividades

1. Crea una métrica `laboratorio_estado`.
2. Comprueba que aparece en Node Exporter.
3. Comprueba que aparece en Prometheus.
4. Cambia su valor a `0`.
5. Explica qué podría significar cada valor.
6. Elimina el fichero y comprueba cuándo desaparece la métrica.

---

## Sesión 10: revisar los registros

### Objetivo

Consultar los registros del servicio y reconocer mensajes habituales.

Consultar los últimos registros:

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  -n 50
```

Seguir los registros:

```bash
sudo journalctl -u node_exporter -f
```

Consultar únicamente errores:

```bash
sudo journalctl -u node_exporter \
  -p err \
  --no-pager
```

Consultar los registros del último arranque:

```bash
sudo journalctl -u node_exporter \
  -b \
  --no-pager
```

### Actividades

1. Consulta los últimos registros.
2. Identifica la dirección de escucha.
3. Identifica los collectors habilitados, si aparecen.
4. Busca errores.
5. Guarda los registros como evidencia.

---

# Diagnóstico de problemas

## El servicio no inicia

Consultar el estado:

```bash
sudo systemctl status node_exporter
```

Consultar los registros:

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  -n 100
```

Comprobar el binario:

```bash
ls -l /usr/local/bin/node_exporter
```

Probar el binario manualmente:

```bash
/usr/local/bin/node_exporter --version
```

Comprobar la unidad:

```bash
systemctl cat node_exporter
```

Posibles causas:

- Ruta incorrecta del binario.
- Usuario inexistente.
- Error en la unidad.
- Puerto ocupado.
- Opción incorrecta.
- Permisos insuficientes.
- Arquitectura incorrecta.

## El puerto `9100` está ocupado

Identificar el proceso:

```bash
sudo ss -lntp | grep ':9100'
```

También:

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

No detener un proceso desconocido sin identificarlo antes.

## El endpoint `/metrics` no responde

Comprobar el servicio:

```bash
systemctl is-active node_exporter
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9100'
```

Probar con detalle:

```bash
curl -v http://localhost:9100/metrics
```

Consultar los registros:

```bash
sudo journalctl -u node_exporter \
  --no-pager \
  -n 50
```

## Prometheus muestra Node Exporter como `DOWN`

Comprobar Node Exporter:

```bash
systemctl is-active node_exporter
```

Probar directamente:

```bash
curl http://localhost:9100/metrics
```

Comprobar el target:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '
    .data.activeTargets[]
    | select(.labels.job == "node_exporter")
    | [
        .health,
        .scrapeUrl,
        .lastError
      ]
    | @tsv
  '
```

Revisar la configuración:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

Posibles causas:

- Puerto incorrecto.
- Nombre de host incorrecto.
- Servicio detenido.
- Error de red.
- Cortafuegos.
- Prometheus no se ha reiniciado.
- Error de indentación YAML.

## El usuario de servicio no puede iniciar Node Exporter

Comprobar que existe:

```bash
getent passwd node_exporter
```

Comprobar la unidad:

```bash
systemctl show node_exporter \
  -p User \
  -p Group \
  -p ExecStart
```

Probar el binario como el usuario:

```bash
sudo -u node_exporter \
  /usr/local/bin/node_exporter \
  --version
```

## El textfile collector no muestra la métrica

Comprobar la opción:

```bash
systemctl show node_exporter -p ExecStart
```

Comprobar el directorio:

```bash
sudo ls -la /var/lib/node_exporter/textfile_collector
```

Comprobar permisos:

```bash
sudo -u node_exporter \
  test -r /var/lib/node_exporter/textfile_collector/laboratorio_estado.prom \
  && echo "Lectura permitida" \
  || echo "Lectura no permitida"
```

Comprobar la sintaxis:

```bash
cat /var/lib/node_exporter/textfile_collector/laboratorio_estado.prom
```

---

# Seguridad

## Usuario sin privilegios

Node Exporter debe ejecutarse con:

```text
node_exporter
```

Comprobar:

```bash
systemctl show node_exporter -p User -p Group
```

## Limitar el acceso al puerto

El puerto `9100` no debería quedar expuesto directamente a Internet.

Se recomienda:

- Permitir el acceso únicamente desde el servidor Prometheus.
- Utilizar reglas de cortafuegos.
- Mantener Node Exporter dentro de una red de administración.
- No publicar `/metrics` sin necesidad.
- No incluir secretos en métricas personalizadas.
- Revisar las interfaces de escucha.

## Comprobar el cortafuegos

```bash
sudo ufw status verbose
```

Si el laboratorio requiere permitir el acceso únicamente desde Prometheus:

```bash
sudo ufw allow from <IP-DE-PROMETHEUS> to any port 9100 proto tcp
```

Sustituir `<IP-DE-PROMETHEUS>` por la dirección real del servidor de Prometheus.

> Las reglas del cortafuegos deben adaptarse al entorno. No se deben ejecutar de forma automática en un servidor remoto sin conocer previamente el acceso disponible.

---

# Informe de instalación

Crear un directorio de evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias
```

Generar un informe:

```bash
{
  echo "===== INSTALACIÓN DE NODE EXPORTER ====="
  echo "Fecha: $(date)"
  echo
  echo "===== SISTEMA ====="
  echo "Hostname: $(hostname)"
  echo "Sistema: $(lsb_release -ds)"
  echo "Arquitectura: $(uname -m)"
  echo "Kernel: $(uname -r)"
  echo
  echo "===== VERSION ====="
  node_exporter --version 2>&1
  echo
  echo "===== SERVICIO ====="
  systemctl is-enabled node_exporter
  systemctl is-active node_exporter
  echo
  echo "===== USUARIO ====="
  systemctl show node_exporter -p User -p Group
  echo
  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':9100' || true
  echo
  echo "===== ENDPOINT ====="
  curl -I http://localhost:9100/metrics 2>&1 || true
} | tee ~/laboratorio-grafana/evidencias/instalacion-node-exporter.txt
```

Consultar el informe:

```bash
cat ~/laboratorio-grafana/evidencias/instalacion-node-exporter.txt
```

Guardar una muestra de las métricas:

```bash
curl -s http://localhost:9100/metrics \
  > ~/laboratorio-grafana/evidencias/node-exporter-metrics.txt
```

Guardar solo métricas del sistema:

```bash
grep '^node_' \
  ~/laboratorio-grafana/evidencias/node-exporter-metrics.txt \
  > ~/laboratorio-grafana/evidencias/node-exporter-system-metrics.txt
```

---

# Ejemplo de sesión completa

```console
$ uname -m
x86_64

$ sudo useradd --system --no-create-home \
    --shell /usr/sbin/nologin node_exporter

$ export NODE_EXPORTER_VERSION="1.8.2"
$ export NODE_EXPORTER_ARCH="amd64"
$ export NODE_EXPORTER_PLATFORM="linux-${NODE_EXPORTER_ARCH}"
$ export NODE_EXPORTER_PACKAGE="node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}.tar.gz"
$ export NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_PACKAGE}"

$ cd /tmp
$ curl -fLO "$NODE_EXPORTER_URL"

$ tar -xzf "$NODE_EXPORTER_PACKAGE"

$ sudo install -m 0755 \
    "/tmp/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_PLATFORM}/node_exporter" \
    /usr/local/bin/node_exporter

$ node_exporter --version
node_exporter, version 1.8.2

$ sudo systemctl daemon-reload
$ sudo systemctl enable node_exporter
$ sudo systemctl start node_exporter

$ systemctl is-active node_exporter
active

$ sudo ss -lntp | grep ':9100'
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=...,fd=...))

$ curl -I http://localhost:9100/metrics
HTTP/1.1 200 OK

$ curl -s http://localhost:9100/metrics \
    | grep '^node_memory_MemAvailable_bytes'
node_memory_MemAvailable_bytes 2.414534656e+09
```

Después de configurar Prometheus:

```console
$ curl -s http://localhost:9090/api/v1/targets \
    | jq -r '
      .data.activeTargets[]
      | [.labels.job, .labels.instance, .health]
      | @tsv
    '
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

---

# Actividad integradora

## Objetivo

Instalar Node Exporter, comprobar sus métricas y conectarlo con Prometheus.

## Tareas

1. Comprobar la arquitectura del sistema.
2. Comprobar que el puerto `9100` está disponible.
3. Crear el usuario `node_exporter`.
4. Descargar la versión indicada.
5. Instalar el binario.
6. Crear el servicio `systemd`.
7. Habilitar el inicio automático.
8. Iniciar Node Exporter.
9. Comprobar el estado.
10. Comprobar el puerto.
11. Consultar `/metrics`.
12. Localizar métricas de CPU, memoria, disco y red.
13. Configurar Prometheus.
14. Validar el fichero YAML.
15. Reiniciar Prometheus.
16. Comprobar el target.
17. Consultar `up{job="node_exporter"}`.
18. Guardar las evidencias.

## Resultado esperado

```text
Usuario de servicio: node_exporter
Servicio: activo
Inicio automático: habilitado
Puerto: 9100
Endpoint /metrics: accesible
Target en Prometheus: up
Métricas de sistema: disponibles
```

---

# Puntos clave

- Node Exporter expone métricas del sistema operativo.
- El endpoint habitual es `/metrics`.
- El puerto habitual es `9100`.
- Node Exporter no almacena métricas.
- Prometheus consulta Node Exporter mediante *scraping*.
- El servicio debe ejecutarse con un usuario sin privilegios.
- El usuario de servicio no debe tener acceso interactivo.
- `systemd` permite iniciar y controlar Node Exporter.
- `curl` permite comprobar el endpoint HTTP.
- Las métricas de sistema suelen comenzar por `node_`.
- `node_cpu_seconds_total` es una métrica acumulativa de CPU.
- `node_memory_MemAvailable_bytes` representa memoria disponible.
- `node_filesystem_avail_bytes` representa espacio disponible.
- `node_network_receive_bytes_total` representa bytes recibidos.
- El estado `up` permite comprobar el resultado del *scraping*.
- El puerto `9100` debe protegerse mediante red o cortafuegos.
- La configuración de Prometheus debe validarse antes de reiniciar.
- El *textfile collector* permite exponer métricas personalizadas.
- Los registros de `systemd` ayudan a diagnosticar errores.
- Una métrica visible directamente en Node Exporter puede tardar unos segundos en aparecer en Prometheus.

---

# Preguntas de comprobación

1. ¿Qué función cumple Node Exporter?
2. ¿Qué puerto utiliza normalmente Node Exporter?
3. ¿Cuál es el endpoint principal de métricas?
4. ¿Qué componente consulta normalmente a Node Exporter?
5. ¿Node Exporter almacena las métricas?
6. ¿Qué usuario debe ejecutar el servicio?
7. ¿Por qué se utiliza `/usr/sbin/nologin`?
8. ¿Qué comando permite consultar la versión instalada?
9. ¿Qué comando permite consultar el estado del servicio?
10. ¿Qué comando permite comprobar el puerto `9100`?
11. ¿Qué comando permite consultar las primeras métricas?
12. ¿Qué prefijo tienen normalmente las métricas del sistema?
13. ¿Qué información proporciona `node_cpu_seconds_total`?
14. ¿Qué información proporciona `node_memory_MemAvailable_bytes`?
15. ¿Qué información proporciona `node_filesystem_avail_bytes`?
16. ¿Qué información proporciona `node_network_receive_bytes_total`?
17. ¿Qué significa que el objetivo aparezca como `up`?
18. ¿Qué puede provocar que Node Exporter aparezca como `down`?
19. ¿Cómo comprobarías si el puerto `9100` está ocupado?
20. ¿Cómo consultarías los registros de Node Exporter?
21. ¿Qué función cumple el *textfile collector*?
22. ¿Por qué no se debe exponer el puerto `9100` directamente a Internet?
23. ¿Qué debes hacer después de modificar una unidad de `systemd`?
24. ¿Por qué se valida la configuración de Prometheus antes de reiniciarlo?
25. ¿Qué diferencia existe entre consultar directamente Node Exporter y consultar Prometheus?

---

# Criterios de finalización

La práctica se considera completada cuando:

- Se ha comprobado la arquitectura del sistema.
- Se ha comprobado que el puerto `9100` estaba disponible.
- Existe el usuario `node_exporter`.
- El usuario utiliza `/usr/sbin/nologin`.
- El binario está instalado en `/usr/local/bin`.
- La versión instalada se ha registrado.
- Existe la unidad `node_exporter.service`.
- El servicio está habilitado.
- El servicio está activo.
- El proceso se ejecuta como `node_exporter`.
- El puerto `9100` está en escucha.
- `/metrics` responde correctamente.
- Se han localizado métricas de CPU.
- Se han localizado métricas de memoria.
- Se han localizado métricas de disco.
- Se han localizado métricas de red.
- Prometheus tiene configurado el target.
- El target aparece como `up`.
- La consulta `up{job="node_exporter"}` devuelve `1`.
- Se han guardado las evidencias de la instalación.

La comprobación final puede ejecutarse con:

```bash
printf '%-40s %s\n' \
  "Servicio activo" \
  "$(systemctl is-active node_exporter)"

printf '%-40s %s\n' \
  "Inicio automático" \
  "$(systemctl is-enabled node_exporter)"

printf '%-40s ' \
  "Usuario de ejecución"
systemctl show node_exporter -p User --value

printf '%-40s ' \
  "Endpoint /metrics"
curl -fsS http://localhost:9100/metrics \
  >/dev/null \
  && echo "accesible" \
  || echo "no accesible"

printf '%-40s ' \
  "Puerto 9100"
sudo ss -lnt '( sport = :9100 )' \
  | grep -q LISTEN \
  && echo "en escucha" \
  || echo "no disponible"

printf '%-40s ' \
  "Métrica de memoria"
curl -fsS http://localhost:9100/metrics \
  | grep -q '^node_memory_MemAvailable_bytes' \
  && echo "disponible" \
  || echo "no disponible"
```

Resultado esperado:

```text
Servicio activo                         active
Inicio automático                       enabled
Usuario de ejecución                    node_exporter
Endpoint /metrics                       accesible
Puerto 9100                             en escucha
Métrica de memoria                      disponible
```

El flujo completo que debe comprender el alumno es:

```text
Sistema operativo
        |
        v
Node Exporter recopila información
        |
        v
Endpoint HTTP /metrics
        |
        v
Prometheus realiza scraping
        |
        v
Métrica up = 1
        |
        v
PromQL consulta las métricas
        |
        v
Grafana visualiza los resultados
```