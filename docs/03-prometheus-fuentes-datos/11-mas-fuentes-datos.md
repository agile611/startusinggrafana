# Fuentes de datos recomendadas

## Loki: logs

**Grafana Loki** es la opción más recomendable para almacenar y consultar logs desde Grafana.

Arquitectura:

```text
Ubuntu 24.04
├── Node Exporter → métricas del sistema
├── Prometheus → almacenamiento de métricas
├── Loki → almacenamiento de logs
└── Grafana → visualización
```

Flujo de logs:

```text
Logs del sistema
        |
        v
Promtail o Grafana Alloy
        |
        v
Loki
        |
        v
Grafana
```

Configuración típica en Grafana:

```text
Name: Loki
Type: Loki
URL: http://localhost:3100
```

Ejemplo de consulta LogQL:

```logql
{job="syslog"}
```

Filtrar errores:

```logql
{job="syslog"} |= "error"
```

Filtrar advertencias y errores:

```logql
{job="syslog"} |~ "(warning|error)"
```

### Qué puedes monitorizar con Loki

- `/var/log/syslog`
- `/var/log/auth.log`
- Logs de Nginx.
- Logs de Apache.
- Logs de Docker.
- Logs de aplicaciones.
- Logs de servicios `systemd`.

**Recomendación:** para instalaciones nuevas, utiliza **Grafana Alloy** como agente de recopilación en lugar de Promtail cuando sea posible.

---

## InfluxDB: series temporales alternativas

**InfluxDB** es otra base de datos especializada en series temporales. Puede convivir con Prometheus.

Puede resultar útil para:

- Datos de sensores.
- IoT.
- Temperaturas.
- Consumo energético.
- Datos de aplicaciones.
- Métricas con otro modelo de almacenamiento.

Configuración habitual:

```text
Name: InfluxDB
Type: InfluxDB
URL: http://localhost:8086
```

Según la versión de InfluxDB, puedes utilizar:

- Flux.
- InfluxQL.

Ejemplo conceptual con InfluxQL:

```sql
SELECT mean("usage_user")
FROM "cpu"
WHERE time > now() - 1h
GROUP BY time(1m)
```

### ¿Cuándo elegir InfluxDB?

Elige InfluxDB si:

- Ya tienes aplicaciones que escriben datos en InfluxDB.
- Trabajas con sensores o sistemas IoT.
- Necesitas consultar datos temporales que no proceden de Prometheus.
- Quieres comparar dos sistemas de almacenamiento temporal.

Para un laboratorio centrado en Linux, **no es imprescindible**. Prometheus ya cubre correctamente las métricas de Node Exporter.

---

## PostgreSQL: datos relacionales y de negocio

Grafana puede conectarse directamente a PostgreSQL.

Configuración:

```text
Name: PostgreSQL
Type: PostgreSQL
Host: localhost:5432
Database: monitorizacion
User: grafana_reader
SSL mode: disable o require
```

Consulta de ejemplo:

```sql
SELECT
  fecha AS "time",
  valor
FROM consumo_electrico
WHERE $__timeFilter(fecha)
ORDER BY fecha;
```

Las macros de Grafana facilitan las consultas temporales:

```sql
$__timeFilter(fecha)
```

También puedes utilizar variables:

```sql
SELECT DISTINCT servicio
FROM incidencias
ORDER BY servicio;
```

### Usos habituales

- Inventario de servidores.
- Incidencias.
- Usuarios activos.
- Consumo energético.
- Resultados de trabajos.
- Estado de aplicaciones.
- Datos de negocio.
- Información de tickets.

**Importante:** utiliza un usuario de solo lectura para Grafana.

```sql
CREATE USER grafana_reader WITH PASSWORD 'contraseña_segura';

GRANT CONNECT ON DATABASE monitorizacion
TO grafana_reader;
```

---

## MySQL o MariaDB: bases de datos relacionales

Grafana también puede consultar MySQL y MariaDB.

Configuración:

```text
Name: MariaDB
Type: MySQL
Host: localhost:3306
Database: monitorizacion
User: grafana_reader
```

Consulta de ejemplo:

```sql
SELECT
  fecha AS "time",
  cpu_percent
FROM metricas_aplicacion
WHERE $__timeFilter(fecha)
ORDER BY fecha;
```

Puede ser interesante si en tu entorno ya existe:

- Una aplicación web con MariaDB.
- Una base de datos de inventario.
- Un sistema de tickets.
- Un servidor de gestión.
- Una aplicación que almacena sus propios indicadores.

---

## Elasticsearch u OpenSearch: logs y eventos

Elasticsearch y OpenSearch pueden utilizarse como fuentes de datos para:

- Logs.
- Eventos.
- Documentos.
- Auditoría.
- Búsqueda textual.
- Datos de aplicaciones.

Configuración conceptual:

```text
Name: OpenSearch
Type: Elasticsearch
URL: http://localhost:9200
Index name: logs-*
Time field: @timestamp
```

Consultas habituales:

- Errores HTTP.
- Excepciones.
- Eventos de seguridad.
- Logs de aplicaciones.
- Actividad de usuarios.
- Eventos de auditoría.

### ¿Cuándo elegir OpenSearch o Elasticsearch?

Tiene sentido si:

- Ya utilizas Elastic Stack.
- Necesitas búsquedas complejas sobre logs.
- Tienes grandes volúmenes de documentos.
- Requieres análisis avanzado de eventos.

Para un laboratorio pequeño, Loki suele ser más sencillo y ligero.

---

## Tempo o Jaeger: trazas distribuidas

Las trazas ayudan a localizar dónde se produce la latencia dentro de una aplicación distribuida.

Arquitectura:

```text
Aplicación
    |
    v
OpenTelemetry
    |
    +----> Tempo
    |
    +----> Grafana
```

Configuración de Tempo:

```text
Name: Tempo
Type: Tempo
URL: http://localhost:3200
```

Configuración de Jaeger:

```text
Name: Jaeger
Type: Jaeger
URL: http://localhost:16686
```

Estas fuentes son útiles si tienes:

- Microservicios.
- APIs.
- Aplicaciones web distribuidas.
- Peticiones que atraviesan varios servicios.
- Problemas de latencia.
- Errores difíciles de localizar únicamente con métricas.

En tu laboratorio actual, Tempo o Jaeger serían **opcionales**, porque Node Exporter no genera trazas.

---

## Zabbix

Grafana puede conectarse a Zabbix mediante un plugin.

Zabbix puede aportar:

- Monitorización de servidores.
- Inventario.
- Alertas.
- Disponibilidad.
- Métricas históricas.
- Descubrimiento de dispositivos.

Configuración conceptual:

```text
Name: Zabbix
Type: Zabbix
URL: http://localhost/zabbix/api_jsonrpc.php
```

Tiene sentido utilizarlo si ya existe infraestructura monitorizada con Zabbix. No es necesario instalarlo solo para complementar un laboratorio básico de Prometheus.

---

## AWS CloudWatch, Azure Monitor y Google Cloud Monitoring

Si tu entorno está conectado a servicios cloud, Grafana puede consultar fuentes como:

- **Amazon CloudWatch**
- **Azure Monitor**
- **Google Cloud Monitoring**

Estas fuentes permiten consultar:

- Máquinas virtuales.
- Bases de datos gestionadas.
- Balanceadores.
- Servicios cloud.
- Funciones serverless.
- Colas.
- Redes.
- Costes y consumo.

En un servidor Ubuntu local no aportan valor inmediato, salvo que estés monitorizando recursos cloud.

# Comparativa de opciones

| Fuente | Tipo de datos | Utilidad en tu entorno | Complejidad |
|---|---|---|---:|
| Loki | Logs | Muy recomendable | Baja |
| InfluxDB | Series temporales | Útil para IoT y sensores | Media |
| PostgreSQL | Datos SQL | Muy útil para datos de negocio | Baja |
| MySQL/MariaDB | Datos SQL | Útil si ya existe una aplicación | Baja |
| OpenSearch | Logs y eventos | Útil para búsquedas avanzadas | Media-alta |
| Tempo | Trazas | Útil para microservicios | Media |
| Jaeger | Trazas | Alternativa para tracing | Media |
| Zabbix | Monitorización | Útil si ya lo utilizas | Media |
| CloudWatch | Datos de AWS | Solo para entornos AWS | Media |
| Azure Monitor | Datos de Azure | Solo para entornos Azure | Media |
| Google Cloud Monitoring | Datos de GCP | Solo para entornos GCP | Media |

# Entorno recomendado para tu laboratorio

Para ampliar tu entorno actual sin complicarlo demasiado, utilizaría:

```text
Node Exporter
      |
      v
Prometheus
      |
      +------------------+
      |                  |
      v                  v
    Loki               Grafana
   Logs             Dashboards
```

Componentes:

```text
Prometheus → métricas
Node Exporter → métricas del sistema operativo
Loki → logs
Grafana → visualización
```

Los puertos podrían ser:

| Componente | Puerto |
|---|---:|
| Grafana | `3000` |
| Prometheus | `9090` |
| Node Exporter | `9100` |
| Loki | `3100` |

# Ejemplo de instalación de Loki con Docker

Si quieres probar Loki sin modificar demasiado Ubuntu, puedes ejecutar Loki con Docker:

```bash
docker run -d \
  --name loki \
  -p 3100:3100 \
  grafana/loki:latest \
  -config.file=/etc/loki/local-config.yaml
```

Comprobar que responde:

```bash
curl http://localhost:3100/ready
```

Resultado esperado:

```text
ready
```

En Grafana añadirías:

```text
Name: Loki
URL: http://localhost:3100
Access: Server o Proxy
```

> Si Grafana también se ejecuta dentro de Docker, no utilices necesariamente `localhost:3100`. En ese caso, utiliza el nombre del contenedor o del servicio, por ejemplo `http://loki:3100`.

# Ejemplo con Docker Compose

Un entorno sencillo con Prometheus, Grafana, Node Exporter y Loki podría ser:

```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    depends_on:
      - prometheus
      - loki
    networks:
      - monitoring

  node_exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    ports:
      - "9100:9100"
    networks:
      - monitoring

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge
```

Dentro de Docker, las URLs serían:

```text
Prometheus:    http://prometheus:9090
Loki:          http://loki:3100
Node Exporter: http://node_exporter:9100
```

Desde el navegador accederías a Grafana mediante:

```text
http://localhost:3000
```

# Dashboards con varias fuentes

Un dashboard puede combinar paneles de distintas fuentes:

```text
Dashboard: Estado del servidor
├── Uso de CPU             → Prometheus
├── Uso de memoria         → Prometheus
├── Uso de disco           → Prometheus
├── Tráfico de red         → Prometheus
├── Logs del sistema       → Loki
└── Errores de aplicación  → Loki
```

Ejemplo de panel Prometheus:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Ejemplo de panel Loki:

```logql
{job="syslog"} |= "error"
```

El dashboard podría visualizarse así:

```text
+-------------------+-------------------+-------------------+
| Estado            | CPU               | Memoria           |
| Prometheus        | Prometheus        | Prometheus        |
+-------------------+-------------------+-------------------+
| Disco             | Red               | Carga             |
| Prometheus        | Prometheus        | Prometheus        |
+-------------------+-------------------+-------------------+
| Logs recientes    | Errores de app    | Eventos críticos  |
| Loki              | Loki              | Loki              |
+-------------------+-------------------+-------------------+
```

