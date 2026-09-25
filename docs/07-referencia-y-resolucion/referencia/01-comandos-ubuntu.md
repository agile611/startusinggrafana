# Comandos de Ubuntu

Esta página reúne los comandos de Ubuntu más utilizados durante el curso de Grafana, Prometheus y Node Exporter. Los ejemplos están pensados para ejecutarse en un entorno de laboratorio controlado.

> **Advertencia:** algunos comandos requieren permisos de administrador. Utiliza `sudo` únicamente cuando sea necesario y revisa siempre el comando antes de ejecutarlo.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Consultar información básica del sistema.
- Identificar la versión de Ubuntu y la arquitectura del equipo.
- Gestionar ficheros y directorios desde la terminal.
- Consultar procesos y servicios.
- Comprobar puertos y conexiones de red.
- Revisar registros del sistema.
- Utilizar permisos de administrador de forma segura.
- Ejecutar comprobaciones básicas sobre Grafana, Prometheus y Node Exporter.
- Documentar los comandos utilizados y sus resultados.

## Introducción

La terminal de Ubuntu permite administrar el sistema de forma precisa y repetible. Durante las prácticas de observabilidad se utilizará para:

- Instalar servicios.
- Crear usuarios y directorios.
- Modificar ficheros de configuración.
- Iniciar y detener servicios.
- Consultar registros.
- Comprobar puertos.
- Probar endpoints HTTP.
- Diagnosticar problemas.

Los comandos no deben ejecutarse de forma mecánica. Es importante entender qué información devuelve cada uno y cómo utilizarla para tomar decisiones.

## Recomendaciones para trabajar con la terminal

Antes de ejecutar un comando:

1. Lee la orden completa.
2. Comprueba si necesita `sudo`.
3. Revisa los ficheros o directorios que modifica.
4. Comprueba que estás trabajando en el equipo correcto.
5. Guarda los resultados importantes.
6. Evita copiar comandos que no comprendas.

### Mostrar el usuario actual

```bash
whoami
```

Ejemplo de resultado:

```text
guillem
```

### Mostrar el directorio actual

```bash
pwd
```

Ejemplo de resultado:

```text
/home/guillem
```

### Limpiar la pantalla

```bash
clear
```

También puedes utilizar el atajo de teclado:

```text
Ctrl + L
```

### Consultar la ayuda de un comando

```bash
man ls
```

Para salir del manual, pulsa:

```text
q
```

También puedes utilizar:

```bash
ls --help
```

## Información básica del sistema

Estos comandos permiten identificar el sistema operativo, el núcleo y la arquitectura.

### Consultar el nombre del equipo

```bash
hostname
```

Para consultar información más completa:

```bash
hostnamectl
```

Ejemplo:

```text
Static hostname: laboratorio
Operating System: Ubuntu 24.04.5 LTS
Kernel: Linux 6.8.0
Architecture: x86-64
```

### Consultar la versión de Ubuntu

```bash
lsb_release -a
```

Para mostrar únicamente la descripción:

```bash
lsb_release -ds
```

También puedes consultar el fichero de identificación del sistema:

```bash
cat /etc/os-release
```

### Consultar la versión del núcleo

```bash
uname -r
```

Para mostrar toda la información disponible:

```bash
uname -a
```

### Consultar la arquitectura

```bash
uname -m
```

Resultados habituales:

```text
x86_64
```

o:

```text
aarch64
```

### Consultar la fecha y la hora

```bash
date
```

Para consultar la zona horaria:

```bash
timedatectl
```

### Consultar el tiempo que lleva encendido el sistema

```bash
uptime
```

Una salida posible:

```text
11:30:42 up 2 days, 4:15, 1 user, load average: 0.08, 0.05, 0.01
```

## Navegación por directorios

### Listar el contenido de un directorio

```bash
ls
```

Mostrar información detallada:

```bash
ls -l
```

Incluir ficheros ocultos:

```bash
ls -la
```

Mostrar tamaños de forma legible:

```bash
ls -lah
```

### Cambiar de directorio

```bash
cd /var/log
```

Volver al directorio personal:

```bash
cd ~
```

Volver al directorio anterior:

```bash
cd -
```

Subir un nivel:

```bash
cd ..
```

### Crear un directorio

```bash
mkdir laboratorio
```

Crear una estructura completa de directorios:

```bash
mkdir -p laboratorio/config/prometheus
```

### Eliminar un directorio vacío

```bash
rmdir laboratorio
```

Para eliminar un directorio con contenido:

```bash
rm -r laboratorio
```

> **Precaución:** `rm -r` elimina el contenido de forma recursiva. Comprueba siempre la ruta antes de ejecutarlo.

## Gestión de ficheros

### Crear un fichero vacío

```bash
touch notas.txt
```

Crear varios ficheros:

```bash
touch cpu.txt memoria.txt almacenamiento.txt
```

### Copiar un fichero

```bash
cp notas.txt copia-notas.txt
```

Copiar un directorio completo:

```bash
cp -r laboratorio laboratorio-copia
```

### Mover o renombrar un fichero

```bash
mv notas.txt notas-laboratorio.txt
```

Mover un fichero a otro directorio:

```bash
mv notas-laboratorio.txt laboratorio/
```

### Eliminar un fichero

```bash
rm notas-laboratorio.txt
```

### Mostrar el contenido de un fichero

```bash
cat /etc/os-release
```

Para leer un fichero largo página a página:

```bash
less /var/log/syslog
```

Para salir de `less`:

```text
q
```

### Mostrar las primeras líneas

```bash
head /etc/os-release
```

Mostrar las primeras 20 líneas:

```bash
head -n 20 /var/log/syslog
```

### Mostrar las últimas líneas

```bash
tail /var/log/syslog
```

Seguir un fichero en tiempo real:

```bash
tail -f /var/log/syslog
```

Para detener el seguimiento:

```text
Ctrl + C
```

## Búsqueda de ficheros y texto

### Buscar un fichero por nombre

```bash
find /etc -name "prometheus.yml"
```

Buscar en una ruta concreta:

```bash
find /etc/prometheus -type f
```

Buscar únicamente directorios:

```bash
find /var -type d -name "log"
```

### Buscar texto dentro de un fichero

```bash
grep "listen" /etc/prometheus/prometheus.yml
```

Ignorar mayúsculas y minúsculas:

```bash
grep -i "error" /var/log/syslog
```

Mostrar los números de línea:

```bash
grep -n "job_name" /etc/prometheus/prometheus.yml
```

Buscar recursivamente en un directorio:

```bash
grep -R "node_exporter" /etc/prometheus
```

### Combinar comandos con una tubería

La tubería `|` utiliza la salida de un comando como entrada del siguiente.

```bash
systemctl list-units --type=service | grep grafana
```

Otro ejemplo:

```bash
ps aux | grep prometheus
```

Para evitar que aparezca el propio comando `grep`:

```bash
ps aux | grep "[p]rometheus"
```

## Usuarios, grupos y permisos

### Consultar el usuario actual

```bash
whoami
```

### Consultar la identidad completa

```bash
id
```

### Consultar los usuarios del sistema

```bash
cut -d: -f1 /etc/passwd
```

### Consultar los grupos del usuario actual

```bash
groups
```

### Consultar los permisos de un fichero

```bash
ls -l /etc/prometheus/prometheus.yml
```

Ejemplo:

```text
-rw-r----- 1 prometheus prometheus 1234 Sep 25 10:15 prometheus.yml
```

La información muestra:

```text
permisos propietario grupo tamaño fecha nombre
```

### Utilizar `sudo`

Ejecutar un comando con permisos administrativos:

```bash
sudo systemctl status prometheus
```

Abrir una shell administrativa:

```bash
sudo -i
```

> Es preferible utilizar `sudo` delante del comando concreto en lugar de mantener una shell administrativa abierta durante toda la sesión.

### Cambiar el propietario de un fichero

```bash
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

### Cambiar permisos

```bash
sudo chmod 640 /etc/prometheus/prometheus.yml
```

Los permisos numéricos más habituales son:

| Valor | Permiso |
|---:|---|
| 7 | Lectura, escritura y ejecución |
| 6 | Lectura y escritura |
| 5 | Lectura y ejecución |
| 4 | Solo lectura |
| 0 | Sin permisos |

## Procesos del sistema

### Mostrar procesos activos

```bash
ps aux
```

### Buscar un proceso concreto

```bash
ps aux | grep "[p]rometheus"
```

### Consultar procesos en tiempo real

```bash
top
```

Una alternativa más completa, si está instalada:

```bash
htop
```

Para salir:

```text
q
```

o:

```text
Ctrl + C
```

### Consultar el consumo de memoria

```bash
free -h
```

### Consultar el espacio de almacenamiento

```bash
df -h
```

Consultar el espacio de una ruta concreta:

```bash
df -h /
```

### Consultar el tamaño de un directorio

```bash
du -sh /var/lib/prometheus
```

Consultar el tamaño de sus subdirectorios:

```bash
du -h --max-depth=1 /var/lib/prometheus
```

## Servicios con systemd

Ubuntu utiliza `systemd` para gestionar muchos servicios del sistema.

### Consultar el estado de un servicio

```bash
systemctl status grafana-server
```

```bash
systemctl status prometheus
```

```bash
systemctl status node_exporter
```

### Comprobar si un servicio está activo

```bash
systemctl is-active grafana-server
```

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
active
```

### Comprobar si un servicio se inicia automáticamente

```bash
systemctl is-enabled grafana-server
```

```bash
systemctl is-enabled prometheus
```

```bash
systemctl is-enabled node_exporter
```

Resultado esperado:

```text
enabled
```

### Iniciar un servicio

```bash
sudo systemctl start grafana-server
```

### Detener un servicio

```bash
sudo systemctl stop grafana-server
```

### Reiniciar un servicio

```bash
sudo systemctl restart grafana-server
```

### Recargar la configuración de systemd

Después de crear o modificar una unidad:

```bash
sudo systemctl daemon-reload
```

### Activar un servicio al arrancar

```bash
sudo systemctl enable grafana-server
```

Activar y arrancar en una sola orden:

```bash
sudo systemctl enable --now grafana-server
```

### Consultar los servicios fallidos

```bash
systemctl --failed
```

## Registros del sistema

Los registros son una fuente esencial para diagnosticar problemas.

### Consultar los registros de un servicio

```bash
sudo journalctl -u grafana-server
```

```bash
sudo journalctl -u prometheus
```

```bash
sudo journalctl -u node_exporter
```

### Consultar los registros desde el último arranque

```bash
sudo journalctl -u prometheus -b
```

### Mostrar las últimas líneas

```bash
sudo journalctl -u prometheus -n 50
```

### Seguir los registros en tiempo real

```bash
sudo journalctl -u prometheus -f
```

Detener el seguimiento:

```text
Ctrl + C
```

### Mostrar errores recientes

```bash
sudo journalctl -p err -b
```

### Consultar los registros de una franja temporal

```bash
sudo journalctl -u prometheus --since "10 minutes ago"
```

```bash
sudo journalctl -u grafana-server --since today
```

## Red y conectividad

### Consultar las interfaces de red

```bash
ip addr
```

Mostrar únicamente las direcciones:

```bash
hostname -I
```

### Consultar las rutas de red

```bash
ip route
```

### Probar la conectividad con otro equipo

```bash
ping -c 4 8.8.8.8
```

Probar un nombre de dominio:

```bash
ping -c 4 example.com
```

### Consultar la resolución DNS

```bash
resolvectl status
```

Consultar una resolución concreta:

```bash
resolvectl query example.com
```

### Consultar los puertos en escucha

```bash
sudo ss -lntp
```

Consultar los puertos de Grafana, Prometheus y Node Exporter:

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

La expresión busca:

| Puerto | Servicio |
|---:|---|
| 3000 | Grafana |
| 9090 | Prometheus |
| 9100 | Node Exporter |

### Comprobar un puerto concreto

```bash
sudo ss -lntp | grep ':3000'
```

Si no devuelve ninguna línea, no hay ningún proceso escuchando en ese puerto.

## Peticiones HTTP con curl

`curl` permite comprobar si un servicio HTTP responde.

### Comprobar Grafana

```bash
curl -I http://localhost:3000
```

### Comprobar Prometheus

```bash
curl -I http://localhost:9090
```

### Comprobar el endpoint de métricas

```bash
curl -I http://localhost:9100/metrics
```

### Mostrar las primeras métricas de Node Exporter

```bash
curl -s http://localhost:9100/metrics | head
```

### Comprobar la salud de Prometheus

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Consultar la API de targets

```bash
curl -s http://localhost:9090/api/v1/targets
```

Si `jq` está instalado, puedes formatear la salida:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

## Instalación de paquetes

### Actualizar la información de paquetes

```bash
sudo apt update
```

### Actualizar los paquetes instalados

```bash
sudo apt upgrade
```

### Instalar un paquete

```bash
sudo apt install curl
```

Instalar varios paquetes:

```bash
sudo apt install curl wget jq tree
```

### Consultar si un paquete está instalado

```bash
dpkg -l | grep curl
```

También puedes utilizar:

```bash
apt policy curl
```

### Buscar un paquete

```bash
apt search prometheus
```

### Eliminar un paquete

```bash
sudo apt remove nombre-del-paquete
```

Eliminar también los ficheros de configuración:

```bash
sudo apt purge nombre-del-paquete
```

## Redirecciones y salida de comandos

### Guardar la salida en un fichero

```bash
hostnamectl > sistema.txt
```

Esto sobrescribe el fichero si ya existe.

### Añadir información al final de un fichero

```bash
date >> sistema.txt
```

### Ver la salida y guardarla simultáneamente

```bash
hostnamectl | tee sistema.txt
```

Añadir al final:

```bash
date | tee -a sistema.txt
```

### Redirigir errores

```bash
comando-inexistente 2> errores.txt
```

Redirigir la salida normal y los errores:

```bash
comando-inexistente > salida.txt 2> errores.txt
```

## Variables de entorno

### Mostrar las variables de entorno

```bash
env
```

### Consultar una variable concreta

```bash
echo "$HOME"
```

```bash
echo "$PATH"
```

### Crear una variable temporal

```bash
export ENTORNO=lab
```

Consultar su valor:

```bash
echo "$ENTORNO"
```

Esta variable desaparece al cerrar la sesión de terminal.

## Sesión práctica 1: reconocimiento del sistema

En esta sesión el alumno recopilará información básica del equipo de laboratorio.

### Objetivo

Crear un informe básico con:

- Nombre del equipo.
- Usuario actual.
- Versión de Ubuntu.
- Versión del núcleo.
- Arquitectura.
- Dirección IP.
- Tiempo de actividad.
- Espacio disponible.
- Memoria disponible.

### Preparación

Crear un directorio para los resultados:

```bash
mkdir -p ~/laboratorio/comandos-ubuntu
cd ~/laboratorio/comandos-ubuntu
```

### Recopilación de información

Ejecutar:

```bash
{
  echo "===== INFORME DEL SISTEMA ====="
  echo
  echo "Fecha:"
  date
  echo
  echo "Usuario:"
  whoami
  echo
  echo "Nombre del equipo:"
  hostname
  echo
  echo "Sistema operativo:"
  lsb_release -ds
  echo
  echo "Núcleo:"
  uname -r
  echo
  echo "Arquitectura:"
  uname -m
  echo
  echo "Direcciones IP:"
  hostname -I
  echo
  echo "Tiempo de actividad:"
  uptime
  echo
  echo "Memoria:"
  free -h
  echo
  echo "Almacenamiento:"
  df -h /
} | tee informe-sistema.txt
```

### Revisar el informe

```bash
less informe-sistema.txt
```

### Comprobar el resultado

El fichero debe existir:

```bash
test -f informe-sistema.txt && echo "Informe creado correctamente"
```

### Evidencia

Conserva:

```text
informe-sistema.txt
```

También puedes realizar una captura de:

- La terminal con el informe.
- El fichero abierto.
- La ruta del directorio de trabajo.

## Sesión práctica 2: comprobar servicios y puertos

En esta sesión se comprobará el estado de Grafana, Prometheus y Node Exporter.

### Objetivo

Determinar si:

- Los tres servicios están activos.
- Los servicios están habilitados al arrancar.
- Los puertos esperados están en escucha.
- Los endpoints HTTP responden.

### Comprobar el estado de los servicios

```bash
for service in grafana-server prometheus node_exporter; do
  echo "===== $service ====="
  echo -n "Estado: "
  systemctl is-active "$service"
  echo -n "Inicio automático: "
  systemctl is-enabled "$service" 2>/dev/null || true
  echo
done
```

### Comprobar los puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

### Comprobar los endpoints

```bash
for url in \
  http://localhost:3000 \
  http://localhost:9090 \
  http://localhost:9100/metrics
do
  echo "===== $url ====="
  curl -I --max-time 5 "$url"
  echo
done
```

### Interpretar los resultados

| Resultado | Interpretación |
|---|---|
| `active` | El servicio está activo |
| `inactive` | El servicio está detenido |
| `failed` | El servicio ha fallado |
| `enabled` | Se iniciará automáticamente |
| `disabled` | No se iniciará automáticamente |
| `HTTP/1.1 200` | El endpoint responde correctamente |
| `Connection refused` | No hay servicio escuchando |
| `Connection timed out` | Puede existir un problema de red o cortafuegos |

### Evidencia

Guarda la salida:

```bash
{
  echo "===== SERVICIOS ====="
  systemctl is-active grafana-server
  systemctl is-active prometheus
  systemctl is-active node_exporter
  echo
  echo "===== PUERTOS ====="
  sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true
  echo
  echo "===== TARGETS ====="
  curl -s http://localhost:9090/api/v1/targets
} | tee comprobacion-servicios.txt
```

## Sesión práctica 3: diagnosticar un servicio detenido

En esta sesión se simulará una incidencia controlada deteniendo Node Exporter.

> Realiza esta actividad únicamente en el entorno de laboratorio.

### Objetivo

Observar el ciclo completo de diagnóstico:

1. Detener el servicio.
2. Detectar el problema.
3. Revisar el estado.
4. Consultar los registros.
5. Volver a iniciar el servicio.
6. Verificar la recuperación.

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Comprobar el estado

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
inactive
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

No debería aparecer ninguna línea.

### Probar el endpoint

```bash
curl -I --max-time 5 http://localhost:9100/metrics
```

Resultado esperado:

```text
curl: (7) Failed to connect to localhost port 9100
```

### Consultar los registros

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

### Recuperar el servicio

```bash
sudo systemctl start node_exporter
```

### Verificar la recuperación

```bash
systemctl is-active node_exporter
```

```bash
curl -I http://localhost:9100/metrics
```

Resultado esperado:

```text
active
```

y una respuesta HTTP correcta del endpoint.

### Comprobar el target en Prometheus

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

En la interfaz de Prometheus también puedes consultar:

```promql
up
```

El objetivo de Node Exporter debería volver a mostrar el valor:

```text
1
```

### Preguntas de la sesión

- ¿Qué resultado devolvió `systemctl is-active node_exporter` cuando el servicio estaba detenido?
- ¿Qué ocurrió al consultar el puerto `9100`?
- ¿Qué respuesta devolvió `curl`?
- ¿Qué comando permitió recuperar el servicio?
- ¿Qué valor mostró la consulta `up` antes y después de la recuperación?

## Sesión práctica 4: localizar un fichero de configuración

En esta sesión se practicarán comandos de búsqueda y consulta de ficheros.

### Objetivo

Localizar y consultar la configuración de Prometheus.

### Buscar el fichero

```bash
sudo find /etc -type f -name "prometheus.yml"
```

### Consultar el fichero

Si la ruta habitual existe:

```bash
sudo less /etc/prometheus/prometheus.yml
```

### Buscar los trabajos configurados

```bash
sudo grep -n "job_name" /etc/prometheus/prometheus.yml
```

### Buscar Node Exporter

```bash
sudo grep -n -i "node_exporter" /etc/prometheus/prometheus.yml
```

### Mostrar los permisos

```bash
sudo ls -l /etc/prometheus/prometheus.yml
```

### Validar la configuración

Si `promtool` está instalado:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: ...
```

### Documentar el resultado

```bash
{
  echo "Fichero:"
  sudo find /etc -type f -name "prometheus.yml"
  echo
  echo "Trabajos configurados:"
  sudo grep -n "job_name" /etc/prometheus/prometheus.yml
  echo
  echo "Permisos:"
  sudo ls -l /etc/prometheus/prometheus.yml
} | tee configuracion-prometheus.txt
```

## Sesión práctica 5: crear un informe de diagnóstico

Esta sesión integra varios comandos para elaborar un informe técnico.

### Objetivo

Crear un informe que permita conocer el estado general del entorno.

### Crear el script

```bash
mkdir -p ~/laboratorio/comandos-ubuntu
cd ~/laboratorio/comandos-ubuntu
nano diagnostico-entorno.sh
```

Escribe el contenido siguiente:

```bash
#!/usr/bin/env bash

set -u

echo "===== DIAGNÓSTICO DEL ENTORNO ====="
echo "Fecha: $(date)"
echo

echo "===== SISTEMA ====="
hostname
lsb_release -ds
uname -r
uname -m
echo

echo "===== RED ====="
hostname -I
echo

echo "===== MEMORIA ====="
free -h
echo

echo "===== ALMACENAMIENTO ====="
df -h /
echo

echo "===== SERVICIOS ====="
for service in grafana-server prometheus node_exporter; do
  printf "%-20s: " "$service"
  systemctl is-active "$service" 2>/dev/null || true
done
echo

echo "===== PUERTOS ====="
sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true
echo

echo "===== ENDPOINTS ====="
for url in \
  http://localhost:3000 \
  http://localhost:9090 \
  http://localhost:9100/metrics
do
  printf "%-45s: " "$url"
  curl -s -o /dev/null -w "%{http_code}\n" \
    --max-time 5 "$url" || true
done
```

### Conceder permiso de ejecución

```bash
chmod +x diagnostico-entorno.sh
```

### Ejecutar el script

```bash
./diagnostico-entorno.sh
```

Guardar el resultado:

```bash
./diagnostico-entorno.sh | tee diagnostico-entorno.txt
```

### Revisar el informe

```bash
less diagnostico-entorno.txt
```

### Mejoras propuestas

Añade al script:

- Comprobación de la configuración de Prometheus.
- Comprobación de la API de targets.
- Consulta del estado de Grafana.
- Fecha de la última modificación de los ficheros de configuración.
- Comprobación del espacio disponible en `/var/lib/prometheus`.

## Comandos relacionados con el laboratorio

### Grafana

Consultar el estado:

```bash
systemctl status grafana-server
```

Consultar los registros:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

Comprobar la interfaz:

```bash
curl -I http://localhost:3000
```

### Prometheus

Consultar el estado:

```bash
systemctl status prometheus
```

Consultar los registros:

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

Comprobar la salud:

```bash
curl http://localhost:9090/-/healthy
```

Comprobar los targets:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

### Node Exporter

Consultar el estado:

```bash
systemctl status node_exporter
```

Consultar los registros:

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

Comprobar el endpoint:

```bash
curl -s http://localhost:9100/metrics | head
```

Buscar una métrica concreta:

```bash
curl -s http://localhost:9100/metrics | grep "^node_cpu_seconds_total" | head
```

## Resumen de comandos principales

| Necesidad | Comando |
|---|---|
| Usuario actual | `whoami` |
| Directorio actual | `pwd` |
| Versión de Ubuntu | `lsb_release -ds` |
| Información del sistema | `hostnamectl` |
| Memoria disponible | `free -h` |
| Espacio disponible | `df -h` |
| Procesos activos | `ps aux` |
| Puertos en escucha | `sudo ss -lntp` |
| Estado de un servicio | `systemctl status servicio` |
| Actividad de un servicio | `systemctl is-active servicio` |
| Registros de un servicio | `journalctl -u servicio` |
| Contenido de un fichero | `cat fichero` |
| Buscar texto | `grep texto fichero` |
| Buscar ficheros | `find ruta -name nombre` |
| Probar HTTP | `curl -I URL` |
| Seguir registros | `journalctl -u servicio -f` |

## Puntos clave

- `pwd` muestra el directorio actual.
- `ls -la` muestra todos los ficheros, incluidos los ocultos.
- `cp` copia ficheros o directorios.
- `mv` mueve o renombra elementos.
- `rm` elimina ficheros; úsalo con precaución.
- `grep` busca texto dentro de ficheros.
- `find` localiza ficheros y directorios.
- `systemctl` gestiona servicios.
- `journalctl` consulta los registros de `systemd`.
- `ss` muestra puertos y conexiones.
- `curl` permite comprobar endpoints HTTP.
- `sudo` concede permisos administrativos para un comando concreto.
- Las tuberías `|` permiten combinar comandos.
- `tee` permite visualizar y guardar una salida.
- Los comandos de diagnóstico deben ejecutarse en un orden lógico.
- Una incidencia debe documentar el síntoma, la comprobación, la causa y la solución.

## Preguntas de comprobación

1. ¿Qué comando permite consultar el usuario actual?
2. ¿Qué diferencia existe entre `pwd` y `ls`?
3. ¿Qué opción de `ls` permite mostrar ficheros ocultos?
4. ¿Qué comando permite conocer la versión de Ubuntu?
5. ¿Qué comando permite comprobar la memoria disponible?
6. ¿Qué comando permite comprobar el espacio disponible en la raíz del sistema?
7. ¿Qué diferencia existe entre `systemctl status` y `systemctl is-active`?
8. ¿Qué comando permite consultar los registros de Prometheus?
9. ¿Qué comando permite comprobar si el puerto `9100` está en escucha?
10. ¿Qué endpoint proporciona las métricas de Node Exporter?
11. ¿Qué comando permite comprobar la salud de Prometheus?
12. ¿Qué función cumple la tubería `|`?
13. ¿Qué diferencia existe entre `>` y `>>`?
14. ¿Por qué se debe utilizar `sudo` con precaución?
15. ¿Qué pasos seguirías si Node Exporter no responde?
16. ¿Qué resultado esperarías de `up` cuando un target está disponible?
17. ¿Qué información debería incluir un informe de diagnóstico?
18. ¿Qué comando utilizarías para seguir los registros de un servicio en tiempo real?