(function () {
  "use strict";

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

  function getSelectedModule() {
    const currentPath = window.location.pathname;

    return modules.find(function (module) {
      return currentPath.indexOf("/" + module.path + "/") !== -1 ||
             currentPath.endsWith("/" + module.path);
    });
  }

  function updateSidebarTitle() {
    const selectedModule = getSelectedModule();

    if (!selectedModule) {
      return;
    }

    const selectors = [
      ".bs-sidebar .navbar-brand",
      ".bs-sidebar .navbar-header .navbar-brand",
      ".bs-sidebar a.navbar-brand",
      ".bs-sidebar div.navbar-brand"
    ];

    let sidebarTitle = null;

    for (const selector of selectors) {
      sidebarTitle = document.querySelector(selector);

      if (sidebarTitle) {
        break;
      }
    }

    if (!sidebarTitle) {
      console.warn("No se encontró el título de la columna lateral.");
      return;
    }

    sidebarTitle.textContent = selectedModule.title;
  }

  function initialize() {
    updateSidebarTitle();

    /*
     * Algunos temas terminan de construir la barra lateral
     * después de cargar el documento.
     */
    setTimeout(updateSidebarTitle, 100);
    setTimeout(updateSidebarTitle, 500);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initialize);
  } else {
    initialize();
  }
})();