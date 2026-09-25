# Problemas de instalación

Esta página describe los problemas más habituales durante la instalación de Ubuntu, Grafana, Prometheus y Node Exporter.

El objetivo no es únicamente aplicar comandos, sino aprender un procedimiento sistemático de diagnóstico:

```text
Identificar el síntoma
        |
        v
Recopilar información
        |
        v
Consultar registros
        |
        v
Comprobar configuración
        |
        v
Aplicar una corrección
        |
        v
Validar el resultado
        |
        v
Documentar la solución
```

> **Advertencia:** realiza las prácticas en el entorno de laboratorio. Antes de modificar una configuración, crea una copia de seguridad y verifica que el comando se ejecuta sobre el equipo correcto.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Identificar los síntomas habituales de un problema de instalación.
- Comprobar si un paquete está instalado correctamente.
- Diagnosticar errores de `apt`.
- Comprobar la arquitectura del sistema.
- Verificar la existencia de usuarios, grupos y directorios.
- Analizar errores de servicios gestionados por `systemd`.
- Revisar los registros de instalación y ejecución.
- Diagnosticar conflictos de puertos.
- Validar configuraciones de Grafana y Prometheus.
- Comprobar los binarios instalados.
- Resolver problemas de permisos.
- Restaurar configuraciones desde una copia de seguridad.
- Documentar una incidencia técnica de forma reproducible.

## Introducción

Una instalación puede fallar por diferentes motivos:

- El sistema no tiene acceso a Internet.
- El repositorio no está disponible.
- La arquitectura descargada es incorrecta.
- El paquete no es compatible con la versión de Ubuntu.
- Ya existe una instalación anterior.
- Un puerto está ocupado.
- El usuario del servicio no existe.
- La configuración contiene errores.
- El servicio no tiene permisos suficientes.
- Faltan dependencias.
- El sistema de archivos está lleno.
- El reloj del sistema es incorrecto.
- El firewall bloquea la comunicación.
- El fichero descargado está incompleto o corrupto.

El mensaje visible suele ser solo una parte del problema. Por ejemplo, este mensaje:

```text
Job for prometheus.service failed because the control process exited with error code.
```

no explica necesariamente la causa. Para encontrarla hay que consultar:

```bash
systemctl status prometheus
```

y:

```bash
sudo journalctl -u prometheus -n 100 --no-pager
```

## Procedimiento general de diagnóstico

### Identificar el componente afectado

Determina qué elemento presenta el problema:

```text
Ubuntu
APT
Grafana
Prometheus
Node Exporter
systemd
Red
Firewall
Permisos
Almacenamiento
```

### Registrar el síntoma

Anota exactamente:

- Qué comando se ejecutó.
- Qué resultado se obtuvo.
- Qué mensaje de error apareció.
- Cuándo comenzó el problema.
- Qué cambios se habían realizado antes.

Ejemplo:

```text
Al ejecutar sudo systemctl start prometheus aparece un error.
El servicio no llega a estar activo.
El puerto 9090 no está en escucha.
El fichero prometheus.yml se modificó antes del fallo.
```

### Recopilar información del sistema

```bash
hostnamectl
```

```bash
lsb_release -ds
```

```bash
uname -m
```

```bash
df -h
```

```bash
free -h
```

### Comprobar el servicio

```bash
systemctl status nombre-del-servicio
```

```bash
systemctl is-active nombre-del-servicio
```

### Consultar los registros

```bash
sudo journalctl -u nombre-del-servicio -n 100 --no-pager
```

### Comprobar el proceso y el puerto

```bash
ps aux | grep "[n]ombre-del-proceso"
```

```bash
sudo ss -lntp
```

### Validar la configuración

Utiliza la herramienta de validación específica cuando exista:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### Aplicar la solución

Realiza un cambio cada vez. Después de cada cambio:

1. Comprueba el estado.
2. Revisa los registros.
3. Verifica el puerto.
4. Prueba el endpoint.
5. Documenta el resultado.

## Información inicial del sistema

### Consultar la versión de Ubuntu

```bash
lsb_release -a
```

También:

```bash
cat /etc/os-release
```

### Consultar la arquitectura

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

La arquitectura debe coincidir con el paquete o binario descargado.

### Consultar el kernel

```bash
uname -r
```

### Consultar el nombre del equipo

```bash
hostnamectl
```

### Consultar la fecha y la hora

```bash
date
```

### Consultar la zona horaria

```bash
timedatectl
```

### Comprobar el espacio disponible

```bash
df -h
```

Comprobar especialmente:

```bash
df -h /
df -h /var
df -h /tmp
```

### Comprobar la memoria disponible

```bash
free -h
```

### Comprobar la conectividad

```bash
ping -c 4 8.8.8.8
```

Comprobar la resolución DNS:

```bash
resolvectl query archive.ubuntu.com
```

## Problemas con APT

APT es el sistema de gestión de paquetes utilizado en Ubuntu.

### Actualizar la información de paquetes

```bash
sudo apt update
```

### Actualizar los paquetes instalados

```bash
sudo apt upgrade
```

### Comprobar si un paquete está instalado

```bash
dpkg -l | grep nombre-del-paquete
```

También:

```bash
apt policy nombre-del-paquete
```

### Buscar un paquete

```bash
apt search nombre-del-paquete
```

### Consultar los paquetes pendientes de configuración

```bash
sudo dpkg --audit
```

### Reparar dependencias

```bash
sudo apt --fix-broken install
```

### Configurar paquetes pendientes

```bash
sudo dpkg --configure -a
```

### Limpiar la caché de paquetes

```bash
sudo apt clean
```

### Consultar los registros de APT

```bash
sudo less /var/log/apt/history.log
```

```bash
sudo less /var/log/apt/term.log
```

### Error: no se puede localizar el paquete

Mensaje habitual:

```text
E: Unable to locate package nombre-del-paquete
```

Comprobaciones:

```bash
sudo apt update
```

```bash
apt-cache policy nombre-del-paquete
```

```bash
grep -R "^deb " /etc/apt/sources.list /etc/apt/sources.list.d/ \
  2>/dev/null
```

Posibles causas:

- No se ha ejecutado `apt update`.
- El nombre del paquete es incorrecto.
- El repositorio no está configurado.
- El repositorio no corresponde a la versión de Ubuntu.
- No existe una conexión a Internet.
- La arquitectura no está disponible.

### Error de bloqueo de APT

Mensaje habitual:

```text
Could not get lock /var/lib/dpkg/lock-frontend
```

Comprueba si hay otro proceso de APT ejecutándose:

```bash
ps aux | grep -E "[a]pt|[d]pkg"
```

Comprueba quién utiliza el fichero:

```bash
sudo lsof /var/lib/dpkg/lock-frontend
```

No elimines manualmente los ficheros de bloqueo mientras exista un proceso de APT activo.

### Error de configuración incompleta

Ejecuta:

```bash
sudo dpkg --configure -a
```

Después:

```bash
sudo apt --fix-broken install
```

### Error de firma o repositorio no válido

Revisa:

```bash
sudo apt update
```

Consulta:

```bash
grep -R "deb " /etc/apt/sources.list.d/ \
  2>/dev/null
```

Comprueba:

- La URL del repositorio.
- La versión de Ubuntu.
- La clave de firma.
- La fecha y hora del sistema.
- La compatibilidad del repositorio.

No desactives la verificación de firmas como solución permanente.

## Problemas al instalar Grafana

### Comprobar si Grafana está instalado

```bash
dpkg -l | grep grafana
```

```bash
apt policy grafana
```

### Localizar el ejecutable

```bash
command -v grafana-server
```

Buscarlo en rutas habituales:

```bash
sudo find /usr /opt -type f \
  -name "grafana-server" \
  -executable 2>/dev/null
```

### Comprobar el servicio

```bash
systemctl status grafana-server
```

```bash
systemctl is-active grafana-server
```

### Comprobar la unidad

```bash
systemctl cat grafana-server
```

### Consultar la configuración

La ruta habitual es:

```bash
/etc/grafana/grafana.ini
```

Comprobar que existe:

```bash
sudo test -f /etc/grafana/grafana.ini \
  && echo "Configuración encontrada"
```

Consultar la configuración de red:

```bash
sudo grep -n -E \
  "http_addr|http_port|domain|root_url" \
  /etc/grafana/grafana.ini
```

### Comprobar el puerto de Grafana

```bash
sudo ss -lntp | grep ':3000'
```

### Comprobar la interfaz web

```bash
curl -I http://localhost:3000
```

Una respuesta `200 OK` o `302 Found` puede indicar que Grafana responde correctamente.

### Consultar los registros

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

Seguir los registros en tiempo real:

```bash
sudo journalctl -u grafana-server -f
```

### Error: el puerto 3000 está ocupado

Comprueba el proceso:

```bash
sudo ss -lntp | grep ':3000'
```

También:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

Consulta el PID:

```bash
ps -fp PID
```

Posibles causas:

- Existe otra instancia de Grafana.
- Otra aplicación utiliza el puerto.
- Grafana se ha iniciado dos veces.
- Una instalación antigua continúa activa.

### Error: Grafana no puede escribir en sus directorios

Consulta los permisos:

```bash
sudo ls -ld /var/lib/grafana
```

```bash
sudo ls -ld /var/log/grafana
```

```bash
sudo ls -l /etc/grafana/grafana.ini
```

Consulta el usuario del servicio:

```bash
systemctl show grafana-server \
  -p User \
  -p Group
```

Corrige el propietario únicamente si sabes cuál debe ser:

```bash
sudo chown -R grafana:grafana /var/lib/grafana
```

```bash
sudo chown -R grafana:grafana /var/log/grafana
```

Después:

```bash
sudo systemctl restart grafana-server
```

### Error: Grafana no inicia después de modificar `grafana.ini`

Crea una copia antes de editar:

```bash
sudo cp /etc/grafana/grafana.ini \
  /etc/grafana/grafana.ini.bak
```

Consulta los registros:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

Si la configuración anterior era válida:

```bash
sudo cp /etc/grafana/grafana.ini.bak \
  /etc/grafana/grafana.ini
```

Reinicia:

```bash
sudo systemctl restart grafana-server
```

## Problemas al instalar Prometheus

### Comprobar si Prometheus está instalado

```bash
dpkg -l | grep prometheus
```

Si se instaló manualmente:

```bash
command -v prometheus
```

```bash
sudo find /usr /opt -type f \
  -name "prometheus" \
  -executable 2>/dev/null
```

### Comprobar `promtool`

```bash
command -v promtool
```

```bash
promtool --version
```

### Comprobar el servicio

```bash
systemctl status prometheus
```

```bash
systemctl is-active prometheus
```

### Consultar la unidad

```bash
systemctl cat prometheus
```

Consultar el comando de inicio:

```bash
systemctl show prometheus \
  -p ExecStart
```

### Consultar el proceso

```bash
ps aux | grep "[p]rometheus"
```

### Consultar el fichero de configuración

La ruta habitual es:

```bash
/etc/prometheus/prometheus.yml
```

Comprobar que existe:

```bash
sudo test -f /etc/prometheus/prometheus.yml \
  && echo "Configuración encontrada"
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Si hay reglas:

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

### Error de sintaxis en `prometheus.yml`

Ejemplo de mensaje:

```text
yaml: line 15: did not find expected key
```

Consulta la línea indicada:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml \
  | sed -n '10,20p'
```

El comando:

- Muestra los números de línea.
- Permite revisar el contexto del error.
- Facilita localizar espacios o sangrías incorrectas.

### Comprobar la sangría YAML

Incorrecto:

```yaml
scrape_configs:
- job_name: node_exporter
  static_configs:
    - targets:
      - localhost:9100
```

Correcto:

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

### Error: el puerto 9090 está ocupado

```bash
sudo ss -lntp | grep ':9090'
```

```bash
sudo lsof -iTCP:9090 -sTCP:LISTEN
```

Consulta el proceso:

```bash
ps -fp PID
```

### Error: Prometheus no puede escribir los datos

Consulta:

```bash
sudo ls -ld /var/lib/prometheus
```

```bash
df -h /var/lib/prometheus
```

```bash
systemctl show prometheus \
  -p User \
  -p Group
```

Corrige el propietario si corresponde:

```bash
sudo chown -R prometheus:prometheus \
  /var/lib/prometheus
```

### Error: falta el directorio de datos

```bash
sudo mkdir -p /var/lib/prometheus
```

Después asigna el propietario adecuado:

```bash
sudo chown prometheus:prometheus \
  /var/lib/prometheus
```

### Error: Prometheus no encuentra el fichero de configuración

Consulta la unidad:

```bash
systemctl show prometheus \
  -p ExecStart
```

Busca el parámetro:

```text
--config.file=
```

Comprueba la ruta:

```bash
sudo ls -l /etc/prometheus/prometheus.yml
```

### Error: Prometheus arranca, pero no tiene targets

Consulta la configuración:

```bash
sudo grep -n -A 10 -B 2 \
  "scrape_configs" \
  /etc/prometheus/prometheus.yml
```

Comprueba la API:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

Comprueba la métrica:

```promql
up
```

## Problemas al instalar Node Exporter

### Comprobar el ejecutable

```bash
command -v node_exporter
```

Buscarlo:

```bash
sudo find /usr /opt -type f \
  -name "node_exporter" \
  -executable 2>/dev/null
```

### Comprobar la arquitectura

```bash
uname -m
```

Una arquitectura incorrecta puede producir errores como:

```text
cannot execute binary file
```

### Consultar la versión

```bash
node_exporter --version
```

### Comprobar el servicio

```bash
systemctl status node_exporter
```

```bash
systemctl is-active node_exporter
```

### Consultar la unidad

```bash
systemctl cat node_exporter
```

### Consultar los parámetros de ejecución

```bash
systemctl show node_exporter \
  -p ExecStart
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar las métricas

```bash
curl -I http://localhost:9100/metrics
```

```bash
curl -s http://localhost:9100/metrics | head
```

### Error: unidad no encontrada

Mensaje habitual:

```text
Unit node_exporter.service could not be found.
```

Comprueba:

```bash
systemctl list-unit-files | grep node
```

Busca ficheros de unidad:

```bash
sudo find /etc/systemd /lib/systemd /usr/lib/systemd \
  -name "*node*exporter*.service" \
  2>/dev/null
```

Si se ha creado una unidad nueva:

```bash
sudo systemctl daemon-reload
```

Después:

```bash
sudo systemctl enable --now node_exporter
```

### Error: el servicio se inicia y se detiene

Consulta:

```bash
sudo journalctl -u node_exporter \
  -n 100 \
  --no-pager
```

Consulta el proceso:

```bash
ps aux | grep "[n]ode_exporter"
```

Posibles causas:

- El binario no es ejecutable.
- La arquitectura es incorrecta.
- El puerto está ocupado.
- El usuario no tiene permisos.
- Existe un parámetro incorrecto.
- La unidad contiene una ruta equivocada.

### Dar permiso de ejecución

```bash
sudo chmod +x /usr/local/bin/node_exporter
```

Comprueba:

```bash
ls -l /usr/local/bin/node_exporter
```

### Problemas con el usuario del servicio

Comprueba si existe:

```bash
getent passwd node_exporter
```

Comprueba el grupo:

```bash
getent group node_exporter
```

Consulta la unidad:

```bash
systemctl cat node_exporter
```

Si la unidad utiliza un usuario inexistente, el servicio no podrá iniciarse correctamente.

## Problemas con `systemd`

### Consultar el estado

```bash
systemctl status nombre-del-servicio
```

### Consultar el código de salida

```bash
systemctl show nombre-del-servicio \
  -p Result \
  -p ExecMainStatus \
  -p ExecMainCode
```

### Consultar el motivo de un fallo

```bash
sudo journalctl -u nombre-del-servicio \
  -b \
  --no-pager
```

### Consultar solo los errores

```bash
sudo journalctl -u nombre-del-servicio \
  -p err \
  --no-pager
```

### Recargar las unidades

```bash
sudo systemctl daemon-reload
```

### Reiniciar un servicio

```bash
sudo systemctl restart nombre-del-servicio
```

### Activar un servicio al arrancar

```bash
sudo systemctl enable nombre-del-servicio
```

### Activar e iniciar

```bash
sudo systemctl enable --now nombre-del-servicio
```

### Consultar servicios fallidos

```bash
systemctl --failed
```

### Comprobar la sintaxis de una unidad

```bash
systemd-analyze verify \
  /etc/systemd/system/node_exporter.service
```

## Problemas de permisos

### Consultar permisos

```bash
ls -l fichero
```

```bash
stat fichero
```

### Consultar el propietario de una ruta

```bash
sudo stat /var/lib/prometheus
```

### Comprobar acceso como usuario del servicio

Por ejemplo:

```bash
sudo -u prometheus test -r \
  /etc/prometheus/prometheus.yml \
  && echo "Puede leer el fichero"
```

Comprobar escritura:

```bash
sudo -u prometheus test -w \
  /var/lib/prometheus \
  && echo "Puede escribir en el directorio"
```

### Consultar permisos de todos los directorios de una ruta

```bash
namei -l /etc/prometheus/prometheus.yml
```

Este comando ayuda a comprobar los permisos de cada directorio intermedio.

### Cambiar propietario

```bash
sudo chown prometheus:prometheus \
  /etc/prometheus/prometheus.yml
```

### Cambiar permisos de un fichero de configuración

```bash
sudo chmod 640 \
  /etc/prometheus/prometheus.yml
```

### Cambiar permisos de un ejecutable

```bash
sudo chmod 755 \
  /usr/local/bin/node_exporter
```

No utilices:

```bash
sudo chmod -R 777 /etc
```

Esta práctica es insegura y puede dañar el sistema.

## Problemas de red y DNS

### Consultar interfaces

```bash
ip addr
```

### Consultar rutas

```bash
ip route
```

### Probar conectividad IP

```bash
ping -c 4 8.8.8.8
```

### Probar resolución DNS

```bash
resolvectl query archive.ubuntu.com
```

### Consultar el estado de DNS

```bash
resolvectl status
```

### Probar una conexión HTTP

```bash
curl -I https://example.com
```

### Diagnosticar una descarga

```bash
curl -v -L -o /tmp/fichero.tar.gz URL
```

### Comprobar el tamaño descargado

```bash
ls -lh /tmp/fichero.tar.gz
```

### Comprobar el tipo de fichero

```bash
file /tmp/fichero.tar.gz
```

Si se esperaba un archivo comprimido y `file` muestra HTML, probablemente se descargó una página de error en lugar del archivo.

## Problemas con descargas y binarios

### Comprobar la integridad mediante SHA-256

```bash
sha256sum fichero.tar.gz
```

Compara el resultado con la suma publicada por el proyecto.

### Extraer un archivo comprimido

```bash
tar -xzf fichero.tar.gz
```

Consultar su contenido antes de extraerlo:

```bash
tar -tzf fichero.tar.gz
```

### Error de formato de archivo

Si aparece:

```text
gzip: stdin: not in gzip format
```

Comprueba:

```bash
file fichero.tar.gz
```

Posibles causas:

- La URL no apunta al archivo correcto.
- Se descargó una página HTML.
- La descarga está incompleta.
- El archivo utiliza otro formato.
- El archivo está corrupto.

### Error de arquitectura

Comprueba:

```bash
uname -m
```

Comprueba el binario:

```bash
file /usr/local/bin/node_exporter
```

La arquitectura del binario debe ser compatible con el sistema.

### Error de ejecución

Si aparece:

```text
Permission denied
```

Comprueba:

```bash
ls -l /usr/local/bin/node_exporter
```

Concede permiso solo si corresponde:

```bash
sudo chmod +x /usr/local/bin/node_exporter
```

Si aparece:

```text
Exec format error
```

comprueba la arquitectura:

```bash
file /usr/local/bin/node_exporter
uname -m
```

## Problemas de puertos

### Mostrar puertos en escucha

```bash
sudo ss -lntp
```

### Comprobar Grafana

```bash
sudo ss -lntp | grep ':3000'
```

### Comprobar Prometheus

```bash
sudo ss -lntp | grep ':9090'
```

### Comprobar Node Exporter

```bash
sudo ss -lntp | grep ':9100'
```

### Identificar un proceso

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Interpretar las direcciones de escucha

Ejemplo:

```text
127.0.0.1:3000
```

Solo acepta conexiones locales.

Ejemplo:

```text
0.0.0.0:3000
```

Acepta conexiones IPv4 desde las interfaces disponibles, sujeto al firewall.

Ejemplo:

```text
[::]:3000
```

Escucha en IPv6, según la configuración del sistema.

### Cambiar un puerto

Antes de cambiarlo:

1. Crea una copia de seguridad.
2. Consulta la documentación del servicio.
3. Comprueba que el nuevo puerto está libre.
4. Modifica la configuración correcta.
5. Reinicia el servicio.
6. Comprueba el nuevo endpoint.
7. Actualiza Prometheus, Grafana o el firewall si es necesario.

## Problemas del firewall

### Consultar UFW

```bash
sudo ufw status verbose
```

### Consultar las reglas numeradas

```bash
sudo ufw status numbered
```

### Permitir Grafana en una red de laboratorio

```bash
sudo ufw allow from 192.168.1.0/24 \
  to any port 3000 \
  proto tcp
```

### Permitir Prometheus en una red de laboratorio

```bash
sudo ufw allow from 192.168.1.0/24 \
  to any port 9090 \
  proto tcp
```

### Permitir Node Exporter desde un servidor Prometheus

```bash
sudo ufw allow from DIRECCION_IP_PROMETHEUS \
  to any port 9100 \
  proto tcp
```

### Comprobar una regla

```bash
sudo ufw status numbered
```

No abras los puertos a cualquier origen sin una justificación:

```bash
sudo ufw allow 9100/tcp
```

Esta regla puede exponer Node Exporter a más equipos de los necesarios.

## Problemas de espacio en disco

### Consultar espacio disponible

```bash
df -h
```

### Buscar directorios grandes

```bash
sudo du -h --max-depth=1 /var \
  | sort -h
```

### Consultar datos de Prometheus

```bash
sudo du -sh /var/lib/prometheus
```

### Consultar datos de Grafana

```bash
sudo du -sh /var/lib/grafana
```

### Buscar ficheros grandes

```bash
sudo find /var -type f \
  -size +500M \
  -printf "%s %p\n" \
  2>/dev/null \
  | sort -n
```

### Revisar registros

```bash
sudo journalctl --disk-usage
```

### Reducir registros antiguos del journal

Solo en el entorno de laboratorio y siguiendo la política de retención:

```bash
sudo journalctl --vacuum-time=7d
```

No elimines datos de Prometheus o Grafana sin comprender sus consecuencias.

## Problemas de fecha y certificados

Una fecha incorrecta puede provocar errores al descargar paquetes o validar certificados.

### Consultar fecha

```bash
date
```

### Consultar sincronización

```bash
timedatectl
```

### Activar sincronización NTP

```bash
sudo timedatectl set-ntp true
```

### Consultar el estado de sincronización

```bash
timedatectl show-timesync \
  --all
```

## Problemas posteriores a una reinstalación

### Detectar instalaciones duplicadas

```bash
dpkg -l | grep -E \
  "grafana|prometheus|node-exporter"
```

Buscar procesos duplicados:

```bash
ps aux | grep -E \
  "[g]rafana|[p]rometheus|[n]ode_exporter"
```

Buscar unidades duplicadas:

```bash
systemctl list-unit-files \
  | grep -E \
  "grafana|prometheus|node_exporter"
```

### Detectar configuraciones antiguas

```bash
sudo find /etc /opt /usr/local \
  -iname "*grafana*" \
  -o -iname "*prometheus*" \
  -o -iname "*node_exporter*" \
  2>/dev/null
```

### Revisar puertos duplicados

```bash
sudo ss -lntp \
  | grep -E ':(3000|9090|9100)\b'
```

### No borrar inmediatamente

Antes de eliminar una instalación anterior:

1. Identifica el servicio activo.
2. Comprueba la configuración utilizada.
3. Haz una copia de seguridad.
4. Documenta la instalación antigua.
5. Comprueba qué procesos dependen de ella.
6. Detén el servicio de forma controlada.
7. Elimina únicamente los ficheros necesarios.

## Sesión práctica 1: diagnóstico inicial

### Objetivo

Recopilar información antes de modificar el sistema.

### Preparación

```bash
mkdir -p ~/laboratorio/problemas-instalacion
cd ~/laboratorio/problemas-instalacion
```

### Generar un informe inicial

```bash
{
  echo "===== INFORME INICIAL ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== SISTEMA ====="
  hostnamectl
  echo
  lsb_release -ds
  uname -m
  uname -r
  echo

  echo "===== ESPACIO ====="
  df -h
  echo

  echo "===== MEMORIA ====="
  free -h
  echo

  echo "===== RED ====="
  ip addr
  ip route
  echo

  echo "===== SERVICIOS ====="
  for service in grafana-server prometheus node_exporter; do
    echo "--- $service ---"
    systemctl is-active "$service" 2>/dev/null || true
    systemctl is-enabled "$service" 2>/dev/null || true
  done

  echo
  echo "===== PUERTOS ====="
  sudo ss -lntp
} | tee informe-inicial.txt
```

### Preguntas de análisis

- ¿Qué versión de Ubuntu está instalada?
- ¿Qué arquitectura utiliza el equipo?
- ¿Hay espacio suficiente?
- ¿Qué servicios están instalados?
- ¿Qué servicios están activos?
- ¿Qué puertos están en escucha?
- ¿Existe algún conflicto evidente?

## Sesión práctica 2: diagnosticar una instalación de Prometheus

### Objetivo

Determinar por qué Prometheus no inicia.

### Comprobar el estado

```bash
systemctl status prometheus
```

### Consultar el registro

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

### Consultar la unidad

```bash
systemctl cat prometheus
```

### Comprobar la configuración

```bash
sudo ls -l /etc/prometheus/prometheus.yml
```

### Validar el fichero

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Comprobar los permisos

```bash
sudo stat /etc/prometheus/prometheus.yml
```

```bash
sudo stat /var/lib/prometheus
```

### Comprobar el espacio

```bash
df -h /var/lib/prometheus
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Procedimiento de recuperación

Si el problema está en la configuración:

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

Restaura una copia válida:

```bash
sudo cp /etc/prometheus/prometheus.yml.bak \
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

Comprueba:

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

## Sesión práctica 3: diagnosticar un conflicto de puertos

### Objetivo

Identificar qué proceso utiliza un puerto necesario.

### Comprobar el puerto de Grafana

```bash
sudo ss -lntp | grep ':3000'
```

### Identificar el proceso

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Consultar el PID

```bash
ps -fp PID
```

Sustituye `PID` por el valor real.

### Consultar el servicio

```bash
systemctl status grafana-server
```

### Consultar los procesos relacionados

```bash
ps aux | grep "[g]rafana"
```

### Preguntas de análisis

- ¿Qué proceso ocupa el puerto?
- ¿A qué usuario pertenece?
- ¿Lo gestiona `systemd`?
- ¿Existe más de una instalación?
- ¿Qué solución sería más segura?
- ¿Es preferible cambiar el puerto o detener el proceso duplicado?

## Sesión práctica 4: simular un problema de permisos

### Objetivo

Observar cómo un permiso incorrecto impide iniciar un servicio.

> Realiza esta actividad únicamente en una máquina virtual o entorno de laboratorio.

### Crear una copia de la configuración

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.practica
```

### Consultar los permisos iniciales

```bash
sudo stat /etc/prometheus/prometheus.yml
```

### Aplicar una modificación controlada

```bash
sudo chmod 600 /etc/prometheus/prometheus.yml
```

Comprueba si el usuario del servicio puede leerlo:

```bash
sudo -u prometheus test -r \
  /etc/prometheus/prometheus.yml \
  && echo "Puede leerlo" \
  || echo "No puede leerlo"
```

### Consultar el servicio

```bash
sudo systemctl restart prometheus
```

```bash
systemctl status prometheus
```

### Restaurar permisos adecuados

```bash
sudo chmod 640 /etc/prometheus/prometheus.yml
```

Si es necesario:

```bash
sudo chown prometheus:prometheus \
  /etc/prometheus/prometheus.yml
```

### Validar y reiniciar

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Preguntas de análisis

- ¿Qué permisos tenía inicialmente el fichero?
- ¿Qué usuario ejecuta Prometheus?
- ¿Podía leer el fichero después del cambio?
- ¿Qué mensaje apareció en los registros?
- ¿Qué permisos permiten el funcionamiento correcto?

## Sesión práctica 5: diagnosticar una descarga incorrecta

### Objetivo

Comprobar si un archivo descargado corresponde realmente al formato esperado.

### Crear un fichero de prueba

```bash
cd ~/laboratorio/problemas-instalacion
```

### Consultar el tipo de archivo

```bash
file fichero-descargado.tar.gz
```

### Consultar el tamaño

```bash
ls -lh fichero-descargado.tar.gz
```

### Consultar el contenido

```bash
tar -tzf fichero-descargado.tar.gz
```

### Comprobar la suma

```bash
sha256sum fichero-descargado.tar.gz
```

### Interpretar los resultados

Si `file` muestra:

```text
HTML document
```

en lugar de:

```text
gzip compressed data
```

la descarga probablemente no corresponde al archivo esperado.

### Repetir una descarga de forma controlada

```bash
curl -fL \
  -o fichero.tar.gz \
  URL_DEL_ARCHIVO
```

La opción `-f` hace que `curl` falle ante errores HTTP.

Después:

```bash
file fichero.tar.gz
```

```bash
tar -tzf fichero.tar.gz
```

## Sesión práctica 6: diagnosticar Node Exporter

### Objetivo

Comprobar el flujo completo entre Node Exporter y Prometheus.

### Comprobar el servicio

```bash
systemctl is-active node_exporter
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar el endpoint

```bash
curl -I http://localhost:9100/metrics
```

### Comprobar las métricas

```bash
curl -s http://localhost:9100/metrics | head -20
```

### Consultar Prometheus

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Ejecutar PromQL

```promql
up{job="node_exporter"}
```

### Interpretar el resultado

| Comprobación | Resultado esperado |
|---|---|
| Servicio | `active` |
| Puerto `9100` | En escucha |
| Endpoint `/metrics` | Responde |
| Target de Prometheus | `UP` |
| Consulta `up` | Valor `1` |

## Sesión práctica 7: elaborar un informe de incidencia

### Objetivo

Documentar un problema de instalación de principio a fin.

### Situación

Prometheus no inicia después de modificar su configuración.

### Recopilar información

```bash
systemctl status prometheus
```

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Crear una copia del estado actual

```bash
sudo cp /etc/prometheus/prometheus.yml \
  "/var/backups/prometheus.yml.$(date +%F-%H%M%S)"
```

### Resolver el problema

Aplica la corrección necesaria y valida de nuevo:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar el servicio

```bash
sudo systemctl restart prometheus
```

### Validar el resultado

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Completar el informe

```text
Título:

Fecha:

Alumno:

Equipo:

Componente afectado:

Síntoma:

Cambio realizado antes del fallo:

Estado inicial:

Mensaje de error:

Comando de validación:

Causa identificada:

Copia de seguridad:

Corrección aplicada:

Resultado posterior:

Evidencias:
```

## Método de recuperación recomendado

### Detener los cambios

No realices varios cambios simultáneos. Si modificas cinco elementos a la vez, será más difícil identificar cuál solucionó o causó el problema.

### Recuperar la última configuración válida

```bash
sudo cp fichero.bak fichero
```

### Validar

```bash
promtool check config fichero
```

### Recargar o reiniciar

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl restart nombre-del-servicio
```

### Comprobar el estado

```bash
systemctl is-active nombre-del-servicio
```

### Comprobar el endpoint

```bash
curl -I URL
```

### Revisar los registros posteriores

```bash
sudo journalctl -u nombre-del-servicio \
  --since "5 minutes ago" \
  --no-pager
```

## Lista de comprobación de Grafana

```text
[ ] El paquete está instalado.
[ ] El ejecutable existe.
[ ] El usuario grafana existe.
[ ] La unidad grafana-server existe.
[ ] El fichero grafana.ini existe.
[ ] Los directorios de datos existen.
[ ] Los permisos son correctos.
[ ] El servicio está activo.
[ ] El puerto 3000 está en escucha.
[ ] Grafana responde por HTTP.
[ ] Los registros no muestran errores críticos.
[ ] La fuente de datos de Prometheus funciona.
```

## Lista de comprobación de Prometheus

```text
[ ] El paquete o binario está instalado.
[ ] promtool está disponible.
[ ] El usuario prometheus existe.
[ ] El fichero prometheus.yml existe.
[ ] El directorio de datos existe.
[ ] Los permisos son correctos.
[ ] La configuración es válida.
[ ] La unidad systemd existe.
[ ] El servicio está activo.
[ ] El puerto 9090 está en escucha.
[ ] El endpoint de salud responde.
[ ] Los targets aparecen en la interfaz.
[ ] La consulta up devuelve resultados.
```

## Lista de comprobación de Node Exporter

```text
[ ] El binario existe.
[ ] El binario es ejecutable.
[ ] La arquitectura es compatible.
[ ] El usuario del servicio existe.
[ ] La unidad systemd existe.
[ ] El servicio está activo.
[ ] El puerto 9100 está en escucha.
[ ] El endpoint /metrics responde.
[ ] Se exponen métricas node_*.
[ ] Prometheus puede acceder al endpoint.
[ ] El target aparece como UP.
```

## Comandos de diagnóstico rápido

### Estado general

```bash
hostnamectl
lsb_release -ds
uname -m
df -h
free -h
```

### Servicios

```bash
systemctl --failed
systemctl is-active grafana-server
systemctl is-active prometheus
systemctl is-active node_exporter
```

### Puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

### Procesos

```bash
ps aux | grep -E \
  "[g]rafana|[p]rometheus|[n]ode_exporter"
```

### Registros

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
sudo journalctl -u prometheus -n 50 --no-pager
sudo journalctl -u node_exporter -n 50 --no-pager
```

### Endpoints

```bash
curl -I http://localhost:3000
curl http://localhost:9090/-/healthy
curl -I http://localhost:9100/metrics
```

### Configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

## Buenas prácticas

- Crea una copia de seguridad antes de modificar una configuración.
- Valida los ficheros antes de reiniciar los servicios.
- Comprueba siempre la versión y la arquitectura.
- Lee los registros antes de buscar una solución.
- Cambia un único elemento cada vez.
- No elimines ficheros de bloqueo de APT mientras haya procesos activos.
- No utilices permisos `777` como solución general.
- No descargues binarios de fuentes desconocidas.
- Comprueba la suma de verificación de los archivos.
- Limita los puertos mediante el firewall.
- No expongas Node Exporter públicamente sin necesidad.
- Comprueba el espacio disponible antes de instalar.
- Documenta las rutas reales si difieren de las habituales.
- Conserva una copia de las configuraciones válidas.
- No borres los datos de Prometheus o Grafana sin autorización.
- Utiliza `systemctl cat` para entender cómo se inicia un servicio.
- Utiliza `promtool` antes de reiniciar Prometheus.
- Verifica la solución desde el punto de vista del cliente.
- Conserva evidencias de las comprobaciones.

## Tabla de síntomas y comprobaciones

| Síntoma | Primera comprobación | Comprobación adicional |
|---|---|---|
| El paquete no se encuentra | `sudo apt update` | Revisar repositorios |
| APT está bloqueado | `ps aux \| grep apt` | `lsof` sobre el lock |
| Grafana no inicia | `systemctl status grafana-server` | `journalctl` |
| Prometheus no inicia | `promtool check config` | `journalctl` |
| Node Exporter no inicia | `systemctl status node_exporter` | Arquitectura y permisos |
| Puerto ocupado | `sudo ss -lntp` | `lsof` |
| Endpoint no responde | `curl -v URL` | Servicio y firewall |
| Target `DOWN` | `up` y API de targets | Endpoint del exporter |
| Disco lleno | `df -h` | `du` |
| Permiso denegado | `stat` y `namei` | Usuario del servicio |
| Binario no ejecutable | `file` y `ls -l` | Arquitectura y permisos |
| Configuración inválida | Herramienta de validación | Copia de seguridad |

## Puntos clave

- Un error de instalación debe investigarse de forma sistemática.
- El mensaje visible no siempre contiene la causa real.
- `systemctl status` muestra el estado general de un servicio.
- `journalctl` muestra los registros de `systemd`.
- `ss` permite comprobar puertos en escucha.
- `curl` permite verificar endpoints HTTP.
- `promtool check config` valida la configuración de Prometheus.
- La arquitectura del binario debe coincidir con la arquitectura del sistema.
- Los permisos deben permitir al usuario del servicio leer o escribir lo necesario.
- Un puerto ocupado puede impedir que un servicio se inicie.
- Un servicio activo no garantiza que su endpoint funcione correctamente.
- La conectividad debe comprobarse desde el equipo que realiza la conexión.
- Las copias de seguridad permiten recuperar una configuración válida.
- APT no debe manipularse mientras otro proceso de paquetes está activo.
- No se deben utilizar permisos excesivamente amplios como solución rápida.
- Los cambios deben aplicarse uno a uno.
- Toda incidencia debe documentar el síntoma, la causa, la solución y la validación.
- El objetivo del diagnóstico es obtener una solución reproducible.

## Preguntas de comprobación

1. ¿Qué pasos seguirías ante un servicio que no inicia?
2. ¿Qué comando permite consultar los registros de un servicio?
3. ¿Qué comando permite comprobar si el puerto `9090` está ocupado?
4. ¿Qué herramienta permite validar `prometheus.yml`?
5. ¿Qué diferencia existe entre `systemctl status` y `journalctl`?
6. ¿Qué puede provocar el error `Unable to locate package`?
7. ¿Qué debes comprobar si aparece `Exec format error`?
8. ¿Qué información proporciona `uname -m`?
9. ¿Cómo comprobarías que el usuario `prometheus` puede leer su configuración?
10. ¿Qué comando permite verificar el endpoint de Node Exporter?
11. ¿Qué puede significar que un servicio esté activo pero no tenga ningún puerto en escucha?
12. ¿Qué causas pueden producir un `Connection refused`?
13. ¿Por qué no se debe eliminar manualmente un fichero de bloqueo de APT?
14. ¿Qué pasos realizarías antes de modificar `grafana.ini`?
15. ¿Cómo comprobarías si una descarga es realmente un archivo comprimido?
16. ¿Qué diferencia existe entre `127.0.0.1:3000` y `0.0.0.0:3000`?
17. ¿Qué comprobarías si Prometheus muestra un target como `DOWN`?
18. ¿Qué riesgos tiene utilizar `chmod -R 777`?
19. ¿Qué información debe incluir un informe de incidencia?
20. ¿Por qué es importante cambiar una sola cosa cada vez durante el diagnóstico?