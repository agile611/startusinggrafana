# Entorno de laboratorio: Grafana, Prometheus y Node Exporter

Esta guía describe el entorno utilizado durante el curso para instalar, configurar y comprobar Grafana, Prometheus y Node Exporter sobre Ubuntu.

El laboratorio se basa en un servidor Ubuntu que ejecuta los tres componentes principales:

```text
Ubuntu
├── Grafana
├── Prometheus
└── Node Exporter
```

El objetivo es que el alumno pueda identificar los recursos del sistema, comprobar el estado de los servicios, configurar la recopilación de métricas y documentar el entorno antes de comenzar las prácticas.

---

## Objetivos

Al finalizar esta guía, el alumno podrá:

- Identificar los componentes principales del laboratorio.
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
- Consultar registros mediante `journalctl`.
- Interpretar ficheros YAML.
- Utilizar permisos administrativos con `sudo`.
- Preparar un directorio de trabajo.
- Instalar Grafana.
- Instalar Prometheus.
- Instalar Node Exporter.
- Comprobar los endpoints HTTP.
- Configurar objetivos de *scraping*.
- Validar objetivos de Prometheus.
- Ejecutar consultas PromQL básicas.
- Crear evidencias del estado del laboratorio.
- Diagnosticar problemas iniciales de instalación y conectividad.

---

## Arquitectura del laboratorio

La arquitectura básica está formada por un servidor Ubuntu con los tres componentes principales.

```text
Servidor Ubuntu
├── Grafana
├── Prometheus
└── Node Exporter
```

### Función de cada componente

| Componente | Función | Puerto habitual |
|---|---|---:|
| Node Exporter | Expone métricas del sistema operativo | 9100 |
| Prometheus | Recopila y almacena métricas | 9090 |
| Grafana | Visualiza métricas y crea dashboards | 3000 |
| PromQL | Lenguaje de consulta de Prometheus | No aplica |

### Flujo completo de los datos

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

El recorrido de una métrica es el siguiente:

1. El sistema operativo genera información.
2. Node Exporter recopila esa información.
3. Node Exporter publica las métricas en el puerto `9100`.
4. Prometheus consulta periódicamente el endpoint.
5. Prometheus almacena las muestras.
6. Grafana consulta Prometheus mediante PromQL.
7. Grafana representa los datos en dashboards.
8. Las alertas pueden detectar condiciones anómalas.

### Comunicación entre componentes

| Origen | Destino | Protocolo | Puerto | Finalidad |
|---|---|---|---:|---|
| Prometheus | Node Exporter | HTTP | 9100 | Recopilar métricas |
| Grafana | Prometheus | HTTP | 9090 | Ejecutar consultas |
| Navegador | Grafana | HTTP o HTTPS | 3000 | Acceder a la interfaz |
| Administrador | Servidor | SSH o consola | 22 | Administrar el laboratorio |

### Modelo de recopilación *pull*

Prometheus utiliza normalmente un modelo *pull*. Esto significa que Prometheus inicia las conexiones y consulta periódicamente a los objetivos.

```text
Prometheus ---- solicitud HTTP ----> Node Exporter
Prometheus <--- métricas ------------ Node Exporter
```

Node Exporter no envía activamente los datos a Prometheus. En su lugar, mantiene disponible un endpoint HTTP:

```text
http://localhost:9100/metrics
```

Prometheus consulta dicho endpoint según el intervalo definido en su fichero de configuración.

---

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

Comprobar la versión instalada:

```bash
lsb_release -a
```

También puede consultarse el fichero del sistema:

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

Consultar información completa del sistema:

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

---

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
---
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

Una indentación incorrecta puede impedir que Prometheus arranque.

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

---

## Preparación del entorno de trabajo

### Actualizar los paquetes

Actualizar la información de los repositorios:

```bash
sudo apt update
```

Actualizar los paquetes instalados:

```bash
sudo apt upgrade -y
```

También puede utilizarse:

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
  apt-transport-https \
  yamllint
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

Crear los subdirectorios:

```bash
mkdir -p \
  configuracion \
  descargas \
  evidencias \
  scripts
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

---

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

Consultar sus grupos:

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

Registrar los datos:

```text
Usuario principal: ______________________
UID: ____________________________________
Grupo principal: ________________________
¿Pertenece a sudo?: _____________________
```

### Usuarios de servicio

Los servicios deberían ejecutarse con usuarios específicos cuando sea posible.

| Usuario o cuenta | Servicio | Función |
|---|---|---|
| `grafana` | Grafana | Ejecutar Grafana |
| `prometheus` | Prometheus | Ejecutar Prometheus |
| Cuenta del paquete | Node Exporter | Exponer métricas |

En Ubuntu, el usuario exacto de Node Exporter puede depender del paquete y de la versión instalada. Por ello, debe comprobarse mediante `systemctl`.

Consultar las cuentas existentes:

```bash
getent passwd grafana
getent passwd prometheus
getent passwd node_exporter
getent passwd prometheus-node-exporter
```

### Comprobar el usuario de ejecución

Para Grafana:

```bash
systemctl show grafana-server -p User
```

Para Prometheus:

```bash
systemctl show prometheus -p User
```

Para Node Exporter instalado mediante APT:

```bash
systemctl show prometheus-node-exporter -p User
```

También pueden consultarse los procesos:

```bash
ps -ef | grep '[g]rafana'
ps -ef | grep '[p]rometheus'
ps -ef | grep '[p]rometheus-node'
```

### Recomendaciones de seguridad

- No ejecutar aplicaciones como `root` si no es necesario.
- No compartir contraseñas entre alumnos.
- Utilizar usuarios de servicio.
- No exponer el laboratorio directamente a Internet.
- Utilizar una red interna, VPN o cortafuegos.
- Mantener actualizado el sistema.
- Revisar los permisos de los ficheros.
- No guardar credenciales en repositorios públicos.
- No incluir contraseñas en capturas de pantalla.
- No incluir secretos en ficheros de evidencias.
- No utilizar el laboratorio sobre sistemas de producción.

---

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

---

## Sesión 2: comprobar los recursos del sistema

### Objetivo

Verificar que el equipo tiene recursos suficientes para ejecutar el laboratorio.

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

### Consultar el almacenamiento

```bash
df -h
```

Consultar los dispositivos:

```bash
lsblk
```

Consultar el tamaño del directorio personal:

```bash
du -sh "$HOME"
```

### Consultar la carga del sistema

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

### Actividades

1. ¿Cuánta memoria total tiene el equipo?
2. ¿Cuántos procesadores están disponibles?
3. ¿Cuánto espacio libre existe en `/`?
4. ¿Qué proceso consume más CPU?
5. ¿Qué proceso consume más memoria?
6. ¿La carga del sistema parece normal?

---

## Sesión 3: comprobar la red

### Objetivo

Verificar que el equipo tiene conectividad y resolución de nombres.

### Consultar las interfaces

```bash
ip address
```

Mostrar únicamente las direcciones IPv4:

```bash
ip -4 address
```

### Consultar las rutas

```bash
ip route
```

Consultar la puerta de enlace:

```bash
ip route | grep default
```

### Consultar la dirección IP

```bash
hostname -I
```

También puede utilizarse:

```bash
ip -4 addr show
```

### Comprobar la resolución DNS

```bash
getent hosts archive.ubuntu.com
```

### Probar la conectividad IP

```bash
ping -c 4 8.8.8.8
```

### Probar la conectividad mediante nombre

```bash
ping -c 4 archive.ubuntu.com
```

### Probar el acceso HTTPS

```bash
curl -I https://grafana.com
```

### Interpretar los resultados

| Prueba | Resultado | Interpretación |
|---|---|---|
| `ip address` | Hay una IP | La interfaz tiene configuración |
| `ip route` | Hay una ruta `default` | Existe una puerta de enlace |
| `getent hosts` | Devuelve una IP | DNS funciona |
| `ping` | Recibe respuestas | Hay conectividad IP |
| `curl -I` | Devuelve un código HTTP | El acceso HTTP funciona |

### Actividades

1. Identifica la dirección IP.
2. Identifica la puerta de enlace.
3. Comprueba la resolución DNS.
4. Comprueba el acceso HTTPS.
5. Explica la diferencia entre conectividad IP y resolución DNS.

---

## Sesión 4: comprobar la sincronización horaria

### Objetivo

Verificar que el reloj del sistema está sincronizado.

### Comandos

Consultar el estado:

```bash
timedatectl status
```

Consultar si está sincronizado:

```bash
timedatectl show -p NTPSynchronized --value
```

Consultar la zona horaria:

```bash
timedatectl show -p Timezone --value
```

Consultar la hora local:

```bash
date
```

Consultar la hora UTC:

```bash
date -u
```

Consultar los servidores de sincronización:

```bash
timedatectl show-timesync --all
```

Resultado esperado:

```text
yes
```

### Importancia de la sincronización horaria

La hora es importante para:

- Ordenar correctamente las muestras.
- Interpretar dashboards.
- Comparar periodos.
- Analizar incidencias.
- Correlacionar métricas y logs.
- Evaluar alertas.

### Actividades

1. Comprueba si el reloj está sincronizado.
2. Identifica la zona horaria.
3. Compara la hora local con UTC.
4. Explica cómo una diferencia de varios minutos puede afectar a Grafana.
5. Explica cómo puede afectar a una alerta o a una comparación temporal.

---

## Sesión 5: comprobar los puertos

### Objetivo

Verificar que los puertos necesarios están libres antes de la instalación y ocupados por el proceso correcto después de la instalación.

### Comprobar todos los puertos TCP

```bash
sudo ss -lntp
```

### Comprobar un puerto concreto

```bash
sudo ss -lntp | grep ':3000'
```

### Comprobar los puertos del laboratorio

```bash
for port in 3000 9090 9100; do
  echo "Puerto $port:"
  sudo ss -lnt "( sport = :$port )"
done
```

También puede utilizarse:

```bash
sudo lsof -nP -iTCP:3000 -sTCP:LISTEN
```

### Identificar los procesos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

Una salida posible es:

```text
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1500,fd=9))
```

### Actividades

1. Comprueba si el puerto `3000` está ocupado.
2. Comprueba si el puerto `9090` está ocupado.
3. Comprueba si el puerto `9100` está ocupado.
4. Identifica los procesos asociados.
5. Explica por qué dos servicios no pueden escuchar en la misma dirección y puerto.

---

## Sesión 6: comprobar servicios con systemd

### Objetivo

Aprender a consultar servicios antes y después de la instalación.

### Consultar un servicio

```bash
systemctl status ssh
```

### Comprobar si está activo

```bash
systemctl is-active ssh
```

### Comprobar si arranca automáticamente

```bash
systemctl is-enabled ssh
```

### Consultar los servicios fallidos

```bash
systemctl --failed
```

### Consultar registros

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

---

## Sesión 7: instalar Grafana

### Objetivo

Instalar Grafana y comprobar que el servicio funciona.

### Instalar los paquetes auxiliares

```bash
sudo apt update
sudo apt install -y apt-transport-https wget gnupg
```

### Crear el directorio de claves

```bash
sudo mkdir -p /etc/apt/keyrings
```

### Añadir la clave del repositorio

```bash
wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

### Añadir el repositorio

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
```

### Instalar Grafana

```bash
sudo apt update
sudo apt install -y grafana
```

### Activar e iniciar el servicio

```bash
sudo systemctl enable --now grafana-server
```

### Comprobar el estado

```bash
systemctl status grafana-server --no-pager
```

Comprobar únicamente si está activo:

```bash
systemctl is-active grafana-server
```

Comprobar si arranca automáticamente:

```bash
systemctl is-enabled grafana-server
```

### Consultar la versión

```bash
grafana-server -v
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':3000'
```

### Probar la respuesta HTTP

```bash
curl -I http://localhost:3000
```

Grafana puede responder con un código `302`, que normalmente indica una redirección hacia la página de inicio de sesión.

### Consultar los registros

```bash
sudo journalctl -u grafana-server --no-pager -n 30
```

### Acceder desde el navegador

```text
http://IP_DEL_SERVIDOR:3000
```

Ejemplo:

```text
http://192.168.1.50:3000
```

Después de iniciar sesión, cambia la contraseña predeterminada si la instalación la utiliza.

---

## Sesión 8: instalar Prometheus y Node Exporter mediante APT

### Objetivo

Instalar Prometheus y Node Exporter mediante los paquetes disponibles en Ubuntu.

> **Importante:** no crees manualmente el usuario `prometheus` antes de instalar el paquete. Ubuntu gestiona automáticamente las cuentas y permisos necesarios.

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

Durante la instalación se crearán normalmente estos servicios:

```text
prometheus.service
prometheus-node-exporter.service
```

### Comprobar los paquetes instalados

```bash
dpkg -l | grep -E 'prometheus|node-exporter'
```

Comprobar si existen paquetes pendientes de configurar:

```bash
sudo dpkg --audit
```

Si la instalación ha quedado interrumpida:

```bash
sudo dpkg --configure -a
```

Después:

```bash
sudo apt-get -f install
```

### Comprobar los servicios

Comprobar Prometheus:

```bash
systemctl status prometheus --no-pager
```

Comprobar Node Exporter:

```bash
systemctl status prometheus-node-exporter --no-pager
```

Comprobar únicamente si están activos:

```bash
systemctl is-active prometheus
systemctl is-active prometheus-node-exporter
```

### Activar los servicios al arrancar

```bash
sudo systemctl enable --now prometheus
sudo systemctl enable --now prometheus-node-exporter
```

### Comprobar los puertos

```bash
sudo ss -lntp | grep -E ':9090|:9100'
```

Prometheus utiliza normalmente el puerto `9090` y Node Exporter el puerto `9100`.

### Consultar las versiones

```bash
prometheus --version
promtool --version
prometheus-node-exporter --version
```

En algunas instalaciones, el ejecutable puede estar disponible con otro nombre. Compruébalo con:

```bash
command -v prometheus
command -v promtool
command -v prometheus-node-exporter
command -v node_exporter
```

### Consultar la configuración del servicio

```bash
sudo systemctl cat prometheus
```

Consultar los parámetros de inicio:

```bash
systemctl show prometheus -p ExecStart
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
sudo stat -c '%U:%G %n' /var/lib/prometheus
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
curl -s http://localhost:9100/metrics | head
```

La respuesta debe contener métricas similares a:

```text
node_uname_info
node_cpu_seconds_total
node_memory_MemTotal_bytes
```

### Consultar los registros

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

---

## Sesión 9: resolver un conflicto en el puerto 9100

### Descripción del problema

El error:

```text
bind: address already in use
```

indica que otro proceso ya está utilizando el puerto `9100`.

Una causa habitual es tener dos servicios de Node Exporter:

```text
node_exporter.service
prometheus-node-exporter.service
```

Solo debe existir una instancia escuchando en el puerto `9100`.

### Identificar el proceso que utiliza el puerto

```bash
sudo ss -lntp | grep ':9100'
```

También puede utilizarse:

```bash
sudo lsof -nP -iTCP:9100 -sTCP:LISTEN
```

### Consultar los servicios relacionados

```bash
systemctl list-units --type=service --all \
  | grep -Ei 'node|exporter'
```

### Solución recomendada

Si se desea utilizar el paquete instalado mediante APT, debe conservarse:

```text
prometheus-node-exporter.service
```

Detener y deshabilitar el servicio manual duplicado:

```bash
sudo systemctl disable --now node_exporter.service
```

Comprobar su estado:

```bash
systemctl is-active node_exporter.service
```

Resultado esperado:

```text
inactive
```

Comprobar si el puerto ha quedado libre:

```bash
sudo ss -lntp | grep ':9100'
```

Si no aparece ninguna salida, el puerto está libre.

Reiniciar el servicio instalado mediante APT:

```bash
sudo systemctl reset-failed prometheus-node-exporter.service
sudo systemctl enable --now prometheus-node-exporter.service
```

Comprobar el estado:

```bash
systemctl is-active prometheus-node-exporter.service
```

Resultado esperado:

```text
active
```

### Verificar el endpoint de métricas

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

### Comprobar ambos servicios

```bash
systemctl list-units --type=service --all \
  | grep -Ei 'node_exporter|prometheus-node-exporter'
```

El resultado esperado es aproximadamente:

```text
node_exporter.service                  inactive
prometheus-node-exporter.service       active
```

### Si el servicio antiguo vuelve a arrancar

Puede bloquearse temporalmente:

```bash
sudo systemctl mask node_exporter.service
```

Después, reiniciar el servicio correcto:

```bash
sudo systemctl reset-failed prometheus-node-exporter.service
sudo systemctl restart prometheus-node-exporter.service
```

Para retirar la máscara:

```bash
sudo systemctl unmask node_exporter.service
```

### Secuencia completa

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
- Endpoint `/metrics`: responde correctamente.

---

## Sesión 10: configurar Prometheus

### Objetivo

Configurar Prometheus para recopilar métricas del propio Prometheus y de Node Exporter.

### Crear una copia de seguridad

```bash
sudo cp \
  /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

Comprobar la copia:

```bash
sudo ls -l /etc/prometheus/prometheus.yml*
```

### Consultar la configuración actual

```bash
sudo cat /etc/prometheus/prometheus.yml
```

### Editar el fichero

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Utilizar una configuración como esta:

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

### Configuración con etiquetas

También pueden añadirse etiquetas:

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

### Validar la sintaxis YAML

```bash
yamllint /etc/prometheus/prometheus.yml
```

Comprobar si existen tabuladores:

```bash
grep -n $'\t' /etc/prometheus/prometheus.yml
```

### Validar la configuración de Prometheus

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado, aproximadamente:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: 0 rule files found
```

`yamllint` comprueba la sintaxis general de YAML. `promtool` comprueba que el contenido sea válido para Prometheus.

### Comprobar los permisos de lectura

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
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

Consultar los últimos registros:

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

### Comprobar la salud

```bash
curl -s http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

---

## Sesión 11: comprobar los objetivos de Prometheus

### Objetivo

Verificar que Prometheus puede consultar correctamente a Node Exporter.

### Consultar todos los objetivos

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

### Mostrar los nombres de los trabajos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq -r '.data.activeTargets[].labels.job'
```

### Consultar el estado de cada objetivo

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

Ejemplo:

```text
prometheus      localhost:9090  up
node_exporter   localhost:9100  up
```

También puede abrirse la página de objetivos:

```text
http://localhost:9090/targets
```

### Interpretar el estado

```text
up
```

Indica que Prometheus ha podido consultar correctamente el objetivo.

```text
down
```

Indica que Prometheus conoce el objetivo, pero no ha podido recopilar sus métricas.

### Posibles causas de un objetivo `down`

- Servicio detenido.
- Puerto incorrecto.
- URL incorrecta.
- Error de red.
- Firewall.
- Node Exporter no está escuchando.
- Problema de permisos.
- Error en la configuración.
- Prometheus no se ha reiniciado después de modificarla.

### Comprobar Node Exporter directamente

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

---

## Sesión 12: ejecutar consultas PromQL

### Objetivo

Consultar métricas almacenadas en Prometheus.

Las consultas pueden ejecutarse desde:

```text
http://localhost:9090/graph
```

También pueden ejecutarse mediante la API de Prometheus.

### Consultar la disponibilidad

```promql
up
```

Filtrar Node Exporter:

```promql
up{job="node_exporter"}
```

### Consultar el tiempo de actividad

```promql
node_time_seconds - node_boot_time_seconds
```

### Consultar la memoria total

```promql
node_memory_MemTotal_bytes
```

### Consultar la memoria disponible

```promql
node_memory_MemAvailable_bytes
```

### Consultar el número de CPUs

```promql
count by (instance) (
  node_cpu_seconds_total{mode="idle"}
)
```

### Calcular el porcentaje de CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Esta consulta:

1. Calcula la velocidad de cambio de la métrica en los últimos cinco minutos.
2. Selecciona el modo `idle`.
3. Calcula la media por instancia.
4. Convierte el tiempo libre en porcentaje.
5. Resta el resultado a `100`.
6. Obtiene el porcentaje aproximado de CPU utilizada.

### Calcular el porcentaje de memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Calcular el porcentaje de almacenamiento utilizado

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

### Consultar tráfico recibido

```promql
rate(node_network_receive_bytes_total[5m])
```

### Consultar tráfico enviado

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Actividades

1. Consulta `up`.
2. Filtra el objetivo `node_exporter`.
3. Calcula el uso de CPU.
4. Calcula el uso de memoria.
5. Consulta el espacio utilizado.
6. Identifica las interfaces de red.
7. Agrupa los resultados por `instance`.
8. Registra la unidad de cada consulta.

---

## Sesión 13: consultar Prometheus mediante la API

### Objetivo

Ejecutar consultas PromQL desde la terminal sin utilizar todavía la interfaz gráfica.

### Consultar `up`

```bash
curl -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

Mostrar el resultado con formato legible:

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Mostrar los objetivos activos

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

### Consultar la memoria total

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_memory_MemTotal_bytes' \
  | jq
```

### Consultar el uso de CPU

```bash
curl -s -G http://localhost:9090/api/v1/query \
  --data-urlencode \
  'query=100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)' \
  | jq
```

### Registro de resultados

```text
Consulta:

Número de series:

Etiquetas:

Valor:

Unidad:

Resultado:
```

---

## Sesión 14: comprobar Grafana

### Objetivo

Verificar que Grafana responde y acceder a su interfaz.

### Probar la conexión local

```bash
curl -I http://localhost:3000
```

### Probar mediante la dirección IP

```bash
curl -I http://$(hostname -I | awk '{print $1}'):3000
```

### Acceder desde el navegador

```text
http://IP_DEL_SERVIDOR:3000
```

Ejemplo:

```text
http://192.168.1.50:3000
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server --no-pager -n 30
```

Consultar los registros desde el último arranque:

```bash
sudo journalctl -u grafana-server -b --no-pager
```

---

## Sesión 15: añadir Prometheus como fuente de datos en Grafana

### Objetivo

Conectar Grafana con Prometheus.

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

Si Grafana y Prometheus están en máquinas distintas, no debe utilizarse `localhost`. En ese caso, debe utilizarse la dirección accesible desde Grafana:

```text
http://IP_DE_PROMETHEUS:9090
```

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

---

## Sesión 16: crear un informe de estado

### Objetivo

Crear un informe sencillo con el estado del entorno.

### Crear el directorio de evidencias

```bash
mkdir -p ~/laboratorio-grafana/evidencias
```

### Crear el informe

En una instalación mediante APT, el nombre correcto del servicio de Node Exporter es `prometheus-node-exporter`:

```bash
cat > ~/laboratorio-grafana/evidencias/estado-laboratorio.txt <<EOF
Fecha: $(date)
Hostname: $(hostname)
IP: $(hostname -I | awk '{print $1}')
Sistema: $(lsb_release -ds)
Arquitectura: $(uname -m)
Kernel: $(uname -r)

Estado de los servicios:
Grafana: $(systemctl is-active grafana-server 2>/dev/null || echo no-disponible)
Prometheus: $(systemctl is-active prometheus 2>/dev/null || echo no-disponible)
Node Exporter: $(systemctl is-active prometheus-node-exporter 2>/dev/null || echo no-disponible)

Puertos:
$(sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true)
EOF
```

Consultar el informe:

```bash
cat ~/laboratorio-grafana/evidencias/estado-laboratorio.txt
```

### Actividad

Añadir manualmente:

- Nombre del alumno.
- Grupo.
- Fecha de realización.
- Incidencias encontradas.
- Soluciones aplicadas.
- Observaciones finales.

---

## Script de comprobación completa

### Crear el script

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

servicios=(
  "grafana-server|Grafana"
  "prometheus|Prometheus"
  "prometheus-node-exporter|Node Exporter"
)

for entrada in "${servicios[@]}"; do
  unidad="${entrada%%|*}"
  nombre="${entrada##*|}"

  printf "%-20s" "$nombre"

  if systemctl is-active --quiet "$unidad"; then
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

### Dar permisos de ejecución

```bash
chmod +x ~/laboratorio-grafana/scripts/comprobar-entorno.sh
```

### Ejecutar el script

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

== Servicios ==
Grafana              activo
Prometheus           activo
Node Exporter        activo

== HTTP ==
Grafana: HTTP 302
Prometheus: HTTP 200
Node Exporter: HTTP 200
```

Un código HTTP `302` en Grafana no indica necesariamente un error. Normalmente significa que Grafana está redirigiendo hacia la página de inicio de sesión.

---

## Diagnóstico básico

### Grafana no responde

Comprobar el servicio:

```bash
systemctl status grafana-server
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':3000'
```

Probar localmente:

```bash
curl -I http://localhost:3000
```

Consultar los registros:

```bash
sudo journalctl -u grafana-server --no-pager -n 50
```

Posibles causas:

- El servicio está detenido.
- El puerto está ocupado.
- La configuración contiene errores.
- El proceso no tiene permisos.
- La interfaz todavía está iniciándose.

### Prometheus no responde

Comprobar el servicio:

```bash
systemctl status prometheus
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9090'
```

Comprobar la salud:

```bash
curl http://localhost:9090/-/healthy
```

Consultar los registros:

```bash
sudo journalctl -u prometheus --no-pager -n 50
```

Validar la configuración:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### Node Exporter no responde

Para la instalación mediante APT:

```bash
systemctl status prometheus-node-exporter
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9100'
```

Probar el endpoint:

```bash
curl -I http://localhost:9100/metrics
```

Consultar los registros:

```bash
sudo journalctl -u prometheus-node-exporter \
  --no-pager \
  -n 50
```

Posibles causas:

- Servicio detenido.
- Puerto ocupado.
- Dos instancias de Node Exporter.
- Error en la unidad systemd.
- Binario inexistente.
- Problema de permisos.
- Configuración incorrecta.

### Prometheus muestra un objetivo `down`

Comprobar directamente el endpoint:

```bash
curl -I http://localhost:9100/metrics
```

Consultar los detalles del objetivo:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[] | {
      job: .labels.job,
      instance: .labels.instance,
      health: .health,
      lastError: .lastError
    }'
```

Revisar:

- Que Node Exporter esté iniciado.
- Que el puerto sea correcto.
- Que el hostname sea resoluble.
- Que exista conectividad entre los servicios.
- Que no haya un firewall bloqueando el acceso.
- Que la configuración de Prometheus sea válida.
- Que Prometheus se haya reiniciado después de modificarla.

### Grafana no puede conectar con Prometheus

Desde el servidor, comprobar:

```bash
curl http://localhost:9090/-/healthy
```

Si ambos servicios están en el mismo servidor, la URL habitual es:

```text
http://localhost:9090
```

Si están en servidores distintos, utilizar:

```text
http://IP_DE_PROMETHEUS:9090
```

No utilizar `localhost` si Grafana y Prometheus se ejecutan en máquinas diferentes.

---

## Verificación final del entorno

El entorno se considera preparado cuando:

- Se ha identificado el sistema operativo.
- Se ha registrado el hostname.
- Se ha registrado la dirección IP.
- Se han comprobado los recursos disponibles.
- Se han identificado las versiones de los componentes.
- Grafana responde en el puerto `3000`.
- Prometheus responde en el puerto `9090`.
- Node Exporter responde en el puerto `9100`.
- Prometheus muestra sus objetivos en estado `up`.
- Los usuarios de servicio están identificados.
- La hora del sistema está sincronizada.
- Se ha completado la ficha final.
- Se ha guardado un informe de evidencias.
- Grafana utiliza Prometheus como fuente de datos.

---

## Puntos clave

- Grafana proporciona la interfaz de visualización.
- Prometheus recopila y almacena series temporales.
- Node Exporter expone métricas del sistema operativo.
- PromQL permite consultar las métricas almacenadas.
- Prometheus utiliza normalmente un modelo *pull*.
- Grafana utiliza normalmente el puerto `3000`.
- Prometheus utiliza normalmente el puerto `9090`.
- Node Exporter utiliza normalmente el puerto `9100`.
- Prometheus consulta a Node Exporter mediante HTTP.
- Grafana consulta Prometheus mediante PromQL.
- La dirección `localhost` hace referencia al equipo desde el que se realiza la conexión.
- La hora del sistema es importante para interpretar las muestras.
- `systemctl` permite consultar el estado de los servicios.
- `journalctl` permite investigar errores.
- `curl` permite validar rápidamente los endpoints HTTP.
- La métrica `up` permite comprobar si un objetivo está disponible.
- Un entorno correctamente documentado facilita el diagnóstico.
- Solo debe existir una instancia de Node Exporter escuchando en el puerto `9100`.
- En Ubuntu, el servicio instalado mediante APT se llama `prometheus-node-exporter`.
- La configuración YAML debe validarse con `promtool`.

---

## Preguntas de comprobación

1. ¿Qué versión de Ubuntu utiliza el entorno de laboratorio?
2. ¿Qué comando permite consultar el hostname?
3. ¿Qué comando muestra la dirección IP del servidor?
4. ¿Qué función cumple Grafana?
5. ¿Qué función cumple Prometheus?
6. ¿Qué función cumple Node Exporter?
7. ¿Qué puerto utiliza normalmente Grafana?
8. ¿Qué puerto utiliza normalmente Prometheus?
9. ¿Qué puerto utiliza normalmente Node Exporter?
10. ¿Qué significa que un objetivo de Prometheus tenga el estado `up`?
11. ¿Qué diferencia existe entre `localhost` y una dirección IP de red?
12. ¿Por qué Grafana necesita acceder a Prometheus?
13. ¿Por qué Prometheus necesita acceder a Node Exporter?
14. ¿Qué comando permite comprobar si un puerto está en escucha?
15. ¿Qué comando permite consultar los registros de un servicio?
16. ¿Qué información proporciona el endpoint `/metrics`?
17. ¿Qué usuario debería ejecutar normalmente un servicio de monitorización?
18. ¿Qué problema puede producir una hora incorrecta en el servidor?
19. ¿Cómo comprobarías si Grafana está respondiendo?
20. ¿Cómo comprobarías si Prometheus puede consultar Node Exporter?
21. ¿Qué significa el valor `up = 1`?
22. ¿Qué significa el valor `up = 0`?
23. ¿Qué diferencia existe entre `active` y `enabled`?
24. ¿Qué puede provocar un error `address already in use`?
25. ¿Cómo solucionarías un conflicto en el puerto `9100`?
26. ¿Qué diferencia existe entre `yamllint` y `promtool`?
27. ¿Por qué no debe crearse manualmente el usuario `prometheus` antes de instalar el paquete?
28. ¿Qué información debe registrarse en la ficha del entorno?
29. ¿Qué evidencias demuestran que la instalación es correcta?
30. ¿Qué información no debe aparecer en las capturas?

---

## Ficha final del entorno

Completar esta ficha después de realizar las verificaciones.

### Datos generales

| Propiedad | Valor |
|---|---|
| Alumno | |
| Grupo | |
| Fecha | |
| Distribución | Ubuntu |
| Versión | |
| Hostname | |
| Dirección IP | |
| Arquitectura | |
| Kernel | |
| CPUs | |
| Memoria total | |
| Espacio libre en `/` | |
| Zona horaria | |
| Usuario principal | |

### Estado de los servicios

| Servicio | Unidad systemd | Versión | Puerto | Estado | Inicio automático |
|---|---|---:|---:|---|---|
| Grafana | `grafana-server` | | 3000 | | |
| Prometheus | `prometheus` | | 9090 | | |
| Node Exporter | `prometheus-node-exporter` | | 9100 | | |

### Resultado de las pruebas

| Prueba | Resultado | Observaciones |
|---|---|---|
| Sistema operativo | | |
| Arquitectura | | |
| Recursos | | |
| Red | | |
| DNS | | |
| Sincronización horaria | | |
| Puerto 3000 | | |
| Puerto 9090 | | |
| Puerto 9100 | | |
| Grafana | | |
| Prometheus | | |
| Node Exporter | | |
| Objetivos de Prometheus | | |
| Consulta `up` | | |
| Fuente de datos de Grafana | | |

### Incidencias encontradas

```text
Incidencia 1:

Causa:

Solución aplicada:


Incidencia 2:

Causa:

Solución aplicada:
```

---

## Resultado esperado

Al finalizar la guía, el entorno deberá presentar una estructura similar a esta:

```text
Ubuntu
  |
  +--> Grafana activo en el puerto 3000
  |
  +--> Prometheus activo en el puerto 9090
  |
  +--> Node Exporter activo en el puerto 9100
```

Además, deberá poder demostrarse que:

```text
Grafana responde por HTTP.
Prometheus responde por HTTP.
Node Exporter expone /metrics.
Prometheus consulta a Node Exporter.
El objetivo node_exporter aparece como UP.
La consulta up devuelve datos.
Las consultas de CPU devuelven datos.
Las consultas de memoria devuelven datos.
Las consultas de almacenamiento devuelven datos.
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