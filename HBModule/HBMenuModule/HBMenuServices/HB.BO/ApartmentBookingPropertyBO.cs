using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using System.Data;
using HB.Entity;

namespace HB.BO
{
    public class ApartmentBookingPropertyBO
    {
        public DataSet Save(string BedBookingProperty, User user, int BookingId)
        {
            return new ApartmentBookingPropertyDAO().Save(BedBookingProperty, user, BookingId);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ApartmentBookingPropertyDAO().Help(data, user);
        }
    }
}
