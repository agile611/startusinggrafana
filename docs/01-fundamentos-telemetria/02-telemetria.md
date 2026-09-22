# Conceptos de telemetría

La telemetría permite recopilar información sobre el estado y el comportamiento de sistemas, aplicaciones y servicios.

Estos datos pueden utilizarse para:

- Detectar problemas.
- Analizar tendencias.
- Validar cambios.
- Investigar incidentes.
- Crear alertas.
- Planificar la capacidad futura.
- Mejorar la operación de una infraestructura.

El recorrido general de la telemetría es:

```text
Sistema monitorizado
        ↓
Agente o exporter
        ↓
Sistema de recopilación
        ↓
Almacenamiento
        ↓
Consultas
        ↓
Visualización y alertas
```

En este curso utilizaremos principalmente:

```text
Node Exporter → Prometheus → Grafana
```

- **Node Exporter** expone métricas del sistema operativo.
- **Prometheus** recopila y almacena esas métricas.
- **Grafana** consulta y representa los datos visualmente.

---

## Objetivos

Al finalizar esta sesión podrás:

- Explicar qué es la telemetría.
- Diferenciar métricas, logs, trazas y eventos.
- Identificar ejemplos de telemetría en un sistema Ubuntu.
- Consultar información básica desde la terminal.
- Relacionar los datos recopilados con Prometheus y Grafana.
- Diferenciar un valor puntual de una tendencia temporal.
- Interpretar el papel de Node Exporter dentro de una arquitectura de monitorización.

---

## 1. ¿Qué es la telemetría?

La telemetría es el conjunto de técnicas y herramientas utilizadas para recopilar, transmitir, almacenar y analizar información sobre un sistema.

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

### Sin telemetría

Sin datos históricos, solo podemos observar el estado actual:

```text
La CPU está al 85 % ahora mismo.
```

Este dato no permite saber:

- Cuándo comenzó el incremento.
- Si se trata de un pico puntual.
- Si ocurre periódicamente.
- Si está relacionado con un cambio reciente.
- Si otros componentes también están afectados.

### Con telemetría

Con una secuencia de valores podemos observar la evolución:

```text
Hora     CPU
10:00    25 %
10:05    40 %
10:10    85 %
10:15    98 %
```

En este caso se observa una tendencia ascendente que podría indicar una sobrecarga progresiva.

> Una métrica aislada muestra un estado. Una serie de valores permite analizar una evolución.

---

## 2. Tipos principales de telemetría

En observabilidad suelen distinguirse cuatro tipos principales de información:

| Tipo | Qué representa | Ejemplo | Pregunta principal |
|---|---|---|---|
| Métrica | Un valor numérico | CPU al 75 % | ¿Cuánto? |
| Log | Un mensaje registrado | Error de conexión | ¿Qué ocurrió? |
| Traza | El recorrido de una petición | API → base de datos | ¿Dónde se produjo la demora? |
| Evento | Una acción puntual | Reinicio de un servicio | ¿Qué cambió? |

---

## 3. Métricas

Una métrica es un valor numérico que describe el estado o la actividad de un sistema.

Ejemplos:

```text
Uso de CPU: 73 %
Memoria disponible: 2,4 GiB
Espacio libre: 38 GiB
Peticiones por segundo: 125
Temperatura: 48 °C
Tiempo de respuesta: 240 ms
```

Las métricas tienen normalmente estas características:

- Son valores numéricos.
- Se pueden recopilar periódicamente.
- Se pueden representar mediante gráficos.
- Permiten establecer umbrales.
- Son adecuadas para observar tendencias.
- Pueden utilizarse para crear alertas.

### Estructura de una métrica

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

El valor aislado representa el estado en un instante determinado:

```text
cpu_usage_percent{host="ubuntu-01"} 73
```

Una secuencia de valores permite analizar la evolución:

```text
10:00  32 %
10:01  35 %
10:02  48 %
10:03  73 %
10:04  81 %
```

En este caso se observa una tendencia ascendente.

### Consultar métricas básicas en Ubuntu

Consultar la carga media del sistema:

```bash
uptime
```

Ejemplo de salida:

```text
17:20:10 up 2 days, 4:32, 2 users, load average: 0.42, 0.36, 0.28
```

La salida incluye:

- Hora actual.
- Tiempo desde el último arranque.
- Número de usuarios conectados.
- Carga media durante 1 minuto.
- Carga media durante 5 minutos.
- Carga media durante 15 minutos.

Consultar la memoria:

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

### Actividad: consultar el estado del sistema

Ejecuta:

```bash
uptime
free -h
df -h /
```

Completa la siguiente información:

```text
Carga media de 1 minuto:
Memoria total:
Memoria disponible:
Espacio total de /:
Espacio disponible en /:
Porcentaje utilizado:
```

Estos comandos muestran el estado en un instante. Para realizar monitorización necesitamos recopilar los valores periódicamente y almacenarlos.

Un ejemplo sencillo sería:

```bash
while true; do
  date
  uptime
  free -h
  sleep 5
done
```

Para detener el bucle:

```text
Ctrl + C
```

Este ejemplo no sustituye a Prometheus, pero ayuda a comprender el concepto de muestreo.

---

## 4. Logs

Un log es un registro textual generado por una aplicación, un servicio o el sistema operativo.

Ejemplos:

```text
Usuario autenticado correctamente
Conexión aceptada desde 192.168.1.25
ERROR: no se pudo conectar con la base de datos
Servicio reiniciado correctamente
Archivo de configuración cargado
```

Un log suele incluir:

- Fecha y hora.
- Nivel de severidad.
- Servicio o componente.
- Mensaje.
- Identificador de proceso.
- Información adicional.

### Niveles habituales

| Nivel | Significado |
|---|---|
| `DEBUG` | Información detallada para diagnóstico |
| `INFO` | Información normal de funcionamiento |
| `WARNING` | Situación anómala que no impide continuar |
| `ERROR` | Error que afecta a una operación |
| `CRITICAL` | Problema grave que puede detener el servicio |

### Consultar logs en Ubuntu

Ubuntu utiliza habitualmente `systemd-journald` para gestionar los registros de los servicios.

Consultar los últimos registros del sistema:

```bash
sudo journalctl -n 20 --no-pager
```

Consultar los registros de Grafana:

```bash
sudo journalctl -u grafana-server -n 30 --no-pager
```

Consultar los registros de Prometheus:

```bash
sudo journalctl -u prometheus -n 30 --no-pager
```

Consultar los registros de Node Exporter:

```bash
sudo journalctl -u node-exporter -n 30 --no-pager
```

> El nombre del servicio puede variar según el método de instalación. Si `node-exporter` no existe, consulta las unidades disponibles con `systemctl list-units --type=service | grep -i exporter`.

Ver los registros en tiempo real:

```bash
sudo journalctl -f
```

Para salir:

```text
Ctrl + C
```

Filtrar errores:

```bash
sudo journalctl -p err -n 30 --no-pager
```

Consultar los registros desde el último arranque:

```bash
sudo journalctl -b --no-pager
```

### Actividad: analizar logs

Ejecuta:

```bash
sudo journalctl -u grafana-server -n 20 --no-pager
```

Busca:

- La hora de cada mensaje.
- El nombre del servicio.
- Mensajes de inicio.
- Advertencias.
- Errores.

Responde:

```text
1. ¿A qué hora se inició el servicio?
2. ¿Aparece algún mensaje de error?
3. ¿Qué componente genera los registros?
4. ¿Qué diferencia hay entre estos registros y una métrica?
```

### Diferencia entre una métrica y un log

Una métrica podría indicar:

```text
grafana_http_request_duration_seconds 0.240
```

Un log podría indicar:

```text
2026-09-22 17:25:10 ERROR database connection timeout
```

La métrica responde principalmente:

```text
¿Cuánto?
```

El log aporta contexto:

```text
¿Qué ocurrió?
¿Dónde ocurrió?
¿Cuándo ocurrió?
¿Qué mensaje produjo el componente?
```

---

## 5. Trazas

Una traza representa el recorrido de una petición a través de distintos componentes.

Es especialmente útil en aplicaciones distribuidas y arquitecturas de microservicios.

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

Una petición podría tener estos tiempos:

```text
API Gateway:       20 ms
Servicio usuarios: 45 ms
Servicio pedidos: 180 ms
Base de datos:     150 ms
```

La traza permite observar qué parte de la petición produce la mayor demora.

### Ejemplo con identificadores

```text
trace_id: 8f3a2c
span: api-gateway
duración: 20 ms

trace_id: 8f3a2c
span: users-service
duración: 45 ms

trace_id: 8f3a2c
span: orders-service
duración: 180 ms
```

Todos los fragmentos pertenecen a la misma petición porque comparten el mismo identificador de traza.

Una métrica puede indicar:

```text
El tiempo medio de respuesta es de 400 ms.
```

Una traza ayuda a responder:

```text
¿Qué servicio concreto está causando esos 400 ms?
```

### Actividad de análisis

Analiza este ejemplo:

```text
Petición: GET /api/orders/42

API Gateway       12 ms
Servicio usuarios 25 ms
Servicio pedidos  310 ms
Base de datos     280 ms
```

Responde:

1. ¿Qué componente consume más tiempo?
2. ¿Qué componente investigarías primero?
3. ¿Qué métrica complementaria consultarías?
4. ¿Qué log buscarías?

Respuestas esperadas:

1. El servicio de pedidos y la base de datos.
2. La consulta o conexión con la base de datos.
3. Latencia de consultas, conexiones activas o errores de base de datos.
4. Los logs del servicio de pedidos y de la base de datos.

---

## 6. Eventos

Un evento representa una acción o un cambio ocurrido en un instante concreto.

Ejemplos:

```text
El servicio Grafana se ha reiniciado.
Se ha creado un nuevo usuario.
Se ha desplegado una nueva versión.
Se ha agotado el espacio disponible.
Se ha modificado la configuración.
```

Los eventos suelen ser puntuales, mientras que las métricas describen valores que pueden cambiar continuamente.

### Consultar eventos en Ubuntu

Ver servicios fallidos:

```bash
systemctl --failed
```

Consultar el estado de un servicio:

```bash
systemctl status grafana-server
```

Consultar los últimos reinicios:

```bash
last reboot
```

Consultar los usuarios conectados:

```bash
who
```

Consultar servicios activos:

```bash
systemctl list-units --type=service --state=running
```

### Actividad: comprobar servicios fallidos

Ejecuta:

```bash
systemctl --failed
```

Si no hay servicios fallidos, puedes obtener una salida similar a:

```text
0 loaded units listed.
```

Responde:

```text
1. ¿Hay algún servicio fallido?
2. ¿Esta información es una métrica, un log o un evento?
3. ¿En qué momento sería importante consultar este dato?
```

---

## 7. Comparación entre métricas, logs, trazas y eventos

| Tipo | Representa | Ejemplo | Pregunta principal |
|---|---|---|---|
| Métrica | Un valor medible | CPU al 75 % | ¿Cuánto? |
| Log | Un mensaje registrado | Error de conexión | ¿Qué ocurrió? |
| Traza | El recorrido de una petición | API → base de datos | ¿Dónde se produjo la demora? |
| Evento | Una acción puntual | Reinicio de un servicio | ¿Qué cambió? |

### Ejemplo integrado

Supongamos que una aplicación responde lentamente.

#### Métricas

```text
http_request_duration_seconds: 2.4
node_load1: 5.8
node_memory_available_bytes: 524288000
```

Indican que:

- Las peticiones tardan 2,4 segundos.
- La carga del sistema es elevada.
- Queda poca memoria disponible.

#### Logs

```text
ERROR database connection timeout
```

Indican que se ha producido un problema de conexión.

#### Traza

```text
API Gateway: 20 ms
Pedidos: 250 ms
Base de datos: 2200 ms
```

Indica que la mayor parte del tiempo se consume en la base de datos.

#### Evento

```text
17:30 — Se reinicia el servicio de base de datos
```

Puede explicar el inicio de la degradación.

### Conclusión

Ningún tipo de dato proporciona por sí solo toda la información necesaria.

Una investigación completa combina:

```text
Métricas + logs + trazas + eventos
```

---

## 8. Arquitectura del laboratorio

En el entorno del curso utilizaremos principalmente esta arquitectura:

```text
Ubuntu
  │
  ├── Grafana
  ├── Prometheus
  └── Node Exporter
```

El flujo completo es:

```text
Node Exporter
      ↓
Expone métricas en /metrics
      ↓
Prometheus las recopila
      ↓
Grafana ejecuta consultas
      ↓
El usuario observa gráficos
```

---

## 9. Node Exporter

Node Exporter recopila información del sistema operativo y la expone en un formato compatible con Prometheus.

El endpoint habitual es:

```text
http://127.0.0.1:9100/metrics
```

### Comprobar el servicio

```bash
systemctl is-active node-exporter
```

Resultado esperado:

```text
active
```

### Comprobar el endpoint

```bash
curl -I http://127.0.0.1:9100/metrics
```

La respuesta esperada contiene:

```text
HTTP/1.1 200 OK
```

### Consultar las primeras métricas

```bash
curl -s http://127.0.0.1:9100/metrics | head -20
```

### Buscar métricas de CPU

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_cpu' \
  | head
```

### Buscar métricas de memoria

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_memory' \
  | head
```

### Buscar métricas de disco

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep '^node_filesystem' \
  | head
```

### Contar métricas expuestas

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep -v '^#' \
  | wc -l
```

### Actividad

Selecciona tres métricas y documenta:

```text
Nombre:
Tipo:
Valor:
Etiquetas:
Unidad:
Qué representa:
```

Ten en cuenta que no todas las métricas representan porcentajes.

Ejemplos:

```text
node_cpu_seconds_total
```

Es un contador acumulado en segundos.

```text
node_memory_MemAvailable_bytes
```

Representa memoria disponible en bytes.

```text
node_load1
```

Representa la carga media del sistema durante un minuto.

---

## 10. Prometheus

Prometheus recopila, almacena y permite consultar métricas.

### Comprobar si está preparado

```bash
curl -s http://127.0.0.1:9090/-/ready
```

Respuesta esperada:

```text
Prometheus Server is Ready.
```

### Consultar su API

```bash
curl -sG http://127.0.0.1:9090/api/v1/query \
  --data-urlencode 'query=up'
```

La consulta `up` permite comprobar si los objetivos monitorizados están disponibles.

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

## 11. Grafana

Grafana consulta las fuentes de datos y representa los resultados mediante paneles y dashboards.

Grafana permite:

- Ejecutar consultas.
- Crear gráficos.
- Crear tablas.
- Configurar dashboards.
- Analizar tendencias.
- Representar alertas.

### Comprobar el acceso

```bash
curl -I http://127.0.0.1:3000/login
```

La respuesta esperada contiene:

```text
HTTP/1.1 200 OK
```

### Configurar la fuente de datos

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

- ¿Cuánto tiempo lleva encendido el sistema?
- ¿La carga parece elevada?
- ¿Cuánta memoria está disponible?
- ¿Qué porcentaje del disco está ocupado?
- ¿Qué datos son métricas?
- ¿Qué datos son información de configuración?

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

Busca métricas concretas:

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

Documenta tres métricas con esta plantilla:

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

#### Panel 2: uso estimado de CPU

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

## 15. Práctica de investigación

### Situación

Un usuario informa:

> La aplicación responde lentamente desde hace unos minutos.

Investiga el sistema y recopila evidencias.

### Paso 1: comprobar la carga

```bash
uptime
```

### Paso 2: comprobar la memoria

```bash
free -h
```

### Paso 3: comprobar el disco

```bash
df -h
```

### Paso 4: comprobar servicios fallidos

```bash
systemctl --failed
```

### Paso 5: buscar errores recientes

```bash
sudo journalctl -p err --since "15 minutes ago" --no-pager
```

### Paso 6: consultar Node Exporter

```bash
curl -s http://127.0.0.1:9100/metrics \
  | grep -E '^node_load|^node_memory_MemAvailable_bytes|^node_filesystem_avail_bytes' \
  | head -20
```

### Informe

Completa:

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

## 16. Errores frecuentes

### Confundir una métrica con un log

Esto es una métrica:

```text
node_load1 0.84
```

Esto es un log:

```text
ERROR: unable to open configuration file
```

La métrica tiene una estructura numérica y puede representarse en una serie temporal. El log es un mensaje descriptivo.

### Interpretar un valor sin conocer su unidad

Estos valores no significan lo mismo:

```text
75
75 bytes
75 seconds
75 %
```

Antes de interpretar una métrica hay que conocer:

- Nombre.
- Unidad.
- Tipo de dato.
- Etiquetas.
- Momento de recopilación.

### Confundir estado con tendencia

Un comando puede mostrar:

```text
CPU actual: 80 %
```

Pero no sabemos si:

- Acaba de subir.
- Lleva una hora alta.
- Está descendiendo.
- Es un pico puntual.

Para conocer la tendencia necesitamos varios valores a lo largo del tiempo.

### Consultar una única fuente

Un gráfico puede mostrar que la latencia es alta, pero no explicar la causa.

Por eso conviene combinar:

```text
Métricas para medir
Logs para contextualizar
Trazas para localizar
Eventos para relacionar cambios
```

---

## 17. Puntos clave

- La telemetría recopila información sobre sistemas, aplicaciones y servicios.
- Las métricas son valores numéricos que pueden observarse a lo largo del tiempo.
- Los logs son mensajes generados por aplicaciones y servicios.
- Las trazas muestran el recorrido de una petición entre componentes.
- Los eventos representan acciones o cambios puntuales.
- Una métrica aislada ofrece menos información que una serie temporal.
- El nombre, el valor, la unidad y las etiquetas son necesarios para interpretar una métrica.
- Node Exporter expone métricas del sistema operativo.
- Prometheus recopila y almacena métricas.
- Grafana consulta y visualiza esas métricas.
- Una ausencia de datos también puede ser una señal importante.
- Un valor numérico sin contexto puede interpretarse incorrectamente.
- La investigación de un problema suele requerir combinar varias fuentes de telemetría.

---

## 18. Preguntas de comprobación

1. ¿Qué es la telemetría?
2. ¿Para qué sirve recopilar datos de un sistema?
3. ¿Qué diferencia existe entre una métrica y un log?
4. ¿Qué información proporciona una traza?
5. ¿Qué es un evento?
6. Clasifica este dato: `node_load1 0.85`.
7. Clasifica este mensaje: `ERROR: database connection timeout`.
8. ¿Qué comando permite consultar la carga media de Ubuntu?
9. ¿Qué comando permite consultar la memoria disponible?
10. ¿Qué comando permite consultar los logs del sistema?
11. ¿Qué comando permite consultar los logs de un servicio?
12. ¿Qué endpoint expone normalmente Node Exporter?
13. ¿Qué indica una respuesta HTTP `200 OK` en `/metrics`?
14. ¿Qué función cumple Prometheus?
15. ¿Qué función cumple Grafana?
16. ¿Por qué no basta con observar un único valor?
17. ¿Qué información aportan las etiquetas?
18. ¿Por qué es útil combinar métricas y logs?
19. ¿Qué puede indicar que una métrica deje de actualizarse?
20. ¿Qué investigarías si una aplicación responde lentamente?

### Soluciones orientativas

1. La recopilación y análisis de información sobre el estado y comportamiento de sistemas.
2. Para detectar problemas, observar tendencias, investigar incidentes y tomar decisiones.
3. Una métrica es un valor numérico; un log es un mensaje registrado.
4. El recorrido y la duración de una petición entre diferentes componentes.
5. Una acción o cambio ocurrido en un instante concreto.
6. Métrica.
7. Log.
8. `uptime`.
9. `free -h`.
10. `journalctl`.
11. `journalctl -u nombre-del-servicio`.
12. `http://127.0.0.1:9100/metrics`.
13. Que el endpoint responde correctamente.
14. Recopilar, almacenar y consultar métricas.
15. Consultar y visualizar datos mediante paneles y dashboards.
16. Porque no permite conocer la evolución ni detectar tendencias.
17. Identifican la serie temporal y permiten filtrar o agrupar datos.
18. Las métricas muestran la magnitud del problema y los logs aportan contexto.
19. Que el exporter, el servicio, la red o el sistema de recopilación puede tener un problema.
20. La carga, la memoria, el disco, la red, los logs, las trazas y los eventos recientes.