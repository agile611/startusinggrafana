# Correo electrónico

El correo electrónico es uno de los canales más habituales para recibir notificaciones de Grafana.

Permite informar sobre:

- Alertas activas.
- Alertas resueltas.
- Errores de evaluación.
- Ausencia de datos.
- Cambios de estado.
- Resúmenes operativos.
- Incidencias de servicios o infraestructura.

Para utilizarlo, Grafana necesita conectarse a un servidor **SMTP**. SMTP es el protocolo utilizado para enviar mensajes de correo.

El flujo completo es:

```text
Regla de alerta
      |
      v
Política de notificación
      |
      v
Contacto de correo electrónico
      |
      v
Servidor SMTP
      |
      v
Servidor receptor
      |
      v
Bandeja del destinatario
```

Una alerta puede estar correctamente configurada y, aun así, no llegar al destinatario si existe un problema en SMTP, en la política, en el contacto o en el sistema receptor.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es SMTP.
- Diferenciar Grafana, SMTP y el servidor de correo receptor.
- Identificar los parámetros necesarios para enviar correo.
- Configurar un contacto de tipo correo electrónico.
- Configurar una cuenta técnica para Grafana.
- Comprender el uso de los puertos SMTP habituales.
- Diferenciar SMTP sin cifrado, STARTTLS y TLS implícito.
- Configurar un remitente autorizado.
- Configurar uno o varios destinatarios.
- Probar el envío de un correo desde Grafana.
- Configurar una notificación de activación.
- Configurar una notificación de recuperación.
- Diagnosticar errores de conexión SMTP.
- Diagnosticar errores de autenticación.
- Diagnosticar problemas de entrega.
- Revisar los logs de Grafana.
- Proteger las credenciales SMTP.
- Documentar una configuración de correo.
- Verificar que las alertas llegan al equipo correcto.

---

## Introducción

Grafana no entrega directamente el mensaje al buzón del destinatario. Normalmente actúa como cliente SMTP.

El flujo es:

```text
Grafana
   |
   | Conexión SMTP
   v
Servidor de correo saliente
   |
   | Entrega del mensaje
   v
Servidor receptor
   |
   v
Buzón del destinatario
```

### Ejemplo conceptual

```text
Grafana:
smtp.example.com:587

Remitente:
grafana@example.com

Destinatario:
systems@example.com

Asunto:
[FIRING] HighCPUUsage

Resultado:
El equipo de sistemas recibe la notificación.
```

Si el servidor SMTP rechaza la conexión, Grafana no puede entregar el mensaje.

Si SMTP acepta el mensaje, todavía puede existir un problema posterior en el servidor receptor:

- Dirección inexistente.
- Filtro antispam.
- Política de seguridad.
- Dominio no autorizado.
- Problema de reputación.
- Restricción del proveedor.

Por eso deben probarse tanto el envío desde Grafana como la recepción en el buzón.

---

## Qué es SMTP

SMTP significa **Simple Mail Transfer Protocol**.

Es el protocolo utilizado para enviar mensajes de correo entre clientes y servidores.

En este escenario:

```text
Grafana = cliente SMTP
Servidor de correo = servidor SMTP
```

Grafana se conecta al servidor SMTP y le solicita enviar un mensaje.

### Operaciones habituales

Durante una conexión SMTP pueden realizarse operaciones equivalentes a:

```text
Establecer conexión
Identificarse
Autenticarse
Indicar el remitente
Indicar el destinatario
Enviar el contenido
Cerrar la conexión
```

No es necesario ejecutar manualmente estas operaciones para utilizar Grafana, pero conocerlas ayuda a entender los errores.

---

## Parámetros principales

Una configuración SMTP suele incluir los siguientes parámetros:

| Parámetro | Descripción |
|---|---|
| `enabled` | Activa o desactiva SMTP |
| `host` | Servidor SMTP y puerto |
| `user` | Usuario SMTP |
| `password` | Credencial SMTP |
| `from_address` | Dirección remitente |
| `from_name` | Nombre visible del remitente |
| `startTLS_policy` | Política de cifrado |
| `skip_verify` | Omite la validación del certificado; debe evitarse |
| `ehlo_identity` | Identidad utilizada durante la conexión |

Los nombres exactos pueden variar según la versión y el método de configuración.

### Ejemplo conceptual

```ini
[smtp]
enabled = true
host = smtp.example.com:587
user = grafana@example.com
password = UTILIZAR_UN_SECRETO
from_address = grafana@example.com
from_name = Grafana Monitoring
startTLS_policy = MandatoryStartTLS
```

Este ejemplo no contiene credenciales reales.

---

## Puertos SMTP habituales

### Puerto 25

Tradicionalmente se utiliza para el intercambio de correo entre servidores.

Características:

- Puede no requerir autenticación en redes internas.
- Muchos proveedores bloquean el tráfico saliente por este puerto.
- No suele ser la primera opción para clientes de aplicaciones.
- Puede funcionar en entornos internos controlados.

### Puerto 465

Se utiliza habitualmente para SMTP con TLS implícito.

Características:

- La conexión comienza cifrada.
- La configuración debe coincidir con el servidor.
- No debe confundirse con STARTTLS.

### Puerto 587

Se utiliza habitualmente para el envío autenticado desde aplicaciones y clientes.

Características:

- Suele utilizar STARTTLS.
- Es una opción frecuente para Grafana.
- Normalmente requiere autenticación.
- El proveedor debe indicar la política exacta.

### Resumen

| Puerto | Uso habitual | Cifrado |
|---|---|---|
| `25` | Comunicación entre servidores | Variable |
| `465` | SMTP con TLS implícito | Desde el inicio |
| `587` | Envío autenticado | STARTTLS habitual |

El puerto correcto debe confirmarse con el administrador o proveedor del correo.

---

## Cifrado SMTP

### SMTP sin cifrado

La comunicación no está protegida.

No debe utilizarse para credenciales ni contenido sensible salvo en un entorno controlado y autorizado.

### STARTTLS

La conexión comienza inicialmente sin cifrado y se actualiza a una conexión cifrada mediante TLS.

Flujo:

```text
Conexión SMTP
    |
    v
Solicitud STARTTLS
    |
    v
Negociación TLS
    |
    v
Autenticación y envío cifrados
```

Es habitual en el puerto `587`.

### TLS implícito

La conexión comienza cifrada desde el primer momento.

Es habitual en el puerto `465`.

### Buenas prácticas

- Utilizar cifrado siempre que sea posible.
- Validar los certificados.
- Evitar desactivar la verificación TLS.
- No utilizar `skip_verify` en producción.
- Mantener actualizada la cadena de certificados.
- Documentar la política de cifrado utilizada.

---

## Remitente y destinatario

### Remitente

Es la dirección desde la que parece enviarse el mensaje.

Ejemplo:

```text
grafana@example.com
```

El servidor SMTP puede exigir que el remitente:

- Exista.
- Pertenezca al dominio autorizado.
- Coincida con el usuario autenticado.
- Esté validado por el proveedor.

### Nombre del remitente

Es el texto visible junto a la dirección.

Ejemplo:

```text
Grafana Monitoring <grafana@example.com>
```

### Destinatario

Es la dirección que recibirá el mensaje.

Ejemplo:

```text
systems@example.com
```

También puede utilizarse una lista autorizada:

```text
systems@example.com
on-call@example.com
```

### Recomendación

Utilizar una cuenta técnica específica:

```text
grafana-monitoring@example.com
```

Evitar:

```text
cuenta-personal-del-administrador@example.com
```

Una cuenta personal puede provocar problemas cuando la persona cambia de equipo, abandona la organización o modifica su contraseña.

---

## Cuenta técnica para Grafana

Una cuenta técnica es una identidad utilizada por una aplicación o servicio.

### Características recomendadas

- Nombre descriptivo.
- Propietario definido.
- Permisos mínimos.
- Contraseña o token gestionado de forma segura.
- Fecha de revisión.
- Fecha de rotación.
- Dirección remitente autorizada.
- Uso limitado al envío de alertas.

### Ejemplo

```text
Cuenta:
grafana-monitoring@example.com

Uso:
Envío de alertas desde Grafana

Propietario:
Equipo de operaciones

Permisos:
Envío SMTP

Entorno:
Producción
```

No se debe utilizar la cuenta técnica para recibir correo operativo salvo que exista una razón concreta.

---

## Configuración SMTP en Grafana

La configuración puede realizarse de varias formas:

- Archivo de configuración.
- Variables de entorno.
- Parámetros de un contenedor.
- Secretos gestionados.
- Configuración proporcionada por una plataforma administrada.

El método concreto depende de la instalación.

### Ejemplo mediante archivo de configuración

```ini
[smtp]
enabled = true
host = smtp.example.com:587
user = grafana-monitoring@example.com
password = UTILIZAR_UN_SECRETO
from_address = grafana-monitoring@example.com
from_name = Grafana Monitoring
startTLS_policy = MandatoryStartTLS
```

### Ejemplo mediante variables de entorno

```bash
GF_SMTP_ENABLED=true
GF_SMTP_HOST=smtp.example.com:587
GF_SMTP_USER=grafana-monitoring@example.com
GF_SMTP_PASSWORD=UTILIZAR_UN_SECRETO
GF_SMTP_FROM_ADDRESS=grafana-monitoring@example.com
GF_SMTP_FROM_NAME="Grafana Monitoring"
```

Los nombres de las variables deben comprobarse para la versión instalada.

### Importante

No guardar valores reales en:

```text
Repositorios
Ficheros compartidos
Capturas de pantalla
Documentación pública
Scripts de clase
Mensajes de chat
```

---

## Reinicio y validación

Después de modificar la configuración SMTP, puede ser necesario reiniciar Grafana.

### Instalación mediante servicio

```bash
sudo systemctl restart grafana-server
```

Comprobar el estado:

```bash
sudo systemctl status grafana-server
```

Consultar los logs:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

El nombre del servicio puede variar según la instalación.

### Instalación mediante contenedor

Consultar los contenedores:

```bash
docker ps
```

Revisar los logs:

```bash
docker logs grafana
```

Reiniciar el contenedor solo si corresponde al procedimiento del entorno:

```bash
docker restart grafana
```

No reiniciar servicios de producción sin autorización.

---

## Crear un contacto de correo

El procedimiento general es:

1. Acceder a Grafana.
2. Abrir **Alerting**.
3. Acceder a **Contact points**.
4. Crear un nuevo contacto.
5. Introducir un nombre descriptivo.
6. Seleccionar la integración de correo.
7. Añadir uno o varios destinatarios.
8. Guardar el contacto.
9. Ejecutar la prueba.
10. Confirmar la recepción.
11. Asociar el contacto a una política.
12. Activar una alerta de laboratorio.
13. Comprobar la notificación.
14. Documentar el resultado.

### Ejemplo

```text
Nombre:
laboratory-email

Tipo:
Correo electrónico

Destinatario:
alumno@example.com

Entorno:
laboratory
```

No utilizar destinatarios reales sin autorización.

---

## Asunto de los mensajes

El asunto debe permitir reconocer rápidamente:

- Que el mensaje procede de Grafana.
- El estado de la alerta.
- El nombre de la regla.
- El entorno.
- La severidad.

### Ejemplo

```text
[FIRING] [critical] NodeExporterDown - laboratory
```

Otro ejemplo:

```text
[RESOLVED] [warning] HighCPUUsage - staging
```

Una estructura consistente facilita:

- Filtros de correo.
- Clasificación automática.
- Búsquedas.
- Reglas antispam.
- Integración con sistemas de incidencias.

---

## Contenido de una notificación

Una notificación útil debería incluir:

```text
Nombre de la alerta
Estado
Severidad
Equipo responsable
Servicio
Instancia afectada
Valor observado
Umbral
Hora de inicio
Descripción
Enlace al dashboard
Enlace al runbook
```

### Ejemplo conceptual

```text
Alerta: HighCPUUsage
Estado: FIRING
Severidad: warning
Equipo: systems
Servicio: node_exporter
Instancia: server-01:9100
Valor: 94 %
Umbral: 90 %
Inicio: 2026-09-24 18:10
Descripción: La CPU supera el 90 % durante cinco minutos.
Dashboard: https://grafana.example.com/d/infra
Runbook: https://docs.example.com/runbooks/high-cpu
```

Las variables disponibles dependen de Grafana y de la plantilla utilizada.

---

## Notificaciones de activación y recuperación

### Activación

Se envía cuando la alerta pasa a un estado activo.

```text
Normal → Pending → Alerting
```

Dependiendo de la configuración, la notificación puede generarse al entrar en `Alerting`.

### Recuperación

Se envía cuando la condición deja de cumplirse.

```text
Alerting → Normal
```

### Ejemplo

Mensaje de activación:

```text
[FIRING] HighCPUUsage en server-01
```

Mensaje de recuperación:

```text
[RESOLVED] HighCPUUsage en server-01
```

### Comprobar

```text
¿Se recibe la activación?

¿Se recibe la recuperación?

¿El asunto diferencia ambos estados?

¿Aparece la hora?

¿Aparece la instancia?

¿El contenido es suficiente para actuar?
```

---

## Correo electrónico y políticas de notificación

El contacto de correo no decide qué alertas recibe.

La política de notificación utiliza las etiquetas de la alerta para seleccionar el contacto.

### Regla

```text
Nombre:
HighCPUUsage
```

### Etiquetas

```text
team = systems
severity = warning
environment = laboratory
```

### Política

```text
team = systems
environment = laboratory
```

### Contacto

```text
laboratory-email
```

### Resultado

```text
La alerta coincide con la política
y se envía por correo electrónico.
```

Si las etiquetas no coinciden, el mensaje puede:

- Seguir otra ruta.
- Utilizar una política predeterminada.
- No llegar al destinatario esperado.
- Ser agrupado con otras alertas.

---

## Configurar varios destinatarios

Un contacto puede utilizar varias direcciones, dependiendo de la configuración disponible.

### Ejemplo

```text
systems@example.com
on-call@example.com
operations@example.com
```

### Criterios para elegir destinatarios

- Responsabilidad sobre el servicio.
- Horario de guardia.
- Severidad de la alerta.
- Entorno.
- Nivel de urgencia.
- Requisitos de privacidad.

### Evitar

- Enviar todas las alertas a toda la organización.
- Utilizar listas sin propietario.
- Mantener destinatarios que ya no trabajan en el equipo.
- Enviar alertas críticas a buzones no supervisados.

---

## Entornos separados

Las alertas de laboratorio, pruebas y producción deben diferenciarse.

### Ejemplo

```text
laboratory-email
staging-email
production-email
production-on-call-email
```

### Etiquetas

```text
environment = laboratory
environment = staging
environment = production
```

### Recomendaciones

- Utilizar destinatarios diferentes.
- Añadir el entorno al asunto.
- Añadir el entorno al contenido.
- Crear políticas separadas.
- Probar primero en laboratorio.
- Evitar enviar pruebas a producción.
- Revisar cuidadosamente el destinatario antes de activar una regla.

---

## Ejemplo de configuración conceptual

```text
Contacto:
production-systems-email

Tipo:
Email

Remitente:
grafana-monitoring@example.com

Destinatarios:
systems@example.com
on-call@example.com

Entorno:
production

Política:
team=systems

Severidades:
warning
critical

Notificación de recuperación:
Activada
```

La configuración real puede tener campos adicionales.

---

## Ejemplo de sesión 1: configurar SMTP en laboratorio

### Objetivo

Preparar Grafana para enviar mensajes desde una cuenta de laboratorio.

### Requisitos

- Grafana instalado.
- Cuenta SMTP autorizada.
- Servidor SMTP disponible.
- Puerto conocido.
- Credencial gestionada de forma segura.
- Destinatario de pruebas.

### Datos de ejemplo

```text
Servidor:
smtp.example.com

Puerto:
587

Cifrado:
STARTTLS

Usuario:
grafana-laboratory@example.com

Remitente:
grafana-laboratory@example.com

Destinatario:
alumno@example.com
```

### Pasos

1. Confirmar los datos proporcionados por el administrador.
2. Configurar SMTP mediante el mecanismo aprobado.
3. No escribir la contraseña en este documento.
4. Reiniciar Grafana si es necesario.
5. Consultar los logs.
6. Acceder a Grafana.
7. Crear un contacto de correo.
8. Ejecutar la prueba.
9. Confirmar la recepción.
10. Registrar el resultado sin incluir secretos.

### Registro

```text
Servidor SMTP:

Puerto:

Política de cifrado:

Usuario:

Remitente:

Destinatario:

Fecha de configuración:

Resultado:

Problemas encontrados:

Corrección aplicada:
```

---

## Ejemplo de sesión 2: probar un contacto de correo

### Objetivo

Verificar que el contacto puede entregar un mensaje.

### Pasos

1. Abrir **Alerting**.
2. Acceder a **Contact points**.
3. Seleccionar el contacto de laboratorio.
4. Ejecutar la opción de prueba.
5. Revisar la bandeja de entrada.
6. Revisar la carpeta de spam.
7. Comprobar el asunto.
8. Comprobar el remitente.
9. Comprobar el contenido.
10. Registrar la hora de recepción.

### Lista de comprobación

```text
[ ] La prueba se ejecutó correctamente.
[ ] El servidor SMTP aceptó la conexión.
[ ] El mensaje llegó al destinatario.
[ ] El remitente es correcto.
[ ] El asunto es reconocible.
[ ] El estado de prueba aparece en el contenido.
[ ] No se muestran secretos.
[ ] El mensaje no aparece como spam.
```

---

## Ejemplo de sesión 3: conectar una alerta con el correo

### Objetivo

Comprobar el flujo completo entre una alerta y un buzón.

### Regla

```text
Nombre:
NodeExporterDown

Consulta:
up{job="node_exporter"}

Condición:
Igual a 0

Duración:
1 minuto
```

### Etiquetas

```text
team = systems
severity = critical
environment = laboratory
```

### Contacto

```text
laboratory-systems-email
```

### Política

```text
team = systems
environment = laboratory
```

### Pasos

1. Confirmar que el contacto funciona.
2. Confirmar que la política coincide con las etiquetas.
3. Confirmar que la regla está en `Normal`.
4. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

5. Esperar el cambio a `Pending`.
6. Esperar el cambio a `Alerting`.
7. Comprobar el correo recibido.
8. Iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

9. Esperar la recuperación.
10. Comprobar el mensaje de resolución.
11. Registrar los tiempos.

### Registro

```text
Hora de detención:

Hora de activación:

Hora de recepción:

Hora de recuperación:

Hora de recepción de recuperación:

Resultado:

Observaciones:
```

---

## Ejemplo de sesión 4: probar alertas de CPU

### Objetivo

Enviar por correo una alerta de CPU elevada.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Configuración

```text
Nombre:
HighCPUUsage

Condición:
Mayor que 90

Intervalo:
1 minuto

Duración:
5 minutos
```

### Etiquetas

```text
team = systems
severity = warning
environment = laboratory
resource = cpu
```

### Pasos

1. Validar la consulta en Explore.
2. Comprobar que devuelve un porcentaje.
3. Revisar la política de notificación.
4. Confirmar el contacto.
5. Generar carga controlada:

```bash
stress-ng --cpu 1 --timeout 60s
```

6. Observar el estado.
7. Confirmar si la alerta llega al buzón.
8. Detener la prueba.
9. Comprobar la recuperación.
10. Documentar el resultado.

El comando debe utilizarse solo en un entorno autorizado.

---

## Ejemplo de sesión 5: investigar un correo que no llega

### Objetivo

Diagnosticar una notificación que aparece como activa en Grafana, pero no se recibe.

### Procedimiento

1. Comprobar que la regla está en `Alerting`.
2. Comprobar las etiquetas de la alerta.
3. Revisar la política coincidente.
4. Confirmar el contacto seleccionado.
5. Ejecutar una prueba directa del contacto.
6. Revisar la configuración SMTP.
7. Consultar los logs de Grafana.
8. Revisar la bandeja de spam.
9. Confirmar que el destinatario existe.
10. Revisar las restricciones de red.
11. Repetir la prueba.
12. Documentar la causa.

### Posibles causas

```text
La regla no coincide con la política.
El contacto utiliza una dirección incorrecta.
SMTP está deshabilitado.
El puerto está bloqueado.
La credencial ha caducado.
El remitente no está autorizado.
El certificado no es válido.
El mensaje ha sido filtrado.
La alerta está silenciada.
El mensaje se ha agrupado o retrasado.
```

### Registro

```text
Regla:

Estado:

Etiquetas:

Política:

Contacto:

Prueba directa:

Error en logs:

Resultado en el buzón:

Causa:

Corrección:
```

---

## Ejemplo de sesión 6: diagnosticar un error de autenticación

### Situación

Grafana no puede autenticarse contra el servidor SMTP.

### Síntomas

```text
La prueba falla.
Los logs muestran un error de autenticación.
No se entrega ningún mensaje.
```

### Pasos

1. Confirmar el usuario SMTP.
2. Confirmar que la cuenta está activa.
3. Revisar la credencial mediante el almacén seguro.
4. Confirmar si el proveedor requiere una contraseña específica para aplicaciones.
5. Revisar el puerto.
6. Revisar la política TLS.
7. Confirmar que el remitente está autorizado.
8. Probar nuevamente.
9. Rotar la credencial si ha sido expuesta.
10. Documentar el resultado.

### Registro

```text
Usuario SMTP:

Puerto:

Cifrado:

Mensaje de error:

Causa encontrada:

Corrección:

Prueba posterior:

Resultado:
```

Nunca guardar la contraseña en el registro.

---

## Ejemplo de sesión 7: diagnosticar un error de certificado

### Situación

El servidor SMTP utiliza un certificado que Grafana no puede validar.

### Posibles causas

```text
Certificado caducado.
Nombre del certificado incorrecto.
Autoridad certificadora no instalada.
Reloj del sistema incorrecto.
Cadena de certificados incompleta.
Configuración TLS incompatible.
```

### Procedimiento

1. Revisar la fecha y hora del servidor.
2. Confirmar el nombre del host SMTP.
3. Revisar la cadena de certificados.
4. Confirmar que la autoridad certificadora está disponible.
5. Revisar los logs.
6. Corregir el problema en el servidor o en la configuración autorizada.
7. Repetir la prueba.
8. Evitar desactivar la validación como solución permanente.

### Advertencia

No utilizar una opción equivalente a:

```text
skip_verify = true
```

en producción salvo una excepción documentada, aprobada y temporal.

---

## Ejemplo de sesión 8: probar activación y recuperación

### Objetivo

Comprobar que se reciben los dos eventos.

### Regla

```text
Nombre:
NodeExporterDown
```

### Pasos

1. Confirmar el estado `Normal`.
2. Detener el servicio.
3. Esperar la activación.
4. Comprobar el mensaje `FIRING`.
5. Iniciar el servicio.
6. Esperar la recuperación.
7. Comprobar el mensaje `RESOLVED`.
8. Comparar el contenido de ambos mensajes.
9. Registrar los tiempos.

### Tabla

| Evento | Hora en Grafana | Hora de recepción | Resultado |
|---|---|---|---|
| Activación | | | |
| Recuperación | | | |

---

## Ejemplo de sesión 9: comparar destinatarios por severidad

### Objetivo

Enviar alertas de advertencia y críticas a destinos diferentes.

### Contactos

```text
laboratory-warning-email
laboratory-critical-email
```

### Políticas

```text
severity=warning
    → laboratory-warning-email

severity=critical
    → laboratory-critical-email
```

### Pasos

1. Crear ambos contactos.
2. Probar ambos contactos.
3. Crear las políticas.
4. Crear una regla de prueba con `severity=warning`.
5. Activarla.
6. Confirmar el destinatario.
7. Cambiar la etiqueta a `severity=critical`.
8. Repetir la prueba.
9. Confirmar el segundo destinatario.
10. Documentar las rutas.

### Registro

| Severidad | Contacto esperado | Contacto recibido | Resultado |
|---|---|---|---|
| `warning` | | | |
| `critical` | | | |

---

## Ejemplo de sesión 10: revisar un correo agrupado

### Objetivo

Comprobar cómo se recibe un mensaje cuando varias alertas se activan simultáneamente.

### Escenario

```text
server-01 → CPU elevada
server-02 → CPU elevada
server-03 → CPU elevada
```

### Pasos

1. Crear una regla multidimensional.
2. Configurar el contacto de correo.
3. Activar varias instancias.
4. Observar la lista de alertas.
5. Revisar el buzón.
6. Comprobar si se recibió un mensaje o varios.
7. Verificar que aparecen todas las instancias.
8. Evaluar si el formato es comprensible.
9. Proponer mejoras.

### Preguntas

```text
¿El asunto indica que hay varias alertas?

¿Se identifica cada instancia?

¿Aparecen los valores?

¿Se distingue cada severidad?

¿La agrupación facilita la respuesta?
```

---

## Diagnóstico de conectividad SMTP

Antes de revisar Grafana, puede ser útil comprobar si el servidor es accesible desde el equipo donde se ejecuta Grafana.

### Comprobar resolución DNS

```bash
getent hosts smtp.example.com
```

Si no devuelve una dirección, revisar:

- DNS.
- Nombre del host.
- Configuración de red.
- Dominio utilizado.

### Comprobar conectividad TCP

```bash
nc -vz smtp.example.com 587
```

Resultado esperado:

```text
Connection to smtp.example.com 587 port [tcp/submission] succeeded
```

Un resultado negativo puede indicar:

- Firewall.
- Ruta inexistente.
- Puerto incorrecto.
- Servidor inaccesible.
- Restricción del proveedor.

### Probar STARTTLS

En un entorno autorizado, puede utilizarse:

```bash
openssl s_client -starttls smtp -connect smtp.example.com:587
```

Esta prueba permite observar la negociación TLS y el certificado.

No utilizar credenciales reales en comandos compartidos o registrados en el historial.

---

## Revisar los logs de Grafana

Los logs pueden indicar:

- Error de conexión.
- Error de autenticación.
- Error TLS.
- Rechazo del remitente.
- Error del destinatario.
- Fallo interno de la integración.

### Servicio del sistema

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

### Contenedor

```bash
docker logs grafana --tail 100
```

### Buscar mensajes relacionados

```bash
sudo journalctl -u grafana-server --no-pager | grep -i smtp
```

También pueden utilizarse términos como:

```bash
grep -i mail
grep -i notification
grep -i alert
grep -i tls
```

Los comandos dependen del sistema operativo y del método de instalación.

---

## Errores frecuentes

### SMTP está deshabilitado

Síntoma:

```text
La prueba de correo no está disponible o falla inmediatamente.
```

Revisar:

```text
enabled
```

### Servidor incorrecto

Síntoma:

```text
No se puede resolver o conectar con el servidor.
```

Revisar:

- Host.
- Dominio.
- DNS.
- Entorno.

### Puerto incorrecto

Síntoma:

```text
La conexión se rechaza o expira.
```

Revisar:

- Puerto configurado.
- Puerto permitido por el firewall.
- Cifrado esperado.
- Documentación del proveedor.

### Credenciales incorrectas

Síntoma:

```text
El servidor rechaza la autenticación.
```

Revisar:

- Usuario.
- Credencial.
- Cuenta bloqueada.
- Contraseña de aplicación.
- Método de autenticación.

### Remitente no autorizado

Síntoma:

```text
El servidor acepta la conexión, pero rechaza el remitente.
```

Revisar:

- Dirección `from_address`.
- Dominio autorizado.
- Coincidencia con el usuario SMTP.
- Políticas SPF, DKIM o DMARC, si aplican.

### Certificado no válido

Síntoma:

```text
Error durante la negociación TLS.
```

Revisar:

- Fecha de expiración.
- Nombre del certificado.
- Autoridad certificadora.
- Cadena de certificados.
- Reloj del sistema.

### El correo llega como spam

Revisar:

- Remitente.
- Dominio.
- Reputación.
- SPF.
- DKIM.
- DMARC.
- Contenido del mensaje.
- Configuración del servidor receptor.

### La alerta está activa, pero no llega el mensaje

Revisar:

- Política.
- Etiquetas.
- Contacto.
- Silencio.
- Agrupación.
- Intervalo de repetición.
- Logs.
- Estado del buzón.

### El correo llega sin información

Revisar:

- Plantilla.
- Anotaciones.
- Etiquetas.
- Variables.
- Contenido del contacto.
- Enlaces al dashboard y runbook.

---

## Seguridad

### No almacenar contraseñas en texto plano

Incorrecto:

```ini
password = MiContraseñaReal
```

en un repositorio o documento compartido.

### Utilizar secretos gestionados

La credencial debe almacenarse en:

- Gestor de secretos.
- Variables protegidas.
- Secretos de contenedor.
- Bóveda corporativa.
- Mecanismo seguro de la plataforma.

### Principio de mínimo privilegio

La cuenta SMTP debería tener únicamente los permisos necesarios para enviar mensajes.

### Rotación

Establecer un procedimiento para:

- Rotar contraseñas.
- Rotar tokens.
- Revocar credenciales.
- Actualizar Grafana.
- Ejecutar una prueba posterior.

### Protección de los destinatarios

No enviar información sensible a listas amplias.

Revisar:

- Datos personales.
- Direcciones internas.
- Información de infraestructura.
- Nombres de servidores.
- Detalles de seguridad.
- Contenido de logs.

### Separación por entorno

Utilizar cuentas y contactos independientes:

```text
grafana-laboratory@example.com
grafana-staging@example.com
grafana-production@example.com
```

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/correo-electronico
```

Crear una plantilla de configuración sin secretos:

```bash
cat > ~/laboratorio-grafana/evidencias/correo-electronico/configuracion.txt <<'EOF'
Entorno:

Servidor SMTP:

Puerto:

Política de cifrado:

Usuario SMTP:

Dirección remitente:

Nombre del remitente:

Destinatario de pruebas:

Contacto de Grafana:

Política de notificación:

Fecha de configuración:

Resultado de la prueba:

Observaciones:
EOF
```

Crear una plantilla de diagnóstico:

```bash
cat > ~/laboratorio-grafana/evidencias/correo-electronico/diagnostico.txt <<'EOF'
Fecha:

Regla:

Estado de la regla:

Etiquetas:

Política utilizada:

Contacto seleccionado:

Prueba directa del contacto:

Resultado SMTP:

Mensaje de error:

Logs consultados:

Causa:

Corrección:

Resultado posterior:
EOF
```

Crear una plantilla de activación y recuperación:

```bash
cat > ~/laboratorio-grafana/evidencias/correo-electronico/activacion-recuperacion.txt <<'EOF'
Regla:

Instancia:

Hora de activación en Grafana:

Hora de recepción de activación:

Hora de recuperación en Grafana:

Hora de recepción de recuperación:

Asunto de activación:

Asunto de recuperación:

Resultado:

Observaciones:
EOF
```

Capturas recomendadas:

```text
01-configuracion-smtp-sin-secretos.png
02-contacto-email.png
03-prueba-contacto.png
04-politica-email.png
05-alerta-firing.png
06-correo-de-activacion.png
07-alerta-resolved.png
08-correo-de-recuperacion.png
09-logs-smtp-sin-secretos.png
10-registro-final.png
```

Antes de guardar una captura, ocultar:

```text
Contraseñas
Tokens
Direcciones privadas
Cabeceras de autenticación
URLs con credenciales
Información personal no necesaria
```

---

## Práctica integradora

### Objetivo

Configurar y probar una notificación de correo desde la activación de una alerta hasta su recuperación.

### Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Node Exporter disponible.
- Cuenta SMTP de laboratorio.
- Destinatario autorizado.
- Permisos para crear contactos y políticas.
- Entorno controlado.

---

### Tarea 1: revisar SMTP

Registrar:

```text
Servidor SMTP:

Puerto:

Cifrado:

Usuario:

Remitente:

Método de configuración:

Estado de conectividad:
```

No registrar la contraseña.

---

### Tarea 2: crear el contacto

Crear:

```text
Nombre:
laboratory-systems-email

Tipo:
Correo electrónico

Destinatario:
dirección autorizada de laboratorio
```

Ejecutar una prueba directa.

---

### Tarea 3: crear la política

Utilizar las etiquetas:

```text
team = systems
environment = laboratory
```

Asignar el contacto:

```text
laboratory-systems-email
```

---

### Tarea 4: preparar la regla

Utilizar la regla de disponibilidad:

```promql
up{job="node_exporter"}
```

Configuración:

```text
Nombre:
NodeExporterDown

Condición:
Igual a 0

Intervalo:
30 segundos

Duración:
1 minuto
```

Etiquetas:

```text
team = systems
severity = critical
environment = laboratory
resource = availability
```

Anotaciones:

```text
summary = Node Exporter no disponible en {{ $labels.instance }}

description = El objetivo {{ $labels.instance }}
no responde a Prometheus.
```

---

### Tarea 5: probar la activación

1. Confirmar que la alerta está en `Normal`.
2. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

3. Esperar el estado `Pending`.
4. Esperar el estado `Alerting`.
5. Revisar el correo.
6. Registrar la hora de recepción.

---

### Tarea 6: probar la recuperación

1. Iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

2. Esperar la recuperación.
3. Revisar si se recibe el mensaje de resolución.
4. Comparar ambos mensajes.
5. Registrar el resultado.

---

### Tarea 7: elaborar el informe

```text
Contacto utilizado:

Servidor SMTP:

Regla:

Política:

Etiquetas:

Hora de activación:

Hora de recepción:

Hora de recuperación:

Recepción de resolución:

Problemas encontrados:

Correcciones:

Conclusión:
```

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Servidor SMTP identificado | | |
| Puerto confirmado | | |
| Cifrado confirmado | | |
| Conectividad comprobada | | |
| Contacto creado | | |
| Prueba directa ejecutada | | |
| Correo de prueba recibido | | |
| Política creada | | |
| Etiquetas revisadas | | |
| Regla activada | | |
| Estado `Pending` observado | | |
| Estado `Alerting` observado | | |
| Correo de activación recibido | | |
| Servicio recuperado | | |
| Correo de recuperación recibido | | |
| Asuntos correctos | | |
| Instancia identificada | | |
| Runbook incluido | | |
| Evidencias guardadas | | |
| Documentación completada | | |

---

## Puntos clave

- Grafana utiliza SMTP para enviar correos electrónicos.
- Grafana actúa normalmente como cliente SMTP.
- El servidor SMTP realiza el envío hacia el destinatario.
- Los puertos `25`, `465` y `587` tienen usos diferentes.
- El puerto `587` suele utilizar STARTTLS.
- El puerto `465` suele utilizar TLS implícito.
- El cifrado debe coincidir con la configuración del servidor.
- El remitente debe estar autorizado.
- Es preferible utilizar una cuenta técnica.
- Las credenciales deben protegerse mediante un sistema seguro.
- El contacto de correo define el destino.
- La política de notificación decide qué alertas llegan a ese contacto.
- Las etiquetas conectan las reglas con las políticas.
- Una alerta activa no garantiza que el correo se haya entregado.
- Las pruebas deben incluir activación y recuperación.
- Los logs son fundamentales para diagnosticar errores.
- Un error `401` suele indicar un problema de autenticación.
- Un error `404` suele indicar una URL o ruta incorrecta.
- Un error `429` suele indicar limitación de peticiones.
- Los certificados TLS deben validarse correctamente.
- No se debe desactivar la validación TLS como solución habitual.
- Los entornos de laboratorio y producción deben utilizar contactos separados.
- El contenido del mensaje debe incluir contexto suficiente.
- Los destinatarios deben tener responsabilidad sobre las alertas recibidas.
- Toda configuración de correo debe documentarse sin exponer secretos.

---

## Preguntas de comprobación

1. ¿Qué es SMTP?
2. ¿Qué papel desempeña Grafana en el envío de correo?
3. ¿Qué función tiene el servidor SMTP?
4. ¿Qué diferencia existe entre los puertos `25`, `465` y `587`?
5. ¿Qué es STARTTLS?
6. ¿Qué diferencia existe entre STARTTLS y TLS implícito?
7. ¿Qué parámetros necesita normalmente una configuración SMTP?
8. ¿Por qué se recomienda utilizar una cuenta técnica?
9. ¿Qué información no debe guardarse en un repositorio?
10. ¿Qué diferencia existe entre un contacto y una política de notificación?
11. ¿Qué revisarías si el servidor SMTP rechaza la autenticación?
12. ¿Qué revisarías ante un error TLS?
13. ¿Qué significa que el mensaje llegue a la carpeta de spam?
14. ¿Qué revisarías si la alerta está activa, pero no llega el correo?
15. ¿Cómo probarías un contacto de correo?
16. ¿Cómo comprobarías la notificación de recuperación?
17. ¿Por qué deben separarse los contactos de laboratorio y producción?
18. ¿Qué información debería incluir un correo de alerta?
19. ¿Qué significa una respuesta HTTP `401`?  
20. ¿Qué significa una respuesta HTTP `404`?
21. ¿Qué significa una respuesta HTTP `429`?
22. ¿Qué utilidad tienen los logs de Grafana?
23. ¿Por qué es importante que el remitente esté autorizado?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener una configuración de correo segura y mantenible?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de configurar y probar el envío de alertas mediante correo electrónico.

El flujo final será:

```text
Confirmar SMTP
      |
      v
Configurar la cuenta técnica
      |
      v
Crear el contacto de correo
      |
      v
Probar el contacto
      |
      v
Crear la política
      |
      v
Comprobar las etiquetas
      |
      v
Activar una alerta
      |
      v
Recibir el correo de activación
      |
      v
Resolver la condición
      |
      v
Recibir el correo de recuperación
      |
      v
Revisar logs y evidencias
      |
      v
Documentar el resultado
```

La configuración está correctamente realizada cuando:

- SMTP está habilitado.
- El servidor y el puerto son correctos.
- La conexión utiliza el cifrado esperado.
- La cuenta técnica está autorizada.
- El contacto de correo supera la prueba.
- La política coincide con las etiquetas.
- La alerta activa genera un mensaje.
- El destinatario recibe el correo.
- El mensaje incluye información suficiente.
- La recuperación también se comporta correctamente.
- Los errores pueden diagnosticarse mediante logs.
- Las credenciales permanecen protegidas.
- La configuración está documentada.

El correo electrónico es un canal sencillo de entender, pero depende de varias piezas: red, DNS, cifrado, autenticación, políticas, filtros y destinatarios. Probar cada pieza por separado convierte un problema difuso en un diagnóstico manejable.