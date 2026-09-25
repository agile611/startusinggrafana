document.addEventListener("DOMContentLoaded", function () {
  const modules = [
    {
      path: "00-el-curso",
      title: "El curso"
    },
    {
      path: "01-fundamentos-telemetria",
      title: "Fundamentos de telemetría"
    },
    {
      path: "02-grafana",
      title: "Grafana"
    },
    {
      path: "03-prometheus-fuentes-datos",
      title: "Prometheus y fuentes de datos"
    },
    {
      path: "04-dashboards-visualizacion",
      title: "Dashboards y visualización"
    },
    {
      path: "05-anotaciones-alertas",
      title: "Anotaciones y alertas"
    },
    {
      path: "06-proyecto-final",
      title: "Proyecto final"
    },
    {
      path: "07-referencia-y-resolucion",
      title: "Referencia y resolución"
    }
  ];

  const currentPath = window.location.pathname;

  const selectedModule = modules.find(function (module) {
    return currentPath.includes("/" + module.path + "/");
  });

  if (!selectedModule) {
    return;
  }

  /*
   * Selector utilizado por el tema MkDocs clásico.
   * Se incluyen varias alternativas para facilitar la compatibilidad
   * con distintas versiones o temas derivados.
   */
  const sidebarTitle = document.querySelector(
    ".bs-sidebar .navbar-brand, " +
    ".bs-sidebar h1, " +
    ".sidebar .navbar-brand, " +
    ".sidebar h1, " +
    "aside .navbar-brand, " +
    "aside h1"
  );

  if (sidebarTitle) {
    sidebarTitle.textContent = selectedModule.title;
  }
});