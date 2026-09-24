# Reglas de alerta

Una **regla de alerta** define una condición que Grafana evalúa periódicamente para determinar si existe una situación que requiere atención.

Una regla puede detectar, por ejemplo:

- Un servidor que deja de responder.
- Un uso elevado de CPU.
- Una memoria disponible demasiado baja.
- Un sistema de ficheros casi lleno.
- Una latencia excesiva.
- Una tasa de errores superior al límite establecido.
- La ausencia de datos procedentes de una fuente.

Una regla no consiste únicamente en configurar un umbral. También debe definir:

- La consulta que obtiene los datos.
- La condición que debe cumplirse.
- La frecuencia de evaluación.
- El tiempo que debe mantenerse la condición.
- Las etiquetas de clasificación.
- Las anotaciones descriptivas.
- El comportamiento ante ausencia de datos.
- El comportamiento ante errores.
- El contacto y la política de notificación.

El flujo general es:

```text
Métrica
   |
   v
Consulta PromQL
   |
   v
Expresión o reducción
   |
   v
Condición
   |
   v
Duración
   |
   v
Estado de la alerta
   |
   v
Notificación
```

La interfaz exacta puede variar según la versión de Grafana, pero los conceptos fundamentales se mantienen.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es una regla de alerta.
- Diferenciar una regla de alerta de una métrica y de una notificación.
- Identificar los componentes de una regla.
- Validar una consulta antes de utilizarla en una alerta.
- Crear reglas de alerta basadas en consultas PromQL.
- Configurar expresiones y reducciones.
- Configurar condiciones y umbrales.
- Configurar el intervalo de evaluación.
- Configurar el tiempo de permanencia en estado pendiente.
- Añadir etiquetas a una regla.
- Añadir anotaciones descriptivas.
- Configurar el comportamiento ante ausencia de datos.
- Configurar el comportamiento ante errores de consulta.
- Crear una alerta de disponibilidad.
- Crear una alerta de CPU.
- Crear una alerta de memoria.
- Crear una alerta de almacenamiento.
- Probar una regla en un entorno de laboratorio.
- Diagnosticar una regla que no se activa.
- Documentar una regla y sus pruebas.

---

## Introducción

La monitorización proporciona datos sobre un sistema. Una regla de alerta utiliza esos datos para detectar situaciones relevantes.

Por ejemplo, Prometheus puede proporcionar el estado de un objetivo mediante:

```promql
up{job="node_exporter"}
```

Interpretación habitual:

```text
up = 1  → el objetivo está disponible
up = 0  → el objetivo no está disponible
```

Una regla puede establecer:

```text
Si up es igual a 0 durante un minuto,
activar una alerta.
```

Otro ejemplo es el uso de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

La consulta calcula el porcentaje de CPU utilizada. La regla puede definir:

```text
Si el valor es mayor que 90
durante 5 minutos,
activar una alerta.
```

La consulta responde:

```text
¿Qué valor tiene la métrica?
```

La regla responde:

```text
¿Ese valor representa una situación que requiere atención?
```

---

## Qué es una regla de alerta

Una regla de alerta es una definición que combina una consulta, una condición y una política de evaluación.

## Estructura conceptual

```text
Nombre
  +
Consulta
  +
Expresión
  +
Condición
  +
Intervalo de evaluación
  +
Duración
  +
Etiquetas
  +
Anotaciones
```

## Ejemplo

```text
Nombre:
HighCPUUsage

Consulta:
Uso de CPU por instancia

Condición:
Mayor que 90

Duración:
5 minutos

Etiqueta:
severity=warning

Resultado:
Alerta de CPU elevada
```

Una regla debe representar una situación concreta y accionable.

## Regla accionable

Una regla es accionable cuando el equipo que recibe la alerta sabe:

- Qué ocurre.
- Dónde ocurre.
- Qué importancia tiene.
- Qué debe revisar.
- Qué procedimiento puede seguir.
- Cuándo comenzó el problema.

Ejemplo poco útil:

```text
Problema detectado
```

Ejemplo más útil:

```text
La CPU de server-01 supera el 90 % durante cinco minutos.
Revisar los procesos activos y el runbook de CPU elevada.
```

---

## Componentes de una regla

## Nombre

El nombre debe describir el problema detectado.

Buenos ejemplos:

```text
NodeExporterDown
HighCPUUsage
HighMemoryUsage
FilesystemUsageHigh
HighApplicationLatency
ApplicationErrorRateHigh
```

Ejemplos poco descriptivos:

```text
Alerta1
Regla nueva
Prueba
Problema
```

## Consulta

La consulta obtiene o calcula el valor que será evaluado.

Ejemplo:

```promql
up{job="node_exporter"}
```

## Expresión o reducción

Convierte el resultado en un valor evaluable.

Según la configuración, puede utilizarse una operación como:

```text
Last
Mean
Min
Max
Sum
```

Por ejemplo:

```text
Consulta → varias muestras
Reducción → último valor
Condición → último valor igual a 0
```

## Condición

Compara el resultado con un criterio.

Ejemplos:

```text
Mayor que 90
Menor que 10
Igual a 0
Mayor o igual que 1
```

## Intervalo de evaluación

Indica cada cuánto se evalúa la regla.

Ejemplos:

```text
Cada 30 segundos
Cada 1 minuto
Cada 5 minutos
```

## Duración

Indica cuánto tiempo debe mantenerse la condición antes de activar la alerta.

Ejemplos:

```text
Durante 1 minuto
Durante 5 minutos
Durante 10 minutos
```

## Etiquetas

Clasifican y permiten enrutar la alerta.

Ejemplo:

```text
severity = warning
team = systems
service = node_exporter
environment = laboratory
```

## Anotaciones

Proporcionan información legible para las personas.

Ejemplo:

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

---

## Ciclo de vida de una regla

Una regla pasa por varias fases:

```text
Regla creada
    |
    v
Consulta validada
    |
    v
Evaluación normal
    |
    v
Condición detectada
    |
    v
Pending
    |
    v
Alerting
    |
    v
Notificación
    |
    v
Condición resuelta
    |
    v
Normal
```

## Ejemplo temporal

Configuración:

```text
Condición: CPU > 90 %
Duración: 5 minutos
Evaluación: cada 1 minuto
```

Secuencia:

```text
10:00 - CPU = 45 % → Normal
10:01 - CPU = 93 % → Pending
10:02 - CPU = 94 % → Pending
10:03 - CPU = 92 % → Pending
10:04 - CPU = 91 % → Pending
10:05 - CPU = 93 % → Alerting
10:06 - CPU = 50 % → Normal
```

La duración evita que un pico aislado genere una alerta.

---

## Estados de una regla

## Normal

La condición no se cumple.

```text
CPU actual: 45 %
Umbral: 90 %
Estado: Normal
```

## Pending

La condición se cumple, pero todavía no ha transcurrido la duración configurada.

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Tiempo transcurrido: 2 minutos
Estado: Pending
```

## Alerting o Firing

La condición se ha mantenido durante el tiempo necesario.

```text
CPU actual: 93 %
Duración requerida: 5 minutos
Tiempo transcurrido: 6 minutos
Estado: Alerting
```

## No data

La regla no obtiene datos suficientes para realizar la evaluación.

Posibles causas:

- La métrica no existe.
- El objetivo no responde.
- La consulta no devuelve series.
- Prometheus no está disponible.
- Existe un filtro incorrecto.
- El rango temporal no es adecuado.

## Error

La evaluación no puede completarse por un problema técnico.

Posibles causas:

- Error de sintaxis PromQL.
- Fuente de datos inaccesible.
- Expresión incorrecta.
- Problemas de permisos.
- Configuración incompatible.

---

## Diferencia entre intervalo y duración

Estos conceptos suelen confundirse.

## Intervalo de evaluación

Indica cada cuánto se ejecuta la regla.

```text
Evaluar cada 1 minuto
```

## Duración

Indica cuánto tiempo debe mantenerse la condición.

```text
La condición debe permanecer activa durante 5 minutos
```

## Ejemplo

```text
Intervalo: 1 minuto
Duración: 5 minutos
```

La regla se evalúa cada minuto, pero solo se activa si la condición sigue cumpliéndose durante aproximadamente cinco minutos.

No significa que la consulta se ejecute únicamente después de cinco minutos. Se evalúa en cada intervalo.

---

## Crear una regla en Grafana

El nombre exacto de las opciones puede cambiar según la versión.

Procedimiento general:

1. Acceder a Grafana.
2. Abrir **Alerting**.
3. Seleccionar **Alert rules**.
4. Crear una nueva regla.
5. Introducir el nombre.
6. Seleccionar la fuente de datos.
7. Introducir la consulta.
8. Ejecutar o validar la consulta.
9. Configurar la expresión o reducción.
10. Configurar la condición.
11. Definir el intervalo de evaluación.
12. Definir la duración.
13. Añadir etiquetas.
14. Añadir anotaciones.
15. Configurar la ausencia de datos.
16. Configurar los errores.
17. Guardar la regla.
18. Comprobar el estado.
19. Probar la activación.
20. Documentar el resultado.

Antes de guardar, comprobar que la consulta devuelve datos con las etiquetas esperadas.

---

## Validar una consulta antes de crear la regla

No se debe crear una alerta sobre una consulta que no se ha probado.

## Procedimiento

1. Abrir **Explore**.
2. Seleccionar Prometheus.
3. Introducir la consulta.
4. Ejecutarla.
5. Comprobar si devuelve datos.
6. Revisar las etiquetas.
7. Revisar la unidad.
8. Comprobar si el resultado es el esperado.
9. Probar distintos rangos temporales.
10. Ajustar la consulta si es necesario.

## Consulta de ejemplo

```promql
up{job="node_exporter"}
```

Comprobar:

```text
¿Devuelve 0 o 1?
¿Qué valor tiene instance?
¿Qué valor tiene job?
¿Existen varias instancias?
```

## Consulta de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Comprobar:

```text
¿El resultado está entre 0 y 100?
¿Aparece una serie por instancia?
¿El nombre de la instancia es correcto?
¿El valor se corresponde con el panel de CPU?
```

---

## Ejemplo 1: alerta de disponibilidad

## Objetivo

Detectar que un objetivo supervisado deja de responder.

## Consulta

```promql
up{job="node_exporter"}
```

## Condición

```text
Valor igual a 0
```

## Configuración

```text
Nombre: NodeExporterDown
Intervalo: 30 segundos
Duración: 1 minuto
```

## Etiquetas

```text
severity = critical
team = systems
service = node_exporter
resource = availability
environment = laboratory
```

## Anotaciones

```text
summary = Node Exporter no disponible en {{ $labels.instance }}

description = El objetivo {{ $labels.instance }}
no está respondiendo a Prometheus.

runbook_url = https://example.com/runbooks/node-exporter-down
```

## Interpretación

```text
up = 1 → objetivo disponible
up = 0 → objetivo no disponible
```

## Configuración ante ausencia de datos

Para una alerta de disponibilidad, la ausencia de datos puede considerarse un problema. La decisión depende de la arquitectura y debe documentarse.

---

## Ejemplo 2: alerta de CPU

## Objetivo

Detectar un uso sostenido de CPU superior al límite establecido.

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Condición

```text
Valor mayor que 90
```

## Configuración

```text
Nombre: HighCPUUsage
Intervalo: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
service = node_exporter
resource = cpu
environment = laboratory
```

## Anotaciones

```text
summary = Uso de CPU elevado en {{ $labels.instance }}

description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

## Consideración operativa

Un uso alto de CPU no siempre indica una incidencia. Puede producirse durante:

- Procesamientos planificados.
- Copias de seguridad.
- Compilaciones.
- Pruebas de carga.
- Procesos batch.
- Ventanas de mantenimiento.

Por este motivo, es recomendable utilizar una duración adecuada y consultar las anotaciones del dashboard.

---

## Ejemplo 3: alerta de memoria

## Objetivo

Detectar un uso elevado de memoria.

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Condición

```text
Valor mayor que 90
```

## Configuración

```text
Nombre: HighMemoryUsage
Intervalo: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
environment = laboratory
```

## Anotaciones

```text
summary = Uso de memoria elevado en {{ $labels.instance }}

description = La memoria utilizada en {{ $labels.instance }}
supera el 90 % durante cinco minutos.

runbook_url = https://example.com/runbooks/high-memory
```

## Alternativa: memoria disponible

También se puede evaluar directamente la memoria disponible:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Condición:

```text
Valor menor que 10
```

Ambas estrategias pueden ser válidas. Lo importante es que la unidad y el umbral sean coherentes.

---

## Ejemplo 4: alerta de almacenamiento

## Objetivo

Detectar un sistema de ficheros con ocupación elevada.

## Consulta

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

## Condición

```text
Valor mayor que 80
```

## Configuración

```text
Nombre: FilesystemUsageHigh
Intervalo: 5 minutos
Duración: 10 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = filesystem
mountpoint = /
environment = laboratory
```

## Anotaciones

```text
summary = Sistema de ficheros con ocupación elevada

description = El punto de montaje {{ $labels.mountpoint }}
de {{ $labels.instance }} supera el 80 % de uso.

runbook_url = https://example.com/runbooks/filesystem-full
```

## Precauciones

- Excluir sistemas temporales.
- Filtrar puntos de montaje relevantes.
- Comprobar que el porcentaje está correctamente calculado.
- Considerar el crecimiento esperado.
- No alertar sobre sistemas efímeros sin necesidad.

---

## Ejemplo 5: alerta de latencia

Si la aplicación expone métricas de histograma, puede calcularse un percentil.

## Consulta

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(
      http_request_duration_seconds_bucket[5m]
    )
  )
)
```

## Condición

```text
Valor mayor que 1
```

El resultado representa una latencia aproximada en segundos.

## Configuración

```text
Nombre: HighApplicationLatency
Intervalo: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = application
resource = latency
environment = laboratory
```

## Anotaciones

```text
summary = Latencia p95 elevada

description = El percentil 95 de latencia
supera un segundo durante cinco minutos.

runbook_url = https://example.com/runbooks/high-latency
```

La consulta debe adaptarse a los nombres reales de las métricas y etiquetas de la aplicación.

---

## Etiquetas de una regla

Las etiquetas sirven para clasificar, buscar y enrutar alertas.

## Etiquetas recomendadas

```text
alertname
severity
team
service
environment
instance
resource
```

## Ejemplo

```text
alertname = HighCPUUsage
severity = warning
team = systems
service = node_exporter
environment = laboratory
resource = cpu
```

## Severidad

Una convención habitual es:

```text
info
warning
critical
```

Ejemplo:

```text
severity = warning
```

La organización debe establecer el significado de cada nivel.

No se debe utilizar `critical` para todas las reglas. Si todo se marca como crítico, se pierde la capacidad de priorizar.

## Buenas prácticas

- Utilizar nombres consistentes.
- Mantener una convención común.
- Evitar sinónimos innecesarios.
- No incluir secretos.
- No añadir etiquetas que no se utilicen.
- Documentar las etiquetas que emplean las políticas.

---

## Anotaciones de una regla

Las anotaciones proporcionan contexto a la persona que recibe la alerta.

## `summary`

Texto breve:

```text
summary = CPU elevada en {{ $labels.instance }}
```

## `description`

Descripción ampliada:

```text
description = La CPU de {{ $labels.instance }}
supera el 90 % durante cinco minutos.
```

## `runbook_url`

Enlace al procedimiento:

```text
runbook_url = https://example.com/runbooks/high-cpu
```

## Ejemplo completo

```text
summary = Sistema de ficheros casi lleno en {{ $labels.instance }}

description = El punto de montaje {{ $labels.mountpoint }}
supera el umbral de ocupación configurado.

runbook_url = https://example.com/runbooks/filesystem-full
```

La sintaxis de las variables puede depender de la versión de Grafana y del contexto de la plantilla.

---

## Ausencia de datos

Una regla puede no recibir datos durante una evaluación.

Las opciones habituales son:

```text
No data
Normal
Alerting
```

## `No data`

La regla pasa a un estado de ausencia de datos.

Adecuado cuando:

- La métrica debería existir siempre.
- La ausencia puede indicar una caída.
- Se necesita diferenciar la ausencia de datos del estado normal.

## `Normal`

La ausencia no genera una alerta.

Adecuado cuando:

- La métrica es opcional.
- La ausencia es esperada.
- La consulta solo devuelve series en determinadas circunstancias.

## `Alerting`

La ausencia se considera un problema.

Adecuado cuando:

- La fuente es crítica.
- El objetivo debe responder continuamente.
- No recibir datos equivale a perder visibilidad.

La elección debe documentarse para evitar interpretaciones ambiguas.

---

## Errores de evaluación

Un error no significa necesariamente que la condición sea verdadera.

## Causas habituales

- Error de sintaxis PromQL.
- Prometheus inaccesible.
- Fuente de datos mal configurada.
- Expresión inválida.
- Permisos insuficientes.
- Consulta incompatible con el tipo de datos.

## Procedimiento de diagnóstico

1. Ejecutar la consulta en Explore.
2. Revisar el mensaje de error.
3. Comprobar la fuente de datos.
4. Validar la sintaxis.
5. Revisar los filtros.
6. Comprobar los permisos.
7. Revisar los logs de Grafana.
8. Volver a evaluar la regla.

No se debe ocultar un error configurándolo como un estado normal sin entender su causa.

---

## Grupos de evaluación

Las reglas pueden organizarse en grupos de evaluación.

Un grupo puede compartir:

- Intervalo de evaluación.
- Fuente de datos.
- Organización lógica.
- Contexto operativo.

## Ejemplo

```text
Grupo: Infraestructura - cada 1 minuto
  - HighCPUUsage
  - HighMemoryUsage
  - NodeExporterDown

Grupo: Almacenamiento - cada 5 minutos
  - FilesystemUsageHigh
```

Agrupar las reglas facilita:

- Comprender su frecuencia.
- Administrar su ejecución.
- Mantener una estructura ordenada.
- Detectar configuraciones incoherentes.

El comportamiento exacto depende de la versión y del modelo de alertas utilizado.

---

## Reglas multidimensionales

Una consulta puede devolver varias series.

Ejemplo:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Si existen tres instancias, la consulta puede devolver:

```text
server-01 → 42 %
server-02 → 94 %
server-03 → 55 %
```

La alerta debe poder identificar qué instancia incumple la condición.

Las etiquetas de la serie, como `instance`, permiten generar contexto específico:

```text
CPU elevada en server-02
```

Es importante no eliminar las etiquetas necesarias mediante agregaciones excesivas.

---

## Crear una regla multidimensional

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Condición

```text
Mayor que 90
```

## Resultado esperado

```text
server-01 → Normal
server-02 → Alerting
server-03 → Normal
```

## Actividades

1. Ejecutar la consulta.
2. Identificar las series devueltas.
3. Revisar la etiqueta `instance`.
4. Crear la regla.
5. Añadir `{{ $labels.instance }}` a la anotación.
6. Verificar que la notificación identifica la instancia afectada.

---

## Ejemplo de sesión 1: crear una regla de disponibilidad

## Objetivo

Crear y probar una regla que detecte la caída de Node Exporter.

## Requisitos

- Grafana funcionando.
- Prometheus configurado.
- Node Exporter instalado.
- Permisos para crear reglas.
- Entorno de laboratorio.

## Consulta

```promql
up{job="node_exporter"}
```

## Configuración

```text
Nombre: NodeExporterDown
Condición: igual a 0
Evaluación: cada 30 segundos
Duración: 1 minuto
```

## Etiquetas

```text
severity = critical
team = systems
service = node_exporter
environment = laboratory
```

## Anotaciones

```text
summary = Node Exporter no disponible en {{ $labels.instance }}

description = El objetivo {{ $labels.instance }}
no responde a Prometheus.
```

## Pasos

1. Validar la consulta en Explore.
2. Crear la regla.
3. Configurar la condición.
4. Añadir la duración.
5. Añadir etiquetas.
6. Añadir anotaciones.
7. Guardar.
8. Confirmar el estado normal.
9. Detener Node Exporter:

```bash
sudo systemctl stop node_exporter
```

10. Esperar la evaluación.
11. Observar el cambio de estado.
12. Iniciar el servicio:

```bash
sudo systemctl start node_exporter
```

13. Comprobar la recuperación.
14. Registrar los tiempos.

## Registro

```text
Hora de detención:

Primer estado observado:

Hora de activación:

Hora de recuperación:

Tiempo hasta la activación:

Tiempo hasta la recuperación:

Observaciones:
```

---

## Ejemplo de sesión 2: crear una regla de CPU

## Objetivo

Detectar un uso sostenido de CPU superior al 90 %.

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Configuración

```text
Nombre: HighCPUUsage
Condición: mayor que 90
Evaluación: cada 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = cpu
environment = laboratory
```

## Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La CPU supera el 90 %
durante cinco minutos.

runbook_url = https://example.com/runbooks/high-cpu
```

## Pasos

1. Ejecutar la consulta en Explore.
2. Comprobar la unidad.
3. Crear la regla.
4. Configurar el umbral.
5. Configurar la duración.
6. Añadir las etiquetas.
7. Añadir las anotaciones.
8. Guardar la regla.
9. Generar carga controlada:

```bash
stress-ng --cpu 1 --timeout 60s
```

10. Observar el valor de CPU.
11. Comprobar si aparece `Pending`.
12. Comprobar si llega a `Alerting`.
13. Detener la prueba.
14. Comprobar la recuperación.

Este comando debe utilizarse únicamente en un entorno autorizado de laboratorio.

---

## Ejemplo de sesión 3: diagnosticar una regla que no se activa

## Objetivo

Investigar una regla que permanece en `Normal` aunque aparentemente se cumple la condición.

## Situación

```text
La CPU muestra un valor superior al 90 %,
pero la regla HighCPUUsage no se activa.
```

## Procedimiento

1. Ejecutar la consulta en Explore.
2. Comprobar el valor real.
3. Revisar el nombre de la métrica.
4. Revisar los filtros.
5. Revisar el umbral.
6. Revisar la unidad.
7. Revisar la duración.
8. Revisar el intervalo de evaluación.
9. Comprobar que la regla está habilitada.
10. Comprobar el grupo de evaluación.
11. Revisar si la consulta devuelve varias series.
12. Revisar el comportamiento ante errores.

## Errores posibles

```text
Umbral configurado como 0.90 en lugar de 90.
La consulta filtra una instancia que no existe.
La duración está configurada en 30 minutos.
La regla está pausada.
La consulta no devuelve datos.
La expresión utiliza una reducción incorrecta.
```

## Registro

```text
Nombre de la regla:

Consulta:

Valor observado:

Condición configurada:

Umbral:

Unidad:

Intervalo:

Duración:

Estado inicial:

Causa encontrada:

Corrección aplicada:

Estado final:
```

---

## Ejemplo de sesión 4: configurar una regla multidimensional

## Objetivo

Detectar qué instancia presenta un uso elevado de CPU.

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Configuración

```text
Nombre: HighCPUUsageByInstance
Condición: mayor que 90
Duración: 5 minutos
```

## Anotaciones

```text
summary = CPU elevada en {{ $labels.instance }}

description = La instancia {{ $labels.instance }}
supera el 90 % de uso de CPU.
```

## Actividades

1. Identificar todas las instancias.
2. Comprobar que cada serie conserva `instance`.
3. Crear la regla.
4. Generar carga en una instancia de laboratorio.
5. Observar qué serie cambia de estado.
6. Verificar que la notificación incluye la instancia correcta.
7. Explicar por qué no debe eliminarse la etiqueta `instance`.

---

## Ejemplo de sesión 5: crear una regla de memoria

## Objetivo

Detectar un uso elevado de memoria durante un periodo continuado.

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Configuración

```text
Nombre: HighMemoryUsage
Condición: mayor que 90
Evaluación: cada 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
environment = laboratory
```

## Actividades

1. Validar la consulta.
2. Revisar el valor en porcentaje.
3. Crear la regla.
4. Añadir una anotación descriptiva.
5. Comprobar el estado normal.
6. Simular una situación de laboratorio autorizada si procede.
7. Revisar la transición de estados.
8. Documentar el resultado.

---

## Ejemplo de sesión 6: configurar ausencia de datos

## Objetivo

Observar cómo cambia una regla según la política de ausencia de datos.

## Consulta

```promql
up{job="node_exporter"}
```

## Pasos

1. Crear una regla de disponibilidad.
2. Configurar inicialmente el comportamiento como `No data`.
3. Detener Node Exporter.
4. Esperar varias evaluaciones.
5. Observar el estado.
6. Cambiar la política a `Alerting`.
7. Repetir la prueba.
8. Comparar ambos resultados.
9. Elegir la configuración apropiada para el laboratorio.
10. Documentar la decisión.

## Registro

```text
Configuración utilizada:

Estado con datos ausentes:

Tiempo transcurrido:

Estado esperado:

Estado observado:

Conclusión:
```

---

## Ejemplo de sesión 7: revisar etiquetas y enrutamiento

## Objetivo

Comprobar que una regla contiene las etiquetas que necesita una política de notificación.

## Etiquetas de la regla

```text
severity = critical
team = systems
service = node_exporter
```

## Coincidencia de la política

```text
team = systems
severity = critical
```

## Actividades

1. Crear o revisar la regla.
2. Comprobar las etiquetas.
3. Revisar la política de notificación.
4. Verificar el contacto asignado.
5. Activar la regla en laboratorio.
6. Comprobar el destinatario.
7. Cambiar temporalmente `severity` a `warning`.
8. Repetir la prueba.
9. Explicar el cambio de ruta.

---

## Ejemplo de sesión 8: crear una regla de almacenamiento

## Objetivo

Detectar una ocupación elevada del sistema de ficheros raíz.

## Consulta

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

## Configuración

```text
Nombre: FilesystemUsageHigh
Condición: mayor que 80
Evaluación: cada 5 minutos
Duración: 10 minutos
```

## Actividades

1. Validar la consulta.
2. Revisar la etiqueta `mountpoint`.
3. Comprobar los sistemas de ficheros excluidos.
4. Crear la regla.
5. Añadir un runbook.
6. Documentar por qué se ha utilizado el umbral del 80 %.
7. Revisar la regla en la lista de alertas.

---

## Buenas prácticas

## Validar siempre las consultas

Una consulta debe funcionar correctamente antes de formar parte de una regla.

## Elegir nombres descriptivos

El nombre debe identificar el problema y no solo la métrica.

## Utilizar umbrales coherentes

El umbral debe utilizar la misma unidad que el resultado de la consulta.

Ejemplo:

```text
Consulta: porcentaje de CPU
Umbral: 90
```

No confundir:

```text
0.90
90
```

## Configurar una duración adecuada

La duración debe evitar falsos positivos sin retrasar demasiado la respuesta.

## Conservar las etiquetas útiles

Las etiquetas como `instance`, `service` y `environment` suelen ser necesarias para identificar el origen.

## Añadir contexto

Una alerta sin descripción obliga al operador a investigar desde cero.

## Añadir runbooks

Cuando exista un procedimiento, incluir un enlace accesible para el equipo destinatario.

## Configurar explícitamente `No data`

La ausencia de datos debe ser una decisión consciente, no una configuración olvidada.

## Probar activación y recuperación

Una regla debe probarse en ambos sentidos:

```text
Normal → Alerting
Alerting → Normal
```

## Evitar alertas demasiado sensibles

Una regla que se activa ante cualquier fluctuación produce ruido.

## Evitar alertas demasiado permisivas

Una regla que tarda demasiado puede retrasar la respuesta.

## Revisar las reglas periódicamente

Analizar:

- Alertas repetidas.
- Alertas ignoradas.
- Alertas sin acciones.
- Reglas duplicadas.
- Umbrales obsoletos.
- Contactos incorrectos.
- Runbooks inexistentes.

## Mantener las reglas documentadas

Cada regla debería tener:

- Objetivo.
- Consulta.
- Umbral.
- Duración.
- Etiquetas.
- Contacto.
- Runbook.
- Procedimiento de prueba.

---

## Errores frecuentes

## La consulta no devuelve datos

Comprobar:

- Nombre de la métrica.
- Filtros.
- Etiquetas.
- Rango temporal.
- Disponibilidad de Prometheus.
- Existencia de la serie.

## El resultado está en una unidad inesperada

Comprobar:

- Multiplicaciones por 100.
- Conversión de bytes.
- Conversión de segundos.
- Agregaciones.
- Funciones utilizadas.

## La regla no pasa de `Pending`

Comprobar:

- La condición sigue cumpliéndose.
- La duración configurada.
- El intervalo de evaluación.
- Fluctuaciones de la métrica.
- Reinicios de la regla.
- Cambios de etiquetas.

## La regla nunca se activa

Comprobar:

- Umbral.
- Unidad.
- Fuente de datos.
- Estado de la regla.
- Grupo de evaluación.
- Consulta.
- Expresión o reducción.

## La alerta se activa con demasiada frecuencia

Comprobar:

- Umbral demasiado bajo.
- Duración demasiado corta.
- Métrica ruidosa.
- Ausencia de agregación.
- Varias series duplicadas.
- Reglas duplicadas.

## La notificación no identifica el recurso

Comprobar:

- Que la consulta conserva las etiquetas.
- Que la anotación utiliza correctamente `{{ $labels... }}`.
- Que no se ha aplicado una agregación que elimina `instance`.
- Que el filtro identifica el servicio correcto.

## La alerta aparece como `No data`

Comprobar:

- Objetivo.
- Fuente de datos.
- Consulta.
- Rango temporal.
- Filtros.
- Política de ausencia de datos.

## La alerta aparece como `Error`

Comprobar:

- Sintaxis.
- Expresión.
- Conectividad.
- Permisos.
- Logs.
- Compatibilidad de la consulta.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/reglas-alerta
```

Crear una plantilla para documentar reglas:

```bash
cat > ~/laboratorio-grafana/evidencias/reglas-alerta/registro-regla.txt <<'EOF'
Nombre de la regla:

Objetivo:

Fuente de datos:

Consulta:

Expresión o reducción:

Condición:

Umbral:

Unidad:

Intervalo de evaluación:

Duración:

Etiquetas:

Anotaciones:

Comportamiento ante No data:

Comportamiento ante Error:

Contacto:

Política de notificación:

Runbook:

Prueba de activación:

Prueba de recuperación:

Resultado:

Observaciones:
EOF
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/reglas-alerta/consultas.txt <<'EOF'
Disponibilidad:
up{job="node_exporter"}

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

Almacenamiento:
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

Capturas recomendadas:

```text
01-consulta-validada.png
02-regla-disponibilidad.png
03-regla-cpu.png
04-regla-memoria.png
05-regla-disco.png
06-estado-normal.png
07-estado-pending.png
08-estado-alerting.png
09-estado-resuelto.png
10-regla-multidimensional.png
11-configuracion-no-data.png
12-notificacion-recibida.png
```

---

## Práctica integradora

## Objetivo

Crear, probar y documentar un conjunto de reglas para un servidor de laboratorio.

## Regla 1: disponibilidad

## Consulta

```promql
up{job="node_exporter"}
```

## Configuración

```text
Nombre: NodeExporterDown
Condición: igual a 0
Intervalo: 30 segundos
Duración: 1 minuto
```

## Etiquetas

```text
severity = critical
team = systems
resource = availability
environment = laboratory
```

---

## Regla 2: CPU

## Consulta

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Configuración

```text
Nombre: HighCPUUsage
Condición: mayor que 90
Intervalo: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = cpu
environment = laboratory
```

---

## Regla 3: memoria

## Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Configuración

```text
Nombre: HighMemoryUsage
Condición: mayor que 90
Intervalo: 1 minuto
Duración: 5 minutos
```

## Etiquetas

```text
severity = warning
team = systems
resource = memory
environment = laboratory
```

---

## Actividades

1. Validar las tres consultas en Explore.
2. Crear las tres reglas.
3. Añadir nombres descriptivos.
4. Configurar las condiciones.
5. Configurar los intervalos.
6. Configurar las duraciones.
7. Añadir etiquetas.
8. Añadir anotaciones.
9. Crear un contacto de laboratorio.
10. Configurar una política de notificación.
11. Probar la caída de Node Exporter.
12. Probar una carga controlada de CPU.
13. Revisar los estados.
14. Comprobar las notificaciones.
15. Comprobar la recuperación.
16. Documentar las reglas.
17. Guardar las capturas.
18. Explicar cualquier problema encontrado.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Consulta de disponibilidad validada | | |
| Consulta de CPU validada | | |
| Consulta de memoria validada | | |
| Regla de disponibilidad creada | | |
| Regla de CPU creada | | |
| Regla de memoria creada | | |
| Condiciones configuradas | | |
| Intervalos configurados | | |
| Duraciones configuradas | | |
| Etiquetas añadidas | | |
| Anotaciones añadidas | | |
| Contacto creado | | |
| Política creada | | |
| Estado `Normal` observado | | |
| Estado `Pending` observado | | |
| Estado `Alerting` observado | | |
| Recuperación observada | | |
| Notificación recibida | | |
| Ausencia de datos probada | | |
| Evidencias guardadas | | |
| Documentación completada | | |

---

## Puntos clave

- Una regla de alerta define cuándo una condición debe considerarse relevante.
- Una regla combina consulta, condición, evaluación, duración y contexto.
- La consulta debe validarse antes de utilizarse en una regla.
- El intervalo indica cada cuánto se evalúa la regla.
- La duración indica cuánto tiempo debe mantenerse la condición.
- `Pending` significa que la condición se cumple, pero aún no ha transcurrido la duración.
- `Alerting` significa que la condición se ha mantenido durante el tiempo requerido.
- `Normal` indica que la condición no se cumple.
- `No data` indica que no existen datos suficientes para evaluar.
- `Error` indica que la evaluación no pudo completarse correctamente.
- Las etiquetas permiten clasificar y enrutar alertas.
- Las anotaciones proporcionan contexto legible.
- Las etiquetas de las series deben conservarse cuando sean necesarias para identificar el recurso.
- Los umbrales deben utilizar unidades coherentes con la consulta.
- La duración ayuda a reducir falsos positivos.
- Una regla debe probarse tanto durante la activación como durante la recuperación.
- La ausencia de datos debe configurarse de forma explícita.
- Los nombres de las reglas deben describir el problema detectado.
- Las anotaciones deberían incluir una descripción y, cuando sea posible, un runbook.
- Las reglas deben revisarse periódicamente.
- Una alerta útil debe ser accionable y tener un destinatario adecuado.

---

## Preguntas de comprobación

1. ¿Qué es una regla de alerta?
2. ¿Qué elementos forman parte de una regla?
3. ¿Qué diferencia existe entre una consulta y una condición?
4. ¿Qué diferencia existe entre el intervalo de evaluación y la duración?
5. ¿Qué significa que una regla esté en estado `Pending`?
6. ¿Cuándo pasa una regla al estado `Alerting`?
7. ¿Qué significa el estado `No data`?
8. ¿Qué diferencia existe entre `No data` y `Error`?
9. ¿Por qué se debe validar una consulta antes de crear una regla?
10. ¿Qué función cumplen las etiquetas?
11. ¿Qué información debe incluir una anotación?
12. ¿Cómo crearías una regla para detectar un objetivo no disponible?
13. ¿Cómo crearías una regla para detectar un uso elevado de CPU?
14. ¿Por qué una regla de CPU puede necesitar una duración de varios minutos?
15. ¿Qué revisarías si una regla permanece en `Normal`?
16. ¿Qué revisarías si una regla permanece en `Pending`?
17. ¿Qué revisarías si una regla aparece como `No data`?
18. ¿Por qué es importante conservar la etiqueta `instance`?
19. ¿Qué problemas puede causar un umbral con una unidad incorrecta?
20. ¿Cómo probarías la recuperación de una alerta?
21. ¿Qué diferencia existe entre una alerta unidimensional y una multidimensional?
22. ¿Qué función cumple un grupo de evaluación?
23. ¿Qué información debe documentarse para mantener una regla?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe tener una regla accionable?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear una regla completa, probarla y documentar su comportamiento.

El flujo final será:

```text
Identificar el problema
        |
        v
Seleccionar la métrica
        |
        v
Validar la consulta
        |
        v
Definir la condición
        |
        v
Definir el intervalo
        |
        v
Definir la duración
        |
        v
Añadir etiquetas
        |
        v
Añadir anotaciones
        |
        v
Configurar No data y Error
        |
        v
Guardar la regla
        |
        v
Probar la activación
        |
        v
Observar Pending
        |
        v
Observar Alerting
        |
        v
Comprobar la recuperación
        |
        v
Documentar el resultado
```

Una regla no está terminada cuando se guarda en Grafana. Está terminada cuando:

- La consulta ha sido validada.
- El umbral utiliza la unidad correcta.
- La duración es adecuada.
- Las etiquetas identifican el recurso.
- Las anotaciones explican el problema.
- La notificación llega al contacto correcto.
- La recuperación funciona.
- El procedimiento está documentado.