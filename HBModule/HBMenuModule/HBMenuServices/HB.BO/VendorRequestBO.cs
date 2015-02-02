using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class VendorRequestBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new VendorRequestDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new VendorRequestDAO().Search(data, user);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new VendorRequestDAO().Help(Hdrval, user);
        }
    }
}
