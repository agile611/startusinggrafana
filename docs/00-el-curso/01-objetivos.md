# Objetivos del curso

Este curso presenta un recorrido práctico por los fundamentos de la observabilidad y la monitorización utilizando **Grafana**, **Prometheus** y **Node Exporter** sobre Ubuntu.

El objetivo no es únicamente aprender a instalar herramientas. También se pretende comprender cómo se recopilan, almacenan, consultan y visualizan las métricas de un sistema.

---

## Objetivos

Al finalizar el curso, el alumno podrá:

- Comprender los conceptos fundamentales de telemetría y observabilidad.
- Diferenciar métricas, logs, trazas y eventos.
- Explicar las diferencias entre los modelos de recopilación *push* y *pull*.
- Identificar los componentes principales de una plataforma de monitorización.
- Instalar y configurar Grafana en Ubuntu.
- Instalar y configurar Prometheus.
- Instalar Node Exporter para recopilar métricas del sistema.
- Comprobar el estado de los servicios mediante `systemctl`.
- Consultar endpoints HTTP de métricas.
- Utilizar consultas básicas de PromQL.
- Añadir Prometheus como fuente de datos en Grafana.
- Crear dashboards con diferentes tipos de paneles.
- Utilizar paneles de series temporales, estadísticas y medidores.
- Configurar rangos de tiempo y desplazamientos temporales.
- Aplicar transformaciones sobre los datos.
- Crear alertas basadas en métricas.
- Diagnosticar problemas habituales de instalación, conectividad y consultas.
- Diseñar un dashboard operativo básico para supervisar un servidor Linux.

---

## Introducción

La monitorización permite conocer el estado de un sistema y detectar cambios antes de que se conviertan en problemas graves.

Un sistema puede funcionar correctamente durante una gran parte del tiempo y, aun así, presentar señales de degradación:

- El uso de CPU puede aumentar progresivamente.
- La memoria disponible puede disminuir.
- El almacenamiento puede acercarse a su límite.
- Un servicio puede dejar de responder.
- La latencia de una aplicación puede incrementarse.
- El número de errores puede crecer después de un despliegue.

La observabilidad ayuda a responder preguntas como:

- ¿Qué está ocurriendo en el sistema?
- ¿Desde cuándo ocurre?
- ¿Qué componentes están afectados?
- ¿El problema es puntual o recurrente?
- ¿Qué comportamiento tenía el sistema antes del incidente?
- ¿Cómo podemos comprobar que la solución ha funcionado?

Durante el curso se construirá progresivamente una plataforma sencilla de observabilidad:

```text
Sistema Linux
     |
     v
Node Exporter
     |
     v
Prometheus
     |
     v
Grafana
     |
     v
Dashboards y alertas
```

### Función de cada componente

| Componente | Función |
|---|---|
| Node Exporter | Expone métricas del sistema operativo |
| Prometheus | Recopila y almacena series temporales |
| PromQL | Lenguaje para consultar métricas en Prometheus |
| Grafana | Visualiza los datos mediante dashboards |
| Alertas | Notifican situaciones que requieren atención |

---

## Contenido

El curso está organizado en varios bloques relacionados.

### 1. Fundamentos de telemetría

En este bloque se estudian los conceptos esenciales:

- Telemetría.
- Observabilidad.
- Métricas.
- Logs.
- Trazas.
- Eventos.
- Series temporales.
- Etiquetas.
- Frecuencia de muestreo.
- Retención de datos.
- *Downsampling*.
- Modelos *push* y *pull*.

El alumno aprenderá a reconocer qué tipo de información proporciona cada señal de observabilidad y cuándo resulta más útil.

### 2. Grafana

En este bloque se introduce Grafana:

- Requisitos del sistema.
- Instalación en Ubuntu.
- Acceso a la interfaz web.
- Configuración inicial.
- Fuentes de datos.
- Selector de rango temporal.
- Tiempo relativo.
- Desplazamiento temporal.
- Dashboards.
- Filas.
- Paneles.

### 3. Prometheus y fuentes de datos

Este bloque presenta Prometheus y su arquitectura:

- Componentes principales.
- Instalación del servicio.
- Fichero de configuración.
- Objetivos de *scraping*.
- Interfaz web.
- Métricas disponibles.
- Instalación de Node Exporter.
- Configuración de Prometheus.
- Consultas PromQL.
- Integración con Grafana.

### 4. Dashboards y visualización

En este bloque se crean dashboards para representar información de forma clara:

- Panel Time series.
- Panel Stat.
- Panel Gauge.
- Panel Bar gauge.
- Panel Heatmap.
- Panel de texto.
- Panel Canvas.
- Transformaciones.
- Organización de paneles.
- Listas de dashboards.
- Dashboards operativos.

### 5. Anotaciones y alertas

Este bloque introduce la detección automática de situaciones anómalas:

- Anotaciones.
- Reglas de alerta.
- Expresiones.
- Condiciones.
- Contactos de notificación.
- Políticas de notificación.
- Silenciados.
- Correo electrónico.
- Resolución de alertas.

### 6. Proyecto final

Como actividad final, el alumno diseñará un dashboard operativo para supervisar un servidor Linux.

El dashboard deberá incluir, como mínimo:

- Uso de CPU.
- Memoria disponible.
- Espacio utilizado.
- Tráfico de red.
- Estado de un servicio.
- Una alerta operativa.
- Un rango temporal adecuado.
- Títulos y unidades correctamente configurados.

---

## Ejemplo

### Ejemplo 1: recorrido de una métrica

La métrica de uso de CPU atraviesa varias etapas:

```text
CPU del sistema
      |
      v
Node Exporter recopila información
      |
      v
Prometheus realiza el scraping
      |
      v
Prometheus almacena muestras
      |
      v
Grafana ejecuta una consulta PromQL
      |
      v
Un panel representa la información
```

Una consulta habitual para calcular el porcentaje aproximado de CPU utilizada es:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Esta consulta:

1. Calcula la velocidad de cambio de la métrica de CPU en los últimos 5 minutos.
2. Selecciona el modo `idle`.
3. Calcula la media por instancia.
4. Convierte el tiempo libre en porcentaje.
5. Resta el resultado a `100` para obtener el porcentaje utilizado.

### Ejemplo 2: consulta de memoria disponible

Una consulta básica para conocer el porcentaje de memoria disponible es:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Para obtener el porcentaje utilizado:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Ejemplo 3: espacio utilizado en disco

La siguiente consulta calcula el porcentaje utilizado en cada sistema de ficheros:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint="/"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint="/"
  }
)
```

La etiqueta `mountpoint="/"` limita la consulta al sistema de ficheros raíz.

---

# Sesiones prácticas

Las siguientes sesiones están diseñadas para realizarse progresivamente durante el curso.

---

## Sesión 1: comprobar el entorno de trabajo

### Objetivo

Verificar que Ubuntu está disponible y que el alumno puede ejecutar comandos básicos.

### Comandos

Comprobar la versión del sistema:

```bash
lsb_release -a
```

Consultar la versión del kernel:

```bash
uname -a
```

Consultar el nombre del equipo:

```bash
hostname
```

Consultar la fecha y la hora:

```bash
date
```

Comprobar el uso general del sistema:

```bash
uptime
```

Consultar el espacio disponible:

```bash
df -h
```

Consultar la memoria:

```bash
free -h
```

### Ejemplo de sesión

```console
$ hostname
monitoring-01

$ uptime
 10:32:18 up 2 days, 4:15, 1 user, load average: 0.12, 0.18, 0.20

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.2Gi       640Mi        12Mi       2.0Gi       2.3Gi

$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        40G   12G   26G  32% /
```

### Actividades

1. Anota el nombre del equipo.
2. Anota la cantidad total de memoria.
3. Anota el porcentaje utilizado del sistema de ficheros raíz.
4. Comprueba si la carga del sistema parece elevada.
5. Explica qué diferencia existe entre memoria libre y memoria disponible.

---

## Sesión 2: comprobar la sincronización horaria

### Objetivo

Comprobar que el sistema tiene la hora sincronizada. Las marcas de tiempo son esenciales para interpretar correctamente las métricas.

Consultar el estado de la sincronización:

```bash
timedatectl status
```

Consultar los servidores NTP utilizados:

```bash
timedatectl show-timesync --all
```

Comprobar la hora actual en formato UTC:

```bash
date -u
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
          RTC in local TZ: no
```

### Actividades

1. Comprueba si el reloj está sincronizado.
2. Identifica la zona horaria configurada.
3. Explica por qué Grafana y Prometheus deben tener una hora coherente.
4. Describe qué problemas podría producir una diferencia de varios minutos.

---

## Sesión 3: instalación y comprobación de Grafana

### Objetivo

Instalar Grafana y comprobar que el servicio está operativo.

Actualizar la información de paquetes:

```bash
sudo apt update
```

Instalar paquetes auxiliares:

```bash
sudo apt install -y apt-transport-https wget gnupg
```

Añadir la clave del repositorio de Grafana:

```bash
sudo mkdir -p /etc/apt/keyrings

wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

Añadir el repositorio:

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
```

Actualizar los repositorios:

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

Comprobar su estado:

```bash
systemctl status grafana-server
```

Comprobar el puerto de escucha:

```bash
sudo ss -lntp | grep 3000
```

Probar la respuesta HTTP:

```bash
curl -I http://localhost:3000
```

### Ejemplo de sesión

```console
$ systemctl is-active grafana-server
active

$ systemctl is-enabled grafana-server
enabled

$ sudo ss -lntp | grep 3000
LISTEN 0  4096  0.0.0.0:3000  0.0.0.0:*  users:(("grafana",pid=1234,fd=9))
```

### Actividades

1. Comprueba que Grafana está activo.
2. Comprueba que arranca automáticamente.
3. Verifica que escucha en el puerto `3000`.
4. Accede desde el navegador a:

```text
http://localhost:3000
```

5. Consulta los registros del servicio:

```bash
sudo journalctl -u grafana-server --no-pager -n 30
```

---

## Sesión 4: instalación y comprobación de Node Exporter

### Objetivo

Instalar Node Exporter y comprobar que expone métricas del sistema.

Crear un usuario de sistema:

```bash
sudo useradd \
  --no-create-home \
  --shell /usr/sbin/nologin \
  node_exporter
```

Descargar Node Exporter:

```bash
cd /tmp

wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-linux-amd64.tar.gz
```

Extraer el archivo:

```bash
tar xvf node_exporter-linux-amd64.tar.gz
```

Copiar el binario:

```bash
sudo cp node_exporter-*/node_exporter /usr/local/bin/
```

Asignar permisos:

```bash
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```

Crear el servicio systemd:

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

Activar e iniciar el servicio:

```bash
sudo systemctl enable --now node_exporter
```

Comprobar el servicio:

```bash
systemctl status node_exporter
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep 9100
```

Consultar el endpoint de métricas:

```bash
curl http://localhost:9100/metrics
```

Filtrar métricas de CPU:

```bash
curl -s http://localhost:9100/metrics | grep '^node_cpu_seconds_total' | head
```

Filtrar métricas de memoria:

```bash
curl -s http://localhost:9100/metrics | grep '^node_memory_' | head
```

### Ejemplo de sesión

```console
$ systemctl is-active node_exporter
active

$ curl -s http://localhost:9100/metrics | grep '^node_memory_MemTotal_bytes'
node_memory_MemTotal_bytes 4.10437632e+09

$ curl -s http://localhost:9100/metrics | grep '^node_filesystem_size_bytes' | head -1
node_filesystem_size_bytes{device="/dev/sda2",fstype="ext4",mountpoint="/"} 4.294967296e+10
```

### Actividades

1. Comprueba que Node Exporter está activo.
2. Consulta cinco métricas diferentes.
3. Identifica las etiquetas de una métrica de sistema de ficheros.
4. Explica qué representa la métrica `node_memory_MemTotal_bytes`.
5. Explica por qué el endpoint `/metrics` es importante.

---

## Sesión 5: configurar Prometheus para recopilar métricas

### Objetivo

Configurar Prometheus para que realice *scraping* de Node Exporter.

Editar el fichero de configuración:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Añadir o comprobar la siguiente configuración:

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

Comprobar la sintaxis YAML y reiniciar Prometheus:

```bash
sudo systemctl restart prometheus
```

Comprobar el estado:

```bash
systemctl status prometheus
```

Consultar los objetivos desde la API:

```bash
curl -s http://localhost:9090/api/v1/targets
```

Comprobar que Prometheus responde:

```bash
curl -I http://localhost:9090
```

### Ejemplo de configuración con etiquetas

```yaml
scrape_configs:
  - job_name: node_exporter
    static_configs:
      - targets:
          - localhost:9100
        labels:
          environment: laboratorio
          role: servidor
```

Estas etiquetas permiten clasificar las métricas y filtrarlas posteriormente mediante PromQL.

### Actividades

1. Añade Node Exporter como objetivo de scraping.
2. Reinicia Prometheus.
3. Comprueba que el objetivo aparece como `UP`.
4. Consulta la métrica `up`.
5. Explica la diferencia entre los valores `1` y `0`.

Consulta:

```promql
up
```

Resultado esperado:

```text
up{instance="localhost:9090",job="prometheus"} 1
up{instance="localhost:9100",job="node_exporter"} 1
```

---

## Sesión 6: primeras consultas PromQL

### Objetivo

Consultar métricas básicas desde Prometheus.

### Comprobar objetivos disponibles

```promql
up
```

### Consultar el tiempo de actividad del sistema

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

### Calcular el uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Calcular el uso de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Calcular el espacio utilizado

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

### Consultar tráfico de red recibido

```promql
rate(node_network_receive_bytes_total[5m])
```

### Consultar tráfico de red enviado

```promql
rate(node_network_transmit_bytes_total[5m])
```

### Actividades

1. Consulta el valor de `up`.
2. Calcula el uso de CPU.
3. Calcula el uso de memoria.
4. Consulta el espacio utilizado en `/`.
5. Identifica qué interfaz de red genera tráfico.
6. Modifica las consultas para agrupar por `instance`.

---

## Sesión 7: añadir Prometheus como fuente de datos en Grafana

### Objetivo

Conectar Grafana con Prometheus.

Acceder a Grafana:

```text
http://localhost:3000
```

Desde la interfaz:

1. Abrir **Connections**.
2. Seleccionar **Data sources**.
3. Pulsar **Add data source**.
4. Seleccionar **Prometheus**.
5. Introducir la URL:

```text
http://localhost:9090
```

6. Pulsar **Save & test**.
7. Confirmar que la conexión se ha realizado correctamente.

### Verificación

Crear un panel nuevo y probar la consulta:

```promql
up
```

El panel debería mostrar el estado de los objetivos de Prometheus.

### Actividades

1. Añade Prometheus como fuente de datos.
2. Ejecuta la consulta `up`.
3. Comprueba qué objetivos están disponibles.
4. Cambia el rango temporal.
5. Guarda la fuente de datos con un nombre descriptivo.

---

## Sesión 8: crear un dashboard operativo

### Objetivo

Crear un dashboard inicial para supervisar el sistema.

Crear un dashboard nuevo:

1. Abrir **Dashboards**.
2. Pulsar **New**.
3. Seleccionar **New dashboard**.
4. Añadir un panel.
5. Seleccionar Prometheus como fuente de datos.

### Panel 1: uso de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración recomendada:

- Título: `Uso de CPU`
- Unidad: `Percent (0-100)`
- Visualización: `Time series`
- Rango temporal: `Last 15 minutes`

### Panel 2: uso de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración recomendada:

- Título: `Uso de memoria`
- Unidad: `Percent (0-100)`
- Visualización: `Gauge`
- Umbral de advertencia: `75`
- Umbral crítico: `90`

### Panel 3: memoria disponible

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Configuración recomendada:

- Título: `Memoria disponible`
- Unidad: `bytes`
- Visualización: `Stat`

### Panel 4: uso del sistema de ficheros

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

Configuración recomendada:

- Título: `Uso del sistema de ficheros raíz`
- Unidad: `Percent (0-100)`
- Visualización: `Gauge`
- Umbral de advertencia: `75`
- Umbral crítico: `90`

### Panel 5: disponibilidad de Node Exporter

Consulta:

```promql
up{job="node_exporter"}
```

Configuración recomendada:

- Título: `Estado de Node Exporter`
- Visualización: `Stat`
- Valor correcto: `1`
- Valor incorrecto: `0`

### Panel 6: tráfico de red recibido

Consulta:

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!~"lo"
  }[5m])
)
```

Configuración recomendada:

- Título: `Tráfico recibido`
- Unidad: `bytes/sec`
- Visualización: `Time series`

### Actividades

1. Crea un dashboard llamado `Dashboard operativo`.
2. Añade los seis paneles anteriores.
3. Organiza los paneles en dos filas.
4. Configura títulos descriptivos.
5. Configura unidades correctas.
6. Añade umbrales a los paneles de tipo Gauge.
7. Guarda el dashboard.
8. Cambia el rango temporal a `Last 1 hour`.
9. Comprueba que los paneles muestran datos.

---

## Sesión 9: comparar periodos temporales

### Objetivo

Comparar el comportamiento actual con un periodo anterior.

Utilizar como rango principal:

```text
Last 15 minutes
```

En un panel de Grafana se puede aplicar un desplazamiento temporal a una consulta.

Consulta actual:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Consulta desplazada siete días:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configuración:

- Consulta A: sin desplazamiento.
- Consulta B: desplazamiento de `7d`.
- Estilo de Consulta A: línea sólida.
- Estilo de Consulta B: línea discontinua.

### Actividades

1. Compara el uso de CPU actual con el de hace un día.
2. Compara el tráfico de red actual con el de una hora antes.
3. Explica qué ocurre si Prometheus no conserva datos suficientemente antiguos.
4. Observa si el comportamiento del sistema presenta patrones repetitivos.

---

## Sesión 10: crear una regla de alerta

### Objetivo

Detectar automáticamente un uso elevado de CPU.

Una condición conceptual de alerta podría utilizar la siguiente consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
) > 80
```

La alerta se activaría cuando el uso medio de CPU superase el `80 %`.

### Pasos generales

1. Crear una regla de alerta.
2. Seleccionar Prometheus como fuente.
3. Introducir la consulta de CPU.
4. Configurar la condición:
   - Mayor que `80`.
5. Establecer el intervalo de evaluación.
6. Añadir un nombre descriptivo.
7. Añadir una descripción.
8. Guardar la regla.

### Ejemplo de anotaciones

```text
Resumen:
Uso elevado de CPU

Descripción:
La instancia {{ $labels.instance }} presenta un uso de CPU superior al 80 % durante el periodo de evaluación.
```

### Actividades

1. Crea una alerta de CPU superior al `80 %`.
2. Crea una alerta de memoria superior al `85 %`.
3. Crea una alerta de espacio utilizado superior al `90 %`.
4. Comprueba el estado de las reglas.
5. Explica la diferencia entre una alerta pendiente y una alerta activa.

---

# Práctica integradora

## Objetivo

Construir un dashboard operativo completo para un servidor Ubuntu.

### Requisitos mínimos

El dashboard debe incluir:

- Un panel de uso de CPU.
- Un panel de uso de memoria.
- Un panel de espacio utilizado.
- Un panel de tráfico de red.
- Un panel de disponibilidad de Node Exporter.
- Un panel de texto con información del servidor.
- Al menos una alerta.
- Un rango temporal configurable.
- Un título descriptivo para cada panel.
- Unidades apropiadas.
- Umbrales visuales en los paneles de capacidad.

### Panel de texto recomendado

Contenido sugerido:

```markdown
# Dashboard operativo

Este dashboard muestra el estado general del servidor monitorizado.

## Métricas principales

- Uso de CPU
- Uso de memoria
- Espacio disponible
- Tráfico de red
- Estado de Node Exporter

## Interpretación

Los valores deben analizarse considerando el periodo temporal seleccionado y el comportamiento habitual del sistema.
```

### Preguntas para la práctica

1. ¿Qué panel permite detectar una saturación progresiva?
2. ¿Qué panel permite consultar rápidamente el valor actual?
3. ¿Qué métrica indica que Node Exporter está disponible?
4. ¿Qué diferencia existe entre memoria libre y memoria disponible?
5. ¿Por qué se utiliza `rate()` para las métricas acumulativas?
6. ¿Qué riesgos tiene crear una alerta demasiado sensible?
7. ¿Por qué deben excluirse algunos sistemas de ficheros virtuales?
8. ¿Qué información debería aparecer en un dashboard operativo?
9. ¿Qué diferencia existe entre una métrica y un indicador visual?
10. ¿Cómo comprobarías si un problema pertenece al sistema o a la aplicación?

---

## Puntos clave

- La telemetría proporciona información sobre el estado y el comportamiento de los sistemas.
- Las métricas se representan habitualmente como series temporales.
- Prometheus recopila y almacena métricas.
- Node Exporter expone métricas del sistema operativo.
- Grafana consulta y visualiza los datos almacenados en Prometheus.
- PromQL permite seleccionar, filtrar, agregar y transformar métricas.
- La métrica `up` permite comprobar la disponibilidad de un objetivo de scraping.
- Las métricas acumulativas suelen necesitar funciones como `rate()`.
- Los dashboards deben facilitar la interpretación rápida del estado del sistema.
- Las unidades y los umbrales son tan importantes como la consulta.
- Un rango temporal incorrecto puede dificultar la interpretación de una métrica.
- Las alertas deben representar condiciones relevantes y accionables.
- La hora de los sistemas debe estar sincronizada.
- La retención limita la antigüedad de los datos que pueden consultarse.
- Un dashboard operativo debe priorizar claridad, contexto y capacidad de diagnóstico.

---

## Preguntas de comprobación

### Conceptos generales

1. ¿Qué es la telemetría?
2. ¿Qué diferencia existe entre una métrica, un log, una traza y un evento?
3. ¿Qué significa que una métrica sea una serie temporal?
4. ¿Qué función cumplen las etiquetas de una métrica?
5. ¿Qué diferencia existe entre monitorización y observabilidad?

### Grafana

6. ¿Qué función cumple Grafana?
7. ¿Qué es un dashboard?
8. ¿Qué diferencia existe entre un panel Stat y un panel Time series?
9. ¿Por qué es importante seleccionar correctamente la unidad de un panel?
10. ¿Qué es un rango temporal relativo?

### Prometheus

11. ¿Qué significa que Prometheus utilice un modelo *pull*?
12. ¿Qué función cumple un objetivo de scraping?
13. ¿Qué indica el valor `1` de la métrica `up`?
14. ¿Qué indica el valor `0` de la métrica `up`?
15. ¿Qué ocurre si un objetivo deja de responder?

### Node Exporter

16. ¿Qué información proporciona Node Exporter?
17. ¿En qué puerto suele escuchar Node Exporter?
18. ¿Qué contiene el endpoint `/metrics`?
19. ¿Cómo comprobarías que Node Exporter está activo?
20. ¿Cómo consultarías las métricas de memoria desde la terminal?

### PromQL

21. ¿Para qué sirve la función `rate()`?
22. ¿Por qué se utiliza una ventana como `[5m]`?
23. ¿Cómo calcularías el uso de memoria?
24. ¿Cómo calcularías el uso de CPU?
25. ¿Cómo filtrarías una métrica por la etiqueta `job`?

### Dashboards y alertas

26. ¿Qué elementos debe incluir un dashboard operativo?
27. ¿Qué diferencia existe entre una métrica actual y una tendencia?
28. ¿Qué es un umbral?
29. ¿Qué condiciones podrían justificar una alerta?
30. ¿Por qué una alerta debe ser accionable?

---

## Soluciones orientativas

### Solución 1: comprobar el estado de Node Exporter

```bash
systemctl is-active node_exporter
```

Resultado esperado:

```text
active
```

### Solución 2: consultar la disponibilidad

```promql
up{job="node_exporter"}
```

### Solución 3: uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Solución 4: uso de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Solución 5: tráfico recibido

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{
    device!~"lo"
  }[5m])
)
```

### Solución 6: filtrar por trabajo

```promql
up{job="node_exporter"}
```

### Solución 7: consultar objetivos mediante la API

```bash
curl -s http://localhost:9090/api/v1/targets
```

### Solución 8: comprobar el puerto de Grafana

```bash
sudo ss -lntp | grep 3000
```

### Solución 9: comprobar el puerto de Prometheus

```bash
sudo ss -lntp | grep 9090
```

### Solución 10: comprobar el endpoint de Node Exporter

```bash
curl -s http://localhost:9100/metrics | head
```

---

## Criterios de evaluación

La práctica integradora puede evaluarse mediante los siguientes criterios:

| Criterio | Puntuación |
|---|---:|
| Instalación y estado correcto de los servicios | 2 puntos |
| Configuración de Prometheus | 2 puntos |
| Conexión de Grafana con Prometheus | 1 punto |
| Creación del dashboard | 2 puntos |
| Corrección de las consultas PromQL | 1 punto |
| Configuración de unidades y umbrales | 1 punto |
| Creación de una alerta funcional | 1 punto |
| **Total** | **10 puntos** |

### Resultado esperado

Al finalizar la práctica, el alumno debe poder explicar el recorrido completo de una métrica:

```text
El sistema genera información
        |
        v
Node Exporter la expone
        |
        v
Prometheus la recopila
        |
        v
PromQL la consulta
        |
        v
Grafana la representa
        |
        v
Una alerta puede notificar una condición anómala
```