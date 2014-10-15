using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class BookingGuestDetailsBO
    {
       public DataSet Save(string BookingGuestDetails, User user, int BookingId)
        {
            return new BookingGuestDetailsDAO().Save(BookingGuestDetails, user, BookingId);
        }
    }
}
