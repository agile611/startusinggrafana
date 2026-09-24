# Plugins de paneles

Los **plugins de paneles** amplían las capacidades de visualización de Grafana.

Grafana incluye varios tipos de paneles integrados, como:

- Stat.
- Gauge.
- Bar Gauge.
- Time series.
- Heatmap.
- Table.
- Text.
- Canvas.

Además, puede utilizar plugins adicionales para ofrecer visualizaciones especializadas o funciones que no están disponibles en los paneles estándar.

Los plugins permiten adaptar Grafana a diferentes necesidades:

- Monitorización de infraestructuras.
- Observabilidad de aplicaciones.
- Visualización de redes.
- Representación de topologías.
- Análisis de logs.
- Paneles ejecutivos.
- Mapas geográficos.
- Diagramas personalizados.
- Integración con otras plataformas.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Explicar qué es un plugin de Grafana.
- Diferenciar un plugin de panel de una fuente de datos.
- Consultar los plugins instalados.
- Buscar plugins disponibles.
- Instalar un plugin de panel.
- Actualizar un plugin.
- Deshabilitar un plugin.
- Eliminar un plugin.
- Reiniciar Grafana después de instalar un plugin.
- Crear un panel utilizando un plugin.
- Configurar las opciones básicas de un plugin.
- Comprobar la compatibilidad de un plugin.
- Identificar los riesgos de instalar plugins de terceros.
- Revisar los permisos y la firma de un plugin.
- Consultar los logs relacionados con plugins.
- Diagnosticar un panel que no carga correctamente.
- Exportar un dashboard que utiliza un plugin.
- Documentar las dependencias de un dashboard.
- Aplicar buenas prácticas de seguridad y mantenimiento.

---

# Introducción

Un plugin es un componente que añade funcionalidades a Grafana.

De forma conceptual:

```text
Grafana
   |
   +-- Paneles integrados
   |
   +-- Plugins de panel
   |
   +-- Plugins de fuentes de datos
   |
   +-- Plugins de aplicaciones
   |
   +-- Plugins de autenticación o integración
```

En esta sección se estudiarán principalmente los **plugins de paneles**.

Un plugin de panel puede proporcionar una visualización especializada que recibe datos desde una fuente de datos y los representa de una forma concreta.

El flujo general es:

```text
Fuente de datos
       |
       v
Consulta
       |
       v
Resultado
       |
       v
Plugin de panel
       |
       v
Visualización
```

Ejemplo:

```text
Prometheus
    |
    v
Consulta PromQL
    |
    v
Métricas de CPU
    |
    v
Plugin de panel
    |
    v
Visualización personalizada
```

---

# Tipos de plugins de Grafana

Grafana puede utilizar diferentes categorías de plugins.

## Plugins de panel

Añaden visualizaciones.

Ejemplos de funciones:

- Diagramas.
- Mapas.
- Indicadores personalizados.
- Gráficos especializados.
- Visualizaciones de relaciones.
- Paneles con HTML o SVG.
- Representaciones geográficas.

## Plugins de fuentes de datos

Permiten consultar sistemas externos.

Ejemplos:

- Prometheus.
- Loki.
- InfluxDB.
- Elasticsearch.
- PostgreSQL.
- MySQL.
- Microsoft SQL Server.

## Plugins de aplicación

Añaden funcionalidades más amplias, como:

- Páginas personalizadas.
- Integraciones.
- Configuración adicional.
- Vistas de aplicación.
- Flujos de trabajo.

## Plugins de autenticación

Permiten integrar Grafana con mecanismos externos de autenticación.

Ejemplos conceptuales:

- Proveedores de identidad.
- Directorios corporativos.
- Sistemas de autenticación externos.

En esta unidad se trabajará principalmente con:

```text
Plugins de panel
```

---

# Plugins integrados y plugins externos

## Plugins integrados

Son los paneles disponibles en la instalación estándar de Grafana.

Ejemplos:

```text
Stat
Gauge
Bar Gauge
Time series
Table
Text
Canvas
Heatmap
```

Ventajas:

- Suelen estar probados con la versión instalada.
- No requieren instalaciones adicionales.
- Tienen una integración directa con Grafana.
- Reciben mantenimiento dentro del ciclo de Grafana.

## Plugins externos

Son desarrollados y distribuidos fuera del conjunto principal de Grafana.

Pueden aportar:

- Visualizaciones adicionales.
- Integraciones específicas.
- Funciones experimentales.
- Representaciones especializadas.
- Soporte para necesidades concretas.

Antes de utilizarlos se debe revisar:

- Compatibilidad.
- Mantenimiento.
- Licencia.
- Procedencia.
- Firma.
- Versión requerida.
- Permisos.
- Dependencias.
- Documentación.
- Historial de actualizaciones.

---

# Cuándo utilizar un plugin de panel

Un plugin puede ser útil cuando:

- Ningún panel integrado representa correctamente los datos.
- Se necesita una visualización especializada.
- Se requiere un diagrama personalizado.
- Se desea utilizar un mapa.
- Se necesita representar una topología.
- Se requiere un tipo específico de gráfico.
- El equipo ya utiliza un plugin aprobado.
- La visualización aporta información operativa real.

## Ejemplos

### Mapa geográfico

Representar:

```text
Disponibilidad de servicios por ubicación.
```

### Diagrama de red

Representar:

```text
Routers, switches, servidores y conexiones.
```

### Visualización especializada

Representar:

```text
Distribuciones, relaciones o indicadores personalizados.
```

### Panel operativo

Representar:

```text
Estado de un servicio mediante una vista diseñada para un equipo concreto.
```

---

# Cuándo no utilizar un plugin

No conviene instalar un plugin cuando:

- Un panel integrado ya resuelve el problema.
- El plugin está abandonado.
- No existe documentación.
- No se conoce su procedencia.
- Requiere permisos excesivos.
- No es compatible con la versión de Grafana.
- Añade complejidad sin aportar información.
- El dashboard debe ser fácilmente portable.
- Se necesita mantener una instalación mínima.

## Regla práctica

Antes de instalar un plugin, comprobar si el resultado puede conseguirse con:

- Un panel integrado.
- Una consulta PromQL mejor diseñada.
- Una transformación.
- Un panel Canvas.
- Un panel Text.
- Variables de dashboard.
- Un enlace a otro dashboard.

Instalar plugins no debe convertirse en el equivalente técnico de comprar otra taza para una cocina ya llena de tazas.

---

# Buscar plugins

Desde la interfaz de Grafana se puede consultar el catálogo de plugins disponible para la instalación.

Procedimiento general:

1. Iniciar sesión en Grafana.
2. Acceder a la sección de administración.
3. Abrir la sección de plugins.
4. Buscar por nombre o categoría.
5. Revisar la descripción.
6. Revisar la versión.
7. Revisar el estado de firma.
8. Revisar la compatibilidad.
9. Revisar la documentación.
10. Confirmar si el plugin es adecuado.

La ubicación exacta de las opciones puede variar según:

- La versión de Grafana.
- El rol del usuario.
- La edición instalada.
- La configuración administrativa.
- El método de instalación.

---

# Información que se debe revisar

Antes de instalar un plugin, revisar:

## Nombre

Confirmar que corresponde al plugin esperado.

## Identificador

Los plugins tienen un identificador único.

Ejemplo conceptual:

```text
fabric-panel-plugin
```

El identificador se utiliza a menudo en comandos y configuraciones.

## Versión

Comprobar:

```text
Versión instalada
Versión disponible
Versión mínima de Grafana
```

## Firma

Determinar si el plugin está:

```text
Firmado
No firmado
Firmado por un proveedor
Firmado por la comunidad
```

## Compatibilidad

Comprobar:

- Versión de Grafana.
- Sistema operativo.
- Arquitectura.
- Navegador.
- Fuente de datos.
- Tipo de consultas.
- Dependencias.

## Mantenimiento

Revisar:

- Fecha de la última actualización.
- Frecuencia de versiones.
- Problemas abiertos.
- Documentación.
- Actividad del proyecto.
- Soporte disponible.

## Permisos

Revisar qué permisos solicita el plugin.

Un plugin de panel no debería recibir permisos innecesarios.

---

# Instalar un plugin desde la interfaz

El procedimiento general es:

1. Acceder a la administración de Grafana.
2. Abrir la sección de plugins.
3. Buscar el plugin.
4. Abrir su ficha.
5. Revisar la información.
6. Seleccionar la opción de instalación.
7. Confirmar la operación.
8. Reiniciar Grafana si es necesario.
9. Comprobar que el plugin aparece disponible.
10. Crear un panel de prueba.

La instalación puede requerir permisos administrativos.

---

# Instalar un plugin desde la línea de comandos

Grafana proporciona una herramienta administrativa para gestionar plugins.

El comando habitual es:

```bash
grafana-cli plugins install ID_DEL_PLUGIN
```

En instalaciones recientes, la ruta y el nombre del comando pueden variar según el paquete y la distribución.

Ejemplo conceptual:

```bash
grafana-cli plugins install ejemplo-panel-plugin
```

Después de instalarlo, normalmente se reinicia Grafana:

```bash
sudo systemctl restart grafana-server
```

Comprobar el estado:

```bash
sudo systemctl status grafana-server
```

Comprobar los logs:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

## Precauciones

- Sustituir `ID_DEL_PLUGIN` por un identificador verificado.
- No copiar comandos de fuentes desconocidas.
- Revisar la versión de Grafana.
- Crear una copia de seguridad antes de modificar producción.
- Probar primero en laboratorio.

---

# Directorios habituales de plugins

La ubicación depende del método de instalación y del sistema operativo.

Una ubicación habitual es:

```text
/var/lib/grafana/plugins
```

Comprobar el contenido:

```bash
sudo ls -lah /var/lib/grafana/plugins
```

También puede ser necesario revisar la configuración de Grafana:

```bash
sudo grep -R "plugins" /etc/grafana/ 2>/dev/null
```

El directorio puede estar configurado mediante:

```text
data
plugins
paths
```

No se debe asumir que todas las instalaciones utilizan la misma ruta.

---

# Instalar un plugin manualmente

La instalación manual puede consistir en:

1. Descargar el paquete desde una fuente confiable.
2. Verificar su integridad.
3. Extraerlo en el directorio de plugins.
4. Revisar permisos.
5. Reiniciar Grafana.
6. Comprobar los logs.
7. Confirmar que el plugin aparece en la interfaz.

Ejemplo conceptual:

```bash
sudo mkdir -p /var/lib/grafana/plugins
sudo tar -xzf plugin.tar.gz \
  -C /var/lib/grafana/plugins
```

Ajustar propietario y permisos según la instalación:

```bash
sudo chown -R grafana:grafana \
  /var/lib/grafana/plugins
```

Reiniciar:

```bash
sudo systemctl restart grafana-server
```

## Precaución

La instalación manual requiere más control y más comprobaciones que la instalación desde el catálogo.

No instalar archivos descargados de ubicaciones no verificadas.

---

# Plugins no firmados

Grafana puede bloquear plugins no firmados por razones de seguridad.

En entornos de laboratorio puede habilitarse explícitamente un plugin concreto, según la configuración soportada por la versión instalada.

Una configuración conceptual puede tener este aspecto:

```ini
[plugins]
allow_loading_unsigned_plugins = ID_DEL_PLUGIN
```

Después de modificar la configuración:

```bash
sudo systemctl restart grafana-server
```

## Advertencias

Permitir plugins no firmados:

- Reduce las garantías de integridad.
- Puede introducir código no verificado.
- Puede incumplir las políticas de seguridad.
- No debería realizarse en producción sin una revisión formal.
- Debe limitarse al identificador estrictamente necesario.

No utilizar una configuración genérica que permita cualquier plugin.

---

# Comprobar que un plugin está instalado

Desde la interfaz:

1. Abrir la sección de plugins.
2. Buscar el nombre.
3. Revisar el estado.
4. Comprobar la versión.
5. Crear un panel nuevo.
6. Buscar el tipo de visualización.

Desde la terminal:

```bash
grafana-cli plugins ls
```

También se puede revisar el directorio:

```bash
sudo find /var/lib/grafana/plugins \
  -maxdepth 1 \
  -mindepth 1 \
  -type d \
  -printf "%f\n" \
  | sort
```

Consultar logs:

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

---

# Actualizar un plugin

Antes de actualizar:

1. Revisar la nueva versión.
2. Comprobar compatibilidad.
3. Consultar cambios importantes.
4. Exportar dashboards que dependan del plugin.
5. Probar en laboratorio.
6. Programar una ventana de mantenimiento.
7. Actualizar.
8. Reiniciar Grafana si es necesario.
9. Revisar los dashboards.
10. Comprobar los logs.

Comando conceptual:

```bash
grafana-cli plugins update ID_DEL_PLUGIN
```

Después:

```bash
sudo systemctl restart grafana-server
```

## Comprobaciones posteriores

- El plugin aparece instalado.
- Los paneles siguen cargando.
- Las consultas siguen funcionando.
- Las opciones no han cambiado.
- Las transformaciones se conservan.
- Los enlaces funcionan.
- La exportación sigue siendo válida.

---

# Deshabilitar un plugin

Deshabilitar un plugin puede ser útil cuando:

- Está causando errores.
- Se necesita realizar una prueba.
- Se sospecha que afecta al rendimiento.
- Se quiere impedir su uso temporalmente.
- Se prepara una retirada.

El procedimiento depende de la versión de Grafana y del método de administración.

Antes de deshabilitarlo:

- Identificar los dashboards afectados.
- Exportar una copia.
- Informar a los usuarios.
- Registrar la modificación.
- Tener un procedimiento de recuperación.

---

# Eliminar un plugin

Antes de eliminar un plugin:

1. Buscar dashboards que lo utilizan.
2. Exportar esos dashboards.
3. Sustituir los paneles dependientes.
4. Confirmar que no quedan usuarios.
5. Detener o reiniciar Grafana según el procedimiento.
6. Eliminar el plugin.
7. Revisar los logs.
8. Comprobar que Grafana inicia correctamente.

## Localizar referencias en dashboards exportados

Si existen ficheros JSON:

```bash
grep -R "ID_DEL_PLUGIN" \
  ~/laboratorio-grafana/dashboards/
```

También puede utilizarse:

```bash
jq '.. | strings | select(contains("ID_DEL_PLUGIN"))' \
  dashboard.json
```

## Advertencia

Eliminar un plugin no convierte automáticamente sus paneles en paneles estándar.

Los dashboards que dependan de él pueden mostrar:

```text
Panel plugin not found
```

---

# Dependencias de un dashboard

Un dashboard puede depender de:

- Un plugin de panel.
- Una fuente de datos.
- Una variable.
- Una transformación.
- Unidades específicas.
- Unidades personalizadas.
- Un enlace externo.
- Una imagen.
- Un sistema de autenticación.
- Una versión concreta de Grafana.

## Ejemplo de documentación

```markdown
## Dependencias

- Grafana: versión compatible con el dashboard.
- Fuente de datos: Prometheus.
- Plugin de panel: `ejemplo-panel-plugin`.
- Versión del plugin: `1.2.0`.
- Variables: `instance`, `job`.
- Transformaciones: `Labels to fields`, `Join by field`.
```

Documentar estas dependencias facilita:

- Migraciones.
- Copias de seguridad.
- Recuperación.
- Formación.
- Resolución de incidencias.

---

# Exportar un dashboard que utiliza un plugin

Al exportar un dashboard, la definición del panel puede conservar:

- Identificador del plugin.
- Configuración.
- Opciones.
- Consultas.
- Transformaciones.
- Umbrales.
- Enlaces.

Sin embargo, exportar el dashboard no siempre incluye el código del plugin.

En el sistema destino puede ser necesario:

1. Instalar el mismo plugin.
2. Utilizar una versión compatible.
3. Configurar la fuente de datos.
4. Importar el dashboard.
5. Revisar cada panel.

## Proceso recomendado

```text
Exportar dashboard
        |
        v
Documentar dependencias
        |
        v
Instalar plugin en destino
        |
        v
Configurar fuente de datos
        |
        v
Importar dashboard
        |
        v
Probar paneles
```

---

# Diagnóstico de plugins

Cuando un panel basado en un plugin no funciona, revisar en este orden:

```text
1. Plugin instalado.
2. Plugin habilitado.
3. Versión compatible.
4. Firma y permisos.
5. Fuente de datos disponible.
6. Consulta válida.
7. Variables correctas.
8. Transformaciones compatibles.
9. Logs de Grafana.
10. Compatibilidad del navegador.
```

## Comprobar el panel

Revisar si aparece:

```text
Plugin not found
Panel plugin not found
Plugin failed to load
Unknown panel type
Error loading plugin
```

## Revisar logs

```bash
sudo journalctl -u grafana-server \
  --since "30 minutes ago" \
  --no-pager
```

Filtrar por términos:

```bash
sudo journalctl -u grafana-server \
  --since "30 minutes ago" \
  --no-pager \
  | grep -Ei "plugin|panel|error|signature"
```

---

# Problemas habituales

## El plugin no aparece en la lista

Comprobar:

- Instalación finalizada.
- Identificador correcto.
- Directorio de plugins.
- Permisos.
- Reinicio de Grafana.
- Logs.
- Compatibilidad de versión.
- Firma del plugin.

## Aparece “Plugin not found”

Posibles causas:

- El plugin no está instalado.
- Se eliminó el plugin.
- El identificador ha cambiado.
- El dashboard se importó en otra instancia.
- La versión no reconoce el plugin.

Solución general:

1. Identificar el plugin.
2. Instalar una versión compatible.
3. Reiniciar Grafana.
4. Volver a abrir el dashboard.

## El plugin aparece, pero el panel está vacío

Comprobar:

- Fuente de datos.
- Consulta.
- Variables.
- Rango temporal.
- Formato esperado.
- Transformaciones.
- Opciones específicas del plugin.

## El plugin provoca errores en Grafana

Revisar:

- Logs.
- Compatibilidad.
- Dependencias.
- Arquitectura.
- Permisos.
- Versión de Node o runtime, si aplica.
- Documentación del proveedor.

En laboratorio se puede deshabilitar temporalmente para aislar el problema.

## El plugin no está firmado

No habilitarlo automáticamente en producción.

Revisar:

- Procedencia.
- Código fuente.
- Reputación.
- Firma disponible.
- Política de seguridad.
- Necesidad real.
- Alcance de la configuración.

## El panel cambia después de actualizar

Posibles causas:

- Cambios de configuración.
- Campos renombrados.
- Opciones eliminadas.
- Transformaciones incompatibles.
- Cambios en el formato de datos.
- Cambios en la consulta.
- Cambios en la unidad.

Comparar:

- Versión anterior.
- Versión nueva.
- Exportación JSON.
- Documentación de cambios.

## El dashboard no se puede importar

Comprobar:

- Plugin instalado.
- Versión compatible.
- Fuentes de datos.
- Variables.
- Transformaciones.
- Permisos.
- Identificadores de panel.

---

# Seguridad de los plugins

Los plugins son software que se ejecuta o se integra con Grafana.

Por ello deben tratarse como componentes de la plataforma.

## Buenas prácticas

- Instalar plugins desde fuentes confiables.
- Revisar firmas.
- Mantenerlos actualizados.
- Aplicar el principio de mínimo privilegio.
- Probar antes en laboratorio.
- Documentar versiones.
- Revisar cambios.
- Limitar plugins no firmados.
- Eliminar plugins no utilizados.
- Supervisar los logs.
- Mantener copias de seguridad.
- No instalar plugins por recomendación no verificada.

## En producción

Antes de instalar un plugin:

```text
1. Solicitar aprobación.
2. Revisar seguridad.
3. Probar compatibilidad.
4. Evaluar impacto.
5. Documentar el cambio.
6. Planificar reversión.
7. Aplicar en una ventana controlada.
```

---

# Rendimiento

Un plugin puede afectar al rendimiento de:

- El navegador.
- Grafana.
- Prometheus.
- La red.
- La experiencia del usuario.

## Factores que pueden aumentar el coste

- Muchas consultas.
- Muchas series.
- Imágenes grandes.
- Actualización frecuente.
- Transformaciones complejas.
- Código poco optimizado.
- Paneles muy grandes.
- Uso simultáneo por muchos usuarios.

## Recomendaciones

- Limitar el número de paneles.
- Limitar la cantidad de series.
- Utilizar rangos temporales razonables.
- Utilizar filtros PromQL.
- Reducir la frecuencia de actualización.
- Evitar imágenes innecesariamente grandes.
- Medir el rendimiento antes y después.

---

# Plugins y permisos de usuario

No todos los usuarios deben poder:

- Instalar plugins.
- Actualizar plugins.
- Eliminar plugins.
- Configurar plugins.
- Administrar Grafana.

## Separación de responsabilidades

| Rol | Acceso habitual |
|---|---|
| Viewer | Utilizar dashboards |
| Editor | Modificar paneles |
| Admin | Gestionar configuración y plugins |

La configuración exacta depende de la organización y de la versión de Grafana.

## Recomendación

Limitar la administración de plugins a usuarios responsables de la plataforma.

---

# Ejemplo completo 1: documentar un plugin de panel

## Contenido recomendado

```markdown
# Plugin de panel utilizado

## Identificador

```text
ejemplo-panel-plugin
```

## Versión

```text
1.2.0
```

## Finalidad

Representar visualmente la distribución de estados
de los servicios monitorizados.

## Fuente de datos

```text
Prometheus
```

## Dashboards dependientes

- Resumen de infraestructura.
- Estado de aplicaciones.

## Requisitos

- Grafana compatible.
- Prometheus configurado.
- Variables `instance` y `job`.

## Mantenimiento

Revisar la compatibilidad antes de actualizar Grafana.
```

---

# Ejemplo completo 2: instalar un plugin en laboratorio

## Objetivo

Practicar el proceso de instalación de un plugin sin afectar a producción.

## Pasos conceptuales

1. Consultar el catálogo.
2. Seleccionar un plugin aprobado para el laboratorio.
3. Anotar su identificador.
4. Revisar la documentación.
5. Revisar la versión de Grafana.
6. Exportar los dashboards existentes.
7. Instalar el plugin.
8. Reiniciar Grafana.
9. Revisar los logs.
10. Crear un panel de prueba.
11. Guardar el resultado.
12. Documentar la instalación.

## Comandos de comprobación

```bash
grafana-cli plugins ls
```

```bash
sudo systemctl restart grafana-server
```

```bash
sudo systemctl status grafana-server
```

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

## Actividades

1. Identifica el plugin instalado.
2. Anota su versión.
3. Comprueba su estado.
4. Crea un panel.
5. Selecciona el plugin.
6. Utiliza una consulta de Prometheus.
7. Documenta las opciones disponibles.

---

# Ejemplo completo 3: crear un panel con un plugin

## Objetivo

Utilizar un plugin de panel para mostrar una métrica.

## Consulta

```promql
100 * avg(up)
```

## Pasos

1. Crear un dashboard de laboratorio.
2. Añadir un panel.
3. Seleccionar el plugin instalado.
4. Seleccionar Prometheus.
5. Introducir la consulta.
6. Configurar la unidad como porcentaje.
7. Configurar los umbrales.
8. Revisar la visualización.
9. Guardar el panel.
10. Guardar el dashboard.

## Actividades

1. Cambia la consulta a:

```promql
100 - (
  avg(
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

2. Cambia la unidad.
3. Prueba una variable de instancia.
4. Exporta el dashboard.
5. Documenta la dependencia del plugin.

---

# Ejemplo de sesión 1: inventario de plugins

## Objetivo

Identificar los plugins disponibles en una instalación de Grafana.

## Pasos

1. Abrir Grafana.
2. Acceder a la sección de plugins.
3. Revisar los paneles integrados.
4. Revisar los plugins externos.
5. Anotar:
   - Nombre.
   - Identificador.
   - Versión.
   - Estado.
   - Firma.
6. Comparar la lista con la salida de:

```bash
grafana-cli plugins ls
```

## Actividades

Crear una tabla:

| Nombre | Identificador | Versión | Firmado | Uso |
|---|---|---:|---|---|
| | | | | |

Responder:

1. ¿Qué plugins están instalados?
2. ¿Cuáles son paneles?
3. ¿Cuáles son fuentes de datos?
4. ¿Hay plugins no utilizados?
5. ¿Hay plugins pendientes de actualización?

---

# Ejemplo de sesión 2: instalar y comprobar un plugin

## Objetivo

Instalar un plugin aprobado para el laboratorio.

## Pasos

1. Seleccionar el plugin.
2. Revisar la documentación.
3. Anotar el identificador.
4. Exportar los dashboards.
5. Ejecutar la instalación:

```bash
grafana-cli plugins install ID_DEL_PLUGIN
```

6. Reiniciar Grafana:

```bash
sudo systemctl restart grafana-server
```

7. Comprobar el estado:

```bash
sudo systemctl status grafana-server
```

8. Revisar los logs:

```bash
sudo journalctl -u grafana-server \
  --since "10 minutes ago" \
  --no-pager
```

9. Confirmar que aparece en Grafana.
10. Crear un panel de prueba.

## Actividades

1. Anota el resultado de cada paso.
2. Comprueba la versión instalada.
3. Comprueba si requiere una fuente de datos concreta.
4. Crea una captura del panel.
5. Completa el informe de instalación.

---

# Ejemplo de sesión 3: probar la compatibilidad

## Objetivo

Comprobar que un plugin funciona con una consulta Prometheus.

## Consulta inicial

```promql
up
```

## Pasos

1. Crear un panel con el plugin.
2. Ejecutar la consulta.
3. Comprobar que muestra datos.
4. Cambiar la consulta a:

```promql
node_load1
```

5. Comprobar el cambio de unidad.
6. Cambiar la consulta a:

```promql
100 * avg(up)
```

7. Configurar umbrales.
8. Probar una variable.
9. Guardar el panel.

## Actividades

1. ¿Qué tipos de datos acepta el plugin?
2. ¿Permite varias series?
3. ¿Admite transformaciones?
4. ¿Permite variables?
5. ¿Permite enlaces?
6. ¿Qué opciones son específicas del plugin?

---

# Ejemplo de sesión 4: actualizar un plugin

## Objetivo

Practicar una actualización controlada.

## Pasos

1. Consultar la versión instalada:

```bash
grafana-cli plugins ls
```

2. Exportar el dashboard.
3. Anotar la versión actual.
4. Revisar la versión disponible.
5. Consultar cambios importantes.
6. Actualizar:

```bash
grafana-cli plugins update ID_DEL_PLUGIN
```

7. Reiniciar Grafana:

```bash
sudo systemctl restart grafana-server
```

8. Revisar los logs.
9. Abrir el dashboard.
10. Comprobar el panel.
11. Comparar con la exportación anterior.

## Actividades

1. Documenta la versión anterior.
2. Documenta la versión nueva.
3. Comprueba las opciones.
4. Comprueba las consultas.
5. Comprueba los colores.
6. Comprueba las transformaciones.
7. Registra cualquier cambio.

---

# Ejemplo de sesión 5: simular una migración

## Objetivo

Importar un dashboard que utiliza un plugin en otra instancia de Grafana.

## Instancia origen

```text
Grafana A
```

## Instancia destino

```text
Grafana B
```

## Pasos

1. En Grafana A, identificar el plugin.
2. Exportar el dashboard.
3. Documentar la versión.
4. Instalar la misma versión en Grafana B.
5. Configurar Prometheus en Grafana B.
6. Importar el dashboard.
7. Seleccionar la fuente de datos.
8. Comprobar el panel.
9. Comparar las configuraciones.

## Actividades

1. Importa el dashboard sin instalar el plugin.
2. Documenta el error.
3. Instala el plugin.
4. Repite la importación.
5. Explica la diferencia.
6. Completa la tabla de dependencias.

---

# Ejemplo de sesión 6: diagnosticar un plugin ausente

## Objetivo

Resolver un dashboard que muestra un panel desconocido.

## Situación

El dashboard presenta:

```text
Panel plugin not found
```

## Procedimiento

1. Exportar el dashboard.
2. Abrir el JSON.
3. Localizar el identificador del panel.
4. Buscar el identificador en la instalación.
5. Consultar la lista de plugins:

```bash
grafana-cli plugins ls
```

6. Instalar una versión compatible.
7. Reiniciar Grafana.
8. Volver a abrir el dashboard.
9. Comprobar el panel.

## Actividades

Documentar:

```text
Identificador del plugin:
Versión requerida:
Versión instalada:
Error inicial:
Acción aplicada:
Resultado:
```

---

# Ejemplo de sesión 7: probar un plugin no firmado en laboratorio

## Objetivo

Comprender las implicaciones de un plugin no firmado.

## Advertencia

Esta actividad debe realizarse únicamente en un entorno aislado y autorizado.

## Pasos

1. Revisar el identificador del plugin.
2. Confirmar que la fuente es confiable.
3. Revisar el código o la documentación.
4. Añadir únicamente el identificador permitido a la configuración.
5. Reiniciar Grafana.
6. Revisar los logs.
7. Crear un panel de prueba.
8. Registrar la configuración.
9. Retirar el permiso al finalizar.
10. Reiniciar Grafana.

Configuración conceptual:

```ini
[plugins]
allow_loading_unsigned_plugins = ID_DEL_PLUGIN
```

## Actividades

1. Explica por qué se requiere una configuración especial.
2. Explica los riesgos.
3. Comprueba que el plugin funciona.
4. Elimina la autorización.
5. Comprueba el comportamiento posterior.
6. Documenta la reversión.

---

# Ejemplo de sesión 8: eliminar un plugin no utilizado

## Objetivo

Retirar un plugin después de comprobar que no existen dependencias.

## Pasos

1. Listar los plugins:

```bash
grafana-cli plugins ls
```

2. Identificar el plugin.
3. Buscar su identificador en dashboards exportados:

```bash
grep -R "ID_DEL_PLUGIN" \
  ~/laboratorio-grafana/dashboards/
```

4. Exportar los dashboards afectados.
5. Sustituir los paneles dependientes.
6. Eliminar el plugin mediante el procedimiento aprobado.
7. Reiniciar Grafana.
8. Revisar los logs.
9. Comprobar los dashboards.
10. Documentar la retirada.

## Actividades

1. Identifica qué dashboards dependían del plugin.
2. Registra cómo se sustituyeron.
3. Comprueba que Grafana funciona.
4. Verifica que no aparecen errores de plugin.

---

# Ejemplo de sesión 9: revisar rendimiento

## Objetivo

Observar el impacto de un panel basado en un plugin.

## Pasos

1. Abrir el panel.
2. Utilizar un rango de una hora.
3. Observar el tiempo de carga.
4. Cambiar el rango a 24 horas.
5. Aumentar el número de series.
6. Reducir el número de series.
7. Comparar el comportamiento.
8. Revisar los logs.
9. Utilizar las herramientas del navegador si están disponibles.

## Actividades

1. ¿Cambia el tiempo de carga?
2. ¿Qué ocurre al mostrar más series?
3. ¿Qué parte del procesamiento realiza Grafana?
4. ¿Qué parte realiza Prometheus?
5. ¿Cómo reducirías la carga?

---

# Ejemplo de sesión 10: documentar una dependencia

## Objetivo

Crear documentación para que otro administrador pueda recuperar el dashboard.

## Contenido

```markdown
# Dependencias del dashboard

## Grafana

Versión probada:

```text
Indicar versión
```

## Plugin de panel

Identificador:

```text
ID_DEL_PLUGIN
```

Versión:

```text
Indicar versión
```

## Fuente de datos

```text
Prometheus
```

## Variables

```text
instance
job
```

## Transformaciones

```text
Labels to fields
Organize fields by name
Reduce
```

## Procedimiento de recuperación

1. Instalar Grafana.
2. Configurar Prometheus.
3. Instalar el plugin.
4. Comprobar la versión.
5. Importar el dashboard.
6. Seleccionar la fuente de datos.
7. Revisar las variables.
8. Probar el panel.
```

## Actividades

1. Completa la documentación.
2. Exporta el dashboard.
3. Entrega el JSON junto con la documentación.
4. Comprueba que otra persona puede reproducir el entorno.

---

# Gestión de plugins mediante configuración

Grafana puede tener opciones relacionadas con plugins en su fichero de configuración.

La ubicación depende de la instalación.

Una ruta habitual es:

```text
/etc/grafana/grafana.ini
```

Consultar parámetros relacionados:

```bash
sudo grep -n "\[plugins\]" \
  /etc/grafana/grafana.ini
```

Consultar la sección:

```bash
sudo sed -n '/^\[plugins\]/,/^\[/p' \
  /etc/grafana/grafana.ini
```

Las opciones pueden incluir:

- Directorio de plugins.
- Plugins permitidos.
- Plugins no firmados.
- Configuración de actualizaciones.
- Opciones de carga.

No modificar la configuración sin:

- Copia de seguridad.
- Registro del cambio.
- Revisión de sintaxis.
- Plan de reversión.
- Reinicio controlado.

---

# Plugins y archivos JSON

Un dashboard exportado puede incluir referencias como:

```json
{
  "type": "ID_DEL_PLUGIN",
  "title": "Panel personalizado"
}
```

El campo `type` identifica el tipo de panel.

Para localizar paneles de un plugin:

```bash
jq '.. | objects | select(.type? == "ID_DEL_PLUGIN")' \
  dashboard.json
```

Buscar referencias de forma general:

```bash
grep -n "ID_DEL_PLUGIN" dashboard.json
```

## Actividades

1. Exporta un dashboard con un plugin.
2. Busca su identificador.
3. Localiza su configuración.
4. Identifica las consultas.
5. Comprueba las opciones específicas.
6. Documenta los campos relevantes.

---

# Buenas prácticas de ciclo de vida

## Antes de instalar

```text
1. Definir la necesidad.
2. Comprobar si existe una alternativa integrada.
3. Revisar el plugin.
4. Comprobar compatibilidad.
5. Evaluar seguridad.
6. Probar en laboratorio.
```

## Durante la instalación

```text
1. Registrar versión.
2. Registrar identificador.
3. Revisar permisos.
4. Instalar desde una fuente confiable.
5. Reiniciar según el procedimiento.
6. Revisar logs.
```

## Durante la operación

```text
1. Supervisar errores.
2. Revisar compatibilidad.
3. Mantener dashboards documentados.
4. Controlar actualizaciones.
5. Revisar rendimiento.
```

## Antes de eliminar

```text
1. Buscar dependencias.
2. Exportar dashboards.
3. Sustituir paneles.
4. Informar a los usuarios.
5. Ejecutar la retirada.
6. Verificar el resultado.
```

---

# Evidencias de la práctica

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/plugins-paneles
```

Guardar el inventario:

```bash
grafana-cli plugins ls \
  > ~/laboratorio-grafana/evidencias/plugins-paneles/plugins.txt
```

Guardar información del servicio:

```bash
systemctl status grafana-server --no-pager \
  > ~/laboratorio-grafana/evidencias/plugins-paneles/grafana-status.txt
```

Guardar logs recientes:

```bash
sudo journalctl -u grafana-server \
  --since "30 minutes ago" \
  --no-pager \
  > ~/laboratorio-grafana/evidencias/plugins-paneles/grafana-logs.txt
```

Guardar la documentación del plugin:

```bash
cat > ~/laboratorio-grafana/evidencias/plugins-paneles/plugin.txt <<'EOF'
Plugin utilizado:

Identificador:

Versión:

Tipo:
Panel

Fuente de instalación:

Estado de firma:

Versión de Grafana:

Dashboards dependientes:

Problemas encontrados:

Soluciones aplicadas:
EOF
```

Guardar un informe:

```bash
cat > ~/laboratorio-grafana/evidencias/plugins-paneles/informe.txt <<'EOF'
Práctica: Plugins de paneles

Plugin utilizado:

Identificador:

Versión inicial:

Versión final:

Instalación realizada:
- Interfaz
- Línea de comandos
- Manual

Paneles creados:

Consultas utilizadas:

Transformaciones utilizadas:

Actualización realizada:

Problemas encontrados:

Soluciones aplicadas:

Revisión de seguridad:

Conclusiones:
EOF
```

Capturas recomendadas:

```text
01-lista-plugins.png
02-detalle-plugin.png
03-plugin-instalado.png
04-panel-plugin.png
05-panel-configurado.png
06-error-plugin-ausente.png
07-plugin-recuperado.png
08-dashboard-final.png
```

---

# Práctica integradora

## Objetivo

Instalar, utilizar, documentar y mantener un plugin de panel en un entorno de laboratorio.

## Requisitos

Utilizar un plugin aprobado por el instructor.

Registrar:

```text
Identificador
Versión
Tipo
Firma
Compatibilidad
Fuente de instalación
```

## Tareas

1. Consultar los plugins instalados.
2. Seleccionar un plugin de panel.
3. Revisar su documentación.
4. Comprobar su compatibilidad.
5. Exportar los dashboards actuales.
6. Instalar el plugin.
7. Reiniciar Grafana.
8. Revisar los logs.
9. Crear un panel de prueba.
10. Utilizar una consulta Prometheus.
11. Configurar la unidad.
12. Configurar colores o umbrales.
13. Añadir una variable.
14. Añadir una transformación si es compatible.
15. Guardar el panel.
16. Exportar el dashboard.
17. Importar una copia en otra instancia o carpeta.
18. Comprobar la dependencia del plugin.
19. Actualizar el plugin en laboratorio.
20. Comparar el comportamiento.
21. Documentar la actualización.
22. Desinstalarlo o dejarlo documentado según las instrucciones del curso.

---

# Tabla de resultados

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Plugin localizado | | |
| Identificador comprobado | | |
| Versión registrada | | |
| Firma revisada | | |
| Compatibilidad comprobada | | |
| Dashboard exportado | | |
| Plugin instalado | | |
| Grafana reiniciado | | |
| Logs revisados | | |
| Panel de prueba creado | | |
| Consulta configurada | | |
| Unidad configurada | | |
| Variables comprobadas | | |
| Transformaciones comprobadas | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Actualización realizada | | |
| Dependencias documentadas | | |
| Plugin retirado o mantenido | | |
| Evidencias guardadas | | |

---

# Puntos clave

- Un plugin amplía las capacidades de Grafana.
- Los plugins de panel añaden nuevas visualizaciones.
- Los plugins de fuentes de datos permiten consultar sistemas externos.
- Los plugins de aplicación ofrecen funciones más amplias.
- Los plugins integrados suelen requerir menos mantenimiento.
- Los plugins externos deben revisarse antes de instalarse.
- La firma, la procedencia y la compatibilidad son aspectos importantes.
- Un plugin puede requerir una versión concreta de Grafana.
- Después de instalar un plugin puede ser necesario reiniciar Grafana.
- Los logs ayudan a diagnosticar errores de carga.
- Un dashboard exportado no incluye necesariamente el código del plugin.
- Para restaurar un dashboard se debe instalar el plugin compatible.
- Los plugins no firmados deben limitarse a entornos controlados.
- No se deben permitir plugins no firmados de forma genérica.
- Antes de actualizar un plugin conviene exportar los dashboards dependientes.
- Antes de eliminar un plugin hay que localizar sus dependencias.
- Los plugins pueden afectar al rendimiento.
- Los usuarios deben disponer únicamente de los permisos necesarios.
- Las dependencias deben documentarse junto al dashboard.
- Un plugin debe utilizarse cuando aporta valor real.
- Un panel integrado puede ser preferible por simplicidad y portabilidad.
- La gestión de plugins forma parte de la administración de Grafana.

---

# Preguntas de comprobación

1. ¿Qué es un plugin de Grafana?
2. ¿Qué diferencia existe entre un plugin de panel y un plugin de fuente de datos?
3. ¿Qué ventajas ofrecen los plugins integrados?
4. ¿Qué riesgos pueden tener los plugins externos?
5. ¿Qué información revisarías antes de instalar un plugin?
6. ¿Qué es el identificador de un plugin?
7. ¿Qué significa que un plugin esté firmado?
8. ¿Por qué es importante comprobar la compatibilidad?
9. ¿Qué pasos realizarías después de instalar un plugin?
10. ¿Qué comando permite consultar los plugins instalados?
11. ¿Dónde buscarías los logs de Grafana?
12. ¿Qué puede ocurrir si se importa un dashboard sin instalar su plugin?
13. ¿Qué diferencia existe entre exportar un dashboard y exportar un plugin?
14. ¿Qué precauciones tomarías al habilitar un plugin no firmado?
15. ¿Qué pasos seguirías antes de actualizar un plugin?
16. ¿Qué pasos seguirías antes de eliminar un plugin?
17. ¿Cómo buscarías dashboards que dependan de un plugin?
18. ¿Qué factores pueden afectar al rendimiento de un plugin?
19. ¿Qué permisos deberían tener los usuarios que administran plugins?
20. ¿Qué información documentarías sobre una dependencia?
21. ¿Cómo diagnosticarías un mensaje `Plugin not found`?
22. ¿Qué comprobarías si el plugin aparece, pero el panel está vacío?
23. ¿Cuándo utilizarías un panel integrado en lugar de un plugin?
24. ¿Qué evidencias guardarías durante la práctica?
25. ¿Qué características debe cumplir un plugin apto para producción?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de gestionar plugins de paneles de forma controlada.

El proceso completo será:

```text
Definir la necesidad
        |
        v
Buscar una solución integrada
        |
        v
Evaluar el plugin
        |
        v
Comprobar seguridad y compatibilidad
        |
        v
Probar en laboratorio
        |
        v
Instalar y reiniciar
        |
        v
Crear un panel de prueba
        |
        v
Revisar logs y rendimiento
        |
        v
Documentar dependencias
        |
        v
Actualizar o retirar de forma controlada
```

El resultado final debe ser una instalación de Grafana en la que los plugins estén justificados, documentados, actualizados y gestionados con criterios de seguridad y mantenimiento.

Un plugin no debe instalarse únicamente porque su captura de pantalla sea llamativa. Debe resolver una necesidad concreta y poder mantenerse durante todo el ciclo de vida del dashboard.