# Guía de preparación del curso de observabilidad

Esta página reúne los contenidos iniciales del curso: objetivos generales, requisitos previos y descripción del entorno de laboratorio.

El alumno utilizará Ubuntu para instalar y comprobar Grafana, Prometheus y Node Exporter. Antes de crear dashboards o alertas, deberá verificar que el sistema, la red, los permisos, los puertos y los servicios funcionan correctamente.

El recorrido será:

```text
Preparar Ubuntu
        |
        v
Comprobar recursos y conectividad
        |
        v
Instalar Grafana
        |
        v
Instalar Node Exporter
        |
        v
Instalar Prometheus
        |
        v
Configurar el scraping
        |
        v
Validar métricas
        |
        v
Conectar Grafana con Prometheus
```

## Objetivos

Al finalizar esta guía, el alumno podrá:

- Identificar los objetivos generales del curso.
- Comprender la relación entre Grafana, Prometheus y Node Exporter.
- Diferenciar métricas, logs, trazas y eventos.
- Explicar el modelo de recopilación *pull*.
- Comprobar la versión de Ubuntu.
- Consultar la arquitectura y el kernel.
- Revisar los recursos disponibles.
- Comprobar la sincronización horaria.
- Verificar la conectividad de red.
- Comprobar puertos TCP.
- Utilizar comandos básicos de Linux.
- Consultar servicios mediante `systemctl`.
- Interpretar ficheros YAML.
- Utilizar permisos administrativos con `sudo`.
- Preparar un directorio de trabajo.
- Instalar Grafana.
- Instalar Prometheus.
- Instalar Node Exporter.
- Comprobar los endpoints HTTP.
- Validar objetivos de scraping.
- Ejecutar consultas PromQL básicas.
- Documentar el entorno de laboratorio.
- Diagnosticar problemas iniciales de instalación y conectividad.

## Introducción

La observabilidad permite comprender qué ocurre dentro de un sistema y relacionar los síntomas con sus posibles causas.

Durante el curso se observarán señales como:

- Incrementos de uso de CPU.
- Reducciones de memoria disponible.
- Aumento de la ocupación del almacenamiento.
- Caídas de servicios.
- Cambios en el tráfico de red.
- Incrementos de carga.
- Errores después de una modificación.

La monitorización responde principalmente a:

```text
¿Está funcionando el sistema?

¿Cuál es su estado actual?

¿Ha superado algún umbral?

¿Existe un cambio respecto al comportamiento habitual?
```

La observabilidad amplía esas preguntas:

```text
¿Qué está ocurriendo?

¿Desde cuándo?

¿Qué componentes están afectados?

¿El problema es puntual o recurrente?

¿Qué ocurrió antes del incidente?

¿Cómo podemos comprobar que la solución ha funcionado?
```

## Contenido general del curso

El curso se organiza en los siguientes bloques:

### Fundamentos de telemetría

Se estudiarán:

- Telemetría.
- Observabilidad.
- Métricas.
- Logs.
- Trazas.
- Eventos.
- Series temporales.
- Etiquetas.
- Frecuencia de muestreo.
- Retención.
- *Downsampling*.
- Modelos *push* y *pull*.

### Grafana

Se trabajará con:

- Instalación en Ubuntu.
- Acceso a la interfaz web.
- Fuentes de datos.
- Rangos temporales.
- Desplazamientos temporales.
- Dashboards.
- Filas.
- Paneles.
- Transformaciones.
- Anotaciones.
- Alertas.

### Prometheus y Node Exporter

Se estudiarán:

- Arquitectura de Prometheus.
- Configuración de objetivos.
- Operaciones de *scraping*.
- Almacenamiento de series temporales.
- Instalación de Node Exporter.
- Endpoint de métricas.
- Consultas PromQL.
- Integración con Grafana.

### Visualización

Se crearán paneles de tipo:

- Time series.
- Stat.
- Gauge.
- Bar gauge.
- Heatmap.
- Text.
- Canvas.

### Alertas

Se configurarán:

- Reglas de alerta.
- Expresiones.
- Condiciones.
- Contactos.
- Políticas de notificación.
- Silenciamientos.
- Resolución de alertas.

### Proyecto final

El alumno construirá un dashboard operativo para supervisar un servidor Linux.

Como mínimo, deberá incluir:

- Uso de CPU.
- Memoria disponible o utilizada.
- Espacio de almacenamiento.
- Tráfico de red.
- Estado de un servicio.
- Una alerta operativa.
- Un rango temporal adecuado.
- Títulos y unidades correctas.

## Arquitectura del laboratorio

La arquitectura básica estará formada por un servidor Ubuntu con los tres componentes principales:

```text
Servidor Ubuntu
├── Grafana
├── Prometheus
└── Node Exporter
```

### Flujo completo

```text
Sistema operativo
        |
        v
Node Exporter
        |
        | Endpoint HTTP :9100
        v
Prometheus
        |
        | Consultas PromQL
        v
Grafana
        |
        v
Dashboards y alertas
```

### Función de cada componente

| Componente | Función | Puerto habitual |
|---|---|---:|
| Node Exporter | Expone métricas del sistema operativo | 9100 |
| Prometheus | Recopila y almacena métricas | 9090 |
| Grafana | Visualiza datos y configura dashboards | 3000 |
| PromQL | Consulta las métricas almacenadas | No aplica |

### Comunicación entre componentes

| Origen | Destino | Protocolo | Finalidad |
|---|---|---|---|
| Prometheus | Node Exporter | HTTP | Recopilar métricas |
| Grafana | Prometheus | HTTP | Ejecutar consultas |
| Navegador | Grafana | HTTP o HTTPS | Acceder a la interfaz |
| Administrador | Servidor | SSH o consola | Administrar el laboratorio |

### Modelo de recopilación *pull*

Prometheus utiliza normalmente un modelo *pull*. Prometheus inicia la conexión y consulta periódicamente a Node Exporter.

```text
Prometheus ---- solicitud HTTP ----> Node Exporter
Prometheus <--- métricas ------------ Node Exporter
```

Node Exporter mantiene disponible un endpoint como:

```text
http://localhost:9100/metrics
```

Prometheus consulta ese endpoint según el intervalo definido en su configuración.

## Requisitos del sistema

### Sistema operativo

El entorno recomendado es:

```text
Ubuntu 24.04.5 LTS
```

También pueden utilizarse otras versiones recientes de Ubuntu. En ese caso, pueden variar:

- Los nombres de algunos paquetes.
- Las rutas de configuración.
- La versión de los servicios.
- El formato de algunas opciones de Grafana.

Comprobar la versión:

```bash
lsb_release -a
```

También se puede utilizar:

```bash
cat /etc/os-release
```

### Arquitectura

Comprobar la arquitectura:

```bash
uname -m
```

Resultado habitual:

```text
x86_64
```

Consultar información completa:

```bash
uname -a
```

### Recursos recomendados

| Recurso | Mínimo recomendado |
|---|---:|
| CPU | 2 núcleos |
| Memoria RAM | 4 GB |
| Almacenamiento libre | 20 GB |
| Sistema operativo | Ubuntu reciente |
| Permisos | Usuario con `sudo` |
| Red | Acceso a Internet |
| Navegador | Firefox, Chrome o Chromium |

## Conocimientos previos

### Linux básico

El alumno debe conocer, al menos de forma introductoria:

- Navegación por directorios.
- Creación de directorios.
- Creación y lectura de ficheros.
- Copia y eliminación de archivos.
- Rutas absolutas y relativas.
- Redirecciones.
- Tuberías.
- Búsqueda de texto.
- Permisos.
- Procesos.
- Servicios.

Comandos habituales:

```bash
pwd
ls
cd
mkdir
cp
mv
rm
cat
less
head
tail
grep
find
```

### Redes básicas

Es recomendable comprender:

- Qué es una dirección IP.
- Qué es un puerto TCP.
- Qué representa `localhost`.
- Qué significa que un servicio escuche.
- Qué función cumple HTTP.
- Qué diferencia existe entre un servicio local y uno remoto.
- Qué es una puerta de enlace.
- Qué función tiene DNS.

### YAML

Prometheus utiliza YAML. Es necesario respetar:

- La indentación.
- Los dos puntos.
- Las listas.
- Los espacios.
- La ausencia de tabuladores.

Ejemplo válido:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

Ejemplo problemático:

```yaml
global:
 scrape_interval: 15s

scrape_configs:
- job_name: node_exporter
  static_configs:
  - targets:
    - localhost:9100
```

Aunque algunos analizadores pueden aceptar determinadas variantes, una indentación clara reduce los errores.

### Permisos administrativos

Algunas tareas necesitan permisos elevados:

```bash
sudo apt update
sudo systemctl restart prometheus
sudo nano /etc/prometheus/prometheus.yml
```

Comprobar que el usuario puede utilizar `sudo`:

```bash
sudo -v
```

## Preparación del entorno de trabajo

### Actualizar los paquetes

```bash
sudo apt update
```

Actualizar los paquetes instalados:

```bash
sudo apt upgrade
```

En un entorno de laboratorio también puede utilizarse:

```bash
sudo apt update && sudo apt upgrade -y
```

### Instalar herramientas básicas

```bash
sudo apt install -y \
  curl \
  wget \
  git \
  vim \
  nano \
  jq \
  tree \
  net-tools \
  lsof \
  ca-certificates \
  gnupg \
  apt-transport-https
```

Comprobar algunas versiones:

```bash
curl --version
wget --version
git --version
jq --version
```

### Crear el directorio del curso

```bash
mkdir -p ~/laboratorio-grafana
cd ~/laboratorio-grafana
pwd
```

Crear subdirectorios:

```bash
mkdir -p \
  configuracion \
  descargas \
  scripts \
  evidencias
```

Consultar la estructura:

```bash
tree ~/laboratorio-grafana
```

Resultado esperado:

```text
/home/alumno/laboratorio-grafana
├── configuracion
├── descargas
├── evidencias
└── scripts
```

## Usuarios y permisos

### Usuario principal

Consultar el usuario actual:

```bash
whoami
```

Consultar su identidad:

```bash
id
```

Consultar los grupos:

```bash
groups
```

Ejemplo:

```console
$ whoami
alumno

$ id
uid=1000(alumno) gid=1000(alumno) groups=1000(alumno),27(sudo)
```

Registrar:

```text
Usuario principal:

UID:

Grupo principal:

¿Pertenece a sudo?:
```

### Usuarios de servicio

Los servicios deberían ejecutarse con usuarios específicos cuando sea posible.

| Usuario | Servicio | Función |
|---|---|---|
| `grafana` | Grafana | Ejecutar Grafana |
| `prometheus` | Prometheus | Ejecutar Prometheus |
| `node_exporter` | Node Exporter | Exponer métricas |

Consultar los usuarios:

```bash
getent passwd grafana
getent passwd prometheus
getent passwd node_exporter
```

Comprobar el usuario configurado para cada servicio:

```bash
systemctl show grafana-server -p User
systemctl show prometheus -p User
systemctl show node_exporter -p User
```

### Recomendaciones de seguridad

- No ejecutar aplicaciones como `root` si no es necesario.
- No compartir contraseñas entre alumnos.
- Utilizar usuarios de servicio.
- No exponer el laboratorio directamente a Internet.
- Utilizar una red interna, VPN o cortafuegos.
- Mantener actualizado el sistema.
- Revisar los permisos de los ficheros.
- No guardar credenciales en repositorios.
- No incluir secretos en capturas.
- No trabajar sobre sistemas de producción.

## Sesión 1: identificar el sistema

### Objetivo

Recopilar información básica del equipo donde se realizará el laboratorio.

### Comandos

```bash
hostname
hostnamectl
lsb_release -a
uname -r
uname -m
date
timedatectl
```

### Ejemplo de sesión

```console
$ hostname
monitoring-lab

$ uname -r
6.8.0-40-generic

$ uname -m
x86_64

$ date
Thu Sep 24 10:05:42 CEST 2026
```

### Actividades

1. Anota el nombre del equipo.
2. Anota la versión de Ubuntu.
3. Anota la versión del kernel.
4. Identifica la arquitectura.
5. Comprueba la zona horaria.
6. Explica por qué la hora es importante en una plataforma de monitorización.

### Registro

```text
Hostname:

Sistema operativo:

Versión:

Kernel:

Arquitectura:

Zona horaria:

Fecha y hora:
```

## Sesión 2: comprobar los recursos del sistema

### Objetivo

Verificar que el equipo tiene recursos suficientes.

### Consultar la memoria

```bash
free -h
```

### Consultar los procesadores

```bash
lscpu
```

Mostrar únicamente el número de procesadores:

```bash
nproc
```

### Consultar almacenamiento

```bash
df -h
```

Consultar dispositivos:

```bash
lsblk
```

Consultar el tamaño del directorio personal:

```bash
du -sh "$HOME"
```

### Consultar la carga

```bash
uptime
```

Procesos con mayor consumo de CPU:

```bash
ps aux --sort=-%cpu | head
```

Procesos con mayor consumo de memoria:

```bash
ps aux --sort=-%mem | head
```

### Ejemplo de sesión

```console
$ nproc
2

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.1Gi       720Mi        18Mi       2.0Gi       2.4Gi
Swap:          2.0Gi          0B       2.0Gi

$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        40G   11G   27G  29% /
```

### Actividades

1. ¿Cuánta memoria total tiene el equipo?
2. ¿Cuántos procesadores están disponibles?
3. ¿Cuánto espacio libre existe en `/`?
4. ¿Qué proceso consume más CPU?
5. ¿Qué proceso consume más memoria?
6. ¿La carga del sistema parece normal?

## Sesión 3: trabajar con ficheros y directorios

### Objetivo

Practicar operaciones que se utilizarán con ficheros de configuración.

Entrar en el directorio de trabajo:

```bash
cd ~/laboratorio-grafana
```

Crear un fichero:

```bash
touch configuracion/prueba.conf
```

Escribir contenido:

```bash
cat > configuracion/prueba.conf <<'EOF'
nombre=servidor-laboratorio
entorno=pruebas
servicio=monitorizacion
EOF
```

Mostrar el contenido:

```bash
cat configuracion/prueba.conf
```

Añadir una línea:

```bash
echo "puerto=9090" >> configuracion/prueba.conf
```

Buscar una propiedad:

```bash
grep "puerto" configuracion/prueba.conf
```

Crear una copia:

```bash
cp configuracion/prueba.conf configuracion/prueba.conf.bak
```

Comparar los ficheros:

```bash
diff configuracion/prueba.conf configuracion/prueba.conf.bak
```

Eliminar los ficheros de prueba:

```bash
rm configuracion/prueba.conf
rm configuracion/prueba.conf.bak
```

### Actividades

Crear un fichero llamado `servidor.conf` con este contenido:

```text
nombre=monitoring-lab
entorno=laboratorio
grafana_port=3000
prometheus_port=9090
node_exporter_port=9100
```

Después:

1. Crea una copia de seguridad.
2. Modifica el fichero original.
3. Utiliza `diff`.
4. Documenta el cambio realizado.

## Sesión 4: comprobar la red

### Objetivo

Verificar que el equipo tiene conectividad y resolución de nombres.

### Comandos

Consultar las interfaces:

```bash
ip address
```

Consultar las rutas:

```bash
ip route
```

Consultar la puerta de enlace:

```bash
ip route | grep default
```

Comprobar la resolución DNS:

```bash
getent hosts archive.ubuntu.com
```

Probar conectividad IP:

```bash
ping -c 4 8.8.8.8
```

Probar conectividad mediante nombre:

```bash
ping -c 4 archive.ubuntu.com
```

Probar acceso HTTPS:

```bash
curl -I https://grafana.com
```

### Ejemplo de sesión

```console
$ getent hosts archive.ubuntu.com
185.125.190.39 archive.ubuntu.com

$ curl -I https://grafana.com
HTTP/2 200
content-type: text/html
```

### Interpretación

Si funciona:

```bash
ping -c 4 8.8.8.8
```

pero falla:

```bash
ping -c 4 archive.ubuntu.com
```

puede existir un problema de DNS.

Si falla también la conexión a `8.8.8.8`, puede existir un problema relacionado con:

- La interfaz.
- La ruta.
- La puerta de enlace.
- El cortafuegos.
- La red de la máquina virtual.

### Actividades

1. Identifica la dirección IP.
2. Identifica la puerta de enlace.
3. Comprueba la resolución DNS.
4. Comprueba el acceso HTTPS.
5. Explica la diferencia entre conectividad IP y resolución DNS.

## Sesión 5: comprobar la sincronización horaria

### Objetivo

Verificar que el reloj del sistema está sincronizado.

### Comandos

```bash
timedatectl status
```

Consultar si está sincronizado:

```bash
timedatectl show -p NTPSynchronized --value
```

Consultar la hora UTC:

```bash
date -u
```

Consultar la hora local:

```bash
date
```

Consultar los servidores de sincronización:

```bash
timedatectl show-timesync --all
```

### Ejemplo de salida

```console
$ timedatectl status
               Local time: Thu 2026-09-24 10:40:12 CEST
           Universal time: Thu 2026-09-24 08:40:12 UTC
                 RTC time: Thu 2026-09-24 08:40:12
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: yes
              NTP service: active
```

### Actividades

1. Comprueba si el reloj está sincronizado.
2. Identifica la zona horaria.
3. Compara la hora local con UTC.
4. Explica cómo una diferencia de varios minutos puede afectar a Grafana.
5. Explica cómo puede afectar a una alerta o a una comparación temporal.

## Sesión 6: comprobar puertos disponibles

### Objetivo

Verificar que los puertos necesarios están libres antes de la instalación.

### Comprobar todos los puertos TCP

```bash
sudo ss -lntp
```

### Comprobar un puerto concreto

```bash
sudo ss -lntp | grep ':3000'
```

### Comprobar los puertos del curso

```bash
for port in 3000 9090 9100; do
  echo "Puerto $port:"
  sudo ss -lnt "( sport = :$port )"
done
```

También se puede utilizar:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Ejemplo de salida

```console
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1500,fd=9))
```

### Actividades

1. Comprueba si el puerto `3000` está ocupado.
2. Comprueba si el puerto `9090` está ocupado.
3. Comprueba si el puerto `9100` está ocupado.
4. Identifica los procesos asociados.
5. Explica por qué dos servicios no pueden escuchar en la misma dirección y puerto.

## Sesión 7: comprobar servicios con systemd

### Objetivo

Aprender a consultar servicios antes y después de la instalación.

Consultar un servicio:

```bash
systemctl status ssh
```

Comprobar si está activo:

```bash
systemctl is-active ssh
```

Comprobar si arranca automáticamente:

```bash
systemctl is-enabled ssh
```

Consultar los servicios fallidos:

```bash
systemctl --failed
```

Consultar registros:

```bash
sudo journalctl -u ssh --no-pager -n 30
```

Consultar registros recientes:

```bash
sudo journalctl --since "30 minutes ago"
```

### Estados habituales

| Estado | Significado |
|---|---|
| `active` | El servicio está funcionando |
| `inactive` | El servicio está detenido |
| `failed` | El servicio intentó iniciarse y falló |
| `enabled` | Se iniciará automáticamente |
| `disabled` | No se iniciará automáticamente |

### Actividades

1. Consulta el estado de `ssh`.
2. Comprueba si está activo.
3. Consulta los últimos registros.
4. Ejecuta `systemctl --failed`.
5. Explica la diferencia entre `active` y `enabled`.

## Sesión 8: validar YAML

### Objetivo

Comprender la sintaxis básica que utilizará Prometheus.

Instalar `yamllint`:

```bash
sudo apt install -y yamllint
```

Crear un fichero:

```bash
cat > ~/laboratorio-grafana/configuracion/ejemplo.yml <<'EOF'
---
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
EOF
```

Validar el fichero:

```bash
yamllint ~/laboratorio-grafana/configuracion/ejemplo.yml
```

Comprobar si existen tabuladores:

```bash
grep -n $'\t' ~/laboratorio-grafana/configuracion/ejemplo.yml
```

### Actividades

1. Crea un fichero YAML con información del laboratorio.
2. Valida su sintaxis.
3. Introduce deliberadamente un error de indentación.
4. Ejecuta `yamllint`.
5. Corrige el error.
6. Explica por qué una indentación incorrecta puede impedir que Prometheus arranque.

## Sesión 9: inventariar el laboratorio

### Objetivo

Completar una ficha básica del entorno antes de instalar los componentes.

### Comandos

```bash
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I | awk '{print $1}')"
echo "Sistema: $(lsb_release -ds)"
echo "Arquitectura: $(uname -m)"
echo "Kernel: $(uname -r)"
echo "CPU: $(nproc)"
echo "Zona horaria: $(timedatectl show -p Timezone --value)"
```

### Registro

| Propiedad | Valor |
|---|---|
| Hostname | |
| Dirección IP | |
| Sistema operativo | |
| Arquitectura | |
| Kernel | |
| CPUs | |
| Zona horaria | |
| Usuario principal | |

## Sesión 10: instalar Grafana

### Objetivo

Instalar Grafana y comprobar que el servicio funciona.

Actualizar los repositorios:

```bash
sudo apt update
```

Instalar paquetes auxiliares:

```bash
sudo apt install -y apt-transport-https wget gnupg
```

Crear el directorio de claves:

```bash
sudo mkdir -p /etc/apt/keyrings
```

Añadir la clave del repositorio:

```bash
wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

Añadir el repositorio:

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
```

Actualizar la información de paquetes:

```bash
sudo apt update
```

Instalar Grafana:

```bash
sudo apt install -y grafana
```

Activar e iniciar el servicio:

```bash
sudo systemctl enable --now grafana-server
```

Comprobar el estado:

```bash
systemctl status grafana-server
```

Comprobar si está activo:

```bash
systemctl is-active grafana-server
```

Comprobar si arranca automáticamente:

```bash
systemctl is-enabled grafana-server
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':3000'
```

Probar la respuesta HTTP:

```bash
curl -I http://localhost:3000
```

Consultar los registros:

```bash
sudo journalctl -u grafana-server --no-pager -n 30
```

### Ejemplo de sesión

```console
$ systemctl is-active grafana-server
active

$ systemctl is-enabled grafana-server
enabled

$ sudo ss -lntp | grep 3000
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1234,fd=9))
```

### Actividades

1. Comprueba que Grafana está activo.
2. Comprueba que arranca automáticamente.
3. Verifica el puerto `3000`.
4. Accede desde el navegador a:

```text
http://localhost:3000
```
o
```text
http://IP_DE_TU_HOST:3000
```

5. Entra con el usuario `admin` y password `admin`.
6. Agrega password nuevo de no por defecto a la versión instalada.

## Sesión 11: instalar Node Exporter

### Objetivo

Instalar Node Exporter y comprobar que expone métricas del sistema.

Crear el usuario de servicio:

```bash
sudo useradd \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

Entrar en un directorio temporal:

```bash
cd /tmp
```

Descargar Node Exporter:

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.12.1/node_exporter-1.12.1.linux-amd64.tar.gz
```

Extraer el archivo:

```bash
tar xvf node_exporter-1.12.1.linux-amd64.tar.gz
```

Copiar el binario:

```bash
sudo cp node_exporter-*/node_exporter /usr/local/bin/
```

Asignar el propietario:

```bash
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```

Crear el servicio:

```bash
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
```

Recargar systemd:

```bash
sudo systemctl daemon-reload
```

Activar e iniciar:

```bash
sudo systemctl enable --now node_exporter
```

Comprobar el estado:

```bash
systemctl status node_exporter
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9100'
```

Consultar métricas:

```bash
curl http://localhost:9100/metrics
```
o
```bash
curl http://IP_DE_TU_HOST:9100/metrics
```

### Filtrar métricas concretas

CPU:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

Memoria:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_memory_' \
  | head
```

Almacenamiento:

```bash
curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem_size_bytes' \
  | head
```

### Ejemplo de sesión

```console
$ systemctl is-active node_exporter
active

$ curl -s http://localhost:9100/metrics \
  | grep '^node_memory_MemTotal_bytes'
node_memory_MemTotal_bytes 4.10437632e+09

$ curl -s http://localhost:9100/metrics \
  | grep '^node_filesystem_size_bytes' \
  | head -1
node_filesystem_size_bytes{device="/dev/sda2",fstype="ext4",mountpoint="/"} 4.294967296e+10
```

### Actividades

1. Comprueba que Node Exporter está activo.
2. Consulta cinco métricas diferentes.
3. Identifica las etiquetas de una métrica de almacenamiento.
4. Explica qué representa `node_memory_MemTotal_bytes`.
5. Explica por qué el endpoint `/metrics` es importante.

## Sesión 12: instalar Prometheus y Node Exporter en Ubuntu

### Objetivo

Instalar Prometheus y Node Exporter mediante los paquetes disponibles en Ubuntu, comprobar los servicios y verificar que las cuentas de servicio se crean correctamente.

> **Importante:** no ejecutes `useradd prometheus` antes de instalar el paquete. Ubuntu crea automáticamente el usuario y el grupo `prometheus`.

### Comprobar la versión de Ubuntu

```bash
lsb_release -a
```

También puedes utilizar:

```bash
cat /etc/os-release
```

### Actualizar el índice de paquetes

```bash
sudo apt update
```

### Instalar Prometheus y Node Exporter

```bash
sudo apt install -y \
  prometheus \
  prometheus-node-exporter \
  prometheus-node-exporter-collectors
```

Durante la instalación se crearán, normalmente, los servicios:

```text
prometheus.service
prometheus-node-exporter.service
```

También se crearán las cuentas de servicio correspondientes.

### Comprobar los usuarios de servicio

```bash
getent passwd prometheus
```

```bash
getent passwd prometheus-node-exporter
```

Comprobar el usuario de Prometheus:

```bash
id prometheus
```

Comprobar el usuario de Node Exporter:

```bash
id prometheus-node-exporter
```

Los usuarios de servicio deben tener:

- Un identificador de usuario del sistema.
- Un shell no interactivo o deshabilitado.
- Ningún uso previsto para iniciar sesión manualmente.

### Comprobar los paquetes instalados

```bash
dpkg -l | grep -E \
  'prometheus|node-exporter'
```

También puedes comprobar si existen paquetes pendientes de configurar:

```bash
sudo dpkg --audit
```

Si la instalación ha quedado interrumpida, repara los paquetes con:

```bash
sudo dpkg --configure -a
```

Después:

```bash
sudo apt-get -f install
```

### Comprobar los servicios

```bash
systemctl status prometheus
```

```bash
systemctl status prometheus-node-exporter
```

Comprobar únicamente si están activos:

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active prometheus-node-exporter
```

### Activar los servicios al arrancar

```bash
sudo systemctl enable --now prometheus
```

```bash
sudo systemctl enable --now prometheus-node-exporter
```

### Comprobar los puertos

Prometheus utiliza normalmente el puerto `9090` y Node Exporter el puerto `9100`.

```bash
sudo ss -lntp | grep -E ':9090|:9100'
```

Resultado esperado, de forma aproximada:

```text
LISTEN ... 0.0.0.0:9090 ...
LISTEN ... 0.0.0.0:9100 ...
```

La dirección exacta puede variar según la configuración del sistema.

### Comprobar la ubicación de los binarios

```bash
command -v prometheus
```

```bash
command -v promtool
```

```bash
command -v node_exporter
```

### Consultar las versiones

```bash
prometheus --version
```

```bash
promtool --version
```

```bash
node_exporter --version
```

### Consultar la configuración del servicio

```bash
sudo systemctl cat prometheus
```

También puedes consultar los parámetros de inicio:

```bash
systemctl show prometheus \
  -p ExecStart
```

Busca especialmente:

```text
--config.file
--storage.tsdb.path
```

En una instalación habitual de Ubuntu, las rutas suelen ser:

```text
Configuración: /etc/prometheus/prometheus.yml
Datos:         /var/lib/prometheus
```

### Comprobar directorios importantes

```bash
sudo ls -ld \
  /etc/prometheus \
  /var/lib/prometheus
```

Comprobar el propietario del directorio de datos:

```bash
sudo stat -c '%U:%G %n' \
  /var/lib/prometheus
```

El propietario habitual debe ser:

```text
prometheus:prometheus
```

### Comprobar la interfaz HTTP de Prometheus

```bash
curl -I http://localhost:9090
```

### Comprobar la salud de Prometheus

```bash
curl -s http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Comprobar Node Exporter

```bash
curl -s http://localhost:9100/metrics \
  | head
```

La respuesta debe contener métricas con nombres similares a:

```text
node_uname_info
node_cpu_seconds_total
node_memory_MemTotal_bytes
```

### Consultar los logs

Logs de Prometheus:

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

Logs de Node Exporter:

```bash
sudo journalctl -u prometheus-node-exporter \
  -n 100 \
  --no-pager
```

### Actividades

1. Identifica el paquete responsable del servidor Prometheus.
2. Identifica el paquete responsable de Node Exporter.
3. Comprueba qué usuario ejecuta cada servicio.
4. Comprueba los puertos `9090` y `9100`.
5. Consulta la versión de Prometheus.
6. Consulta la ruta del fichero de configuración.
7. Consulta los logs de ambos servicios.
8. Explica por qué no debe crearse manualmente el usuario `prometheus` antes de instalar el paquete.

### Si existe un problema en node exporter y no inicia
El problema del puerto `9100` se debe a que hay **dos servicios de Node Exporter** intentando utilizar el mismo puerto:

- `node_exporter.service`: activo y ocupando `9100`.
- `prometheus-node-exporter.service`: también intenta arrancar y falla con `address already in use`.

La solución es dejar **un único servicio activo**.

#### Solución recomendada

Conserva el servicio instalado mediante APT:

```bash
prometheus-node-exporter.service
```

##### 1. Detener el servicio duplicado

```bash
sudo systemctl disable --now node_exporter.service
```

Comprueba que está detenido:

```bash
systemctl is-active node_exporter.service
```

Resultado esperado:

```text
inactive
```

##### 2. Verificar que el puerto está libre

```bash
sudo ss -lntp | grep ':9100'
```

No debería aparecer ninguna salida.

Si todavía aparece un proceso, identifícalo:

```bash
sudo lsof -nP -iTCP:9100 -sTCP:LISTEN
```

##### 3. Iniciar el servicio correcto

```bash
sudo systemctl reset-failed prometheus-node-exporter.service
```

```bash
sudo systemctl enable --now prometheus-node-exporter.service
```

Comprueba su estado:

```bash
systemctl is-active prometheus-node-exporter.service
```

Resultado esperado:

```text
active
```

##### 4. Verificar que Node Exporter responde

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -I http://localhost:9100/metrics
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

##### 5. Comprobar los servicios

```bash
systemctl list-units --type=service --all \
  | grep -Ei 'node_exporter|prometheus-node-exporter'
```

Debe quedar:

```text
node_exporter.service                  inactive
prometheus-node-exporter.service      active
```

#### Si el servicio antiguo vuelve a arrancar

Bloquéalo temporalmente:

```bash
sudo systemctl mask node_exporter.service
```

Después reinicia el servicio correcto:

```bash
sudo systemctl reset-failed prometheus-node-exporter.service
sudo systemctl restart prometheus-node-exporter.service
```

#### Secuencia completa

```bash
sudo systemctl disable --now node_exporter.service
sudo ss -lntp | grep ':9100'
sudo systemctl reset-failed prometheus-node-exporter.service
sudo systemctl enable --now prometheus-node-exporter.service
systemctl is-active prometheus-node-exporter.service
curl -I http://localhost:9100/metrics
```

El resultado final debe ser:

- `node_exporter.service`: detenido.
- `prometheus-node-exporter.service`: activo.
- Puerto `9100`: utilizado por una sola instancia.
- `/metrics`: responde correctamente.

---

## Sesión 13: configurar Prometheus para recopilar métricas

### Objetivo

Configurar Prometheus para recopilar métricas del propio Prometheus y de Node Exporter.

### Crear una copia de seguridad

Antes de modificar la configuración original:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

Comprobar la copia:

```bash
sudo ls -l \
  /etc/prometheus/prometheus.yml*
```

### Consultar la configuración actual

```bash
sudo cat /etc/prometheus/prometheus.yml
```

### Editar el fichero

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Utiliza una configuración como esta:

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

La línea inicial:

```yaml
---
```

indica explícitamente el inicio del documento YAML y evita el aviso habitual de `yamllint`:

```text
missing document start "---"
```

### Configuración con etiquetas

También puedes añadir etiquetas al target de Node Exporter:

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
        labels:
          environment: laboratorio
          role: monitorizacion

  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          role: servidor
```

Las etiquetas estarán disponibles en las consultas PromQL.

Ejemplo:

```promql
up{
  job="node_exporter"
}
```

### Comprobar la sintaxis YAML

Si `yamllint` no está instalado:

```bash
sudo apt install -y yamllint
```

Validar el fichero:

```bash
yamllint /etc/prometheus/prometheus.yml
```

También puedes validar el fichero de práctica que tengas en tu directorio de trabajo:

```bash
yamllint \
  ~/laboratorio-grafana/configuracion/ejemplo.yml
```

Una configuración correcta no debería mostrar errores. Los avisos dependerán de las reglas configuradas en `yamllint`.

### Validar la configuración con `promtool`

La validación más importante para Prometheus es:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Resultado esperado, aproximadamente:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: 0 rule files found
```

`yamllint` comprueba la sintaxis YAML general, mientras que `promtool` comprueba que el contenido sea válido para Prometheus.

### Comprobar la configuración con el usuario del servicio

Puedes verificar que el fichero sea legible:

```bash
sudo -u prometheus test -r \
  /etc/prometheus/prometheus.yml \
  && echo "Configuración legible" \
  || echo "Configuración no legible"
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Comprobar el estado

```bash
sudo systemctl status prometheus
```

### Comprobar si está activo

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

### Consultar los últimos logs

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

Para observar los logs en tiempo real:

```bash
sudo journalctl -u prometheus \
  -f
```

Pulsa:

```text
Ctrl + C
```

para salir.

### Probar la interfaz web

```bash
curl -I http://localhost:9090
```

### Consultar la salud

```bash
curl -s http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Consultar la API de consultas

Ejecuta la consulta `up`:

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

Si tienes instalado `jq`, puedes mostrar el resultado con formato legible:

```bash
sudo apt install -y jq
```

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Consultar los targets

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

También puedes abrir en el navegador:

```text
http://localhost:9090/targets
```

Los targets deberían aparecer con estado:

```text
UP
```

### Consultar los valores de `up`

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq '.data.result[] | {
      metric: .metric,
      value: .value
    }'
```

Una respuesta simplificada puede incluir:

```text
job: prometheus
value: 1

job: node_exporter
value: 1
```

### Consultar mediante PromQL

Desde la interfaz web de Prometheus:

```text
http://localhost:9090/graph
```

Ejecuta:

```promql
up
```

Después:

```promql
up{
  job="prometheus"
}
```

Y finalmente:

```promql
up{
  job="node_exporter"
}
```

### Interpretar `up = 1`

```text
up = 1
```

Significa que Prometheus ha podido realizar correctamente el scraping del target.

### Interpretar `up = 0`

```text
up = 0
```

Significa que Prometheus conoce el target, pero no ha podido recopilar sus métricas.

Posibles causas:

- Servicio detenido.
- Puerto incorrecto.
- Firewall.
- URL incorrecta.
- Error de red.
- Node Exporter no está escuchando.
- Problema de permisos o configuración.

### Probar Node Exporter directamente

```bash
curl -I http://localhost:9100/metrics
```

Consultar algunas métricas:

```bash
curl -s http://localhost:9100/metrics \
  | grep -E \
  'node_uname_info|node_memory_MemTotal_bytes|node_cpu_seconds_total' \
  | head
```

### Consultar una métrica del sistema

Desde Prometheus:

```promql
node_load1
```

Consultar memoria total:

```promql
node_memory_MemTotal_bytes
```

Consultar información del sistema:

```promql
node_uname_info
```

### Configurar una dirección remota

Si Node Exporter está en otro servidor, no utilices:

```yaml
- targets:
    - localhost:9100
```

Utiliza la dirección real:

```yaml
- targets:
    - 192.168.1.30:9100
```

Ejemplo:

```yaml
---
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - 192.168.1.30:9100
        labels:
          environment: laboratorio
          role: servidor
```

Desde el servidor Prometheus, prueba primero la conectividad:

```bash
curl -I http://192.168.1.30:9100/metrics
```

Después valida y reinicia:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Problemas habituales

#### El servicio no arranca

Consulta:

```bash
sudo systemctl status prometheus
```

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

Valida la configuración:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

#### Error de YAML

Comprueba:

- Sangría.
- Espacios en lugar de tabuladores.
- Dos puntos.
- Guiones.
- Comillas.
- Nombres de propiedades.
- Inicio del documento `---`.

Ejemplo correcto:

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

#### El target aparece como `DOWN`

Comprueba Node Exporter:

```bash
systemctl is-active prometheus-node-exporter
```

Comprueba el puerto:

```bash
sudo ss -lntp | grep ':9100'
```

Prueba directamente:

```bash
curl -I http://localhost:9100/metrics
```

Consulta los detalles de los targets:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[] | {
      job: .labels.job,
      instance: .labels.instance,
      health: .health,
      lastError: .lastError
    }'
```

#### El target no aparece

Comprueba:

- Que esté dentro de `scrape_configs`.
- Que la configuración guardada sea la que utiliza el servicio.
- Que Prometheus se haya reiniciado.
- Que `promtool` no muestre errores.
- Que no haya otro fichero de configuración activo.

Consulta los parámetros del servicio:

```bash
systemctl show prometheus \
  -p ExecStart
```

#### `localhost` apunta al equipo equivocado

Si Prometheus y Node Exporter están en equipos diferentes, `localhost` apunta al servidor donde se ejecuta Prometheus.

Ejemplo:

```text
Prometheus:    192.168.1.20
Node Exporter: 192.168.1.30
```

Configuración incorrecta:

```yaml
targets:
  - localhost:9100
```

Configuración correcta:

```yaml
targets:
  - 192.168.1.30:9100
```

### Restaurar la configuración original

Si necesitas volver a la copia de seguridad:

```bash
sudo cp \
  /etc/prometheus/prometheus.yml.bak \
  /etc/prometheus/prometheus.yml
```

Valida:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Reinicia:

```bash
sudo systemctl restart prometheus
```

### Actividades

1. Instala Prometheus mediante `apt`.
2. Instala Node Exporter mediante `apt`.
3. Comprueba los usuarios de servicio creados.
4. Consulta la configuración actual de Prometheus.
5. Crea una copia de seguridad.
6. Configura los jobs `prometheus` y `node_exporter`.
7. Valida el YAML con `yamllint`.
8. Valida la configuración con `promtool`.
9. Reinicia Prometheus.
10. Comprueba el estado del servicio.
11. Consulta la página `/targets`.
12. Ejecuta la consulta `up`.
13. Explica la diferencia entre `up = 1` y `up = 0`.
14. Detén Node Exporter y observa el cambio.
15. Inicia Node Exporter y comprueba la recuperación.
16. Consulta `node_load1`.
17. Documenta el resultado.

## Nota sobre una instalación interrumpida

Si anteriormente ejecutaste:

```bash
sudo useradd \
  --no-create-home \
  --shell /usr/sbin/nologin \
  prometheus
```

y posteriormente `apt install prometheus` muestra:

```text
The user `prometheus' already exists, but is not a system user
```

no repitas la instalación sin corregir primero la cuenta.

En un laboratorio sin datos importantes, puedes comprobar y corregir el usuario siguiendo estos pasos:

```bash
getent passwd prometheus
```

```bash
id prometheus
```

Si confirmas que la cuenta fue creada únicamente para la práctica y no contiene datos necesarios:

```bash
sudo systemctl stop prometheus 2>/dev/null || true
sudo userdel prometheus
```

Si existe un grupo independiente:

```bash
getent group prometheus
```

```bash
sudo groupdel prometheus
```

Después repara la instalación:

```bash
sudo dpkg --configure -a
```

```bash
sudo apt-get -f install
```

Finalmente:

```bash
sudo apt install --reinstall prometheus
```

En producción, **no elimines la cuenta sin revisar antes sus procesos, archivos, UID, GID y permisos**.


## Sesión 14: comprobar los objetivos de Prometheus

### Objetivo

Verificar que Prometheus puede consultar correctamente a Node Exporter.

Consultar la API:

```bash
curl -s http://localhost:9090/api/v1/targets
```

Mostrar el resultado con formato legible:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

Mostrar los nombres de los trabajos:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '.data.activeTargets[].labels.job'
```

Consultar el estado de cada objetivo:

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

### Ejemplo de resultado

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

### Actividades

1. Identifica todos los objetivos.
2. Comprueba el estado de cada uno.
3. Busca posibles errores.
4. Explica qué significa que un objetivo aparezca como `down`.
5. Guarda una captura de la página de objetivos.

## Sesión 15: primeras consultas PromQL

### Objetivo

Consultar métricas básicas desde Prometheus.

### Disponibilidad

```promql
up
```

Filtrar Node Exporter:

```promql
up{job="node_exporter"}
```

### Tiempo de actividad

```promql
node_time_seconds - node_boot_time_seconds
```

### Memoria total

```promql
node_memory_MemTotal_bytes
```

### Memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Número de CPUs

```promql
count by (instance) (
  node_cpu_seconds_total{mode="idle"}
)
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

### Tráfico recibido

```promql
rate(node_network_receive_bytes_total[5m])
```

### Tráfico enviado

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Actividades

1. Consulta `up`.
2. Calcula el uso de CPU.
3. Calcula el uso de memoria.
4. Consulta el espacio utilizado.
5. Identifica las interfaces de red.
6. Agrupa los resultados por `instance`.
7. Registra la unidad de cada consulta.

## Sesión 16: consultar Prometheus mediante la API

### Objetivo

Ejecutar consultas PromQL sin utilizar todavía la interfaz gráfica.

Consultar `up`:

```bash
curl -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

Mostrar el resultado con `jq`:

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

Mostrar los objetivos activos:

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq -r '
    .data.result[]
    | [
        .metric.job,
        .metric.instance,
        .value[1]
      ]
    | @tsv
  '
```

Consultar la memoria total:

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_memory_MemTotal_bytes' \
  | jq
```

### Actividades

Ejecutar y documentar:

```promql
up
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

Para cada consulta, registrar:

```text
Consulta:

Número de series:

Etiquetas:

Valor:

Unidad:

Resultado:
```

## Sesión 17: comprobar Grafana

### Objetivo

Verificar que Grafana responde y acceder a su interfaz.

Probar la conexión local:

```bash
curl -I http://localhost:3000
```

Probar mediante la dirección IP:

```bash
curl -I http://$(hostname -I | awk '{print $1}'):3000
```

Abrir desde el navegador:

```text
http://<DIRECCION_IP>:3000
```

Ejemplo:

```text
http://192.168.1.50:3000
```

Consultar registros:

```bash
sudo journalctl -u grafana-server --no-pager -n 30
```

Consultar registros desde el último arranque:

```bash
sudo journalctl -u grafana-server -b --no-pager
```

### Actividades

1. Accede a Grafana.
2. Comprueba que la interfaz carga correctamente.
3. Registra la URL utilizada.
4. Consulta los registros.
5. Anota cualquier advertencia o error.

## Sesión 18: añadir Prometheus como fuente de datos

### Objetivo

Conectar Grafana con Prometheus.

Acceder a:

```text
http://localhost:3000
```

En Grafana:

1. Abrir **Connections**.
2. Seleccionar **Data sources**.
3. Pulsar **Add data source**.
4. Seleccionar **Prometheus**.
5. Introducir la URL:

```text
http://localhost:9090
```

6. Pulsar **Save & test**.
7. Confirmar que la conexión es correcta.

### Verificación

Crear un panel temporal y ejecutar:

```promql
up
```

### Registro

```text
Nombre de la fuente:

Tipo:

URL:

Resultado de Save & test:

Fecha:

Observaciones:
```

## Sesión 19: crear un dashboard inicial

### Objetivo

Crear una primera vista del estado del sistema.

Crear un dashboard:

1. Abrir **Dashboards**.
2. Pulsar **New**.
3. Seleccionar **New dashboard**.
4. Añadir un panel.
5. Seleccionar Prometheus.

### Panel de CPU

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
Uso de CPU

Unidad:
Percent (0-100)

Visualización:
Time series

Rango:
Last 15 minutes
```

### Panel de memoria

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
Uso de memoria

Unidad:
Percent (0-100)

Visualización:
Gauge

Umbral de advertencia:
75

Umbral crítico:
90
```

### Panel de memoria disponible

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Configuración:

```text
Título:
Memoria disponible

Unidad:
bytes

Visualización:
Stat
```

### Panel de almacenamiento

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
Uso del sistema de ficheros raíz

Unidad:
Percent (0-100)

Visualización:
Gauge

Umbral de advertencia:
75

Umbral crítico:
90
```

### Panel de disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Configuración:

```text
Título:
Estado de Node Exporter

Visualización:
Stat

Valor correcto:
1

Valor incorrecto:
0
```

### Panel de tráfico recibido

Consulta:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!="lo"
  }[5m])
)
```

Configuración:

```text
Título:
Tráfico recibido

Unidad:
bytes/sec

Visualización:
Time series
```

### Actividades

1. Crea el dashboard `Dashboard operativo`.
2. Añade los seis paneles.
3. Organiza los paneles en dos filas.
4. Configura títulos descriptivos.
5. Configura las unidades.
6. Añade umbrales a los paneles Gauge.
7. Guarda el dashboard.
8. Cambia el rango a `Last 1 hour`.
9. Comprueba que todos los paneles muestran datos.

## Sesión 20: comparar periodos temporales

### Objetivo

Comparar el comportamiento actual con un periodo anterior.

Consulta de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configurar dos consultas en el mismo panel:

```text
Consulta A:
Sin desplazamiento

Consulta B:
Desplazamiento temporal de 1h o 1d
```

Configuración visual:

```text
Consulta A:
Línea sólida

Consulta B:
Línea discontinua
```

### Actividades

1. Compara el uso de CPU actual con el de hace una hora.
2. Compara el tráfico de red actual con un periodo anterior.
3. Explica qué ocurre si Prometheus no conserva datos antiguos.
4. Identifica si existe algún patrón repetitivo.
5. Documenta el rango y el desplazamiento utilizados.

## Sesión 21: validación completa del entorno

### Objetivo

Ejecutar una comprobación general antes de continuar con el resto del curso.

Crear un script:

```bash
cat > ~/laboratorio-grafana/scripts/comprobar-entorno.sh <<'EOF'
#!/usr/bin/env bash

set -u

echo "== Sistema =="
hostname
lsb_release -ds
uname -m
uname -r

echo
echo "== Usuario =="
whoami
id -u
id -nG

echo
echo "== Recursos =="
nproc
free -h
df -h /

echo
echo "== Hora =="
timedatectl show -p NTPSynchronized --value
timedatectl show -p Timezone --value
date

echo
echo "== Red =="
ip route | grep default || true
hostname -I

echo
echo "== Servicios =="
for service in grafana-server prometheus node_exporter; do
  printf "%-20s" "$service"

  if systemctl is-active --quiet "$service"; then
    echo "activo"
  else
    echo "no activo"
  fi
done

echo
echo "== Puertos =="
sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true

echo
echo "== HTTP =="
curl -s -o /dev/null -w "Grafana: HTTP %{http_code}\n" \
  http://localhost:3000

curl -s -o /dev/null -w "Prometheus: HTTP %{http_code}\n" \
  http://localhost:9090

curl -s -o /dev/null -w "Node Exporter: HTTP %{http_code}\n" \
  http://localhost:9100/metrics
EOF
```

Dar permisos de ejecución:

```bash
chmod +x ~/laboratorio-grafana/scripts/comprobar-entorno.sh
```

Ejecutar:

```bash
~/laboratorio-grafana/scripts/comprobar-entorno.sh
```

### Ejemplo de salida

```console
== Sistema ==
monitoring-lab
Ubuntu 24.04.5 LTS
x86_64
6.8.0-40-generic

== Usuario ==
alumno
1000
alumno sudo

== Recursos ==
2
...

== Servicios ==
grafana-server       activo
prometheus           activo
node_exporter        activo

== HTTP ==
Grafana: HTTP 302
Prometheus: HTTP 200
Node Exporter: HTTP 200
```

### Actividades

1. Ejecuta el script.
2. Guarda la salida como evidencia.
3. Identifica cualquier servicio inactivo.
4. Identifica cualquier puerto ausente.
5. Documenta los problemas encontrados.
6. Corrige los problemas autorizados.
7. Ejecuta de nuevo el script.

## Diagnóstico básico

### Grafana no responde

Comprobar:

```bash
systemctl status grafana-server
sudo ss -lntp | grep ':3000'
sudo journalctl -u grafana-server --no-pager -n 50
```

Posibles causas:

```text
El servicio está detenido.
El puerto está ocupado.
La configuración contiene errores.
El proceso no tiene permisos.
La interfaz todavía está iniciándose.
```

### Prometheus no arranca

Comprobar:

```bash
systemctl status prometheus
sudo journalctl -u prometheus --no-pager -n 50
```

Revisar el YAML:

```bash
yamllint /etc/prometheus/prometheus.yml
```

Comprobar la configuración con la herramienta disponible en la instalación:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Posibles causas:

```text
Error de indentación YAML.
Ruta incorrecta.
Objetivo mal escrito.
Puerto incorrecto.
Permisos insuficientes.
Fichero de configuración inexistente.
```

### Node Exporter no responde

Comprobar:

```bash
systemctl status node_exporter
sudo ss -lntp | grep ':9100'
curl -I http://localhost:9100/metrics
sudo journalctl -u node_exporter --no-pager -n 50
```

Posibles causas:

```text
Servicio detenido.
Binario inexistente.
Puerto ocupado.
Usuario de servicio incorrecto.
Error en la unidad systemd.
```

### Target de Prometheus aparece como `down`

Comprobar:

```bash
curl -I http://localhost:9100/metrics
```

Revisar:

```text
Nombre del host.
Puerto configurado.
Estado de Node Exporter.
Conectividad.
Firewall.
Configuración de Prometheus.
```

### Grafana no conecta con Prometheus

Comprobar:

```bash
curl -I http://localhost:9090
curl http://localhost:9090/-/healthy
```

Revisar:

```text
URL de la fuente de datos.
Puerto 9090.
Estado de Prometheus.
Resolución del nombre.
Dirección de escucha.
Restricciones de red.
```

## Ficha final del entorno

Completar antes de continuar con las prácticas:

```text
Alumno:

Grupo:

Fecha:

Hostname:

Dirección IP:

Interfaz principal:

Sistema operativo:

Versión:

Arquitectura:

Kernel:

Zona horaria:

Usuario principal:

Grafana:

Versión:

URL:

Puerto:

Estado:

Prometheus:

Versión:

URL:

Puerto:

Estado:

Node Exporter:

Versión:

URL:

Puerto:

Estado:

Fuente de datos de Grafana:

Nombre:

URL:

Estado:

Objetivo de Prometheus:

Job:

Instance:

Estado:

Observaciones:
```

## Registro de evidencias

Guardar las evidencias dentro de:

```text
~/laboratorio-grafana/evidencias
```

Estructura recomendada:

```text
evidencias/
├── sistema/
├── red/
├── servicios/
├── prometheus/
├── node-exporter/
├── grafana/
└── consultas/
```

### Evidencias recomendadas

```text
01-version-ubuntu.txt
02-recursos-sistema.txt
03-red.txt
04-puertos.txt
05-servicios.txt
06-grafana-http.txt
07-prometheus-health.txt
08-node-exporter-metrics.txt
09-prometheus-targets.json
10-consulta-up.txt
11-consulta-cpu.txt
12-consulta-memoria.txt
13-consulta-almacenamiento.txt
14-dashboard-inicial.png
15-fuente-prometheus.png
```

### Seguridad de las evidencias

Antes de entregar capturas o ficheros:

- Ocultar contraseñas.
- Ocultar tokens.
- Ocultar claves API.
- Ocultar cookies.
- Ocultar cabeceras de autorización.
- Anonimizar direcciones privadas si procede.
- Confirmar que las pruebas se realizaron en laboratorio.

## Puntos clave

- Grafana visualiza datos, pero normalmente no los recopila directamente.
- Prometheus recopila y almacena series temporales.
- Node Exporter expone métricas del sistema operativo.
- PromQL permite consultar las métricas almacenadas.
- El modelo habitual de Prometheus es *pull*.
- Los puertos principales son `3000`, `9090` y `9100`.
- La hora del sistema es importante para interpretar las muestras.
- La sincronización horaria facilita la correlación entre métricas y eventos.
- Los servicios deben comprobarse mediante `systemctl`.
- Los endpoints HTTP permiten validar cada componente de forma independiente.
- El endpoint `/metrics` de Node Exporter debe responder antes de configurar Prometheus.
- Prometheus debe mostrar el target de Node Exporter como `up`.
- Grafana debe validar correctamente la fuente de datos.
- Las consultas PromQL deben probarse antes de incorporarlas a un dashboard.
- La configuración YAML depende de una indentación correcta.
- Los usuarios de servicio reducen los riesgos de ejecución.
- La estructura de directorios facilita el trabajo y la recogida de evidencias.
- El entorno de laboratorio debe mantenerse separado de producción.
- La documentación debe incluir versiones, direcciones, puertos y estados.
- Los problemas deben registrarse junto con sus causas y soluciones.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre monitorización y observabilidad?
2. ¿Qué función cumple Node Exporter?
3. ¿Qué función cumple Prometheus?
4. ¿Qué función cumple Grafana?
5. ¿Qué es PromQL?
6. ¿Qué significa que Prometheus utilice un modelo *pull*?
7. ¿Qué puerto utiliza habitualmente Grafana?
8. ¿Qué puerto utiliza habitualmente Prometheus?
9. ¿Qué puerto utiliza habitualmente Node Exporter?
10. ¿Qué comando permite consultar el estado de un servicio?
11. ¿Qué diferencia existe entre `active` y `enabled`?
12. ¿Cómo se comprueba que un puerto está escuchando?
13. ¿Qué indica un código HTTP `200`?
14. ¿Qué diferencia existe entre `localhost` y una dirección IP de red?
15. ¿Por qué es importante sincronizar el reloj del sistema?
16. ¿Qué problemas puede provocar una indentación incorrecta en YAML?
17. ¿Qué representa la métrica `up`?
18. ¿Qué significa `up = 1`?
19. ¿Qué significa `up = 0`?
20. ¿Qué comprobarías si Node Exporter responde localmente, pero Prometheus muestra el target como `down`?
21. ¿Qué comprobarías si Grafana no puede conectarse con Prometheus?
22. ¿Por qué se recomienda utilizar usuarios de servicio?
23. ¿Qué información debe registrarse en la ficha del entorno?
24. ¿Qué evidencias demostrarían que la instalación es correcta?
25. ¿Qué información no debe aparecer en las capturas?

## Resultado esperado

Al finalizar esta guía, el alumno deberá tener un entorno preparado con esta estructura:

```text
Ubuntu
  |
  +--> Grafana activo en el puerto 3000
  |
  +--> Prometheus activo en el puerto 9090
  |
  +--> Node Exporter activo en el puerto 9100
```

Además, deberá poder demostrar:

```text
Grafana responde por HTTP.
Prometheus responde por HTTP.
Node Exporter expone /metrics.
Prometheus consulta a Node Exporter.
El target node_exporter aparece como UP.
La consulta up devuelve datos.
Las consultas de CPU y memoria devuelven datos.
La consulta de almacenamiento devuelve datos.
Grafana utiliza Prometheus como fuente de datos.
El entorno está documentado.
```

El resultado mínimo esperado es:

```text
Servicio              Estado       Puerto
Grafana               activo       3000
Prometheus            activo       9090
Node Exporter         activo       9100
```

La siguiente etapa del curso podrá comenzar cuando el alumno haya validado el sistema operativo, los recursos, la red, los servicios, los endpoints, los objetivos de Prometheus y la fuente de datos de Grafana.