using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutPaymentBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new CheckOutPaymentDao().Save(Hdrval, user);
        }
    }
}
