# Instalación de Grafana en Ubuntu 24.04.5 LTS

## Objetivos

Al finalizar esta sección podrás:

- Preparar Ubuntu 24.04.5 LTS para instalar Grafana.
- Instalar Grafana mediante el repositorio oficial de Grafana Labs.
- Gestionar Grafana como un servicio de `systemd`.
- Verificar que Grafana se inicia correctamente.
- Comprobar el acceso a la interfaz web.
- Configurar el inicio automático del servicio.
- Consultar los logs de Grafana.
- Identificar y resolver problemas habituales de instalación.

## Introducción

Grafana es una plataforma de visualización y observabilidad que permite consultar datos procedentes de diferentes fuentes, como Prometheus, Loki, Elasticsearch, InfluxDB, MySQL o PostgreSQL.

En este documento se describe la instalación de Grafana en:

```text
Ubuntu 24.04.5 LTS
```

Se utilizará el repositorio oficial de Grafana Labs para instalar y actualizar el paquete mediante `apt`.

La arquitectura resultante será:

```text
Ubuntu 24.04.5 LTS
└── Grafana
    ├── Servicio systemd
    ├── Interfaz web
    ├── Base de datos local
    └── Fuentes de datos
```

Por defecto, Grafana escucha en el puerto:

```text
3000/tcp
```

Una vez instalado, la interfaz web estará disponible en:

```text
http://localhost:3000
```

Si se accede desde otro equipo:

```text
http://DIRECCION_IP_DEL_SERVIDOR:3000
```

La instalación del paquete no configura automáticamente todas las fuentes de datos. La conexión con Prometheus, Loki u otros sistemas se realizará posteriormente desde la interfaz de Grafana o mediante provisioning.

## Contenido

### Requisitos previos

Antes de comenzar, comprueba que dispones de:

- Ubuntu 24.04.5 LTS instalado.
- Un usuario con permisos `sudo`.
- Conexión a Internet.
- Nombre de host o dirección IP accesible.
- Al menos 2 GB de memoria RAM para un laboratorio.
- Al menos 10 GB de espacio libre.
- Un navegador web.
- El puerto `3000/tcp` disponible.

Comprueba la versión de Ubuntu:

```bash
lsb_release -a
```

También puedes utilizar:

```bash
cat /etc/os-release
```

La salida debería identificar Ubuntu 24.04 LTS.

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

Comprueba si el puerto `3000` está ocupado:

```bash
sudo ss -lntp | grep ':3000' || echo "El puerto 3000 está disponible"
```

### Actualizar el sistema

Antes de instalar Grafana, actualiza la información de los paquetes:

```bash
sudo apt update
```

Instala las actualizaciones disponibles:

```bash
sudo apt upgrade -y
```

Reiniciar el sistema después de una actualización importante puede ser recomendable:

```bash
sudo reboot
```

Después del reinicio, vuelve a conectarte mediante SSH o abre una nueva sesión de terminal.

### Instalar paquetes necesarios

Instala las herramientas necesarias para añadir el repositorio de Grafana:

```bash
sudo apt install -y \
  ca-certificates \
  wget \
  gnupg \
  apt-transport-https \
  software-properties-common
```

Estos paquetes permiten:

- Descargar la clave del repositorio.
- Utilizar repositorios HTTPS.
- Verificar firmas de paquetes.
- Gestionar fuentes de paquetes de forma segura.

Comprueba que `wget` está instalado:

```bash
wget --version
```

Comprueba que `gpg` está disponible:

```bash
gpg --version
```

### Añadir la clave del repositorio

Crea el directorio utilizado para almacenar claves de repositorios:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
```

Descarga y convierte la clave de Grafana:

```bash
wget -q -O - https://apt.grafana.com/gpg.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

Comprueba que la clave existe:

```bash
sudo ls -l /etc/apt/keyrings/grafana.gpg
```

La clave permite a `apt` verificar que los paquetes proceden de un repositorio firmado y no han sido alterados durante la descarga.

No se recomienda utilizar repositorios sin firma ni desactivar la verificación de autenticidad de los paquetes.

### Añadir el repositorio de Grafana

Crea el fichero del repositorio:

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list
```

Comprueba el contenido:

```bash
cat /etc/apt/sources.list.d/grafana.list
```

La salida esperada es similar a:

```text
deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main
```

Actualiza de nuevo el índice de paquetes:

```bash
sudo apt update
```

Si el repositorio se ha añadido correctamente, `apt` debería descargar su información sin mostrar errores de firma o conectividad.

### Comprobar las versiones disponibles

Consulta la información del paquete:

```bash
apt policy grafana
```

También puedes buscar paquetes relacionados:

```bash
apt search '^grafana'
```

El paquete principal de Grafana suele ser:

```text
grafana
```

En algunos entornos también puede aparecer una edición empresarial:

```text
grafana-enterprise
```

Para este laboratorio se utilizará el paquete:

```text
grafana
```

Antes de instalar en producción, comprueba la edición y la versión que necesita tu organización.

### Instalar Grafana

Instala el paquete:

```bash
sudo apt install -y grafana
```

Durante la instalación se crearán, entre otros elementos:

- El usuario de servicio de Grafana.
- El servicio `grafana-server`.
- Los directorios de configuración.
- El directorio de datos.
- El directorio de logs.
- La unidad `systemd`.

Comprueba que el paquete está instalado:

```bash
dpkg -l | grep grafana
```

Consulta la versión instalada:

```bash
grafana-server --version
```

También puedes utilizar:

```bash
grafana cli --version
```

El comando disponible puede variar según la versión y el paquete instalado.

### Iniciar el servicio

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

Un estado correcto debe mostrar:

```text
Active: active (running)
```

Si el servicio está activo, Grafana debería estar escuchando en el puerto `3000`.

Compruébalo con:

```bash
sudo ss -lntp | grep 3000
```

### Activar el inicio automático

Para iniciar Grafana automáticamente al arrancar Ubuntu:

```bash
sudo systemctl enable grafana-server
```

También puedes activar e iniciar el servicio en un único comando:

```bash
sudo systemctl enable --now grafana-server
```

Comprueba si está habilitado:

```bash
systemctl is-enabled grafana-server
```

La salida esperada es:

```text
enabled
```

Comprueba si está activo:

```bash
systemctl is-active grafana-server
```

La salida esperada es:

```text
active
```

### Comprobar el servicio mediante HTTP

Desde el propio servidor:

```bash
curl -I http://localhost:3000
```

Una respuesta correcta puede ser similar a:

```text
HTTP/1.1 302 Found
```

También puedes solicitar información básica:

```bash
curl -s http://localhost:3000/api/health
```

La respuesta debería indicar que la base de datos está disponible y que Grafana está operativo.

Una respuesta habitual tiene una estructura parecida a:

```json
{
  "commit": "...",
  "database": "ok",
  "version": "..."
}
```

El contenido exacto depende de la versión instalada.

### Acceder desde un navegador

Desde el propio servidor, abre:

```text
http://localhost:3000
```

Desde otro equipo de la misma red:

```text
http://DIRECCION_IP_DEL_SERVIDOR:3000
```

Para conocer las direcciones IP del servidor:

```bash
ip address
```

También puedes utilizar:

```bash
hostname -I
```

Ejemplo:

```text
http://192.168.1.50:3000
```

Si aparece la pantalla de inicio de sesión, la instalación básica ha finalizado correctamente.

### Credenciales iniciales

En una instalación nueva, Grafana puede solicitar las credenciales iniciales predeterminadas:

```text
Usuario: admin
Contraseña: admin
```

La plataforma debería solicitar el cambio de contraseña durante el primer acceso.

Utiliza una contraseña:

- Larga.
- Única.
- Difícil de adivinar.
- No reutilizada en otros servicios.
- Almacenada de forma segura.

No mantengas las credenciales predeterminadas en un entorno real.

### Directorios importantes

Las rutas habituales de Grafana son:

| Ruta | Función |
|---|---|
| `/etc/grafana` | Configuración |
| `/etc/grafana/grafana.ini` | Configuración principal |
| `/var/lib/grafana` | Datos y base de datos local |
| `/var/log/grafana` | Logs |
| `/usr/share/grafana` | Archivos de la aplicación y plugins |
| `/etc/systemd/system` o `/lib/systemd/system` | Unidades de servicio |

Comprueba los directorios principales:

```bash
sudo ls -ld \
  /etc/grafana \
  /var/lib/grafana \
  /var/log/grafana \
  /usr/share/grafana
```

La ubicación de la unidad puede consultarse con:

```bash
systemctl cat grafana-server
```

### Usuario del servicio

Grafana se ejecuta normalmente con un usuario de servicio específico.

Consulta el usuario utilizado por la unidad:

```bash
systemctl show grafana-server \
  --property=User \
  --property=Group
```

También puedes consultar los procesos:

```bash
ps aux | grep '[g]rafana'
```

No ejecutes Grafana como `root` salvo que exista una justificación técnica concreta.

El uso de un usuario de servicio limita el impacto de posibles errores o vulnerabilidades.

### Configuración del puerto

El puerto predeterminado es:

```text
3000
```

La configuración principal se encuentra normalmente en:

```text
/etc/grafana/grafana.ini
```

Crea una copia de seguridad antes de modificarla:

```bash
sudo cp \
  /etc/grafana/grafana.ini \
  /etc/grafana/grafana.ini.bak
```

Edita el fichero:

```bash
sudo nano /etc/grafana/grafana.ini
```

Busca la sección:

```ini
[server]
```

Una configuración básica puede ser:

```ini
[server]
protocol = http
http_addr =
http_port = 3000
domain = localhost
```

Después de modificar la configuración, reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

No es necesario modificar el puerto si el `3000` está disponible.

### Configurar una dirección de escucha

Por defecto, Grafana puede escuchar en las interfaces configuradas por el paquete.

Para comprobar dónde escucha:

```bash
sudo ss -lntp | grep grafana
```

Si se desea limitar la escucha a una dirección concreta:

```ini
[server]
http_addr = 192.168.1.50
http_port = 3000
```

Si se desea escuchar en todas las interfaces:

```ini
[server]
http_addr =
http_port = 3000
```

Escuchar en todas las interfaces puede ser práctico en un laboratorio, pero debe combinarse con firewall y autenticación adecuados.

### Configurar el firewall

Comprueba el estado del firewall:

```bash
sudo ufw status verbose
```

Para permitir Grafana únicamente desde una red local:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
```

Para permitir el acceso desde una única dirección:

```bash
sudo ufw allow from 192.168.1.25 to any port 3000 proto tcp
```

Comprueba las reglas:

```bash
sudo ufw status numbered
```

No abras el puerto a todo Internet sin proteger la instalación.

Esta regla es menos restrictiva:

```bash
sudo ufw allow 3000/tcp
```

Debe utilizarse solo cuando la arquitectura y las medidas de seguridad lo justifiquen.

### Consultar los logs

Consulta los últimos mensajes del servicio:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

Consulta los logs en tiempo real:

```bash
sudo journalctl -u grafana-server -f
```

Consulta los ficheros de logs:

```bash
sudo ls -lh /var/log/grafana
```

Muestra el log principal:

```bash
sudo tail -f /var/log/grafana/grafana.log
```

Los logs son útiles para diagnosticar:

- Fallos de inicio.
- Problemas de permisos.
- Errores de base de datos.
- Plugins incompatibles.
- Problemas de conexión.
- Errores de configuración.
- Fallos de autenticación.

### Validar una instalación completa

Ejecuta las siguientes comprobaciones:

```bash
systemctl is-active grafana-server
```

```bash
systemctl is-enabled grafana-server
```

```bash
sudo ss -lntp | grep ':3000'
```

```bash
curl -s http://localhost:3000/api/health
```

```bash
sudo journalctl -u grafana-server -n 30 --no-pager
```

El resultado esperado es:

```text
Servicio activo
Servicio habilitado
Puerto 3000 escuchando
API de salud disponible
Sin errores críticos en los logs
```

## Ejemplo

### Instalación completa mediante APT

El siguiente ejemplo reúne los pasos principales:

```bash
sudo apt update

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

La última consulta debería devolver información de salud de Grafana.

### Configurar el firewall del laboratorio

Si el servidor tiene UFW activo y el acceso se realizará desde la red `192.168.1.0/24`:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
```

Comprueba la regla:

```bash
sudo ufw status numbered
```

Desde un equipo cliente, prueba la conexión:

```bash
curl -I http://DIRECCION_IP_DEL_SERVIDOR:3000
```

También puedes comprobar el puerto:

```bash
nc -vz DIRECCION_IP_DEL_SERVIDOR 3000
```

### Resolver un fallo de inicio

Si Grafana no se inicia, consulta el estado:

```bash
sudo systemctl status grafana-server
```

Consulta los logs:

```bash
sudo journalctl -u grafana-server -xe --no-pager
```

Comprueba la configuración:

```bash
sudo grep -v '^[[:space:]]*#' /etc/grafana/grafana.ini \
  | grep -v '^[[:space:]]*$'
```

Comprueba los permisos:

```bash
sudo ls -ld /var/lib/grafana
sudo ls -ld /var/log/grafana
```

Comprueba si el puerto está ocupado:

```bash
sudo ss -lntp | grep ':3000'
```

Si otro proceso utiliza el puerto `3000`, identifica el proceso:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

Después de corregir el problema:

```bash
sudo systemctl restart grafana-server
```

### Desinstalar Grafana

Para eliminar el paquete conservando algunos ficheros de configuración:

```bash
sudo apt remove grafana
```

Para eliminar también los ficheros de configuración administrados por el paquete:

```bash
sudo apt purge grafana
```

Actualiza la información de paquetes:

```bash
sudo apt autoremove
```

El directorio de datos puede permanecer en el sistema. Compruébalo antes de eliminarlo:

```bash
sudo ls -la /var/lib/grafana
```

Si deseas eliminar los datos del laboratorio:

```bash
sudo rm -rf /var/lib/grafana
```

Este comando es destructivo. No debe ejecutarse en una instalación que contenga dashboards, usuarios o configuraciones que se quieran conservar.

Si ya no vas a utilizar el repositorio:

```bash
sudo rm -f /etc/apt/sources.list.d/grafana.list
sudo rm -f /etc/apt/keyrings/grafana.gpg
sudo apt update
```

### Actualizar Grafana

Antes de actualizar, realiza una copia de seguridad de:

```text
/etc/grafana/
/var/lib/grafana/
```

Ejemplo:

```bash
sudo tar -czf \
  /tmp/grafana-backup-$(date +%F).tar.gz \
  /etc/grafana \
  /var/lib/grafana
```

Actualiza la información de paquetes:

```bash
sudo apt update
```

Consulta si existe una actualización:

```bash
apt list --upgradable 2>/dev/null | grep grafana
```

Actualiza Grafana:

```bash
sudo apt install --only-upgrade grafana
```

Reinicia el servicio:

```bash
sudo systemctl restart grafana-server
```

Comprueba la versión:

```bash
grafana-server --version
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

Antes de actualizar en producción, revisa:

- Compatibilidad de plugins.
- Cambios de configuración.
- Requisitos de la nueva versión.
- Procedimiento de rollback.
- Copias de seguridad.
- Ventana de mantenimiento.

## Puntos clave

- Grafana puede instalarse en Ubuntu 24.04.5 LTS mediante el repositorio oficial de Grafana Labs.
- Es necesario añadir la clave de firma y el repositorio antes de instalar el paquete.
- El paquete principal utilizado en este laboratorio es `grafana`.
- Grafana se ejecuta normalmente como el servicio `grafana-server`.
- El puerto web predeterminado es `3000/tcp`.
- El servicio puede gestionarse mediante `systemctl`.
- `systemctl enable --now grafana-server` habilita e inicia el servicio.
- La API `/api/health` permite realizar una comprobación básica del estado.
- La configuración principal se encuentra normalmente en `/etc/grafana/grafana.ini`.
- Los datos locales suelen almacenarse en `/var/lib/grafana`.
- Los logs suelen encontrarse en `/var/log/grafana`.
- El servicio debe ejecutarse con un usuario específico y permisos limitados.
- El firewall debe permitir solo las redes que necesiten acceder a Grafana.
- Las credenciales predeterminadas deben cambiarse durante el primer acceso.
- La instalación de Grafana no configura automáticamente Prometheus u otras fuentes de datos.
- Los logs de `systemd` son una herramienta fundamental para diagnosticar errores.
- Antes de actualizar o desinstalar Grafana deben realizarse copias de seguridad.
- No se deben eliminar los datos de `/var/lib/grafana` sin confirmar que ya no son necesarios.
- En producción conviene utilizar HTTPS, un proxy inverso y controles de acceso.
- La instalación debe validarse comprobando el servicio, el puerto, la API de salud y los logs.

## Preguntas de comprobación

1. ¿Qué versión de Ubuntu se utiliza en este procedimiento?
2. ¿Qué método de instalación se utiliza para instalar Grafana?
3. ¿Para qué sirve la clave GPG del repositorio?
4. ¿Qué paquete se instala con `apt`?
5. ¿Qué servicio de `systemd` gestiona Grafana?
6. ¿Cuál es el puerto web predeterminado de Grafana?
7. ¿Qué comando permite iniciar Grafana?
8. ¿Qué comando permite activar el inicio automático?
9. ¿Qué diferencia existe entre `systemctl start` y `systemctl enable`?
10. ¿Qué comando permite comprobar el estado del servicio?
11. ¿Qué comando permite consultar los logs de Grafana?
12. ¿Qué función cumple la ruta `/etc/grafana/grafana.ini`?
13. ¿Dónde se almacenan normalmente los datos locales de Grafana?
14. ¿Cómo comprobarías que el puerto `3000` está escuchando?
15. ¿Qué consulta HTTP permite comprobar el estado de salud de Grafana?
16. ¿Por qué no se recomienda exponer Grafana directamente a Internet?
17. ¿Qué medidas aplicarías para proteger el acceso a Grafana?
18. ¿Qué pasos seguirías si el servicio no se inicia?
19. ¿Por qué es importante realizar una copia de seguridad antes de actualizar?
20. ¿Qué diferencia existe entre `apt remove` y `apt purge`?
```

## Referencias

- [Instalación oficial de Grafana en Debian y Ubuntu](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/)
- [Documentación oficial de Grafana](https://grafana.com/docs/grafana/latest/)
- [Documentación oficial de Ubuntu](https://documentation.ubuntu.com/)
- [Manual de `systemctl` y servicios systemd](https://www.freedesktop.org/software/systemd/man/latest/systemctl.html)
- [Documentación de UFW en Ubuntu](https://help.ubuntu.com/community/UFW)