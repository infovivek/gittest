using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class MapPOAndVendorBO
    {
       public DataSet Save(string []Hdrval, User user, int BookingId, string Remarks, string SendMail)
       {
           return new MapPOAndVendorDAO().Save(Hdrval, user, BookingId, Remarks, SendMail);
       }
        //public DataSet Delete(string[] data, User user)
        //{
        //    return new BookingCancelDAO().Delete(data, user);
        //}
        public DataSet Help(string[] data, User user)
        {
            return new MapPOAndVendorDAO().Help(data, user);
        }
    }
}
