# Configuración inicial

## Objetivos

Al finalizar esta sección podrás:

- Completar la configuración inicial de una instalación de Grafana.
- Cambiar las credenciales predeterminadas del administrador.
- Revisar las preferencias generales de la interfaz.
- Configurar usuarios, equipos, carpetas y permisos básicos.
- Añadir una fuente de datos, como Prometheus.
- Verificar la conectividad entre Grafana y la fuente de datos.
- Aplicar medidas básicas de seguridad.
- Preparar Grafana para crear los primeros dashboards.

## Introducción

Después de instalar Grafana y acceder por primera vez a su interfaz web, es necesario realizar una serie de configuraciones iniciales.

La instalación del servicio proporciona una instancia funcional, pero todavía es necesario definir aspectos como:

- Cuenta de administrador.
- Nombre de la instancia.
- Zona horaria.
- Preferencias de idioma.
- Fuentes de datos.
- Usuarios y permisos.
- Carpetas de organización.
- Configuración de alertas.
- Opciones de seguridad.
- Copias de seguridad.

La configuración inicial debe realizarse de forma ordenada. Una configuración incorrecta puede provocar problemas de acceso, consultas fallidas, dashboards con horarios incorrectos o usuarios con permisos excesivos.

Una arquitectura básica después de la configuración puede ser:

```text
Grafana
├── Usuario administrador
├── Fuente de datos: Prometheus
├── Organización
├── Carpetas
├── Usuarios y equipos
└── Dashboards
```

La configuración puede realizarse desde la interfaz web o mediante ficheros de provisioning. Para un primer laboratorio se utilizará principalmente la interfaz gráfica.

## Contenido

### Acceder por primera vez

Abre Grafana utilizando la dirección configurada:

```text
http://localhost:3000
```

Si Grafana se encuentra en otro servidor:

```text
http://DIRECCION_IP:3000
```

Si se ha configurado un dominio y HTTPS:

```text
https://grafana.example.com
```

En la pantalla de inicio de sesión introduce las credenciales iniciales.

En muchas instalaciones nuevas se utilizan:

```text
Usuario: admin
Contraseña: admin
```

Después del primer acceso, Grafana solicitará cambiar la contraseña.

Utiliza una contraseña:

- Larga.
- Única.
- Difícil de adivinar.
- No reutilizada en otros servicios.
- Guardada en un gestor de contraseñas.

No mantengas las credenciales predeterminadas en un entorno real.

### Cambiar la contraseña del administrador

Durante el primer acceso:

1. Introduce el usuario inicial.
2. Introduce la contraseña inicial.
3. Escribe una nueva contraseña.
4. Confirma la nueva contraseña.
5. Guarda los cambios.

Si se necesita cambiar la contraseña posteriormente:

1. Abre el menú del usuario.
2. Accede a las preferencias de la cuenta.
3. Selecciona la opción para cambiar la contraseña.
4. Introduce la contraseña actual.
5. Introduce y confirma la nueva contraseña.
6. Guarda la configuración.

Una contraseña segura debe evitar:

- Nombres de personas.
- Fechas de nacimiento.
- Nombres de empresas.
- Palabras del diccionario.
- Secuencias como `123456`.
- Contraseñas utilizadas en otros servicios.

### Revisar la página de inicio

Después de iniciar sesión, Grafana muestra la página principal.

Desde ella se puede acceder a:

- Dashboards.
- Fuentes de datos.
- Exploración de métricas.
- Alertas.
- Administración.
- Configuración.
- Plugins.
- Usuarios y equipos.

Los nombres exactos de algunos menús pueden cambiar entre versiones de Grafana, pero la organización general es similar.

La barra lateral permite desplazarse entre las principales áreas de trabajo.

### Configurar el nombre de la instancia

El nombre de la instancia ayuda a identificar el servidor de Grafana cuando existen varios entornos.

Por ejemplo:

```text
Grafana Laboratorio
Grafana Desarrollo
Grafana Producción
```

La configuración puede realizarse mediante el fichero:

```text
/etc/grafana/grafana.ini
```

Realiza una copia de seguridad antes de modificarlo:

```bash
sudo cp \
  /etc/grafana/grafana.ini \
  /etc/grafana/grafana.ini.bak
```

Edita el fichero:

```bash
sudo nano /etc/grafana/grafana.ini
```

En la sección `[server]` pueden configurarse algunos parámetros generales:

```ini
[server]
protocol = http
http_port = 3000
domain = localhost
```

Después de modificar el fichero, reinicia el servicio:

```bash
sudo systemctl restart grafana-server
```

Comprueba que se encuentra activo:

```bash
sudo systemctl status grafana-server
```

### Configurar la zona horaria

La zona horaria es importante para interpretar correctamente:

- Métricas.
- Logs.
- Dashboards.
- Alertas.
- Incidentes.
- Eventos históricos.

La configuración puede realizarse desde las preferencias de usuario o del dashboard.

Es necesario diferenciar entre:

- Zona horaria del sistema operativo.
- Zona horaria del navegador.
- Zona horaria del usuario.
- Zona horaria del dashboard.
- Zona horaria configurada en una alerta.

Comprueba la zona horaria del servidor:

```bash
timedatectl
```

Ejemplo:

```text
Time zone: Europe/Madrid (CEST, +0200)
```

Para configurar la zona horaria del sistema:

```bash
sudo timedatectl set-timezone Europe/Madrid
```

Comprueba el resultado:

```bash
timedatectl
```

En Grafana se puede seleccionar normalmente una de estas opciones:

- Zona horaria local del navegador.
- UTC.
- Una zona horaria concreta.

Para un entorno distribuido, utilizar UTC puede facilitar la correlación entre servidores ubicados en diferentes regiones. Para un laboratorio local, la zona horaria del navegador suele ser más cómoda.

### Configurar el idioma

Grafana permite seleccionar el idioma de la interfaz cuando la versión instalada lo admite.

La configuración puede encontrarse en:

- Preferencias del usuario.
- Preferencias de la organización.
- Configuración general.

El idioma afecta principalmente a:

- Menús.
- Botones.
- Mensajes.
- Etiquetas de la interfaz.
- Ayuda contextual.

Las consultas, los nombres de métricas y las etiquetas dependen de la fuente de datos y no se traducen automáticamente.

### Configurar la organización

Grafana utiliza organizaciones para separar recursos y configuraciones.

Una organización puede contener:

- Usuarios.
- Dashboards.
- Carpetas.
- Fuentes de datos.
- Alertas.
- Permisos.

En un laboratorio sencillo se puede utilizar la organización predeterminada.

En entornos más grandes pueden crearse organizaciones independientes para:

```text
Organización A: Desarrollo
Organización B: Pruebas
Organización C: Producción
```

La separación mediante organizaciones puede ayudar a evitar que los usuarios consulten o modifiquen recursos de otros entornos.

Antes de crear varias organizaciones, define una estrategia clara de:

- Propiedad de los dashboards.
- Usuarios autorizados.
- Equipos.
- Fuentes de datos.
- Permisos.
- Responsables de administración.

### Crear usuarios

No es recomendable que todos los usuarios utilicen la cuenta `admin`.

Crea una cuenta individual para cada persona que necesite acceder a Grafana.

Una cuenta de usuario debería tener:

- Nombre identificable.
- Correo electrónico válido.
- Contraseña segura.
- Rol apropiado.
- Acceso limitado a los recursos necesarios.

Los roles habituales dentro de una organización son:

| Rol | Permisos generales |
|---|---|
| Viewer | Puede consultar dashboards |
| Editor | Puede crear y modificar recursos permitidos |
| Admin | Puede administrar la organización |
| Grafana Admin | Puede administrar la instancia completa |

Los nombres y permisos pueden variar según la versión y la configuración.

Utiliza el principio de mínimo privilegio:

- Asigna `Viewer` para usuarios que solo necesiten consultar.
- Asigna `Editor` para quienes creen o mantengan dashboards.
- Reserva `Admin` para responsables de la organización.
- Limita el uso de `Grafana Admin`.

### Crear equipos

Los equipos permiten agrupar usuarios y asignar permisos colectivamente.

Ejemplos:

```text
Equipo: Operaciones
Equipo: Desarrollo
Equipo: Seguridad
Equipo: Administración
```

Un equipo puede recibir permisos sobre:

- Carpetas.
- Dashboards.
- Fuentes de datos.
- Alertas.

Ventajas de utilizar equipos:

- Evita asignar permisos usuario por usuario.
- Facilita la incorporación de nuevos miembros.
- Simplifica las revisiones de acceso.
- Reduce errores de configuración.
- Permite aplicar una política coherente.

Una estructura sencilla puede ser:

```text
Operaciones
├── Ana
├── Luis
└── Marta

Desarrollo
├── Carlos
└── Elena

Seguridad
└── Sergio
```

### Crear carpetas

Las carpetas permiten organizar dashboards relacionados.

Ejemplo:

```text
Dashboards
├── Infraestructura
├── Aplicaciones
├── Bases de datos
├── Redes
└── Seguridad
```

Una carpeta puede representar:

- Un equipo.
- Una aplicación.
- Un entorno.
- Un servicio.
- Una ubicación.
- Un nivel de criticidad.

Ejemplo por entorno:

```text
Dashboards
├── Producción
├── Desarrollo
└── Laboratorio
```

Ejemplo por servicio:

```text
Dashboards
├── Linux
├── Kubernetes
├── Bases de datos
└── Aplicaciones web
```

Una buena organización evita dashboards duplicados y facilita el acceso durante un incidente.

### Configurar una fuente de datos

Grafana necesita al menos una fuente de datos para consultar métricas, logs o trazas.

Algunas fuentes habituales son:

- Prometheus.
- Loki.
- InfluxDB.
- Elasticsearch.
- MySQL.
- PostgreSQL.
- Tempo.

Para añadir una fuente de datos:

1. Abre el área de configuración.
2. Accede a **Data sources** o **Fuentes de datos**.
3. Selecciona **Add data source**.
4. Elige el tipo de fuente.
5. Introduce la URL.
6. Configura las opciones necesarias.
7. Guarda y prueba la conexión.

### Añadir Prometheus

Selecciona:

```text
Prometheus
```

Introduce la URL de Prometheus.

Si ambos servicios se ejecutan en el mismo servidor:

```text
http://localhost:9090
```

Si Prometheus está en otro servidor:

```text
http://192.168.1.60:9090
```

Si se utiliza Docker Compose, la dirección puede ser:

```text
http://prometheus:9090
```

La dirección correcta depende del punto desde el que Grafana realiza la conexión.

Una configuración básica puede ser:

```text
Nombre: Prometheus
URL: http://localhost:9090
Access: Server
```

El modo `Server` indica que Grafana realiza la consulta desde el servidor de Grafana, no desde el navegador del usuario.

Guarda la fuente y utiliza la opción de probar la conexión.

Una conexión correcta debería mostrar un mensaje equivalente a:

```text
Data source is working
```

### Comprobar Prometheus antes de conectarlo

Desde el servidor de Grafana, comprueba que Prometheus responde:

```bash
curl -I http://localhost:9090
```

Comprueba su endpoint de disponibilidad:

```bash
curl http://localhost:9090/-/ready
```

También puedes consultar la API:

```bash
curl http://localhost:9090/api/v1/status/buildinfo
```

Si Prometheus está en otro servidor:

```bash
curl http://192.168.1.60:9090/-/ready
```

Si estas consultas fallan, Grafana tampoco podrá utilizar Prometheus como fuente de datos.

### Configurar la fuente de datos predeterminada

Cuando existen varias fuentes de datos, puede establecerse una como predeterminada.

Por ejemplo:

```text
Prometheus
```

Esto facilita la creación de paneles, ya que Grafana seleccionará automáticamente esa fuente en nuevos dashboards.

Antes de definir una fuente predeterminada, comprueba que:

- La URL es correcta.
- La conexión funciona.
- La fuente contiene los datos esperados.
- Los usuarios autorizados pueden utilizarla.
- Las credenciales están protegidas.

### Probar una consulta básica

Después de añadir Prometheus, abre el explorador de datos.

Selecciona la fuente:

```text
Prometheus
```

Prueba una consulta sencilla:

```promql
up
```

La consulta `up` muestra si los objetivos monitorizados están disponibles.

Otra consulta básica es:

```promql
scrape_samples_scraped
```

Esta métrica permite observar el número de muestras procesadas por Prometheus.

Para consultar información sobre los objetivos:

```promql
up{job="node"}
```

El resultado dependerá de los nombres de los trabajos configurados en Prometheus.

### Configurar las preferencias de usuario

Las preferencias de usuario pueden incluir:

- Tema claro u oscuro.
- Zona horaria.
- Idioma.
- Dashboard de inicio.
- Formato de visualización.
- Preferencias de navegación.

El modo oscuro puede ser útil en salas de operaciones o durante sesiones prolongadas, mientras que el modo claro puede facilitar la lectura en entornos bien iluminados.

La configuración de preferencias es personal. No debe confundirse con la configuración global de la instancia.

### Configurar un dashboard de inicio

Grafana puede mostrar un dashboard concreto después del inicio de sesión.

Un dashboard de inicio útil podría incluir:

- Disponibilidad de servidores.
- Uso de CPU.
- Uso de memoria.
- Espacio de disco.
- Estado de servicios.
- Alertas activas.

Para seleccionar un dashboard de inicio:

1. Abre el dashboard deseado.
2. Accede a las opciones de preferencias.
3. Selecciona la opción para establecerlo como dashboard inicial.
4. Guarda los cambios.

El dashboard inicial debe ofrecer información útil sin sobrecargar al usuario con demasiados paneles.

### Configurar alertas

Grafana puede utilizarse para definir reglas de alerta basadas en datos de las fuentes configuradas.

Antes de crear alertas, define:

- Qué condición debe activar la alerta.
- Durante cuánto tiempo debe mantenerse.
- Qué severidad tiene.
- Quién debe recibirla.
- Qué canal de notificación se utilizará.
- Qué información debe incluir el mensaje.

Ejemplo conceptual:

```text
Si el uso de CPU supera el 80 %
durante más de 5 minutos,
crear una alerta de severidad warning.
```

Una alerta no debe activarse por cualquier variación normal. Las condiciones deben representar situaciones que requieran atención.

Una política de alertas puede utilizar niveles como:

```text
info
warning
critical
```

### Configurar canales de contacto

Los canales de contacto permiten enviar notificaciones a sistemas externos.

Algunos ejemplos son:

- Correo electrónico.
- Microsoft Teams.
- Slack.
- Webhook.
- PagerDuty.
- Sistemas de gestión de incidencias.

Antes de configurar notificaciones, revisa:

- Credenciales.
- URLs.
- Certificados.
- Restricciones de red.
- Datos sensibles incluidos en los mensajes.
- Responsables de cada canal.

No incluyas contraseñas, tokens o información sensible directamente en dashboards compartidos.

### Revisar los plugins

Grafana puede ampliarse mediante plugins.

Los plugins pueden proporcionar:

- Nuevas fuentes de datos.
- Paneles adicionales.
- Aplicaciones integradas.
- Funciones de visualización.
- Integraciones externas.

Instala únicamente plugins:

- Necesarios.
- Compatibles con la versión instalada.
- Procedentes de fuentes confiables.
- Mantenidos activamente.
- Revisados por el equipo responsable.

Cada plugin puede introducir requisitos adicionales y aumentar la superficie de mantenimiento.

Consulta los plugins instalados desde la interfaz o mediante la configuración del sistema.

### Configuración mediante provisioning

En entornos repetibles puede definirse la configuración mediante ficheros de provisioning.

Esta técnica permite automatizar:

- Fuentes de datos.
- Dashboards.
- Contactos.
- Reglas de alerta.
- Configuraciones iniciales.

Una estructura habitual puede ser:

```text
/etc/grafana/provisioning/
├── datasources/
├── dashboards/
├── alerting/
└── plugins/
```

Ejemplo de fuente de datos de Prometheus:

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

Guarda el fichero, por ejemplo, como:

```text
/etc/grafana/provisioning/datasources/prometheus.yml
```

Comprueba los permisos:

```bash
sudo chown root:grafana \
  /etc/grafana/provisioning/datasources/prometheus.yml
```

Después reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Consulta los logs:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

El provisioning es especialmente útil cuando se necesita reproducir la misma configuración en varios entornos.

### Realizar una copia de seguridad inicial

Antes de personalizar ampliamente Grafana, realiza una copia de seguridad.

En una instalación basada en SQLite, una copia básica puede ser:

```bash
sudo tar -czf \
  /tmp/grafana-config-$(date +%F).tar.gz \
  /etc/grafana \
  /var/lib/grafana
```

Comprueba el fichero generado:

```bash
ls -lh /tmp/grafana-config-*.tar.gz
```

Una copia de seguridad debería incluir:

- Configuración.
- Base de datos.
- Provisioning.
- Certificados, si corresponde.
- Dashboards exportados.
- Documentación de las credenciales y dependencias.

No guardes copias con contraseñas o tokens en ubicaciones públicas.

### Lista de comprobación inicial

Antes de dar por finalizada la configuración, verifica:

```text
[ ] Se ha cambiado la contraseña de admin.
[ ] Se ha comprobado la zona horaria.
[ ] Se ha definido el idioma o las preferencias necesarias.
[ ] Se ha revisado el nombre de la instancia.
[ ] Se ha creado la estructura de carpetas.
[ ] Se han creado los usuarios necesarios.
[ ] Se han creado los equipos necesarios.
[ ] Se han asignado los permisos mínimos.
[ ] Se ha añadido la fuente de datos.
[ ] Se ha probado la conexión con la fuente de datos.
[ ] Se ha ejecutado una consulta básica.
[ ] Se ha seleccionado un dashboard inicial.
[ ] Se han revisado los plugins.
[ ] Se ha configurado HTTPS si corresponde.
[ ] Se ha realizado una copia de seguridad.
```

## Ejemplo

### Configuración inicial con Prometheus

Supongamos el siguiente escenario:

```text
Sistema operativo: Ubuntu 24.04.5 LTS
Grafana: localhost:3000
Prometheus: localhost:9090
Usuario inicial: admin
```

Comprueba que Prometheus responde:

```bash
curl http://localhost:9090/-/ready
```

Accede a Grafana:

```text
http://localhost:3000
```

Completa los siguientes pasos:

1. Inicia sesión con el usuario inicial.
2. Cambia la contraseña.
3. Configura la zona horaria.
4. Accede a las fuentes de datos.
5. Añade Prometheus.
6. Introduce la URL `http://localhost:9090`.
7. Guarda y prueba la conexión.
8. Abre el explorador.
9. Ejecuta la consulta `up`.
10. Comprueba que aparecen resultados.

### Configuración mediante provisioning

Crea el directorio:

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
```

Crea el fichero:

```bash
sudo nano /etc/grafana/provisioning/datasources/prometheus.yml
```

Añade:

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

Asegura los permisos:

```bash
sudo chown -R root:grafana \
  /etc/grafana/provisioning
```

Reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprueba el estado:

```bash
sudo systemctl status grafana-server
```

Revisa los logs:

```bash
sudo journalctl -u grafana-server -n 50 --no-pager
```

Accede a la sección de fuentes de datos y verifica que aparece:

```text
Prometheus
```

### Crear una estructura de dashboards

Una estructura inicial puede ser:

```text
Dashboards
├── Infraestructura
│   ├── Estado de servidores
│   ├── CPU y memoria
│   └── Almacenamiento
├── Aplicaciones
│   ├── Disponibilidad
│   ├── Latencia
│   └── Errores
└── Laboratorio
    ├── Pruebas de Prometheus
    └── Pruebas de Grafana
```

Esta estructura separa los dashboards por finalidad y facilita su localización.

### Crear un usuario de solo lectura

Para un usuario que únicamente necesita consultar dashboards:

1. Accede a la administración de usuarios.
2. Crea un usuario individual.
3. Asigna el rol `Viewer`.
4. Añádelo al equipo correspondiente.
5. Comprueba que puede abrir los dashboards.
6. Verifica que no puede modificarlos.

Este procedimiento permite validar que los permisos siguen el principio de mínimo privilegio.

## Puntos clave

- La configuración inicial comienza después del primer inicio de sesión.
- La contraseña predeterminada debe cambiarse inmediatamente.
- No debe utilizarse la cuenta `admin` para todas las tareas diarias.
- Cada usuario debe tener una cuenta individual.
- Los roles deben asignarse siguiendo el principio de mínimo privilegio.
- Las carpetas ayudan a organizar dashboards por equipo, servicio o entorno.
- Los equipos simplifican la asignación de permisos.
- Grafana necesita una fuente de datos para mostrar métricas, logs o trazas.
- Prometheus suele configurarse mediante una URL como `http://localhost:9090`.
- La opción `Server` o `Proxy` permite que Grafana consulte la fuente de datos desde el servidor.
- La consulta `up` es una comprobación sencilla para validar una conexión con Prometheus.
- La zona horaria debe configurarse correctamente para interpretar métricas y alertas.
- La configuración mediante provisioning facilita la automatización.
- Los plugins deben instalarse con criterio y mantenerse actualizados.
- Las alertas deben representar condiciones importantes, no cualquier variación normal.
- Las notificaciones pueden enviarse mediante correo, webhooks o plataformas externas.
- Es recomendable utilizar HTTPS en producción.
- Las copias de seguridad deben incluir la configuración y los datos de Grafana.
- La configuración debe validarse mediante una lista de comprobación.
- Una configuración ordenada reduce errores durante la creación y el mantenimiento de dashboards.

## Preguntas de comprobación

1. ¿Qué tareas deben realizarse después del primer inicio de sesión?
2. ¿Por qué es importante cambiar la contraseña predeterminada?
3. ¿Qué diferencia existe entre un usuario `Viewer`, `Editor` y `Admin`?
4. ¿Qué ventaja ofrece crear usuarios individuales?
5. ¿Para qué se utilizan los equipos en Grafana?
6. ¿Cómo pueden organizarse los dashboards mediante carpetas?
7. ¿Qué información necesita Grafana para conectarse con Prometheus?
8. ¿Qué consulta PromQL puede utilizarse para comprobar la disponibilidad de objetivos?
9. ¿Qué diferencia existe entre la zona horaria del sistema y la del usuario?
10. ¿Por qué puede ser recomendable utilizar UTC en entornos distribuidos?
11. ¿Qué función cumple una fuente de datos predeterminada?
12. ¿Qué es el provisioning de Grafana?
13. ¿En qué directorio se almacenan habitualmente los ficheros de provisioning?
14. ¿Qué precauciones deben tomarse antes de instalar un plugin?
15. ¿Qué elementos debería incluir una copia de seguridad inicial?
16. ¿Por qué no es recomendable utilizar la cuenta `admin` para las tareas diarias?
17. ¿Qué factores deben definirse antes de crear una alerta?
18. ¿Qué canales pueden utilizarse para enviar notificaciones?
19. ¿Qué comprobarías si Prometheus aparece configurado, pero la prueba de conexión falla?
20. ¿Qué pasos seguirías para validar que la configuración inicial de Grafana está completa?