using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class SearchBookingBO
    {
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new SearchBookingDAO().Help(data, user);
        }

        public DataSet Search(string[] data, User user)
        {
            return new SearchBookingDAO().Search(data, user);
        }
    }
}
