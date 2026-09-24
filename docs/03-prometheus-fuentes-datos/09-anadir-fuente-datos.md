# Añadir una fuente de datos en Grafana

Grafana necesita una fuente de datos para consultar y representar la información almacenada en sistemas externos.

En este laboratorio se añadirá Prometheus como fuente de datos de Grafana. De esta forma, Grafana podrá ejecutar consultas PromQL y utilizar sus resultados en paneles y dashboards.

El flujo será:

```text
Node Exporter
      |
      v
Prometheus
      |
      | Consultas PromQL
      v
Grafana
      |
      v
Paneles y dashboards
```

La configuración final será:

```text
Grafana    http://localhost:3000
Prometheus http://localhost:9090
```

---

## Objetivos

Al finalizar esta práctica, el alumno podrá:

- Explicar qué es una fuente de datos.
- Identificar la función de Prometheus dentro de Grafana.
- Acceder al menú de fuentes de datos.
- Añadir Prometheus como fuente de datos.
- Configurar correctamente la URL de Prometheus.
- Diferenciar entre `localhost` del navegador y `localhost` del servidor Grafana.
- Probar la conexión entre Grafana y Prometheus.
- Interpretar los errores habituales de conexión.
- Ejecutar una consulta PromQL desde Grafana.
- Comprobar que Grafana recibe datos de Prometheus.
- Definir una fuente de datos predeterminada.
- Consultar la configuración mediante la API de Grafana.
- Utilizar el aprovisionamiento mediante ficheros YAML.
- Documentar las evidencias de la configuración.

---

## Introducción

Una fuente de datos es un sistema externo al que Grafana se conecta para consultar información.

Ejemplos de fuentes de datos compatibles con Grafana:

- Prometheus.
- Loki.
- InfluxDB.
- Elasticsearch.
- MySQL.
- PostgreSQL.
- Tempo.
- OpenSearch.
- Azure Monitor.
- CloudWatch.

En este curso se utilizará Prometheus.

Prometheus almacena las métricas y ejecuta las consultas PromQL. Grafana utiliza esas consultas para mostrar los resultados en:

- Paneles.
- Gráficos.
- Tablas.
- Estadísticas.
- Indicadores.
- Dashboards.
- Alertas.

Grafana no copia normalmente todas las métricas de Prometheus. Cuando un usuario abre un dashboard, Grafana consulta la fuente de datos y representa el resultado.

---

# Requisitos previos

Antes de comenzar, deben estar activos Grafana y Prometheus.

## Comprobar Prometheus

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

Comprobar el endpoint de salud:

```bash
curl http://localhost:9090/-/healthy
```

Resultado esperado:

```text
Prometheus is Healthy.
```

Comprobar que Prometheus responde a una consulta:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

## Comprobar Grafana

```bash
systemctl is-active grafana-server
```

Resultado esperado:

```text
active
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':3000'
```

Probar la API de Grafana:

```bash
curl -I http://localhost:3000/api/health
```

Consultar el estado:

```bash
curl -s http://localhost:3000/api/health
```

Resultado conceptual:

```json
{
  "commit": "...",
  "database": "ok",
  "version": "..."
}
```

---

# Conceptos fundamentales

## ¿Qué es una fuente de datos?

Una fuente de datos es una conexión configurada en Grafana para consultar un sistema externo.

En este laboratorio:

```text
Nombre: Prometheus
Tipo: Prometheus
URL: http://localhost:9090
```

## ¿Qué es una URL de fuente de datos?

Es la dirección que Grafana utilizará para conectarse con Prometheus.

Ejemplo:

```text
http://localhost:9090
```

La URL debe ser accesible **desde el servidor o contenedor donde se ejecuta Grafana**.

## ¿Qué es una fuente de datos predeterminada?

Es la fuente que Grafana selecciona automáticamente cuando se crea un panel nuevo.

En este laboratorio se configurará Prometheus como fuente predeterminada.

## ¿Qué protocolo utiliza Grafana?

Grafana consulta Prometheus mediante HTTP o HTTPS utilizando la API de Prometheus.

Ejemplo conceptual:

```text
Grafana
   |
   | HTTP API
   v
Prometheus
   |
   | Resultado PromQL
   v
Grafana
```

---

# Acceder a Grafana

Abrir un navegador y acceder a:

```text
http://localhost:3000
```

Si Grafana está instalado en otro servidor:

```text
http://<IP-DEL-SERVIDOR>:3000
```

Ejemplo:

```text
http://192.168.1.50:3000
```

Iniciar sesión con la cuenta de administración definida durante la instalación.

> En un entorno real no se deben utilizar credenciales por defecto. Después del primer acceso se debe establecer una contraseña segura.

---

# Ubicación del menú de fuentes de datos

Según la versión y el diseño de Grafana, la opción puede encontrarse en:

```text
Connections → Data sources
```

o en:

```text
Configuration → Data sources
```

El recorrido habitual es:

```text
Grafana
   |
   v
Connections
   |
   v
Data sources
   |
   v
Add new data source
```

Seleccionar:

```text
Prometheus
```

---

# Añadir Prometheus mediante la interfaz web

## Paso 1: abrir las fuentes de datos

1. Acceder a Grafana.
2. Abrir el menú principal.
3. Entrar en **Connections**.
4. Seleccionar **Data sources**.
5. Pulsar **Add new data source**.

## Paso 2: seleccionar Prometheus

Buscar:

```text
Prometheus
```

Seleccionar el tipo de fuente.

## Paso 3: configurar la URL

En el campo **Prometheus server URL**, introducir:

```text
http://localhost:9090
```

La configuración mínima será:

| Campo | Valor |
|---|---|
| Name | `Prometheus` |
| Type | `Prometheus |
| URL | `http://localhost:9090` |
| Access | `Server` |
| Default | Activado |

## Paso 4: guardar y probar

Pulsar:

```text
Save & test
```

Resultado esperado:

```text
Successfully queried the Prometheus API.
```

El texto puede variar ligeramente según la versión de Grafana, pero debe indicar que la conexión se ha realizado correctamente.

---

# Configuración de acceso

Grafana puede conectarse a una fuente de datos utilizando diferentes modos de acceso.

## Server

En este modo, Grafana realiza la conexión desde el servidor donde se ejecuta.

Es el modo recomendado para esta práctica:

```text
Access: Server
```

Flujo:

```text
Navegador
    |
    v
Grafana
    |
    v
Prometheus
```

## Browser

En este modo, algunas peticiones pueden realizarse desde el navegador del usuario.

Puede provocar problemas relacionados con:

- CORS.
- Resolución de nombres.
- Redes privadas.
- Direcciones no accesibles desde el equipo del alumno.

Para el laboratorio se utilizará:

```text
Access: Server
```

---

# La importancia de `localhost`

`localhost` siempre hace referencia al equipo que realiza la conexión.

## Caso 1: Grafana y Prometheus en el mismo servidor

Esta configuración es correcta:

```text
http://localhost:9090
```

El flujo es:

```text
Grafana ───> localhost:9090 ───> Prometheus
```

## Caso 2: Grafana y Prometheus en servidores diferentes

Si Grafana está en `grafana-01` y Prometheus en `prometheus-01`, esta configuración puede ser incorrecta:

```text
http://localhost:9090
```

Grafana intentará conectarse al puerto `9090` de `grafana-01`.

La configuración correcta sería, por ejemplo:

```text
http://prometheus-01:9090
```

o:

```text
http://192.168.1.50:9090
```

## Caso 3: Grafana y Prometheus en contenedores

Si ambos servicios están en la misma red Docker, normalmente se utiliza el nombre del servicio:

```text
http://prometheus:9090
```

No utilizar necesariamente:

```text
http://localhost:9090
```

Dentro de un contenedor, `localhost` hace referencia al propio contenedor.

---

# Configuración recomendada según el entorno

| Entorno | URL habitual |
|---|---|
| Mismo servidor físico o virtual | `http://localhost:9090` |
| Prometheus en otro servidor | `http://IP:9090` |
| Resolución DNS disponible | `http://prometheus.example.local:9090` |
| Docker Compose | `http://prometheus:9090` |
| Kubernetes | URL del Service de Prometheus |
| HTTPS con proxy | `https://prometheus.example.local` |

La URL correcta depende de dónde se ejecuten Grafana y Prometheus.

---

# Opciones de configuración de Prometheus

La fuente de datos de Prometheus puede incluir opciones adicionales.

## HTTP method

Normalmente se utiliza:

```text
POST
```

Grafana puede utilizar peticiones GET o POST según la consulta y la versión.

## Scrape interval

Grafana puede utilizar un intervalo mínimo relacionado con el intervalo de scraping de Prometheus.

Ejemplo:

```text
Scrape interval: 15s
```

Esto no cambia el intervalo con el que Prometheus recopila métricas. Solo ayuda a que Grafana construya consultas temporales coherentes.

## Query timeout

Define cuánto tiempo puede esperar Grafana por una respuesta de Prometheus.

Ejemplo:

```text
Query timeout: 60s
```

Un tiempo de espera excesivo puede ocultar problemas de rendimiento. Un tiempo demasiado pequeño puede provocar errores en consultas complejas.

## Prometheus type

Según la versión de Grafana, puede aparecer una opción para indicar el tipo o versión de Prometheus.

Seleccionar la opción compatible con la instalación del laboratorio.

## Default

Activar:

```text
Set as default
```

Esto hará que Prometheus aparezca seleccionado automáticamente al crear un panel.

---

# Probar la fuente de datos

Después de pulsar **Save & test**, Grafana debe comprobar la conectividad.

La prueba verifica generalmente:

- Que la URL tiene un formato válido.
- Que Grafana puede resolver el nombre.
- Que el puerto está accesible.
- Que Prometheus responde.
- Que la API devuelve una respuesta válida.
- Que la fuente de datos puede realizar consultas.

Una prueba correcta indica que Grafana puede comunicarse con Prometheus, pero no garantiza que todos los paneles estén bien configurados.

---

# Crear un panel de prueba

Después de añadir la fuente de datos:

1. Abrir el menú **Dashboards**.
2. Crear un dashboard nuevo.
3. Añadir un panel.
4. Seleccionar la fuente de datos `Prometheus`.
5. Introducir una consulta.

Consulta de prueba:

```promql
up
```

Resultado esperado:

- Aparece una serie para Prometheus.
- Aparece una serie para Node Exporter, si está configurado.
- El valor normal es `1`.

## Probar una métrica de memoria

```promql
node_memory_MemAvailable_bytes
```

## Probar el uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Probar la carga del sistema

```promql
node_load1
```

---

# Configurar un panel de disponibilidad

Utilizar la consulta:

```promql
up
```

Configurar el panel como:

```text
Visualization: Stat
```

O como:

```text
Visualization: Table
```

Interpretación:

| Valor | Estado |
|---:|---|
| `1` | Objetivo disponible |
| `0` | Objetivo no disponible |

Para mostrar únicamente Node Exporter:

```promql
up{job="node_exporter"}
```

Para mostrar el número de objetivos disponibles:

```promql
sum(up)
```

Para mostrar el porcentaje de disponibilidad:

```promql
100 * avg(up)
```

---

# Consultar los paneles y las fuentes de datos

## Mostrar la fuente de datos en el panel

Cada panel debe tener seleccionada una fuente de datos.

Comprobar:

```text
Data source: Prometheus
```

## Consultar el inspector del panel

Grafana dispone de un inspector que permite revisar:

- Consulta enviada.
- Respuesta recibida.
- Tiempo de respuesta.
- Errores.
- Datos transformados.
- Series devueltas.

Abrir el inspector desde el panel y revisar la pestaña de consulta o datos.

Esta función resulta útil para distinguir entre:

- Error de conexión.
- Consulta incorrecta.
- Consulta sin resultados.
- Problema de visualización.
- Problema de unidades.

---

# Administrar la fuente de datos

Desde la página de fuentes de datos se pueden realizar acciones como:

- Editar la configuración.
- Probar la conexión.
- Cambiar el nombre.
- Establecerla como predeterminada.
- Consultar el UID.
- Eliminar la fuente de datos.

> Eliminar una fuente de datos puede dejar dashboards sin conexión. Antes de eliminarla se deben revisar los dashboards que la utilizan.

---

# Identificador y UID

Grafana asigna identificadores internos a las fuentes de datos.

El nombre visible puede ser:

```text
Prometheus
```

El UID puede ser similar a:

```text
prometheus
```

El UID se utiliza en:

- Dashboards.
- Paneles.
- Provisioning.
- API de Grafana.
- Ficheros JSON exportados.

Para evitar referencias frágiles, se recomienda definir un UID estable cuando se utiliza aprovisionamiento:

```yaml
uid: prometheus
```

---

# Añadir la fuente de datos mediante provisioning

Grafana permite crear fuentes de datos automáticamente mediante un fichero YAML.

Esta opción es útil para:

- Laboratorios reproducibles.
- Automatización.
- Contenedores.
- Infraestructura como código.
- Recuperación de instalaciones.
- Entornos de pruebas.
- Configuraciones homogéneas.

## Crear el directorio

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

## Crear el fichero YAML

```bash
sudo tee /etc/grafana/provisioning/datasources/prometheus.yml > /dev/null <<'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
EOF
```

## Reiniciar Grafana

```bash
sudo systemctl restart grafana-server
```

Comprobar:

```bash
systemctl is-active grafana-server
```

Acceder a:

```text
Connections → Data sources
```

La fuente `Prometheus` debe aparecer creada.

## Explicación del fichero

| Propiedad | Función |
|---|---|
| `apiVersion` | Versión del formato de provisioning |
| `name` | Nombre visible en Grafana |
| `uid` | Identificador estable |
| `type` | Tipo de fuente |
| `access` | Forma de acceso |
| `url` | URL de Prometheus |
| `isDefault` | Establece la fuente como predeterminada |
| `editable` | Permite modificarla desde la interfaz |

## Provisioning para Docker Compose

Si Grafana se ejecuta en Docker y Prometheus tiene el nombre de servicio `prometheus`:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
```

La URL depende de la red donde se encuentren los contenedores.

---

# Añadir la fuente de datos mediante la API

Grafana proporciona una API HTTP para gestionar fuentes de datos.

El endpoint habitual es:

```text
/api/datasources
```

## Crear una fuente de datos

Ejemplo conceptual:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  http://localhost:3000/api/datasources \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "access": "proxy",
    "url": "http://localhost:9090",
    "isDefault": true,
    "uid": "prometheus"
  }'
```

Sustituir:

```text
<TOKEN>
```

por un token válido de Grafana.

> No guardar tokens en scripts públicos ni en repositorios. Utilizar variables de entorno o un sistema seguro de gestión de secretos.

## Consultar las fuentes existentes

```bash
curl \
  -H "Authorization: Bearer <TOKEN>" \
  http://localhost:3000/api/datasources
```

Mostrar con formato legible:

```bash
curl -s \
  -H "Authorization: Bearer <TOKEN>" \
  http://localhost:3000/api/datasources \
  | jq
```

## Consultar una fuente por UID

```bash
curl -s \
  -H "Authorization: Bearer <TOKEN>" \
  http://localhost:3000/api/datasources/uid/prometheus \
  | jq
```

## Probar una fuente mediante la API

La ruta exacta puede variar según la versión de Grafana. Para tareas administrativas es preferible utilizar la interfaz, el provisioning o la documentación de la API de la versión instalada.

---

# Permisos y credenciales

Para consultar Prometheus localmente, la fuente puede no necesitar credenciales si Prometheus no tiene autenticación configurada.

En entornos protegidos pueden ser necesarios:

- Usuario y contraseña.
- Token Bearer.
- Certificado de cliente.
- CA personalizada.
- Verificación TLS.
- Proxy inverso.
- Cabeceras HTTP adicionales.

## No guardar secretos en el fichero de provisioning

Evitar configuraciones como:

```yaml
basicAuthPassword: contraseña-secreta
```

en ficheros accesibles por usuarios no autorizados.

Utilizar:

- Variables de entorno.
- Secretos de Docker.
- Secretos de Kubernetes.
- Vault.
- Gestores de credenciales.
- Permisos restrictivos.

## Permisos del fichero

Comprobar:

```bash
sudo stat \
  -c '%A %U:%G %n' \
  /etc/grafana/provisioning/datasources/prometheus.yml
```

---

# Configuración con HTTPS

Si Prometheus está detrás de HTTPS:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus
    type: prometheus
    access: proxy
    url: https://prometheus.example.local
    isDefault: true
```

Si utiliza un certificado interno, puede ser necesario configurar una CA.

No se recomienda desactivar la verificación TLS en producción. En un laboratorio controlado puede existir una opción equivalente a:

```text
Skip TLS verify
```

Debe utilizarse únicamente para prácticas concretas y documentarse claramente.

---

# Diagnóstico de problemas

## Error: connection refused

Síntoma habitual:

```text
connection refused
```

Comprobar Prometheus:

```bash
systemctl is-active prometheus
```

Comprobar el puerto:

```bash
sudo ss -lntp | grep ':9090'
```

Probar desde el servidor de Grafana:

```bash
curl http://localhost:9090/-/healthy
```

Posibles causas:

- Prometheus está detenido.
- El puerto es incorrecto.
- La URL utiliza una dirección equivocada.
- Grafana y Prometheus están en servidores distintos.
- El firewall bloquea el acceso.
- Los contenedores no comparten red.

## Error: no route to host

Posibles causas:

- Falta de conectividad.
- Ruta de red incorrecta.
- Servidor apagado.
- Red virtual mal configurada.
- Firewall.
- Dirección IP incorrecta.

Probar:

```bash
ping <IP-DE-PROMETHEUS>
```

Comprobar la ruta:

```bash
ip route
```

Probar el puerto:

```bash
nc -vz <IP-DE-PROMETHEUS> 9090
```

## Error: DNS

Comprobar la resolución:

```bash
getent hosts prometheus.example.local
```

Si no hay resultado, utilizar temporalmente la dirección IP o corregir el DNS.

## Error al utilizar `localhost`

Si Grafana está en un contenedor:

```text
http://localhost:9090
```

apunta al propio contenedor de Grafana.

Usar el nombre del servicio:

```text
http://prometheus:9090
```

## La fuente se conecta, pero no devuelve datos

La conexión puede ser correcta aunque la consulta no tenga resultados.

Probar en Grafana:

```promql
up
```

Después:

```promql
prometheus_build_info
```

Y finalmente:

```promql
node_memory_MemAvailable_bytes
```

Comprobar directamente Prometheus:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

Posibles causas:

- Prometheus no tiene objetivos activos.
- Node Exporter está detenido.
- La métrica no existe.
- El rango temporal es incorrecto.
- El panel utiliza una fuente de datos distinta.
- La consulta contiene un filtro incorrecto.

## Error de permisos o autenticación

Comprobar:

- Usuario utilizado.
- Contraseña.
- Token.
- Certificados.
- Cabeceras.
- Proxy.
- Configuración de Prometheus.
- Registros de Grafana.

Consultar los registros:

```bash
sudo journalctl -u grafana-server \
  --no-pager \
  -n 100
```

## La fuente aparece duplicada

Puede haberse creado:

- Desde la interfaz web.
- Mediante provisioning.
- Mediante la API.
- Durante una restauración.

Consultar las fuentes configuradas desde la interfaz o la API.

Revisar:

```bash
sudo find /etc/grafana/provisioning/datasources \
  -type f \
  -maxdepth 1 \
  -print
```

---

# Consultar los registros de Grafana

Ver los últimos registros:

```bash
sudo journalctl -u grafana-server \
  --no-pager \
  -n 100
```

Seguir los registros:

```bash
sudo journalctl -u grafana-server -f
```

Consultar errores:

```bash
sudo journalctl -u grafana-server \
  -p err \
  --no-pager
```

Consultar los registros recientes:

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

Los registros pueden mostrar:

- Errores de provisioning.
- Fallos de conexión.
- Problemas de autenticación.
- Errores de consulta.
- Problemas de base de datos.
- Errores de plugins.
- Fallos de configuración.

---

# Sesiones prácticas

## Sesión 1: comprobar los servicios

### Objetivo

Verificar que Grafana y Prometheus están disponibles antes de crear la fuente.

### Comandos

```bash
systemctl is-active prometheus
```

```bash
systemctl is-active grafana-server
```

```bash
curl http://localhost:9090/-/healthy
```

```bash
curl -s http://localhost:3000/api/health | jq
```

### Actividades

1. Comprueba el estado de Prometheus.
2. Comprueba el estado de Grafana.
3. Comprueba el endpoint de salud de Prometheus.
4. Consulta la API de salud de Grafana.
5. Comprueba que el puerto `9090` está disponible.
6. Comprueba que el puerto `3000` está disponible.

---

## Sesión 2: añadir Prometheus desde la interfaz

### Objetivo

Crear una fuente de datos de forma manual.

### Pasos

1. Abrir:

```text
http://localhost:3000
```

2. Acceder a **Connections**.
3. Entrar en **Data sources**.
4. Pulsar **Add new data source**.
5. Seleccionar **Prometheus**.
6. Introducir:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server
```

7. Activar la opción de fuente predeterminada.
8. Pulsar **Save & test**.

### Resultado esperado

Grafana debe mostrar un mensaje indicando que la conexión se ha realizado correctamente.

### Actividades

1. Anota el nombre asignado a la fuente.
2. Anota la URL configurada.
3. Comprueba si se ha establecido como predeterminada.
4. Consulta el UID generado.
5. Captura la pantalla de confirmación.

---

## Sesión 3: crear un panel de prueba

### Objetivo

Comprobar que Grafana puede ejecutar consultas PromQL.

### Pasos

1. Abrir **Dashboards**.
2. Crear un dashboard nuevo.
3. Añadir un panel.
4. Seleccionar la fuente `Prometheus`.
5. Ejecutar:

```promql
up
```

6. Seleccionar una visualización de tipo tabla.
7. Guardar el panel.

### Consultas adicionales

```promql
prometheus_build_info
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_load1
```

### Actividades

1. Ejecuta las consultas.
2. Comprueba que devuelven resultados.
3. Cambia la visualización a gráfico.
4. Comprueba las etiquetas.
5. Anota qué consultas devuelven datos.

---

## Sesión 4: distinguir un error de conexión de un error de consulta

### Objetivo

Diferenciar entre problemas de conectividad y problemas de PromQL.

### Prueba 1: consulta correcta

```promql
up
```

### Prueba 2: consulta de una métrica inexistente

```promql
metrica_que_no_existe
```

Esta consulta puede devolver un resultado vacío sin que exista un problema de conexión.

### Prueba 3: URL incorrecta

Editar temporalmente la fuente y cambiar:

```text
http://localhost:9090
```

por:

```text
http://localhost:9999
```

Pulsar **Save & test**.

### Actividades

1. Ejecuta una consulta correcta.
2. Ejecuta una consulta de una métrica inexistente.
3. Cambia temporalmente el puerto.
4. Compara los mensajes mostrados.
5. Restaura la URL correcta.
6. Vuelve a probar la conexión.

---

## Sesión 5: analizar el caso de servidores separados

### Objetivo

Comprender el significado de `localhost`.

### Escenario

```text
Grafana:    192.168.1.40
Prometheus: 192.168.1.50
```

### Configuración incorrecta

```text
http://localhost:9090
```

### Configuración correcta

```text
http://192.168.1.50:9090
```

### Comprobar desde el servidor de Grafana

```bash
curl http://192.168.1.50:9090/-/healthy
```

### Actividades

1. Identifica dónde se ejecuta Grafana.
2. Identifica dónde se ejecuta Prometheus.
3. Explica a qué equipo apunta `localhost`.
4. Configura la URL correcta.
5. Ejecuta **Save & test**.
6. Comprueba que el panel puede consultar `up`.

---

## Sesión 6: configurar mediante provisioning

### Objetivo

Crear la fuente de datos automáticamente mediante YAML.

### Crear el fichero

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

```bash
sudo tee /etc/grafana/provisioning/datasources/prometheus.yml > /dev/null <<'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    uid: prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
EOF
```

Reiniciar Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprobar:

```bash
systemctl is-active grafana-server
```

### Actividades

1. Crea el fichero de provisioning.
2. Reinicia Grafana.
3. Accede a la lista de fuentes de datos.
4. Comprueba que Prometheus aparece configurado.
5. Comprueba su UID.
6. Ejecuta un panel con la consulta `up`.
7. Consulta los registros de Grafana.

---

## Sesión 7: consultar la fuente mediante la API

### Objetivo

Identificar la fuente de datos mediante la API de Grafana.

> Esta actividad requiere un token con permisos suficientes.

Definir el token en una variable:

```bash
export GRAFANA_TOKEN="REEMPLAZAR_POR_UN_TOKEN"
```

Consultar las fuentes:

```bash
curl -s \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/datasources \
  | jq
```

Consultar la fuente por UID:

```bash
curl -s \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/datasources/uid/prometheus \
  | jq
```

### Actividades

1. Consulta las fuentes configuradas.
2. Identifica el nombre.
3. Identifica el tipo.
4. Identifica la URL.
5. Identifica el UID.
6. Comprueba si es la fuente predeterminada.
7. Elimina la variable al terminar:

```bash
unset GRAFANA_TOKEN
```

---

## Sesión 8: crear un dashboard de verificación

### Objetivo

Crear un dashboard básico utilizando Prometheus.

### Panel 1: disponibilidad

```promql
up
```

Visualización:

```text
Table
```

### Panel 2: uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Visualización:

```text
Time series
```

### Panel 3: memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Visualización:

```text
Gauge
```

### Panel 4: espacio utilizado

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

Visualización:

```text
Gauge
```

### Actividades

1. Crea los cuatro paneles.
2. Selecciona Prometheus como fuente.
3. Configura las unidades.
4. Guarda el dashboard.
5. Comprueba que los paneles muestran datos.
6. Anota el nombre del dashboard.

---

# Diagnóstico desde Grafana

## Comprobar la fuente

Desde Grafana:

```text
Connections → Data sources → Prometheus
```

Pulsar:

```text
Save & test
```

## Comprobar la consulta del panel

Abrir el panel y utilizar el inspector.

Revisar:

- Consulta PromQL.
- URL utilizada.
- Respuesta.
- Tiempo de respuesta.
- Número de series.
- Mensaje de error.

## Comprobar Prometheus directamente

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq
```

Si Prometheus devuelve datos pero Grafana no muestra resultados, revisar:

- Fuente de datos seleccionada.
- Rango temporal.
- Consulta del panel.
- Variables del dashboard.
- Transformaciones.
- Unidades.
- Filtros.

---

# Seguridad y mantenimiento

## No utilizar credenciales por defecto

Cambiar la contraseña inicial de Grafana.

## Proteger el acceso a Grafana

Recomendaciones:

- Utilizar HTTPS.
- Limitar el acceso por red.
- Configurar usuarios y roles.
- Utilizar autenticación centralizada cuando proceda.
- Mantener Grafana actualizado.
- Revisar los registros.
- No compartir tokens.
- No guardar credenciales en repositorios.

## Proteger la API

Los tokens deben:

- Tener los permisos mínimos necesarios.
- Tener una duración controlada.
- Guardarse de forma segura.
- Revocarse cuando ya no sean necesarios.
- No aparecer en capturas ni informes públicos.

## Proteger la comunicación con Prometheus

En un entorno de producción pueden utilizarse:

- HTTPS.
- Proxy inverso.
- Autenticación.
- Redes privadas.
- Firewall.
- Certificados.
- VPN.

---

# Informe de configuración

Crear un directorio para evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/grafana-datasource
```

Guardar el estado de Grafana:

```bash
curl -s http://localhost:3000/api/health \
  | jq \
  > ~/laboratorio-grafana/evidencias/grafana-datasource/grafana-health.json
```

Guardar una prueba de Prometheus:

```bash
curl -s http://localhost:9090/-/healthy \
  > ~/laboratorio-grafana/evidencias/grafana-datasource/prometheus-health.txt
```

Guardar una consulta de Prometheus:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up' \
  | jq \
  > ~/laboratorio-grafana/evidencias/grafana-datasource/query-up.json
```

Guardar el fichero de provisioning, si se utiliza:

```bash
sudo cp \
  /etc/grafana/provisioning/datasources/prometheus.yml \
  ~/laboratorio-grafana/evidencias/grafana-datasource/prometheus-datasource.yml
```

Guardar los registros de Grafana:

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/grafana-datasource/grafana-logs.txt
```

---

# Ejemplo de sesión completa

```console
$ systemctl is-active prometheus
active

$ systemctl is-active grafana-server
active

$ curl http://localhost:9090/-/healthy
Prometheus is Healthy.

$ curl -s http://localhost:3000/api/health | jq
{
  "database": "ok",
  "version": "...",
  "commit": "..."
}
```

En Grafana:

```text
Connections
    └── Data sources
          └── Add new data source
                └── Prometheus
```

Configuración:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server
Default: Yes
```

Después de pulsar **Save & test**:

```text
Successfully queried the Prometheus API.
```

En un panel nuevo se ejecuta:

```promql
up
```

Resultado conceptual:

```text
prometheus      localhost:9090  1
node_exporter   localhost:9100  1
```

Después se prueba una consulta calculada:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Resultado esperado:

- La fuente de datos responde.
- Grafana ejecuta PromQL.
- El panel recibe datos.
- Las métricas se representan correctamente.
- Prometheus aparece como fuente de datos predeterminada.

---

# Actividad integradora

## Objetivo

Añadir Prometheus como fuente de datos en Grafana y crear un dashboard de verificación.

## Tareas

1. Comprobar que Prometheus está activo.
2. Comprobar que Grafana está activo.
3. Acceder a Grafana.
4. Crear una fuente de datos de tipo Prometheus.
5. Introducir la URL correcta.
6. Seleccionar el modo de acceso `Server`.
7. Establecer Prometheus como fuente predeterminada.
8. Ejecutar **Save & test**.
9. Crear un panel con la consulta `up`.
10. Crear un panel con el uso de CPU.
11. Crear un panel con el uso de memoria.
12. Crear un panel con el espacio utilizado.
13. Guardar el dashboard.
14. Configurar la fuente mediante provisioning.
15. Consultar los registros de Grafana.
16. Guardar las evidencias.

## Resultado esperado

```text
Grafana: activo
Prometheus: activo
Fuente creada: sí
Conexión probada: correcta
Fuente predeterminada: sí
Consulta up: devuelve datos
Panel de CPU: muestra datos
Panel de memoria: muestra datos
Panel de almacenamiento: muestra datos
Evidencias: guardadas
```

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Grafana activo | | |
| Prometheus activo | | |
| URL configurada | | |
| Modo de acceso | | |
| Save & test | | |
| Fuente predeterminada | | |
| Consulta `up` | | |
| Panel de CPU | | |
| Panel de memoria | | |
| Panel de almacenamiento | | |
| Provisioning | | |
| Registros revisados | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Grafana necesita una fuente de datos para consultar métricas.
- Prometheus será la fuente de datos utilizada en este laboratorio.
- La URL debe ser accesible desde Grafana.
- `localhost` hace referencia al equipo donde se realiza la conexión.
- Si Grafana y Prometheus están en contenedores, puede ser necesario utilizar el nombre del servicio.
- El modo `Server` es el más apropiado para esta práctica.
- **Save & test** comprueba la comunicación con Prometheus.
- Una conexión correcta no garantiza que todas las consultas devuelvan datos.
- La consulta `up` es una buena prueba inicial.
- La fuente de datos puede establecerse como predeterminada.
- El provisioning permite automatizar la configuración.
- La API permite consultar y administrar fuentes de datos.
- Los tokens deben protegerse.
- Los paneles deben utilizar la fuente de datos correcta.
- El inspector de Grafana ayuda a diagnosticar consultas.
- Los registros de Grafana ayudan a detectar errores de conexión y provisioning.
- La configuración debe documentarse para poder reproducirla.

---

# Preguntas de comprobación

1. ¿Qué es una fuente de datos en Grafana?
2. ¿Qué función cumple Prometheus dentro de Grafana?
3. ¿Qué URL se utiliza normalmente si ambos servicios están en el mismo servidor?
4. ¿Qué significa `localhost` cuando Grafana y Prometheus están en servidores diferentes?
5. ¿Qué modo de acceso se utilizará en esta práctica?
6. ¿Qué función cumple el botón **Save & test**?
7. ¿Qué consulta PromQL se recomienda para realizar la primera prueba?
8. ¿Qué significa establecer una fuente como predeterminada?
9. ¿Qué problema puede producirse si Grafana y Prometheus están en contenedores separados?
10. ¿Qué URL se utilizaría en una red Docker donde el servicio se llama `prometheus`?
11. ¿Qué información permite revisar el inspector de un panel?
12. ¿Qué diferencia existe entre un error de conexión y una consulta sin resultados?
13. ¿Para qué sirve el provisioning?
14. ¿Dónde se ubican normalmente los ficheros de provisioning de fuentes de datos?
15. ¿Qué propiedad define el nombre visible de una fuente?
16. ¿Qué propiedad define su identificador estable?
17. ¿Por qué no se deben guardar tokens en repositorios?
18. ¿Qué comprobarías si Grafana muestra `connection refused`?
19. ¿Qué comprobarías si la conexión funciona pero el panel está vacío?
20. ¿Cómo consultarías directamente la API de Prometheus?
21. ¿Qué consulta utilizarías para probar Node Exporter?
22. ¿Qué riesgos tiene eliminar una fuente de datos utilizada por dashboards?
23. ¿Qué diferencia existe entre configurar la fuente desde la interfaz y utilizar provisioning?
24. ¿Qué medidas aplicarías para proteger Grafana en producción?
25. ¿Qué evidencias guardarías para documentar la configuración?

---

# Criterios de finalización

La práctica se considera completada cuando el alumno puede:

- Acceder a Grafana.
- Comprobar el estado de Grafana y Prometheus.
- Crear una fuente de datos de tipo Prometheus.
- Configurar correctamente la URL.
- Explicar el significado de `localhost`.
- Seleccionar el modo de acceso adecuado.
- Probar la conexión.
- Establecer la fuente como predeterminada.
- Crear un panel de prueba.
- Ejecutar la consulta `up`.
- Ejecutar consultas de CPU y memoria.
- Diagnosticar un error de conexión.
- Diagnosticar una consulta sin resultados.
- Configurar la fuente mediante provisioning.
- Consultar los registros de Grafana.
- Guardar evidencias reproducibles.

La comprobación final puede realizarse con:

```bash
printf '%-40s %s\n' \
  "Prometheus activo" \
  "$(systemctl is-active prometheus)"

printf '%-40s %s\n' \
  "Grafana activo" \
  "$(systemctl is-active grafana-server)"

printf '%-40s ' \
  "Prometheus saludable"
curl -fsS http://localhost:9090/-/healthy \
  >/dev/null \
  && echo "sí" \
  || echo "no"

printf '%-40s ' \
  "API de Grafana disponible"
curl -fsS http://localhost:3000/api/health \
  >/dev/null \
  && echo "sí" \
  || echo "no"

printf '%-40s ' \
  "Consulta up disponible"
curl -fsS http://localhost:9090/api/v1/query \
  --get \
  --data-urlencode 'query=up' \
  | jq -e '.status == "success"' \
  >/dev/null \
  && echo "sí" \
  || echo "no"
```

Resultado esperado:

```text
Prometheus activo                       active
Grafana activo                          active
Prometheus saludable                    sí
API de Grafana disponible               sí
Consulta up disponible                  sí
```

El flujo que debe dominar el alumno es:

```text
Comprobar Prometheus
        |
        v
Comprobar Grafana
        |
        v
Crear la fuente de datos
        |
        v
Configurar la URL correcta
        |
        v
Probar la conexión
        |
        v
Ejecutar una consulta PromQL
        |
        v
Crear un panel
        |
        v
Guardar y documentar la configuración
```