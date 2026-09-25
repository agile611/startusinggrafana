# Enlaces útiles

Esta página reúne recursos oficiales y de referencia para continuar el aprendizaje de Ubuntu, Grafana, Prometheus, Node Exporter, PromQL y GitHub.

Los enlaces están organizados por categorías para que el alumno pueda localizar rápidamente la documentación que necesita durante las prácticas.

> **Recomendación:** utiliza preferentemente documentación oficial. Los blogs y foros pueden ser útiles para comparar experiencias, pero conviene verificar siempre la información con la documentación del proyecto y con la versión instalada.

## Objetivos

Al finalizar esta sesión, el alumno podrá:

- Identificar las fuentes oficiales de documentación del curso.
- Consultar la documentación de Ubuntu.
- Localizar información oficial de Grafana y Prometheus.
- Utilizar la documentación de Node Exporter.
- Buscar información sobre consultas PromQL.
- Consultar la documentación de MkDocs Material.
- Utilizar Git y GitHub para gestionar el proyecto.
- Evaluar si una fuente de información es fiable.
- Buscar respuestas de forma autónoma.
- Documentar las fuentes utilizadas durante una práctica o incidencia.

## Introducción

La documentación técnica es una herramienta fundamental para administrar sistemas y resolver problemas.

Durante el curso no se espera que el alumno memorice todos los comandos, rutas o consultas. Se espera que sepa:

1. Identificar el problema.
2. Formular una búsqueda concreta.
3. Consultar una fuente fiable.
4. Comprobar que la información corresponde a la versión instalada.
5. Aplicar la solución en un entorno controlado.
6. Documentar el resultado.

Una buena búsqueda técnica debe ser específica.

Ejemplo poco concreto:

```text
Grafana no funciona
```

Ejemplo más útil:

```text
Grafana Ubuntu 24.04 service failed port 3000 journalctl
```

Otro ejemplo:

```text
Prometheus target down node_exporter connection refused
```

## Cómo evaluar una fuente de información

Antes de aplicar una solución, comprueba los siguientes aspectos:

### Autoridad

Comprueba quién publica la información.

Son fuentes especialmente recomendables:

- Documentación oficial del proyecto.
- Manuales del sistema.
- Repositorios oficiales.
- Documentación de versiones.
- Páginas de referencia de comandos.

### Fecha y versión

Verifica que la información corresponde a la versión utilizada.

Por ejemplo:

```text
Ubuntu 24.04 LTS
Grafana 11.x
Prometheus 3.x
Node Exporter 1.x
```

Una instrucción válida para una versión antigua puede no ser adecuada para una versión reciente.

### Contexto

Comprueba si la solución se refiere a:

- Ubuntu o Debian.
- Red Hat o Fedora.
- Instalación mediante paquete.
- Instalación mediante archivo comprimido.
- Docker.
- Kubernetes.
- Grafana Cloud.
- Instalación local.

No mezcles instrucciones de entornos diferentes sin comprobar sus consecuencias.

### Reproducibilidad

Una buena solución debe permitir repetir el procedimiento.

Documenta:

```text
Comando utilizado:

Resultado obtenido:

Cambio aplicado:

Resultado posterior:

Versión del software:

```

### Seguridad

No ejecutes comandos que:

- Borren directorios completos.
- Modifiquen permisos de forma indiscriminada.
- Descarguen y ejecuten scripts sin revisarlos.
- Expongan servicios a Internet.
- Modifiquen el firewall sin comprender las reglas.
- Sobrescriban configuraciones sin copia de seguridad.

## Documentación oficial de Ubuntu

La documentación oficial de Ubuntu es la referencia principal para instalar, configurar y administrar el sistema operativo.

### Ubuntu Server

Documentación oficial de Ubuntu Server:

[Ubuntu Server documentation](https://documentation.ubuntu.com/server/)

Recursos especialmente útiles:

- Instalación de Ubuntu Server.
- Gestión de paquetes.
- Usuarios y permisos.
- Servicios y `systemd`.
- Redes.
- Firewall.
- Almacenamiento.
- Registros del sistema.
- Seguridad.

### Manuales de Ubuntu

[Ubuntu Manpages](https://manpages.ubuntu.com/)

Permite consultar manuales de comandos y servicios.

Ejemplos:

```text
systemctl
journalctl
ss
ip
find
grep
chmod
chown
```

### Ayuda local de Ubuntu

También puedes consultar los manuales directamente desde el sistema:

```bash
man systemctl
```

```bash
man journalctl
```

```bash
man ss
```

```bash
man find
```

```bash
man grep
```

Para buscar una palabra clave en los manuales:

```bash
apropos network
```

### Ubuntu Packages

[Ubuntu Packages](https://packages.ubuntu.com/)

Permite consultar:

- Nombre de paquetes.
- Versiones disponibles.
- Dependencias.
- Ficheros incluidos.
- Arquitecturas compatibles.

Ejemplo de búsqueda:

```text
curl
lsof
jq
prometheus
```

### Ubuntu Security Notices

[Ubuntu Security Notices](https://ubuntu.com/security/notices)

Permite consultar avisos de seguridad relacionados con paquetes de Ubuntu.

## Documentación oficial de Grafana

La documentación oficial de Grafana es la referencia principal para crear dashboards, configurar fuentes de datos, trabajar con alertas y administrar la plataforma.

### Documentación de Grafana

[Grafana documentation](https://grafana.com/docs/grafana/latest/)

Temas recomendados:

- Instalación.
- Configuración inicial.
- Dashboards.
- Paneles.
- Fuentes de datos.
- Variables.
- Alertas.
- Usuarios y equipos.
- Plugins.
- Administración.
- Seguridad.

### Dashboards

[Grafana dashboards](https://grafana.com/docs/grafana/latest/dashboards/)

Recursos relacionados con:

- Creación de dashboards.
- Organización de paneles.
- Variables.
- Anotaciones.
- Enlaces.
- Importación y exportación.
- Configuración temporal.

### Visualizaciones

[Grafana visualizations](https://grafana.com/docs/grafana/latest/visualizations/)

Incluye información sobre:

- Time series.
- Stat.
- Gauge.
- Bar gauge.
- Table.
- Text.
- Heatmap.
- Geomap.
- Canvas.

### Fuentes de datos

[Grafana data sources](https://grafana.com/docs/grafana/latest/datasources/)

Consulta esta sección para configurar:

- Prometheus.
- Loki.
- InfluxDB.
- MySQL.
- PostgreSQL.
- Elasticsearch.
- Fuentes de datos externas.

### Variables de dashboard

[Grafana variables](https://grafana.com/docs/grafana/latest/dashboards/variables/)

Permite consultar información sobre:

- Variables de consulta.
- Variables personalizadas.
- Selección múltiple.
- Opción `All`.
- Variables encadenadas.
- Variables de intervalo.

### Alertas de Grafana

[Grafana alerting](https://grafana.com/docs/grafana/latest/alerting/)

Incluye información sobre:

- Reglas de alerta.
- Condiciones.
- Expresiones.
- Contactos de notificación.
- Políticas de notificación.
- Silencios.
- Historial de alertas.

### Plugins de Grafana

[Grafana plugins](https://grafana.com/grafana/plugins/)

Permite buscar plugins de:

- Paneles.
- Fuentes de datos.
- Aplicaciones.
- Visualizaciones adicionales.

Antes de instalar un plugin, comprueba:

- Compatibilidad con la versión de Grafana.
- Fecha de actualización.
- Autor.
- Permisos necesarios.
- Dependencias.
- Estado de mantenimiento.

### Grafana HTTP API

[Grafana HTTP API](https://grafana.com/docs/grafana/latest/developers/http_api/)

Útil para automatizar:

- Dashboards.
- Usuarios.
- Equipos.
- Fuentes de datos.
- Alertas.
- Carpetas.

No compartas tokens ni claves API en capturas, repositorios o informes públicos.

## Documentación oficial de Prometheus

Prometheus es el sistema de monitorización y almacenamiento de series temporales utilizado en el curso.

### Documentación de Prometheus

[Prometheus documentation](https://prometheus.io/docs/)

Incluye información sobre:

- Conceptos básicos.
- Instalación.
- Configuración.
- Scraping.
- Targets.
- Reglas.
- Alertas.
- Almacenamiento.
- API.
- Seguridad.
- Exporters.

### Primeros pasos

[Prometheus getting started](https://prometheus.io/docs/prometheus/latest/getting_started/)

Explica:

- Cómo ejecutar Prometheus.
- Cómo configurar targets.
- Cómo consultar métricas.
- Cómo comprobar el estado de los targets.

### Configuración

[Prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

Referencia para:

- `global`.
- `scrape_configs`.
- `rule_files`.
- `alerting`.
- `remote_write`.
- `remote_read`.
- `relabel_configs`.
- `metric_relabel_configs`.

### Consultas PromQL

[Prometheus querying basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)

[Prometheus operators](https://prometheus.io/docs/prometheus/latest/querying/operators/)

[Prometheus functions](https://prometheus.io/docs/prometheus/latest/querying/functions/)

Estas páginas son especialmente importantes para trabajar con:

- Selectores.
- Etiquetas.
- Vectores instantáneos.
- Vectores de rango.
- Operadores.
- Agregaciones.
- Funciones.
- Consultas temporales.

### Referencia de PromQL

[PromQL language reference](https://prometheus.io/docs/prometheus/latest/querying/basics/)

Ejemplos de consultas:

```promql
up
```

```promql
up{job="node_exporter"}
```

```promql
rate(node_cpu_seconds_total[5m])
```

```promql
sum by (instance) (up)
```

### Reglas y alertas

[Prometheus recording and alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/)

Utiliza esta documentación para consultar:

- Reglas de grabación.
- Reglas de alerta.
- Etiquetas.
- Anotaciones.
- Evaluación de reglas.
- Validación de ficheros.

### API HTTP de Prometheus

[Prometheus HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/)

Permite consultar:

- Series.
- Etiquetas.
- Targets.
- Reglas.
- Metadata.
- Consultas instantáneas.
- Consultas de rango.

Ejemplo:

```bash
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up'
```

### Consola de expresiones

La interfaz web de Prometheus permite validar consultas antes de utilizarlas en Grafana.

Dirección habitual:

```text
http://localhost:9090
```

Procedimiento:

1. Accede a Prometheus.
2. Abre el explorador de expresiones.
3. Introduce la consulta.
4. Ejecuta la consulta.
5. Revisa la tabla.
6. Revisa el gráfico.
7. Comprueba las etiquetas devueltas.

## Documentación oficial de Node Exporter

Node Exporter expone métricas del sistema operativo para que Prometheus pueda recopilarlas.

### Repositorio oficial

[Prometheus Node Exporter](https://github.com/prometheus/node_exporter)

Incluye:

- Código fuente.
- Releases.
- Collectors.
- Opciones de ejecución.
- Issues.
- Ejemplos.
- Información de compatibilidad.

### Releases

[Node Exporter releases](https://github.com/prometheus/node_exporter/releases)

Antes de instalar una versión, comprueba:

- Arquitectura del sistema.
- Versión disponible.
- Cambios relevantes.
- Compatibilidad.
- Método de instalación.

Consultar la arquitectura local:

```bash
uname -m
```

Consultar la versión instalada:

```bash
node_exporter --version
```

### Endpoint de métricas

La dirección habitual es:

```text
http://localhost:9100/metrics
```

Comprobarlo desde la terminal:

```bash
curl -s http://localhost:9100/metrics | head
```

Buscar métricas de memoria:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_memory_" \
  | head
```

Buscar métricas de CPU:

```bash
curl -s http://localhost:9100/metrics \
  | grep "^node_cpu_" \
  | head
```

## Documentación de exporters

Los exporters permiten adaptar métricas de diferentes sistemas para que Prometheus pueda recopilarlas.

### Exporters oficiales y mantenidos por la comunidad

[Prometheus exporters](https://prometheus.io/docs/instrumenting/exporters/)

Ejemplos:

- Node Exporter.
- Blackbox Exporter.
- MySQL Exporter.
- PostgreSQL Exporter.
- NGINX Exporter.
- SNMP Exporter.
- Apache Exporter.

Antes de utilizar un exporter:

1. Revisa el repositorio.
2. Comprueba la última actualización.
3. Consulta la licencia.
4. Comprueba los requisitos.
5. Revisa los puertos.
6. Valida las métricas expuestas.
7. Limita el acceso de red.

## Documentación de Alertmanager

Alertmanager gestiona las alertas enviadas por Prometheus.

### Documentación oficial

[Alertmanager documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)

Incluye información sobre:

- Rutas.
- Receptores.
- Agrupación.
- Silencios.
- Inhibiciones.
- Plantillas.
- Integraciones.

### Configuración de Alertmanager

[Alertmanager configuration](https://prometheus.io/docs/alerting/latest/configuration/)

Ejemplo conceptual:

```yaml
route:
  receiver: equipo-sistemas

receivers:
  - name: equipo-sistemas
```

No incluyas contraseñas, tokens ni credenciales reales en ejemplos públicos.

## Documentación de Git

Git se utiliza para controlar los cambios del proyecto de documentación.

### Documentación de Git

[Git documentation](https://git-scm.com/doc)

Temas recomendados:

- Repositorios.
- Commits.
- Ramas.
- Etiquetas.
- Remotos.
- Fusión de cambios.
- Resolución de conflictos.

### Comandos básicos

Consultar el estado:

```bash
git status
```

Ver los cambios:

```bash
git diff
```

Añadir un fichero:

```bash
git add docs/referencia/06-enlaces-utiles.md
```

Crear un commit:

```bash
git commit -m "Añadir enlaces útiles"
```

Consultar el historial:

```bash
git log --oneline
```

Enviar cambios:

```bash
git push
```

Actualizar el repositorio local:

```bash
git pull
```

### Buenas prácticas de commits

Un commit debe describir un cambio concreto.

Ejemplos adecuados:

```text
Añadir documentación de PromQL
Corregir enlace de Grafana
Actualizar práctica de Node Exporter
Añadir ejemplos de variables
```

Ejemplos poco útiles:

```text
Cambios
Actualización
Prueba
Cosas nuevas
```

## Documentación de GitHub

### GitHub Docs

[GitHub Docs](https://docs.github.com/)

Incluye información sobre:

- Repositorios.
- Ramas.
- Actions.
- GitHub Pages.
- Issues.
- Pull requests.
- Seguridad.
- Secretos.
- Permisos.

### GitHub Actions

[GitHub Actions documentation](https://docs.github.com/en/actions)

Recursos útiles:

- Workflows.
- Jobs.
- Steps.
- Runners.
- Actions reutilizables.
- Variables.
- Secretos.
- Artefactos.
- Permisos.

### GitHub Pages

[GitHub Pages documentation](https://docs.github.com/en/pages)

Consulta esta sección para:

- Publicar sitios estáticos.
- Configurar dominios.
- Utilizar GitHub Actions.
- Revisar despliegues.
- Configurar la visibilidad del sitio.

### Sintaxis de workflows

[Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)

Ejemplo básico:

```yaml
name: Publicar documentación

on:
  push:
    branches:
      - main

permissions:
  contents: read
  pages: write
  id-token: write
```

### Marketplace de GitHub Actions

[GitHub Marketplace](https://github.com/marketplace?type=actions)

Antes de utilizar una Action:

- Revisa el repositorio.
- Comprueba el autor.
- Consulta la versión.
- Revisa los permisos.
- Comprueba la actividad del proyecto.
- Evita utilizar Actions desconocidas sin analizarlas.

## Documentación de MkDocs

MkDocs se utiliza para generar el sitio de documentación a partir de ficheros Markdown.

### MkDocs

[MkDocs documentation](https://www.mkdocs.org/)

Incluye información sobre:

- Instalación.
- Estructura del proyecto.
- Configuración.
- Navegación.
- Extensiones.
- Plugins.
- Previsualización local.
- Construcción del sitio.

### Comandos básicos de MkDocs

Crear un proyecto:

```bash
mkdocs new .
```

Iniciar el servidor local:

```bash
mkdocs serve
```

Construir el sitio:

```bash
mkdocs build
```

Construir con validación estricta:

```bash
mkdocs build --strict
```

Limpiar y construir:

```bash
mkdocs build --clean --strict
```

### Material for MkDocs

[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)

La documentación incluye:

- Temas.
- Navegación.
- Paletas.
- Iconos.
- Pestañas.
- Tabs de contenido.
- Admonitions.
- Código.
- Búsqueda.
- Variables.
- JavaScript.
- CSS personalizado.

### Configuración del tema

[Material for MkDocs configuration](https://squidfunk.github.io/mkdocs-material/setup/)

Ejemplo:

```yaml
theme:
  name: material
  language: es
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.top
    - content.code.copy
    - search.highlight
    - search.suggest
```

### Extensiones de Markdown

[Material for MkDocs extensions](https://squidfunk.github.io/mkdocs-material/setup/extensions/)

Extensiones habituales:

```yaml
markdown_extensions:
  - admonition
  - attr_list
  - md_in_html
  - tables
  - footnotes
  - pymdownx.details
  - pymdownx.superfences
```

### Plugins

[Material for MkDocs plugins](https://squidfunk.github.io/mkdocs-material/plugins/)

Ejemplo del plugin de búsqueda:

```yaml
plugins:
  - search:
      lang:
        - es
```

### Validar el sitio

Ejecuta:

```bash
mkdocs build --strict
```

Comprueba que:

- No existen enlaces rotos.
- No faltan ficheros del `nav`.
- No hay errores de configuración.
- Se generan los recursos CSS.
- Se generan los recursos JavaScript.
- Se genera el índice de búsqueda.

## Repositorios y ejemplos

### Repositorio de Grafana

[Grafana GitHub](https://github.com/grafana/grafana)

### Repositorio de Prometheus

[Prometheus GitHub](https://github.com/prometheus/prometheus)

### Repositorio de Node Exporter

[Node Exporter GitHub](https://github.com/prometheus/node_exporter)

### Repositorio de Alertmanager

[Alertmanager GitHub](https://github.com/prometheus/alertmanager)

### Repositorio de MkDocs Material

[Material for MkDocs GitHub](https://github.com/squidfunk/mkdocs-material)

Los repositorios permiten consultar:

- Código fuente.
- Releases.
- Cambios.
- Issues.
- Ejemplos.
- Documentación asociada.
- Problemas conocidos.

## Recursos sobre Linux

### Linux man-pages

[Linux man-pages project](https://www.kernel.org/doc/man-pages/)

Referencia para llamadas, comandos y conceptos relacionados con Linux.

### systemd

[systemd documentation](https://systemd.io/)

Recursos sobre:

- Servicios.
- Unidades.
- Journal.
- Arranque.
- Dependencias.
- Logs.
- Seguridad.

### Kernel de Linux

[The Linux Kernel documentation](https://docs.kernel.org/)

Referencia avanzada para:

- Kernel.
- Dispositivos.
- Redes.
- Almacenamiento.
- Rendimiento.
- Sistemas de ficheros.

### Bash Reference Manual

[Bash Reference Manual](https://www.gnu.org/software/bash/manual/)

Útil para comprender:

- Variables.
- Bucles.
- Condicionales.
- Redirecciones.
- Tuberías.
- Sustitución de comandos.
- Scripts.

## Recursos sobre redes

### MDN HTTP

[MDN HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP)

Explica:

- Métodos HTTP.
- Códigos de estado.
- Cabeceras.
- Peticiones.
- Respuestas.
- Caching.
- Autenticación.

### curl documentation

[curl documentation](https://curl.se/docs/)

Incluye:

- Opciones de `curl`.
- Protocolos.
- Ejemplos.
- Seguridad.
- Diagnóstico de conexiones.

Ejemplos:

```bash
curl -I http://localhost:3000
```

```bash
curl -v http://localhost:9090/-/healthy
```

```bash
curl -s http://localhost:9100/metrics | head
```

### IANA Service Name and Port Number Registry

[IANA port registry](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml)

Puede utilizarse para consultar la asignación oficial de nombres y puertos. Los puertos utilizados en un laboratorio pueden ser personalizados, por lo que siempre debes comprobar la configuración real del servicio.

## Recursos sobre seguridad

### Ubuntu security

[Ubuntu security](https://ubuntu.com/security)

Incluye información sobre:

- Actualizaciones.
- Avisos de seguridad.
- Ubuntu Pro.
- Mantenimiento.
- Vulnerabilidades.

### OWASP

[OWASP](https://owasp.org/)

Referencia para conceptos de seguridad de aplicaciones web:

- Autenticación.
- Control de acceso.
- Gestión de sesiones.
- Inyección.
- Configuración segura.
- Exposición de datos.

### Principios de seguridad para el laboratorio

- Utiliza contraseñas de prueba, nunca credenciales reales.
- No publiques tokens en GitHub.
- No incluyas secretos en capturas.
- No abras puertos innecesarios.
- Limita el acceso por red.
- Mantén actualizado el software.
- Revisa los permisos de los ficheros.
- Elimina credenciales de los ejemplos antes de compartirlos.
- Utiliza usuarios con los permisos mínimos necesarios.

## Cómo realizar una búsqueda técnica

### Definir el problema

Ejemplo:

```text
Prometheus muestra el target node_exporter como DOWN.
```

### Recopilar datos

Ejecuta:

```bash
systemctl status node_exporter
```

```bash
sudo ss -lntp | grep ':9100'
```

```bash
curl -I http://localhost:9100/metrics
```

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

### Formular la búsqueda

Búsqueda recomendada:

```text
Prometheus node_exporter target down connection refused
```

Búsqueda más específica:

```text
Prometheus node_exporter target down Ubuntu systemd port 9100
```

### Comparar fuentes

Consulta al menos:

1. Documentación oficial.
2. Repositorio oficial.
3. Manual del sistema.
4. Una fuente secundaria, si es necesario.

### Probar la solución

Aplica la solución en el entorno de laboratorio y registra:

```text
Comando:

Resultado:

Cambio:

Validación:

```

### Documentar la respuesta

Un informe técnico debe explicar:

- Qué problema existía.
- Cómo se detectó.
- Qué fuente se consultó.
- Qué solución se aplicó.
- Cómo se verificó.
- Qué evidencias se obtuvieron.

## Sesión práctica 1: localizar documentación oficial

### Objetivo

Localizar las fuentes oficiales de los componentes del curso.

### Tarea

Encuentra y registra la URL oficial de:

- Ubuntu Server.
- Grafana.
- Prometheus.
- Node Exporter.
- Alertmanager.
- MkDocs Material.
- GitHub Actions.
- GitHub Pages.

### Plantilla

```text
Ubuntu Server:

Grafana:

Prometheus:

Node Exporter:

Alertmanager:

MkDocs Material:

GitHub Actions:

GitHub Pages:
```

### Preguntas de análisis

- ¿Qué fuente utilizarías para resolver un problema de PromQL?
- ¿Qué fuente utilizarías para comprobar una opción de `systemctl`?
- ¿Qué fuente utilizarías para consultar la configuración de un dashboard?
- ¿Qué fuente utilizarías para revisar la sintaxis de un workflow?
- ¿Por qué es importante consultar la versión del software?

## Sesión práctica 2: investigar un problema de Node Exporter

### Objetivo

Utilizar documentación y comandos para resolver un problema de conectividad.

### Situación

Prometheus muestra el target de Node Exporter como `DOWN`.

### Comprobar el servicio

```bash
systemctl is-active node_exporter
```

### Comprobar el puerto

```bash
sudo ss -lntp | grep ':9100'
```

### Comprobar el endpoint

```bash
curl -v http://localhost:9100/metrics
```

### Consultar los registros

```bash
sudo journalctl -u node_exporter -n 50 --no-pager
```

### Buscar documentación

Consulta:

- Documentación o repositorio de Node Exporter.
- Documentación de Prometheus sobre targets.
- Manual de `systemctl`.
- Manual de `journalctl`.

### Resolver la incidencia

Si el servicio está detenido:

```bash
sudo systemctl start node_exporter
```

Después:

```bash
systemctl is-active node_exporter
```

```bash
curl -I http://localhost:9100/metrics
```

### Informe

```text
Síntoma:

Comprobación inicial:

Fuente oficial consultada:

Causa:

Comando aplicado:

Resultado:

Evidencias:
```

## Sesión práctica 3: investigar una consulta PromQL

### Objetivo

Utilizar la documentación de Prometheus para construir y validar una consulta.

### Consulta inicial

```promql
node_cpu_seconds_total
```

### Filtrar el modo idle

```promql
node_cpu_seconds_total{
  mode="idle"
}
```

### Aplicar `rate`

```promql
rate(
  node_cpu_seconds_total{
    mode="idle"
  }[5m]
)
```

### Agrupar por instancia

```promql
avg by (instance) (
  rate(
    node_cpu_seconds_total{
      mode="idle"
    }[5m]
  )
)
```

### Convertir a porcentaje de uso

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

### Fuentes que deben consultarse

- Conceptos básicos de PromQL.
- Función `rate`.
- Operadores de agregación.
- Etiquetas.
- Métricas de Node Exporter.

### Informe

```text
Métrica inicial:

Etiquetas utilizadas:

Función utilizada:

Ventana temporal:

Agregación aplicada:

Unidad del resultado:

Consulta final:

Interpretación:
```

## Sesión práctica 4: investigar una variable de Grafana

### Objetivo

Crear y diagnosticar una variable de dashboard.

### Crear la variable

Nombre:

```text
instance
```

Consulta:

```promql
label_values(up, instance)
```

### Utilizar la variable

```promql
node_load1{
  instance=~"$instance"
}
```

### Simular un error

Cambia temporalmente la consulta de la variable por:

```promql
label_values(up, instancia)
```

### Diagnosticar

Comprueba las etiquetas reales:

```bash
curl -s http://localhost:9090/api/v1/labels \
  | jq
```

### Corregir

Utiliza:

```promql
label_values(up, instance)
```

### Informe

```text
Nombre de la variable:

Consulta inicial:

Problema observado:

Comando de diagnóstico:

Etiqueta correcta:

Consulta corregida:

Resultado final:
```

## Sesión práctica 5: validar el sitio MkDocs

### Objetivo

Comprobar que la documentación se puede construir correctamente.

### Construcción local

```bash
mkdocs build --strict
```

### Servidor local

```bash
mkdocs serve
```

Abre:

```text
http://127.0.0.1:8000
```

### Comprobar recursos

```bash
test -f site/assets/css/custom.css
```

```bash
test -f site/assets/js/custom.js
```

```bash
test -f site/search/search_index.json
```

### Comprobar enlaces y navegación

Revisa:

- Página de inicio.
- Menú lateral.
- Enlaces internos.
- Búsqueda.
- Código con botón de copia.
- Imágenes.
- CSS personalizado.
- JavaScript personalizado.
- Navegación entre módulos.

### Informe

```text
Resultado de mkdocs build:

Resultado de mkdocs serve:

Recursos encontrados:

Páginas comprobadas:

Enlaces con problemas:

Correcciones aplicadas:

Evidencias:
```

## Sesión práctica 6: investigar un workflow de GitHub Actions

### Objetivo

Comprender cómo se construye y publica la documentación.

### Revisar el workflow

Localiza el fichero:

```text
.github/workflows/
```

Consulta su contenido:

```bash
find .github/workflows -type f -maxdepth 1 -print
```

```bash
cat .github/workflows/publicar-documentacion.yml
```

### Identificar las fases

El workflow debe incluir fases similares a:

```text
Descargar el repositorio
Configurar Python
Instalar dependencias
Construir MkDocs
Comprobar el sitio
Subir el artefacto
Desplegar en GitHub Pages
```

### Validar localmente

```bash
python -m pip install -r requirements.txt
mkdocs build --strict
```

### Consultar la ejecución

En GitHub:

1. Abre el repositorio.
2. Accede a **Actions**.
3. Selecciona el workflow.
4. Abre la ejecución más reciente.
5. Revisa cada job.
6. Consulta los logs.
7. Identifica posibles errores.

### Informe

```text
Nombre del workflow:

Evento que lo ejecuta:

Rama configurada:

Versión de Python:

Comando de construcción:

Ruta del artefacto:

Job de publicación:

Resultado de la ejecución:

Errores encontrados:

Correcciones:
```

## Plantilla para registrar enlaces

Utiliza esta plantilla para ampliar la documentación del curso:

```text
Nombre del recurso:

Categoría:

URL:

Organización o autor:

Versión consultada:

Fecha de consulta:

Tema principal:

Motivo de utilidad:

Comandos o ejemplos relevantes:

Observaciones:
```

## Plantilla para una investigación técnica

```text
Título de la incidencia:

Fecha:

Alumno:

Equipo:

Versión de Ubuntu:

Versión de la aplicación:

Síntoma:

Impacto:

Comprobaciones realizadas:

Comandos utilizados:

Resultado de cada comprobación:

Fuente oficial consultada:

Fuente secundaria consultada:

Causa identificada:

Solución aplicada:

Validación posterior:

Riesgos o efectos secundarios:

Evidencias:

Conclusión:
```

## Recomendaciones para citar fuentes

Cuando utilices información externa en un informe:

- Incluye el nombre del proyecto.
- Incluye el título de la página.
- Incluye la URL.
- Incluye la fecha de consulta.
- Indica qué parte de la información has utilizado.
- No copies configuraciones sin comprenderlas.
- No presentes como propia una solución tomada de otra fuente.

### Ejemplo de referencia

```text
Prometheus Authors.
Prometheus documentation: Querying basics.
https://prometheus.io/docs/prometheus/latest/querying/basics/
Consulta realizada el 25/09/2026.
Utilizada para revisar selectores y tipos de datos de PromQL.
```

## Recursos recomendados por tema

| Tema | Recurso principal |
|---|---|
| Administración de Ubuntu | [Ubuntu Server documentation](https://documentation.ubuntu.com/server/) |
| Manuales de comandos | [Ubuntu Manpages](https://manpages.ubuntu.com/) |
| Dashboards | [Grafana dashboards](https://grafana.com/docs/grafana/latest/dashboards/) |
| Paneles | [Grafana visualizations](https://grafana.com/docs/grafana/latest/visualizations/) |
| Variables | [Grafana variables](https://grafana.com/docs/grafana/latest/dashboards/variables/) |
| Alertas | [Grafana alerting](https://grafana.com/docs/grafana/latest/alerting/) |
| Prometheus | [Prometheus documentation](https://prometheus.io/docs/) |
| PromQL | [Prometheus querying basics](https://prometheus.io/docs/prometheus/latest/querying/basics/) |
| API de Prometheus | [Prometheus HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/) |
| Node Exporter | [Node Exporter repository](https://github.com/prometheus/node_exporter) |
| Alertmanager | [Alertmanager documentation](https://prometheus.io/docs/alerting/latest/alertmanager/) |
| Git | [Git documentation](https://git-scm.com/doc) |
| GitHub Actions | [GitHub Actions documentation](https://docs.github.com/en/actions) |
| GitHub Pages | [GitHub Pages documentation](https://docs.github.com/en/pages) |
| MkDocs | [MkDocs documentation](https://www.mkdocs.org/) |
| Material for MkDocs | [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) |
| HTTP y redes | [MDN HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP) |
| curl | [curl documentation](https://curl.se/docs/) |

## Puntos clave

- La documentación oficial debe ser la primera fuente de consulta.
- Comprueba siempre la versión del software.
- Verifica que la solución corresponde al sistema utilizado.
- No mezcles instrucciones de Ubuntu, Docker y Kubernetes sin comprobar sus diferencias.
- Utiliza los manuales locales para consultar comandos.
- Prometheus ofrece documentación específica para PromQL, configuración y API.
- Grafana dispone de documentación específica para dashboards, variables y alertas.
- Node Exporter se documenta principalmente en su repositorio oficial.
- MkDocs Material tiene su propia documentación de configuración y extensiones.
- GitHub Actions y GitHub Pages tienen documentación independiente.
- Una buena investigación técnica debe ser reproducible.
- No ejecutes comandos destructivos sin comprenderlos.
- No compartas credenciales, tokens ni secretos.
- Documenta la URL y la fecha de consulta.
- Comprueba las soluciones en un entorno de laboratorio.
- Las fuentes secundarias son útiles, pero deben contrastarse con las fuentes oficiales.
- Un informe técnico debe incluir el problema, las pruebas, la fuente, la solución y la validación.

## Preguntas de comprobación

1. ¿Cuál debe ser la primera fuente que se consulte ante un problema de Prometheus?
2. ¿Dónde consultarías la referencia oficial de PromQL?
3. ¿Dónde consultarías la documentación de las variables de Grafana?
4. ¿Qué recurso utilizarías para conocer las opciones de `systemctl`?
5. ¿Dónde consultarías las versiones disponibles de Node Exporter?
6. ¿Qué diferencia existe entre la documentación de GitHub Actions y la de GitHub Pages?
7. ¿Por qué es importante comprobar la versión del software?
8. ¿Qué información debes registrar al utilizar una fuente externa?
9. ¿Qué riesgos existen al ejecutar comandos encontrados en Internet?
10. ¿Cómo comprobarías que una solución encontrada en un blog es aplicable a Ubuntu 24.04?
11. ¿Qué fuente utilizarías para conocer el significado de un código HTTP?
12. ¿Qué documentación utilizarías para configurar un workflow?
13. ¿Qué información incluirías en un informe de incidencia?
14. ¿Por qué no se deben publicar tokens o contraseñas en un repositorio?
15. ¿Qué diferencia existe entre una fuente oficial y una fuente secundaria?
16. ¿Qué pasos seguirías para investigar un target de Prometheus que aparece como `DOWN`?
17. ¿Qué fuente consultarías para validar una configuración de Prometheus?
18. ¿Qué fuente consultarías para resolver un problema de un dashboard?
19. ¿Por qué es útil guardar la fecha de consulta de una documentación?
20. ¿Qué significa que una solución sea reproducible?