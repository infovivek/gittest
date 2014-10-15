using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class VendorAdvancePaymentBO
    {
        public DataSet Save(string[] AdvancePay, User user)
        {
            return new VendorAdvancePaymentDAO().Save(AdvancePay, user); 
        }
        public DataSet Search(string[] data, User user)
        {
            return new VendorAdvancePaymentDAO().Search(data, user); 
        }
    }
}
