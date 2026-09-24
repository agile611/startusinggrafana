# Contactos de notificación

Los **contactos de notificación** definen los destinos a los que Grafana envía los avisos generados por las reglas de alerta.

En Grafana, estos destinos suelen denominarse **contact points**. Un contacto puede enviar mensajes mediante distintos canales:

- Correo electrónico.
- Webhook.
- Microsoft Teams.
- Slack.
- Telegram.
- PagerDuty.
- Opsgenie.
- Sistemas de incidencias.
- Integraciones externas compatibles.

La terminología y las opciones disponibles pueden variar según la versión de Grafana y las integraciones instaladas.

Un contacto no decide por sí mismo cuándo se envía una alerta. Su función principal es definir **dónde se entrega**. El momento y las condiciones de envío se controlan mediante las políticas de notificación.

El flujo completo es:

```text
Regla de alerta
      |
      v
Etiquetas
      |
      v
Política de notificación
      |
      v
Contacto de notificación
      |
      v
Canal de entrega
      |
      v
Destinatario
```

Ejemplo:

```text
Regla:
HighCPUUsage

Etiquetas:
team=systems
severity=warning

Política:
team=systems

Contacto:
correo del equipo de sistemas

Resultado:
La alerta se envía al equipo de sistemas
```

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es un contacto de notificación.
- Diferenciar un contacto de una regla de alerta.
- Diferenciar un contacto de una política de notificación.
- Identificar los principales tipos de contacto.
- Crear un contacto de correo electrónico.
- Crear un contacto de tipo webhook.
- Configurar los datos básicos de un contacto.
- Ejecutar una prueba de entrega.
- Interpretar el resultado de una prueba.
- Relacionar un contacto con una política de notificación.
- Comprobar que las etiquetas de una alerta coinciden con una política.
- Diagnosticar notificaciones que no llegan.
- Reconocer problemas de SMTP.
- Reconocer errores de webhook.
- Gestionar contactos de forma segura.
- Evitar almacenar credenciales en repositorios o dashboards.
- Documentar los contactos existentes.
- Retirar contactos obsoletos o no autorizados.

---

## Introducción

Una alerta puede cambiar al estado `Alerting`, pero eso no garantiza que alguien reciba un mensaje.

Para entregar una notificación se necesitan varios componentes:

```text
Regla
  +
Etiquetas
  +
Política
  +
Contacto
  +
Canal funcional
```

### Ejemplo

```text
Regla:
NodeExporterDown

Estado:
Alerting

Etiquetas:
team=systems
severity=critical

Política:
team=systems y severity=critical

Contacto:
guardia-sistemas

Canal:
correo electrónico

Resultado:
Mensaje enviado al equipo de guardia
```

Si alguno de estos elementos está mal configurado, la notificación puede no llegar.

### Posibles problemas

```text
La regla no se activa.
La política no coincide con las etiquetas.
El contacto está mal configurado.
El servidor SMTP rechaza el mensaje.
El webhook devuelve un error.
La alerta está silenciada.
La notificación está agrupada.
La integración no tiene permisos.
```

Por este motivo, la configuración de contactos debe probarse de forma independiente antes de utilizarla en un entorno real.

---

## Qué es un contacto de notificación

Un contacto de notificación es una configuración reutilizable que define un destino y un canal de entrega.

También puede denominarse:

```text
Contact point
Receptor
Destino de notificación
Canal de notificación
```

### Ejemplos

```text
Equipo de sistemas por correo
Canal de operaciones mediante webhook
Sistema de incidencias
Equipo de guardia
Canal de desarrollo
```

### Información habitual

Un contacto puede incluir:

- Nombre.
- Tipo de integración.
- Dirección o URL de destino.
- Parámetros del canal.
- Método de autenticación.
- Opciones de entrega.
- Plantilla del mensaje.
- Configuración de recuperación.
- Identificador de la integración.

La disponibilidad de estos campos depende del tipo de contacto.

---

## Diferencia entre regla, política y contacto

| Elemento | Función | Ejemplo |
|---|---|---|
| Regla | Detectar una condición | CPU mayor que 90 % |
| Etiquetas | Clasificar la alerta | `team=systems` |
| Política | Decidir cuándo y a quién enviar | Alertas de sistemas |
| Contacto | Definir el destino | `systems@example.com` |
| Notificación | Mensaje enviado | Correo sobre CPU elevada |

### Ejemplo completo

```text
La regla HighCPUUsage detecta CPU elevada.

La regla añade:
team=systems
severity=warning

La política busca:
team=systems

La política utiliza:
contacto-sistemas

El contacto entrega:
correo a systems@example.com
```

La regla detecta.

La política enruta.

El contacto entrega.

---

## Tipos de contactos

### Correo electrónico

Envía mensajes a una o varias direcciones.

Ejemplo:

```text
systems@example.com
on-call@example.com
```

Es útil para:

- Equipos pequeños.
- Entornos de laboratorio.
- Resúmenes.
- Alertas no urgentes.
- Comunicaciones operativas.

### Webhook

Envía una petición HTTP a un endpoint.

Ejemplo conceptual:

```text
https://automation.example.com/hooks/grafana
```

Es útil para:

- Automatizaciones.
- Sistemas de incidencias.
- Aplicaciones internas.
- Integraciones personalizadas.
- Procesamiento automático de alertas.

### Slack o Microsoft Teams

Envía mensajes a un canal colaborativo.

Es útil para:

- Equipos de operaciones.
- Incidencias compartidas.
- Alertas de laboratorio.
- Comunicación rápida.

### PagerDuty u otras plataformas de guardia

Integra las alertas con sistemas de guardia y escalado.

Es útil para:

- Alertas críticas.
- Servicios con disponibilidad continua.
- Rotaciones de guardia.
- Escalado automático.

### Telegram u otros canales

Puede utilizarse para laboratorios o equipos que hayan aprobado ese canal.

Debe revisarse siempre:

- La privacidad.
- La protección de los datos.
- La disponibilidad del servicio.
- Las políticas de la organización.

---

## Crear un contacto

El nombre exacto de las opciones puede cambiar según la versión de Grafana.

El procedimiento general es:

1. Acceder a Grafana.
2. Abrir **Alerting**.
3. Acceder a **Contact points** o **Contactos de notificación**.
4. Crear un nuevo contacto.
5. Introducir un nombre descriptivo.
6. Seleccionar el tipo de integración.
7. Completar los datos del destino.
8. Configurar la autenticación si es necesaria.
9. Guardar el contacto.
10. Ejecutar una prueba de entrega.
11. Confirmar la recepción.
12. Documentar el resultado.

### Nombre recomendado

Ejemplos:

```text
systems-email-laboratory
on-call-webhook
application-team-email
critical-alerts-pager
```

Evitar:

```text
Contacto1
Prueba
Nuevo
Correo
```

Un nombre claro facilita la administración y el diagnóstico.

---

## Contacto de correo electrónico

### Requisitos

Para enviar correo se necesita normalmente:

- Servidor SMTP.
- Puerto SMTP.
- Cifrado, cuando corresponda.
- Usuario SMTP, si es necesario.
- Contraseña o credencial.
- Dirección remitente.
- Dirección destinataria.
- Permisos de salida de red.
- Certificados válidos, cuando se utilice TLS.

### Datos conceptuales

```text
Servidor SMTP:
smtp.example.com

Puerto:
587

Cifrado:
STARTTLS

Remitente:
grafana@example.com

Destinatario:
systems@example.com
```

Los valores reales dependen del proveedor de correo y de la infraestructura.

### Recomendación

Utilizar una cuenta técnica específica para Grafana.

Evitar utilizar:

- La cuenta personal de un administrador.
- Una cuenta compartida sin control.
- Credenciales incluidas en scripts públicos.
- Contraseñas almacenadas en el repositorio.
- Cuentas con permisos excesivos.

---

## Configuración SMTP

Grafana necesita una configuración SMTP válida para enviar correos.

La configuración puede realizarse mediante:

- Archivo de configuración.
- Variables de entorno.
- Secretos del sistema.
- Configuración gestionada por el proveedor.
- Parámetros del contenedor.

El método depende de cómo se haya instalado Grafana.

### Ejemplo conceptual de configuración

```ini
[smtp]
enabled = true
host = smtp.example.com:587
user = grafana@example.com
password = CAMBIAR_POR_UN_SECRETO
from_address = grafana@example.com
from_name = Grafana
startTLS_policy = MandatoryStartTLS
```

Este ejemplo es ilustrativo. Los nombres exactos y las opciones disponibles dependen de la versión.

**No se deben guardar contraseñas reales en documentación, capturas ni repositorios.**

### Después de modificar SMTP

Normalmente es necesario:

1. Guardar la configuración.
2. Reiniciar Grafana si corresponde.
3. Comprobar los logs.
4. Crear o revisar el contacto.
5. Ejecutar una prueba.
6. Confirmar la recepción.

---

## Prueba de un contacto de correo

### Objetivo

Comprobar que Grafana puede enviar un mensaje al destinatario configurado.

### Pasos

1. Crear un contacto de tipo correo.
2. Introducir una dirección de laboratorio.
3. Guardar el contacto.
4. Ejecutar la opción de prueba.
5. Revisar la bandeja de entrada.
6. Revisar la carpeta de correo no deseado.
7. Comprobar el remitente.
8. Revisar los logs si el correo no llega.
9. Registrar el resultado.

### Registro

```text
Nombre del contacto:

Remitente:

Destinatario:

Servidor SMTP:

Puerto:

Fecha de la prueba:

Hora de envío:

Hora de recepción:

Resultado:

Problemas encontrados:
```

No registrar la contraseña SMTP.

---

## Contactos con varias direcciones

Un contacto de correo puede utilizar varias direcciones, según la configuración disponible.

Ejemplo:

```text
systems@example.com
on-call@example.com
operations@example.com
```

### Ventajas

- Permite avisar a un equipo.
- Reduce la dependencia de una persona.
- Facilita la continuidad operativa.
- Permite incluir una dirección de guardia.

### Precauciones

- Evitar listas demasiado amplias.
- Revisar quién debe recibir cada severidad.
- No enviar alertas críticas a destinatarios que no tienen responsabilidad operativa.
- Cumplir las políticas de privacidad.
- Retirar direcciones obsoletas.

---

## Contactos mediante webhook

Un webhook envía una petición HTTP a una URL.

### Flujo conceptual

```text
Grafana
   |
   | HTTP
   v
Endpoint receptor
   |
   v
Procesamiento de la alerta
```

El receptor puede:

- Crear una incidencia.
- Publicar un mensaje.
- Ejecutar una automatización.
- Guardar el evento.
- Escalar la alerta.

### Información habitual

```text
URL:
https://automation.example.com/hooks/grafana

Método:
POST

Formato:
JSON

Autenticación:
Token o cabecera autorizada
```

La configuración exacta depende del endpoint receptor.

### Ejemplo conceptual de payload

```json
{
  "status": "firing",
  "alertname": "HighCPUUsage",
  "severity": "warning",
  "team": "systems",
  "instance": "server-01:9100"
}
```

El formato real puede incluir más campos y variar según Grafana y la integración utilizada.

---

## Seguridad de los webhooks

Un webhook debe protegerse adecuadamente.

### Riesgos

- URL expuesta.
- Token incluido en una captura.
- Endpoint sin autenticación.
- Comunicación sin cifrado.
- Reenvío de información sensible.
- Permisos excesivos.
- Repetición de peticiones.
- Falta de validación del origen.

### Recomendaciones

- Utilizar HTTPS.
- Validar la autenticación.
- Proteger los tokens.
- Utilizar un endpoint dedicado.
- Limitar el acceso de red.
- Validar el contenido recibido.
- Registrar errores sin guardar secretos.
- Rotar las credenciales.
- No utilizar endpoints personales para alertas de producción.

### Ejemplo incorrecto

```text
https://example.com/hooks/grafana?token=secreto-real
```

### Ejemplo preferible

```text
https://example.com/hooks/grafana
```

La credencial debe configurarse mediante el mecanismo seguro disponible, no escribirse en una URL compartida.

---

## Respuestas HTTP de un webhook

Un endpoint puede devolver diferentes códigos.

| Código | Significado habitual |
|---|---|
| `2xx` | Petición aceptada |
| `400` | Petición incorrecta |
| `401` | Falta autenticación |
| `403` | Acceso prohibido |
| `404` | Endpoint inexistente |
| `429` | Demasiadas peticiones |
| `5xx` | Error del servidor |

### Diagnóstico

Si el webhook devuelve:

```text
401
```

Revisar:

- Token.
- Cabecera de autenticación.
- Credenciales.
- Fecha de expiración.

Si devuelve:

```text
404
```

Revisar:

- URL.
- Ruta.
- Entorno.
- Servicio receptor.

Si devuelve:

```text
500
```

Revisar:

- Logs del receptor.
- Formato del payload.
- Dependencias.
- Estado del servicio externo.

---

## Contactos para diferentes severidades

Una organización puede utilizar contactos distintos según la severidad.

### Ejemplo

```text
severity=info
    → correo de información

severity=warning
    → equipo de sistemas

severity=critical
    → equipo de guardia
```

### Etiquetas de las reglas

```text
severity = warning
team = systems
```

o:

```text
severity = critical
team = on-call
```

### Importante

El contacto no realiza por sí solo el enrutamiento. La política debe reconocer las etiquetas y seleccionar el contacto correspondiente.

---

## Contactos y políticas

### Ejemplo completo

#### Regla

```text
Nombre:
NodeExporterDown
```

#### Etiquetas

```text
severity = critical
team = systems
service = node_exporter
```

#### Política

```text
Coincidencia:
team=systems
severity=critical
```

#### Contacto

```text
Nombre:
on-call-systems-email
Tipo:
correo electrónico
Destino:
on-call@example.com
```

#### Resultado

```text
La alerta crítica de Node Exporter
se envía al equipo de guardia de sistemas.
```

### Si no hay coincidencia

La alerta puede:

- Utilizar la política predeterminada.
- Llegar a otro contacto.
- No entregarse como se esperaba.
- Quedar pendiente de una configuración adicional.

Siempre se debe probar la correspondencia entre:

```text
Etiquetas → Política → Contacto
```

---

## Contactos y recuperación de alertas

Algunas configuraciones pueden enviar notificaciones cuando una alerta se resuelve.

### Ejemplo

```text
Alerta:
HighCPUUsage

Notificación de activación:
CPU superior al 90 %

Notificación de recuperación:
CPU vuelve a valores normales
```

Las notificaciones de recuperación ayudan a saber que la condición dejó de cumplirse.

### Debe documentarse

```text
¿Se notifican las activaciones?

¿Se notifican las recuperaciones?

¿El destinatario recibe ambos mensajes?

¿Las recuperaciones se agrupan?

¿Se repiten las alertas activas?
```

El comportamiento depende de las políticas y de la configuración de la integración.

---

## Contactos y agrupación

Cuando varias alertas se activan al mismo tiempo, Grafana puede agruparlas según la política.

### Ejemplo

Tres instancias presentan CPU elevada:

```text
server-01
server-02
server-03
```

La agrupación puede producir un mensaje conjunto:

```text
HighCPUUsage:
- server-01
- server-02
- server-03
```

### Ventajas

- Reduce el número de mensajes.
- Facilita la identificación de un incidente común.
- Evita saturar al destinatario.

### Riesgos

- Puede ocultar el detalle de una instancia.
- Puede retrasar la entrega según la configuración.
- Puede dificultar la lectura si el grupo es demasiado grande.

La agrupación debe probarse con alertas de laboratorio.

---

## Plantillas de mensajes

Los contactos pueden utilizar plantillas para personalizar los mensajes.

### Contenido recomendado

Una notificación debería incluir:

```text
Nombre de la alerta
Estado
Severidad
Instancia afectada
Servicio
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
Estado: firing
Severidad: warning
Instancia: server-01:9100
Servicio: node_exporter
Valor: 94 %
Umbral: 90 %
Equipo: systems
Descripción: La CPU supera el 90 % durante cinco minutos.
Runbook: https://example.com/runbooks/high-cpu
```

Las variables disponibles dependen de Grafana y de la integración.

Antes de utilizar una plantilla en producción, probarla con una alerta real de laboratorio.

---

## Contactos de laboratorio y producción

No se deben mezclar sin control los destinos de laboratorio y producción.

### Ejemplo de nombres

```text
laboratory-systems-email
staging-systems-email
production-systems-email
production-on-call-webhook
```

### Etiquetas de entorno

```text
environment = laboratory
environment = staging
environment = production
```

### Recomendaciones

- Utilizar destinatarios diferentes.
- Separar las políticas.
- Identificar claramente cada contacto.
- Evitar enviar pruebas a equipos de producción.
- Revisar los permisos de creación y modificación.
- Documentar el entorno de cada contacto.

---

## Crear un contacto de correo de laboratorio

### Objetivo

Configurar un contacto de correo para realizar pruebas sin afectar a destinatarios reales.

### Datos de ejemplo

```text
Nombre:
laboratory-systems-email

Tipo:
Correo electrónico

Destinatario:
alumno@example.com
```

### Pasos

1. Acceder a **Alerting**.
2. Abrir **Contact points**.
3. Crear un contacto.
4. Introducir el nombre.
5. Seleccionar correo electrónico.
6. Utilizar una dirección autorizada.
7. Guardar.
8. Ejecutar la prueba.
9. Revisar la recepción.
10. Documentar el resultado.

### Actividad

Completar:

```text
¿Se recibió el correo?

¿La dirección remitente era correcta?

¿El asunto identificaba el entorno?

¿El contenido incluía la alerta?

¿Se recibió la recuperación?

¿Qué problema apareció?
```

---

## Ejemplo de sesión 1: probar un contacto de correo

### Objetivo

Comprobar que Grafana puede enviar un mensaje mediante SMTP.

### Pasos

1. Revisar que SMTP está habilitado.
2. Crear el contacto:

```text
laboratory-email
```

3. Añadir un destinatario autorizado.
4. Guardar.
5. Ejecutar una prueba.
6. Revisar la bandeja de entrada.
7. Revisar el correo no deseado.
8. Revisar los logs de Grafana si no llega.
9. Registrar el resultado.
10. Eliminar o deshabilitar el contacto cuando termine el laboratorio.

### Registro

```text
Contacto:

Servidor SMTP:

Destinatario:

Hora de prueba:

Código o resultado:

Mensaje recibido:

Tiempo de entrega:

Problemas:

Corrección:
```

No incluir contraseñas en este registro.

---

## Ejemplo de sesión 2: probar un webhook

### Objetivo

Comprobar que Grafana puede enviar una alerta a un endpoint autorizado.

### Requisitos

- Endpoint de laboratorio.
- URL HTTPS.
- Método de autenticación definido.
- Permisos para probar la integración.

### Pasos

1. Crear un contacto de tipo webhook.
2. Introducir la URL del endpoint.
3. Configurar la autenticación.
4. Guardar.
5. Ejecutar la prueba.
6. Revisar la respuesta HTTP.
7. Consultar los logs del receptor.
8. Verificar el payload.
9. Activar una alerta de laboratorio.
10. Comprobar la recepción.

### Registro

```text
Nombre del contacto:

URL del endpoint:

Método:

Código HTTP:

Hora de la prueba:

Payload recibido:

Resultado:

Problemas:

Corrección:
```

Eliminar tokens y credenciales antes de guardar evidencias.

---

## Ejemplo de sesión 3: conectar una regla con un contacto

### Objetivo

Comprobar el flujo completo desde una regla hasta un destinatario.

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

### Contacto

```text
Nombre:
laboratory-systems-email
```

### Política

```text
Coincidencia:
team=systems
environment=laboratory
```

### Pasos

1. Crear o revisar el contacto.
2. Crear la política.
3. Comprobar las etiquetas de la regla.
4. Activar una alerta de CPU en laboratorio.
5. Esperar la evaluación.
6. Observar el estado `Pending`.
7. Observar el estado `Alerting`.
8. Revisar el correo.
9. Comprobar la recuperación.
10. Revisar si se recibió el mensaje de resolución.

### Flujo esperado

```text
CPU elevada
    |
    v
HighCPUUsage activa
    |
    v
team=systems
environment=laboratory
    |
    v
Coincidencia con la política
    |
    v
laboratory-systems-email
    |
    v
Correo recibido
```

---

## Ejemplo de sesión 4: diagnosticar un correo que no llega

### Objetivo

Investigar un fallo de entrega.

### Procedimiento

1. Comprobar que la regla está en `Alerting`.
2. Comprobar que la política coincide.
3. Comprobar el contacto asignado.
4. Revisar el destinatario.
5. Revisar la configuración SMTP.
6. Revisar el puerto.
7. Revisar el cifrado.
8. Revisar las credenciales mediante el mecanismo seguro.
9. Consultar los logs.
10. Ejecutar una prueba independiente.
11. Revisar la bandeja de correo no deseado.
12. Confirmar las restricciones de red.

### Posibles errores

```text
Servidor SMTP incorrecto.
Puerto bloqueado.
Credencial caducada.
Destinatario mal escrito.
Remitente no autorizado.
Certificado no válido.
Política sin coincidencia.
Alerta silenciada.
Mensaje agrupado o retrasado.
```

### Registro

```text
Estado de la alerta:

Política utilizada:

Contacto seleccionado:

Servidor SMTP:

Error observado:

Causa:

Corrección:

Resultado de la nueva prueba:
```

---

## Ejemplo de sesión 5: diagnosticar un webhook con error 401

### Objetivo

Resolver un error de autenticación.

### Situación

```text
La prueba del webhook devuelve HTTP 401.
```

### Interpretación

El endpoint rechaza la petición porque la autenticación falta o no es válida.

### Pasos

1. Revisar el método de autenticación.
2. Comprobar el nombre de la cabecera.
3. Comprobar la credencial mediante el almacén seguro.
4. Verificar que no ha caducado.
5. Revisar los permisos del token.
6. Probar de nuevo.
7. Consultar los logs del receptor.
8. Rotar la credencial si ha sido expuesta.

### Registro

```text
Código inicial:

Método de autenticación:

Causa:

Corrección:

Código posterior:

Credencial rotada:

Observaciones:
```

---

## Ejemplo de sesión 6: probar diferentes severidades

### Objetivo

Enviar alertas de distinta severidad a contactos diferentes.

### Contactos

```text
laboratory-warning-email
laboratory-critical-email
```

### Políticas conceptuales

```text
severity=warning
    → laboratory-warning-email

severity=critical
    → laboratory-critical-email
```

### Actividades

1. Crear ambos contactos.
2. Crear o revisar las políticas.
3. Crear una alerta de prueba con:

```text
severity = warning
```

4. Activarla.
5. Comprobar el destinatario.
6. Cambiar a:

```text
severity = critical
```

7. Repetir la prueba.
8. Comparar los resultados.
9. Documentar las rutas.

### Tabla

| Severidad | Contacto esperado | Contacto recibido | Resultado |
|---|---|---|---|
| `warning` | | | |
| `critical` | | | |

---

## Ejemplo de sesión 7: probar una notificación de recuperación

### Objetivo

Comprobar el comportamiento cuando una alerta vuelve a estado normal.

### Regla

```text
Nombre:
NodeExporterDown
Condición:
up = 0 durante 1 minuto
```

### Pasos

1. Comprobar que la regla está en `Normal`.
2. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

3. Esperar la activación.
4. Confirmar la notificación.
5. Iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

6. Esperar la recuperación.
7. Comprobar si se envía una notificación de resolución.
8. Registrar ambos mensajes.

### Registro

```text
Hora de activación:

Notificación de activación recibida:

Hora de recuperación:

Notificación de recuperación recibida:

Contenido correcto:

Observaciones:
```

---

## Ejemplo de sesión 8: revisar agrupación de notificaciones

### Objetivo

Comprobar cómo se agrupan varias alertas.

### Escenario

Tres instancias presentan CPU elevada:

```text
server-01
server-02
server-03
```

### Pasos

1. Crear una regla multidimensional.
2. Configurar el contacto de laboratorio.
3. Activar las tres instancias.
4. Observar la lista de alertas.
5. Revisar el mensaje recibido.
6. Identificar si las alertas llegaron agrupadas.
7. Comprobar que cada instancia aparece en el contenido.
8. Evaluar la legibilidad del mensaje.

### Preguntas

```text
¿Se recibió un mensaje o varios?

¿Aparecen todas las instancias?

¿El agrupamiento facilita la respuesta?

¿Se pierde información importante?

¿Sería necesario cambiar la política?
```

---

## Ejemplo de sesión 9: revisar un contacto obsoleto

### Objetivo

Identificar contactos que ya no deben utilizarse.

### Indicadores

```text
Destinatario inexistente.
Webhook retirado.
Equipo disuelto.
Token caducado.
Contacto sin políticas asociadas.
Canal no supervisado.
Cuenta personal utilizada como destino.
```

### Pasos

1. Listar los contactos existentes.
2. Revisar su tipo.
3. Revisar su destinatario.
4. Consultar las políticas que los utilizan.
5. Confirmar el propietario.
6. Identificar contactos obsoletos.
7. Sustituirlos si corresponde.
8. Eliminar o deshabilitar los que ya no deben utilizarse.
9. Documentar el cambio.

### Registro

```text
Contacto:

Tipo:

Propietario:

Políticas asociadas:

Última prueba:

Motivo de revisión:

Acción:

Fecha:
```

---

## Gestión segura de credenciales

Los contactos pueden necesitar credenciales, tokens o claves.

### Nunca incluir en documentación

```text
Contraseñas
Tokens
Claves privadas
Secretos SMTP
URLs con credenciales
Cabeceras completas de autenticación
```

### No almacenar en

```text
Repositorio Git
Capturas de pantalla
Dashboards
Documentos públicos
Mensajes de chat
Scripts compartidos
```

### Recomendaciones

- Utilizar secretos gestionados.
- Limitar los permisos.
- Rotar credenciales.
- Establecer fechas de caducidad.
- Auditar el acceso.
- Separar credenciales por entorno.
- Revocar credenciales no utilizadas.
- Registrar únicamente referencias no sensibles.

### Ejemplo de documentación segura

```text
Contacto:
production-on-call-webhook

Credencial:
Gestionada por el almacén de secretos de producción

Última rotación:
2026-09-01

Responsable:
Equipo de operaciones
```

---

## Permisos y administración

No todos los usuarios deberían poder crear o modificar contactos.

Los contactos pueden afectar a:

- Distribución de información operativa.
- Datos personales.
- Canales de guardia.
- Sistemas externos.
- Automatizaciones.
- Incidencias de producción.

### Recomendaciones

- Limitar permisos administrativos.
- Separar creación y revisión.
- Auditar cambios.
- Utilizar contactos aprobados.
- Revisar destinatarios.
- Evitar que un usuario redirija alertas críticas a una cuenta personal.
- Mantener una lista de responsables.

---

## Documentar contactos

Cada contacto debería tener una ficha.

### Plantilla

```text
Nombre:

Tipo:

Entorno:

Propietario:

Equipo destinatario:

Finalidad:

Dirección o endpoint:

Política asociada:

Severidades permitidas:

Frecuencia de prueba:

Última prueba:

Resultado:

Fecha de revisión:

Responsable:
```

No incluir credenciales ni tokens.

### Ejemplo

```text
Nombre:
laboratory-systems-email

Tipo:
Correo electrónico

Entorno:
Laboratorio

Propietario:
Equipo de formación

Equipo destinatario:
Alumnos del laboratorio

Finalidad:
Pruebas de reglas de alerta

Política asociada:
team=systems y environment=laboratory

Última prueba:
2026-09-24

Resultado:
Correcto
```

---

## Problemas frecuentes

### El contacto no aparece en la política

Comprobar:

- Que el contacto se ha guardado.
- Que se está trabajando en la organización correcta.
- Que el usuario tiene permisos.
- Que se ha seleccionado el tipo correcto.
- Que no existen filtros en la interfaz.

### La prueba falla inmediatamente

Comprobar:

- Datos obligatorios.
- URL o dirección.
- Tipo de integración.
- Campos de autenticación.
- Conectividad.
- Certificados.
- Logs.

### La alerta está activa, pero no se envía

Comprobar:

- Coincidencia de etiquetas.
- Política.
- Contacto.
- Silenciamiento.
- Agrupación.
- Repetición.
- Estado de la integración.
- Errores de entrega.

### El correo no llega

Comprobar:

- SMTP.
- Remitente.
- Destinatario.
- Puerto.
- TLS.
- Credenciales.
- Restricciones de red.
- Correo no deseado.
- Logs.

### El webhook devuelve `401`

Comprobar:

- Token.
- Cabecera.
- Permisos.
- Caducidad.
- Método de autenticación.

### El webhook devuelve `404`

Comprobar:

- URL.
- Ruta.
- Entorno.
- Servicio receptor.
- Versión de la API.

### El webhook devuelve `429`

Comprobar:

- Límite de peticiones.
- Agrupación.
- Repetición.
- Número de alertas.
- Capacidad del receptor.

### Se reciben demasiados mensajes

Comprobar:

- Políticas.
- Agrupación.
- Intervalo de repetición.
- Duración de la alerta.
- Reglas duplicadas.
- Número de instancias.
- Severidad.

### Se recibe un mensaje sin información útil

Comprobar:

- Plantilla.
- Anotaciones.
- Etiquetas.
- Variables.
- Contenido del contacto.
- Enlaces al dashboard y runbook.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/contactos-notificacion
```

Crear una plantilla de contacto:

```bash
cat > ~/laboratorio-grafana/evidencias/contactos-notificacion/contacto.txt <<'EOF'
Nombre del contacto:

Tipo:

Entorno:

Propietario:

Equipo destinatario:

Finalidad:

Política asociada:

Fecha de creación:

Fecha de la prueba:

Resultado de la prueba:

Problemas encontrados:

Acción correctiva:

Fecha de revisión:
EOF
```

Crear una plantilla de pruebas:

```bash
cat > ~/laboratorio-grafana/evidencias/contactos-notificacion/pruebas.txt <<'EOF'
Prueba 1: correo electrónico

Contacto:

Fecha:

Hora:

Resultado:

Prueba 2: webhook

Contacto:

Código HTTP:

Resultado:

Prueba 3: activación de alerta

Regla:

Estado:

Contacto utilizado:

Notificación recibida:

Prueba 4: recuperación

Regla:

Notificación de recuperación recibida:

Observaciones:
EOF
```

Capturas recomendadas:

```text
01-lista-contactos.png
02-contacto-correo.png
03-contacto-webhook.png
04-prueba-correo.png
05-prueba-webhook.png
06-politica-contacto.png
07-alerta-notificada.png
08-alerta-recuperada.png
09-error-contacto.png
10-contacto-documentado.png
```

Antes de guardar capturas, ocultar o eliminar:

```text
Contraseñas
Tokens
Claves
Direcciones privadas
URLs con credenciales
```

---

## Práctica integradora

### Objetivo

Crear, probar y utilizar un contacto de notificación en un flujo completo de alertas.

### Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Una regla de alerta disponible.
- Permisos para crear contactos.
- Un destinatario de laboratorio.
- SMTP o webhook autorizado.
- Un entorno de pruebas.

---

### Tarea 1: crear el contacto

Crear un contacto de correo electrónico:

```text
Nombre:
laboratory-systems-email

Entorno:
laboratory

Equipo:
systems
```

Utilizar una dirección de pruebas autorizada.

---

### Tarea 2: probar el contacto

Ejecutar la prueba de entrega.

Registrar:

```text
Fecha:

Hora:

Resultado:

Tiempo de entrega:

Contenido recibido:

Problemas:
```

---

### Tarea 3: crear o revisar la política

Configurar una política que coincida con:

```text
team = systems
environment = laboratory
```

Asignar:

```text
laboratory-systems-email
```

---

### Tarea 4: preparar la regla

Utilizar una regla de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Etiquetas:

```text
team = systems
environment = laboratory
severity = warning
resource = cpu
```

Condición:

```text
Valor mayor que 90
```

Duración:

```text
5 minutos
```

---

### Tarea 5: activar la alerta

Generar carga controlada:

```bash
stress-ng --cpu 1 --timeout 60s
```

Utilizar el comando únicamente en un entorno autorizado.

Observar:

```text
Estado Normal
Estado Pending
Estado Alerting
Notificación enviada
Estado Normalizado
```

---

### Tarea 6: comprobar la recepción

Verificar:

```text
¿Llegó el correo?

¿El destinatario era correcto?

¿La alerta aparece en el asunto?

¿Aparece la instancia?

¿Aparece la severidad?

¿Aparece el valor?

¿Aparece el runbook?

¿Se recibió la recuperación?
```

---

### Tarea 7: documentar el flujo

Completar:

```text
Regla:

Etiquetas:

Política:

Contacto:

Canal:

Hora de activación:

Hora de recepción:

Hora de recuperación:

Resultado:

Problemas:

Correcciones:
```

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Contacto creado | | |
| Destinatario autorizado | | |
| Prueba de contacto ejecutada | | |
| Mensaje de prueba recibido | | |
| Política creada | | |
| Etiquetas revisadas | | |
| Regla activada | | |
| Estado `Pending` observado | | |
| Estado `Alerting` observado | | |
| Notificación recibida | | |
| Instancia identificada | | |
| Severidad visible | | |
| Valor visible | | |
| Runbook visible | | |
| Notificación de recuperación recibida | | |
| Contacto documentado | | |
| Evidencias guardadas | | |

---

## Puntos clave

- Un contacto de notificación define dónde se entrega una alerta.
- Una política determina cuándo y a qué contacto se envía.
- Una regla detecta la condición que origina la alerta.
- Las etiquetas conectan la regla con la política.
- El correo electrónico requiere una configuración SMTP válida.
- Un webhook requiere una URL y una autenticación adecuadas.
- Los contactos deben probarse antes de utilizarse en producción.
- Una alerta activa no garantiza que la notificación haya sido entregada.
- Un silencio puede impedir el envío aunque la regla esté en `Alerting`.
- La agrupación puede reducir el número de mensajes.
- Las notificaciones de recuperación deben probarse cuando estén configuradas.
- Los contactos deben tener nombres descriptivos.
- Los contactos de laboratorio y producción deben estar separados.
- Las credenciales no deben almacenarse en documentación ni repositorios.
- Los webhooks deben utilizar HTTPS y autenticación.
- Los errores HTTP ayudan a diagnosticar problemas de integración.
- Las etiquetas de las reglas deben coincidir con las condiciones de las políticas.
- Los contactos obsoletos deben revisarse y retirarse.
- Cada contacto debe tener un propietario y una finalidad documentados.
- Las notificaciones deben incluir contexto útil para actuar.
- El destinatario debe ser responsable del tipo de alerta recibido.
- Las pruebas deben incluir activación y recuperación.
- Los permisos de administración deben limitarse.
- El canal de notificación debe ser fiable y estar supervisado.
- Un contacto correctamente configurado forma parte de un flujo completo, no de una configuración aislada.

---

## Preguntas de comprobación

1. ¿Qué es un contacto de notificación?
2. ¿Qué diferencia existe entre un contacto y una regla de alerta?
3. ¿Qué diferencia existe entre un contacto y una política?
4. ¿Qué función cumplen las etiquetas en el enrutamiento?
5. ¿Qué datos necesita normalmente un contacto SMTP?
6. ¿Qué es un webhook?
7. ¿Qué significa una respuesta HTTP `401`?
8. ¿Qué significa una respuesta HTTP `404`?
9. ¿Qué significa una respuesta HTTP `429`?
10. ¿Qué revisarías si una prueba de correo falla?
11. ¿Qué revisarías si la alerta está activa, pero no llega la notificación?
12. ¿Qué relación existe entre un silencio y un contacto?
13. ¿Qué ventajas tiene agrupar varias alertas?
14. ¿Qué riesgos puede tener una agrupación demasiado amplia?
15. ¿Por qué deben separarse los contactos de laboratorio y producción?
16. ¿Qué información debería incluir una notificación útil?
17. ¿Qué información no debe aparecer nunca en una captura?
18. ¿Cómo probarías un contacto de correo?
19. ¿Cómo probarías un contacto webhook?
20. ¿Cómo comprobarías una notificación de recuperación?
21. ¿Qué debe hacerse con un contacto obsoleto?
22. ¿Por qué es importante documentar el propietario de un contacto?
23. ¿Qué comprobarías si el mensaje llega sin información útil?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener un contacto fiable y seguro?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear y probar un contacto de notificación dentro de un flujo completo de alertas.

El proceso será:

```text
Crear la regla
      |
      v
Añadir etiquetas
      |
      v
Crear el contacto
      |
      v
Probar el contacto
      |
      v
Crear la política
      |
      v
Relacionar etiquetas y política
      |
      v
Activar la alerta
      |
      v
Enviar la notificación
      |
      v
Comprobar la recepción
      |
      v
Comprobar la recuperación
      |
      v
Documentar el resultado
```

Un contacto está correctamente configurado cuando:

- Tiene un nombre claro.
- Utiliza un canal autorizado.
- El destinatario es correcto.
- La prueba de entrega funciona.
- La política lo selecciona correctamente.
- Las alertas llegan con información suficiente.
- Las recuperaciones se comportan según lo esperado.
- Las credenciales están protegidas.
- Existe un propietario.
- El contacto se revisa periódicamente.

El contacto es el último tramo del flujo de alertas: una regla puede detectar perfectamente un problema, pero si el mensaje no llega al equipo adecuado, la detección no se convierte en respuesta operativa.