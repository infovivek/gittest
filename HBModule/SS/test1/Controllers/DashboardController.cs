using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using test1.Models;
using WebMatrix.WebData;

namespace test1.Controllers
{
    public class DashboardController : Controller
    {
        HBEntities db = new HBEntities();
        // GET: /Dashboard/
        public ActionResult Index()
        {
            return View();
        } 
        public JsonResult getUserId()
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select c.rowid).FirstOrDefault();
            //  long? id = CliendId != null ? CliendId : 0;
            string rowid = Convert.ToString(CliendId);// != 0 ? CliendId : null);
            return Json(rowid, JsonRequestBehavior.AllowGet);
        }
        public ActionResult PrptyMonthReports(String D)
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
            if (CliendId != null)
            {
                Session["clientId"] = CliendId.ClientId;
                Session["UserId"] = CliendId.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
                ViewBag.UserId = CliendId.rowid;
            }
            if (CliendId == null)
            {
                var CliendId1 = (from c in db.ClientAndUserId_Flux(5, "ENDUSR")
                                 select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
                Session["clientId"] = CliendId1.ClientId;
                Session["UserId"] = CliendId1.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
            }
            return View();
        }
        public ActionResult PrptyDateReports(String D)
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
            if (CliendId != null)
            {
                Session["clientId"] = CliendId.ClientId;
                Session["UserId"] = CliendId.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
                ViewBag.UserId = CliendId.rowid;
            }
            if (CliendId == null)
            {
                var CliendId1 = (from c in db.ClientAndUserId_Flux(5, "ENDUSR")
                                 select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
                Session["clientId"] = CliendId1.ClientId;
                Session["UserId"] = CliendId1.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
            }
            return View();
        }
        public ActionResult CityMonthReports(String D)
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
            if (CliendId != null)
            {
                Session["clientId"] = CliendId.ClientId;
                Session["UserId"] = CliendId.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
                ViewBag.UserId = CliendId.rowid;
            }
            if (CliendId == null)
            {
                var CliendId1 = (from c in db.ClientAndUserId_Flux(5, "ENDUSR")
                                 select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
                Session["clientId"] = CliendId1.ClientId;
                Session["UserId"] = CliendId1.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
            }
            return View();
        }
        public ActionResult CityDateReports(String D)
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
            if (CliendId != null)
            {
                Session["clientId"] = CliendId.ClientId;
                Session["UserId"] = CliendId.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
                ViewBag.UserId = CliendId.rowid;
            }
            if (CliendId == null)
            {
                var CliendId1 = (from c in db.ClientAndUserId_Flux(5, "ENDUSR")
                                 select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
                Session["clientId"] = CliendId1.ClientId;
                Session["UserId"] = CliendId1.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
            }
            return View();
        }
        public ActionResult PaymentReports(String D) 
        {
            var CliendId = (from c in db.ClientAndUserId_Flux(WebSecurity.CurrentUserId, "TRDESK")
                            select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
            if (CliendId != null)
            {
                Session["clientId"] = CliendId.ClientId;
                Session["UserId"] = CliendId.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
                ViewBag.UserId = CliendId.rowid;
            }
            if (CliendId == null)
            {
                var CliendId1 = (from c in db.ClientAndUserId_Flux(5, "ENDUSR")
                                 select new { c.Id, c.ClientId, c.rowid }).FirstOrDefault();
                Session["clientId"] = CliendId1.ClientId;
                Session["UserId"] = CliendId1.Id;
                Session["TRDESKRowId"] = CliendId.rowid;
            }
            return View();
        }

	}
}