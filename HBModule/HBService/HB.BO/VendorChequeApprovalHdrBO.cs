using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class VendorChequeApprovalHdrBO
    {
        public DataSet Save(string data, User user)
        {
            return new VendorChequeApprovalHdrDAO().Save(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new VendorChequeApprovalHdrDAO().Help(data, user);
        }
    }
}
