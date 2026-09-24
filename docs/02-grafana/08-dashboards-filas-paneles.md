# Dashboards, filas y paneles

## Objetivos

Al finalizar esta sección podrás:

- Comprender la relación entre dashboards, filas y paneles.
- Crear un dashboard en Grafana.
- Organizar un dashboard mediante filas.
- Añadir, configurar y duplicar paneles.
- Seleccionar una fuente de datos para cada panel.
- Crear visualizaciones utilizando consultas PromQL.
- Configurar títulos, descripciones, unidades y umbrales.
- Aplicar variables para crear dashboards reutilizables.
- Compartir y exportar dashboards.
- Aplicar buenas prácticas de diseño y organización.

## Introducción

Un dashboard de Grafana es una vista organizada que permite representar y analizar información procedente de una o varias fuentes de datos.

Un dashboard puede contener:

- Filas.
- Paneles.
- Consultas.
- Variables.
- Enlaces.
- Anotaciones.
- Configuración temporal.
- Reglas de visualización.
- Permisos de acceso.

La estructura básica es:

```text
Dashboard
├── Fila
│   ├── Panel
│   ├── Panel
│   └── Panel
├── Fila
│   ├── Panel
│   └── Panel
└── Fila
    └── Panel
```

Cada elemento cumple una función diferente:

| Elemento | Función |
|---|---|
| Dashboard | Contenedor principal de una vista de monitorización |
| Fila | Agrupa paneles relacionados |
| Panel | Muestra una métrica, tabla, gráfico o estado |
| Consulta | Solicita datos a una fuente |
| Variable | Permite cambiar filtros dinámicamente |
| Umbral | Define estados visuales según el valor |

Un dashboard bien diseñado debe ayudar a responder rápidamente preguntas como:

- ¿Está disponible el servicio?
- ¿Existe algún problema ahora?
- ¿Cuándo comenzó el problema?
- ¿Qué recursos están saturados?
- ¿Qué servidores o aplicaciones están afectados?
- ¿La situación está mejorando o empeorando?

Un dashboard no debe convertirse en una colección interminable de gráficos. Más paneles no significa necesariamente más información; a veces solo significa más scroll y una pequeña expedición arqueológica.

## Contenido

### Crear un dashboard

Para crear un dashboard:

1. Accede a Grafana.
2. Abre el menú de dashboards.
3. Selecciona la opción para crear un dashboard nuevo.
4. Añade un panel.
5. Selecciona una fuente de datos.
6. Introduce una consulta.
7. Configura la visualización.
8. Guarda el dashboard.

Al guardar el dashboard, Grafana solicitará información como:

```text
Título del dashboard
Carpeta
Descripción
Identificador o URL
```

Utiliza nombres descriptivos.

Ejemplos:

```text
Infraestructura Linux
Monitorización de Prometheus
Estado de la API
Rendimiento de bases de datos
Producción - Servicios críticos
```

Evita nombres poco informativos como:

```text
Dashboard 1
Pruebas
Nuevo
Test final
```

### Estructura de un dashboard

Una estructura habitual para un dashboard de infraestructura es:

```text
Infraestructura Linux
├── Resumen
│   ├── Objetivos disponibles
│   ├── Alertas activas
│   └── Servidores monitorizados
├── CPU y carga
│   ├── Uso de CPU
│   ├── Carga del sistema
│   └── Procesos
├── Memoria
│   ├── Memoria disponible
│   ├── Uso de memoria
│   └── Swap
├── Almacenamiento
│   ├── Espacio utilizado
│   ├── Inodos
│   └── Latencia de disco
└── Red
    ├── Tráfico recibido
    ├── Tráfico transmitido
    └── Errores de red
```

Esta estructura separa la información según la función que cumple.

### Crear una fila

Las filas permiten agrupar paneles relacionados dentro de un dashboard.

Ejemplos de nombres de filas:

```text
Resumen
CPU y carga
Memoria
Almacenamiento
Red
Aplicaciones
Bases de datos
Alertas
```

Para crear una fila:

1. Abre el dashboard.
2. Accede al modo de edición.
3. Selecciona la opción para añadir una fila.
4. Introduce un nombre descriptivo.
5. Guarda los cambios.

Una fila puede contener varios paneles relacionados.

Ejemplo:

```text
Fila: Memoria
├── Memoria disponible
├── Porcentaje utilizado
└── Uso de swap
```

Las filas ayudan a organizar visualmente el dashboard y facilitan la navegación.

### Utilizar filas colapsables

Una fila puede mostrarse expandida o colapsada.

Una fila colapsada:

- Ocupa menos espacio.
- Permite ocultar detalles secundarios.
- Facilita la navegación.
- Puede utilizarse para información de diagnóstico.

Una fila de resumen debería permanecer visible:

```text
Resumen
├── Disponibilidad
├── Alertas
└── Estado general
```

Las filas de detalle pueden permanecer colapsadas:

```text
Diagnóstico avanzado
├── Métricas internas
├── Consultas detalladas
└── Información de depuración
```

No ocultes información crítica dentro de una fila colapsada.

### Añadir un panel

Un panel es la unidad principal de visualización de Grafana.

Para añadir un panel:

1. Abre el dashboard.
2. Selecciona la opción para añadir un panel.
3. Elige una fuente de datos.
4. Introduce una consulta.
5. Selecciona la visualización.
6. Configura las opciones.
7. Guarda el panel.

Cada panel debería tener:

- Título descriptivo.
- Fuente de datos definida.
- Consulta documentada.
- Unidad adecuada.
- Intervalo temporal coherente.
- Umbrales cuando sean necesarios.
- Descripción funcional.

### Componentes de un panel

Un panel puede contener los siguientes elementos:

```text
Panel
├── Título
├── Descripción
├── Fuente de datos
├── Consulta
├── Transformaciones
├── Visualización
├── Opciones de campo
├── Umbrales
├── Enlaces
└── Configuración temporal
```

La configuración exacta depende del tipo de panel y de la versión de Grafana.

### Tipos de panel habituales

Grafana dispone de diferentes tipos de visualización.

| Tipo de panel | Uso habitual |
|---|---|
| Time series | Evolución de una métrica en el tiempo |
| Stat | Mostrar un valor principal |
| Gauge | Representar un valor dentro de un rango |
| Bar gauge | Comparar varios valores |
| Table | Mostrar datos tabulares |
| Heatmap | Analizar distribuciones |
| Pie chart | Representar proporciones |
| Text | Añadir documentación o contexto |
| Logs | Mostrar registros de eventos |
| State timeline | Visualizar estados a lo largo del tiempo |
| Status history | Mostrar cambios de estado |

La visualización debe elegirse según la pregunta que se desea responder.

### Panel Time series

El panel `Time series` representa la evolución de una o varias series a lo largo del tiempo.

Es adecuado para:

- Uso de CPU.
- Memoria.
- Latencia.
- Tráfico de red.
- Solicitudes por segundo.
- Errores.
- Temperatura.
- Número de usuarios.

Ejemplo de consulta:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

Esta consulta representa el porcentaje de uso de CPU por instancia.

Configuraciones recomendadas:

```text
Título: Uso de CPU por servidor
Unidad: Porcentaje (0-100)
Visualización: Time series
Leyenda: visible
```

### Panel Stat

El panel `Stat` muestra un valor principal.

Es adecuado para:

- Número de servidores disponibles.
- Estado de un servicio.
- Memoria disponible.
- Total de alertas.
- Solicitudes actuales.
- Porcentaje de disponibilidad.

Ejemplo:

```promql
sum(up)
```

Este valor puede representar el número de objetivos disponibles, según la configuración de Prometheus.

Configuración posible:

```text
Título: Objetivos disponibles
Unidad: Ninguna
Visualización: Stat
Color: Según umbrales
```

### Panel Gauge

El panel `Gauge` representa un valor dentro de un intervalo.

Es adecuado para:

- Uso de CPU.
- Porcentaje de memoria.
- Capacidad de almacenamiento.
- Uso de conexiones.
- Saturación de recursos.

Ejemplo:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configuración posible:

```text
Título: Uso de memoria
Unidad: Porcentaje (0-100)
Mínimo: 0
Máximo: 100
```

Un gauge debe utilizar límites comprensibles. Un valor sin contexto puede ser difícil de interpretar.

### Panel Table

El panel `Table` muestra resultados en forma de tabla.

Es útil para:

- Listar servidores.
- Mostrar estados.
- Comparar valores.
- Consultar etiquetas.
- Representar resultados detallados.
- Revisar errores por servicio.

Ejemplo:

```promql
up
```

La tabla puede configurarse para mostrar columnas como:

```text
instance
job
value
```

Las transformaciones permiten reorganizar o renombrar los campos recibidos.

### Panel Text

El panel `Text` permite añadir contenido explicativo.

Puede utilizarse para:

- Documentar el dashboard.
- Indicar el responsable.
- Explicar los umbrales.
- Añadir enlaces.
- Mostrar instrucciones operativas.
- Incluir información del entorno.

Ejemplo de contenido:

```markdown
## Dashboard de infraestructura

Este dashboard muestra el estado de los servidores Linux monitorizados
mediante Prometheus y Node Exporter.

- Rango recomendado: últimas 6 horas.
- Actualización: cada 1 minuto.
- Responsable: equipo de operaciones.
- Zona horaria: Europe/Madrid.
```

Este tipo de panel aporta contexto, especialmente cuando el dashboard es utilizado por varios equipos.

### Panel Logs

El panel `Logs` se utiliza para visualizar registros, normalmente desde una fuente compatible como Loki.

Puede ayudar a analizar:

- Errores de aplicaciones.
- Fallos de autenticación.
- Reinicios de servicios.
- Eventos de seguridad.
- Mensajes del sistema.

Las métricas y los logs cumplen funciones diferentes:

```text
Métricas:
¿Qué está ocurriendo?

Logs:
¿Qué mensajes explican lo que está ocurriendo?
```

Una buena estrategia de observabilidad combina ambos tipos de información.

### Elegir una fuente de datos

Cada panel debe utilizar una fuente de datos.

Ejemplos:

```text
Prometheus
Loki
InfluxDB
PostgreSQL
MySQL
Elasticsearch
Tempo
```

Al crear un panel:

1. Selecciona la fuente de datos.
2. Introduce la consulta.
3. Comprueba que devuelve resultados.
4. Selecciona la visualización.
5. Configura los campos.

Si el panel no muestra datos, comprueba:

- Fuente seleccionada.
- URL de la fuente.
- Consulta.
- Etiquetas.
- Rango temporal.
- Retención.
- Permisos.
- Conectividad.

### Crear una consulta PromQL

Prometheus utiliza PromQL para consultar métricas.

Consulta básica:

```promql
up
```

Uso de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

Memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Porcentaje de memoria utilizada:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Espacio disponible:

```promql
node_filesystem_avail_bytes{
  fstype!~"tmpfs|overlay"
}
```

Carga media:

```promql
node_load1
```

La consulta debe adaptarse a las métricas y etiquetas disponibles en el entorno.

### Configurar el título

Un título debe explicar claramente qué representa el panel.

Ejemplos adecuados:

```text
Uso de CPU por servidor
Memoria disponible
Espacio utilizado por filesystem
Solicitudes HTTP por segundo
Latencia p95 de la API
Objetivos no disponibles
```

Ejemplos poco adecuados:

```text
Panel 1
CPU
Datos
Gráfico nuevo
```

Cuando un panel utiliza filtros o un intervalo particular, el título puede incluirlos:

```text
Errores HTTP - últimas 6 horas
Uso de CPU - servidores de producción
Latencia p95 - API pública
```

### Añadir una descripción

La descripción permite explicar:

- Qué representa el panel.
- Qué fuente utiliza.
- Qué significan los colores.
- Qué unidades se muestran.
- Qué hacer cuando aparece un valor anómalo.

Ejemplo:

```text
Porcentaje de CPU utilizado por instancia. El cálculo excluye el tiempo
en modo idle y utiliza una ventana de 5 minutos.

Verde: funcionamiento normal.
Amarillo: revisar si supera el 70 %.
Rojo: investigar si supera el 90 %.
```

Una descripción breve puede ahorrar muchas preguntas durante un incidente.

### Configurar unidades

Las unidades deben corresponder al tipo de dato.

Ejemplos:

| Dato | Unidad recomendada |
|---|---|
| CPU | Percent (0-100) |
| Memoria | Bytes o percent |
| Latencia | Milliseconds |
| Tráfico | Bytes/sec |
| Solicitudes | Requests/sec |
| Temperatura | Celsius |
| Tiempo | Seconds |
| Espacio | Bytes |

Una unidad incorrecta puede hacer que un valor parezca normal o alarmante cuando no lo es.

Por ejemplo:

```text
0.5
```

puede significar:

- 0.5 segundos.
- 0.5 bytes.
- 0.5 por ciento.
- 0.5 solicitudes por segundo.

La unidad proporciona el contexto necesario.

### Configurar decimales

La cantidad de decimales debe ser suficiente para interpretar el valor, pero no excesiva.

Ejemplos:

```text
CPU: 72.4 %
Latencia: 125 ms
Disponibilidad: 99.98 %
Temperatura: 41.2 °C
```

Mostrar demasiados decimales genera ruido:

```text
72.437829104 %
```

Mostrar muy pocos puede ocultar variaciones importantes.

### Configurar umbrales

Los umbrales permiten cambiar el estado visual de un valor.

Ejemplo para uso de CPU:

```text
0-70 %: verde
70-90 %: amarillo
90-100 %: rojo
```

Ejemplo para disponibilidad:

```text
1: verde
0: rojo
```

Ejemplo para latencia:

```text
0-200 ms: verde
200-500 ms: amarillo
Más de 500 ms: rojo
```

Los umbrales deben basarse en:

- Capacidad del sistema.
- Nivel de servicio.
- Comportamiento normal.
- Requisitos de la aplicación.
- Experiencia histórica.
- Impacto para los usuarios.

No utilices valores arbitrarios sin conocer el comportamiento normal del servicio.

### Colores y estados

Los colores deben tener un significado coherente en todo el dashboard.

Una convención habitual es:

```text
Verde: normal
Amarillo: advertencia
Rojo: crítico
Gris: desconocido o sin datos
Azul: información
```

Utiliza los mismos significados en todos los paneles.

No emplees el rojo simplemente para destacar un panel importante. El rojo debería indicar una situación que requiera atención.

### Configurar la leyenda

La leyenda identifica las series mostradas.

Puede incluir:

- Nombre de la métrica.
- Instancia.
- Servicio.
- Entorno.
- Región.
- Código de respuesta.

Ejemplo:

```text
instance
job
service
environment
```

Una leyenda demasiado larga dificulta la lectura.

Cuando existan muchas series:

- Utiliza alias.
- Reduce las etiquetas mostradas.
- Agrupa series.
- Utiliza variables.
- Considera un panel de tabla.
- Divide la información por filas.

### Organizar el tamaño de los paneles

Los paneles pueden cambiar de tamaño y posición dentro de la fila.

Criterios prácticos:

- Paneles principales: mayor tamaño.
- Valores únicos: paneles pequeños o medianos.
- Gráficos temporales: mayor anchura.
- Tablas: anchura suficiente para leer las columnas.
- Texto: tamaño ajustado al contenido.
- Detalles secundarios: paneles más pequeños.

Ejemplo de distribución:

```text
Fila: Resumen

┌─────────────────────┬─────────────────────┬─────────────────────┐
│ Objetivos activos   │ Alertas activas     │ Disponibilidad      │
├─────────────────────┴─────────────────────┴─────────────────────┤
│                 Uso de CPU por servidor                         │
└─────────────────────────────────────────────────────────────────┘
```

La primera fila debe mostrar la información más importante.

### Ordenar los paneles

Ordena los paneles siguiendo el flujo de análisis:

1. Estado general.
2. Impacto.
3. Recursos.
4. Componentes afectados.
5. Detalle técnico.
6. Diagnóstico.
7. Enlaces y documentación.

Ejemplo:

```text
Resumen
├── Estado general
├── Alertas
└── Disponibilidad

Recursos
├── CPU
├── Memoria
├── Disco
└── Red

Detalle
├── Procesos
├── Filesystems
└── Errores
```

Este orden permite pasar rápidamente de una visión general a un diagnóstico detallado.

### Duplicar un panel

Duplicar un panel puede ahorrar tiempo cuando se necesita una visualización similar.

Procedimiento general:

1. Abre el menú del panel.
2. Selecciona la opción para duplicar o copiar.
3. Cambia el título.
4. Modifica la consulta.
5. Revisa las unidades.
6. Revisa los umbrales.
7. Guarda los cambios.

Después de duplicar, comprueba todos los elementos. Es fácil conservar accidentalmente:

- Títulos incorrectos.
- Unidades antiguas.
- Descripciones que ya no corresponden.
- Filtros equivocados.
- Umbrales inadecuados.

### Copiar paneles entre dashboards

Los paneles pueden copiarse entre dashboards cuando se desea reutilizar una visualización.

Es conveniente revisar:

- Fuente de datos.
- Variables.
- Carpetas.
- Permisos.
- Consultas.
- Enlaces.
- Rangos temporales.
- Configuración específica del dashboard.

Un panel que funciona en un dashboard puede no funcionar igual en otro si utiliza variables o fuentes diferentes.

### Variables de dashboard

Las variables permiten modificar filtros sin crear un dashboard distinto para cada servidor o servicio.

Ejemplos de variables:

```text
instance
job
environment
region
namespace
service
```

Un dashboard puede utilizar una variable llamada:

```text
instance
```

y permitir seleccionar:

```text
Todos
server-01:9100
server-02:9100
server-03:9100
```

Una consulta con variable podría ser:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

El operador `=~` permite utilizar una selección múltiple o una expresión regular.

### Variables por entorno

Una variable de entorno puede tener valores como:

```text
laboratorio
desarrollo
producción
```

Una consulta puede filtrar el entorno:

```promql
up{environment=~"$environment"}
```

Esto permite utilizar un mismo dashboard en varios entornos.

Una estructura habitual es:

```text
Dashboard:
Infraestructura

Variables:
- environment
- region
- instance
```

### Variables con selección múltiple

Una variable puede permitir seleccionar varios valores.

Por ejemplo:

```text
server-01
server-02
server-03
```

La consulta debe utilizar una expresión compatible:

```promql
up{instance=~"$instance"}
```

No utilices igualdad simple si la variable puede contener varios valores:

```promql
up{instance="$instance"}
```

En ese caso, la consulta puede no devolver los resultados esperados.

### Opción Todos

Una variable puede incluir una opción que represente todos los valores.

Ejemplo:

```text
Todos
server-01
server-02
server-03
```

La opción `Todos` permite ver todas las series sin crear un panel diferente.

Utiliza esta función con cuidado cuando existan muchas series. Mostrar demasiados elementos puede:

- Sobrecargar el panel.
- Reducir la legibilidad.
- Aumentar el coste de la consulta.
- Hacer más difícil detectar problemas.

### Enlaces entre dashboards

Los enlaces permiten navegar desde un dashboard hacia:

- Otro dashboard.
- Una vista filtrada.
- Un sistema de incidencias.
- La documentación.
- Un repositorio.
- Una aplicación externa.

Ejemplos:

```text
Ver dashboard de detalle
Abrir documentación del servicio
Consultar incidencias
Abrir consola de Prometheus
```

Un enlace útil debe incluir el contexto necesario, como:

```text
instance
service
environment
time range
```

De esta forma, el operador no tiene que reconstruir manualmente la información.

### Enlaces de datos

Algunos paneles permiten definir enlaces asociados a valores o series concretas.

Ejemplo:

```text
Servidor: server-01
Enlace:
https://inventario.example.com/hosts/server-01
```

Otro ejemplo:

```text
Servicio:
https://incidencias.example.com/search?service=api
```

Los enlaces deben probarse periódicamente. Un dashboard con enlaces rotos pierde parte de su utilidad operativa.

### Anotaciones

Las anotaciones permiten marcar eventos importantes en una línea temporal.

Ejemplos:

- Despliegue.
- Reinicio.
- Cambio de configuración.
- Incidente.
- Mantenimiento.
- Escalado.
- Cambio de versión.

Una visualización puede mostrar una línea temporal con los eventos:

```text
10:00  Despliegue versión 2.4
10:15  Aumento de errores
10:20  Rollback
10:30  Recuperación
```

Las anotaciones ayudan a relacionar cambios con variaciones en las métricas.

### Guardar un dashboard

Después de crear o modificar un dashboard:

1. Guarda los cambios.
2. Introduce un comentario si la plataforma lo solicita.
3. Comprueba la carpeta.
4. Revisa el título.
5. Verifica que los paneles cargan correctamente.
6. Comprueba el rango temporal.
7. Actualiza la página.
8. Confirma que los cambios se mantienen.

Guardar el dashboard no sustituye a una copia de seguridad o a un sistema de control de versiones.

### Exportar un dashboard

La exportación permite generar una representación JSON del dashboard.

Puede utilizarse para:

- Realizar copias de seguridad.
- Migrar dashboards.
- Compartir configuraciones.
- Revisar cambios.
- Guardar dashboards en un repositorio.

Antes de compartir un fichero exportado, revisa si contiene:

- URLs internas.
- Nombres de servidores.
- Identificadores sensibles.
- Credenciales.
- Tokens.
- Información de infraestructura.
- Variables privadas.

Los dashboards exportados deben tratarse como ficheros de configuración, no como información pública por defecto.

### Importar un dashboard

Para importar un dashboard:

1. Accede al área de dashboards.
2. Selecciona la opción de importar.
3. Carga el fichero JSON o introduce el identificador correspondiente.
4. Selecciona la fuente de datos.
5. Revisa las variables.
6. Comprueba las consultas.
7. Guarda el dashboard.

Después de importar, valida:

```text
[ ] Las fuentes de datos son correctas.
[ ] Las variables funcionan.
[ ] Los paneles muestran datos.
[ ] Las unidades son adecuadas.
[ ] Los títulos son correctos.
[ ] Los enlaces funcionan.
[ ] El rango temporal es apropiado.
```

### Permisos de dashboards y carpetas

Los permisos pueden asignarse a:

- Usuarios.
- Equipos.
- Roles.
- Carpetas.
- Dashboards.

Ejemplo:

```text
Carpeta: Producción
├── Equipo Operaciones: Editor
├── Equipo Desarrollo: Viewer
└── Equipo Auditoría: Viewer
```

Utiliza el principio de mínimo privilegio:

- `Viewer` para consulta.
- `Editor` para mantenimiento.
- `Admin` para administración limitada.
- Administrador global solo cuando sea necesario.

Revisa periódicamente los permisos, especialmente después de cambios organizativos.

### Buenas prácticas de diseño

Para crear dashboards útiles:

- Coloca el resumen en la parte superior.
- Organiza los paneles mediante filas.
- Utiliza títulos descriptivos.
- Configura unidades correctas.
- Mantén una escala coherente.
- Usa colores con significado constante.
- Evita sobrecargar un único dashboard.
- Añade descripciones.
- Documenta las consultas complejas.
- Utiliza variables para reutilizar dashboards.
- Mantén los paneles relevantes.
- Revisa periódicamente el rendimiento.
- Elimina paneles obsoletos.
- Utiliza enlaces hacia el detalle.
- Prueba el dashboard con sus usuarios reales.

### Evitar dashboards excesivamente grandes

Un dashboard con demasiados paneles puede provocar:

- Carga lenta.
- Consultas costosas.
- Dificultad para localizar información.
- Exceso de desplazamiento.
- Problemas de legibilidad.
- Mayor mantenimiento.

Divide la información cuando sea necesario:

```text
Dashboard de resumen
Dashboard de infraestructura
Dashboard de aplicaciones
Dashboard de bases de datos
Dashboard de diagnóstico
```

Un dashboard debe responder a una finalidad concreta.

### Rendimiento de los dashboards

El rendimiento depende de:

- Número de paneles.
- Número de consultas.
- Complejidad de las consultas.
- Rango temporal.
- Resolución.
- Número de series.
- Frecuencia de actualización.
- Capacidad de la fuente de datos.
- Número de usuarios simultáneos.

Para mejorar el rendimiento:

- Reduce el número de paneles.
- Utiliza rangos temporales razonables.
- Evita consultas sin filtros.
- Limita el número de series.
- Establece un intervalo mínimo.
- Reduce la frecuencia de actualización.
- Agrupa paneles relacionados.
- Utiliza métricas precomputadas cuando corresponda.
- Revisa las consultas lentas.
- Evita mostrar todos los recursos por defecto si son muchos.

## Ejemplo

### Crear un dashboard de infraestructura

Objetivo:

```text
Mostrar el estado básico de servidores Linux monitorizados con Prometheus.
```

Estructura:

```text
Infraestructura Linux
├── Resumen
│   ├── Objetivos disponibles
│   └── Alertas activas
├── CPU y carga
│   ├── Uso de CPU
│   └── Carga del sistema
├── Memoria
│   ├── Memoria disponible
│   └── Porcentaje de memoria utilizada
└── Almacenamiento
    └── Espacio disponible
```

### Crear la fila Resumen

Crea una fila denominada:

```text
Resumen
```

Añade un panel `Stat` con la consulta:

```promql
sum(up)
```

Configura:

```text
Título: Objetivos disponibles
Unidad: Ninguna
```

Añade otro panel para mostrar los objetivos no disponibles:

```promql
count(up == 0)
```

Configura:

```text
Título: Objetivos no disponibles
Unidad: Ninguna
```

Añade umbrales:

```text
0: verde
1 o más: rojo
```

### Crear la fila CPU y carga

Crea una fila denominada:

```text
CPU y carga
```

Añade un panel `Time series`:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle"
    }[5m])
  ) * 100
)
```

Configura:

```text
Título: Uso de CPU por servidor
Unidad: Percent (0-100)
Visualización: Time series
```

Añade un panel para la carga media:

```promql
node_load1
```

Configura:

```text
Título: Carga del sistema
Unidad: Short
Visualización: Time series
```

La interpretación de la carga depende del número de CPUs. Una carga de `2` puede ser normal en un servidor con muchos procesadores y elevada en uno con un solo procesador.

### Crear la fila Memoria

Crea una fila denominada:

```text
Memoria
```

Añade un panel `Gauge`:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Configura:

```text
Título: Uso de memoria
Unidad: Percent (0-100)
Mínimo: 0
Máximo: 100
```

Define umbrales orientativos:

```text
0-70: verde
70-90: amarillo
90-100: rojo
```

Añade un panel `Time series` para la memoria disponible:

```promql
node_memory_MemAvailable_bytes
```

Configura:

```text
Título: Memoria disponible
Unidad: Bytes
Visualización: Time series
```

### Crear la fila Almacenamiento

Crea una fila denominada:

```text
Almacenamiento
```

Añade un panel `Time series`:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay"
  }
)
```

Configura:

```text
Título: Uso de filesystem
Unidad: Percent (0-100)
Visualización: Time series
```

Para excluir determinados puntos de montaje, pueden añadirse filtros adicionales según las etiquetas disponibles:

```promql
node_filesystem_avail_bytes{
  fstype!~"tmpfs|overlay",
  mountpoint!~"/run|/sys|/proc"
}
```

Los nombres exactos de las etiquetas dependen de la configuración de Node Exporter.

### Añadir una variable de servidor

Crea una variable llamada:

```text
instance
```

Configúrala para obtener valores de la etiqueta `instance`.

Una consulta posible para la variable es:

```promql
label_values(up, instance)
```

En versiones o configuraciones donde esta función no esté disponible directamente en el editor de variables, utiliza el mecanismo de consulta de variables proporcionado por la interfaz de Grafana.

Permite selección múltiple y añade una opción para seleccionar todos los valores.

Modifica la consulta de CPU:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{
      mode="idle",
      instance=~"$instance"
    }[5m])
  ) * 100
)
```

Ahora el usuario puede seleccionar:

```text
Todos
server-01:9100
server-02:9100
server-03:9100
```

### Añadir una descripción al dashboard

Añade un panel de texto con:

```markdown
## Infraestructura Linux

Dashboard para supervisar servidores Linux mediante Prometheus y Node Exporter.

### Convenciones

- Verde: funcionamiento normal.
- Amarillo: valor que requiere revisión.
- Rojo: situación crítica.
- Gris: sin datos o estado desconocido.

### Configuración

- Rango recomendado: últimas 6 horas.
- Actualización: cada 1 minuto.
- Fuente: Prometheus.
- Zona horaria: la configurada por el usuario.
```

Esta información permite que otros usuarios comprendan el dashboard sin consultar documentación externa.

### Guardar y validar

Antes de finalizar, comprueba:

```text
[ ] El dashboard tiene un nombre descriptivo.
[ ] Está almacenado en la carpeta correcta.
[ ] Todos los paneles utilizan la fuente adecuada.
[ ] Las consultas devuelven datos.
[ ] Las unidades son correctas.
[ ] Los títulos son claros.
[ ] Los umbrales están documentados.
[ ] Las variables funcionan.
[ ] El rango temporal es apropiado.
[ ] Los paneles están ordenados.
[ ] Los permisos son correctos.
[ ] Se ha realizado una exportación o copia de seguridad.
```

## Puntos clave

- Un dashboard es un contenedor de paneles, filas, consultas y configuración.
- Las filas agrupan paneles relacionados.
- Los paneles representan métricas, estados, logs o información adicional.
- El tipo de visualización debe corresponder a la pregunta que se desea responder.
- `Time series` es adecuado para analizar la evolución temporal.
- `Stat` es adecuado para mostrar un valor principal.
- `Gauge` representa un valor dentro de un intervalo.
- `Table` facilita la consulta detallada de múltiples valores.
- Los títulos deben describir claramente el contenido del panel.
- Las unidades deben corresponder al tipo de dato.
- Los umbrales deben tener un significado operativo.
- Los colores deben utilizarse de forma coherente.
- Las variables permiten reutilizar un dashboard con diferentes filtros.
- Las consultas con variables múltiples suelen utilizar el operador `=~`.
- Las anotaciones ayudan a relacionar cambios con variaciones en las métricas.
- Los enlaces facilitan la navegación hacia otros dashboards o sistemas.
- Los permisos deben aplicar el principio de mínimo privilegio.
- Los dashboards excesivamente grandes pueden ser difíciles de leer y mantener.
- El número de paneles, consultas y series influye en el rendimiento.
- Los dashboards deben tener una finalidad clara.
- Las descripciones ayudan a interpretar los paneles durante un incidente.
- Los dashboards deben revisarse, exportarse y mantenerse periódicamente.

## Preguntas de comprobación

1. ¿Qué diferencia existe entre un dashboard, una fila y un panel?
2. ¿Para qué se utilizan las filas?
3. ¿Qué tipo de panel utilizarías para representar la evolución de la CPU?
4. ¿Qué tipo de panel utilizarías para mostrar el número de objetivos disponibles?
5. ¿Cuándo es apropiado utilizar un panel de tipo `Gauge`?
6. ¿Qué información debería incluir el título de un panel?
7. ¿Por qué es importante configurar correctamente las unidades?
8. ¿Qué función cumplen los umbrales?
9. ¿Qué significado deberían tener los colores verde, amarillo y rojo?
10. ¿Qué ventajas ofrecen las variables de dashboard?
11. ¿Qué operador PromQL suele utilizarse con variables de selección múltiple?
12. ¿Para qué sirven las anotaciones?
13. ¿Qué información puede incluir una descripción de panel?
14. ¿Qué factores influyen en el rendimiento de un dashboard?
15. ¿Por qué puede ser problemático utilizar demasiados paneles?
16. ¿Qué permisos asignarías a un usuario que solo necesita consultar dashboards?
17. ¿Qué comprobarías después de importar un dashboard?
18. ¿Qué elementos revisarías antes de duplicar un panel?
19. ¿Cómo organizarías un dashboard de infraestructura Linux?
20. ¿Qué pasos seguirías para validar un dashboard antes de ponerlo a disposición de otros usuarios?