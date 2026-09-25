# Referencia y resolución de problemas

Este módulo reúne la documentación de consulta rápida y los procedimientos de diagnóstico utilizados durante el curso de Grafana, Prometheus y Node Exporter.

La sección está pensada para acompañar las prácticas. Permite localizar rápidamente comandos, puertos, rutas, consultas PromQL, variables, etiquetas y procedimientos para resolver problemas habituales.

## Objetivos

Al finalizar este módulo, el alumno podrá:

- Localizar comandos habituales de Ubuntu.
- Identificar los servicios y puertos utilizados en el laboratorio.
- Consultar las rutas principales de configuración.
- Utilizar consultas PromQL frecuentes.
- Interpretar variables y etiquetas de Prometheus.
- Localizar documentación y recursos adicionales.
- Diagnosticar problemas de instalación.
- Diagnosticar problemas de acceso a Grafana.
- Diagnosticar problemas de Prometheus.
- Diagnosticar problemas de Node Exporter.
- Diagnosticar problemas de fuentes de datos.
- Diagnosticar problemas de dashboards.
- Diagnosticar problemas de alertas.
- Documentar la causa y la solución de una incidencia.

## Cómo utilizar este módulo

Utiliza la sección de referencia cuando necesites consultar un dato concreto durante una práctica:

```text
¿Qué comando necesito?

¿Qué puerto utiliza el servicio?

¿Dónde está el fichero de configuración?

¿Qué consulta PromQL puedo utilizar?

¿Qué etiquetas tiene una métrica?

¿Qué URL debo comprobar?
```

Utiliza la sección de resolución de problemas cuando una parte del entorno no funcione como esperas:

```text
¿Por qué no arranca Prometheus?

¿Por qué no puedo acceder a Grafana?

¿Por qué Node Exporter no responde?

¿Por qué el target aparece como DOWN?

¿Por qué Grafana no conecta con Prometheus?

¿Por qué un dashboard no muestra datos?

¿Por qué una alerta no se activa?
```

## Estructura del módulo

El módulo se divide en dos bloques:

```text
Referencia rápida
        |
        v
Comandos, puertos, rutas, consultas y etiquetas

Resolución de problemas
        |
        v
Procedimientos de diagnóstico y corrección
```

## Referencia rápida

Esta sección contiene información para consultar durante las prácticas.

### Comandos y administración de Ubuntu

Incluye comandos para:

- Consultar el sistema.
- Consultar usuarios y permisos.
- Gestionar ficheros.
- Consultar procesos.
- Consultar servicios.
- Revisar registros.
- Comprobar la red.
- Consultar puertos.

[Consultar comandos de Ubuntu](referencia/01-comandos-ubuntu.md)

### Servicios y puertos

Incluye información sobre:

- Grafana.
- Prometheus.
- Node Exporter.
- Puertos TCP.
- Procesos en escucha.
- Comprobaciones HTTP.
- Comandos `systemctl`.

[Consultar servicios y puertos](referencia/02-servicios-puertos.md)

### Rutas de ficheros

Incluye las rutas habituales de:

- Ficheros de configuración.
- Datos de Prometheus.
- Configuración de Grafana.
- Unidades de `systemd`.
- Logs.
- Dashboards y provisión.

[Consultar rutas de ficheros](referencia/03-rutas-ficheros.md)

### Consultas PromQL

Incluye ejemplos de consultas para:

- Comprobar disponibilidad.
- Calcular uso de CPU.
- Calcular uso de memoria.
- Calcular ocupación de almacenamiento.
- Consultar tráfico de red.
- Agrupar series.
- Filtrar etiquetas.
- Utilizar funciones temporales.
- Preparar consultas para dashboards y alertas.

[Consultar PromQL](referencia/04-promql.md)

### Variables y etiquetas

Incluye información sobre:

- Etiquetas de Prometheus.
- Etiquetas de Node Exporter.
- Variables de Grafana.
- Filtros por instancia.
- Expresiones regulares.
- Selección múltiple.
- Opción `All`.
- Agrupaciones mediante `by` y `without`.

[Consultar variables y etiquetas](referencia/05-variables-etiquetas.md)

### Enlaces útiles

Incluye enlaces relacionados con:

- Documentación oficial.
- Grafana.
- Prometheus.
- Node Exporter.
- PromQL.
- Ubuntu.
- YAML.
- Administración de servicios.

[Consultar enlaces útiles](referencia/06-enlaces-utiles.md)

## Resolución de problemas

Esta sección contiene procedimientos ordenados para identificar y corregir errores.

### Instalación

Utiliza esta página cuando existan problemas durante:

- La instalación de Grafana.
- La instalación de Prometheus.
- La instalación de Node Exporter.
- La configuración de repositorios.
- La importación de claves.
- La creación de usuarios de servicio.
- La creación de unidades `systemd`.
- La activación de servicios.

[Resolver problemas de instalación](resolucion-problemas/01-instalacion.md)

### Node Exporter

Utiliza esta página cuando:

- El servicio no arranca.
- El puerto `9100` no está disponible.
- El endpoint `/metrics` no responde.
- Prometheus muestra el target como `DOWN`.
- Faltan métricas del sistema.
- El usuario de servicio tiene permisos incorrectos.

[Resolver problemas de Node Exporter](resolucion-problemas/04-node-exporter.md)

### Prometheus

Utiliza esta página cuando:

- Prometheus no arranca.
- El fichero YAML contiene errores.
- Un target aparece como `DOWN`.
- La consulta `up` devuelve valores inesperados.
- No se almacenan métricas.
- La interfaz web no responde.
- La configuración no se puede validar.

[Resolver problemas de Prometheus](resolucion-problemas/03-prometheus.md)

### Acceso a Grafana

Utiliza esta página cuando:

- Grafana no responde.
- El puerto `3000` no está disponible.
- La interfaz muestra un error.
- El servicio está detenido.
- El navegador no puede acceder al servidor.
- Existen problemas de red o cortafuegos.

[Resolver problemas de acceso a Grafana](resolucion-problemas/02-acceso-grafana.md)

### Fuentes de datos

Utiliza esta página cuando:

- Grafana no conecta con Prometheus.
- `Save & test` devuelve un error.
- Las consultas no muestran resultados.
- La URL de Prometheus es incorrecta.
- La fuente de datos no está disponible.
- El dashboard utiliza una fuente equivocada.

[Resolver problemas de fuentes de datos](resolucion-problemas/05-fuentes-datos.md)

### Dashboards

Utiliza esta página cuando:

- Un panel no muestra datos.
- Una consulta devuelve demasiadas series.
- Las unidades son incorrectas.
- Una variable no filtra correctamente.
- La leyenda no identifica las instancias.
- Los umbrales visuales no funcionan.
- Una transformación produce resultados inesperados.

[Resolver problemas de dashboards](resolucion-problemas/06-dashboards.md)

### Alertas

Utiliza esta página cuando:

- Una alerta no se activa.
- Una alerta permanece en estado `Pending`.
- Una alerta no se recupera.
- No llega una notificación.
- Las etiquetas no coinciden con una política.
- Existe demasiado ruido.
- Un silencio bloquea una notificación.

[Resolver problemas de alertas](resolucion-problemas/07-alertas.md)

## Flujo general de diagnóstico

Cuando aparezca un problema, sigue este orden:

1. Identifica el componente afectado.
2. Comprueba si el servicio está activo.
3. Comprueba si el servicio arranca automáticamente.
4. Comprueba el puerto correspondiente.
5. Prueba el endpoint HTTP.
6. Revisa los registros del servicio.
7. Valida la configuración.
8. Ejecuta una consulta básica.
9. Repite la prueba después de aplicar la corrección.
10. Documenta la causa y la solución.

El flujo puede representarse así:

```text
Problema
    |
    v
Identificar componente
    |
    v
Comprobar servicio
    |
    v
Comprobar puerto
    |
    v
Probar endpoint
    |
    v
Revisar registros
    |
    v
Validar configuración
    |
    v
Repetir la prueba
    |
    v
Documentar la solución
```

## Comprobaciones iniciales

Antes de analizar un problema específico, ejecutar las comprobaciones básicas.

### Comprobar el sistema

```bash
hostname
lsb_release -ds
uname -m
uname -r
date
```

### Comprobar los servicios

```bash
for service in grafana-server prometheus node_exporter; do
  echo "===== $service ====="
  systemctl is-active "$service"
  systemctl is-enabled "$service" 2>/dev/null || true
done
```

### Comprobar los puertos

```bash
sudo ss -lntp | grep -E ':(3000|9090|9100)\b'
```

### Comprobar los endpoints

```bash
curl -I http://localhost:3000
curl -I http://localhost:9090
curl -I http://localhost:9100/metrics
```

### Comprobar la salud de Prometheus

```bash
curl http://localhost:9090/-/healthy
```

### Comprobar Node Exporter

```bash
curl -s http://localhost:9100/metrics | head
```

### Comprobar los targets

```bash
curl -s http://localhost:9090/api/v1/targets | jq
```

## Tabla rápida de componentes

| Componente | Función | Puerto | Comprobación |
|---|---|---:|---|
| Grafana | Dashboards y alertas | 3000 | `curl -I http://localhost:3000` |
| Prometheus | Métricas y PromQL | 9090 | `curl http://localhost:9090/-/healthy` |
| Node Exporter | Métricas del sistema | 9100 | `curl http://localhost:9100/metrics` |

## Tabla rápida de servicios

| Servicio | Estado esperado | Comando |
|---|---|---|
| Grafana | `active` | `systemctl is-active grafana-server` |
| Prometheus | `active` | `systemctl is-active prometheus` |
| Node Exporter | `active` | `systemctl is-active node_exporter` |

## Tabla rápida de consultas

### Disponibilidad de objetivos

```promql
up
```

### Disponibilidad de Node Exporter

```promql
up{job="node_exporter"}
```

### CPU utilizada

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

### Memoria utilizada

```promql
100 * (
  1 -
  node_memory_MemAvailable_bytes
  /
  node_memory_MemTotal_bytes
)
```

### Almacenamiento utilizado

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

## Registro de incidencias

Cuando se resuelva un problema, documentarlo mediante la siguiente plantilla:

```text
Fecha:

Alumno:

Componente afectado:

Síntoma:

Comando o consulta utilizada:

Resultado inicial:

Mensaje de error:

Causa identificada:

Corrección aplicada:

Resultado posterior:

Evidencia:

Observaciones:
```

### Ejemplo

```text
Fecha:
2026-09-25

Componente afectado:
Node Exporter

Síntoma:
Prometheus muestra el target como DOWN.

Comando utilizado:
curl -I http://localhost:9100/metrics

Resultado inicial:
Connection refused

Causa:
El servicio node_exporter estaba detenido.

Corrección:
sudo systemctl start node_exporter

Resultado posterior:
El endpoint responde con HTTP 200 y el target aparece como UP.

Evidencia:
captura-target-recuperado.png
```

## Recomendaciones de seguridad

Durante el diagnóstico:

- Trabaja únicamente en el entorno autorizado.
- No detengas servicios de producción.
- No generes carga sobre sistemas no autorizados.
- No compartas contraseñas.
- No incluyas tokens en capturas.
- No publiques claves API.
- Revisa las URLs antes de compartirlas.
- Utiliza usuarios de servicio.
- Evita ejecutar aplicaciones como `root`.
- Documenta los cambios temporales.
- Restaura el entorno al finalizar.

## Estado final esperado

Al finalizar las prácticas, el entorno debería cumplir estas condiciones:

```text
Grafana:
    activo
    puerto 3000 disponible
    interfaz accesible

Prometheus:
    activo
    puerto 9090 disponible
    API accesible
    configuración válida

Node Exporter:
    activo
    puerto 9100 disponible
    endpoint /metrics accesible

Prometheus:
    target node_exporter en estado UP

Grafana:
    fuente de datos Prometheus validada
    dashboards con datos
```

## Navegación relacionada

### Curso

- [Objetivos del curso](../00-el-curso/01-objetivos.md)
- [Requisitos previos](../00-el-curso/02-requisitos-previos.md)
- [Entorno de laboratorio](../00-el-curso/03-entorno-laboratorio.md)

### Prácticas

- [Práctica 3 - Consultas PromQL](../03-promql/index.md)
- [Práctica 4 - Dashboard operativo](../04-dashboard/index.md)
- [Práctica 5 - Alertas](../05-alertas/index.md)
- [Entregables](../06-entregables/index.md)
- [Criterios de evaluación](../06-entregables/criterios-evaluacion.md)