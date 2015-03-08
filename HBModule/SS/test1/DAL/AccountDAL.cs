using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using test1.Models;
using WebMatrix.WebData;

namespace test1.DAL
{
    public class AccountDAL
    {
        //public void LoginVerification(string UserName, string Password)
        //{
        //    using (HBEntities db = new HBEntities())
        //    {
        //        var exists = db.UserProfiles.FirstOrDefault(s => s.UserName == UserName && s.Password == Password);
        //        if (exists != null)
        //        {

        //        }
        //        var pswd = (from s in db.DecryptPswd(UserName)
        //                    select new AccountLoginBO { Password = s.UserPassword }).FirstOrDefault();

        //        string psd = pswd != null ? pswd.Password : "";

        //        var user = (from u in db.WrbhbTravelDesks
        //                    where u.Email == UserName && Password == pswd.Password
        //                    select u).FirstOrDefault();

        //        //if (user != null )
        //        //{
        //        //    WebSecurity.CreateAccount()
        //        //}
        //    }
        //}
   
    }
}