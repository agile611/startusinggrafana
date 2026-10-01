# Crear un Heatmap en Grafana con datos personalizados de Prometheus

La forma más sencilla de crear un **Heatmap en Grafana** con datos introducidos manualmente consiste en:

1. Crear un pequeño exporter en Python.
2. Exponer una métrica tipo histograma en `/metrics`.
3. Configurar Prometheus para leer ese endpoint.
4. Generar datos manuales y aleatorios.
5. Representar la distribución en Grafana mediante un panel Heatmap.

La arquitectura será:

```text
Datos manuales o aleatorios
              ↓
        Exporter Python
              ↓
       http://127.0.0.1:9101/metrics
              ↓
          Prometheus
              ↓
            PromQL
              ↓
        Grafana Heatmap
```

Prometheus normalmente no recibe datos mediante peticiones directas. En su lugar, consulta periódicamente los endpoints `/metrics` de los exporters mediante un mecanismo denominado **scraping**.

En este ejemplo utilizaremos un histograma llamado:

```text
curso_valor_seconds
```

La métrica representará valores numéricos, por ejemplo:

```text
0.15
0.80
2.50
15.00
60.00
```

---

## 1. Preparar el exporter de prueba

Primero instalaremos Python, crearemos un entorno virtual y añadiremos la librería oficial de Prometheus para Python.

### 1.1. Instalar Python y crear el entorno virtual

```bash
sudo apt-get install -y python3 python3-venv
```

Crear el directorio de trabajo:

```bash
sudo mkdir -p /opt/heatmap-exporter
```

Crear el entorno virtual:

```bash
sudo python3 -m venv /opt/heatmap-exporter/venv
```

Instalar la librería de Prometheus:

```bash
sudo /opt/heatmap-exporter/venv/bin/pip install prometheus-client
```

---

### 1.2. Crear el programa Python

Crear el fichero:

```bash
sudo nano /opt/heatmap-exporter/exporter.py
```

Pega el siguiente contenido:

```python
#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

from prometheus_client import Histogram, generate_latest

import json
import random


# Histogramas acumulativos para los valores observados.
#
# Los buckets deben estar ordenados de menor a mayor.
# Cuantos más buckets haya, más detalle tendrá el eje vertical
# del Heatmap.
histogram = Histogram(
    "curso_valor_seconds",
    "Valores personalizados para el Heatmap",
    buckets=(
        0.01,
        0.025,
        0.05,
        0.1,
        0.25,
        0.5,
        0.75,
        1.0,
        1.5,
        2.5,
        5.0,
        7.5,
        10.0,
        15.0,
        20.0,
        30.0,
        45.0,
        60.0,
        90.0,
        120.0,
    ),
)


def generate_random_value(minimum=0.05, maximum=120.0):
    """
    Genera valores aleatorios con una distribución variada.

    No usamos una distribución uniforme pura porque suele producir
    una nube demasiado plana. Mezclamos varios comportamientos:

    - Valores pequeños y frecuentes.
    - Valores medios.
    - Valores altos ocasionales.
    """

    distribution = random.choices(
        population=("small", "medium", "large"),
        weights=(60, 30, 10),
        k=1,
    )[0]

    if distribution == "small":
        value = random.lognormvariate(
            mu=-1.2,
            sigma=0.9,
        )

    elif distribution == "medium":
        value = random.gauss(
            mu=12.0,
            sigma=6.0,
        )

    else:
        value = random.gauss(
            mu=55.0,
            sigma=25.0,
        )

    # Limitamos el valor al intervalo solicitado.
    value = max(minimum, min(value, maximum))

    return round(value, 4)


class Handler(BaseHTTPRequestHandler):

    def send_json(self, status_code, response):
        body = json.dumps(response).encode("utf-8")

        self.send_response(status_code)
        self.send_header(
            "Content-Type",
            "application/json; charset=utf-8",
        )
        self.send_header(
            "Content-Length",
            str(len(body)),
        )
        self.end_headers()
        self.wfile.write(body)

    def send_text(self, status_code, text):
        body = text.encode("utf-8")

        self.send_response(status_code)
        self.send_header(
            "Content-Type",
            "text/plain; charset=utf-8",
        )
        self.send_header(
            "Content-Length",
            str(len(body)),
        )
        self.end_headers()
        self.wfile.write(body)

    def get_float_parameter(
        self,
        parameters,
        name,
        default,
    ):
        try:
            return float(parameters.get(name, [default])[0])
        except (TypeError, ValueError):
            raise ValueError(
                f"El parámetro '{name}' debe ser numérico"
            )

    def get_int_parameter(
        self,
        parameters,
        name,
        default,
    ):
        try:
            return int(parameters.get(name, [default])[0])
        except (TypeError, ValueError):
            raise ValueError(
                f"El parámetro '{name}' debe ser entero"
            )

    def do_GET(self):
        parsed = urlparse(self.path)
        parameters = parse_qs(parsed.query)

        # Endpoint de métricas para Prometheus.
        if parsed.path == "/metrics":
            data = generate_latest()

            self.send_response(200)
            self.send_header(
                "Content-Type",
                "text/plain; version=0.0.4; charset=utf-8",
            )
            self.send_header(
                "Content-Length",
                str(len(data)),
            )
            self.end_headers()
            self.wfile.write(data)
            return

        # Añade un único valor recibido por URL.
        #
        # Ejemplo:
        # /add?value=2.5
        if parsed.path == "/add":
            try:
                value = self.get_float_parameter(
                    parameters,
                    "value",
                    None,
                )

                if value is None or value < 0:
                    raise ValueError(
                        "El valor debe ser mayor o igual que cero"
                    )

                histogram.observe(value)

                self.send_json(
                    200,
                    {
                        "status": "ok",
                        "mode": "manual",
                        "value": value,
                    },
                )

            except ValueError as error:
                self.send_json(
                    400,
                    {
                        "status": "error",
                        "message": str(error),
                        "usage": "/add?value=2.5",
                    },
                )

            return

        # Añade varios valores aleatorios.
        #
        # Parámetros:
        # - count: número de observaciones
        # - min: valor mínimo
        # - max: valor máximo
        #
        # Ejemplo:
        # /random?count=100&min=0.1&max=60
        if parsed.path == "/random":
            try:
                count = self.get_int_parameter(
                    parameters,
                    "count",
                    50,
                )

                minimum = self.get_float_parameter(
                    parameters,
                    "min",
                    0.05,
                )

                maximum = self.get_float_parameter(
                    parameters,
                    "max",
                    120.0,
                )

                if count < 1 or count > 10000:
                    raise ValueError(
                        "count debe estar entre 1 y 10000"
                    )

                if minimum < 0:
                    raise ValueError(
                        "min no puede ser negativo"
                    )

                if maximum <= minimum:
                    raise ValueError(
                        "max debe ser mayor que min"
                    )

                values = []

                for _ in range(count):
                    value = generate_random_value(
                        minimum,
                        maximum,
                    )

                    histogram.observe(value)
                    values.append(value)

                self.send_json(
                    200,
                    {
                        "status": "ok",
                        "mode": "random",
                        "count": count,
                        "minimum": minimum,
                        "maximum": maximum,
                        "first_values": values[:10],
                    },
                )

            except ValueError as error:
                self.send_json(
                    400,
                    {
                        "status": "error",
                        "message": str(error),
                        "usage": (
                            "/random?"
                            "count=100&"
                            "min=0.1&"
                            "max=60"
                        ),
                    },
                )

            return

        self.send_text(
            404,
            (
                "Endpoint no encontrado.\n\n"
                "Endpoints disponibles:\n"
                "  /metrics\n"
                "  /add?value=2.5\n"
                "  /random?count=100&min=0.1&max=60\n"
            ),
        )

    def log_message(self, format, *args):
        # Evita imprimir una línea por cada petición HTTP.
        return


server = HTTPServer(
    ("127.0.0.1", 9101),
    Handler,
)

print(
    "Exporter escuchando en "
    "http://127.0.0.1:9101"
)

server.serve_forever()
```

---

### 1.3. Dar permisos al programa

```bash
sudo chmod +x /opt/heatmap-exporter/exporter.py
```

Comprobar el contenido:

```bash
sudo sed -n '1,260p' \
  /opt/heatmap-exporter/exporter.py
```

---

## 2. Probar el exporter manualmente

Antes de crear el servicio `systemd`, probaremos el programa directamente.

### 2.1. Iniciar el exporter

```bash
sudo /opt/heatmap-exporter/venv/bin/python \
  /opt/heatmap-exporter/exporter.py
```

Deberías ver:

```text
Exporter escuchando en http://127.0.0.1:9101
```

Mantén esta sesión abierta.

---

### 2.2. Abrir una segunda sesión SSH

Desde otra terminal del equipo local:

```bash
ssh curso@185.142.62.160
```

Accede como root:

```bash
su
```

---

### 2.3. Añadir valores manualmente

Añade un valor individual:

```bash
curl "http://127.0.0.1:9101/add?value=0.15"
```

Respuesta esperada:

```json
{
  "status": "ok",
  "mode": "manual",
  "value": 0.15
}
```

Añade varios valores:

```bash
curl "http://127.0.0.1:9101/add?value=0.30"
curl "http://127.0.0.1:9101/add?value=0.80"
curl "http://127.0.0.1:9101/add?value=1.20"
curl "http://127.0.0.1:9101/add?value=3.00"
curl "http://127.0.0.1:9101/add?value=8.00"
curl "http://127.0.0.1:9101/add?value=15.00"
curl "http://127.0.0.1:9101/add?value=45.00"
```

---

### 2.4. Generar un bloque de datos aleatorios

El endpoint `/random` permite generar muchos valores en una sola petición:

```bash
curl \
  "http://127.0.0.1:9101/random?count=100&min=0.1&max=60"
```

Este comando genera:

- 100 observaciones.
- Valores entre `0.1` y `60`.
- Una distribución no uniforme.
- Más valores pequeños que grandes.
- Algunos valores medios y altos.

Respuesta aproximada:

```json
{
  "status": "ok",
  "mode": "random",
  "count": 100,
  "minimum": 0.1,
  "maximum": 60.0,
  "first_values": [
    0.3842,
    1.2071,
    14.3312,
    5.0945,
    48.2077
  ]
}
```

Generar 500 observaciones:

```bash
curl \
  "http://127.0.0.1:9101/random?count=500&min=0.1&max=120"
```

Generar 1000 observaciones con un rango más pequeño:

```bash
curl \
  "http://127.0.0.1:9101/random?count=1000&min=0.01&max=30"
```

---

### 2.5. Consultar el endpoint `/metrics`

```bash
curl http://127.0.0.1:9101/metrics
```

Filtrar únicamente la métrica del ejercicio:

```bash
curl -s \
  http://127.0.0.1:9101/metrics \
  | grep curso_valor
```

El resultado tendrá una estructura parecida a esta:

```text
curso_valor_seconds_bucket{le="0.01"} 0.0
curso_valor_seconds_bucket{le="0.025"} 1.0
curso_valor_seconds_bucket{le="0.05"} 2.0
curso_valor_seconds_bucket{le="0.1"} 7.0
curso_valor_seconds_bucket{le="0.25"} 19.0
curso_valor_seconds_bucket{le="0.5"} 37.0
curso_valor_seconds_bucket{le="0.75"} 48.0
curso_valor_seconds_bucket{le="1.0"} 56.0
curso_valor_seconds_bucket{le="1.5"} 73.0
curso_valor_seconds_bucket{le="2.5"} 91.0
curso_valor_seconds_bucket{le="5.0"} 134.0
curso_valor_seconds_bucket{le="10.0"} 211.0
curso_valor_seconds_bucket{le="20.0"} 286.0
curso_valor_seconds_bucket{le="30.0"} 337.0
curso_valor_seconds_bucket{le="60.0"} 418.0
curso_valor_seconds_bucket{le="120.0"} 500.0
curso_valor_seconds_bucket{le="+Inf"} 500.0
curso_valor_seconds_count 500.0
curso_valor_seconds_sum 4217.83
```

Las series terminadas en:

```text
_bucket
```

son los buckets acumulativos que Prometheus y Grafana utilizarán para construir el Heatmap.

---

## 3. Convertir el exporter en un servicio systemd

Una vez comprobado que funciona, detén la ejecución manual:

```text
Ctrl + C
```

### 3.1. Crear el servicio

```bash
sudo nano /etc/systemd/system/heatmap-exporter.service
```

Contenido:

```ini
[Unit]
Description=Exporter de datos para Heatmap
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
WorkingDirectory=/opt/heatmap-exporter
ExecStart=/opt/heatmap-exporter/venv/bin/python /opt/heatmap-exporter/exporter.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

### 3.2. Comprobar que existe el usuario Prometheus

```bash
id prometheus
```

Si el usuario no existe, créalo:

```bash
sudo useradd \
  --system \
  --no-create-home \
  --shell /usr/sbin/nologin \
  prometheus
```

---

### 3.3. Ajustar permisos

```bash
sudo chown -R root:prometheus \
  /opt/heatmap-exporter
```

Permitir el acceso al directorio:

```bash
sudo chmod 755 \
  /opt/heatmap-exporter
```

Permitir la lectura y ejecución del programa:

```bash
sudo chmod 755 \
  /opt/heatmap-exporter/exporter.py
```

Permitir la lectura del entorno virtual:

```bash
sudo chmod -R o+rX \
  /opt/heatmap-exporter/venv
```

---

### 3.4. Activar el servicio

```bash
sudo systemctl daemon-reload
```

Activar el inicio automático:

```bash
sudo systemctl enable heatmap-exporter
```

Iniciar el servicio:

```bash
sudo systemctl start heatmap-exporter
```

También se puede hacer todo en un solo comando:

```bash
sudo systemctl enable --now heatmap-exporter
```

---

### 3.5. Comprobar el servicio

```bash
sudo systemctl status heatmap-exporter \
  --no-pager \
  -l
```

Debe aparecer:

```text
Active: active (running)
```

Comprobar el estado de forma breve:

```bash
systemctl is-active heatmap-exporter
```

Resultado esperado:

```text
active
```

Consultar los logs:

```bash
sudo journalctl -u heatmap-exporter \
  -n 50 \
  --no-pager
```

Comprobar que el endpoint está disponible:

```bash
curl http://127.0.0.1:9101/metrics
```

---

## 4. Configurar Prometheus

Prometheus debe consultar periódicamente el puerto `9101`.

### 4.1. Editar la configuración

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Añade este bloque dentro de la sección `scrape_configs`:

```yaml
  - job_name: heatmap-exporter
    scrape_interval: 5s
    static_configs:
      - targets:
          - 127.0.0.1:9101
```

Un ejemplo completo sería:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - 127.0.0.1:9090

  - job_name: heatmap-exporter
    scrape_interval: 5s
    static_configs:
      - targets:
          - 127.0.0.1:9101
```

Si ya existe `scrape_configs`, no vuelvas a crear esa clave. Añade únicamente el bloque del exporter.

---

### 4.2. Validar la configuración

```bash
sudo promtool check config \
  /etc/prometheus/prometheus.yml
```

Resultado esperado:

```text
SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax
```

Si aparece un error de YAML, comprueba especialmente:

- La indentación.
- El número de espacios.
- Que no se hayan utilizado tabuladores.
- Que `targets` esté dentro de `static_configs`.

---

### 4.3. Reiniciar Prometheus

```bash
sudo systemctl restart prometheus
```

Comprobar el servicio:

```bash
sudo systemctl status prometheus \
  --no-pager \
  -l
```

Comprobar que está activo:

```bash
systemctl is-active prometheus
```

Resultado esperado:

```text
active
```

---

### 4.4. Comprobar el target

Abre Prometheus en:

```text
http://185.142.62.160:9090
```

Ve a:

```text
Status → Targets
```

El target debe aparecer como:

```text
heatmap-exporter
```

Y su estado debe ser:

```text
UP
```

También puedes consultar la métrica desde la interfaz de Prometheus:

```promql
curso_valor_seconds_count
```

Deberías obtener el número total de valores observados.

Comprobar los buckets:

```promql
curso_valor_seconds_bucket
```

Comprobar únicamente el bucket de `10` segundos:

```promql
curso_valor_seconds_bucket{le="10.0"}
```

---

## 5. Crear el Heatmap en Grafana

### 5.1. Crear un panel

En Grafana:

1. Abre **Dashboards**.
2. Selecciona **New dashboard**.
3. Pulsa **Add visualization**.
4. Selecciona la fuente de datos **Prometheus**.
5. Selecciona la visualización **Heatmap**.

---

### 5.2. Consulta principal con `rate`

Para datos generados frecuentemente, utiliza:

```promql
sum by (le) (
  rate(curso_valor_seconds_bucket[5m])
)
```

Esta consulta calcula la frecuencia media de observaciones por segundo en cada bucket durante los últimos cinco minutos.

---

### 5.3. Consulta con `increase`

Para datos generados por bloques o de forma menos frecuente:

```promql
sum by (le) (
  increase(curso_valor_seconds_bucket[15m])
)
```

Esta consulta muestra cuántas observaciones han aparecido aproximadamente en cada intervalo durante los últimos quince minutos.

---

### 5.4. Comparación de las consultas

| Consulta | Uso recomendado |
|---|---|
| `rate(...[5m])` | Datos continuos o generados frecuentemente |
| `increase(...[15m])` | Bloques de datos generados manualmente |
| `sum by (le)` | Agrupar correctamente los buckets del histograma |

Para una práctica de clase, la consulta siguiente suele ser más fácil de interpretar:

```promql
sum by (le) (
  increase(curso_valor_seconds_bucket[5m])
)
```

---

### 5.5. Configuración visual del panel

En el panel Heatmap configura:

- **Visualization**: `Heatmap`.
- **Data format**: `Time series buckets`.
- **Unit**: `seconds`.
- **Y-axis minimum**: `0`.
- **Y-axis maximum**: `120`.
- **Y-axis scale**: `Linear`.
- **Color scheme**: una escala de colores progresiva.
- **Tooltip**: activado.
- **Legend**: activada si la versión de Grafana la muestra.

Los buckets verticales serán:

```text
0.01
0.025
0.05
0.1
0.25
0.5
0.75
1
1.5
2.5
5
7.5
10
15
20
30
45
60
90
120
```

El eje horizontal representará el tiempo.

La intensidad del color representará el número de observaciones existentes en cada intervalo.

---

## 6. Generar muchos datos aleatorios

Para que el Heatmap sea más visible, conviene generar datos durante varios minutos.

### 6.1. Generar un bloque de datos

```bash
curl -s \
  "http://127.0.0.1:9101/random?count=500&min=0.1&max=120"
```

Después espera unos segundos y actualiza el panel de Grafana.

---

### 6.2. Generar bloques continuamente

Este bucle genera 100 observaciones cada cinco segundos:

```bash
while true; do
  curl -s \
    "http://127.0.0.1:9101/random?count=100&min=0.1&max=120" \
    >/dev/null

  echo "Bloque generado: $(date)"

  sleep 5
done
```

Para detenerlo:

```text
Ctrl + C
```

---

### 6.3. Generar bloques con tamaños aleatorios

Este ejemplo cambia el número de observaciones y el rango en cada ciclo:

```bash
while true; do
  count=$((50 + RANDOM % 251))
  maximum=$((30 + RANDOM % 91))

  curl -s \
    "http://127.0.0.1:9101/random?count=${count}&min=0.1&max=${maximum}" \
    >/dev/null

  echo "Generadas ${count} observaciones con máximo ${maximum}"

  sleep 5
done
```

El número de observaciones estará entre:

```text
50 y 300
```

El valor máximo estará entre:

```text
30 y 120
```

---

### 6.4. Generar una carga más intensa

Para una demostración rápida:

```bash
for iteration in $(seq 1 20); do
  curl -s \
    "http://127.0.0.1:9101/random?count=500&min=0.1&max=120" \
    >/dev/null

  echo "Iteración ${iteration}/20 completada"

  sleep 2
done
```

Esto generará:

```text
20 × 500 = 10000 observaciones
```

---

### 6.5. Generar datos con varias zonas de concentración

Los datos generados por el programa ya utilizan una mezcla de distribuciones:

- **60 %** de valores pequeños.
- **30 %** de valores medios.
- **10 %** de valores altos.

Por eso el Heatmap no será una distribución uniforme. Se observarán zonas con mayor intensidad, que simulan una carga o comportamiento más realista.

---

## 7. Practicar con sesiones de ejemplo

Las siguientes sesiones están pensadas para que los alumnos puedan seguirlas paso a paso.

### Sesión 1: comprobar todos los servicios

Comprobar el exporter:

```bash
systemctl is-active heatmap-exporter
```

Comprobar Prometheus:

```bash
systemctl is-active prometheus
```

Comprobar Grafana:

```bash
systemctl is-active grafana-server
```

Comprobar el endpoint del exporter:

```bash
curl http://127.0.0.1:9101/metrics
```

Comprobar Prometheus:

```bash
curl http://127.0.0.1:9090/-/ready
```

Comprobar Grafana:

```bash
curl http://127.0.0.1:3000/api/health
```

---

### Sesión 2: introducir datos manualmente

Añadir observaciones:

```bash
curl "http://127.0.0.1:9101/add?value=0.2"
curl "http://127.0.0.1:9101/add?value=0.4"
curl "http://127.0.0.1:9101/add?value=0.8"
curl "http://127.0.0.1:9101/add?value=1.5"
curl "http://127.0.0.1:9101/add?value=2.5"
curl "http://127.0.0.1:9101/add?value=5"
curl "http://127.0.0.1:9101/add?value=10"
curl "http://127.0.0.1:9101/add?value=30"
```

Consultar el total:

```promql
curso_valor_seconds_count
```

Consultar la suma:

```promql
curso_valor_seconds_sum
```

Consultar el promedio:

```promql
curso_valor_seconds_sum
/
curso_valor_seconds_count
```

---

### Sesión 3: generar 1000 datos aleatorios

Ejecutar:

```bash
curl -s \
  "http://127.0.0.1:9101/random?count=1000&min=0.1&max=120"
```

Consultar el total:

```promql
curso_valor_seconds_count
```

Consultar el Heatmap con:

```promql
sum by (le) (
  increase(curso_valor_seconds_bucket[5m])
)
```

Cambiar el rango temporal de Grafana a:

```text
Last 15 minutes
```

---

### Sesión 4: observar la evolución temporal

Ejecutar:

```bash
while true; do
  curl -s \
    "http://127.0.0.1:9101/random?count=100&min=0.1&max=120" \
    >/dev/null

  sleep 10
done
```

En Grafana:

1. Selecciona un rango de 15 minutos.
2. Activa la actualización automática.
3. Selecciona un intervalo de refresco de 5 segundos.
4. Observa cómo aparecen nuevas columnas en el eje temporal.

Detener la generación:

```text
Ctrl + C
```

---

### Sesión 5: comparar dos distribuciones

Generar valores pequeños:

```bash
curl -s \
  "http://127.0.0.1:9101/random?count=1000&min=0.01&max=5"
```

Esperar unos segundos y generar valores altos:

```bash
curl -s \
  "http://127.0.0.1:9101/random?count=1000&min=30&max=120"
```

En Grafana, observa cómo cambia la distribución de colores.

La primera tanda debería concentrarse en la zona inferior del Heatmap.

La segunda tanda debería producir actividad en la zona media y superior.

---

### Sesión 6: provocar un error controlado

Enviar un valor no numérico:

```bash
curl \
  "http://127.0.0.1:9101/add?value=abc"
```

Enviar un número negativo:

```bash
curl \
  "http://127.0.0.1:9101/add?value=-5"
```

Enviar demasiadas observaciones:

```bash
curl \
  "http://127.0.0.1:9101/random?count=20000"
```

El exporter debería devolver una respuesta JSON con:

```json
{
  "status": "error"
}
```

Este ejercicio permite comprobar que una API debe validar los datos recibidos.

---

## 8. Entender las métricas del histograma

Al utilizar:

```python
histogram.observe(value)
```

la librería genera automáticamente varias métricas.

### 8.1. Métricas `_bucket`

Ejemplo:

```text
curso_valor_seconds_bucket{le="1.0"} 56.0
```

Indica cuántas observaciones tienen un valor menor o igual que `1.0`.

Los buckets son acumulativos.

Por ejemplo:

```text
le="1.0"  → 56 observaciones
le="2.5"  → 91 observaciones
```

Las 56 observaciones menores o iguales que `1.0` también forman parte de las 91 observaciones menores o iguales que `2.5`.

---

### 8.2. Métrica `_count`

```text
curso_valor_seconds_count 500.0
```

Indica el número total de observaciones.

---

### 8.3. Métrica `_sum`

```text
curso_valor_seconds_sum 4217.83
```

Indica la suma de todos los valores observados.

---

### 8.4. Calcular el promedio

Consulta PromQL:

```promql
curso_valor_seconds_sum
/
curso_valor_seconds_count
```

Para calcular el promedio a lo largo del tiempo:

```promql
rate(curso_valor_seconds_sum[5m])
/
rate(curso_valor_seconds_count[5m])
```

---

## 9. Importante: conservar los datos anteriores

El exporter mantiene los contadores del histograma en memoria.

Esto significa:

- Los valores permanecen mientras el proceso esté activo.
- Los valores se acumulan con cada petición.
- El endpoint `/metrics` siempre muestra el estado acumulado actual.
- Prometheus conserva las muestras que ha ido recopilando en su propia base de datos temporal.

Sin embargo, si se reinicia el exporter, sus contadores internos vuelven a empezar desde cero:

```bash
sudo systemctl restart heatmap-exporter
```

Prometheus detectará el reinicio del contador y tratará la disminución como un **counter reset**.

Para una práctica de laboratorio esto es suficiente. En un sistema real, si los datos deben sobrevivir a reinicios, habría que guardar los eventos en una base de datos o utilizar otro sistema de persistencia.

La información histórica que Prometheus ya haya almacenado no desaparece inmediatamente, pero la nueva ejecución del exporter empezará con contadores reiniciados.

---

## 10. Importante: no publicar buckets manualmente sin control

No se deben escribir manualmente métricas como estas:

```text
curso_valor_seconds_bucket{le="1"} 7
curso_valor_seconds_bucket{le="5"} 12
```

salvo que se mantengan correctamente todas las reglas del histograma:

- Los buckets deben ser acumulativos.
- Deben estar ordenados.
- `_count` debe coincidir con el bucket `+Inf`.
- `_sum` debe contener la suma correcta.
- Los contadores no deberían disminuir durante la ejecución normal.

Por eso utilizamos:

```python
histogram.observe(value)
```

La librería calcula automáticamente:

- Los buckets.
- `_count`.
- `_sum`.
- El bucket especial `+Inf`.

---

## 11. Comandos de diagnóstico

### 11.1. Estado del exporter

```bash
sudo systemctl status heatmap-exporter \
  --no-pager \
  -l
```

### 11. Logs del exporter

```bash
sudo journalctl -u heatmap-exporter \
  -n 100 \
  --no-pager
```

### 11. Puerto del exporter

```bash
sudo ss -lntp | grep ':9101'
```

Resultado esperado:

```text
127.0.0.1:9101
```

### 11. Comprobar la métrica

```bash
curl -s \
  http://127.0.0.1:9101/metrics \
  | grep curso_valor
```

### 11. Estado de Prometheus

```bash
sudo systemctl status prometheus \
  --no-pager \
  -l
```

### 11. Validar Prometheus

```bash
sudo promtool check config \
  /etc/prometheus/prometheus.yml
```

### 11. Logs de Prometheus

```bash
sudo journalctl -u prometheus \
  -n 100 \
  --no-pager
```

### 11. Estado de Grafana

```bash
sudo systemctl status grafana-server \
  --no-pager \
  -l
```

### 11. API de Grafana

```bash
curl -s \
  http://127.0.0.1:3000/api/health
```

---

## 12. Resumen de comandos principales

Añadir una observación manual:

```bash
curl "http://127.0.0.1:9101/add?value=2.4"
```

Generar 100 observaciones aleatorias:

```bash
curl \
  "http://127.0.0.1:9101/random?count=100&min=0.1&max=60"
```

Consultar las métricas:

```bash
curl http://127.0.0.1:9101/metrics
```

Consultar el número total de valores:

```promql
curso_valor_seconds_count
```

Consultar la suma de valores:

```promql
curso_valor_seconds_sum
```

Consultar la distribución para el Heatmap:

```promql
sum by (le) (
  increase(curso_valor_seconds_bucket[5m])
)
```

Consultar la distribución mediante frecuencia:

```promql
sum by (le) (
  rate(curso_valor_seconds_bucket[5m])
)
```

Consultar el promedio:

```promql
rate(curso_valor_seconds_sum[5m])
/
rate(curso_valor_seconds_count[5m])
```

La consulta principal recomendada para el panel Heatmap es:

```promql
sum by (le) (
  increase(curso_valor_seconds_bucket[5m])
)
```

Con esta configuración, los alumnos pueden introducir datos concretos, generar bloques grandes de valores aleatorios, observar la distribución temporal y analizar cómo Prometheus y Grafana trabajan conjuntamente con métricas de tipo histograma.