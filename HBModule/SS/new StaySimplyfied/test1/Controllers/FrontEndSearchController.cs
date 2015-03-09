using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace test1.Controllers
{
    public class FrontEndSearchController : Controller
    {
        //
        // GET: /FrontEndSearch/
        [HttpPost]
        public ActionResult SearchProperty(string destination, string checkin, string checkout, string Adult, decimal room1)
        {
            return RedirectToAction("Index", "Home");
        }
	}
}