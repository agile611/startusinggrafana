# Grafana y las fuentes de datos

## Objetivos

Al finalizar esta sección podrás:

- Explicar qué es una fuente de datos en Grafana.
- Diferenciar entre una fuente de datos y un dashboard.
- Comprender cómo se conecta Grafana con Prometheus.
- Configurar una fuente de datos de tipo Prometheus.
- Probar la conectividad y validar una configuración.
- Utilizar una fuente de datos en consultas y paneles.
- Comprender la importancia de las variables y permisos.
- Identificar problemas habituales de conexión y resolución de errores.

## Introducción

Grafana es una plataforma de visualización y observabilidad que permite consultar, representar y analizar datos procedentes de diferentes sistemas.

Grafana no suele almacenar las métricas principales. En lugar de eso, se conecta a una o varias **fuentes de datos** y ejecuta consultas contra ellas.

Algunas fuentes de datos habituales son:

- Prometheus.
- Loki.
- Elasticsearch.
- InfluxDB.
- MySQL.
- PostgreSQL.
- Microsoft SQL Server.
- Tempo.
- Jaeger.
- CloudWatch.
- Azure Monitor.
- Google Cloud Monitoring.

En un entorno de monitorización con Prometheus, el flujo habitual es:

```text
Exporters y aplicaciones
          │
          │ Métricas
          ▼
      Prometheus
          │
          │ Consultas PromQL
          ▼
       Grafana
          │
          ▼
 Dashboards, paneles y alertas
```

Prometheus recopila y almacena las métricas. Grafana consulta esas métricas y las representa mediante gráficos, indicadores, tablas y otros tipos de visualización.

## Contenido

### ¿Qué es una fuente de datos?

Una fuente de datos es una conexión configurada en Grafana para acceder a un sistema externo.

La configuración puede incluir:

- Tipo de sistema.
- URL o dirección del servicio.
- Método de acceso.
- Credenciales.
- Certificados.
- Opciones de consulta.
- Tiempo de espera.
- Configuración de acceso desde Grafana o desde el navegador.

Una fuente de datos no es un dashboard.

La diferencia principal es:

| Elemento | Función |
|---|---|
| Fuente de datos | Define dónde se encuentran los datos |
| Consulta | Solicita datos a la fuente |
| Panel | Representa el resultado de una consulta |
| Dashboard | Agrupa varios paneles |
| Alerta | Evalúa una condición sobre los datos |

Un mismo origen de datos puede utilizarse en muchos dashboards y paneles.

### Fuentes de datos y plugins

Grafana utiliza integraciones o plugins para comunicarse con diferentes sistemas.

El plugin de Prometheus permite:

- Ejecutar consultas PromQL.
- Consultar series temporales.
- Utilizar etiquetas.
- Crear variables de dashboard.
- Representar métricas.
- Configurar alertas basadas en datos de Prometheus.

La disponibilidad de determinadas funciones puede depender de la versión de Grafana y del tipo de fuente configurada.

### Comunicación entre Grafana y Prometheus

Cuando Grafana consulta Prometheus, normalmente realiza solicitudes HTTP contra la API de Prometheus.

Si Grafana y Prometheus están instalados en el mismo servidor, la dirección puede ser:

```text
http://localhost:9090
```

Si Grafana está instalado en otro servidor:

```text
http://192.168.1.50:9090
```

Si ambos servicios se ejecutan mediante Docker Compose, no suele utilizarse `localhost` desde el contenedor de Grafana. En ese caso se utiliza el nombre del servicio:

```text
http://prometheus:9090
```

Esto se debe a que, dentro de un contenedor, `localhost` hace referencia al propio contenedor de Grafana, no al contenedor de Prometheus.

### Configurar Prometheus como fuente de datos

Para añadir Prometheus desde la interfaz de Grafana:

1. Accede a Grafana.
2. Abre el menú de configuración.
3. Selecciona **Data sources**.
4. Pulsa **Add data source**.
5. Selecciona **Prometheus**.
6. Introduce la URL de Prometheus.
7. Configura las opciones necesarias.
8. Pulsa **Save & test**.

La dirección básica sería:

```text
http://localhost:9090
```

En una instalación separada:

```text
http://prometheus:9090
```

En un entorno con HTTPS:

```text
https://prometheus.example.com
```

La URL debe ser accesible desde el lugar donde Grafana realiza la consulta.

### Acceso desde el servidor y desde el navegador

Grafana puede consultar una fuente de datos de dos formas habituales:

- **Server**: Grafana realiza la consulta desde el servidor.
- **Browser**: el navegador del usuario realiza la consulta directamente.

La opción recomendada para Prometheus suele ser:

```text
Access: Server
```

Con esta opción:

```text
Navegador → Grafana → Prometheus
```

El navegador no necesita acceder directamente a Prometheus.

Con acceso desde el navegador:

```text
Navegador → Prometheus
```

pueden aparecer problemas de:

- CORS.
- Firewall.
- Resolución DNS.
- Certificados.
- Direcciones privadas.
- Exposición innecesaria de Prometheus.

Por razones de seguridad y conectividad, normalmente es preferible que Grafana actúe como intermediario.

### Probar la fuente de datos

Después de introducir la URL de Prometheus, utiliza:

```text
Save & test
```

Si la conexión funciona, Grafana mostrará un mensaje de confirmación.

Si falla, revisa:

- Que Prometheus esté iniciado.
- Que la URL sea correcta.
- Que el puerto esté abierto.
- Que Grafana pueda resolver el nombre del servidor.
- Que exista conectividad de red.
- Que no haya un firewall bloqueando la conexión.
- Que el protocolo sea correcto: `http` o `https`.
- Que el certificado sea válido cuando se use HTTPS.

Desde el servidor de Grafana se puede comprobar la conexión con:

```bash
curl http://localhost:9090/-/ready
```

Una respuesta correcta suele ser:

```text
Prometheus is Ready.
```

También puede consultarse la API:

```bash
curl http://localhost:9090/api/v1/status/buildinfo
```

Para comprobar que responde con datos:

```bash
curl 'http://localhost:9090/api/v1/query?query=up'
```

Si Grafana está en otro equipo, sustituye `localhost` por el nombre o la dirección correspondiente.

### Consultas PromQL en Grafana

Cuando la fuente de datos está configurada, los paneles pueden utilizar consultas PromQL.

Para comprobar los objetivos disponibles:

```promql
up
```

Para consultar únicamente los objetivos de Node Exporter:

```promql
up{job="node"}
```

Para consultar la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Para convertir bytes a gigabytes:

```promql
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

Para obtener solicitudes por segundo:

```promql
sum(
  rate(http_requests_total[5m])
)
```

Para agrupar solicitudes por código de estado:

```promql
sum by (status) (
  rate(http_requests_total[5m])
)
```

Grafana envía estas consultas a Prometheus y utiliza los resultados para generar la visualización seleccionada.

### Crear un panel con Prometheus

Para crear un panel:

1. Abre un dashboard.
2. Selecciona **Add panel**.
3. Selecciona la fuente de datos de Prometheus.
4. Introduce una consulta PromQL.
5. Selecciona el tipo de visualización.
6. Configura la unidad.
7. Añade una descripción o leyenda.
8. Guarda el panel.

Para representar la disponibilidad de los objetivos:

```promql
up
```

Una visualización adecuada puede ser:

```text
Time series
```

o:

```text
Stat
```

Para representar el porcentaje de CPU:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

La unidad recomendada es:

```text
Percent (0-100)
```

Para representar la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

La unidad recomendada es:

```text
Bytes (IEC)
```

Configurar correctamente la unidad evita interpretaciones incorrectas.

### Intervalo temporal y resolución

Grafana permite seleccionar un intervalo temporal para cada dashboard o panel:

- Últimos 5 minutos.
- Última hora.
- Últimas 6 horas.
- Últimos 7 días.
- Últimos 30 días.
- Intervalo personalizado.

El intervalo seleccionado influye en:

- La cantidad de datos consultados.
- La resolución de la consulta.
- El tiempo de respuesta.
- La cantidad de puntos representados.

Un panel de las últimas dos horas no necesita la misma resolución que un panel de los últimos doce meses.

En Grafana también se puede definir un intervalo mínimo para evitar que se soliciten demasiados puntos:

```text
Min interval: 15s
```

Este valor debe relacionarse con el intervalo de scraping de Prometheus.

Si Prometheus recopila datos cada 15 segundos, solicitar una resolución de 1 segundo no crea información adicional. Solo puede generar consultas innecesariamente costosas.

### Variables de dashboard

Las variables permiten cambiar dinámicamente el contenido de un dashboard.

Una variable puede representar:

- Una instancia.
- Un trabajo.
- Un entorno.
- Un servicio.
- Un código de estado.
- Un dispositivo.

Por ejemplo, una variable llamada:

```text
instance
```

puede obtener sus valores con:

```promql
label_values(up, instance)
```

Según la versión y el editor disponible, la configuración puede realizarse mediante una consulta de variables basada en etiquetas.

Después, la consulta del panel puede utilizar la variable:

```promql
up{instance="$instance"}
```

Para permitir seleccionar múltiples instancias:

```promql
up{instance=~"$instance"}
```

La expresión:

```text
=~
```

permite utilizar coincidencias mediante expresiones regulares.

Una variable puede mejorar la reutilización del dashboard y evitar crear un panel independiente para cada servidor.

### Variables de trabajo

Una variable para seleccionar trabajos puede obtener valores a partir de:

```promql
label_values(up, job)
```

Después se puede utilizar así:

```promql
up{job="$job"}
```

Para seleccionar todos los trabajos:

```promql
up{job=~"$job"}
```

Las variables deben utilizarse con cuidado cuando existan muchas combinaciones, porque una consulta muy amplia puede aumentar el tiempo de respuesta.

### Seleccionar una fuente de datos mediante una variable

En dashboards reutilizables puede ser útil seleccionar la fuente de datos mediante una variable de tipo **Datasource**.

Esto permite utilizar el mismo dashboard con:

- Prometheus de desarrollo.
- Prometheus de pruebas.
- Prometheus de producción.
- Diferentes organizaciones.
- Diferentes entornos.

La consulta puede utilizar la variable de fuente de datos seleccionada en el panel.

Esta opción resulta especialmente útil cuando el dashboard debe importarse en varios entornos.

### Fuentes de datos predeterminadas

Grafana puede marcar una fuente como predeterminada.

Cuando una fuente es predeterminada:

- Los nuevos paneles pueden seleccionarla automáticamente.
- Se reduce la configuración repetitiva.
- Los dashboards sencillos son más rápidos de crear.

En un laboratorio con una única instancia de Prometheus, puede ser conveniente establecerla como predeterminada.

En entornos con varias fuentes, conviene seleccionar explícitamente la fuente en cada dashboard para evitar errores.

### Organización de las fuentes de datos

En un entorno pequeño puede existir una única fuente:

```text
Prometheus
```

En un entorno mayor pueden existir varias:

```text
Prometheus - Desarrollo
Prometheus - Pruebas
Prometheus - Producción
Loki - Producción
Tempo - Producción
```

Es recomendable utilizar nombres claros.

Un nombre ambiguo como:

```text
Metrics
```

puede causar errores cuando existen varios sistemas.

Un nombre más descriptivo sería:

```text
Prometheus - Producción - Europa
```

También conviene documentar:

- Dirección del servicio.
- Propósito de la fuente.
- Entorno.
- Responsable.
- Método de autenticación.
- Política de acceso.
- Retención disponible.

### Autenticación y seguridad

Una fuente de datos puede requerir autenticación mediante:

- Usuario y contraseña.
- Token.
- Certificado de cliente.
- Cabeceras HTTP.
- Proxy de autenticación.
- OAuth.
- Autenticación integrada en un servicio externo.

No se deben incluir credenciales directamente en dashboards o consultas.

Las credenciales deben gestionarse desde la configuración de la fuente de datos y protegerse mediante:

- Variables de entorno.
- Secretos de GitHub Actions.
- Secretos de Kubernetes.
- Sistemas de gestión de secretos.
- Permisos mínimos necesarios.
- Rotación periódica.

También se recomienda:

- Utilizar HTTPS cuando los datos atraviesen redes no confiables.
- Restringir el acceso a la API de Prometheus.
- No exponer Prometheus directamente a Internet.
- Aplicar reglas de firewall.
- Limitar los permisos de los usuarios de Grafana.
- Revisar los logs de acceso.

### Permisos en Grafana

Grafana permite controlar el acceso mediante:

- Usuarios.
- Equipos.
- Carpetas.
- Organizaciones.
- Roles.
- Permisos sobre dashboards.
- Permisos sobre fuentes de datos.

Un usuario puede tener permiso para:

- Visualizar dashboards.
- Editar dashboards.
- Crear paneles.
- Administrar fuentes de datos.
- Gestionar alertas.
- Administrar usuarios.

Es recomendable conceder únicamente los permisos necesarios.

Por ejemplo:

```text
Usuario estudiante:
- Ver dashboards
- Ejecutar consultas permitidas

Usuario administrador:
- Gestionar fuentes de datos
- Editar dashboards
- Administrar usuarios
```

### Provisioning de fuentes de datos

Grafana permite definir fuentes de datos mediante ficheros de configuración.

Una estructura habitual es:

```text
/etc/grafana/provisioning/datasources/
└── prometheus.yml
```

Ejemplo:

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

En algunas versiones y configuraciones se utiliza el valor:

```yaml
access: proxy
```

para indicar que Grafana realiza las consultas desde el servidor.

La opción:

```yaml
isDefault: true
```

marca la fuente como predeterminada.

Después de crear o modificar el fichero, reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprobar el estado:

```bash
sudo systemctl status grafana-server
```

Consultar los logs:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

### Provisioning con credenciales

Si la fuente necesita credenciales, es preferible utilizar variables de entorno o un sistema de secretos.

Ejemplo conceptual:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: https://prometheus.example.com
    basicAuth: true
    basicAuthUser: ${PROMETHEUS_USER}
    secureJsonData:
      basicAuthPassword: ${PROMETHEUS_PASSWORD}
    isDefault: true
```

La disponibilidad exacta de la sustitución de variables depende de la versión y del método de despliegue.

Nunca se deben subir contraseñas reales a un repositorio público.

### Provisioning y GitOps

El provisioning permite gestionar la configuración como código.

Ventajas:

- Repetibilidad.
- Historial de cambios.
- Revisión mediante pull requests.
- Despliegues automatizados.
- Menor configuración manual.
- Facilidad para reconstruir un entorno.

Una estructura posible sería:

```text
grafana/
├── provisioning/
│   ├── datasources/
│   │   └── prometheus.yml
│   └── dashboards/
│       └── dashboards.yml
└── dashboards/
    └── infraestructura.json
```

Este enfoque resulta especialmente útil para laboratorios, equipos y despliegues automatizados.

### Errores habituales

#### `localhost` apunta al lugar equivocado

Si Grafana está en un contenedor y Prometheus en otro, esta URL puede ser incorrecta:

```text
http://localhost:9090
```

Debe utilizarse el nombre del servicio dentro de la red de contenedores:

```text
http://prometheus:9090
```

#### Prometheus no está iniciado

Comprobar:

```bash
sudo systemctl status prometheus
```

Iniciar:

```bash
sudo systemctl start prometheus
```

#### Puerto inaccesible

Comprobar si Prometheus escucha:

```bash
sudo ss -lntp | grep 9090
```

Probar localmente:

```bash
curl http://localhost:9090/-/ready
```

#### Problemas de DNS

Comprobar la resolución:

```bash
getent hosts prometheus.example.com
```

En Docker:

```bash
docker exec -it grafana getent hosts prometheus
```

#### Error de protocolo

Si Prometheus utiliza HTTPS, no debe configurarse:

```text
http://prometheus.example.com
```

sino:

```text
https://prometheus.example.com
```

#### Problemas con certificados

Un certificado no válido puede provocar errores de conexión. No se recomienda desactivar la validación en producción como solución permanente.

Es preferible:

- Instalar una autoridad certificadora válida.
- Utilizar un certificado correcto.
- Configurar la cadena de confianza.
- Revisar el nombre DNS del certificado.

#### Consulta sin resultados

Si una consulta no devuelve datos, comprueba:

- Que el nombre de la métrica sea correcto.
- Que las etiquetas existan.
- Que el intervalo temporal contenga datos.
- Que el objetivo esté disponible.
- Que Prometheus haya recopilado la métrica.
- Que no haya filtros demasiado restrictivos.

Probar primero con:

```promql
up
```

Después:

```promql
count({__name__=~".+"})
```

Y finalmente con una métrica concreta.

## Ejemplo

### Configurar Grafana y Prometheus en Ubuntu

Supongamos que:

```text
Grafana: 192.168.1.20
Prometheus: 192.168.1.50
Puerto de Prometheus: 9090
```

Desde el servidor de Grafana se comprueba la conectividad:

```bash
curl http://192.168.1.50:9090/-/ready
```

Si la respuesta es correcta, en Grafana se configura:

```text
Name: Prometheus
Type: Prometheus
URL: http://192.168.1.50:9090
Access: Server
```

Después se pulsa:

```text
Save & test
```

La primera consulta del panel puede ser:

```promql
up
```

Si existen objetivos configurados, deberían aparecer series con valores como:

```text
1
```

Un valor igual a `1` indica que el objetivo respondió correctamente durante el último scraping.

### Crear un panel de CPU

Consulta:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  )
)
```

Configuración recomendada:

```text
Visualización: Time series
Unidad: Percent (0-100)
Leyenda: {{instance}}
Título: Uso de CPU
```

La consulta obtiene el porcentaje de CPU no inactiva agrupado por instancia.

### Crear un panel de memoria

Consulta:

```promql
node_memory_MemAvailable_bytes
```

Configuración:

```text
Visualización: Time series
Unidad: Bytes (IEC)
Leyenda: {{instance}}
Título: Memoria disponible
```

Para mostrar gigabytes:

```promql
node_memory_MemAvailable_bytes
/ 1024
/ 1024
/ 1024
```

En este caso la unidad puede configurarse como:

```text
Gigabytes (decimal)
```

o una unidad equivalente según la versión de Grafana.

### Crear un panel de objetivos caídos

Consulta:

```promql
up == 0
```

Visualización recomendada:

```text
Table
```

o:

```text
Stat
```

Para mostrar el estado de todos los objetivos:

```promql
up
```

Una tabla puede incluir:

- `job`.
- `instance`.
- Valor de `up`.
- Última actualización.

Si el resultado es `0`, el objetivo no respondió correctamente durante el último scraping.

### Crear un dashboard reutilizable

Añade una variable llamada:

```text
instance
```

Obtén sus valores a partir de la etiqueta `instance`.

Después, utiliza la variable en las consultas:

```promql
100 *
(
  1 -
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  )
)
```

Configura la variable para permitir:

```text
Multi-value: activado
Include All option: activado
```

Con esto, el mismo dashboard puede mostrar:

- Un servidor concreto.
- Varios servidores.
- Todos los servidores.

### Configurar la fuente mediante provisioning

Crear el directorio:

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

Crear el fichero:

```bash
sudo nano /etc/grafana/provisioning/datasources/prometheus.yml
```

Contenido:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://192.168.1.50:9090
    isDefault: true
    editable: true
```

Reiniciar Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprobar:

```bash
sudo systemctl status grafana-server
```

Al acceder a Grafana, la fuente de datos debería aparecer configurada automáticamente.

## Puntos clave

- Grafana visualiza datos procedentes de fuentes externas.
- Una fuente de datos define cómo se conecta Grafana con un sistema de almacenamiento.
- Prometheus almacena métricas y Grafana las consulta mediante PromQL.
- Un dashboard está formado por uno o varios paneles.
- Un panel ejecuta una consulta y representa sus resultados.
- La opción `Server` permite que Grafana realice las consultas desde el servidor.
- En Docker, `localhost` hace referencia al contenedor actual.
- Las fuentes de datos deben probarse con **Save & test**.
- La consulta `up` es útil para comprobar que Prometheus contiene datos.
- Las variables permiten reutilizar dashboards en varios servidores y entornos.
- Las fuentes de datos pueden configurarse manualmente o mediante provisioning.
- El provisioning permite gestionar la configuración como código.
- Las credenciales no deben almacenarse directamente en dashboards o repositorios públicos.
- El acceso a Prometheus debe protegerse mediante red, autenticación y permisos.
- Una fuente predeterminada facilita la creación de paneles sencillos.
- Una consulta sin resultados no siempre significa que Grafana esté fallando.
- Los problemas pueden estar en la métrica, las etiquetas, el intervalo temporal o la conectividad.
- Grafana no sustituye a Prometheus: cada herramienta cumple una función diferente.
- Prometheus recopila y almacena métricas.
- Grafana consulta, visualiza y ayuda a interpretar esas métricas.

## Preguntas de comprobación

1. ¿Qué es una fuente de datos en Grafana?
2. ¿Qué diferencia existe entre una fuente de datos, un panel y un dashboard?
3. ¿Qué función cumple Prometheus en una arquitectura con Grafana?
4. ¿Qué protocolo utiliza normalmente Grafana para consultar Prometheus?
5. ¿Qué URL se utilizaría si Prometheus está instalado en el mismo servidor que Grafana?
6. ¿Por qué `localhost` puede ser incorrecto cuando Grafana y Prometheus se ejecutan en contenedores diferentes?
7. ¿Qué función cumple la opción **Save & test**?
8. ¿Qué consulta PromQL permite comprobar la disponibilidad de los objetivos?
9. ¿Qué indica normalmente el valor `up = 1`?
10. ¿Qué indica normalmente el valor `up = 0`?
11. ¿Qué ventajas ofrece utilizar el acceso `Server`?
12. ¿Para qué sirven las variables de dashboard?
13. ¿Qué diferencia existe entre una configuración manual y el provisioning?
14. ¿Por qué no deben almacenarse contraseñas directamente en un repositorio?
15. ¿Qué comprobarías si Grafana no puede conectarse con Prometheus?
16. ¿Qué factores revisarías si una consulta no devuelve resultados?
17. ¿Qué unidad utilizarías para una métrica de memoria expresada en bytes?
18. ¿Qué unidad utilizarías para una consulta que devuelve un porcentaje?
19. ¿Por qué es útil utilizar nombres descriptivos para las fuentes de datos?
20. ¿Qué ventajas proporciona gestionar Grafana mediante configuración como código?
```