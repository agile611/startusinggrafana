# Problemas con las fuentes de datos

Esta página explica cómo diagnosticar y resolver los problemas más habituales relacionados con las fuentes de datos de Grafana.

Una fuente de datos permite que Grafana consulte información almacenada en otro sistema. En el laboratorio, la fuente de datos principal suele ser Prometheus:

```text
Grafana
    |
    | Consulta PromQL
    v
Prometheus
    |
    | Datos recopilados
    v
Node Exporter
```

Cuando un panel no muestra datos, el problema puede encontrarse en diferentes niveles:

```text
Panel de Grafana
        |
        v
Consulta del panel
        |
        v
Fuente de datos seleccionada
        |
        v
URL de la fuente
        |
        v
Conectividad de red
        |
        v
Servicio externo
        |
        v
Métricas o registros disponibles
```

Por este motivo, un panel vacío no significa necesariamente que Grafana esté fallando. Puede existir un problema en la consulta, en la conexión con Prometheus, en los targets o en las métricas almacenadas.

> **Advertencia:** realiza las prácticas en un entorno de laboratorio. No elimines fuentes de datos ni modifiques configuraciones de producción sin crear antes una copia de seguridad y documentar el estado inicial.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Explicar qué es una fuente de datos en Grafana.
- Identificar una fuente de datos Prometheus.
- Crear una fuente de datos en Grafana.
- Comprobar la URL de una fuente de datos.
- Utilizar **Save & test**.
- Diagnosticar errores de conexión.
- Diferenciar problemas de Grafana y Prometheus.
- Comprobar la conectividad desde el servidor de Grafana.
- Diagnosticar errores relacionados con `localhost`.
- Comprobar si Prometheus está activo.
- Comprobar si Prometheus tiene targets disponibles.
- Validar consultas PromQL.
- Identificar consultas que devuelven cero resultados.
- Diagnosticar problemas de permisos y autenticación.
- Revisar fuentes de datos provisionadas.
- Documentar una incidencia de conexión.

## Introducción

Grafana no recopila ni almacena por sí mismo las métricas de Prometheus. Grafana consulta una fuente de datos cuando un panel necesita representar información.

Una fuente de datos contiene información como:

- Tipo de sistema consultado.
- URL del servicio.
- Método de acceso.
- Configuración de autenticación.
- Opciones de conexión.
- Intervalos de consulta.
- Ajustes específicos del plugin.

En el caso de Prometheus, una configuración habitual puede utilizar:

```text
http://localhost:9090
```

Sin embargo, esta dirección solo es correcta si Prometheus se ejecuta en el mismo equipo que Grafana.

Si Grafana y Prometheus están en equipos diferentes, debe utilizarse la dirección del servidor Prometheus:

```text
http://192.168.1.20:9090
```

Este es uno de los errores más frecuentes:

```text
Grafana está en 192.168.1.10
Prometheus está en 192.168.1.20
Fuente configurada: http://localhost:9090
```

Desde Grafana, `localhost` apunta a `192.168.1.10`, no a `192.168.1.20`.

## Conceptos fundamentales

### Fuente de datos

Una fuente de datos es un sistema externo que proporciona información a Grafana.

Ejemplos:

- Prometheus.
- Loki.
- InfluxDB.
- PostgreSQL.
- MySQL.
- Elasticsearch.
- OpenSearch.
- Tempo.
- Jaeger.

### Plugin de fuente de datos

Grafana utiliza plugins para comunicarse con diferentes tecnologías.

El plugin define:

- Cómo se conecta Grafana.
- Qué tipo de consultas permite.
- Cómo interpreta las respuestas.
- Qué opciones aparecen en el editor.
- Cómo se autentica.
- Qué variables y funciones están disponibles.

### Consulta

Una consulta solicita información a la fuente de datos.

Ejemplo para Prometheus:

```promql
up
```

Otro ejemplo:

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Panel

Un panel utiliza una consulta y representa el resultado mediante una visualización.

Ejemplos de visualización:

- Time series.
- Stat.
- Gauge.
- Table.
- Bar gauge.
- Heatmap.

### Dashboard

Un dashboard agrupa varios paneles relacionados.

Todos los paneles pueden utilizar:

- La misma fuente de datos.
- Fuentes de datos diferentes.
- Variables.
- Intervalos de tiempo.
- Consultas independientes.

## Flujo de una consulta

Cuando Grafana muestra un panel, normalmente ocurre lo siguiente:

1. El usuario abre un dashboard.
2. Grafana identifica la fuente de datos del panel.
3. Grafana construye la consulta.
4. Grafana sustituye las variables.
5. Grafana envía la consulta al servicio externo.
6. Prometheus procesa la consulta PromQL.
7. Prometheus devuelve los resultados.
8. Grafana transforma los datos.
9. El panel representa la respuesta.

Si alguno de estos pasos falla, el panel puede mostrar:

```text
No data
```

```text
Error querying data source
```

```text
Bad Gateway
```

```text
Connection refused
```

```text
Timeout
```

## Fuentes de datos de Prometheus

### Configuración habitual

Una fuente Prometheus puede utilizar:

```text
Name: Prometheus
Type: Prometheus
URL: http://localhost:9090
```

### URL local

Utiliza esta URL cuando Prometheus se ejecuta en el mismo servidor que Grafana:

```text
http://localhost:9090
```

También:

```text
http://127.0.0.1:9090
```

### URL remota

Utiliza la dirección real del servidor Prometheus:

```text
http://192.168.1.20:9090
```

Con nombre DNS:

```text
http://prometheus.ejemplo.local:9090
```

### URL con HTTPS

Si Prometheus está detrás de HTTPS:

```text
https://prometheus.ejemplo.local
```

Comprueba:

- Certificado.
- Nombre DNS.
- Puerto.
- Proxy inverso.
- Reglas de firewall.
- Validación TLS.

## Crear una fuente de datos Prometheus

### Abrir la configuración

En Grafana:

1. Accede a **Connections**.
2. Selecciona **Data sources**.
3. Pulsa **Add new data source**.
4. Selecciona **Prometheus**.

### Configurar la fuente

Ejemplo:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server
```

Según la versión de Grafana, algunos nombres pueden aparecer en una ubicación ligeramente diferente.

### Probar la conexión

Pulsa:

```text
Save & test
```

Un resultado correcto indica que Grafana puede comunicarse con Prometheus.

### Comprobar el resultado

Después de guardar:

1. Abre un panel.
2. Selecciona la fuente Prometheus.
3. Abre el explorador de consultas.
4. Ejecuta:

```promql
up
```

Si aparecen resultados, la conexión básica funciona.

## Comprobar una fuente existente

### Ver las fuentes desde la interfaz

En Grafana:

1. Accede a **Connections**.
2. Selecciona **Data sources**.
3. Abre la fuente Prometheus.
4. Revisa el nombre.
5. Revisa el tipo.
6. Revisa la URL.
7. Pulsa **Save & test**.

### Buscar el nombre utilizado por un panel

Abre el panel y revisa:

```text
Data source
```

Comprueba que el panel utiliza la fuente correcta.

### Comprobar si el panel utiliza una variable de fuente

Algunos dashboards utilizan una variable como:

```text
$datasource
```

o:

```text
$prometheus
```

Consulta:

1. **Dashboard settings**.
2. **Variables**.
3. Revisa el nombre de la variable.
4. Comprueba sus valores.
5. Revisa la fuente seleccionada en el panel.

## Probar Prometheus desde el servidor de Grafana

Este paso es esencial. No basta con probar Prometheus desde el navegador del alumno.

### Comprobar el servicio de Prometheus

En el servidor Prometheus:

```bash
systemctl is-active prometheus
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Probar el endpoint local

En el servidor Prometheus:

```bash
curl -I http://localhost:9090
```

### Probar la salud de Prometheus

```bash
curl http://localhost:9090/-/healthy
```

### Probar desde el servidor de Grafana

En el servidor de Grafana:

```bash
curl -I http://DIRECCION_IP_PROMETHEUS:9090
```

Comprobar la API:

```bash
curl -s http://DIRECCION_IP_PROMETHEUS:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Interpretar las pruebas

| Resultado | Interpretación |
|---|---|
| Prometheus responde localmente | El servicio funciona en su servidor |
| Grafana no puede conectarse | Problema de red, firewall o URL |
| La API devuelve datos | La conexión y la consulta básica funcionan |
| `Connection refused` | Servicio detenido o puerto incorrecto |
| `Timeout` | Firewall, ruta o problema de red |
| `Could not resolve host` | Problema DNS |

## Problemas habituales de URL

### Error con `localhost`

Escenario:

```text
Grafana: 192.168.1.10
Prometheus: 192.168.1.20
URL configurada: http://localhost:9090
```

Desde Grafana, la URL apunta a:

```text
192.168.1.10:9090
```

La configuración correcta sería:

```text
http://192.168.1.20:9090
```

### Error de puerto

URL incorrecta:

```text
http://192.168.1.20:3000
```

Si `3000` es el puerto de Grafana y Prometheus utiliza `9090`, la URL correcta es:

```text
http://192.168.1.20:9090
```

### Error de protocolo

Si el servicio utiliza HTTP:

```text
http://prometheus.ejemplo.local:9090
```

Si utiliza HTTPS:

```text
https://prometheus.ejemplo.local
```

No intercambies ambos protocolos sin revisar el proxy y los certificados.

### Barra final

Según la versión y el tipo de proxy, estas URLs pueden comportarse de forma diferente:

```text
http://prometheus.ejemplo.local:9090
```

```text
http://prometheus.ejemplo.local:9090/
```

Utiliza el formato recomendado por la configuración del servicio y evita añadir rutas que Prometheus no utilice.

## Problemas de conectividad

### Comprobar la dirección IP

En el servidor Prometheus:

```bash
hostname -I
```

```bash
ip -br addr
```

### Comprobar la ruta

En el servidor Grafana:

```bash
ip route
```

### Probar el nombre DNS

```bash
getent hosts prometheus.ejemplo.local
```

```bash
resolvectl query prometheus.ejemplo.local
```

### Probar la conectividad IP

```bash
ping -c 4 DIRECCION_IP_PROMETHEUS
```

El ping puede estar bloqueado, por lo que una prueba fallida no demuestra por sí sola que HTTP no funcione.

### Probar el puerto

```bash
nc -vz DIRECCION_IP_PROMETHEUS 9090
```

### Probar HTTP

```bash
curl -v \
  --max-time 5 \
  http://DIRECCION_IP_PROMETHEUS:9090
```

### Probar la API

```bash
curl -v \
  --max-time 5 \
  http://DIRECCION_IP_PROMETHEUS:9090/api/v1/query \
  --data-urlencode 'query=up'
```

## Problemas de firewall

### Consultar UFW en Prometheus

```bash
sudo ufw status verbose
```

### Permitir Prometheus desde Grafana

Si Grafana está en `192.168.1.10`:

```bash
sudo ufw allow from 192.168.1.10 \
  to any port 9090 \
  proto tcp
```

### Consultar las reglas numeradas

```bash
sudo ufw status numbered
```

### Probar desde Grafana

```bash
nc -vz 192.168.1.20 9090
```

```bash
curl -I http://192.168.1.20:9090
```

### No abrir el puerto globalmente sin necesidad

Evita como solución inicial:

```bash
sudo ufw allow 9090/tcp
```

Es preferible permitir únicamente el servidor Grafana o la red de administración.

## Problemas de escucha de Prometheus

### Comprobar la dirección de escucha

En el servidor Prometheus:

```bash
sudo ss -lntp | grep ':9090'
```

### Escucha solo localmente

Si aparece:

```text
127.0.0.1:9090
```

Prometheus solo acepta conexiones locales.

Consulta los parámetros de inicio:

```bash
systemctl show prometheus \
  -p ExecStart
```

Busca:

```text
--web.listen-address
```

### Escuchar en una dirección accesible

Un ejemplo puede ser:

```text
--web.listen-address=0.0.0.0:9090
```

La configuración concreta depende del método de instalación y de la política de seguridad.

Después de modificar la unidad:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprueba:

```bash
sudo ss -lntp | grep ':9090'
```

> Escuchar en todas las interfaces no sustituye la configuración del firewall. Limita siempre los orígenes permitidos.

## Problemas de autenticación

### Prometheus sin autenticación

En un laboratorio, Prometheus puede estar disponible directamente:

```text
http://prometheus:9090
```

### Prometheus detrás de autenticación

Si existe un proxy o una capa de autenticación, Grafana puede necesitar:

- Usuario.
- Contraseña.
- Certificado.
- Token.
- Cabecera HTTP.
- Configuración TLS.

### Comprobar la autenticación con `curl`

Ejemplo conceptual:

```bash
curl -u usuario:CONTRASEÑA \
  http://prometheus.ejemplo.local/api/v1/query \
  --data-urlencode 'query=up'
```

No guardes credenciales reales en:

- Historial de shell.
- Capturas.
- Repositorios.
- Ficheros Markdown.
- Informes públicos.

### Error `401 Unauthorized`

Suele indicar:

- Falta autenticación.
- Credenciales incorrectas.
- Token caducado.
- Usuario no autorizado.

### Error `403 Forbidden`

Suele indicar:

- Las credenciales son válidas.
- El usuario no tiene permisos para esa ruta.
- Una política del proxy bloquea la solicitud.

## Problemas de TLS y certificados

### Comprobar HTTPS

```bash
curl -vk \
  https://prometheus.ejemplo.local
```

La opción `-k` omite la validación del certificado y debe utilizarse únicamente para diagnóstico controlado.

### Consultar el certificado

```bash
openssl s_client \
  -connect prometheus.ejemplo.local:443 \
  -servername prometheus.ejemplo.local
```

### Consultar las fechas del certificado

```bash
echo | openssl s_client \
  -connect prometheus.ejemplo.local:443 \
  -servername prometheus.ejemplo.local \
  2>/dev/null \
  | openssl x509 -noout -dates
```

### Problemas habituales

- Certificado caducado.
- Nombre DNS distinto del certificado.
- Certificado autofirmado.
- Cadena incompleta.
- Hora incorrecta del sistema.
- CA no instalada en el servidor de Grafana.
- Proxy configurado con un protocolo incorrecto.

## Probar la API de Prometheus

### Consulta instantánea

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Consulta con formato legible

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

### Consultar una métrica concreta

```bash
curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=node_load1' \
  | jq
```

### Consultar targets

```bash
curl -s http://localhost:9090/api/v1/targets \
  | jq
```

### Consultar etiquetas

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### Consultar nombres de métricas

```bash
curl -s \
  http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

### Interpretar una respuesta correcta

Una respuesta API correcta suele incluir:

```json
{
  "status": "success",
  "data": {}
}
```

Una consulta válida puede devolver un resultado vacío:

```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": []
  }
}
```

Esto significa que la API funciona, pero la consulta no encontró series coincidentes.

### Diferenciar error de consulta y ausencia de datos

Error de consulta:

```json
{
  "status": "error",
  "errorType": "bad_data"
}
```

Consulta válida sin resultados:

```json
{
  "status": "success",
  "data": {
    "result": []
  }
}
```

## Problemas de consultas en Grafana

### La fuente funciona, pero el panel está vacío

Comprueba en este orden:

1. La fuente seleccionada.
2. La consulta.
3. El intervalo temporal.
4. Las variables.
5. Los filtros de etiquetas.
6. La existencia de datos.
7. El estado de los targets.
8. La transformación del panel.

### Probar una consulta mínima

En el explorador de Grafana, ejecuta:

```promql
up
```

Después:

```promql
node_load1
```

Después:

```promql
node_load1{
  job="node_exporter"
}
```

### Comprobar el intervalo temporal

Una consulta puede devolver datos en:

```text
Last 6 hours
```

pero no en:

```text
Last 5 minutes
```

Comprueba:

- Rango temporal.
- Zona horaria.
- Hora del sistema.
- Retención de Prometheus.
- Momento en que comenzó el scraping.

### Comprobar las variables

Si la consulta utiliza:

```promql
up{
  instance=~"$instance"
}
```

comprueba que la variable `$instance` tenga valores.

En Grafana:

1. Abre **Dashboard settings**.
2. Selecciona **Variables**.
3. Abre `instance`.
4. Comprueba la consulta.
5. Comprueba los valores disponibles.

### Problema con variables múltiples

Para una variable de selección múltiple:

```promql
instance=~"$instance"
```

Para una variable de selección única puede utilizarse:

```promql
instance="$instance"
```

### Problema con la opción `All`

Cuando se activa **Include All option**, utiliza normalmente:

```promql
job=~"$job"
```

No utilices:

```promql
job="$job"
```

si la variable puede contener varios valores.

### Consultar la consulta generada

En el panel:

1. Abre **Edit**.
2. Revisa el editor de consultas.
3. Abre **Query inspector**.
4. Consulta la petición enviada.
5. Consulta la respuesta recibida.

## Query Inspector

Query Inspector permite analizar:

- Consulta generada.
- Variables sustituidas.
- Petición HTTP.
- Respuesta de la fuente.
- Tiempo de respuesta.
- Errores devueltos.

### Procedimiento

1. Abre el panel.
2. Selecciona **Inspect**.
3. Abre **Query** o **Query inspector**.
4. Revisa la consulta final.
5. Copia la consulta sin credenciales.
6. Comprueba el resultado.
7. Compara con la misma consulta en Prometheus.

### Qué buscar

- URL incorrecta.
- Fuente de datos incorrecta.
- Variable vacía.
- Filtro equivocado.
- Intervalo demasiado corto.
- Error HTTP.
- Respuesta vacía.
- Tiempo de espera.

## Problemas de rendimiento

### La fuente responde lentamente

Prueba la consulta directamente en Prometheus:

```bash
time curl -s http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Consultas excesivamente amplias

Una consulta como esta puede devolver muchas series:

```promql
node_cpu_seconds_total
```

Prueba con filtros:

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

O agrega:

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### Consultas con demasiados datos históricos

Reduce el rango temporal o agrega las series:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Consultas con demasiadas etiquetas

Conserva únicamente las etiquetas necesarias:

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Intervalo de consulta

Grafana puede utilizar variables integradas como:

```text
$__interval
```

```text
$__rate_interval
```

Ejemplo:

```promql
rate(
  node_cpu_seconds_total[$__rate_interval]
)
```

## Problemas de tiempo y datos recientes

### Comprobar la hora del servidor Grafana

```bash
date
```

```bash
timedatectl
```

### Comprobar la hora del servidor Prometheus

```bash
date
```

```bash
timedatectl
```

### Comprobar la sincronización NTP

```bash
timedatectl show \
  -p NTPSynchronized
```

### Síntomas de una hora incorrecta

- Paneles sin datos recientes.
- Datos desplazados en el tiempo.
- Certificados rechazados.
- Dashboards que parecen vacíos.
- Alertas que se activan tarde.

## Fuentes de datos provisionadas

Una fuente de datos puede configurarse mediante la interfaz o mediante un fichero de provisioning.

### Buscar ficheros de provisioning

```bash
sudo find /etc/grafana/provisioning \
  -type f \
  -maxdepth 3 \
  -print
```

### Buscar configuraciones de fuentes

```bash
sudo grep -R -n \
  "datasources\|Prometheus\|url:" \
  /etc/grafana/provisioning \
  2>/dev/null
```

### Ejemplo de provisioning

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
```

### Problemas de provisioning

- El fichero está en una ruta incorrecta.
- El YAML tiene una sangría incorrecta.
- El tipo de fuente no es correcto.
- La URL no es accesible.
- La fuente tiene un nombre diferente.
- El archivo no tiene permisos adecuados.
- Grafana no se ha reiniciado después del cambio.
- La fuente se crea y se sobrescribe automáticamente.

### Validar después de modificar

```bash
sudo systemctl restart grafana-server
```

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager
```

## Acceso `Server` y acceso desde el navegador

Grafana puede realizar las consultas desde diferentes ubicaciones según la configuración de la fuente.

### Acceso desde el servidor

En este modo, Grafana realiza la petición desde el servidor donde está instalado.

Ejemplo:

```text
Grafana → Prometheus
```

La URL debe ser accesible desde el servidor de Grafana.

### Acceso desde el navegador

En este modo, el navegador del usuario realiza directamente la petición.

La URL debe ser accesible desde el equipo del alumno.

### Error de ubicación

Puede ocurrir que:

```text
El navegador puede acceder a Prometheus
```

pero:

```text
El servidor Grafana no puede acceder a Prometheus
```

o al contrario.

Comprueba desde el punto exacto donde se ejecuta la petición.

## Problemas con CORS y proxy

Si la consulta se realiza desde el navegador, pueden aparecer problemas relacionados con:

- CORS.
- Certificados.
- DNS del cliente.
- Proxy corporativo.
- Rutas de red.
- Bloqueadores del navegador.

Revisa:

- Pestaña **Network**.
- Código HTTP.
- Cabeceras.
- URL solicitada.
- Mensajes de la consola.
- Método de acceso de la fuente.

## Configuración de una fuente mediante API

Las operaciones administrativas de Grafana requieren autenticación. No incluyas tokens reales en documentación.

### Consultar fuentes de datos

Ejemplo conceptual:

```bash
curl -H "Authorization: Bearer TOKEN" \
  http://localhost:3000/api/datasources
```

### Crear una fuente

Ejemplo conceptual:

```bash
curl -X POST \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "access": "proxy",
    "url": "http://localhost:9090",
    "isDefault": true
  }' \
  http://localhost:3000/api/datasources
```

Antes de utilizar una API:

- Comprueba la versión de Grafana.
- Revisa la documentación de la API.
- Utiliza un token con permisos mínimos.
- No compartas el token.
- Elimina secretos de los ejemplos.
- Revoca tokens que ya no sean necesarios.

## Diagnóstico automatizado

### Crear un script de diagnóstico

```bash
mkdir -p ~/laboratorio/fuentes-datos
cd ~/laboratorio/fuentes-datos
nano diagnostico-fuente-prometheus.sh
```

Contenido:

```bash
#!/usr/bin/env bash

set -u

PROMETHEUS_URL="${1:-http://localhost:9090}"

echo "===== DIAGNÓSTICO DE FUENTE PROMETHEUS ====="
echo "Fecha: $(date)"
echo "Equipo: $(hostname)"
echo "URL probada: ${PROMETHEUS_URL}"
echo

echo "===== SERVICIO LOCAL DE GRAFANA ====="
systemctl is-active grafana-server 2>/dev/null || true
echo

echo "===== SERVICIO LOCAL DE PROMETHEUS ====="
systemctl is-active prometheus 2>/dev/null || true
echo

echo "===== CONECTIVIDAD HTTP ====="
curl -sS \
  -o /dev/null \
  -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
  --max-time 5 \
  "${PROMETHEUS_URL}" \
  || true
echo

echo "===== SALUD DE PROMETHEUS ====="
curl -sS \
  --max-time 5 \
  "${PROMETHEUS_URL}/-/healthy" \
  || true
echo
echo

echo "===== CONSULTA UP ====="
curl -sS \
  --max-time 10 \
  "${PROMETHEUS_URL}/api/v1/query" \
  --data-urlencode 'query=up' \
  || true
echo
echo

echo "===== TARGETS ====="
curl -sS \
  --max-time 10 \
  "${PROMETHEUS_URL}/api/v1/targets" \
  || true
echo
```

### Conceder permisos

```bash
chmod +x diagnostico-fuente-prometheus.sh
```

### Ejecutar con Prometheus local

```bash
./diagnostico-fuente-prometheus.sh
```

### Ejecutar contra un servidor remoto

```bash
./diagnostico-fuente-prometheus.sh \
  http://192.168.1.20:9090
```

### Guardar el resultado

```bash
./diagnostico-fuente-prometheus.sh \
  http://192.168.1.20:9090 \
  | tee diagnostico-fuente-prometheus.txt
```

## Sesión práctica 1: crear y probar una fuente Prometheus

### Objetivo

Crear una fuente de datos y validar su conexión.

### Preparación

Comprueba que Prometheus está activo:

```bash
systemctl is-active prometheus
```

Comprueba el endpoint:

```bash
curl http://localhost:9090/-/healthy
```

### Crear la fuente

En Grafana:

1. Accede a **Connections**.
2. Selecciona **Data sources**.
3. Pulsa **Add new data source**.
4. Selecciona **Prometheus**.
5. Introduce:

```text
Name: Prometheus-Laboratorio
URL: http://localhost:9090
```

6. Pulsa **Save & test**.

### Validar con una consulta

Abre el explorador y ejecuta:

```promql
up
```

Después:

```promql
node_load1
```

### Registrar el resultado

```text
Nombre de la fuente:

Tipo:

URL:

Resultado de Save & test:

Consulta ejecutada:

Número de series:

Resultado:
```

## Sesión práctica 2: diagnosticar una URL incorrecta

### Objetivo

Comprender el problema de utilizar `localhost` desde el servidor equivocado.

### Escenario

Grafana está en:

```text
192.168.1.10
```

Prometheus está en:

```text
192.168.1.20
```

La fuente de datos utiliza:

```text
http://localhost:9090
```

### Probar en el servidor Prometheus

```bash
curl -I http://localhost:9090
```

### Probar en el servidor Grafana

```bash
curl -I http://localhost:9090
```

### Interpretar

Las dos pruebas consultan equipos diferentes:

```text
localhost en Prometheus → 192.168.1.20
localhost en Grafana → 192.168.1.10
```

### Probar la dirección correcta

Desde Grafana:

```bash
curl -I http://192.168.1.20:9090
```

### Corregir la fuente

Configura en Grafana:

```text
URL: http://192.168.1.20:9090
```

### Validar

Pulsa:

```text
Save & test
```

Después ejecuta:

```promql
up
```

### Preguntas de análisis

- ¿Desde qué equipo se ejecuta la consulta?
- ¿Qué significa `localhost` para Grafana?
- ¿Qué URL debe utilizarse?
- ¿Qué prueba demuestra que la red funciona?

## Sesión práctica 3: diagnosticar un problema de firewall

### Objetivo

Comprobar el acceso a Prometheus cuando Grafana y Prometheus están separados.

### Comprobar el firewall

En Prometheus:

```bash
sudo ufw status verbose
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9090'
```

### Probar desde Grafana

```bash
nc -vz DIRECCION_IP_PROMETHEUS 9090
```

```bash
curl -I \
  http://DIRECCION_IP_PROMETHEUS:9090
```

### Añadir una regla restringida

Sustituye la dirección por la IP real de Grafana:

```bash
sudo ufw allow from DIRECCION_IP_GRAFANA \
  to any port 9090 \
  proto tcp
```

### Validar la regla

```bash
sudo ufw status numbered
```

### Repetir la prueba

Desde Grafana:

```bash
curl -I \
  http://DIRECCION_IP_PROMETHEUS:9090
```

### Validar en Grafana

Pulsa:

```text
Save & test
```

### Preguntas de análisis

- ¿El puerto estaba en escucha?
- ¿El firewall bloqueaba la conexión?
- ¿La regla permite solo el origen necesario?
- ¿Qué riesgo tendría permitir el puerto a cualquier dirección?

## Sesión práctica 4: fuente accesible, consulta sin datos

### Objetivo

Diferenciar un problema de conexión de una consulta sin resultados.

### Crear una consulta válida

```promql
up
```

### Crear una consulta con un filtro incorrecto

```promql
up{
  job="trabajo-inexistente"
}
```

### Comparar los resultados

La primera consulta puede devolver datos:

```text
status: success
result: varias series
```

La segunda puede devolver:

```text
status: success
result: []
```

La conexión funciona, pero no existen series con ese filtro.

### Diagnosticar las etiquetas reales

```bash
curl -s http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=up' \
  | jq
```

Consultar valores de `job`:

```bash
curl -s \
  http://localhost:9090/api/v1/label/job/values \
  | jq
```

### Corregir la consulta

Utiliza un valor real:

```promql
up{
  job="node_exporter"
}
```

### Preguntas de análisis

- ¿La fuente de datos estaba funcionando?
- ¿La consulta produjo un error o un resultado vacío?
- ¿Qué diferencia existe entre ambos casos?
- ¿Cómo se obtuvieron los valores reales de `job`?

## Sesión práctica 5: utilizar Query Inspector

### Objetivo

Analizar la consulta real enviada por Grafana.

### Crear un panel

Utiliza:

```promql
up{
  instance=~"$instance"
}
```

### Abrir Query Inspector

1. Abre el panel.
2. Pulsa **Edit**.
3. Selecciona **Inspect**.
4. Abre **Query**.
5. Revisa la consulta final.
6. Comprueba la URL utilizada.
7. Comprueba las variables sustituidas.
8. Revisa el resultado HTTP.

### Buscar problemas

Comprueba si:

```text
$instance
```

ha sido sustituido por:

```text
.* 
```

o por una lista de valores.

Comprueba también si la fuente seleccionada es:

```text
Prometheus-Laboratorio
```

y no otra fuente vacía o eliminada.

### Registrar el resultado

```text
Fuente seleccionada:

Consulta original:

Consulta final:

Variable utilizada:

URL de la petición:

Código HTTP:

Número de series:

Error observado:

Corrección:
```

## Sesión práctica 6: fuente con Prometheus detenido

### Objetivo

Observar el error producido cuando el servicio externo no está disponible.

### Detener Prometheus

En el entorno de laboratorio:

```bash
sudo systemctl stop prometheus
```

### Probar el endpoint

```bash
curl -I http://localhost:9090
```

### Probar la API

```bash
curl -s \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Probar desde Grafana

En la fuente de datos:

```text
Save & test
```

### Consultar el error

Revisa:

- Mensaje de Grafana.
- Código HTTP.
- Registros de Grafana.
- Registros de Prometheus.

### Iniciar Prometheus

```bash
sudo systemctl start prometheus
```

### Validar la recuperación

```bash
curl http://localhost:9090/-/healthy
```

En Grafana:

```text
Save & test
```

Ejecuta:

```promql
up
```

### Preguntas de análisis

- ¿Qué error apareció mientras Prometheus estaba detenido?
- ¿Qué componente generó el error?
- ¿Cuánto tardó Grafana en recuperar la conexión?
- ¿La fuente tuvo que volver a configurarse?

## Sesión práctica 7: comprobar el intervalo temporal

### Objetivo

Diagnosticar un panel vacío causado por un rango temporal incorrecto.

### Consultar una métrica actual

```promql
up
```

### Consultar una métrica de rango

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

### Cambiar el intervalo de Grafana

Prueba:

```text
Last 5 minutes
```

```text
Last 1 hour
```

```text
Last 24 hours
```

### Analizar

Comprueba:

- Si existen datos recientes.
- Cuándo comenzó el scraping.
- Si el target estuvo `DOWN`.
- Si la retención contiene el intervalo seleccionado.
- Si el reloj del sistema es correcto.

### Consultar el tiempo del sistema

```bash
date
```

```bash
timedatectl
```

### Preguntas de análisis

- ¿En qué intervalo aparecen datos?
- ¿El target estuvo disponible durante todo el período?
- ¿Existe diferencia entre la hora de Grafana y la de Prometheus?
- ¿Qué consulta utiliza una ventana de cinco minutos?

## Sesión práctica 8: revisar una fuente provisionada

### Objetivo

Localizar y analizar una fuente creada mediante configuración.

### Buscar ficheros

```bash
sudo find /etc/grafana/provisioning \
  -type f \
  -print
```

### Buscar referencias a Prometheus

```bash
sudo grep -R -n \
  "prometheus\|url:" \
  /etc/grafana/provisioning \
  2>/dev/null
```

### Consultar el fichero

```bash
sudo cat \
  /etc/grafana/provisioning/datasources/*.yaml
```

### Validar la URL

Comprueba la URL desde el servidor Grafana:

```bash
curl -I http://DIRECCION_IP_PROMETHEUS:9090
```

### Reiniciar Grafana

```bash
sudo systemctl restart grafana-server
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager
```

### Validar en la interfaz

1. Accede a **Data sources**.
2. Localiza la fuente.
3. Comprueba su nombre.
4. Comprueba su URL.
5. Ejecuta **Save & test**.

## Sesión práctica 9: comprobar varias fuentes

### Objetivo

Comparar una fuente válida con una fuente mal configurada.

### Crear una fuente válida

```text
Name: Prometheus-Correcto
URL: http://localhost:9090
```

### Crear una fuente incorrecta de laboratorio

```text
Name: Prometheus-Incorrecto
URL: http://localhost:9999
```

### Probar ambas

Utiliza:

```text
Save & test
```

### Crear un panel

Selecciona primero:

```text
Prometheus-Correcto
```

Consulta:

```promql
up
```

Después selecciona:

```text
Prometheus-Incorrecto
```

Observa el mensaje.

### Comparar

```text
Fuente:

URL:

Puerto:

Resultado:

Mensaje:
```

### Eliminar la fuente incorrecta

Elimina únicamente la fuente creada para la práctica.

## Diagnóstico de errores habituales

### `Bad Gateway`

Posibles causas:

- Grafana utiliza un proxy.
- El backend no responde.
- La URL apunta al puerto equivocado.
- Prometheus está detenido.
- El proxy no puede resolver el nombre.
- Existe un problema de HTTP y HTTPS.

Pruebas:

```bash
curl -I http://DIRECCION_IP_PROMETHEUS:9090
```

```bash
systemctl is-active prometheus
```

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager
```

### `Connection refused`

Posibles causas:

- Prometheus está detenido.
- No hay ningún proceso en el puerto.
- El puerto es incorrecto.
- La dirección apunta al equipo equivocado.

Pruebas:

```bash
sudo ss -lntp | grep ':9090'
```

```bash
systemctl status prometheus
```

### `Connection timed out`

Posibles causas:

- Firewall.
- Ruta incorrecta.
- Servicio remoto inaccesible.
- Red caída.
- Prometheus escucha solo localmente.

Pruebas:

```bash
ip route
```

```bash
nc -vz DIRECCION_IP_PROMETHEUS 9090
```

```bash
sudo ufw status verbose
```

### `401 Unauthorized`

Posibles causas:

- Faltan credenciales.
- Usuario incorrecto.
- Contraseña incorrecta.
- Token inválido.
- Proxy de autenticación.

### `403 Forbidden`

Posibles causas:

- Usuario sin permisos.
- Ruta restringida.
- Política del proxy.
- Autenticación válida, pero autorización insuficiente.

### `404 Not Found`

Posibles causas:

- URL incorrecta.
- Ruta adicional incorrecta.
- Proxy configurado con una subruta.
- Endpoint no disponible en ese servicio.

### `No data`

Posibles causas:

- No existen series coincidentes.
- Intervalo temporal incorrecto.
- Target `DOWN`.
- Filtro de etiquetas incorrecto.
- Variable vacía.
- Métrica inexistente.
- Consulta mal construida.

## Lista de comprobación de una fuente Prometheus

```text
[ ] La fuente existe en Grafana.
[ ] El tipo es Prometheus.
[ ] El nombre es correcto.
[ ] La URL es correcta.
[ ] El protocolo es correcto.
[ ] El puerto es correcto.
[ ] La URL es accesible desde Grafana.
[ ] Prometheus está activo.
[ ] Prometheus escucha en la dirección adecuada.
[ ] El firewall permite el acceso.
[ ] Save & test funciona.
[ ] La consulta up devuelve resultados.
[ ] Los targets están disponibles.
[ ] El panel utiliza la fuente correcta.
[ ] Las variables tienen valores.
[ ] El intervalo temporal es adecuado.
[ ] La consulta no contiene filtros incorrectos.
[ ] Query Inspector no muestra errores.
```

## Buenas prácticas

- Utiliza nombres descriptivos para las fuentes.
- Define una fuente predeterminada cuando corresponda.
- Evita crear varias fuentes idénticas sin necesidad.
- Comprueba la URL desde el servidor de Grafana.
- No utilices `localhost` para referirte a otro servidor.
- Limita el acceso mediante firewall.
- No guardes credenciales en capturas ni documentación.
- Utiliza el método de acceso adecuado.
- Valida la fuente con **Save & test**.
- Prueba primero con la consulta `up`.
- Comprueba los targets antes de investigar el panel.
- Utiliza Query Inspector para revisar la petición real.
- Comprueba las variables del dashboard.
- Diferencia una respuesta vacía de un error de conexión.
- Revisa el rango temporal.
- Comprueba la hora de los servidores.
- Documenta las fuentes provisionadas.
- Realiza copias de seguridad antes de editar provisioning.
- No elimines una fuente utilizada por muchos dashboards sin analizar el impacto.
- Utiliza tokens con permisos mínimos cuando sea necesario.
- Revoca credenciales que ya no se utilicen.

## Tabla de síntomas y comprobaciones

| Síntoma | Primera prueba | Posible causa |
|---|---|---|
| `Save & test` falla | `curl` desde Grafana | URL, red o servicio |
| `Connection refused` | `ss` en Prometheus | Servicio detenido o puerto incorrecto |
| `Connection timed out` | `nc` y firewall | Red o firewall |
| `Bad Gateway` | Backend directo | Proxy o URL |
| `401 Unauthorized` | Configuración de autenticación | Credenciales |
| `403 Forbidden` | Permisos del usuario | Autorización |
| `404 Not Found` | URL completa | Ruta incorrecta |
| `No data` | Consulta `up` | Consulta o filtros |
| Panel vacío | Query Inspector | Variables o intervalo |
| Fuente desaparece | Provisioning | Configuración automática |
| Consulta lenta | `time curl` | Consulta costosa o demasiados datos |
| Datos antiguos | Hora y targets | Scraping o reloj |

## Puntos clave

- Una fuente de datos permite a Grafana consultar sistemas externos.
- Prometheus es una fuente de datos habitual para métricas.
- La URL debe ser accesible desde el equipo que realiza la consulta.
- `localhost` hace referencia al equipo desde el que se ejecuta la petición.
- `Save & test` comprueba la conexión básica de una fuente.
- Una fuente accesible puede devolver cero resultados si la consulta no coincide con ninguna serie.
- `Connection refused` y `Connection timed out` indican problemas diferentes.
- Grafana y Prometheus pueden ejecutarse en equipos distintos.
- El firewall debe permitir únicamente el tráfico necesario.
- La consulta `up` es una prueba inicial muy útil.
- El estado de los targets debe comprobarse antes de investigar un panel vacío.
- Query Inspector muestra la petición real enviada por Grafana.
- Las variables pueden generar consultas vacías o incorrectas.
- El intervalo temporal puede ocultar datos existentes.
- Los dashboards pueden utilizar fuentes de datos fijas o variables.
- Las fuentes provisionadas pueden sobrescribir cambios manuales.
- Las credenciales y tokens deben mantenerse fuera de la documentación pública.
- Toda incidencia debe incluir URL, pruebas, error, causa y validación.
- La solución debe probarse desde el servidor de Grafana, no solo desde el navegador.
- Una fuente correcta no garantiza que todas las consultas del dashboard sean correctas.

## Preguntas de comprobación

1. ¿Qué es una fuente de datos en Grafana?
2. ¿Qué función cumple una fuente Prometheus?
3. ¿Por qué `localhost` puede provocar un error cuando Grafana y Prometheus están en equipos diferentes?
4. ¿Qué diferencia existe entre una fuente inaccesible y una consulta sin resultados?
5. ¿Qué función cumple **Save & test**?
6. ¿Qué comando permite probar Prometheus desde el servidor de Grafana?
7. ¿Qué comando permite comprobar si el puerto `9090` está en escucha?
8. ¿Qué significa el error `Connection refused`?
9. ¿Qué causas pueden producir un `Connection timed out`?
10. ¿Qué diferencia existe entre los errores HTTP `401` y `403`?
11. ¿Qué comprobarías ante un error `502 Bad Gateway`?
12. ¿Qué consulta PromQL utilizarías como primera prueba?
13. ¿Qué información proporciona Query Inspector?
14. ¿Por qué una variable múltiple suele utilizar `=~`?
15. ¿Qué puede causar que un panel muestre `No data`?
16. ¿Qué diferencia existe entre el acceso desde el servidor y el acceso desde el navegador?
17. ¿Qué es una fuente provisionada?
18. ¿Por qué no deben guardarse tokens en los informes?
19. ¿Qué comprobarías si `Save & test` funciona, pero el panel está vacío?
20. ¿Qué información debe incluir un informe sobre una fuente de datos?

## Actividad final

Completa la siguiente actividad en el entorno de laboratorio:

1. Comprueba que Prometheus está activo.
2. Comprueba el puerto `9090`.
3. Comprueba el endpoint `/-/healthy`.
4. Crea una fuente de datos Prometheus.
5. Utiliza un nombre descriptivo.
6. Ejecuta **Save & test**.
7. Crea un panel con la consulta:

```promql
up
```

8. Crea un panel con la consulta:

```promql
node_load1
```

9. Crea una variable `instance`.
10. Utiliza la variable en una consulta:

```promql
up{
  instance=~"$instance"
}
```

11. Abre Query Inspector.
12. Revisa la consulta generada.
13. Crea una fuente incorrecta en un entorno de laboratorio.
14. Documenta el error obtenido.
15. Detén Prometheus de forma controlada.
16. Repite **Save & test**.
17. Observa el error.
18. Inicia Prometheus.
19. Valida de nuevo la fuente.
20. Comprueba que los paneles vuelven a mostrar datos.
21. Revisa los targets de Prometheus.
22. Genera un informe técnico.