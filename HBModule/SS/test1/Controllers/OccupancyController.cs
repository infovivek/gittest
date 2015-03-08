using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using test1.Utils;
using test1.DAO;
using test1.Models;
namespace test1.Controllers
{
    public class OccupancyController : Controller
    {
        //
        // GET: /Occupancy/
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult OccupancyChart()
        {
            string[] Hdrval = new string[5];
            Hdrval[0] = "SP_OccupancyChartMVC_Help"; Hdrval[1] = "Property"; Hdrval[2] = ""; Hdrval[3] = ""; Hdrval[4] = "0";
            DataSet ds = new GHDataDao().GHData(Hdrval);
            ViewBag.Property = ds.Tables[0].ToList<GHModel>();
            return View();
        }
        [HttpGet]
        public JsonResult OccupancyData(string StartDate, string EndDate, string PropertyId)
        {
            string[] Hdrval = new string[5];
            Hdrval[0] = "SP_OccupancyChartMVC_Help"; Hdrval[1] = "OccupancyChart"; Hdrval[2] = StartDate; Hdrval[3] = EndDate; Hdrval[4] = PropertyId;

            DataSet ds = new GHDataDao().GHData(Hdrval);
            if (ds.Tables[0].Rows[0][0].ToString() == "Date")
            {
                var Property = ds.Tables[0].ToList<GHModel>();

                return Json(Property, JsonRequestBehavior.AllowGet);
            }
            var Property1 = "";
            return Json(Property1, JsonRequestBehavior.AllowGet);

        }
    }
}