# Retención de datos

## Objetivos

Al finalizar esta sección podrás:

- Explicar qué significa la retención de datos en un sistema de monitorización.
- Comprender cómo gestiona Prometheus el almacenamiento de las series temporales.
- Configurar un periodo de retención basado en tiempo o en tamaño.
- Estimar los factores que influyen en el espacio de disco necesario.
- Diferenciar entre retención, archivado y downsampling.
- Diseñar una estrategia de conservación de datos adecuada para un entorno de laboratorio.
- Identificar los riesgos de conservar demasiados datos o eliminarlos demasiado pronto.

## Introducción

La **retención de datos** define durante cuánto tiempo se conservan las métricas recopiladas por un sistema de monitorización.

Prometheus almacena las métricas como series temporales. Cada nueva recopilación añade muestras a esas series:

```text
10:00:00 → CPU: 35 %
10:00:15 → CPU: 42 %
10:00:30 → CPU: 38 %
10:00:45 → CPU: 51 %
```

Con el paso del tiempo, el número de muestras aumenta. Para evitar que el almacenamiento crezca indefinidamente, Prometheus elimina automáticamente los datos que superan la política de retención configurada.

Por ejemplo:

```text
Retención: 15 días
```

Esta configuración significa que Prometheus conservará aproximadamente los últimos 15 días de datos y eliminará progresivamente los datos más antiguos.

La retención debe equilibrar dos necesidades:

- Disponer de suficiente información histórica.
- Mantener controlados el espacio de disco y el consumo de recursos.

Una retención demasiado corta puede impedir analizar incidentes antiguos. Una retención demasiado larga puede consumir rápidamente el almacenamiento disponible.

## Contenido

### ¿Qué es la retención de datos?

La retención es el periodo durante el cual una muestra permanece disponible para ser consultada.

Si una métrica se registra el 1 de septiembre y la retención es de 15 días, esa muestra podrá eliminarse aproximadamente después del 16 de septiembre.

La eliminación no suele producirse exactamente en el instante en que se cumple el periodo. Prometheus gestiona los datos mediante bloques y realiza tareas periódicas de compactación y limpieza.

El objetivo práctico es conservar una ventana temporal aproximada:

```text
Ahora - periodo de retención
```

Por ejemplo:

```text
Fecha actual: 22 de septiembre
Retención: 15 días
Datos disponibles aproximadamente desde: 7 de septiembre
```

### Por qué es necesaria

Sin una política de retención, el almacenamiento crecería continuamente.

El crecimiento depende de factores como:

- Número de objetivos monitorizados.
- Número de métricas expuestas.
- Cardinalidad de las etiquetas.
- Intervalo de scraping.
- Número de muestras por segundo.
- Número de réplicas.
- Duración del periodo de conservación.
- Uso de reglas de grabación.
- Métricas generadas por aplicaciones y exporters.

La retención permite controlar ese crecimiento y establecer una política predecible de almacenamiento.

### Retención en Prometheus

Prometheus permite configurar la retención principalmente de dos formas:

- Por tiempo.
- Por tamaño máximo de almacenamiento.

La opción más habitual es la retención basada en tiempo.

Por ejemplo:

```bash
prometheus \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=15d
```

Esta configuración conserva los datos durante aproximadamente 15 días.

También pueden utilizarse unidades como:

```text
h   Horas
d   Días
w   Semanas
y   Años
```

Ejemplos:

```bash
--storage.tsdb.retention.time=24h
--storage.tsdb.retention.time=30d
--storage.tsdb.retention.time=12w
--storage.tsdb.retention.time=1y
```

La configuración debe adaptarse a la capacidad del sistema y a las necesidades del entorno.

### Retención basada en tiempo

La retención basada en tiempo establece una antigüedad máxima para las muestras.

Ejemplo:

```bash
--storage.tsdb.retention.time=30d
```

Significa que Prometheus intentará conservar aproximadamente los últimos 30 días.

Ventajas:

- Es fácil de comprender.
- Permite definir un histórico mínimo.
- Resulta útil para políticas basadas en días o meses.
- Facilita planificar la capacidad necesaria.

Limitaciones:

- El espacio utilizado puede variar según la carga.
- Una cardinalidad elevada puede llenar el disco antes de alcanzar el periodo esperado.
- Un aumento repentino de métricas puede incrementar el consumo rápidamente.

### Retención basada en tamaño

También puede establecerse un límite máximo de almacenamiento:

```bash
--storage.tsdb.retention.size=10GB
```

Esta opción limita el espacio utilizado por la base de datos TSDB de Prometheus.

Se recomienda escribir el tamaño con una unidad explícita, por ejemplo:

```bash
--storage.tsdb.retention.size=10GB
--storage.tsdb.retention.size=50GB
--storage.tsdb.retention.size=500MB
```

La retención basada en tamaño resulta útil cuando el espacio disponible es limitado.

Ventajas:

- Ayuda a evitar que Prometheus ocupe todo el disco.
- Permite trabajar con una capacidad máxima conocida.
- Es adecuada para servidores con almacenamiento fijo.

Limitaciones:

- El periodo real conservado puede variar.
- Con pocas métricas se conservará un periodo más largo.
- Con muchas métricas se conservará un periodo más corto.
- No garantiza un número concreto de días históricos.

### Usar tiempo y tamaño conjuntamente

Es posible definir ambas opciones:

```bash
prometheus \
  --storage.tsdb.retention.time=30d \
  --storage.tsdb.retention.size=20GB
```

En este caso, Prometheus conservará los datos mientras no se supere ninguna de las dos condiciones.

La eliminación se producirá cuando los datos:

- Sean más antiguos que el periodo configurado, o
- Hagan que se supere el tamaño máximo establecido.

Conceptualmente:

```text
Retención efectiva =
el límite que se alcance primero
```

Esta combinación proporciona una protección adicional:

- El límite temporal garantiza un histórico mínimo cuando existe capacidad suficiente.
- El límite de tamaño evita que el almacenamiento crezca demasiado.

Es importante reservar espacio adicional para el sistema operativo y otros ficheros. El límite de retención no debe configurarse igual que la capacidad total del disco.

### Directorio de almacenamiento

Prometheus almacena sus datos en el directorio definido por:

```bash
--storage.tsdb.path
```

En muchas instalaciones sobre Ubuntu se utiliza:

```text
/var/lib/prometheus
```

Ejemplo:

```bash
prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=15d
```

El directorio puede contener:

- Bloques de datos.
- Índices.
- Metadatos.
- Ficheros temporales.
- Información de la TSDB.
- Datos pendientes de compactación.

No se debe borrar manualmente su contenido mientras Prometheus está funcionando.

Una eliminación manual puede provocar:

- Pérdida de métricas.
- Corrupción de datos.
- Errores de arranque.
- Consultas incompletas.
- Problemas con la compactación.

Para modificar o limpiar el almacenamiento debe utilizarse una estrategia controlada.

### Configurar la retención mediante systemd

Cuando Prometheus se instala como servicio systemd, los argumentos suelen definirse en:

```text
/etc/default/prometheus
```

Un ejemplo sería:

```bash
ARGS="--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/var/lib/prometheus \
--storage.tsdb.retention.time=15d \
--storage.tsdb.retention.size=10GB"
```

La ubicación exacta puede variar según el método de instalación.

Después de modificar la configuración:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprobar el estado:

```bash
sudo systemctl status prometheus
```

Consultar los últimos mensajes del servicio:

```bash
sudo journalctl -u prometheus -n 50 --no-pager
```

Comprobar que Prometheus está escuchando:

```bash
sudo ss -lntp | grep 9090
```

El puerto habitual de Prometheus es:

```text
9090
```

### Configurar la retención en un servicio systemd personalizado

Otra posibilidad es definir los argumentos directamente en un fichero de unidad:

```ini
[Service]
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=15d \
  --storage.tsdb.retention.size=10GB
```

Después de modificar la unidad:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprobar la configuración efectiva:

```bash
sudo systemctl cat prometheus
```

También puede consultarse el proceso activo:

```bash
ps aux | grep prometheus
```

Esto permite verificar que los parámetros se han aplicado realmente.

### Espacio de disco y capacidad

El espacio necesario no depende únicamente del número de días.

También influyen:

- Número de series activas.
- Frecuencia de scraping.
- Tamaño de las etiquetas.
- Cardinalidad.
- Número de reglas de grabación.
- Número de objetivos.
- Variación de las métricas.
- Compactación y ficheros temporales.

Para comprobar el espacio disponible:

```bash
df -h
```

Para comprobar el tamaño del directorio de Prometheus:

```bash
sudo du -sh /var/lib/prometheus
```

Para analizar el tamaño de sus subdirectorios:

```bash
sudo du -h --max-depth=1 /var/lib/prometheus
```

Conviene supervisar el almacenamiento con una alerta. Por ejemplo:

```promql
100 *
(
  node_filesystem_size_bytes{
    mountpoint="/var/lib/prometheus"
  }
  -
  node_filesystem_avail_bytes{
    mountpoint="/var/lib/prometheus"
  }
)
/
node_filesystem_size_bytes{
  mountpoint="/var/lib/prometheus"
}
```

La consulta anterior calcula aproximadamente el porcentaje de espacio utilizado en el sistema de archivos que contiene Prometheus.

Es necesario adaptar las etiquetas, especialmente:

```text
mountpoint
instance
job
```

### Métricas útiles de Prometheus

Prometheus expone métricas sobre su propio funcionamiento.

Para consultar el número de muestras almacenadas:

```promql
prometheus_tsdb_head_samples
```

Para consultar el número de series activas:

```promql
prometheus_tsdb_head_series
```

Para observar el tamaño de los bloques:

```promql
prometheus_tsdb_storage_blocks_bytes
```

Para consultar el espacio utilizado por la TSDB:

```promql
prometheus_tsdb_storage_size_bytes
```

Los nombres exactos pueden variar entre versiones. Es recomendable buscar las métricas disponibles en la interfaz de Prometheus:

```text
http://localhost:9090/metrics
```

También pueden utilizarse consultas como:

```promql
prometheus_tsdb_head_series
```

para detectar un crecimiento anormal del número de series.

### Retención y cardinalidad

La cardinalidad tiene un impacto directo sobre la retención.

Supongamos dos instalaciones:

```text
Instalación A:
- 10.000 series activas
- scraping cada 15 segundos

Instalación B:
- 1.000.000 de series activas
- scraping cada 15 segundos
```

Aunque ambas tengan la misma retención configurada, la instalación B necesitará mucho más almacenamiento.

Una etiqueta con valores ilimitados puede hacer crecer rápidamente el número de series:

```text
request_id
user_id
session_id
timestamp
```

Ejemplos más controlados:

```text
method="GET"
status="200"
environment="production"
region="eu-west"
```

Antes de aumentar la retención conviene revisar la cardinalidad:

- Eliminar etiquetas innecesarias.
- Evitar identificadores únicos.
- Revisar métricas generadas por aplicaciones.
- Limitar etiquetas de rutas HTTP.
- Agrupar valores poco relevantes.
- Utilizar reglas de grabación cuando sea apropiado.

### Retención y reglas de grabación

Las reglas de grabación almacenan el resultado de una consulta como una nueva serie temporal.

Ejemplo:

```yaml
groups:
  - name: rendimiento
    interval: 30s
    rules:
      - record: instance:node_cpu_usage:ratio
        expr: |
          1 -
          avg by (instance) (
            rate(node_cpu_seconds_total{
              mode="idle"
            }[5m])
          )
```

La serie generada:

```text
instance:node_cpu_usage:ratio
```

también ocupa almacenamiento.

Las reglas de grabación pueden mejorar el rendimiento de consultas complejas, pero no son gratuitas desde el punto de vista del almacenamiento.

Es necesario considerar:

- El número de reglas.
- La frecuencia de evaluación.
- Las etiquetas resultantes.
- El periodo de retención.
- La utilidad real de cada serie generada.

### Retención y consultas históricas

Un gráfico de Grafana solo puede mostrar datos que todavía existen en Prometheus o en otro sistema de almacenamiento.

Si la retención es de siete días:

```text
Retención: 7 días
```

no será posible consultar directamente datos de hace tres meses desde esa instancia de Prometheus.

Aumentar el selector temporal de Grafana no recuperará datos eliminados:

```text
Últimos 90 días
```

Si Prometheus solo conserva siete días, el gráfico mostrará únicamente el periodo disponible.

Cuando se necesita conservar históricos más largos pueden utilizarse:

- Otra instancia de Prometheus.
- Almacenamiento remoto.
- Sistemas compatibles con Prometheus.
- Copias de seguridad.
- Soluciones de archivado.
- Plataformas de métricas de largo plazo.

### Almacenamiento remoto

Prometheus puede enviar muestras a un sistema remoto mediante `remote_write`.

Ejemplo conceptual:

```yaml
remote_write:
  - url: "https://metrics.example.com/api/v1/write"
```

La configuración real depende del sistema receptor y puede requerir:

- Autenticación.
- Certificados.
- Headers.
- Compresión.
- Colas de envío.
- Control de errores.
- Límites de escritura.

El almacenamiento remoto permite separar:

- Retención local para consultas rápidas y recientes.
- Retención externa para históricos más largos.

Por ejemplo:

```text
Prometheus local:
- Retención: 15 días
- Consultas operativas rápidas

Almacenamiento remoto:
- Retención: 2 años
- Informes y análisis históricos
```

El almacenamiento remoto no elimina la necesidad de configurar correctamente la retención local. Prometheus seguirá necesitando espacio para sus datos locales, bloques y colas pendientes de envío.

### Retención, copias de seguridad y archivado

La retención no es lo mismo que una copia de seguridad.

La retención determina qué datos mantiene Prometheus para las consultas normales.

Una copia de seguridad permite recuperar datos o configuración después de un fallo.

El archivado conserva información durante largos periodos, normalmente con menor frecuencia de consulta.

Una estrategia completa puede incluir:

```text
Datos recientes:
Prometheus local durante 15 días

Datos históricos:
Almacenamiento remoto durante 1 año

Configuración:
Copias de seguridad de prometheus.yml y reglas

Documentación:
Registro de cambios y política de retención
```

No se debe considerar el directorio de datos de Prometheus como sustituto automático de una estrategia de copias de seguridad.

Antes de realizar una copia debe tenerse en cuenta:

- Estado del proceso.
- Consistencia de los bloques.
- Espacio necesario.
- Frecuencia de la copia.
- Cifrado.
- Control de acceso.
- Prueba de restauración.

### Downsampling

El **downsampling** consiste en reducir la resolución de los datos históricos.

Por ejemplo:

```text
Datos recientes:
Una muestra cada 15 segundos

Datos antiguos:
Un promedio cada 5 minutos
```

Esto permite conservar tendencias durante más tiempo utilizando menos espacio.

El downsampling puede conservar:

- Promedios.
- Mínimos.
- Máximos.
- Percentiles.
- Tasas agregadas.

Sin embargo, al reducir la resolución pueden perderse eventos breves y picos.

Por ejemplo, un promedio de cinco minutos puede ocultar un pico de CPU que duró diez segundos.

Por ese motivo, una estrategia habitual es:

```text
Alta resolución:
Últimos 7-15 días

Resolución media:
Últimos 3-6 meses

Resolución reducida:
Uno o varios años
```

La implementación concreta depende de la plataforma de almacenamiento utilizada.

### Retención en un entorno de laboratorio

Para un entorno de prácticas con un único servidor, una configuración razonable podría ser:

```bash
--storage.tsdb.retention.time=15d
--storage.tsdb.retention.size=10GB
```

Esta configuración ofrece:

- Un histórico suficiente para ejercicios.
- Un límite de seguridad para el almacenamiento.
- Un comportamiento sencillo de explicar.
- Un consumo razonable en una máquina virtual.

Para un laboratorio pequeño también podría utilizarse:

```bash
--storage.tsdb.retention.time=7d
--storage.tsdb.retention.size=5GB
```

La elección depende de:

- Número de exporters.
- Número de ejercicios simultáneos.
- Capacidad del disco.
- Frecuencia de scraping.
- Número de métricas generadas.

En producción no debe copiarse automáticamente la configuración del laboratorio. La retención debe basarse en los requisitos operativos y de auditoría.

## Ejemplo

### Configurar Prometheus con 15 días y 10 GB

Supongamos que Prometheus está instalado en Ubuntu y utiliza:

```text
Configuración: /etc/prometheus/prometheus.yml
Datos: /var/lib/prometheus
Servicio: prometheus
```

Los parámetros deseados son:

```text
Retención temporal: 15 días
Límite de almacenamiento: 10 GB
```

Una unidad systemd podría contener:

```ini
[Unit]
Description=Prometheus
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=15d \
  --storage.tsdb.retention.size=10GB \
  --web.listen-address=0.0.0.0:9090

Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Después de guardar los cambios:

```bash
sudo systemctl daemon-reload
sudo systemctl restart prometheus
```

Comprobar el estado:

```bash
sudo systemctl status prometheus
```

Comprobar los argumentos del proceso:

```bash
ps aux | grep '[p]rometheus'
```

Comprobar el espacio utilizado:

```bash
sudo du -sh /var/lib/prometheus
```

Comprobar el espacio libre:

```bash
df -h /var/lib/prometheus
```

### Comprobar la retención desde la interfaz

Accede a:

```text
http://localhost:9090
```

Consulta algunas métricas internas:

```promql
prometheus_tsdb_head_series
```

```promql
prometheus_tsdb_storage_size_bytes
```

También puedes revisar los logs:

```bash
sudo journalctl -u prometheus --since "10 minutes ago"
```

Si existe un error relacionado con los argumentos, el servicio puede no iniciar. Por ejemplo:

- Ruta de configuración incorrecta.
- Directorio de datos inexistente.
- Permisos insuficientes.
- Unidad de tamaño mal escrita.
- Versión de Prometheus incompatible.
- Espacio de disco insuficiente.

### Crear una alerta de almacenamiento

Si Node Exporter monitoriza el sistema de archivos donde se almacenan los datos, se puede crear una regla:

```yaml
groups:
  - name: almacenamiento
    rules:
      - alert: DiscoPrometheusCasiLleno
        expr: |
          100 *
          (
            node_filesystem_size_bytes{
              mountpoint="/var/lib/prometheus",
              fstype!~"tmpfs|overlay"
            }
            -
            node_filesystem_avail_bytes{
              mountpoint="/var/lib/prometheus",
              fstype!~"tmpfs|overlay"
            }
          )
          /
          node_filesystem_size_bytes{
            mountpoint="/var/lib/prometheus",
            fstype!~"tmpfs|overlay"
          }
          > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "El almacenamiento de Prometheus está muy utilizado"
          description: "El sistema de archivos {{ $labels.mountpoint }} supera el 80 % de uso."
```

Para una alerta crítica:

```yaml
      - alert: DiscoPrometheusCritico
        expr: |
          100 *
          (
            node_filesystem_size_bytes{
              mountpoint="/var/lib/prometheus",
              fstype!~"tmpfs|overlay"
            }
            -
            node_filesystem_avail_bytes{
              mountpoint="/var/lib/prometheus",
              fstype!~"tmpfs|overlay"
            }
          )
          /
          node_filesystem_size_bytes{
            mountpoint="/var/lib/prometheus",
            fstype!~"tmpfs|overlay"
          }
          > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "El almacenamiento de Prometheus está casi lleno"
          description: "El sistema de archivos {{ $labels.mountpoint }} supera el 90 % de uso."
```

Las etiquetas de la consulta deben ajustarse al sistema real. El valor de `mountpoint` puede ser diferente si Prometheus utiliza otra ruta o un volumen independiente.

### Estimar el impacto de cambiar la retención

Supongamos que una instalación conserva:

```text
15 días de datos
8 GB utilizados
```

No es correcto calcular automáticamente que:

```text
30 días = 16 GB
```

La estimación puede servir como aproximación inicial, pero el consumo real depende de:

- Variación del número de series.
- Compactación.
- Etiquetas.
- Cambios en los exporters.
- Reglas de grabación.
- Intervalo de scraping.
- Compresión de los bloques.

Antes de ampliar la retención:

1. Comprueba el tamaño actual.
2. Comprueba el número de series.
3. Revisa el espacio libre.
4. Reserva espacio para el sistema.
5. Define un límite máximo.
6. Supervisa el crecimiento durante varios días.
7. Verifica que las alertas de disco funcionan.

## Puntos clave

- La retención define durante cuánto tiempo se conservan las métricas.
- Prometheus elimina progresivamente los datos que superan la política configurada.
- La retención puede configurarse por tiempo, por tamaño o mediante ambas opciones.
- `--storage.tsdb.retention.time` establece una antigüedad máxima aproximada.
- `--storage.tsdb.retention.size` establece un límite máximo de almacenamiento.
- Cuando se configuran ambos límites, se aplica el que se alcanza primero.
- El consumo depende de la cardinalidad, el scraping y el número de series.
- Una retención larga requiere más almacenamiento.
- Una retención corta puede impedir analizar incidentes antiguos.
- Las reglas de grabación generan nuevas series y también consumen almacenamiento.
- Grafana solo puede mostrar datos que todavía existen en el sistema de almacenamiento.
- La retención no es lo mismo que una copia de seguridad.
- El downsampling reduce la resolución para conservar históricos durante más tiempo.
- El almacenamiento remoto permite separar datos recientes e históricos.
- No se debe eliminar manualmente el contenido de la TSDB mientras Prometheus está activo.
- Es necesario supervisar el espacio de disco utilizado por Prometheus.
- La cardinalidad elevada puede reducir considerablemente el periodo real conservado.
- Una política de retención debe adaptarse a los objetivos del sistema.
- En un laboratorio, una retención de 7 o 15 días suele ser suficiente.
- En producción, la retención debe tener en cuenta requisitos operativos, de capacidad y de cumplimiento.

## Preguntas de comprobación

1. ¿Qué significa retener datos en Prometheus?
2. ¿Por qué es necesaria una política de retención?
3. ¿Qué opción configura la retención basada en tiempo?
4. ¿Qué opción configura la retención basada en tamaño?
5. ¿Qué ocurre cuando se configuran simultáneamente los límites de tiempo y tamaño?
6. ¿Qué factores influyen en el espacio ocupado por Prometheus?
7. ¿Por qué dos instalaciones con la misma retención pueden utilizar cantidades diferentes de disco?
8. ¿Qué función cumple la opción `--storage.tsdb.path`?
9. ¿Por qué no se debe borrar manualmente el contenido de la TSDB con Prometheus en ejecución?
10. ¿Qué diferencia existe entre retención y copia de seguridad?
11. ¿Qué diferencia existe entre retención y archivado?
12. ¿Qué es el downsampling?
13. ¿Qué información puede perderse al reducir la resolución de los datos?
14. ¿Qué impacto tiene una cardinalidad elevada sobre la retención?
15. ¿Por qué las reglas de grabación también consumen almacenamiento?
16. ¿Qué consulta puede utilizarse para observar el número de series activas?
17. ¿Cómo comprobarías el tamaño ocupado por el directorio de Prometheus?
18. ¿Por qué es recomendable configurar una alerta sobre el espacio disponible?
19. ¿Qué estrategia utilizarías para conservar datos recientes y datos históricos?
20. ¿Qué periodo de retención elegirías para un laboratorio y qué factores tendrías en cuenta?