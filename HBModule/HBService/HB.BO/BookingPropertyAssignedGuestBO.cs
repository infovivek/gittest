using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class BookingPropertyAssignedGuestBO
    {
        public DataSet Save(string PropertyAssignedGuest, User user, int BookingId)
        {
            return new BookingPropertyAssignedGuestDAO().Save(PropertyAssignedGuest, user, BookingId);
        }
    }
}
