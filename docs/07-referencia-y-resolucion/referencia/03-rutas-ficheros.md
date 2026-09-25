# Rutas y ficheros

Esta página reúne las rutas y los ficheros más importantes del entorno de laboratorio basado en Ubuntu, Grafana, Prometheus y Node Exporter.

Conocer la ubicación de los ficheros permite:

- Localizar configuraciones.
- Consultar datos y registros.
- Validar permisos.
- Diagnosticar errores.
- Realizar copias de seguridad.
- Comprobar qué unidad de `systemd` utiliza cada servicio.
- Relacionar una aplicación con sus ficheros de configuración y datos.

Las rutas pueden variar según el método de instalación, la versión del software y la distribución utilizada. Antes de modificar un fichero, comprueba siempre que la ruta corresponde al entorno de laboratorio.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Diferenciar rutas de configuración, datos, registros y ejecutables.
- Localizar los ficheros principales de Grafana.
- Localizar los ficheros principales de Prometheus.
- Localizar los ficheros principales de Node Exporter.
- Consultar las unidades de `systemd`.
- Identificar las rutas utilizadas por un servicio.
- Comprobar permisos y propietarios.
- Buscar ficheros mediante `find`.
- Buscar texto dentro de ficheros mediante `grep`.
- Crear copias de seguridad antes de modificar configuraciones.
- Documentar las rutas utilizadas durante una incidencia.

## Introducción

En Linux, cada componente suele tener varias ubicaciones diferenciadas:

```text
Configuración
    Define cómo funciona el servicio.

Datos
    Contiene la información generada o almacenada.

Registros
    Permite analizar la actividad y los errores.

Ejecutables
    Contiene los programas que se ejecutan.

Unidades systemd
    Define cómo se inicia y gestiona el servicio.
```

Por ejemplo, Prometheus puede utilizar:

```text
/etc/prometheus/
    Ficheros de configuración.

/var/lib/prometheus/
    Datos almacenados.

/var/log/
    Registros, si están configurados en ficheros.

/lib/systemd/system/
    Unidad del servicio.
```

No todos los servicios utilizan exactamente las mismas rutas. Por ese motivo, cuando exista una duda, conviene consultar la unidad de `systemd` y el proceso en ejecución.

## Tipos de rutas

### Rutas de configuración

Contienen los parámetros que definen el comportamiento de un servicio.

Ejemplos:

```text
/etc/grafana/
/etc/prometheus/
/etc/systemd/system/
```

### Rutas de datos

Contienen datos generados por la aplicación.

Ejemplos:

```text
/var/lib/grafana/
/var/lib/prometheus/
```

### Rutas de registros

Contienen información sobre la actividad y los errores.

Ejemplos:

```text
/var/log/grafana/
/var/log/
/var/log/syslog
```

Algunos servicios envían sus registros directamente al journal de `systemd` en lugar de utilizar un fichero específico.

### Rutas de ejecutables

Contienen los programas que se ejecutan.

Ejemplos:

```text
/usr/sbin/
/usr/bin/
/usr/local/bin/
/opt/
```

### Rutas de unidades systemd

Las unidades pueden encontrarse en varias ubicaciones:

```text
/lib/systemd/system/
/usr/lib/systemd/system/
/etc/systemd/system/
```

Las unidades creadas o modificadas por el administrador suelen ubicarse en:

```text
/etc/systemd/system/
```

## Estructura básica del sistema de ficheros

### Directorio raíz

La raíz del sistema se representa mediante:

```text
/
```

Desde ella cuelgan los directorios principales:

```text
/
├── etc
├── home
├── opt
├── tmp
├── usr
├── var
└── root
```

### Directorio `/etc`

Contiene la configuración del sistema y de muchas aplicaciones.

Ejemplos:

```text
/etc/hosts
/etc/fstab
/etc/systemd/
/etc/grafana/
/etc/prometheus/
```

### Directorio `/var`

Contiene datos variables, como registros, cachés y datos de aplicaciones.

Ejemplos:

```text
/var/log/
/var/lib/
/var/cache/
/var/lib/grafana/
/var/lib/prometheus/
```

### Directorio `/usr`

Contiene programas, bibliotecas y recursos instalados por el sistema.

Ejemplos:

```text
/usr/bin/
/usr/sbin/
/usr/share/
/usr/lib/
```

### Directorio `/opt`

Se utiliza habitualmente para aplicaciones instaladas fuera de la estructura estándar del sistema.

Ejemplo:

```text
/opt/prometheus/
```

Esta ruta puede utilizarse cuando Prometheus se instala manualmente mediante un archivo comprimido.

### Directorio `/home`

Contiene los directorios personales de los usuarios.

Ejemplo:

```text
/home/alumno/
```

### Directorio `/root`

Es el directorio personal del usuario administrador:

```text
/root/
```

### Directorio `/tmp`

Contiene ficheros temporales:

```text
/tmp/
```

No debe utilizarse para almacenar configuraciones permanentes o datos importantes.

## Comandos para consultar rutas

### Mostrar el directorio actual

```bash
pwd
```

### Listar un directorio

```bash
ls
```

Mostrar información detallada:

```bash
ls -l
```

Mostrar ficheros ocultos:

```bash
ls -la
```

Mostrar tamaños legibles:

```bash
ls -lah
```

### Consultar una ruta concreta

```bash
ls -lah /etc
```

```bash
ls -lah /var/lib
```

Si la ruta requiere permisos:

```bash
sudo ls -lah /etc/prometheus
```

### Comprobar si existe un fichero

```bash
test -f /etc/prometheus/prometheus.yml \
  && echo "El fichero existe" \
  || echo "El fichero no existe"
```

### Comprobar si existe un directorio

```bash
test -d /var/lib/prometheus \
  && echo "El directorio existe" \
  || echo "El directorio no existe"
```

### Consultar información de un fichero

```bash
file /etc/prometheus/prometheus.yml
```

### Consultar el tamaño de un fichero

```bash
du -h /etc/prometheus/prometheus.yml
```

### Consultar el tamaño de un directorio

```bash
sudo du -sh /var/lib/prometheus
```

Consultar el tamaño de sus subdirectorios:

```bash
sudo du -h --max-depth=1 /var/lib/prometheus
```

## Rutas de Grafana

Las rutas de Grafana dependen de la instalación y de la distribución. En una instalación habitual mediante paquete `.deb`, las rutas principales suelen ser las siguientes.

### Tabla de rutas de Grafana

| Elemento | Ruta habitual |
|---|---|
| Configuración principal | `/etc/grafana/grafana.ini` |
| Configuración de provisioning | `/etc/grafana/provisioning/` |
| Datos de Grafana | `/var/lib/grafana/` |
| Plugins | `/var/lib/grafana/plugins/` |
| Registros | `/var/log/grafana/` |
| Ejecutable o servidor | `/usr/sbin/grafana-server` |
| Unidad del servicio | `/lib/systemd/system/grafana-server.service` |
| Variables de entorno | `/etc/default/grafana-server` |

### Configuración principal

La configuración principal suele encontrarse en:

```text
/etc/grafana/grafana.ini
```

Consultar el fichero:

```bash
sudo less /etc/grafana/grafana.ini
```

Buscar la configuración de red:

```bash
sudo grep -n -E 'http_addr|http_port|domain|root_url' \
  /etc/grafana/grafana.ini
```

Buscar la configuración de la base de datos:

```bash
sudo grep -n -E '^\[database\]|type|path|host|name' \
  /etc/grafana/grafana.ini
```

> Algunas líneas pueden estar comentadas. Una línea comentada normalmente comienza con `;` o `#`.

### Directorio de provisioning

El directorio de provisioning suele ser:

```text
/etc/grafana/provisioning/
```

Consultar su contenido:

```bash
sudo find /etc/grafana/provisioning -maxdepth 2 -type f -print
```

Las subcarpetas habituales pueden incluir:

```text
/etc/grafana/provisioning/dashboards/
/etc/grafana/provisioning/datasources/
/etc/grafana/provisioning/alerting/
/etc/grafana/provisioning/notifiers/
```

### Datos de Grafana

La ruta habitual de datos es:

```text
/var/lib/grafana/
```

Consultar el contenido:

```bash
sudo ls -lah /var/lib/grafana
```

Consultar el tamaño:

```bash
sudo du -sh /var/lib/grafana
```

### Base de datos de Grafana

En instalaciones básicas, Grafana puede utilizar SQLite. El fichero suele encontrarse en:

```text
/var/lib/grafana/grafana.db
```

Comprobar si existe:

```bash
sudo test -f /var/lib/grafana/grafana.db \
  && echo "Base de datos encontrada"
```

Consultar sus permisos:

```bash
sudo ls -l /var/lib/grafana/grafana.db
```

> No modifiques directamente la base de datos de Grafana. Utiliza la interfaz web o los mecanismos oficiales de exportación y administración.

### Plugins de Grafana

Los plugins instalados suelen encontrarse en:

```text
/var/lib/grafana/plugins/
```

Consultar los plugins:

```bash
sudo find /var/lib/grafana/plugins -maxdepth 2 -type d
```

### Registros de Grafana

Los registros pueden encontrarse en:

```text
/var/log/grafana/
```

Consultar los ficheros:

```bash
sudo find /var/log/grafana -type f -maxdepth 2 -print
```

Consultar las últimas líneas:

```bash
sudo tail -n 50 /var/log/grafana/grafana.log
```

En algunos entornos, los registros pueden estar únicamente en `journald`:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

## Rutas de Prometheus

Prometheus también puede instalarse mediante paquete o manualmente. Las rutas dependen del método utilizado.

### Tabla de rutas de Prometheus

| Elemento | Instalación mediante paquete | Instalación manual habitual |
|---|---|---|
| Configuración | `/etc/prometheus/` | `/etc/prometheus/` o `/opt/prometheus/` |
| Configuración principal | `/etc/prometheus/prometheus.yml` | `/opt/prometheus/prometheus.yml` |
| Datos | `/var/lib/prometheus/` | Ruta definida con `--storage.tsdb.path` |
| Ejecutable | `/usr/bin/prometheus` o `/usr/sbin/prometheus` | `/opt/prometheus/prometheus` |
| Herramienta `promtool` | `/usr/bin/promtool` | `/opt/prometheus/promtool` |
| Unidad systemd | `/lib/systemd/system/prometheus.service` | `/etc/systemd/system/prometheus.service` |

### Configuración principal

La configuración principal suele ser:

```text
/etc/prometheus/prometheus.yml
```

Consultar el fichero:

```bash
sudo less /etc/prometheus/prometheus.yml
```

Mostrar las primeras líneas:

```bash
sudo head -n 40 /etc/prometheus/prometheus.yml
```

Buscar los trabajos configurados:

```bash
sudo grep -n "job_name" /etc/prometheus/prometheus.yml
```

Buscar los targets:

```bash
sudo grep -n -A 5 -B 2 "static_configs" \
  /etc/prometheus/prometheus.yml
```

Buscar referencias a Node Exporter:

```bash
sudo grep -n -i "node_exporter" \
  /etc/prometheus/prometheus.yml
```

### Directorio de reglas

Si se han configurado reglas de grabación o alertas:

```text
/etc/prometheus/rules/
```

o:

```text
/etc/prometheus/rules.d/
```

Localizar ficheros de reglas:

```bash
sudo find /etc/prometheus -type f \
  \( -name "*.yml" -o -name "*.yaml" \) -print
```

Buscar reglas de alerta:

```bash
sudo grep -R -n "alert:" /etc/prometheus
```

### Datos de Prometheus

La ruta habitual de almacenamiento es:

```text
/var/lib/prometheus/
```

Consultar el tamaño:

```bash
sudo du -sh /var/lib/prometheus
```

Consultar los elementos principales:

```bash
sudo find /var/lib/prometheus -maxdepth 2 -type d -print
```

La base de datos de series temporales no debe modificarse manualmente.

### Ejecutables de Prometheus

Localizar el ejecutable:

```bash
command -v prometheus
```

```bash
command -v promtool
```

Si no se encuentra mediante `command -v`, busca en las rutas habituales:

```bash
sudo find /usr /opt -type f \
  \( -name "prometheus" -o -name "promtool" \) \
  -executable 2>/dev/null
```

### Registros de Prometheus

Consultar los registros mediante `systemd`:

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

Seguirlos en tiempo real:

```bash
sudo journalctl -u prometheus -f
```

Buscar errores:

```bash
sudo journalctl -u prometheus --no-pager \
  | grep -i -E "error|failed|invalid|panic"
```

## Rutas de Node Exporter

Node Exporter es un ejecutable que expone métricas del sistema. Normalmente no necesita una gran estructura de configuración.

### Tabla de rutas de Node Exporter

| Elemento | Ruta habitual |
|---|---|
| Ejecutable | `/usr/local/bin/node_exporter` |
| Ejecutable alternativo | `/usr/bin/node_exporter` |
| Unidad systemd | `/etc/systemd/system/node_exporter.service` |
| Usuario de servicio | Definido en la unidad systemd |
| Puerto habitual | `9100` |
| Endpoint de métricas | `/metrics` |

### Localizar el ejecutable

```bash
command -v node_exporter
```

Buscarlo en el sistema:

```bash
sudo find /usr /opt -type f \
  -name "node_exporter" -executable 2>/dev/null
```

### Consultar la unidad del servicio

```bash
systemctl cat node_exporter
```

Si la unidad está en una ruta específica:

```bash
sudo cat /etc/systemd/system/node_exporter.service
```

### Consultar los parámetros de ejecución

```bash
systemctl show node_exporter -p ExecStart
```

También puedes consultar el proceso:

```bash
ps aux | grep "[n]ode_exporter"
```

### Consultar el endpoint

```bash
curl -s http://localhost:9100/metrics | head
```

Buscar la versión:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_exporter_build_info"
```

### Registros de Node Exporter

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

Seguir los registros:

```bash
sudo journalctl -u node_exporter -f
```

## Unidades systemd

### Consultar la unidad de un servicio

```bash
systemctl cat grafana-server
```

```bash
systemctl cat prometheus
```

```bash
systemctl cat node_exporter
```

Este comando muestra:

- La unidad principal.
- Las directivas de servicio.
- El usuario de ejecución.
- El comando de inicio.
- Las dependencias.
- Las opciones de reinicio.

### Mostrar la ruta de la unidad

```bash
systemctl show -p FragmentPath grafana-server
```

```bash
systemctl show -p FragmentPath prometheus
```

```bash
systemctl show -p FragmentPath node_exporter
```

### Mostrar todas las propiedades

```bash
systemctl show prometheus
```

Consultar propiedades concretas:

```bash
systemctl show prometheus \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath \
  -p WorkingDirectory
```

### Consultar las dependencias

```bash
systemctl list-dependencies prometheus
```

### Buscar unidades relacionadas

```bash
systemctl list-unit-files | grep -E \
  "grafana|prometheus|node_exporter"
```

### Recargar las unidades

Después de modificar o crear una unidad:

```bash
sudo systemctl daemon-reload
```

Después, reinicia el servicio si es necesario:

```bash
sudo systemctl restart node_exporter
```

## Permisos y propietarios

### Consultar permisos

```bash
sudo ls -l /etc/prometheus/prometheus.yml
```

Ejemplo:

```text
-rw-r----- 1 prometheus prometheus 1542 Sep 25 11:00 prometheus.yml
```

La salida contiene:

```text
permisos propietario grupo tamaño fecha nombre
```

### Consultar permisos con formato detallado

```bash
stat /etc/prometheus/prometheus.yml
```

### Consultar el propietario de un directorio

```bash
sudo stat /var/lib/prometheus
```

### Consultar todos los elementos de una ruta

```bash
sudo ls -la /etc/prometheus
```

### Cambiar el propietario

```bash
sudo chown prometheus:prometheus \
  /etc/prometheus/prometheus.yml
```

### Cambiar los permisos

```bash
sudo chmod 640 /etc/prometheus/prometheus.yml
```

### Consultar permisos recursivamente

```bash
sudo find /etc/prometheus -maxdepth 2 \
  -printf "%M %u:%g %p\n"
```

### Interpretar permisos habituales

```text
-rw-r----- 
```

Significa:

```text
Propietario: lectura y escritura
Grupo:       lectura
Otros:       ningún permiso
```

Para un fichero de configuración que contiene información sensible, no conviene conceder permisos de escritura a todos los usuarios.

## Buscar rutas y ficheros

### Utilizar `find`

Buscar la configuración de Prometheus:

```bash
sudo find /etc -type f \
  -name "prometheus.yml"
```

Buscar configuraciones de Grafana:

```bash
sudo find /etc/grafana -type f -print
```

Buscar unidades de servicios:

```bash
sudo find /etc/systemd /lib/systemd /usr/lib/systemd \
  -type f \
  \( -name "grafana*.service" \
  -o -name "prometheus*.service" \
  -o -name "node_exporter*.service" \) \
  -print 2>/dev/null
```

Buscar ficheros modificados recientemente:

```bash
sudo find /etc/prometheus -type f \
  -mtime -7 -print
```

Buscar ficheros grandes:

```bash
sudo find /var/lib/prometheus -type f \
  -size +100M -print
```

### Utilizar `locate`

Si está instalado:

```bash
locate prometheus.yml
```

Actualizar la base de datos de `locate`:

```bash
sudo updatedb
```

> `locate` puede no mostrar ficheros creados recientemente hasta que se actualice su base de datos.

### Utilizar `whereis`

```bash
whereis prometheus
```

```bash
whereis grafana-server
```

```bash
whereis node_exporter
```

### Utilizar `command -v`

```bash
command -v prometheus
```

```bash
command -v grafana-server
```

```bash
command -v node_exporter
```

## Buscar texto dentro de ficheros

### Buscar una palabra

```bash
sudo grep -n "job_name" \
  /etc/prometheus/prometheus.yml
```

### Buscar sin distinguir mayúsculas

```bash
sudo grep -ni "error" /etc/grafana/grafana.ini
```

### Buscar recursivamente

```bash
sudo grep -Rni "node_exporter" /etc/prometheus
```

### Mostrar líneas próximas

```bash
sudo grep -n -A 5 -B 5 "node_exporter" \
  /etc/prometheus/prometheus.yml
```

Las opciones significan:

| Opción | Función |
|---|---|
| `-n` | Mostrar números de línea |
| `-i` | Ignorar mayúsculas y minúsculas |
| `-R` | Buscar recursivamente |
| `-A 5` | Mostrar cinco líneas posteriores |
| `-B 5` | Mostrar cinco líneas anteriores |

### Buscar varias palabras

```bash
sudo grep -n -E \
  "error|warning|failed|invalid" \
  /var/log/syslog
```

## Editar ficheros de configuración

### Utilizar `nano`

Abrir la configuración de Prometheus:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Atajos básicos de `nano`:

| Atajo | Función |
|---|---|
| `Ctrl + O` | Guardar |
| `Enter` | Confirmar nombre |
| `Ctrl + X` | Salir |
| `Ctrl + W` | Buscar |
| `Ctrl + K` | Cortar una línea |
| `Ctrl + U` | Pegar una línea |

### Crear una copia antes de editar

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

### Comparar una copia con la configuración actual

```bash
sudo diff -u \
  /etc/prometheus/prometheus.yml.bak \
  /etc/prometheus/prometheus.yml
```

### Restaurar una copia

```bash
sudo cp /etc/prometheus/prometheus.yml.bak \
  /etc/prometheus/prometheus.yml
```

Después de restaurar:

```bash
sudo systemctl restart prometheus
```

### Validar antes de reiniciar

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

No reinicies Prometheus si la validación devuelve errores. Corrige primero el fichero y vuelve a validarlo.

## Copias de seguridad

### Copiar un fichero con fecha

```bash
sudo cp /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%F-%H%M%S).bak"
```

### Crear un directorio de copias

```bash
sudo mkdir -p /var/backups/observabilidad
```

### Copiar varias configuraciones

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /var/backups/observabilidad/

sudo cp /etc/grafana/grafana.ini \
  /var/backups/observabilidad/
```

### Crear un archivo comprimido

```bash
sudo tar -czf \
  /var/backups/observabilidad/configuracion-$(date +%F).tar.gz \
  /etc/prometheus \
  /etc/grafana
```

### Consultar el contenido de una copia

```bash
sudo tar -tzf \
  /var/backups/observabilidad/configuracion-2026-09-25.tar.gz
```

### Extraer una copia

```bash
sudo tar -xzf \
  /var/backups/observabilidad/configuracion-2026-09-25.tar.gz \
  -C /
```

## Sesión práctica 1: inventario de rutas

En esta sesión se elaborará un inventario de las rutas principales del laboratorio.

### Objetivo

Localizar:

- Configuración de Grafana.
- Configuración de Prometheus.
- Unidad de Node Exporter.
- Directorios de datos.
- Ejecutables.
- Registros.

### Preparación

Crear el directorio de trabajo:

```bash
mkdir -p ~/laboratorio/rutas-ficheros
cd ~/laboratorio/rutas-ficheros
```

### Buscar las configuraciones principales

```bash
{
  echo "===== CONFIGURACIÓN DE GRAFANA ====="
  sudo find /etc/grafana -maxdepth 2 -type f -print \
    2>/dev/null || true
  echo

  echo "===== CONFIGURACIÓN DE PROMETHEUS ====="
  sudo find /etc/prometheus -maxdepth 2 -type f -print \
    2>/dev/null || true
  echo

  echo "===== UNIDAD DE NODE EXPORTER ====="
  sudo find /etc/systemd /lib/systemd /usr/lib/systemd \
    -type f -name "node_exporter*.service" -print \
    2>/dev/null || true
} | tee inventario-configuracion.txt
```

### Buscar los ejecutables

```bash
{
  echo "===== EJECUTABLES ====="
  echo -n "Grafana: "
  command -v grafana-server || true
  echo -n "Prometheus: "
  command -v prometheus || true
  echo -n "Promtool: "
  command -v promtool || true
  echo -n "Node Exporter: "
  command -v node_exporter || true
} | tee inventario-ejecutables.txt
```

### Buscar los directorios de datos

```bash
{
  echo "===== DIRECTORIOS DE DATOS ====="
  for directory in \
    /var/lib/grafana \
    /var/lib/prometheus \
    /var/log/grafana \
    /etc/prometheus \
    /etc/grafana
  do
    if [ -d "$directory" ]; then
      echo "Existe: $directory"
      sudo du -sh "$directory"
    else
      echo "No existe: $directory"
    fi
  done
} | tee inventario-datos.txt
```

### Evidencias

Conserva los siguientes ficheros:

```text
inventario-configuracion.txt
inventario-ejecutables.txt
inventario-datos.txt
```

## Sesión práctica 2: investigar una unidad systemd

En esta sesión se analizará cómo se inicia y configura Prometheus.

### Objetivo

Identificar:

- La ruta de la unidad.
- El usuario de ejecución.
- El comando de inicio.
- El fichero de configuración.
- La ruta de datos.
- El puerto utilizado.

### Consultar la unidad

```bash
systemctl cat prometheus
```

### Consultar la ruta de la unidad

```bash
systemctl show prometheus \
  -p FragmentPath
```

### Consultar los parámetros principales

```bash
systemctl show prometheus \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath
```

### Consultar el proceso en ejecución

```bash
ps aux | grep "[p]rometheus"
```

### Consultar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Documentar los resultados

```bash
{
  echo "===== UNIDAD DE PROMETHEUS ====="
  systemctl show prometheus \
    -p User \
    -p Group \
    -p ExecStart \
    -p FragmentPath
  echo
  echo "===== PROCESO ====="
  ps aux | grep "[p]rometheus" || true
  echo
  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':9090' || true
} | tee analisis-prometheus.txt
```

### Preguntas de análisis

- ¿Qué usuario ejecuta Prometheus?
- ¿Qué fichero de configuración utiliza?
- ¿Qué ruta de almacenamiento utiliza?
- ¿Qué puerto aparece en el proceso?
- ¿Coincide la información de la unidad con la del proceso?

## Sesión práctica 3: modificar una configuración de forma segura

En esta sesión se practicará un procedimiento seguro para modificar la configuración de Prometheus.

### Objetivo

Aplicar el siguiente procedimiento:

```text
Copia de seguridad
        |
        v
Edición
        |
        v
Validación
        |
        v
Reinicio
        |
        v
Comprobación
```

### Crear la copia de seguridad

```bash
sudo cp /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%F-%H%M%S).bak"
```

Comprobar que existe:

```bash
sudo ls -l /etc/prometheus/prometheus.yml*
```

### Consultar la configuración actual

```bash
sudo less /etc/prometheus/prometheus.yml
```

### Editar el fichero

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Realiza únicamente un cambio controlado y autorizado por el profesor.

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus

Solo si la validación es correcta:

```bash
sudo systemctl restart prometheus
```

### Comprobar el estado

```bash
systemctl is-active prometheus
```

### Comprobar la salud

```bash
curl http://localhost:9090/-/healthy
```

### Consultar los registros

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

### Restaurar la copia si aparece un error

```bash
sudo cp /etc/prometheus/prometheus.yml.FECHA-HORA.bak \
  /etc/prometheus/prometheus.yml
```

Después:

```bash
sudo systemctl restart prometheus
```

### Evidencias

Incluye:

- Nombre de la copia de seguridad.
- Resultado de `promtool check config`.
- Estado posterior del servicio.
- Resultado del endpoint de salud.
- Registros relevantes.

## Sesión práctica 4: localizar el origen de un error

En esta sesión se simulará una investigación sobre un servicio que no funciona correctamente.

### Objetivo

Utilizar distintas fuentes de información para localizar la causa de un problema.

### Comprobar el servicio

```bash
systemctl status prometheus
```

### Consultar la unidad

```bash
systemctl cat prometheus
```

### Consultar el proceso

```bash
ps aux | grep "[p]rometheus"
```

### Consultar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Comprobar el endpoint

```bash
curl -v http://localhost:9090/-/healthy
```

### Consultar los registros

```bash
sudo journalctl -u prometheus \
  --since "15 minutes ago" \
  --no-pager
```

### Revisar la configuración

```bash
sudo grep -n -E \
  "scrape_interval|job_name|static_configs" \
  /etc/prometheus/prometheus.yml
```

### Registrar la investigación

```text
Componente analizado:

Ruta de configuración:

Ruta de datos:

Ruta de la unidad:

Usuario de ejecución:

Puerto:

Estado del servicio:

Resultado de curl:

Mensaje de error:

Causa identificada:

Corrección:

Resultado final:
```

## Sesión práctica 5: crear un informe de rutas y permisos

### Objetivo

Crear un informe con las rutas, los propietarios y los permisos de los componentes principales.

### Crear el informe

```bash
{
  echo "===== INFORME DE RUTAS Y PERMISOS ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  for path in \
    /etc/grafana/grafana.ini \
    /etc/grafana/provisioning \
    /var/lib/grafana \
    /etc/prometheus/prometheus.yml \
    /var/lib/prometheus \
    /etc/systemd/system/node_exporter.service \
    /usr/local/bin/node_exporter
  do
    echo "===== $path ====="

    if [ -e "$path" ]; then
      sudo stat \
        --format="Tipo: %F%nPermisos: %A%nPropietario: %U%nGrupo: %G%nTamaño: %s bytes%nRuta: %n" \
        "$path"
    else
      echo "No existe en esta instalación."
    fi

    echo
  done
} | tee informe-rutas-permisos.txt
```

### Revisar el informe

```bash
less informe-rutas-permisos.txt
```

### Identificar diferencias

Comprueba si alguna ruta esperada no existe. Si una ruta no está presente:

1. Consulta el método de instalación.
2. Consulta la unidad de `systemd`.
3. Consulta el proceso en ejecución.
4. Busca el ejecutable con `find`.
5. Documenta la ruta real encontrada.

## Sesión práctica 6: investigar Grafana

### Objetivo

Localizar la configuración, los datos, los plugins y los registros de Grafana.

### Consultar la configuración principal

```bash
sudo ls -l /etc/grafana/grafana.ini
```

```bash
sudo grep -n -E \
  "http_addr|http_port|domain|root_url|data" \
  /etc/grafana/grafana.ini
```

### Consultar el provisioning

```bash
sudo find /etc/grafana/provisioning \
  -maxdepth 2 \
  -type f \
  -print 2>/dev/null
```

### Consultar los datos

```bash
sudo du -sh /var/lib/grafana
```

### Consultar los plugins

```bash
sudo find /var/lib/grafana/plugins \
  -maxdepth 2 \
  -type d \
  -print 2>/dev/null
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  --since "30 minutes ago" \
  --no-pager
```

### Comprobar la unidad

```bash
systemctl show grafana-server \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath
```

### Resultado esperado

El informe debe permitir responder:

- ¿Dónde está `grafana.ini`?
- ¿Qué puerto utiliza Grafana?
- ¿Dónde se guardan sus datos?
- ¿Dónde se encuentran los plugins?
- ¿Qué usuario ejecuta el servicio?
- ¿Dónde se consultan sus registros?

## Rutas habituales resumidas

### Grafana

```text
/etc/grafana/grafana.ini
/etc/grafana/provisioning/
/var/lib/grafana/
/var/lib/grafana/plugins/
/var/log/grafana/
/lib/systemd/system/grafana-server.service
```

### Prometheus

```text
/etc/prometheus/prometheus.yml
/etc/prometheus/rules/
/var/lib/prometheus/
/usr/bin/prometheus
/usr/bin/promtool
/lib/systemd/system/prometheus.service
```

### Node Exporter

```text
/usr/local/bin/node_exporter
/usr/bin/node_exporter
/etc/systemd/system/node_exporter.service
```

### Registros mediante systemd

```bash
journalctl -u grafana-server
journalctl -u prometheus
journalctl -u node_exporter
```

## Tabla rápida de comandos

| Necesidad | Comando |
|---|---|
| Mostrar la ruta actual | `pwd` |
| Listar ficheros | `ls -lah` |
| Buscar un fichero | `find /ruta -name "fichero"` |
| Buscar texto | `grep -n "texto" fichero` |
| Consultar permisos | `stat fichero` |
| Consultar una unidad | `systemctl cat servicio` |
| Mostrar la ruta de una unidad | `systemctl show -p FragmentPath servicio` |
| Consultar el ejecutable | `command -v programa` |
| Consultar el proceso | `ps aux \| grep "[p]rograma"` |
| Consultar el tamaño | `du -sh ruta` |
| Crear una copia | `cp fichero fichero.bak` |
| Comparar ficheros | `diff -u original copia` |
| Validar Prometheus | `promtool check config fichero` |
| Consultar registros | `journalctl -u servicio` |

## Tabla de rutas principales

| Componente | Configuración | Datos | Unidad |
|---|---|---|---|
| Grafana | `/etc/grafana/` | `/var/lib/grafana/` | `grafana-server.service` |
| Prometheus | `/etc/prometheus/` | `/var/lib/prometheus/` | `prometheus.service` |
| Node Exporter | Parámetros de la unidad | No suele almacenar datos propios | `node_exporter.service` |

## Buenas prácticas

- Comprueba la ruta real antes de modificar un fichero.
- Crea una copia de seguridad antes de editar configuraciones.
- Valida la configuración antes de reiniciar un servicio.
- No modifiques directamente bases de datos de aplicaciones.
- No borres datos de Prometheus durante una práctica sin autorización.
- Comprueba los permisos y propietarios.
- Utiliza `systemctl cat` para conocer cómo se inicia un servicio.
- Utiliza `systemctl show` para consultar propiedades concretas.
- Documenta las rutas que no coincidan con las esperadas.
- Evita almacenar configuraciones permanentes en `/tmp`.
- No publiques ficheros que contengan contraseñas o tokens.
- Utiliza rutas absolutas en scripts de administración.
- Comprueba el resultado de cada comando antes de continuar.

## Puntos clave

- `/etc` contiene configuraciones.
- `/var/lib` contiene datos variables de las aplicaciones.
- `/var/log` contiene registros almacenados en ficheros.
- `/usr/bin`, `/usr/sbin` y `/usr/local/bin` contienen ejecutables.
- Las unidades de `systemd` definen cómo se gestionan los servicios.
- Grafana utiliza normalmente `/etc/grafana/` y `/var/lib/grafana/`.
- Prometheus utiliza normalmente `/etc/prometheus/` y `/var/lib/prometheus/`.
- Node Exporter suele definirse mediante una unidad `systemd`.
- `systemctl cat` muestra la definición de un servicio.
- `systemctl show` permite consultar propiedades de una unidad.
- `find` localiza ficheros y directorios.
- `grep` localiza texto dentro de ficheros.
- `stat` muestra permisos, propietario, grupo y tamaño.
- Antes de editar una configuración se debe crear una copia de seguridad.
- Una configuración debe validarse antes de reiniciar el servicio.

## Preguntas de comprobación

1. ¿Qué tipo de información se almacena normalmente en `/etc`?
2. ¿Qué tipo de información se almacena normalmente en `/var/lib`?
3. ¿Cuál es la ruta habitual de la configuración principal de Prometheus?
4. ¿Cuál es la ruta habitual de los datos de Prometheus?
5. ¿Cuál es la ruta habitual de la configuración principal de Grafana?
6. ¿Dónde suelen almacenarse los plugins de Grafana?
7. ¿Qué comando permite consultar la definición de una unidad `systemd`?
8. ¿Qué comando permite mostrar la ruta física de una unidad?
9. ¿Qué comando permite localizar `prometheus.yml`?
10. ¿Qué comando permite buscar `node_exporter` dentro de una configuración?
11. ¿Qué información muestra `stat`?
12. ¿Por qué se debe crear una copia de seguridad antes de editar una configuración?
13. ¿Qué herramienta permite validar la configuración de Prometheus?
14. ¿Dónde se pueden consultar los registros de un servicio gestionado por `systemd`?
15. ¿Qué diferencia existe entre una ruta de configuración y una ruta de datos?
16. ¿Por qué las rutas pueden variar según el método de instalación?
17. ¿Qué información puedes obtener con `systemctl show prometheus -p ExecStart`?
18. ¿Qué procedimiento seguirías para localizar un fichero cuya ruta desconoces?
19. ¿Qué riesgos existen al modificar directamente una base de datos de Grafana?
20. ¿Qué pasos realizarías antes de reiniciar Prometheus después de editar su configuración?