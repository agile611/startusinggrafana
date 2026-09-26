# Instalación de Prometheus mediante binarios

Prometheus es el componente central del sistema de monitorización que se construirá durante este bloque.

En esta práctica se instalará Prometheus como un servicio de `systemd`, se configurará su almacenamiento local y se comprobará que responde correctamente mediante la interfaz web, la API HTTP y los endpoints de salud.

La instalación seguirá este recorrido:

```text
Comprobación del sistema
        |
        v
Descarga del binario
        |
        v
Creación del usuario de servicio
        |
        v
Creación de directorios
        |
        v
Instalación de los binarios
        |
        v
Instalación de la configuración
        |
        v
Creación del servicio systemd
        |
        v
Inicio del servicio
        |
        v
Comprobaciones
```

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Identificar los requisitos necesarios para instalar Prometheus.
- Consultar la arquitectura del sistema operativo.
- Descargar una versión concreta de Prometheus.
- Crear un usuario de servicio sin acceso interactivo.
- Crear los directorios de configuración y almacenamiento.
- Instalar los binarios de Prometheus y `promtool`.
- Crear un fichero básico `prometheus.yml`.
- Validar una configuración de Prometheus.
- Crear una unidad de `systemd`.
- Iniciar, detener y reiniciar Prometheus.
- Habilitar Prometheus para que se inicie automáticamente.
- Comprobar el puerto de escucha.
- Consultar el endpoint de salud.
- Consultar el endpoint de preparación.
- Acceder a la interfaz web.
- Consultar los registros del servicio.
- Diagnosticar errores básicos de instalación y configuración.
- Documentar las evidencias de la instalación.

---

## Introducción

Prometheus puede instalarse mediante paquetes, contenedores o binarios precompilados.

En este laboratorio se utilizará el binario oficial distribuido como archivo comprimido. Este método permite:

- Elegir una versión concreta.
- Mantener separadas la aplicación, la configuración y los datos.
- Comprender qué componentes forman la instalación.
- Crear manualmente el servicio de `systemd`.
- Practicar la administración de servicios Linux.

La instalación resultante tendrá esta estructura:

```text
/usr/local/bin/
├── prometheus
└── promtool

/etc/prometheus/
├── prometheus.yml
├── consoles/
└── console_libraries/

/var/lib/prometheus/
└── Datos de series temporales

/etc/systemd/system/
└── prometheus.service
```

El servicio se ejecutará con el usuario:

```text
prometheus
```

El puerto web habitual será:

```text
9090
```

La URL local será:

```text
http://localhost:9090
```

---

## Arquitectura de la instalación

```text
+------------------------------------------------------+
| Servidor Ubuntu                                      |
|                                                      |
|  Usuario de servicio: prometheus                    |
|                                                      |
|  /usr/local/bin/prometheus                           |
|  /usr/local/bin/promtool                             |
|                                                      |
|  Configuración: /etc/prometheus/prometheus.yml      |
|  Datos:        /var/lib/prometheus                   |
|                                                      |
|  Servicio systemd: prometheus.service                |
|  Interfaz web:    http://localhost:9090              |
+------------------------------------------------------+
```

### Directorios principales

| Directorio | Función |
|---|---|
| `/usr/local/bin` | Binarios ejecutables |
| `/etc/prometheus` | Configuración y recursos web |
| `/var/lib/prometheus` | Datos almacenados por Prometheus |
| `/etc/systemd/system` | Unidad de servicio |

---

## Requisitos previos

Antes de comenzar, comprobar que se dispone de:

- Ubuntu instalado.
- Arquitectura compatible.
- Usuario con permisos de `sudo`.
- Conectividad a Internet.
- Al menos 2 GB de memoria disponible.
- Espacio libre suficiente.
- Puerto `9090` disponible.
- Hora del sistema sincronizada.

### Comprobar la distribución

```bash
lsb_release -ds
```

También puede utilizarse:

```bash
cat /etc/os-release
```

### Comprobar la arquitectura

```bash
uname -m
```

Arquitecturas habituales:

```text
x86_64
aarch64
armv7l
```

Prometheus utiliza nombres de arquitectura diferentes para los paquetes:

| Salida de `uname -m` | Arquitectura del paquete |
|---|---|
| `x86_64` | `amd64` |
| `aarch64` | `arm64` |
| `armv7l` | `armv7` |

En esta práctica se utilizará principalmente `amd64`.

### Comprobar permisos administrativos

```bash
sudo -v
```

### Comprobar el espacio disponible

```bash
df -h /
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090' || true
```

Si no aparece ninguna salida, el puerto probablemente está disponible.

### Comprobar la hora

```bash
timedatectl status
```

Comprobar la sincronización:

```bash
timedatectl show -p NTPSynchronized --value
```

Resultado esperado:

```text
yes
```

---

## Preparar las variables de instalación

Para evitar repetir valores, se definirán algunas variables.

> Sustituye la versión de ejemplo por la versión autorizada para el laboratorio.

```bash
export PROMETHEUS_VERSION="3.5.0"
export PROMETHEUS_ARCH="amd64"
export PROMETHEUS_PLATFORM="linux-${PROMETHEUS_ARCH}"
export PROMETHEUS_PACKAGE="prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_PLATFORM}.tar.gz"
export PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_PACKAGE}"
export PROMETHEUS_DIR="/tmp/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_PLATFORM}"
```

Comprobar las variables:

```bash
echo "$PROMETHEUS_VERSION"
echo "$PROMETHEUS_PLATFORM"
echo "$PROMETHEUS_PACKAGE"
echo "$PROMETHEUS_URL"
echo "$PROMETHEUS_DIR"
```

Ejemplo:

```console
$ echo "$PROMETHEUS_PACKAGE"
prometheus-3.5.0.linux-amd64.tar.gz
```

### Comprobar la URL de descarga

```bash
curl -I "$PROMETHEUS_URL"
```

La respuesta debe indicar que el recurso existe. Si devuelve un error `404`, revisa la versión, la arquitectura y el nombre del archivo.

### Descargar el paquete

```bash
cd /tmp
curl -fLO "$PROMETHEUS_URL"
```

Comprobar que el archivo existe:

```bash
ls -lh "/tmp/$PROMETHEUS_PACKAGE"
```

---

## Crear el usuario de servicio

Prometheus no debería ejecutarse con el usuario personal del alumno ni como `root`.

Crear el usuario de forma segura:

```bash
if ! getent passwd prometheus >/dev/null; then
  sudo useradd \
    --system \
    --no-create-home \
    --shell /usr/sbin/nologin \
    prometheus
fi
```

Comprobar la cuenta:

```bash
getent passwd prometheus
```

Ejemplo:

```console
$ getent passwd prometheus
prometheus:x:995:995::/home/prometheus:/usr/sbin/nologin
```

### Explicación de las opciones

| Opción | Función |
|---|---|
| `--system` | Crea un usuario de sistema |
| `--no-create-home` | No crea un directorio personal |
| `--shell /usr/sbin/nologin` | Impide el inicio de sesión interactivo |

Comprobar el identificador:

```bash
id prometheus
```

Resultado esperado:

```text
uid=995(prometheus) gid=995(prometheus) groups=995(prometheus)
```

Comprobar el shell:

```bash
getent passwd prometheus | cut -d: -f7
```

Resultado esperado:

```text
/usr/sbin/nologin
```

---

## Crear los directorios

Crear el directorio de configuración:

```bash
sudo mkdir -p /etc/prometheus
```

Crear el directorio de datos:

```bash
sudo mkdir -p /var/lib/prometheus
```

Crear los directorios para las plantillas y las consolas:

```bash
sudo mkdir -p \
  /etc/prometheus/consoles \
  /etc/prometheus/console_libraries
```

### Función de cada directorio

| Directorio | Uso |
|---|---|
| `/etc/prometheus` | Configuración de Prometheus |
| `/etc/prometheus/consoles` | Consolas web |
| `/etc/prometheus/console_libraries` | Bibliotecas de las consolas |
| `/var/lib/prometheus` | Base de datos local de series temporales |

---

## Extraer el paquete

Extraer el archivo descargado:

```bash
cd /tmp
tar -xzf "$PROMETHEUS_PACKAGE"
```

Comprobar el directorio creado:

```bash
ls -ld "$PROMETHEUS_DIR"
```

Listar su contenido:

```bash
find "$PROMETHEUS_DIR" \
  -maxdepth 2 \
  -type f \
  -printf '%P\n'
```

El paquete contiene normalmente:

```text
prometheus
promtool
prometheus.yml
consoles/
console_libraries/
LICENSE
NOTICE
```

---

## Instalar los binarios

Instalar el binario de Prometheus:

```bash
sudo install \
  -m 0755 \
  "$PROMETHEUS_DIR/prometheus" \
  /usr/local/bin/prometheus
```

Instalar `promtool`:

```bash
sudo install \
  -m 0755 \
  "$PROMETHEUS_DIR/promtool" \
  /usr/local/bin/promtool
```

Comprobar las versiones:

```bash
prometheus --version
```

```bash
promtool --version
```

Ejemplo:

```console
$ prometheus --version
prometheus, version 3.5.0
  branch: release-3.5
  revision: ...
  build user: ...
  build date: ...
  go version: ...
  platform: linux/amd64
```

Comprobar la ubicación de los binarios:

```bash
command -v prometheus
command -v promtool
```

Resultado esperado:

```text
/usr/local/bin/prometheus
/usr/local/bin/promtool
```

---

## Instalar los recursos de configuración

Copiar el fichero de configuración de ejemplo:

```bash
sudo install \
  -m 0644 \
  "$PROMETHEUS_DIR/prometheus.yml" \
  /etc/prometheus/prometheus.yml
```

Copiar las consolas:

```bash
sudo cp -r \
  "$PROMETHEUS_DIR/consoles/." \
  /etc/prometheus/consoles/
```

Copiar las bibliotecas:

```bash
sudo cp -r \
  "$PROMETHEUS_DIR/console_libraries/." \
  /etc/prometheus/console_libraries/
```

Comprobar el contenido:

```bash
sudo find /etc/prometheus -maxdepth 2 -type f
```

---

## Crear una configuración inicial

Antes de conectar Node Exporter, se utilizará una configuración mínima.

### Crear una copia de seguridad

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.orig
```

### Crear la configuración

```bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
---
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
EOF
```

Mostrar el contenido:

```bash
sudo cat /etc/prometheus/prometheus.yml
```

La configuración será:

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
```

### Explicación de la configuración

#### Bloque `global`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

- `scrape_interval`: intervalo entre recopilaciones.
- `evaluation_interval`: intervalo de evaluación de reglas.

#### Bloque `scrape_configs`

```yaml
scrape_configs:
```

Contiene los trabajos de recopilación.

#### Propiedad `job_name`

```yaml
job_name: prometheus
```

Identifica el trabajo de monitorización.

#### Propiedad `targets`

```yaml
targets:
  - localhost:9090
```

Define el endpoint que Prometheus debe consultar.

---

## Validar la configuración

Antes de iniciar el servicio, validar el fichero:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax
```

El mensaje exacto puede variar según la versión, pero debe indicar que la configuración es válida.

### Validar también la sintaxis YAML

Si `yamllint` está instalado:

```bash
yamllint /etc/prometheus/prometheus.yml
```

`yamllint` comprueba la sintaxis general de YAML. `promtool` comprueba además que la estructura sea válida para Prometheus.

### Practicar con un error de YAML

Crear una copia incorrecta:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  /tmp/prometheus.yml.incorrecto
```

Editar la copia:

```bash
sudo nano /tmp/prometheus.yml.incorrecto
```

Introducir, por ejemplo, una indentación incorrecta:

```yaml
---
global:
  scrape_interval: 15s
 evaluation_interval: 15s
```

Validar el fichero incorrecto:

```bash
promtool check config /tmp/prometheus.yml.incorrecto
```

El comando debe informar de un error de sintaxis.

Restaurar la configuración correcta si fuera necesario:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml.orig \
  /etc/prometheus/prometheus.yml
```

Volver a validar:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

---

## Configurar los permisos

El usuario `prometheus` debe poder leer la configuración y escribir en el directorio de datos.

### Asignar la propiedad de los datos

```bash
sudo chown -R \
  prometheus:prometheus \
  /var/lib/prometheus
```

### Asignar la propiedad de la configuración

```bash
sudo chown -R \
  root:prometheus \
  /etc/prometheus
```

### Configurar los permisos

```bash
sudo find /etc/prometheus \
  -type d \
  -exec chmod 0750 {} \;
```

```bash
sudo find /etc/prometheus \
  -type f \
  -exec chmod 0640 {} \;
```

Comprobar los permisos:

```bash
sudo ls -ld \
  /etc/prometheus \
  /var/lib/prometheus
```

Comprobar el fichero principal:

```bash
sudo ls -l /etc/prometheus/prometheus.yml
```

Comprobar que el usuario puede escribir en el directorio de datos:

```bash
sudo -u prometheus test -w /var/lib/prometheus \
  && echo "El usuario puede escribir en el directorio de datos" \
  || echo "El usuario no puede escribir en el directorio de datos"
```

Comprobar que puede leer la configuración:

```bash
sudo -u prometheus test -r /etc/prometheus/prometheus.yml \
  && echo "El usuario puede leer la configuración" \
  || echo "El usuario no puede leer la configuración"
```

---

## Crear el servicio de systemd

Crear la unidad:

```bash
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Monitoring
Documentation=https://prometheus.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple

ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=on-failure
RestartSec=5s

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF
```

### Explicación de las opciones

| Opción | Función |
|---|---|
| `User=prometheus` | Ejecuta el proceso con el usuario de servicio |
| `Group=prometheus` | Utiliza el grupo del servicio |
| `ExecStart` | Define el comando de inicio |
| `--config.file` | Indica el fichero de configuración |
| `--storage.tsdb.path` | Indica dónde guardar los datos |
| `--web.console.templates` | Indica las plantillas web |
| `--web.console.libraries` | Indica las bibliotecas web |
| `Restart=on-failure` | Reinicia el servicio si termina con error |
| `ProtectSystem=strict` | Reduce las posibilidades de modificar el sistema |
| `ProtectHome=true` | Protege los directorios personales |
| `ReadWritePaths` | Permite escribir en el directorio de datos |

> Las opciones de protección de `systemd` pueden variar según la distribución y su versión. Si el servicio no inicia, consulta primero los registros antes de modificar la unidad.

---

## Recargar la configuración de systemd

Después de crear o modificar una unidad, recargar la configuración:

```bash
sudo systemctl daemon-reload
```

Comprobar que la unidad se reconoce:

```bash
systemctl cat prometheus
```

Consultar la configuración resumida:

```bash
systemctl show prometheus \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath
```

---

## Iniciar Prometheus

Iniciar el servicio:

```bash
sudo systemctl start prometheus
```

Consultar el estado:

```bash
sudo systemctl status prometheus --no-pager
```

Resultado esperado:

```text
● prometheus.service - Prometheus Monitoring
     Loaded: loaded (...)
     Active: active (running)
```

Comprobar mediante un comando breve:

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

### Habilitar el inicio automático

```bash
sudo systemctl enable prometheus
```

Comprobar:

```bash
systemctl is-enabled prometheus
```

Resultado esperado:

```text
enabled
```

### Comandos habituales

Detener:

```bash
sudo systemctl stop prometheus
```

Iniciar:

```bash
sudo systemctl start prometheus
```

Reiniciar:

```bash
sudo systemctl restart prometheus
```

Consultar el estado:

```bash
sudo systemctl status prometheus
```

---

## Verificar el puerto de escucha

Comprobar que Prometheus escucha en el puerto `9090`:

```bash
sudo ss -lntp | grep ':9090'
```

Ejemplo:

```text
LISTEN 0 4096 0.0.0.0:9090 0.0.0.0:* users:(("prometheus",pid=...,fd=...))
```

También puede consultarse el proceso:

```bash
ps -ef | grep '[p]rometheus'
```

Ejemplo:

```text
prometheus  1234  1  0 16:20 ?  00:00:02 /usr/local/bin/prometheus ...
```

---

## Comprobar los endpoints HTTP

### Endpoint principal

```bash
curl -I http://localhost:9090
```

### Endpoint de salud

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Endpoint de preparación

```bash
curl http://localhost:9090/-/ready
```

Resultado esperado:

```text
Prometheus is Ready.
```

### Información de versión

Si `jq` está instalado:

```bash
curl -s http://localhost:9090/api/v1/status/buildinfo | jq
```

Sin `jq`:

```bash
curl -s http://localhost:9090/api/v1/status/buildinfo
```

### Consultar la métrica `up`

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

Al principio debería aparecer el objetivo de Prometheus:

```text
up{instance="localhost:9090",job="prometheus"} 1
```

---

## Acceder a la interfaz web

Abrir desde el propio servidor:

```text
http://localhost:9090
```

Desde otro equipo de la red:

```text
http://IP_DEL_SERVIDOR:9090
```

Ejemplo:

```text
http://192.168.1.50:9090
```

Desde la interfaz web se pueden consultar:

- Expresiones PromQL.
- Series temporales.
- Objetivos.
- Reglas.
- Configuración.
- Estado del servicio.
- Información de compilación.

### Primera consulta

Ejecutar:

```promql
up
```

Otras consultas iniciales:

```promql
prometheus_build_info
```

```promql
process_resident_memory_bytes
```

```promql
prometheus_tsdb_head_series
```

---

## Consultar los registros

Consultar los últimos registros:

```bash
sudo journalctl -u prometheus --no-pager -n 50
```

Seguir los registros en tiempo real:

```bash
sudo journalctl -u prometheus -f
```

Consultar los registros desde el último arranque:

```bash
sudo journalctl -u prometheus -b --no-pager
```

Mostrar únicamente los errores:

```bash
sudo journalctl -u prometheus \
  -p err \
  --no-pager
```

Consultar los registros de los últimos diez minutos:

```bash
sudo journalctl -u prometheus \
  --since "10 minutes ago" \
  --no-pager
```

---

## Añadir Node Exporter posteriormente

En esta práctica se instala inicialmente Prometheus con su propio objetivo.

Cuando Node Exporter esté instalado, se añadirá un segundo trabajo.

### Configuración

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
```

### Validar y aplicar la configuración

```bash
promtool check config /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Comprobar los objetivos

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

Comprobar desde PromQL:

```promql
up
```

```promql
up{job="node_exporter"}
```

---

# Sesiones prácticas

## Sesión 1: preparar el sistema

### Objetivo

Comprobar que el sistema cumple los requisitos previos.

### Comandos

```bash
lsb_release -ds
uname -m
nproc
free -h
df -h /
sudo ss -lntp | grep ':9090' || true
timedatectl status
```

### Actividades

1. Anota la versión de Ubuntu.
2. Anota la arquitectura.
3. Anota el número de CPUs.
4. Anota la memoria disponible.
5. Anota el espacio libre.
6. Comprueba que el puerto `9090` está disponible.
7. Comprueba que el reloj está sincronizado.

---

## Sesión 2: crear el usuario y los directorios

### Objetivo

Crear la base de la instalación.

### Comandos

```bash
if ! getent passwd prometheus >/dev/null; then
  sudo useradd \
    --system \
    --no-create-home \
    --shell /usr/sbin/nologin \
    prometheus
fi
```

```bash
sudo mkdir -p \
  /etc/prometheus \
  /var/lib/prometheus
```

```bash
sudo chown -R \
  prometheus:prometheus \
  /var/lib/prometheus
```

### Comprobaciones

```bash
getent passwd prometheus
```

```bash
sudo ls -ld \
  /etc/prometheus \
  /var/lib/prometheus
```

### Actividades

1. Comprueba que existe el usuario.
2. Comprueba su shell.
3. Comprueba los directorios.
4. Explica por qué Prometheus necesita escribir en `/var/lib/prometheus`.
5. Explica por qué la configuración debe estar separada de los datos.

---

## Sesión 3: descargar e instalar los binarios

### Objetivo

Instalar `prometheus` y `promtool`.

### Comandos

```bash
export PROMETHEUS_VERSION="3.5.0"
export PROMETHEUS_ARCH="amd64"
export PROMETHEUS_PLATFORM="linux-${PROMETHEUS_ARCH}"
export PROMETHEUS_PACKAGE="prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_PLATFORM}.tar.gz"
export PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_PACKAGE}"
export PROMETHEUS_DIR="/tmp/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_PLATFORM}"
```

```bash
cd /tmp
curl -fLO "$PROMETHEUS_URL"
```

```bash
tar -xzf "$PROMETHEUS_PACKAGE"
```

```bash
sudo install \
  -m 0755 \
  "$PROMETHEUS_DIR/prometheus" \
  /usr/local/bin/prometheus
```

```bash
sudo install \
  -m 0755 \
  "$PROMETHEUS_DIR/promtool" \
  /usr/local/bin/promtool
```

### Comprobaciones

```bash
prometheus --version
```

```bash
promtool --version
```

```bash
command -v prometheus
```

```bash
command -v promtool
```

### Actividades

1. Anota la versión instalada.
2. Anota la arquitectura del binario.
3. Comprueba que los binarios están en `/usr/local/bin`.
4. Explica la función de `promtool`.

---

## Sesión 4: crear y validar la configuración

### Objetivo

Crear una configuración mínima y comprobar su sintaxis.

### Crear el fichero

```bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
---
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
EOF
```

### Validar

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### Actividades

1. Ejecuta la validación.
2. Comprueba que no aparecen errores.
3. Modifica temporalmente la indentación.
4. Vuelve a validar.
5. Corrige el error.
6. Explica por qué la indentación es importante en YAML.

---

## Sesión 5: crear el servicio

### Objetivo

Crear una unidad de `systemd` para gestionar Prometheus.

### Crear la unidad

```bash
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Monitoring
Documentation=https://prometheus.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple

ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=on-failure
RestartSec=5s

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF
```

### Recargar y habilitar

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl enable prometheus
```

```bash
sudo systemctl start prometheus
```

### Comprobar

```bash
systemctl is-enabled prometheus
```

```bash
systemctl is-active prometheus
```

```bash
sudo systemctl status prometheus --no-pager
```

### Actividades

1. Comprueba que la unidad existe.
2. Comprueba que está habilitada.
3. Comprueba que el servicio está activo.
4. Consulta el usuario de ejecución:

```bash
systemctl show prometheus -p User -p Group
```

5. Consulta el comando de inicio:

```bash
systemctl show prometheus -p ExecStart
```

---

## Sesión 6: verificar la instalación

### Objetivo

Comprobar Prometheus desde la terminal.

### Comandos

```bash
sudo ss -lntp | grep ':9090'
```

```bash
curl http://localhost:9090/-/healthy
```

```bash
curl http://localhost:9090/-/ready
```

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Ejemplo de sesión

```console
$ systemctl is-active prometheus
active

$ curl http://localhost:9090/-/healthy
Prometheus is Healthy.

$ curl http://localhost:9090/-/ready
Prometheus is Ready.

$ curl -sG http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    | jq -r '.data.result[] | [.metric.job, .value[1]] | @tsv'
prometheus      1
```

### Actividades

1. Comprueba el estado del servicio.
2. Comprueba el endpoint de salud.
3. Comprueba el endpoint de preparación.
4. Ejecuta la consulta `up`.
5. Explica el valor `1`.
6. Accede a la interfaz web desde un navegador.

---

## Sesión 7: modificar la configuración de forma segura

### Objetivo

Aprender a modificar la configuración y reiniciar el servicio de forma controlada.

Crear una copia:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%Y%m%d-%H%M%S).bak"
```

Editar:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Validar:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Si la validación es correcta, reiniciar:

```bash
sudo systemctl restart prometheus
```

Comprobar:

```bash
systemctl is-active prometheus
```

Consultar los registros:

```bash
sudo journalctl -u prometheus \
  --since "1 minute ago" \
  --no-pager
```

### Actividades

1. Crea una copia de seguridad.
2. Añade un comentario al fichero YAML.
3. Valida la configuración.
4. Reinicia Prometheus.
5. Comprueba que continúa activo.
6. Consulta los registros.

---

# Diagnóstico de problemas

## El servicio no inicia

Consultar el estado:

```bash
sudo systemctl status prometheus --no-pager
```

Consultar los registros:

```bash
sudo journalctl -u prometheus \
  --no-pager \
  -n 100
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Comprobar la existencia de los binarios:

```bash
ls -l /usr/local/bin/prometheus
ls -l /usr/local/bin/promtool
```

Comprobar los directorios:

```bash
sudo ls -ld \
  /etc/prometheus \
  /var/lib/prometheus
```

## Error de permisos en el directorio de datos

Comprobar el propietario:

```bash
sudo stat -c '%U:%G %A %n' \
  /var/lib/prometheus
```

Corregir:

```bash
sudo chown -R \
  prometheus:prometheus \
  /var/lib/prometheus
```

Comprobar la escritura:

```bash
sudo -u prometheus \
  test -w /var/lib/prometheus \
  && echo "Escritura permitida" \
  || echo "Escritura no permitida"
```

## Error de permisos en la configuración

Comprobar la lectura:

```bash
sudo -u prometheus \
  test -r /etc/prometheus/prometheus.yml \
  && echo "Lectura permitida" \
  || echo "Lectura no permitida"
```

Corregir propietario y permisos:

```bash
sudo chown root:prometheus \
  /etc/prometheus/prometheus.yml
```

```bash
sudo chmod 0640 \
  /etc/prometheus/prometheus.yml
```

## El puerto `9090` está ocupado

Identificar el proceso:

```bash
sudo ss -lntp | grep ':9090'
```

También:

```bash
sudo lsof -nP -iTCP:9090 -sTCP:LISTEN
```

No detengas el proceso sin identificarlo previamente.

## El servicio aparece activo, pero no responde

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9090'
```

Probar localmente:

```bash
curl -v http://localhost:9090/-/healthy
```

Comprobar los registros:

```bash
sudo journalctl -u prometheus --no-pager -n 100
```

Comprobar que `ExecStart` es correcto:

```bash
systemctl show prometheus -p ExecStart
```

## La URL de descarga devuelve un error

Comprobar las variables:

```bash
echo "$PROMETHEUS_VERSION"
echo "$PROMETHEUS_ARCH"
echo "$PROMETHEUS_PACKAGE"
echo "$PROMETHEUS_URL"
```

Comprobar la respuesta:

```bash
curl -I "$PROMETHEUS_URL"
```

Posibles causas:

- Versión inexistente.
- Arquitectura incorrecta.
- Error en el nombre del paquete.
- Problemas de conectividad.
- Red corporativa o proxy.
- URL no autorizada en el laboratorio.

## `promtool` indica un error de configuración

Mostrar el fichero con números de línea:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml
```

Validar de nuevo:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Revisar especialmente:

- Indentación.
- Dos puntos.
- Guiones de listas.
- Espacios.
- Nombres de propiedades.
- Dirección de los targets.
- Comillas incompletas.
- Tabuladores.

---

# Seguridad y mantenimiento

## Ejecutar con un usuario sin privilegios

El servicio debe ejecutarse como:

```text
prometheus
```

Comprobar:

```bash
systemctl show prometheus -p User -p Group
```

## Proteger el fichero de configuración

Comprobar los permisos:

```bash
sudo stat -c '%A %U:%G %n' \
  /etc/prometheus/prometheus.yml
```

## No exponer Prometheus directamente a Internet

Prometheus no debe publicarse directamente en Internet sin controles adicionales.

Recomendaciones:

- Utilizar un cortafuegos.
- Limitar el acceso a la red de administración.
- Utilizar un proxy inverso cuando sea necesario.
- Aplicar autenticación y autorización.
- No incluir credenciales en ficheros públicos.
- Mantener el software actualizado.
- Revisar los registros.
- Utilizar una VPN cuando corresponda.

## Crear copias de seguridad

Copia de la configuración:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  ~/prometheus.yml.backup
```

Copia de la unidad de servicio:

```bash
sudo cp \
  /etc/systemd/system/prometheus.service \
  ~/prometheus.service.backup
```

> El directorio `/var/lib/prometheus` contiene datos de series temporales. Su copia de seguridad requiere planificación y espacio suficiente.

---

# Informe de instalación

Crear un directorio de evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias
```

Generar un informe:

```bash
{
  echo "===== INSTALACIÓN DE PROMETHEUS ====="
  echo "Fecha: $(date)"
  echo
  echo "===== SISTEMA ====="
  echo "Hostname: $(hostname)"
  echo "Sistema: $(lsb_release -ds)"
  echo "Arquitectura: $(uname -m)"
  echo "Kernel: $(uname -r)"
  echo
  echo "===== VERSIONES ====="
  prometheus --version 2>&1
  promtool --version 2>&1
  echo
  echo "===== SERVICIO ====="
  echo "Inicio automático: $(systemctl is-enabled prometheus 2>/dev/null || echo no-disponible)"
  echo "Estado: $(systemctl is-active prometheus 2>/dev/null || echo no-disponible)"
  echo
  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':9090' || true
  echo
  echo "===== SALUD ====="
  curl -s http://localhost:9090/-/healthy || true
  echo
  echo "===== PREPARACIÓN ====="
  curl -s http://localhost:9090/-/ready || true
  echo
  echo "===== CONFIGURACIÓN ====="
  promtool check config /etc/prometheus/prometheus.yml 2>&1
} | tee ~/laboratorio-grafana/evidencias/instalacion-prometheus.txt
```

Consultar el informe:

```bash
cat ~/laboratorio-grafana/evidencias/instalacion-prometheus.txt
```

---

# Actividad integradora

## Objetivo

Instalar Prometheus como servicio y demostrar que funciona correctamente.

## Tareas

1. Comprobar los requisitos previos.
2. Crear el usuario `prometheus`.
3. Crear los directorios de configuración y datos.
4. Descargar la versión indicada.
5. Instalar `prometheus` y `promtool`.
6. Copiar los recursos de configuración.
7. Crear el fichero `prometheus.yml`.
8. Validar la configuración.
9. Configurar los permisos.
10. Crear la unidad de `systemd`.
11. Recargar la configuración de `systemd`.
12. Habilitar el inicio automático.
13. Iniciar Prometheus.
14. Comprobar el estado del servicio.
15. Comprobar el puerto `9090`.
16. Comprobar `/-/healthy`.
17. Comprobar `/-/ready`.
18. Acceder a la interfaz web.
19. Ejecutar la consulta `up`.
20. Consultar los registros.
21. Guardar las evidencias.

## Resultado esperado

El alumno debe obtener:

```text
Servicio: activo
Inicio automático: habilitado
Puerto: 9090
Endpoint de salud: correcto
Endpoint de preparación: correcto
Interfaz web: accesible
Consulta up: devuelve el objetivo de Prometheus
```

---

# Ejemplo de sesión completa

La siguiente sesión resume una instalación funcional:

```console
$ uname -m
x86_64

$ sudo useradd --system --no-create-home \
    --shell /usr/sbin/nologin prometheus

$ sudo mkdir -p /etc/prometheus /var/lib/prometheus

$ sudo chown -R prometheus:prometheus /var/lib/prometheus

$ prometheus --version
prometheus, version 3.5.0

$ sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
---
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
EOF

$ promtool check config /etc/prometheus/prometheus.yml
Checking /etc/prometheus/prometheus.yml
 SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax

$ sudo systemctl daemon-reload

$ sudo systemctl enable prometheus
Created symlink ...

$ sudo systemctl start prometheus

$ systemctl is-active prometheus
active

$ curl http://localhost:9090/-/healthy
Prometheus is Healthy.

$ curl http://localhost:9090/-/ready
Prometheus is Ready.

$ curl -sG http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    | jq -r '.data.result[] | [.metric.job, .value[1]] | @tsv'
prometheus      1
```

---

# Puntos clave

- Prometheus se instalará como un servicio de `systemd`.
- El binario principal se instalará en `/usr/local/bin/prometheus`.
- `promtool` permite validar configuraciones.
- La configuración principal estará en `/etc/prometheus/prometheus.yml`.
- Los datos se almacenarán en `/var/lib/prometheus`.
- El servicio debe ejecutarse con el usuario `prometheus`.
- El puerto web habitual es el `9090`.
- La configuración debe validarse antes de reiniciar el servicio.
- `systemctl` permite gestionar el servicio.
- `journalctl` permite revisar los registros.
- `/-/healthy` comprueba la salud básica.
- `/-/ready` comprueba si Prometheus está preparado.
- La consulta `up` permite comprobar los objetivos recopilados.
- Los permisos de configuración y datos son fundamentales.
- Un error de YAML puede impedir el inicio del servicio.
- El puerto `9090` debe estar disponible.
- La versión y la arquitectura deben coincidir con el sistema.
- Las copias de seguridad facilitan la recuperación.
- Prometheus no debe exponerse directamente a Internet sin protección.
- La instalación debe documentarse mediante evidencias reproducibles.

---

# Preguntas de comprobación

1. ¿Qué función cumple Prometheus?
2. ¿Qué función cumple `promtool`?
3. ¿Dónde se instala el binario de Prometheus en esta práctica?
4. ¿Dónde se almacena la configuración?
5. ¿Dónde se almacenan los datos de Prometheus?
6. ¿Qué usuario debe ejecutar el servicio?
7. ¿Por qué no se recomienda ejecutar Prometheus como `root`?
8. ¿Qué puerto utiliza normalmente Prometheus?
9. ¿Qué comando permite validar la configuración?
10. ¿Qué comando permite consultar el estado del servicio?
11. ¿Qué comando permite consultar los registros?
12. ¿Qué función cumple `systemctl daemon-reload`?
13. ¿Qué diferencia existe entre `start` y `enable`?
14. ¿Qué endpoint permite comprobar la salud de Prometheus?
15. ¿Qué endpoint permite comprobar si Prometheus está preparado?
16. ¿Qué indica un resultado `up = 1`?
17. ¿Qué puede provocar que Prometheus no se inicie?
18. ¿Qué puede provocar un error de permisos?
19. ¿Cómo comprobarías si el puerto `9090` está ocupado?
20. ¿Por qué es importante validar el fichero YAML antes de reiniciar?
21. ¿Qué comando muestra la versión de Prometheus?
22. ¿Qué directorio debe tener permisos de escritura para el usuario `prometheus`?
23. ¿Qué información se puede obtener mediante `journalctl`?
24. ¿Por qué debe realizarse una copia de seguridad de `prometheus.yml`?
25. ¿Qué comprobaciones realizarías antes de añadir Node Exporter?

---

# Criterios de finalización

La instalación se considera correcta cuando:

- El usuario `prometheus` existe.
- El usuario no tiene acceso interactivo.
- Existe `/etc/prometheus`.
- Existe `/var/lib/prometheus`.
- `prometheus` está instalado.
- `promtool` está instalado.
- La configuración es válida.
- La unidad de `systemd` existe.
- El servicio está habilitado.
- El servicio está activo.
- El proceso utiliza el usuario `prometheus`.
- El puerto `9090` está en escucha.
- El endpoint `/-/healthy` responde correctamente.
- El endpoint `/-/ready` responde correctamente.
- La interfaz web es accesible.
- La consulta `up` devuelve el objetivo de Prometheus.
- Los registros no contienen errores críticos.
- Se ha guardado el informe de evidencias.

## Comprobación final

```bash
printf '%-35s %s\n' \
  "Servicio activo" \
  "$(systemctl is-active prometheus)"

printf '%-35s %s\n' \
  "Inicio automático" \
  "$(systemctl is-enabled prometheus)"

printf '%-35s ' \
  "Configuración válida"

promtool check config /etc/prometheus/prometheus.yml \
  >/dev/null 2>&1 \
  && echo "sí" \
  || echo "no"

printf '%-35s ' \
  "Endpoint saludable"

curl -fsS http://localhost:9090/-/healthy \
  >/dev/null \
  && echo "sí" \
  || echo "no"

printf '%-35s ' \
  "Endpoint preparado"

curl -fsS http://localhost:9090/-/ready \
  >/dev/null \
  && echo "sí" \
  || echo "no"

printf '%-35s ' \
  "Puerto 9090"

sudo ss -lnt '( sport = :9090 )' \
  | grep -q LISTEN \
  && echo "en escucha" \
  || echo "no disponible"
```

Resultado esperado:

```text
Servicio activo                    active
Inicio automático                  enabled
Configuración válida               sí
Endpoint saludable                 sí
Endpoint preparado                 sí
Puerto 9090                        en escucha
```