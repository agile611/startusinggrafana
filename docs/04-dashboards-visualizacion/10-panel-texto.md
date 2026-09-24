# Panel de texto

El panel **Text** de Grafana permite añadir contenido escrito dentro de un dashboard.

Se utiliza para documentar el propósito del dashboard, explicar métricas, indicar procedimientos operativos, mostrar advertencias y proporcionar enlaces útiles.

A diferencia de los paneles Stat, Gauge o Time series, el panel Text no representa principalmente una métrica. Su función es aportar contexto y facilitar la interpretación de los demás paneles.

Ejemplos de contenido que puede incluir:

- Descripción del servicio monitorizado.
- Información del entorno.
- Fecha de la última revisión.
- Responsable del dashboard.
- Significado de los colores.
- Procedimientos ante incidencias.
- Enlaces a documentación.
- Consultas PromQL utilizadas.
- Advertencias operativas.
- Notas para los alumnos.
- Información sobre ventanas de mantenimiento.

---

### Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Text.
- Diferenciar un panel Text de un panel de métricas.
- Crear un panel de texto.
- Utilizar Markdown para documentar un dashboard.
- Utilizar variables de dashboard dentro del texto.
- Añadir títulos, listas, tablas y bloques de código.
- Crear enlaces desde un panel Text.
- Mostrar información sobre el entorno monitorizado.
- Documentar umbrales y colores.
- Añadir instrucciones para resolver incidencias.
- Crear una portada para un dashboard.
- Organizar paneles Text junto con paneles de métricas.
- Comprender las diferencias entre Markdown, HTML y texto plano.
- Aplicar buenas prácticas de seguridad.
- Evitar incluir credenciales o información sensible.
- Utilizar un panel Text como guía de laboratorio.
- Diagnosticar problemas de visualización.
- Exportar un dashboard que contenga paneles Text.
- Documentar correctamente el propósito de cada panel.

---

## Introducción

Un dashboard sin contexto puede ser difícil de interpretar.

Un usuario puede observar un valor elevado, una línea roja o un panel vacío y no saber:

- Qué métrica está viendo.
- Qué significa el color.
- Qué equipo es responsable.
- Qué valores son normales.
- Qué debe hacer ante una incidencia.
- Qué entorno está representado.
- Cuándo se actualizó la información.

El panel Text permite añadir esa información directamente dentro del dashboard.

Un dashboard documentado puede tener esta estructura:

```text
+------------------------------------------------------+
| Información general del dashboard                    |
+------------------------------------------------------+
| Disponibilidad       | Uso de CPU                    |
+------------------------------------------------------+
| Uso de memoria       | Uso de almacenamiento         |
+------------------------------------------------------+
| Tráfico de red                                        |
+------------------------------------------------------+
| Procedimiento ante una incidencia                    |
+------------------------------------------------------+
```

El contenido del panel puede escribirse en:

- Texto plano.
- Markdown.
- HTML, según la configuración y la versión de Grafana.

Para documentación técnica, Markdown suele ser la opción más práctica.

---

## Cuándo utilizar un panel Text

El panel Text es apropiado cuando se necesita:

- Explicar el objetivo del dashboard.
- Documentar el entorno.
- Indicar el significado de las métricas.
- Mostrar instrucciones operativas.
- Añadir enlaces.
- Presentar una tabla de responsables.
- Mostrar una advertencia.
- Incluir comandos de diagnóstico.
- Separar visualmente grupos de paneles.
- Crear material de prácticas.

### Ejemplos adecuados

#### Descripción del dashboard

```markdown
Este dashboard muestra el estado de los servidores Linux
monitorizados mediante Prometheus y Node Exporter.
```

#### Leyenda de colores

```markdown
- Verde: estado normal
- Amarillo: requiere revisión
- Rojo: situación crítica
```

#### Procedimiento de diagnóstico

```markdown
1. Comprobar la disponibilidad del objetivo.
2. Revisar el uso de CPU y memoria.
3. Comprobar el espacio disponible.
4. Revisar los logs del servicio.
```

#### Información del entorno

```markdown
| Elemento | Valor |
|---|---|
| Entorno | Laboratorio |
| Fuente de datos | Prometheus |
| Exporter | Node Exporter |
| Responsable | Equipo de sistemas |
```

---

## Cuándo no utilizar un panel Text

El panel Text no debe utilizarse como sustituto de una métrica cuando se necesita:

- Mostrar un valor actualizado automáticamente.
- Representar una tendencia.
- Mostrar una alerta dinámica.
- Calcular porcentajes.
- Comparar servidores.
- Visualizar latencias.
- Representar disponibilidad en tiempo real.

Para esas necesidades utilizar:

| Necesidad | Panel recomendado |
|---|---|
| Valor actual | Stat |
| Valor frente a límites | Gauge |
| Comparación de valores | Bar Gauge |
| Evolución temporal | Time series |
| Distribución | Heatmap |
| Datos tabulares | Table |
| Documentación | Text |

El panel Text puede acompañar a estos paneles, pero no reemplaza sus funciones.

---

## Modos de visualización

El panel Text puede ofrecer diferentes modos de edición y representación.

### Texto plano

Muestra el contenido sin formato especial.

Ejemplo:

```text
Dashboard de infraestructura.
Entorno: laboratorio.
Fuente de datos: Prometheus.
```

Es adecuado para mensajes breves.

### Markdown

Permite utilizar:

- Títulos.
- Listas.
- Tablas.
- Enlaces.
- Negrita.
- Cursiva.
- Bloques de código.
- Citas.
- Separadores.

Ejemplo:

```markdown
## Monitorización de servidores

**Entorno:** laboratorio

- CPU
- Memoria
- Disco
- Red
```

Markdown suele ser el modo recomendado para documentación técnica.

### HTML

Permite utilizar elementos HTML si la versión y la configuración de Grafana lo permiten.

Ejemplo:

```html
<h2>Monitorización de servidores</h2>
<p>Entorno de laboratorio.</p>
```

El uso de HTML debe realizarse con precaución porque puede estar restringido por razones de seguridad.

---

## Crear un panel Text

### Procedimiento general

1. Abrir Grafana.
2. Acceder a un dashboard.
3. Añadir un panel.
4. Seleccionar la visualización `Text`.
5. Seleccionar el modo de edición.
6. Introducir el contenido.
7. Cambiar a la vista de previsualización.
8. Revisar el formato.
9. Guardar el panel.
10. Guardar el dashboard.

### Contenido inicial recomendado

```markdown
## Dashboard de monitorización

Este dashboard muestra el estado de los servidores Linux
del entorno de laboratorio.

### Fuente de datos

- Prometheus
- Node Exporter

### Métricas principales

- Disponibilidad
- CPU
- Memoria
- Almacenamiento
- Red
```

---

## Sintaxis básica de Markdown

### Títulos

```markdown
## Título principal

### Sección

#### Subsección
```

Resultado conceptual:

## Título principal

### Sección

#### Subsección

### Negrita

```markdown
**Texto importante**
```

Resultado:

**Texto importante**

### Cursiva

```markdown
*Texto destacado*
```

Resultado:

*Texto destacado*

### Listas sin ordenar

```markdown
- CPU
- Memoria
- Disco
- Red
```

### Listas ordenadas

```markdown
1. Comprobar la alerta.
2. Revisar el dashboard.
3. Ejecutar las comprobaciones.
4. Documentar el resultado.
```

### Enlaces

```markdown
[Documentación de Grafana](https://grafana.com/docs/)
```

### Código en línea

```markdown
Utiliza la consulta `up` para comprobar la disponibilidad.
```

### Bloques de código

````markdown
```promql
sum(up)
```
````

### Separadores

```markdown
---
```

### Citas

```markdown
> Los paneles deben documentar el contexto necesario
> para interpretar correctamente las métricas.
```

---

## Crear tablas

Las tablas son útiles para mostrar información estructurada.

Ejemplo:

```markdown
| Métrica | Unidad | Umbral de advertencia |
|---|---|---:|
| CPU | % | 70 |
| Memoria | % | 70 |
| Almacenamiento | % | 80 |
| Disponibilidad | % | 90 |
```

Resultado:

| Métrica | Unidad | Umbral de advertencia |
|---|---|---:|
| CPU | % | 70 |
| Memoria | % | 70 |
| Almacenamiento | % | 80 |
| Disponibilidad | % | 90 |

### Recomendaciones para las tablas

- Utilizar pocas columnas.
- Mantener los nombres breves.
- Alinear correctamente los valores numéricos.
- Evitar tablas demasiado anchas.
- No incluir información sensible.
- Utilizar la misma terminología que en los demás paneles.

---

## Crear bloques de código

Un bloque de código puede documentar:

- Consultas PromQL.
- Comandos de Linux.
- URLs.
- Fragmentos de configuración.
- Procedimientos de diagnóstico.

### Consulta PromQL

````markdown
```promql
100 * avg(up)
```
````

### Comando de Linux

````markdown
```bash
systemctl status node_exporter
```
````

### Configuración

````markdown
```text
Entorno: laboratorio
Fuente de datos: Prometheus
Rango temporal: Last 1 hour
```
````

Es recomendable indicar el lenguaje cuando sea posible:

```markdown
```promql
...
```
```

Esto mejora la legibilidad y el resaltado de sintaxis.

---

## Utilizar variables de dashboard

Las variables permiten mostrar información dinámica en un panel Text.

Ejemplos habituales:

```text
$instance
$job
$service
$environment
```

### Ejemplo de texto dinámico

```markdown
## Monitorización de `$instance`

Este panel muestra información de la instancia seleccionada:

- Instancia: `$instance`
- Job: `$job`
- Entorno: `$environment`
```

Cuando el usuario cambia la variable, el texto puede actualizarse.

### Ejemplo con una variable de servicio

```markdown
### Servicio seleccionado

El dashboard está mostrando actualmente:

**Servicio:** `$service`

Revisa los paneles inferiores para consultar su disponibilidad,
rendimiento y consumo de recursos.
```

### Precauciones

- Comprobar que la variable existe.
- Utilizar exactamente el nombre configurado.
- Verificar el comportamiento con `All`.
- Revisar qué ocurre si no se selecciona ningún valor.
- Evitar mostrar variables que contengan información sensible.

---

## Utilizar enlaces

Un panel Text puede incluir enlaces a:

- Documentación.
- Runbooks.
- Wikis.
- Tickets.
- Repositorios.
- Herramientas de administración.
- Paneles relacionados.
- Procedimientos de operación.

### Ejemplo

```markdown
### Enlaces útiles

- [Documentación de Grafana](https://grafana.com/docs/)
- [Documentación de Prometheus](https://prometheus.io/docs/)
- [Runbook de incidencias](https://example.com/runbooks/monitorizacion)
- [Repositorio de dashboards](https://example.com/repositorio/dashboards)
```

### Enlaces internos

Según la configuración, pueden utilizarse enlaces a otros dashboards:

```markdown
[Dashboard de red](/d/ID_DEL_DASHBOARD/redes)
```

La URL exacta depende de la instancia de Grafana y del identificador del dashboard.

### Buenas prácticas

- Utilizar textos descriptivos.
- No mostrar URLs enormes si no son necesarias.
- Comprobar que los enlaces funcionan.
- Revisar los permisos del destino.
- No enlazar a información pública si el dashboard contiene datos internos.
- No incluir tokens en las URLs.

---

## Crear una portada de dashboard

Un panel Text puede colocarse en la parte superior como portada.

### Ejemplo

```markdown
## Monitorización de infraestructura

Este dashboard resume el estado de los servidores Linux
del entorno de producción.

### Información del entorno

| Elemento | Valor |
|---|---|
| Entorno | Producción |
| Fuente de datos | Prometheus |
| Exporter principal | Node Exporter |
| Actualización | Cada 30 segundos |
| Responsable | Equipo de operaciones |

### Lectura recomendada

1. Comprobar la disponibilidad.
2. Revisar los indicadores de CPU y memoria.
3. Analizar las tendencias temporales.
4. Consultar los paneles de detalle.
```

### Ubicación recomendada

Colocar la portada:

```text
En la parte superior del dashboard
```

Debe ser visible antes de los paneles de métricas.

---

## Documentar unidades y umbrales

El panel Text puede explicar cómo interpretar los valores.

### Ejemplo

```markdown
### Interpretación de los colores

| Color | Significado |
|---|---|
| Verde | Funcionamiento normal |
| Amarillo | Valor elevado; requiere revisión |
| Rojo | Situación crítica o posible incidencia |

### Umbrales

- CPU:
  - Advertencia: 70 %
  - Crítico: 90 %
- Memoria:
  - Advertencia: 70 %
  - Crítico: 90 %
- Almacenamiento:
  - Advertencia: 80 %
  - Crítico: 90 %
```

### Importante

Los umbrales visuales del texto deben coincidir con los configurados en los paneles.

No se debe documentar:

```text
CPU crítica a partir del 80 %
```

si el Gauge y el Time series utilizan realmente:

```text
CPU crítica a partir del 90 %
```

---

## Documentar consultas PromQL

Un panel Text puede incluir las consultas principales del dashboard.

### Ejemplo

````markdown
### Consultas principales

#### Disponibilidad

```promql
sum(up)
```

#### Uso de CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

#### Uso de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```
````

### Recomendaciones

- Documentar únicamente las consultas importantes.
- Añadir una breve explicación.
- Indicar la unidad.
- Indicar el intervalo utilizado por `rate()`.
- Evitar crear un panel Text demasiado largo.
- Utilizar enlaces a documentación detallada cuando sea necesario.

---

## Crear instrucciones de operación

El panel Text puede contener procedimientos para operadores.

### Ejemplo

```markdown
## Procedimiento ante una alerta de CPU

1. Comprueba qué instancia presenta el valor elevado.
2. Revisa la evolución en el panel de CPU.
3. Comprueba la carga del sistema.
4. Identifica los procesos con mayor consumo.
5. Revisa si existe una tarea programada.
6. Comprueba los logs de la aplicación.
7. Documenta las acciones realizadas.
```

### Comandos relacionados

````markdown
```bash
uptime
top
ps aux --sort=-%cpu | head
journalctl -u nombre-del-servicio --since "15 minutes ago"
```
````

### Advertencia

Los comandos mostrados deben adaptarse al entorno. No se deben incluir comandos destructivos o peligrosos sin una explicación clara y autorización.

---

## Crear una guía de diagnóstico

### Ejemplo

```markdown
## Diagnóstico de un objetivo caído

### 1. Comprobar Prometheus

```bash
systemctl status prometheus
```

### 2. Comprobar Node Exporter

```bash
systemctl status node_exporter
```

### 3. Comprobar conectividad

```bash
curl http://localhost:9100/metrics
```

### 4. Comprobar desde Prometheus

```promql
up
```

### 5. Revisar los logs

```bash
journalctl -u node_exporter --since "15 minutes ago"
```
```

Este contenido debe adaptarse a la arquitectura real del laboratorio.

---

## Mostrar avisos y advertencias

Un panel Text puede destacar información importante.

### Ejemplo

```markdown
> **Aviso de mantenimiento**
>
> El servicio de Prometheus será reiniciado durante la sesión práctica.
> Es normal observar valores `0` o huecos temporales en los paneles.
```

### Ejemplo de advertencia de seguridad

```markdown
> **Información sensible**
>
> Este dashboard contiene nombres internos de servidores.
> No debe compartirse fuera de la organización.
```

### Recomendaciones

- Utilizar avisos breves.
- Colocarlos cerca de los paneles afectados.
- Indicar fechas cuando sea necesario.
- Retirar los avisos obsoletos.
- No utilizar demasiadas advertencias.

---

## Crear una guía para alumnos

El panel Text puede servir como instrucciones de laboratorio.

### Ejemplo

```markdown
## Práctica: análisis de recursos

### Objetivo

Analizar el uso de CPU, memoria y almacenamiento
durante los últimos 30 minutos.

### Tareas

1. Identifica la instancia con mayor CPU.
2. Comprueba la evolución de la memoria.
3. Revisa el espacio disponible.
4. Genera una carga controlada.
5. Observa el cambio en el dashboard.
6. Documenta tus conclusiones.

### Evidencias

- Captura del panel de CPU.
- Captura del panel de memoria.
- Captura del dashboard durante la carga.
- Informe de resultados.
```

Este tipo de panel permite que las instrucciones estén junto a las métricas que deben analizarse.

---

## Crear separadores visuales

Los paneles Text pueden utilizarse para separar secciones.

### Ejemplo

```markdown
## Estado general

Los siguientes paneles muestran los indicadores principales.
```

Después:

```markdown
## Recursos del sistema

Esta sección muestra CPU, memoria y almacenamiento.
```

Después:

```markdown
## Red

Esta sección muestra el tráfico y el estado de las interfaces.
```

### Recomendación

Usar separadores cuando el dashboard tenga muchos paneles.

No crear demasiadas secciones, porque una estructura excesivamente fragmentada dificulta la navegación.

---

## Mostrar información dinámica de tiempo

Grafana ofrece variables globales o funciones que pueden estar disponibles según la versión y el contexto.

También se puede documentar el rango seleccionado utilizando texto fijo:

```markdown
### Periodo de análisis

Utiliza el selector temporal del dashboard para cambiar
el intervalo de consulta.
```

No se debe asumir que todas las variables de tiempo funcionan igual en todas las versiones.

La forma más fiable consiste en:

- Utilizar el selector temporal de Grafana.
- Documentar el rango recomendado.
- Explicar qué rango usar en cada práctica.

---

## Utilizar HTML con precaución

HTML puede permitir diseños personalizados, pero introduce riesgos y limitaciones.

### Ejemplo sencillo

```html
<h2>Monitorización de infraestructura</h2>
<p>Entorno de laboratorio.</p>
```

### Posibles restricciones

Según la versión y la configuración:

- Algunas etiquetas pueden no representarse.
- El HTML puede sanitizarse.
- Los estilos pueden eliminarse.
- Los scripts pueden bloquearse.
- El contenido activo puede estar deshabilitado.
- El resultado puede variar entre versiones.

### Recomendación

Utilizar Markdown para la documentación habitual.

Reservar HTML para casos controlados y previamente probados.

No incluir:

- Scripts.
- Código externo.
- Formularios.
- Contenido no confiable.
- Código copiado sin revisar.
- Tokens.
- Credenciales.

---

## Seguridad del panel Text

Aunque el panel Text parezca estático, puede contener información sensible.

No incluir:

- Contraseñas.
- Tokens de API.
- Claves privadas.
- Cadenas de conexión.
- Datos personales.
- Direcciones internas innecesarias.
- Información de clientes.
- Enlaces sin protección.
- Credenciales dentro de URLs.

### Ejemplo incorrecto

```markdown
Token de Prometheus:

```text
eyJhbGciOi...
```
```

### Ejemplo correcto

```markdown
Para consultar la API se necesita un token con permisos de lectura.
El token debe almacenarse en una variable segura y nunca en el dashboard.
```

### Compartición

Antes de compartir un dashboard, revisar:

- El contenido de los paneles Text.
- Los enlaces.
- Las URLs.
- Los nombres de servidores.
- Las instrucciones operativas.
- Las consultas.
- Los nombres de usuarios.
- Los datos de producción.

---

## Ejemplo completo 1: portada de monitorización

### Contenido

```markdown
## Monitorización de infraestructura

Este dashboard muestra el estado operativo de los servidores
Linux monitorizados mediante Prometheus y Node Exporter.

### Entorno

| Elemento | Valor |
|---|---|
| Entorno | Laboratorio |
| Fuente de datos | Prometheus |
| Exporter | Node Exporter |
| Rango recomendado | Última hora |
| Actualización | Según la configuración del dashboard |

### Paneles disponibles

1. Disponibilidad de los objetivos.
2. Uso de CPU.
3. Uso de memoria.
4. Uso del sistema de ficheros.
5. Tráfico de red.
6. Tendencias temporales.

### Interpretación

- Verde: situación normal.
- Amarillo: valor elevado; revisar.
- Rojo: situación crítica o posible incidencia.

> No compartas este dashboard fuera del entorno autorizado.
```

---

## Ejemplo completo 2: documentación de recursos

### Contenido

```markdown
## Recursos del sistema

### CPU

El porcentaje de CPU se calcula a partir del tiempo
que las CPUs no están en estado `idle`.

Consulta utilizada:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria

El uso de memoria se calcula a partir de la memoria disponible
y la memoria total.

Consulta utilizada:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento

El uso del sistema de ficheros raíz excluye `tmpfs` y `overlay`.

Consulta utilizada:

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
```

---

## Ejemplo completo 3: procedimiento operativo

### Contenido

```markdown
## Procedimiento ante una incidencia

### Paso 1: disponibilidad

Comprueba si el objetivo aparece como disponible:

```promql
up
```

### Paso 2: recursos

Revisa:

- CPU.
- Memoria.
- Almacenamiento.
- Tráfico de red.

### Paso 3: tendencia

Amplía el rango temporal para comprobar
cuándo comenzó el problema.

### Paso 4: sistema operativo

Ejecuta las comprobaciones autorizadas:

```bash
uptime
free -h
df -h
```

### Paso 5: documentación

Registra:

- Hora de inicio.
- Instancia afectada.
- Métrica observada.
- Valor máximo.
- Acciones realizadas.
- Resultado final.
```

---

## Ejemplo de sesión 1: crear una portada

### Objetivo

Añadir una portada documentada al dashboard principal.

### Pasos

1. Abrir el dashboard.
2. Añadir un panel.
3. Seleccionar `Text`.
4. Seleccionar Markdown.
5. Introducir:

```markdown
## Dashboard de monitorización

Este dashboard muestra el estado de los servidores Linux
del entorno de laboratorio.

### Orden de lectura

1. Disponibilidad.
2. CPU y memoria.
3. Almacenamiento.
4. Red.
5. Tendencias.
```

6. Revisar la previsualización.
7. Redimensionar el panel para que ocupe el ancho completo.
8. Moverlo a la parte superior.
9. Guardar el panel.
10. Guardar el dashboard.

### Actividades

1. Añade una tabla del entorno.
2. Añade una sección de interpretación.
3. Añade un enlace a la documentación de Grafana.
4. Comprueba la lectura en pantalla completa.
5. Exporta el dashboard.

---

## Ejemplo de sesión 2: documentar umbrales

### Objetivo

Crear un panel Text que explique los colores utilizados en el dashboard.

### Contenido

```markdown
## Interpretación de umbrales

| Métrica | Verde | Amarillo | Rojo |
|---|---:|---:|---:|
| CPU | < 70 % | 70-89 % | >= 90 % |
| Memoria | < 70 % | 70-89 % | >= 90 % |
| Almacenamiento | < 80 % | 80-89 % | >= 90 % |
| Disponibilidad | >= 99 % | 90-98 % | < 90 % |

> Los umbrales son orientativos para el laboratorio.
> En producción deben adaptarse al comportamiento del servicio.
```

### Actividades

1. Crea el panel.
2. Colócalo junto a los Gauges.
3. Comprueba que coincide con los umbrales reales.
4. Modifica un umbral de un Gauge.
5. Actualiza la documentación.
6. Explica por qué deben mantenerse sincronizados.

---

## Ejemplo de sesión 3: documentar consultas PromQL

### Objetivo

Crear una sección de referencia para las consultas principales.

### Contenido

````markdown
## Consultas de referencia

### Disponibilidad

```promql
sum(up)
```

### CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Carga del sistema

```promql
node_load1
```

### Nota

Las consultas se ejecutan contra la fuente de datos Prometheus.
El intervalo `[5m]` representa la ventana utilizada para calcular tasas.
````

### Actividades

1. Añade las consultas utilizadas en tu dashboard.
2. Indica la unidad de cada resultado.
3. Explica qué consulta devuelve un único valor.
4. Explica qué consultas devuelven varias series.
5. Revisa que los bloques de código se muestran correctamente.

---

## Ejemplo de sesión 4: utilizar variables

### Objetivo

Mostrar en el texto la instancia seleccionada.

### Requisito

Debe existir una variable llamada:

```text
instance
```

### Contenido

```markdown
## Servidor seleccionado

El dashboard está mostrando información de:

- **Instancia:** `$instance`
- **Job:** `$job`

Utiliza el selector superior para cambiar
la instancia analizada.
```

### Actividades

1. Crea la variable `instance`.
2. Añade el panel Text.
3. Selecciona diferentes instancias.
4. Comprueba si el texto cambia.
5. Prueba la opción `All`.
6. Documenta el resultado.

---

## Ejemplo de sesión 5: crear un procedimiento de incidencia

### Objetivo

Crear instrucciones para investigar un servidor con CPU elevada.

### Contenido

```markdown
## Procedimiento: CPU elevada

### Indicador inicial

Revisa el panel **Uso de CPU por instancia**.

### Comprobaciones

1. Identifica la instancia afectada.
2. Amplía el rango temporal.
3. Comprueba si el aumento es puntual o sostenido.
4. Revisa la carga del sistema.
5. Consulta los procesos con mayor consumo.

### Comandos autorizados

```bash
uptime
top
ps aux --sort=-%cpu | head
```

### Documentar

- Instancia afectada.
- Hora de inicio.
- Valor máximo.
- Proceso identificado.
- Acción realizada.
- Resultado.
```

### Actividades

1. Añade el procedimiento al dashboard.
2. Genera carga controlada en el laboratorio.
3. Sigue las instrucciones.
4. Completa un informe.
5. Retira el procedimiento si ya no es necesario para el dashboard operativo.

---

## Ejemplo de sesión 6: crear un panel Text para una práctica

### Objetivo

Utilizar el panel Text como guía de trabajo para los alumnos.

### Contenido

```markdown
## Práctica: análisis del servidor

### Objetivo

Analizar la disponibilidad y el consumo de recursos
durante los últimos 30 minutos.

### Tareas

1. Comprueba el número de objetivos disponibles.
2. Identifica la instancia con mayor uso de CPU.
3. Revisa el porcentaje de memoria utilizada.
4. Comprueba el espacio disponible.
5. Genera carga de CPU de forma controlada.
6. Observa el cambio en los paneles.
7. Detén la carga.
8. Documenta la recuperación.

### Evidencias

- Captura del dashboard inicial.
- Captura durante la carga.
- Captura después de la recuperación.
- Tabla con los valores observados.
- Conclusiones.
```

### Actividades

1. Crea el panel.
2. Colócalo en la parte superior.
3. Completa la práctica.
4. Añade una sección de resultados.
5. Exporta el dashboard.

---

## Ejemplo de sesión 7: crear enlaces internos

### Objetivo

Añadir enlaces a otros dashboards relacionados.

### Contenido

```markdown
## Dashboards relacionados

- [Resumen de infraestructura](/d/ID_RESUMEN/infraestructura)
- [Monitorización de red](/d/ID_RED/redes)
- [Aplicaciones](/d/ID_APLICACIONES/aplicaciones)
```

Los identificadores son ejemplos. Deben sustituirse por las rutas reales de la instancia.

### Actividades

1. Crea tres dashboards relacionados.
2. Copia sus enlaces.
3. Añade los enlaces al panel Text.
4. Comprueba que funcionan.
5. Revisa los permisos de acceso.
6. Prueba el comportamiento con un usuario sin permisos.

---

## Ejemplo de sesión 8: revisar seguridad del contenido

### Objetivo

Identificar información que no debe incluirse en un panel Text.

### Contenido incorrecto

```markdown
## Acceso a la API

Token:

```text
TOKEN_SECRETO
```

URL:

```text
https://usuario:contraseña@example.com
```
```

### Contenido corregido

```markdown
## Acceso a la API

La API requiere autenticación.

- Utiliza un token de lectura.
- Almacénalo en una ubicación segura.
- No lo incluyas en el dashboard.
- No lo guardes en el repositorio.
- Revócalo cuando ya no sea necesario.
```

### Actividades

1. Revisa los paneles Text existentes.
2. Busca tokens, contraseñas y URLs sensibles.
3. Elimina la información confidencial.
4. Sustitúyela por instrucciones seguras.
5. Documenta la revisión.

---

## Ejemplo de sesión 9: comparar Markdown y HTML

### Objetivo

Observar las diferencias entre los modos de edición.

### Markdown

```markdown
### Estado del laboratorio

- Prometheus: disponible
- Grafana: disponible
- Node Exporter: disponible
```

### HTML

```html
<h2>Estado del laboratorio</h2>
<ul>
  <li>Prometheus: disponible</li>
  <li>Grafana: disponible</li>
  <li>Node Exporter: disponible</li>
</ul>
```

### Actividades

1. Crea un panel Markdown.
2. Crea un panel HTML.
3. Compara la representación.
4. Comprueba qué etiquetas están permitidas.
5. Determina cuál es más fácil de mantener.
6. Documenta las restricciones observadas.

---

## Ejemplo de sesión 10: exportar un dashboard documentado

### Objetivo

Conservar una copia del dashboard con sus paneles Text.

### Pasos

1. Abrir el dashboard.
2. Comprobar todos los paneles Text.
3. Revisar enlaces.
4. Revisar variables.
5. Revisar comandos.
6. Revisar información sensible.
7. Exportar el dashboard en JSON.
8. Guardar el fichero con un nombre descriptivo:

```text
dashboard-infraestructura-documentado.json
```

9. Validar el JSON:

```bash
jq empty dashboard-infraestructura-documentado.json
```

10. Importar una copia en otro dashboard.
11. Comprobar que el contenido Text se conserva.

### Actividades

1. Exporta el dashboard.
2. Importa una copia.
3. Comprueba los paneles Text.
4. Comprueba las variables.
5. Comprueba los enlaces.
6. Documenta cualquier diferencia.

---

## Buenas prácticas

### Colocar la documentación donde sea visible

La portada debe estar normalmente al principio del dashboard.

### Utilizar títulos claros

Ejemplos:

```text
Información del entorno
Interpretación de umbrales
Procedimiento ante incidencias
Consultas PromQL
Dashboards relacionados
```

### Mantener el contenido breve

Un panel Text no debe convertirse en un manual completo.

Para contenidos extensos:

- Crear una página de documentación externa.
- Añadir un enlace.
- Dividir el contenido en varios paneles.
- Utilizar un repositorio.
- Utilizar un wiki.

### Mantener sincronizada la documentación

Actualizar el panel cuando cambien:

- Métricas.
- Umbrales.
- Nombres de servicios.
- Fuentes de datos.
- Procedimientos.
- Enlaces.
- Responsables.

### Utilizar Markdown preferentemente

Markdown suele ofrecer un equilibrio adecuado entre:

- Legibilidad.
- Mantenimiento.
- Seguridad.
- Portabilidad.
- Sencillez.

### No incluir secretos

Los paneles Text forman parte del dashboard y pueden exportarse.

### Documentar las unidades

Indicar si una métrica se expresa en:

```text
%
Bytes
Bytes por segundo
Segundos
Grados Celsius
```

### Utilizar tablas pequeñas

Las tablas muy anchas dificultan la lectura en pantallas pequeñas.

### Revisar el dashboard completo

La documentación debe concordar con:

- Consultas.
- Títulos.
- Unidades.
- Umbrales.
- Variables.
- Enlaces.

---

## Problemas habituales

### El texto no se muestra correctamente

Comprobar:

- El modo de edición.
- La sintaxis Markdown.
- Las comillas invertidas.
- Los bloques de código.
- Las listas.
- La previsualización.
- La versión de Grafana.

### La tabla aparece deformada

Revisar:

- Número de columnas.
- Separadores `|`.
- Línea de separación entre cabecera y contenido.
- Longitud del texto.
- Ancho del panel.

Ejemplo válido:

```markdown
| Elemento | Estado |
|---|---|
| Prometheus | Disponible |
| Grafana | Disponible |
```

### El enlace no funciona

Comprobar:

- URL.
- Protocolo `https://`.
- Permisos.
- Identificador del dashboard.
- Organización.
- Acceso de la cuenta actual.

### La variable no se sustituye

Comprobar:

- Que la variable existe.
- Que el nombre coincide exactamente.
- Que se utiliza `$variable`.
- Que el valor está disponible.
- Que se ha guardado el dashboard.
- Que la versión de Grafana admite esa sustitución en el panel Text.

### El HTML no aparece

Posibles causas:

- Sanitización.
- Restricciones de seguridad.
- Modo incorrecto.
- Etiquetas no permitidas.
- Código HTML mal formado.

Utilizar Markdown como alternativa.

### El contenido es demasiado largo

Soluciones:

- Dividirlo en varios paneles.
- Reducir texto repetido.
- Mover la documentación extensa a un wiki.
- Añadir un enlace.
- Utilizar una página de documentación externa.

### El contenido contiene información sensible

Realizar una revisión inmediata:

1. Retirar el secreto.
2. Revocar el token si se ha expuesto.
3. Cambiar la contraseña si procede.
4. Revisar exportaciones.
5. Revisar repositorios.
6. Documentar la incidencia de seguridad.

---

## Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-texto
```

Guardar el contenido utilizado:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-texto/contenido.md <<'EOF'
## Dashboard de monitorización

### Entorno

| Elemento | Valor |
|---|---|
| Entorno | Laboratorio |
| Fuente de datos | Prometheus |
| Exporter | Node Exporter |

### Interpretación

- Verde: estado normal
- Amarillo: requiere revisión
- Rojo: situación crítica
EOF
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-texto/informe.txt <<'EOF'
Práctica: Panel de texto

Dashboard utilizado:

Paneles Text creados:

Modo utilizado:
- Markdown
- HTML
- Texto plano

Variables utilizadas:

Enlaces añadidos:

Procedimientos documentados:

Información sensible revisada:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-panel-texto-portada.png
02-panel-texto-tabla.png
03-panel-texto-consultas.png
04-panel-texto-umbrales.png
05-panel-texto-procedimiento.png
06-panel-texto-variables.png
07-panel-texto-enlaces.png
08-panel-texto-dashboard-final.png
```

---

## Práctica integradora

### Objetivo

Crear un dashboard documentado mediante paneles Text y paneles de métricas.

### Panel Text 1: portada

Contenido mínimo:

```markdown
## Monitorización de servidores Linux

Este dashboard muestra el estado de los servidores
del entorno de laboratorio.

### Paneles

- Disponibilidad.
- CPU.
- Memoria.
- Almacenamiento.
- Red.
- Tendencias.
```

### Panel Text 2: información del entorno

Crear una tabla:

```markdown
| Elemento | Valor |
|---|---|
| Entorno | Laboratorio |
| Fuente de datos | Prometheus |
| Exporter | Node Exporter |
| Intervalo de scraping | Según configuración |
| Responsable | Equipo de sistemas |
```

### Panel Text 3: interpretación

```markdown
## Interpretación de colores

- Verde: estado normal.
- Amarillo: valor elevado.
- Rojo: situación crítica.

### Umbrales

- CPU: advertencia al 70 %, crítico al 90 %.
- Memoria: advertencia al 70 %, crítico al 90 %.
- Disco: advertencia al 80 %, crítico al 90 %.
```

### Panel Text 4: procedimiento

```markdown
## Procedimiento ante una incidencia

1. Comprobar `up`.
2. Identificar la instancia afectada.
3. Revisar las tendencias.
4. Comprobar CPU, memoria y disco.
5. Revisar los logs.
6. Documentar el resultado.
```

### Paneles de métricas

Añadir también:

```text
Stat de disponibilidad
Gauge de memoria
Bar Gauge de CPU por instancia
Time series de CPU
Time series de red
```

### Tareas

1. Crear el dashboard.
2. Crear los paneles Text.
3. Crear los paneles de métricas.
4. Colocar la portada al principio.
5. Colocar la interpretación junto a los Gauges.
6. Colocar el procedimiento junto a las tendencias.
7. Añadir enlaces a documentación.
8. Añadir una variable de instancia.
9. Mostrar la instancia seleccionada en un panel Text.
10. Revisar la información sensible.
11. Exportar el dashboard.
12. Importar una copia.
13. Comprobar que la documentación se conserva.
14. Completar el informe.

---

## Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Portada creada | | |
| Información del entorno añadida | | |
| Tabla creada | | |
| Umbrales documentados | | |
| Procedimiento añadido | | |
| Consultas documentadas | | |
| Enlaces añadidos | | |
| Variable utilizada | | |
| Texto dinámico comprobado | | |
| Markdown comprobado | | |
| HTML comprobado | | |
| Información sensible revisada | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Documentación conservada | | |
| Evidencias guardadas | | |

---

## Puntos clave

- El panel Text añade contexto y documentación a un dashboard.
- No sustituye a los paneles que representan métricas.
- Markdown es adecuado para títulos, listas, tablas, enlaces y código.
- El panel Text puede utilizarse como portada.
- También puede documentar unidades, umbrales y procedimientos.
- Las variables permiten mostrar información dinámica.
- Los enlaces facilitan la navegación entre dashboards y documentación.
- Los bloques de código permiten mostrar consultas PromQL y comandos.
- HTML debe utilizarse con precaución por motivos de seguridad y compatibilidad.
- No se deben incluir tokens, contraseñas ni claves privadas.
- La documentación debe coincidir con la configuración real de los paneles.
- Los avisos deben retirarse cuando queden obsoletos.
- Los paneles Text pueden servir como guía para las prácticas de los alumnos.
- Una documentación breve y visible mejora la interpretación del dashboard.
- Un contenido demasiado largo debe dividirse o trasladarse a una documentación externa.
- Las tablas deben mantenerse sencillas y legibles.
- Los enlaces deben comprobarse periódicamente.
- Las variables deben probarse con valores individuales y con `All`.
- El contenido Text también forma parte del dashboard exportado.
- Antes de compartir un dashboard, debe revisarse todo su contenido.

---

## Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Text?
2. ¿Qué diferencia existe entre un panel Text y un panel Stat?
3. ¿Qué ventajas ofrece Markdown?
4. ¿Qué elementos se pueden crear con Markdown?
5. ¿Cómo se crea una tabla en Markdown?
6. ¿Cómo se crea un bloque de código?
7. ¿Para qué sirven las variables dentro de un panel Text?
8. ¿Qué información puede documentarse en una portada?
9. ¿Qué utilidad tienen los enlaces internos?
10. ¿Qué riesgos tiene incluir secretos en un panel Text?
11. ¿Cuándo utilizarías HTML?
12. ¿Por qué se recomienda utilizar Markdown para la documentación técnica?
13. ¿Qué información incluirías en una tabla del entorno?
14. ¿Cómo documentarías los colores de los umbrales?
15. ¿Cómo crearías un procedimiento de diagnóstico?
16. ¿Qué comprobarías si una variable no se sustituye?
17. ¿Qué revisarías si una tabla se muestra deformada?
18. ¿Qué harías si un enlace deja de funcionar?
19. ¿Qué información debe revisarse antes de compartir un dashboard?
20. ¿Cómo utilizarías un panel Text para una práctica de alumnos?
21. ¿Qué ventajas tiene colocar una portada en la parte superior?
22. ¿Por qué debe mantenerse sincronizada la documentación?
23. ¿Qué evidencias guardarías durante la práctica?
24. ¿Qué contenido dividirías en varios paneles Text?
25. ¿Qué características debe tener una buena documentación dentro de un dashboard?

---

## Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear dashboards documentados y comprensibles.

El proceso completo será:

```text
Definir el propósito del dashboard
        |
        v
Crear una portada
        |
        v
Documentar el entorno
        |
        v
Explicar unidades y umbrales
        |
        v
Añadir procedimientos
        |
        v
Documentar consultas importantes
        |
        v
Añadir enlaces y variables
        |
        v
Revisar seguridad
        |
        v
Guardar y exportar
        |
        v
Mantener la documentación actualizada
```

El resultado final debe ser un dashboard que no solo muestre métricas, sino que también explique su significado, indique cómo interpretarlas y proporcione instrucciones claras para actuar ante una incidencia.