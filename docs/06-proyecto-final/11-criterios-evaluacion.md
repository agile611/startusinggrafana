# Criterios de evaluación

Los criterios de evaluación permiten valorar de forma objetiva el proyecto final de observabilidad con Grafana, Prometheus y Node Exporter.

La evaluación no se centra únicamente en que el alumno complete una configuración. También debe demostrar que comprende el flujo completo:

```text
Preparar el entorno
        |
        v
Recopilar métricas
        |
        v
Consultar datos
        |
        v
Crear dashboards
        |
        v
Configurar alertas
        |
        v
Enviar notificaciones
        |
        v
Probar fallos controlados
        |
        v
Comprobar recuperaciones
        |
        v
Documentar la solución
```

La solución deberá ser funcional, segura, reproducible y suficientemente clara para que otra persona pueda revisarla.

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Comprender los criterios utilizados para evaluar el proyecto.
- Diferenciar una configuración funcional de una solución bien documentada.
- Identificar los requisitos técnicos y operativos de la entrega.
- Evaluar la disponibilidad de Grafana, Prometheus y Node Exporter.
- Validar consultas PromQL.
- Evaluar la calidad de un dashboard operativo.
- Revisar reglas de alerta.
- Valorar etiquetas, anotaciones y duraciones.
- Comprobar contactos y políticas de notificación.
- Analizar pruebas de activación y recuperación.
- Revisar silenciamientos.
- Valorar la calidad de las evidencias.
- Detectar problemas de seguridad en la documentación.
- Justificar decisiones técnicas.
- Identificar errores frecuentes.
- Preparar una autoevaluación.
- Utilizar una rúbrica de puntuación.
- Documentar limitaciones del entorno.
- Preparar una entrega reproducible y mantenible.

## Introducción

Un proyecto puede funcionar parcialmente y, aun así, no cumplir los criterios de calidad necesarios.

Por ejemplo:

```text
El dashboard existe, pero no tiene unidades correctas.

La alerta se activa, pero no identifica la instancia.

La notificación llega, pero al contacto equivocado.

La consulta devuelve datos, pero no está documentada.

La prueba se realiza, pero no existe evidencia.

El sistema funciona, pero quedan servicios detenidos.
```

Por este motivo, la evaluación considera varias dimensiones:

```text
Funcionamiento técnico
        |
        v
Calidad de la configuración
        |
        v
Pruebas realizadas
        |
        v
Seguridad
        |
        v
Documentación
        |
        v
Presentación final
```

## Escala de calificación

La calificación total será de:

```text
10 puntos
```

| Bloque | Puntuación |
|---|---:|
| Preparación y validación del entorno | 1,0 |
| Consultas PromQL | 1,0 |
| Dashboard operativo | 1,5 |
| Reglas de alerta | 2,0 |
| Notificaciones y políticas | 1,0 |
| Pruebas de activación y recuperación | 1,0 |
| Anotaciones y silenciamientos | 0,5 |
| Evidencias técnicas | 1,0 |
| Memoria técnica y presentación | 1,0 |
| **Total** | **10,0** |

## Niveles de desempeño

Cada apartado puede valorarse mediante cuatro niveles.

| Nivel | Descripción |
|---|---|
| Excelente | La solución funciona, está completa, justificada y documentada |
| Adecuado | La solución funciona con pequeños defectos de presentación o detalle |
| Básico | La solución funciona parcialmente o requiere correcciones importantes |
| Insuficiente | El requisito no está realizado o no puede verificarse |

### Excelente

El alumno:

- Completa el requisito.
- Explica su finalidad.
- Aporta evidencias.
- Justifica las decisiones.
- Detecta y corrige problemas.
- Mantiene una estructura clara.
- No expone información sensible.

### Adecuado

El alumno:

- Completa el requisito principal.
- Presenta evidencias suficientes.
- Tiene pequeños errores de nomenclatura o presentación.
- Puede explicar la configuración general.
- Necesita pocas correcciones.

### Básico

El alumno:

- Completa solo una parte del requisito.
- Presenta evidencias incompletas.
- Tiene consultas o reglas poco justificadas.
- No documenta todos los problemas.
- Requiere apoyo para explicar el resultado.

### Insuficiente

El alumno:

- No completa el requisito.
- No presenta evidencias.
- Configura elementos que no funcionan.
- No puede explicar las decisiones.
- Afecta a sistemas no autorizados.
- Incluye credenciales o secretos en la entrega.

## Requisitos mínimos para aprobar

Para considerar el proyecto superado, deben cumplirse como mínimo estas condiciones:

- Grafana es accesible.
- Prometheus está disponible.
- Node Exporter expone métricas.
- Prometheus recopila métricas.
- Existe un dashboard operativo.
- Se han validado consultas PromQL.
- Existe al menos una regla de alerta funcional.
- Se ha documentado una prueba de activación.
- Se ha documentado una recuperación o una prueba equivalente.
- Las evidencias están organizadas.
- No se han incluido credenciales.
- El entorno queda en un estado estable.
- La memoria técnica permite entender el trabajo realizado.

Un proyecto no debe considerarse completo únicamente porque el dashboard se visualice correctamente.

## Evaluación del entorno

### Criterios

Se evaluará si el alumno:

- Identifica la máquina de laboratorio.
- Registra las versiones utilizadas.
- Comprueba el estado de los servicios.
- Comprueba los puertos.
- Comprueba el endpoint `/metrics`.
- Comprueba los targets de Prometheus.
- Verifica la conexión entre Grafana y Prometheus.
- Documenta los permisos y limitaciones.
- Mantiene la separación entre laboratorio y producción.

### Puntuación orientativa

```text
Entorno correctamente validado:
1,0 puntos

Entorno parcialmente validado:
0,5 puntos

Entorno no validado:
0 puntos
```

### Evidencias esperadas

```text
Servicios activos.
Endpoint /metrics respondiendo.
Target de Prometheus en UP.
Fuente de datos validada.
Versiones documentadas.
```

### Errores que reducen la puntuación

```text
No se identifica el entorno.
No se documentan las versiones.
El target aparece DOWN sin explicación.
La fuente de datos no ha sido probada.
Se confunden problemas de red con problemas de PromQL.
```

## Evaluación de las consultas PromQL

### Criterios

Se evaluará si las consultas:

- Devuelven datos.
- Utilizan métricas adecuadas.
- Aplican filtros correctos.
- Conservan las etiquetas necesarias.
- Utilizan correctamente `rate`.
- Utilizan agregaciones apropiadas.
- Devuelven unidades comprensibles.
- Evitan series duplicadas.
- Excluyen sistemas de ficheros irrelevantes.
- Están documentadas.

### Consultas mínimas

Disponibilidad:

```promql
up{job="node_exporter"}
```

CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Memoria:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Almacenamiento:

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

### Puntuación orientativa

```text
Consultas completas, correctas y documentadas:
1,0 puntos

Consultas funcionales con pequeños errores:
0,75 puntos

Consultas parcialmente correctas:
0,5 puntos

Consultas inexistentes o no funcionales:
0 puntos
```

### Evidencias esperadas

```text
Capturas de Explore.
Fichero con consultas.
Registro de resultados.
Unidades documentadas.
Explicación de filtros y agregaciones.
```

### Errores frecuentes

```text
Utilizar node_cpu_seconds_total sin rate.
Confundir bytes con porcentajes.
Usar un job incorrecto.
No filtrar mountpoint.
No excluir tmpfs u overlay.
No agrupar por instance.
No documentar las etiquetas.
```

## Evaluación del dashboard operativo

### Criterios

Se evaluará si el dashboard:

- Tiene un nombre claro.
- Tiene una descripción.
- Incluye los paneles necesarios.
- Utiliza títulos comprensibles.
- Utiliza unidades correctas.
- Muestra las leyendas adecuadas.
- Utiliza colores coherentes.
- Tiene umbrales visuales.
- Incluye una variable de instancia.
- Permite seleccionar una o varias instancias.
- Muestra anotaciones.
- Tiene un rango temporal razonable.
- Tiene un intervalo de actualización adecuado.
- Es legible para otra persona.

### Paneles mínimos

```text
Disponibilidad
CPU
Memoria
Almacenamiento
```

Se recomienda añadir:

```text
Carga del sistema
Resumen por instancia
Panel de alertas
```

### Puntuación orientativa

```text
Dashboard completo, claro y operativo:
1,5 puntos

Dashboard funcional con defectos menores:
1,0 puntos

Dashboard incompleto o poco legible:
0,5 puntos

Dashboard inexistente o no funcional:
0 puntos
```

### Revisión visual

El evaluador comprobará:

```text
¿Se identifica rápidamente el estado del entorno?

¿Los paneles importantes están arriba?

¿Las unidades son correctas?

¿Las instancias aparecen en las leyendas?

¿Los colores tienen significado?

¿Se distingue cero de ausencia de datos?

¿La variable funciona?

¿Las anotaciones son visibles?
```

### Defectos que reducen la valoración

```text
Títulos genéricos.
Paneles sin unidades.
Leyendas incompletas.
Colores incoherentes.
Demasiados paneles.
Paneles duplicados.
Variable que no filtra.
Rango temporal inadecuado.
Dashboard sin descripción.
```

## Evaluación de las reglas de alerta

### Criterios

Se evaluará si las reglas:

- Detectan una condición relevante.
- Utilizan consultas validadas.
- Tienen umbrales razonables.
- Incluyen intervalos de evaluación.
- Incluyen periodos de duración.
- Utilizan nombres coherentes.
- Incluyen etiquetas.
- Incluyen anotaciones.
- Identifican la instancia.
- Definen el comportamiento ante ausencia de datos.
- Definen el comportamiento ante errores.
- Pueden probarse de forma segura.

### Reglas mínimas

```text
NodeExporterDown-Laboratory
HighCPUUsage-Laboratory
HighMemoryUsage-Laboratory
FilesystemUsageHigh-Laboratory
```

### Tabla de referencia

| Regla | Umbral | Duración | Severidad |
|---|---:|---|---|
| `NodeExporterDown-Laboratory` | `up == 0` | 1 minuto | `critical` |
| `HighCPUUsage-Laboratory` | CPU > 90 % | 5 minutos | `warning` |
| `HighMemoryUsage-Laboratory` | Memoria > 90 % | 5 minutos | `warning` |
| `FilesystemUsageHigh-Laboratory` | Disco > 80 % | 10 minutos | `warning` |

### Puntuación orientativa

```text
Reglas completas y correctamente justificadas:
2,0 puntos

Reglas funcionales con defectos menores:
1,5 puntos

Reglas parcialmente configuradas:
0,75 puntos

Reglas inexistentes o no funcionales:
0 puntos
```

### Revisión de una regla

El evaluador comprobará:

```text
Nombre:

Consulta:

Condición:

Umbral:

Intervalo:

Duración:

Etiquetas:

Anotaciones:

Ausencia de datos:

Estado inicial:

Resultado de la prueba:
```

## Evaluación de etiquetas y anotaciones

### Etiquetas esperadas

```text
alertname
severity
team
service
environment
resource
```

### Ejemplo

```text
alertname = HighCPUUsage-Laboratory
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

### Anotaciones esperadas

```text
summary
description
```

Se recomienda:

```text
runbook_url
dashboard_url
```

### Criterios

Se evaluará si:

- Las etiquetas son coherentes.
- El entorno está identificado.
- La severidad es razonable.
- El equipo responsable está definido.
- La descripción incluye la instancia.
- La alerta explica qué ocurre.
- La información es útil para actuar.

### Puntuación orientativa

Este apartado puede integrarse en la evaluación de alertas y silenciamientos.

```text
Etiquetas y anotaciones completas:
valoración máxima

Etiquetas parcialmente correctas:
valoración intermedia

Sin contexto suficiente:
valoración mínima
```

## Evaluación de notificaciones

### Contacto de laboratorio

El contacto debe:

- Existir.
- Tener un nombre descriptivo.
- Utilizar un canal autorizado.
- Haber sido probado.
- Estar documentado sin secretos.

Ejemplo:

```text
Nombre:
laboratory-observability

Tipo:
Webhook de pruebas

Finalidad:
Recibir alertas del proyecto final
```

### Política de notificación

La política debe:

- Coincidir con las etiquetas de las alertas.
- Utilizar el contacto correcto.
- Definir la agrupación.
- Definir los intervalos.
- Haber sido probada.

Ejemplo:

```text
environment = laboratory
    → laboratory-observability
```

### Puntuación orientativa

```text
Contactos y políticas funcionales:
1,0 puntos

Configuración parcialmente funcional:
0,5 puntos

Sin contacto o sin política:
0 puntos
```

### Errores frecuentes

```text
La alerta utiliza environment=lab.
La política espera environment=laboratory.

La alerta utiliza severity=critical.
La ruta solo contempla severity=warning.

El contacto existe, pero no se ha probado.

La notificación se agrupa y el alumno interpreta el retraso como un error.

Existe un silencio activo que bloquea el mensaje.
```

## Evaluación de pruebas de activación y recuperación

### Criterios

Se evaluará si el alumno:

- Define una condición inicial.
- Ejecuta una prueba autorizada.
- Registra la hora de inicio.
- Observa el estado `Pending`.
- Observa el estado `Alerting`, cuando procede.
- Comprueba la notificación.
- Recupera el servicio o la condición.
- Comprueba el estado `Normal`.
- Registra la recuperación.
- Conserva evidencias.

### Ciclo esperado

```text
Normal
   |
   v
Pending
   |
   v
Alerting
   |
   v
Normal
```

### Puntuación orientativa

```text
Activación y recuperación completas:
1,0 puntos

Prueba parcial:
0,5 puntos

Sin prueba o sin evidencias:
0 puntos
```

### Registro mínimo

```text
Regla:

Condición aplicada:

Valor inicial:

Hora de inicio:

Hora de Pending:

Hora de Alerting:

Notificación:

Acción de recuperación:

Hora de recuperación:

Estado final:

Resultado:
```

### Consideración

Si una alerta no puede activarse de forma segura, el alumno puede:

- Validar la consulta.
- Documentar la condición.
- Explicar el procedimiento.
- Utilizar una alerta de prueba.
- Demostrar el ciclo con una condición controlada.

La seguridad del entorno tiene prioridad sobre la activación artificial de una alerta.

## Evaluación de anotaciones y silenciamientos

### Anotaciones

Se evaluará si las anotaciones:

- Identifican el evento.
- Incluyen fecha y hora.
- Aportan contexto.
- Utilizan etiquetas.
- Aparecen en el dashboard.

### Silenciamientos

Se evaluará si los silenciamientos:

- Tienen coincidencias específicas.
- Tienen fecha de inicio.
- Tienen fecha de fin.
- Incluyen un comentario.
- Se aplican solo al entorno de laboratorio.
- Se relacionan con una actividad conocida.
- Se revisan al finalizar.

### Ejemplo de silencio correcto

```text
alertname = NodeExporterDown-Laboratory
instance = server-01:9100
environment = laboratory
```

### Ejemplo de silencio demasiado amplio

```text
severity = critical
```

Este silencio puede afectar a demasiadas alertas y no es adecuado para una práctica específica.

### Puntuación orientativa

```text
Anotaciones y silenciamientos completos:
0,5 puntos

Configuración parcial:
0,25 puntos

No realizados:
0 puntos
```

## Evaluación de evidencias

### Criterios

Las evidencias deben:

- Estar organizadas.
- Tener nombres descriptivos.
- Ser legibles.
- Mostrar el resultado.
- Relacionarse con un requisito.
- Pertenecer al laboratorio.
- Ocultar secretos.
- Incluir información temporal cuando sea relevante.

### Evidencias mínimas

```text
Servicios activos.
Fuente de datos validada.
Target UP.
Consulta de disponibilidad.
Consulta de CPU.
Consulta de memoria.
Consulta de almacenamiento.
Dashboard operativo.
Variable de instancia.
Reglas de alerta.
Contacto.
Política.
Estado Pending.
Estado Alerting.
Recuperación.
Silenciamiento.
```

### Puntuación orientativa

```text
Evidencias completas, claras y seguras:
1,0 puntos

Evidencias suficientes con pequeños defectos:
0,75 puntos

Evidencias incompletas:
0,5 puntos

Sin evidencias verificables:
0 puntos
```

### Nombres recomendados

```text
01-entorno-validado.png
02-fuente-prometheus.png
03-target-up.png
04-consulta-up.png
05-consulta-cpu.png
06-consulta-memoria.png
07-consulta-almacenamiento.png
08-dashboard-operativo.png
09-variable-instance.png
10-regla-disponibilidad.png
11-regla-cpu.png
12-regla-memoria.png
13-regla-almacenamiento.png
14-contacto.png
15-politica.png
16-alerta-pending.png
17-alerta-alerting.png
18-notificacion.png
19-alerta-recuperada.png
20-silenciamiento.png
```

## Evaluación de la memoria técnica

### Criterios

La memoria debe incluir:

- Identificación del alumno.
- Descripción del entorno.
- Arquitectura.
- Objetivos.
- Requisitos.
- Consultas.
- Dashboard.
- Alertas.
- Notificaciones.
- Anotaciones.
- Silenciamientos.
- Pruebas.
- Problemas.
- Soluciones.
- Seguridad.
- Limitaciones.
- Conclusiones.

### Puntuación orientativa

```text
Memoria completa y bien estructurada:
1,0 puntos

Memoria funcional con algunos apartados incompletos:
0,75 puntos

Memoria breve o poco explicativa:
0,5 puntos

Memoria inexistente:
0 puntos
```

### Calidad de la redacción

La documentación debe:

- Utilizar títulos claros.
- Evitar párrafos excesivamente largos.
- Mantener una nomenclatura uniforme.
- Diferenciar objetivo, procedimiento y resultado.
- Explicar los problemas con precisión.
- Evitar afirmaciones que no estén respaldadas por evidencias.
- Utilizar capturas solo cuando aporten información.

## Evaluación de la seguridad

### Condiciones obligatorias

El alumno no debe:

- Trabajar sobre producción sin autorización.
- Detener servicios reales.
- Generar carga no autorizada.
- Crear notificaciones reales.
- Exponer contraseñas.
- Compartir tokens.
- Incluir claves API.
- Entregar URLs con secretos.
- Modificar configuraciones críticas sin permiso.
- Eliminar archivos fuera del laboratorio.

### Incidencias de seguridad

Una incidencia de seguridad puede:

- Reducir la calificación.
- Invalidar una prueba.
- Requerir la repetición de la práctica.
- Impedir la superación del proyecto.
- Activar el protocolo del centro o laboratorio.

### Revisión de secretos

Antes de entregar, ejecutar una revisión orientativa:

```bash
grep -RniE 'password|passwd|token|secret|api[_-]?key|authorization' \
  ~/entrega-proyecto-final 2>/dev/null
```

Cada resultado debe revisarse manualmente, ya que puede contener falsos positivos.

## Sesión 1: realizar una autoevaluación

### Objetivo

Valorar el estado del proyecto antes de la revisión del instructor.

### Actividad

Completar la tabla:

| Área | Puntuación máxima | Autoevaluación | Justificación |
|---|---:|---:|---|
| Entorno | 1,0 | | |
| PromQL | 1,0 | | |
| Dashboard | 1,5 | | |
| Alertas | 2,0 | | |
| Notificaciones | 1,0 | | |
| Pruebas | 1,0 | | |
| Anotaciones y silencios | 0,5 | | |
| Evidencias | 1,0 | | |
| Memoria | 1,0 | | |
| **Total** | **10,0** | | |

### Registro

```text
Puntuación estimada:

Área más fuerte:

Área más débil:

Problema pendiente:

Acción de mejora:

Fecha de revisión:
```

## Sesión 2: revisar los requisitos

### Objetivo

Comprobar que todos los requisitos del proyecto tienen un resultado asociado.

### Actividad

Completar:

| Requisito | Resultado | Evidencia | Documento |
|---|---|---|---|
| Node Exporter operativo | | | |
| Prometheus recopila métricas | | | |
| Grafana consulta Prometheus | | | |
| Dashboard operativo | | | |
| Variable de instancia | | | |
| Alerta de disponibilidad | | | |
| Alerta de CPU | | | |
| Alerta de memoria | | | |
| Alerta de almacenamiento | | | |
| Contacto de laboratorio | | | |
| Política de notificación | | | |
| Anotación | | | |
| Silenciamiento | | | |
| Recuperación | | | |

### Resultado esperado

Cada requisito debe poder relacionarse con:

```text
Una configuración
Una prueba
Una evidencia
Una parte de la documentación
```

## Sesión 3: realizar una revisión cruzada

### Objetivo

Comprobar si otra persona puede entender la entrega.

### Procedimiento

1. Entregar temporalmente la documentación a otro alumno.
2. No explicar verbalmente el proyecto durante los primeros minutos.
3. Pedir que localice el dashboard.
4. Pedir que localice las consultas.
5. Pedir que localice las alertas.
6. Pedir que localice una prueba de recuperación.
7. Pedir que identifique una limitación.
8. Registrar las dificultades.

### Preguntas para la revisión

```text
¿Se entiende la arquitectura?

¿Se encuentra rápidamente el dashboard?

¿Se entiende cada consulta?

¿Se identifican los umbrales?

¿Se localizan las evidencias?

¿Se pueden distinguir activación y recuperación?

¿Hay información innecesaria?

¿Falta algún dato?
```

### Registro

```text
Revisor:

Elemento difícil de localizar:

Problema de comprensión:

Mejora aplicada:

Resultado:
```

## Sesión 4: revisar las evidencias

### Objetivo

Comprobar que las capturas y ficheros son suficientes.

### Actividad

Para cada evidencia, completar:

```text
Nombre:

Requisito demostrado:

Acción visible:

Resultado visible:

Fecha u hora:

Secretos ocultos:

Documento relacionado:

Resultado:
```

### Ejemplo

```text
Nombre:
17-alerta-alerting.png

Requisito demostrado:
La alerta de disponibilidad pasa a Alerting.

Acción visible:
NodeExporterDown-Laboratory activa.

Resultado visible:
Estado Alerting e instancia afectada.

Documento relacionado:
pruebas-alertas.md

Resultado:
Evidencia válida.
```

## Sesión 5: revisar la limpieza del entorno

### Objetivo

Confirmar que el laboratorio no conserva cambios temporales inesperados.

### Comprobaciones

```bash
sudo systemctl is-active node_exporter
sudo systemctl is-active prometheus
sudo systemctl is-active grafana-server
```

Comprobar disponibilidad:

```promql
up{job="node_exporter"}
```

Revisar procesos de carga:

```bash
ps aux | grep -E '[s]tress|[s]tress-ng'
```

Revisar:

```text
Servicios restaurados.
Procesos temporales detenidos.
Reglas de prueba eliminadas o documentadas.
Silenciamientos temporales revisados.
Contactos temporales revisados.
Configuraciones temporales documentadas.
```

### Registro

```text
Node Exporter:

Prometheus:

Grafana:

Procesos temporales:

Reglas temporales:

Silenciamientos:

Estado final:

Resultado:
```

## Sesión 6: preparar la entrega final

### Objetivo

Crear una copia final ordenada.

### Actividad

1. Crear el directorio de entrega.
2. Copiar los documentos definitivos.
3. Copiar las evidencias.
4. Copiar el dashboard exportado.
5. Revisar el README.
6. Revisar la memoria.
7. Revisar los secretos.
8. Comprobar los nombres.
9. Verificar la estructura.
10. Crear un archivo comprimido si procede.

### Comprobar la estructura

```bash
find ~/entrega-proyecto-final -maxdepth 4 -type f | sort
```

### Comprimir

```bash
tar -czf ~/entrega-proyecto-final.tar.gz \
  -C ~ entrega-proyecto-final
```

### Comprobar el archivo

```bash
tar -tzf ~/entrega-proyecto-final.tar.gz
```

### Registro

```text
Directorio:

Archivo comprimido:

Tamaño:

Fecha:

Revisión de secretos:

Resultado:
```

## Sesión 7: completar el acta de entrega

### Objetivo

Registrar formalmente el estado final del proyecto.

### Plantilla

```text
Proyecto:

Alumno:

Grupo:

Fecha de entrega:

Dashboard operativo:

Consultas documentadas:

Reglas documentadas:

Contacto de laboratorio:

Política documentada:

Anotaciones documentadas:

Silenciamientos documentados:

Pruebas de activación:

Pruebas de recuperación:

Evidencias:

Memoria técnica:

Limitaciones:

Entorno limpio:

Observaciones del alumno:

Firma o validación:
```

## Ejemplo de evaluación completa

### Entorno

```text
Resultado:
Correcto

Evidencias:
Servicios activos, target UP y fuente validada.

Puntuación:
1,0 / 1,0
```

### PromQL

```text
Resultado:
Las consultas de disponibilidad, CPU, memoria y almacenamiento
devuelven datos y están documentadas.

Puntuación:
1,0 / 1,0
```

### Dashboard

```text
Resultado:
Dashboard con cinco paneles, variable instance,
umbrales, leyendas y anotaciones.

Puntuación:
1,5 / 1,5
```

### Alertas

```text
Resultado:
Cuatro reglas con umbrales, duraciones, etiquetas y anotaciones.
La alerta de disponibilidad se ha probado.

Puntuación:
2,0 / 2,0
```

### Notificaciones

```text
Resultado:
Contacto de laboratorio probado y política documentada.

Puntuación:
1,0 / 1,0
```

### Pruebas

```text
Resultado:
Activación, Pending, Alerting y recuperación documentadas.

Puntuación:
1,0 / 1,0
```

### Anotaciones y silenciamientos

```text
Resultado:
Anotación de mantenimiento y silencio específico documentados.

Puntuación:
0,5 / 0,5
```

### Evidencias

```text
Resultado:
Capturas ordenadas, legibles y sin secretos.

Puntuación:
1,0 / 1,0
```

### Memoria

```text
Resultado:
Memoria técnica completa con conclusiones y limitaciones.

Puntuación:
1,0 / 1,0
```

### Nota final

```text
10,0 / 10,0
```

## Casos que requieren revisión

### Dashboard correcto, pero sin evidencias

La configuración puede estar bien realizada, pero no es posible verificar el proceso ni las pruebas.

Resultado orientativo:

```text
La puntuación de evidencias se reduce.
La puntuación de pruebas puede reducirse.
```

### Alertas creadas, pero sin duración

Las alertas pueden generar ruido por picos breves.

Resultado orientativo:

```text
La puntuación de diseño de alertas se reduce.
Debe justificarse la ausencia de duración.
```

### Notificaciones no probadas

La existencia de un contacto no demuestra que la entrega funcione.

Resultado orientativo:

```text
La puntuación de notificaciones se reduce.
Debe realizarse una prueba controlada.
```

### Evidencias con credenciales

Es una incidencia de seguridad.

Resultado orientativo:

```text
La entrega debe corregirse antes de aceptarse.
```

### Servicios de laboratorio detenidos

El entorno no queda limpio.

Resultado orientativo:

```text
Debe restaurarse el servicio y documentarse la acción.
```

## Puntos clave

- La evaluación considera configuración, funcionamiento y documentación.
- Cada requisito debe tener una evidencia asociada.
- El dashboard debe ser útil para operaciones.
- Las consultas deben estar validadas y explicadas.
- Las alertas deben ser accionables.
- Las duraciones deben estar justificadas.
- Las etiquetas deben permitir enrutar las alertas.
- Las anotaciones deben aportar contexto.
- Las notificaciones deben probarse.
- Las recuperaciones deben comprobarse.
- Los silenciamientos deben ser específicos y temporales.
- Las evidencias deben ser legibles.
- Las capturas no deben incluir secretos.
- El README debe explicar cómo revisar la solución.
- La memoria debe explicar las decisiones técnicas.
- Las limitaciones deben documentarse.
- La limpieza final forma parte de la evaluación.
- Un proyecto funcional pero sin evidencias está incompleto.
- Una buena presentación facilita la revisión técnica.
- La solución debe diferenciar claramente el laboratorio de producción.

## Preguntas de comprobación

1. ¿Qué aspectos se evalúan en el proyecto final?
2. ¿Cuántos puntos tiene la evaluación completa?
3. ¿Qué requisitos mínimos deben cumplirse para aprobar?
4. ¿Qué evidencias demostrarían que el entorno está preparado?
5. ¿Qué debe incluir la documentación de una consulta PromQL?
6. ¿Qué debe incluir la documentación de una regla de alerta?
7. ¿Qué diferencia existe entre una configuración funcional y una solución mantenible?
8. ¿Qué elementos debe tener un dashboard operativo?
9. ¿Qué etiquetas deben incluir las alertas?
10. ¿Qué información deben contener las anotaciones?
11. ¿Cómo se evalúa una prueba de activación?
12. ¿Cómo se evalúa una prueba de recuperación?
13. ¿Qué características debe tener un silenciamiento correcto?
14. ¿Qué información no debe aparecer en las evidencias?
15. ¿Qué función cumple el README?
16. ¿Qué debe contener la memoria técnica?
17. ¿Cómo se comprueba que una evidencia demuestra un requisito?
18. ¿Qué debe revisarse antes de comprimir la entrega?
19. ¿Qué acciones deben realizarse para limpiar el entorno?
20. ¿Qué puede ocurrir si se entregan credenciales?
21. ¿Cómo se documenta una limitación del laboratorio?
22. ¿Por qué es importante realizar una revisión cruzada?
23. ¿Qué diferencia existe entre una prueba realizada y una prueba documentada?
24. ¿Cuándo se considera que el proyecto está completo?
25. ¿Qué características debe tener una solución de observabilidad de calidad?

## Lista de comprobación final

### Entorno

```text
[ ] La máquina de laboratorio está identificada.
[ ] Grafana está operativo.
[ ] Prometheus está operativo.
[ ] Node Exporter está operativo.
[ ] El endpoint /metrics responde.
[ ] El target aparece como UP.
[ ] La fuente de datos funciona.
[ ] Las versiones están documentadas.
```

### PromQL

```text
[ ] La consulta de disponibilidad está validada.
[ ] La consulta de CPU está validada.
[ ] La consulta de memoria está validada.
[ ] La consulta de almacenamiento está validada.
[ ] Las unidades están documentadas.
[ ] Las etiquetas están documentadas.
[ ] Las consultas están guardadas.
```

### Dashboard

```text
[ ] El dashboard tiene un nombre claro.
[ ] El dashboard tiene una descripción.
[ ] Existe disponibilidad.
[ ] Existe CPU.
[ ] Existe memoria.
[ ] Existe almacenamiento.
[ ] Existe una variable de instancia.
[ ] Los títulos son claros.
[ ] Las unidades son correctas.
[ ] Las leyendas son legibles.
[ ] Los umbrales están configurados.
[ ] Las anotaciones son visibles.
[ ] El dashboard está exportado o documentado.
```

### Alertas

```text
[ ] Existe una alerta de disponibilidad.
[ ] Existe una alerta de CPU.
[ ] Existe una alerta de memoria.
[ ] Existe una alerta de almacenamiento.
[ ] Las consultas están validadas.
[ ] Los umbrales están documentados.
[ ] Las duraciones están justificadas.
[ ] Las etiquetas son coherentes.
[ ] Las anotaciones identifican la instancia.
[ ] El comportamiento ante ausencia de datos está documentado.
```

### Notificaciones

```text
[ ] Existe un contacto de laboratorio.
[ ] El contacto se ha probado.
[ ] Existe una política.
[ ] La política coincide con las etiquetas.
[ ] Se ha documentado la agrupación.
[ ] Se han documentado los intervalos.
[ ] Se ha comprobado la recepción.
```

### Pruebas

```text
[ ] Se ha observado Normal.
[ ] Se ha observado Pending.
[ ] Se ha observado Alerting.
[ ] Se ha comprobado una recuperación.
[ ] Se ha documentado una anotación.
[ ] Se ha probado un silenciamiento.
[ ] Se han guardado evidencias.
```

### Seguridad y limpieza

```text
[ ] No existen credenciales en la entrega.
[ ] No existen tokens en las capturas.
[ ] No se ha trabajado sobre producción.
[ ] Los servicios están restaurados.
[ ] No quedan procesos de carga.
[ ] No quedan silenciamientos inesperados.
[ ] No quedan reglas temporales sin documentar.
[ ] El entorno está limpio.
```

## Resultado esperado

El proyecto se considera correctamente evaluado cuando el alumno puede demostrar el siguiente flujo:

```text
Validar el entorno
        |
        v
Validar las métricas
        |
        v
Validar las consultas
        |
        v
Revisar el dashboard
        |
        v
Revisar las alertas
        |
        v
Revisar las notificaciones
        |
        v
Revisar las anotaciones
        |
        v
Revisar los silenciamientos
        |
        v
Comprobar las pruebas
        |
        v
Revisar las evidencias
        |
        v
Revisar la seguridad
        |
        v
Limpiar el laboratorio
        |
        v
Preparar la entrega
        |
        v
Realizar la autoevaluación
        |
        v
Presentar el proyecto
```

La solución final debe demostrar que el alumno sabe:

```text
Preparar una plataforma de observabilidad.

Recopilar métricas.

Consultar datos con PromQL.

Construir un dashboard operativo.

Crear alertas útiles.

Clasificar y enrutar notificaciones.

Registrar eventos operativos.

Utilizar silenciamientos controlados.

Probar activaciones.

Comprobar recuperaciones.

Diagnosticar errores.

Documentar decisiones.

Proteger información sensible.

Entregar una solución reproducible.
```

La calificación final no debe depender únicamente de que una pantalla muestre datos. Debe reflejar la capacidad del alumno para construir una solución completa, comprender su comportamiento, justificar sus decisiones y dejar el entorno documentado y seguro.