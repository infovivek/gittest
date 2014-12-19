using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using HB.Dao;

namespace HB.BusinessService.BusinessService
{
    public class BookingPaymentEmailService:IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            return new BookingPaymentEmailDAO().FnBookingPaymentEmail(data, user);
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
            throw new NotImplementedException();
        }
    }
}
