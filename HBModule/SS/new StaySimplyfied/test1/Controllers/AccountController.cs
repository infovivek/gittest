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
            return View();
        }
        [HttpPost]
        public ActionResult Login(string username, string Password, string ReturnUrl)
        {
            if (ModelState.IsValid)
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
                        //ModelState.AddModelError("", "Sorry The UserName or Password is Invalid");
                        return View();
                    }
                }
                else
                {
                    var pswd = (from s in db.DecryptPswd(username)
                                select new AccountLoginBO { Password = s.UserPassword }).FirstOrDefault();

                    string psd = pswd != null ? pswd.Password : "";

                    var user = (from u in db.WrbhbTravelDesks
                                where u.Email == username && Password == pswd.Password
                                select u).FirstOrDefault();

                    if (user != null)
                    {
                        WebSecurity.CreateUserAndAccount(username, Password);
                        WebSecurity.Login(username, Password);

                        var userprofiles = db.UserProfiles.FirstOrDefault(s => s.UserName == username);
                        userprofiles.Password = Password;

                        user.App_UserId = userprofiles.UserId;

                        db.SaveChanges();

                        return RedirectToAction("Index", "Home");
                    }
                }
            }
            
            //ModelState.AddModelError("", "Sorry The UserName or Password is Invalid");
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
    }
}