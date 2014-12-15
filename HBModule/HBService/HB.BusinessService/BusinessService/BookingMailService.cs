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
    public class BookingMailService:IBusinessService
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
                ds = new BookingRoomMailDAO().Mail(BookingId, user);
                //string dfd = ds.Tables["Table12"].Rows[0][0].ToString();
                if (ds.Tables["Table12"].Rows[0][0].ToString() == "")
                {
                    DataSet ds1 = new SMSDAO().FnSMS(BookingId, user);
                }
            }
            if (data[1].ToString() == "Bed")
            {
                ds = new BedBookingMailDAO().Mail(BookingId, user);
                if (ds.Tables["Table11"].Rows[0][0].ToString() == "")
                {
                    DataSet ds1 = new SMSDAO().FnSMS(BookingId, user);
                }
            }
            if (data[1].ToString() == "Apartment")
            {
                ds = new ApartmentBookingMailDAO().Mail(BookingId, user);
                if (ds.Tables["Table11"].Rows[0][0].ToString() == "")
                {
                    DataSet ds1 = new SMSDAO().FnSMS(BookingId, user);
                }
            }
            if (data[1].ToString() == "Recommend")
            {
                ds = new BookingRecommendPropertyMailDAO().Mail(BookingId);
            }
            if (data[1].ToString() == "MMT")
            {
                ds = new APIBookingMailDAO().Mail(BookingId, user);
                DataSet ds1 = new SMSDAO().FnSMS(BookingId, user);
            }
            if (data[1].ToString() == "BookingCancelMMT")
            {
                ds = new BookingCancelMMTDAO().FnCancel(data, user);
            }
            if (data[1].ToString() == "SMS")
            {
                ds = new SMSDAO().FnSMS(BookingId, user);
            }
            if (data[1].ToString() == "RoomResend")
            {
                ds = new BookingRoomResendMailDAO().Mail(BookingId, "", "", user);
            }
            return ds;
        }
    }
}
