# Objetivos del curso

Este curso presenta un recorrido práctico por los fundamentos de la observabilidad y la monitorización utilizando **Grafana**, **Prometheus** y **Node Exporter** sobre Ubuntu.

El objetivo no es únicamente aprender a instalar herramientas. También se pretende comprender cómo se recopilan, almacenan, consultan y visualizan las métricas de un sistema.

---

## Objetivos

Al finalizar el curso, el alumno podrá:

- Comprender los conceptos fundamentales de telemetría y observabilidad.
- Diferenciar métricas, logs, trazas y eventos.
- Explicar las diferencias entre los modelos de recopilación *push* y *pull*.
- Identificar los componentes principales de una plataforma de monitorización.
- Instalar y configurar Grafana en Ubuntu.
- Instalar y configurar Prometheus.
- Instalar Node Exporter para recopilar métricas del sistema.
- Comprobar el estado de los servicios mediante `systemctl`.
- Consultar endpoints HTTP de métricas.
- Utilizar consultas básicas de PromQL.
- Añadir Prometheus como fuente de datos en Grafana.
- Crear dashboards con diferentes tipos de paneles.
- Utilizar paneles de series temporales, estadísticas y medidores.
- Configurar rangos de tiempo y desplazamientos temporales.
- Aplicar transformaciones sobre los datos.
- Crear alertas basadas en métricas.
- Diagnosticar problemas habituales de instalación, conectividad y consultas.
- Diseñar un dashboard operativo básico para supervisar un servidor Linux.

---

## Introducción

La monitorización permite conocer el estado de un sistema y detectar cambios antes de que se conviertan en problemas graves.

Un sistema puede funcionar correctamente durante una gran parte del tiempo y, aun así, presentar señales de degradación:

- El uso de CPU puede aumentar progresivamente.
- La memoria disponible puede disminuir.
- El almacenamiento puede acercarse a su límite.
- Un servicio puede dejar de responder.
- La latencia de una aplicación puede incrementarse.
- El número de errores puede crecer después de un despliegue.

La observabilidad ayuda a responder preguntas como:

- ¿Qué está ocurriendo en el sistema?
- ¿Desde cuándo ocurre?
- ¿Qué componentes están afectados?
- ¿El problema es puntual o recurrente?
- ¿Qué comportamiento tenía el sistema antes del incidente?
- ¿Cómo podemos comprobar que la solución ha funcionado?

Durante el curso se construirá progresivamente una plataforma sencilla de observabilidad:

```text
Sistema Linux
     |
     v
Node Exporter
     |
     v
Prometheus
     |
     v
Grafana
     |
     v
Dashboards y alertas
```

### Función de cada componente

| Componente | Función |
|---|---|
| Node Exporter | Expone métricas del sistema operativo |
| Prometheus | Recopila y almacena series temporales |
| PromQL | Lenguaje para consultar métricas en Prometheus |
| Grafana | Visualiza los datos mediante dashboards |
| Alertas | Notifican situaciones que requieren atención |

---

## Contenido

El curso está organizado en varios bloques relacionados.

### 1. Fundamentos de telemetría

En este bloque se estudian los conceptos esenciales:

- Telemetría.
- Observabilidad.
- Métricas.
- Logs.
- Trazas.
- Eventos.
- Series temporales.
- Etiquetas.
- Frecuencia de muestreo.
- Retención de datos.
- *Downsampling*.
- Modelos *push* y *pull*.

El alumno aprenderá a reconocer qué tipo de información proporciona cada señal de observabilidad y cuándo resulta más útil.

### 2. Grafana

En este bloque se introduce Grafana:

- Requisitos del sistema.
- Instalación en Ubuntu.
- Acceso a la interfaz web.
- Configuración inicial.
- Fuentes de datos.
- Selector de rango temporal.
- Tiempo relativo.
- Desplazamiento temporal.
- Dashboards.
- Filas.
- Paneles.

### 3. Prometheus y fuentes de datos

Este bloque presenta Prometheus y su arquitectura:

- Componentes principales.
- Instalación del servicio.
- Fichero de configuración.
- Objetivos de *scraping*.
- Interfaz web.
- Métricas disponibles.
- Instalación de Node Exporter.
- Configuración de Prometheus.
- Consultas PromQL.
- Integración con Grafana.

### 4. Dashboards y visualización

En este bloque se crean dashboards para representar información de forma clara:

- Panel Time series.
- Panel Stat.
- Panel Gauge.
- Panel Bar gauge.
- Panel Heatmap.
- Panel de texto.
- Panel Canvas.
- Transformaciones.
- Organización de paneles.
- Listas de dashboards.
- Dashboards operativos.

### 5. Anotaciones y alertas

Este bloque introduce la detección automática de situaciones anómalas:

- Anotaciones.
- Reglas de alerta.
- Expresiones.
- Condiciones.
- Contactos de notificación.
- Políticas de notificación.
- Silenciados.
- Correo electrónico.
- Resolución de alertas.

### 6. Proyecto final

Como actividad final, el alumno diseñará un dashboard operativo para supervisar un servidor Linux.

El dashboard deberá incluir, como mínimo:

- Uso de CPU.
- Memoria disponible.
- Espacio utilizado.
- Tráfico de red.
- Estado de un servicio.
- Una alerta operativa.
- Un rango temporal adecuado.
- Títulos y unidades correctamente configurados.

---

## Ejemplo

### Ejemplo 1: recorrido de una métrica

La métrica de uso de CPU atraviesa varias etapas:

```text
CPU del sistema
      |
      v
Node Exporter recopila información
      |
      v
Prometheus realiza el scraping
      |
      v
Prometheus almacena muestras
      |
      v
Grafana ejecuta una consulta PromQL
      |
      v
Un panel representa la información
```

Una consulta habitual para calcular el porcentaje aproximado de CPU utilizada es:

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

Esta consulta:

1. Calcula la velocidad de cambio de la métrica de CPU en los últimos 5 minutos.
2. Selecciona el modo `idle`.
3. Calcula la media por instancia.
4. Convierte el tiempo libre en porcentaje.
5. Resta el resultado a `100` para obtener el porcentaje utilizado.

### Ejemplo 2: consulta de memoria disponible

Una consulta básica para conocer el porcentaje de memoria disponible es:

```promql
100 * (
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

Para obtener el porcentaje utilizado:

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Ejemplo 3: espacio utilizado en disco

La siguiente consulta calcula el porcentaje utilizado en cada sistema de ficheros:

```promql
100 * (
  1 -
  node_filesystem_avail_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint="/"
  }
  /
  node_filesystem_size_bytes{
    fstype!~"tmpfs|overlay",
    mountpoint="/"
  }
)
```

La etiqueta `mountpoint="/"` limita la consulta al sistema de ficheros raíz.