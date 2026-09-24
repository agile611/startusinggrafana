# Anotaciones

Las **anotaciones de Grafana** permiten registrar eventos sobre una línea temporal. De esta forma, es posible relacionar cambios operativos con variaciones observadas en las métricas.

Por ejemplo, una gráfica puede mostrar un aumento repentino de CPU. Sin contexto adicional, no siempre es posible saber si el incremento se debe a una incidencia, un despliegue, una copia de seguridad o una prueba de carga.

Una anotación puede registrar:

```text
Inicio de un despliegue
Reinicio de un servicio
Cambio de configuración
Inicio de una prueba de carga
Mantenimiento programado
Resolución de una incidencia
Cambio de versión
```

El resultado es una línea temporal enriquecida:

```text
Métrica de CPU
      ^
      |                 /\ 
      |                /  \
      |_______________/    \________
                      |
                      |
              Inicio de prueba de carga
                      |
                      +----------------------> Tiempo
```

Las anotaciones no sustituyen a las métricas ni a las alertas. Las complementan aportando el contexto operativo que las métricas no pueden proporcionar por sí solas.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es una anotación en Grafana.
- Diferenciar una anotación de una alerta y de una métrica.
- Crear anotaciones manuales sobre un panel.
- Consultar anotaciones en una línea temporal.
- Añadir texto descriptivo a una anotación.
- Utilizar etiquetas para clasificar anotaciones.
- Filtrar anotaciones por etiquetas.
- Relacionar anotaciones con cambios en las métricas.
- Comprender el funcionamiento de las anotaciones automáticas.
- Configurar una consulta de anotaciones cuando la versión de Grafana lo permita.
- Registrar despliegues, mantenimientos y pruebas.
- Utilizar anotaciones durante la investigación de una incidencia.
- Documentar evidencias de una práctica.
- Aplicar buenas prácticas de redacción y clasificación.
- Evitar incluir información sensible en una anotación.

---

# Introducción

Una métrica indica lo que está ocurriendo en un sistema. Una anotación indica qué evento operativo ocurrió en un momento determinado.

## Ejemplo sin anotación

Una gráfica muestra este comportamiento:

```text
10:00 - CPU: 35 %
10:05 - CPU: 38 %
10:10 - CPU: 92 %
10:15 - CPU: 90 %
10:20 - CPU: 40 %
```

Sin contexto, pueden existir varias explicaciones:

- Se ejecutó una copia de seguridad.
- Se desplegó una aplicación.
- Se realizó una prueba de carga.
- Se produjo una incidencia.
- Se ejecutó una tarea programada.
- Se modificó la configuración.

## Ejemplo con anotaciones

```text
10:09 - Inicio de despliegue de la versión 2.4.0
10:10 - CPU: 92 %
10:15 - CPU: 90 %
10:20 - Fin del despliegue
```

La relación entre el evento y la métrica es mucho más clara.

Las anotaciones ayudan a responder:

```text
¿Qué ocurrió?
¿Cuándo ocurrió?
¿Quién lo inició?
¿Qué componente estaba afectado?
¿Qué cambios se realizaron?
¿Coincide el evento con una variación de la métrica?
```

---

# Qué es una anotación

Una anotación es un evento asociado a un instante o intervalo de tiempo.

Puede contener:

- Texto descriptivo.
- Fecha y hora.
- Etiquetas.
- Información del usuario que la creó.
- Referencias a un dashboard o panel.
- Datos procedentes de una consulta.
- Información adicional del evento.

## Ejemplo

```text
Texto:
Inicio de mantenimiento de la base de datos

Etiquetas:
tipo=mantenimiento
servicio=database
entorno=laboratorio

Hora:
2026-09-24 18:00
```

La anotación se mostrará como una marca sobre la gráfica correspondiente.

---

# Diferencia entre métrica, alerta y anotación

| Elemento | Función | Ejemplo |
|---|---|---|
| Métrica | Medir el comportamiento del sistema | CPU al 85 % |
| Consulta | Obtener o calcular datos | `rate(...)` |
| Alerta | Detectar una condición relevante | CPU mayor que 90 % durante 5 minutos |
| Notificación | Comunicar una alerta | Enviar un correo |
| Anotación | Registrar un evento operativo | Inicio de despliegue |

## Ejemplo completo

```text
Métrica:
CPU = 93 %

Condición:
CPU > 90 %

Alerta:
CPU elevada durante 5 minutos

Notificación:
Mensaje enviado al equipo de sistemas

Anotación:
Inicio de prueba de carga
```

La alerta indica que se ha detectado una condición.

La anotación explica qué estaba ocurriendo en ese momento.

---

# Tipos de anotaciones

## Anotaciones manuales

Son creadas directamente por un usuario desde Grafana.

Ejemplos:

- Inicio de mantenimiento.
- Fin de una incidencia.
- Cambio de configuración.
- Inicio de una prueba.
- Despliegue de una nueva versión.

Son apropiadas cuando el evento no procede de un sistema automatizado o cuando se necesita añadir contexto durante una investigación.

## Anotaciones automáticas

Son generadas por una consulta o por una integración externa.

Ejemplos:

- Sistema de despliegue.
- Herramienta de control de versiones.
- Plataforma de integración continua.
- Sistema de gestión de incidencias.
- Automatización de mantenimiento.
- Herramienta de orquestación.

Una anotación automática puede incluir:

```text
Versión desplegada
Autor del cambio
Servicio afectado
Entorno
Identificador del commit
Enlace a la ejecución
```

## Anotaciones asociadas a alertas

Una alerta puede generar o mostrar información relacionada con un cambio de estado.

Ejemplos:

```text
Inicio de una alerta
Resolución de una alerta
Cambio de severidad
```

La disponibilidad de estas funciones depende de la versión y de la configuración de Grafana.

---

# Componentes de una anotación

## Texto

Debe describir el evento de forma breve y clara.

Ejemplo:

```text
Inicio de mantenimiento de Node Exporter
```

Evitar textos demasiado genéricos:

```text
Cambio
Prueba
Evento
Problema
```

## Fecha y hora

Indica cuándo ocurrió el evento.

Es importante utilizar una zona horaria conocida y coherente con la configuración del equipo.

## Etiquetas

Clasifican la anotación.

Ejemplo:

```text
tipo = despliegue
servicio = api
entorno = laboratorio
version = 2.4.0
```

## Duración

Algunos eventos tienen un instante concreto.

Ejemplo:

```text
Reinicio del servicio
```

Otros tienen una duración:

```text
Mantenimiento de 22:00 a 23:00
```

Cuando la interfaz o la integración lo permite, se puede registrar un inicio y un final.

## Referencias

Una anotación puede incluir información adicional:

```text
https://example.com/incidencias/INC-245
https://example.com/deployments/987
```

No se deben incluir credenciales ni tokens en las URLs.

---

# Crear una anotación manual

El procedimiento exacto puede variar según la versión de Grafana y el tipo de panel.

El flujo habitual es:

1. Abrir un dashboard.
2. Seleccionar un panel con información temporal.
3. Abrir el menú de opciones del panel.
4. Seleccionar la opción relacionada con anotaciones.
5. Elegir el instante o intervalo de tiempo.
6. Introducir el texto del evento.
7. Añadir etiquetas.
8. Guardar la anotación.
9. Comprobar que aparece sobre la gráfica.

En algunas instalaciones también es posible añadir anotaciones desde una opción general del dashboard o desde una vista temporal.

## Datos de ejemplo

```text
Texto:
Inicio de prueba de carga de CPU

Etiquetas:
tipo=prueba
componente=cpu
entorno=laboratorio
```

Después de guardar, la anotación debe aparecer como una marca o línea vertical en el momento seleccionado.

---

# Consultar anotaciones

Las anotaciones pueden visualizarse sobre un panel temporal.

Para analizarlas correctamente:

1. Seleccionar un rango temporal que incluya el evento.
2. Comprobar que la anotación aparece en la gráfica.
3. Pasar el cursor sobre la marca.
4. Leer el texto y las etiquetas.
5. Comparar el momento del evento con las métricas.
6. Repetir la consulta utilizando otros rangos.
7. Filtrar por tipo de evento si existe esa posibilidad.

## Ejemplo

```text
10:00 - CPU normal
10:10 - Inicio de prueba de carga
10:11 - Incremento de CPU
10:15 - Fin de prueba de carga
10:16 - CPU normal
```

La anotación permite establecer una relación temporal entre la prueba y el incremento de CPU.

---

# Etiquetas de anotaciones

Las etiquetas permiten clasificar los eventos y facilitar su búsqueda.

## Ejemplo de etiquetas

```text
tipo = despliegue
servicio = api
entorno = laboratorio
version = 2.4.0
```

## Categorías recomendadas

### Tipo de evento

```text
tipo = despliegue
tipo = mantenimiento
tipo = incidente
tipo = prueba
tipo = cambio-configuracion
tipo = reinicio
```

### Entorno

```text
entorno = desarrollo
entorno = laboratorio
entorno = preproduccion
entorno = produccion
```

### Servicio

```text
servicio = api
servicio = base-datos
servicio = node-exporter
servicio = frontend
```

### Equipo

```text
equipo = sistemas
equipo = desarrollo
equipo = operaciones
```

## Buenas prácticas

- Utilizar nombres consistentes.
- Evitar acentos en los nombres técnicos si la herramienta los procesa automáticamente.
- Utilizar valores sencillos.
- No crear una etiqueta distinta para cada variación ortográfica.
- No introducir información sensible.
- Documentar las etiquetas acordadas.

---

# Ejemplos de anotaciones

## Despliegue

```text
Texto:
Despliegue de la versión 2.4.0 de la API

Etiquetas:
tipo=despliegue
servicio=api
entorno=produccion
version=2.4.0
```

## Mantenimiento

```text
Texto:
Inicio de mantenimiento programado de la base de datos

Etiquetas:
tipo=mantenimiento
servicio=base-datos
entorno=produccion
```

## Prueba de carga

```text
Texto:
Inicio de prueba de carga sobre el endpoint /api/orders

Etiquetas:
tipo=prueba
servicio=api
endpoint=orders
entorno=laboratorio
```

## Reinicio

```text
Texto:
Reinicio de Node Exporter para validar la alerta de disponibilidad

Etiquetas:
tipo=reinicio
servicio=node-exporter
entorno=laboratorio
```

## Resolución de incidencia

```text
Texto:
Incidencia resuelta: recuperación de la conectividad con Prometheus

Etiquetas:
tipo=incidente
estado=resuelto
servicio=prometheus
```

## Cambio de configuración

```text
Texto:
Actualización del intervalo de evaluación de las alertas

Etiquetas:
tipo=cambio-configuracion
componente=alerting
entorno=laboratorio
```

---

# Relación entre anotaciones y métricas

Las anotaciones permiten comparar eventos operativos con series temporales.

## Ejemplo: despliegue y errores

Consulta de tasa de errores:

```promql
sum(
  rate(http_requests_total{status=~"5.."}[5m])
)
```

Consulta de peticiones totales:

```promql
sum(
  rate(http_requests_total[5m])
)
```

Porcentaje de errores:

```promql
100 *
sum(
  rate(http_requests_total{status=~"5.."}[5m])
)
/
sum(
  rate(http_requests_total[5m])
)
```

Si se crea una anotación en el momento del despliegue, se puede comprobar si el porcentaje de errores cambió inmediatamente después.

## Método de análisis

```text
1. Seleccionar el rango temporal.
2. Localizar la anotación.
3. Observar la métrica antes del evento.
4. Observar la métrica después del evento.
5. Comparar el comportamiento.
6. Formular una hipótesis.
7. Validar la hipótesis con otros datos.
```

Una coincidencia temporal no demuestra por sí sola una relación causal. Es una pista que debe contrastarse.

---

# Relación entre anotaciones y alertas

Una alerta responde a:

```text
¿Se cumple una condición técnica?
```

Una anotación responde a:

```text
¿Qué evento operativo ocurrió en ese momento?
```

## Ejemplo

```text
14:00 - Despliegue de la versión 3.1.0
14:02 - Aumento de la latencia
14:05 - Alerta de latencia elevada
14:10 - Rollback
14:12 - Latencia normalizada
```

Las anotaciones ayudan a reconstruir la secuencia de una incidencia.

## Línea temporal de una incidencia

```text
14:00  Despliegue iniciado
14:02  Latencia comienza a aumentar
14:05  Alerta HighLatency activa
14:06  Investigación iniciada
14:10  Rollback ejecutado
14:12  Alerta resuelta
14:15  Incidencia cerrada
```

Esta línea temporal es útil para:

- Analizar la causa.
- Calcular tiempos de respuesta.
- Identificar cambios relacionados.
- Preparar un informe posterior.
- Mejorar los procedimientos.

---

# Anotaciones automáticas mediante consultas

Grafana puede utilizar una consulta de anotaciones para encontrar eventos en una fuente de datos compatible.

El procedimiento general consiste en:

1. Acceder a la configuración de anotaciones.
2. Crear una definición de anotación.
3. Seleccionar la fuente de datos.
4. Introducir una consulta.
5. Definir el campo temporal.
6. Definir el texto del evento.
7. Definir las etiquetas.
8. Guardar la configuración.
9. Activar la visualización sobre los paneles.

La sintaxis exacta depende de la fuente de datos.

## Ejemplo conceptual con SQL

Supóngase una tabla:

```sql
CREATE TABLE deployments (
    id INTEGER,
    deployed_at TIMESTAMP,
    service VARCHAR(100),
    version VARCHAR(50),
    environment VARCHAR(50)
);
```

Consulta de anotaciones:

```sql
SELECT
  deployed_at AS time,
  CONCAT(
    'Despliegue de ',
    service,
    ' versión ',
    version
  ) AS text,
  service,
  version,
  environment
FROM deployments
WHERE environment = 'laboratorio'
ORDER BY deployed_at;
```

La consulta proporciona:

```text
time  → momento del evento
text  → descripción
service, version, environment → etiquetas
```

Los nombres de las columnas y el formato esperado pueden variar según la versión y el conector utilizado.

---

# Ejemplo conceptual con una API de despliegues

Una plataforma de despliegue puede enviar un evento con esta información:

```json
{
  "timestamp": "2026-09-24T16:00:00Z",
  "service": "orders-api",
  "version": "2.4.0",
  "environment": "laboratory",
  "author": "deployment-bot"
}
```

La anotación podría mostrar:

```text
Despliegue de orders-api versión 2.4.0
```

Y utilizar estas etiquetas:

```text
tipo=despliegue
servicio=orders-api
version=2.4.0
entorno=laboratorio
```

No se deben enviar contraseñas, tokens ni información privada dentro de la anotación.

---

# Anotaciones durante una incidencia

Durante una investigación, las anotaciones ayudan a construir una línea temporal.

## Eventos recomendados

```text
Incidencia detectada
Investigación iniciada
Equipo de desarrollo avisado
Cambio aplicado
Servicio reiniciado
Prueba de validación iniciada
Métrica normalizada
Incidencia resuelta
```

## Ejemplo

```text
09:15 - Alerta de latencia elevada
09:17 - Investigación iniciada
09:22 - Se identifica una consulta lenta
09:28 - Se aplica una configuración temporal
09:31 - Latencia normalizada
09:40 - Incidencia cerrada
```

## Recomendación

Las anotaciones deben registrarse en el momento del evento o poco después. Las anotaciones creadas muchas horas más tarde pueden perder precisión.

---

# Ejemplo de sesión 1: crear una anotación manual

## Objetivo

Crear una anotación sobre el inicio de una prueba de carga.

## Requisitos

- Grafana funcionando.
- Un dashboard con un panel Time series.
- Una métrica de CPU disponible.
- Permisos para crear anotaciones.

## Consulta del panel

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Pasos

1. Abrir Grafana.
2. Abrir un dashboard de laboratorio.
3. Seleccionar el panel de CPU.
4. Seleccionar la opción para añadir una anotación.
5. Elegir el momento actual.
6. Introducir:

```text
Inicio de prueba de carga de CPU
```

7. Añadir:

```text
tipo=prueba
componente=cpu
entorno=laboratorio
```

8. Guardar la anotación.
9. Comprobar que aparece sobre el panel.

## Resultado esperado

Debe aparecer una marca en la línea temporal con el texto y las etiquetas configuradas.

---

# Ejemplo de sesión 2: relacionar una anotación con una métrica

## Objetivo

Observar el efecto de una prueba sobre el uso de CPU.

## Pasos

1. Abrir el panel de CPU.
2. Seleccionar un rango temporal de 15 minutos.
3. Crear la anotación:

```text
Inicio de carga de CPU
```

4. Ejecutar una carga controlada en el laboratorio:

```bash
stress-ng --cpu 1 --timeout 60s
```

5. Esperar a que la métrica refleje el incremento.
6. Crear una segunda anotación:

```text
Fin de carga de CPU
```

7. Añadir las etiquetas:

```text
tipo=prueba
fase=fin
entorno=laboratorio
```

8. Comparar la gráfica antes, durante y después de la prueba.

## Registro

```text
Hora de inicio:

Hora de fin:

Valor de CPU antes:

Valor máximo observado:

Valor de CPU después:

Relación observada:

Observaciones:
```

## Preguntas de análisis

- ¿La métrica aumentó después de la primera anotación?
- ¿Cuánto tiempo tardó en reflejarse el cambio?
- ¿Cuánto tardó en volver a los valores normales?
- ¿La gráfica muestra algún retraso?
- ¿La duración de la prueba fue suficiente?

---

# Ejemplo de sesión 3: documentar un despliegue

## Objetivo

Registrar un despliegue y analizar sus efectos.

## Evento

```text
Despliegue de la versión 2.4.0 de la API
```

## Etiquetas

```text
tipo=despliegue
servicio=api
version=2.4.0
entorno=laboratorio
```

## Pasos

1. Abrir el dashboard de la aplicación.
2. Seleccionar un rango de 30 minutos.
3. Crear la anotación justo antes del despliegue.
4. Ejecutar el despliegue de laboratorio.
5. Observar:
   - Latencia.
   - Tasa de errores.
   - Peticiones por segundo.
   - Uso de CPU.
   - Uso de memoria.
6. Crear una anotación al finalizar:

```text
Fin del despliegue de la versión 2.4.0
```

7. Comparar las métricas antes y después.
8. Documentar cualquier variación.

## Resultado esperado

El alumno debe poder identificar si las métricas presentan cambios coincidentes con el despliegue.

---

# Ejemplo de sesión 4: documentar un mantenimiento

## Objetivo

Registrar el inicio y el final de una ventana de mantenimiento.

## Inicio

```text
Inicio de mantenimiento de Prometheus
```

Etiquetas:

```text
tipo=mantenimiento
servicio=prometheus
entorno=laboratorio
fase=inicio
```

## Final

```text
Fin de mantenimiento de Prometheus
```

Etiquetas:

```text
tipo=mantenimiento
servicio=prometheus
entorno=laboratorio
fase=fin
```

## Pasos

1. Crear la anotación de inicio.
2. Ejecutar el mantenimiento autorizado.
3. Observar las métricas afectadas.
4. Restaurar el servicio.
5. Crear la anotación de finalización.
6. Comparar la disponibilidad antes y después.

## Actividad

Crear una tabla:

| Evento | Hora | Métrica afectada | Observaciones |
|---|---|---|---|
| Inicio del mantenimiento | | | |
| Servicio detenido | | | |
| Servicio restaurado | | | |
| Fin del mantenimiento | | | |

---

# Ejemplo de sesión 5: relacionar una alerta con anotaciones

## Objetivo

Comprender cómo una anotación ayuda a interpretar una alerta.

## Regla

```text
Nombre: HighCPUUsage
Condición: CPU mayor que 90 %
Duración: 5 minutos
```

## Secuencia

```text
10:00 - Inicio de prueba de carga
10:02 - CPU supera el 90 %
10:05 - Alerta HighCPUUsage activa
10:06 - Fin de prueba de carga
10:08 - CPU normalizada
10:10 - Alerta resuelta
```

## Pasos

1. Crear la regla de CPU.
2. Crear la anotación de inicio.
3. Ejecutar la carga.
4. Observar el estado `Pending`.
5. Observar el estado `Alerting`.
6. Crear la anotación de fin.
7. Esperar la resolución.
8. Comparar la línea temporal completa.

## Actividad

Explicar por escrito:

```text
¿Qué ocurrió antes de que se activara la alerta?

¿Qué evento coincide con el inicio del problema?

¿Qué evento coincide con la recuperación?

¿La alerta representa una incidencia real o una prueba controlada?

¿Qué información adicional sería útil?
```

---

# Ejemplo de sesión 6: filtrar anotaciones por etiquetas

## Objetivo

Consultar únicamente anotaciones de un tipo concreto.

## Anotaciones de ejemplo

```text
tipo=despliegue
tipo=mantenimiento
tipo=prueba
tipo=incidente
```

## Pasos

1. Crear varias anotaciones.
2. Utilizar etiquetas diferentes.
3. Abrir el panel o dashboard.
4. Configurar el filtro de anotaciones.
5. Mostrar solo:

```text
tipo=despliegue
```

6. Cambiar el filtro a:

```text
tipo=incidente
```

7. Comparar los resultados.

## Actividad

Completar:

```text
Filtro utilizado:

Número de anotaciones encontradas:

Eventos relacionados:

Periodo consultado:

Observaciones:
```

---

# Ejemplo de sesión 7: crear anotaciones desde una tabla de eventos

## Objetivo

Utilizar una fuente de datos de eventos para mostrar anotaciones automáticas.

## Tabla de ejemplo

```sql
CREATE TABLE events (
    event_time TIMESTAMP,
    event_text VARCHAR(255),
    event_type VARCHAR(50),
    service VARCHAR(100),
    environment VARCHAR(50)
);
```

## Datos de ejemplo

```sql
INSERT INTO events (
    event_time,
    event_text,
    event_type,
    service,
    environment
)
VALUES
(
    CURRENT_TIMESTAMP,
    'Inicio de despliegue de la API',
    'deploy',
    'api',
    'laboratory'
);
```

## Consulta

```sql
SELECT
  event_time AS time,
  event_text AS text,
  event_type,
  service,
  environment
FROM events
WHERE environment = 'laboratory'
ORDER BY event_time;
```

## Actividades

1. Crear la tabla.
2. Insertar un evento.
3. Configurar la consulta de anotaciones.
4. Mostrar el evento en un dashboard.
5. Insertar un segundo evento.
6. Actualizar el dashboard.
7. Verificar la nueva anotación.
8. Filtrar por `event_type`.

La sintaxis puede necesitar ajustes según el motor SQL y el conector de Grafana utilizado.

---

# Ejemplo de sesión 8: construir la línea temporal de una incidencia

## Objetivo

Documentar una incidencia desde la detección hasta la resolución.

## Escenario

La latencia de una aplicación aumenta y activa una alerta.

## Anotaciones

```text
Incidencia detectada
```

```text
Investigación iniciada
```

```text
Se identifica una consulta lenta
```

```text
Se aplica una corrección temporal
```

```text
Latencia normalizada
```

```text
Incidencia resuelta
```

## Etiquetas

```text
tipo=incidente
servicio=api
entorno=laboratorio
incidencia=INC-001
```

## Actividades

1. Crear el panel de latencia.
2. Crear una alerta de latencia.
3. Crear una anotación cuando la alerta se active.
4. Añadir una anotación al comenzar la investigación.
5. Añadir una anotación al aplicar la corrección.
6. Añadir una anotación al resolver la incidencia.
7. Analizar el intervalo completo.
8. Calcular aproximadamente el tiempo de respuesta.

## Registro

```text
Hora de detección:

Hora de inicio de investigación:

Hora de aplicación de la corrección:

Hora de recuperación:

Hora de cierre:

Tiempo hasta iniciar la investigación:

Tiempo total de la incidencia:
```

---

# Buenas prácticas

## Escribir textos claros

Preferir:

```text
Inicio de despliegue de la versión 2.4.0 de la API
```

Evitar:

```text
Deploy
```

El texto debe ser comprensible para cualquier persona que consulte el dashboard.

## Registrar el contexto mínimo necesario

Una anotación debería indicar:

- Qué ocurrió.
- Qué servicio está implicado.
- Qué entorno está afectado.
- Qué versión o cambio se aplicó.
- Quién o qué sistema generó el evento, cuando sea relevante.

## Utilizar etiquetas consistentes

Mantener una convención:

```text
tipo
servicio
entorno
version
equipo
estado
```

## Separar inicio y final

Para eventos largos, crear anotaciones diferentes:

```text
Inicio de mantenimiento
Fin de mantenimiento
```

Esto permite conocer la duración aproximada del evento.

## Registrar cambios importantes

No es necesario anotar cada acción menor. Priorizar:

- Despliegues.
- Cambios de configuración.
- Mantenimientos.
- Incidencias.
- Reinicios.
- Pruebas.
- Cambios de infraestructura.

## Utilizar anotaciones durante las investigaciones

Registrar los pasos importantes facilita reconstruir posteriormente la incidencia.

## Mantener una zona horaria coherente

Una diferencia de zona horaria puede provocar conclusiones incorrectas sobre la relación entre un evento y una métrica.

## Proteger la información sensible

No incluir:

- Contraseñas.
- Tokens.
- Claves privadas.
- Datos personales innecesarios.
- Información confidencial de clientes.
- URLs con credenciales.
- Mensajes completos que contengan secretos.

## Evitar anotaciones ambiguas

Una anotación debe seguir siendo útil varias semanas después.

---

# Errores frecuentes

## La anotación no aparece

Comprobar:

- El rango temporal seleccionado.
- La configuración de anotaciones del dashboard.
- El panel utilizado.
- Las etiquetas de filtrado.
- Los permisos del usuario.
- La fuente de datos.
- La hora y zona horaria.

## La anotación aparece en un momento incorrecto

Posibles causas:

- Zona horaria diferente.
- Formato de fecha incorrecto.
- Hora del sistema incorrecta.
- Conversión entre UTC y hora local.
- Marca temporal mal calculada.

## Se muestran demasiadas anotaciones

Comprobar:

- Filtros.
- Etiquetas.
- Rango temporal.
- Consulta de anotaciones.
- Eventos duplicados.
- Integraciones que reintentan el envío.

## Las etiquetas no filtran correctamente

Comprobar:

- Nombre exacto de la etiqueta.
- Valor exacto.
- Mayúsculas y minúsculas.
- Espacios.
- Convención utilizada por otros equipos.
- Etiquetas duplicadas.

## Existen anotaciones duplicadas

Posibles causas:

- El sistema reenvía el mismo evento.
- Se utiliza más de una integración.
- No existe un identificador único.
- Se ha creado una anotación manual y otra automática para el mismo evento.

## El texto no aporta información

Evitar:

```text
Cambio realizado
```

Preferir:

```text
Actualización del límite de conexiones de la API de 100 a 200
```

## Las anotaciones no coinciden con las métricas

Comprobar:

- Hora del evento.
- Zona horaria.
- Panel consultado.
- Rango temporal.
- Retraso de ingestión de la métrica.
- Retraso de la anotación.
- Fuente de datos.

---

# Seguridad y privacidad

Las anotaciones pueden ser visibles para varias personas y permanecer almacenadas durante mucho tiempo.

Antes de guardar una anotación, revisar si contiene:

```text
Contraseñas
Tokens
Claves de API
Direcciones privadas
Datos personales
Información de clientes
Detalles de vulnerabilidades
URLs con autenticación
```

## Ejemplo incorrecto

```text
Despliegue realizado con token=abc123...
```

## Ejemplo correcto

```text
Despliegue de la versión 2.4.0 realizado por el sistema de automatización
```

Si se necesita enlazar información privada, utilizar un sistema con control de acceso y una referencia segura.

---

# Evidencias de la práctica

Crear un directorio para las evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/anotaciones
```

Crear una plantilla de registro:

```bash
cat > ~/laboratorio-grafana/evidencias/anotaciones/registro.txt <<'EOF'
Anotación:

Fecha y hora:

Texto:

Etiquetas:

Dashboard:

Panel:

Evento relacionado:

Métrica observada:

Resultado:

Observaciones:
EOF
```

Crear un inventario de eventos:

```bash
cat > ~/laboratorio-grafana/evidencias/anotaciones/eventos.txt <<'EOF'
1. Inicio de prueba:

2. Fin de prueba:

3. Inicio de mantenimiento:

4. Fin de mantenimiento:

5. Inicio de despliegue:

6. Fin de despliegue:

7. Inicio de investigación:

8. Resolución de incidencia:
EOF
```

Capturas recomendadas:

```text
01-panel-sin-anotaciones.png
02-anotacion-inicio-prueba.png
03-anotacion-fin-prueba.png
04-metrica-con-anotaciones.png
05-filtro-por-etiqueta.png
06-anotacion-despliegue.png
07-linea-temporal-incidencia.png
08-anotacion-mantenimiento.png
```

---

# Práctica integradora

## Objetivo

Crear una línea temporal de eventos y relacionarla con las métricas de un servidor de laboratorio.

## Requisitos

- Grafana funcionando.
- Un dashboard con métricas de CPU.
- Prometheus o una fuente de datos configurada.
- Permisos para crear anotaciones.
- Un entorno de laboratorio.
- Una herramienta para generar carga controlada.

## Tarea 1: preparar el panel

Utilizar la consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Configurar:

```text
Título: Uso de CPU
Unidad: porcentaje
Rango temporal: últimos 30 minutos
```

## Tarea 2: crear la anotación inicial

Texto:

```text
Inicio de prueba de carga de CPU
```

Etiquetas:

```text
tipo=prueba
componente=cpu
entorno=laboratorio
fase=inicio
```

## Tarea 3: ejecutar la prueba

```bash
stress-ng --cpu 1 --timeout 60s
```

Utilizar este comando únicamente en un entorno autorizado.

## Tarea 4: crear la anotación final

Texto:

```text
Fin de prueba de carga de CPU
```

Etiquetas:

```text
tipo=prueba
componente=cpu
entorno=laboratorio
fase=fin
```

## Tarea 5: analizar la gráfica

Responder:

```text
¿Qué valor tenía la CPU antes de la prueba?

¿Cuándo comenzó a aumentar?

¿Cuál fue el valor máximo?

¿Cuánto tiempo tardó en recuperar el nivel normal?

¿Las anotaciones aparecen en los momentos correctos?
```

## Tarea 6: documentar un cambio

Crear otra anotación:

```text
Cambio de intervalo de evaluación de una regla de CPU
```

Etiquetas:

```text
tipo=cambio-configuracion
componente=alerting
entorno=laboratorio
```

## Tarea 7: construir una línea temporal

Completar:

| Hora | Evento | Métrica afectada | Observaciones |
|---|---|---|---|
| | Inicio de prueba | CPU | |
| | Incremento observado | CPU | |
| | Fin de prueba | CPU | |
| | Recuperación | CPU | |
| | Cambio de configuración | Alerting | |

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Panel temporal creado | | |
| Consulta validada | | |
| Anotación manual creada | | |
| Etiquetas añadidas | | |
| Anotación de inicio creada | | |
| Prueba de carga ejecutada | | |
| Anotación de fin creada | | |
| Métrica comparada con eventos | | |
| Anotaciones filtradas | | |
| Evento de mantenimiento registrado | | |
| Evento de despliegue registrado | | |
| Línea temporal completada | | |
| Evidencias guardadas | | |
| Información sensible revisada | | |
| Informe completado | | |

---

# Puntos clave

- Una anotación registra un evento sobre una línea temporal.
- Las anotaciones aportan contexto a las métricas.
- Una métrica muestra un valor, pero no explica necesariamente por qué cambió.
- Una alerta detecta una condición; una anotación registra un acontecimiento.
- Las anotaciones pueden ser manuales o automáticas.
- El texto debe ser breve, claro y descriptivo.
- Las etiquetas permiten clasificar y filtrar eventos.
- Los eventos de larga duración pueden registrarse con anotaciones de inicio y fin.
- Las anotaciones son útiles durante las investigaciones de incidencias.
- Un despliegue debe poder relacionarse con las métricas afectadas.
- Las zonas horarias deben estar correctamente configuradas.
- Las anotaciones duplicadas dificultan el análisis.
- Una coincidencia temporal no demuestra por sí sola una relación causal.
- No se deben incluir secretos ni datos sensibles.
- Las anotaciones deben utilizar una convención coherente.
- Los eventos importantes deben documentarse cerca del momento en que ocurren.
- Las anotaciones pueden ayudar a reconstruir una línea temporal operativa.
- Un dashboard con métricas y anotaciones facilita el análisis posterior.
- Las anotaciones deben aportar información accionable.
- Una buena anotación permite entender el contexto sin consultar sistemas adicionales.

---

# Preguntas de comprobación

1. ¿Qué es una anotación en Grafana?
2. ¿Qué diferencia existe entre una métrica y una anotación?
3. ¿Qué diferencia existe entre una alerta y una anotación?
4. ¿Para qué sirven las etiquetas de una anotación?
5. ¿Qué información debería incluir el texto de una anotación?
6. ¿Qué diferencia existe entre una anotación manual y una automática?
7. ¿Qué eventos se deberían registrar durante un despliegue?
8. ¿Por qué es útil crear anotaciones de inicio y fin?
9. ¿Cómo puede una anotación ayudar a investigar una incidencia?
10. ¿Qué problemas puede causar una zona horaria incorrecta?
11. ¿Qué comprobarías si una anotación no aparece?
12. ¿Qué comprobarías si una anotación aparece en un momento incorrecto?
13. ¿Por qué pueden aparecer anotaciones duplicadas?
14. ¿Qué etiquetas utilizarías para un mantenimiento?
15. ¿Qué etiquetas utilizarías para un despliegue?
16. ¿Cómo relacionarías una anotación con un aumento de CPU?
17. ¿Por qué una coincidencia temporal no demuestra una relación causal?
18. ¿Qué información no debe incluirse nunca en una anotación?
19. ¿Qué evidencias guardarías durante la práctica?
20. ¿Qué características debe tener una anotación útil?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear y utilizar anotaciones para enriquecer un dashboard de monitorización.

El flujo completo será:

```text
Identificar un evento
        |
        v
Seleccionar el dashboard
        |
        v
Seleccionar el panel temporal
        |
        v
Registrar la fecha y la hora
        |
        v
Escribir una descripción clara
        |
        v
Añadir etiquetas
        |
        v
Guardar la anotación
        |
        v
Compararla con las métricas
        |
        v
Analizar el efecto del evento
        |
        v
Documentar las conclusiones
```

El resultado final debe ser una línea temporal comprensible que permita relacionar eventos operativos con el comportamiento observado en las métricas.

Una anotación no explica automáticamente la causa de un problema, pero proporciona una pista temporal valiosa para investigar qué ocurrió y cuándo ocurrió.