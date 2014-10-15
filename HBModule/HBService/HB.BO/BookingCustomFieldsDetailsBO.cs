using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class BookingCustomFieldsDetailsBO
    {
        public DataSet Save(string CustomFieldsDetails, User user, int BookingId)
        {
            return new BookingCustomFieldsDetailsDAO().Save(CustomFieldsDetails, user, BookingId);
        }
      
    }
}
