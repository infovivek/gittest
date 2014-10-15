using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using System.Data;
using HB.Entity;

namespace HB.BO
{
    public class BookingPropertyBO
    {
        public DataSet Save(string Property, User user, int BookingId)
        {
            return new BookingPropertyDAO().Save(Property, user, BookingId);
        }
    }
}
