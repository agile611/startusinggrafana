Aquí tienes una página Markdown completa, lista para guardar como:

```text
docs/02-grafana/04-acceso-grafana.md
```

```markdown
# Acceso a Grafana

## Objetivos

Al finalizar esta sección podrás:

- Acceder a Grafana desde el propio servidor y desde un equipo remoto.
- Identificar la dirección y el puerto utilizados por Grafana.
- Comprobar que el servicio está activo antes de abrir la interfaz web.
- Realizar el primer inicio de sesión.
- Cambiar las credenciales iniciales.
- Diagnosticar problemas habituales de conectividad.
- Aplicar medidas básicas de seguridad para proteger el acceso.

## Introducción

Una vez instalado Grafana y puesto en marcha el servicio, es necesario acceder a su interfaz web para completar la configuración inicial.

De forma predeterminada, Grafana escucha en el puerto:

```text
3000/tcp
```

Si Grafana está instalado en el mismo equipo desde el que se abre el navegador, la dirección habitual es:

```text
http://localhost:3000
```

Si Grafana está instalado en un servidor remoto, se utilizará la dirección IP o el nombre DNS del servidor:

```text
http://DIRECCION_IP:3000
```

o:

```text
http://grafana.example.com:3000
```

El acceso a Grafana depende de varios componentes:

```text
Navegador
   │
   │ HTTP o HTTPS
   ▼
Servidor Grafana
   │
   ├── Servicio grafana-server
   ├── Puerto 3000
   ├── Autenticación
   └── Base de datos de Grafana
```

Antes de intentar acceder desde el navegador, conviene verificar que el servicio está activo, que el puerto está disponible y que el firewall permite la conexión.

## Contenido

### Comprobar el estado de Grafana

Comprueba el estado del servicio:

```bash
sudo systemctl status grafana-server
```

El resultado esperado debe incluir:

```text
Active: active (running)
```

También puedes realizar una comprobación breve:

```bash
systemctl is-active grafana-server
```

La salida esperada es:

```text
active
```

Comprueba si el servicio está configurado para iniciarse automáticamente:

```bash
systemctl is-enabled grafana-server
```

La salida esperada es:

```text
enabled
```

Si Grafana está detenido, inicia el servicio:

```bash
sudo systemctl start grafana-server
```

Para reiniciarlo:

```bash
sudo systemctl restart grafana-server
```

Para detenerlo:

```bash
sudo systemctl stop grafana-server
```

### Comprobar el puerto de escucha

Grafana utiliza normalmente el puerto `3000`.

Comprueba si existe un proceso escuchando:

```bash
sudo ss -lntp | grep ':3000'
```

Una salida posible es:

```text
LISTEN 0 4096 0.0.0.0:3000 0.0.0.0:* users:(("grafana",pid=1234,fd=10))
```

También puedes utilizar:

```bash
sudo lsof -iTCP:3000 -sTCP:LISTEN
```

Si no aparece ningún resultado:

- Grafana puede estar detenido.
- El servicio puede haber fallado al iniciarse.
- Se puede estar utilizando otro puerto.
- La configuración puede contener un error.

Consulta los logs:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

### Acceder desde el propio servidor

Si el navegador se ejecuta en el mismo servidor donde está instalado Grafana, utiliza:

```text
http://localhost:3000
```

También puedes utilizar:

```text
http://127.0.0.1:3000
```

Desde la terminal, comprueba la respuesta:

```bash
curl -I http://localhost:3000
```

Una respuesta correcta puede ser similar a:

```text
HTTP/1.1 302 Found
```

También puedes consultar la API de salud:

```bash
curl -s http://localhost:3000/api/health
```

La respuesta debería indicar que la base de datos está disponible:

```json
{
  "database": "ok"
}
```

El contenido exacto depende de la versión instalada.

### Acceder desde otro equipo

Si Grafana está instalado en un servidor remoto, primero identifica su dirección IP:

```bash
hostname -I
```

También puedes utilizar:

```bash
ip -br address
```

Ejemplo de resultado:

```text
192.168.1.50
```

Desde el equipo cliente, abre:

```text
http://192.168.1.50:3000
```

Si se utiliza un nombre DNS:

```text
http://grafana.example.com:3000
```

La dirección debe ser accesible desde el equipo cliente y el puerto `3000` debe estar permitido por la red y el firewall.

### Comprobar la conectividad desde el cliente

Desde el equipo cliente, comprueba si el puerto está accesible:

```bash
nc -vz 192.168.1.50 3000
```

Una respuesta correcta sería similar a:

```text
Connection to 192.168.1.50 3000 port [tcp/*] succeeded!
```

También puedes utilizar `curl`:

```bash
curl -I http://192.168.1.50:3000
```

Si `nc` no está instalado en Ubuntu:

```bash
sudo apt install -y netcat-openbsd
```

Comprueba la resolución DNS:

```bash
getent hosts grafana.example.com
```

Si el nombre no se resuelve, prueba temporalmente con la dirección IP para determinar si el problema está relacionado con DNS.

### Firewall del servidor

Comprueba el estado de UFW:

```bash
sudo ufw status verbose
```

Para permitir el acceso desde una red local:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 3000 proto tcp
```

Para permitir el acceso desde una única dirección:

```bash
sudo ufw allow from 192.168.1.25 to any port 3000 proto tcp
```

Comprueba las reglas configuradas:

```bash
sudo ufw status numbered
```

No es recomendable abrir Grafana a cualquier origen mediante:

```bash
sudo ufw allow 3000/tcp
```

Esta regla permite conexiones desde cualquier dirección accesible por el servidor. En un entorno real debe limitarse el origen siempre que sea posible.

### Inicio de sesión inicial

Al abrir Grafana por primera vez aparecerá la pantalla de inicio de sesión.

En una instalación nueva, las credenciales iniciales suelen ser:

```text
Usuario: admin
Contraseña: admin
```

Después del primer acceso, Grafana normalmente solicitará cambiar la contraseña.

La nueva contraseña debe ser:

- Larga.
- Única.
- Difícil de adivinar.
- Diferente de la utilizada en otros servicios.
- Protegida mediante un gestor de contraseñas.

No mantengas las credenciales predeterminadas en un entorno de producción.

### Cambiar la contraseña

Después de iniciar sesión:

1. Abre el menú del usuario.
2. Accede a las preferencias o configuración de la cuenta.
3. Selecciona la opción para cambiar la contraseña.
4. Introduce la contraseña actual.
5. Introduce la nueva contraseña.
6. Confirma el cambio.
7. Guarda la configuración.

Si la contraseña de `admin` se ha perdido, puede restablecerse desde el servidor utilizando la CLI de Grafana.

El comando exacto puede variar según la versión y el método de instalación. Comprueba primero las opciones disponibles:

```bash
grafana cli admin --help
```

En algunas instalaciones se puede utilizar:

```bash
sudo grafana cli admin reset-admin-password NUEVA_CONTRASEÑA
```

Después del restablecimiento, vuelve a acceder con:

```text
Usuario: admin
Contraseña: NUEVA_CONTRASEÑA
```

Evita incluir contraseñas reales en historiales de terminal, scripts o repositorios.

### Acceso mediante HTTPS

En un laboratorio puede utilizarse HTTP:

```text
http://192.168.1.50:3000
```

En producción es preferible utilizar HTTPS:

```text
https://grafana.example.com
```

Una arquitectura habitual utiliza un proxy inverso:

```text
Navegador
   │ HTTPS :443
   ▼
Nginx o Apache
   │ HTTP interno :3000
   ▼
Grafana
```

El proxy inverso puede encargarse de:

- Gestionar certificados TLS.
- Redirigir HTTP hacia HTTPS.
- Publicar Grafana mediante un nombre DNS.
- Añadir cabeceras de seguridad.
- Limitar el acceso por red.
- Integrarse con sistemas de autenticación.

En este caso, los usuarios acceden al puerto `443`, mientras que Grafana continúa escuchando internamente en el puerto `3000`.

### Acceso mediante un nombre DNS

En lugar de utilizar una dirección IP, puede configurarse un nombre DNS:

```text
grafana.example.com
```

El nombre debe apuntar a la dirección IP del servidor o del proxy inverso.

Comprueba la resolución:

```bash
getent hosts grafana.example.com
```

Comprueba la respuesta del servicio:

```bash
curl -I https://grafana.example.com
```

Si se utiliza un nombre DNS interno, todos los clientes autorizados deben poder resolverlo correctamente.

### Configuración de la URL pública

Cuando Grafana se publica mediante un nombre DNS o un proxy inverso, puede ser necesario configurar la URL pública en:

```text
/etc/grafana/grafana.ini
```

Realiza una copia de seguridad:

```bash
sudo cp \
  /etc/grafana/grafana.ini \
  /etc/grafana/grafana.ini.bak
```

Edita la configuración:

```bash
sudo nano /etc/grafana/grafana.ini
```

En la sección `[server]`, configura valores similares a:

```ini
[server]
protocol = http
http_port = 3000
domain = grafana.example.com
root_url = https://grafana.example.com/
```

Después, reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

La configuración exacta depende de si HTTPS termina en Grafana o en un proxy inverso.

### Problemas habituales de acceso

#### La página no responde

Comprueba si Grafana está activo:

```bash
sudo systemctl is-active grafana-server
```

Comprueba el puerto:

```bash
sudo ss -lntp | grep ':3000'
```

Comprueba la respuesta local:

```bash
curl -I http://localhost:3000
```

Consulta los logs:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

#### Error de conexión rechazada

Un error de conexión rechazada suele indicar que:

- El servicio está detenido.
- No hay ningún proceso escuchando en el puerto.
- Se ha utilizado un puerto incorrecto.
- Un proxy está mal configurado.

Comprueba:

```bash
sudo systemctl status grafana-server
```

```bash
sudo ss -lntp | grep ':3000'
```

#### Tiempo de espera agotado

Un tiempo de espera puede deberse a:

- Firewall.
- Ruta de red incorrecta.
- Dirección IP equivocada.
- Servicio escuchando solo en `localhost`.
- Regla de seguridad de la nube.
- Proxy o VPN.

Desde el cliente:

```bash
nc -vz DIRECCION_IP 3000
```

Desde el servidor:

```bash
curl -I http://localhost:3000
```

Si funciona localmente pero no desde el cliente, revisa la red y el firewall.

#### El navegador muestra un error 502

Un error `502 Bad Gateway` suele indicar que el proxy inverso no puede comunicarse con Grafana.

Comprueba:

```bash
sudo systemctl status grafana-server
```

Verifica que Grafana escucha en el puerto configurado:

```bash
sudo ss -lntp | grep ':3000'
```

Comprueba la conexión desde el servidor del proxy:

```bash
curl -I http://127.0.0.1:3000
```

Revisa los logs del proxy y de Grafana.

#### El nombre DNS no funciona

Prueba directamente con la dirección IP:

```text
http://DIRECCION_IP:3000
```

Si la dirección IP funciona y el nombre no, revisa:

- Registro DNS.
- Servidores DNS utilizados.
- Archivo `/etc/hosts`.
- Caché DNS.
- Configuración del dominio.
- Nombre incluido en el certificado TLS.

#### El servicio falla después de modificar la configuración

Consulta los logs:

```bash
sudo journalctl -u grafana-server -xe --no-pager
```

Restaura la copia de seguridad si es necesario:

```bash
sudo cp \
  /etc/grafana/grafana.ini.bak \
  /etc/grafana/grafana.ini
```

Reinicia el servicio:

```bash
sudo systemctl restart grafana-server
```

### Acceso y seguridad

Para proteger el acceso a Grafana:

- Cambia la contraseña inicial.
- Utiliza HTTPS en producción.
- Limita el acceso mediante firewall.
- No expongas innecesariamente el puerto `3000`.
- Utiliza usuarios individuales.
- Evita compartir la cuenta de administrador.
- Asigna permisos mínimos.
- Mantén Grafana actualizado.
- Revisa los logs.
- Realiza copias de seguridad.
- Protege los tokens y credenciales.
- Utiliza autenticación externa cuando sea necesario.

Una arquitectura más segura sería:

```text
Usuarios autorizados
        │
        │ HTTPS :443
        ▼
Proxy inverso
        │
        │ Red interna
        ▼
Grafana :3000
        │
        ▼
Fuentes de datos
```

## Ejemplo

### Acceder a Grafana en un servidor local

Supongamos que Grafana está instalado en Ubuntu y se ejecuta en el mismo equipo que el navegador.

Comprueba el servicio:

```bash
sudo systemctl status grafana-server
```

Comprueba la API:

```bash
curl -s http://localhost:3000/api/health
```

Abre en el navegador:

```text
http://localhost:3000
```

Inicia sesión con las credenciales iniciales y cambia la contraseña cuando Grafana lo solicite.

### Acceder desde un equipo remoto

Supongamos la siguiente configuración:

```text
Servidor Grafana: 192.168.1.50
Puerto: 3000
Equipo cliente: 192.168.1.25
```

En el servidor, permite el acceso únicamente desde el equipo cliente:

```bash
sudo ufw allow from 192.168.1.25 to any port 3000 proto tcp
```

Comprueba la regla:

```bash
sudo ufw status numbered
```

Desde el equipo cliente:

```bash
nc -vz 192.168.1.50 3000
```

Después abre:

```text
http://192.168.1.50:3000
```

### Diagnóstico completo de conexión

Ejecuta en el servidor Grafana:

```bash
echo "=== Servicio ==="
systemctl is-active grafana-server

echo "=== Puerto ==="
sudo ss -lntp | grep ':3000' || true

echo "=== API local ==="
curl -s http://localhost:3000/api/health

echo "=== Logs recientes ==="
sudo journalctl -u grafana-server -n 20 --no-pager
```

Desde el equipo cliente:

```bash
echo "=== Resolución ==="
getent hosts 192.168.1.50

echo "=== Conectividad TCP ==="
nc -vz 192.168.1.50 3000

echo "=== Respuesta HTTP ==="
curl -I http://192.168.1.50:3000
```

Interpretación:

| Resultado | Posible causa |
|---|---|
| Servicio inactivo | Grafana no está iniciado |
| Sin puerto `3000` | Error de inicio o puerto diferente |
| API local funciona, cliente falla | Firewall o red |
| `nc` funciona, navegador falla | Problema del navegador o URL |
| Error `502` | Proxy inverso mal configurado |
| Error DNS | Nombre no resuelto |
| Error TLS | Certificado o HTTPS mal configurado |

### Configurar un acceso mediante dominio

Supongamos:

```text
Dominio: grafana.example.com
Proxy inverso: 192.168.1.10
Grafana: 192.168.1.50:3000
```

Los usuarios accederán mediante:

```text
https://grafana.example.com
```

El proxy inverso reenviará las solicitudes a:

```text
http://192.168.1.50:3000
```

En Grafana se puede configurar:

```ini
[server]
protocol = http
http_port = 3000
domain = grafana.example.com
root_url = https://grafana.example.com/
```

Después de modificar la configuración:

```bash
sudo systemctl restart grafana-server
```

Comprueba el acceso final:

```bash
curl -I https://grafana.example.com
```

El navegador debe mostrar la pantalla de inicio de sesión de Grafana mediante HTTPS.

## Puntos clave

- Grafana escucha normalmente en el puerto `3000`.
- El acceso local se realiza mediante `http://localhost:3000`.
- El acceso remoto utiliza la dirección IP o el nombre DNS del servidor.
- Antes de acceder, hay que comprobar que `grafana-server` está activo.
- `ss` y `lsof` permiten comprobar si el puerto está escuchando.
- `curl` permite probar la respuesta HTTP desde la terminal.
- `nc` permite comprobar la conectividad TCP desde un equipo cliente.
- El firewall puede impedir el acceso aunque Grafana esté funcionando correctamente.
- Las credenciales iniciales deben cambiarse durante el primer acceso.
- No debe compartirse la cuenta de administrador.
- En producción es recomendable utilizar HTTPS.
- Un proxy inverso puede gestionar TLS y publicar Grafana mediante un dominio.
- La configuración de `root_url` es importante cuando Grafana se publica detrás de un proxy.
- Un error `502` suele indicar un problema entre el proxy y Grafana.
- Si el acceso local funciona pero el remoto falla, hay que revisar la red y el firewall.
- Los logs de `systemd` ayudan a identificar errores de servicio y configuración.
- El puerto de Grafana no debe exponerse públicamente sin medidas de protección.
- Los usuarios deben disponer únicamente de los permisos necesarios.
- La resolución DNS debe funcionar cuando se utiliza un nombre de dominio.
- El acceso debe validarse desde el mismo punto de red utilizado por los usuarios.

## Preguntas de comprobación

1. ¿Cuál es el puerto predeterminado de Grafana?
2. ¿Qué dirección se utiliza para acceder localmente a Grafana?
3. ¿Cómo se accede a Grafana desde otro equipo?
4. ¿Qué comando permite comprobar el estado del servicio?
5. ¿Qué comando permite comprobar si el puerto `3000` está escuchando?
6. ¿Para qué sirve la API `/api/health`?
7. ¿Qué diferencia existe entre `localhost` y la dirección IP del servidor?
8. ¿Qué herramienta permite comprobar la conectividad TCP hacia el puerto `3000`?
9. ¿Qué puede indicar un error de conexión rechazada?
10. ¿Qué puede indicar un tiempo de espera agotado?
11. ¿Qué pasos realizarías si Grafana funciona localmente pero no desde otro equipo?
12. ¿Por qué es importante cambiar la contraseña inicial?
13. ¿Qué ventajas ofrece utilizar HTTPS?
14. ¿Qué función cumple un proxy inverso?
15. ¿Qué suele indicar un error `502 Bad Gateway`?
16. ¿Qué configuración puede ser necesaria cuando Grafana se publica detrás de un dominio?
17. ¿Por qué no se recomienda compartir la cuenta de administrador?
18. ¿Qué reglas de firewall aplicarías para permitir acceso únicamente a una red concreta?
19. ¿Qué información consultarías en los logs si Grafana no inicia?
20. Describe el procedimiento completo para verificar que un usuario remoto puede acceder a Grafana.
```