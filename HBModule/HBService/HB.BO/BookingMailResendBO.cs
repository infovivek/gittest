using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.Dao;

namespace HB.BO
{
    public class BookingMailResendBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            throw new NotImplementedException();
        }
        public DataSet Search(string[] data, User user)
        {
            throw new NotImplementedException();
        }
        public DataSet Delete(string[] data, User user)
        {
            throw new NotImplementedException();
        }
        public DataSet Help(string[] data, User user)
        {
            return new BookingMailResendDAO().Help(data, user);
        }
    }
}
