# Problemas de acceso a Grafana

Esta página explica cómo diagnosticar y resolver los problemas más habituales al acceder a Grafana desde un navegador.

El acceso puede fallar por diferentes motivos:

- El servicio de Grafana está detenido.
- Grafana no está instalado correctamente.
- El puerto `3000` está ocupado o no está en escucha.
- Grafana solo acepta conexiones locales.
- El firewall bloquea la conexión.
- La dirección IP utilizada no es correcta.
- La URL base está mal configurada.
- Existe un problema con un proxy inverso.
- El usuario o la contraseña no son válidos.
- La cuenta está deshabilitada o bloqueada.
- El navegador conserva una sesión antigua.
- Grafana responde, pero la fuente de datos no funciona.

El diagnóstico debe comenzar por el propio servidor y continuar hasta el navegador:

```text
Servicio Grafana
        |
        v
Puerto 3000
        |
        v
Dirección de escucha
        |
        v
Firewall
        |
        v
Conectividad de red
        |
        v
Navegador
        |
        v
Autenticación
        |
        v
Fuentes de datos
```

> **Advertencia:** realiza las prácticas en el entorno de laboratorio. No restablezcas contraseñas ni modifiques el firewall de un sistema de producción sin autorización.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Comprobar si Grafana está instalado.
- Verificar el estado del servicio `grafana-server`.
- Consultar los registros de Grafana.
- Comprobar si el puerto `3000` está en escucha.
- Identificar el proceso que utiliza un puerto.
- Diferenciar un problema del servidor de un problema del navegador.
- Comprobar la dirección de escucha de Grafana.
- Diagnosticar problemas de acceso local y remoto.
- Revisar reglas del firewall.
- Comprobar la configuración de red de Grafana.
- Validar la URL base y el uso de un proxy inverso.
- Diagnosticar errores de autenticación.
- Comprobar la conexión con Prometheus.
- Documentar una incidencia de acceso de forma reproducible.

## Introducción

Grafana proporciona una interfaz web que suele estar disponible en el puerto:

```text
3000/tcp
```

En un laboratorio local, el acceso habitual es:

```text
http://localhost:3000
```

Si Grafana se ejecuta en otro equipo, se utiliza la dirección IP o el nombre DNS del servidor:

```text
http://DIRECCION_IP:3000
```

Ejemplo:

```text
http://192.168.1.50:3000
```

El primer diagnóstico debe responder a estas preguntas:

1. ¿Está instalado Grafana?
2. ¿Está activo el servicio?
3. ¿Está escuchando en el puerto `3000`?
4. ¿En qué dirección escucha?
5. ¿Responde una petición HTTP?
6. ¿El firewall permite la conexión?
7. ¿El navegador utiliza la URL correcta?
8. ¿Las credenciales son válidas?
9. ¿Grafana puede comunicarse con Prometheus?

## URL de acceso

### Acceso local

Si el navegador se ejecuta en el mismo servidor:

```text
http://localhost:3000
```

También:

```text
http://127.0.0.1:3000
```

Estas dos direcciones representan normalmente el propio equipo.

### Acceso mediante la dirección IP

Consulta las direcciones del servidor:

```bash
hostname -I
```

También:

```bash
ip addr
```

Ejemplo:

```text
192.168.1.50
```

Acceso:

```text
http://192.168.1.50:3000
```

### Acceso mediante nombre DNS

Si existe un nombre DNS:

```text
http://grafana.ejemplo.local:3000
```

Comprueba la resolución:

```bash
getent hosts grafana.ejemplo.local
```

También:

```bash
resolvectl query grafana.ejemplo.local
```

### Diferencia entre `localhost` y una dirección remota

Si ejecutas el navegador en el equipo del alumno y escribes:

```text
http://localhost:3000
```

el navegador intenta conectarse al propio equipo del alumno, no necesariamente al servidor donde está Grafana.

Si Grafana está en otro equipo, utiliza:

```text
http://IP_DEL_SERVIDOR:3000
```

Este es uno de los errores más frecuentes en entornos de laboratorio. `localhost` no es “el servidor de Grafana”; es “el equipo desde el que se abre el navegador”.

## Comprobar la instalación

### Consultar los paquetes instalados

```bash
dpkg -l | grep grafana
```

También:

```bash
apt policy grafana
```

### Localizar el ejecutable

```bash
command -v grafana-server
```

Si no aparece, busca en las rutas habituales:

```bash
sudo find /usr /opt -type f \
  -name "grafana-server" \
  -executable 2>/dev/null
```

### Consultar la versión

```bash
grafana-server --version
```

Si el comando no está en el `PATH`:

```bash
/usr/sbin/grafana-server --version
```

### Comprobar las rutas habituales

```bash
sudo ls -lah /etc/grafana
```

```bash
sudo ls -lah /var/lib/grafana
```

```bash
sudo ls -lah /var/log/grafana
```

Las rutas habituales son:

| Elemento | Ruta |
|---|---|
| Configuración principal | `/etc/grafana/grafana.ini` |
| Provisioning | `/etc/grafana/provisioning/` |
| Datos | `/var/lib/grafana/` |
| Plugins | `/var/lib/grafana/plugins/` |
| Registros | `/var/log/grafana/` |
| Unidad del servicio | `/lib/systemd/system/grafana-server.service` |

## Comprobar el servicio

### Consultar el estado completo

```bash
systemctl status grafana-server
```

La salida puede indicar:

```text
Active: active (running)
```

Esto significa que el servicio está activo.

Otros estados posibles:

```text
inactive
failed
activating
deactivating
```

Para salir de la vista:

```text
q
```

### Comprobar si está activo

```bash
systemctl is-active grafana-server
```

Resultado esperado:

```text
active
```

### Comprobar si se inicia automáticamente

```bash
systemctl is-enabled grafana-server
```

Resultado esperado:

```text
enabled
```

### Iniciar Grafana

```bash
sudo systemctl start grafana-server
```

### Reiniciar Grafana

```bash
sudo systemctl restart grafana-server
```

### Detener Grafana

```bash
sudo systemctl stop grafana-server
```

Realiza esta operación únicamente en el laboratorio o durante una ventana de mantenimiento autorizada.

### Activar el inicio automático

```bash
sudo systemctl enable grafana-server
```

Activar e iniciar simultáneamente:

```bash
sudo systemctl enable --now grafana-server
```

### Consultar servicios fallidos

```bash
systemctl --failed
```

## Consultar los registros

### Últimas líneas del registro

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

### Registros desde el último arranque

```bash
sudo journalctl -u grafana-server -b --no-pager
```

### Seguir los registros en tiempo real

```bash
sudo journalctl -u grafana-server -f
```

Para detener el seguimiento:

```text
Ctrl + C
```

### Consultar errores recientes

```bash
sudo journalctl -u grafana-server \
  -p err \
  --since "30 minutes ago" \
  --no-pager
```

### Consultar registros de una franja temporal

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --until "now" \
  --no-pager
```

### Consultar ficheros de registro

Si Grafana utiliza ficheros de log:

```bash
sudo find /var/log/grafana \
  -type f \
  -maxdepth 2 \
  -print
```

Consultar las últimas líneas:

```bash
sudo tail -n 100 /var/log/grafana/grafana.log
```

### Buscar errores

```bash
sudo journalctl -u grafana-server \
  --no-pager \
  | grep -i -E "error|failed|panic|permission|denied"
```

## Comprobar el puerto 3000

### Utilizar `ss`

```bash
sudo ss -lntp | grep ':3000'
```

Una salida posible:

```text
LISTEN 0 4096 127.0.0.1:3000 0.0.0.0:* users:(("grafana",pid=1234,fd=8))
```

Otra posibilidad:

```text
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1234,fd=8))
```

### Interpretar la dirección de escucha

#### `127.0.0.1:3000`

Grafana solo acepta conexiones desde el propio servidor.

```text
127.0.0.1:3000
```

El acceso local puede funcionar:

```bash
curl http://localhost:3000
```

Pero el acceso desde otro equipo puede fallar.

#### `0.0.0.0:3000`

Grafana acepta conexiones IPv4 en las interfaces disponibles, siempre que el firewall lo permita.

```text
0.0.0.0:3000
```

#### `[::]:3000`

Grafana escucha mediante IPv6:

```text
[::]:3000
```

La accesibilidad depende de la configuración IPv6 y del firewall.

### Utilizar `lsof`

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Utilizar `fuser`

```bash
sudo fuser -v 3000/tcp
```

### Identificar el proceso

Si el PID es `1234`:

```bash
ps -fp 1234
```

Consultar el proceso completo:

```bash
sudo tr '\0' ' ' < /proc/1234/cmdline
echo
```

## Probar Grafana desde el servidor

### Utilizar `curl`

```bash
curl -I http://localhost:3000
```

Una respuesta válida puede ser:

```text
HTTP/1.1 200 OK
```

o:

```text
HTTP/1.1 302 Found
```

Un código `302` suele indicar una redirección a la página de inicio de sesión.

### Consultar la respuesta completa

```bash
curl -v http://localhost:3000
```

### Consultar la página de salud

Grafana proporciona normalmente un endpoint de salud:

```bash
curl -s http://localhost:3000/api/health
```

Una respuesta correcta puede tener este aspecto:

```json
{
  "commit": "版本",
  "database": "ok",
  "version": "x.y.z"
}
```

Para obtener únicamente el código HTTP:

```bash
curl -s -o /dev/null \
  -w "%{http_code}\n" \
  http://localhost:3000/api/health
```

### Probar mediante la dirección IP local

Consulta las direcciones:

```bash
hostname -I
```

Después prueba:

```bash
curl -I http://DIRECCION_IP:3000
```

Si funciona con `localhost` pero no con la dirección IP, revisa la dirección de escucha de Grafana.

### Probar desde otro equipo

Desde el equipo cliente:

```bash
curl -I http://DIRECCION_IP_GRAFANA:3000
```

Si `curl` no está instalado:

```bash
sudo apt install curl
```

## Configuración de red de Grafana

### Localizar la configuración principal

```bash
sudo ls -l /etc/grafana/grafana.ini
```

### Consultar la sección HTTP

```bash
sudo grep -n -A 20 \
  "^\[server\]" \
  /etc/grafana/grafana.ini
```

Las opciones relacionadas suelen ser:

```ini
[server]
protocol = http
http_addr =
http_port = 3000
domain = localhost
root_url = %(protocol)s://%(domain)s:%(http_port)s/
```

### Consultar opciones concretas

```bash
sudo grep -n -E \
  "protocol|http_addr|http_port|domain|root_url|serve_from_sub_path" \
  /etc/grafana/grafana.ini
```

### Cambiar la dirección de escucha

Para escuchar en todas las interfaces IPv4:

```ini
[server]
http_addr = 0.0.0.0
```

Para escuchar únicamente en una dirección concreta:

```ini
[server]
http_addr = 192.168.1.50
```

Después de modificar la configuración:

```bash
sudo systemctl restart grafana-server
```

Comprueba:

```bash
sudo ss -lntp | grep ':3000'
```

> No expongas Grafana a redes no autorizadas. Escuchar en `0.0.0.0` no sustituye a una configuración segura del firewall.

### Cambiar el puerto

Ejemplo:

```ini
[server]
http_port = 3001
```

Después:

```bash
sudo systemctl restart grafana-server
```

Comprueba:

```bash
sudo ss -lntp | grep ':3001'
```

La URL pasará a ser:

```text
http://localhost:3001
```

También tendrás que actualizar:

- Reglas del firewall.
- Documentación del laboratorio.
- Proxies inversos.
- Marcadores del navegador.
- Pruebas automáticas.
- Cualquier enlace utilizado por los alumnos.

### Configurar `root_url`

Si Grafana se publica directamente en el puerto `3000`:

```ini
[server]
root_url = http://grafana.ejemplo.local:3000/
```

Si se publica detrás de un proxy en una subruta:

```ini
[server]
root_url = https://ejemplo.local/grafana/
serve_from_sub_path = true
```

La configuración debe coincidir con la URL pública real.

## Problemas de acceso local

### Grafana no responde en `localhost`

Ejecuta:

```bash
systemctl is-active grafana-server
```

```bash
sudo ss -lntp | grep ':3000'
```

```bash
curl -v http://localhost:3000
```

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

### No hay ningún proceso en el puerto

Si no aparece ninguna línea:

```bash
sudo ss -lntp | grep ':3000'
```

Comprueba:

```bash
systemctl status grafana-server
```

Si está detenido:

```bash
sudo systemctl start grafana-server
```

Si falla al iniciar:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

### El servicio está activo, pero no responde

Comprueba el proceso:

```bash
ps aux | grep "[g]rafana"
```

Comprueba el puerto:

```bash
sudo ss -lntp | grep ':3000'
```

Comprueba el endpoint:

```bash
curl -v http://localhost:3000/api/health
```

Comprueba los registros:

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

Posibles causas:

- El servicio está en proceso de iniciar.
- El puerto no es el esperado.
- La aplicación está bloqueada.
- El proxy local interfiere.
- El sistema tiene poca memoria.
- La configuración contiene un problema.

### El navegador muestra `ERR_CONNECTION_REFUSED`

Comprueba en el servidor:

```bash
sudo ss -lntp | grep ':3000'
```

Si no hay salida, Grafana no está escuchando en el puerto.

Comprueba:

```bash
systemctl status grafana-server
```

### El navegador muestra `ERR_CONNECTION_TIMED_OUT`

Este error suele indicar que la conexión no recibe respuesta.

Comprueba:

```bash
ping -c 4 DIRECCION_IP_GRAFANA
```

```bash
curl -I --max-time 5 \
  http://DIRECCION_IP_GRAFANA:3000
```

En el servidor:

```bash
sudo ufw status verbose
```

```bash
sudo ss -lntp | grep ':3000'
```

Posibles causas:

- Firewall.
- Dirección IP incorrecta.
- Ruta de red inexistente.
- Grafana escucha solo en `localhost`.
- El servidor no está accesible.
- El equipo cliente está en otra red.

### El navegador muestra `502 Bad Gateway`

Este error suele proceder de un proxy inverso, no directamente de Grafana.

Comprueba:

```bash
systemctl status grafana-server
```

```bash
curl -I http://localhost:3000
```

Si Grafana responde localmente, revisa el proxy:

```bash
sudo journalctl -u nginx -n 100 --no-pager
```

o:

```bash
sudo journalctl -u apache2 -n 100 --no-pager
```

También revisa:

- Dirección del backend.
- Puerto configurado.
- Protocolo HTTP o HTTPS.
- Rutas.
- Certificados.
- `root_url`.

## Problemas de acceso remoto

### Comprobar la dirección IP del servidor

En el servidor:

```bash
hostname -I
```

```bash
ip -br addr
```

### Comprobar la ruta desde el cliente

```bash
ip route
```

### Probar conectividad

Desde el cliente:

```bash
ping -c 4 DIRECCION_IP_GRAFANA
```

El ping puede estar bloqueado aunque el servicio HTTP funcione, por lo que no debe utilizarse como única prueba.

### Probar el puerto desde el cliente

```bash
nc -vz DIRECCION_IP_GRAFANA 3000
```

Si `nc` no está instalado:

```bash
sudo apt install netcat-openbsd
```

También puedes usar:

```bash
curl -I --max-time 5 \
  http://DIRECCION_IP_GRAFANA:3000
```

### Comprobar el firewall del servidor

```bash
sudo ufw status numbered
```

Si el puerto debe ser accesible desde una red de laboratorio:

```bash
sudo ufw allow from 192.168.1.0/24 \
  to any port 3000 \
  proto tcp
```

Comprueba la regla:

```bash
sudo ufw status verbose
```

### Comprobar que Grafana no escucha solo localmente

```bash
sudo ss -lntp | grep ':3000'
```

Si aparece:

```text
127.0.0.1:3000
```

revisa:

```ini
[server]
http_addr =
```

Configura una dirección adecuada para el laboratorio, reinicia y vuelve a comprobar.

### Diferenciar un problema de red de un problema de Grafana

| Prueba | Resultado | Interpretación |
|---|---|---|
| `curl localhost:3000` en servidor | Falla | Problema local de Grafana |
| `curl localhost:3000` en servidor | Funciona | Grafana funciona localmente |
| `curl IP:3000` en servidor | Falla | Dirección de escucha o configuración |
| `curl IP:3000` desde cliente | Falla | Red, firewall o escucha |
| `curl IP:3000` desde cliente | Funciona | El problema puede estar en navegador o credenciales |

## Problemas de autenticación

### Página de inicio de sesión visible

Si aparece la página de login, Grafana está respondiendo. El problema ya no es de conectividad, sino de autenticación o autorización.

Comprueba:

- Nombre de usuario.
- Contraseña.
- Mayúsculas y minúsculas.
- Espacio accidental al copiar.
- Método de autenticación.
- Estado de la cuenta.
- Organización seleccionada.
- Permisos del usuario.

### Credenciales iniciales

En muchas instalaciones locales, las credenciales iniciales pueden ser:

```text
Usuario: admin
Contraseña: admin
```

Grafana normalmente solicita cambiar la contraseña en el primer acceso.

No reutilices estas credenciales en un entorno expuesto o de producción.

### La contraseña no funciona

Comprueba que no se haya copiado un espacio:

```text
admin␠
```

Prueba desde una ventana privada del navegador.

Borra las cookies del dominio de Grafana.

Comprueba que el navegador no está rellenando una contraseña antigua.

### Restablecer la contraseña del administrador

El comando depende de la versión y del método de instalación. En muchas instalaciones puede utilizarse:

```bash
sudo grafana-cli admin reset-admin-password NUEVA_CONTRASEÑA
```

En instalaciones recientes puede estar disponible:

```bash
sudo grafana cli admin reset-admin-password NUEVA_CONTRASEÑA
```

Consulta primero las opciones disponibles:

```bash
grafana cli admin --help
```

o:

```bash
grafana-cli admin --help
```

Después reinicia Grafana si fuera necesario:

```bash
sudo systemctl restart grafana-server
```

> Utiliza este procedimiento únicamente con autorización. No incluyas la contraseña en el historial, en capturas ni en informes públicos.

### Evitar que la contraseña aparezca en el historial

En lugar de escribir una contraseña real directamente en una orden visible, revisa el método recomendado por la versión instalada y evita compartir:

```bash
history
```

Si una contraseña real se ha escrito accidentalmente en el historial, considera eliminar únicamente la entrada sensible y cambiar la contraseña.

### Cuenta deshabilitada

Consulta la configuración de usuarios desde la interfaz de administración o mediante el mecanismo de autenticación configurado.

Si se utiliza LDAP, OAuth, proxy authentication u otro proveedor externo, revisa:

- Configuración del proveedor.
- Mapeo de usuarios.
- Grupos.
- Permisos.
- Certificados.
- Registros de autenticación.

## Problemas de sesión y navegador

### Borrar cookies de Grafana

Las cookies antiguas pueden provocar:

- Redirecciones repetidas.
- Pantallas en blanco.
- Sesiones inválidas.
- Errores después de actualizar Grafana.
- Accesos con un usuario incorrecto.

Prueba:

- Ventana privada.
- Otro navegador.
- Borrar cookies del dominio.
- Recargar sin caché.

### Recarga completa

En Linux y Windows:

```text
Ctrl + Shift + R
```

En macOS:

```text
Cmd + Shift + R
```

### Comprobar errores del navegador

Abre las herramientas de desarrollo:

```text
F12
```

Revisa:

- Console.
- Network.
- Status code.
- URL solicitada.
- Redirecciones.
- Errores JavaScript.
- Recursos CSS y JavaScript no encontrados.

### Pantalla en blanco

Comprueba:

```bash
curl -I http://localhost:3000
```

En el navegador revisa:

- Errores en `Console`.
- Recursos con código `404`.
- Recursos bloqueados por el proxy.
- URL base incorrecta.
- Configuración de subruta.
- Problemas de caché.

### Bucle de redirecciones

Puede aparecer cuando:

- Grafana está configurado con HTTPS, pero el proxy utiliza HTTP.
- `root_url` no coincide con la URL pública.
- La subruta está configurada incorrectamente.
- El proxy no envía las cabeceras adecuadas.
- Hay dos proxies redirigiendo simultáneamente.

Consulta:

```bash
sudo grep -n -E \
  "protocol|domain|root_url|serve_from_sub_path" \
  /etc/grafana/grafana.ini
```

## Grafana detrás de un proxy inverso

### Acceso directo

Sin proxy:

```text
http://servidor:3000
```

### Acceso mediante dominio

Con proxy:

```text
https://grafana.ejemplo.local
```

### Acceso mediante subruta

Ejemplo:

```text
https://ejemplo.local/grafana/
```

Configuración orientativa:

```ini
[server]
protocol = http
domain = ejemplo.local
root_url = https://ejemplo.local/grafana/
serve_from_sub_path = true
```

La configuración exacta depende del proxy y de la arquitectura utilizada.

### Comprobar el backend directamente

Desde el servidor:

```bash
curl -I http://localhost:3000
```

### Comprobar el proxy

Desde el cliente:

```bash
curl -Ik https://ejemplo.local/grafana/
```

### Revisar registros del proxy

Para Nginx:

```bash
sudo tail -n 100 /var/log/nginx/error.log
```

```bash
sudo tail -n 100 /var/log/nginx/access.log
```

Para Apache:

```bash
sudo tail -n 100 /var/log/apache2/error.log
```

```bash
sudo tail -n 100 /var/log/apache2/access.log
```

### Problemas habituales del proxy

- El backend apunta al puerto equivocado.
- El proxy utiliza HTTPS contra un backend HTTP sin configurarlo correctamente.
- La subruta no coincide con `root_url`.
- No se envían cabeceras `Host` o `X-Forwarded-*`.
- Los recursos estáticos se solicitan desde una ruta incorrecta.
- El proxy tiene una regla de redirección circular.

## Problemas con HTTPS y certificados

### Comprobar un certificado

```bash
openssl s_client \
  -connect grafana.ejemplo.local:443 \
  -servername grafana.ejemplo.local
```

### Consultar la fecha de expiración

```bash
echo | openssl s_client \
  -connect grafana.ejemplo.local:443 \
  -servername grafana.ejemplo.local \
  2>/dev/null \
  | openssl x509 -noout -dates
```

### Probar con `curl`

```bash
curl -vk https://grafana.ejemplo.local
```

La opción `-k` omite la validación del certificado y debe utilizarse únicamente para diagnóstico controlado.

### Errores habituales

- Certificado caducado.
- Nombre del certificado distinto del dominio.
- Certificado autofirmado no confiable.
- Cadena incompleta.
- Proxy configurado con HTTPS incorrectamente.
- Fecha del sistema incorrecta.

## Problemas de conexión con Prometheus

El acceso a Grafana puede funcionar aunque Grafana no pueda consultar Prometheus.

### Comprobar Grafana

```bash
systemctl is-active grafana-server
```

### Comprobar Prometheus

```bash
systemctl is-active prometheus
```

### Comprobar Prometheus desde el servidor de Grafana

Si están en el mismo equipo:

```bash
curl http://localhost:9090/-/healthy
```

Si Prometheus está en otro equipo:

```bash
curl http://DIRECCION_IP_PROMETHEUS:9090/-/healthy
```

### Comprobar la fuente de datos

En Grafana:

1. Abre **Connections**.
2. Accede a **Data sources**.
3. Selecciona Prometheus.
4. Revisa la URL.
5. Pulsa **Save & test**.

### Errores habituales

```text
Bad Gateway
```

```text
Connection refused
```

```text
context deadline exceeded
```

Posibles causas:

- Prometheus está detenido.
- La URL utiliza `localhost` desde un servidor equivocado.
- El puerto es incorrecto.
- El firewall bloquea el acceso.
- Prometheus escucha solo en `127.0.0.1`.
- El nombre DNS no resuelve.
- Hay un problema de proxy.

### Consultar los registros de Grafana

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager
```

Busca referencias a:

```text
datasource
prometheus
connection refused
timeout
bad gateway
```

## Diagnóstico mediante la API de Grafana

### Comprobar la salud

```bash
curl -s http://localhost:3000/api/health
```

### Comprobar el código HTTP

```bash
curl -s -o /dev/null \
  -w "Código: %{http_code}\n" \
  http://localhost:3000/api/health
```

### Consultar una API protegida

Las rutas administrativas requieren autenticación. No incluyas credenciales reales en comandos compartidos.

Ejemplo conceptual:

```bash
curl -u usuario:CONTRASEÑA \
  http://localhost:3000/api/org
```

Para entornos de laboratorio, utiliza credenciales de prueba y elimina cualquier secreto antes de guardar el historial o compartir el informe.

## Diagnóstico completo automatizado

### Crear un script de diagnóstico

```bash
mkdir -p ~/laboratorio/acceso-grafana
cd ~/laboratorio/acceso-grafana
nano diagnostico-grafana.sh
```

Contenido:

```bash
#!/usr/bin/env bash

set -u

echo "===== DIAGNÓSTICO DE GRAFANA ====="
echo "Fecha: $(date)"
echo "Equipo: $(hostname)"
echo

echo "===== SISTEMA ====="
lsb_release -ds 2>/dev/null || true
uname -m
uname -r
echo

echo "===== SERVICIO ====="
systemctl is-active grafana-server 2>/dev/null || true
systemctl is-enabled grafana-server 2>/dev/null || true
echo

echo "===== PROCESO ====="
ps aux | grep "[g]rafana" || true
echo

echo "===== PUERTO 3000 ====="
sudo ss -lntp | grep ':3000' || true
echo

echo "===== ENDPOINT LOCAL ====="
curl -sS -o /dev/null \
  -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
  --max-time 5 \
  http://localhost:3000/api/health \
  || true
echo

echo "===== CONFIGURACIÓN ====="
sudo grep -n -E \
  "protocol|http_addr|http_port|domain|root_url|serve_from_sub_path" \
  /etc/grafana/grafana.ini \
  2>/dev/null || true
echo

echo "===== ESPACIO ====="
df -h / /var /var/lib 2>/dev/null || true
echo

echo "===== REGISTROS RECIENTES ====="
sudo journalctl -u grafana-server \
  -n 30 \
  --no-pager \
  2>/dev/null || true
```

### Conceder permisos de ejecución

```bash
chmod +x diagnostico-grafana.sh
```

### Ejecutar el diagnóstico

```bash
./diagnostico-grafana.sh
```

### Guardar el resultado

```bash
./diagnostico-grafana.sh \
  | tee diagnostico-grafana.txt
```

## Sesión práctica 1: Grafana no responde localmente

### Objetivo

Diagnosticar un acceso fallido desde el propio servidor.

### Situación

El navegador muestra:

```text
Unable to connect
```

### Comprobar el servicio

```bash
systemctl is-active grafana-server
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':3000'
```

### Probar el endpoint

```bash
curl -v http://localhost:3000/api/health
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager
```

### Aplicar una posible recuperación

Si el servicio está detenido:

```bash
sudo systemctl start grafana-server
```

Si el servicio está fallando:

```bash
sudo systemctl restart grafana-server
```

### Validar

```bash
systemctl is-active grafana-server
```

```bash
sudo ss -lntp | grep ':3000'
```

```bash
curl -s http://localhost:3000/api/health
```

### Preguntas de análisis

- ¿Estaba activo el servicio?
- ¿Había un proceso en el puerto `3000`?
- ¿Qué mensaje aparecía en el journal?
- ¿Qué código HTTP devolvió el endpoint?
- ¿La recuperación requirió reiniciar o corregir la configuración?

## Sesión práctica 2: Grafana funciona localmente, pero no desde otro equipo

### Objetivo

Diagnosticar un problema de acceso remoto.

### Preparación

En el servidor de Grafana:

```bash
hostname -I
```

```bash
sudo ss -lntp | grep ':3000'
```

En el propio servidor:

```bash
curl -I http://localhost:3000
```

### Prueba desde el cliente

Sustituye la dirección:

```bash
curl -I http://DIRECCION_IP_GRAFANA:3000
```

### Comprobar conectividad

```bash
ping -c 4 DIRECCION_IP_GRAFANA
```

### Comprobar el puerto

```bash
nc -vz DIRECCION_IP_GRAFANA 3000
```

### Comprobar el firewall

En el servidor:

```bash
sudo ufw status verbose
```

### Analizar la dirección de escucha

```bash
sudo ss -lntp | grep ':3000'
```

Si aparece:

```text
127.0.0.1:3000
```

revisa la configuración:

```bash
sudo grep -n -A 10 \
  "^\[server\]" \
  /etc/grafana/grafana.ini
```

### Corrección controlada

Edita la configuración:

```bash
sudo nano /etc/grafana/grafana.ini
```

Configura, según la arquitectura del laboratorio:

```ini
[server]
http_addr = 0.0.0.0
```

Reinicia:

```bash
sudo systemctl restart grafana-server
```

Comprueba:

```bash
sudo ss -lntp | grep ':3000'
```

Si el firewall está activo, permite únicamente la red de laboratorio:

```bash
sudo ufw allow from 192.168.1.0/24 \
  to any port 3000 \
  proto tcp
```

### Validación

Desde el cliente:

```bash
curl -I http://DIRECCION_IP_GRAFANA:3000
```

### Preguntas de análisis

- ¿Qué dirección utilizaba Grafana antes del cambio?
- ¿Qué dirección utiliza después?
- ¿El firewall estaba activo?
- ¿La regla permite acceso desde cualquier lugar o desde una red concreta?
- ¿Qué riesgos tendría abrir el puerto a Internet?

## Sesión práctica 3: conflicto en el puerto 3000

### Objetivo

Identificar el proceso que impide a Grafana utilizar su puerto.

### Comprobar el servicio

```bash
systemctl status grafana-server
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager
```

Busca mensajes como:

```text
address already in use
```

### Identificar el proceso

```bash
sudo ss -lntp | grep ':3000'
```

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

### Consultar el proceso

```bash
ps -fp PID
```

### Consultar todos los procesos relacionados

```bash
ps aux | grep "[g]rafana"
```

### Analizar la solución

Determina si:

- Existe una segunda instancia de Grafana.
- El proceso pertenece a otra aplicación.
- Se ha iniciado un Grafana manualmente.
- Existe una unidad duplicada.
- Es preferible detener el proceso o cambiar el puerto.

### Validación

Después de la corrección:

```bash
sudo systemctl restart grafana-server
```

```bash
systemctl is-active grafana-server
```

```bash
sudo ss -lntp | grep ':3000'
```

```bash
curl -I http://localhost:3000
```

## Sesión práctica 4: problema de autenticación

### Objetivo

Diferenciar un problema de red de un problema de credenciales.

### Comprobar que Grafana responde

```bash
curl -I http://localhost:3000
```

Si responde con:

```text
HTTP/1.1 200 OK
```

o:

```text
HTTP/1.1 302 Found
```

Grafana está accesible.

### Acceder desde el navegador

Abre:

```text
http://localhost:3000
```

o la dirección correspondiente:

```text
http://DIRECCION_IP_GRAFANA:3000
```

### Comprobar la sesión

Prueba:

- Ventana privada.
- Eliminación de cookies.
- Otro navegador.
- Recarga completa.
- Usuario correcto.
- Contraseña del entorno de laboratorio.

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager
```

### Restablecimiento controlado

Consulta primero la ayuda:

```bash
grafana cli admin --help
```

o:

```bash
grafana-cli admin --help
```

Utiliza el procedimiento de restablecimiento autorizado por el profesor.

Después:

```bash
sudo systemctl restart grafana-server
```

### Preguntas de análisis

- ¿El servicio estaba disponible?
- ¿La pantalla de login aparecía?
- ¿El problema era de red o de autenticación?
- ¿Qué evidencias se obtuvieron?
- ¿Dónde se debe evitar guardar la nueva contraseña?

## Sesión práctica 5: Grafana detrás de una subruta

### Objetivo

Comprender los problemas derivados de publicar Grafana en una subruta.

### Situación

Grafana se publica mediante:

```text
https://ejemplo.local/grafana/
```

Pero la página aparece incompleta o redirige incorrectamente.

### Comprobar el acceso directo

En el servidor:

```bash
curl -I http://localhost:3000
```

### Consultar la configuración

```bash
sudo grep -n -E \
  "protocol|domain|root_url|serve_from_sub_path" \
  /etc/grafana/grafana.ini
```

### Configuración orientativa

```ini
[server]
protocol = http
domain = ejemplo.local
root_url = https://ejemplo.local/grafana/
serve_from_sub_path = true
```

### Reiniciar Grafana

```bash
sudo systemctl restart grafana-server
```

### Comprobar el proxy

```bash
curl -Ik https://ejemplo.local/grafana/
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

Si se utiliza Nginx:

```bash
sudo tail -n 100 /var/log/nginx/error.log
```

### Preguntas de análisis

- ¿Cuál es la URL pública?
- ¿Cuál es la URL interna?
- ¿Coincide `root_url` con la URL pública?
- ¿Está activado `serve_from_sub_path`?
- ¿Qué recursos fallan en la pestaña Network del navegador?

## Sesión práctica 6: Grafana no conecta con Prometheus

### Objetivo

Diagnosticar el acceso de Grafana a su fuente de datos.

### Comprobar Prometheus

```bash
systemctl is-active prometheus
```

### Comprobar su endpoint de salud

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar desde el servidor de Grafana

Si Prometheus está en otro equipo:

```bash
curl http://DIRECCION_IP_PROMETHEUS:9090/-/healthy
```

### Revisar la fuente de datos

En Grafana:

1. Accede a **Connections**.
2. Selecciona **Data sources**.
3. Abre Prometheus.
4. Comprueba la URL.
5. Pulsa **Save & test**.

### Errores frecuentes

Si Grafana y Prometheus están en el mismo equipo:

```text
http://localhost:9090
```

Si están en equipos diferentes, no utilices `localhost` para referirte al otro servidor. Utiliza:

```text
http://DIRECCION_IP_PROMETHEUS:9090
```

### Consultar los registros de Grafana

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager \
  | grep -i -E "prometheus|datasource|timeout|refused"
```

### Validación

Ejecuta en Grafana:

```promql
up
```

El resultado debe mostrar los targets conocidos por Prometheus.

## Sesión práctica 7: generar un informe de acceso

### Objetivo

Crear un informe reproducible sobre el estado de acceso a Grafana.

### Preparación

```bash
mkdir -p ~/laboratorio/acceso-grafana
cd ~/laboratorio/acceso-grafana
```

### Ejecutar el diagnóstico

```bash
{
  echo "===== INFORME DE ACCESO A GRAFANA ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== SERVICIO ====="
  systemctl is-active grafana-server 2>/dev/null || true
  systemctl is-enabled grafana-server 2>/dev/null || true
  echo

  echo "===== PUERTO ====="
  sudo ss -lntp | grep ':3000' || true
  echo

  echo "===== ENDPOINT ====="
  curl -sS -o /dev/null \
    -w "Código HTTP: %{http_code}\nTiempo: %{time_total}s\n" \
    --max-time 5 \
    http://localhost:3000/api/health \
    || true
  echo

  echo "===== CONFIGURACIÓN DE RED ====="
  sudo grep -n -E \
    "protocol|http_addr|http_port|domain|root_url|serve_from_sub_path" \
    /etc/grafana/grafana.ini \
    2>/dev/null || true
  echo

  echo "===== RED ====="
  hostname -I
  ip route
  echo

  echo "===== FIREWALL ====="
  sudo ufw status verbose 2>/dev/null || true
  echo

  echo "===== ESPACIO ====="
  df -h / /var /var/lib
  echo

  echo "===== REGISTROS ====="
  sudo journalctl -u grafana-server \
    -n 50 \
    --no-pager \
    2>/dev/null || true
} | tee informe-acceso-grafana.txt
```

### Revisar el informe

```bash
less informe-acceso-grafana.txt
```

### Comprobar que se ha creado

```bash
test -f informe-acceso-grafana.txt \
  && echo "Informe creado correctamente"
```

## Matriz de diagnóstico

| Síntoma | Primera prueba | Posible causa |
|---|---|---|
| `Connection refused` | `ss` y `systemctl` | Servicio detenido o puerto cerrado |
| `Connection timed out` | `ufw`, `ip route`, `nc` | Firewall o red |
| `502 Bad Gateway` | `curl localhost:3000` | Proxy o backend |
| Página de login | `curl` responde | Problema de credenciales |
| Pantalla en blanco | Consola del navegador | URL base o recursos |
| Redirección infinita | `root_url` y proxy | HTTP/HTTPS o subruta |
| Dashboard sin datos | Fuente de datos | Prometheus inaccesible |
| Puerto ocupado | `lsof` o `ss` | Otra aplicación |
| Servicio `failed` | `journalctl` | Configuración, permisos o dependencia |
| Acceso local correcto, remoto incorrecto | Dirección de escucha | `127.0.0.1` o firewall |

## Lista de comprobación rápida

```text
[ ] La dirección URL es correcta.
[ ] El nombre DNS resuelve.
[ ] La dirección IP del servidor es correcta.
[ ] Grafana está instalado.
[ ] grafana-server está activo.
[ ] El proceso de Grafana existe.
[ ] El puerto 3000 está en escucha.
[ ] La dirección de escucha es adecuada.
[ ] El endpoint /api/health responde.
[ ] El firewall permite el acceso necesario.
[ ] El navegador no tiene una sesión antigua.
[ ] Las credenciales son correctas.
[ ] root_url coincide con la URL pública.
[ ] El proxy inverso funciona, si existe.
[ ] Prometheus está accesible desde Grafana.
[ ] La fuente de datos está validada.
[ ] Los registros no muestran errores críticos.
```

## Buenas prácticas

- Comienza siempre por el servicio antes de investigar el navegador.
- Utiliza `curl` para separar problemas del servidor y problemas del navegador.
- Comprueba el puerto real con `ss`.
- Comprueba la dirección de escucha.
- Utiliza el nombre DNS o la IP correcta desde el cliente.
- No utilices `localhost` para acceder a otro servidor.
- Limita el acceso del firewall a la red necesaria.
- No expongas Grafana directamente a Internet sin protección.
- Utiliza HTTPS cuando Grafana sea accesible fuera del laboratorio.
- Crea copias de seguridad antes de editar `grafana.ini`.
- Valida la URL pública cuando utilices un proxy inverso.
- Revisa las cookies y la caché cuando aparezcan problemas de sesión.
- No compartas contraseñas en comandos, capturas o informes.
- Consulta los registros antes de reiniciar repetidamente el servicio.
- Documenta el estado inicial y el resultado final.
- Comprueba la fuente de datos después de recuperar el acceso a Grafana.
- Diferencia un problema de acceso a Grafana de un problema de datos en los paneles.

## Puntos clave

- Grafana utiliza normalmente el puerto `3000`.
- `systemctl status grafana-server` muestra el estado del servicio.
- `journalctl -u grafana-server` muestra los registros.
- `ss -lntp` permite comprobar si el puerto está en escucha.
- `curl` permite verificar el acceso sin depender del navegador.
- `127.0.0.1` solo permite conexiones locales.
- `0.0.0.0` permite escuchar en las interfaces IPv4 disponibles.
- `localhost` siempre hace referencia al equipo desde el que se realiza la conexión.
- Un `Connection refused` suele indicar que no hay un servicio aceptando conexiones.
- Un `Connection timed out` suele relacionarse con red, firewall o rutas.
- Un `502 Bad Gateway` suele indicar un problema entre el proxy y Grafana.
- Ver la pantalla de login demuestra que Grafana es accesible.
- Una pantalla de login no garantiza que las credenciales sean válidas.
- `root_url` debe coincidir con la URL pública de Grafana.
- Una fuente de datos de Prometheus puede fallar aunque Grafana sea accesible.
- El diagnóstico debe realizarse desde el servidor y desde el cliente.
- Las contraseñas y tokens no deben aparecer en informes ni repositorios.
- Toda incidencia debe registrar síntoma, pruebas, causa, solución y validación.

## Preguntas de comprobación

1. ¿Cuál es el puerto habitual de Grafana?
2. ¿Qué comando permite comprobar si `grafana-server` está activo?
3. ¿Qué comando permite consultar los registros de Grafana?
4. ¿Qué diferencia existe entre `127.0.0.1:3000` y `0.0.0.0:3000`?
5. ¿Por qué `localhost` puede ser incorrecto al acceder desde otro equipo?
6. ¿Qué significa normalmente el error `Connection refused`?
7. ¿Qué causas pueden producir un `Connection timed out`?
8. ¿Qué comando permite identificar el proceso que utiliza el puerto `3000`?
9. ¿Qué endpoint permite comprobar la salud de Grafana?
10. ¿Qué diferencia existe entre un problema de conectividad y un problema de autenticación?
11. ¿Qué comprobarías si Grafana funciona en el servidor, pero no desde el cliente?
12. ¿Qué función cumple `root_url`?
13. ¿Cuándo puede ser necesario utilizar `serve_from_sub_path`?
14. ¿Qué comprobarías ante un error `502 Bad Gateway`?
15. ¿Qué problema puede provocar una URL de Prometheus basada en `localhost`?
16. ¿Qué pasos realizarías si aparece una pantalla en blanco?
17. ¿Por qué conviene probar Grafana con `curl`?
18. ¿Qué información debe incluir un informe de acceso?
19. ¿Por qué no se deben abrir indiscriminadamente los puertos del servidor?
20. ¿Qué comprobaciones realizarías antes de restablecer una contraseña?