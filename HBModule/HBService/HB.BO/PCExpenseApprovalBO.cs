using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PCExpenseApprovalBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new PCExpenseApprovalDAO().Save(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new PCExpenseApprovalDAO().Help(data, user);
        }

    }
}
