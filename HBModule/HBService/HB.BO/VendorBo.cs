using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
   public class VendorBo
    {
        public DataSet Save(string[] Hdrval, User user)
        {
            return new VendorDao().Save(Hdrval, user);
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            return new VendorDao().Delete(Hdrval, user);
        }
        public DataSet Search(string[] Hdrval, User user)
        {
            return new VendorDao().Search(Hdrval, user);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new VendorDao().HelpResult(Hdrval, user);
        }

    }
}
