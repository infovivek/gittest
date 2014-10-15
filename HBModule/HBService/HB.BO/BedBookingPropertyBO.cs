using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using System.Data;
using HB.Entity;

namespace HB.BO
{
    public class BedBookingPropertyBO
    {
        public DataSet Save(string BedBookingProperty, User user, int BookingId)
        {
            return new BedBookingPropertyDAO().Save(BedBookingProperty, user, BookingId);
        }
        public DataSet Help(string[] data, User user)
        {
            return new BedBookingPropertyDAO().Help(data, user);
        }
    }
}
