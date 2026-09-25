# Servicios y puertos

Esta página explica cómo identificar, comprobar y diagnosticar los servicios y puertos utilizados durante el curso de Grafana, Prometheus y Node Exporter.

Los servicios proporcionan funcionalidades concretas y los puertos permiten que otros procesos o equipos se comuniquen con ellos. En el entorno de laboratorio, la relación principal es:

```text
Node Exporter
    |
    | Puerto 9100
    v
Prometheus
    |
    | Puerto 9090
    v
Grafana
    |
    | Puerto 3000
    v
Navegador web
```

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Identificar los servicios principales del entorno de observabilidad.
- Asociar cada servicio con su puerto habitual.
- Comprobar si un servicio está activo.
- Comprobar si un servicio se inicia automáticamente.
- Identificar los procesos que están escuchando en un puerto.
- Verificar endpoints HTTP con `curl`.
- Diferenciar entre un servicio detenido y un problema de red.
- Consultar los registros de un servicio.
- Diagnosticar problemas de conexión entre Grafana, Prometheus y Node Exporter.
- Documentar las comprobaciones realizadas durante una incidencia.

## Introducción

Un servicio es un proceso que se ejecuta en segundo plano y proporciona una funcionalidad concreta. En Ubuntu, muchos servicios se gestionan mediante `systemd`.

En este curso se utilizan principalmente los siguientes servicios:

| Servicio | Función | Puerto habitual |
|---|---|---:|
| Grafana | Dashboards, paneles y alertas | `3000` |
| Prometheus | Recopilación, almacenamiento y consulta de métricas | `9090` |
| Node Exporter | Exposición de métricas del sistema | `9100` |

El puerto identifica el punto de comunicación utilizado por un servicio. Sin embargo, que un puerto esté abierto no garantiza que la aplicación funcione correctamente. Por eso se deben realizar varias comprobaciones:

1. Comprobar el estado del servicio.
2. Comprobar el proceso asociado.
3. Comprobar el puerto en escucha.
4. Probar el endpoint.
5. Revisar los registros.
6. Verificar la comunicación desde el componente cliente.

## Arquitectura de servicios

### Flujo de comunicación

El flujo habitual del laboratorio es el siguiente:

```text
Node Exporter
  Expone métricas en http://localhost:9100/metrics
              |
              | Prometheus realiza scraping
              v
Prometheus
  Consulta web en http://localhost:9090
              |
              | Grafana consulta datos mediante PromQL
              v
Grafana
  Interfaz web en http://localhost:3000
```

### Función de cada componente

#### Node Exporter

Node Exporter recopila información del sistema operativo y la expone en formato compatible con Prometheus.

Algunas métricas proporcionadas son:

- Uso de CPU.
- Memoria disponible.
- Espacio de almacenamiento.
- Tráfico de red.
- Estado del sistema.
- Número de procesos.
- Tiempo de actividad.

Su endpoint principal es:

```text
http://localhost:9100/metrics
```

#### Prometheus

Prometheus consulta periódicamente los endpoints configurados y almacena las métricas como series temporales.

Sus funciones principales son:

- Realizar scraping.
- Almacenar métricas.
- Ejecutar consultas PromQL.
- Mantener el estado de los targets.
- Evaluar reglas de alerta.

Su interfaz web está disponible normalmente en:

```text
http://localhost:9090
```

#### Grafana

Grafana consulta Prometheus y representa sus datos mediante dashboards y paneles.

Sus funciones principales son:

- Crear dashboards.
- Visualizar series temporales.
- Aplicar variables y filtros.
- Mostrar anotaciones.
- Configurar alertas.
- Enviar notificaciones.

Su interfaz web está disponible normalmente en:

```text
http://localhost:3000
```

## Servicios y puertos del laboratorio

### Tabla de referencia

| Componente | Servicio `systemd` | Puerto | Endpoint principal |
|---|---|---:|---|
| Grafana | `grafana-server` | `3000` | `http://localhost:3000` |
| Prometheus | `prometheus` | `9090` | `http://localhost:9090` |
| Node Exporter | `node_exporter` | `9100` | `http://localhost:9100/metrics` |

### Puertos TCP

Los tres servicios utilizan normalmente puertos TCP:

```text
3000/tcp Grafana
9090/tcp Prometheus
9100/tcp Node Exporter
```

La notación `3000/tcp` significa:

- `3000`: número de puerto.
- `tcp`: protocolo utilizado.

### Puerto local y dirección de escucha

Un servicio puede escuchar en:

```text
127.0.0.1:3000
```

Esto significa que solo acepta conexiones desde el propio equipo.

También puede escuchar en:

```text
0.0.0.0:3000
```

Esto significa que acepta conexiones IPv4 desde las interfaces de red disponibles, siempre que el cortafuegos y la configuración lo permitan.

Otros ejemplos:

```text
127.0.0.1:9090
192.168.1.50:9090
0.0.0.0:9100
[::]:3000
```

## Comprobar el estado de los servicios

### Consultar el estado completo

Para consultar Grafana:

```bash
systemctl status grafana-server
```

Para consultar Prometheus:

```bash
systemctl status prometheus
```

Para consultar Node Exporter:

```bash
systemctl status node_exporter
```

La salida incluye información como:

- Estado actual.
- PID del proceso.
- Fecha de inicio.
- Últimas líneas del registro.
- Ruta de la unidad `systemd`.
- Mensajes de error.

Para salir de la vista de estado, pulsa:

```text
q
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

Otros resultados posibles:

| Resultado | Significado |
|---|---|
| `active` | El servicio está funcionando |
| `inactive` | El servicio está detenido |
| `failed` | El servicio ha fallado |
| `activating` | El servicio se está iniciando |
| `deactivating` | El servicio se está deteniendo |
| `unknown` | No se ha podido determinar el estado |

### Comprobar el inicio automático

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

Otros resultados habituales:

```text
disabled
masked
static
indirect
```

### Comprobar los tres servicios en una sola orden

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

### Crear una tabla de comprobación

```bash
printf "%-20s %-12s %-12s\n" "SERVICIO" "ESTADO" "ARRANQUE"
printf "%-20s %-12s %-12s\n" "grafana-server" \
  "$(systemctl is-active grafana-server)" \
  "$(systemctl is-enabled grafana-server 2>/dev/null || echo desconocido)"
printf "%-20s %-12s %-12s\n" "prometheus" \
  "$(systemctl is-active prometheus)" \
  "$(systemctl is-enabled prometheus 2>/dev/null || echo desconocido)"
printf "%-20s %-12s %-12s\n" "node_exporter" \
  "$(systemctl is-active node_exporter)" \
  "$(systemctl is-enabled node_exporter 2>/dev/null || echo desconocido)"
```

## Gestionar los servicios

### Iniciar un servicio

```bash
sudo systemctl start grafana-server
```

```bash
sudo systemctl start prometheus
```

```bash
sudo systemctl start node_exporter
```

### Detener un servicio

```bash
sudo systemctl stop grafana-server
```

```bash
sudo systemctl stop prometheus
```

```bash
sudo systemctl stop node_exporter
```

> Detén servicios únicamente en el entorno de laboratorio. Prometheus y Grafana dependen de Node Exporter para completar algunas comprobaciones del curso.

### Reiniciar un servicio

```bash
sudo systemctl restart grafana-server
```

```bash
sudo systemctl restart prometheus
```

```bash
sudo systemctl restart node_exporter
```

### Habilitar el inicio automático

```bash
sudo systemctl enable grafana-server
```

```bash
sudo systemctl enable prometheus
```

```bash
sudo systemctl enable node_exporter
```

### Habilitar e iniciar simultáneamente

```bash
sudo systemctl enable --now grafana-server
```

```bash
sudo systemctl enable --now prometheus
```

```bash
sudo systemctl enable --now node_exporter
```

### Deshabilitar el inicio automático

```bash
sudo systemctl disable grafana-server
```

```bash
sudo systemctl disable prometheus
```

```bash
sudo systemctl disable node_exporter
```

### Recargar unidades de `systemd`

Después de crear o modificar una unidad:

```bash
sudo systemctl daemon-reload
```

Si la unidad se ha modificado y el servicio debe aplicar la nueva configuración:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

## Comprobar los puertos en escucha

### Utilizar `ss`

`ss` muestra sockets, puertos y conexiones de red.

Mostrar todos los puertos TCP en escucha:

```bash
sudo ss -lntp
```

Las opciones significan:

| Opción | Significado |
|---|---|
| `-l` | Mostrar sockets en escucha |
| `-n` | Mostrar números sin resolver nombres |
| `-t` | Mostrar TCP |
| `-p` | Mostrar el proceso asociado |

### Filtrar los puertos del laboratorio

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

Una salida posible:

```text
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1234,fd=8))
LISTEN 0 4096 127.0.0.1:9090 0.0.0.0:* users:(("prometheus",pid=1456,fd=7))
LISTEN 0 4096 0.0.0.0:9100 0.0.0.0:* users:(("node_exporter",pid=1678,fd=3))
```

### Comprobar un puerto concreto

Puerto de Grafana:

```bash
sudo ss -lntp | grep ':3000'
```

Puerto de Prometheus:

```bash
sudo ss -lntp | grep ':9090'
```

Puerto de Node Exporter:

```bash
sudo ss -lntp | grep ':9100'
```

Si el comando no muestra ninguna línea, no hay ningún proceso escuchando en ese puerto.

### Consultar el proceso asociado

```bash
sudo ss -lntp 'sport = :3000'
```

```bash
sudo ss -lntp 'sport = :9090'
```

```bash
sudo ss -lntp 'sport = :9100'
```

### Utilizar `lsof`

Si está instalado:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

```bash
sudo lsof -iTCP:9090 -sTCP:LISTEN
```

```bash
sudo lsof -iTCP:9100 -sTCP:LISTEN
```

Si no está instalado:

```bash
sudo apt update
sudo apt install lsof
```

### Utilizar `fuser`

```bash
sudo fuser -v 3000/tcp
```

```bash
sudo fuser -v 9090/tcp
```

```bash
sudo fuser -v 9100/tcp
```

## Comprobar endpoints HTTP

Un puerto puede estar en escucha y, aun así, la aplicación puede devolver errores. Por eso es importante probar el endpoint.

### Comprobar Grafana

```bash
curl -I http://localhost:3000
```

También puedes obtener la respuesta completa:

```bash
curl -s http://localhost:3000 | head
```

Una respuesta HTTP habitual puede ser:

```text
HTTP/1.1 302 Found
```

o:

```text
HTTP/1.1 200 OK
```

Un código `302` no implica necesariamente un problema. Grafana puede redirigir a la página de inicio de sesión.

### Comprobar Prometheus

```bash
curl -I http://localhost:9090
```

Comprobar la página de salud:

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

### Comprobar Node Exporter

```bash
curl -I http://localhost:9100/metrics
```

Mostrar las primeras líneas:

```bash
curl -s http://localhost:9100/metrics | head
```

Una salida correcta contiene líneas similares a:

```text
# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
# TYPE node_cpu_seconds_total counter
```

### Comprobar códigos HTTP

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9090
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9100/metrics
```

### Comprobar tiempos de respuesta

```bash
curl -s -o /dev/null \
  -w "Código: %{http_code}\nTiempo total: %{time_total}s\n" \
  http://localhost:9100/metrics
```

### Probar todos los endpoints

```bash
for url in \
  http://localhost:3000 \
  http://localhost:9090 \
  http://localhost:9100/metrics
do
  echo "===== $url ====="
  curl -s -o /dev/null \
    -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
    --max-time 5 "$url"
  echo
done
```

## Interpretar errores de conexión

### `Connection refused`

Ejemplo:

```text
curl: (7) Failed to connect to localhost port 9100: Connection refused
```

Causas habituales:

- El servicio está detenido.
- El proceso ha fallado.
- No hay ningún proceso escuchando en el puerto.
- El servicio está configurado en otro puerto.

Comprobaciones:

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

### `Connection timed out`

Causas habituales:

- Un cortafuegos bloquea la conexión.
- La dirección IP no es accesible.
- El servicio está en otro equipo.
- Existe un problema de red.
- El servicio solo escucha en `localhost`.

Comprobaciones:

```bash
ip addr
```

```bash
ip route
```

```bash
sudo ufw status verbose
```

### `HTTP 404 Not Found`

El servicio responde, pero la ruta solicitada no existe.

Por ejemplo:

```bash
curl -I http://localhost:9100
```

Node Exporter puede no ofrecer contenido en `/`, pero sí en:

```bash
curl -I http://localhost:9100/metrics
```

### `HTTP 500 Internal Server Error`

La aplicación ha recibido la petición, pero ha encontrado un error interno.

Comprobaciones:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

```bash
sudo journalctl -u prometheus -n 100 --no-pager
```

### `Empty reply from server`

El proceso acepta la conexión, pero cierra la comunicación sin enviar una respuesta válida.

Posibles causas:

- El proceso está fallando.
- El protocolo utilizado no es el esperado.
- La aplicación está reiniciándose.
- La configuración contiene un problema.

## Consultar los registros

### Registros de Grafana

Últimas 50 líneas:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

Seguir los registros en tiempo real:

```bash
sudo journalctl -u grafana-server -f
```

Consultar los registros desde el último arranque:

```bash
sudo journalctl -u grafana-server -b
```

### Registros de Prometheus

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

```bash
sudo journalctl -u prometheus -f
```

### Registros de Node Exporter

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

```bash
sudo journalctl -u node_exporter -f
```

### Consultar errores recientes

```bash
sudo journalctl -p err -b
```

### Consultar registros de los últimos minutos

```bash
sudo journalctl -u prometheus --since "10 minutes ago"
```

```bash
sudo journalctl -u node_exporter --since "30 minutes ago"
```

## Comprobar la configuración de Prometheus

### Localizar el fichero de configuración

```bash
sudo find /etc -type f -name "prometheus.yml"
```

La ruta habitual es:

```text
/etc/prometheus/prometheus.yml
```

### Validar la configuración

Si `promtool` está instalado:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
Checking /etc/prometheus/prometheus.yml
 SUCCESS: 0 rule files found
```

### Consultar los trabajos configurados

```bash
sudo grep -n "job_name" /etc/prometheus/prometheus.yml
```

### Buscar Node Exporter

```bash
sudo grep -n -i "node_exporter" /etc/prometheus/prometheus.yml
```

### Reiniciar Prometheus después de modificar la configuración

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Después comprueba:

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

## Comprobar los targets de Prometheus

### Consultar la API de targets

```bash
curl -s http://localhost:9090/api/v1/targets
```

Si `jq` está instalado:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

### Mostrar solo los estados

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq '.data.activeTargets[] | {
      job: .labels.job,
      instance: .labels.instance,
      health: .health,
      lastError: .lastError
    }'
```

### Interpretar los estados

| Estado | Significado |
|---|---|
| `up` | Prometheus puede consultar el target |
| `down` | Prometheus no puede consultar el target |
| `unknown` | No existe información suficiente |

### Comprobar mediante PromQL

En la interfaz web de Prometheus, ejecuta:

```promql
up
```

Para consultar Node Exporter:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

El valor `0` indica que el target no está disponible para Prometheus.

## Comprobar la comunicación entre componentes

### Prometheus hacia Node Exporter

Desde el equipo donde se ejecuta Prometheus:

```bash
curl -I http://localhost:9100/metrics
```

Si Node Exporter está en otro equipo:

```bash
curl -I http://DIRECCION_IP_NODE_EXPORTER:9100/metrics
```

### Grafana hacia Prometheus

Desde el equipo donde se ejecuta Grafana:

```bash
curl http://localhost:9090/-/healthy
```

Si Prometheus está en otro equipo:

```bash
curl http://DIRECCION_IP_PROMETHEUS:9090/-/healthy
```

### Navegador hacia Grafana

Desde el navegador:

```text
http://localhost:3000
```

Si Grafana está en un equipo remoto:

```text
http://DIRECCION_IP_GRAFANA:3000
```

## Firewall con UFW

### Consultar el estado del firewall

```bash
sudo ufw status verbose
```

Posibles resultados:

```text
Status: inactive
```

o:

```text
Status: active
```

### Mostrar las reglas numeradas

```bash
sudo ufw status numbered
```

### Permitir Grafana desde una red concreta

Ejemplo para una red de laboratorio:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
```

### Permitir Prometheus desde una red concreta

```bash
sudo ufw allow from 192.168.1.0/24 to any port 9090 proto tcp
```

### Permitir Node Exporter desde una red concreta

```bash
sudo ufw allow from 192.168.1.0/24 to any port 9100 proto tcp
```

> Es preferible limitar el acceso a una red o a una dirección IP concreta en lugar de abrir los puertos a Internet.

### Eliminar una regla

Primero consulta las reglas:

```bash
sudo ufw status numbered
```

Después elimina la regla utilizando su número:

```bash
sudo ufw delete NUMERO
```

## Sesión práctica 1: inventario de servicios y puertos

En esta sesión se elaborará un inventario del entorno de laboratorio.

### Objetivo

Identificar:

- Los servicios instalados.
- El estado de cada servicio.
- El inicio automático.
- Los puertos en escucha.
- Los procesos asociados.

### Preparación

Crear el directorio de trabajo:

```bash
mkdir -p ~/laboratorio/servicios-puertos
cd ~/laboratorio/servicios-puertos
```

### Comprobar los servicios

```bash
for service in grafana-server prometheus node_exporter; do
  echo "===== $service ====="
  systemctl is-active "$service"
  systemctl is-enabled "$service" 2>/dev/null || true
  echo
done
```

### Comprobar los puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b' \
  | tee puertos-en-escucha.txt
```

### Crear un inventario

```bash
{
  echo "INVENTARIO DE SERVICIOS Y PUERTOS"
  echo "Fecha: $(date)"
  echo
  echo "===== GRAFANA ====="
  echo "Servicio: grafana-server"
  echo "Puerto: 3000"
  echo -n "Estado: "
  systemctl is-active grafana-server
  echo -n "Inicio automático: "
  systemctl is-enabled grafana-server 2>/dev/null || true
  echo
  echo "===== PROMETHEUS ====="
  echo "Servicio: prometheus"
  echo "Puerto: 9090"
  echo -n "Estado: "
  systemctl is-active prometheus
  echo -n "Inicio automático: "
  systemctl is-enabled prometheus 2>/dev/null || true
  echo
  echo "===== NODE EXPORTER ====="
  echo "Servicio: node_exporter"
  echo "Puerto: 9100"
  echo -n "Estado: "
  systemctl is-active node_exporter
  echo -n "Inicio automático: "
  systemctl is-enabled node_exporter 2>/dev/null || true
  echo
  echo "===== PUERTOS ====="
  sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true
} | tee inventario-servicios.txt
```

### Resultado esperado

El inventario debe indicar:

```text
grafana-server: active
prometheus: active
node_exporter: active
```

Y deben aparecer los puertos:

```text
3000
9090
9100
```

### Evidencias

Conserva:

```text
inventario-servicios.txt
puertos-en-escucha.txt
```

También puedes incluir una captura de:

```bash
systemctl status prometheus
```

## Sesión práctica 2: comprobar los endpoints

En esta sesión se probarán los endpoints HTTP de los tres componentes.

### Objetivo

Comprobar que:

- Grafana responde.
- Prometheus responde.
- Prometheus está saludable.
- Node Exporter expone métricas.
- Los códigos HTTP son coherentes.

### Ejecutar las pruebas

```bash
for url in \
  http://localhost:3000 \
  http://localhost:9090 \
  http://localhost:9090/-/healthy \
  http://localhost:9100/metrics
do
  echo "===== $url ====="
  curl -s -o /dev/null \
    -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
    --max-time 5 "$url"
  echo
done
```

### Comprobar el contenido de Node Exporter

```bash
curl -s http://localhost:9100/metrics | head -20
```

### Buscar métricas de CPU

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_cpu_seconds_total" \
  | head
```

### Guardar los resultados

```bash
{
  echo "PRUEBA DE ENDPOINTS"
  echo "Fecha: $(date)"
  echo
  for url in \
    http://localhost:3000 \
    http://localhost:9090 \
    http://localhost:9090/-/healthy \
    http://localhost:9100/metrics
  do
    echo "===== $url ====="
    curl -s -o /dev/null \
      -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
      --max-time 5 "$url" || true
    echo
  done
} | tee pruebas-endpoints.txt
```

### Preguntas de análisis

- ¿Qué código HTTP devuelve Grafana?
- ¿Qué código HTTP devuelve Prometheus?
- ¿Qué texto aparece en el endpoint de salud de Prometheus?
- ¿Qué código HTTP devuelve Node Exporter?
- ¿Qué ocurre si se consulta Node Exporter sin `/metrics`?

## Sesión práctica 3: detener y recuperar Node Exporter

Esta actividad simula una incidencia controlada.

> Realiza la actividad únicamente en el entorno de laboratorio.

### Objetivo

Comprobar cómo cambia el estado de un servicio cuando se detiene y se vuelve a iniciar.

### Registrar el estado inicial

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -s -o /dev/null \
  -w "%{http_code}\n" \
  http://localhost:9100/metrics
```

### Detener Node Exporter

```bash
sudo systemctl stop node_exporter
```

### Comprobar el estado después de detenerlo

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
Connection refused
```

### Consultar los registros

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

### Iniciar de nuevo el servicio

```bash
sudo systemctl start node_exporter
```

### Verificar la recuperación

```bash
systemctl is-active node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -I http://localhost:9100/metrics
```

### Verificar desde Prometheus

Ejecuta en Prometheus:

```promql
up{job="node_exporter"}
```

Resultado esperado:

```text
1
```

### Preguntas de análisis

- ¿Qué resultado devolvió `systemctl is-active` después de detener el servicio?
- ¿Qué ocurrió con el puerto `9100`?
- ¿Qué error devolvió `curl`?
- ¿Qué comando permitió recuperar el servicio?
- ¿Cuánto tiempo tardó Prometheus en volver a mostrar el target como disponible?

## Sesión práctica 4: diagnosticar un puerto ocupado

En esta actividad se analizará qué ocurre cuando dos procesos intentan utilizar el mismo puerto.

### Objetivo

Aprender a:

- Identificar el proceso que ocupa un puerto.
- Consultar el PID.
- Consultar el servicio asociado.
- Evitar conflictos de puertos.

### Consultar el puerto de Grafana

```bash
sudo ss -lntp | grep ':3000'
```

### Identificar el PID

En la salida busca una sección similar a:

```text
pid=1234
```

Consultar información del proceso:

```bash
ps -fp 1234
```

Sustituye `1234` por el PID real.

### Utilizar `lsof`

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Consultar la unidad del servicio

```bash
systemctl status grafana-server
```

### Diagnosticar un fallo de arranque

Si Grafana no puede iniciar porque el puerto está ocupado:

```bash
sudo systemctl status grafana-server
```

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

Busca mensajes como:

```text
address already in use
```

o:

```text
bind: address already in use
```

### Preguntas de análisis

- ¿Qué proceso ocupa el puerto?
- ¿Cuál es su PID?
- ¿Qué servicio lo ha iniciado?
- ¿La aplicación escucha en `127.0.0.1`, `0.0.0.0` o en otra dirección?
- ¿Qué solución aplicarías para evitar el conflicto?

## Sesión práctica 5: comprobar la comunicación completa

En esta sesión se verificará el flujo completo del entorno.

### Objetivo

Validar la cadena:

```text
Node Exporter → Prometheus → Grafana
```

### Comprobar Node Exporter

```bash
systemctl is-active node_exporter
```

```bash
curl -s http://localhost:9100/metrics | head
```

### Comprobar Prometheus

```bash
systemctl is-active prometheus
```

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar los targets

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

### Ejecutar una consulta PromQL

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Comprobar Grafana

```bash
systemctl is-active grafana-server
```

```bash
curl -I http://localhost:3000
```

### Validar la fuente de datos desde Grafana

En la interfaz de Grafana:

1. Accede a **Connections**.
2. Abre **Data sources**.
3. Selecciona Prometheus.
4. Comprueba la URL configurada.
5. Pulsa **Save & test**.
6. Verifica que la conexión sea correcta.

### Tabla de resultados

| Comprobación | Resultado esperado |
|---|---|
| Servicio Node Exporter | `active` |
| Endpoint `/metrics` | Responde |
| Servicio Prometheus | `active` |
| Salud de Prometheus | `Prometheus is Healthy.` |
| Target de Node Exporter | `UP` |
| Servicio Grafana | `active` |
| Interfaz de Grafana | Responde |
| Fuente de datos | Conexión correcta |

## Sesión práctica 6: generar un informe técnico

### Objetivo

Crear un informe con el estado de servicios, puertos y endpoints.

### Crear el directorio de trabajo

```bash
mkdir -p ~/laboratorio/servicios-puertos
cd ~/laboratorio/servicios-puertos
```

### Generar el informe

```bash
{
  echo "===== INFORME DE SERVICIOS Y PUERTOS ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== SERVICIOS ====="
  for service in grafana-server prometheus node_exporter; do
    echo "--- $service ---"
    echo -n "Estado: "
    systemctl is-active "$service" 2>/dev/null || true
    echo -n "Inicio automático: "
    systemctl is-enabled "$service" 2>/dev/null || true
    echo
  done

  echo "===== PUERTOS ====="
  sudo ss -lntp | grep -E ':(3000|9090|9100)\b' || true
  echo

  echo "===== ENDPOINTS ====="
  for url in \
    http://localhost:3000 \
    http://localhost:9090 \
    http://localhost:9090/-/healthy \
    http://localhost:9100/metrics
  do
    echo "--- $url ---"
    curl -s -o /dev/null \
      -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
      --max-time 5 "$url" || true
  done

  echo
  echo "===== TARGETS DE PROMETHEUS ====="
  curl -s http://localhost:9090/api/v1/targets || true
} | tee informe-servicios-puertos.txt
```

### Revisar el informe

```bash
less informe-servicios-puertos.txt
```

### Comprobar que el fichero existe

```bash
test -f informe-servicios-puertos.txt \
  && echo "Informe creado correctamente"
```

### Evidencias

Incluye en la entrega:

- `informe-servicios-puertos.txt`.
- Captura de los servicios activos.
- Captura de los puertos en escucha.
- Captura de la página de targets de Prometheus.
- Captura de la fuente de datos validada en Grafana.

## Resolución de problemas

### El servicio está activo, pero el puerto no aparece

Comprueba:

```bash
systemctl status nombre-del-servicio
```

```bash
sudo ss -lntp
```

```bash
sudo journalctl -u nombre-del-servicio -n 100 --no-pager
```

Posibles causas:

- El servicio utiliza otro puerto.
- La configuración no se ha aplicado.
- El proceso está activo, pero ha iniciado parcialmente.
- El servicio se ha iniciado y ha fallado después.
- Se está utilizando una unidad distinta.

### El puerto aparece, pero `curl` falla

Comprueba:

```bash
curl -v http://localhost:PUERTO
```

Consulta la dirección de escucha:

```bash
sudo ss -lntp | grep ':PUERTO'
```

Posibles causas:

- La ruta HTTP no es correcta.
- El protocolo no es HTTP.
- La aplicación requiere autenticación.
- El servicio responde en otra interfaz.
- Existe una configuración de proxy.

### `localhost` funciona, pero la IP del equipo no

Comprueba la dirección de escucha:

```bash
sudo ss -lntp | grep ':3000'
```

Si aparece:

```text
127.0.0.1:3000
```

el servicio solo acepta conexiones locales.

Si necesitas acceso desde otro equipo, revisa la configuración de escucha del servicio y las reglas del firewall. No expongas servicios innecesariamente a redes no autorizadas.

### Prometheus muestra un target como `DOWN`

Comprueba:

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

Después revisa:

```bash
systemctl is-active node_exporter
```

```bash
curl -I http://localhost:9100/metrics
```

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

Revisa también el fichero:

```bash
sudo less /etc/prometheus/prometheus.yml
```

### Grafana no conecta con Prometheus

Comprueba desde el equipo donde se ejecuta Grafana:

```bash
curl http://localhost:9090/-/healthy
```

Después revisa:

```bash
systemctl is-active grafana-server
```

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

Comprueba que la URL de la fuente de datos sea correcta. En un entorno local puede ser:

```text
http://localhost:9090
```

Si Grafana y Prometheus están en equipos distintos, `localhost` no debe utilizarse para referirse al otro equipo.

## Registro de una incidencia

Utiliza esta plantilla para documentar un problema:

```text
Fecha:

Alumno:

Equipo:

Componente afectado:

Servicio:

Puerto:

Síntoma:

Comando utilizado:

Resultado inicial:

Mensaje de error:

Causa identificada:

Corrección aplicada:

Resultado posterior:

Evidencias:

Observaciones:
```

### Ejemplo de incidencia

```text
Fecha:
2026-09-25

Alumno:
Nombre del alumno

Equipo:
laboratorio

Componente afectado:
Node Exporter

Servicio:
node_exporter

Puerto:
9100

Síntoma:
Prometheus muestra el target como DOWN.

Comando utilizado:
curl -I http://localhost:9100/metrics

Resultado inicial:
Connection refused

Causa identificada:
El servicio node_exporter estaba detenido.

Corrección aplicada:
sudo systemctl start node_exporter

Resultado posterior:
El endpoint responde y Prometheus muestra el target como UP.

Evidencias:
captura-target-up.png
informe-servicios-puertos.txt
```

## Buenas prácticas

- Comprueba el estado del servicio antes de reiniciarlo.
- Revisa los registros antes de modificar la configuración.
- Comprueba el puerto que utiliza realmente la aplicación.
- Utiliza `curl` para comprobar el endpoint desde el propio equipo.
- No confundas un puerto abierto con una aplicación correctamente configurada.
- No abras puertos a Internet sin una justificación.
- Limita las reglas del firewall a las redes necesarias.
- Usa `sudo` solo cuando sea necesario.
- Documenta las modificaciones temporales.
- Vuelve a dejar el entorno en su estado inicial después de una prueba.
- Comprueba la comunicación desde el equipo cliente, no solo desde el servidor.
- Guarda evidencias reproducibles de las incidencias.

## Puntos clave

- Grafana utiliza normalmente el puerto `3000`.
- Prometheus utiliza normalmente el puerto `9090`.
- Node Exporter utiliza normalmente el puerto `9100`.
- `systemctl` permite consultar y gestionar servicios.
- `systemctl is-active` comprueba si un servicio está activo.
- `systemctl is-enabled` comprueba si se inicia automáticamente.
- `ss -lntp` muestra los puertos TCP en escucha y sus procesos.
- `curl` permite comprobar endpoints HTTP.
- `journalctl` permite consultar los registros de `systemd`.
- Un servicio activo no siempre implica que el endpoint responda correctamente.
- Un puerto en escucha no siempre significa que la aplicación esté bien configurada.
- `localhost` hace referencia al equipo desde el que se ejecuta el comando.
- Prometheus debe poder acceder al endpoint de Node Exporter.
- Grafana debe poder acceder al endpoint de Prometheus.
- La comprobación debe realizarse siguiendo el flujo `Node Exporter → Prometheus → Grafana`.

## Preguntas de comprobación

1. ¿Qué función cumple un servicio en Ubuntu?
2. ¿Qué puerto utiliza normalmente Grafana?
3. ¿Qué puerto utiliza normalmente Prometheus?
4. ¿Qué puerto utiliza normalmente Node Exporter?
5. ¿Qué comando permite consultar el estado completo de un servicio?
6. ¿Qué diferencia existe entre `systemctl is-active` y `systemctl is-enabled`?
7. ¿Qué comando permite mostrar los puertos TCP en escucha?
8. ¿Qué significa que un puerto esté asociado a `127.0.0.1`?
9. ¿Qué significa que un servicio escuche en `0.0.0.0`?
10. ¿Qué comando permite comprobar el endpoint de métricas de Node Exporter?
11. ¿Qué respuesta se espera de `http://localhost:9090/-/healthy`?
12. ¿Qué significa el error `Connection refused`?
13. ¿Qué causas pueden producir un `Connection timed out`?
14. ¿Qué comando permite consultar los registros de Prometheus?
15. ¿Qué comando permite identificar el proceso que utiliza el puerto `3000`?
16. ¿Qué diferencia existe entre consultar un servicio localmente y hacerlo desde otro equipo?
17. ¿Qué significa que el target de Node Exporter aparezca como `DOWN`?
18. ¿Qué comprobaciones realizarías si Grafana no conecta con Prometheus?
19. ¿Por qué no es recomendable abrir los puertos `3000`, `9090` y `9100` a Internet?
20. ¿Qué información debe incluir el registro de una incidencia?