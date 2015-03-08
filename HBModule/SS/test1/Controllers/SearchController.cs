using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Xml;
using test1.Models;
using WebMatrix.WebData;

namespace test1.Controllers
{
    [Authorize]
    public class SearchController : Controller
    {
        //
        // GET: /Search/      


        public ActionResult Searchdata(string destination, string checkin, string checkout, string Adult, string room1, string room2, string room3, string room4, string room5, int? count)
        {
            Session["count"] = count != null ? count : 0;
            ViewBag.Dest = destination;
            string fntin = checkin;
            string fntout = checkout;
            ViewBag.IN = fntin;
            ViewBag.OUT = fntout;
            Session["fntin"] = fntin;
            Session["fntout"] = fntout;
            Session["dest"] = destination;
            //Session["roomcnt"] = Adult;       
            //ViewBag.InDt = Session["checindate"] != null ? Session["checindate"] : "";
            //ViewBag.OutDt = Session["checoutdate"] != null ? Session["checoutdate"] : "";
            //ViewBag.room = Session["roomcnt"];
            //ViewBag.guest1 = Session["g1"];
            //ViewBag.guest2 = Session["g2"];
            //ViewBag.guest3 = Session["g3"];
            //ViewBag.guest4 = Session["g4"];
            //ViewBag.guest5 = Session["g5"];

            if (destination == null || destination == "")
            {
                return RedirectToAction("Index", "Home");
            }
            Session["NoOfRooms"] = Adult;
            Session["g1"] = room1;
            Session["g2"] = room2;
            Session["g3"] = room3;
            Session["g4"] = room4;
            Session["g5"] = room5;
            char sp = '/';
            string[] chkin = checkin.Split(sp);
            string[] chkout = checkout.Split(sp);
            checkin = chkin[2] + "-" + chkin[0] + "-" + chkin[1] + " " + "12:00:00 PM";
            checkout = chkout[2] + "-" + chkout[0] + "-" + chkout[1] + " " + "11:59:00 AM";

            string CHKi = chkin[2] + "-" + chkin[0] + "-" + chkin[1];
            string CHKo = chkout[2] + "-" + chkout[0] + "-" + chkout[1];
            Session["chi"] = checkin;
            Session["cho"] = checkout;
            Session["CIN"] = CHKi;
            Session["COUT"] = CHKo;
            FrontHelpBO Details = new FrontHelpBO();
            Details.count = count != null ? count : 0;
            using (HBEntities db = new HBEntities())
            {
                var dest = (from c in db.CitywithApiHeader()
                            where c.CityName.ToLower() == destination.ToLower()
                            select new { c.Id, c.StateId }).FirstOrDefault();
                if (dest == null)
                {
                    ViewBag.error = "Search Unsuccessful. No Destination were found for this search";
                    Details.BudgetPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.BusinessPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.LuxuryPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.ManagedGuestHouse = new List<BookingFrontEndHelpBO>();
                    Details.ServiceAppartments = new List<BookingFrontEndHelpBO>();
                    Details.ClientPreferredPrppertyList = new List<BookingFrontEndHelpBO>();
                    ViewBag.LocalityLst = new SelectList(GetLocalityList(0), "Key", "Value");
                    ViewBag.IN = fntin;
                    ViewBag.OUT = fntout;
                    ViewBag.Dest = destination;
                    ViewBag.Done = "Success";
                    return RedirectToAction("NoItems", "Search");
                }

                Session["cityid"] = dest.Id;
                Session["Api"] = dest.StateId;
                Session["checindate"] = checkin;
                Session["checoutdate"] = checkout;

                long cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;

                ViewBag.LocalityLst = new SelectList(GetLocalityList(cityid), "Key", "Value");

                var CliendId = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "TRDESK")
                                select c.ClientId).FirstOrDefault();
                if (CliendId != null)
                {
                    Session["client"] = CliendId;
                    Session["UserType"] = "TRAVELDESK";
                }

                if (CliendId == null)
                {
                    var CliendId1 = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "ENDUSR")
                                     select c.ClientId).FirstOrDefault();
                    Session["client"] = CliendId1;
                    Session["UserType"] = "ENDUSER";
                }

                long? ClientId = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
                ViewBag.Done = "Success";

                var Budget = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, dest.StateId, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 750, 2500, "")
                              select new BookingFrontEndHelpBO
                              {
                                  PptyId = s.PropertyId,
                                  PptyImg = s.ImageLocation,
                                  PropertyType = s.PropertyType,
                                  MinimunPrice = s.Tariff,
                                  AboutPpty = s.shortDescription,
                                  PptyName = s.PropertyName,
                                  dummy = "test" + s.PropertyId,
                                  PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                  StarImage = starimagesetup(s.StarRating),
                                  LatitudeLangitude = s.LatitudeLongitude

                              }).ToList();

                var Business = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, dest.StateId, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 2501, 5000, "")
                                select new BookingFrontEndHelpBO
                                {
                                    PptyId = s.PropertyId,
                                    PptyImg = s.ImageLocation,
                                    PropertyType = s.PropertyType,
                                    MinimunPrice = s.Tariff,
                                    AboutPpty = s.shortDescription,
                                    PptyName = s.PropertyName,
                                    dummy = "test" + s.PropertyId,
                                    PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                    StarImage = starimagesetup(s.StarRating),
                                    LatitudeLangitude = s.LatitudeLongitude
                                }).ToList();

                var Luxury = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, dest.StateId, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 5001, 1000000, "")
                              select new BookingFrontEndHelpBO
                              {
                                  PptyId = s.PropertyId,
                                  PptyImg = s.ImageLocation,
                                  PropertyType = s.PropertyType,
                                  MinimunPrice = s.Tariff,
                                  AboutPpty = s.shortDescription,
                                  PptyName = s.PropertyName,
                                  dummy = "test" + s.PropertyId,
                                  PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                  StarImage = starimagesetup(s.StarRating),
                                  LatitudeLangitude = s.LatitudeLongitude
                              }).ToList();

                var Service = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, 0, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 0, 0, "SA")
                               select new BookingFrontEndHelpBO
                               {
                                   PptyId = s.PropertyId,
                                   PptyImg = s.ImageLocation,
                                   PropertyType = s.PropertyType,
                                   MinimunPrice = s.Tariff,
                                   AboutPpty = s.shortDescription,
                                   PptyName = s.PropertyName,
                                   dummy = "test" + s.PropertyId,
                                   PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                   StarImage = starimagesetup(s.StarRating),
                                   LatitudeLangitude = s.LatitudeLongitude,
                                   Drop1Id = "Drp1" + s.PropertyId,
                                   Drop2Id = "Drp2" + s.PropertyId,
                                   Drop3Id = "Drp3" + s.PropertyId,
                                   BookingDetails = s.PropertyId + "," + s.PropertyName + "," + s.ImageLocation + "," + s.PropertyType,
                                   Label1 = "Label1" + s.PropertyId,
                                   Label2 = "Label2" + s.PropertyId,
                                   Label3 = "Label3" + s.PropertyId
                               }).ToList();
                var Managed = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, 0, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 0, 0, "MGH")
                               select new BookingFrontEndHelpBO
                               {
                                   PptyId = s.PropertyId,
                                   PptyImg = s.ImageLocation,
                                   PropertyType = s.PropertyType,
                                   MinimunPrice = s.Tariff,
                                   AboutPpty = s.shortDescription,
                                   PptyName = s.PropertyName,
                                   dummy = "test" + s.PropertyId,
                                   PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                   StarImage = starimagesetup(s.StarRating),
                                   LatitudeLangitude = s.LatitudeLongitude,
                                   Drop1Id = "Drp1" + s.PropertyId,
                                   Drop2Id = "Drp2" + s.PropertyId,
                                   BookingDetails = s.PropertyId + "," + s.PropertyName + "," + s.ImageLocation + "," + s.PropertyType,
                                   trbdrop1 = "trb1"+s.PropertyId,
                                   trbdrop2 = "trb2"+s.PropertyId,
                                   trbdrop3 = "trb3"+s.PropertyId,
                                   trbdrop4 = "trb4"+s.PropertyId,
                                   trbdrop5 = "trb5"+s.PropertyId,
                                   trbdrop6 = "trb6"+s.PropertyId,
                                   trbdrop7 = "trb7"+s.PropertyId,
                                   trbdrop8 = "trb8"+s.PropertyId,
                                   trbdrop9 = "trb9"+s.PropertyId,
                                   trbdrop10 = "trb10"+s.PropertyId,
                                   trrdrop1 = "trr1"+s.PropertyId,
                                   trrdrop2 = "trr2"+s.PropertyId,
                                   trrdrop3 = "trr3"+s.PropertyId,
                                   trrdrop4 = "trr4"+s.PropertyId,
                                   trrdrop5 = "trr5"+s.PropertyId
                                  
                               }).ToList();

                var Clientpreffered = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checkin, checkout, 0, dest.Id, ClientId, 0, 0, 0, 0, "FIRST", 0, 0, "CPP")
                                       select new BookingFrontEndHelpBO
                                       {
                                           PptyId = s.PropertyId,
                                           PptyImg = s.ImageLocation,
                                           PropertyType = s.PropertyType,
                                           MinimunPrice = s.Tariff,
                                           AboutPpty = s.shortDescription,
                                           PptyName = s.PropertyName,
                                           dummy = "test" + s.PropertyId,
                                           PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                           StarImage = starimagesetup(s.StarRating),
                                           LatitudeLangitude = s.LatitudeLongitude
                                       }).ToList();

                Details.UserType = Session["UserType"] != null ? Session["UserType"].ToString() : "";

                if (Budget.Count == 0 && Business.Count == 0 && Luxury.Count == 0 && Managed.Count == 0 && Clientpreffered.Count == 0 && Service.Count == 0)
                {
                    ViewBag.error = "Search Unsuccessful. No Items were found for this search";
                    Details.BudgetPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.BusinessPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.LuxuryPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.ManagedGuestHouse = new List<BookingFrontEndHelpBO>();
                    Details.ServiceAppartments = new List<BookingFrontEndHelpBO>();
                    Details.ClientPreferredPrppertyList = new List<BookingFrontEndHelpBO>();
                    ViewBag.LocalityLst = new SelectList(GetLocalityList(0), "Key", "Value");
                    ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
                    ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
                    ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
                    ViewBag.Done = "Success";
                    return RedirectToAction("NoItems", "Search");
                }

                Details.BudgetPrppertyList = Budget.Take(20).ToList();
                Details.BusinessPrppertyList = Business.Take(20).ToList();
                Details.LuxuryPrppertyList = Luxury.Take(20).ToList();
                Details.ManagedGuestHouse = Managed.Take(20).ToList();
                Details.ServiceAppartments = Service.Take(20).ToList();
                Details.ClientPreferredPrppertyList = Clientpreffered.Take(20).ToList();


                return View("Searchdata", Details);
            }
        }

        public ActionResult FilterResult(FrontHelpBO front)
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            ViewBag.name = front.propertyname != null ? front.propertyname : "";
            front.propertyname = (front.propertyname != null && front.propertyname != "") ? front.propertyname.ToLower() : "";
            FrontHelpBO Details = new FrontHelpBO();
            Details.count = Session["count"] != null ? Convert.ToInt32(Session["count"]) : 0;
            using (HBEntities db = new HBEntities())
            {
                long cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
                long? stateId = Session["stateid"] != null ? Convert.ToInt64(Session["stateid"]) : 0;
                string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
                ViewBag.Done = "Success";
                ViewBag.LocalityLst = new SelectList(GetLocalityList(cityid), "Key", "Value");
                var Budget = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, stateId, cityid, cliendid, 0, 0, 0, 0, "FIRST", 750, 2500, "")
                              where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                              && (s.LocalityId == front.localityId || front.localityId == null)
                              && (s.StarRating == front.rate || front.rate == null)
                              select new BookingFrontEndHelpBO
                              {
                                  PptyId = s.PropertyId,
                                  PptyImg = s.ImageLocation,
                                  PropertyType = s.PropertyType,
                                  MinimunPrice = s.Tariff,
                                  AboutPpty = s.shortDescription,
                                  PptyName = s.PropertyName,
                                  dummy = "test" + s.PropertyId,
                                  PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                  StarImage = starimagesetup(s.StarRating),
                                  LatitudeLangitude = s.LatitudeLongitude

                              }).ToList();

                var Business = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, stateId, cityid, cliendid, 0, 0, 0, 0, "FIRST", 2501, 5000, "")
                                where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                                && (s.LocalityId == front.localityId || front.localityId == null)
                                && (s.StarRating == front.rate || front.rate == null)
                                select new BookingFrontEndHelpBO
                                {
                                    PptyId = s.PropertyId,
                                    PptyImg = s.ImageLocation,
                                    PropertyType = s.PropertyType,
                                    MinimunPrice = s.Tariff,
                                    AboutPpty = s.shortDescription,
                                    PptyName = s.PropertyName,
                                    dummy = "test" + s.PropertyId,
                                    PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                    StarImage = starimagesetup(s.StarRating),
                                    LatitudeLangitude = s.LatitudeLongitude
                                }).ToList();

                var Luxury = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, stateId, cityid, cliendid, 0, 0, 0, 0, "FIRST", 5001, 1000000, "")
                              where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                              && (s.LocalityId == front.localityId || front.localityId == null)
                              && (s.StarRating == front.rate || front.rate == null)
                              select new BookingFrontEndHelpBO
                              {
                                  PptyId = s.PropertyId,
                                  PptyImg = s.ImageLocation,
                                  PropertyType = s.PropertyType,
                                  MinimunPrice = s.Tariff,
                                  AboutPpty = s.shortDescription,
                                  PptyName = s.PropertyName,
                                  dummy = "test" + s.PropertyId,
                                  PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                  StarImage = starimagesetup(s.StarRating),
                                  LatitudeLangitude = s.LatitudeLongitude
                              }).ToList();

                var Service = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, 0, cityid, cliendid, 0, 0, 0, 0, "FIRST", 0, 0, "SA")
                               where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                               && (s.LocalityId == front.localityId || front.localityId == null)
                               && (s.StarRating == front.rate || front.rate == null)
                               select new BookingFrontEndHelpBO
                               {
                                   PptyId = s.PropertyId,
                                   PptyImg = s.ImageLocation,
                                   PropertyType = s.PropertyType,
                                   MinimunPrice = s.Tariff,
                                   AboutPpty = s.shortDescription,
                                   PptyName = s.PropertyName,
                                   dummy = "test" + s.PropertyId,
                                   PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                   StarImage = starimagesetup(s.StarRating),
                                   LatitudeLangitude = s.LatitudeLongitude,
                                   Drop1Id = "Drp1" + s.PropertyId,
                                   Drop2Id = "Drp2" + s.PropertyId,
                                   Drop3Id = "Drp3" + s.PropertyId,
                                   BookingDetails = s.PropertyId + "," + s.PropertyName + "," + s.ImageLocation + "," + s.PropertyType,
                                   Label1 = "Label1" + s.PropertyId,
                                   Label2 = "Label2" + s.PropertyId,
                                   Label3 = "Label3" + s.PropertyId
                               }).ToList();
                var Managed = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, 0, cityid, cliendid, 0, 0, 0, 0, "FIRST", 0, 0, "MGH")
                               where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                               && (s.LocalityId == front.localityId || front.localityId == null)
                               && (s.StarRating == front.rate || front.rate == null)
                               select new BookingFrontEndHelpBO
                               {
                                   PptyId = s.PropertyId,
                                   PptyImg = s.ImageLocation,
                                   PropertyType = s.PropertyType,
                                   MinimunPrice = s.Tariff,
                                   AboutPpty = s.shortDescription,
                                   PptyName = s.PropertyName,
                                   dummy = "test" + s.PropertyId,
                                   PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                   StarImage = starimagesetup(s.StarRating),
                                   LatitudeLangitude = s.LatitudeLongitude,
                                   Drop1Id = "Drp1" + s.PropertyId,
                                   Drop2Id = "Drp2" + s.PropertyId,
                                   BookingDetails = s.PropertyId + "," + s.PropertyName + "," + s.ImageLocation + "," + s.PropertyType,
                                   trbdrop1 = "trb1" + s.PropertyId,
                                   trbdrop2 = "trb2" + s.PropertyId,
                                   trbdrop3 = "trb3" + s.PropertyId,
                                   trbdrop4 = "trb4" + s.PropertyId,
                                   trbdrop5 = "trb5" + s.PropertyId,
                                   trbdrop6 = "trb6" + s.PropertyId,
                                   trbdrop7 = "trb7" + s.PropertyId,
                                   trbdrop8 = "trb8" + s.PropertyId,
                                   trbdrop9 = "trb9" + s.PropertyId,
                                   trbdrop10 = "trb10" + s.PropertyId,
                                   trrdrop1 = "trr1" + s.PropertyId,
                                   trrdrop2 = "trr2" + s.PropertyId,
                                   trrdrop3 = "trr3" + s.PropertyId,
                                   trrdrop4 = "trr4" + s.PropertyId,
                                   trrdrop5 = "trr5" + s.PropertyId
                               }).ToList();

                var Clientpreffered = (from s in db.SP_New_Booking_FrontEnd_Help_First("Property", "", "", checin, checout, 0, cityid, cliendid, 0, 0, 0, 0, "FIRST", 0, 0, "CPP")
                                       where (s.PropertyName.ToLower().Contains(front.propertyname) || front.propertyname == "")
                                       && (s.LocalityId == front.localityId || front.localityId == null)
                                       && (s.StarRating == front.rate || front.rate == null)
                                       select new BookingFrontEndHelpBO
                                       {
                                           PptyId = s.PropertyId,
                                           PptyImg = s.ImageLocation,
                                           PropertyType = s.PropertyType,
                                           MinimunPrice = s.Tariff,
                                           AboutPpty = s.shortDescription,
                                           PptyName = s.PropertyName,
                                           dummy = "test" + s.PropertyId,
                                           PropertyDiscription = s.PropertyName + "|" + s.ImageLocation + "|" + s.PropertyDescription,
                                           StarImage = starimagesetup(s.StarRating),
                                           LatitudeLangitude = s.LatitudeLongitude
                                       }).ToList();
                if (Budget.Count == 0 && Business.Count == 0 && Luxury.Count == 0 && Managed.Count == 0 && Clientpreffered.Count == 0 && Service.Count == 0)
                {
                    ViewBag.error = "Search Unsuccessful. No Items were found for this search";
                    Details.BudgetPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.BusinessPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.LuxuryPrppertyList = new List<BookingFrontEndHelpBO>();
                    Details.ManagedGuestHouse = new List<BookingFrontEndHelpBO>();
                    Details.ServiceAppartments = new List<BookingFrontEndHelpBO>();
                    Details.ClientPreferredPrppertyList = new List<BookingFrontEndHelpBO>();
                    ViewBag.LocalityLst = new SelectList(GetLocalityList(0), "Key", "Value");
                    ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
                    ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
                    ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
                    ViewBag.name = front.propertyname != null ? front.propertyname : "";
                    ViewBag.Done = "Success";
                    return View("Searchdata", Details);
                }

                Details.BudgetPrppertyList = Budget.Take(20).ToList();
                Details.BusinessPrppertyList = Business.Take(20).ToList();
                Details.LuxuryPrppertyList = Luxury.Take(20).ToList();
                Details.ManagedGuestHouse = Managed.Take(20).ToList();
                Details.ServiceAppartments = Service.Take(20).ToList();
                Details.ClientPreferredPrppertyList = Clientpreffered.Take(20).ToList();

                return View("Searchdata", Details);
            }


        }

        public JsonResult RoomTypes(Int64 PropertyId, string PropertyType)
        {
            long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
            long? stateId = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;

            if (PropertyType == "MGH" || PropertyType == "SA" || PropertyType == "CPP")
                stateId = 0;
            using (HBEntities db = new HBEntities())
            {
                var datas = db.SP_New_Booking_FrontEnd_Help("Property", "", "", checin, checout, stateId, cityid, cliendid, PropertyId, 0, 0, 0, "SECOND", 0, 0, PropertyType).ToList();
                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Aboutproperty(string Details)
        {
            char com = '|';
            string[] Property = Details.Split(com);
            MoreDetailsBO about = new MoreDetailsBO();
            about.ImageSourse = Convert.ToString(Property[1]) != null ? Convert.ToString(Property[1]) : "";
            about.About = Convert.ToString(Property[2]) != null ? Convert.ToString(Property[2]) : "";
            about.PptyName = Convert.ToString(Property[0]) != null ? Convert.ToString(Property[0]) : "";
            return View(about);
        }

        public JsonResult Autocomplete(string city, int count)
        {
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.WRBHBCities
                             where s.CityName.StartsWith(city)
                             select new
                             {
                                 s.CityName
                             }).ToList();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Book(string Details)
        {
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string RoomCount = Session["NoOfRooms"] != null ? Convert.ToString(Session["NoOfRooms"]) : "";
            decimal guestCount1 = Session["NoOfGuest"] != null ? Convert.ToDecimal(Session["NoOfGuest"]) : 0;
            decimal guestCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
            decimal guestCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
            decimal guestCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
            decimal guestCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;
            char com = ',';
            string[] Property = Details.Split(com);
            BookingBO book = new BookingBO();
            book.PropertyId = Convert.ToInt64(Property[0]);
            book.SingleOccupancy = Convert.ToDecimal(Property[1]);
            book.doubleOccupancy = Convert.ToDecimal(Property[2]);
            book.PropertyName = Property[3];
            book.ImageLocation = Convert.ToString(Property[4]);
            book.CheckIn = Session["CIN"] != null ? Convert.ToString(Session["CIN"]) : "";
            book.Checkout = Session["COUT"] != null ? Convert.ToString(Session["COUT"]) : "";
            book.RoomCount = RoomCount == "1" ? "1 Room" : RoomCount == "2" ? "2 Room" : RoomCount == "3" ? "3 Room" : RoomCount == "4" ? "4 Room" : "5 Room";
            //book.GuestCount = guestCount;
            book.Total_Tariff = GetTotalTariff(book.SingleOccupancy, book.doubleOccupancy);

            using (HBEntities db = new HBEntities())
            {
                var user = (from s in db.WrbhbTravelDesks
                            where s.App_UserId == WebSecurity.CurrentUserId
                            && s.IsActive == true && s.IsDeleted == false
                            select new
                            {
                                s.ClientId,
                                s.Id,
                                s.Mobile,
                                s.FirstName,
                                s.LastName,
                                s.Email,
                                s.Designation

                            }).FirstOrDefault();
                if (user != null)
                {
                    book.FirstName = user.FirstName;
                    book.LastName = user.LastName;
                    book.Phno = user.Mobile;
                    book.Email = user.Email;
                    book.Designation = user.Designation;
                }

                if (user == null)
                {
                    var Clientuser = (from u in db.WRBHBClientManagementAddClientGuests
                                      where u.App_UserId == WebSecurity.CurrentUserId
                                      && u.IsActive == true && u.IsDeleted == false
                                      select new
                                      {
                                          u.CltmgntId,
                                          u.Id,
                                          u.FirstName,
                                          u.LastName,
                                          u.EmailId,
                                          u.Designation,
                                          u.EmpCode,
                                          u.GMobileNo

                                      }).FirstOrDefault();
                    if (Clientuser != null)
                    {
                        book.FirstName = Clientuser.FirstName;
                        book.LastName = Clientuser.LastName;
                        book.Phno = Clientuser.GMobileNo;
                        book.Email = Clientuser.EmailId;
                        book.Designation = Clientuser.Designation;
                        book.EmployeeCode = Clientuser.EmpCode;
                    }
                }
            }
            return View(book);
        }

        public string starimagesetup(string star)
        {
            string starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/0.0-MCID-5.png";
            if (star == "1")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/1.0-MCID-5.png";
            }
            else if (star == "0.5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/0.5-MCID-5.png";
            }
            else if (star == "1.5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/1.5-MCID-5.png";
            }
            else if (star == "2")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/2.0-MCID-5.png";
            }
            else if (star == "2.5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/2.5-MCID-5.png";
            }
            else if (star == "3")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/3.0-MCID-5.png";
            }
            else if (star == "3.5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/3.5-MCID-5.png";
            }
            else if (star == "4")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/4.0-MCID-5.png";
            }
            else if (star == "4.5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png";
            }
            else if (star == "5")
            {
                starimg = "http://tripadvisor.com/img/cdsi/img2/ratings/traveler/5.0-MCID-5.png";
            }

            return starimg;
        }

        public List<DropdownList> GetLocalityList(Int64 cityid)
        {

            using (HBEntities db = new HBEntities())
            {
                List<DropdownList> drpList = new List<DropdownList>();
                var lst1 = (from s in db.WRBHBLocalities
                            orderby s.Locality
                            select new DropdownList
                            {
                                Key = 0,
                                Value = "All"
                            }).ToList();

                var lst = (from s in db.WRBHBLocalities
                           where s.CityId == cityid && s.IsActive == true && s.IsDeleted == false
                           orderby s.Locality
                           select new DropdownList
                           {
                               Key = s.Id,
                               Value = s.Locality
                           }).ToList();

                //var mergedList = lst != null ? lst1.Union(lst).ToList() : lst1.ToList();
                return lst != null ? lst : new List<DropdownList>();
            }
        }

        public decimal GetTotalTariff(decimal singletariff, decimal doubletariff)
        {
            decimal TotalTariff = 0;
            decimal Tariff1;
            decimal Tariff2;
            decimal Tariff3;
            decimal Tariff4;
            decimal Tariff5;
            string RoomCount = Session["NoOfRooms"] != null ? Convert.ToString(Session["NoOfRooms"]) : "";
            decimal guestCount1 = Session["g1"] != null ? Convert.ToDecimal(Session["g1"]) : 0;
            decimal guestCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
            decimal guestCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
            decimal guestCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
            decimal guestCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;

            if (RoomCount == "1")
            {
                if (guestCount1 == 1)
                    TotalTariff = singletariff;
                else
                    TotalTariff = doubletariff;
            }
            else if (RoomCount == "2")
            {
                if (guestCount1 == 1)
                    Tariff1 = singletariff;
                else
                    Tariff1 = doubletariff;

                if (guestCount2 == 1)
                    Tariff2 = singletariff;
                else
                    Tariff2 = doubletariff;

                TotalTariff = Tariff1 + Tariff2;
            }
            else if (RoomCount == "3")
            {
                if (guestCount1 == 1)
                    Tariff1 = singletariff;
                else
                    Tariff1 = doubletariff;

                if (guestCount2 == 1)
                    Tariff2 = singletariff;
                else
                    Tariff2 = doubletariff;

                if (guestCount3 == 1)
                    Tariff3 = singletariff;
                else
                    Tariff3 = doubletariff;

                TotalTariff = Tariff1 + Tariff2 + Tariff3;
            }
            else if (RoomCount == "4")
            {
                if (guestCount1 == 1)
                    Tariff1 = singletariff;
                else
                    Tariff1 = doubletariff;

                if (guestCount2 == 1)
                    Tariff2 = singletariff;
                else
                    Tariff2 = doubletariff;

                if (guestCount3 == 1)
                    Tariff3 = singletariff;
                else
                    Tariff3 = doubletariff;
                if (guestCount4 == 1)
                    Tariff4 = singletariff;
                else
                    Tariff4 = doubletariff;

                TotalTariff = Tariff1 + Tariff2 + Tariff3 + Tariff4;
            }
            else if (RoomCount == "5")
            {
                if (guestCount1 == 1)
                    Tariff1 = singletariff;
                else
                    Tariff1 = doubletariff;

                if (guestCount2 == 1)
                    Tariff2 = singletariff;
                else
                    Tariff2 = doubletariff;

                if (guestCount3 == 1)
                    Tariff3 = singletariff;
                else
                    Tariff3 = doubletariff;
                if (guestCount4 == 1)
                    Tariff4 = singletariff;
                else
                    Tariff4 = doubletariff;

                if (guestCount4 == 1)
                    Tariff5 = singletariff;
                else
                    Tariff5 = doubletariff;

                TotalTariff = Tariff1 + Tariff2 + Tariff3 + Tariff4 + Tariff5;


            }
            return TotalTariff;
        }

        public JsonResult LoadBedDropDown(Int64 PropertyId, string PrType)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_FrontEnd(checin, checout, cliendid, PropertyId, "Bed", PrType)
                             select new
                             {
                                 s.label,
                                 s.Id

                             }).ToList();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult LoadSABedDropDown(Int64 PropertyId, string PrType)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, cliendid, PropertyId, "Bed", PrType)
                             select new
                             {
                                 s.label,
                                 s.Id,
                                 s.Tariff
                             }).ToList();
                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult LoadRoomDropDown(Int64 PropertyId, string PrType)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_FrontEnd(checin, checout, cliendid, PropertyId, "Room", PrType)
                             select new
                             {
                                 s.label,
                                 s.Id
                             }).ToList();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult LoadSARoomDropDown(Int64 PropertyId, string PrType)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_SA2_FrontEnd(checin, checout, cliendid, PropertyId, "Room", PrType)
                             select new
                             {
                                 s.label,
                                 s.Id
                             }).ToList();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult LoadSAApartmentDropDown(Int64 PropertyId, string PrType)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, cliendid, PropertyId, "Apartment", PrType)
                             select new
                             {
                                 s.label,
                                 s.Id,
                                 s.Tariff
                             }).ToList();

                return Json(datas, JsonRequestBehavior.AllowGet);
            }

        }

        public JsonResult BedTariff(Int64 PropertyId, Int64 BedId)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, cliendid, PropertyId, "Bed", "InP")
                             where s.Id == BedId
                             select new
                             {
                                 s.Tariff
                             }).FirstOrDefault();
                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult RoomTariff(Int64 PropertyId, Int64 BedId)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checin, checout, 0, cityid, cliendid, PropertyId, 0, 0, 0, "SECOND", 0, 0, "InP")
                             where s.PropertyId == PropertyId
                             select new
                             {
                                 s.GetType
                             }).FirstOrDefault();

                if (datas.GetType.ToLower() == "contract")
                {
                    var tariff = (from t in db.WRBHBContractNonDedicateds
                                  join D in db.WRBHBContractNonDedicatedApartments on t.Id equals D.NondedContractId
                                  where t.ClientId == cliendid && D.PropertyId == PropertyId
                                  select new
                                  {
                                      singleTariff = D.RoomTarif,
                                      doubleTariff = D.DoubleTarif
                                  }).ToList();
                    return Json(tariff, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var Ptariff = (from p in db.WRBHBPropertyRooms
                                   where p.Id == BedId
                                   select new
                                   {
                                       singleTariff = p.RackTariff,
                                       doubleTariff = p.DoubleOccupancyTariff
                                   }).ToList();
                    return Json(Ptariff, JsonRequestBehavior.AllowGet);
                }



            }
        }
        public decimal RoomTarifflocal(Int64 PropertyId, Int64 BedId)
        {
            decimal Totaltariff;
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checin, checout, 0, cityid, cliendid, PropertyId, 0, 0, 0, "SECOND", 0, 0, "InP")
                             where s.PropertyId == PropertyId
                             select new
                             {
                                 s.GetType
                             }).FirstOrDefault();

                if (datas.GetType.ToLower() == "contract")
                {
                    var tariff = (from t in db.WRBHBContractNonDedicateds
                                  join D in db.WRBHBContractNonDedicatedApartments on t.Id equals D.NondedContractId
                                  where t.ClientId == cliendid && D.PropertyId == PropertyId
                                  select new
                                  {
                                      singleTariff = D.RoomTarif,
                                      doubleTariff = D.DoubleTarif
                                  }).FirstOrDefault();
                    Totaltariff = Convert.ToDecimal(tariff.singleTariff);

                    return Totaltariff;
                }
                else
                {
                    var Ptariff = (from p in db.WRBHBPropertyRooms
                                   where p.Id == BedId
                                   select new
                                   {
                                       singleTariff = p.RackTariff,
                                       doubleTariff = p.DoubleOccupancyTariff
                                   }).FirstOrDefault();
                    Totaltariff = Convert.ToDecimal(Ptariff.singleTariff);

                    return Totaltariff;
                }
            }
        }
        public JsonResult ApartmentTariff(Int64 PropertyId, Int64 BedId)
        {
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, cliendid, PropertyId, "Apartment", "InP")
                             where s.Id == BedId
                             select new
                             {
                                 s.Tariff
                             }).FirstOrDefault();
                return Json(datas, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult MGHBooking(string Details)
        {
            try
            {
                ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
                ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
                ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";

                string UserType = Session["UserType"].ToString();
                long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
                string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
                string RoomCount = Session["NoOfRooms"] != null ? Convert.ToString(Session["NoOfRooms"]) : "";
                decimal guestCount1 = Session["NoOfGuest"] != null ? Convert.ToDecimal(Session["NoOfGuest"]) : 0;
                decimal guestCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
                decimal guestCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
                decimal guestCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
                decimal guestCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;

                char com = ',';
                string[] Property = Details.Split(com);


                if (UserType == "ENDUSER")
                {
                    MGHBookingBO book = new MGHBookingBO();
                    book.PropertyId = Convert.ToInt64(Property[0]);
                    book.PropertyName = Property[1];
                    book.ImageLocation = Convert.ToString(Property[2]);
                    book.PropertyType = Convert.ToString(Property[3]);
                    book.Level = Property[5];
                    book.BedType = "empty";
                    book.RoomType = "empty";

                    if (book.Level == "Bed")
                    {
                        book.BedId = Convert.ToInt64(Property[4]);
                        book.RoomCount = "1 Bed";
                        using (HBEntities db = new HBEntities())
                        {
                            var datas = (from s in db.SP_BookingPropertyDtls_Help_FrontEnd(checin, checout, 0, book.PropertyId, "Bed", book.PropertyType)
                                         where s.Id == book.BedId
                                         select new
                                         {
                                             s.label,
                                             s.Id
                                         }).FirstOrDefault();
                            book.BedType = datas.label;
                        }
                    }
                    else
                    {
                        book.RoomId = Convert.ToInt64(Property[4]);
                        book.RoomCount = "1 Room";
                        using (HBEntities db = new HBEntities())
                        {
                            var datas = (from s in db.SP_BookingPropertyDtls_Help_FrontEnd(checin, checout, 0, book.PropertyId, "Room", book.PropertyType)
                                         where s.Id == book.RoomId
                                         select new
                                         {
                                             s.label,
                                             s.Id
                                         }).FirstOrDefault();
                            book.RoomType = datas.label;
                        }
                    }

                    book.CheckIn = Session["CIN"] != null ? Convert.ToString(Session["CIN"]) : "";
                    book.Checkout = Session["COUT"] != null ? Convert.ToString(Session["COUT"]) : "";

                    //book.GuestCount = guestCount;
                    book.Total_Tariff = 0;


                    using (HBEntities db = new HBEntities())
                    {
                        var destion = (from c in db.WRBHBCities
                                       join s in db.WRBHBStates on c.StateId equals s.Id
                                       where c.Id == cityid
                                       select new
                                       {
                                           c.Id,
                                           c.StateId,
                                           c.CityName,
                                           s.StateName
                                       }).FirstOrDefault();


                        book.stateId = destion.StateId;
                        book.cityId = destion.Id;
                        book.CityName = destion.CityName;
                        book.SateName = destion.StateName;
                    }



                    using (HBEntities db = new HBEntities())
                    {
                        var Clientuser = (from u in db.WRBHBClientManagementAddClientGuests
                                          join cm in db.WRBHBClientManagements on u.CltmgntId equals cm.Id
                                          where u.App_UserId == WebSecurity.CurrentUserId
                                          && u.IsActive == true && u.IsDeleted == false
                                          select new
                                          {
                                              u.Grade,
                                              cm.ClientName,
                                              u.CltmgntId,
                                              u.Id,
                                              u.FirstName,
                                              u.LastName,
                                              u.EmailId,
                                              u.Designation,
                                              u.EmpCode,
                                              u.GMobileNo,
                                              u.GradeId,
                                              u.Title,
                                              u.Nationality

                                          }).FirstOrDefault();

                        book.FirstName = Clientuser.FirstName;
                        book.LastName = Clientuser.LastName;
                        book.Phno = Clientuser.GMobileNo;
                        book.Email = Clientuser.EmailId;
                        book.Designation = Clientuser.Designation;
                        book.EmployeeCode = Clientuser.EmpCode;
                        book.CliendId = Clientuser.CltmgntId;
                        book.ClientName = Clientuser.ClientName;
                        book.Grade = Clientuser.Grade;
                        book.UserId = Clientuser.Id;
                        book.GradeId = Clientuser.GradeId;
                        book.guestId = Clientuser.Id;
                        book.Title = Clientuser.Title;
                        book.Nationality = Clientuser.Nationality != "" ? Clientuser.Nationality : "Indian";
                    }
                    book.TariffPayMode = "empty";
                    book.ServicePayMode = "empty";
                    return View(book);

                }
                else
                {
                    string empcode1 = Session["emp1"] != null ? Session["emp1"].ToString() : "";
                    string empcode2 = Session["emp2"] != null ? Session["emp2"].ToString() : "";
                    string empcode3 = Session["emp3"] != null ? Session["emp3"].ToString() : "";
                    string empcode4 = Session["emp4"] != null ? Session["emp4"].ToString() : "";
                    string empcode5 = Session["emp5"] != null ? Session["emp5"].ToString() : "";
                    string empcode6 = Session["emp6"] != null ? Session["emp6"].ToString() : "";
                    string empcode7 = Session["emp7"] != null ? Session["emp7"].ToString() : "";
                    string empcode8 = Session["emp8"] != null ? Session["emp8"].ToString() : "";
                    string empcode9 = Session["emp9"] != null ? Session["emp9"].ToString() : "";
                    string empcode10 = Session["emp10"] != null ? Session["emp10"].ToString() : "";

                    int count = Session["count"] != null ? Convert.ToInt32(Session["count"]) : 0;
                    MGHTRBookingBO TRbook = new MGHTRBookingBO();
                    TRbook.PropertyId = Convert.ToInt64(Property[0]);
                    TRbook.PropertyName = Property[1];
                    TRbook.ImageLocation = Convert.ToString(Property[2]);
                    TRbook.PropertyType = Convert.ToString(Property[3]);
                    TRbook.Level = Property[5];
                    TRbook.BedType = "empty";
                    TRbook.RoomType = "empty";
                    return RedirectToAction("Working", "search");
                }

            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " MGH  Booking Creation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }
        }

        public ActionResult MGHConfirmBooking(MGHBookingBO mghbo)
        {
            SendingMailController mail = new SendingMailController();
            try
            {

                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                mghbo.EmployeeCode = mghbo.EmployeeCode != null ? mghbo.EmployeeCode : "";
                mghbo.Grade = mghbo.Grade != null ? mghbo.Grade : "";
                mghbo.Designation = mghbo.Designation != null ? mghbo.Designation : "";
                mghbo.specialrequst = mghbo.specialrequst != null ? mghbo.specialrequst : "";
                mghbo.Nationality = mghbo.Nationality != null ? mghbo.Nationality : "";

                using (HBEntities db = new HBEntities())
                {


                    var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(mghbo.CliendId, mghbo.GradeId, mghbo.stateId, mghbo.cityId, mghbo.ClientName, mghbo.CheckIn, "12:00:00", mghbo.Checkout, mghbo.Grade, mghbo.SateName, mghbo.CityName, mghbo.UserId,
                                   "", "", mghbo.UserId, mghbo.FirstName + " " + mghbo.LastName, mghbo.Email, true, "", mghbo.specialrequst, "Direct Booked", "PM", mghbo.Level, false, "", "")
                                   select new
                                   {
                                       s.BookingCode,
                                       s.Id,
                                       s.RowId,
                                       s.ExpectedChkInTime
                                   }).FirstOrDefault();
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(mghbo.GradeId);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, mghbo.guestId, mghbo.Designation, mghbo.FirstName, mghbo.LastName, mghbo.Email, mghbo.EmployeeCode, mghbo.UserId, mghbo.Grade, GradeID, mghbo.Nationality, mghbo.Phno, mghbo.Title)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, 0, mghbo.cityId, mghbo.CliendId, mghbo.PropertyId, 0, 0, 0, "SECOND", 0, 0, mghbo.PropertyType)
                                     select new
                                     {

                                         s.RoomType,
                                         s.PropertyId,
                                         s.PropertyName,
                                         s.MealPlan,
                                         s.APIHdrId,
                                         s.Phone,
                                         s.Email,
                                         s.GetType,
                                         s.Inclusions,
                                         s.PropertyType,
                                         s.DiscountModeRS,
                                         s.DiscountAllowed,
                                         s.DiscountModePer,
                                         s.MarkupId,
                                         s.RatePlanCode,
                                         s.RoomTypeCode,
                                         s.TaxAdded,
                                         s.LTAgreed,
                                         s.LTRack,
                                         s.STAgreed,
                                         s.TaxInclusive,
                                         s.BaseTariff,
                                         s.GeneralMarkup,
                                         s.SC,
                                         s.Locality,
                                         s.LocalityId

                                     }).FirstOrDefault();
                        if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                        {
                            mghbo.ServicePayMode = "Direct";
                            mghbo.TariffPayMode = "Bill to Company (BTC)";
                        }
                        else if (datas.PropertyType.ToUpper() == "CPP")
                        {
                            mghbo.ServicePayMode = "Bill to Client";
                            mghbo.TariffPayMode = "Bill to Client";
                        }
                        else
                        {
                            var btc = db.WRBHBClientManagements.Where(s => s.Id == mghbo.CliendId).Select(s => s.BTC).FirstOrDefault();

                            if (btc == true)
                            {
                                mghbo.ServicePayMode = "Bill to Company (BTC)";
                                mghbo.TariffPayMode = "Bill to Company (BTC)";
                            }
                            else
                            {
                                mghbo.ServicePayMode = "Direct";
                                mghbo.TariffPayMode = "Direct";
                            }
                        }

                        if (mghbo.Level == "Room")
                        {
                            var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                                   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                                   datas.LocalityId, mghbo.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                                   datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId
                                                   }).FirstOrDefault();

                            var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, mghbo.EmployeeCode, mghbo.FirstName, mghbo.LastName, mghbo.guestId, "Single", mghbo.RoomType, mghbo.ServicePayMode, mghbo.TariffPayMode, 0,
                                                 mghbo.RoomId, mghbo.PropertyId, BookingProperty.Id, mghbo.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                                 select new
                                                 {
                                                     s.Id,
                                                     s.RowId

                                                 }).FirstOrDefault();
                            //mail.RoomBookingMail(Booking.Id);
                        }
                        else
                        {
                            var BedBookingProperty = (from s in db.SP_BedBookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, 0, datas.Phone, datas.Email, datas.Locality, datas.LocalityId, mghbo.UserId, false, false, 0, 0, 0)
                                                      select new
                                                      {
                                                          s.Id,
                                                          s.RowId
                                                      }).FirstOrDefault();

                            var BedAssignedGuest = (from s in db.SP_BedBookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, mghbo.EmployeeCode, mghbo.FirstName, mghbo.LastName, mghbo.guestId,
                                                    mghbo.BedType, mghbo.ServicePayMode, mghbo.TariffPayMode, 0, 0, mghbo.BedId, mghbo.PropertyId, BedBookingProperty.Id, mghbo.UserId, 0, "", "", "", "", "", "", "", "", "", "", "", 0)
                                                    select new
                                                    {
                                                        s.Id,
                                                        s.RowId
                                                    }).FirstOrDefault();
                            //mail.BedBookingMail(Booking.Id);

                        }
                    }
                }

            }

            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " mgh  Booking Confirmation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }

            return RedirectToAction("Success", "Search");
        }

        public ActionResult InPBooking(string Details)
        {
            try
            {
                ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
                ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
                ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
                string UserType = Session["UserType"].ToString();
                long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
                string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
                string RoomCount = Session["NoOfRooms"] != null ? Convert.ToString(Session["NoOfRooms"]) : "";
                decimal guestCount1 = Session["NoOfGuest"] != null ? Convert.ToDecimal(Session["NoOfGuest"]) : 0;
                decimal guestCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
                decimal guestCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
                decimal guestCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
                decimal guestCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;

                InPBookingBO book = new InPBookingBO();
                char com = ',';
                string[] Property = Details.Split(com);
                book.PropertyId = Convert.ToInt64(Property[0]);
                book.PropertyName = Property[1];
                book.ImageLocation = Convert.ToString(Property[2]);
                book.PropertyType = Convert.ToString(Property[3]);
                book.Level = Property[5];
                book.BedType = "empty";
                book.RoomType = "empty";
                book.ApartmentType = "empty";

                if (UserType == "ENDUSER")
                {

                    if (book.Level == "Bed")
                    {
                        book.BedId = Convert.ToInt64(Property[4]);
                        book.RoomCount = "1 Bed";
                        using (HBEntities db = new HBEntities())
                        {
                            var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, 0, book.PropertyId, "Bed", book.PropertyType)
                                         where s.Id == book.BedId
                                         select new
                                         {
                                             s.label,
                                             s.Id,
                                             s.Tariff
                                         }).FirstOrDefault();
                            book.BedType = datas.label;
                            book.Total_Tariff = datas.Tariff;
                        }
                    }
                    else if (book.Level == "Room")
                    {
                        book.RoomId = Convert.ToInt64(Property[4]);
                        book.RoomCount = "1 Room";
                        using (HBEntities db = new HBEntities())
                        {
                            var datas = (from s in db.SP_BookingPropertyDtls_Help_SA2_FrontEnd(checin, checout, 0, book.PropertyId, "Room", book.PropertyType)
                                         where s.Id == book.RoomId
                                         select new
                                         {
                                             s.label,
                                             s.Id
                                         }).FirstOrDefault();
                            book.RoomType = datas.label;

                            book.Total_Tariff = RoomTarifflocal(book.PropertyId, book.RoomId);
                        }
                    }
                    else
                    {
                        book.ApartmentId = Convert.ToInt64(Property[4]);
                        book.RoomCount = "1 Apartment";
                        using (HBEntities db = new HBEntities())
                        {
                            var datas = (from s in db.SP_BookingPropertyDtls_Help_SA_FrontEnd(checin, checout, 0, book.PropertyId, "Apartment", book.PropertyType)
                                         where s.Id == book.ApartmentId
                                         select new
                                         {
                                             s.label,
                                             s.Id,
                                             s.Tariff
                                         }).FirstOrDefault();
                            book.ApartmentType = datas.label;
                            book.Total_Tariff = datas.Tariff;
                        }
                    }

                    book.CheckIn = Session["CIN"] != null ? Convert.ToString(Session["CIN"]) : "";
                    book.Checkout = Session["COUT"] != null ? Convert.ToString(Session["COUT"]) : "";

                    //book.GuestCount = guestCount;



                    using (HBEntities db = new HBEntities())
                    {
                        var destion = (from c in db.WRBHBCities
                                       join s in db.WRBHBStates on c.StateId equals s.Id
                                       where c.Id == cityid
                                       select new
                                       {
                                           c.Id,
                                           c.StateId,
                                           c.CityName,
                                           s.StateName
                                       }).FirstOrDefault();


                        book.stateId = destion.StateId;
                        book.cityId = destion.Id;
                        book.CityName = destion.CityName;
                        book.SateName = destion.StateName;
                    }



                    using (HBEntities db = new HBEntities())
                    {
                        var Clientuser = (from u in db.WRBHBClientManagementAddClientGuests
                                          join cm in db.WRBHBClientManagements on u.CltmgntId equals cm.Id
                                          where u.App_UserId == WebSecurity.CurrentUserId
                                          && u.IsActive == true && u.IsDeleted == false
                                          select new
                                          {
                                              u.Grade,
                                              cm.ClientName,
                                              u.CltmgntId,
                                              u.Id,
                                              u.FirstName,
                                              u.LastName,
                                              u.EmailId,
                                              u.Designation,
                                              u.EmpCode,
                                              u.GMobileNo,
                                              u.GradeId,
                                              u.Title,
                                              u.Nationality

                                          }).FirstOrDefault();

                        book.FirstName = Clientuser.FirstName;
                        book.LastName = Clientuser.LastName;
                        book.Phno = Clientuser.GMobileNo;
                        book.Email = Clientuser.EmailId;
                        book.Designation = Clientuser.Designation;
                        book.EmployeeCode = Clientuser.EmpCode;
                        book.CliendId = Clientuser.CltmgntId;
                        book.ClientName = Clientuser.ClientName;
                        book.Grade = Clientuser.Grade;
                        book.UserId = Clientuser.Id;
                        book.GradeId = Clientuser.GradeId;
                        book.guestId = Clientuser.Id;
                        book.Title = Clientuser.Title;
                        book.Nationality = Clientuser.Nationality != "" ? Clientuser.Nationality : "Indian";
                    }
                    book.TariffPayMode = "empty";
                    book.ServicePayMode = "empty";
                    return View(book);
                }
                else
                {
                    return RedirectToAction("Working", "search");
                }
            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " InP  Booking Creation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }
        }

        public ActionResult InPConfirmBooking(InPBookingBO inpbo)
        {
            SendingMailController mail = new SendingMailController();
            try
            {

                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                inpbo.EmployeeCode = inpbo.EmployeeCode != null ? inpbo.EmployeeCode : "";
                inpbo.Grade = inpbo.Grade != null ? inpbo.Grade : "";
                inpbo.Designation = inpbo.Designation != null ? inpbo.Designation : "";
                inpbo.specialrequst = inpbo.specialrequst != null ? inpbo.specialrequst : "";
                inpbo.Nationality = inpbo.Nationality != null ? inpbo.Nationality : "";
                using (HBEntities db = new HBEntities())
                {

                    var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(inpbo.CliendId, inpbo.GradeId, inpbo.stateId, inpbo.cityId, inpbo.ClientName, inpbo.CheckIn, "12:00:00", inpbo.Checkout, inpbo.Grade, inpbo.SateName, inpbo.CityName, inpbo.UserId,
                                   "", "", inpbo.UserId, inpbo.FirstName + " " + inpbo.LastName, inpbo.Email, true, "", inpbo.specialrequst, "Direct Booked", "PM", inpbo.Level, false, "", "")
                                   select new
                                   {
                                       s.BookingCode,
                                       s.Id,
                                       s.RowId,
                                       s.ExpectedChkInTime
                                   }).FirstOrDefault();
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(inpbo.GradeId);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, inpbo.guestId, inpbo.Designation, inpbo.FirstName, inpbo.LastName, inpbo.Email, inpbo.EmployeeCode, inpbo.UserId, inpbo.Grade, GradeID, inpbo.Nationality, inpbo.Phno, inpbo.Title)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, 0, inpbo.cityId, inpbo.CliendId, inpbo.PropertyId, 0, 0, 0, "SECOND", 0, 0, inpbo.PropertyType)
                                     select s).FirstOrDefault();

                        if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                        {
                            inpbo.ServicePayMode = "Direct";
                            inpbo.TariffPayMode = "Bill to Company (BTC)";
                        }
                        else if (datas.PropertyType.ToUpper() == "CPP")
                        {
                            inpbo.ServicePayMode = "Bill to Client";
                            inpbo.TariffPayMode = "Bill to Client";
                        }
                        else
                        {
                            var btc = db.WRBHBClientManagements.Where(s => s.Id == inpbo.CliendId).Select(s => s.BTC).FirstOrDefault();

                            if (btc == true)
                            {
                                inpbo.ServicePayMode = "Bill to Company (BTC)";
                                inpbo.TariffPayMode = "Bill to Company (BTC)";
                            }
                            else
                            {
                                inpbo.ServicePayMode = "Direct";
                                inpbo.TariffPayMode = "Direct";
                            }
                        }

                        if (inpbo.Level == "Room")
                        {
                            var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                                   datas.SingleTariff, datas.DoubleTariff, datas.TripleTariff, datas.SingleandMarkup, datas.DoubleandMarkup, datas.TripleTariff, 0, datas.SingleandMarkup1, datas.DoubleandMarkup1, datas.TripleandMarkup1, datas.TAC, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                                   datas.LocalityId, inpbo.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                                   datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId
                                                   }).FirstOrDefault();

                            var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, inpbo.EmployeeCode, inpbo.FirstName, inpbo.LastName, inpbo.guestId, "Single", inpbo.RoomType, inpbo.ServicePayMode, inpbo.TariffPayMode, inpbo.Total_Tariff,
                                                 inpbo.RoomId, inpbo.PropertyId, BookingProperty.Id, inpbo.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                                 select new
                                                 {
                                                     s.Id,
                                                     s.RowId

                                                 }).FirstOrDefault();
                            var RowId = (from s in db.RowIdSearching_FrontEnd("RowId", Booking.Id, "")
                                         select s.RowId_PayU).FirstOrDefault();

                            //return Redirect("http://www.staysimplyfied.com/payment/Default.aspx?" + RowId);

                            //mail.RoomBookingMail(Booking.Id);
                        }
                        else if (inpbo.Level == "Bed")
                        {
                            var BedBookingProperty = (from s in db.SP_BedBookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, 0, datas.Phone, datas.Email, datas.Locality, datas.LocalityId, inpbo.UserId, false, false, datas.DiscountAllowed, 0, 0)
                                                      select new
                                                      {
                                                          s.Id,
                                                          s.RowId
                                                      }).FirstOrDefault();

                            var BedAssignedGuest = (from s in db.SP_BedBookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, inpbo.EmployeeCode, inpbo.FirstName, inpbo.LastName, inpbo.guestId,
                                                    inpbo.BedType, inpbo.ServicePayMode, inpbo.TariffPayMode, inpbo.Total_Tariff, 0, inpbo.BedId, inpbo.PropertyId, BedBookingProperty.Id, inpbo.UserId, 0, "", "", "", "", "", "", "", "", "", "", "", 0)
                                                    select new
                                                    {
                                                        s.Id,
                                                        s.RowId
                                                    }).FirstOrDefault();

                            var RowId = (from s in db.RowIdSearching_FrontEnd("RowId", Booking.Id, "")
                                         select s.RowId_PayU).FirstOrDefault();

                            //return Redirect("http://www.staysimplyfied.com/payment/Default.aspx?" + RowId);
                            //mail.BedBookingMail(Booking.Id);

                        }
                        else
                        {
                            var ApartmentBookingProperty = (from s in db.SP_ApartmentBookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, inpbo.Total_Tariff, 0, 0, datas.Phone,
                                                            datas.Email, datas.Locality, datas.LocalityId, false, false, datas.DiscountAllowed, inpbo.UserId)
                                                            select new
                                                            {
                                                                s.Id,
                                                                s.RowId
                                                            }).FirstOrDefault();

                            var ApartmentAssignedGuest = (from s in db.SP_ApartmentBookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, inpbo.EmployeeCode, inpbo.FirstName, inpbo.LastName, inpbo.guestId, inpbo.ApartmentType, inpbo.ServicePayMode, inpbo.TariffPayMode, inpbo.Total_Tariff, inpbo.ApartmentId,
                                                         inpbo.PropertyId, ApartmentBookingProperty.Id, inpbo.UserId, 0, "", "", "", "", "", "", "", "", "", "", 0, "")
                                                          select new
                                                          {
                                                              s.Id,
                                                              s.RowId
                                                          }).FirstOrDefault();

                            var RowId = (from s in db.RowIdSearching_FrontEnd("RowId", Booking.Id, "")
                                         select s.RowId_PayU).FirstOrDefault();

                            //return Redirect("http://www.staysimplyfied.com/payment/Default.aspx?" + RowId);
                            //mail.ApartmentBookingMail(Booking.Id);
                        }
                    }
                }

            }

            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " InP  Booking Confirmation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }

            return RedirectToAction("Success", "Search");
        }

        public ActionResult CppExpBooking(string Details)
        {
            try
            {
                ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
                ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
                ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string UserType = Session["UserType"] != null ? Session["UserType"].ToString() : "";
                long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
                string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;
                string RoomCount = Session["NoOfRooms"] != null ? Convert.ToString(Session["NoOfRooms"]) : "";
                decimal guestCount1 = Session["g1"] != null ? Convert.ToDecimal(Session["g1"]) : 0;
                decimal guestCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
                decimal guestCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
                decimal guestCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
                decimal guestCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;
                char com = ',';
                string[] Property = Details.Split(com);
                if (UserType == "ENDUSER")
                {

                    CppExpBookingBO book = new CppExpBookingBO();

                    book.PropertyId = Convert.ToInt64(Property[0]);
                    book.SingleOccupancy = Convert.ToDecimal(Property[1]);
                    book.doubleOccupancy = Convert.ToDecimal(Property[2]);
                    book.PropertyName = Property[3];
                    book.ImageLocation = Convert.ToString(Property[4]);
                    book.PropertyType = Property[5];
                    book.RoomType = Property[6];
                    book.CheckIn = Session["CIN"] != null ? Convert.ToString(Session["CIN"]) : "";
                    book.Checkout = Session["COUT"] != null ? Convert.ToString(Session["COUT"]) : "";
                    book.Level = "Room";



                    using (HBEntities db = new HBEntities())
                    {
                        var destion = (from c in db.WRBHBCities
                                       join s in db.WRBHBStates on c.StateId equals s.Id
                                       where c.Id == cityid
                                       select new
                                       {
                                           c.Id,
                                           c.StateId,
                                           c.CityName,
                                           s.StateName,
                                           c.CityCode
                                       }).FirstOrDefault();


                        book.stateId = destion.StateId;
                        book.cityId = destion.Id;
                        book.CityName = destion.CityName;
                        book.SateName = destion.StateName;
                        book.CityCode = destion.CityCode;
                    }


                    book.Total_Tariff = book.SingleOccupancy;
                    book.RoomCount = "1 Room";


                    using (HBEntities db = new HBEntities())
                    {
                        var Clientuser = (from u in db.WRBHBClientManagementAddClientGuests
                                          join cm in db.WRBHBClientManagements on u.CltmgntId equals cm.Id
                                          where u.App_UserId == WebSecurity.CurrentUserId
                                          && u.IsActive == true && u.IsDeleted == false
                                          select new
                                          {
                                              u.Grade,
                                              cm.ClientName,
                                              u.CltmgntId,
                                              u.Id,
                                              u.FirstName,
                                              u.LastName,
                                              u.EmailId,
                                              u.Designation,
                                              u.EmpCode,
                                              u.GMobileNo,
                                              u.GradeId,
                                              u.Title
                                          }).FirstOrDefault();

                        book.FirstName = Clientuser.FirstName;
                        book.LastName = Clientuser.LastName;
                        book.Phno = Clientuser.GMobileNo;
                        book.Email = Clientuser.EmailId;
                        book.Designation = Clientuser.Designation;
                        book.EmployeeCode = Clientuser.EmpCode;
                        book.CliendId = Clientuser.CltmgntId;
                        book.ClientName = Clientuser.ClientName;
                        book.Grade = Clientuser.Grade;
                        book.UserId = Clientuser.Id;
                        book.GradeId = Clientuser.GradeId;
                        book.guestId = Clientuser.Id;
                        book.Title = Clientuser.Title;
                    }

                    if (book.PropertyType.ToUpper() == "MMT")
                    {

                        string[] data = { "", "", book.CityCode, Convert.ToString(book.PropertyId), Property[8], Property[7], checin, checout, Convert.ToString(apiheader), "1" };

                        //APIAvailabilityExistingDataDAO check = new APIAvailabilityExistingDataDAO();
                        MMTController check = new MMTController();
                        var mseg = check.FnAvailabilityExistingData(data);
                        if (mseg != "")
                        {
                            return RedirectToAction("NotAvailable", new { msg = mseg });
                        }
                        else
                        {
                            return RedirectToAction("MMTBooking", "Search", book);
                        }
                    }
                    book.TariffPayMode = "empty";
                    book.ServicePayMode = "empty";
                    return View(book);
                }
                else
                {
                    string empcode1 = Session["emp1"] != null ? Session["emp1"].ToString() : "";
                    string empcode2 = Session["emp2"] != null ? Session["emp2"].ToString() : "";
                    string empcode3 = Session["emp3"] != null ? Session["emp3"].ToString() : "";
                    string empcode4 = Session["emp4"] != null ? Session["emp4"].ToString() : "";
                    string empcode5 = Session["emp5"] != null ? Session["emp5"].ToString() : "";
                    string empcode6 = Session["emp6"] != null ? Session["emp6"].ToString() : "";
                    string empcode7 = Session["emp7"] != null ? Session["emp7"].ToString() : "";
                    string empcode8 = Session["emp8"] != null ? Session["emp8"].ToString() : "";
                    string empcode9 = Session["emp9"] != null ? Session["emp9"].ToString() : "";
                    string empcode10 = Session["emp10"] != null ? Session["emp10"].ToString() : "";

                    int count = Session["count"] != null ? Convert.ToInt32(Session["count"]) : 0;
                    CppExpTRBookingBO TRbook = new CppExpTRBookingBO();

                    TRbook.PropertyId = Convert.ToInt64(Property[0]);
                    TRbook.SingleOccupancy = Convert.ToDecimal(Property[1]);
                    TRbook.doubleOccupancy = Convert.ToDecimal(Property[2]);
                    TRbook.PropertyName = Property[3];
                    TRbook.ImageLocation = Convert.ToString(Property[4]);
                    TRbook.PropertyType = Property[5];
                    TRbook.RoomType = Property[6];
                    TRbook.CheckIn = Session["CIN"] != null ? Convert.ToString(Session["CIN"]) : "";
                    TRbook.Checkout = Session["COUT"] != null ? Convert.ToString(Session["COUT"]) : "";
                    TRbook.Level = "Room";
                    TRbook.Total_Tariff = GetTotalTariff(TRbook.SingleOccupancy, TRbook.doubleOccupancy);
                    TRbook.RoomCount = Session["NoOfRooms"] != null ? Session["NoOfRooms"].ToString() + " Rooms" : "";


                    using (HBEntities db = new HBEntities())
                    {
                        var destion = (from c in db.WRBHBCities
                                       join s in db.WRBHBStates on c.StateId equals s.Id
                                       where c.Id == cityid
                                       select new
                                       {
                                           c.Id,
                                           c.StateId,
                                           c.CityName,
                                           s.StateName,
                                           c.CityCode
                                       }).FirstOrDefault();


                        TRbook.stateId = destion.StateId;
                        TRbook.cityId = destion.Id;
                        TRbook.CityName = destion.CityName;
                        TRbook.SateName = destion.StateName;
                        TRbook.CityCode = destion.CityCode;


                        var Booker = (from u in db.WrbhbTravelDesks
                                      join cm in db.WRBHBClientManagements on u.ClientId equals cm.Id
                                      where u.App_UserId == WebSecurity.CurrentUserId
                                      && u.IsActive == true && u.IsDeleted == false
                                      select new
                                    {

                                        cm.ClientName,
                                        u.ClientId,
                                        u.Id,
                                        u.FirstName,
                                        u.LastName,
                                        u.Email,
                                        u.Designation
                                    }).FirstOrDefault();
                        TRbook.BookerMail = Booker.Email;
                        TRbook.BookerName = Booker.FirstName + " " + Booker.LastName;
                        TRbook.BookrerId = Booker.Id;
                        TRbook.CliendId = Booker.ClientId;
                        TRbook.ClientName = Booker.ClientName;
                        TRbook.UserId = Booker.Id;

                        var CustomFields = (from s in db.WRBHBClientColumns
                                            where s.ClientId == TRbook.CliendId
                                            select s).FirstOrDefault();
                        if (CustomFields != null)
                        {
                            TRbook.column1 = CustomFields.Column1;
                            TRbook.column2 = CustomFields.Column2;
                            TRbook.column3 = CustomFields.Column3;
                            TRbook.column4 = CustomFields.Column4;
                            TRbook.column5 = CustomFields.Column5;
                            TRbook.column6 = CustomFields.Column6;
                            TRbook.column7 = CustomFields.Column7;
                            TRbook.column8 = CustomFields.Column8;
                            TRbook.column9 = CustomFields.Column9;
                            TRbook.column10 = CustomFields.Column10;
                        }

                        if (count > 0)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode1
                                      select s).FirstOrDefault();
                            TRbook.FirstName1 = TD.FirstName;
                            TRbook.LastName1 = TD.LastName;
                            TRbook.Email1 = TD.EmailId;
                            TRbook.grade1 = TD.Grade;
                            TRbook.GradeId1 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno1 = TD.GMobileNo;
                            TRbook.EmployeeCode1 = TD.EmpCode;
                            TRbook.guestId1 = TD.Id;
                            TRbook.Title1 = TD.Title;
                            TRbook.Nationality1 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation1 = TD.Designation;
                            TRbook.Name1 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 1)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode2
                                      select s).FirstOrDefault();
                            TRbook.FirstName2 = TD.FirstName;
                            TRbook.LastName2 = TD.LastName;
                            TRbook.Email2 = TD.EmailId;
                            TRbook.grade2 = TD.Grade;
                            TRbook.GradeId2 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno2 = TD.GMobileNo;
                            TRbook.EmployeeCode2 = TD.EmpCode;
                            TRbook.guestId2 = TD.Id;
                            TRbook.Title2 = TD.Title;
                            TRbook.Nationality2 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation2 = TD.Designation;
                            TRbook.Name2 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 2)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode3
                                      select s).FirstOrDefault();
                            TRbook.FirstName3 = TD.FirstName;
                            TRbook.LastName3 = TD.LastName;
                            TRbook.Email3 = TD.EmailId;
                            TRbook.grade3 = TD.Grade;
                            TRbook.GradeId3 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno3 = TD.GMobileNo;
                            TRbook.EmployeeCode3 = TD.EmpCode;
                            TRbook.guestId3 = TD.Id;
                            TRbook.Title3 = TD.Title;
                            TRbook.Nationality3 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation3 = TD.Designation;
                            TRbook.Name3 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 3)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode4
                                      select s).FirstOrDefault();
                            TRbook.FirstName4 = TD.FirstName;
                            TRbook.LastName4 = TD.LastName;
                            TRbook.Email4 = TD.EmailId;
                            TRbook.grade4 = TD.Grade;
                            TRbook.GradeId4 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno4 = TD.GMobileNo;
                            TRbook.EmployeeCode4 = TD.EmpCode;
                            TRbook.guestId4 = TD.Id;
                            TRbook.Title4 = TD.Title;
                            TRbook.Nationality4 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation4 = TD.Designation;
                            TRbook.Name4 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 4)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode5
                                      select s).FirstOrDefault();
                            TRbook.FirstName5 = TD.FirstName;
                            TRbook.LastName5 = TD.LastName;
                            TRbook.Email5 = TD.EmailId;
                            TRbook.grade5 = TD.Grade;
                            TRbook.GradeId5 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno5 = TD.GMobileNo;
                            TRbook.EmployeeCode5 = TD.EmpCode;
                            TRbook.guestId5 = TD.Id;
                            TRbook.Title5 = TD.Title;
                            TRbook.Nationality5 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation5 = TD.Designation;
                            TRbook.Name5 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 5)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode6
                                      select s).FirstOrDefault();
                            TRbook.FirstName6 = TD.FirstName;
                            TRbook.LastName6 = TD.LastName;
                            TRbook.Email6 = TD.EmailId;
                            TRbook.grade6 = TD.Grade;
                            TRbook.GradeId6 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno6 = TD.GMobileNo;
                            TRbook.EmployeeCode6 = TD.EmpCode;
                            TRbook.guestId6 = TD.Id;
                            TRbook.Title6 = TD.Title;
                            TRbook.Nationality6 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation6 = TD.Designation;
                            TRbook.Name6 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 6)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode7
                                      select s).FirstOrDefault();
                            TRbook.FirstName7 = TD.FirstName;
                            TRbook.LastName7 = TD.LastName;
                            TRbook.Email7 = TD.EmailId;
                            TRbook.grade7 = TD.Grade;
                            TRbook.GradeId7 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno7 = TD.GMobileNo;
                            TRbook.EmployeeCode7 = TD.EmpCode;
                            TRbook.guestId7 = TD.Id;
                            TRbook.Title7 = TD.Title;
                            TRbook.Nationality7 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation7 = TD.Designation;
                            TRbook.Name7 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 7)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode8
                                      select s).FirstOrDefault();
                            TRbook.FirstName8 = TD.FirstName;
                            TRbook.LastName8 = TD.LastName;
                            TRbook.Email8 = TD.EmailId;
                            TRbook.grade8 = TD.Grade;
                            TRbook.GradeId8 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno8 = TD.GMobileNo;
                            TRbook.EmployeeCode8 = TD.EmpCode;
                            TRbook.guestId8 = TD.Id;
                            TRbook.Title8 = TD.Title;
                            TRbook.Nationality8 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation8 = TD.Designation;
                            TRbook.Name8 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 8)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode9
                                      select s).FirstOrDefault();
                            TRbook.FirstName9 = TD.FirstName;
                            TRbook.LastName9 = TD.LastName;
                            TRbook.Email9 = TD.EmailId;
                            TRbook.grade9 = TD.Grade;
                            TRbook.GradeId9 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno9 = TD.GMobileNo;
                            TRbook.EmployeeCode9 = TD.EmpCode;
                            TRbook.guestId9 = TD.Id;
                            TRbook.Title9 = TD.Title;
                            TRbook.Nationality9 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation9 = TD.Designation;
                            TRbook.Name9 = TD.FirstName + " " + TD.LastName;
                        }
                        if (count > 9)
                        {
                            var TD = (from s in db.WRBHBClientManagementAddClientGuests
                                      where s.EmpCode == empcode10
                                      select s).FirstOrDefault();
                            TRbook.FirstName10 = TD.FirstName;
                            TRbook.LastName10 = TD.LastName;
                            TRbook.Email10 = TD.EmailId;
                            TRbook.grade10 = TD.Grade;
                            TRbook.GradeId10 = TD.GradeId != null ? TD.GradeId : 0;
                            TRbook.Phno10 = TD.GMobileNo;
                            TRbook.EmployeeCode10 = TD.EmpCode;
                            TRbook.guestId10 = TD.Id;
                            TRbook.Title10 = TD.Title;
                            TRbook.Nationality10 = TD.Nationality != null ? TD.Nationality : "";
                            TRbook.Designation10 = TD.Designation;
                            TRbook.Name10 = TD.FirstName + " " + TD.LastName;
                        }
                    }

                    if (TRbook.PropertyType.ToUpper() == "MMT")
                    {

                        decimal Count1 = Session["g1"] != null ? Convert.ToDecimal(Session["g1"]) : 0;
                        decimal Count2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
                        decimal Count3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
                        decimal Count4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
                        decimal Count5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;

                        decimal singlecount = 0;
                        decimal doublecount = 0;
                        if (Count1 == 1)
                        {
                            singlecount += 1;
                        }
                        else if (Count1 == 2)
                        {
                            doublecount += 1;
                        }
                        if (Count2 == 1)
                        {
                            singlecount += 1;
                        }
                        else if (Count2 == 2)
                        {
                            doublecount += 1;
                        }
                        if (Count3 == 1)
                        {
                            singlecount += 1;
                        }
                        else if (Count3 == 2)
                        {
                            doublecount += 1;
                        }
                        if (Count4 == 1)
                        {
                            singlecount += 1;
                        }
                        else if (Count4 == 2)
                        {
                            doublecount += 1;
                        }
                        if (Count5 == 1)
                        {
                            singlecount += 1;
                        }
                        else if (Count5 == 2)
                        {
                            doublecount += 1;
                        }

                        string[] data = { "", "", TRbook.CityCode, Convert.ToString(TRbook.PropertyId), Property[8], Property[7], checin, checout, Convert.ToString(apiheader), count.ToString(), singlecount.ToString(), doublecount.ToString() };

                        //APIAvailabilityExistingDataDAO check = new APIAvailabilityExistingDataDAO();
                        MMTController check = new MMTController();
                        var mseg = check.FnAvailabilityExistingDataTR(data);
                        if (mseg != "")
                        {
                            return RedirectToAction("NotAvailable", new { msg = mseg });
                        }
                        else
                        {
                            return RedirectToAction("MMTBooking", "Search", TRbook);
                        }
                    }
                    TRbook.ServicePayMode = "empty";
                    TRbook.TariffPayMode = "empty";
                    TRbook.count = count;
                    return View("cppExpTRBooking", TRbook);
                }

            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " cpp or external or MMT  Booking creation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }

        }


        public ActionResult CppExpTRConfirmBooking(CppExpTRBookingBO cpextr)
        {
            SendingMailController mail = new SendingMailController();

            try
            {

                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                cpextr.specialrequst = cpextr.specialrequst != null ? cpextr.specialrequst : "";

                if (cpextr.PropertyType == "MGH" || cpextr.PropertyType == "SA" || cpextr.PropertyType == "CPP")
                    apiheader = 0;
                HBEntities dbs = new HBEntities();

                var datas = (from s in dbs.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, apiheader, cpextr.cityId, cpextr.CliendId, cpextr.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpextr.PropertyType)
                             select s).FirstOrDefault();


                if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                {
                    cpextr.ServicePayMode = "Direct";
                    cpextr.TariffPayMode = "Bill to Company (BTC)";
                }
                else if (datas.PropertyType.ToUpper() == "CPP")
                {
                    cpextr.ServicePayMode = "Bill to Client";
                    cpextr.TariffPayMode = "Bill to Client";
                }
                else
                {
                    var btc = dbs.WRBHBClientManagements.Where(s => s.Id == cpextr.CliendId).Select(s => s.BTC).FirstOrDefault();

                    if (btc == true)
                    {
                        cpextr.ServicePayMode = "Bill to Company (BTC)";
                        cpextr.TariffPayMode = "Bill to Company (BTC)";
                    }
                    else
                    {
                        cpextr.ServicePayMode = "Direct";
                        cpextr.TariffPayMode = "Direct";
                    }
                }



                HBEntities db = new HBEntities();

                var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(cpextr.CliendId, 0, cpextr.stateId, cpextr.cityId, cpextr.ClientName, cpextr.CheckIn, "12:00:00", cpextr.Checkout, "", cpextr.SateName, cpextr.CityName, cpextr.UserId,
                               "", "", cpextr.BookrerId, cpextr.BookerName, cpextr.BookerMail, true, "", cpextr.specialrequst, "RmdPty", "PM", cpextr.Level, false, "", "")
                               select new
                               {
                                   s.BookingCode,
                                   s.Id,
                                   s.RowId,
                                   s.ExpectedChkInTime
                               }).FirstOrDefault();

                if (Booking != null)
                {
                    var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                                 datas.SingleTariff, datas.DoubleTariff, datas.TripleTariff, datas.SingleandMarkup, datas.DoubleandMarkup, datas.TripleTariff, 0, datas.SingleandMarkup1, datas.DoubleandMarkup1, datas.TripleandMarkup1, datas.TAC, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                                 datas.LocalityId, cpextr.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                                 datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                           select new
                                           {
                                               s.Id,
                                               s.RowId
                                           }).FirstOrDefault();
                }

                if (cpextr.count > 0)
                {
                    cpextr.EmployeeCode1 = cpextr.EmployeeCode1 != null ? cpextr.EmployeeCode1 : "";
                    cpextr.grade1 = cpextr.grade1 != null ? cpextr.grade1 : "";
                    cpextr.Designation1 = cpextr.Designation1 != null ? cpextr.Designation1 : "";
                    cpextr.Nationality1 = cpextr.Nationality1 != null ? cpextr.Nationality1 : "";
                    cpextr.GradeId1 = cpextr.GradeId1 != null ? cpextr.GradeId1 : 0;
                    cpextr.Title1 = cpextr.Title1 != null ? cpextr.Title1 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId1);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId1, cpextr.Designation1, cpextr.FirstName1, cpextr.LastName1, cpextr.Email1, cpextr.EmployeeCode1, cpextr.UserId, cpextr.grade1, GradeID, cpextr.Nationality1, cpextr.Phno1, cpextr.Title1)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 1)
                {
                    cpextr.EmployeeCode2 = cpextr.EmployeeCode2 != null ? cpextr.EmployeeCode2 : "";
                    cpextr.grade2 = cpextr.grade2 != null ? cpextr.grade2 : "";
                    cpextr.Designation2 = cpextr.Designation2 != null ? cpextr.Designation2 : "";
                    cpextr.Nationality2 = cpextr.Nationality2 != null ? cpextr.Nationality2 : "";
                    cpextr.GradeId2 = cpextr.GradeId2 != null ? cpextr.GradeId2 : 0;
                    cpextr.Title2 = cpextr.Title2 != null ? cpextr.Title2 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId2);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId2, cpextr.Designation2, cpextr.FirstName2, cpextr.LastName2, cpextr.Email2, cpextr.EmployeeCode2, cpextr.UserId, cpextr.grade2, GradeID, cpextr.Nationality2, cpextr.Phno2, cpextr.Title2)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }

                if (cpextr.count > 2)
                {
                    cpextr.EmployeeCode3 = cpextr.EmployeeCode3 != null ? cpextr.EmployeeCode3 : "";
                    cpextr.grade3 = cpextr.grade3 != null ? cpextr.grade3 : "";
                    cpextr.Designation3 = cpextr.Designation3 != null ? cpextr.Designation3 : "";
                    cpextr.Nationality3 = cpextr.Nationality3 != null ? cpextr.Nationality3 : "";
                    cpextr.GradeId3 = cpextr.GradeId3 != null ? cpextr.GradeId3 : 0;
                    cpextr.Title3 = cpextr.Title3 != null ? cpextr.Title3 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId3);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId3, cpextr.Designation3, cpextr.FirstName3, cpextr.LastName3, cpextr.Email3, cpextr.EmployeeCode3, cpextr.UserId, cpextr.grade3, GradeID, cpextr.Nationality3, cpextr.Phno3, cpextr.Title3)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }

                if (cpextr.count > 3)
                {
                    cpextr.EmployeeCode4 = cpextr.EmployeeCode4 != null ? cpextr.EmployeeCode4 : "";
                    cpextr.grade4 = cpextr.grade4 != null ? cpextr.grade4 : "";
                    cpextr.Designation4 = cpextr.Designation4 != null ? cpextr.Designation4 : "";
                    cpextr.Nationality4 = cpextr.Nationality4 != null ? cpextr.Nationality4 : "";
                    cpextr.GradeId4 = cpextr.GradeId4 != null ? cpextr.GradeId4 : 0;
                    cpextr.Title4 = cpextr.Title4 != null ? cpextr.Title4 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId4);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId4, cpextr.Designation4, cpextr.FirstName4, cpextr.LastName4, cpextr.Email4, cpextr.EmployeeCode4, cpextr.UserId, cpextr.grade4, GradeID, cpextr.Nationality4, cpextr.Phno4, cpextr.Title4)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 4)
                {
                    cpextr.EmployeeCode5 = cpextr.EmployeeCode5 != null ? cpextr.EmployeeCode5 : "";
                    cpextr.grade5 = cpextr.grade5 != null ? cpextr.grade5 : "";
                    cpextr.Designation5 = cpextr.Designation5 != null ? cpextr.Designation5 : "";
                    cpextr.Nationality5 = cpextr.Nationality5 != null ? cpextr.Nationality5 : "";
                    cpextr.GradeId5 = cpextr.GradeId5 != null ? cpextr.GradeId5 : 0;
                    cpextr.Title5 = cpextr.Title5 != null ? cpextr.Title5 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId5);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId5, cpextr.Designation5, cpextr.FirstName5, cpextr.LastName5, cpextr.Email5, cpextr.EmployeeCode5, cpextr.UserId, cpextr.grade5, GradeID, cpextr.Nationality5, cpextr.Phno5, cpextr.Title5)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 5)
                {
                    cpextr.EmployeeCode6 = cpextr.EmployeeCode6 != null ? cpextr.EmployeeCode6 : "";
                    cpextr.grade6 = cpextr.grade6 != null ? cpextr.grade6 : "";
                    cpextr.Designation6 = cpextr.Designation6 != null ? cpextr.Designation6 : "";
                    cpextr.Nationality6 = cpextr.Nationality6 != null ? cpextr.Nationality6 : "";
                    cpextr.GradeId6 = cpextr.GradeId6 != null ? cpextr.GradeId6 : 0;
                    cpextr.Title6 = cpextr.Title6 != null ? cpextr.Title6 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId6);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId6, cpextr.Designation6, cpextr.FirstName6, cpextr.LastName6, cpextr.Email6, cpextr.EmployeeCode6, cpextr.UserId, cpextr.grade6, GradeID, cpextr.Nationality6, cpextr.Phno6, cpextr.Title6)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 6)
                {
                    cpextr.EmployeeCode7 = cpextr.EmployeeCode7 != null ? cpextr.EmployeeCode7 : "";
                    cpextr.grade7 = cpextr.grade7 != null ? cpextr.grade7 : "";
                    cpextr.Designation7 = cpextr.Designation7 != null ? cpextr.Designation7 : "";
                    cpextr.Nationality7 = cpextr.Nationality7 != null ? cpextr.Nationality7 : "";
                    cpextr.GradeId7 = cpextr.GradeId7 != null ? cpextr.GradeId7 : 0;
                    cpextr.Title7 = cpextr.Title7 != null ? cpextr.Title7 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId7);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId7, cpextr.Designation7, cpextr.FirstName7, cpextr.LastName7, cpextr.Email7, cpextr.EmployeeCode7, cpextr.UserId, cpextr.grade7, GradeID, cpextr.Nationality7, cpextr.Phno7, cpextr.Title7)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 7)
                {
                    cpextr.EmployeeCode8 = cpextr.EmployeeCode8 != null ? cpextr.EmployeeCode8 : "";
                    cpextr.grade8 = cpextr.grade8 != null ? cpextr.grade8 : "";
                    cpextr.Designation8 = cpextr.Designation8 != null ? cpextr.Designation8 : "";
                    cpextr.Nationality8 = cpextr.Nationality8 != null ? cpextr.Nationality8 : "";
                    cpextr.GradeId8 = cpextr.GradeId8 != null ? cpextr.GradeId8 : 0;
                    cpextr.Title8 = cpextr.Title8 != null ? cpextr.Title8 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId8);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId8, cpextr.Designation8, cpextr.FirstName8, cpextr.LastName8, cpextr.Email8, cpextr.EmployeeCode8, cpextr.UserId, cpextr.grade8, GradeID, cpextr.Nationality8, cpextr.Phno8, cpextr.Title8)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }

                }
                if (cpextr.count > 8)
                {
                    cpextr.EmployeeCode9 = cpextr.EmployeeCode9 != null ? cpextr.EmployeeCode9 : "";
                    cpextr.grade9 = cpextr.grade9 != null ? cpextr.grade9 : "";
                    cpextr.Designation9 = cpextr.Designation9 != null ? cpextr.Designation9 : "";
                    cpextr.Nationality9 = cpextr.Nationality9 != null ? cpextr.Nationality9 : "";
                    cpextr.GradeId9 = cpextr.GradeId9 != null ? cpextr.GradeId9 : 0;
                    cpextr.Title9 = cpextr.Title9 != null ? cpextr.Title9 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId9);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId9, cpextr.Designation9, cpextr.FirstName9, cpextr.LastName9, cpextr.Email9, cpextr.EmployeeCode9, cpextr.UserId, cpextr.grade9, GradeID, cpextr.Nationality9, cpextr.Phno9, cpextr.Title9)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 9)
                {
                    cpextr.EmployeeCode10 = cpextr.EmployeeCode10 != null ? cpextr.EmployeeCode10 : "";
                    cpextr.grade10 = cpextr.grade10 != null ? cpextr.grade10 : "";
                    cpextr.Designation10 = cpextr.Designation10 != null ? cpextr.Designation10 : "";
                    cpextr.Nationality10 = cpextr.Nationality10 != null ? cpextr.Nationality10 : "";
                    cpextr.GradeId9 = cpextr.GradeId9 != null ? cpextr.GradeId9 : 0;
                    cpextr.Title10 = cpextr.Title10 != null ? cpextr.Title10 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId2);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId10, cpextr.Designation10, cpextr.FirstName10, cpextr.LastName10, cpextr.Email10, cpextr.EmployeeCode10, cpextr.UserId, cpextr.grade10, GradeID, cpextr.Nationality10, cpextr.Phno10, cpextr.Title10)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                    }
                }

                mail.RecomentationMail(Booking.Id);
            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog("cpp or external TR Confirm Booking " + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }
            return RedirectToAction("Waiting", "Search");
        }

        [HttpPost]
        public ActionResult CppExpBooking(CppExpBookingBO cpexp)
        {
            SendingMailController mail = new SendingMailController();

            try
            {
                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                cpexp.EmployeeCode = cpexp.EmployeeCode != null ? cpexp.EmployeeCode : "";
                cpexp.Grade = cpexp.Grade != null ? cpexp.Grade : "";
                cpexp.Designation = cpexp.Designation != null ? cpexp.Designation : "";
                cpexp.specialrequst = cpexp.specialrequst != null ? cpexp.specialrequst : "";
                cpexp.Nationality = cpexp.Nationality != null ? cpexp.Nationality : "";
                using (HBEntities db = new HBEntities())
                {

                    var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(cpexp.CliendId, cpexp.GradeId, cpexp.stateId, cpexp.cityId, cpexp.ClientName, cpexp.CheckIn, "12:00:00", cpexp.Checkout, cpexp.Grade, cpexp.SateName, cpexp.CityName, cpexp.UserId,
                                   "", "", cpexp.UserId, cpexp.FirstName + " " + cpexp.LastName, cpexp.Email, true, "", cpexp.specialrequst, "RmdPty", "PM", cpexp.Level, false, "", "")
                                   select new
                                   {
                                       s.BookingCode,
                                       s.Id,
                                       s.RowId,
                                       s.ExpectedChkInTime
                                   }).FirstOrDefault();
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpexp.GradeId);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpexp.guestId, cpexp.Designation, cpexp.FirstName, cpexp.LastName, cpexp.Email, cpexp.EmployeeCode, cpexp.UserId, cpexp.Grade, GradeID, cpexp.Nationality, cpexp.Phno, cpexp.Title)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();
                        if (cpexp.PropertyType == "MGH" || cpexp.PropertyType == "SA" || cpexp.PropertyType == "CPP")
                            apiheader = 0;

                        var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, apiheader, cpexp.cityId, cpexp.CliendId, cpexp.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpexp.PropertyType)
                                     select s).FirstOrDefault();

                        if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                        {
                            cpexp.ServicePayMode = "Direct";
                            cpexp.TariffPayMode = "Bill to Company (BTC)";
                        }
                        else if (datas.PropertyType.ToUpper() == "CPP")
                        {
                            cpexp.ServicePayMode = "Bill to Client";
                            cpexp.TariffPayMode = "Bill to Client";
                        }
                        else
                        {
                            var btc = db.WRBHBClientManagements.Where(s => s.Id == cpexp.CliendId).Select(s => s.BTC).FirstOrDefault();

                            if (btc == true)
                            {
                                cpexp.ServicePayMode = "Bill to Company (BTC)";
                                cpexp.TariffPayMode = "Bill to Company (BTC)";
                            }
                            else
                            {
                                cpexp.ServicePayMode = "Direct";
                                cpexp.TariffPayMode = "Direct";
                            }
                        }

                        var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                                  datas.SingleTariff, datas.DoubleTariff, datas.TripleTariff, datas.SingleandMarkup, datas.DoubleandMarkup, datas.TripleTariff, 0, datas.SingleandMarkup1, datas.DoubleandMarkup1, datas.TripleandMarkup1, datas.TAC, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                                  datas.LocalityId, cpexp.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                                  datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                               select new
                                               {
                                                   s.Id,
                                                   s.RowId
                                               }).FirstOrDefault();
                    }


                    //mail.RecomentationMail(Booking.Id);
                }
            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog("cpp or external Confirm Booking " + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }

            return RedirectToAction("Waiting", "Search");
        }

        public ActionResult MMTBooking(CppExpBookingBO cpexp)
        {


            long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
            long? stateId = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;

            using (HBEntities db = new HBEntities())
            {
                var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checin, checout, stateId, cityid, cliendid, cpexp.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpexp.PropertyType)
                             where s.PropertyId == cpexp.PropertyId
                             select s).FirstOrDefault();
                if (cpexp.Total_Tariff != datas.SingleandMarkup1)
                    ViewBag.UpdateTarrif = "The Tarrif Updated for your Booking..Please check before Comfirm";

                cpexp.Total_Tariff = datas.SingleandMarkup1;
                return View(cpexp);
            }
        }

        public ActionResult MMTConfirmBooking(CppExpBookingBO cpexp)
        {
            SendingMailController mail = new SendingMailController();

            try
            {

                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                cpexp.EmployeeCode = cpexp.EmployeeCode != null ? cpexp.EmployeeCode : "";
                cpexp.Grade = cpexp.Grade != null ? cpexp.Grade : "";
                cpexp.Designation = cpexp.Designation != null ? cpexp.Designation : "";
                cpexp.specialrequst = cpexp.specialrequst != null ? cpexp.specialrequst : "";
                cpexp.Nationality = cpexp.Nationality != null ? cpexp.Nationality : "";
                using (HBEntities db = new HBEntities())
                {

                    var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(cpexp.CliendId, cpexp.GradeId, cpexp.stateId, cpexp.cityId, cpexp.ClientName, cpexp.CheckIn, "12:00:00", cpexp.Checkout, cpexp.Grade, cpexp.SateName, cpexp.CityName, cpexp.UserId,
                                   "", "", cpexp.UserId, cpexp.FirstName + " " + cpexp.LastName, cpexp.Email, true, "", cpexp.specialrequst, "RmdPty", "PM", cpexp.Level, false, "", "")
                                   select new
                                   {
                                       s.BookingCode,
                                       s.Id,
                                       s.RowId,
                                       s.ExpectedChkInTime
                                   }).FirstOrDefault();
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpexp.GradeId);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpexp.guestId, cpexp.Designation, cpexp.FirstName, cpexp.LastName, cpexp.Email, cpexp.EmployeeCode, cpexp.UserId, cpexp.Grade, GradeID, cpexp.Nationality, cpexp.Phno, cpexp.Title)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();


                        var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, apiheader, cpexp.cityId, cpexp.CliendId, cpexp.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpexp.PropertyType)
                                     select s).FirstOrDefault();

                        if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                        {
                            cpexp.ServicePayMode = "Direct";
                            cpexp.TariffPayMode = "Bill to Company (BTC)";
                        }
                        else if (datas.PropertyType.ToUpper() == "CPP")
                        {
                            cpexp.ServicePayMode = "Bill to Client";
                            cpexp.TariffPayMode = "Bill to Client";
                        }
                        else
                        {
                            var btc = db.WRBHBClientManagements.Where(s => s.Id == cpexp.CliendId).Select(s => s.BTC).FirstOrDefault();

                            if (btc == true)
                            {
                                cpexp.ServicePayMode = "Bill to Company (BTC)";
                                cpexp.TariffPayMode = "Bill to Company (BTC)";
                            }
                            else
                            {
                                cpexp.ServicePayMode = "Direct";
                                cpexp.TariffPayMode = "Direct";
                            }
                        }

                        var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                                  datas.SingleTariff, datas.DoubleTariff, datas.TripleTariff, datas.SingleandMarkup, datas.DoubleandMarkup, datas.TripleTariff, 0, datas.SingleandMarkup1, datas.DoubleandMarkup1, datas.TripleandMarkup1, datas.TAC, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                                  datas.LocalityId, cpexp.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                                  datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                               select new
                                               {
                                                   s.Id,
                                                   s.RowId
                                               }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpexp.EmployeeCode, cpexp.FirstName, cpexp.LastName, cpexp.guestId, "Single", cpexp.RoomType, cpexp.ServicePayMode, cpexp.TariffPayMode, cpexp.Total_Tariff,
                                               cpexp.RoomId, cpexp.PropertyId, BookingProperty.Id, cpexp.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                        var RowId = (from s in db.RowIdSearching_FrontEnd("RowId", Booking.Id, "")
                                     select s.RowId_PayU).FirstOrDefault();

                        // return Redirect("http://www.staysimplyfied.com/payment/Default.aspx?" + RowId);

                    }
                }
            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog(ex.Message + " MMT  Booking Confirmation" + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }
            return RedirectToAction("Success", "Search");
        }

        public ActionResult MMTTRBooking(CppExpTRBookingBO cpexp)
        {

            long? cityid = Session["cityid"] != null ? Convert.ToInt64(Session["cityid"]) : 0;
            long? stateId = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
            string checin = Session["checindate"] != null ? Session["checindate"].ToString() : "";
            string checout = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
            long? cliendid = Session["client"] != null ? Convert.ToInt64(Session["client"]) : 0;

            using (HBEntities db = new HBEntities())
            {
                decimal currentTarrif;
                var datas = (from s in db.SP_New_Booking_FrontEnd_Help("Property", "", "", checin, checout, stateId, cityid, cliendid, cpexp.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpexp.PropertyType)
                             where s.PropertyId == cpexp.PropertyId
                             select s).FirstOrDefault();
                currentTarrif = GetTotalTariff(datas.SingleandMarkup1, datas.DoubleandMarkup1);
                if (cpexp.Total_Tariff != currentTarrif)
                    ViewBag.UpdateTarrif = "The Tarrif Updated for your Booking..Please check before Comfirm";

                cpexp.Total_Tariff = datas.SingleandMarkup1;
                return View(cpexp);
            }
        }

        public ActionResult MMTTRConfirmBooking(CppExpTRBookingBO cpextr)
        {

            SendingMailController mail = new SendingMailController();

            try
            {

                string checinDt = Session["checindate"] != null ? Session["checindate"].ToString() : "";
                string checoutDt = Session["checoutdate"] != null ? Session["checoutdate"].ToString() : "";
                long? apiheader = Session["Api"] != null ? Convert.ToInt64(Session["Api"]) : 0;
                string checin = Session["chi"] != null ? Session["chi"].ToString() : "";
                string checout = Session["cho"] != null ? Session["cho"].ToString() : "";
                cpextr.specialrequst = cpextr.specialrequst != null ? cpextr.specialrequst : "";

                if (cpextr.PropertyType == "MGH" || cpextr.PropertyType == "SA" || cpextr.PropertyType == "CPP")
                    apiheader = 0;
                HBEntities dbs = new HBEntities();

                var datas = (from s in dbs.SP_New_Booking_FrontEnd_Help("Property", "", "", checinDt, checoutDt, apiheader, cpextr.cityId, cpextr.CliendId, cpextr.PropertyId, 0, 0, 0, "SECOND", 0, 0, cpextr.PropertyType)
                             select s).FirstOrDefault();


                if (datas.PropertyType.ToUpper() == "MGH" || datas.PropertyType.ToUpper() == "MMT")
                {
                    cpextr.ServicePayMode = "Direct";
                    cpextr.TariffPayMode = "Bill to Company (BTC)";
                }
                else if (datas.PropertyType.ToUpper() == "CPP")
                {
                    cpextr.ServicePayMode = "Bill to Client";
                    cpextr.TariffPayMode = "Bill to Client";
                }
                else
                {
                    var btc = dbs.WRBHBClientManagements.Where(s => s.Id == cpextr.CliendId).Select(s => s.BTC).FirstOrDefault();

                    if (btc == true)
                    {
                        cpextr.ServicePayMode = "Bill to Company (BTC)";
                        cpextr.TariffPayMode = "Bill to Company (BTC)";
                    }
                    else
                    {
                        cpextr.ServicePayMode = "Direct";
                        cpextr.TariffPayMode = "Direct";
                    }
                }
                decimal GCount1 = Session["g1"] != null ? Convert.ToDecimal(Session["g1"]) : 0;
                decimal GCount2 = Session["g2"] != null ? Convert.ToDecimal(Session["g2"]) : 0;
                decimal GCount3 = Session["g3"] != null ? Convert.ToDecimal(Session["g3"]) : 0;
                decimal GCount4 = Session["g4"] != null ? Convert.ToDecimal(Session["g4"]) : 0;
                decimal GCount5 = Session["g5"] != null ? Convert.ToDecimal(Session["g5"]) : 0;


                HBEntities db = new HBEntities();

                var Booking = (from s in db.Sp_Booking_Insert_FrontEnd(cpextr.CliendId, 0, cpextr.stateId, cpextr.cityId, cpextr.ClientName, cpextr.CheckIn, "12:00:00", cpextr.Checkout, "", cpextr.SateName, cpextr.CityName, cpextr.UserId,
                               "", "", cpextr.BookrerId, cpextr.BookerName, cpextr.BookerMail, true, "", cpextr.specialrequst, "RmdPty", "PM", cpextr.Level, false, "", "")
                               select new
                               {
                                   s.BookingCode,
                                   s.Id,
                                   s.RowId,
                                   s.ExpectedChkInTime
                               }).FirstOrDefault();

                var BookingProperty = (from s in db.SP_BookingProperty_Insert_FrontEnd(Booking.Id, datas.PropertyName, datas.PropertyId, datas.GetType, datas.PropertyType, datas.RoomType,
                                             datas.SingleTariff, datas.DoubleTariff, datas.TripleTariff, datas.SingleandMarkup, datas.DoubleandMarkup, datas.TripleTariff, 0, datas.SingleandMarkup1, datas.DoubleandMarkup1, datas.TripleandMarkup1, datas.TAC, datas.Inclusions, datas.DiscountModeRS, datas.DiscountModePer, datas.DiscountAllowed, datas.Phone, datas.Email, datas.Locality,
                                             datas.LocalityId, cpextr.UserId, datas.MarkupId, datas.APIHdrId, datas.RatePlanCode, datas.RoomTypeCode, 0, datas.TaxAdded, datas.LTAgreed, datas.LTRack,
                                             datas.STAgreed, datas.TaxInclusive, datas.BaseTariff, datas.GeneralMarkup, datas.SC)
                                       select new
                                       {
                                           s.Id,
                                           s.RowId
                                       }).FirstOrDefault();


                if (cpextr.count > 0)
                {
                    string occupancy = GCount1 == 1 ? "Single" : "Double";
                    cpextr.EmployeeCode1 = cpextr.EmployeeCode1 != null ? cpextr.EmployeeCode1 : "";
                    cpextr.grade1 = cpextr.grade1 != null ? cpextr.grade1 : "";
                    cpextr.Designation1 = cpextr.Designation1 != null ? cpextr.Designation1 : "";
                    cpextr.Nationality1 = cpextr.Nationality1 != null ? cpextr.Nationality1 : "";
                    cpextr.GradeId1 = cpextr.GradeId1 != null ? cpextr.GradeId1 : 0;
                    cpextr.Title1 = cpextr.Title1 != null ? cpextr.Title1 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId1);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId1, cpextr.Designation1, cpextr.FirstName1, cpextr.LastName1, cpextr.Email1, cpextr.EmployeeCode1, cpextr.UserId, cpextr.grade1, GradeID, cpextr.Nationality1, cpextr.Phno1, cpextr.Title1)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();


                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode1, cpextr.FirstName1, cpextr.LastName1, cpextr.guestId1, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                               cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }



                }
                if (cpextr.count > 1)
                {
                    cpextr.EmployeeCode2 = cpextr.EmployeeCode2 != null ? cpextr.EmployeeCode2 : "";
                    cpextr.grade2 = cpextr.grade2 != null ? cpextr.grade2 : "";
                    cpextr.Designation2 = cpextr.Designation2 != null ? cpextr.Designation2 : "";
                    cpextr.Nationality2 = cpextr.Nationality2 != null ? cpextr.Nationality2 : "";
                    cpextr.GradeId2 = cpextr.GradeId2 != null ? cpextr.GradeId2 : 0;
                    cpextr.Title2 = cpextr.Title2 != null ? cpextr.Title2 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId2);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId2, cpextr.Designation2, cpextr.FirstName2, cpextr.LastName2, cpextr.Email2, cpextr.EmployeeCode2, cpextr.UserId, cpextr.grade2, GradeID, cpextr.Nationality2, cpextr.Phno2, cpextr.Title2)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode3, cpextr.FirstName3, cpextr.LastName3, cpextr.guestId3, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }

                if (cpextr.count > 2)
                {
                    cpextr.EmployeeCode3 = cpextr.EmployeeCode3 != null ? cpextr.EmployeeCode3 : "";
                    cpextr.grade3 = cpextr.grade3 != null ? cpextr.grade3 : "";
                    cpextr.Designation3 = cpextr.Designation3 != null ? cpextr.Designation3 : "";
                    cpextr.Nationality3 = cpextr.Nationality3 != null ? cpextr.Nationality3 : "";
                    cpextr.GradeId3 = cpextr.GradeId3 != null ? cpextr.GradeId3 : 0;
                    cpextr.Title3 = cpextr.Title3 != null ? cpextr.Title3 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId3);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId3, cpextr.Designation3, cpextr.FirstName3, cpextr.LastName3, cpextr.Email3, cpextr.EmployeeCode3, cpextr.UserId, cpextr.grade3, GradeID, cpextr.Nationality3, cpextr.Phno3, cpextr.Title3)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode3, cpextr.FirstName3, cpextr.LastName3, cpextr.guestId3, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }

                if (cpextr.count > 3)
                {
                    cpextr.EmployeeCode4 = cpextr.EmployeeCode4 != null ? cpextr.EmployeeCode4 : "";
                    cpextr.grade4 = cpextr.grade4 != null ? cpextr.grade4 : "";
                    cpextr.Designation4 = cpextr.Designation4 != null ? cpextr.Designation4 : "";
                    cpextr.Nationality4 = cpextr.Nationality4 != null ? cpextr.Nationality4 : "";
                    cpextr.GradeId4 = cpextr.GradeId4 != null ? cpextr.GradeId4 : 0;
                    cpextr.Title4 = cpextr.Title4 != null ? cpextr.Title4 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId4);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId4, cpextr.Designation4, cpextr.FirstName4, cpextr.LastName4, cpextr.Email4, cpextr.EmployeeCode4, cpextr.UserId, cpextr.grade4, GradeID, cpextr.Nationality4, cpextr.Phno4, cpextr.Title4)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode4, cpextr.FirstName4, cpextr.LastName4, cpextr.guestId4, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 4)
                {
                    cpextr.EmployeeCode5 = cpextr.EmployeeCode5 != null ? cpextr.EmployeeCode5 : "";
                    cpextr.grade5 = cpextr.grade5 != null ? cpextr.grade5 : "";
                    cpextr.Designation5 = cpextr.Designation5 != null ? cpextr.Designation5 : "";
                    cpextr.Nationality5 = cpextr.Nationality5 != null ? cpextr.Nationality5 : "";
                    cpextr.GradeId5 = cpextr.GradeId5 != null ? cpextr.GradeId5 : 0;
                    cpextr.Title5 = cpextr.Title5 != null ? cpextr.Title5 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId5);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId5, cpextr.Designation5, cpextr.FirstName5, cpextr.LastName5, cpextr.Email5, cpextr.EmployeeCode5, cpextr.UserId, cpextr.grade5, GradeID, cpextr.Nationality5, cpextr.Phno5, cpextr.Title5)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode5, cpextr.FirstName5, cpextr.LastName5, cpextr.guestId5, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 5)
                {
                    cpextr.EmployeeCode6 = cpextr.EmployeeCode6 != null ? cpextr.EmployeeCode6 : "";
                    cpextr.grade6 = cpextr.grade6 != null ? cpextr.grade6 : "";
                    cpextr.Designation6 = cpextr.Designation6 != null ? cpextr.Designation6 : "";
                    cpextr.Nationality6 = cpextr.Nationality6 != null ? cpextr.Nationality6 : "";
                    cpextr.GradeId6 = cpextr.GradeId6 != null ? cpextr.GradeId6 : 0;
                    cpextr.Title6 = cpextr.Title6 != null ? cpextr.Title6 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId6);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId6, cpextr.Designation6, cpextr.FirstName6, cpextr.LastName6, cpextr.Email6, cpextr.EmployeeCode6, cpextr.UserId, cpextr.grade6, GradeID, cpextr.Nationality6, cpextr.Phno6, cpextr.Title6)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode6, cpextr.FirstName6, cpextr.LastName6, cpextr.guestId6, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 6)
                {
                    cpextr.EmployeeCode7 = cpextr.EmployeeCode7 != null ? cpextr.EmployeeCode7 : "";
                    cpextr.grade7 = cpextr.grade7 != null ? cpextr.grade7 : "";
                    cpextr.Designation7 = cpextr.Designation7 != null ? cpextr.Designation7 : "";
                    cpextr.Nationality7 = cpextr.Nationality7 != null ? cpextr.Nationality7 : "";
                    cpextr.GradeId7 = cpextr.GradeId7 != null ? cpextr.GradeId7 : 0;
                    cpextr.Title7 = cpextr.Title7 != null ? cpextr.Title7 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId7);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId7, cpextr.Designation7, cpextr.FirstName7, cpextr.LastName7, cpextr.Email7, cpextr.EmployeeCode7, cpextr.UserId, cpextr.grade7, GradeID, cpextr.Nationality7, cpextr.Phno7, cpextr.Title7)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode7, cpextr.FirstName7, cpextr.LastName7, cpextr.guestId7, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 7)
                {
                    cpextr.EmployeeCode8 = cpextr.EmployeeCode8 != null ? cpextr.EmployeeCode8 : "";
                    cpextr.grade8 = cpextr.grade8 != null ? cpextr.grade8 : "";
                    cpextr.Designation8 = cpextr.Designation8 != null ? cpextr.Designation8 : "";
                    cpextr.Nationality8 = cpextr.Nationality8 != null ? cpextr.Nationality8 : "";
                    cpextr.GradeId8 = cpextr.GradeId8 != null ? cpextr.GradeId8 : 0;
                    cpextr.Title8 = cpextr.Title8 != null ? cpextr.Title8 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId8);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId8, cpextr.Designation8, cpextr.FirstName8, cpextr.LastName8, cpextr.Email8, cpextr.EmployeeCode8, cpextr.UserId, cpextr.grade8, GradeID, cpextr.Nationality8, cpextr.Phno8, cpextr.Title8)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode8, cpextr.FirstName8, cpextr.LastName8, cpextr.guestId8, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }

                }
                if (cpextr.count > 8)
                {
                    cpextr.EmployeeCode9 = cpextr.EmployeeCode9 != null ? cpextr.EmployeeCode9 : "";
                    cpextr.grade9 = cpextr.grade9 != null ? cpextr.grade9 : "";
                    cpextr.Designation9 = cpextr.Designation9 != null ? cpextr.Designation9 : "";
                    cpextr.Nationality9 = cpextr.Nationality9 != null ? cpextr.Nationality9 : "";
                    cpextr.GradeId9 = cpextr.GradeId9 != null ? cpextr.GradeId9 : 0;
                    cpextr.Title9 = cpextr.Title9 != null ? cpextr.Title9 : "";
                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId9);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId9, cpextr.Designation9, cpextr.FirstName9, cpextr.LastName9, cpextr.Email9, cpextr.EmployeeCode9, cpextr.UserId, cpextr.grade9, GradeID, cpextr.Nationality9, cpextr.Phno9, cpextr.Title9)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode9, cpextr.FirstName9, cpextr.LastName9, cpextr.guestId9, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }
                if (cpextr.count > 9)
                {
                    cpextr.EmployeeCode10 = cpextr.EmployeeCode10 != null ? cpextr.EmployeeCode10 : "";
                    cpextr.grade10 = cpextr.grade10 != null ? cpextr.grade10 : "";
                    cpextr.Designation10 = cpextr.Designation10 != null ? cpextr.Designation10 : "";
                    cpextr.Nationality10 = cpextr.Nationality10 != null ? cpextr.Nationality10 : "";
                    cpextr.GradeId9 = cpextr.GradeId9 != null ? cpextr.GradeId9 : 0;
                    cpextr.Title10 = cpextr.Title10 != null ? cpextr.Title10 : "";

                    if (Booking != null)
                    {
                        int? GradeID = Convert.ToInt32(cpextr.GradeId2);

                        var BookingGuestDetails = (from s in db.Sp_BookingGuestDetails_Insert_FrontEnd(Booking.Id, cpextr.guestId10, cpextr.Designation10, cpextr.FirstName10, cpextr.LastName10, cpextr.Email10, cpextr.EmployeeCode10, cpextr.UserId, cpextr.grade10, GradeID, cpextr.Nationality10, cpextr.Phno10, cpextr.Title10)
                                                   select new
                                                   {
                                                       s.Id,
                                                       s.RowId,
                                                       s.GuestId
                                                   }).FirstOrDefault();

                        var AssignedGuest = (from s in db.SP_BookingPropertyAssingedGuest_Insert_FrontEnd(Booking.Id, cpextr.EmployeeCode10, cpextr.FirstName10, cpextr.LastName10, cpextr.guestId10, "Single", cpextr.RoomType, cpextr.ServicePayMode, cpextr.TariffPayMode, cpextr.Total_Tariff,
                                              cpextr.RoomId, cpextr.PropertyId, BookingProperty.Id, cpextr.UserId, 0, 0, "", "", "", "", "", "", "", "", "", "", "")
                                             select new
                                             {
                                                 s.Id,
                                                 s.RowId

                                             }).FirstOrDefault();
                    }
                }

                mail.RecomentationMail(Booking.Id);
            }
            catch (DbUpdateException ex)
            {
                CreateLogFiles LOG = new CreateLogFiles();
                LOG.ErrorLog("cpp or external TR Confirm Booking " + WebSecurity.CurrentUserName);
                return RedirectToAction("Failure", "Search");
            }
            return RedirectToAction("Waiting", "Search");
        }

        public ActionResult Success()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            return View();
        }

        public ActionResult Failure(string msg)
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            ViewBag.mssg = msg;
            return View();
        }

        public ActionResult Waiting()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";

            return View();
        }

        public ActionResult NotAvailable(string msg)
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            ViewBag.errmsg = msg;
            if (msg == "Error")
                ViewBag.ERROR = msg;
            return View();
        }

        public ActionResult NoItems()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            return View();
        }

        public ActionResult Working()
        {
            ViewBag.Dest = Session["dest"] != null ? Session["dest"] : "";
            ViewBag.IN = Session["fntin"] != null ? Session["fntin"] : "";
            ViewBag.OUT = Session["fntout"] != null ? Session["fntout"] : "";
            return View();
        }


    }

    public class SendingMailController : Controller
    {
        HBEntities db = new HBEntities();
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string Err;
        string UserData;
        public DataSet RoomBookingMail(Int64 BookingId)
        {

            //UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            // "', SctId:" + user.SctId + ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            DataTable dT = new DataTable("Table12");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds = new DataSet();

            command.CommandText = "SP_BookingDtls_Help_FrontEnd";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "RoomBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            Err = "";
            try
            {
                string Flag = "true";
                string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";
                for (int j = 0; j < ds.Tables[9].Rows.Count; j++)
                {
                    if (ds.Tables[9].Rows[j][0].ToString() != "")
                    {
                        System.Text.RegularExpressions.Match match =
                            Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                        if (!match.Success)
                        {
                            if (Flag == "true")
                            {
                                Err += ds.Tables[9].Rows[j][0].ToString(); Flag = "false";
                            }
                            else
                            {
                                Err = Err + ", " + ds.Tables[9].Rows[j][0].ToString();
                            }
                        }
                    }
                }
                if (Err != "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                    return ds;
                }
                if (Err == "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                }
                if (ds.Tables[10].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][15].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][14].ToString(), "", System.Text.Encoding.UTF8);
                }
                message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                message.Subject = "Test Booking - " + ds.Tables[2].Rows[0][2].ToString();
                //message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                //if (ds.Tables[4].Rows[0][0].ToString() == "0")
                //{
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                //else
                //{
                //    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                //    {
                //        if (ds.Tables[5].Rows[i][0].ToString() != "")
                //        {
                //            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                //        }
                //    }
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                ////Extra CC
                //for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                //{
                //    if (ds.Tables[7].Rows[i][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                //    }
                //}
                //// Extra CC email from Front end
                //if (ds.Tables[8].Rows[0][2].ToString() != "")
                //{
                //    string ExtraCC = ds.Tables[8].Rows[0][2].ToString();
                //    var ExtraCCEmail = ExtraCC.Split(',');
                //    int cnt = ExtraCCEmail.Length;
                //    for (int i = 0; i < cnt; i++)
                //    {
                //        if (ExtraCCEmail[i].ToString() != "")
                //        {
                //            message.CC.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                //        }
                //    }
                //}
                //if (ds.Tables[2].Rows[0][4].ToString() != "")
                //{
                //    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                //}
                //message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                string typeofpty = ds.Tables[4].Rows[0][8].ToString();
                string Imagelocation = "";
                string Imagealt = "";
                if (typeofpty == "MGH")
                {
                    Imagelocation = ds.Tables[6].Rows[0][4].ToString();
                    Imagealt = ds.Tables[6].Rows[0][5].ToString();
                    if (Imagelocation == "")
                    {
                        Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                        Imagealt = ds.Tables[6].Rows[0][1].ToString();
                    }
                }
                else
                {
                    Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                    Imagealt = ds.Tables[6].Rows[0][1].ToString();
                }
                string Imagebody =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + Imagealt + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";

                string SecondRow = " <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #ffffff solid 1px\">" +
                            " <tr><td style=\"width: 65%;\">" +
                            " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                            " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                            " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p><br>" + //Date
                            " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p><br>" + //Date
                            " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                            " </td>" +
                            " <td>" +
                            " <p style=\"padding:5px 5px 5px 5px; font-size:13px; color:#000; font-weight:bold; background-color:#ffcc00;\">Please refer your name and " + ds.Tables[4].Rows[0][9].ToString() + " at the time of check-In</p>" +
                            " </td></tr>" +
                            " <tr><td>" +
                            " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                            " </td></tr>" +
                            " </table>";
                string GuestDetailsTable1 = "";
                // MGH,DdP,
                if ((typeofpty == "MGH") || (typeofpty == "DdP"))
                {
                    GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:140px;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Check-In Date / Expected Time</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Check-Out Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Room No</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Occupancy</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:90px;\"><p>Payment Mode<br>for Service</p></th>" +
                        " </tr>";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:140px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][7].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:90px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></td>" +
                        " </tr>";
                    }
                    GuestDetailsTable1 += "</table>";
                }
                else
                {
                    GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room Type</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Tariff / Room / Day</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                        " </tr>";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[4].Rows[0][12].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></td>" +
                        " </tr>";
                    }
                    GuestDetailsTable1 += "</table>";
                }
                string Note = "";
                string CheckInPolicy = "";
                string CheckOutPolicy = "";
                if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
                {
                    Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
                }
                else if (ds.Tables[1].Rows[0][6].ToString() == "External Property")
                {
                    if (ds.Tables[1].Rows[0][11].ToString() == "Serviced Appartments")
                    {
                        Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
                    }
                    else
                    {
                        Note = "";
                    }
                }
                if (ds.Tables[1].Rows[0][8].ToString() != "")
                {
                    CheckInPolicy = ds.Tables[1].Rows[0][8].ToString() + ' ' + ds.Tables[1].Rows[0][9].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                if (ds.Tables[1].Rows[0][10].ToString() != "")
                {
                    CheckOutPolicy = ds.Tables[1].Rows[0][10].ToString() + ' ' + ds.Tables[1].Rows[0][7].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                string Taxes = "";
                if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
                {
                    //Taxes = "Taxes as applicable";
                    Taxes = ds.Tables[4].Rows[0][13].ToString();
                }
                if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
                {
                    Taxes = ds.Tables[4].Rows[0][7].ToString();
                }
                string AddressDtls =
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax :</span> " + Taxes + "" +
                    " </p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                        " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address :</span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone :</span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions :</span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note :</span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + ds.Tables[2].Rows[0][8].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check In Policy :</span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy :</span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> (9:00 AM  to  5:00 PM)<br>" +
                    " </p></td></tr></table>";
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";
                for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName = ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId = ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo = ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                    else
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName += " , " + ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId += " , " + ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo += " , " + ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                }
                string QRCode =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                        "  <br /><br />" +
                        "  <img src=" + ds.Tables[8].Rows[0][3].ToString() + " width=\"100\" height=\"100\" />" +
                        " <p style=\"margin-top:5px;\">" +
                        "  *NOTE: Download QRCode reader to get propery address to your maps" +
                        "    </p>" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                        " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                        " </tr></table>";
                string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][5].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][6].ToString() + "</td>" +
                        " </tr></table><br>";
                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email: 
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                //smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Mail --> " + message.Subject + WebSecurity.CurrentUserName);
                }
                // Property Mail            
                if (ds.Tables[3].Rows.Count > 0)
                {
                    if (ds.Tables[3].Rows[0][4].ToString() != "")
                    {
                        string PropertyMail = ds.Tables[3].Rows[0][4].ToString();
                        //string PropertyMail = "sakthi@warblerit.com,vivek@warblerit.com,arun@warblerit.com";
                        var PtyMail = PropertyMail.Split(',');
                        int cnt = PtyMail.Length;
                        System.Net.Mail.MailMessage message1 = new System.Net.Mail.MailMessage();
                        if (ds.Tables[10].Rows.Count > 0)
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                            // message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][15].ToString(), "", System.Text.Encoding.UTF8);
                        }
                        else
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                            //message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][14].ToString(), "", System.Text.Encoding.UTF8);
                        }
                        message1.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message1.Subject = "Test Booking - " + ds.Tables[2].Rows[0][2].ToString();
                        //for (int i = 0; i < cnt; i++)
                        //{
                        //    if (PtyMail[i].ToString() != "")
                        //    {
                        //        message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                        //    }
                        //}
                        //for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                        //{
                        //    if (ds.Tables[3].Rows[i][2].ToString() != "")
                        //    {
                        //        message1.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][2].ToString()));
                        //    }
                        //}
                        //if (ds.Tables[2].Rows[0][4].ToString() != "")
                        //{
                        //    message1.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                        //}
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        //message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        string typeofpty1 = ds.Tables[4].Rows[0][8].ToString();
                        string Imagelocation1 = "";
                        string Imagealt1 = "";
                        if (typeofpty == "MGH")
                        {
                            Imagelocation1 = ds.Tables[6].Rows[0][4].ToString();
                            Imagealt1 = ds.Tables[6].Rows[0][5].ToString();
                            if (Imagelocation1 == "")
                            {
                                Imagelocation1 = ds.Tables[4].Rows[0][10].ToString();
                                Imagealt1 = ds.Tables[4].Rows[0][11].ToString();
                            }
                        }
                        else
                        {
                            Imagelocation1 = ds.Tables[4].Rows[0][10].ToString();
                            Imagealt1 = ds.Tables[4].Rows[0][11].ToString();
                        }
                        string Imagebody1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation1 + " width=\"200px\" height=\"52px\" alt=" + Imagealt1 + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                        string SecondRow1 = " <table width=\"800px\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"left\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #ffffff solid 1px\">" +
                            " <tr><td>" +
                            " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                            " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                            " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p><br>" + //Date
                            " <p style=\"margin:0px;\">Property Name : <span>" + ds.Tables[4].Rows[0][3].ToString() + "</span></p><br>" + //Date
                            " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name                        
                            " </td></tr>" +
                            " <tr><td>" +
                            " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                            " </td></tr>" +
                            " </table>";

                        string GuestDetailsTable11 = "";
                        if ((typeofpty == "MGH") || (typeofpty == "DdP"))
                        {
                            GuestDetailsTable11 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"left\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room No</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                                " </tr>";
                            for (int i = 0; i < ds.Tables[11].Rows.Count; i++)
                            {
                                GuestDetailsTable11 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][0].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][1].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][2].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][10].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][4].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][5].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][6].ToString() + "</p></td>" +
                                " </tr>";
                            }
                            GuestDetailsTable11 += "</table>";
                        }
                        else
                        {
                            GuestDetailsTable11 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Room Type</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Agreed Tariff / Room / Day</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                                " </tr>";
                            for (int i = 0; i < ds.Tables[11].Rows.Count; i++)
                            {
                                GuestDetailsTable11 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][0].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][1].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][2].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[4].Rows[0][12].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[11].Rows[i][3].ToString() + "/-</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][4].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][5].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[11].Rows[i][6].ToString() + "</p></td>" +
                                " </tr>";
                            }
                            GuestDetailsTable11 += "</table>";
                        }
                        string SplReq = ds.Tables[2].Rows[0][8].ToString();
                        if (SplReq == "")
                        {
                            SplReq = " - NA - ";
                        }
                        string MobileNo = ds.Tables[4].Rows[0][4].ToString();
                        if (MobileNo == "")
                        {
                            MobileNo = " - NA - ";
                        }
                        string Stng = ds.Tables[11].Rows[0][8].ToString();
                        string BelowTACcontent = ds.Tables[11].Rows[0][9].ToString();
                        string AddressDtls1 = "";
                        if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
                        //if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
                        {
                            if (Stng != "")
                            {
                                AddressDtls1 =
                                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Agreed Tariff & TAC (Per day / Room Night) :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + Stng + "</p>" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> Agreed Tariff & TAC :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + BelowTACcontent + "</p>" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                    " </td></tr></table>";
                            }
                            if (Stng == "")
                            {
                                AddressDtls1 =
                                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                    " <p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                    " </td></tr></table>";
                            }
                        }
                        if (ds.Tables[11].Rows[0][7].ToString() == "BTC")
                        //if (ds.Tables[11].Rows[0][7].ToString() == "NOTBTC")
                        {
                            try
                            {
                                string file = ds.Tables[4].Rows[0][1].ToString();
                                //string file = "D:/Project/HBModule/HB/flex_bin/Proof_of_Stay.pdf";
                                System.Net.Mail.Attachment att = new System.Net.Mail.Attachment(file);
                                att.Name = ds.Tables[4].Rows[0][2].ToString();
                                //att.Name = "Proof_of_Stay.pdf";
                                message1.Attachments.Add(att);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Property Mail --> " + message1.Subject + " PDF Attachment" + WebSecurity.CurrentUserName);
                            }
                            AddressDtls1 =
                                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                                    "<p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + "</p>" +
                                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                                    "<p style=\"margin-top:5px; margin-left:25px\">" + SplReq + "</p>" +
                                    "</td></tr>" +
                                // first line
                                    " <tr style=\"font-size:11px;\">" +
                                    "<td width=\"800px\" style=\"padding:12px 5px;\">" +
                                    "<p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Note :</p>" +
                                    "<ul><li>Kindly send us a confirmation e-mail immediately to stay@hummingbirdindia.com on receipt of this booking request followed by a confirmation voucher. Arrange to send the confirmation voucher within 5 minutes on receipt of this mail. Do not delay in sending the confirmation mail/voucher, as the booking may get cancelled.</li>" +
                                // 2nd line
                                    "<li>In case there is any change regarding the above booking, kindly let us know before confirming the booking.</li>" +
                                // 3rd
                                    "<li>After check-in, if there is any cancellations/amendments/extensions to this booking, the same MUST be routed through Hummingbird only.</li>" +
                                // 4th
                                    "<li>Any escalation regarding the stay needs to be attended and resolved at the property level immediately. All escalations need to be informed to HummingBird through mail and by phone. HummingBird will also assist the property to resolve issues.</li>" +
                                // 5th
                                    "<li>Kindly find attached Proof of Stay (POS) which needs to be filled and signed by the guest for all Bill to Company (BTC) bookings. The filled POS has to be attached along with the invoice sent to HummingBird.</li>" +
                                // 6th
                                    "<li>If the mode of payment for services is BTC, necessary supporting vouchers (with guest signature) for the service items delivered is to be attached along with invoice.</li>" +
                                // 7th
                                    "<li>All the invoices to be raised on “Hummingbird Travel & Stay Pvt Ltd” and all statutory numbers of the property to be mentioned on the invoice. Invoice should reach within three days of the check-out date.</li></td></tr>" +
                                    "</table>";
                        }
                        string FooterDtls1 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                                " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                                " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                                "" + ds.Tables[4].Rows[0][5].ToString() + "" +
                                " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                                "" + ds.Tables[4].Rows[0][6].ToString() + "</td></tr></table><br>";

                        message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                        message1.IsBodyHtml = true;
                        // SMTP Email email:
                        System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                        smtp1.EnableSsl = true;
                        smtp1.Port = 587;
                        smtp1.Host = "smtp.gmail.com"; smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        //smtp1.Host = "email-smtp.us-west-2.amazonaws.com"; smtp1.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                        try
                        {
                            smtp1.Send(message1);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Property Mail --> " + message1.Subject + WebSecurity.CurrentUserName);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Property Mail Content Creation --> " + WebSecurity.CurrentUserName);
            }
            return ds;
        }

        public DataSet BedBookingMail(Int64 BookingId)
        {

            //UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            // "', SctId:" + user.SctId + ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            DataTable dT = new DataTable("Table12");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds = new DataSet();

            command.CommandText = "SP_BookingDtls_Help_FrontEnd";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BedBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            Err = "";
            try
            {
                string Flag = "true";
                string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

                for (int j = 0; j < ds.Tables[9].Rows.Count; j++)
                {
                    if (ds.Tables[9].Rows[j][0].ToString() != "")
                    {
                        System.Text.RegularExpressions.Match match =
                            Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                        if (!match.Success)
                        {
                            if (Flag == "true")
                            {
                                Err += ds.Tables[9].Rows[j][0].ToString(); Flag = "false";
                            }
                            else
                            {
                                Err = Err + ", " + ds.Tables[9].Rows[j][0].ToString();
                            }
                        }
                    }
                }
                if (Err != "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                    return ds;
                }
                if (Err == "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                }
                //System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                //ds.Tables[1].Rows[0][4].ToString()
                if (ds.Tables[10].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                    //message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][6].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    ///message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][5].ToString(), "", System.Text.Encoding.UTF8);
                }
                message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));

                message.Subject = "Test Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                //message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                //if (ds.Tables[4].Rows[0][0].ToString() == "0")
                //{
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                //else
                //{
                //    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                //    {
                //        if (ds.Tables[5].Rows[i][0].ToString() != "")
                //        {
                //            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                //        }
                //    }
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                ////Extra CC
                //for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                //{
                //    if (ds.Tables[7].Rows[i][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                //    }
                //}
                //// Extra CC email from Front end
                //if (ds.Tables[8].Rows[0][1].ToString() != "")
                //{
                //    string ExtraCC = ds.Tables[8].Rows[0][1].ToString();
                //    var ExtraCCEmail = ExtraCC.Split(',');
                //    int cnt = ExtraCCEmail.Length;
                //    for (int i = 0; i < cnt; i++)
                //    {
                //        if (ExtraCCEmail[i].ToString() != "")
                //        {
                //            message.CC.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                //        }
                //    }
                //}
                ////
                //if (ds.Tables[2].Rows[0][4].ToString() != "")
                //{
                //    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                //}
                //message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                /*if (ds.Tables[10].Rows.Count > 0)
                {
                    BMail.From = "homestay@uniglobeatb.co.in";
                    //BMail.To.Add("sakthi@warblerit.com");
                    //BMail.Subject = "Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    BMail.To.Add("booking_confirmation@staysimplyfied.com");                
                    if (ds.Tables[4].Rows[0][0].ToString() == "0")
                    {
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            BMail.To.Add(ds.Tables[8].Rows[0][0].ToString());
                        }
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                        {
                            if (ds.Tables[5].Rows[i][0].ToString() != "")
                            {
                                BMail.To.Add(ds.Tables[5].Rows[i][0].ToString());
                            }
                        }
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            BMail.Cc.Add(ds.Tables[8].Rows[0][0].ToString());
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                    {
                        if (ds.Tables[7].Rows[i][0].ToString() != "")
                        {
                            BMail.Cc.Add(ds.Tables[7].Rows[i][0].ToString());
                        }
                    }
                    //
                    if (ds.Tables[2].Rows[0][4].ToString() != "")
                    {
                        BMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                    }
                    BMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                    BMail.Bcc.Add("vivek@warblerit.com");
                    BMail.Bcc.Add("arun@warblerit.com");
                    BMail.Bcc.Add("sakthi@warblerit.com");
                    BMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message.Subject = "Bed Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                    if (ds.Tables[4].Rows[0][0].ToString() == "0")
                    {
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                        }
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                        {
                            if (ds.Tables[5].Rows[i][0].ToString() != "")
                            {
                                message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                            }
                        }
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                    {
                        if (ds.Tables[7].Rows[i][0].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                        }
                    }
                    //
                    if (ds.Tables[2].Rows[0][4].ToString() != "")
                    {
                        message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();               
                }*/
                string Imagelocation = "";
                string Imagealt = "";
                string PtyType = ds.Tables[5].Rows[0][1].ToString();
                if (PtyType == "MGH")
                {
                    Imagelocation = ds.Tables[6].Rows[0][4].ToString();
                    Imagealt = ds.Tables[6].Rows[0][5].ToString();
                    if (Imagelocation == "")
                    {
                        Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                        Imagealt = ds.Tables[6].Rows[0][1].ToString();
                    }
                }
                else
                {
                    Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                    Imagealt = ds.Tables[6].Rows[0][1].ToString();
                }
                string Imagebody =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + Imagealt + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                /*string Imagebody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800pxpx\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                    " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"800pxpx\" border=\"0\" align=\"center\">" +
                    " <tr><td width=\"800pxpx\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                    " <img src=" + Imagelocation + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +
                    " </td></tr></table>";*/
                string SecondRow =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                    " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                    " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
                    " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                    " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                    " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                    " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                    " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                    " </td> </tr></table>";
                // Dataset Table 0 begin
                string GuestDetailsTable1 = "";
                if (PtyType == "MGH")
                {
                    GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Room No</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                        " </tr>";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></th>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                        " </tr>";
                    }
                    GuestDetailsTable1 += "</table>";
                }
                else
                {
                    GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Bed / Day</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                        " </tr>";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                        " </tr>";
                    }
                    GuestDetailsTable1 += "</table>";
                }
                // Dataset Table 0 end
                string Note = "";
                string CheckInPolicy = "";
                string CheckOutPolicy = "";
                if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
                {
                    Note = "This booking entitles you to use 1 bed in the room during your stay. There may be another bed in the same room, where another guest may be staying. Your room may have an attached or non-attached bath. Guests in a room will be sharing all amenities in the room and the bath.";
                }
                if (ds.Tables[1].Rows[0][8].ToString() != "")
                {
                    CheckInPolicy = ds.Tables[1].Rows[0][8].ToString() + ' ' + ds.Tables[1].Rows[0][9].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                if (ds.Tables[1].Rows[0][10].ToString() != "")
                {
                    CheckOutPolicy = ds.Tables[1].Rows[0][10].ToString() + ' ' + ds.Tables[1].Rows[0][7].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                string Spl = ds.Tables[2].Rows[0][8].ToString();
                if (Spl == "")
                {
                    Spl = "- NA -";
                }
                string AddressDtls =
                    "<p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Tax : </span>Taxes as applicable " +
                    " </p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                        " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address : </span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone : </span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions : </span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note : </span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements : </span> " + Spl + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check-in Policy : </span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy : </span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong> 1800-425-3454</strong> ( 9:00 AM  to  5:00 PM )<br>" +
                    " </p></td></tr></table>";
                // Dataset Table 1 Begin
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";
                for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName = ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId = ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo = ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                    else
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName += " , " + ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId += " , " + ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo += " , " + ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                }
                string QRCode =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                        "  <br /><br />" +
                        "  <img src=" + ds.Tables[8].Rows[0][2].ToString() + " width=\"100\" height=\"100\" />" +
                        " <p style=\"margin-top:5px;\">" +
                        "  *NOTE: Download QRCode reader to get propery address to your maps" +
                        "    </p>" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                        " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                        " </tr></table>";
                //string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                /*string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                        " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                        " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                        " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                        " <li><span>800px refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                        " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                        " </tr></table><br>";*/
                string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                        " </tr></table><br>";
                /*<tr style=\"font-size:0px; font-weight:normal;\"> " +
                " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                " </td></tr> </table>";*/
                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                //smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Bed Level Booking Confirmation Mail --> " + message.Subject + WebSecurity.CurrentUserName);
                }
                /*if (ds.Tables[10].Rows.Count > 0)
                {
                    BMail.HtmlBody = message.Body;
                    SmtpServer BServer = new SmtpServer("mail.uniglobeatb.co.in");
                    BServer.User = "homestay@uniglobeatb.co.in";
                    BServer.Password = "Atb@33%";
                    BServer.Port = 465;
                    BServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                    SmtpClient BSmtp = new SmtpClient();                
                    try
                    {
                        BSmtp.SendMail(BServer, BMail);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + "Bed Level Booking Confirmation Mail in Port 465" + BMail.Subject);
                    }
                }
                else
                {
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Host = "smtp.gmail.com";
                    smtp.Port = 587;
                    smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                    //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                    try
                    {
                        smtp.Send(message);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + "Bed Level Booking Confirmation Mail in Port 587" + message.Subject);
                    }                
                }*/

                // Property Mail
                if (ds.Tables[3].Rows.Count > 0)
                {
                    if (ds.Tables[3].Rows[0][4].ToString() != "")
                    {
                        string PropertyMail = ds.Tables[3].Rows[0][4].ToString();
                        //string PropertyMail = "sakthi@warblerit.com,vivek@warblerit.com,arun@warblerit.com";
                        var PtyMail = PropertyMail.Split(',');
                        int cnt = PtyMail.Length;
                        System.Net.Mail.MailMessage message1 = new System.Net.Mail.MailMessage();
                        //SmtpMail PMail = new SmtpMail("TryIt");
                        //ds.Tables[1].Rows[0][4].ToString()
                        if (ds.Tables[10].Rows.Count > 0)
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                            //message1.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                            ///message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][6].ToString(), "", System.Text.Encoding.UTF8);
                        }
                        else
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                            //message1.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                            ///message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][5].ToString(), "", System.Text.Encoding.UTF8);
                        }

                        message1.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message1.Subject = "Test Bed Booking Confirmation Property  - " + ds.Tables[2].Rows[0][2].ToString();
                        //for (int i = 0; i < cnt; i++)
                        //{
                        //    if (PtyMail[i].ToString() != "")
                        //    {
                        //        message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                        //    }
                        //}
                        //for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                        //{
                        //    if (ds.Tables[3].Rows[i][2].ToString() != "")
                        //    {
                        //        message1.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][2].ToString()));
                        //    }
                        //}
                        //if (ds.Tables[2].Rows[0][4].ToString() != "")
                        //{
                        //    message1.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                        //}
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        //message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        /*if (ds.Tables[10].Rows.Count > 0)
                        {
                            PMail.From = "homestay@uniglobeatb.co.in";
                            for (int i = 0; i < cnt; i++)
                            {
                                if (PtyMail[i].ToString() != "")
                                {
                                    PMail.To.Add(PtyMail[i].ToString());
                                }
                            }
                            if (ds.Tables[2].Rows[0][4].ToString() != "")
                            {
                                PMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                            }
                            PMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                            PMail.Bcc.Add("vivek@warblerit.com");
                            PMail.Bcc.Add("sakthi@warblerit.com");
                            PMail.Bcc.Add("arun@warblerit.com");
                            PMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        }
                        else
                        {
                            message1.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                            for (int i = 0; i < cnt; i++)
                            {
                                if (PtyMail[i].ToString() != "")
                                {
                                    message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                                }
                            }
                            if (ds.Tables[2].Rows[0][4].ToString() != "")
                            {
                                message1.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                            }
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                            message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        }*/
                        string Imagelocation1 = "";
                        string Imagealt1 = "";
                        string PtyType1 = ds.Tables[5].Rows[0][1].ToString();
                        if (PtyType1 == "MGH")
                        {
                            Imagelocation1 = ds.Tables[6].Rows[0][4].ToString();
                            Imagealt1 = ds.Tables[6].Rows[0][5].ToString();
                            if (Imagelocation1 == "")
                            {
                                Imagelocation1 = ds.Tables[6].Rows[0][2].ToString();
                                Imagealt1 = ds.Tables[6].Rows[0][3].ToString();
                            }
                        }
                        else
                        {
                            Imagelocation1 = ds.Tables[6].Rows[0][2].ToString();
                            Imagealt1 = ds.Tables[6].Rows[0][3].ToString();
                        }

                        string Imagebody1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + Imagealt1 + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                        /*string Imagebody1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            " <tr><td width=\"800px\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                            " <img src=" + Imagelocation1 + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][3].ToString() + ">" +
                            " </td></tr></table>";*/
                        string SecondRow1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                            " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                            " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                            " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                            " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                            " <p style=\"margin:0px;\">Property Name : <span>" + ds.Tables[4].Rows[0][1].ToString() + "</span></p>" + //Date
                            " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                            " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                            " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                            " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                            " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                            " </td> </tr></table>";
                        string GuestDetailsTable11 = "";
                        if (PtyType1 == "MGH")
                        {
                            GuestDetailsTable11 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Room No</p></th>" +
                                /*" <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Bed / Day</p></th>" +*/
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                                " </tr>";
                            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                            {
                                GuestDetailsTable11 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></td>" +
                                    /*" <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +*/
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td></tr>";
                            }
                            GuestDetailsTable11 += "</table>";
                        }
                        else
                        {
                            GuestDetailsTable11 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Bed / Day</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                                " </tr>";
                            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                            {
                                GuestDetailsTable11 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td></tr>";
                            }
                            GuestDetailsTable11 += "</table>";
                        }
                        string SplReq = ds.Tables[2].Rows[0][8].ToString();
                        if (SplReq == "")
                        {
                            SplReq = "- NA -";
                        }
                        string MobileNo = ds.Tables[4].Rows[0][2].ToString();
                        if (MobileNo == "")
                        {
                            MobileNo = " - NA - ";
                        }
                        string AddressDtls1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details : </p>" +
                            "<p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + " </p>" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request </p>" +
                            "<p style=\"margin-top:5px; margin-left:25px\">" + SplReq + " </p></td></tr></table>";
                        //string Disclaimer1 = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                        /*string FooterDtls1 =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                                " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                                " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                                " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                                " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                                " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                                " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                                " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                                " <li><span>800px refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                                " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                                " </tr></table><br>";*/
                        string FooterDtls1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                        " </tr></table><br>";
                        /*<tr style=\"font-size:0px; font-weight:normal;\"> " +
                        " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                        " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                        " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:10px;\">Disclaimer :</p>" +
                        " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer1 + "</p>" +
                        " </td></tr> </table>";*/
                        message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                        message1.IsBodyHtml = true;
                        // SMTP Email email:
                        System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                        smtp1.EnableSsl = true;
                        smtp1.Port = 587;
                        smtp1.Host = "smtp.gmail.com"; smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        // smtp1.Host = "email-smtp.us-west-2.amazonaws.com"; smtp1.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                        try
                        {
                            smtp1.Send(message1);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " --> Bed Level Booking Confirmation Property Mail --> " + message1.Subject + WebSecurity.CurrentUserName);
                        }
                        /*if (ds.Tables[10].Rows.Count > 0)
                        {
                            PMail.HtmlBody = message1.Body;
                            SmtpServer PServer = new SmtpServer("mail.uniglobeatb.co.in");
                            PServer.User = "homestay@uniglobeatb.co.in";
                            PServer.Password = "Atb@33%";
                            PServer.Port = 465;
                            PServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                            SmtpClient PSmtp = new SmtpClient();
                            try
                            {
                                PSmtp.SendMail(PServer, PMail);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + "Bed Level Booking Property Mail in Port 465" + PMail.Subject);
                            }
                        }
                        else
                        {
                            System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                            smtp1.EnableSsl = true;
                            smtp1.Host = "smtp.gmail.com";
                            smtp1.Port = 587;
                            smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                            try
                            {
                                smtp1.Send(message1);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + "Bed Level Booking Property Mail in Port 587" + message1.Subject);
                            }
                            //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                            //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");                        
                        }*/
                    }
                }
            }
            catch (Exception ex)
            {

                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Bed Level Booking Confirmation Property Mail content creation --> " + WebSecurity.CurrentUserName);
            }
            return ds;
        }

        public DataSet ApartmentBookingMail(Int64 BookingId)
        {
            //UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            //  "', SctId:" + user.SctId + ", Service : ApartmentBookingMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            DataTable dT = new DataTable("Table11");
            dT.Columns.Add("Str");
            command = new SqlCommand();
            ds = new DataSet();
            command.CommandText = "SP_BookingDtls_Help_FrontEnd";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "ApartmentBookingConfirmed";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            try
            {
                Err = "";
                string Flag = "true";
                //string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|" +
                //   @"0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z]" +
                //   @"[a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";

                string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

                for (int j = 0; j < ds.Tables[9].Rows.Count; j++)
                {
                    if (ds.Tables[9].Rows[j][0].ToString() != "")
                    {
                        System.Text.RegularExpressions.Match match =
                            Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                        if (!match.Success)
                        {
                            if (Flag == "true")
                            {
                                Err += ds.Tables[9].Rows[j][0].ToString(); Flag = "false";
                            }
                            else
                            {
                                Err = Err + ", " + ds.Tables[9].Rows[j][0].ToString();
                            }
                        }
                    }
                }
                if (Err != "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                    return ds;
                }
                if (Err == "")
                {
                    dT.Rows.Add(Err);
                    ds.Tables.Add(dT);
                }
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                if (ds.Tables[10].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied", "noreply", System.Text.Encoding.UTF8);

                    //message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][6].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][5].ToString(), "", System.Text.Encoding.UTF8);
                }
                message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Subject = "Test Apartment Booking - " + ds.Tables[2].Rows[0][2].ToString();
                //message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                //if (ds.Tables[4].Rows[0][0].ToString() == "0")
                //{
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                //else
                //{
                //    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                //    {
                //        if (ds.Tables[5].Rows[i][0].ToString() != "")
                //        {
                //            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                //        }
                //    }
                //    if (ds.Tables[8].Rows[0][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                //    }
                //}
                ////Extra CC
                //for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                //{
                //    if (ds.Tables[7].Rows[i][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                //    }
                //}
                //// Extra CC email from Front end
                //if (ds.Tables[8].Rows[0][1].ToString() != "")
                //{
                //    string ExtraCC = ds.Tables[8].Rows[0][1].ToString();
                //    var ExtraCCEmail = ExtraCC.Split(',');
                //    int cnt = ExtraCCEmail.Length;
                //    for (int i = 0; i < cnt; i++)
                //    {
                //        if (ExtraCCEmail[i].ToString() != "")
                //        {
                //            message.CC.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                //        }
                //    }
                //}
                ////
                //if (ds.Tables[2].Rows[0][4].ToString() != "")
                //{
                //    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                //}
                //message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                /*SmtpMail BMail = new SmtpMail("TryIt");
                //ds.Tables[1].Rows[0][4].ToString()
                if (ds.Tables[10].Rows.Count > 0)
                {
                    BMail.From = "homestay@uniglobeatb.co.in";
                    //BMail.To.Add("sakthi@warblerit.com");
                    //BMail.Subject = "Apartment Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    BMail.To.Add("booking_confirmation@staysimplyfied.com");
                    if (ds.Tables[4].Rows[0][0].ToString() == "0")
                    {
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            BMail.To.Add(ds.Tables[8].Rows[0][0].ToString());
                        }
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                        {
                            if (ds.Tables[5].Rows[i][0].ToString() != "")
                            {
                                BMail.To.Add(ds.Tables[5].Rows[i][0].ToString());
                            }
                        }
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            BMail.Cc.Add(ds.Tables[8].Rows[0][0].ToString());
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                    {
                        if (ds.Tables[7].Rows[i][0].ToString() != "")
                        {
                            BMail.Cc.Add(ds.Tables[7].Rows[i][0].ToString());
                        }
                    }
                    // User
                    if (ds.Tables[2].Rows[0][4].ToString() != "")
                    {
                        BMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                    }
                    BMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                    BMail.Bcc.Add("vivek@warblerit.com");
                    BMail.Bcc.Add("sakthi@warblerit.com");
                    BMail.Bcc.Add("arun@warblerit.com");
                    BMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message.Subject = "Apartment Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                    message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                    if (ds.Tables[4].Rows[0][0].ToString() == "0")
                    {
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                        }
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                        {
                            if (ds.Tables[5].Rows[i][0].ToString() != "")
                            {
                                message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                            }
                        }
                        if (ds.Tables[8].Rows[0][0].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                    {
                        if (ds.Tables[7].Rows[i][0].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                        }
                    }
                    //
                    if (ds.Tables[2].Rows[0][4].ToString() != "")
                    {
                        message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                    message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                }*/
                string Imagelocation = "";
                Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                string Imagebody =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                /*string Imagebody =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                   " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                   " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                   " <img src=" + Imagelocation + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +
                   " </td></tr></table>";*/
                string SecondRow =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                    " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                    " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
                    " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                    " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                    " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                    " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                    " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                    " </td> </tr></table>";
                // Dataset Table 0 begin
                string GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Apartment / Day</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                    " </tr>";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
                // Dataset Table 0 end
                string Note = "";
                string CheckInPolicy = "";
                string CheckOutPolicy = "";
                if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
                {
                    Note = "This booking entitles you to use the whole apartment.";
                }
                if (ds.Tables[1].Rows[0][8].ToString() != "")
                {
                    CheckInPolicy = ds.Tables[1].Rows[0][8].ToString() + ' ' + ds.Tables[1].Rows[0][9].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                if (ds.Tables[1].Rows[0][10].ToString() != "")
                {
                    CheckOutPolicy = ds.Tables[1].Rows[0][10].ToString() + ' ' + ds.Tables[1].Rows[0][7].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                string Spl = ds.Tables[2].Rows[0][8].ToString();
                if (Spl == "")
                {
                    Spl = "- NA -";
                }
                string AddressDtls =
                    "<p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Tax : </span>Taxes as applicable " +
                    " </p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                     " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address : </span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone : </span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions : </span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note : </span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + Spl + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check-in Policy : </span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy : </span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> ( 9:00 AM  to  5:00 PM )<br>" +
                    " </p></td></tr></table>";
                // Dataset Table 1 Begin
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";
                for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName = ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId = ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo = ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                    else
                    {
                        if (ds.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName += " , " + ds.Tables[3].Rows[i][1].ToString();
                        }
                        if (ds.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId += " , " + ds.Tables[3].Rows[i][2].ToString();
                        }
                        if (ds.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo += " , " + ds.Tables[3].Rows[i][3].ToString();
                        }
                    }
                }
                string QRCode =
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                     " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                     " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                     "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                     "  <br /><br />" +
                     "  <img src=" + ds.Tables[8].Rows[0][2].ToString() + " width=\"100\" height=\"100\" />" +
                     " <p style=\"margin-top:5px;\">" +
                     "  *NOTE: Download QRCode reader to get propery address to your maps" +
                     "    </p>" +
                     " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                     " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                     " </tr></table>";
                //string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                /*string FooterDtls =
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                     " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                     " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                     " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                     " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                     " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                     " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                     " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                     " <li><span>800px refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                     " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                     " </tr></table><br>";*/
                string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                        " </tr></table><br>";
                /*"<tr style=\"font-size:0px; font-weight:normal;\"> " +
                " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                " </td></tr> </table>";*/
                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                // smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Apartment Level Booking Confirmation Mail --> " + message.Subject + WebSecurity.CurrentUserName);
                }
                /*if (ds.Tables[10].Rows.Count > 0)
                {
                    BMail.HtmlBody = message.Body;
                    SmtpServer BServer = new SmtpServer("mail.uniglobeatb.co.in");
                    BServer.User = "homestay@uniglobeatb.co.in";
                    BServer.Password = "Atb@33%";
                    BServer.Port = 465;
                    BServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                    SmtpClient BSmtp = new SmtpClient();
                    try
                    {
                        BSmtp.SendMail(BServer, BMail);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + "Apartment Level Booking Confirmation Mail in Port 465" + BMail.Subject);
                    }
                }
                else
                {
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Host = "smtp.gmail.com";
                    smtp.Port = 587;
                    smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                    //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                    try
                    {
                        smtp.Send(message);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + "Apartment Level Booking Confirmation Mail in Port 587" + message.Subject);
                    }                
                }*/

                // Property Mail
                if (ds.Tables[3].Rows.Count > 0)
                {
                    if (ds.Tables[3].Rows[0][4].ToString() != "")
                    {
                        string PropertyMail = ds.Tables[3].Rows[0][4].ToString();
                        //string PropertyMail = "sakthi@warblerit.com,vivek@warblerit.com,arun@warblerit.com";
                        var PtyMail = PropertyMail.Split(',');
                        int cnt = PtyMail.Length;
                        System.Net.Mail.MailMessage message1 = new System.Net.Mail.MailMessage();
                        //ds.Tables[1].Rows[0][4].ToString()
                        if (ds.Tables[10].Rows.Count > 0)
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                            //message1.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                            //message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][6].ToString(), "", System.Text.Encoding.UTF8);
                        }
                        else
                        {
                            message1.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                            //message1.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                            //message1.From = new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][5].ToString(), "", System.Text.Encoding.UTF8);
                        }
                        message1.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message1.Subject = "Test Apartment Property - " + ds.Tables[2].Rows[0][2].ToString();
                        //for (int i = 0; i < cnt; i++)
                        //{
                        //    if (PtyMail[i].ToString() != "")
                        //    {
                        //        message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                        //    }
                        //}
                        //for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                        //{
                        //    if (ds.Tables[3].Rows[i][2].ToString() != "")
                        //    {
                        //        message1.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][2].ToString()));
                        //    }
                        //}
                        //if (ds.Tables[2].Rows[0][4].ToString() != "")
                        //{
                        //    message1.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                        //}
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        //message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        //message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        /*if (ds.Tables[10].Rows.Count > 0)
                        {
                            PMail.From = "homestay@uniglobeatb.co.in";
                            for (int i = 0; i < cnt; i++)
                            {
                                if (PtyMail[i].ToString() != "")
                                {
                                    PMail.To.Add(PtyMail[i].ToString());
                                }
                            }
                            if (ds.Tables[2].Rows[0][4].ToString() != "")
                            {
                                PMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                            }
                            PMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                            PMail.Bcc.Add("vivek@warblerit.com");
                            PMail.Bcc.Add("sakthi@warblerit.com");
                            PMail.Bcc.Add("arun@warblerit.com");
                            PMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        }
                        else
                        {
                            message1.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                            for (int i = 0; i < cnt; i++)
                            {
                                if (PtyMail[i].ToString() != "")
                                {
                                    message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                                }
                            }
                            if (ds.Tables[2].Rows[0][4].ToString() != "")
                            {
                                message1.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                            }
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            message1.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                            message1.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                        }*/
                        string Imagelocation1 = "";
                        Imagelocation1 = ds.Tables[6].Rows[0][2].ToString();
                        string Imagebody1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][3].ToString() + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                        /*string Imagebody1 =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                           " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                           " <img src=" + Imagelocation1 + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][3].ToString() + ">" +
                           " </td></tr></table>";*/

                        string SecondRow1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                            " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                            " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                            " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                            " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                            " <p style=\"margin:0px;\">Property Name : <span>" + ds.Tables[4].Rows[0][1].ToString() + "</span></p>" + //Date
                            " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                            " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                            " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                            " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                            " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                            " </td> </tr></table>";

                        string GuestDetailsTable11 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-In Date / Expected Time</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Tariff / Apartment / Day</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p>Payment Mode<br>for Service</p></th>" +
                            " </tr>";

                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            GuestDetailsTable11 +=
                            "<tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #ccc; width:96px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></td></tr>";
                        }
                        GuestDetailsTable11 += "</table>";
                        string SplReq = ds.Tables[2].Rows[0][8].ToString();
                        if (SplReq == "")
                        {
                            SplReq = "- NA -";
                        }
                        string MobileNo = ds.Tables[4].Rows[0][2].ToString();
                        if (MobileNo == "")
                        {
                            MobileNo = " - NA - ";
                        }
                        string AddressDtls1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Guest Contact Details :</p>" +
                            "<p style=\"margin-top:5px; margin-left:25px\">" + MobileNo + " </p>" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request</p>" +
                            "<p style=\"margin-top:5px; margin-left:25px\">" + SplReq + " </p></td></tr></table>";
                        //string Disclaimer1 = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                        /*string FooterDtls1 =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                             " <tr style=\"font-size:11px; font-weight:normal;\">" +
                             " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                             " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                             " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                             " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                             " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                             " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                             " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                             " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                             " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through Email.</span></li><li><span>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</span></li>" +
                             " <li><span>800px refund will be made if cancellation request is sent 48 (forty eight) hours prior to the check-in date and NIL amount will be refunded if cancellation request sent beyond 48 (forty eight) hours to check-in date.</span></li>" +
                             " <li><span>1 day tariff will be charged for No-show without intimation.</span></li></td></ol>" +
                             " </tr></table><br>";*/
                        string FooterDtls1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][3].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[4].Rows[0][4].ToString() + "</td>" +
                        " </tr></table><br>";
                        /*<tr style=\"font-size:0px; font-weight:normal;\"> " +
                        " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                        " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                        " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:10px;\">Disclaimer :</p>" +
                        " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer1 + "</p>" +
                        " </td></tr> </table>";*/

                        message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                        message1.IsBodyHtml = true;
                        // SMTP Email email:                    
                        System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                        smtp1.EnableSsl = true;
                        smtp1.Port = 587;
                        smtp1.Host = "smtp.gmail.com"; smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        //smtp1.Host = "email-smtp.us-west-2.amazonaws.com"; smtp1.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                        try
                        {
                            smtp1.Send(message1);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " --> Apartment Level Booking Confirmation Property Mail --> " + message1.Subject + WebSecurity.CurrentUserName);
                        }
                        /*if (ds.Tables[10].Rows.Count > 0)
                        {
                            PMail.HtmlBody = message1.Body;
                            SmtpServer PServer = new SmtpServer("mail.uniglobeatb.co.in");
                            PServer.User = "homestay@uniglobeatb.co.in";
                            PServer.Password = "Atb@33%";
                            PServer.Port = 465;
                            PServer.ConnectType = SmtpConnectType.ConnectSSLAuto;
                            SmtpClient PSmtp = new SmtpClient();                        
                            try
                            {
                                PSmtp.SendMail(PServer, PMail);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + "Apartment Level Booking Property Mail in Port 465" + PMail.Subject);
                            }
                        }
                        else
                        {
                            System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                            smtp1.EnableSsl = true;
                            smtp1.Host = "smtp.gmail.com";
                            smtp1.Port = 587;
                            smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                            //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                            //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                            try
                            {
                                smtp1.Send(message1);
                            }
                            catch (Exception ex)
                            {
                                CreateLogFiles log = new CreateLogFiles();
                                log.ErrorLog(ex.Message + "Apartment Level Booking Property Mail in Port 587" + message1.Subject);
                            }                        
                        }*/
                    }
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + "Apartment Level Booking Property Mail in Port 587 CONTENT CREATION" + WebSecurity.CurrentUserName);
            }
            return ds;

        }

        public DataSet RecomentationMail(Int64 BookingId)
        {
            //UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
            //"', SctId:" + Usr.SctId + ", Service:BookingPropertyDAO - Help - Action Name - RecommendProperty" + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            SqlCommand command = new SqlCommand();
            command.CommandText = "SP_BookingDtls_Help_FrontEnd";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "RecommendProperty";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            DataSet DSBooking = new WrbErpConnection().ExecuteDataSet(command, UserData);
            try
            {
                //if (DSBooking.Tables[4].Rows[0][0].ToString() == "RmdPty")
                //{
                //SmtpMail Mail = new SmtpMail("TryIt");
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                //DSBooking.Tables[1].Rows[0][4].ToString()
                if (DSBooking.Tables[8].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(DSBooking.Tables[2].Rows[0][2].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(DSBooking.Tables[2].Rows[0][1].ToString(), "", System.Text.Encoding.UTF8);
                }
                //message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                message.To.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                // message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Subject = " Test Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                // message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                //if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                //{
                //    if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                //    {
                //        message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                //    }
                //}
                //else
                //{
                //    for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                //    {
                //        if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                //        {
                //            message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[3].Rows[i][0].ToString()));
                //        }
                //    }
                //    if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                //    }
                //}
                //Extra CC
                //for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                //{
                //    if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[6].Rows[i][0].ToString()));
                //    }
                //}
                //if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                //{
                //    message.Bcc.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][4].ToString()));
                //}
                //message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();

                string Imagelocation = "";
                Imagelocation = DSBooking.Tables[5].Rows[0][0].ToString();
                string Imagebody =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                    "<tr><td>" +
                    "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    "<tr> " +
                    "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                    "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + DSBooking.Tables[5].Rows[0][1].ToString() + ">" +              //Image Name Change
                    "</th><th width=\"50%\"></th></tr></table>";
                string NameBody =
                    " <p style=\"margin:0px;\">Hello " + DSBooking.Tables[7].Rows[0][0].ToString() + ",</p><br>" +         //Name Change
                    " <p style=\"margin:0px;\">Greetings for the Day.</p><br>" +
                    " <p style=\"margin:0px;\">Rooms are available in below mentioned hotels.   [ Tracking Id: " + DSBooking.Tables[1].Rows[0][2].ToString() + " ]</p>" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\">Property Details :</p>" +
                    " <span style=\"color:#f54d02; font-weight:bold\">City: </span> " + DSBooking.Tables[0].Rows[0][0].ToString() + " " +
                    "<br><br>";
                string GridBody =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                   " <tr style=\"font-size:11px; font-weight:normal;\">" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Type</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Location</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Room Type</p></th>" +
                    //" <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Base Tariff</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Single Tariff</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Double Tariff</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Inclusions</p></th>" +
                   " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #fff;\"><p>Check In Policy</p></th>" +
                   "</tr>";
                for (int j = 0; j < DSBooking.Tables[0].Rows.Count; j++)
                {
                    GridBody +=
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][9].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][3].ToString() + "</p></td>" +
                        //" <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][10].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][4].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][7].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][5].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #fff;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][8].ToString() + "</p></td>" +
                        "</tr>";
                }
                GridBody += "</table>";

                GridBody +=
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    "<span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax </span><ul><li>  &#9733;   - Taxes as applicable</li><li> #   - Including Tax</li></ul></p>" +
                    "<p style=\"font-weight:bold; font-size:13px;\">TO CONFIRM - Reply with your top 2 - 3 preferred hotel and room type to confirmation of your booking as per availablity</p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                    " <p style=\"margin-top:0px;\"><b>Conditions : </b><ul><li><b>All rates quoted are subject to availability and duration of Stay.</b></li><li>All Tariff quoted are limited and subject to availability and has to be confirmed in 30 mins from the time when these tariff's are generated " + DSBooking.Tables[4].Rows[0][1].ToString() + ".</li><li>While every effort has been made to ensure the accuracy and availablity of all information.</li></ul></p>" +
                    " <p style=\"margin-top:0px;\"><b>Cancellation Policy : </b> <ul><li> Cancellation of booking to be confirmed through Email.</li> " +
                    "<li>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</li>" +
                    "<li>Cancellation policy varies from Property to property. Please verify confirmation email.</li></ul>" +
                    " <p style=\"margin-top:20px;\"><b>Note : </b>" + DSBooking.Tables[1].Rows[0][5].ToString() + "<br>" +
                    " <p style=\"margin-top:20px;\">Kindly confirm the property at the earliest as rooms are subject to availability.<br>" +
                    " <br /> Thanking You,<br />" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">" + DSBooking.Tables[1].Rows[0][3].ToString() + "" + //username change
                    " </p></td></tr></table><br><br>";

                message.Body = Imagebody + NameBody + GridBody;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                //smtp.Host = "email-smtp.us-west-2.amazonaws.com"; smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                smtp.Host = "smtp.gmail.com"; smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                try
                {
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Recommend Property Mail --> " + message.Subject + WebSecurity.CurrentUserName);
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Recommend Property Mail CONTENT CREATION --> " + WebSecurity.CurrentUserName);
            }
            return ds;
        }

        public DataSet MMTBookingConfirmedMail(int BookingId)
        {
            //UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName +
            //           ", ScreenName:'" + user.ScreenName + "', SctId:" + user.SctId +
            //           ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            try
            {
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_BookingDtls_Help_FrontEnd";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTBookingConfirmed";
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                if (ds.Tables[5].Rows.Count > 0)
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);

                    //message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[3].Rows[0][3].ToString(), "", System.Text.Encoding.UTF8);
                }
                else
                {
                    message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "noreply", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    //message.From = new System.Net.Mail.MailAddress(ds.Tables[3].Rows[0][2].ToString(), "", System.Text.Encoding.UTF8);
                }
                //message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                message.To.Add(new System.Net.Mail.MailAddress("vaitheeshwaran@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));

                message.Subject = "Test MMT Booking Confirmation - " + ds.Tables[2].Rows[0][0].ToString();
                //message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                //if (ds.Tables[2].Rows[0][6].ToString() == "0")
                //{
                //    if (ds.Tables[2].Rows[0][7].ToString() != "")
                //    {
                //        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][7].ToString()));
                //    }
                //}
                //else
                //{
                //    for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                //    {
                //        if (ds.Tables[3].Rows[i][0].ToString() != "")
                //        {
                //            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][0].ToString()));
                //        }
                //    }
                //    if (ds.Tables[2].Rows[0][7].ToString() != "")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][7].ToString()));
                //    }
                //}
                //// Extra CC email from Front end
                //if (ds.Tables[2].Rows[0][9].ToString() != "")
                //{
                //    string ExtraCC = ds.Tables[2].Rows[0][9].ToString();
                //    var ExtraCCEmail = ExtraCC.Split(',');
                //    int cnt = ExtraCCEmail.Length;
                //    for (int i = 0; i < cnt; i++)
                //    {
                //        if (ExtraCCEmail[i].ToString() != "")
                //        {
                //            message.CC.Add(new System.Net.Mail.MailAddress(ExtraCCEmail[i].ToString()));
                //        }
                //    }
                //}
                //if (ds.Tables[2].Rows[0][4].ToString() != "")
                //{
                //    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                //}
                //message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][0].ToString();
                string Imagelocation = "";
                Imagelocation = ds.Tables[4].Rows[0][0].ToString();
                string Imagebody =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                            "<tr><td>" +
                            "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                            "<tr> " +
                            "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                            "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[4].Rows[0][1].ToString() + ">" +              //Image Name Change
                            "</th><th width=\"50%\"></th></tr></table>";
                string SecondRow =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"300\" style=\" padding-bottom:1px;\">" +
                    " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + ds.Tables[2].Rows[0][0].ToString() + " </span></p>" + //Reservation
                    /*" <p style=\"margin:0px;\">Ref : <span>" + ds.Tables[2].Rows[0][8].ToString() + "</span></p><br>" +*/
                    " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p><br>" +             //Name                    
                    " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][2].ToString() + "</span></p><br>" + //Date
                    " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p><br>" + //company name
                    " </td><td width=\"300\"><p style=\"padding:25px 25px 25px 25px; font-size:13px; color:#000; font-weight:bold; background-color:#ffcc00;\">Please refer your name and reference number - " + ds.Tables[2].Rows[0][8].ToString() + " at the time of check-In</p>" +
                    " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                    " </td></tr><tr><td width=\"800px\" style=\"margin-bottom:\">" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                    " </td> </tr></table>";
                string GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Tariff / Room / Day</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Occupancy</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p>Payment Mode<br>for Service</p></th>" +
                    " </tr>";
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:120px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666; width:80px;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></th>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
                //                
                string CheckInPolicy = "";
                if (ds.Tables[1].Rows[0][4].ToString() != "")
                {
                    CheckInPolicy = ds.Tables[1].Rows[0][4].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                //
                string CheckOutPolicy = "";
                if (ds.Tables[1].Rows[0][5].ToString() != "")
                {
                    CheckOutPolicy = ds.Tables[1].Rows[0][5].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                //
                string Note = "";
                if (ds.Tables[1].Rows[0][6].ToString() == "MMT") { Note = " - NA - "; } else { Note = " - NA - "; }
                //
                string SplReq = "";
                if (ds.Tables[2].Rows[0][5].ToString() == "") { SplReq = " - NA - "; }
                else { SplReq = ds.Tables[2].Rows[0][5].ToString(); }
                //
                string AddressDtls =
                    "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax :</span> " + ds.Tables[3].Rows[0][1].ToString() + "" +
                    " </p>" +
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"800px\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                        " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][0].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address :</span> " + ds.Tables[1].Rows[0][1].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone :</span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions :</span>" + ds.Tables[1].Rows[0][3].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note :</span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + SplReq + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check In Policy :</span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy :</span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> (9:00 AM  to  5:00 PM)<br>" +
                    " </p></td></tr></table>";
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";
                string QRCode =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Contact for any issues and feedbacks</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> QR Code</p>" +
                        "  <br /><br />" +
                        "  <img src=" + ds.Tables[2].Rows[0][10].ToString() + " width=\"100\" height=\"100\" />" +
                        " <p style=\"margin-top:5px;\">" +
                        "  *NOTE: Download QRCode reader to get propery address to your maps" +
                        "    </p>" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                        " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                        " </tr></table>";
                string FooterDtls =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                        " <th width=\"50%\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                        " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[1].Rows[0][7].ToString() + "" +
                        " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                        " " + ds.Tables[1].Rows[0][8].ToString() + "</td>" +
                        " </tr></table><br>";
                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email: 
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.EnableSsl = true;
                smtp.Port = 587;
                smtp.Host = "smtp.gmail.com";
                smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                //smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                //smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Room Level Booking MMT Confirmation Mail --> " + message.Subject + WebSecurity.CurrentUserName);
            }
            return ds;
        }

    }

    public class MMTController : Controller
    {
        SqlCommand command = new SqlCommand();
        bool Flag = true;
        string FlagStr = "";
        DataSet ds = new DataSet();
        string UserData = "";
        string UpdateTariffFlag = "";

        public string FnAvailabilityExistingData(string[] data)
        {
            try
            {
                APIDynamic api = new APIDynamic();
                api.CityCode = data[2].ToString();
                api.HotelId = data[3].ToString();
                api.RatePlanCode = data[4].ToString();
                api.RoomTypecode = data[5].ToString();
                string d1 = data[6].ToString();
                string d2 = data[7].ToString();
                api.FrmDt = d1.Substring(0, 10);
                api.ToDt = d2.Substring(0, 10);
                api.HeaderId = Convert.ToInt32(data[8].ToString());
                DateTime dt1 = Convert.ToDateTime(api.FrmDt);
                DateTime dt2 = Convert.ToDateTime(api.ToDt);
                double dys = (dt2 - dt1).TotalDays;
                int CntDys = Convert.ToInt32(dys);
                int GstCnt = Convert.ToInt32(data[9].ToString());
                int RoomAvaCnt = 0;
                WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelAvailability");
                HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                httpRequest.Method = "POST";
                httpRequest.ContentType = "application/xml; charset=utf-8";
                httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                httpRequest.ProtocolVersion = HttpVersion.Version11;
                httpRequest.Credentials = CredentialCache.DefaultCredentials;
                httpRequest.Timeout = 100000000;
                Stream requestStream = httpRequest.GetRequestStream();
                //Create Stream and Complete Request             
                StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                soapRequest.Append("<MMTHotelAvailRequest>");
                soapRequest.Append("<POS>");
                //soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // Test
                soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // Live
                soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
                soapRequest.Append("</POS>");
                soapRequest.Append("<ResultTransformer>");
                soapRequest.Append("<CancellationPolicyRulesReq text=\"yes\"/>");
                soapRequest.Append("</ResultTransformer>");
                soapRequest.Append("<HotelAvailabilityCriteria>");
                soapRequest.Append("<Area>");
                soapRequest.Append("<CityCode>");
                soapRequest.Append(api.CityCode);
                soapRequest.Append("</CityCode>");
                //soapRequest.Append("<CityCode>TCC</CityCode>");
                soapRequest.Append("<CountryCode>IN</CountryCode>");
                soapRequest.Append("</Area>");
                soapRequest.Append("<HotelRef id='" + api.HotelId + "'/>");
                soapRequest.Append("<RatePlan code='" + api.RatePlanCode + "'/>");
                soapRequest.Append("<RoomType code='" + api.RoomTypecode + "'/>");
                // single & double room added
                soapRequest.Append("<RoomStayCandidates>");

                soapRequest.Append("<RoomStayCandidate>");
                soapRequest.Append("<GuestCounts>");
                soapRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                soapRequest.Append("</GuestCounts>");
                soapRequest.Append("</RoomStayCandidate>");
                //soapRequest.Append("<RoomStayCandidate>");
                //soapRequest.Append("<GuestCounts>");
                //soapRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                //soapRequest.Append("</GuestCounts>");
                //soapRequest.Append("</RoomStayCandidate>");
                soapRequest.Append("</RoomStayCandidates>");
                //soapRequest.Append("<StayDateRange start="2014-10-10" end="2014-10-11"/>");
                soapRequest.Append("<StayDateRange start='" + api.FrmDt + "' end='" + api.ToDt + "'/>");
                soapRequest.Append("</HotelAvailabilityCriteria>");
                soapRequest.Append("</MMTHotelAvailRequest>");
                streamWriter.Write(soapRequest.ToString());
                streamWriter.Close();
                //Get the Response
                HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                StreamReader srd = new StreamReader(wr.GetResponseStream());
                string ResponseXML = srd.ReadToEnd();
                //
                //JObject dynObj = JObject.Parse(ResponseXML); 
                //
                command = new SqlCommand();
                XmlDocument document = new XmlDocument();
                document.LoadXml(ResponseXML);
                int n = 0;
                Flag = true;
                n = document.SelectNodes("//Hotel").Count;
                if (n != 0)
                {
                    api.AvaavailStatus = document.SelectNodes("//RoomRate")[0].Attributes["availStatus"].Value;
                    try
                    {
                        RoomAvaCnt = Convert.ToInt32(document.SelectNodes("//RoomRate")[0].Attributes["availableCount"].Value);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> API Availability Existing Data --> Room Avaliable Count is Empty." + WebSecurity.CurrentUserName);
                        RoomAvaCnt = 0;
                    }
                    if (api.AvaavailStatus == "B")
                    {
                        decimal RoomRate1 = 0, RoomRate2 = 0, RoomDiscount1 = 0, RoomDiscount2 = 0;
                        decimal Taxes1 = 0, Taxes2 = 0;
                        XmlNodeList XmlRoomTariffs1 = document.DocumentElement.SelectNodes("/MMTHotelAvailResponse/Hotel/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate/Rate/RoomTariffs/RoomTariff");
                        foreach (XmlNode xnRT in XmlRoomTariffs1)
                        {
                            //string RoomTariffs = xnRT.InnerXml;XmlDocument XmlDoc = new XmlDocument();XmlDoc.LoadXml(RoomTariffs);
                            string RoomTariffs1 = xnRT.OuterXml;
                            XmlDocument XmlDoc1 = new XmlDocument();
                            XmlDoc1.LoadXml(RoomTariffs1);
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "1")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "2")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                        }
                        command = new SqlCommand();
                        ds = new DataSet();
                        command.CommandText = "SP_API_Help_FrontEnd";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "SingleDoubleRateLoad";
                        command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                        command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                        command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                        command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                        command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = api.HeaderId;
                        command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                        ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                        // ROOM RATE
                        decimal RoomNo1Existsamt = Convert.ToDecimal(ds.Tables[0].Rows[0][0].ToString()) * CntDys;
                        decimal RoomNo2Existsamt = Convert.ToDecimal(ds.Tables[1].Rows[0][0].ToString()) * CntDys;
                        // ROOM TAX
                        decimal RoomNo1ExistsTaxamt = 0;
                        if (ds.Tables[2].Rows.Count > 0)
                        {
                            RoomNo1ExistsTaxamt = Convert.ToDecimal(ds.Tables[2].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2ExistsTaxamt = 0;
                        if (ds.Tables[3].Rows.Count > 0)
                        {
                            RoomNo2ExistsTaxamt = Convert.ToDecimal(ds.Tables[3].Rows[0][0].ToString()) * CntDys;
                        }
                        // ROOM discount
                        decimal RoomNo1Existsdiscountamt = 0;
                        if (ds.Tables[4].Rows.Count > 0)
                        {
                            RoomNo1Existsdiscountamt = Convert.ToDecimal(ds.Tables[4].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2Existsdiscountamt = 0;
                        if (ds.Tables[5].Rows.Count > 0)
                        {
                            RoomNo2Existsdiscountamt = Convert.ToDecimal(ds.Tables[5].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal diff = Convert.ToDecimal(ds.Tables[6].Rows[0][0].ToString());
                        //
                        FlagStr = "";
                        //
                        //if ((RoomNo1Existsamt == RoomRate1) && (RoomNo2Existsamt == RoomRate2) && (RoomAvaCnt >= GstCnt) &&
                        //    (RoomNo1ExistsTaxamt == Taxes1) && (RoomNo2ExistsTaxamt == Taxes2) &&
                        //    (RoomNo1Existsdiscountamt == RoomDiscount1) && (RoomNo2Existsdiscountamt == RoomDiscount2))
                        //{
                        //    Flag = true;
                        //}
                        decimal Rate1diff = Math.Abs(RoomNo1Existsamt - RoomRate1);
                        decimal Rate2diff = Math.Abs(RoomNo2Existsamt - RoomRate2);
                        decimal Tax1diff = Math.Abs(RoomNo1ExistsTaxamt - Taxes1);
                        decimal Tax2diff = Math.Abs(RoomNo2ExistsTaxamt - Taxes2);
                        decimal Discount1diff = Math.Abs(RoomNo1Existsdiscountamt - RoomDiscount1);
                        decimal Discount2diff = Math.Abs(RoomNo2Existsdiscountamt - RoomDiscount2);
                        if ((Rate1diff < diff) && (Rate2diff < diff) && (Tax1diff < diff) && (Tax2diff < diff) &&
                            (Discount1diff < diff) && (Discount2diff < diff) && (RoomAvaCnt >= GstCnt))
                        {
                            Flag = true;
                        }
                        else
                        {
                            Flag = false; UpdateTariffFlag = "123";
                            // Tariff is Changed for this Hotel.
                            FlagStr = "Tariff is Changed.";
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = "SP_API_Help_FrontEnd";
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTTariffTaxesUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomRate1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomRate2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = Math.Round(Taxes1 / CntDys);
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = Math.Round(Taxes2 / CntDys);
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = "SP_API_Help_FrontEnd";
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTDiscountUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomDiscount1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomDiscount2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            //if ((roomdiscount1 != 0) || (roomdiscount2 != 0))
                            //{
                            //    command = new sqlcommand();
                            //    ds = new dataset();
                            //    command.commandtext = storedprocedures.api_help;
                            //    command.commandtype = commandtype.storedprocedure;
                            //    command.parameters.add("@action", sqldbtype.nvarchar).value = "mmtdiscountupdate";
                            //    command.parameters.add("@str1", sqldbtype.nvarchar).value = api.hotelid;
                            //    command.parameters.add("@str2", sqldbtype.nvarchar).value = api.rateplancode;
                            //    command.parameters.add("@str3", sqldbtype.nvarchar).value = api.roomtypecode;
                            //    command.parameters.add("@str4", sqldbtype.nvarchar).value = api.headerid;
                            //    command.parameters.add("@id1", sqldbtype.bigint).value = math.round(roomdiscount1 / cntdys);
                            //    command.parameters.add("@id2", sqldbtype.bigint).value = math.round(roomdiscount2 / cntdys);
                            //    command.parameters.add("@id3", sqldbtype.bigint).value = 0;
                            //    command.parameters.add("@id4", sqldbtype.bigint).value = 0;
                            //    ds = new wrberpconnection().executedataset(command, userdata);
                            //}
                        }
                    }
                    else
                    {
                        Flag = false; UpdateTariffFlag = "";
                        // Room is Not Avaliable for this Date Range.
                        FlagStr = "Room is Not Avaliable";
                        return FlagStr;
                    }
                }
                else
                {
                    Flag = false; UpdateTariffFlag = "";
                    // Hotel is Not Avaliable for this Date Range.
                    FlagStr = "Hotel is Not Avaliable";
                    return FlagStr;
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> API Availability Existing Data." + WebSecurity.CurrentUserName);
                Flag = false;
                FlagStr = "Error";
                return FlagStr;
            }
            //if (Flag == false)
            //{
            //    command = new SqlCommand();
            //    ds = new DataSet();
            //    command.CommandText = StoredProcedures.API_Help;
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "FalseFlagLoad";
            //    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = FlagStr;
            //    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = UpdateTariffFlag;
            //    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            //    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //    /*DataTable dT1 = new DataTable("DBERRORTBL");
            //    ds.Tables.Add(dT1);
            //    DataTable dTable = new DataTable("ERRORTBL");
            //    dTable.Columns.Add("Exception");
            //    DataTable dT = new DataTable("Table");
            //    dT.Columns.Add("Str");*/
            //}
            //else
            //{
            //    command = new SqlCommand();
            //    ds = new DataSet();
            //    command.CommandText = ""API_Help;
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "TrueFlagLoad";
            //    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            //    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //}
            return "";
        }
        public string FnAvailabilityExistingDataTR(string[] data)
        {
            try
            {
                APIDynamic api = new APIDynamic();
                api.CityCode = data[2].ToString();
                api.HotelId = data[3].ToString();
                api.RatePlanCode = data[4].ToString();
                api.RoomTypecode = data[5].ToString();
                string d1 = data[6].ToString();
                string d2 = data[7].ToString();
                api.FrmDt = d1.Substring(0, 10);
                api.ToDt = d2.Substring(0, 10);
                api.HeaderId = Convert.ToInt32(data[8].ToString());
                DateTime dt1 = Convert.ToDateTime(api.FrmDt);
                DateTime dt2 = Convert.ToDateTime(api.ToDt);
                double dys = (dt2 - dt1).TotalDays;
                int CntDys = Convert.ToInt32(dys);
                int GstCnt = Convert.ToInt32(data[9].ToString());
                api.singlecnt = Convert.ToInt32(data[10].ToString());
                api.doublecnt = Convert.ToInt32(data[11].ToString());
                int RoomAvaCnt = 0;
                WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelAvailability");
                HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                httpRequest.Method = "POST";
                httpRequest.ContentType = "application/xml; charset=utf-8";
                httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                httpRequest.ProtocolVersion = HttpVersion.Version11;
                httpRequest.Credentials = CredentialCache.DefaultCredentials;
                httpRequest.Timeout = 100000000;
                Stream requestStream = httpRequest.GetRequestStream();
                //Create Stream and Complete Request             
                StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                soapRequest.Append("<MMTHotelAvailRequest>");
                soapRequest.Append("<POS>");
                //soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // Test
                soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // Live
                soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
                soapRequest.Append("</POS>");
                soapRequest.Append("<ResultTransformer>");
                soapRequest.Append("<CancellationPolicyRulesReq text=\"yes\"/>");
                soapRequest.Append("</ResultTransformer>");
                soapRequest.Append("<HotelAvailabilityCriteria>");
                soapRequest.Append("<Area>");
                soapRequest.Append("<CityCode>");
                soapRequest.Append(api.CityCode);
                soapRequest.Append("</CityCode>");
                //soapRequest.Append("<CityCode>TCC</CityCode>");
                soapRequest.Append("<CountryCode>IN</CountryCode>");
                soapRequest.Append("</Area>");
                soapRequest.Append("<HotelRef id='" + api.HotelId + "'/>");
                soapRequest.Append("<RatePlan code='" + api.RatePlanCode + "'/>");
                soapRequest.Append("<RoomType code='" + api.RoomTypecode + "'/>");
                // single & double room added
                soapRequest.Append("<RoomStayCandidates>");
                if (api.singlecnt > 0)
                {
                    for (int i = 0; i < api.singlecnt; i++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                if (api.doublecnt > 0)
                {
                    for (int j = 0; j < api.doublecnt; j++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                soapRequest.Append("</RoomStayCandidates>");
                //soapRequest.Append("<StayDateRange start="2014-10-10" end="2014-10-11"/>");
                soapRequest.Append("<StayDateRange start='" + api.FrmDt + "' end='" + api.ToDt + "'/>");
                soapRequest.Append("</HotelAvailabilityCriteria>");
                soapRequest.Append("</MMTHotelAvailRequest>");
                streamWriter.Write(soapRequest.ToString());
                streamWriter.Close();
                //Get the Response
                HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                StreamReader srd = new StreamReader(wr.GetResponseStream());
                string ResponseXML = srd.ReadToEnd();
                //
                //JObject dynObj = JObject.Parse(ResponseXML); 
                //
                command = new SqlCommand();
                XmlDocument document = new XmlDocument();
                document.LoadXml(ResponseXML);
                int n = 0;
                Flag = true;
                n = document.SelectNodes("//Hotel").Count;
                if (n != 0)
                {
                    api.AvaavailStatus = document.SelectNodes("//RoomRate")[0].Attributes["availStatus"].Value;
                    try
                    {
                        RoomAvaCnt = Convert.ToInt32(document.SelectNodes("//RoomRate")[0].Attributes["availableCount"].Value);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> API Availability Existing Data --> Room Avaliable Count is Empty." + WebSecurity.CurrentUserName);
                        RoomAvaCnt = 0;
                    }
                    if (api.AvaavailStatus == "B")
                    {
                        decimal RoomRate1 = 0, RoomRate2 = 0, RoomDiscount1 = 0, RoomDiscount2 = 0;
                        decimal Taxes1 = 0, Taxes2 = 0;
                        XmlNodeList XmlRoomTariffs1 = document.DocumentElement.SelectNodes("/MMTHotelAvailResponse/Hotel/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate/Rate/RoomTariffs/RoomTariff");
                        foreach (XmlNode xnRT in XmlRoomTariffs1)
                        {
                            //string RoomTariffs = xnRT.InnerXml;XmlDocument XmlDoc = new XmlDocument();XmlDoc.LoadXml(RoomTariffs);
                            string RoomTariffs1 = xnRT.OuterXml;
                            XmlDocument XmlDoc1 = new XmlDocument();
                            XmlDoc1.LoadXml(RoomTariffs1);
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "1")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "2")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                        }
                        command = new SqlCommand();
                        ds = new DataSet();
                        command.CommandText = "SP_API_Help_FrontEnd";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "SingleDoubleRateLoad";
                        command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                        command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                        command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                        command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                        command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = api.HeaderId;
                        command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                        ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                        // ROOM RATE
                        decimal RoomNo1Existsamt = Convert.ToDecimal(ds.Tables[0].Rows[0][0].ToString()) * CntDys;
                        decimal RoomNo2Existsamt = Convert.ToDecimal(ds.Tables[1].Rows[0][0].ToString()) * CntDys;
                        // ROOM TAX
                        decimal RoomNo1ExistsTaxamt = 0;
                        if (ds.Tables[2].Rows.Count > 0)
                        {
                            RoomNo1ExistsTaxamt = Convert.ToDecimal(ds.Tables[2].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2ExistsTaxamt = 0;
                        if (ds.Tables[3].Rows.Count > 0)
                        {
                            RoomNo2ExistsTaxamt = Convert.ToDecimal(ds.Tables[3].Rows[0][0].ToString()) * CntDys;
                        }
                        // ROOM discount
                        decimal RoomNo1Existsdiscountamt = 0;
                        if (ds.Tables[4].Rows.Count > 0)
                        {
                            RoomNo1Existsdiscountamt = Convert.ToDecimal(ds.Tables[4].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2Existsdiscountamt = 0;
                        if (ds.Tables[5].Rows.Count > 0)
                        {
                            RoomNo2Existsdiscountamt = Convert.ToDecimal(ds.Tables[5].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal diff = Convert.ToDecimal(ds.Tables[6].Rows[0][0].ToString());
                        //
                        FlagStr = "";
                        //
                        //if ((RoomNo1Existsamt == RoomRate1) && (RoomNo2Existsamt == RoomRate2) && (RoomAvaCnt >= GstCnt) &&
                        //    (RoomNo1ExistsTaxamt == Taxes1) && (RoomNo2ExistsTaxamt == Taxes2) &&
                        //    (RoomNo1Existsdiscountamt == RoomDiscount1) && (RoomNo2Existsdiscountamt == RoomDiscount2))
                        //{
                        //    Flag = true;
                        //}
                        decimal Rate1diff = Math.Abs(RoomNo1Existsamt - RoomRate1);
                        decimal Rate2diff = Math.Abs(RoomNo2Existsamt - RoomRate2);
                        decimal Tax1diff = Math.Abs(RoomNo1ExistsTaxamt - Taxes1);
                        decimal Tax2diff = Math.Abs(RoomNo2ExistsTaxamt - Taxes2);
                        decimal Discount1diff = Math.Abs(RoomNo1Existsdiscountamt - RoomDiscount1);
                        decimal Discount2diff = Math.Abs(RoomNo2Existsdiscountamt - RoomDiscount2);
                        if ((Rate1diff < diff) && (Rate2diff < diff) && (Tax1diff < diff) && (Tax2diff < diff) &&
                            (Discount1diff < diff) && (Discount2diff < diff) && (RoomAvaCnt >= GstCnt))
                        {
                            Flag = true;
                        }
                        else
                        {
                            Flag = false; UpdateTariffFlag = "123";
                            // Tariff is Changed for this Hotel.
                            FlagStr = "Tariff is Changed.";
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = "SP_API_Help_FrontEnd";
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTTariffTaxesUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomRate1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomRate2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = Math.Round(Taxes1 / CntDys);
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = Math.Round(Taxes2 / CntDys);
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = "SP_API_Help_FrontEnd";
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTDiscountUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomDiscount1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomDiscount2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            //if ((roomdiscount1 != 0) || (roomdiscount2 != 0))
                            //{
                            //    command = new sqlcommand();
                            //    ds = new dataset();
                            //    command.commandtext = storedprocedures.api_help;
                            //    command.commandtype = commandtype.storedprocedure;
                            //    command.parameters.add("@action", sqldbtype.nvarchar).value = "mmtdiscountupdate";
                            //    command.parameters.add("@str1", sqldbtype.nvarchar).value = api.hotelid;
                            //    command.parameters.add("@str2", sqldbtype.nvarchar).value = api.rateplancode;
                            //    command.parameters.add("@str3", sqldbtype.nvarchar).value = api.roomtypecode;
                            //    command.parameters.add("@str4", sqldbtype.nvarchar).value = api.headerid;
                            //    command.parameters.add("@id1", sqldbtype.bigint).value = math.round(roomdiscount1 / cntdys);
                            //    command.parameters.add("@id2", sqldbtype.bigint).value = math.round(roomdiscount2 / cntdys);
                            //    command.parameters.add("@id3", sqldbtype.bigint).value = 0;
                            //    command.parameters.add("@id4", sqldbtype.bigint).value = 0;
                            //    ds = new wrberpconnection().executedataset(command, userdata);
                            //}
                        }
                    }
                    else
                    {
                        Flag = false; UpdateTariffFlag = "";
                        // Room is Not Avaliable for this Date Range.
                        FlagStr = "Room is Not Avaliable";
                        return FlagStr;
                    }
                }
                else
                {
                    Flag = false; UpdateTariffFlag = "";
                    // Hotel is Not Avaliable for this Date Range.
                    FlagStr = "Hotel is Not Avaliable";
                    return FlagStr;
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> API Availability Existing Data." + WebSecurity.CurrentUserName);
                Flag = false;
                FlagStr = "Error";
                return FlagStr;
            }
            //if (Flag == false)
            //{
            //    command = new SqlCommand();
            //    ds = new DataSet();
            //    command.CommandText = StoredProcedures.API_Help;
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "FalseFlagLoad";
            //    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = FlagStr;
            //    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = UpdateTariffFlag;
            //    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            //    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //    /*DataTable dT1 = new DataTable("DBERRORTBL");
            //    ds.Tables.Add(dT1);
            //    DataTable dTable = new DataTable("ERRORTBL");
            //    dTable.Columns.Add("Exception");
            //    DataTable dT = new DataTable("Table");
            //    dT.Columns.Add("Str");*/
            //}
            //else
            //{
            //    command = new SqlCommand();
            //    ds = new DataSet();
            //    command.CommandText = ""API_Help;
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "TrueFlagLoad";
            //    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            //    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            //    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            //    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //}
            return "";
        }

        public DataSet FnCreateReservation(string[] data, long? userid)
        {
            bool flg = true;
            //DataSet asd = new DataSet();DataTable asddT = new DataTable("Table");asddT.Columns.Add("Str");asddT.Columns.Add("Str1");asddT.Rows.Add("No", "No1");ds.Tables.Add(asddT);return ds;            
            string Step = "";
            //DataTable dT = new DataTable("Table1");
            //dT.Columns.Add("Str");
            //UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
            //           ", SctId : " + user.SctId + ", Service : APICreateReservationDAO" +
            //           ", ProcName: " + StoredProcedures.API_Help;
            //
            command = new SqlCommand();
            ds = new DataSet();
            command.CommandText = "SP_API_Help_FrontEnd";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            APIDynamic api = new APIDynamic();
            //
            try
            {
                api.BookingId = Convert.ToInt32(data[6].ToString());
                api.CityCode = ds.Tables[0].Rows[0][0].ToString();
                api.HotelId = ds.Tables[0].Rows[0][1].ToString();
                api.PtyRatePlancode = ds.Tables[0].Rows[0][2].ToString();
                api.PtyRoomTypecode = ds.Tables[0].Rows[0][3].ToString();
                api.start = ds.Tables[0].Rows[0][4].ToString();
                api.End = ds.Tables[0].Rows[0][5].ToString();
                api.singlecnt = Convert.ToInt32(ds.Tables[0].Rows[0][6].ToString());
                api.doublecnt = Convert.ToInt32(ds.Tables[0].Rows[0][7].ToString());
                //
                //string pattern = @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
                //Regex.IsMatch(api.Surname, pattern);
                //System.Text.RegularExpressions.Match match = Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                //
                Step = "Availability Request";
                //
                WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelAvailability");
                HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                httpRequest.Method = "POST";
                httpRequest.ContentType = "application/xml; charset=utf-8";
                httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                httpRequest.ProtocolVersion = HttpVersion.Version11;
                httpRequest.Credentials = CredentialCache.DefaultCredentials;
                httpRequest.Timeout = 100000000;
                Stream requestStream = httpRequest.GetRequestStream();
                //Create Stream and Complete Request             
                StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                soapRequest.Append("<MMTHotelAvailRequest>");
                soapRequest.Append("<POS>");
                //soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // test
                soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
                soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
                soapRequest.Append("</POS>");
                soapRequest.Append("<ResultTransformer>");
                soapRequest.Append("<CancellationPolicyRulesReq text=\"yes\"/>");
                soapRequest.Append("</ResultTransformer>");
                soapRequest.Append("<HotelAvailabilityCriteria>");
                soapRequest.Append("<Area>");
                soapRequest.Append("<CityCode>");
                soapRequest.Append(api.CityCode);
                soapRequest.Append("</CityCode>");
                //soapRequest.Append("<CityCode>TCC</CityCode>");
                soapRequest.Append("<CountryCode>IN</CountryCode>");
                soapRequest.Append("</Area>");
                soapRequest.Append("<HotelRef id='" + api.HotelId + "'/>");
                soapRequest.Append("<RatePlan code='" + api.PtyRatePlancode + "'/>");
                soapRequest.Append("<RoomType code='" + api.PtyRoomTypecode + "'/>");
                // single & double room added
                soapRequest.Append("<RoomStayCandidates>");
                if (api.singlecnt > 0)
                {
                    for (int i = 0; i < api.singlecnt; i++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                if (api.doublecnt > 0)
                {
                    for (int j = 0; j < api.doublecnt; j++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                soapRequest.Append("</RoomStayCandidates>");
                //soapRequest.Append("<StayDateRange start="2014-10-10" end="2014-10-11"/>");
                soapRequest.Append("<StayDateRange start='" + api.start + "' end='" + api.End + "'/>");
                soapRequest.Append("</HotelAvailabilityCriteria>");
                soapRequest.Append("</MMTHotelAvailRequest>");
                streamWriter.Write(soapRequest.ToString());
                streamWriter.Close();
                //Get the Response
                HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                StreamReader srd = new StreamReader(wr.GetResponseStream());
                string ResponseXML = srd.ReadToEnd();
                command = new SqlCommand();
                XmlDocument document = new XmlDocument();
                //document.LoadXml(NewHeader);
                document.LoadXml(ResponseXML);
                int n = 0;
                n = document.SelectNodes("//Hotel").Count;
                if (n != 0)
                {
                    Step = "Availability Response";
                    api.AvaavailStatus = document.SelectNodes("//RoomRate")[0].Attributes["availStatus"].Value;
                    if (api.AvaavailStatus == "B")
                    {
                        api.AvaRatePlanCode = document.SelectNodes("//RoomRate")[0].Attributes["ratePlanCode"].Value;
                        //api.AvaRoomTypecode = document.SelectNodes("//RoomRate")[0].Attributes["roomTypeCode"].Value;
                        //
                        api.AmountAfterTax = Convert.ToDecimal(document.SelectNodes("//AmountAfterTax")[0].InnerText);
                        api.AmountBeforeTax = Convert.ToDecimal(document.SelectNodes("//AmountBeforeTax")[0].InnerText);
                        api.AvaResponseCode = document.SelectNodes("//ResponseCode")[0].Attributes["success"].Value;
                        api.AvaResponseReferenceKey = document.SelectNodes("//ResponseReferenceKey")[0].InnerText;
                        //
                        if (api.AvaResponseCode == "true")
                        {
                            Step = "Book Hotel Request";
                            WebRequest webRequest1 = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/book/v1.0/bookHotels");
                            HttpWebRequest httpRequest1 = (HttpWebRequest)webRequest1;
                            httpRequest1.Method = "POST";
                            httpRequest1.ContentType = "application/xml; charset=utf-8";
                            httpRequest1.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                            //httpRequest1.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                            httpRequest1.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                            httpRequest1.ProtocolVersion = HttpVersion.Version11;
                            httpRequest1.Credentials = CredentialCache.DefaultCredentials;
                            httpRequest1.Timeout = 100000000;
                            Stream requestStream1 = httpRequest1.GetRequestStream();
                            //Create Stream and Complete Request             
                            StreamWriter streamWriter1 = new StreamWriter(requestStream1, Encoding.ASCII);
                            StringBuilder BookRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                            BookRequest.Append("<MMTHotelReservationRequest>");
                            BookRequest.Append("<POS>");
                            //BookRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // test
                            BookRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
                            BookRequest.Append("<Source iSOCurrency=\"INR\"/>");
                            BookRequest.Append("</POS>");
                            BookRequest.Append("<HotelReservation>");
                            BookRequest.Append("<Criterion>");
                            BookRequest.Append("<Area>");
                            //BookRequest.Append("<CityCode>TCC</CityCode>");
                            BookRequest.Append("<CityCode>");
                            BookRequest.Append(api.CityCode);
                            BookRequest.Append("</CityCode>");
                            BookRequest.Append("<CountryCode>IN</CountryCode>");
                            BookRequest.Append("</Area>");
                            BookRequest.Append("<HotelRef id='" + api.HotelId + "' idContext=\"\"/>");
                            BookRequest.Append("<RatePlan code='" + api.AvaRatePlanCode + "'/>");
                            BookRequest.Append("<RoomType code='" + api.PtyRoomTypecode + "'/>");
                            BookRequest.Append("<RoomStayCandidates>");
                            if (api.singlecnt > 0)
                            {
                                for (int i = 0; i < api.singlecnt; i++)
                                {
                                    BookRequest.Append("<RoomStayCandidate>");
                                    BookRequest.Append("<GuestCounts>");
                                    BookRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                                    BookRequest.Append("</GuestCounts>");
                                    BookRequest.Append("</RoomStayCandidate>");
                                }
                            }
                            if (api.doublecnt > 0)
                            {
                                for (int j = 0; j < api.doublecnt; j++)
                                {
                                    BookRequest.Append("<RoomStayCandidate>");
                                    BookRequest.Append("<GuestCounts>");
                                    BookRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                                    BookRequest.Append("</GuestCounts>");
                                    BookRequest.Append("</RoomStayCandidate>");
                                }
                            }
                            BookRequest.Append("</RoomStayCandidates>");
                            BookRequest.Append("<Tariff currencyCode='INR' amountBeforeTax='" + api.AmountBeforeTax + "' amountAfterTax='" + api.AmountAfterTax + "'/>");
                            //BookRequest.Append("<StayDateRange start='2014-10-10' end='2014-10-11'/>");
                            BookRequest.Append("<StayDateRange start='" + api.start + "' end='" + api.End + "'/>");
                            BookRequest.Append("</Criterion>");
                            BookRequest.Append("<ReservationGlobalInfo>");
                            BookRequest.Append("<PayAuth ref='' provider='MMT-PG' code='3143318'/>");
                            BookRequest.Append("</ReservationGlobalInfo>");
                            BookRequest.Append("<ReservationGuests>");
                            // GUST BEGIN
                            api.BookEmail = ds.Tables[0].Rows[0][8].ToString();
                            for (int Cnt = 0; Cnt < ds.Tables[0].Rows.Count; Cnt++)
                            {
                                api.GivenName = ds.Tables[0].Rows[Cnt][9].ToString();
                                api.NamePrefix = ds.Tables[0].Rows[Cnt][10].ToString();
                                api.Surname = ds.Tables[0].Rows[Cnt][11].ToString();
                                /*string your_String = "Sakthi!@&()''";
                                string my_String = Regex.Replace(your_String, @"[^a-zA-Z]+", "");
                                int len = my_String.Length;*/
                                if (Cnt == 0)
                                {
                                    BookRequest.Append("<ReservationGuest primary=\"true\">");
                                }
                                else
                                {
                                    BookRequest.Append("<ReservationGuest primary=\"false\">");
                                }
                                BookRequest.Append("<CustomerAge>30</CustomerAge>");
                                //BookRequest.Append("<Email type='PERSONAL'>hotels-qa@makemytrip.com</Email>");
                                BookRequest.Append("<Email type='PERSONAL'>" + api.BookEmail + "</Email>");
                                BookRequest.Append("<PersonName>");
                                BookRequest.Append("<GivenName>" + api.GivenName + "</GivenName>");
                                BookRequest.Append("<NamePrefix>" + api.NamePrefix + "</NamePrefix>");
                                BookRequest.Append("<Surname>" + api.Surname + "</Surname>");
                                BookRequest.Append("</PersonName>");
                                BookRequest.Append("<SpecialRequests>nothing</SpecialRequests>");
                                BookRequest.Append("<Telephone phoneUseType='DAYTIME' phoneTechType='2' phoneNumber='1234567890' areaCityCode=''/>");
                                BookRequest.Append("</ReservationGuest>");
                            }
                            /*BookRequest.Append("<ReservationGuest primary=\"true\">");
                            BookRequest.Append("<CustomerAge>30</CustomerAge>");
                            BookRequest.Append("<Email type='PERSONAL'>hotels-qa@makemytrip.com</Email>");
                            BookRequest.Append("<PersonName>");
                            BookRequest.Append("<GivenName>Test</GivenName>");
                            BookRequest.Append("<NamePrefix>Mr</NamePrefix>");
                            BookRequest.Append("<Surname>Test</Surname>");
                            BookRequest.Append("</PersonName>");                            
                            BookRequest.Append("<SpecialRequests>nothing</SpecialRequests>");
                            BookRequest.Append("<Telephone phoneUseType='DAYTIME' phoneTechType='2' phoneNumber='1234567890' areaCityCode=''/>");
                            BookRequest.Append("</ReservationGuest>");*/
                            // GUST END
                            BookRequest.Append("</ReservationGuests>");
                            BookRequest.Append("</HotelReservation>");
                            BookRequest.Append("<ResponseReferenceKey>" + api.AvaResponseReferenceKey + "</ResponseReferenceKey>");
                            BookRequest.Append("</MMTHotelReservationRequest>");
                            streamWriter1.Write(BookRequest.ToString());
                            streamWriter1.Close();
                            //Get the Response
                            HttpWebResponse wr1 = (HttpWebResponse)httpRequest1.GetResponse();
                            StreamReader srd1 = new StreamReader(wr1.GetResponseStream());
                            string ResponseXML1 = srd1.ReadToEnd();
                            document = new XmlDocument();
                            document.LoadXml(ResponseXML1);
                            //api.HotelId = document.SelectNodes("//HotelRef")[0].Attributes["id"].Value;
                            api.BookResponseCode = document.SelectNodes("//ResponseCode")[0].Attributes["success"].Value;
                            //
                            if (api.BookResponseCode == "true")
                            {
                                Step = "Book Hotel Response";
                                api.BookReservationGlobalInfo = document.SelectNodes("//ReservationGlobalInfo")[0].Attributes["status"].Value;
                                if (api.BookReservationGlobalInfo == "B")
                                {
                                    api.BookHotelReservationIdvalue = document.SelectNodes("//HotelReservationId")[0].Attributes["value"].Value;
                                    api.BookHotelReservationIdtype = document.SelectNodes("//HotelReservationId")[0].Attributes["type"].Value;
                                    //
                                    api.BookResponseReferenceKey = document.SelectNodes("//ResponseReferenceKey")[0].InnerText;
                                    command = new SqlCommand();
                                    ds = new DataSet();
                                    command.CommandText = "SP_APIPropertyDetails_Update_FrondEnd";
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@AvaRatePlanCode", SqlDbType.NVarChar).Value = api.AvaRatePlanCode;
                                    command.Parameters.Add("@AmountAfterTax", SqlDbType.Decimal).Value = api.AmountAfterTax;
                                    command.Parameters.Add("@AmountBeforeTax", SqlDbType.Decimal).Value = api.AmountBeforeTax;
                                    command.Parameters.Add("@AvaResponseReferenceKey", SqlDbType.NVarChar).Value = api.AvaResponseReferenceKey;
                                    command.Parameters.Add("@BookHotelReservationIdvalue", SqlDbType.NVarChar).Value = api.BookHotelReservationIdvalue;
                                    command.Parameters.Add("@BookHotelReservationIdtype", SqlDbType.NVarChar).Value = api.BookHotelReservationIdtype;
                                    command.Parameters.Add("@BookResponseReferenceKey", SqlDbType.NVarChar).Value = api.BookResponseReferenceKey;
                                    command.Parameters.Add("@HotelId", SqlDbType.BigInt).Value = Convert.ToInt64(api.HotelId);
                                    command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = Convert.ToInt32(api.BookingId);
                                    command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = userid;
                                    //BookRequest.ToString()
                                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    //
                                    //CreateLogFiles log1 = new CreateLogFiles();
                                    //log1.ErrorLog("M M T BOOKING CONFIRMATION NO --> " + api.BookHotelReservationIdvalue);
                                }
                                else
                                {
                                    //Book Hotel Response - available status is E.                            
                                    flg = false;
                                    FlagStr = "Book Hotel Response - available status is E.";
                                }
                            }
                            else
                            {
                                //Book Response Code is False.
                                flg = false;
                                FlagStr = "Book Response Code is False.";
                            }
                        }
                        else
                        {
                            //Availability Available Status is E.                            
                            flg = false;
                            FlagStr = "Availability Available Status is E";
                        }
                    }
                    else
                    {
                        //Availability Response Code is False.
                        flg = false;
                        FlagStr = "Availability Response Code is False.";
                    }
                }
                else
                {
                    //Availability Hotel Count is Zero OR Error
                    flg = false;
                    FlagStr = "Availability Hotel Count is Zero.";
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + ex.Message + WebSecurity.CurrentUserName);
                flg = false;
                FlagStr = "Error";
            }
            if (flg == false)
            {
                //dT.Rows.Add("No");ds.Tables.Add(dT);
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_API_Help_FrontEnd";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookFalseFlagLoad";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = FlagStr;
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else
            {
                //DataSet ds1 = new APIBookingMailDAO().Mail(api.BookingId);
                //dT.Rows.Add("Yes");ds.Tables.Add(dT);
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookTrueFlagLoad";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }

    }
}


