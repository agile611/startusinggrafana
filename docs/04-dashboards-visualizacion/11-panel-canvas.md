# Panel Canvas

El panel **Canvas** de Grafana permite crear una composición visual personalizada combinando texto, formas, imágenes, iconos y valores procedentes de consultas.

Mientras que un panel Time series representa una métrica mediante un gráfico temporal, Canvas permite diseñar una vista visual más parecida a un esquema, un mapa operativo o un diagrama de infraestructura.

Puede utilizarse para representar:

- El estado de servidores.
- La topología de una red.
- La relación entre servicios.
- El flujo de una aplicación.
- La ubicación de componentes.
- Indicadores sobre un diagrama.
- Valores de CPU, memoria o disponibilidad.
- Estados mediante colores.
- Enlaces hacia otros dashboards.
- Un mapa visual de una infraestructura.

Un panel Canvas combina dos tipos de información:

```text
Elementos visuales estáticos
        +
Datos dinámicos de Grafana
        |
        v
Vista operativa personalizada
```

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar la finalidad del panel Canvas.
- Diferenciar Canvas de un panel Text, Time series y Node Graph.
- Crear un panel Canvas.
- Añadir elementos visuales.
- Añadir texto, formas, imágenes e iconos.
- Incorporar valores procedentes de consultas.
- Configurar colores y tamaños.
- Crear una representación visual de una infraestructura.
- Utilizar consultas PromQL en elementos dinámicos.
- Mostrar el estado de servidores.
- Representar CPU, memoria y disponibilidad.
- Organizar elementos mediante capas.
- Mover y redimensionar elementos.
- Utilizar enlaces desde elementos visuales.
- Crear un panel Canvas como mapa operativo.
- Diseñar una vista de laboratorio.
- Diagnosticar elementos sin datos.
- Aplicar buenas prácticas de legibilidad y seguridad.
- Exportar y documentar un dashboard con Canvas.

---

# Introducción

Un panel Canvas permite crear una composición visual libre dentro de Grafana.

En lugar de limitarse a una cuadrícula de gráficos, se puede diseñar una vista como esta:

```text
+------------------------------------------------------+
|             MAPA DE INFRAESTRUCTURA                  |
|                                                      |
|  [Usuarios] ---> [Balanceador] ---> [Aplicación]     |
|                                      |               |
|                                      v               |
|                               [Base de datos]        |
|                                                      |
|  Servidor 1: UP       CPU: 42 %      Memoria: 61 %  |
|  Servidor 2: UP       CPU: 78 %      Memoria: 74 %  |
+------------------------------------------------------+
```

El panel Canvas puede utilizarse para colocar:

- Un título.
- Una imagen de fondo.
- Iconos de servidores.
- Etiquetas.
- Valores actuales.
- Colores de estado.
- Flechas o conexiones.
- Enlaces.
- Indicadores operativos.

El objetivo no es decorar el dashboard. El objetivo es mostrar la información de una forma que facilite la comprensión del sistema.

---

# Cuándo utilizar Canvas

Canvas es apropiado cuando:

- Se necesita una vista visual personalizada.
- La posición de los elementos tiene significado.
- Se desea representar una topología.
- Se quiere colocar indicadores sobre una imagen.
- Se necesita combinar texto y métricas.
- Se desea crear una pantalla de operaciones.
- Se necesita una representación sencilla de un servicio.

## Ejemplos adecuados

### Mapa de servidores

```text
Servidor web 1
Servidor web 2
Servidor de base de datos
Servidor de monitorización
```

### Flujo de una aplicación

```text
Usuarios → API → Servicios → Base de datos
```

### Estado de una infraestructura

```text
Prometheus: UP
Grafana: UP
Node Exporter: UP
Aplicación web: DOWN
```

### Indicadores sobre un plano

Una imagen puede representar un centro de datos y los valores pueden situarse sobre los equipos correspondientes.

---

# Cuándo no utilizar Canvas

Canvas no suele ser la mejor opción cuando se necesita:

- Analizar tendencias durante mucho tiempo.
- Mostrar muchas series temporales.
- Comparar numerosos valores.
- Representar una distribución estadística.
- Consultar grandes cantidades de datos.
- Crear una tabla detallada.
- Sustituir un sistema de diagramas especializado.

En esos casos pueden ser más adecuados:

| Necesidad | Visualización recomendada |
|---|---|
| Evolución temporal | Time series |
| Valor actual | Stat |
| Valor frente a límites | Gauge |
| Comparación de valores | Bar Gauge |
| Distribución temporal | Heatmap |
| Tabla de datos | Table |
| Topología automática | Node Graph |
| Diagrama visual personalizado | Canvas |

Canvas puede complementar estos paneles, pero no debe utilizarse para mostrar toda la información del sistema en una única pantalla.

---

# Diferencia entre Canvas y panel Text

El panel Text se utiliza principalmente para documentación.

Canvas se utiliza para crear una composición visual con elementos colocados libremente.

## Panel Text

Adecuado para:

```text
- Descripciones.
- Procedimientos.
- Tablas.
- Consultas.
- Advertencias.
```

## Panel Canvas

Adecuado para:

```text
- Esquemas.
- Mapas.
- Indicadores visuales.
- Iconos.
- Relaciones entre componentes.
- Valores colocados sobre una imagen.
```

Es posible incluir texto dentro de Canvas, pero su propósito principal es la composición visual.

---

# Diferencia entre Canvas y Node Graph

Node Graph está orientado a representar relaciones entre nodos mediante datos estructurados.

Canvas ofrece un control visual más libre.

| Característica | Canvas | Node Graph |
|---|---|---|
| Posición manual | Muy adecuada | Más limitada |
| Imagen de fondo | Posible | No es su objetivo |
| Texto libre | Sí | Limitado |
| Indicadores sobre un plano | Sí | No es su objetivo |
| Relaciones automáticas | Manuales o visuales | Basadas en datos |
| Topología dinámica | Limitada | Más adecuada |
| Diseño personalizado | Alto | Más bajo |

Utilizar Canvas cuando el diseño visual sea importante.

Utilizar Node Graph cuando las relaciones entre nodos procedan directamente de los datos.

---

# Elementos de Canvas

La disponibilidad exacta de elementos puede variar según la versión de Grafana.

Entre los elementos habituales se encuentran:

- Texto.
- Forma.
- Imagen.
- Icono.
- Valor de métrica.
- Elementos interactivos.
- Enlaces.
- Conexiones o líneas.
- Fondos.
- Contenedores o grupos.

## Texto

Permite añadir:

```text
Títulos
Etiquetas
Descripciones
Nombres de servicios
Advertencias
```

## Forma

Permite crear:

```text
Rectángulos
Círculos
Tarjetas
Fondos
Zonas de agrupación
```

## Imagen

Permite utilizar:

```text
Logotipos
Planos
Diagramas
Mapas de red
Esquemas de arquitectura
```

## Icono

Permite representar visualmente:

```text
Servidores
Bases de datos
Usuarios
Aplicaciones
Redes
Dispositivos
```

## Valor de métrica

Permite mostrar un valor procedente de una consulta.

Ejemplos:

```text
CPU: 42 %
Memoria: 61 %
Estado: UP
```

## Conexiones

Permiten representar relaciones o flujos:

```text
Usuarios → Aplicación
Aplicación → Base de datos
Prometheus → Exporters
```

---

# Crear un panel Canvas

## Procedimiento general

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar la visualización `Canvas`.
5. Crear el diseño inicial.
6. Añadir elementos visuales.
7. Configurar la posición y el tamaño.
8. Añadir consultas si se necesitan valores dinámicos.
9. Configurar colores y estilos.
10. Añadir enlaces.
11. Revisar el comportamiento con datos reales.
12. Guardar el panel.
13. Guardar el dashboard.

## Diseño inicial recomendado

Para una práctica de laboratorio:

```text
+------------------------------------------------------+
| Monitorización de infraestructura                    |
+------------------------------------------------------+
| Prometheus       Grafana          Node Exporter      |
| Estado           Estado          Estado             |
+------------------------------------------------------+
| CPU              Memoria          Disco              |
| 42 %             61 %             73 %               |
+------------------------------------------------------+
```

---

# Planificar el diseño

Antes de crear el panel Canvas, definir:

- Qué información debe mostrar.
- Qué elementos son estáticos.
- Qué valores deben actualizarse.
- Qué colores se utilizarán.
- Qué componentes deben estar relacionados.
- Qué enlaces serán necesarios.
- Qué tamaño tendrá el panel.
- Quién utilizará la vista.

## Ejemplo de planificación

```text
Objetivo:
Mostrar el estado general de tres servicios.

Elementos estáticos:
- Título.
- Nombres de los servicios.
- Flechas de relación.

Elementos dinámicos:
- Disponibilidad.
- CPU.
- Memoria.

Colores:
- Verde: disponible.
- Rojo: no disponible.
- Amarillo: valor elevado.

Enlaces:
- Dashboard de aplicaciones.
- Dashboard de infraestructura.
```

Una buena planificación evita terminar con muchos elementos superpuestos y sin jerarquía. Canvas permite libertad, pero la libertad sin orden produce un pequeño museo del caos.

---

# Crear una composición básica

## Elementos recomendados

Crear:

```text
1. Un título.
2. Tres tarjetas de servicio.
3. Un nombre por tarjeta.
4. Un valor de disponibilidad.
5. Un valor de CPU.
6. Un valor de memoria.
7. Una leyenda de colores.
```

## Distribución

```text
+------------------------------------------------------+
| Estado de servicios                                  |
+------------------------------------------------------+
| [Prometheus]   [Grafana]       [Node Exporter]       |
|    UP             UP                UP              |
|                                                      |
| CPU: 22 %       CPU: 41 %        CPU: 63 %           |
| MEM: 35 %       MEM: 58 %        MEM: 71 %           |
+------------------------------------------------------+
```

## Buenas prácticas

- Mantener márgenes.
- Alinear las tarjetas.
- Utilizar tamaños consistentes.
- Reservar espacio para valores largos.
- No superponer elementos.
- Mantener el texto legible.
- Utilizar colores con suficiente contraste.

---

# Configurar texto

El texto puede utilizarse para:

- Títulos.
- Nombres de componentes.
- Leyendas.
- Advertencias.
- Descripciones.
- Etiquetas de ejes visuales.

## Ejemplo de títulos

```text
Estado de infraestructura
Servicios principales
Servidores de producción
Flujo de la aplicación
```

## Ejemplo de etiquetas

```text
Usuarios
Balanceador
API
Base de datos
Monitorización
```

## Recomendaciones

- Utilizar títulos breves.
- Evitar párrafos extensos dentro de diagramas.
- Diferenciar títulos y etiquetas mediante tamaño.
- Mantener una terminología coherente.
- No utilizar demasiados colores en el texto.

---

# Configurar formas

Las formas pueden utilizarse como:

- Tarjetas.
- Fondos.
- Contenedores.
- Zonas de agrupación.
- Indicadores visuales.
- Separadores.

## Ejemplo de tarjeta

```text
+----------------------------+
| Prometheus                 |
| Estado: UP                |
| Targets: 4                |
+----------------------------+
```

## Recomendaciones

- Utilizar un mismo estilo para componentes equivalentes.
- Reservar colores intensos para estados importantes.
- Mantener suficiente espacio interior.
- No utilizar fondos demasiado oscuros detrás de texto oscuro.
- Agrupar visualmente elementos relacionados.

---

# Configurar colores

Los colores deben tener un significado coherente.

Convención recomendada:

```text
Verde: funcionamiento normal
Amarillo: advertencia
Rojo: problema o estado crítico
Azul: información
Gris: elemento inactivo o no seleccionado
```

## Ejemplo

```text
Prometheus: verde
Grafana: verde
Aplicación web: amarillo
Base de datos: rojo
```

## Precauciones

No utilizar colores únicamente por motivos decorativos.

Un usuario debe poder interpretar el panel sin preguntarse qué significa cada color.

Añadir una leyenda:

```text
Verde = disponible
Amarillo = requiere revisión
Rojo = no disponible o crítico
```

---

# Añadir valores dinámicos

Los valores dinámicos proceden de consultas de Grafana.

Ejemplos:

```promql
up
```

```promql
100 * avg(up)
```

```promql
node_load1
```

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Valores adecuados para Canvas

- Disponibilidad.
- CPU.
- Memoria.
- Almacenamiento.
- Número de objetivos.
- Latencia.
- Tráfico.
- Número de errores.

## Recomendación

Utilizar valores reducidos y fáciles de interpretar.

Canvas no debería mostrar cientos de series en una única zona visual.

---

# Consultas PromQL para Canvas

## Estado de Prometheus

```promql
up{job="prometheus"}
```

## Estado de Node Exporter

```promql
up{job="node_exporter"}
```

## Objetivos disponibles

```promql
sum(up)
```

## Disponibilidad global

```promql
100 * avg(up)
```

## CPU de una instancia

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{
      mode="idle",
      instance="localhost:9100"
    }[5m])
  ) * 100
)
```

## CPU por instancia

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

## Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

## Uso del sistema de ficheros raíz

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

## Carga del sistema

```promql
node_load1
```

---

# Mostrar el estado de un servicio

## Consulta

```promql
up{job="node_exporter"}
```

Resultado:

```text
1 = disponible
0 = no disponible
```

## Interpretación visual

```text
1 → UP → Verde
0 → DOWN → Rojo
```

Si el elemento Canvas permite mapas de valores, configurar:

```text
1 → UP
0 → DOWN
```

Si no permite mapas de valores directamente, se puede utilizar:

- Un Stat auxiliar.
- Una transformación.
- Un elemento de texto asociado.
- Un color configurado según el resultado.
- Un panel independiente junto al Canvas.

Las posibilidades exactas dependen de la versión de Grafana y de la configuración del panel.

---

# Configurar unidades y formatos

Los valores mostrados en Canvas deben tener unidades claras.

## Porcentajes

```text
CPU: 42 %
Memoria: 61 %
Disponibilidad: 100 %
```

Unidad:

```text
Percent (0-100)
```

## Bytes

```text
Memoria disponible: 4.2 GiB
```

Unidad:

```text
Bytes (IEC)
```

## Velocidad

```text
Tráfico: 1.4 MB/s
```

Unidad:

```text
bytes/sec
```

## Carga

```text
Carga: 0.82
```

Unidad:

```text
None
```

La carga no debe mostrarse como porcentaje salvo que se haya realizado un cálculo específico.

---

# Configurar umbrales en Canvas

Cuando un valor dinámico utiliza umbrales, se puede representar con colores o estilos diferentes.

## Ejemplo de CPU

```text
0 - 69 %:   Verde
70 - 89 %:  Amarillo
90 - 100 %: Rojo
```

## Ejemplo de memoria

```text
0 - 69 %:   Verde
70 - 89 %:  Amarillo
90 - 100 %: Rojo
```

## Ejemplo de almacenamiento

```text
0 - 79 %:   Verde
80 - 89 %:  Amarillo
90 - 100 %: Rojo
```

## Consideración

La consulta, la unidad y el umbral deben utilizar la misma escala.

No mezclar:

```text
Consulta en proporción: 0.73
```

con:

```text
Umbral crítico: 90
```

En ese caso, convertir la consulta a porcentaje:

```promql
100 *
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

o ajustar la escala a `0 - 1`.

---

# Utilizar imágenes de fondo

Una imagen de fondo puede representar:

- Un rack.
- Un plano de red.
- Una arquitectura.
- Un centro de datos.
- Un esquema de aplicación.
- Un mapa de ubicación.

## Recomendaciones

- Utilizar imágenes con licencia adecuada.
- Mantener un contraste suficiente.
- No ocultar los valores dinámicos.
- Utilizar una resolución razonable.
- Evitar imágenes demasiado pesadas.
- Documentar el origen si es necesario.
- No incluir información sensible.

## Ejemplo de composición

```text
Imagen de fondo:
Plano de un centro de datos

Elementos superpuestos:
- Servidor web 1
- Servidor web 2
- Base de datos
- Monitorización
- Estado de cada componente
```

---

# Representar un flujo de aplicación

## Diseño conceptual

```text
+----------+      +-------------+      +-------------+
| Usuarios | ---> | Balanceador | ---> | Aplicación  |
+----------+      +-------------+      +-------------+
                                             |
                                             v
                                      +-------------+
                                      | Base datos  |
                                      +-------------+
```

## Datos dinámicos

En cada bloque se pueden mostrar:

```text
Estado
CPU
Memoria
Latencia
Errores
```

## Ejemplo

```text
Aplicación
Estado: UP
CPU: 48 %
Errores: 0.4 %
```

El panel Canvas puede ofrecer una vista de alto nivel, mientras que otros dashboards contienen el detalle.

---

# Representar una topología de monitorización

## Diseño conceptual

```text
+-------------+
| Prometheus  |
+-------------+
       |
       +------------------+
       |                  |
       v                  v
+-------------+    +-------------+
| Node Exp. 1 |    | Node Exp. 2 |
+-------------+    +-------------+
       |                  |
       v                  v
+-------------+    +-------------+
| Servidor 1  |    | Servidor 2  |
+-------------+    +-------------+
```

## Valores dinámicos

Para Prometheus:

```promql
up{job="prometheus"}
```

Para Node Exporter:

```promql
up{job="node_exporter"}
```

Para el estado de una instancia:

```promql
up{instance="server-01:9100"}
```

## Actividad

Crear un Canvas que muestre:

- Prometheus.
- Grafana.
- Dos servidores.
- Dos exporters.
- Estado de cada componente.
- Líneas de relación.
- Una leyenda de colores.

---

# Utilizar enlaces

Los elementos de Canvas pueden configurarse con enlaces, según la versión y el tipo de elemento.

Los enlaces pueden dirigir a:

- Otro dashboard.
- Un panel específico.
- Explore.
- Un runbook.
- Documentación.
- Un sistema de tickets.

## Ejemplo conceptual

```text
Servidor web
      |
      +--> Dashboard de servidor
      +--> Dashboard de aplicación
      +--> Runbook de incidencias
```

## Buenas prácticas

- Utilizar enlaces descriptivos.
- Comprobar los permisos del destino.
- Evitar URLs con tokens.
- No enlazar a información innecesaria.
- Mantener los enlaces actualizados.
- Utilizar el mismo destino para elementos equivalentes.

---

# Organizar elementos y capas

En una composición Canvas puede haber elementos superpuestos.

Es importante controlar:

- Orden de apilamiento.
- Elementos delanteros.
- Elementos traseros.
- Agrupaciones.
- Alineación.
- Distribución.
- Bloqueo de elementos.

## Orden recomendado

```text
1. Fondo.
2. Zonas o contenedores.
3. Líneas y conexiones.
4. Iconos.
5. Formas de tarjetas.
6. Valores.
7. Etiquetas.
8. Avisos.
```

## Recomendaciones

- Bloquear el fondo después de colocarlo.
- Agrupar elementos relacionados.
- Utilizar una cuadrícula visual.
- Alinear tarjetas.
- Mantener distancias regulares.
- Evitar que los valores queden detrás de las formas.

---

# Crear tarjetas de servicio

Una tarjeta puede representar un componente.

## Ejemplo

```text
+-----------------------------+
| API                         |
|                             |
| Estado: UP                  |
| CPU: 42 %                   |
| Memoria: 61 %               |
| Latencia p95: 180 ms        |
+-----------------------------+
```

## Elementos de una tarjeta

```text
Fondo:
Rectángulo

Título:
API

Estado:
UP

Métrica 1:
CPU: 42 %

Métrica 2:
Memoria: 61 %

Métrica 3:
Latencia p95: 180 ms
```

## Recomendaciones

- Mantener el mismo tamaño en todas las tarjetas.
- Utilizar la misma posición para cada métrica.
- Alinear los valores.
- Utilizar el color únicamente para estados.
- No mostrar más datos de los necesarios.

---

# Ejemplo completo 1: Canvas de infraestructura

## Objetivo

Crear un mapa visual de una infraestructura pequeña.

## Componentes

```text
Prometheus
Grafana
Servidor web
Servidor de base de datos
Node Exporter
```

## Diseño

```text
+------------------------------------------------------+
| Infraestructura de laboratorio                       |
+------------------------------------------------------+
|                                                      |
| +------------+       +-------------+                 |
| | Grafana    | ----> | Prometheus  |                 |
| | UP         |       | UP          |                 |
| +------------+       +-------------+                 |
|                              |                       |
|                      +-------+-------+               |
|                      |               |               |
|                      v               v               |
|                +-----------+   +-----------+          |
|                | Web       |   | Base datos|          |
|                | UP        |   | UP        |          |
|                +-----------+   +-----------+          |
|                                                      |
+------------------------------------------------------+
```

## Valores recomendados

```promql
up{job="prometheus"}
```

```promql
up{job="node_exporter"}
```

```promql
100 * avg(up)
```

## Actividad

1. Crear el fondo.
2. Añadir las tarjetas.
3. Añadir las líneas.
4. Añadir valores de estado.
5. Añadir una leyenda.
6. Configurar colores.
7. Guardar el dashboard.

---

# Ejemplo completo 2: Canvas de estado operativo

## Objetivo

Mostrar los indicadores principales de un servidor.

## Elementos

```text
Nombre del servidor
Estado
CPU
Memoria
Almacenamiento
Carga
```

## Consultas

### Estado

```promql
up{job="node_exporter"}
```

### CPU

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{
      mode="idle",
      instance="localhost:9100"
    }[5m])
  ) * 100
)
```

### Memoria

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes{
    instance="localhost:9100"
  }
  /
  node_memory_MemTotal_bytes{
    instance="localhost:9100"
  }
)
```

### Almacenamiento

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    instance="localhost:9100",
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    instance="localhost:9100",
    mountpoint="/",
    fstype!~"tmpfs|overlay"
  }
)
```

### Carga

```promql
node_load1{instance="localhost:9100"}
```

## Diseño conceptual

```text
+--------------------------------------+
| Servidor: localhost:9100             |
+--------------------------------------+
| Estado          UP                   |
| CPU             42 %                 |
| Memoria         61 %                 |
| Almacenamiento  73 %                 |
| Carga           0.82                 |
+--------------------------------------+
```

---

# Ejemplo completo 3: Canvas de flujo de aplicación

## Objetivo

Representar el flujo principal de una aplicación.

## Diseño

```text
+----------+       +----------+       +-------------+
| Usuarios | ----> | Web      | ----> | API         |
+----------+       +----------+       +-------------+
                                             |
                                             v
                                      +-------------+
                                      | Base datos  |
                                      +-------------+
```

## Información dinámica

```text
Web:
- Estado
- CPU
- Latencia

API:
- Estado
- Errores
- Latencia p95

Base de datos:
- Estado
- Conexiones
- Uso de disco
```

## Actividades

1. Crea los cuatro bloques.
2. Añade las conexiones.
3. Añade los estados.
4. Utiliza colores.
5. Añade un enlace al dashboard de cada servicio.
6. Documenta el significado de las conexiones.

---

# Ejemplo de sesión 1: crear un Canvas básico

## Objetivo

Crear una composición sencilla con tres servicios.

## Pasos

1. Acceder a Grafana.
2. Abrir un dashboard.
3. Añadir un panel.
4. Seleccionar `Canvas`.
5. Añadir un título:

```text
Estado de servicios
```

6. Añadir tres formas rectangulares.
7. Etiquetarlas:

```text
Prometheus
Grafana
Node Exporter
```

8. Añadir una línea o conexión entre los elementos.
9. Añadir una leyenda:

```text
Verde: disponible
Rojo: no disponible
```

10. Guardar el panel.
11. Guardar el dashboard.

## Actividades

1. Cambia el color de fondo.
2. Alinea los tres elementos.
3. Añade iconos.
4. Añade una descripción.
5. Redimensiona el panel para ocupar todo el ancho.

---

# Ejemplo de sesión 2: añadir valores dinámicos

## Objetivo

Mostrar el estado actual de Prometheus y Node Exporter.

## Consulta de Prometheus

```promql
up{job="prometheus"}
```

## Consulta de Node Exporter

```promql
up{job="node_exporter"}
```

## Pasos

1. Abrir el panel Canvas.
2. Añadir un elemento de valor de métrica.
3. Seleccionar Prometheus.
4. Introducir la consulta.
5. Configurar el nombre:

```text
Prometheus
```

6. Repetir el proceso para Node Exporter.
7. Colocar cada valor junto a su tarjeta.
8. Configurar la unidad.
9. Configurar colores o mapas de valores.
10. Guardar.

## Actividades

1. Detén Node Exporter:

```bash
sudo systemctl stop node_exporter
```

2. Espera al siguiente scraping.
3. Observa el cambio.
4. Inicia Node Exporter:

```bash
sudo systemctl start node_exporter
```

5. Comprueba la recuperación.
6. Documenta el tiempo aproximado del cambio.

---

# Ejemplo de sesión 3: añadir CPU y memoria

## Objetivo

Crear una tarjeta visual con recursos del servidor.

## Pasos

1. Crear una forma como fondo.
2. Añadir un texto:

```text
Servidor Linux
```

3. Añadir un valor dinámico de CPU.
4. Utilizar:

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

5. Añadir un valor dinámico de memoria.
6. Utilizar:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

7. Configurar las unidades como porcentaje.
8. Colocar los valores dentro de la tarjeta.
9. Configurar colores.
10. Guardar el panel.

## Actividades

1. Añade una métrica de almacenamiento.
2. Añade la carga del sistema.
3. Alinea todos los valores.
4. Comprueba que el texto no se superpone.
5. Genera carga de CPU y observa el cambio.

---

# Ejemplo de sesión 4: crear un mapa de topología

## Objetivo

Representar la relación entre Prometheus y dos servidores.

## Diseño

```text
                         +-------------+
                         | Prometheus  |
                         +-------------+
                           /           \
                          /             \
                         v               v
                +---------------+ +---------------+
                | Servidor 1    | | Servidor 2    |
                | Node Exporter | | Node Exporter |
                +---------------+ +---------------+
```

## Pasos

1. Añadir el título.
2. Añadir la forma de Prometheus.
3. Añadir las formas de los servidores.
4. Añadir los iconos.
5. Añadir las conexiones.
6. Añadir los estados.
7. Añadir la CPU de cada servidor.
8. Añadir una leyenda.
9. Guardar.

## Actividades

1. Detén uno de los exporters.
2. Observa el cambio de estado.
3. Cambia el color de la tarjeta afectada.
4. Inicia de nuevo el exporter.
5. Comprueba la recuperación.

---

# Ejemplo de sesión 5: usar una imagen de fondo

## Objetivo

Colocar valores dinámicos sobre una imagen de infraestructura.

## Preparación

Utilizar una imagen de laboratorio autorizada que represente:

```text
Un rack
Un plano
Una arquitectura
Una topología
```

## Pasos

1. Añadir un elemento de imagen.
2. Seleccionar la imagen.
3. Ajustar su tamaño.
4. Enviar la imagen al fondo.
5. Añadir iconos sobre los componentes.
6. Añadir valores de estado.
7. Añadir etiquetas.
8. Comprobar el contraste.
9. Guardar el panel.

## Actividades

1. Coloca un indicador por servidor.
2. Utiliza verde para disponibilidad.
3. Utiliza rojo para indisponibilidad.
4. Añade un texto que identifique el entorno.
5. Comprueba la legibilidad en pantalla completa.

---

# Ejemplo de sesión 6: crear enlaces hacia otros dashboards

## Objetivo

Convertir elementos Canvas en puntos de navegación.

## Pasos

1. Crear una tarjeta para el servidor web.
2. Abrir la configuración del elemento.
3. Añadir un enlace al dashboard del servidor.
4. Crear una tarjeta para la base de datos.
5. Añadir un enlace al dashboard de base de datos.
6. Probar ambos enlaces.
7. Revisar los permisos.

## Actividades

1. Añade un enlace al dashboard de red.
2. Añade un enlace a un runbook.
3. Añade un texto que indique:

```text
Haz clic en el componente para consultar el detalle.
```

4. Comprueba que los enlaces no contienen tokens.
5. Documenta las rutas utilizadas.

---

# Ejemplo de sesión 7: configurar colores por estado

## Objetivo

Representar visualmente los estados `UP` y `DOWN`.

## Consulta

```promql
up{job="node_exporter"}
```

## Mapa de valores

```text
1 → UP
0 → DOWN
```

## Colores

```text
UP → Verde
DOWN → Rojo
```

## Pasos

1. Crear un valor dinámico.
2. Seleccionar la métrica.
3. Configurar el mapa de valores.
4. Configurar los colores.
5. Colocar el estado junto al nombre del servidor.
6. Detener Node Exporter.
7. Observar el cambio.
8. Iniciar Node Exporter.
9. Confirmar la recuperación.

## Actividades

1. Añade un tercer estado para ausencia de datos.
2. Documenta la diferencia entre:
   - `DOWN`
   - `No data`
   - `Error`
3. Comprueba cómo representa Canvas cada situación.

---

# Ejemplo de sesión 8: crear una vista con variables

## Objetivo

Permitir la selección de una instancia.

## Crear la variable

Crear una variable llamada:

```text
instance
```

Consulta de variable posible:

```promql
label_values(up, instance)
```

La sintaxis puede variar según la versión de Grafana y el editor de variables.

## Consulta de CPU

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

## Pasos

1. Crear la variable.
2. Añadir un elemento dinámico de CPU.
3. Introducir la consulta.
4. Añadir un texto:

```text
Instancia seleccionada: $instance
```

5. Cambiar la instancia.
6. Comprobar el valor mostrado.
7. Probar la opción `All`.

## Actividades

1. Añade una variable `job`.
2. Muestra el job seleccionado.
3. Comprueba qué ocurre cuando se seleccionan varias instancias.
4. Documenta el resultado.

---

# Ejemplo de sesión 9: diagnosticar un elemento sin datos

## Objetivo

Identificar por qué un valor Canvas no se muestra correctamente.

## Consulta incorrecta

```promql
metrica_inexistente_para_canvas
```

## Pasos

1. Crear un elemento dinámico.
2. Introducir la consulta incorrecta.
3. Observar el resultado.
4. Probar la consulta:

```promql
up
```

5. Revisar la fuente de datos.
6. Revisar el inspector del panel.
7. Revisar el rango temporal.
8. Restaurar la consulta válida.
9. Guardar el panel.

## Actividades

Documentar:

```text
Elemento afectado:
Consulta:
Resultado observado:
Fuente de datos:
Causa:
Solución:
Resultado final:
```

---

# Ejemplo de sesión 10: exportar un dashboard con Canvas

## Objetivo

Crear una copia de seguridad del diseño.

## Pasos

1. Abrir el dashboard.
2. Revisar los elementos Canvas.
3. Comprobar las consultas.
4. Comprobar los enlaces.
5. Revisar las imágenes.
6. Revisar la información sensible.
7. Exportar el dashboard en JSON.
8. Guardar el fichero:

```text
dashboard-canvas-infraestructura.json
```

9. Validar el fichero:

```bash
jq empty dashboard-canvas-infraestructura.json
```

10. Importar una copia.
11. Comprobar el diseño.
12. Comprobar los valores dinámicos.

## Actividades

1. Exporta el dashboard.
2. Importa una copia.
3. Compara el diseño original y el importado.
4. Comprueba si las imágenes se conservan.
5. Comprueba si los enlaces funcionan.
6. Documenta cualquier adaptación necesaria.

---

# Buenas prácticas

## Diseñar antes de configurar

Definir primero:

- Elementos.
- Posiciones.
- Colores.
- Consultas.
- Enlaces.
- Responsables.
- Público objetivo.

## Mantener una jerarquía visual

El usuario debe distinguir rápidamente:

```text
Título
Componentes
Estados
Métricas
Acciones
```

## Utilizar un número limitado de colores

Una paleta pequeña facilita la interpretación.

## Reservar el rojo para problemas reales

No utilizar rojo como decoración.

## Mantener el mismo estilo

Las tarjetas equivalentes deben tener:

- Mismo tamaño.
- Mismos colores.
- Misma tipografía.
- Misma posición de las métricas.
- Misma estructura.

## Utilizar elementos dinámicos con moderación

Canvas no debe convertirse en una pantalla llena de valores pequeños.

## Evitar el solapamiento

Comprobar la vista en:

- Tamaño normal.
- Pantalla completa.
- Diferentes resoluciones.
- Navegadores compatibles.

## Utilizar imágenes optimizadas

Imágenes excesivamente grandes pueden afectar al rendimiento.

## Bloquear elementos estáticos

Bloquear fondos y elementos que no deben moverse accidentalmente.

## Documentar las consultas

Añadir un panel Text cercano o una descripción del dashboard.

## Probar estados normales y anómalos

Comprobar:

- Disponible.
- No disponible.
- Sin datos.
- Valor elevado.
- Error de consulta.

---

# Seguridad del panel Canvas

Canvas puede mostrar información sensible de forma muy visible.

No incluir:

- Contraseñas.
- Tokens.
- Claves privadas.
- Cadenas de conexión.
- Direcciones internas innecesarias.
- Información de clientes.
- Datos personales.
- Rutas de administración sin protección.
- Imágenes con información confidencial.

## Revisar imágenes

Una imagen de fondo puede contener:

- Direcciones IP.
- Nombres de servidores.
- Nombres de clientes.
- Identificadores de red.
- Información de ubicación.
- Datos de arquitectura.

Antes de compartir el dashboard, revisar también las imágenes.

## Revisar enlaces

No incluir enlaces como:

```text
https://usuario:contraseña@example.com
```

Utilizar enlaces autenticados mediante el mecanismo de acceso correspondiente.

---

# Problemas habituales

## El panel Canvas aparece vacío

Comprobar:

- Que el panel está guardado.
- Que la visualización seleccionada es Canvas.
- Que los elementos están dentro del área visible.
- Que los elementos no están detrás del fondo.
- Que la imagen no cubre todo el contenido.
- Que el zoom no oculta los elementos.

## Un elemento queda detrás de otro

Revisar:

- Orden de capas.
- Elementos delanteros y traseros.
- Posición del fondo.
- Agrupaciones.
- Visibilidad.

## El valor dinámico no aparece

Comprobar:

- Fuente de datos.
- Consulta.
- Rango temporal.
- Variables.
- Permisos.
- Estado de la métrica.
- Inspector del panel.
- Elemento seleccionado.

## El valor aparece con una unidad incorrecta

Revisar:

- Consulta.
- Unidad.
- Multiplicación por `100`.
- Escala.
- Decimales.

## Todos los elementos tienen el mismo color

Comprobar:

- Configuración de umbrales.
- Mapa de valores.
- Tipo de color.
- Consulta.
- Campo utilizado.
- Compatibilidad de la versión.

## La imagen no se muestra

Posibles causas:

- URL inaccesible.
- Recurso bloqueado.
- Formato no compatible.
- Permisos.
- Ruta incorrecta.
- Imagen demasiado grande.
- Restricciones de seguridad.

## Los enlaces no funcionan

Comprobar:

- URL.
- Permisos.
- Organización.
- Identificador del dashboard.
- Rutas relativas.
- Restricciones del navegador.

## El diseño se ve mal en otra pantalla

Posibles causas:

- Elementos posicionados de forma absoluta.
- Tamaños fijos.
- Texto demasiado grande.
- Panel demasiado estrecho.
- Imagen de fondo con relación de aspecto diferente.

Soluciones:

- Aumentar el tamaño del panel.
- Reducir texto.
- Alinear elementos.
- Utilizar tamaños coherentes.
- Probar distintas resoluciones.

## El panel tarda en cargar

Posibles causas:

- Demasiadas consultas.
- Muchas imágenes.
- Consultas complejas.
- Demasiados elementos dinámicos.
- Intervalo de actualización demasiado corto.
- Fuentes de datos lentas.

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/panel-canvas
```

Guardar las consultas:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-canvas/consultas-promql.txt <<'EOF'
Estado de Prometheus:
up{job="prometheus"}

Estado de Node Exporter:
up{job="node_exporter"}

Objetivos disponibles:
sum(up)

Disponibilidad global:
100 * avg(up)

Uso de CPU:
100 - (
  avg(
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)

Uso de memoria:
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)

Carga del sistema:
node_load1
EOF
```

Guardar la información del diseño:

```bash
cat > ~/laboratorio-grafana/evidencias/panel-canvas/diseno.txt <<'EOF'
Práctica: Panel Canvas

Objetivo del Canvas:

Elementos estáticos:

Elementos dinámicos:

Consultas utilizadas:

Colores utilizados:

Enlaces añadidos:

Imagen de fondo:

Variables utilizadas:

Problemas encontrados:

Soluciones aplicadas:

Conclusiones:
EOF
```

Guardar una respuesta de la API:

```bash
curl -sG \
  http://localhost:9090/api/v1/query \
  --data-urlencode 'query=100 * avg(up)' \
  | jq \
  > ~/laboratorio-grafana/evidencias/panel-canvas/disponibilidad.json
```

Capturas recomendadas:

```text
01-canvas-basico.png
02-canvas-servicios.png
03-canvas-valores-dinamicos.png
04-canvas-topologia.png
05-canvas-imagen-fondo.png
06-canvas-estado-down.png
07-canvas-enlaces.png
08-canvas-dashboard-final.png
```

---

# Práctica integradora

## Objetivo

Crear un panel Canvas que represente visualmente una infraestructura de laboratorio.

## Componentes

```text
Grafana
Prometheus
Servidor web
Servidor de base de datos
Node Exporter
```

## Diseño propuesto

```text
+------------------------------------------------------+
| Infraestructura de laboratorio                       |
+------------------------------------------------------+
|                                                      |
|  +----------+     +------------+                     |
|  | Grafana  | --> | Prometheus |                     |
|  | UP       |     | UP         |                     |
|  +----------+     +------------+                     |
|                         |                            |
|                 +-------+--------+                   |
|                 |                |                   |
|                 v                v                   |
|          +-------------+  +-------------+            |
|          | Servidor web|  | Base datos  |            |
|          | UP          |  | UP          |            |
|          | CPU: 42 %   |  | CPU: 31 %   |            |
|          | MEM: 55 %   |  | MEM: 68 %   |            |
|          +-------------+  +-------------+            |
|                                                      |
+------------------------------------------------------+
```

## Elementos obligatorios

Añadir:

- Título.
- Fondo o contenedores.
- Cuatro tarjetas.
- Estado de cada componente.
- Al menos una métrica de CPU.
- Al menos una métrica de memoria.
- Conexiones entre componentes.
- Leyenda de colores.
- Enlace a otro dashboard.
- Descripción del entorno.

## Consultas mínimas

### Prometheus

```promql
up{job="prometheus"}
```

### Node Exporter

```promql
up{job="node_exporter"}
```

### CPU

```promql
100 - (
  avg(
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

## Tareas

1. Crear el panel Canvas.
2. Crear la estructura visual.
3. Añadir los componentes.
4. Añadir conexiones.
5. Añadir estados.
6. Añadir valores de CPU y memoria.
7. Configurar colores.
8. Añadir una leyenda.
9. Añadir un enlace.
10. Detener Node Exporter.
11. Comprobar el cambio de estado.
12. Volver a iniciar Node Exporter.
13. Comprobar la recuperación.
14. Exportar el dashboard.
15. Importar una copia.
16. Revisar el resultado.
17. Completar el informe.

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Canvas creado | | |
| Título añadido | | |
| Componentes representados | | |
| Conexiones añadidas | | |
| Valores dinámicos configurados | | |
| Estado de Prometheus configurado | | |
| Estado de Node Exporter configurado | | |
| CPU configurada | | |
| Memoria configurada | | |
| Colores configurados | | |
| Leyenda añadida | | |
| Enlace añadido | | |
| Prueba de estado `DOWN` realizada | | |
| Recuperación comprobada | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Canvas permite crear composiciones visuales personalizadas.
- Puede combinar texto, formas, imágenes, iconos y valores dinámicos.
- Es adecuado para mapas operativos y diagramas de infraestructura.
- Los elementos estáticos proporcionan estructura.
- Los elementos dinámicos muestran datos de Grafana.
- El diseño debe planificarse antes de colocar elementos.
- Los colores deben tener un significado coherente.
- Las formas pueden utilizarse como tarjetas o contenedores.
- Las imágenes pueden actuar como fondos o planos.
- Las conexiones ayudan a representar relaciones y flujos.
- Los valores dinámicos proceden de consultas.
- Las consultas deben devolver datos adecuados para el elemento utilizado.
- Las unidades deben coincidir con los resultados.
- Canvas no sustituye a los paneles de series temporales o análisis detallado.
- Los enlaces permiten navegar hacia dashboards relacionados.
- El orden de las capas es importante.
- Los elementos deben mantenerse alineados y legibles.
- Las imágenes y los enlaces deben revisarse desde el punto de vista de la seguridad.
- El panel debe probarse con estados normales, caídos y sin datos.
- Un Canvas demasiado recargado pierde su utilidad.
- La documentación del diseño facilita su mantenimiento.

---

# Preguntas de comprobación

1. ¿Qué finalidad tiene un panel Canvas?
2. ¿Qué diferencia existe entre Canvas y un panel Text?
3. ¿Qué diferencia existe entre Canvas y Node Graph?
4. ¿Qué tipos de elementos pueden formar parte de un Canvas?
5. ¿Qué diferencia existe entre un elemento estático y uno dinámico?
6. ¿Qué información puede mostrar un elemento dinámico?
7. ¿Qué consulta utilizarías para comprobar el estado de Node Exporter?
8. ¿Qué consulta utilizarías para obtener el porcentaje de CPU?
9. ¿Cómo representarías `1` y `0` como `UP` y `DOWN`?
10. ¿Qué función cumplen las formas?
11. ¿Qué utilidad tienen las conexiones?
12. ¿Qué precauciones deben tomarse al utilizar una imagen de fondo?
13. ¿Qué información no debe incluirse en un Canvas?
14. ¿Por qué es importante controlar el orden de las capas?
15. ¿Qué problemas puede provocar un diseño con demasiados elementos?
16. ¿Qué revisarías si un valor dinámico no aparece?
17. ¿Qué revisarías si un elemento queda oculto?
18. ¿Qué revisarías si una imagen no se muestra?
19. ¿Cómo añadirías un enlace a otro dashboard?
20. ¿Qué probarías después de detener Node Exporter?
21. ¿Por qué deben documentarse los colores?
22. ¿Qué unidades utilizarías para CPU y memoria?
23. ¿Qué evidencias guardarías durante la práctica?
24. ¿Cómo comprobarías que un Canvas exportado se ha restaurado correctamente?
25. ¿Qué características debe tener un buen panel Canvas?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de crear una vista Canvas que combine diseño visual y datos de monitorización.

El proceso completo será:

```text
Definir el objetivo visual
        |
        v
Planificar los componentes
        |
        v
Crear el fondo y las zonas
        |
        v
Añadir formas, textos e iconos
        |
        v
Añadir conexiones
        |
        v
Incorporar valores dinámicos
        |
        v
Configurar unidades y colores
        |
        v
Añadir enlaces
        |
        v
Probar estados normales y anómalos
        |
        v
Guardar, exportar y documentar
```

El resultado final debe ser un panel Canvas claro, legible y útil para comprender rápidamente la estructura y el estado de una infraestructura monitorizada.

Canvas debe funcionar como una **vista operativa de alto nivel**. Los detalles deben mantenerse en paneles especializados de Stat, Gauge, Bar Gauge, Time series, Heatmap y Table.