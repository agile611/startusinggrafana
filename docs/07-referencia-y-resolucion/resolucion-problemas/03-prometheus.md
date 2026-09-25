# Problemas con Prometheus

Esta página explica cómo diagnosticar y resolver los problemas más habituales de Prometheus en un entorno basado en Ubuntu, Grafana y Node Exporter.

Prometheus puede presentar problemas en diferentes niveles:

```text
Instalación
    |
    v
Servicio systemd
    |
    v
Fichero de configuración
    |
    v
Puerto HTTP
    |
    v
Targets y scraping
    |
    v
Almacenamiento de métricas
    |
    v
Consultas PromQL
    |
    v
Grafana
```

El objetivo del diagnóstico es localizar el punto exacto en el que se produce el fallo. No basta con comprobar que Prometheus está iniciado: también hay que verificar que la configuración es válida, que los targets responden, que las métricas se almacenan y que las consultas devuelven resultados.

> **Advertencia:** realiza las prácticas en un entorno de laboratorio. Antes de modificar `prometheus.yml`, crea una copia de seguridad y valida la configuración antes de reiniciar el servicio.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Comprobar si Prometheus está instalado correctamente.
- Consultar el estado del servicio `prometheus`.
- Revisar los registros de Prometheus.
- Validar el fichero `prometheus.yml`.
- Comprobar el puerto `9090`.
- Comprobar el endpoint de salud de Prometheus.
- Identificar targets activos y caídos.
- Diagnosticar problemas de scraping.
- Comprobar la comunicación con Node Exporter.
- Analizar errores de permisos y almacenamiento.
- Revisar problemas relacionados con PromQL.
- Crear copias de seguridad de la configuración.
- Recuperar una configuración válida.
- Documentar una incidencia de Prometheus.

## Introducción

Prometheus recopila métricas mediante un mecanismo denominado scraping. De forma periódica, Prometheus consulta los endpoints configurados y almacena las métricas obtenidas.

En el laboratorio, el flujo habitual es:

```text
Node Exporter
    |
    | http://localhost:9100/metrics
    v
Prometheus
    |
    | http://localhost:9090
    v
Grafana
```

Si Node Exporter no responde, Prometheus no podrá recopilar sus métricas. Si Prometheus está detenido, Grafana no podrá consultar los datos. Si la configuración contiene un error, el servicio puede no iniciar o puede iniciar sin recopilar los targets esperados.

## Arquitectura básica de Prometheus

### Componentes principales

Prometheus está formado por varios elementos:

- Servidor Prometheus.
- Fichero de configuración.
- Base de datos de series temporales.
- Targets.
- Reglas de grabación.
- Reglas de alerta.
- API HTTP.
- Interfaz web.
- Exporters.

### Servidor Prometheus

El proceso principal ejecuta el servidor y proporciona:

- API HTTP.
- Interfaz web.
- Motor de consultas PromQL.
- Sistema de scraping.
- Evaluación de reglas.
- Almacenamiento local.

### Fichero de configuración

La ruta habitual es:

```text
/etc/prometheus/prometheus.yml
```

La ruta puede variar si Prometheus se ha instalado manualmente. Consulta siempre la unidad de `systemd`:

```bash
systemctl show prometheus -p ExecStart
```

### Almacenamiento

La ruta habitual de los datos es:

```text
/var/lib/prometheus/
```

Consultar su tamaño:

```bash
sudo du -sh /var/lib/prometheus
```

### Puerto HTTP

Prometheus utiliza normalmente:

```text
9090/tcp
```

La interfaz web suele estar disponible en:

```text
http://localhost:9090
```

## Procedimiento general de diagnóstico

### Identificar el síntoma

Registra exactamente qué ocurre:

```text
Prometheus no inicia.
Prometheus inicia, pero no aparecen targets.
Un target aparece como DOWN.
Grafana no puede consultar Prometheus.
La consulta up no devuelve resultados.
El disco está lleno.
La configuración no se valida.
```

### Comprobar el servicio

```bash
systemctl status prometheus
```

### Consultar los registros

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Comprobar la salud

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar los targets

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Ejecutar una consulta básica

```promql
up
```

## Comprobar la instalación

### Consultar los paquetes instalados

```bash
dpkg -l | grep prometheus
```

También:

```bash
apt policy prometheus
```

### Localizar el ejecutable

```bash
command -v prometheus
```

Si no aparece:

```bash
sudo find /usr /opt -type f \
  -name "prometheus" \
  -executable 2>/dev/null
```

### Localizar `promtool`

```bash
command -v promtool
```

Si no aparece:

```bash
sudo find /usr /opt -type f \
  -name "promtool" \
  -executable 2>/dev/null
```

### Consultar la versión

```bash
prometheus --version
```

```bash
promtool --version
```

### Consultar la arquitectura

```bash
uname -m
```

Consultar la arquitectura del binario:

```bash
file "$(command -v prometheus)"
```

La arquitectura del binario debe ser compatible con la del sistema.

### Consultar las rutas principales

```bash
sudo ls -lah /etc/prometheus
```

```bash
sudo ls -lah /var/lib/prometheus
```

## Comprobar el servicio de Prometheus

### Consultar el estado completo

```bash
systemctl status prometheus
```

Estados habituales:

```text
active
inactive
failed
activating
deactivating
```

### Comprobar si está activo

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

### Comprobar si se inicia automáticamente

```bash
systemctl is-enabled prometheus
```

Resultado esperado:

```text
enabled
```

### Iniciar Prometheus

```bash
sudo systemctl start prometheus
```

### Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

### Detener Prometheus

```bash
sudo systemctl stop prometheus
```

Realiza esta operación únicamente en el laboratorio o durante una ventana de mantenimiento autorizada.

### Activar el inicio automático

```bash
sudo systemctl enable prometheus
```

Activar e iniciar simultáneamente:

```bash
sudo systemctl enable --now prometheus
```

### Consultar servicios fallidos

```bash
systemctl --failed
```

## Consultar la unidad systemd

### Mostrar la unidad

```bash
systemctl cat prometheus
```

### Consultar la ruta de la unidad

```bash
systemctl show prometheus \
  -p FragmentPath
```

### Consultar el comando de inicio

```bash
systemctl show prometheus \
  -p ExecStart
```

### Consultar el usuario y el grupo

```bash
systemctl show prometheus \
  -p User \
  -p Group
```

### Consultar varias propiedades

```bash
systemctl show prometheus \
  -p User \
  -p Group \
  -p ExecStart \
  -p FragmentPath \
  -p WorkingDirectory
```

### Consultar el proceso

```bash
ps aux | grep "[p]rometheus"
```

### Comparar la unidad y el proceso

Comprueba que coincidan:

- Ruta del ejecutable.
- Fichero de configuración.
- Directorio de datos.
- Puerto.
- Usuario.
- Parámetros de inicio.

## Consultar los registros

### Últimas líneas

```bash
sudo journalctl -u prometheus \
  -n 50 \
  --no-pager
```

### Registros desde el último arranque

```bash
sudo journalctl -u prometheus \
  -b \
  --no-pager
```

### Seguir los registros en tiempo real

```bash
sudo journalctl -u prometheus -f
```

Para detener la salida:

```text
Ctrl + C
```

### Consultar errores

```bash
sudo journalctl -u prometheus \
  -p err \
  --since "30 minutes ago" \
  --no-pager
```

### Buscar mensajes importantes

```bash
sudo journalctl -u prometheus \
  --no-pager \
  | grep -i -E \
  "error|failed|invalid|panic|permission|denied|fatal"
```

### Consultar registros desde una hora concreta

```bash
sudo journalctl -u prometheus \
  --since "2026-09-25 10:00:00" \
  --no-pager
```

## Validar la configuración

### Validar `prometheus.yml`

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS
```

### Validar reglas

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

Si la ruta no existe, comprueba primero:

```bash
sudo find /etc/prometheus \
  -type f \
  \( -name "*.yml" -o -name "*.yaml" \) \
  -print
```

### Mostrar el fichero con números de línea

```bash
sudo nl -ba /etc/prometheus/prometheus.yml
```

### Mostrar una zona concreta

```bash
sudo nl -ba /etc/prometheus/prometheus.yml \
  | sed -n '1,80p'
```

### Comprobar la sintaxis después de editar

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

No reinicies Prometheus si la validación devuelve errores.

## Copias de seguridad de la configuración

### Crear una copia de seguridad

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.bak
```

### Crear una copia con fecha

```bash
sudo cp /etc/prometheus/prometheus.yml \
  "/etc/prometheus/prometheus.yml.$(date +%F-%H%M%S).bak"
```

### Comprobar las copias

```bash
sudo ls -lah /etc/prometheus/prometheus.yml*
```

### Comparar dos ficheros

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

Después:

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

Y, si la validación es correcta:

```bash
sudo systemctl restart prometheus
```

## Errores de sintaxis YAML

Prometheus utiliza YAML para su configuración. YAML depende de la sangría.

### Configuración incorrecta

```yaml
scrape_configs:
- job_name: node_exporter
  static_configs:
    - targets:
      - localhost:9100
```

### Configuración correcta

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
```

### Error por clave incorrecta

Ejemplo incorrecto:

```yaml
scrape_config:
  - job_name: node_exporter
```

La clave correcta es:

```yaml
scrape_configs:
  - job_name: node_exporter
```

### Consultar el número de línea del error

Si `promtool` indica la línea `25`:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml \
  | sed -n '20,30p'
```

### Errores habituales de YAML

- Sangría incorrecta.
- Uso incorrecto de tabuladores.
- Dos puntos ausentes.
- Comillas sin cerrar.
- Claves escritas incorrectamente.
- Listas mal formadas.
- Valores colocados en el nivel equivocado.

> Utiliza espacios, no tabuladores, para la sangría YAML.

## Estructura básica de `prometheus.yml`

### Ejemplo mínimo

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
```

### Configurar Node Exporter

```yaml
global:
  scrape_interval: 15s

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

### Configurar un target remoto

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - 192.168.1.50:9100
```

### Añadir etiquetas estáticas

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          entorno: laboratorio
          servicio: sistema
```

Después se puede consultar:

```promql
up{entorno="laboratorio"}
```

### Comprobar la configuración después de modificarla

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

```bash
systemctl is-active prometheus
```

## Problemas de permisos

### Consultar permisos de la configuración

```bash
sudo stat /etc/prometheus/prometheus.yml
```

### Consultar permisos del directorio de datos

```bash
sudo stat /var/lib/prometheus
```

### Consultar el usuario del servicio

```bash
systemctl show prometheus \
  -p User \
  -p Group
```

### Comprobar si el usuario puede leer la configuración

```bash
sudo -u prometheus test -r \
  /etc/prometheus/prometheus.yml \
  && echo "Puede leer la configuración" \
  || echo "No puede leer la configuración"
```

### Comprobar si puede escribir en los datos

```bash
sudo -u prometheus test -w \
  /var/lib/prometheus \
  && echo "Puede escribir en los datos" \
  || echo "No puede escribir en los datos"
```

### Consultar todos los permisos de la ruta

```bash
namei -l /etc/prometheus/prometheus.yml
```

### Corregir el propietario de los datos

Solo si corresponde al entorno:

```bash
sudo chown -R prometheus:prometheus \
  /var/lib/prometheus
```

### Corregir el propietario de la configuración

```bash
sudo chown prometheus:prometheus \
  /etc/prometheus/prometheus.yml
```

### Corregir los permisos

```bash
sudo chmod 640 \
  /etc/prometheus/prometheus.yml
```

No utilices:

```bash
sudo chmod -R 777 /etc/prometheus
```

## Problemas de almacenamiento

### Comprobar el espacio disponible

```bash
df -h
```

Comprobar la ruta de Prometheus:

```bash
df -h /var/lib/prometheus
```

### Consultar el tamaño de los datos

```bash
sudo du -sh /var/lib/prometheus
```

### Consultar el tamaño de los subdirectorios

```bash
sudo du -h --max-depth=1 \
  /var/lib/prometheus \
  | sort -h
```

### Consultar el uso del journal

```bash
sudo journalctl --disk-usage
```

### Buscar ficheros grandes

```bash
sudo find /var/lib/prometheus \
  -type f \
  -size +500M \
  -printf "%s %p\n" \
  | sort -n
```

### Síntomas de falta de espacio

- Prometheus no inicia.
- No se pueden guardar muestras.
- Aparecen errores de escritura.
- Los targets están activos, pero no hay datos recientes.
- Grafana muestra paneles vacíos.
- El sistema genera errores de disco lleno.

### Comprobar los registros

```bash
sudo journalctl -u prometheus \
  --no-pager \
  | grep -i -E \
  "no space|disk full|write|storage|wal"
```

No borres manualmente la base de datos de Prometheus sin comprender las consecuencias.

## Problemas con el puerto 9090

### Comprobar si está en escucha

```bash
sudo ss -lntp | grep ':9090'
```

### Identificar el proceso

```bash
sudo lsof -iTCP:9090 -sTCP:LISTEN
```

### Comprobar el endpoint local

```bash
curl -I http://localhost:9090
```

### Comprobar la salud

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Puerto ocupado

Si el puerto está siendo utilizado por otro proceso:

```bash
ps -fp PID
```

Consulta los procesos Prometheus:

```bash
ps aux | grep "[p]rometheus"
```

Posibles causas:

- Hay dos instancias de Prometheus.
- Existe una ejecución manual además del servicio.
- Otro programa utiliza el puerto.
- Una instalación anterior sigue activa.

### Cambiar el puerto

El puerto puede definirse mediante un parámetro de ejecución:

```text
--web.listen-address=0.0.0.0:9091
```

Consulta primero la unidad:

```bash
systemctl cat prometheus
```

Después de modificar la unidad:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprueba:

```bash
sudo ss -lntp | grep ':9091'
```

## Problemas de scraping

### Qué es el scraping

El scraping es el proceso mediante el cual Prometheus consulta periódicamente un endpoint de métricas.

Ejemplo:

```text
Prometheus → http://localhost:9100/metrics
```

### Consultar los targets desde la interfaz

Abre:

```text
http://localhost:9090/targets
```

La página muestra:

- Job.
- Instance.
- Estado.
- Último scraping.
- Duración.
- Último error.

### Consultar los targets mediante la API

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Mostrar solo los targets activos

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[]'
```

### Mostrar información resumida

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

### Estados de un target

| Estado | Significado |
|---|---|
| `up` | El scraping funciona |
| `down` | El scraping ha fallado |
| `unknown` | No hay información suficiente |

### Comprobar la métrica `up`

```promql
up
```

Consultar Node Exporter:

```promql
up{job="node_exporter"}
```

Un valor de:

```text
1
```

indica normalmente que el target está disponible.

Un valor de:

```text
0
```

indica que el scraping ha fallado.

## Diagnosticar un target `DOWN`

### Comprobar el servicio del exporter

```bash
systemctl is-active node_exporter
```

### Comprobar el puerto del exporter

```bash
sudo ss -lntp | grep ':9100'
```

### Probar el endpoint desde el servidor de Prometheus

```bash
curl -I http://localhost:9100/metrics
```

Si Node Exporter está en otro equipo:

```bash
curl -I http://DIRECCION_IP_NODE_EXPORTER:9100/metrics
```

### Consultar los registros de Node Exporter

```bash
sudo journalctl -u node_exporter \
  -n 50 \
  --no-pager
```

### Revisar la configuración del target

```bash
sudo grep -n -A 8 -B 3 \
  "node_exporter" \
  /etc/prometheus/prometheus.yml
```

### Comprobar el nombre y el puerto

Verifica que el target tenga el formato:

```text
nombre-o-ip:9100
```

Ejemplo:

```yaml
static_configs:
  - targets:
      - localhost:9100
```

### Posibles causas

- Node Exporter está detenido.
- La dirección IP es incorrecta.
- El puerto es incorrecto.
- El firewall bloquea el acceso.
- Prometheus no puede resolver el nombre.
- El endpoint no es `/metrics`.
- El target se configuró en el job equivocado.
- La red no permite la conexión.
- Node Exporter escucha solo en `localhost`.

## Problemas de resolución DNS

### Resolver un nombre desde el servidor Prometheus

```bash
getent hosts node-exporter.ejemplo.local
```

```bash
resolvectl query node-exporter.ejemplo.local
```

### Probar la conectividad por nombre

```bash
curl -I \
  http://node-exporter.ejemplo.local:9100/metrics
```

### Probar mediante IP

```bash
curl -I \
  http://192.168.1.50:9100/metrics
```

Si funciona mediante IP, pero no mediante nombre, existe probablemente un problema de resolución DNS o del fichero `/etc/hosts`.

### Consultar `/etc/hosts`

```bash
cat /etc/hosts
```

## Problemas de conectividad entre Prometheus y Node Exporter

### Desde el servidor de Prometheus

```bash
ping -c 4 DIRECCION_IP_NODE_EXPORTER
```

```bash
nc -vz DIRECCION_IP_NODE_EXPORTER 9100
```

```bash
curl -I \
  http://DIRECCION_IP_NODE_EXPORTER:9100/metrics
```

### En el servidor de Node Exporter

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar el firewall de Node Exporter

```bash
sudo ufw status verbose
```

Permitir únicamente el servidor Prometheus:

```bash
sudo ufw allow from DIRECCION_IP_PROMETHEUS \
  to any port 9100 \
  proto tcp
```

### Interpretar errores

#### `Connection refused`

No hay un proceso aceptando conexiones en el puerto o el servicio está detenido.

#### `Connection timed out`

Puede existir un problema de firewall, ruta o conectividad.

#### `No route to host`

El servidor Prometheus no tiene una ruta válida hasta el target.

#### `Could not resolve host`

El nombre no se puede resolver.

## Problemas de consultas PromQL

### La consulta `up` no devuelve resultados

Comprueba:

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

Comprueba que los targets estén configurados:

```bash
sudo grep -n "job_name" \
  /etc/prometheus/prometheus.yml
```

### La métrica no existe

Consulta directamente el endpoint del exporter:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_memory_" \
  | head
```

Consulta los nombres de métricas almacenados:

```bash
curl -s \
  http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

### La consulta devuelve cero series

Posibles causas:

- El nombre de la métrica es incorrecto.
- El nombre de la etiqueta es incorrecto.
- El valor de la etiqueta no coincide.
- El target no está disponible.
- No existen datos para el intervalo consultado.
- La métrica no está expuesta por la versión instalada.

Empieza con una consulta amplia:

```promql
up
```

Después:

```promql
node_load1
```

Y finalmente añade filtros:

```promql
node_load1{
  job="node_exporter"
}
```

### Problemas con `rate`

Incorrecto:

```promql
rate(node_cpu_seconds_total)
```

Correcto:

```promql
rate(node_cpu_seconds_total[5m])
```

### Diferenciar gauge y counter

Un gauge puede subir y bajar:

```promql
node_load1
```

Un counter aumenta de forma acumulativa:

```promql
node_cpu_seconds_total
```

Los counters suelen utilizarse con:

```promql
rate(metric[5m])
```

## Problemas con reglas de grabación y alertas

### Localizar las reglas

```bash
sudo find /etc/prometheus \
  -type f \
  \( -name "*.yml" -o -name "*.yaml" \) \
  -print
```

### Validar las reglas

```bash
promtool check rules \
  /etc/prometheus/rules/*.yml
```

### Consultar las reglas mediante la API

```bash
curl -s http://localhost:9090/api/v1/rules \
  | jq
```

### Consultar las alertas activas

```bash
curl -s http://localhost:9090/api/v1/alerts \
  | jq
```

### Consultar desde la interfaz

Abre:

```text
http://localhost:9090/rules
```

y:

```text
http://localhost:9090/alerts
```

### Problemas habituales

- Ruta incorrecta en `rule_files`.
- Error de sintaxis.
- Nombre de métrica incorrecto.
- Expresión PromQL vacía.
- Archivo no legible.
- Regla no cargada después de modificarla.
- Umbral incorrecto.
- Falta de datos históricos.

## Problemas de recarga de configuración

### Reiniciar el servicio

```bash
sudo systemctl restart prometheus
```

### Recargar la configuración

Si Prometheus está configurado para permitir la recarga:

```bash
curl -X POST http://localhost:9090/-/reload
```

La posibilidad depende de cómo se haya iniciado Prometheus y de sus opciones de seguridad.

### Validar antes de recargar

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Comprobar los registros después de recargar

```bash
sudo journalctl -u prometheus \
  --since "5 minutes ago" \
  --no-pager
```

## Problemas con Grafana y Prometheus

### Grafana está accesible, pero no muestra datos

Comprueba primero Prometheus:

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar desde el servidor de Grafana

```bash
curl -I http://localhost:9090
```

Si Prometheus está en otro equipo:

```bash
curl -I \
  http://DIRECCION_IP_PROMETHEUS:9090
```

### Validar la fuente de datos

En Grafana:

1. Abre **Connections**.
2. Selecciona **Data sources**.
3. Abre la fuente Prometheus.
4. Revisa la URL.
5. Pulsa **Save & test**.

### Error habitual con `localhost`

Si Grafana y Prometheus están en servidores diferentes, esta URL es incorrecta desde Grafana:

```text
http://localhost:9090
```

Debes utilizar la dirección del servidor Prometheus:

```text
http://DIRECCION_IP_PROMETHEUS:9090
```

### Consultar los registros de Grafana

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager \
  | grep -i -E \
  "prometheus|datasource|timeout|refused"
```

## Problemas de almacenamiento de series temporales

### Consultar el directorio de datos

```bash
sudo ls -lah /var/lib/prometheus
```

### Consultar el tamaño

```bash
sudo du -sh /var/lib/prometheus
```

### Consultar el espacio disponible

```bash
df -h /var/lib/prometheus
```

### Consultar errores de escritura

```bash
sudo journalctl -u prometheus \
  --no-pager \
  | grep -i -E \
  "storage|wal|write|disk|no space"
```

### Retención de datos

Consulta los parámetros de inicio:

```bash
systemctl show prometheus \
  -p ExecStart
```

Busca opciones relacionadas con:

```text
--storage.tsdb.path
--storage.tsdb.retention.time
--storage.tsdb.retention.size
```

No cambies la retención sin comprender el impacto en el almacenamiento y en los datos históricos.

## Sesión práctica 1: Prometheus no inicia

### Objetivo

Diagnosticar un servicio de Prometheus que no consigue iniciar.

### Comprobar el estado

```bash
systemctl status prometheus
```

### Consultar los registros

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

### Comprobar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Consultar la unidad

```bash
systemctl show prometheus \
  -p ExecStart \
  -p User \
  -p Group
```

### Comprobar permisos

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

### Procedimiento de recuperación

Si la configuración es incorrecta:

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.invalid
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

### Validar

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Preguntas de análisis

- ¿Qué mensaje aparece en los registros?
- ¿La configuración se puede validar?
- ¿El usuario del servicio puede leerla?
- ¿Hay espacio suficiente?
- ¿Qué cambio permitió recuperar el servicio?

## Sesión práctica 2: localizar un error de configuración

### Objetivo

Encontrar un error de sintaxis en `prometheus.yml`.

> Realiza esta actividad únicamente en el entorno de laboratorio.

### Crear una copia

```bash
sudo cp /etc/prometheus/prometheus.yml \
  /etc/prometheus/prometheus.yml.practica
```

### Validar la configuración

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Consultar la línea indicada

Si el error aparece en la línea `20`:

```bash
sudo nl -ba /etc/prometheus/prometheus.yml \
  | sed -n '15,25p'
```

### Editar el fichero

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Corrige únicamente el problema indicado.

### Validar de nuevo

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

### Reiniciar

```bash
sudo systemctl restart prometheus
```

### Comprobar el resultado

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Restaurar si es necesario

```bash
sudo cp /etc/prometheus/prometheus.yml.practica \
  /etc/prometheus/prometheus.yml
```

## Sesión práctica 3: diagnosticar un target `DOWN`

### Objetivo

Determinar por qué Node Exporter no aparece disponible para Prometheus.

### Consultar los targets

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Ejecutar la consulta

```promql
up{job="node_exporter"}
```

### Comprobar Node Exporter

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -I http://localhost:9100/metrics
```

### Consultar el registro

```bash
sudo journalctl -u node_exporter \
  -n 50 \
  --no-pager
```

### Revisar la configuración de Prometheus

```bash
sudo grep -n -A 8 -B 3 \
  "node_exporter" \
  /etc/prometheus/prometheus.yml
```

### Corregir el servicio si está detenido

```bash
sudo systemctl start node_exporter
```

### Comprobar de nuevo

```bash
curl -I http://localhost:9100/metrics
```

Espera uno o varios intervalos de scraping y consulta:

```promql
up{job="node_exporter"}
```

### Preguntas de análisis

- ¿El servicio Node Exporter estaba activo?
- ¿El puerto `9100` estaba en escucha?
- ¿El endpoint respondía?
- ¿Qué mensaje aparecía en el target?
- ¿Cuánto tardó Prometheus en detectar la recuperación?

## Sesión práctica 4: comprobar una configuración remota

### Objetivo

Diagnosticar un target que se ejecuta en otro equipo.

### Situación

Prometheus se ejecuta en:

```text
192.168.1.10
```

Node Exporter se ejecuta en:

```text
192.168.1.20
```

### Probar desde Prometheus

```bash
curl -I \
  http://192.168.1.20:9100/metrics
```

### Comprobar la red

```bash
ping -c 4 192.168.1.20
```

```bash
nc -vz 192.168.1.20 9100
```

### Comprobar el firewall del target

En `192.168.1.20`:

```bash
sudo ufw status verbose
```

Permitir únicamente a Prometheus:

```bash
sudo ufw allow from 192.168.1.10 \
  to any port 9100 \
  proto tcp
```

### Revisar la configuración

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - 192.168.1.20:9100
```

### Validar y reiniciar

```bash
promtool check config \
  /etc/prometheus/prometheus.yml
```

```bash
sudo systemctl restart prometheus
```

### Comprobar el target

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

## Sesión práctica 5: diagnosticar un problema de almacenamiento

### Objetivo

Comprobar si Prometheus puede guardar datos.

### Consultar el espacio

```bash
df -h /var/lib/prometheus
```

### Consultar el tamaño de los datos

```bash
sudo du -sh /var/lib/prometheus
```

### Consultar registros

```bash
sudo journalctl -u prometheus \
  --no-pager \
  | grep -i -E \
  "disk|storage|wal|write|space"
```

### Consultar el usuario

```bash
systemctl show prometheus \
  -p User \
  -p Group
```

### Comprobar escritura

```bash
sudo -u prometheus test -w \
  /var/lib/prometheus \
  && echo "Puede escribir" \
  || echo "No puede escribir"
```

### Crear un informe

```bash
{
  echo "===== DIAGNÓSTICO DE ALMACENAMIENTO ====="
  echo "Fecha: $(date)"
  echo
  echo "Espacio:"
  df -h /var/lib/prometheus
  echo
  echo "Tamaño:"
  sudo du -sh /var/lib/prometheus
  echo
  echo "Permisos:"
  sudo stat /var/lib/prometheus
  echo
  echo "Usuario del servicio:"
  systemctl show prometheus -p User -p Group
  echo
  echo "Errores:"
  sudo journalctl -u prometheus \
    --since "30 minutes ago" \
    --no-pager \
    | grep -i -E "disk|storage|wal|write|space" \
    || true
} | tee diagnostico-almacenamiento.txt
```

## Sesión práctica 6: comprobar la comunicación con Grafana

### Objetivo

Determinar si Grafana puede utilizar Prometheus como fuente de datos.

### Comprobar Prometheus

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar la API

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Probar desde el servidor de Grafana

Si ambos servicios están en equipos diferentes:

```bash
curl -I \
  http://DIRECCION_IP_PROMETHEUS:9090
```

### Revisar Grafana

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager \
  | grep -i -E \
  "prometheus|datasource|timeout|refused"
```

### Validar en la interfaz

En Grafana:

1. Abre la fuente de datos de Prometheus.
2. Comprueba la URL.
3. Pulsa **Save & test**.
4. Revisa el mensaje obtenido.
5. Abre el explorador de consultas.
6. Ejecuta:

```promql
up
```

## Sesión práctica 7: construir un informe de Prometheus

### Objetivo

Recopilar toda la información relevante del servicio.

### Preparación

```bash
mkdir -p ~/laboratorio/problemas-prometheus
cd ~/laboratorio/problemas-prometheus
```

### Generar el informe

```bash
{
  echo "===== INFORME DE PROMETHEUS ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== VERSIONES ====="
  prometheus --version 2>/dev/null || true
  promtool --version 2>/dev/null || true
  echo

  echo "===== SERVICIO ====="
  systemctl is-active prometheus 2>/dev/null || true
  systemctl is-enabled prometheus 2>/dev/null || true
  echo

  echo "===== UNIDAD ====="
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
  echo

  echo "===== SALUD ====="
  curl -sS \
    --max-time 5 \
    http://localhost:9090/-/healthy \
    || true
  echo
  echo

  echo "===== CONFIGURACION ====="
  promtool check config \
    /etc/prometheus/prometheus.yml \
    2>&1 || true
  echo

  echo "===== TARGETS ====="
  curl -sS \
    --max-time 5 \
    http://localhost:9090/api/v1/targets \
    || true
  echo
  echo

  echo "===== ALMACENAMIENTO ====="
  df -h /var/lib/prometheus
  sudo du -sh /var/lib/prometheus 2>/dev/null || true
  echo

  echo "===== REGISTROS ====="
  sudo journalctl -u prometheus \
    -n 50 \
    --no-pager
} | tee informe-prometheus.txt
```

### Revisar el informe

```bash
less informe-prometheus.txt
```

## Lista de comprobación rápida

```text
[ ] Prometheus está instalado.
[ ] prometheus está disponible en el PATH.
[ ] promtool está disponible.
[ ] La arquitectura es compatible.
[ ] El usuario prometheus existe.
[ ] La unidad systemd existe.
[ ] El servicio está activo.
[ ] La configuración se valida correctamente.
[ ] El puerto 9090 está en escucha.
[ ] El endpoint /-/healthy responde.
[ ] El directorio de datos existe.
[ ] Hay espacio disponible.
[ ] Los permisos son correctos.
[ ] Los targets están configurados.
[ ] Los targets aparecen como UP.
[ ] Node Exporter responde.
[ ] La consulta up devuelve resultados.
[ ] Grafana puede consultar Prometheus.
[ ] Los registros no muestran errores críticos.
```

## Buenas prácticas

- Valida siempre `prometheus.yml` antes de reiniciar.
- Crea una copia de seguridad antes de editar.
- Revisa los registros antes de aplicar cambios.
- Comprueba la unidad de `systemd` para conocer los parámetros reales.
- No supongas que las rutas son iguales en instalaciones diferentes.
- Verifica la dirección y el puerto de cada target.
- Prueba el endpoint desde el servidor de Prometheus.
- Comprueba el firewall del servidor exporter.
- Utiliza `up` para validar la disponibilidad.
- No confundas un target `UP` con una métrica correcta en Grafana.
- Controla el espacio ocupado por las series temporales.
- No borres el directorio de datos como solución rápida.
- Limita los puertos a las redes necesarias.
- Utiliza nombres de jobs descriptivos.
- Documenta los intervalos de scraping.
- Comprueba las etiquetas utilizadas en las consultas.
- Construye las consultas PromQL paso a paso.
- Mantén copias de configuraciones válidas.
- Cambia una sola cosa cada vez.
- Documenta el resultado de cada prueba.

## Tabla de síntomas y comprobaciones

| Síntoma | Primera comprobación | Comprobación adicional |
|---|---|---|
| Prometheus no inicia | `systemctl status prometheus` | `journalctl` y `promtool` |
| Error de YAML | `promtool check config` | Revisar números de línea |
| Puerto 9090 ocupado | `ss -lntp` | `lsof` |
| Endpoint no responde | `curl` | Servicio y firewall |
| Target `DOWN` | API de targets | Endpoint del exporter |
| Consulta vacía | `up` | Nombre de métrica y etiquetas |
| No se guardan datos | `df -h` | Permisos y registros |
| Grafana no muestra datos | Fuente de datos | Conectividad con Prometheus |
| Servicio activo sin datos | Targets | Configuración de scraping |
| Regla no aparece | `promtool check rules` | Ruta `rule_files` |

## Puntos clave

- Prometheus utiliza normalmente el puerto `9090`.
- `systemctl status prometheus` muestra el estado del servicio.
- `journalctl -u prometheus` muestra los registros.
- `promtool check config` valida el fichero de configuración.
- YAML depende de la sangría.
- `ss -lntp` permite comprobar el puerto y el proceso asociado.
- `/api/v1/targets` permite consultar el estado de los targets.
- `up` muestra si un target está disponible.
- Un valor `1` indica normalmente que el scraping funciona.
- Un valor `0` indica que el scraping ha fallado.
- Node Exporter debe responder en `/metrics`.
- Prometheus debe poder conectarse al endpoint del exporter.
- `localhost` solo representa el equipo desde el que se realiza la conexión.
- El espacio y los permisos pueden impedir el almacenamiento de métricas.
- Grafana puede estar activo aunque Prometheus no tenga datos.
- Una consulta PromQL vacía puede deberse a una métrica, etiqueta o filtro incorrecto.
- Las reglas deben validarse antes de aplicarse.
- Las configuraciones deben respaldarse antes de modificarse.
- El diagnóstico debe comprobar servicio, puerto, configuración, target y datos.
- Toda incidencia debe documentar síntoma, causa, corrección y validación.

## Preguntas de comprobación

1. ¿Qué función cumple Prometheus en el entorno de monitorización?
2. ¿Cuál es el puerto habitual de Prometheus?
3. ¿Qué comando permite consultar el estado del servicio?
4. ¿Qué comando permite consultar los registros de Prometheus?
5. ¿Qué herramienta permite validar `prometheus.yml`?
6. ¿Por qué la sangría es importante en YAML?
7. ¿Qué comando permite comprobar si el puerto `9090` está en escucha?
8. ¿Qué endpoint permite comprobar la salud de Prometheus?
9. ¿Qué información muestra la API de targets?
10. ¿Qué significa que un target tenga estado `DOWN`?
11. ¿Qué diferencia existe entre `up == 1` y `up == 0`?
12. ¿Qué comprobarías si Node Exporter aparece como `DOWN`?
13. ¿Qué comprobarías si Prometheus no puede escribir datos?
14. ¿Qué información puedes obtener con `systemctl show prometheus -p ExecStart`?
15. ¿Por qué debes validar la configuración antes de reiniciar?
16. ¿Qué puede provocar que una consulta PromQL no devuelva resultados?
17. ¿Qué diferencia existe entre un problema de Prometheus y un problema de Grafana?
18. ¿Qué riesgos tiene borrar directamente el directorio de datos?
19. ¿Qué comprobaciones realizarías si el puerto `9090` está ocupado?
20. ¿Qué información debe incluir un informe de una incidencia de Prometheus?