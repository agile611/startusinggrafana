```markdown
# Problemas con dashboards

Esta página explica cómo diagnosticar y resolver los problemas más habituales relacionados con los dashboards de Grafana.

Un dashboard puede presentar problemas aunque Grafana, Prometheus y Node Exporter estén funcionando correctamente. El fallo puede estar en:

```text
Dashboard
    |
    v
Panel
    |
    v
Consulta
    |
    v
Variables
    |
    v
Fuente de datos
    |
    v
Métricas y etiquetas
    |
    v
Rango temporal
```

Los síntomas más frecuentes son:

- El dashboard no carga.
- Un panel muestra `No data`.
- Un panel muestra `Error querying data source`.
- Las variables aparecen vacías.
- Los paneles muestran datos de otra instancia.
- Las leyendas no son claras.
- Las unidades son incorrectas.
- El gráfico aparece vacío después de importar un dashboard.
- Los datos se muestran con demasiadas series.
- El dashboard tarda mucho en cargar.
- Un panel utiliza una fuente de datos inexistente.
- Las consultas funcionan en Prometheus, pero no en Grafana.
- Un usuario puede ver el dashboard, pero no editarlo.
- Los cambios realizados desaparecen después de reiniciar Grafana.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Explicar la estructura de un dashboard de Grafana.
- Diferenciar entre dashboard, panel, consulta y fuente de datos.
- Diagnosticar paneles sin datos.
- Comprobar la fuente de datos utilizada por un panel.
- Validar consultas PromQL en Prometheus y Grafana.
- Diagnosticar problemas con variables.
- Utilizar variables de selección única y múltiple.
- Comprobar el rango temporal de un dashboard.
- Configurar correctamente unidades y leyendas.
- Identificar consultas excesivamente amplias.
- Utilizar Query Inspector.
- Revisar transformaciones de datos.
- Importar y exportar dashboards.
- Resolver problemas de identificadores de fuentes de datos.
- Comprobar permisos de visualización y edición.
- Documentar una incidencia de un dashboard.

## Introducción

Un dashboard de Grafana está formado por una colección de paneles. Cada panel puede tener:

- Una o varias consultas.
- Una fuente de datos.
- Una visualización.
- Variables.
- Transformaciones.
- Umbrales.
- Unidades.
- Opciones de leyenda.
- Reglas de campo.
- Enlaces.
- Anotaciones.

La estructura lógica es:

```text
Dashboard
    |
    +-- Variables
    |
    +-- Panel de CPU
    |      |
    |      +-- Consulta PromQL
    |      +-- Fuente Prometheus
    |      +-- Visualización
    |
    +-- Panel de memoria
    |      |
    |      +-- Consulta PromQL
    |      +-- Fuente Prometheus
    |      +-- Visualización
    |
    +-- Panel de red
           |
           +-- Consulta PromQL
           +-- Variables
           +-- Transformaciones
```

Cuando un panel no muestra información, no debe modificarse todo el dashboard de forma simultánea. Es preferible aislar el problema:

1. Comprobar el panel.
2. Comprobar la fuente.
3. Comprobar la consulta.
4. Comprobar las variables.
5. Comprobar el intervalo temporal.
6. Comprobar los datos en Prometheus.
7. Aplicar una corrección.
8. Validar el resultado.

## Conceptos fundamentales

### Dashboard

Un dashboard es una página que agrupa paneles relacionados.

Ejemplo:

```text
Dashboard: Monitorización de servidores
```

Puede contener:

- Uso de CPU.
- Memoria.
- Disco.
- Red.
- Carga del sistema.
- Disponibilidad.
- Alertas.

### Panel

Un panel representa una consulta mediante una visualización.

Ejemplo:

```text
Panel: Uso de CPU
Consulta: porcentaje de CPU utilizada
Visualización: Time series
Unidad: porcentaje
```

### Consulta

La consulta solicita datos a la fuente de datos.

Ejemplo:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

### Fuente de datos

La fuente de datos proporciona la información al panel.

Ejemplo:

```text
Prometheus
URL: http://localhost:9090
```

### Variable

Una variable permite cambiar una consulta sin editar manualmente el panel.

Ejemplo:

```text
Variable: instance
Valor: server01:9100
```

Consulta:

```promql
up{
  instance=~"$instance"
}
```

### Transformación

Una transformación modifica los datos después de recibirlos de la fuente.

Ejemplos:

- Unir resultados.
- Organizar campos.
- Renombrar campos.
- Reducir series.
- Convertir filas en columnas.
- Añadir campos calculados.

### Visualización

La visualización define cómo se representan los resultados.

Ejemplos:

- Time series.
- Stat.
- Gauge.
- Table.
- Bar gauge.
- Pie chart.
- Heatmap.
- Text.

## Procedimiento general de diagnóstico

### Identificar el síntoma

Registra exactamente qué ocurre:

```text
El dashboard no abre.
El panel aparece vacío.
La variable instance no muestra valores.
La consulta devuelve un error.
Los datos aparecen desplazados.
La leyenda muestra nombres incomprensibles.
```

### Comprobar la fuente de datos

En Grafana:

1. Abre **Connections**.
2. Selecciona **Data sources**.
3. Abre la fuente utilizada.
4. Pulsa **Save & test**.

### Comprobar la consulta

Abre el panel:

1. Selecciona **Edit**.
2. Revisa la consulta.
3. Comprueba la fuente.
4. Ejecuta la consulta.
5. Revisa la respuesta.

### Probar la consulta en Prometheus

Copia la consulta y ejecútala en:

```text
http://localhost:9090
```

Si la consulta funciona en Prometheus, pero no en Grafana, revisa:

- Variables.
- Rango temporal.
- Fuente seleccionada.
- Transformaciones.
- Opciones del panel.
- Permisos.
- Consulta generada.

### Comprobar Query Inspector

Utiliza:

```text
Inspect
```

y:

```text
Query inspector
```

Revisa:

- Consulta final.
- Variables sustituidas.
- URL utilizada.
- Código HTTP.
- Respuesta.
- Tiempo de ejecución.

### Validar el resultado

Después de corregir el problema:

- Recarga el dashboard.
- Cambia la instancia seleccionada.
- Cambia el rango temporal.
- Comprueba varios paneles.
- Revisa la leyenda.
- Comprueba las unidades.
- Guarda el dashboard.

## Problemas al abrir un dashboard

### El dashboard no existe

Puede aparecer un mensaje como:

```text
Dashboard not found
```

Posibles causas:

- URL incorrecta.
- Dashboard eliminado.
- Dashboard movido a otra carpeta.
- Falta de permisos.
- Identificador incorrecto.
- Importación incompleta.

Comprueba:

- Carpeta del dashboard.
- URL.
- Usuario conectado.
- Permisos de la carpeta.
- Historial de cambios.

### El dashboard muestra una página vacía

Comprueba:

1. La consola del navegador.
2. La pestaña Network.
3. Los registros de Grafana.
4. El estado del servicio.
5. La fuente de datos.
6. Las variables.
7. El JSON del dashboard.

En el servidor:

```bash
systemctl is-active grafana-server
```

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager
```

### El dashboard tarda mucho en cargar

Posibles causas:

- Demasiados paneles.
- Consultas con demasiadas series.
- Rango temporal demasiado amplio.
- Consultas repetidas.
- Variables con muchos valores.
- Transformaciones costosas.
- Alta cardinalidad en Prometheus.
- Paneles con refresco demasiado frecuente.

Comprueba:

- Tiempo de respuesta de cada panel.
- Query Inspector.
- Número de series.
- Intervalo de refresco.
- Rango temporal.

## Problemas con paneles

### El panel muestra `No data`

`No data` no significa necesariamente que la fuente esté caída.

Posibles causas:

- La consulta no coincide con ninguna serie.
- El rango temporal no contiene datos.
- La variable está vacía.
- El target está `DOWN`.
- El nombre de la métrica es incorrecto.
- El filtro de etiquetas no coincide.
- La fuente de datos seleccionada no es correcta.
- La consulta requiere una ventana temporal mayor.

### Comprobar con una consulta mínima

Sustituye temporalmente la consulta por:

```promql
up
```

Si aparecen datos, la fuente probablemente funciona.

Después prueba:

```promql
node_load1
```

Después:

```promql
node_load1{
  job="node_exporter"
}
```

Finalmente añade las variables o filtros originales.

### Panel con datos solo en algunos intervalos

Comprueba el selector temporal:

```text
Last 5 minutes
Last 15 minutes
Last 1 hour
Last 6 hours
Last 24 hours
```

Una métrica puede no tener datos recientes si:

- El target estuvo detenido.
- Node Exporter se instaló hace poco.
- Prometheus se reinició.
- El scraping comenzó recientemente.
- El intervalo de consulta es demasiado corto.

### Panel muestra `Error querying data source`

Comprueba:

- Fuente seleccionada.
- URL de la fuente.
- Estado de Prometheus.
- Consulta PromQL.
- Autenticación.
- Firewall.
- Query Inspector.
- Registros de Grafana.

Consultar los registros:

```bash
sudo journalctl -u grafana-server \
  --since "15 minutes ago" \
  --no-pager
```

### Panel muestra demasiadas series

Consulta original:

```promql
rate(
  node_cpu_seconds_total[5m]
)
```

Esta consulta conserva etiquetas como:

```text
instance
job
cpu
mode
```

Filtra el modo:

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

Agrega por instancia:

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### Panel muestra una única serie global

Consulta:

```promql
sum(
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

Si necesitas una serie por instancia:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

Si necesitas una serie por instancia e interfaz:

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

## Problemas con consultas PromQL

### La métrica no existe

Consulta los nombres de métricas disponibles:

```bash
curl -s \
  http://localhost:9090/api/v1/label/__name__/values \
  | jq
```

Desde Prometheus, prueba:

```promql
node_load1
```

### La etiqueta no existe

Consulta las etiquetas de una serie:

```bash
curl -s http://localhost:9090/api/v1/series \
  --data-urlencode 'match[]=node_load1' \
  | jq
```

Consulta los nombres de etiquetas:

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### El valor de la etiqueta es incorrecto

Consulta todos los valores de `instance`:

```bash
curl -s \
  http://localhost:9090/api/v1/label/instance/values \
  | jq
```

Después utiliza un valor real:

```promql
up{
  instance="localhost:9100"
}
```

### Error con `rate`

Incorrecto:

```promql
rate(node_cpu_seconds_total)
```

Correcto:

```promql
rate(
  node_cpu_seconds_total[5m]
)
```

Con filtro:

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Error con variables múltiples

Incorrecto:

```promql
up{
  instance="$instance"
}
```

Correcto cuando la variable permite varios valores:

```promql
up{
  instance=~"$instance"
}
```

### Error en una expresión aritmética

Esta expresión puede producir resultados inesperados si las etiquetas no coinciden:

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Una forma más clara es conservar los mismos filtros:

```promql
node_memory_MemAvailable_bytes{
  instance=~"$instance"
}
/
node_memory_MemTotal_bytes{
  instance=~"$instance"
}
```

### Agregar antes de operar

Para calcular memoria por instancia:

```promql
100 * (
  1 -
  sum by (instance) (
    node_memory_MemAvailable_bytes
  )
  /
  sum by (instance) (
    node_memory_MemTotal_bytes
  )
)
```

## Problemas con variables

### La variable aparece vacía

Comprueba:

- Nombre de la métrica.
- Nombre de la etiqueta.
- Fuente de datos.
- Consulta de la variable.
- Filtros dependientes.
- Estado de Prometheus.
- Permisos del usuario.

Ejemplo de consulta:

```promql
label_values(up, instance)
```

### Diagnosticar la variable `instance`

Comprueba en Prometheus:

```promql
up
```

Después consulta mediante API:

```bash
curl -s \
  http://localhost:9090/api/v1/label/instance/values \
  | jq
```

### Variable con nombre de etiqueta incorrecto

Incorrecto:

```promql
label_values(up, instancia)
```

Correcto:

```promql
label_values(up, instance)
```

### Variable de selección múltiple

Configura:

```text
Multi-value: activado
```

Utiliza:

```promql
instance=~"$instance"
```

### Variable con opción `All`

Configura:

```text
Include All option: activado
```

Utiliza:

```promql
job=~"$job"
```

### Variable encadenada

Variable principal:

```promql
label_values(up, instance)
```

Variable dependiente:

```promql
label_values(
  node_network_receive_bytes_total{
    instance=~"$instance"
  },
  device
)
```

### Variable dependiente sin valores

Puede ocurrir si:

- La variable principal está vacía.
- La instancia seleccionada no tiene la métrica.
- El nombre de la etiqueta es incorrecto.
- El target está `DOWN`.
- El filtro es demasiado restrictivo.

Prueba primero una consulta amplia:

```promql
label_values(
  node_network_receive_bytes_total,
  device
)
```

Después añade el filtro:

```promql
label_values(
  node_network_receive_bytes_total{
    instance=~"$instance"
  },
  device
)
```

## Problemas con el rango temporal

### Rango demasiado corto

Una consulta con `rate` necesita suficientes muestras:

```promql
rate(
  node_cpu_seconds_total[5m]
)
```

Si el rango del dashboard es muy pequeño, puede no haber muestras suficientes.

### Rango demasiado amplio

Un rango como:

```text
Last 30 days
```

puede generar:

- Más datos.
- Consultas lentas.
- Muchos puntos.
- Mayor consumo de memoria.
- Más tiempo de renderizado.

### Utilizar `$__rate_interval`

```promql
rate(
  node_cpu_seconds_total[$__rate_interval]
)
```

Esta variable ayuda a adaptar la ventana de `rate` a la resolución temporal del panel.

### Utilizar `$__interval`

```promql
avg_over_time(
  node_load1[$__interval]
)
```

### Comprobar la hora del sistema

En Grafana:

```bash
date
```

En Prometheus:

```bash
date
```

Comprobar sincronización:

```bash
timedatectl
```

## Problemas con unidades

### CPU

Si la consulta devuelve un porcentaje:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[5m]
    )
  )
)
```

Configura la unidad:

```text
Percent (0-100)
```

### Memoria

Si la consulta devuelve bytes:

```promql
node_memory_MemTotal_bytes
```

Utiliza:

```text
Bytes (IEC)
```

Si devuelve porcentaje:

```text
Percent (0-100)
```

### Red

Si la consulta utiliza:

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

la unidad es una tasa de bytes por segundo:

```text
bytes/sec
```

Si se multiplica por ocho:

```promql
8 *
rate(
  node_network_receive_bytes_total[5m]
)
```

la unidad puede ser:

```text
bits/sec
```

### Tiempo

Si la métrica devuelve segundos:

```text
seconds
```

Si devuelve milisegundos:

```text
milliseconds
```

### Problemas de unidades incorrectas

Síntomas:

- Memoria mostrada como porcentaje sin convertir.
- Tráfico mostrado como bytes cuando representa bits.
- CPU mostrada como valor decimal sin multiplicar por cien.
- Valores con demasiados decimales.
- Prefijos incorrectos.

## Problemas con leyendas

### Leyenda poco descriptiva

Una consulta puede mostrar nombres largos como:

```text
{instance="server01:9100", job="node_exporter", device="ens33"}
```

Configura una leyenda personalizada:

```text
{{instance}} - {{device}}
```

### CPU por instancia

```text
CPU - {{instance}}
```

### Memoria por instancia

```text
Memoria - {{instance}}
```

### Red por interfaz

```text
Recepción - {{instance}} - {{device}}
```

### Filesystem por punto de montaje

```text
Uso - {{instance}} - {{mountpoint}}
```

### Leyendas duplicadas

Puede ocurrir si la consulta conserva etiquetas innecesarias o si dos series generan el mismo texto.

Soluciones:

- Añadir otra etiqueta.
- Agregar series.
- Eliminar etiquetas mediante una agregación.
- Revisar el campo de leyenda.
- Evitar nombres idénticos.

## Problemas con visualizaciones

### Time series

Adecuada para:

- CPU a lo largo del tiempo.
- Memoria.
- Tráfico de red.
- Carga.
- Uso de disco.

Comprueba:

- Unidad.
- Eje temporal.
- Leyenda.
- Modo de líneas.
- Puntos.
- Escala.

### Stat

Adecuada para:

- Estado actual.
- Valor único.
- Disponibilidad.
- CPU actual.
- Memoria actual.

Si aparecen varias series, configura:

- Reducción.
- Serie a mostrar.
- Cálculo `Last`.
- Cálculo `Mean`.
- Cálculo `Max`.

### Gauge

Adecuada para:

- Porcentaje de CPU.
- Memoria utilizada.
- Disco utilizado.
- Valores con umbrales.

Configura:

- Mínimo.
- Máximo.
- Umbrales.
- Unidad.

Ejemplo:

```text
Mínimo: 0
Máximo: 100
Unidad: Percent (0-100)
```

### Table

Adecuada para:

- Targets.
- Instancias.
- Interfaces.
- Estados.
- Valores actuales.

Comprueba:

- Campos visibles.
- Orden.
- Transformaciones.
- Formato de las columnas.
- Nombres de los campos.

### Bar gauge

Adecuada para comparar:

- Uso de CPU por servidor.
- Uso de disco por punto de montaje.
- Memoria por instancia.

## Problemas con transformaciones

### Transformación que elimina datos

Las transformaciones se aplican después de la consulta. Una transformación mal configurada puede ocultar resultados válidos.

Comprueba:

1. Ejecuta la consulta sin transformaciones.
2. Revisa el resultado.
3. Activa una transformación.
4. Revisa de nuevo el resultado.
5. Repite con cada transformación.

### Transformación `Reduce`

Puede convertir varias muestras en un único valor.

Opciones habituales:

```text
Last
Last not null
Mean
Min
Max
Sum
```

### Transformación `Organize fields`

Puede ocultar o renombrar campos.

Comprueba:

- Campos ocultos.
- Orden.
- Alias.
- Nombres duplicados.

### Transformación `Filter data by values`

Puede eliminar todas las filas si el filtro no coincide.

Comprueba:

- Campo utilizado.
- Operador.
- Valor.
- Tipo de dato.

### Transformación `Join`

Puede no generar resultados si los campos utilizados para unir no coinciden.

Comprueba:

- Campo común.
- Tipo de unión.
- Nombres de los campos.
- Valores compartidos.

### Método de diagnóstico

Para aislar el problema:

1. Elimina temporalmente todas las transformaciones.
2. Comprueba la consulta.
3. Añade una transformación.
4. Comprueba el panel.
5. Repite hasta localizar la transformación problemática.

## Problemas al importar dashboards

### El dashboard se importa, pero aparecen errores

Posibles causas:

- Fuente de datos inexistente.
- Variables incompatibles.
- Paneles de otra versión.
- Plugins no instalados.
- Consultas específicas de otro entorno.
- Identificador de fuente diferente.
- Métricas que no existen.

### Seleccionar la fuente de datos

Durante la importación, Grafana puede solicitar la fuente de datos.

Selecciona la fuente Prometheus correcta:

```text
Prometheus-Laboratorio
```

### Variables después de importar

Revisa:

1. **Dashboard settings**.
2. **Variables**.
3. Nombre de cada variable.
4. Fuente utilizada.
5. Consulta.
6. Valores disponibles.

### Métricas no disponibles

Comprueba en Prometheus:

```promql
up
```

```promql
node_load1
```

```promql
node_memory_MemTotal_bytes
```

Si no existen, el dashboard no puede mostrar esos paneles sin adaptar las consultas.

### Plugins no disponibles

Si un panel necesita un plugin concreto:

- Comprueba el tipo de panel.
- Consulta el mensaje de error.
- Comprueba la versión de Grafana.
- Instala el plugin solo si está autorizado.
- Sustituye la visualización por una integrada si es posible.

## Problemas al exportar dashboards

### Exportar un dashboard

En Grafana:

1. Abre el dashboard.
2. Accede a **Dashboard settings**.
3. Selecciona **JSON model**.
4. Copia el contenido.
5. Guarda el archivo con extensión `.json`.

### Guardar el JSON

```bash
mkdir -p ~/laboratorio/dashboards
nano ~/laboratorio/dashboards/monitorizacion-servidores.json
```

### Comprobar que el JSON es válido

Si tienes `jq` instalado:

```bash
jq empty \
  ~/laboratorio/dashboards/monitorizacion-servidores.json
```

Si es válido, el comando no debería mostrar errores.

### Formatear el JSON

```bash
jq . \
  ~/laboratorio/dashboards/monitorizacion-servidores.json \
  > /tmp/dashboard-formateado.json
```

### Exportar sin credenciales

Revisa el JSON antes de compartirlo y elimina:

- Tokens.
- Contraseñas.
- URLs privadas.
- Identificadores sensibles.
- Información de infraestructura no autorizada.

## Problemas con permisos del dashboard

### Puede ver, pero no editar

Un usuario puede tener permiso de visualización, pero no de edición.

Comprueba:

- Rol del usuario.
- Permisos de la carpeta.
- Permisos del dashboard.
- Equipo al que pertenece.
- Organización seleccionada.

### Puede editar, pero no guardar

Posibles causas:

- Falta permiso de escritura.
- La carpeta es de solo lectura.
- El dashboard está gestionado por provisioning.
- El dashboard se importa desde una fuente externa.
- El usuario no tiene permisos suficientes.

### Dashboard gestionado por provisioning

Si el dashboard se genera mediante provisioning, los cambios manuales pueden desaparecer al reiniciar Grafana.

Busca ficheros:

```bash
sudo find /etc/grafana/provisioning \
  -type f \
  -print
```

Busca referencias a dashboards:

```bash
sudo grep -R -n \
  "providers\|path:" \
  /etc/grafana/provisioning/dashboards \
  2>/dev/null
```

## Problemas con el refresco automático

### Comprobar el intervalo de refresco

Grafana puede utilizar:

```text
Off
5s
10s
30s
1m
5m
```

Un intervalo demasiado corto puede provocar:

- Muchas consultas.
- Mayor carga en Prometheus.
- Mayor consumo de red.
- Paneles lentos.
- Limitación del navegador.

### Consultar el tiempo de ejecución

Utiliza Query Inspector para comprobar cuánto tarda cada consulta.

### Reducir la frecuencia

Utiliza un intervalo razonable para el objetivo del panel:

- Métricas de infraestructura: `30s` o `1m`.
- Tendencias generales: `5m`.
- Datos históricos: sin refresco automático.

## Problemas de rendimiento del dashboard

### Demasiados paneles

Divide un dashboard grande en varios:

```text
Dashboard de sistema
Dashboard de red
Dashboard de almacenamiento
Dashboard de aplicaciones
```

### Demasiadas series

Agrega:

```promql
sum by (instance) (
  rate(
    node_network_receive_bytes_total[5m]
  )
)
```

### Rango temporal excesivo

Evita cargar por defecto:

```text
Last 30 days
```

si los paneles están diseñados para:

```text
Last 1 hour
```

### Variables con demasiados valores

Una variable que consulta miles de valores puede ralentizar el dashboard.

Limita la consulta:

```promql
label_values(
  up{job="node_exporter"},
  instance
)
```

Evita variables basadas en etiquetas de cardinalidad excesiva.

### Consultas repetidas

Si muchos paneles realizan consultas similares:

- Revisa si pueden compartir una consulta.
- Utiliza reglas de grabación en Prometheus.
- Reduce el número de paneles.
- Reutiliza variables.
- Evita consultas innecesarias.

## Problemas con paneles repetidos

Grafana puede repetir paneles según el valor de una variable.

### Repetir por instancia

Configura una variable:

```text
instance
```

Activa:

```text
Multi-value
```

Configura el panel para repetir por:

```text
instance
```

### Problemas habituales

- Se generan demasiados paneles.
- La variable no tiene valores.
- La pantalla queda saturada.
- Cada repetición ejecuta consultas costosas.
- Las leyendas son duplicadas.

### Buenas prácticas

- Limita el número de valores.
- Utiliza repetición solo cuando aporte valor.
- Considera una tabla o un gráfico agrupado.
- Evita repetir por etiquetas de alta cardinalidad.

## Sesión práctica 1: crear un dashboard básico

### Objetivo

Crear un dashboard con paneles de disponibilidad, CPU y memoria.

### Crear el dashboard

En Grafana:

1. Accede a **Dashboards**.
2. Pulsa **New**.
3. Crea un dashboard.
4. Añade un panel.
5. Selecciona la fuente Prometheus.

### Panel de disponibilidad

Consulta:

```promql
up
```

Visualización recomendada:

```text
Stat
```

Configuración:

```text
Título: Disponibilidad de targets
Unidad: none
```

### Panel de CPU

Consulta:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

Configuración:

```text
Título: Uso de CPU
Unidad: Percent (0-100)
Leyenda: CPU - {{instance}}
```

### Panel de memoria

Consulta:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración:

```text
Título: Uso de memoria
Unidad: Percent (0-100)
Leyenda: Memoria - {{instance}}
```

### Guardar el dashboard

Utiliza un nombre descriptivo:

```text
Monitorización básica de servidores
```

### Preguntas de análisis

- ¿Qué fuente de datos utiliza cada panel?
- ¿Qué unidad necesita cada consulta?
- ¿Qué etiquetas conserva el panel de CPU?
- ¿Qué ocurre si no se configura una leyenda?
- ¿Qué panel representa un valor actual y cuál una serie temporal?

## Sesión práctica 2: crear una variable de instancia

### Objetivo

Hacer que el dashboard sea reutilizable para varias instancias.

### Crear la variable

En **Dashboard settings > Variables**:

```text
Name: instance
Label: Instancia
Type: Query
Data source: Prometheus
Query: label_values(up, instance)
```

Activa:

```text
Multi-value: activado
Include All option: activado
```

### Modificar el panel de disponibilidad

```promql
up{
  instance=~"$instance"
}
```

### Modificar el panel de CPU

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        instance=~"$instance",
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Modificar el panel de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance=~"$instance"
  }
  /
  node_memory_MemTotal_bytes{
    instance=~"$instance"
  }
)
```

### Validación

1. Selecciona una instancia.
2. Comprueba los tres paneles.
3. Selecciona varias instancias.
4. Activa **All**.
5. Comprueba las leyendas.
6. Revisa Query Inspector.

## Sesión práctica 3: diagnosticar un panel vacío

### Objetivo

Encontrar la causa de un panel que muestra `No data`.

### Consulta inicial

Utiliza una consulta con un filtro incorrecto:

```promql
node_load1{
  instance="servidor-inexistente:9100"
}
```

### Diagnóstico

Sustituye la consulta por:

```promql
node_load1
```

Si aparecen datos, el problema está en el filtro.

### Consultar los valores reales

```bash
curl -s \
  http://localhost:9090/api/v1/label/instance/values \
  | jq
```

### Corregir la consulta

Utiliza una instancia real:

```promql
node_load1{
  instance="localhost:9100"
}
```

### Registrar el proceso

```text
Consulta inicial:

Resultado inicial:

Consulta de prueba:

Resultado de la consulta de prueba:

Valores reales de instance:

Consulta corregida:

Resultado final:
```

## Sesión práctica 4: diagnosticar una variable vacía

### Objetivo

Resolver una variable cuyo desplegable no muestra valores.

### Crear una consulta incorrecta

```promql
label_values(up, instancia)
```

### Observar el resultado

La variable debería aparecer vacía porque la etiqueta real es:

```text
instance
```

### Comprobar las etiquetas

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### Corregir la variable

```promql
label_values(up, instance)
```

### Validar

1. Recarga el dashboard.
2. Abre el selector.
3. Comprueba los valores.
4. Selecciona una instancia.
5. Revisa los paneles dependientes.

### Preguntas de análisis

- ¿Qué nombre de etiqueta se utilizó inicialmente?
- ¿Cuál es el nombre real?
- ¿Qué consulta permitió descubrirlo?
- ¿Qué paneles dependían de la variable?

## Sesión práctica 5: diagnosticar una fuente incorrecta

### Objetivo

Diferenciar un problema de dashboard de un problema de fuente de datos.

### Crear un panel con fuente válida

Consulta:

```promql
up
```

Fuente:

```text
Prometheus
```

### Cambiar temporalmente la fuente

Selecciona una fuente incorrecta o no disponible.

### Observar el resultado

Registra:

```text
Mensaje mostrado:

Código HTTP:

Fuente seleccionada:

URL utilizada:
```

### Abrir Query Inspector

Comprueba:

- URL.
- Consulta.
- Respuesta.
- Error.
- Tiempo de espera.

### Restaurar la fuente

Selecciona la fuente correcta y ejecuta:

```promql
up
```

### Validar

El panel debe volver a mostrar datos.

## Sesión práctica 6: diagnosticar el rango temporal

### Objetivo

Comprobar cómo afecta el selector temporal a los paneles.

### Utilizar una consulta

```promql
rate(
  node_network_receive_bytes_total[5m]
)
```

### Probar varios intervalos

```text
Last 5 minutes
Last 15 minutes
Last 1 hour
Last 6 hours
Last 24 hours
```

### Registrar el resultado

```text
Intervalo:

¿Hay datos?:

Número de series:

Tiempo de respuesta:

Observaciones:
```

### Comprobar el estado de los targets

```promql
up
```

### Consultar la hora del sistema

```bash
date
```

### Preguntas de análisis

- ¿En qué intervalo aparecen datos?
- ¿El target estuvo activo durante todo el rango?
- ¿La consulta necesita una ventana de cinco minutos?
- ¿Qué ocurre si el rango es menor que la ventana de `rate`?

## Sesión práctica 7: configurar unidades y umbrales

### Objetivo

Configurar correctamente un panel de memoria.

### Consulta

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Configuración del panel

```text
Título: Memoria utilizada
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

### Umbrales de ejemplo

```text
0–70: verde
70–85: amarillo
85–100: rojo
```

### Validación

Comprueba:

- El valor está entre `0` y `100`.
- La unidad muestra `%`.
- Los colores cambian en los umbrales.
- La leyenda identifica la instancia.
- El panel no muestra bytes sin convertir.

## Sesión práctica 8: configurar un panel de red

### Objetivo

Crear un panel de tráfico recibido por interfaz.

### Crear la variable `device`

Consulta:

```promql
label_values(
  node_network_receive_bytes_total,
  device
)
```

Activa:

```text
Multi-value: activado
Include All option: activado
```

### Consulta del panel

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      instance=~"$instance",
      device=~"$device",
      device!~"lo|docker.*|veth.*|br-.*"
    }[$__rate_interval]
  )
)
```

### Configuración

```text
Título: Tráfico recibido
Unidad: bytes/sec
Leyenda: RX - {{instance}} - {{device}}
Visualización: Time series
```

### Validación

1. Selecciona una instancia.
2. Selecciona una interfaz.
3. Comprueba el gráfico.
4. Selecciona varias interfaces.
5. Activa **All**.
6. Comprueba la leyenda.
7. Excluye interfaces virtuales.

## Sesión práctica 9: utilizar Query Inspector

### Objetivo

Analizar una consulta que no devuelve datos.

### Crear la consulta

```promql
up{
  instance=~"$instance",
  job=~"$job"
}
```

### Abrir el inspector

1. Edita el panel.
2. Selecciona **Inspect**.
3. Abre **Query inspector**.
4. Revisa la consulta generada.
5. Revisa los valores de las variables.
6. Revisa el código de respuesta.

### Posibles problemas

```text
instance=~""
```

La variable está vacía.

```text
job=~".*"
```

La variable utiliza la opción **All**.

```text
instance=~"server01:9100|server02:9100"
```

La selección múltiple funciona.

### Registrar el diagnóstico

```text
Consulta escrita:

Consulta generada:

Valor de instance:

Valor de job:

URL utilizada:

Código HTTP:

Respuesta:

Problema identificado:

Solución:
```

## Sesión práctica 10: importar y adaptar un dashboard

### Objetivo

Importar un dashboard y adaptarlo al entorno de laboratorio.

### Preparación

Comprueba las métricas disponibles:

```promql
up
```

```promql
node_load1
```

```promql
node_memory_MemTotal_bytes
```

### Importar

En Grafana:

1. Accede a **Dashboards**.
2. Selecciona **Import**.
3. Introduce el JSON o identificador autorizado.
4. Selecciona la fuente Prometheus.
5. Pulsa **Import**.

### Revisar variables

Accede a:

```text
Dashboard settings > Variables
```

Comprueba:

- `instance`.
- `job`.
- `device`.
- `mountpoint`.
- `datasource`.

### Revisar paneles

Para cada panel:

1. Comprueba la fuente.
2. Comprueba la consulta.
3. Comprueba las métricas.
4. Comprueba las variables.
5. Comprueba la unidad.
6. Comprueba la leyenda.
7. Comprueba el rango temporal.

### Adaptar una consulta

Si el dashboard utiliza una métrica inexistente:

```promql
node_cpu_utilization_percent
```

sustitúyela por:

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Validar

- No hay paneles con errores.
- Las variables muestran valores.
- Las consultas devuelven datos.
- Las unidades son correctas.
- El dashboard funciona con distintas instancias.

## Sesión práctica 11: analizar el rendimiento

### Objetivo

Identificar qué panel tarda más en cargar.

### Procedimiento

1. Abre el dashboard.
2. Abre cada panel.
3. Selecciona **Inspect**.
4. Abre **Query inspector**.
5. Registra el tiempo de respuesta.
6. Registra el número de series.
7. Compara los resultados.

### Plantilla

```text
Panel:

Consulta:

Tiempo de respuesta:

Número de series:

Rango temporal:

¿Utiliza variables?:

¿Utiliza transformaciones?:

Problema observado:

Mejora propuesta:
```

### Optimizar una consulta

Consulta amplia:

```promql
rate(
  node_cpu_seconds_total[5m]
)
```

Consulta más específica:

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

Consulta adaptada a Grafana:

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[$__rate_interval]
  )
)
```

## Sesión práctica 12: comprobar permisos

### Objetivo

Diferenciar un problema de visualización de un problema de permisos.

### Crear un usuario de prueba

Utiliza un usuario de laboratorio autorizado.

### Comprobar el acceso

Registra:

```text
¿Puede abrir el dashboard?:

¿Puede ver los paneles?:

¿Puede cambiar variables?:

¿Puede editar el dashboard?:

¿Puede guardar cambios?:
```

### Revisar permisos

Comprueba:

- Permisos de la carpeta.
- Permisos del dashboard.
- Rol del usuario.
- Organización.
- Equipo.
- Acceso a la fuente de datos.

### Interpretar

| Situación | Posible explicación |
|---|---|
| No puede abrir el dashboard | Falta permiso de visualización |
| Puede verlo, pero no editarlo | Rol de solo lectura |
| Puede editarlo, pero no guardarlo | Falta permiso de escritura |
| Ve el dashboard, pero no datos | Fuente o consulta |
| Ve algunos paneles y otros no | Fuentes o permisos diferentes |

## Sesión práctica 13: comprobar un dashboard provisionado

### Objetivo

Identificar por qué los cambios manuales desaparecen.

### Buscar provisioning

```bash
sudo find /etc/grafana/provisioning \
  -type f \
  -print
```

### Buscar proveedores de dashboards

```bash
sudo grep -R -n \
  "providers\|path:\|folder:" \
  /etc/grafana/provisioning/dashboards \
  2>/dev/null
```

### Consultar los registros

```bash
sudo journalctl -u grafana-server \
  -n 100 \
  --no-pager \
  | grep -i -E \
  "provision|dashboard"
```

### Analizar

Comprueba:

- Ruta de los archivos JSON.
- Carpeta de destino.
- Frecuencia de actualización.
- Si el dashboard es editable.
- Si los cambios se sobrescriben.
- Si el dashboard se carga al iniciar Grafana.

### Preguntas de análisis

- ¿El dashboard se creó manualmente o mediante provisioning?
- ¿Dónde está su JSON?
- ¿Puede editarse desde la interfaz?
- ¿Qué ocurre después de reiniciar Grafana?
- ¿Cuál es la fuente de verdad del dashboard?

## Estructura recomendada para un dashboard

### Variables

Utiliza variables para:

```text
instance
job
device
mountpoint
datasource
```

### Paneles principales

Un dashboard de infraestructura puede incluir:

```text
Estado de targets
Uso de CPU
Uso de memoria
Uso de almacenamiento
Tráfico de red
Carga del sistema
Espacio libre
```

### Organización visual

Agrupa los paneles:

```text
Fila 1: Estado general
Fila 2: CPU y memoria
Fila 3: Almacenamiento
Fila 4: Red
Fila 5: Detalle por dispositivo
```

### Títulos claros

Buenos ejemplos:

```text
Uso de CPU por instancia
Memoria utilizada
Espacio utilizado por punto de montaje
Tráfico recibido por interfaz
Targets no disponibles
```

Evita títulos ambiguos:

```text
Panel 1
Datos
Servidor
Métrica
```

## Ejemplo de dashboard de monitorización

### Variable de instancia

```promql
label_values(up, instance)
```

### Panel de disponibilidad

```promql
up{
  instance=~"$instance"
}
```

### Panel de CPU

```promql
100 * (
  1 -
  avg by (instance) (
    rate(
      node_cpu_seconds_total{
        instance=~"$instance",
        mode="idle"
      }[$__rate_interval]
    )
  )
)
```

### Panel de memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance=~"$instance"
  }
  /
  node_memory_MemTotal_bytes{
    instance=~"$instance"
  }
)
```

### Panel de filesystem

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance=~"$instance",
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
  /
  node_filesystem_size_bytes{
    instance=~"$instance",
    mountpoint="/",
    fstype!~"tmpfs|overlay|squashfs"
  }
)
```

### Panel de red

```promql
sum by (instance, device) (
  rate(
    node_network_receive_bytes_total{
      instance=~"$instance",
      device!~"lo|docker.*|veth.*|br-.*"
    }[$__rate_interval]
  )
)
```

### Configuración de leyendas

```text
Disponibilidad: {{instance}}
CPU: {{instance}}
Memoria: {{instance}}
Filesystem: {{instance}} - {{mountpoint}}
Red: {{instance}} - {{device}}
```

## Diagnóstico automatizado de un dashboard

### Crear un informe básico

```bash
mkdir -p ~/laboratorio/diagnostico-dashboard
cd ~/laboratorio/diagnostico-dashboard
```

### Recopilar información

```bash
{
  echo "===== DIAGNÓSTICO DE DASHBOARD ====="
  echo "Fecha: $(date)"
  echo "Equipo: $(hostname)"
  echo

  echo "===== GRAFANA ====="
  systemctl is-active grafana-server 2>/dev/null || true
  echo

  echo "===== PROMETHEUS ====="
  systemctl is-active prometheus 2>/dev/null || true
  curl -sS \
    --max-time 5 \
    http://localhost:9090/-/healthy \
    || true
  echo
  echo

  echo "===== TARGETS ====="
  curl -sS \
    --max-time 5 \
    http://localhost:9090/api/v1/targets \
    || true
  echo
  echo

  echo "===== CONSULTA UP ====="
  curl -sS \
    --max-time 5 \
    http://localhost:9090/api/v1/query \
    --data-urlencode 'query=up' \
    || true
  echo
  echo

  echo "===== HORA ====="
  date
  timedatectl
} | tee diagnostico-dashboard.txt
```

### Revisar el informe

```bash
less diagnostico-dashboard.txt
```

## Lista de comprobación rápida

```text
[ ] Grafana está activo.
[ ] Prometheus está activo.
[ ] La fuente de datos funciona.
[ ] La fuente seleccionada por el panel es correcta.
[ ] La consulta PromQL es válida.
[ ] La consulta devuelve resultados en Prometheus.
[ ] Las variables tienen valores.
[ ] Las variables múltiples utilizan =~.
[ ] La opción All está configurada correctamente.
[ ] El rango temporal contiene datos.
[ ] El target está disponible.
[ ] Las métricas existen.
[ ] Las etiquetas utilizadas son correctas.
[ ] Las unidades son adecuadas.
[ ] Las leyendas son comprensibles.
[ ] Las transformaciones no eliminan datos.
[ ] Los permisos permiten ver el dashboard.
[ ] Los permisos permiten editarlo si es necesario.
[ ] No existen errores en Query Inspector.
[ ] El dashboard se ha guardado correctamente.
```

## Buenas prácticas

- Diseña dashboards con un objetivo concreto.
- Utiliza títulos descriptivos.
- Mantén las consultas sencillas.
- Valida cada consulta en Prometheus.
- Utiliza variables para reutilizar dashboards.
- Usa `=~` con variables múltiples.
- Configura correctamente la opción `All`.
- Utiliza `$__rate_interval` en consultas `rate`.
- Define unidades coherentes.
- Configura leyendas útiles.
- Evita mostrar demasiadas series.
- Excluye interfaces virtuales cuando no sean relevantes.
- Utiliza agregaciones para reducir cardinalidad visual.
- No crees demasiados paneles en una única página.
- Utiliza rangos temporales razonables.
- Evita intervalos de refresco excesivamente cortos.
- Revisa Query Inspector cuando un panel no funcione.
- Diferencia `No data` de un error de conexión.
- Comprueba los permisos de carpetas y dashboards.
- Documenta si el dashboard se gestiona mediante provisioning.
- Realiza copias de seguridad antes de importar o modificar JSON.
- No incluyas credenciales, tokens ni datos sensibles.
- Comprueba el dashboard con varios usuarios.
- Comprueba el dashboard con varias instancias.
- Guarda los cambios y verifica que persisten.

## Tabla de síntomas y comprobaciones

| Síntoma | Primera prueba | Posible causa |
|---|---|---|
| Dashboard no encontrado | URL y permisos | Dashboard eliminado o inaccesible |
| Panel `No data` | Consulta `up` | Métrica o filtro incorrecto |
| Error de fuente | `Save & test` | URL o servicio |
| Variable vacía | Consulta de variable | Etiqueta incorrecta |
| Muchas series | Agregación | Consulta demasiado amplia |
| Leyendas ilegibles | Configuración de alias | Falta de formato |
| Unidades incorrectas | Opciones de campo | Consulta no convertida |
| Datos antiguos | Rango temporal y reloj | Scraping o tiempo |
| Dashboard lento | Query Inspector | Consultas costosas |
| Cambios desaparecen | Provisioning | Dashboard gestionado automáticamente |
| No puede editar | Permisos | Usuario de solo lectura |
| Pantalla vacía | Consola del navegador | Proxy, caché o URL base |
| Error tras importar | Fuente y variables | Dependencias del dashboard |
| Panel repetido excesivamente | Variable de repetición | Demasiados valores |

## Puntos clave

- Un dashboard está formado por paneles, consultas, variables y visualizaciones.
- Un panel vacío no implica necesariamente que Grafana esté fallando.
- La consulta debe probarse primero en Prometheus.
- La fuente de datos seleccionada debe ser la correcta.
- Query Inspector muestra la petición real enviada por Grafana.
- `No data` suele indicar ausencia de series coincidentes, no necesariamente un error de conexión.
- Las variables vacías pueden provocar consultas sin resultados.
- Las variables múltiples suelen requerir el operador `=~`.
- El rango temporal puede ocultar datos existentes.
- `$__rate_interval` es útil para consultas `rate`.
- Las unidades deben corresponder al resultado real de la consulta.
- Las leyendas deben identificar la instancia, interfaz o punto de montaje.
- Las transformaciones pueden eliminar o modificar los datos.
- Las consultas demasiado amplias pueden ralentizar el dashboard.
- Los permisos de carpetas y dashboards determinan qué puede hacer cada usuario.
- Los dashboards provisionados pueden sobrescribir cambios manuales.
- Los dashboards importados suelen requerir adaptar fuentes y variables.
- Un dashboard debe probarse con diferentes instancias y rangos temporales.
- Toda incidencia debe documentar el síntoma, la consulta, la fuente, la causa y la solución.
- Un dashboard útil debe ser claro, reutilizable y fácil de diagnosticar.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre un dashboard y un panel?
2. ¿Qué elementos puede contener un panel?
3. ¿Qué significa que un panel muestre `No data`?
4. ¿Qué comprobarías antes de modificar una consulta?
5. ¿Qué función cumple Query Inspector?
6. ¿Por qué es útil probar una consulta con `up`?
7. ¿Qué diferencia existe entre `instance="$instance"` e `instance=~"$instance"`?
8. ¿Qué puede causar que una variable aparezca vacía?
9. ¿Qué función cumple `$__rate_interval`?
10. ¿Qué unidad utilizarías para una métrica de memoria expresada en bytes?
11. ¿Qué unidad utilizarías para una métrica de tráfico expresada en bytes por segundo?
12. ¿Qué puede provocar que un panel muestre demasiadas series?
13. ¿Cómo reducirías el número de series de una consulta?
14. ¿Qué comprobarías si una consulta funciona en Prometheus, pero no en Grafana?
15. ¿Qué problemas pueden aparecer al importar un dashboard?
16. ¿Qué es un dashboard provisionado?
17. ¿Por qué pueden desaparecer los cambios manuales de un dashboard?
18. ¿Qué diferencia existe entre un usuario que puede ver y otro que puede editar?
19. ¿Qué factores pueden ralentizar un dashboard?
20. ¿Qué información debe incluir un informe de problemas de un dashboard?