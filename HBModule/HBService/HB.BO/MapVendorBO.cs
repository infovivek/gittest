using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class MapVendorBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new MapVendorDAO().Save(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new MapVendorDAO().HelpResult(data, user);
        }
    }
}
