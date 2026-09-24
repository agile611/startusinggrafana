# Lista de dashboards

La lista de dashboards es el espacio de Grafana desde el que se pueden localizar, crear, abrir, organizar, compartir y administrar los dashboards disponibles.

En un entorno de monitorización, la lista de dashboards permite pasar de una colección de paneles aislados a una estructura organizada de vistas operativas.

Un dashboard puede representar:

- El estado general de la infraestructura.
- La monitorización de un servidor.
- La disponibilidad de los servicios.
- El rendimiento de una aplicación.
- El consumo de recursos.
- Las alertas activas.
- El estado de una plataforma completa.

---

## Objetivos

Al finalizar esta sección, el alumno podrá:

- Acceder a la lista de dashboards de Grafana.
- Crear un dashboard nuevo.
- Abrir y localizar dashboards existentes.
- Utilizar la búsqueda de dashboards.
- Organizar dashboards mediante carpetas.
- Marcar dashboards como favoritos.
- Consultar dashboards recientes.
- Compartir dashboards.
- Exportar dashboards en formato JSON.
- Importar dashboards previamente exportados.
- Copiar dashboards.
- Eliminar dashboards de forma controlada.
- Identificar los permisos básicos de un dashboard.
- Documentar la organización de los dashboards.
- Diferenciar entre dashboard, carpeta y panel.
- Aplicar una estructura coherente para un entorno de monitorización.

---

## Introducción

Grafana puede contener muchos dashboards. Si todos se almacenan en el mismo lugar y utilizan nombres poco descriptivos, localizar la información puede resultar complicado.

La sección **Dashboards** permite organizar estas vistas y acceder a ellas de forma rápida.

El flujo habitual es:

```text
Crear dashboard
       |
       v
Añadir paneles
       |
       v
Guardar dashboard
       |
       v
Asignar carpeta
       |
       v
Marcar como favorito
       |
       v
Compartir o exportar
```

La lista de dashboards no solo sirve para abrir una vista. También permite administrar su ciclo de vida:

```text
Crear → Editar → Compartir → Exportar → Importar → Actualizar → Eliminar
```

En un entorno pequeño puede bastar con unos pocos dashboards. En un entorno más grande conviene definir una organización clara desde el principio.

Ejemplo:

```text
Dashboards/
├── Infraestructura/
│   ├── Resumen general
│   ├── Servidores Linux
│   └── Almacenamiento
├── Aplicaciones/
│   ├── Aplicación web
│   └── Base de datos
├── Redes/
│   ├── Tráfico de red
│   └── Disponibilidad
└── Laboratorios/
    └── Laboratorio integrador
```

---

# Acceder a la lista de dashboards

Para acceder a la lista:

1. Iniciar sesión en Grafana.
2. Abrir el menú lateral.
3. Seleccionar **Dashboards**.
4. Abrir la opción de búsqueda o exploración de dashboards.

La interfaz puede mostrar secciones como:

- Dashboards recientes.
- Dashboards favoritos.
- Dashboards compartidos.
- Carpetas.
- Resultados de búsqueda.
- Dashboards creados por el usuario.
- Dashboards disponibles para el equipo.

La apariencia exacta puede variar según la versión de Grafana y el tema utilizado.

---

# Elementos principales

## Dashboard

Es una vista formada por uno o varios paneles.

Ejemplo:

```text
Monitorización de servidor Linux
```

Puede contener paneles de:

- Disponibilidad.
- CPU.
- Memoria.
- Disco.
- Red.
- Carga del sistema.

## Carpeta

Una carpeta agrupa dashboards relacionados.

Ejemplo:

```text
Infraestructura
```

Dentro de la carpeta se pueden almacenar:

```text
Servidores Linux
Servidores Windows
Almacenamiento
Monitorización de red
```

## Panel

Un panel es una visualización individual dentro de un dashboard.

Ejemplo:

```text
Uso de CPU
```

## Favorito

Un dashboard marcado como favorito aparece en una lista de acceso rápido.

Los favoritos son útiles para:

- Dashboards utilizados diariamente.
- Dashboards de producción.
- Dashboards de incidencias.
- Dashboards de supervisión principal.

## Etiqueta

Una etiqueta permite clasificar un dashboard mediante palabras clave.

Ejemplos:

```text
produccion
linux
prometheus
red
aplicaciones
laboratorio
```

Las etiquetas facilitan la búsqueda y la clasificación.

---

# Crear un dashboard

## Crear un dashboard vacío

Pasos generales:

1. Acceder a **Dashboards**.
2. Seleccionar **New** o **New dashboard**.
3. Crear un dashboard vacío.
4. Añadir un panel.
5. Seleccionar una fuente de datos.
6. Introducir una consulta.
7. Guardar el dashboard.

## Nombre recomendado

Los nombres deben ser claros y descriptivos.

Evitar:

```text
Dashboard 1
Prueba
Panel nuevo
Servidor
```

Utilizar:

```text
Monitorización de servidor Linux
Resumen de infraestructura
Disponibilidad de servicios
Rendimiento de aplicaciones
Capacidad de almacenamiento
```

## Descripción recomendada

Una descripción puede indicar:

- Qué se monitoriza.
- Qué fuente de datos se utiliza.
- Quién es responsable.
- Qué entorno representa.
- Cuándo se actualizó.
- Qué significan los colores.

Ejemplo:

```text
Dashboard de monitorización de servidores Linux.
Fuente de datos: Prometheus.
Incluye disponibilidad, CPU, memoria, almacenamiento y red.
Entorno: laboratorio.
```

---

# Guardar un dashboard

Al guardar un dashboard, Grafana puede solicitar:

- Nombre.
- Carpeta.
- Etiquetas.
- Descripción.
- Confirmación de cambios.

Es importante guardar después de:

- Crear un panel.
- Modificar una consulta.
- Cambiar una visualización.
- Mover un panel.
- Cambiar los umbrales.
- Añadir variables.
- Aplicar transformaciones.

Un dashboard no guardado puede perder los últimos cambios.

## Buenas prácticas al guardar

- Utilizar nombres descriptivos.
- Seleccionar la carpeta correcta.
- Añadir una descripción.
- Utilizar etiquetas coherentes.
- Evitar crear copias innecesarias.
- Revisar los cambios antes de confirmar.

---

# Organizar dashboards mediante carpetas

Las carpetas permiten separar dashboards por función, entorno o equipo.

## Organización por función

```text
Infraestructura/
Aplicaciones/
Bases de datos/
Redes/
Seguridad/
```

## Organización por entorno

```text
Producción/
Preproducción/
Desarrollo/
Laboratorio/
```

## Organización por equipo

```text
Sistemas/
Redes/
Desarrollo/
Operaciones/
```

## Organización combinada

```text
Producción/
├── Infraestructura/
├── Aplicaciones/
└── Redes/

Laboratorio/
├── Prometheus/
├── Grafana/
└── Node Exporter/
```

La estructura debe ser sencilla. Una jerarquía demasiado profunda puede dificultar la navegación.

---

# Buscar dashboards

La búsqueda permite localizar dashboards por:

- Nombre.
- Carpeta.
- Etiqueta.
- Favoritos.
- Propietario.
- Equipo.
- Ubicación.

Ejemplos de búsquedas:

```text
linux
```

```text
prometheus
```

```text
produccion
```

```text
red
```

## Recomendaciones para facilitar las búsquedas

Utilizar nombres y etiquetas consistentes.

Ejemplo:

```text
Linux - Resumen de servidores
Linux - Capacidad de almacenamiento
Linux - Tráfico de red
```

Etiquetas:

```text
linux
infraestructura
prometheus
produccion
```

Evitar nombres ambiguos como:

```text
Vista final
Dashboard nuevo
Copia 2
Prueba definitiva
```

---

# Marcar dashboards como favoritos

Un dashboard favorito aparece en una zona de acceso rápido.

Es recomendable marcar como favoritos:

- El dashboard principal de operaciones.
- El dashboard utilizado durante una incidencia.
- El resumen de producción.
- El dashboard de disponibilidad.
- El dashboard usado en una práctica.

No es recomendable marcar todos los dashboards como favoritos. Si todo es favorito, nada destaca.

---

# Abrir y utilizar un dashboard

Al abrir un dashboard se pueden modificar distintos aspectos de la visualización.

## Rango temporal

El selector temporal permite consultar periodos como:

```text
Last 5 minutes
Last 15 minutes
Last 1 hour
Last 6 hours
Last 12 hours
Last 24 hours
Last 7 days
```

## Actualización automática

Grafana puede actualizar los datos de forma periódica.

Intervalos habituales:

```text
5 seconds
10 seconds
30 seconds
1 minute
5 minutes
```

Un intervalo demasiado corto puede incrementar la carga sobre la fuente de datos.

## Variables

Las variables permiten cambiar el contexto del dashboard.

Ejemplos:

```text
Instancia
Job
Interfaz de red
Punto de montaje
Entorno
```

Un dashboard con una variable `instance` puede mostrar diferentes servidores sin duplicar todos los paneles.

---

# Compartir dashboards

Grafana permite compartir un dashboard de varias formas.

## Compartir mediante enlace

Se puede generar un enlace para acceder al dashboard.

Antes de compartirlo, comprobar:

- Quién puede acceder.
- Si el enlace contiene información sensible.
- Si el dashboard utiliza datos de producción.
- Si las consultas exponen nombres internos.
- Si el acceso requiere autenticación.

## Compartir una instantánea

Una instantánea contiene una copia de los datos visibles en un momento concreto.

Puede ser útil para:

- Informes.
- Incidencias.
- Documentación.
- Presentaciones.
- Evidencias de laboratorio.

Una instantánea no representa necesariamente el estado actual del sistema.

## Compartir una imagen

Una imagen puede utilizarse en:

- Informes.
- Documentación.
- Tickets.
- Correos.
- Evidencias.

La imagen no permite interactuar con el dashboard.

## Buenas prácticas de seguridad

No compartir públicamente dashboards que contengan:

- Direcciones internas.
- Nombres de servidores.
- Información de clientes.
- Métricas de producción.
- Datos personales.
- Tokens.
- Credenciales.
- Información sobre la arquitectura interna.

---

# Exportar un dashboard

Exportar un dashboard permite guardar su definición en formato JSON.

El fichero puede incluir:

- Paneles.
- Consultas.
- Visualizaciones.
- Variables.
- Transformaciones.
- Configuración general.
- Rangos temporales.
- Enlaces.

## Procedimiento general

1. Abrir el dashboard.
2. Abrir el menú de opciones.
3. Seleccionar la opción de compartir o exportar.
4. Elegir la opción de exportar.
5. Guardar el fichero JSON.

Nombre recomendado:

```text
monitorizacion-servidor-linux.json
```

Crear un directorio para los dashboards exportados:

```bash
mkdir -p ~/laboratorio-grafana/dashboards
```

Copiar el fichero:

```text
~/laboratorio-grafana/dashboards/monitorizacion-servidor-linux.json
```

## Ventajas de exportar

- Crear copias de seguridad.
- Migrar dashboards.
- Compartir configuraciones.
- Recuperar una versión anterior.
- Documentar una práctica.
- Reutilizar un dashboard.
- Controlar cambios mediante Git.

## Precauciones

Un dashboard exportado puede contener referencias a:

- Fuentes de datos.
- Variables.
- IDs internos.
- Carpetas.
- Plugins.
- Consultas específicas del entorno.

Al importarlo en otro sistema puede ser necesario adaptar estos elementos.

---

# Importar un dashboard

La importación permite cargar un dashboard desde:

- Un fichero JSON.
- Un identificador de dashboard.
- Una definición copiada.
- Una URL, según la configuración y la versión.

## Procedimiento general

1. Acceder a **Dashboards**.
2. Seleccionar **Import**.
3. Cargar el fichero JSON.
4. Revisar el nombre.
5. Seleccionar la fuente de datos.
6. Seleccionar la carpeta.
7. Confirmar la importación.

## Comprobar después de importar

- Que los paneles existen.
- Que las consultas son válidas.
- Que la fuente de datos está disponible.
- Que las variables funcionan.
- Que los plugins necesarios están instalados.
- Que las unidades son correctas.
- Que el rango temporal es adecuado.

---

# Copiar un dashboard

Copiar un dashboard puede ser útil para crear una nueva versión sin modificar el original.

Ejemplos:

```text
Monitorización Linux - Laboratorio
Monitorización Linux - Preproducción
Monitorización Linux - Producción
```

La copia debe recibir un nombre claro.

Evitar:

```text
Dashboard copia
Dashboard copia 2
Dashboard final definitivo
```

Utilizar:

```text
Monitorización Linux - Producción
```

La copia debe revisarse para comprobar:

- Nombre.
- Carpeta.
- Fuente de datos.
- Variables.
- Consultas.
- Enlaces.
- Descripción.
- Etiquetas.

---

# Eliminar un dashboard

La eliminación debe realizarse con precaución.

Antes de eliminar un dashboard:

1. Comprobar que no se utiliza.
2. Confirmar que existe una copia.
3. Exportarlo si es necesario.
4. Revisar si otros usuarios dependen de él.
5. Confirmar que no forma parte de un procedimiento operativo.
6. Verificar que se está eliminando el dashboard correcto.

No se debe confundir:

```text
Eliminar un panel
```

con:

```text
Eliminar un dashboard completo
```

Eliminar un dashboard puede borrar toda la estructura de paneles, consultas y configuración asociada.

---

# Permisos y acceso

El acceso a un dashboard puede depender de:

- Usuario.
- Equipo.
- Carpeta.
- Organización.
- Rol.
- Permisos específicos.

Roles habituales:

```text
Viewer: puede consultar
Editor: puede modificar
Admin: puede administrar
```

Los nombres exactos pueden variar según la configuración de Grafana.

## Buenas prácticas

- Dar permisos de lectura a quienes solo necesitan consultar.
- Reservar permisos de edición para responsables del dashboard.
- Limitar la administración.
- Organizar dashboards por equipos o carpetas.
- Revisar periódicamente los permisos.
- No utilizar cuentas compartidas.
- No incluir credenciales en paneles o consultas.

---

# Ejemplo de organización

Una organización sencilla para un curso puede ser:

```text
Dashboards/
├── 01-Laboratorio/
│   ├── Monitorización de servidor Linux
│   └── Estado de Prometheus
├── 02-Infraestructura/
│   ├── CPU y memoria
│   └── Almacenamiento
└── 03-Redes/
    ├── Tráfico de red
    └── Interfaces de red
```

Una organización para una empresa puede ser:

```text
Producción/
├── Resumen ejecutivo
├── Infraestructura
├── Aplicaciones
├── Bases de datos
└── Redes

No producción/
├── Preproducción
├── Desarrollo
└── Laboratorio
```

---

# Ejemplo de sesión 1: crear el primer dashboard

## Objetivo

Crear un dashboard básico y guardarlo en una carpeta.

## Pasos

1. Acceder a Grafana:

```text
http://localhost:3000
```

2. Abrir **Dashboards**.
3. Crear un dashboard nuevo.
4. Añadir un panel.
5. Seleccionar Prometheus.
6. Introducir la consulta:

```promql
up
```

7. Utilizar una visualización de tipo `Table`.
8. Establecer el título:

```text
Estado de los objetivos
```

9. Guardar el dashboard.
10. Utilizar el nombre:

```text
Monitorización de servidor Linux
```

11. Crear o seleccionar la carpeta:

```text
Laboratorio
```

12. Añadir la descripción:

```text
Dashboard inicial para comprobar la disponibilidad de Prometheus y Node Exporter.
```

## Actividades

1. Crea el dashboard.
2. Comprueba que aparece en la lista.
3. Comprueba la carpeta asignada.
4. Abre el dashboard desde la lista.
5. Marca el dashboard como favorito.
6. Anota el resultado.

---

# Ejemplo de sesión 2: crear una estructura de carpetas

## Objetivo

Organizar varios dashboards mediante carpetas.

## Crear carpetas

Crear las siguientes carpetas:

```text
Laboratorio
Infraestructura
Redes
```

## Crear dashboards de ejemplo

Crear los siguientes dashboards:

```text
Laboratorio - Estado de los objetivos
Infraestructura - Recursos del servidor
Redes - Tráfico de red
```

Asignarlos así:

| Dashboard | Carpeta |
|---|---|
| Laboratorio - Estado de los objetivos | Laboratorio |
| Infraestructura - Recursos del servidor | Infraestructura |
| Redes - Tráfico de red | Redes |

## Actividades

1. Crea las carpetas.
2. Crea los dashboards.
3. Asigna cada dashboard a su carpeta.
4. Añade etiquetas:
   - `laboratorio`
   - `infraestructura`
   - `redes`
5. Busca cada dashboard.
6. Comprueba que aparece en la ubicación esperada.

---

# Ejemplo de sesión 3: buscar y marcar favoritos

## Objetivo

Localizar dashboards rápidamente y configurar favoritos.

## Pasos

1. Acceder a la lista de dashboards.
2. Buscar:

```text
Infraestructura
```

3. Abrir el dashboard encontrado.
4. Marcarlo como favorito.
5. Volver a la sección de dashboards favoritos.
6. Confirmar que aparece.

## Actividades

1. Marca dos dashboards como favoritos.
2. Elimina uno de favoritos.
3. Comprueba la diferencia entre:
   - Dashboard existente.
   - Dashboard favorito.
4. Explica por qué no conviene marcar todos los dashboards como favoritos.

---

# Ejemplo de sesión 4: exportar un dashboard

## Objetivo

Exportar un dashboard para crear una copia de seguridad.

## Pasos

1. Abrir:

```text
Monitorización de servidor Linux
```

2. Abrir el menú de compartir o exportar.
3. Exportar la definición JSON.
4. Guardar el fichero como:

```text
monitorizacion-servidor-linux.json
```

5. Crear un directorio de evidencias:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/lista-dashboards
```

6. Guardar el JSON en ese directorio.

## Comprobar el fichero

```bash
ls -lh ~/laboratorio-grafana/evidencias/lista-dashboards/
```

Si está disponible `jq`, validar que el fichero tiene formato JSON:

```bash
jq empty \
  ~/laboratorio-grafana/evidencias/lista-dashboards/monitorizacion-servidor-linux.json
```

Resultado esperado:

```text
Sin salida y código de retorno 0
```

## Actividades

1. Exporta el dashboard.
2. Comprueba que el fichero existe.
3. Ábrelo con un editor.
4. Localiza el nombre del dashboard.
5. Localiza los paneles.
6. Localiza las consultas.
7. Identifica la referencia a la fuente de datos.

---

# Ejemplo de sesión 5: importar un dashboard

## Objetivo

Importar un dashboard exportado previamente.

## Pasos

1. Abrir la sección **Dashboards**.
2. Seleccionar **Import**.
3. Cargar:

```text
monitorizacion-servidor-linux.json
```

4. Asignar un nuevo nombre:

```text
Monitorización de servidor Linux - Copia
```

5. Seleccionar la fuente de datos Prometheus.
6. Seleccionar la carpeta `Laboratorio`.
7. Confirmar la importación.

## Comprobaciones

Después de importar, revisar:

- Que el dashboard aparece en la lista.
- Que los paneles existen.
- Que las consultas devuelven datos.
- Que las unidades son correctas.
- Que los títulos se conservan.
- Que los rangos temporales funcionan.
- Que no aparecen errores de plugins.

## Actividades

1. Importa el dashboard.
2. Cambia su nombre.
3. Colócalo en otra carpeta.
4. Modifica el título de un panel.
5. Guarda la copia.
6. Comprueba que el dashboard original no ha cambiado.

---

# Ejemplo de sesión 6: copiar un dashboard para otro entorno

## Objetivo

Crear una versión de un dashboard para un entorno diferente.

## Dashboard original

```text
Monitorización de servidor Linux - Laboratorio
```

## Nueva copia

```text
Monitorización de servidor Linux - Preproducción
```

## Pasos

1. Abrir el dashboard original.
2. Utilizar la opción de guardar como o copiar.
3. Cambiar el nombre.
4. Asignar la carpeta:

```text
Infraestructura
```

5. Actualizar la descripción.
6. Revisar las consultas.
7. Revisar los filtros.
8. Guardar la nueva versión.

## Actividades

1. Crea la copia.
2. Comprueba que existen ambos dashboards.
3. Cambia un título únicamente en la copia.
4. Abre el dashboard original.
5. Comprueba que no se ha modificado.
6. Explica la utilidad de crear copias por entorno.

---

# Ejemplo de sesión 7: compartir un dashboard de forma segura

## Objetivo

Analizar las opciones de compartición y sus implicaciones.

## Pasos

1. Abrir un dashboard de laboratorio.
2. Abrir la opción de compartir.
3. Revisar la opción de enlace.
4. Revisar la opción de instantánea.
5. Revisar la opción de imagen.
6. No publicar información sensible.

## Actividades

Responder:

1. ¿Qué diferencia existe entre un enlace y una imagen?
2. ¿Qué datos contiene una instantánea?
3. ¿Qué riesgos existen al compartir un dashboard de producción?
4. ¿Qué información debe ocultarse antes de compartirlo?
5. ¿Qué usuarios deberían tener permisos de edición?

---

# Ejemplo de sesión 8: eliminar un dashboard de prueba

## Objetivo

Eliminar de forma controlada un dashboard que ya no sea necesario.

## Pasos

1. Crear un dashboard temporal:

```text
Dashboard de prueba - Eliminar
```

2. Añadir un panel sencillo:

```promql
up
```

3. Exportarlo como copia de seguridad.
4. Comprobar que aparece en la lista.
5. Eliminarlo.
6. Confirmar la eliminación.
7. Buscarlo de nuevo.

## Actividades

1. Explica qué diferencia existe entre borrar un panel y borrar un dashboard.
2. Justifica por qué se exportó antes de eliminarlo.
3. Comprueba si sigue apareciendo en la lista.
4. Documenta el resultado.

---

# Ejemplo de sesión 9: revisar dashboards desde la API

## Objetivo

Consultar información de dashboards utilizando la API de Grafana.

La API requiere normalmente autenticación. El siguiente ejemplo utiliza una variable para no escribir el token directamente en el historial del terminal.

Definir:

```bash
export GRAFANA_URL="http://localhost:3000"
export GRAFANA_TOKEN="REEMPLAZAR_POR_UN_TOKEN"
```

Consultar los dashboards:

```bash
curl -s \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  "$GRAFANA_URL/api/search?type=dash-db" \
  | jq
```

Mostrar nombre, tipo y carpeta:

```bash
curl -s \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  "$GRAFANA_URL/api/search?type=dash-db" \
  | jq -r '
    .[]
    | [
        .title,
        .type,
        .folderTitle,
        .url
      ]
    | @tsv
  '
```

## Precauciones

- No guardar tokens en repositorios.
- No incluir tokens en capturas.
- No compartir tokens.
- Utilizar permisos mínimos.
- Revocar tokens que ya no sean necesarios.

## Actividades

1. Consulta los dashboards.
2. Muestra sus nombres.
3. Identifica las carpetas.
4. Compara el resultado con la interfaz web.
5. Documenta la diferencia entre la API y la interfaz.

---

# Problemas habituales

## No aparece un dashboard

Comprobar:

- El término de búsqueda.
- La carpeta seleccionada.
- Los permisos del usuario.
- Las etiquetas.
- Si el dashboard fue eliminado.
- Si se está utilizando la organización correcta.

## No se puede guardar un dashboard

Posibles causas:

- Falta de permisos de edición.
- La carpeta no permite modificaciones.
- El nombre no es válido.
- Existe un conflicto de versión.
- La sesión ha caducado.

## El dashboard importado no muestra datos

Comprobar:

- Fuente de datos.
- Variables.
- Consultas.
- Etiquetas.
- Rango temporal.
- Plugins.
- Nombre de la instancia.
- Disponibilidad de Prometheus.

## El dashboard importado tiene paneles rotos

Posibles causas:

- Falta un plugin.
- La visualización ya no está disponible.
- La versión de Grafana es diferente.
- La fuente de datos tiene otro nombre.
- La consulta utiliza métricas que no existen.
- Se importó una versión antigua.

## El dashboard está duplicado

Revisar:

- Nombre.
- Carpeta.
- Fecha de creación.
- Propietario.
- Descripción.
- Etiquetas.

Mantener una sola versión oficial y eliminar copias obsoletas.

## Los usuarios no pueden abrir el dashboard

Comprobar:

- Permisos de la carpeta.
- Permisos del dashboard.
- Organización.
- Rol del usuario.
- Acceso a la fuente de datos.
- Restricciones de red.

---

# Buenas prácticas

## Utilizar una convención de nombres

Ejemplo:

```text
<entorno> - <servicio> - <propósito>
```

Aplicación:

```text
Producción - Linux - Recursos
Laboratorio - Prometheus - Estado
Preproducción - Web - Rendimiento
```

## Utilizar carpetas con una finalidad clara

No crear carpetas innecesarias.

Una estructura válida:

```text
Producción
Preproducción
Laboratorio
Archivados
```

## Mantener una versión oficial

Evitar varias copias con nombres ambiguos.

Utilizar:

```text
Monitorización Linux - Oficial
Monitorización Linux - Laboratorio
Monitorización Linux - Archivado
```

## Exportar antes de realizar cambios importantes

Antes de modificar un dashboard crítico:

```text
1. Exportar JSON.
2. Guardar copia.
3. Realizar cambios.
4. Probar.
5. Documentar.
```

## Añadir descripciones

La descripción debe permitir que otra persona entienda el dashboard sin consultar al autor.

## Utilizar etiquetas

Ejemplos:

```text
produccion
linux
prometheus
infraestructura
red
laboratorio
```

## Revisar periódicamente

Eliminar o archivar:

- Dashboards obsoletos.
- Copias temporales.
- Dashboards sin datos.
- Dashboards sin propietario.
- Dashboards duplicados.
- Dashboards de pruebas antiguas.

---

# Evidencias de la sesión

Crear el directorio:

```bash
mkdir -p ~/laboratorio-grafana/evidencias/lista-dashboards
```

Guardar una lista de archivos exportados:

```bash
find ~/laboratorio-grafana \
  -type f \
  \( -name "*.json" -o -name "*.md" \) \
  -printf "%p\n" \
  | sort \
  > ~/laboratorio-grafana/evidencias/lista-dashboards/ficheros.txt
```

Guardar información de la práctica:

```bash
cat > ~/laboratorio-grafana/evidencias/lista-dashboards/informe.txt <<'EOF'
Práctica: Lista de dashboards

Dashboards creados:
- 

Carpetas creadas:
- 

Dashboards marcados como favoritos:
- 

Dashboards exportados:
- 

Dashboards importados:
- 

Dashboards eliminados:
- 

Problemas encontrados:
- 

Soluciones aplicadas:
- 
EOF
```

Las capturas recomendadas son:

```text
01-lista-dashboards.png
02-carpetas.png
03-dashboard-favorito.png
04-exportacion.png
05-importacion.png
06-dashboard-compartido.png
07-dashboard-final.png
```

---

# Práctica integradora

## Objetivo

Crear una organización de dashboards para un entorno de monitorización.

## Requisitos

Crear las carpetas:

```text
Laboratorio
Infraestructura
Redes
```

Crear los dashboards:

```text
Laboratorio - Estado de los objetivos
Infraestructura - Recursos del servidor
Redes - Tráfico de red
```

## Dashboard 1: estado de los objetivos

Consulta:

```promql
up
```

Visualización recomendada:

```text
Table
```

## Dashboard 2: recursos del servidor

Paneles mínimos:

```text
Uso de CPU
Uso de memoria
Uso del sistema de ficheros
Carga del sistema
```

## Dashboard 3: tráfico de red

Paneles mínimos:

```text
Tráfico recibido
Tráfico enviado
Estado de las interfaces
```

## Tareas

1. Crear las carpetas.
2. Crear los dashboards.
3. Asignar cada dashboard a su carpeta.
4. Añadir etiquetas.
5. Marcar como favorito el dashboard principal.
6. Exportar los tres dashboards.
7. Importar uno de ellos con otro nombre.
8. Compartir una instantánea del dashboard de laboratorio.
9. Eliminar un dashboard de prueba.
10. Documentar las operaciones realizadas.

---

# Tabla de resultados

| Elemento | Resultado | Observaciones |
|---|---|---|
| Dashboard creado | | |
| Carpeta creada | | |
| Dashboard guardado | | |
| Dashboard localizado mediante búsqueda | | |
| Dashboard marcado como favorito | | |
| Dashboard exportado | | |
| Dashboard importado | | |
| Dashboard copiado | | |
| Dashboard compartido | | |
| Dashboard de prueba eliminado | | |
| Permisos comprobados | | |
| Evidencias guardadas | | |

---

# Puntos clave

- La lista de dashboards permite localizar y administrar las vistas de Grafana.
- Las carpetas ayudan a organizar dashboards relacionados.
- Los nombres deben ser claros y consistentes.
- Las etiquetas facilitan la búsqueda.
- Los favoritos permiten acceder rápidamente a los dashboards importantes.
- Exportar un dashboard permite crear copias de seguridad y reutilizar configuraciones.
- Importar un dashboard puede requerir adaptar fuentes de datos y variables.
- Compartir un dashboard debe hacerse teniendo en cuenta la seguridad.
- Una instantánea muestra datos de un momento concreto.
- Una imagen no permite interactuar con el dashboard.
- Copiar un dashboard permite crear una versión para otro entorno.
- Antes de eliminar un dashboard conviene exportarlo.
- Los permisos deben asignarse según la responsabilidad del usuario.
- Los dashboards obsoletos deben archivarse o eliminarse.
- Una organización sencilla es más útil que una estructura excesivamente profunda.
- La lista de dashboards debe reflejar la estructura real del entorno.
- La exportación JSON debe almacenarse de forma controlada.
- Los tokens de API nunca deben incluirse en capturas ni repositorios.
- Un dashboard importado debe probarse antes de considerarlo operativo.

---

# Preguntas de comprobación

1. ¿Qué función cumple la lista de dashboards?
2. ¿Qué diferencia existe entre una carpeta y un dashboard?
3. ¿Qué diferencia existe entre un dashboard y un panel?
4. ¿Qué ventajas ofrecen las etiquetas?
5. ¿Para qué sirve marcar un dashboard como favorito?
6. ¿Qué información debe incluir un nombre descriptivo?
7. ¿Qué utilidad tiene exportar un dashboard?
8. ¿En qué formato se exporta habitualmente un dashboard?
9. ¿Qué elementos pueden necesitar adaptación al importar un dashboard?
10. ¿Qué diferencia existe entre compartir un enlace y compartir una imagen?
11. ¿Qué riesgos existen al compartir un dashboard de producción?
12. ¿Qué pasos deberían realizarse antes de eliminar un dashboard?
13. ¿Qué rol debería tener un usuario que solo consulta dashboards?
14. ¿Qué rol necesita normalmente un usuario que modifica dashboards?
15. ¿Cómo organizarías dashboards de producción y laboratorio?
16. ¿Qué comprobarías si un dashboard importado no muestra datos?
17. ¿Por qué no conviene crear muchas carpetas?
18. ¿Por qué es importante utilizar una convención de nombres?
19. ¿Qué información incluirías en la descripción de un dashboard?
20. ¿Por qué deben protegerse los tokens de la API de Grafana?
21. ¿Qué diferencia existe entre un dashboard original y una copia?
22. ¿Qué evidencias guardarías después de una práctica?
23. ¿Cómo comprobarías que un dashboard se ha importado correctamente?
24. ¿Qué dashboards marcarías como favoritos en un entorno de producción?
25. ¿Qué proceso seguirías para retirar un dashboard obsoleto?

---

# Resultado esperado

Al finalizar esta sección, el alumno debe ser capaz de gestionar una colección organizada de dashboards.

El flujo completo será:

```text
Crear dashboard
       |
       v
Asignar nombre y descripción
       |
       v
Seleccionar carpeta
       |
       v
Añadir etiquetas
       |
       v
Guardar y probar
       |
       v
Marcar como favorito
       |
       v
Exportar una copia
       |
       v
Compartir de forma segura
       |
       v
Mantener o archivar
```

El resultado final debe ser una estructura de dashboards clara, localizable, documentada y adecuada para el entorno de monitorización.