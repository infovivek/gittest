using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckoutAndIntermediateBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new CheckoutAndIntermediateDao().Save(data, User);
        }
        public DataSet Search(string[] data, User user)
        {
            return new GuestCheckOutDao().Search(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new CheckoutAndIntermediateDao().HelpResult(data, user);
        }
    }
}
