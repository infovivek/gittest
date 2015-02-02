using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;
using HB.Entity;
using System.Xml;

namespace HB.BusinessService.BusinessService
{
    public class BedBookingResendMailService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Delete(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
            Int32 BookingId = Convert.ToInt32(data[2].ToString());
            DataSet ds = new DataSet();
            if (data[1].ToString() == "Room")
            {
                ds = new BookingRoomResendMailDAO().Mail(BookingId);
            }
            if (data[1].ToString() == "Bed")
            {
                ds = new BedBookingesendMailDAO().Mail(BookingId);
            }
            if (data[1].ToString() == "Apartment")
            {
                ds = new ApartmentBookingResendMailDAO().Mail(BookingId);
            }
            return ds;
        }
    }
}
