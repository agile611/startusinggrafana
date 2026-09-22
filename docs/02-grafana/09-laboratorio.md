Aquí tienes una página Markdown completa, lista para guardar como:

```text
docs/02-grafana/09-laboratorio.md
```

```markdown
# Laboratorio - Instalación y primeros pasos con Grafana

## Objetivos

Al finalizar este laboratorio podrás:

- Comprobar los requisitos de un sistema Ubuntu para instalar Grafana.
- Instalar Grafana mediante el repositorio oficial.
- Iniciar y habilitar el servicio `grafana-server`.
- Acceder a la interfaz web de Grafana.
- Cambiar la contraseña inicial del administrador.
- Configurar una fuente de datos Prometheus.
- Crear un dashboard básico.
- Añadir filas y paneles de visualización.
- Utilizar el selector de rango de tiempo.
- Ejecutar consultas PromQL sencillas.
- Verificar el funcionamiento de la instalación.
- Diagnosticar problemas básicos de acceso y conectividad.

## Introducción

En este laboratorio se realizará una instalación completa de Grafana en Ubuntu 24.04.5 LTS.

El ejercicio cubrirá el ciclo básico de trabajo:

```text
Comprobar requisitos
        │
        ▼
Instalar Grafana
        │
        ▼
Iniciar el servicio
        │
        ▼
Acceder a la interfaz web
        │
        ▼
Configurar la cuenta de administrador
        │
        ▼
Añadir Prometheus
        │
        ▼
Crear un dashboard
        │
        ▼
Validar las visualizaciones
```

La arquitectura del laboratorio será:

```text
Ubuntu 24.04.5 LTS
├── Grafana :3000
├── Prometheus :9090
└── Node Exporter :9100
```

Grafana se utilizará como plataforma de visualización y Prometheus como fuente de datos de métricas.

La configuración recomendada para una máquina virtual de laboratorio es:

| Recurso | Recomendación |
|---|---:|
| CPU | 2 vCPU |
| Memoria RAM | 4 GB |
| Almacenamiento | 20 GB |
| Sistema operativo | Ubuntu Server 24.04.5 LTS |
| Grafana | Puerto `3000` |
| Prometheus | Puerto `9090` |
| Node Exporter | Puerto `9100` |

El laboratorio puede realizarse con Prometheus instalado en el mismo servidor o en un sistema independiente.

## Contenido

### Requisitos previos

Antes de comenzar, comprueba que dispones de:

- Un servidor Ubuntu 24.04.5 LTS.
- Un usuario con permisos `sudo`.
- Acceso a Internet.
- Un navegador web.
- Dirección IP o nombre DNS del servidor.
- Prometheus instalado y accesible.
- Node Exporter instalado, si se desean consultar métricas del sistema.
- El puerto `3000/tcp` disponible.

Comprueba la versión de Ubuntu:

```bash
lsb_release -a
```

Comprueba la arquitectura:

```bash
uname -m
```

Comprueba la memoria disponible:

```bash
free -h
```

Comprueba el espacio libre:

```bash
df -h
```

Comprueba si el puerto de Grafana está ocupado:

```bash
sudo ss -lntp | grep ':3000' \
  || echo "El puerto 3000 está disponible"
```

### Comprobar Prometheus

Si Prometheus está instalado en el mismo servidor:

```bash
curl http://localhost:9090/-/ready
```

Si Prometheus está instalado en otro servidor:

```bash
curl http://DIRECCION_IP_PROMETHEUS:9090/-/ready
```

Una respuesta correcta debe indicar que Prometheus está preparado para recibir consultas.

Comprueba también la API de Prometheus:

```bash
curl http://localhost:9090/api/v1/status/buildinfo
```

Si Prometheus no responde, resuelve ese problema antes de continuar con la configuración de Grafana.

### Comprobar Node Exporter

Si Node Exporter está instalado en el mismo servidor:

```bash
curl http://localhost:9100/metrics | head
```

Si está instalado en otro servidor:

```bash
curl http://DIRECCION_IP_NODE_EXPORTER:9100/metrics | head
```

Una respuesta correcta debe mostrar métricas con nombres similares a:

```text
# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
# TYPE node_cpu_seconds_total counter
```

Si Node Exporter no está disponible, Grafana podrá funcionar, pero no mostrará métricas del sistema a través de Prometheus.

## Instalación de Grafana

### Actualizar Ubuntu

Actualiza la información de los paquetes:

```bash
sudo apt update
```

Instala las actualizaciones disponibles:

```bash
sudo apt upgrade -y
```

Reinicia el sistema si el proceso de actualización lo requiere:

```bash
sudo reboot
```

Después del reinicio, vuelve a conectarte al servidor.

### Instalar las dependencias

Instala las herramientas necesarias:

```bash
sudo apt install -y \
  ca-certificates \
  wget \
  gnupg \
  apt-transport-https \
  software-properties-common
```

Comprueba que `wget` está disponible:

```bash
wget --version
```

Comprueba que `gpg` está disponible:

```bash
gpg --version
```

### Añadir la clave del repositorio

Crea el directorio para las claves de repositorios:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
```

Descarga y almacena la clave del repositorio de Grafana:

```bash
wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

Comprueba que el fichero existe:

```bash
sudo ls -l /etc/apt/keyrings/grafana.gpg
```

### Añadir el repositorio

Crea el fichero del repositorio:

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
```

Comprueba su contenido:

```bash
cat /etc/apt/sources.list.d/grafana.list
```

Actualiza el índice de paquetes:

```bash
sudo apt update
```

Comprueba la versión disponible:

```bash
apt policy grafana
```

### Instalar el paquete

Instala Grafana:

```bash
sudo apt install -y grafana
```

Comprueba que el paquete está instalado:

```bash
dpkg -l | grep grafana
```

Consulta la versión instalada:

```bash
grafana-server --version
```

## Puesta en marcha del servicio

### Iniciar Grafana

Recarga las unidades de `systemd`:

```bash
sudo systemctl daemon-reload
```

Inicia Grafana:

```bash
sudo systemctl start grafana-server
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

El estado esperado es:

```text
Active: active (running)
```

### Habilitar el inicio automático

Configura Grafana para iniciarse automáticamente con Ubuntu:

```bash
sudo systemctl enable grafana-server
```

También puedes habilitarlo e iniciarlo en un único comando:

```bash
sudo systemctl enable --now grafana-server
```

Comprueba que está habilitado:

```bash
systemctl is-enabled grafana-server
```

La salida esperada es:

```text
enabled
```

Comprueba que está activo:

```bash
systemctl is-active grafana-server
```

La salida esperada es:

```text
active
```

### Comprobar el puerto

Verifica que Grafana escucha en el puerto `3000`:

```bash
sudo ss -lntp | grep ':3000'
```

Comprueba la respuesta HTTP:

```bash
curl -I http://localhost:3000
```

Consulta la API de salud:

```bash
curl -s http://localhost:3000/api/health
```

La respuesta debe indicar que la base de datos está disponible.

### Consultar los logs

Consulta los últimos mensajes:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

Consulta los logs en tiempo real:

```bash
sudo journalctl -u grafana-server -f
```

Para salir de la vista en tiempo real, pulsa:

```text
Ctrl+C
```

## Acceso a Grafana

### Acceso local

Si el navegador se ejecuta en el mismo servidor, abre:

```text
http://localhost:3000
```

También puedes utilizar:

```text
http://127.0.0.1:3000
```

### Acceso remoto

Obtén la dirección IP del servidor:

```bash
hostname -I
```

También puedes utilizar:

```bash
ip -br address
```

Desde otro equipo, abre:

```text
http://DIRECCION_IP_DEL_SERVIDOR:3000
```

Por ejemplo:

```text
http://192.168.1.50:3000
```

### Comprobar el acceso desde el cliente

Desde el equipo cliente, comprueba el puerto:

```bash
nc -vz DIRECCION_IP_DEL_SERVIDOR 3000
```

Comprueba la respuesta HTTP:

```bash
curl -I http://DIRECCION_IP_DEL_SERVIDOR:3000
```

Si el acceso local funciona, pero el remoto no, revisa:

- Dirección IP.
- Firewall del servidor.
- Reglas de red.
- Configuración de escucha.
- Reglas de seguridad de la máquina virtual.
- Conectividad entre los equipos.

### Configurar el firewall

Comprueba el estado de UFW:

```bash
sudo ufw status verbose
```

Para permitir el acceso desde una red local:

```bash
sudo ufw allow from 192.168.1.0/24 \
  to any port 3000 proto tcp
```

Para permitir el acceso desde una sola dirección:

```bash
sudo ufw allow from 192.168.1.25 \
  to any port 3000 proto tcp
```

Comprueba las reglas:

```bash
sudo ufw status numbered
```

No expongas el puerto de Grafana a Internet sin medidas adicionales de seguridad.

## Configuración inicial

### Primer inicio de sesión

En una instalación nueva, utiliza las credenciales iniciales:

```text
Usuario: admin
Contraseña: admin
```

Grafana solicitará cambiar la contraseña.

Establece una contraseña:

- Larga.
- Única.
- Difícil de adivinar.
- No reutilizada en otros servicios.
- Guardada de forma segura.

No conserves las credenciales predeterminadas.

### Configurar la zona horaria

Comprueba la zona horaria del sistema:

```bash
timedatectl
```

Si es necesario, configura la zona horaria:

```bash
sudo timedatectl set-timezone Europe/Madrid
```

Comprueba la hora:

```bash
date
```

En Grafana, selecciona una de estas opciones según las necesidades del laboratorio:

```text
Zona horaria local del navegador
UTC
Europe/Madrid
```

La zona horaria debe ser coherente cuando se comparen Grafana, Prometheus y los sistemas monitorizados.

### Revisar las preferencias

Revisa las preferencias del usuario:

- Tema de la interfaz.
- Idioma.
- Zona horaria.
- Dashboard de inicio.
- Preferencias de visualización.

Para este laboratorio se recomienda utilizar:

```text
Zona horaria: Europe/Madrid o la del navegador
Tema: libre
Dashboard inicial: el dashboard del laboratorio
```

## Configurar Prometheus como fuente de datos

### Comprobar la dirección de Prometheus

Si Prometheus está en el mismo servidor:

```text
http://localhost:9090
```

Si está en otro servidor:

```text
http://192.168.1.60:9090
```

Si Grafana se ejecuta en un contenedor, `localhost` puede hacer referencia al propio contenedor y no al servidor donde se encuentra Prometheus.

En ese caso, utiliza:

- El nombre del servicio de Docker.
- La dirección IP del host.
- El nombre DNS correspondiente.
- Una red compartida entre contenedores.

### Añadir la fuente desde la interfaz

En Grafana:

1. Abre la configuración.
2. Accede a **Data sources** o **Fuentes de datos**.
3. Selecciona **Add data source**.
4. Elige **Prometheus**.
5. Introduce la URL de Prometheus.
6. Utiliza el modo de acceso del servidor o proxy.
7. Guarda la configuración.
8. Ejecuta la prueba de conexión.

Para una instalación local:

```text
Name: Prometheus
URL: http://localhost:9090
Access: Server
```

La conexión debe finalizar con un mensaje equivalente a:

```text
Data source is working
```

### Comprobar la fuente de datos

Desde el servidor de Grafana:

```bash
curl http://localhost:9090/-/ready
```

Desde Grafana, abre el explorador de datos y selecciona:

```text
Prometheus
```

Ejecuta la consulta:

```promql
up
```

Si devuelve resultados, Grafana puede consultar Prometheus correctamente.

## Crear el dashboard del laboratorio

### Crear el dashboard

Crea un dashboard nuevo con el nombre:

```text
Laboratorio - Infraestructura Linux
```

Guárdalo en una carpeta llamada:

```text
Laboratorio
```

Configura el rango temporal inicial:

```text
Últimas 6 horas
```

Configura la actualización automática:

```text
Cada 1 minuto
```

La estructura será:

```text
Laboratorio - Infraestructura Linux
├── Resumen
├── CPU y carga
├── Memoria
└── Almacenamiento
```

### Crear la fila Resumen

Crea una fila llamada:

```text
Resumen
```

Añade un panel de tipo `Stat` con la consulta:

```promql
sum(up)
```

Configura:

```text
Título: Objetivos disponibles
Unidad: Ninguna
```

Añade un segundo panel de tipo `Stat`:

```promql
count(up == 0)
```

Configura:

```text
Título: Objetivos no disponibles
Unidad: Ninguna
```

Define umbrales para el segundo panel:

```text
0: verde
1 o más: rojo
```

### Crear la fila CPU y carga

Crea una fila llamada:

```text
CPU y carga
```

Añade un panel de tipo `Time series`:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

Configura:

```text
Título: Uso de CPU por servidor
Unidad: Percent (0-100)
Visualización: Time series
```

Añade otro panel para la carga media:

```promql
node_load1
```

Configura:

```text
Título: Carga del sistema
Visualización: Time series
```

La carga media debe interpretarse teniendo en cuenta el número de CPUs del sistema.

### Crear la fila Memoria

Crea una fila llamada:

```text
Memoria
```

Añade un panel de tipo `Gauge`:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configura:

```text
Título: Uso de memoria
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Define umbrales orientativos:

```text
0-70: verde
70-90: amarillo
90-100: rojo
```

Añade un panel de tipo `Time series`:

```promql
node_memory_MemAvailable_bytes
```

Configura:

```text
Título: Memoria disponible
Unidad: Bytes
```

### Crear la fila Almacenamiento

Crea una fila llamada:

```text
Almacenamiento
```

Añade un panel de tipo `Time series`:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay"
  }
)
```

Configura:

```text
Título: Uso del filesystem
Unidad: Percent (0-100)
```

Dependiendo de las etiquetas disponibles, puede ser necesario filtrar determinados puntos de montaje:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint!~"/run|/sys|/proc"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint!~"/run|/sys|/proc"
  }
)
```

## Añadir una variable de servidor

### Crear la variable

Crea una variable denominada:

```text
instance
```

Configúrala para que permita seleccionar una o varias instancias monitorizadas.

Los valores pueden ser similares a:

```text
Todos
server-01:9100
server-02:9100
server-03:9100
```

La forma de obtener los valores depende de la versión de Grafana y de la configuración de Prometheus.

### Utilizar la variable en una consulta

Modifica la consulta de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

El operador `=~` permite utilizar selección múltiple o expresiones regulares.

Prueba las siguientes selecciones:

```text
Todos
Una instancia concreta
Varias instancias
```

Comprueba que los paneles cambian según la selección.

## Utilizar el selector de rango

Prueba los siguientes intervalos:

```text
Últimos 15 minutos
Última hora
Últimas 6 horas
Últimas 24 horas
Últimos 7 días
```

Observa los cambios en:

- Número de puntos.
- Resolución de los gráficos.
- Tendencias.
- Tiempo de respuesta.
- Disponibilidad de datos.

Prueba también un intervalo absoluto:

```text
Desde: fecha y hora del laboratorio
Hasta: fecha y hora del laboratorio
```

Documenta la zona horaria utilizada.

## Comparar periodos

Configura el dashboard con:

```text
Desde: now-24h
Hasta: now
```

Crea o duplica un panel de CPU.

Panel actual:

```text
Desplazamiento: ninguno
```

Panel anterior:

```text
Desplazamiento: 24h
```

Configura títulos claros:

```text
Uso de CPU - periodo actual
Uso de CPU - 24 horas anteriores
```

Comprueba que ambos paneles utilizan:

- La misma consulta.
- La misma fuente de datos.
- El mismo filtro.
- El mismo tipo de visualización.

## Crear un panel de texto

Añade un panel de tipo `Text` con el siguiente contenido:

```markdown
## Laboratorio de Grafana

Este dashboard muestra métricas de infraestructura Linux obtenidas
desde Prometheus.

### Convenciones

- Verde: funcionamiento normal.
- Amarillo: requiere revisión.
- Rojo: situación crítica.
- Gris: sin datos.

### Configuración

- Rango recomendado: últimas 6 horas.
- Actualización: cada 1 minuto.
- Fuente de datos: Prometheus.
- Exporter utilizado: Node Exporter.
- Zona horaria: la configurada en el laboratorio.
```

El panel debe colocarse en la fila `Resumen` o al principio del dashboard.

## Validación del laboratorio

### Validar el servicio

Ejecuta:

```bash
systemctl is-active grafana-server
```

Resultado esperado:

```text
active
```

Ejecuta:

```bash
systemctl is-enabled grafana-server
```

Resultado esperado:

```text
enabled
```

### Validar el puerto

Ejecuta:

```bash
sudo ss -lntp | grep ':3000'
```

Debe aparecer Grafana escuchando en el puerto `3000`.

### Validar la API

Ejecuta:

```bash
curl -s http://localhost:3000/api/health
```

La respuesta debe indicar que la base de datos está disponible.

### Validar Prometheus

Ejecuta:

```bash
curl http://localhost:9090/-/ready
```

La respuesta debe indicar que Prometheus está preparado.

### Validar Node Exporter

Ejecuta:

```bash
curl http://localhost:9100/metrics | head
```

Deben aparecer métricas del sistema.

### Validar el dashboard

Comprueba:

```text
[ ] El dashboard se abre correctamente.
[ ] La fuente Prometheus está disponible.
[ ] La consulta up devuelve resultados.
[ ] Los paneles muestran datos.
[ ] Las unidades son correctas.
[ ] Los títulos son descriptivos.
[ ] Las filas están ordenadas.
[ ] El selector temporal funciona.
[ ] La actualización automática funciona.
[ ] La variable instance funciona.
[ ] Los umbrales cambian los colores.
[ ] El dashboard se ha guardado.
```

## Ejemplo

### Ejecución completa del laboratorio

La secuencia principal de comandos es:

```bash
sudo apt update

sudo apt upgrade -y

sudo apt install -y \
  ca-certificates \
  wget \
  gnupg \
  apt-transport-https \
  software-properties-common

sudo install -d -m 0755 /etc/apt/keyrings

wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update

sudo apt install -y grafana

sudo systemctl daemon-reload

sudo systemctl enable --now grafana-server

systemctl is-active grafana-server

systemctl is-enabled grafana-server

sudo ss -lntp | grep ':3000'

curl -s http://localhost:3000/api/health
```

Después:

1. Abre `http://DIRECCION_IP:3000`.
2. Inicia sesión.
3. Cambia la contraseña inicial.
4. Añade Prometheus.
5. Ejecuta la consulta `up`.
6. Crea el dashboard.
7. Añade las filas y paneles.
8. Guarda y valida el resultado.

### Diagnóstico de una instalación que no inicia

Si Grafana no se inicia:

```bash
sudo systemctl status grafana-server
```

Consulta los logs:

```bash
sudo journalctl -u grafana-server -xe --no-pager
```

Comprueba si el puerto está ocupado:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

Comprueba los permisos:

```bash
sudo ls -ld /etc/grafana
sudo ls -ld /var/lib/grafana
sudo ls -ld /var/log/grafana
```

Revisa la configuración principal:

```bash
sudo grep -v '^[[:space:]]*#' /etc/grafana/grafana.ini \
  | grep -v '^[[:space:]]*$'
```

Después de corregir el problema:

```bash
sudo systemctl restart grafana-server
```

Comprueba de nuevo:

```bash
sudo systemctl status grafana-server
```

### Diagnóstico de una fuente de datos sin conexión

Si Grafana no puede conectarse a Prometheus:

1. Comprueba que Prometheus está activo.
2. Verifica la URL configurada.
3. Prueba la conexión desde el servidor de Grafana.
4. Comprueba el puerto `9090`.
5. Revisa el firewall.
6. Revisa los logs.
7. Comprueba si Grafana se ejecuta en un contenedor.

Desde el servidor de Grafana:

```bash
curl http://DIRECCION_IP_PROMETHEUS:9090/-/ready
```

Comprueba el puerto:

```bash
nc -vz DIRECCION_IP_PROMETHEUS 9090
```

Si Prometheus está en el mismo servidor:

```bash
curl http://localhost:9090/-/ready
```

### Diagnóstico de un panel vacío

Si un panel no muestra datos:

```text
[ ] Comprueba el rango temporal.
[ ] Comprueba la fuente de datos.
[ ] Ejecuta la consulta en Explore.
[ ] Comprueba el nombre de la métrica.
[ ] Comprueba las etiquetas.
[ ] Comprueba la retención de Prometheus.
[ ] Comprueba que Node Exporter está activo.
[ ] Comprueba los logs de Prometheus.
[ ] Comprueba los logs de Grafana.
```

Ejecuta una consulta básica:

```promql
up
```

Si `up` tampoco devuelve resultados, revisa la configuración de Prometheus y sus objetivos.

Consulta los objetivos de Prometheus:

```bash
curl -s http://localhost:9090/api/v1/targets
```

## Puntos clave

- El laboratorio combina Grafana, Prometheus y Node Exporter.
- Grafana utiliza normalmente el puerto `3000`.
- Prometheus utiliza normalmente el puerto `9090`.
- Node Exporter utiliza normalmente el puerto `9100`.
- El servicio de Grafana se administra mediante `systemctl`.
- El inicio automático se configura con `systemctl enable`.
- La API `/api/health` permite realizar una comprobación básica.
- La contraseña inicial debe cambiarse durante el primer acceso.
- Prometheus debe estar accesible desde el servidor de Grafana.
- La consulta `up` es útil para validar la conectividad y disponibilidad de objetivos.
- Un dashboard debe organizarse mediante filas y paneles relacionados.
- Los títulos, unidades y umbrales deben ser claros.
- Las variables permiten reutilizar un dashboard con diferentes instancias.
- La consulta `instance=~"$instance"` permite utilizar una variable con múltiples valores.
- El selector temporal debe adaptarse al objetivo del dashboard.
- Las comparaciones deben utilizar periodos equivalentes.
- Los paneles vacíos pueden deberse a falta de datos, filtros incorrectos o problemas de conectividad.
- Los logs de `systemd` son esenciales para diagnosticar errores de Grafana.
- La configuración final debe validarse mediante una lista de comprobación.
- Los dashboards deben guardarse y exportarse como parte de la documentación del laboratorio.

## Preguntas de comprobación

1. ¿Qué componentes forman la arquitectura de este laboratorio?
2. ¿Qué puerto utiliza normalmente Grafana?
3. ¿Qué puerto utiliza normalmente Prometheus?
4. ¿Qué función cumple Node Exporter?
5. ¿Qué comando permite iniciar automáticamente Grafana con Ubuntu?
6. ¿Cómo comprobarías que el servicio `grafana-server` está activo?
7. ¿Qué URL utilizarías para acceder a Grafana desde otro equipo?
8. ¿Por qué es necesario cambiar la contraseña inicial?
9. ¿Qué consulta PromQL puede utilizarse para comprobar los objetivos monitorizados?
10. ¿Qué pasos seguirías para añadir Prometheus como fuente de datos?
11. ¿Qué diferencia existe entre una fila y un panel?
12. ¿Qué tipo de panel utilizarías para mostrar la evolución de la CPU?
13. ¿Qué tipo de panel utilizarías para mostrar un único valor?
14. ¿Qué función cumplen los umbrales?
15. ¿Por qué es importante configurar correctamente las unidades?
16. ¿Qué operador se utiliza en PromQL para filtrar una variable con varios valores?
17. ¿Qué comprobarías si un panel no muestra datos?
18. ¿Qué comprobarías si Grafana funciona localmente, pero no desde otro equipo?
19. ¿Qué información revisarías si el servicio no se inicia?
20. ¿Qué elementos deben validarse antes de finalizar el laboratorio?
```

## Resultado esperado

Al finalizar el laboratorio deberás disponer de:

```text
Grafana instalado y activo
        │
        ▼
Acceso web operativo
        │
        ▼
Contraseña de administrador modificada
        │
        ▼
Prometheus configurado como fuente de datos
        │
        ▼
Dashboard creado
        │
        ├── Fila Resumen
        ├── Fila CPU y carga
        ├── Fila Memoria
        └── Fila Almacenamiento
```

El resultado final será una instancia funcional de Grafana capaz de consultar métricas de Prometheus y representarlas mediante dashboards, filas y paneles.