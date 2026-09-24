# Requisitos del sistema

## Objetivos

Al finalizar esta sección podrás:

- Identificar los requisitos mínimos para instalar Grafana en Ubuntu.
- Comprobar la arquitectura, memoria, almacenamiento y conectividad del sistema.
- Diferenciar entre los requisitos de un laboratorio y los de un entorno de producción.
- Verificar que los puertos necesarios están disponibles.
- Preparar el sistema operativo antes de iniciar la instalación.
- Detectar posibles limitaciones de hardware o configuración.

## Introducción

Antes de instalar Grafana es necesario comprobar que el sistema dispone de los recursos y servicios necesarios.

Grafana puede ejecutarse en diferentes sistemas operativos y arquitecturas. En este bloque se utilizará **Ubuntu** como sistema base.

Los requisitos dependen del uso previsto:

- Un laboratorio con pocos dashboards necesita pocos recursos.
- Un entorno de producción con muchos usuarios y paneles requiere una planificación más cuidadosa.
- El número de fuentes de datos, dashboards, consultas y usuarios influye en el rendimiento.
- La alta disponibilidad puede requerir varios servidores y una base de datos externa.

Una arquitectura básica de laboratorio puede ser:

```text
Servidor Ubuntu
├── Grafana
├── Prometheus
└── Node Exporter
```

En un entorno más grande, estos componentes pueden ejecutarse en servidores independientes:

```text
Servidor de monitorización
├── Grafana
└── Base de datos de Grafana

Servidor de métricas
└── Prometheus

Servidores monitorizados
└── Exporters y agentes
```

Comprobar los requisitos antes de la instalación evita errores posteriores relacionados con el almacenamiento, la conectividad, los permisos o el rendimiento.

## Contenido

### Sistema operativo compatible

Para este módulo se utilizará Ubuntu como sistema operativo.

Comprueba la versión instalada:

```bash
lsb_release -a
```

También puedes utilizar:

```bash
cat /etc/os-release
```

Ejemplo de salida:

```text
NAME="Ubuntu"
VERSION="24.04 LTS"
ID=ubuntu
VERSION_CODENAME=noble
```

Comprueba la arquitectura del sistema:

```bash
uname -m
```

Los resultados habituales son:

```text
x86_64
```

o:

```text
aarch64
```

La arquitectura debe ser compatible con el paquete o binario de Grafana que se vaya a instalar.

Antes de instalar una versión concreta de Grafana, conviene comprobar la documentación oficial correspondiente a esa versión. Los requisitos y métodos de instalación pueden cambiar con el tiempo.

### Requisitos para un laboratorio

Para un laboratorio pequeño, una configuración razonable puede ser:

| Recurso | Recomendación |
|---|---:|
| CPU | 1 o 2 vCPU |
| Memoria RAM | 2 GB |
| Almacenamiento libre | 10 GB |
| Sistema operativo | Ubuntu Server |
| Red | Acceso a la red local |
| Navegador | Navegador web actualizado |

Estos recursos pueden ser suficientes para:

- Un usuario o pocos usuarios.
- Pocos dashboards.
- Una o dos fuentes de datos.
- Prometheus en el mismo servidor.
- Un número reducido de objetivos.
- Consultas de complejidad baja o media.

La cantidad necesaria puede aumentar si Grafana, Prometheus y varios exporters se ejecutan simultáneamente en la misma máquina virtual.

### Requisitos para producción

En producción no existe una configuración única válida para todos los casos.

El dimensionamiento depende de:

- Número de usuarios simultáneos.
- Número de dashboards.
- Número de paneles por dashboard.
- Frecuencia de actualización.
- Complejidad de las consultas.
- Número de fuentes de datos.
- Retención de los datos.
- Uso de alertas.
- Necesidad de alta disponibilidad.
- Tamaño de la base de datos de Grafana.
- Número de organizaciones y equipos.

Una configuración inicial orientativa para un entorno pequeño podría ser:

| Recurso | Recomendación inicial |
|---|---:|
| CPU | 2-4 vCPU |
| Memoria RAM | 4-8 GB |
| Almacenamiento | SSD |
| Sistema operativo | Ubuntu Server LTS |
| Red | Conectividad estable y controlada |
| Base de datos | SQLite, PostgreSQL o MySQL según el entorno |

Estos valores no sustituyen a una prueba de carga. El rendimiento debe comprobarse utilizando el número real de usuarios, consultas y dashboards.

### Memoria RAM

Grafana necesita memoria para:

- Ejecutar el servicio.
- Procesar solicitudes.
- Mantener sesiones.
- Gestionar usuarios y permisos.
- Renderizar o preparar paneles.
- Ejecutar alertas.
- Mantener conexiones con fuentes de datos.

Para comprobar la memoria disponible:

```bash
free -h
```

Para observar el consumo en tiempo real:

```bash
top
```

También puedes utilizar:

```bash
htop
```

si está instalado.

Una salida de ejemplo podría ser:

```text
               total        used        free      shared  buff/cache   available
Mem:            3.8Gi       1.2Gi       1.1Gi        20Mi       1.5Gi       2.4Gi
Swap:           2.0Gi          0B       2.0Gi
```

La memoria disponible es más importante que la memoria libre estricta, ya que Linux utiliza parte de la memoria como caché.

Si el sistema tiene muy poca memoria, pueden aparecer:

- Respuestas lentas.
- Procesos terminados por falta de memoria.
- Errores al ejecutar consultas.
- Problemas durante la instalación.
- Uso excesivo de swap.

### Procesador

Grafana necesita CPU para:

- Atender peticiones web.
- Procesar consultas.
- Ejecutar reglas de alerta.
- Generar respuestas para los paneles.
- Administrar usuarios y dashboards.
- Ejecutar tareas internas.

Comprueba la información del procesador:

```bash
lscpu
```

Consulta el número de procesadores disponibles:

```bash
nproc
```

Para un laboratorio, una o dos vCPU suelen ser suficientes.

En producción, el número de vCPU debe ajustarse al volumen de solicitudes y a la complejidad de los dashboards.

Un uso elevado de CPU puede estar provocado por:

- Consultas demasiado amplias.
- Muchos paneles cargándose simultáneamente.
- Intervalos de actualización demasiado cortos.
- Consultas sin filtros adecuados.
- Renderizado frecuente de imágenes.
- Muchos usuarios accediendo a la vez.
- Reglas de alerta complejas.

### Almacenamiento

Grafana necesita espacio para:

- Binarios y plugins.
- Configuración.
- Base de datos interna.
- Dashboards.
- Usuarios y permisos.
- Logs.
- Imágenes generadas.
- Ficheros temporales.
- Copias de seguridad.

Comprueba el espacio disponible:

```bash
df -h
```

Comprueba el tamaño de los directorios principales:

```bash
sudo du -h --max-depth=1 /var/lib/grafana
```

La ubicación habitual de los datos de Grafana es:

```text
/var/lib/grafana
```

La configuración suele encontrarse en:

```text
/etc/grafana
```

Los logs suelen almacenarse en:

```text
/var/log/grafana
```

Para un laboratorio, se recomienda disponer de al menos:

```text
10 GB libres
```

Esta cantidad debe ser mayor si también se instalarán Prometheus, Node Exporter, plugins y otros componentes en el mismo sistema.

Es preferible utilizar almacenamiento SSD, especialmente cuando:

- Se consulta una base de datos externa.
- Se generan muchos dashboards.
- Se utilizan plugins.
- Se almacenan muchos logs.
- Se ejecutan tareas de renderizado.

### Base de datos

Grafana utiliza una base de datos para almacenar información como:

- Usuarios.
- Dashboards.
- Paneles.
- Carpetas.
- Fuentes de datos.
- Alertas.
- Configuración.
- Permisos.
- Preferencias.

En instalaciones pequeñas suele utilizarse SQLite.

SQLite puede ser suficiente para:

- Laboratorios.
- Entornos individuales.
- Instalaciones con pocos usuarios.
- Pruebas funcionales.
- Entornos sin alta disponibilidad.

En entornos de producción con más exigencia puede utilizarse:

- PostgreSQL.
- MySQL.
- MariaDB, según la compatibilidad de la versión utilizada.

Una base de datos externa puede facilitar:

- La realización de copias de seguridad.
- La replicación.
- La alta disponibilidad.
- La administración centralizada.
- La migración entre servidores.
- La escalabilidad.

La base de datos de Grafana no es la base de datos principal de las métricas. Las métricas suelen permanecer en sistemas como:

- Prometheus.
- Loki.
- InfluxDB.
- Elasticsearch.
- Otros sistemas compatibles.

### Conectividad de red

Grafana debe poder comunicarse con:

- Los usuarios que acceden a la interfaz web.
- Las fuentes de datos.
- La base de datos externa, si existe.
- Los servicios de autenticación, si se utilizan.
- Los sistemas de plugins o actualizaciones, cuando corresponda.

Comprueba la configuración de red:

```bash
ip address
```

Consulta la tabla de rutas:

```bash
ip route
```

Comprueba la resolución DNS:

```bash
getent hosts google.com
```

Comprueba la conectividad con otro servidor:

```bash
ping -c 4 192.168.1.50
```

El uso de `ping` puede estar bloqueado aunque exista conectividad TCP. Por eso también conviene probar el puerto correspondiente.

### Puertos habituales

Grafana utiliza normalmente el puerto:

```text
3000/tcp
```

Prometheus utiliza normalmente:

```text
9090/tcp
```

Node Exporter utiliza normalmente:

```text
9100/tcp
```

Comprueba si Grafana escucha en el puerto `3000`:

```bash
sudo ss -lntp | grep 3000
```

Comprueba si Prometheus escucha en el puerto `9090`:

```bash
sudo ss -lntp | grep 9090
```

Comprueba si Node Exporter escucha en el puerto `9100`:

```bash
sudo ss -lntp | grep 9100
```

Si Grafana utiliza HTTPS mediante un proxy inverso, los usuarios pueden acceder por:

```text
443/tcp
```

En ese caso, el proxy puede reenviar las solicitudes hacia Grafana en el puerto interno `3000`.

### Firewall

Si el firewall está activo, es necesario permitir únicamente el tráfico necesario.

Comprueba el estado de UFW:

```bash
sudo ufw status verbose
```

Para permitir temporalmente el acceso a Grafana desde una red concreta:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
```

Para permitir Prometheus desde una red concreta:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 9090 proto tcp
```

No es recomendable abrir estos puertos a Internet sin medidas adicionales.

Una política más segura consiste en:

- Permitir Grafana únicamente desde la red de administración.
- Limitar Prometheus a los servidores que lo necesiten.
- No exponer Node Exporter públicamente.
- Utilizar un proxy inverso.
- Aplicar HTTPS.
- Controlar el acceso mediante autenticación.

### Resolución de nombres

Si se utilizan nombres de host en lugar de direcciones IP, todos los equipos deben poder resolverlos.

Comprueba un nombre:

```bash
getent hosts grafana.example.local
```

Comprueba la resolución de Prometheus:

```bash
getent hosts prometheus.example.local
```

Si se utiliza Docker Compose, los nombres de servicio suelen resolverse dentro de la red de Docker:

```text
http://prometheus:9090
```

Desde el host puede utilizarse otra dirección:

```text
http://localhost:9090
```

La dirección correcta depende del punto desde el que se realiza la conexión.

### Hora del sistema

La hora correcta es importante para:

- Los logs.
- Las alertas.
- La autenticación.
- Los certificados TLS.
- La correlación con métricas.
- La comparación entre sistemas.

Comprueba la hora:

```bash
date
```

Comprueba el estado de la sincronización:

```bash
timedatectl
```

Activa la sincronización automática si es necesario:

```bash
sudo timedatectl set-ntp true
```

La salida debería indicar una situación similar a:

```text
System clock synchronized: yes
NTP service: active
```

Una diferencia significativa de hora puede dificultar el análisis de incidentes y la comparación entre Grafana, Prometheus y los sistemas monitorizados.

### Usuario y permisos

Grafana necesita permisos para:

- Leer su configuración.
- Escribir en su directorio de datos.
- Escribir logs.
- Ejecutar el servicio.
- Cargar plugins.
- Acceder a certificados, cuando corresponda.

Comprueba el usuario del servicio:

```bash
systemctl cat grafana-server
```

También puedes consultar el proceso:

```bash
ps aux | grep '[g]rafana'
```

Comprueba los permisos de los directorios:

```bash
sudo ls -ld /var/lib/grafana
sudo ls -ld /etc/grafana
sudo ls -ld /var/log/grafana
```

No ejecutes Grafana como `root` salvo que exista una razón técnica muy concreta y documentada.

Es preferible utilizar un usuario de servicio con permisos limitados.

### Dependencias y paquetes básicos

Actualiza los paquetes del sistema:

```bash
sudo apt update
```

Instala herramientas básicas:

```bash
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  wget
```

Comprueba que `systemd` está disponible:

```bash
systemctl --version
```

En una instalación tradicional de Ubuntu, `systemd` permite:

- Iniciar Grafana.
- Detener Grafana.
- Reiniciar Grafana.
- Activar el inicio automático.
- Consultar el estado.
- Revisar los logs.

### Navegador web

Para acceder a Grafana se necesita un navegador moderno.

Se pueden utilizar navegadores como:

- Firefox.
- Chromium.
- Google Chrome.
- Microsoft Edge.

El navegador debe permitir:

- JavaScript.
- Cookies necesarias para la sesión.
- Conexiones HTTP o HTTPS al servidor.
- Descarga de ficheros si se exportan dashboards.

Comprueba que puedes acceder a la dirección configurada:

```text
http://DIRECCION_IP:3000
```

Si utilizas un proxy inverso:

```text
https://grafana.example.com
```

### Acceso remoto

Si Grafana está instalado en una máquina virtual o en un servidor remoto, necesitarás conocer:

- Dirección IP.
- Nombre DNS.
- Puerto de acceso.
- Usuario con permisos.
- Reglas de firewall.
- Método de conexión SSH.

Comprueba la conectividad desde tu equipo cliente:

```bash
ping -c 4 DIRECCION_IP
```

Comprueba el puerto:

```bash
nc -vz DIRECCION_IP 3000
```

Si `nc` no está instalado:

```bash
sudo apt install -y netcat-openbsd
```

También puedes probar con `curl`:

```bash
curl -I http://DIRECCION_IP:3000
```

Una respuesta HTTP indica que existe comunicación con el servicio web, aunque todavía no garantiza que la configuración de Grafana sea correcta.

### HTTPS y proxy inverso

En entornos de producción es recomendable proteger el acceso mediante HTTPS.

Una arquitectura habitual es:

```text
Cliente
  │ HTTPS :443
  ▼
Nginx o Apache
  │ HTTP interno :3000
  ▼
Grafana
```

El proxy inverso puede encargarse de:

- Terminar TLS.
- Gestionar certificados.
- Redirigir HTTP a HTTPS.
- Aplicar cabeceras de seguridad.
- Controlar el acceso.
- Publicar Grafana mediante un nombre DNS.

El uso de HTTPS es especialmente importante cuando se transmiten:

- Credenciales.
- Cookies de sesión.
- Datos de monitorización.
- Información de infraestructura.
- Consultas con etiquetas sensibles.

### Comprobar el sistema antes de instalar

Antes de comenzar la instalación, ejecuta:

```bash
lsb_release -a
```

```bash
uname -m
```

```bash
free -h
```

```bash
df -h
```

```bash
ip address
```

```bash
timedatectl
```

```bash
sudo ufw status verbose
```

Comprueba también si el puerto previsto ya está ocupado:

```bash
sudo ss -lntp | grep 3000
```

Si aparece otro servicio utilizando el puerto `3000`, puedes:

- Detener el servicio si no es necesario.
- Configurar Grafana para utilizar otro puerto.
- Utilizar un proxy inverso.
- Reorganizar la arquitectura.

### Checklist previo

Antes de instalar Grafana, verifica:

```text
[ ] Ubuntu está instalado y actualizado.
[ ] La arquitectura del sistema es compatible.
[ ] Hay suficiente memoria disponible.
[ ] Hay suficiente espacio libre.
[ ] La hora del sistema está sincronizada.
[ ] El nombre del host se resuelve correctamente.
[ ] Existe conectividad de red.
[ ] El puerto 3000 está disponible.
[ ] El firewall permite el tráfico necesario.
[ ] El usuario dispone de permisos sudo.
[ ] Se ha definido la fuente de datos que se utilizará.
[ ] Se ha decidido si se empleará HTTP o HTTPS.
[ ] Se ha definido una política de copias de seguridad.
```

## Ejemplo

### Comprobar los requisitos en Ubuntu

Ejecuta los siguientes comandos:

```bash
echo "=== Sistema operativo ==="
lsb_release -ds

echo "=== Arquitectura ==="
uname -m

echo "=== Procesadores ==="
nproc

echo "=== Memoria ==="
free -h

echo "=== Almacenamiento ==="
df -h /

echo "=== Hora y sincronización ==="
timedatectl

echo "=== Red ==="
ip -br address

echo "=== Puerto 3000 ==="
sudo ss -lntp | grep ':3000' || echo "Puerto 3000 disponible"
```

Una salida adecuada para un laboratorio podría indicar:

```text
Sistema operativo: Ubuntu 24.04 LTS
Arquitectura: x86_64
Procesadores: 2
Memoria: 2 GiB o más
Almacenamiento libre: 10 GiB o más
Puerto 3000: disponible
```

La salida exacta dependerá del sistema.

### Preparar Ubuntu

Actualiza los paquetes:

```bash
sudo apt update
sudo apt upgrade -y
```

Instala herramientas básicas:

```bash
sudo apt install -y \
  curl \
  wget \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common
```

Comprueba que `curl` funciona:

```bash
curl --version
```

Comprueba que el sistema puede resolver nombres:

```bash
getent hosts packages.grafana.com
```

Comprueba la conectividad HTTPS:

```bash
curl -I https://packages.grafana.com
```

Si estas comprobaciones fallan, revisa:

- Conectividad de red.
- Configuración DNS.
- Proxy corporativo.
- Firewall.
- Certificados del sistema.
- Configuración de la fecha y hora.

### Comprobar la comunicación con Prometheus

Si Prometheus ya está instalado en el mismo servidor:

```bash
curl http://localhost:9090/-/ready
```

Si está en otro servidor:

```bash
curl http://192.168.1.50:9090/-/ready
```

Comprueba también el puerto:

```bash
nc -vz 192.168.1.50 9090
```

El resultado esperado es similar a:

```text
Connection to 192.168.1.50 9090 port [tcp/*] succeeded!
```

Si Grafana no puede alcanzar Prometheus, la configuración de la fuente de datos fallará aunque Grafana esté correctamente instalado.

### Configuración recomendada para el laboratorio

Para un laboratorio con Grafana, Prometheus y Node Exporter en la misma máquina virtual:

```text
CPU: 2 vCPU
RAM: 4 GB
Disco: 20 GB
Sistema: Ubuntu Server LTS
Grafana: puerto 3000
Prometheus: puerto 9090
Node Exporter: puerto 9100
```

Esta configuración proporciona margen para:

- Ejecutar los tres servicios.
- Crear dashboards.
- Realizar consultas básicas.
- Probar alertas.
- Conservar métricas durante varios días.
- Practicar tareas de administración.

La configuración mínima puede funcionar, pero disponer de recursos adicionales evita que el laboratorio se convierta en una competición entre servicios por la memoria. Linux es buen anfitrión, pero tampoco hace magia.

## Puntos clave

- Grafana puede instalarse en Ubuntu utilizando paquetes o binarios compatibles.
- Antes de instalarlo deben comprobarse el sistema operativo y la arquitectura.
- Un laboratorio necesita menos recursos que un entorno de producción.
- La memoria y la CPU influyen en la capacidad de respuesta de Grafana.
- El almacenamiento debe incluir espacio para la configuración, la base de datos, los logs y los plugins.
- El puerto habitual de Grafana es el `3000`.
- Prometheus suele utilizar el puerto `9090`.
- Node Exporter suele utilizar el puerto `9100`.
- El firewall debe permitir únicamente el tráfico necesario.
- Grafana debe poder comunicarse con sus fuentes de datos.
- La hora del sistema debe estar sincronizada.
- La base de datos de Grafana almacena dashboards, usuarios y configuración, no necesariamente las métricas.
- SQLite suele ser suficiente para laboratorios pequeños.
- PostgreSQL o MySQL pueden ser más apropiados para entornos exigentes.
- Es recomendable utilizar un usuario de servicio con permisos limitados.
- HTTPS y un proxy inverso son aconsejables en producción.
- La conectividad debe comprobarse desde el servidor que realiza la conexión.
- En un entorno con contenedores, `localhost` puede apuntar al contenedor equivocado.
- Es conveniente ejecutar un checklist antes de iniciar la instalación.
- Las necesidades reales deben validarse mediante pruebas de carga y monitorización.

## Preguntas de comprobación

1. ¿Qué sistema operativo se utilizará en este módulo?
2. ¿Por qué es importante comprobar la arquitectura del sistema?
3. ¿Qué recursos mínimos recomendarías para un laboratorio pequeño?
4. ¿Qué factores influyen en los requisitos de producción?
5. ¿Para qué se utiliza la memoria en Grafana?
6. ¿Qué información almacena la base de datos de Grafana?
7. ¿Qué diferencia existe entre la base de datos de Grafana y la base de datos de métricas?
8. ¿Cuál es el puerto habitual de Grafana?
9. ¿Cuál es el puerto habitual de Prometheus?
10. ¿Cuál es el puerto habitual de Node Exporter?
11. ¿Qué comando permite comprobar el espacio disponible?
12. ¿Qué comando permite consultar la memoria disponible?
13. ¿Cómo se puede comprobar si un puerto está ocupado?
14. ¿Por qué es importante sincronizar la hora del sistema?
15. ¿Qué problemas pueden aparecer si Grafana no puede comunicarse con Prometheus?
16. ¿Qué ventajas ofrece utilizar PostgreSQL o MySQL en producción?
17. ¿Por qué no se recomienda ejecutar Grafana como `root`?
18. ¿Qué función puede cumplir un proxy inverso?
19. ¿Qué ventajas aporta utilizar HTTPS?
20. ¿Qué comprobaciones realizarías antes de instalar Grafana?