using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace test1
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute("GHData",
                          "GHReport/GHData/",
                          new { controller = "GHReport", action = "GHData" },
                          new[] { "test1.Controllers" });

            routes.MapRoute("GHExport",
                           "GHReport/GHExport/",
                           new { controller = "GHReport", action = "GHExport" },
                           new[] { "test1.Controllers" });

            routes.MapRoute("ExcelDownload",
                           "GHReport/ExcelDownload/",
                           new { controller = "GHReport", action = "ExcelDownload" },
                           new[] { "test1.Controllers" });

            routes.MapRoute("OccupancyData",
                        "Occupancy/OccupancyData/",
                        new { controller = "Occupancy", action = "OccupancyData" },
                        new[] { "test1.Controllers" });
        }
    }
}
