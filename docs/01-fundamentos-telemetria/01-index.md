# Fundamentos de telemetría

La telemetría permite recopilar información sobre el estado y el comportamiento de sistemas, aplicaciones y servicios.

Estos datos pueden utilizarse para:

- Detectar problemas.
- Analizar tendencias.
- Validar cambios.
- Investigar incidentes.
- Crear alertas.
- Mejorar la operación de una infraestructura.
- Planificar la capacidad futura.

En este bloque se estudiará el recorrido completo de una métrica:

```text
Sistema monitorizado
        ↓
Agente o exporter
        ↓
Prometheus
        ↓
Consulta PromQL
        ↓
Grafana
        ↓
Panel visual
```

---

## Objetivos

Al finalizar este bloque podrás:

- Explicar qué es la telemetría.
- Diferenciar métricas, logs, trazas y eventos.
- Diferenciar los modelos de recopilación `push` y `pull`.
- Interpretar una serie temporal.
- Identificar el significado de un nombre de métrica y sus etiquetas.
- Comprender la relación entre muestreo, retención y almacenamiento.
- Explicar el concepto de *downsampling*.
- Identificar el papel de Grafana y de las fuentes de datos.
- Consultar métricas básicas de un sistema Linux.
- Interpretar consultas sencillas de PromQL.

---

## 1. ¿Qué es la telemetría?

La telemetría es el conjunto de técnicas utilizadas para recopilar, transmitir, almacenar y analizar información sobre un sistema.

Un sistema monitorizado puede ser:

- Un servidor.
- Una máquina virtual.
- Un contenedor.
- Una aplicación.
- Una base de datos.
- Un dispositivo de red.
- Un servicio web.

La telemetría permite responder preguntas como:

- ¿Está funcionando el sistema?
- ¿Cuánta CPU está utilizando?
- ¿Cuánta memoria queda disponible?
- ¿Cuánto espacio libre tiene el disco?
- ¿Cuántas peticiones recibe una aplicación?
- ¿Cuánto tardan las respuestas?
- ¿Cuándo comenzó un problema?
- ¿Qué componente puede estar provocando un error?

> La telemetría convierte el comportamiento de un sistema en datos que pueden analizarse.

### Sin telemetría

Sin datos históricos, normalmente solo podemos comprobar el estado actual:

```text
La CPU está al 85 % ahora mismo.
```

No sabemos:

- Cuándo comenzó el incremento.
- Si es un pico puntual.
- Si ocurre periódicamente.
- Si está relacionado con un cambio reciente.
- Si otros componentes también están afectados.

### Con telemetría

Con una serie de datos podemos observar la evolución:

```text
Hora     CPU
10:00    25 %
10:05    40 %
10:10    85 %
10:15    98 %
```

En este caso se observa una tendencia ascendente que podría indicar una sobrecarga progresiva.

---

## 2. Tipos de telemetría

En observabilidad suelen distinguirse cuatro tipos principales de información:

| Tipo | Qué representa | Ejemplo |
|---|---|---|
| Métrica | Un valor numérico medible | Uso de CPU del 75 % |
| Log | Un registro textual | Error de conexión con una base de datos |
| Traza | El recorrido de una petición | Cliente → API → base de datos |
| Evento | Una acción puntual | Reinicio de un servicio |

---

### 2.1. Métricas

Una métrica es un valor numérico que describe el estado o la actividad de un sistema.

Ejemplos:

```text
Uso de CPU: 73 %
Memoria disponible: 2,4 GiB
Espacio libre: 38 GiB
Peticiones por segundo: 125
Tiempo de respuesta: 240 ms
```

Una métrica puede representarse de forma conceptual así:

```text
nombre_metrica{etiquetas} valor
```

Ejemplo:

```text
cpu_usage_percent{host="ubuntu-01"} 73
```

Esta línea contiene:

- Nombre de la métrica: `cpu_usage_percent`.
- Etiqueta `host`: `ubuntu-01`.
- Valor: `73`.
- Unidad conceptual: porcentaje.

Las métricas son especialmente útiles para:

- Crear gráficos.
- Detectar tendencias.
- Establecer umbrales.
- Generar alertas.
- Comparar sistemas.

#### Ejemplos en Ubuntu

Consultar la carga media:

```bash
uptime
```

Consultar el uso de memoria:

```bash
free -h
```

Consultar el espacio de disco:

```bash
df -h
```

Consultar las interfaces de red:

```bash
ip -br addr
```

Estos comandos muestran valores puntuales. Una plataforma de monitorización permite recopilar esos valores periódicamente y almacenarlos.

---

### 2.2. Logs

Un log es un registro textual generado por una aplicación, un servicio o el sistema operativo.

Ejemplos:

```text
Usuario autenticado correctamente
Conexión aceptada desde 192.168.1.25
ERROR: no se pudo conectar con la base de datos
Servicio reiniciado correctamente
```

Un log puede contener:

- Fecha y hora.
- Servicio o componente.
- Nivel de severidad.
- Mensaje.
- Identificador de proceso.
- Información adicional.

#### Niveles habituales

| Nivel | Significado |
|---|---|
| `DEBUG` | Información detallada para diagnóstico |
| `INFO` | Funcionamiento normal |
| `WARNING` | Situación anómala que no impide continuar |
| `ERROR` | Error que afecta a una operación |
| `CRITICAL` | Problema grave |

#### Consultar logs en Ubuntu

Consultar los últimos mensajes:

```bash
sudo journalctl -n 20 --no-pager
```

Consultar los logs de Grafana:

```bash
sudo journalctl -u grafana-server -n 30 --no-pager
```

Consultar los logs de Prometheus:

```bash
sudo journalctl -u prometheus -n 30 --no-pager
```

Consultar los logs de Node Exporter:

```bash
sudo journalctl -u node-exporter -n 30 --no-pager
```

Ver los logs en tiempo real:

```bash
sudo journalctl -f
```

Para salir:

```text
Ctrl + C
```

Filtrar únicamente errores:

```bash
sudo journalctl -p err -n 30 --no-pager
```

---

### 2.3. Trazas

Una traza representa el recorrido de una petición a través de diferentes componentes.

Es especialmente útil en aplicaciones distribuidas y arquitecturas basadas en microservicios.

Ejemplo:

```text
Cliente
  ↓
API Gateway
  ↓
Servicio de usuarios
  ↓
Servicio de pedidos
  ↓
Base de datos
```

Una petición puede producir estos tiempos:

```text
API Gateway:        20 ms
Servicio usuarios:  45 ms
Servicio pedidos: 180 ms
Base de datos:     150 ms
```

La traza permite identificar qué parte de la petición está provocando la demora.

Una métrica podría indicar:

```text
El tiempo medio de respuesta es de 400 ms.
```

La traza ayuda a responder:

```text
¿Qué servicio concreto está causando esos 400 ms?
```

---

### 2.4. Eventos

Un evento representa una acción o cambio ocurrido en un instante concreto.

Ejemplos:

```text
El servicio Grafana se ha reiniciado.
Se ha desplegado una nueva versión.
Se ha agotado el espacio disponible.
Se ha modificado la configuración.
Se ha creado un nuevo usuario.
```

En Ubuntu se pueden consultar algunos eventos mediante:

```bash
systemctl --failed
```

```bash
last reboot
```

```bash
systemctl status grafana-server
```

Los eventos son especialmente útiles para relacionar un cambio con un problema posterior.

Por ejemplo:

```text
10:00 — Se despliega una nueva versión.
10:05 — Aumenta el tiempo de respuesta.
10:10 — Aparecen errores en los logs.
```

---

## 3. Comparación entre métricas, logs, trazas y eventos

| Tipo | Pregunta principal | Ejemplo |
|---|---|---|
| Métrica | ¿Cuánto? | CPU al 75 % |
| Log | ¿Qué ocurrió? | Error de conexión |
| Traza | ¿Dónde se produjo la demora? | Base de datos: 800 ms |
| Evento | ¿Qué cambió? | Reinicio del servicio |

Una investigación completa suele combinar varios tipos de telemetría:

```text
Métricas + logs + trazas + eventos
```

### Ejemplo integrado

Supongamos que una aplicación responde lentamente.

#### Métricas

```text
http_request_duration_seconds 2.4
node_load1 5.8
```

Indican que las peticiones tardan más y que la carga del sistema es elevada.

#### Log

```text
ERROR database connection timeout
```

Indica un problema de conexión con la base de datos.

#### Traza

```text
API Gateway: 20 ms
Servicio de pedidos: 250 ms
Base de datos: 2200 ms
```

Localiza la mayor parte del retraso en la base de datos.

#### Evento

```text
17:30 — Se reinicia el servicio de base de datos
```

Puede explicar el inicio de la degradación.

---

## 4. Modelos de recopilación

Existen dos modelos principales para recopilar datos: `pull` y `push`.

---

### 4.1. Modelo pull

En el modelo `pull`, el sistema de monitorización consulta periódicamente al componente monitorizado.

```text
Prometheus ───── consulta ─────> Exporter
Prometheus <──── devuelve ────── Exporter
```

Por ejemplo, Prometheus puede consultar:

```text
http://servidor:9100/metrics
```

El exporter devuelve métricas como:

```text
node_cpu_seconds_total{cpu="0",mode="idle"} 12345.6
```

Ventajas:

- El sistema de monitorización controla la frecuencia.
- Es sencillo comprobar si un objetivo responde.
- La configuración está centralizada.
- La ausencia de respuesta puede detectarse fácilmente.

Requisitos:

- El endpoint debe ser accesible.
- El componente monitorizado debe exponer las métricas.
- La red debe permitir la conexión.

---

### 4.2. Modelo push

En el modelo `push`, el componente monitorizado envía los datos al sistema receptor.

```text
Aplicación ───── envía métricas ─────> Recolector
```

Puede ser adecuado cuando:

- El componente no puede ser consultado directamente.
- Se trata de un trabajo temporal.
- El sistema está detrás de una red restringida.
- Se utiliza un agente intermediario.
- El proceso dura poco tiempo y no permanece activo.

Ventajas:

- El sistema monitorizado decide cuándo enviar datos.
- Es adecuado para trabajos efímeros.
- Puede funcionar en redes donde el receptor no puede acceder directamente al origen.

---

### 4.3. Comparación

| Característica | Pull | Push |
|---|---|---|
| Quién inicia la comunicación | Sistema de monitorización | Sistema monitorizado |
| Ejemplo | Prometheus consulta un exporter | Un agente envía métricas |
| Ventaja principal | Control centralizado | Adecuado para trabajos temporales |
| Riesgo principal | El endpoint debe ser accesible | El receptor debe aceptar datos |
| Uso habitual | Servidores permanentes | Jobs y agentes |

En el laboratorio utilizaremos principalmente el modelo `pull`:

```text
Prometheus → Node Exporter
```

---

## 5. Series temporales

Una serie temporal es una secuencia de valores asociados a instantes concretos.

Ejemplo:

```text
Hora      CPU
10:00     20 %
10:01     25 %
10:02     95 %
10:03     30 %
```

Cada valor tiene:

- Un instante de tiempo.
- Un valor.
- Una métrica.
- Un conjunto de etiquetas.

Una serie temporal puede representarse así:

```text
nombre_metrica{etiquetas} valor
```

Ejemplo:

```text
cpu_usage_percent{host="ubuntu-01",cpu="0"} 42.5
```

Contiene:

- Nombre: `cpu_usage_percent`.
- Etiqueta `host`: `ubuntu-01`.
- Etiqueta `cpu`: `0`.
- Valor: `42.5`.

---

### 5.1. Etiquetas

Las etiquetas permiten diferenciar y filtrar series temporales.

Estas métricas tienen el mismo nombre, pero representan series diferentes:

```text
http_requests_total{method="GET",status="200"} 1500
http_requests_total{method="GET",status="500"} 12
http_requests_total{method="POST",status="200"} 430
```

Las etiquetas indican:

- Método HTTP.
- Código de respuesta.
- Equipo.
- Instancia.
- Servicio.
- Punto de montaje.
- Interfaz de red.

Una métrica con demasiadas combinaciones de etiquetas puede generar una cantidad excesiva de series. Este problema se conoce como **alta cardinalidad**.

---

### 5.2. Ejemplo de métrica de disco

```text
node_filesystem_avail_bytes{
  device="/dev/sda2",
  fstype="ext4",
  instance="localhost:9100",
  job="node",
  mountpoint="/"
} 18446744073
```

La métrica contiene:

| Elemento | Valor |
|---|---|
| Nombre | `node_filesystem_avail_bytes` |
| Dispositivo | `/dev/sda2` |
| Sistema de ficheros | `ext4` |
| Instancia | `localhost:9100` |
| Trabajo | `node` |
| Punto de montaje | `/` |
| Valor | `18446744073` |

---

### 5.3. Tipos de métricas frecuentes

#### Gauge

Un *gauge* representa un valor que puede subir o bajar.

Ejemplos:

```text
node_load1
node_memory_MemAvailable_bytes
```

#### Counter

Un *counter* representa un valor acumulado que normalmente aumenta.

Ejemplo:

```text
node_cpu_seconds_total
```

Para analizar la velocidad de incremento de un contador se utilizan funciones como `rate`.

#### Histograma

Un histograma permite analizar la distribución de valores, como tiempos de respuesta.

#### Summary

Un *summary* calcula determinados cuantiles o estadísticas sobre observaciones.

> Es importante conocer el tipo y la unidad de una métrica antes de interpretarla.

---

## 6. Comprobar métricas con Node Exporter

Node Exporter expone métricas del sistema operativo en un endpoint HTTP.

Endpoint habitual:

```text
http://127.0.0.1:9100/metrics
```

Comprobar si responde:

```bash
curl -I http://127.0.0.1:9100/metrics
```

La respuesta esperada contiene:

```text
HTTP/1.1 200 OK
```

Consultar las primeras líneas:

```bash
curl -s http://127.0.0.1:9100/metrics | head -20
```

Buscar métricas de CPU:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_cpu_seconds_total' \
  | head
```

Buscar métricas de memoria:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_memory_' \
  | head
```

Buscar métricas de disco:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_filesystem_' \
  | head
```

Contar las métricas expuestas:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep -v '^#' \
  | wc -l
```

### Ejemplos importantes

```text
node_cpu_seconds_total
```

Es un contador acumulado expresado en segundos.

```text
node_memory_MemAvailable_bytes
```

Representa memoria disponible expresada en bytes.

```text
node_load1
```

Representa la carga media del sistema durante un minuto.

---

## 7. Muestreo

El intervalo de muestreo indica cada cuánto se recopila una métrica.

Ejemplos:

- Cada 5 segundos.
- Cada 15 segundos.
- Cada 30 segundos.
- Cada minuto.

Un intervalo corto permite observar cambios rápidos, pero genera más datos.

Un intervalo largo reduce el almacenamiento, pero puede ocultar picos breves.

### Ejemplo

Supongamos que la CPU cambia así:

```text
Hora      CPU
10:00     20 %
10:01     25 %
10:02     95 %
10:03     30 %
10:04     28 %
```

Si recopilamos un valor cada minuto, detectamos el pico:

```text
10:02     95 %
```

Si recopilamos un valor cada cinco minutos, podríamos obtener:

```text
10:00     28 %
10:05     30 %
```

El pico habría desaparecido de la observación.

---

### 7.1. Configuración de Prometheus

Una configuración habitual puede ser:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

- `scrape_interval`: frecuencia con la que se consultan los objetivos.
- `evaluation_interval`: frecuencia con la que se evalúan reglas y alertas.

Consultar la configuración:

```bash
sudo grep -n "interval" /etc/prometheus/prometheus.yml
```

---

## 8. Retención de datos

La retención indica cuánto tiempo se conservan los datos.

Ejemplos:

- 24 horas.
- 15 días.
- 90 días.
- 1 año.

La política de retención debe equilibrar:

- Necesidad de análisis histórico.
- Espacio disponible.
- Rendimiento.
- Coste.
- Requisitos legales o de auditoría.

Una retención larga con un intervalo muy corto puede generar un volumen importante de datos.

La pregunta adecuada no es únicamente:

> ¿Cuántos datos podemos guardar?

También debemos preguntarnos:

> ¿Qué resolución necesitamos conservar para cada periodo?

---

## 9. Downsampling

El *downsampling* consiste en reducir la resolución de los datos históricos.

Ejemplo:

```text
Datos recientes:
  Un valor cada 15 segundos

Datos antiguos:
  Un valor medio cada 5 minutos
```

Se pueden conservar agregaciones como:

- Media.
- Mínimo.
- Máximo.
- Percentiles.
- Número de eventos.

### Ejemplo conceptual

Datos originales:

```text
10:00:00  20
10:00:15  22
10:00:30  25
10:00:45  30
```

Agregación de un minuto:

```text
10:00      media: 24,25
```

La agregación ocupa menos espacio, pero ya no conserva cada valor original.

### Ventajas

- Reduce el espacio de almacenamiento.
- Mejora el rendimiento de consultas históricas.
- Permite conservar tendencias durante más tiempo.

### Inconveniente

- Se pierde detalle.
- Los picos breves pueden desaparecer.
- Ya no es posible reconstruir exactamente los valores originales.

---

## 10. Grafana y las fuentes de datos

Grafana es una plataforma para consultar, visualizar y analizar datos.

Grafana normalmente no recopila directamente las métricas. Se conecta a una fuente de datos, ejecuta consultas y presenta los resultados.

Sus funciones principales son:

- Conectarse a fuentes de datos.
- Ejecutar consultas.
- Mostrar gráficos y tablas.
- Crear dashboards.
- Configurar variables.
- Representar alertas.
- Facilitar el análisis operativo.

El flujo habitual del laboratorio es:

```text
Node Exporter
      ↓
Prometheus
      ↓
Consulta PromQL
      ↓
Grafana
      ↓
Panel visual
```

---

### 10.1. Comprobar Prometheus

Comprobar que Prometheus está preparado:

```bash
curl -s http://127.0.0.1:9090/-/ready
```

Respuesta esperada:

```text
Prometheus Server is Ready.
```

Consultar la API de Prometheus:

```bash
curl -sG http://127.0.0.1:9090/api/v1/query \
  --data-urlencode 'query=up'
```

---

### 10.2. Comprobar la fuente de datos en Grafana

En Grafana:

1. Accede a la interfaz web.
2. Abre **Connections**.
3. Selecciona **Data sources**.
4. Abre la fuente de datos de Prometheus.
5. Comprueba la URL configurada.
6. Pulsa **Save & test**.

La URL puede ser:

```text
http://localhost:9090
```

o:

```text
http://127.0.0.1:9090
```

---

## 11. Consultas PromQL básicas

### Comprobar objetivos

```promql
up
```

Interpretación:

```text
up = 1
```

El objetivo está disponible.

```text
up = 0
```

El objetivo está configurado, pero no responde correctamente.

---

### Consultar la carga del sistema

```promql
node_load1
```

---

### Consultar la memoria disponible

```promql
node_memory_MemAvailable_bytes
```

---

### Consultar el tiempo desde el arranque

```promql
node_time_seconds - node_boot_time_seconds
```

---

### Calcular el uso aproximado de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La métrica `node_cpu_seconds_total` es un contador acumulado. Por eso se utiliza `rate` para calcular su velocidad de cambio durante los últimos cinco minutos.

---

### Calcular el porcentaje de memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

---

## 12. Práctica guiada

### Práctica 1: identificar el estado del sistema

Ejecuta:

```bash
hostname
uptime
free -h
df -h
ip -br addr
```

Completa la tabla:

| Dato | Resultado |
|---|---|
| Nombre del equipo | |
| Tiempo encendido | |
| Carga del sistema | |
| Memoria total | |
| Memoria disponible | |
| Espacio libre en `/` | |
| Dirección IP | |

Responde:

1. ¿Cuánto tiempo lleva encendido el sistema?
2. ¿La carga parece elevada?
3. ¿Cuánta memoria está disponible?
4. ¿Qué porcentaje del disco está ocupado?
5. ¿Qué datos son métricas?
6. ¿Qué datos son información de configuración?

---

### Práctica 2: consultar Node Exporter

Comprueba el servicio:

```bash
systemctl is-active node-exporter
```

Comprueba el endpoint:

```bash
curl -I http://127.0.0.1:9100/metrics
```

Busca tres métricas:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_load'
```

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_memory_MemAvailable_bytes'
```

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_filesystem_avail_bytes'
```

Documenta cada métrica:

```text
Nombre:
Tipo:
Valor:
Etiquetas:
Unidad:
Qué representa:
```

---

### Práctica 3: consultar Prometheus

Accede a:

```text
http://localhost:9090
```

Ejecuta estas consultas:

```promql
up
```

```promql
node_load1
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

```promql
count(node_cpu_seconds_total)
```

Responde:

1. ¿Cuántos objetivos están activos?
2. ¿Qué valor tiene la carga de un minuto?
3. ¿Cuánta memoria está disponible?
4. ¿Qué sistemas de ficheros aparecen?
5. ¿Cuántas series de CPU existen?

---

### Práctica 4: crear un dashboard en Grafana

Crea un dashboard con los siguientes paneles.

#### Panel 1: carga media

Consulta:

```promql
node_load1
```

Título:

```text
Carga media del sistema
```

Visualización recomendada:

```text
Time series
```

#### Panel 2: uso de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Título:

```text
Uso estimado de CPU
```

#### Panel 3: memoria utilizada

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Título:

```text
Memoria utilizada
```

Configura la unidad del panel como porcentaje cuando corresponda.

---

## 13. Comprobación del entorno

Antes de realizar las prácticas, comprueba los servicios:

```bash
systemctl is-active prometheus
systemctl is-active node-exporter
systemctl is-active grafana-server
```

Los tres deberían devolver:

```text
active
```

Comprueba los puertos:

```bash
sudo ss -tulpn | grep -E ':3000|:9090|:9100'
```

Deberían aparecer:

```text
:3000  Grafana
:9090  Prometheus
:9100  Node Exporter
```

Comprueba los endpoints:

```bash
curl -I http://127.0.0.1:3000
curl -I http://127.0.0.1:9090
curl -I http://127.0.0.1:9100/metrics
```

---

## 14. Resolución de problemas

### Node Exporter no responde

Comprueba el servicio:

```bash
systemctl status node-exporter
```

Comprueba el puerto:

```bash
sudo ss -tulpn | grep 9100
```

Consulta los logs:

```bash
sudo journalctl -u node-exporter -n 50 --no-pager
```

---

### Prometheus muestra `up = 0`

Comprueba el endpoint del exporter:

```bash
curl -I http://127.0.0.1:9100/metrics
```

Revisa la configuración:

```bash
sudo grep -n -A8 -B2 "node" \
  /etc/prometheus/prometheus.yml
```

Valida el fichero:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Reinicia Prometheus después de modificar la configuración:

```bash
sudo systemctl restart prometheus
```

---

### Grafana no muestra datos

Comprueba:

1. Que Prometheus está activo.
2. Que Node Exporter responde.
3. Que `up` devuelve `1`.
4. Que la URL de la fuente de datos es correcta.
5. Que el intervalo temporal incluye datos recientes.
6. Que la consulta no contiene etiquetas incorrectas.

---

### Los valores parecen demasiado grandes

Comprueba la unidad y el tipo de métrica:

- Los bytes deben convertirse a KiB, MiB o GiB.
- Los contadores deben analizarse con `rate` o `irate`.
- Los segundos acumulados no son una duración instantánea.
- Los porcentajes suelen estar entre $$0$$ y $$100$$.
- La carga del sistema no es un porcentaje de CPU.

---

## 15. Actividad de investigación

### Situación

Un usuario informa:

> La aplicación responde lentamente desde hace unos minutos.

Investiga el sistema utilizando:

```bash
uptime
```

```bash
free -h
```

```bash
df -h
```

```bash
systemctl --failed
```

```bash
sudo journalctl -p err --since "15 minutes ago" --no-pager
```

Consulta también Node Exporter:

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep -E '^node_load|^node_memory_MemAvailable_bytes|^node_filesystem_avail_bytes' \
  | head -20
```

Completa el informe:

```markdown
## Incidencia

Descripción:

## Métricas observadas

Carga del sistema:
Memoria disponible:
Espacio libre:

## Logs observados

¿Hay errores recientes?
¿Qué servicios aparecen?

## Eventos observados

¿Se ha reiniciado algún servicio?
¿Hay unidades fallidas?

## Hipótesis

¿Cuál puede ser la causa del problema?

## Evidencias

¿Qué comandos y resultados apoyan la hipótesis?

## Siguiente comprobación

¿Qué consultarías a continuación?
```

---

## 16. Preguntas de comprobación

1. ¿Qué es la telemetría?
2. ¿Qué diferencia existe entre una métrica y un log?
3. ¿Qué información proporciona una traza?
4. ¿Qué es un evento?
5. ¿Quién inicia la comunicación en el modelo `pull`?
6. ¿Quién inicia la comunicación en el modelo `push`?
7. ¿Qué representa una etiqueta?
8. ¿Por qué una métrica puede tener varias series temporales?
9. ¿Qué ocurre si el intervalo de muestreo es demasiado grande?
10. ¿Qué problema resuelve la retención?
11. ¿Qué objetivo tiene el *downsampling*?
12. ¿Qué función cumple Node Exporter?
13. ¿Qué función cumple Prometheus?
14. ¿Qué función cumple Grafana?
15. ¿Qué indica `up = 1`?
16. ¿Por qué se utiliza `rate` con `node_cpu_seconds_total`?
17. ¿Qué puede indicar que una métrica deje de actualizarse?
18. ¿Por qué conviene combinar métricas, logs, trazas y eventos?

---

## 17. Puntos clave

- La telemetría permite observar y analizar el comportamiento de los sistemas.
- Las métricas representan valores numéricos.
- Los logs proporcionan información textual y contextual.
- Las trazas muestran el recorrido de una petición.
- Los eventos representan acciones o cambios puntuales.
- Una métrica aislada ofrece menos información que una serie temporal.
- Las etiquetas identifican y diferencian series temporales.
- El modelo `pull` es utilizado habitualmente por Prometheus.
- Node Exporter expone métricas del sistema operativo.
- Prometheus recopila y almacena métricas.
- Grafana consulta y visualiza los datos.
- El muestreo determina la frecuencia de recopilación.
- La retención determina cuánto tiempo se conservan los datos.
- El *downsampling* reduce la resolución de los datos históricos.
- Una investigación eficaz combina diferentes tipos de telemetría.