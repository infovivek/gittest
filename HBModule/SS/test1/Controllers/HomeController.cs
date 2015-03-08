using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using test1.Models;
using WebMatrix.WebData;

namespace test1.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }
        //[Authorize]
        public ActionResult TravellerDetails(EmployeesBO emp)
        {
            ViewBag.Dest = emp.destination;
            ViewBag.IN = emp.checkin;
            ViewBag.OUT = emp.checkout;

            emp.count = Convert.ToInt32(emp.room1);
            if (emp.room2 != null)
            {
                emp.count += Convert.ToInt32(emp.room2);
                if (emp.room3 != null)
                {
                    emp.count += Convert.ToInt32(emp.room3);
                }
                if (emp.room4 != null)
                {
                    emp.count += Convert.ToInt32(emp.room4);
                }
                if (emp.room5 != null)
                {
                    emp.count += Convert.ToInt32(emp.room5);
                }
            }
            return View(emp);
        }

        [Authorize]
        public ActionResult TravellerDetailsSave(EmployeesBO emp)
        {
            Session["emp1"] = emp.EmpCode1;
            Session["emp2"] = emp.EmpCode2;
            Session["emp3"] = emp.EmpCode3;
            Session["emp4"] = emp.EmpCode4;
            Session["emp5"] = emp.EmpCode5;
            Session["emp6"] = emp.EmpCode6;
            Session["emp7"] = emp.EmpCode7;
            Session["emp8"] = emp.EmpCode8;
            Session["emp9"] = emp.EmpCode9;
            Session["emp10 "] = emp.EmpCode10;

            long? CLIENTID = 0; long? USERID = 0;
            try
            {
                using (HBEntities db = new HBEntities())
                {
                    var CliendId = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "TRDESK")
                                    select c).FirstOrDefault();
                    if (CliendId != null)
                    {
                        CLIENTID = CliendId.ClientId;
                        USERID = CliendId.Id;
                    }

                    if (CliendId == null)
                    {
                        var CliendId1 = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "ENDUSR")
                                         select c).FirstOrDefault();
                        CLIENTID = CliendId1.ClientId;
                        USERID = CliendId1.Id;
                    }
                    var insert = db.InsertTravellerDtails_FrontEnd(emp.EmpCode1,emp.First_Name1, emp.Last_Name1, emp.Phno1, emp.email1, emp.Grade1, CLIENTID, USERID);
                    if (emp.count > 1)
                    {
                        var insert2 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode2, emp.First_Name2, emp.Last_Name2, emp.Phno2, emp.email2, emp.Grade2, CLIENTID, USERID);
                    }
                    if (emp.count > 2)
                    {
                        var insert3 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode3, emp.First_Name3, emp.Last_Name3, emp.Phno3, emp.email3, emp.Grade3, CLIENTID, USERID);
                    }
                    if (emp.count > 3)
                    {
                        var insert4 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode4, emp.First_Name4, emp.Last_Name4, emp.Phno4, emp.email4, emp.Grade4, CLIENTID, USERID);
                    }
                    if (emp.count > 4)
                    {
                        var insert5 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode5, emp.First_Name5, emp.Last_Name5, emp.Phno5, emp.email5, emp.Grade5, CLIENTID, USERID);
                    }
                    if (emp.count > 5)
                    {
                        var insert6 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode6, emp.First_Name6, emp.Last_Name6, emp.Phno6, emp.email6, emp.Grade6, CLIENTID, USERID);
                    }
                    if (emp.count > 6)
                    {
                        var insert7 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode7, emp.First_Name7, emp.Last_Name7, emp.Phno7, emp.email7, emp.Grade7, CLIENTID, USERID);
                    }
                    if (emp.count > 7)
                    {
                        var insert8 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode8 ,emp.First_Name8, emp.Last_Name8, emp.Phno8, emp.email8, emp.Grade8, CLIENTID, USERID);
                    }
                    if (emp.count > 8)
                    {
                        var insert9 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode9, emp.First_Name9, emp.Last_Name9, emp.Phno9, emp.email9, emp.Grade9, CLIENTID, USERID);
                    }
                    if (emp.count > 9)
                    {
                        var insert10 = db.InsertTravellerDtails_FrontEnd(emp.EmpCode10, emp.First_Name10, emp.Last_Name10, emp.Phno10, emp.email10, emp.Grade10, CLIENTID, USERID);
                    }

                }
                return RedirectToAction("Searchdata", "Search", new
                {
                    destination = emp.destination,
                    checkin = emp.checkin,
                    checkout = emp.checkout,
                    Adult = emp.Adult,
                    room1 = emp.room1,
                    room2 = emp.room2,
                    room3 = emp.room3,
                    room4 = emp.room4,
                    room5 = emp.room5,
                    count = emp.count
                });
            }
            catch (Exception ex)
            {
                CreateLogFiles err = new CreateLogFiles();
                err.ErrorLog(ex.Message + "error occured on traveller details" + WebSecurity.CurrentUserName);
                return View("Index");
            }

        }

        public ActionResult Feature()
        {
            return View();
        }
        public ActionResult Demo()
        {
            return View();
        }
        public ActionResult Pricing()
        {
            return View();
        }

        public ActionResult About_us()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }
        public ActionResult Testimonials()
        {
            return View();
        }
        public ActionResult Awards()
        {
            return View();
        }
        public ActionResult Terms_of_Service()
        {
            return View();
        }
        public ActionResult Privacy_Policy()
        {
            return View();
        }
        public ActionResult Site_Map()
        {
            return View();
        }
        public ActionResult Contact()
        {
            return View();
        }
        public ActionResult Profile()
        {
            return View();
        }

        public JsonResult Autocomplete(string empcode)
        {
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.WRBHBClientManagementAddClientGuests
                             where s.EmpCode.StartsWith(empcode)
                             select s.EmpCode).ToList();             
                             

                return Json(datas.Take(20), JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult EmployeeDetails(string code)
        {
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.WRBHBClientManagementAddClientGuests
                             where s.EmpCode == code
                             select new
                             {
                                 s.EmpCode,
                                 s.FirstName,
                                 s.LastName,
                                 s.GMobileNo,
                                 s.Grade,
                                 s.EmailId
                             }).FirstOrDefault();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }
    }
}