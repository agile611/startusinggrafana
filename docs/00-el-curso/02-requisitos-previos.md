# Requisitos previos

Esta sección describe los conocimientos, herramientas y condiciones necesarias para realizar correctamente el curso de Grafana, Prometheus y Node Exporter.

El curso tiene un enfoque práctico. Por ello, no basta con conocer los conceptos teóricos: también será necesario trabajar con una terminal Linux, editar ficheros de configuración, consultar servicios y analizar resultados.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Comprobar que su entorno de trabajo cumple los requisitos del curso.
- Identificar la versión del sistema operativo y del kernel.
- Utilizar comandos básicos de Linux desde la terminal.
- Consultar el estado de servicios mediante `systemctl`.
- Comprobar puertos y conexiones de red.
- Editar ficheros de texto y configuración.
- Interpretar estructuras básicas en formato YAML.
- Comprender el uso de permisos administrativos mediante `sudo`.
- Verificar la conectividad entre Grafana, Prometheus y Node Exporter.
- Preparar un entorno de laboratorio reproducible.
- Identificar los problemas más habituales antes de comenzar las prácticas.

---

## Introducción

Grafana y Prometheus son herramientas que funcionan como servicios dentro de un sistema Linux. Durante el curso será necesario instalar paquetes, modificar ficheros, consultar puertos y revisar registros.

El alumno trabajará principalmente con:

- Ubuntu.
- La terminal.
- Servicios gestionados por `systemd`.
- Ficheros de configuración.
- Protocolos HTTP.
- Puertos TCP.
- YAML.
- Métricas de series temporales.
- Consultas PromQL.

El curso no exige experiencia avanzada de administración de sistemas. Sin embargo, sí requiere una base mínima para ejecutar comandos, interpretar salidas y resolver errores sencillos.

Una buena preparación evita problemas posteriores. Antes de configurar un dashboard, es necesario verificar que el sistema, la red y los servicios funcionan correctamente.

---

## Requisitos del sistema

### Sistema operativo

El entorno recomendado es:

```text
Ubuntu 24.04.5 LTS
```

También pueden utilizarse otras versiones recientes de Ubuntu, aunque los nombres de algunos paquetes o las rutas de configuración podrían variar.

Comprobar la versión instalada:

```bash
lsb_release -a
```

Ejemplo de salida:

```console
$ lsb_release -a
Distributor ID: Ubuntu
Description:    Ubuntu 24.04.5 LTS
Release:        24.04.5 LTS
Codename:       noble
```

También se puede consultar el fichero de identificación del sistema:

```bash
cat /etc/os-release
```

### Arquitectura del sistema

Comprobar la arquitectura:

```bash
uname -m
```

Resultado habitual:

```text
x86_64
```

La arquitectura `x86_64` también puede aparecer como `amd64`.

### Recursos recomendados

Para el laboratorio se recomienda disponer, como mínimo, de:

| Recurso | Mínimo recomendado |
|---|---:|
| CPU | 2 núcleos |
| Memoria RAM | 4 GB |
| Almacenamiento libre | 20 GB |
| Sistema operativo | Ubuntu 24.04.5 LTS |
| Acceso administrativo | Usuario con `sudo` |
| Red | Acceso a Internet |
| Navegador | Chrome, Firefox o Chromium |

Estos valores son suficientes para realizar las prácticas del curso en un entorno de laboratorio.

---

## Conocimientos recomendados

### Linux básico

El alumno debe conocer, al menos de forma introductoria:

- Navegación por directorios.
- Creación y eliminación de ficheros.
- Lectura de ficheros de texto.
- Uso de rutas absolutas y relativas.
- Redirecciones.
- Tuberías.
- Búsqueda de texto.
- Permisos básicos.
- Procesos y servicios.

Ejemplos de comandos habituales:

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
- Qué es `localhost`.
- Qué significa escuchar en una dirección.
- Qué función cumple HTTP.
- Qué diferencia existe entre un servicio local y uno remoto.

Durante el curso se utilizarán, entre otros, estos puertos:

| Servicio | Puerto habitual | Función |
|---|---:|---|
| Grafana | 3000 | Interfaz web |
| Prometheus | 9090 | Interfaz y API |
| Node Exporter | 9100 | Endpoint de métricas |

### Ficheros YAML

Prometheus utiliza YAML para su configuración. Es importante respetar:

- La indentación.
- Los dos puntos.
- La estructura de listas.
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

Ejemplo incorrecto:

```yaml
global:
 scrape_interval: 15s

scrape_configs:
- job_name: node_exporter
  static_configs:
  - targets:
    - localhost:9100
```

Aunque algunos analizadores pueden aceptar ciertas variantes, una indentación inconsistente facilita los errores de configuración.

### Permisos administrativos

Muchas tareas requieren privilegios de administrador:

```bash
sudo apt update
sudo systemctl restart prometheus
sudo nano /etc/prometheus/prometheus.yml
```

El usuario debe poder ejecutar comandos con `sudo`.

Comprobar los permisos:

```bash
sudo -v
```

Si el comando no muestra ningún error, las credenciales administrativas son válidas.

---

## Preparación del entorno

### Actualizar los paquetes

Antes de comenzar, actualizar la información de los repositorios:

```bash
sudo apt update
```

Actualizar los paquetes instalados:

```bash
sudo apt upgrade
```

Durante un laboratorio también puede utilizarse:

```bash
sudo apt update && sudo apt upgrade -y
```

### Instalar herramientas básicas

Instalar las herramientas que se utilizarán durante el curso:

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

### Crear un directorio de trabajo

Crear un directorio para los ficheros temporales del laboratorio:

```bash
mkdir -p ~/laboratorio-grafana
```

Entrar en el directorio:

```bash
cd ~/laboratorio-grafana
```

Comprobar la ubicación:

```bash
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

---

# Sesiones prácticas

Las siguientes sesiones permiten comprobar progresivamente que el entorno está preparado.

---

## Sesión 1: identificar el sistema

### Objetivo

Recopilar información básica del equipo donde se realizará el laboratorio.

### Comandos

Consultar el nombre del equipo:

```bash
hostname
```

Consultar información detallada:

```bash
hostnamectl
```

Consultar la versión de Ubuntu:

```bash
lsb_release -a
```

Consultar la versión del kernel:

```bash
uname -r
```

Consultar la arquitectura:

```bash
uname -m
```

Consultar la fecha y la hora:

```bash
date
```

Consultar la zona horaria:

```bash
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
6. Explica por qué la hora del sistema es importante en una plataforma de monitorización.

---

## Sesión 2: comprobar los recursos del sistema

### Objetivo

Verificar que el equipo dispone de recursos suficientes para el laboratorio.

### Consultar la memoria

```bash
free -h
```

Ejemplo:

```console
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.1Gi       720Mi        18Mi       2.0Gi       2.4Gi
Swap:          2.0Gi          0B       2.0Gi
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

Consultar el espacio del directorio personal:

```bash
du -sh "$HOME"
```

### Consultar la carga del sistema

```bash
uptime
```

Consultar procesos activos:

```bash
ps aux --sort=-%cpu | head
```

Consultar los procesos que más memoria consumen:

```bash
ps aux --sort=-%mem | head
```

### Actividades

1. ¿Cuánta memoria total tiene el equipo?
2. ¿Cuántos procesadores están disponibles?
3. ¿Cuánto espacio libre existe en el sistema de ficheros raíz?
4. ¿Qué proceso consume más CPU?
5. ¿Qué proceso consume más memoria?
6. ¿La carga del sistema parece normal?

---

## Sesión 3: trabajar con ficheros y directorios

### Objetivo

Practicar operaciones básicas sobre ficheros de configuración.

Entrar en el directorio de laboratorio:

```bash
cd ~/laboratorio-grafana
```

Crear un fichero de prueba:

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

Consultar las últimas líneas:

```bash
tail configuracion/prueba.conf
```

Buscar una propiedad:

```bash
grep "puerto" configuracion/prueba.conf
```

Copiar el fichero:

```bash
cp configuracion/prueba.conf configuracion/prueba.conf.bak
```

Comparar los dos ficheros:

```bash
diff configuracion/prueba.conf configuracion/prueba.conf.bak
```

Eliminar el fichero de prueba:

```bash
rm configuracion/prueba.conf
rm configuracion/prueba.conf.bak
```

### Actividades

1. Crea un fichero llamado `servidor.conf`.
2. Añade el nombre del servidor.
3. Añade el entorno.
4. Añade los puertos de Grafana, Prometheus y Node Exporter.
5. Crea una copia de seguridad.
6. Modifica el fichero original.
7. Utiliza `diff` para comprobar el cambio.

Ejemplo:

```text
nombre=monitoring-lab
entorno=laboratorio
grafana_port=3000
prometheus_port=9090
node_exporter_port=9100
```

---

## Sesión 4: permisos y usuario administrativo

### Objetivo

Comprobar el usuario actual y practicar operaciones que requieren permisos elevados.

Consultar el usuario actual:

```bash
whoami
```

Consultar la identidad completa:

```bash
id
```

Consultar los grupos:

```bash
groups
```

Comprobar si se puede utilizar `sudo`:

```bash
sudo -v
```

Consultar permisos de un fichero:

```bash
ls -l /etc/hosts
```

Crear un fichero temporal con permisos administrativos:

```bash
sudo touch /tmp/laboratorio-grafana.txt
```

Cambiar el propietario:

```bash
sudo chown "$USER":"$USER" /tmp/laboratorio-grafana.txt
```

Comprobar el resultado:

```bash
ls -l /tmp/laboratorio-grafana.txt
```

Eliminar el fichero:

```bash
rm /tmp/laboratorio-grafana.txt
```

### Actividades

1. Identifica el usuario actual.
2. Comprueba si pertenece al grupo `sudo`.
3. Explica la diferencia entre ejecutar un comando como usuario normal y utilizar `sudo`.
4. Comprueba quién es el propietario de `/etc/hosts`.
5. Crea un fichero temporal y cambia su propietario.

---

## Sesión 5: comprobar la red

### Objetivo

Verificar que el sistema tiene conectividad y que puede acceder a los servicios necesarios.

Consultar las interfaces de red:

```bash
ip address
```

Consultar las rutas:

```bash
ip route
```

Comprobar la puerta de enlace:

```bash
ip route | grep default
```

Comprobar resolución DNS:

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

Comprobar acceso HTTPS:

```bash
curl -I https://grafana.com
```

Comprobar la respuesta de Ubuntu:

```bash
curl -I https://archive.ubuntu.com
```

### Ejemplo de sesión

```console
$ getent hosts archive.ubuntu.com
185.125.190.39 archive.ubuntu.com

$ curl -I https://grafana.com
HTTP/2 200
content-type: text/html
```

### Diferencias importantes

Si funciona:

```bash
ping -c 4 8.8.8.8
```

pero falla:

```bash
ping -c 4 archive.ubuntu.com
```

es posible que exista un problema de resolución DNS.

Si falla también la conexión a `8.8.8.8`, puede existir un problema de red, de ruta o de cortafuegos.

### Actividades

1. Identifica la dirección IP del equipo.
2. Identifica la puerta de enlace predeterminada.
3. Comprueba si funciona la resolución DNS.
4. Comprueba el acceso a una página HTTPS.
5. Explica la diferencia entre conectividad IP y resolución DNS.

---

## Sesión 6: comprobar puertos disponibles

### Objetivo

Verificar que los puertos necesarios no están ocupados antes de instalar los servicios.

Consultar todos los puertos TCP en escucha:

```bash
sudo ss -lntp
```

Consultar un puerto concreto:

```bash
sudo ss -lntp | grep ':3000'
```

Comprobar los puertos del curso:

```bash
for port in 3000 9090 9100; do
  echo "Puerto $port:"
  sudo ss -lnt "( sport = :$port )"
done
```

También se puede utilizar `lsof`:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Interpretación

Si no aparece ninguna salida para un puerto, normalmente significa que ningún proceso está escuchando en él.

Si aparece un proceso, hay que identificarlo:

```bash
sudo ss -lntp | grep ':3000'
```

Ejemplo:

```console
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1500,fd=8))
```

### Actividades

1. Comprueba si el puerto `3000` está disponible.
2. Comprueba si el puerto `9090` está disponible.
3. Comprueba si el puerto `9100` está disponible.
4. Si alguno está ocupado, identifica el proceso.
5. Explica por qué dos servicios no pueden escuchar simultáneamente en la misma dirección y puerto.

---

## Sesión 7: comprobar servicios con systemd

### Objetivo

Aprender a consultar servicios antes de instalar Grafana, Prometheus y Node Exporter.

Consultar el estado del servicio SSH:

```bash
systemctl status ssh
```

Comprobar si está activo:

```bash
systemctl is-active ssh
```

Comprobar si está habilitado:

```bash
systemctl is-enabled ssh
```

Consultar los servicios fallidos:

```bash
systemctl --failed
```

Consultar los últimos registros de un servicio:

```bash
sudo journalctl -u ssh --no-pager -n 30
```

Consultar registros recientes:

```bash
sudo journalctl --since "30 minutes ago"
```

### Diferencia entre estados

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

## Sesión 8: validar sintaxis YAML

### Objetivo

Comprender la estructura básica de un fichero YAML antes de trabajar con Prometheus.

Instalar un analizador YAML:

```bash
sudo apt install -y yamllint
```

Crear un fichero de prueba:

```bash
cat > ~/laboratorio-grafana/configuracion/ejemplo.yml <<'EOF'
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

### Reglas importantes

YAML utiliza espacios para representar niveles.

Correcto:

```yaml
servidor:
  nombre: monitoring-lab
  puerto: 9090
```

Incorrecto:

```yaml
servidor:
 nombre: monitoring-lab
  puerto: 9090
```

También hay que evitar tabuladores:

```bash
grep -n $'\t' ~/laboratorio-grafana/configuracion/ejemplo.yml
```

Si no aparece ninguna salida, no se han encontrado tabuladores.

### Actividades

1. Crea un fichero YAML con información del laboratorio.
2. Valida su sintaxis.
3. Introduce deliberadamente un error de indentación.
4. Ejecuta `yamllint`.
5. Corrige el error.
6. Explica por qué una indentación incorrecta puede impedir que Prometheus arranque.

---

## Sesión 9: comprobar la hora y la sincronización

### Objetivo

Verificar que el sistema tiene una hora correcta y sincronizada.

Consultar el estado:

```bash
timedatectl status
```

Comprobar si el reloj está sincronizado:

```bash
timedatectl show -p NTPSynchronized --value
```

Consultar la fecha UTC:

```bash
date -u
```

Consultar la fecha local:

```bash
date
```

Consultar la zona horaria:

```bash
timedatectl show -p Timezone --value
```

### Ejemplo de resultado

```console
$ timedatectl show -p NTPSynchronized --value
yes

$ timedatectl show -p Timezone --value
Europe/Madrid
```

### Actividades

1. Comprueba si NTP está sincronizado.
2. Anota la zona horaria.
3. Compara la hora local con la hora UTC.
4. Explica cómo una hora incorrecta puede afectar a un dashboard.
5. Explica cómo puede afectar a una comparación temporal.

---

## Sesión 10: prueba completa de preparación

### Objetivo

Ejecutar una comprobación general antes de comenzar la instalación.

Crear un script de diagnóstico:

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
getent hosts archive.ubuntu.com || true

echo
echo "== Puertos del laboratorio =="
for port in 3000 9090 9100; do
  if ss -lnt "( sport = :$port )" | grep -q LISTEN; then
    echo "Puerto $port: ocupado"
  else
    echo "Puerto $port: disponible"
  fi
done

echo
echo "== Servicios fallidos =="
systemctl --failed --no-legend || true
EOF
```

Dar permisos de ejecución:

```bash
chmod +x ~/laboratorio-grafana/scripts/comprobar-entorno.sh
```

Ejecutar el script:

```bash
~/laboratorio-grafana/scripts/comprobar-entorno.sh
```

Guardar el resultado:

```bash
~/laboratorio-grafana/scripts/comprobar-entorno.sh \
  | tee ~/laboratorio-grafana/evidencias/comprobacion-entorno.txt
```

### Actividades

1. Ejecuta el script.
2. Guarda la salida.
3. Revisa si existe algún puerto ocupado.
4. Revisa si existen servicios fallidos.
5. Comprueba la conectividad.
6. Entrega el fichero de evidencias.

---

# Errores frecuentes

## El usuario no puede utilizar sudo

Comprobar los grupos:

```bash
groups
```

Si el usuario no pertenece al grupo adecuado, será necesario utilizar una cuenta administrativa para corregirlo.

No se deben compartir contraseñas administrativas entre alumnos.

## No hay conexión a Internet

Comprobar en este orden:

```bash
ip address
ip route
getent hosts archive.ubuntu.com
curl -I https://archive.ubuntu.com
```

La comprobación debe avanzar desde la configuración local hasta el acceso HTTP.

## El puerto ya está ocupado

Identificar el proceso:

```bash
sudo ss -lntp | grep ':3000'
```

O utilizar:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

No se debe detener un servicio desconocido sin identificar previamente su función.

## El sistema tiene poco espacio libre

Consultar el espacio:

```bash
df -h
```

Localizar directorios grandes:

```bash
sudo du -xh /var 2>/dev/null | sort -h | tail
```

No se deben borrar ficheros del sistema sin conocer su finalidad.

## La hora no está sincronizada

Consultar el estado:

```bash
timedatectl status
```

Una hora incorrecta puede provocar:

- Métricas con marcas temporales inesperadas.
- Dashboards aparentemente vacíos.
- Comparaciones temporales incorrectas.
- Problemas de certificados HTTPS.
- Confusión al analizar registros.

## El fichero YAML no es válido

Validar con:

```bash
yamllint fichero.yml
```

Revisar especialmente:

- Espacios.
- Indentación.
- Dos puntos.
- Guiones de las listas.
- Comillas.
- Tabuladores.

---

## Puntos clave

- El laboratorio requiere un sistema Linux funcional y actualizado.
- Ubuntu 24.04.5 LTS es el entorno recomendado.
- El usuario debe poder utilizar `sudo`.
- Grafana utiliza normalmente el puerto `3000`.
- Prometheus utiliza normalmente el puerto `9090`.
- Node Exporter utiliza normalmente el puerto `9100`.
- Los puertos deben comprobarse antes de iniciar la instalación.
- La conectividad de red es necesaria para descargar paquetes y componentes.
- `systemctl` permite consultar y administrar servicios.
- `journalctl` permite consultar registros de servicios.
- La hora del sistema debe estar sincronizada.
- YAML utiliza espacios e indentación significativa.
- Los ficheros de configuración deben validarse antes de reiniciar servicios.
- Es recomendable guardar evidencias de las comprobaciones.
- Un entorno preparado reduce considerablemente los problemas durante las prácticas.

---

## Preguntas de comprobación

### Sistema operativo

1. ¿Qué versión de Ubuntu se recomienda para el curso?
2. ¿Qué comando muestra la arquitectura del sistema?
3. ¿Qué comando permite consultar la versión del kernel?
4. ¿Qué información proporciona `hostnamectl`?

### Recursos

5. ¿Qué comando muestra la memoria disponible?
6. ¿Qué comando permite consultar el espacio libre?
7. ¿Qué comando muestra el número de procesadores?
8. ¿Qué diferencia existe entre `free` y `available` en la salida de `free -h`?

### Permisos

9. ¿Para qué sirve `sudo`?
10. ¿Qué comando permite comprobar la identidad del usuario?
11. ¿Qué diferencia existe entre un usuario normal y un usuario con privilegios administrativos?

### Red y puertos

12. ¿Qué comando muestra las interfaces de red?
13. ¿Qué comando muestra la ruta predeterminada?
14. ¿Qué puerto utiliza normalmente Grafana?
15. ¿Qué puerto utiliza normalmente Prometheus?
16. ¿Qué puerto utiliza normalmente Node Exporter?
17. ¿Cómo identificarías el proceso que ocupa el puerto `3000`?

### Servicios

18. ¿Qué diferencia existe entre un servicio `active` y uno `enabled`?
19. ¿Qué comando muestra los servicios fallidos?
20. ¿Qué comando permite consultar los registros de Prometheus?

### YAML

21. ¿Por qué es importante la indentación en YAML?
22. ¿Qué problema puede producir un tabulador en un fichero YAML?
23. ¿Qué herramienta puede utilizarse para validar YAML?
24. ¿Qué diferencia existe entre una lista y una propiedad en YAML?

### Tiempo

25. ¿Cómo comprobarías si el reloj está sincronizado?
26. ¿Por qué es importante la sincronización temporal?
27. ¿Qué problemas puede causar una diferencia de hora entre Grafana y Prometheus?

---

## Práctica final de preparación

Antes de comenzar el siguiente bloque, el alumno debe realizar las siguientes tareas:

1. Comprobar la versión de Ubuntu.
2. Comprobar la arquitectura.
3. Consultar los recursos disponibles.
4. Crear el directorio `~/laboratorio-grafana`.
5. Instalar las herramientas básicas.
6. Comprobar que puede utilizar `sudo`.
7. Comprobar la conectividad a Internet.
8. Revisar los puertos `3000`, `9090` y `9100`.
9. Comprobar la sincronización horaria.
10. Validar un fichero YAML.
11. Ejecutar el script de diagnóstico.
12. Guardar el resultado en la carpeta `evidencias`.

El resultado esperado es un fichero similar a:

```text
~/laboratorio-grafana/evidencias/comprobacion-entorno.txt
```

---

## Criterios de finalización

El entorno se considera preparado cuando:

- Ubuntu está correctamente identificado.
- El usuario puede utilizar `sudo`.
- Hay suficiente memoria y almacenamiento.
- La red funciona correctamente.
- Los puertos del laboratorio están disponibles.
- La hora está sincronizada.
- Las herramientas básicas están instaladas.
- El fichero YAML de prueba es válido.
- No existen servicios críticos en estado `failed`.
- El script de comprobación se ejecuta sin errores importantes.

Una vez completadas estas comprobaciones, el alumno puede comenzar la instalación y configuración de Grafana, Prometheus y Node Exporter.