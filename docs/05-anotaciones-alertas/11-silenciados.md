# Silenciados

Los **silenciados** permiten detener temporalmente las notificaciones de determinadas alertas sin eliminar ni desactivar sus reglas.

Son útiles durante:

- Mantenimientos planificados.
- Despliegues.
- Pruebas de carga.
- Migraciones.
- Reinicios controlados.
- Ventanas de cambio.
- Incidencias conocidas.
- Trabajos programados que generan alertas esperadas.

Un silencio afecta al envío de notificaciones, pero **no detiene necesariamente la evaluación de la regla**.

El flujo habitual es:

```text
Regla de alerta
      |
      v
Evaluación de la métrica
      |
      v
Estado de la alerta
      |
      v
Coincidencia con un silencio
      |
      v
Notificación suprimida
```

Una alerta puede seguir apareciendo como activa en Grafana aunque su notificación esté silenciada.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es un silencio.
- Diferenciar un silencio de una regla deshabilitada.
- Diferenciar un silencio de una pausa de una regla.
- Diferenciar un silencio de un intervalo de silencio.
- Crear un silencio para una alerta concreta.
- Crear un silencio mediante coincidencias de etiquetas.
- Configurar la fecha y hora de inicio.
- Configurar la fecha y hora de finalización.
- Añadir un comentario justificativo.
- Identificar quién creó un silencio.
- Consultar los silencios activos.
- Editar un silencio existente.
- Eliminar un silencio.
- Comprobar si una alerta coincide con un silencio.
- Verificar que una alerta sigue evaluándose durante un silencio.
- Comprobar que no se envían notificaciones durante el silencio.
- Diseñar silencios suficientemente específicos.
- Evitar silencios demasiado amplios.
- Revisar silencios caducados o innecesarios.
- Documentar los silencios creados.
- Aplicar buenas prácticas de seguridad y auditoría.

---

## Introducción

Las alertas pueden activarse durante actividades conocidas sin representar una incidencia inesperada.

Por ejemplo, durante un mantenimiento puede detenerse temporalmente un servicio:

```text
22:00 - Inicio del mantenimiento
22:05 - Node Exporter deja de responder
22:06 - La alerta pasa a Alerting
22:30 - Finaliza el mantenimiento
22:35 - El servicio vuelve a funcionar
```

Si no se configura un silencio, Grafana puede enviar notificaciones durante todo el mantenimiento.

Un silencio permite indicar:

```text
Durante esta ventana, no enviar notificaciones
para las alertas que coincidan con estas etiquetas.
```

El silencio no elimina la regla ni modifica su consulta.

### Ejemplo

Regla:

```text
NodeExporterDown
```

Etiquetas:

```text
alertname = NodeExporterDown
instance = server-01:9100
environment = production
```

Silencio:

```text
alertname = NodeExporterDown
instance = server-01:9100
Inicio = 22:00
Fin = 22:30
Motivo = Mantenimiento programado
```

Resultado:

```text
La alerta puede evaluarse y aparecer en Grafana,
pero no se envía su notificación durante ese periodo.
```

---

## Qué es un silencio

Un silencio es una configuración temporal que impide que las notificaciones se entreguen cuando una alerta coincide con determinadas etiquetas.

Normalmente incluye:

- Coincidencias de etiquetas.
- Fecha y hora de inicio.
- Fecha y hora de finalización.
- Comentario o motivo.
- Usuario que lo creó.
- Estado del silencio.

### Ejemplo conceptual

```text
Silencio:
Mantenimiento server-01

Coincidencias:
alertname = NodeExporterDown
instance = server-01:9100

Inicio:
2026-09-24 22:00

Fin:
2026-09-24 22:30

Comentario:
Mantenimiento de sistema autorizado.
```

Durante ese periodo, las alertas que cumplan las coincidencias quedan silenciadas.

---

## Qué no hace un silencio

Un silencio no:

- Elimina una regla.
- Modifica una consulta.
- Cambia un umbral.
- Detiene necesariamente la evaluación.
- Corrige el problema detectado.
- Resuelve una alerta.
- Borra el historial.
- Impide que la alerta aparezca en la lista.
- Garantiza que se oculten todos los problemas relacionados.

### Ejemplo

```text
Regla:
HighCPUUsage

Estado:
Alerting

Silencio:
Activo

Resultado:
La alerta sigue activa,
pero no se envían notificaciones coincidentes.
```

Por eso es importante no interpretar un silencio como una resolución técnica.

---

## Diferencias importantes

### Silencio frente a regla deshabilitada

| Característica | Silencio | Regla deshabilitada |
|---|---|---|
| La regla existe | Sí | Sí |
| La regla se evalúa | Normalmente sí | No, según la configuración |
| La alerta puede aparecer | Sí | No se generan nuevas evaluaciones |
| Suprime notificaciones | Sí | No se generan notificaciones nuevas |
| Tiene duración | Habitualmente sí | Puede permanecer hasta reactivarse |
| Uso habitual | Mantenimiento o evento conocido | Desactivación temporal de una regla |

### Silencio frente a pausa

Pausar una regla impide o detiene su evaluación según el mecanismo utilizado.

Un silencio mantiene la evaluación, pero suprime las notificaciones coincidentes.

### Silencio frente a intervalo de silencio

Un silencio suele aplicarse a una coincidencia concreta durante un periodo determinado.

Un intervalo de silencio define un horario recurrente.

Ejemplo:

```text
Silencio:
server-01 durante hoy de 22:00 a 23:00.

Intervalo de silencio:
Todos los domingos de 02:00 a 04:00.
```

El nombre exacto puede variar según la versión de Grafana.

---

## Componentes de un silencio

### Coincidencias

Determinan qué alertas quedan silenciadas.

Ejemplo:

```text
alertname = HighCPUUsage
```

### Inicio

Momento a partir del cual el silencio queda activo.

```text
2026-09-24 22:00
```

### Fin

Momento a partir del cual el silencio deja de aplicarse.

```text
2026-09-24 22:30
```

### Comentario

Explica el motivo y aporta contexto.

```text
Mantenimiento programado de server-01.
Cambio autorizado CHG-1042.
```

### Creador

Identifica el usuario que configuró el silencio.

### Estado

Un silencio puede estar:

```text
Pendiente
Activo
Expirado
Eliminado
```

La terminología exacta depende de la versión de Grafana.

---

## Coincidencias de etiquetas

Las coincidencias son la parte más importante de un silencio.

### Coincidencia por nombre de alerta

```text
alertname = NodeExporterDown
```

Silencia todas las instancias de esa regla que coincidan con el resto de criterios.

### Coincidencia por instancia

```text
instance = server-01:9100
```

Silencia alertas de una instancia concreta.

### Coincidencias combinadas

```text
alertname = NodeExporterDown
instance = server-01:9100
environment = production
```

Este silencio es más específico.

### Coincidencia por equipo

```text
team = systems
```

Puede silenciar muchas alertas del equipo. Debe utilizarse con cuidado.

### Coincidencia por entorno

```text
environment = laboratory
```

Puede ser apropiado para una ventana de prácticas, pero peligroso si se utiliza sobre producción.

---

## Silencios específicos y amplios

### Silencio específico

```text
alertname = NodeExporterDown
instance = server-01:9100
```

Ventajas:

- Reduce el riesgo de ocultar otras alertas.
- Afecta a un recurso concreto.
- Es más fácil de revisar.

### Silencio amplio

```text
team = systems
```

Puede afectar a:

- CPU.
- Memoria.
- Disco.
- Disponibilidad.
- Latencia.
- Errores de servicios.

Debe utilizarse únicamente cuando el mantenimiento afecta realmente a todo el conjunto.

### Recomendación

Utilizar el silencio más específico que cubra el trabajo previsto.

---

## Silencios con varias etiquetas

Una actividad de mantenimiento puede requerir varias coincidencias.

### Ejemplo

```text
environment = production
instance = server-01:9100
team = systems
```

Esto limita el silencio al servidor concreto del entorno de producción y al equipo correspondiente.

### Ejemplo de mantenimiento de una aplicación

```text
service = payments-api
environment = production
```

El silencio puede cubrir varias alertas del servicio, pero no las de otras aplicaciones.

### Precaución

No añadir etiquetas innecesarias si pueden impedir que el silencio coincida con las alertas esperadas.

---

## Crear un silencio

La ubicación exacta puede cambiar según la versión de Grafana.

Procedimiento general:

1. Acceder a Grafana.
2. Abrir **Alerting**.
3. Acceder a **Silences** o **Silenciados**.
4. Crear un nuevo silencio.
5. Añadir las coincidencias de etiquetas.
6. Configurar el inicio.
7. Configurar el final.
8. Introducir un comentario.
9. Revisar el alcance.
10. Guardar el silencio.
11. Confirmar que aparece como activo o programado.
12. Comprobar una alerta coincidente.
13. Documentar el resultado.

### Ejemplo

```text
Nombre descriptivo:
Mantenimiento server-01

Coincidencia:
instance = server-01:9100

Inicio:
22:00

Fin:
22:30

Comentario:
Mantenimiento autorizado CHG-1042.
```

---

## Comentarios de los silencios

El comentario debe explicar:

- Qué actividad se está realizando.
- Qué recursos afecta.
- Quién la ha autorizado.
- Cuándo termina.
- Qué referencia tiene.
- Qué equipo es responsable.

### Ejemplo correcto

```text
Mantenimiento programado del sistema operativo de server-01.
Cambio CHG-1042. Responsable: equipo de sistemas.
Fin previsto: 22:30.
```

### Ejemplo insuficiente

```text
Prueba
```

### Otro ejemplo correcto

```text
Prueba de carga autorizada en laboratorio.
No afecta a producción. Responsable: formación.
Fin previsto: 18:45.
```

Un buen comentario evita que otra persona tenga que investigar el motivo del silencio.

---

## Duración de un silencio

El periodo debe cubrir la actividad prevista, pero no prolongarse innecesariamente.

### Ejemplo

Mantenimiento previsto:

```text
22:00 a 22:30
```

Silencio recomendado:

```text
21:55 a 22:35
```

El margen debe estar justificado.

### Riesgo de un silencio demasiado corto

La actividad continúa, pero el silencio termina:

```text
22:30 - Finaliza el silencio
22:32 - El mantenimiento continúa
22:33 - Se envía una alerta
```

### Riesgo de un silencio demasiado largo

El problema real puede quedar oculto:

```text
22:00 - Inicio del silencio
23:00 - El mantenimiento termina
02:00 - La alerta sigue silenciada por error
```

### Recomendación

Utilizar una duración razonable y revisar el silencio después de la actividad.

---

## Silencios programados y activos

### Silencio programado

Todavía no ha comenzado.

```text
Inicio: 22:00
Hora actual: 21:30
Estado: programado
```

### Silencio activo

El periodo actual se encuentra dentro de la ventana.

```text
Inicio: 22:00
Hora actual: 22:15
Fin: 22:30
Estado: activo
```

### Silencio expirado

El periodo ha terminado.

```text
Fin: 22:30
Hora actual: 22:45
Estado: expirado
```

Los silencios expirados deben revisarse y conservarse únicamente si son necesarios para auditoría.

---

## Silenciar desde una alerta

En algunos flujos, Grafana permite crear un silencio directamente desde la vista de una alerta.

Procedimiento general:

1. Abrir la alerta.
2. Revisar sus etiquetas.
3. Seleccionar la opción de silenciar.
4. Confirmar las etiquetas coincidentes.
5. Configurar la duración.
6. Introducir el motivo.
7. Guardar.
8. Confirmar que el silencio afecta a la alerta correcta.

### Recomendación

Revisar siempre las coincidencias antes de guardar. Una alerta puede tener más etiquetas de las visibles inicialmente.

---

## Revisar el alcance de un silencio

Antes de crear un silencio, comprobar:

```text
¿Qué regla coincide?

¿Qué instancias coinciden?

¿Qué servicios coinciden?

¿Qué entornos coinciden?

¿Qué severidades coinciden?

¿Afecta a otras alertas?

¿Afecta a producción?

¿Afecta a todo un equipo?
```

### Ejemplo

Silencio:

```text
team = systems
```

Puede coincidir con:

```text
HighCPUUsage
HighMemoryUsage
FilesystemUsageHigh
NodeExporterDown
```

Si solo se pretendía silenciar CPU de un servidor, el alcance es demasiado amplio.

---

## Silencios y políticas de notificación

Un silencio actúa sobre las notificaciones después de que la alerta haya sido evaluada y enrutada.

Flujo conceptual:

```text
Regla
  |
  v
Estado de alerta
  |
  v
Política de notificación
  |
  v
Comprobación de silencio
  |
  v
Notificación enviada o suprimida
```

### Consecuencia

Una alerta puede:

- Coincidir con una política.
- Tener un contacto válido.
- Estar activa.
- Aparecer en Grafana.
- No generar un mensaje porque coincide con un silencio.

Por eso, al investigar una notificación ausente, hay que revisar también los silencios.

---

## Silencios y alertas críticas

Silenciar una alerta crítica puede ocultar un problema importante.

Antes de crear el silencio:

1. Confirmar que el mantenimiento está autorizado.
2. Definir un inicio y un final.
3. Limitar las coincidencias.
4. Añadir un comentario.
5. Identificar al responsable.
6. Confirmar el plan de recuperación.
7. Revisar si existen alertas alternativas.
8. Informar al equipo correspondiente.

### Ejemplo

```text
Silencio:
Mantenimiento de red

Coincidencias:
service = network-monitor
environment = production

Motivo:
Cambio de switches CHG-1108.

Responsable:
Equipo de redes.

Fin:
23:00.
```

No conviene silenciar indiscriminadamente todas las alertas críticas de producción.

---

## Silencios durante mantenimientos

### Procedimiento recomendado

#### Antes del mantenimiento

- Confirmar el alcance.
- Identificar las alertas esperadas.
- Crear el silencio.
- Revisar las etiquetas.
- Informar al equipo.
- Comprobar la hora y la zona horaria.

#### Durante el mantenimiento

- Supervisar el estado desde Grafana.
- Confirmar que el silencio está activo.
- Revisar alertas no relacionadas.
- Mantener el contacto con el responsable.

#### Después del mantenimiento

- Confirmar la recuperación.
- Revisar el estado de las reglas.
- Eliminar o dejar expirar el silencio.
- Comprobar notificaciones.
- Documentar incidencias.
- Revisar alertas que no deberían haberse silenciado.

---

## Zona horaria

Las horas de inicio y finalización deben interpretarse correctamente.

### Riesgos

- Grafana utiliza UTC y el alumno interpreta hora local.
- El servidor tiene una zona horaria diferente.
- Se introduce una hora incorrecta.
- El cambio horario afecta a la ventana.
- La documentación utiliza un formato ambiguo.

### Recomendaciones

Utilizar fechas completas:

```text
2026-09-24 22:00 Europe/Madrid
```

o un formato con zona horaria:

```text
2026-09-24T22:00:00+02:00
```

Comprobar:

- Zona horaria de Grafana.
- Zona horaria del navegador.
- Zona horaria del servidor.
- Hora de inicio efectiva.
- Hora de finalización efectiva.

---

## Revisión y eliminación de silencios

Un silencio debe revisarse cuando:

- Ha terminado el mantenimiento.
- La alerta se ha resuelto.
- El alcance ha cambiado.
- El cambio se ha cancelado.
- Se ha sustituido la regla.
- Ya no es necesario ocultar las notificaciones.

### Eliminar un silencio

Eliminarlo puede hacer que vuelvan a enviarse notificaciones si la alerta continúa activa.

Antes de eliminarlo:

1. Confirmar el estado de la alerta.
2. Confirmar que el mantenimiento ha terminado.
3. Comprobar que el servicio se ha recuperado.
4. Revisar el contacto.
5. Eliminar el silencio.
6. Confirmar el comportamiento posterior.

---

## Silencios expirados

Los silencios expirados ya no suprimen notificaciones, pero pueden conservarse para auditoría.

### Revisar periódicamente

Buscar:

- Silencios antiguos.
- Silencios sin comentario.
- Silencios con alcance excesivo.
- Silencios de usuarios que ya no pertenecen al equipo.
- Silencios asociados a cambios cancelados.
- Silencios duplicados.

### Información útil

```text
Nombre o identificador:

Creador:

Inicio:

Fin:

Coincidencias:

Comentario:

Estado:

Cambio asociado:
```

---

## Auditoría de silencios

Un silencio debe poder responder a estas preguntas:

```text
¿Quién lo creó?

¿Por qué se creó?

¿Qué alertas afecta?

¿Cuándo comienza?

¿Cuándo termina?

¿Quién autorizó el mantenimiento?

¿Sigue siendo necesario?

¿Qué ocurrió durante el silencio?
```

### Ejemplo de ficha

```text
Silencio:
silence-1042

Creador:
operador-sistemas

Motivo:
Mantenimiento de server-01

Cambio:
CHG-1042

Inicio:
2026-09-24 22:00 Europe/Madrid

Fin:
2026-09-24 22:30 Europe/Madrid

Coincidencias:
instance=server-01:9100

Estado:
Expirado
```

---

## Silencios y anotaciones

Las anotaciones ayudan a relacionar una ventana de mantenimiento con el comportamiento de las métricas.

### Ejemplo

```text
22:00 - Inicio del mantenimiento
22:05 - NodeExporterDown activo, silenciado
22:15 - Métricas no disponibles
22:30 - Fin del mantenimiento
22:35 - Métricas recuperadas
```

El silencio explica por qué no se enviaron notificaciones. La anotación aporta contexto temporal al dashboard.

---

## Silencios y ausencia de datos

Una alerta de ausencia de datos puede seguir evaluándose durante un silencio.

Ejemplo:

```text
Silencio:
instance=server-01:9100

Alerta:
No data

Resultado:
La alerta puede aparecer activa,
pero la notificación queda suprimida.
```

Esto puede ser correcto durante un mantenimiento, pero debe revisarse al finalizar.

No se debe asumir que un silencio resuelve la pérdida de datos.

---

## Ejemplo completo

### Escenario

Se realizará un mantenimiento de sistema en `server-01`.

Durante la actividad:

- Node Exporter puede dejar de responder.
- La CPU puede aumentar.
- La memoria puede cambiar.
- La disponibilidad puede verse afectada.

### Silencio

```text
Coincidencias:
instance = server-01:9100
environment = production

Inicio:
2026-09-24 22:00 Europe/Madrid

Fin:
2026-09-24 22:45 Europe/Madrid

Comentario:
Mantenimiento del sistema operativo de server-01.
Cambio CHG-1042. Responsable: equipo de sistemas.
```

### Resultado esperado

```text
Las alertas de server-01 continúan evaluándose,
pero no se envían notificaciones durante la ventana.
```

### Después

1. Confirmar que el servidor está operativo.
2. Confirmar que Prometheus recibe métricas.
3. Confirmar que las reglas vuelven a `Normal`.
4. Comprobar que el silencio ha expirado.
5. Revisar la lista de alertas.
6. Documentar cualquier alerta inesperada.

---

## Ejemplo de sesión 1: crear un silencio para una instancia

### Objetivo

Silenciar temporalmente las alertas de un servidor concreto durante una práctica.

### Regla de referencia

```text
NodeExporterDown
```

### Etiquetas de la alerta

```text
alertname = NodeExporterDown
instance = server-01:9100
environment = laboratory
team = systems
```

### Configuración del silencio

```text
Coincidencias:
alertname = NodeExporterDown
instance = server-01:9100

Inicio:
Hora actual

Fin:
30 minutos después

Comentario:
Práctica de mantenimiento autorizada en laboratorio.
```

### Pasos

1. Abrir **Alerting**.
2. Acceder a **Silences**.
3. Crear un silencio.
4. Añadir `alertname`.
5. Añadir `instance`.
6. Revisar el entorno.
7. Configurar la duración.
8. Añadir el comentario.
9. Guardar.
10. Confirmar que aparece como activo.
11. Activar la alerta.
12. Comprobar que aparece en Grafana.
13. Confirmar que no se envía la notificación.
14. Eliminar o esperar la expiración del silencio.
15. Confirmar el comportamiento posterior.

### Registro

```text
Silencio:

Coincidencias:

Hora de inicio:

Hora de fin:

Estado:

Alerta afectada:

Notificación antes del silencio:

Notificación durante el silencio:

Notificación después del silencio:

Resultado:
```

---

## Ejemplo de sesión 2: comprobar que el silencio es específico

### Objetivo

Verificar que se silencia una instancia sin afectar a otra.

### Preparación

Crear un silencio:

```text
instance = server-01:9100
```

No incluir:

```text
team = systems
```

### Escenario

```text
server-01 → alerta activa
server-02 → alerta activa
```

### Pasos

1. Crear el silencio para `server-01`.
2. Activar la misma regla en `server-01`.
3. Activar la misma regla en `server-02`.
4. Revisar el estado de ambas alertas.
5. Comprobar las notificaciones.
6. Confirmar que solo `server-01` está silenciado.
7. Documentar el resultado.

### Resultado esperado

```text
server-01:
Notificación suprimida.

server-02:
Notificación entregada.
```

---

## Ejemplo de sesión 3: comprobar el alcance de un silencio amplio

### Objetivo

Observar los riesgos de utilizar una coincidencia demasiado general.

### Silencio

```text
team = systems
```

### Alertas del equipo

```text
HighCPUUsage
HighMemoryUsage
FilesystemUsageHigh
NodeExporterDown
```

### Pasos

1. Revisar las alertas etiquetadas con `team=systems`.
2. Crear el silencio.
3. Activar una alerta de CPU.
4. Activar una alerta de memoria.
5. Revisar qué notificaciones se suprimen.
6. Comparar con el objetivo original.
7. Eliminar el silencio.
8. Crear un silencio específico para CPU.
9. Repetir la prueba.

### Conclusión esperada

Un silencio basado únicamente en `team=systems` puede afectar a más alertas de las necesarias.

---

## Ejemplo de sesión 4: comprobar la duración

### Objetivo

Observar qué ocurre cuando el silencio expira mientras la alerta sigue activa.

### Configuración

```text
Duración:
2 minutos
```

### Pasos

1. Crear el silencio.
2. Activar una alerta.
3. Comprobar que la notificación se suprime.
4. Esperar la expiración.
5. Mantener la alerta activa.
6. Observar el comportamiento posterior.
7. Registrar si se envía una nueva notificación.
8. Resolver la alerta.
9. Comprobar la recuperación.

### Registro

```text
Hora de activación:

Inicio del silencio:

Fin del silencio:

Estado al expirar:

Notificación posterior:

Hora de recuperación:

Resultado:
```

La conducta exacta puede depender de la política, la agrupación y el intervalo de repetición.

---

## Ejemplo de sesión 5: probar un silencio programado

### Objetivo

Crear un silencio que empiece en el futuro.

### Configuración

```text
Inicio:
22:00

Fin:
22:30

Coincidencia:
instance = server-01:9100
```

### Pasos

1. Crear el silencio.
2. Confirmar que queda programado.
3. Activar una alerta antes de las 22:00.
4. Comprobar que la notificación se comporta normalmente.
5. Esperar al inicio del silencio.
6. Activar o mantener la alerta.
7. Comprobar que la notificación se suprime.
8. Esperar al final.
9. Revisar el comportamiento posterior.

### Registro

```text
Estado antes del inicio:

Estado durante el silencio:

Estado después del fin:

Resultado:
```

---

## Ejemplo de sesión 6: revisar la zona horaria

### Objetivo

Evitar errores de horario al crear un silencio.

### Pasos

1. Consultar la hora del sistema:

```bash
date
```

2. Consultar la zona horaria configurada:

```bash
timedatectl
```

3. Comparar con la hora mostrada en Grafana.
4. Crear un silencio con fecha y hora explícitas.
5. Confirmar el inicio efectivo.
6. Revisar la hora en la lista de silencios.
7. Documentar la zona horaria utilizada.

### Registro

```text
Hora del sistema:

Zona horaria del sistema:

Hora del navegador:

Zona horaria de Grafana:

Hora introducida:

Hora mostrada por Grafana:

Resultado:
```

---

## Ejemplo de sesión 7: investigar una notificación suprimida

### Objetivo

Determinar si un silencio impide el envío de una alerta.

### Situación

```text
La alerta está en Alerting,
pero el equipo no recibe notificaciones.
```

### Procedimiento

1. Abrir la lista de alertas.
2. Revisar el estado.
3. Consultar las etiquetas.
4. Abrir la sección de silencios.
5. Buscar coincidencias.
6. Revisar el inicio y el fin.
7. Revisar el comentario.
8. Confirmar si el silencio está activo.
9. Comprobar la política y el contacto.
10. Determinar si la ausencia del mensaje es esperada.
11. Documentar la conclusión.

### Registro

```text
Alerta:

Estado:

Etiquetas:

Silencio coincidente:

Estado del silencio:

Inicio:

Fin:

Motivo:

Notificación esperada:

Conclusión:
```

---

## Ejemplo de sesión 8: eliminar un silencio al finalizar un cambio

### Objetivo

Practicar la retirada controlada de un silencio.

### Pasos

1. Crear un silencio para un mantenimiento.
2. Activar una alerta durante el mantenimiento.
3. Confirmar la supresión.
4. Finalizar el mantenimiento.
5. Comprobar la salud del servicio.
6. Comprobar el estado de la métrica.
7. Eliminar el silencio.
8. Activar una alerta de prueba.
9. Confirmar que la notificación vuelve a enviarse.
10. Documentar la retirada.

### Lista de comprobación

```text
[ ] El mantenimiento ha finalizado.
[ ] El servicio funciona.
[ ] Las métricas se reciben correctamente.
[ ] Las reglas se evalúan.
[ ] El silencio ya no es necesario.
[ ] El silencio se ha eliminado.
[ ] Las notificaciones vuelven a funcionar.
[ ] La acción ha quedado documentada.
```

---

## Ejemplo de sesión 9: revisar silencios caducados

### Objetivo

Identificar silencios antiguos o innecesarios.

### Pasos

1. Abrir la lista de silencios.
2. Filtrar los silencios expirados.
3. Revisar el creador.
4. Revisar el motivo.
5. Revisar las etiquetas.
6. Comprobar si existe un cambio asociado.
7. Identificar silencios sin comentario.
8. Identificar silencios con alcance excesivo.
9. Decidir si deben conservarse por auditoría.
10. Documentar la revisión.

### Tabla

| Silencio | Estado | Motivo | Alcance | Acción |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

---

## Ejemplo de sesión 10: mantenimiento completo

### Objetivo

Simular un mantenimiento planificado con silencio y anotación.

### Escenario

Se realizará el mantenimiento de `server-01` entre las 22:00 y las 22:30.

### Preparación

Crear un silencio:

```text
instance = server-01:9100
environment = laboratory
```

Crear una anotación:

```text
Mantenimiento planificado de server-01.
Responsable: equipo de sistemas.
Referencia: LAB-1042.
```

### Durante el mantenimiento

1. Confirmar que el silencio está activo.
2. Detener Node Exporter.
3. Observar el estado de la alerta.
4. Comprobar que no se envían notificaciones.
5. Revisar que otras instancias siguen notificando.
6. Registrar los cambios.

### Después

1. Iniciar Node Exporter.
2. Confirmar la recuperación.
3. Comprobar las métricas.
4. Confirmar la expiración o eliminar el silencio.
5. Revisar la lista de alertas.
6. Documentar el resultado.

---

## Silencios recurrentes

Para actividades que se repiten, puede ser preferible utilizar un intervalo de silencio en lugar de crear silencios manuales cada vez.

### Ejemplo

```text
Todos los domingos
02:00 a 04:00

Coincidencia:
environment = staging
```

### Uso adecuado

- Mantenimientos recurrentes.
- Ventanas de copias de seguridad conocidas.
- Procesos programados.
- Trabajos batch autorizados.

### Riesgos

- El calendario puede cambiar.
- Una actividad puede cancelarse.
- La ventana puede coincidir con un incidente real.
- El silencio puede mantenerse demasiado tiempo.
- El alcance puede ser mayor de lo previsto.

Los intervalos recurrentes deben revisarse periódicamente.

---

## Silencios y mantenimiento de reglas

No se debe crear un silencio para ocultar una regla mal diseñada.

### Situación incorrecta

```text
La alerta genera demasiados falsos positivos.
Solución aplicada:
Silenciarla durante semanas.
```

### Solución adecuada

1. Revisar la consulta.
2. Revisar el umbral.
3. Revisar la duración.
4. Revisar la reducción.
5. Ajustar la regla.
6. Probarla.
7. Utilizar un silencio solo durante cambios controlados.

Un silencio debe ser una medida temporal y justificada, no una solución permanente al ruido.

---

## Silencios y alertas repetitivas

Si una alerta se repite constantemente, puede ser tentador silenciarla.

Antes de hacerlo:

- Confirmar si existe un problema real.
- Revisar el historial.
- Revisar la métrica.
- Revisar el umbral.
- Consultar al equipo responsable.
- Abrir una incidencia de mejora.
- Ajustar la regla si corresponde.

### Excepción

Puede crearse un silencio temporal mientras se corrige la regla, pero debe incluir:

```text
Motivo:

Responsable:

Fecha de revisión:

Incidencia asociada:

Fin previsto:
```

---

## Seguridad y permisos

Los silencios pueden ocultar notificaciones importantes.

Por eso, deben controlarse los permisos para:

- Crear silencios.
- Editar silencios.
- Eliminar silencios.
- Crear silencios amplios.
- Silenciar alertas críticas.
- Consultar el historial.

### Buenas prácticas

- Limitar la creación de silencios.
- Exigir comentarios.
- Registrar los cambios.
- Revisar silencios de producción.
- Auditar silencios amplios.
- Utilizar usuarios individuales.
- Evitar cuentas compartidas.
- Mantener trazabilidad.

---

## Silencios en producción

Antes de silenciar una alerta de producción:

1. Confirmar el cambio autorizado.
2. Confirmar la ventana horaria.
3. Confirmar el equipo responsable.
4. Confirmar las etiquetas.
5. Revisar el contacto de guardia.
6. Definir el fin.
7. Añadir la referencia del cambio.
8. Informar al equipo.
9. Revisar las alertas no relacionadas.
10. Confirmar la recuperación.

### Ejemplo

```text
Cambio:
CHG-1042

Silencio:
environment=production
instance=server-01:9100

Motivo:
Actualización del sistema operativo.

Responsable:
Equipo de sistemas.

Inicio:
2026-09-24 22:00 Europe/Madrid

Fin:
2026-09-24 22:45 Europe/Madrid
```

---

## API y automatización

Grafana puede permitir la gestión de silencios mediante API según la versión y la configuración.

La automatización puede utilizarse para:

- Crear silencios desde un sistema de cambios.
- Eliminar silencios al finalizar una actividad.
- Validar la duración.
- Auditar silencios.
- Asociar silencios con cambios autorizados.

### Precauciones

- Proteger las credenciales de API.
- Utilizar permisos mínimos.
- Validar las etiquetas.
- Limitar la duración máxima.
- Registrar quién ejecutó la operación.
- Evitar crear silencios globales automáticamente.
- Comprobar que el cambio está aprobado.
- Probar primero en laboratorio.

### Ejemplo conceptual de datos

```json
{
  "matchers": [
    {
      "name": "instance",
      "value": "server-01:9100",
      "isRegex": false
    }
  ],
  "startsAt": "2026-09-24T20:00:00Z",
  "endsAt": "2026-09-24T20:45:00Z",
  "comment": "Mantenimiento CHG-1042",
  "createdBy": "automation-system"
}
```

Este ejemplo es ilustrativo. El formato exacto depende de la API utilizada.

No incluir tokens reales en comandos, ejemplos o documentación.

---

## Errores frecuentes

### El silencio no afecta a la alerta esperada

Comprobar:

- Nombre de la etiqueta.
- Valor de la etiqueta.
- Uso de expresiones regulares.
- Zona horaria.
- Inicio del silencio.
- Fin del silencio.
- Estado del silencio.
- Etiquetas reales de la alerta.

### El silencio afecta a demasiadas alertas

Causa habitual:

```text
team = systems
```

Solución:

```text
alertname = NodeExporterDown
instance = server-01:9100
```

Utilizar coincidencias más específicas.

### La alerta sigue apareciendo

Esto puede ser normal. Un silencio no necesariamente detiene la evaluación ni oculta el estado de la alerta.

Comprobar si:

- La alerta está activa.
- La notificación está suprimida.
- El silencio coincide.
- El silencio está dentro de su ventana.

### Se siguen recibiendo notificaciones

Comprobar:

- El silencio no ha comenzado.
- El silencio ha expirado.
- Las etiquetas no coinciden.
- La notificación procede de otra regla.
- La alerta se envía a otro sistema.
- Existe una ruta o contacto independiente.
- La agrupación contiene alertas no silenciadas.

### El silencio no termina cuando se esperaba

Comprobar:

- Zona horaria.
- Fecha completa.
- Hora de verano.
- Configuración del navegador.
- Hora del servidor.
- Hora mostrada en Grafana.

### Se olvidó eliminar el silencio

Establecer:

- Fecha de finalización.
- Responsable.
- Revisión posterior.
- Auditoría periódica.

### Se utiliza un silencio para ocultar ruido permanente

Revisar y corregir la regla en lugar de mantener un silencio indefinido.

### No existe comentario

Añadir:

- Motivo.
- Cambio asociado.
- Responsable.
- Fin previsto.

### Se silencia toda producción por error

Revisar cuidadosamente:

```text
environment
team
service
instance
alertname
```

Antes de guardar un silencio amplio, comprobar cuántas alertas coinciden.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/silenciados
```

Crear una plantilla de silencio:

```bash
cat > ~/laboratorio-grafana/evidencias/silenciados/silencio.txt <<'EOF'
Identificador o nombre:

Creador:

Motivo:

Cambio asociado:

Coincidencias:

Inicio:

Fin:

Zona horaria:

Estado:

Alertas afectadas:

Contacto habitual:

Resultado:

Fecha de revisión:

Observaciones:
EOF
```

Crear una plantilla de prueba:

```bash
cat > ~/laboratorio-grafana/evidencias/silenciados/prueba.txt <<'EOF'
Regla:

Instancia:

Estado antes del silencio:

Coincidencias del silencio:

Inicio del silencio:

Fin del silencio:

Estado durante el silencio:

Notificación antes:

Notificación durante:

Notificación después:

Estado de recuperación:

Resultado:

Problemas encontrados:
EOF
```

Crear una plantilla de auditoría:

```bash
cat > ~/laboratorio-grafana/evidencias/silenciados/auditoria.txt <<'EOF'
Fecha de revisión:

Persona responsable:

Silencios activos:

Silencios programados:

Silencios expirados:

Silencios sin comentario:

Silencios demasiado amplios:

Silencios que deben eliminarse:

Acciones realizadas:

Observaciones:
EOF
```

Capturas recomendadas:

```text
01-lista-silencios.png
02-crear-silencio.png
03-coincidencias.png
04-silencio-activo.png
05-alerta-silenciada.png
06-alerta-no-silenciada.png
07-silencio-expirado.png
08-historial-alerta.png
09-anotacion-mantenimiento.png
10-auditoria-silencios.png
```

Antes de guardar capturas, ocultar:

```text
Tokens
Claves API
Direcciones privadas
Datos personales innecesarios
URLs con credenciales
Información confidencial del cambio
```

---

## Práctica integradora

### Objetivo

Crear, probar y revisar un silencio asociado a un mantenimiento de laboratorio.

### Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Una regla de disponibilidad.
- Una instancia de laboratorio.
- Permisos para crear silencios.
- Un contacto de notificación de laboratorio.
- Un entorno controlado.

---

### Tarea 1: revisar la alerta

Utilizar:

```promql
up{job="node_exporter"}
```

Configuración conceptual:

```text
Nombre:
NodeExporterDown

Condición:
Igual a 0

Duración:
1 minuto
```

Etiquetas:

```text
alertname = NodeExporterDown
instance = server-01:9100
team = systems
environment = laboratory
severity = critical
```

Confirmar que la regla está en estado normal.

---

### Tarea 2: crear el silencio

Configurar:

```text
Coincidencias:
alertname = NodeExporterDown
instance = server-01:9100
environment = laboratory

Inicio:
Hora actual

Fin:
20 minutos después

Comentario:
Práctica de mantenimiento autorizada en laboratorio.
Responsable: alumno.
```

Revisar cuidadosamente el alcance antes de guardar.

---

### Tarea 3: activar la alerta

Detener el servicio en el entorno de laboratorio:

```bash
sudo systemctl stop node_exporter
```

Observar:

```text
Estado de la regla
Estado de la instancia
Silencio activo
Notificación suprimida
```

No detener servicios de producción.

---

### Tarea 4: verificar el silencio

Comprobar:

```text
¿La alerta aparece en la lista?

¿La alerta pasa a Pending?

¿La alerta pasa a Alerting?

¿El silencio aparece como activo?

¿Se suprime el mensaje?

¿Otras instancias siguen notificando?
```

---

### Tarea 5: recuperar el servicio

Iniciar Node Exporter:

```bash
sudo systemctl start node_exporter
```

Comprobar:

```text
¿La métrica vuelve a aparecer?

¿La alerta vuelve a Normal?

¿Se recibe la recuperación?

¿El silencio sigue activo?

¿El silencio ha expirado?
```

---

### Tarea 6: revisar el alcance

Crear una segunda alerta o utilizar una segunda instancia:

```text
server-02:9100
```

Comprobar que el silencio de `server-01` no afecta a `server-02`.

---

### Tarea 7: documentar

Completar:

```text
Silencio:

Coincidencias:

Inicio:

Fin:

Motivo:

Alerta afectada:

Estado durante el silencio:

Notificación suprimida:

Instancia no afectada:

Estado final:

Conclusión:
```

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Regla validada | | |
| Estado normal confirmado | | |
| Silencio creado | | |
| Coincidencias revisadas | | |
| Inicio configurado | | |
| Fin configurado | | |
| Comentario añadido | | |
| Silencio activo observado | | |
| Alerta `Pending` observada | | |
| Alerta `Alerting` observada | | |
| Notificación suprimida | | |
| Alerta visible en Grafana | | |
| Segunda instancia no afectada | | |
| Servicio recuperado | | |
| Alerta `Normal` observada | | |
| Silencio expirado o eliminado | | |
| Evidencias guardadas | | |
| Documentación completada | | |

---

## Buenas prácticas

### Utilizar coincidencias específicas

Silenciar únicamente las alertas necesarias.

### Definir siempre un final

No crear silencios indefinidos durante mantenimientos temporales.

### Añadir un comentario claro

Incluir motivo, responsable y referencia.

### Revisar la zona horaria

Utilizar fechas completas y explícitas.

### Comprobar el alcance

Antes de guardar, confirmar qué alertas coinciden.

### Revisar los silencios activos

Una lista de silencios activa debe poder entenderse rápidamente.

### No utilizar silencios como solución permanente

Si una alerta genera ruido, revisar su diseño.

### Proteger las alertas críticas

Silenciar únicamente cuando exista una actividad autorizada.

### Informar al equipo

El equipo de guardia debe saber qué notificaciones están temporalmente suprimidas.

### Revisar después del mantenimiento

Confirmar que:

- El servicio está operativo.
- Las métricas se reciben.
- Las reglas se recuperan.
- El silencio ha terminado.
- Las notificaciones funcionan.

### Mantener auditoría

Registrar:

- Creador.
- Motivo.
- Cambio.
- Inicio.
- Fin.
- Coincidencias.
- Resultado.

### Probar en laboratorio

Antes de utilizar silencios complejos en producción, probar su alcance en un entorno controlado.

---

## Puntos clave

- Un silencio suprime temporalmente las notificaciones de alertas coincidentes.
- Un silencio no elimina la regla.
- Un silencio no corrige el problema.
- Una alerta puede seguir activa mientras está silenciada.
- Las coincidencias de etiquetas determinan el alcance.
- Los silencios específicos son más seguros que los silencios amplios.
- Todo silencio debe tener inicio y final.
- Todo silencio debe incluir un comentario justificativo.
- La zona horaria debe comprobarse cuidadosamente.
- Los silencios activos deben revisarse durante un mantenimiento.
- Los silencios expirados deben auditarse.
- Un silencio no equivale a una regla deshabilitada.
- Un silencio no equivale a una pausa de evaluación.
- Los intervalos de silencio sirven para ventanas recurrentes.
- Las alertas críticas deben silenciarse solo con autorización.
- Las notificaciones suprimidas pueden seguir apareciendo en Grafana.
- Una alerta sin notificación no significa necesariamente que esté resuelta.
- Los silencios demasiado amplios pueden ocultar problemas reales.
- Los silencios no deben utilizarse para ocultar reglas mal diseñadas.
- La creación y eliminación de silencios debe ser trazable.
- El alcance debe probarse con alertas relacionadas y no relacionadas.
- Los mantenimientos deben asociarse a cambios o referencias operativas.
- Después del mantenimiento debe comprobarse la recuperación.
- Las credenciales y datos sensibles no deben incluirse en evidencias.
- Un silencio correctamente gestionado reduce ruido sin eliminar la visibilidad operativa.

---

## Preguntas de comprobación

1. ¿Qué es un silencio?
2. ¿Qué diferencia existe entre un silencio y una regla deshabilitada?
3. ¿Qué diferencia existe entre un silencio y una pausa?
4. ¿Qué diferencia existe entre un silencio y un intervalo de silencio?
5. ¿Qué información debe contener un silencio?
6. ¿Qué función cumplen las coincidencias de etiquetas?
7. ¿Por qué es preferible utilizar silencios específicos?
8. ¿Qué puede ocurrir si se silencia únicamente `team=systems`?
9. ¿Por qué es importante configurar una fecha de finalización?
10. ¿Qué información debería incluir el comentario?
11. ¿Qué revisarías si el silencio no afecta a la alerta esperada?
12. ¿Qué revisarías si el silencio afecta a demasiadas alertas?
13. ¿Puede una alerta aparecer como `Alerting` mientras está silenciada?
14. ¿Se detiene necesariamente la evaluación de una regla durante un silencio?
15. ¿Qué comprobarías antes de silenciar una alerta crítica?
16. ¿Qué revisarías al finalizar un mantenimiento?
17. ¿Por qué debe comprobarse la zona horaria?
18. ¿Cómo probarías que un silencio solo afecta a una instancia?
19. ¿Qué harías si una alerta genera ruido de forma permanente?
20. ¿Qué información registrarías para auditar un silencio?
21. ¿Qué riesgos tiene un silencio indefinido?
22. ¿Cómo comprobarías que las notificaciones vuelven a funcionar?
23. ¿Qué evidencias guardarías durante la práctica?
24. ¿Qué diferencia existe entre una alerta silenciada y una alerta resuelta?
25. ¿Qué características debe tener un silencio seguro y mantenible?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear, comprobar y revisar silencios de forma controlada.

El flujo final será:

```text
Identificar una actividad conocida
        |
        v
Definir las alertas afectadas
        |
        v
Revisar las etiquetas
        |
        v
Crear un silencio específico
        |
        v
Configurar inicio y fin
        |
        v
Añadir el motivo
        |
        v
Comprobar el alcance
        |
        v
Supervisar el mantenimiento
        |
        v
Verificar la recuperación
        |
        v
Eliminar o dejar expirar el silencio
        |
        v
Auditar el resultado
```

Un silencio está correctamente configurado cuando:

- Afecta únicamente a las alertas necesarias.
- Tiene una duración definida.
- Incluye un motivo claro.
- Identifica al responsable.
- Está asociado a una actividad autorizada.
- No oculta alertas no relacionadas.
- Permite seguir observando el estado en Grafana.
- Se revisa durante el mantenimiento.
- Se elimina o expira al finalizar.
- Las notificaciones vuelven a funcionar posteriormente.
- El resultado queda documentado.

Un silencio bien utilizado reduce el ruido durante una actividad conocida. Un silencio mal diseñado puede ocultar una incidencia real. La diferencia está en el alcance, la duración, la justificación y la revisión posterior.