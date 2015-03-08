using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using test1.Models;
using WebMatrix.WebData;

namespace test1.Controllers
{
    public class AccountController : Controller
    {
        HBEntities db = new HBEntities();
        //
        // GET: /Account/
        public ActionResult Login()
        {
            var Dt1 = DateTime.Now.AddDays(1);
            string date1 = Dt1.Date.ToString("MM/dd/yyyy");
            var Dt2 = DateTime.Now.Date.AddDays(2);
            string date2 = Dt2.Date.ToString("MM/dd/yyyy");
            ViewBag.IN = date1;
            ViewBag.OUT = date2;
            return View();
        }
        [HttpPost]
        public ActionResult Login(string username, string Password, string ReturnUrl)
        {
            if (ModelState.IsValid)
            {
                string DecryptPassword = ""; bool TravelDesk = true;

                var pswd = (from s in db.DecryptPswd("TravelDesk", username)
                            select new  {s.UserPassword }).FirstOrDefault();

               if (pswd != null)
               {
                   DecryptPassword = pswd.UserPassword;
                   TravelDesk = true;
               }
                

                if (DecryptPassword == "")
                {
                    var secondPswd = (from s in db.DecryptPswdClientGuestTable("ClientGuest", username)
                                      select new AccountLoginBO { Password = s.UserPassword }).FirstOrDefault();
                    if (secondPswd != null)
                    {
                        DecryptPassword = secondPswd.Password;
                        TravelDesk = false;
                    }
                   
                    
                }

                if (DecryptPassword != "")
                {
                    if (DecryptPassword == Password)
                    {
                        var exists = db.UserProfiles.FirstOrDefault(s => s.UserName == username && s.Password == Password);
                        if (exists != null)
                        {
                            if (WebSecurity.Login(username, Password))
                            {
                                if (ReturnUrl != null)
                                {
                                    return Redirect(ReturnUrl);
                                }
                                return RedirectToAction("Index", "Home");
                            }
                            else
                            {
                                ViewBag.error = "Sorry The UserName or Password is Invalid";
                                return View();
                            }
                        }
                        else
                        {
                            WebSecurity.CreateUserAndAccount(username, Password);
                            WebSecurity.Login(username, Password);
                            var appuser = db.UserProfiles.FirstOrDefault(u => u.UserName == username);
                            appuser.Password = Password;

                            if (TravelDesk == true)
                            {
                                var user = (from u in db.WrbhbTravelDesks
                                            where u.Email == username
                                            select u).FirstOrDefault();
                                user.App_UserId = Convert.ToInt64(appuser.UserId);
                            }
                            else
                            {
                                var user = (from u in db.WRBHBClientManagementAddClientGuests
                                            where u.EmailId == username
                                            select u).FirstOrDefault();
                                user.App_UserId = Convert.ToInt64(appuser.UserId);
                            }
                            db.SaveChanges();
                            if (ReturnUrl != null)
                            {
                                return Redirect(ReturnUrl);
                            }
                            return RedirectToAction("Index", "Home");
                        }
                    }
                    else
                    {
                        ViewBag.error = "Sorry The UserName or Password is Invalid";
                        return View();
                    }

                }
                else
                {
                    ViewBag.error = "Sorry The UserName or Password is Invalid";
                    return View();
                }

            }
            ViewBag.error = "Sorry The UserName or Password is Invalid";
            return View();
        }





        public ActionResult New_User()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult New_User(UserRegisterBO registermodel)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    WebSecurity.CreateUserAndAccount(registermodel.New_UserName, registermodel.New_Password);
                    WebSecurity.Login(registermodel.New_UserName, registermodel.New_Password);
                    HBEntities db = new HBEntities();

                    var user = db.UserProfiles.FirstOrDefault(s => s.UserName == registermodel.New_UserName);
                    user.Password = registermodel.New_Password;

                    var desk = db.WrbhbTravelDesks.FirstOrDefault(t => t.Email == user.UserName);
                    desk.App_UserId = user.UserId;
                    db.SaveChanges();
                    return RedirectToAction("Index", "Home");

                }
                catch (MemberAccessException exe)
                {
                    ModelState.AddModelError("", "Sorry The UserName Already Existed");
                    return View(registermodel);

                }
            }
            ModelState.AddModelError("", "Sorry The UserName Already Existed");
            return View();
        }

        public ActionResult Logout()
        {
            WebSecurity.Logout();
            return RedirectToAction("Index", "Home");
        }

        public ActionResult ForgetPassword()
        {
            return View();
        }
    }
}