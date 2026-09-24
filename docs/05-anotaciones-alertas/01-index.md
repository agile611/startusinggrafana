# Anotaciones y alertas

Este bloque presenta las funcionalidades de Grafana relacionadas con la detección de problemas, el registro de eventos y el envío de notificaciones.

El alumno aprenderá a crear reglas de alerta a partir de métricas de Prometheus, documentar eventos mediante anotaciones y configurar los mecanismos necesarios para notificar una incidencia.

El recorrido formativo será:

```text
Métrica
  |
  v
Consulta PromQL
  |
  v
Condición
  |
  v
Regla de alerta
  |
  v
Estado de alerta
  |
  v
Notificación
  |
  v
Anotación y seguimiento
```

Una alerta no sustituye al análisis técnico. Su función es avisar de que una condición relevante requiere atención.

---

### Objetivos

Al finalizar este bloque, el alumno podrá:

- Explicar la diferencia entre una métrica, una alerta y una notificación.
- Crear anotaciones manuales y comprender su utilidad.
- Crear reglas de alerta basadas en consultas PromQL.
- Utilizar condiciones, expresiones y umbrales.
- Interpretar los estados de una alerta.
- Configurar contactos de notificación.
- Configurar notificaciones por correo electrónico.
- Comprender el funcionamiento de webhooks y otras integraciones.
- Crear políticas de notificación.
- Enrutar alertas mediante etiquetas.
- Crear silenciamientos temporales.
- Diferenciar un silencio de la desactivación de una regla.
- Diagnosticar alertas que no se activan.
- Probar una alerta en un entorno de laboratorio.
- Documentar reglas, contactos, políticas y silenciamientos.
- Aplicar buenas prácticas de seguridad y mantenimiento.

---

## Introducción

La monitorización permite observar el estado de un sistema, pero observar no siempre es suficiente.

Un operador necesita saber cuándo una situación requiere atención. Para ello se utilizan las alertas.

Ejemplos:

```text
La CPU supera el 90 % durante cinco minutos.
La memoria disponible es inferior al 10 %.
Un sistema de ficheros supera el 85 % de uso.
Un objetivo deja de responder.
La latencia p95 supera el límite establecido.
```

Una regla de alerta transforma una condición técnica en una señal operativa.

### Ejemplo conceptual

```text
Uso de CPU
    |
    v
Consulta PromQL
    |
    v
CPU > 90 %
    |
    v
Durante 5 minutos
    |
    v
Alerta activa
    |
    v
Correo o webhook
```

La calidad de una alerta depende de varios factores:

- La consulta debe ser correcta.
- El umbral debe ser razonable.
- La duración debe evitar falsos positivos.
- Las etiquetas deben permitir enrutarla.
- La notificación debe llegar al destinatario adecuado.
- La anotación debe explicar qué ocurre.
- El procedimiento de respuesta debe estar documentado.

Una alerta mal diseñada puede generar ruido, fatiga y pérdida de confianza. Una alerta bien diseñada ayuda a detectar problemas relevantes en el momento adecuado.

---

## Conceptos fundamentales

### Métrica

Una métrica es un valor que describe el estado o comportamiento de un sistema.

Ejemplos:

```promql
node_load1
```

```promql
up
```

```promql
node_memory_MemAvailable_bytes
```

```promql
node_filesystem_avail_bytes
```

### Consulta

Una consulta obtiene y procesa datos de una fuente como Prometheus.

Ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Esta consulta calcula el porcentaje de CPU utilizada por instancia.

### Condición

Una condición compara el resultado de una consulta con un criterio.

Ejemplo:

```text
CPU mayor que 90 %
```

### Regla de alerta

Una regla combina:

- Consulta.
- Condición.
- Duración.
- Etiquetas.
- Anotaciones.
- Comportamiento ante errores.
- Comportamiento ante ausencia de datos.

### Estado de alerta

Indica la situación actual de una regla.

Estados habituales:

```text
Normal
Pending
Alerting o Firing
No data
Error
```

Los nombres exactos pueden variar según la versión de Grafana y el tipo de regla.

### Notificación

Es el mensaje o evento enviado cuando una alerta cumple las condiciones definidas.

Ejemplos:

- Correo electrónico.
- Webhook.
- Canal de mensajería.
- Sistema de incidencias.
- Integración externa.

### Anotación

Una anotación registra un evento en una línea temporal.

Ejemplos:

```text
Inicio de mantenimiento.
Despliegue de una nueva versión.
Reinicio del servicio.
Inicio de una prueba de carga.
Resolución de una incidencia.
```

---

## Diferencia entre alerta y anotación

| Elemento | Finalidad |
|---|---|
| Métrica | Medir un comportamiento |
| Consulta | Obtener o calcular datos |
| Alerta | Detectar una condición |
| Notificación | Comunicar la alerta |
| Anotación | Registrar un evento |

### Ejemplo

```text
CPU = 93 %
```

Es una métrica.

```text
CPU > 90 %
```

Es una condición.

```text
CPU > 90 % durante 5 minutos
```

Es una regla de alerta.

```text
Enviar un correo al equipo de sistemas
```

Es una notificación.

```text
Registrar "inicio de investigación" en el gráfico
```

Es una anotación.

---

## Estructura del bloque

Los contenidos se organizan de la siguiente forma:

```text
01-index.md
  Introducción y organización del bloque

02-alertas.md
  Conceptos y estados de las alertas

03-anotaciones.md
  Registro de eventos sobre los gráficos

04-reglas-alerta.md
  Creación y configuración de reglas

05-condiciones-expresiones.md
  Condiciones, expresiones y evaluaciones

06-lista-alertas.md
  Consulta y gestión de alertas

07-contactos-notificacion.md
  Contactos y receptores

08-correo-electronico.md
  Configuración de correo electrónico

09-otras-notificaciones.md
  Webhooks e integraciones

10-politicas-notificacion.md
  Enrutamiento y agrupación

11-silenciados.md
  Supresión temporal de notificaciones

12-laboratorio.md
  Práctica integradora
```

---

## Flujo de trabajo recomendado

Una implementación de alertas puede seguir este proceso:

```text
1. Definir el problema operativo.
2. Identificar la métrica.
3. Crear la consulta.
4. Validar la consulta en Explore.
5. Definir el umbral.
6. Definir la duración.
7. Añadir etiquetas.
8. Añadir anotaciones.
9. Crear la regla.
10. Configurar el contacto.
11. Configurar la política.
12. Probar la alerta.
13. Revisar la notificación.
14. Documentar el resultado.
```

No se debe crear una alerta directamente sobre una consulta que no haya sido validada previamente.

---

## Ejemplo de regla de alerta

### Objetivo

Detectar un uso elevado de CPU.

### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Condición

```text
El valor es mayor que 90
```

### Duración

```text
5 minutos
```

### Etiquetas

```text
severity = warning
team = systems
alertname = HighCPUUsage
```

### Anotaciones

```text
summary = Uso de CPU elevado en {{ $labels.instance }}

description = La instancia {{ $labels.instance }}
mantiene un uso de CPU superior al 90 % durante 5 minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

La sintaxis disponible para plantillas puede depender de la versión y del contexto de evaluación.

---

## Estados de una alerta

### Normal

La condición no se cumple.

Ejemplo:

```text
CPU = 45 %
Umbral = 90 %
Estado = Normal
```

### Pending

La condición se cumple, pero todavía no ha transcurrido la duración configurada.

Ejemplo:

```text
CPU = 93 %
Duración configurada = 5 minutos
Tiempo transcurrido = 2 minutos
Estado = Pending
```

### Alerting o Firing

La condición se ha mantenido durante el tiempo requerido.

Ejemplo:

```text
CPU = 93 %
Duración configurada = 5 minutos
Tiempo transcurrido = 6 minutos
Estado = Alerting
```

### No data

Grafana no recibe datos suficientes para evaluar la regla.

Posibles causas:

- El objetivo está caído.
- La consulta no devuelve series.
- El rango temporal es inadecuado.
- La métrica no existe.
- Hay un problema de conectividad.
- La fuente de datos no responde.

### Error

La consulta o la evaluación produce un error.

Posibles causas:

- PromQL inválido.
- Métrica incorrecta.
- Expresión mal configurada.
- Fuente de datos inaccesible.
- Transformación no compatible.

---

## Etiquetas y anotaciones

### Etiquetas

Las etiquetas permiten clasificar y enrutar alertas.

Ejemplo:

```text
severity = critical
team = systems
environment = laboratory
service = web
```

### Anotaciones

Las anotaciones proporcionan contexto legible.

Ejemplo:

```text
summary = El servidor presenta un uso elevado de CPU

description = La CPU de {{ $labels.instance }}
ha superado el umbral configurado.

runbook_url = https://example.com/runbooks/cpu
```

### Diferencia

```text
Etiqueta:
severity=critical

Anotación:
La CPU permanece por encima del 90 % durante cinco minutos.
```

Las etiquetas son útiles para clasificar y enrutar.

Las anotaciones son útiles para comprender y actuar.

---

## Severidad de las alertas

Se puede utilizar una etiqueta para clasificar la severidad:

```text
severity = info
severity = warning
severity = critical
```

### Ejemplo

| Severidad | Significado |
|---|---|
| `info` | Información relevante |
| `warning` | Requiere revisión |
| `critical` | Requiere intervención prioritaria |

Los nombres deben acordarse dentro de la organización.

No se debe marcar todo como `critical`. Si todo es crítico, nada destaca; es la versión operativa de gritar en una biblioteca.

---

## Contactos de notificación

Un contacto define dónde se entrega una notificación.

Ejemplos:

```text
Equipo de sistemas
Equipo de desarrollo
Responsable de guardia
Canal de incidencias
Sistema de tickets
```

Un contacto puede utilizar:

- Correo electrónico.
- Webhook.
- Integración de mensajería.
- Canal externo.
- Sistema de incidencias.

Antes de probar una notificación, comprobar:

- Dirección.
- Permisos.
- Conectividad.
- Configuración SMTP.
- URL del webhook.
- Certificados.
- Restricciones de red.

---

## Políticas de notificación

Una política decide qué ocurre con una alerta después de generarse.

Puede determinar:

- Contacto.
- Ruta.
- Agrupación.
- Espera inicial.
- Intervalo de repetición.
- Condiciones de coincidencia.
- Nivel de severidad.
- Equipo destinatario.

### Ejemplo conceptual

```text
Si severity=critical
    enviar al equipo de guardia

Si severity=warning
    enviar al equipo de sistemas

Si team=development
    enviar al equipo de desarrollo
```

Las etiquetas de las alertas deben coincidir con las condiciones de las políticas.

---

## Silenciamientos

Un silenciamiento evita temporalmente que una alerta genere notificaciones.

Puede utilizarse durante:

- Mantenimientos.
- Despliegues.
- Pruebas de carga.
- Ventanas programadas.
- Incidencias ya conocidas.
- Cambios de infraestructura.

Un silencio no necesariamente detiene la evaluación de la alerta. Normalmente evita o reduce el envío de notificaciones.

### Buen silenciamiento

```text
Motivo: mantenimiento programado
Coincidencia: instance=server-01:9100
Inicio: 22:00
Fin: 23:00
Responsable: equipo de sistemas
```

### Mal silenciamiento

```text
Motivo: temporal
Duración: indefinida
Coincidencia: todas las alertas
```

Todo silencio debe tener:

- Motivo.
- Responsable.
- Alcance limitado.
- Inicio.
- Finalización.
- Revisión posterior.

---

## Prácticas relacionadas

Las prácticas de este bloque se encuentran en:

```text
05-anotaciones-alertas/
```

### Práctica 1: explorar alertas

Archivo:

```text
02-alertas.md
```

Actividades:

- Revisar los estados.
- Consultar alertas.
- Filtrar por etiquetas.
- Identificar alertas activas.
- Diferenciar `Pending` y `Alerting`.

### Práctica 2: crear anotaciones

Archivo:

```text
03-anotaciones.md
```

Actividades:

- Crear una anotación manual.
- Añadir etiquetas.
- Registrar un mantenimiento.
- Registrar el inicio de una prueba.
- Revisar la anotación en un Time series.

### Práctica 3: crear una regla

Archivo:

```text
04-reglas-alerta.md
```

Actividades:

- Crear una consulta.
- Configurar un umbral.
- Añadir una duración.
- Añadir etiquetas.
- Añadir anotaciones.
- Guardar la regla.

### Práctica 4: configurar condiciones

Archivo:

```text
05-condiciones-expresiones.md
```

Actividades:

- Utilizar una expresión matemática.
- Configurar una reducción.
- Comparar con un umbral.
- Probar ausencia de datos.
- Revisar errores de evaluación.

### Práctica 5: configurar contactos

Archivos:

```text
07-contactos-notificacion.md
08-correo-electronico.md
09-otras-notificaciones.md
```

Actividades:

- Crear un contacto.
- Configurar correo.
- Probar un webhook.
- Revisar la entrega.
- Diagnosticar un fallo.

### Práctica 6: crear políticas

Archivo:

```text
10-politicas-notificacion.md
```

Actividades:

- Crear una ruta.
- Enrutar por severidad.
- Agrupar alertas.
- Configurar repetición.
- Probar rutas diferentes.

### Práctica 7: silenciar alertas

Archivo:

```text
11-silenciados.md
```

Actividades:

- Crear un silencio.
- Limitarlo mediante etiquetas.
- Añadir un motivo.
- Definir una finalización.
- Comprobar la recuperación de las notificaciones.

### Práctica 8: laboratorio integrador

Archivo:

```text
12-laboratorio.md
```

Actividades:

- Crear una regla completa.
- Probarla.
- Recibir una notificación.
- Crear una anotación.
- Crear un silencio.
- Documentar todo el proceso.

---

## Ejemplos de sesión

### Sesión 1: identificar métricas para alertas

#### Objetivo

Localizar métricas adecuadas para crear reglas.

#### Consultas

Disponibilidad:

```promql
up
```

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Uso de memoria:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Uso del sistema de ficheros:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

#### Actividades

1. Ejecuta cada consulta en Explore.
2. Comprueba si devuelve datos.
3. Identifica las etiquetas.
4. Anota la unidad.
5. Propón un umbral razonable.
6. Explica qué problema detectaría cada métrica.

---

### Sesión 2: crear una alerta de disponibilidad

#### Objetivo

Detectar que un objetivo deja de estar disponible.

#### Consulta

```promql
up{job="node_exporter"}
```

#### Condición

```text
El valor es igual a 0
```

#### Duración

```text
1 minuto
```

#### Etiquetas

```text
severity = critical
team = systems
service = node-exporter
```

#### Anotaciones

```text
summary = Objetivo no disponible

description = El objetivo {{ $labels.instance }}
no está respondiendo a Prometheus.

runbook_url = https://example.com/runbooks/target-down
```

#### Actividades

1. Crea la regla.
2. Guarda la regla.
3. Detén Node Exporter:

```bash
sudo systemctl stop node_exporter
```

4. Espera el periodo de evaluación.
5. Revisa el estado.
6. Inicia Node Exporter:

```bash
sudo systemctl start node_exporter
```

7. Comprueba la recuperación.
8. Documenta los tiempos.

---

### Sesión 3: crear una alerta de CPU

#### Objetivo

Detectar un consumo sostenido de CPU.

#### Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

#### Condición

```text
Valor mayor que 90
```

#### Duración

```text
5 minutos
```

#### Etiquetas

```text
severity = warning
team = systems
resource = cpu
```

#### Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante el periodo configurado.

runbook_url = https://example.com/runbooks/high-cpu
```

#### Actividades

1. Crea la regla.
2. Genera carga controlada.
3. Observa el estado `Pending`.
4. Mantén la carga el tiempo necesario.
5. Observa el estado `Alerting`.
6. Detén la carga.
7. Comprueba la recuperación.

---

### Sesión 4: crear una alerta de almacenamiento

#### Objetivo

Detectar un sistema de ficheros con ocupación elevada.

#### Consulta

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

#### Condición

```text
Valor mayor que 80
```

#### Etiquetas

```text
severity = warning
team = systems
resource = filesystem
mountpoint = /
```

#### Anotaciones

```text
summary = Sistema de ficheros con ocupación elevada

description = El sistema de ficheros {{ $labels.mountpoint }}
de {{ $labels.instance }} supera el 80 % de uso.
```

#### Actividades

1. Crea la regla.
2. Comprueba la unidad.
3. Revisa las etiquetas.
4. Comprueba el resultado en una tabla.
5. Explica por qué se excluyen `tmpfs` y `overlay`.

---

### Sesión 5: crear una anotación manual

#### Objetivo

Registrar un evento visible sobre un gráfico.

#### Evento

```text
Inicio de prueba de carga de CPU
```

#### Pasos

1. Abrir un panel Time series.
2. Seleccionar la opción de añadir anotación.
3. Introducir el texto:

```text
Inicio de prueba de carga de CPU
```

4. Añadir etiquetas:

```text
tipo = laboratorio
componente = cpu
```

5. Guardar la anotación.
6. Ejecutar la carga.
7. Añadir otra anotación:

```text
Fin de prueba de carga de CPU
```

#### Actividades

1. Compara la posición de las anotaciones con la gráfica.
2. Explica qué relación existe entre el evento y el incremento de CPU.
3. Utiliza etiquetas para filtrar las anotaciones.

---

### Sesión 6: configurar un contacto de correo

#### Objetivo

Crear un contacto de notificación para pruebas.

#### Requisitos

- Cuenta de correo autorizada.
- Configuración SMTP disponible.
- Dirección de destino válida.
- Permisos administrativos.

#### Pasos

1. Acceder a los contactos de notificación.
2. Crear un contacto.
3. Seleccionar correo electrónico.
4. Introducir una dirección autorizada.
5. Guardar.
6. Ejecutar una prueba de envío.
7. Revisar la bandeja de entrada.
8. Revisar la carpeta de correo no deseado.
9. Revisar los logs si no llega.

#### Actividades

Documentar:

```text
Nombre del contacto:

Tipo:

Destinatario:

Fecha de la prueba:

Resultado:

Tiempo de entrega:

Problemas encontrados:
```

No incluir contraseñas SMTP en el dashboard, en capturas ni en el repositorio.

---

### Sesión 7: configurar un webhook

#### Objetivo

Enviar una notificación a un endpoint de laboratorio.

#### Requisitos

- Endpoint autorizado.
- URL válida.
- Método de autenticación definido.
- Entorno de pruebas.

#### Pasos

1. Crear un contacto de tipo webhook.
2. Introducir la URL.
3. Configurar la autenticación si procede.
4. Guardar.
5. Ejecutar una prueba.
6. Revisar la respuesta.
7. Activar una alerta de laboratorio.
8. Comprobar la recepción.

#### Actividades

1. Registra el código de respuesta.
2. Registra el cuerpo recibido.
3. Comprueba el formato.
4. Documenta cualquier error.
5. Elimina los tokens de las evidencias.

---

### Sesión 8: enrutar alertas por severidad

#### Objetivo

Enviar alertas según su nivel de severidad.

#### Etiquetas

Alerta de advertencia:

```text
severity = warning
```

Alerta crítica:

```text
severity = critical
```

#### Políticas

```text
warning:
  contacto = equipo-sistemas

critical:
  contacto = equipo-guardia
```

#### Actividades

1. Crea dos contactos de laboratorio.
2. Crea una ruta para `warning`.
3. Crea una ruta para `critical`.
4. Crea una alerta de prueba para cada nivel.
5. Comprueba el contacto utilizado.
6. Documenta el resultado.

---

### Sesión 9: agrupar alertas

#### Objetivo

Evitar recibir una notificación individual por cada instancia cuando varias presentan el mismo problema.

#### Escenario

```text
Tres servidores presentan CPU elevada.
```

#### Agrupación posible

Agrupar por:

```text
alertname
team
```

#### Actividades

1. Crear varias alertas con la misma etiqueta `alertname`.
2. Configurar la agrupación.
3. Activar las alertas.
4. Comprobar el mensaje recibido.
5. Explicar qué información se conserva.
6. Evaluar si la agrupación facilita o dificulta la respuesta.

---

### Sesión 10: crear un silencio temporal

#### Objetivo

Silenciar una alerta durante una prueba autorizada.

#### Escenario

```text
Se realizará mantenimiento sobre server-01.
```

#### Coincidencias

```text
instance = server-01:9100
```

#### Motivo

```text
Mantenimiento programado del laboratorio
```

#### Duración

```text
30 minutos
```

#### Actividades

1. Crear el silencio.
2. Añadir el motivo.
3. Añadir el responsable.
4. Ejecutar la prueba.
5. Comprobar que la alerta puede seguir evaluándose.
6. Comprobar que no se envían notificaciones.
7. Esperar la finalización.
8. Comprobar la recuperación de las notificaciones.

---

## Buenas prácticas

### Diseñar alertas accionables

Una alerta debe indicar:

- Qué ocurre.
- Dónde ocurre.
- Desde cuándo ocurre.
- Qué nivel de severidad tiene.
- Qué debe revisarse.
- Dónde encontrar el procedimiento.

### Evitar alertas demasiado sensibles

Una regla que se activa ante cada variación pequeña produce ruido.

Utilizar:

- Duraciones.
- Ventanas de evaluación.
- Umbrales razonables.
- Agregaciones.
- Filtros.

### Evitar alertas demasiado tolerantes

Una regla que tarda demasiado en activarse puede retrasar la respuesta.

El tiempo debe adaptarse al problema:

```text
Disponibilidad: intervalos cortos
CPU: varios minutos
Almacenamiento: periodos más amplios
Tareas programadas: según la duración esperada
```

### Utilizar etiquetas consistentes

Ejemplo:

```text
severity
team
service
environment
instance
```

No mezclar nombres equivalentes sin necesidad:

```text
team
owner
responsible_team
```

Elegir una convención y mantenerla.

### Escribir anotaciones útiles

Evitar:

```text
Problema detectado
```

Preferir:

```text
La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.
```

### Probar las alertas

Una alerta no está terminada cuando se guarda. Debe probarse.

Comprobar:

- Activación.
- Notificación.
- Contenido.
- Enrutamiento.
- Recuperación.
- Comportamiento ante ausencia de datos.

### Revisar silenciamientos

Los silenciamientos deben expirar.

Revisar periódicamente:

- Silencios activos.
- Motivos.
- Responsables.
- Fechas de finalización.
- Alcance.

### Proteger los contactos

No incluir:

- Contraseñas.
- Tokens.
- Claves privadas.
- URLs con credenciales.
- Datos personales innecesarios.

---

## Errores frecuentes

### La alerta no se activa

Comprobar:

- La consulta devuelve datos.
- La condición está correctamente configurada.
- El umbral utiliza la misma unidad.
- La duración ha transcurrido.
- La regla está habilitada.
- La evaluación se ejecuta.
- No existe un filtro incorrecto.

### La alerta se activa demasiado pronto

Comprobar:

- Duración.
- Intervalo de evaluación.
- Fluctuaciones de la métrica.
- Ausencia de agregación.
- Umbral demasiado sensible.

### La notificación no llega

Comprobar:

- Contacto.
- Dirección.
- SMTP.
- Webhook.
- Política.
- Coincidencia de etiquetas.
- Silenciamientos.
- Agrupación.
- Logs.

### La alerta aparece como `No data`

Comprobar:

- La métrica existe.
- El objetivo está disponible.
- El rango temporal contiene datos.
- La consulta no filtra demasiado.
- Prometheus responde.
- La política de ausencia de datos está definida.

### La alerta aparece como `Error`

Comprobar:

- Sintaxis PromQL.
- Expresiones.
- Fuente de datos.
- Permisos.
- Logs.
- Variables.
- Transformaciones.

### La política no enruta correctamente

Comprobar:

- Nombre de la etiqueta.
- Valor de la etiqueta.
- Coincidencia exacta.
- Orden de las rutas.
- Ruta predeterminada.
- Contacto asignado.

### El silencio no funciona

Comprobar:

- Etiquetas coincidentes.
- Fecha de inicio.
- Fecha de finalización.
- Zona horaria.
- Regla afectada.
- Alcance del silencio.

---

## Seguridad

Las alertas y notificaciones pueden contener información sensible.

Revisar:

- Direcciones internas.
- Nombres de servidores.
- Nombres de clientes.
- Mensajes de error.
- URLs internas.
- Datos de contacto.
- Tokens.
- Credenciales.
- Información de infraestructura.

### Recomendaciones

- Utilizar contactos de prueba.
- No enviar datos de producción a cuentas personales.
- Proteger los webhooks.
- Limitar permisos.
- Revisar los destinatarios.
- No incluir secretos en las anotaciones.
- Auditar las políticas.
- Retirar contactos no utilizados.
- Probar en laboratorio antes de producción.

---

## Evidencias recomendadas

Conservar:

```text
01-consulta-metrica.png
02-regla-cpu.png
03-regla-disponibilidad.png
04-anotacion-manual.png
05-contacto-notificacion.png
06-prueba-correo.png
07-politica-severidad.png
08-alerta-pending.png
09-alerta-firing.png
10-alerta-resuelta.png
11-silencio-activo.png
12-dashboard-final.png
```

Guardar también las consultas:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/anotaciones-alertas
```

```bash
cat > ~/laboratorio-grafana/evidencias/anotaciones-alertas/consultas.txt <<'EOF'
Disponibilidad:
up

CPU:
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)

Memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Disco:
100 * (
  1 -
  node_filesystem_avail_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
EOF
```

Crear un registro de reglas:

```bash
cat > ~/laboratorio-grafana/evidencias/anotaciones-alertas/reglas.txt <<'EOF'
Regla:

Objetivo:

Consulta:

Condición:

Duración:

Etiquetas:

Anotaciones:

Contacto:

Política:

Prueba realizada:

Resultado:
EOF
```

---

## Práctica integradora

### Objetivo

Crear y probar un sistema completo de alertas para un servidor Linux.

### Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Node Exporter disponible.
- Permisos para crear reglas.
- Contacto de notificación de laboratorio.
- Entorno autorizado para detener servicios y generar carga.

### Tareas

#### 1. Crear la regla de disponibilidad

Consulta:

```promql
up{job="node_exporter"}
```

Condición:

```text
Igual a 0
```

Duración:

```text
1 minuto
```

#### 2. Crear la regla de CPU

Consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Condición:

```text
Mayor que 90
```

Duración:

```text
5 minutos
```

#### 3. Añadir etiquetas

```text
team = systems
environment = laboratory
severity = warning
```

#### 4. Añadir anotaciones

```text
summary = Problema detectado en {{ $labels.instance }}

description = La métrica ha superado el umbral configurado.

environment = laboratory
```

#### 5. Crear el contacto

Utilizar un destinatario de laboratorio.

#### 6. Crear la política

Configurar el enrutamiento para las alertas:

```text
team = systems
```

#### 7. Probar la alerta de disponibilidad

```bash
sudo systemctl stop node_exporter
```

Esperar la activación y registrar el resultado.

Iniciar de nuevo:

```bash
sudo systemctl start node_exporter
```

#### 8. Probar la alerta de CPU

```bash
stress-ng --cpu 1 --timeout 60s
```

Observar:

- Estado `Pending`.
- Estado `Alerting`.
- Notificación.
- Resolución.

#### 9. Crear una anotación

Registrar:

```text
Inicio de prueba de carga
```

y:

```text
Fin de prueba de carga
```

#### 10. Crear un silencio

Silenciar temporalmente la alerta durante una nueva prueba controlada.

#### 11. Documentar

Registrar:

- Regla.
- Consulta.
- Umbral.
- Duración.
- Etiquetas.
- Contacto.
- Política.
- Resultado.
- Evidencias.
- Problemas encontrados.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Métrica identificada | | |
| Consulta validada | | |
| Regla de disponibilidad creada | | |
| Regla de CPU creada | | |
| Umbrales configurados | | |
| Duraciones configuradas | | |
| Etiquetas añadidas | | |
| Anotaciones añadidas | | |
| Contacto creado | | |
| Notificación probada | | |
| Política creada | | |
| Alerta `Pending` observada | | |
| Alerta `Alerting` observada | | |
| Alerta resuelta | | |
| Anotación manual creada | | |
| Silencio creado | | |
| Silencio revisado | | |
| Evidencias guardadas | | |
| Informe completado | | |

---

## Preguntas de comprobación

1. ¿Qué diferencia existe entre una métrica y una alerta?
2. ¿Qué diferencia existe entre una alerta y una notificación?
3. ¿Qué finalidad tiene una anotación?
4. ¿Qué elementos forman una regla de alerta?
5. ¿Qué significa el estado `Pending`?
6. ¿Qué diferencia existe entre `Alerting` y `Normal`?
7. ¿Qué puede provocar un estado `No data`?
8. ¿Qué función cumplen las etiquetas?
9. ¿Qué función cumplen las anotaciones de una regla?
10. ¿Por qué es importante configurar una duración?
11. ¿Qué ventajas tiene utilizar etiquetas de severidad?
12. ¿Qué es un contacto de notificación?
13. ¿Qué función cumple una política de notificación?
14. ¿Cómo se puede enrutar una alerta por equipo?
15. ¿Qué es un silenciamiento?
16. ¿Por qué un silencio debe tener una fecha de finalización?
17. ¿Cómo probarías una alerta de disponibilidad?
18. ¿Cómo probarías una alerta de CPU?
19. ¿Qué revisarías si una alerta no se activa?
20. ¿Qué revisarías si la notificación no llega?
21. ¿Qué revisarías si aparece `No data`?
22. ¿Qué información debe incluir un runbook?
23. ¿Qué información nunca debe incluirse en una notificación?
24. ¿Qué evidencias guardarías en el laboratorio?
25. ¿Qué características debe tener una alerta accionable?

---

## Resultado esperado

Al finalizar este bloque, el alumno debe ser capaz de construir un flujo completo de detección y respuesta:

```text
Identificar una métrica
        |
        v
Validar una consulta
        |
        v
Definir una condición
        |
        v
Crear una regla
        |
        v
Añadir etiquetas y anotaciones
        |
        v
Configurar un contacto
        |
        v
Crear una política
        |
        v
Probar la activación
        |
        v
Recibir la notificación
        |
        v
Registrar el evento
        |
        v
Aplicar un silencio controlado
        |
        v
Comprobar la recuperación
        |
        v
Documentar el resultado
```

El resultado final debe ser un sistema de alertas que genere avisos útiles, comprensibles y accionables, evitando tanto la ausencia de señales como el exceso de notificaciones irrelevantes.