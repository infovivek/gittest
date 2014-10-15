using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PettyCashApprovalHdrBO
    {
        public DataSet Save(string data, User user)
        {
            return new PettyCashApprovalHdrDAO().Save(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new PettyCashApprovalHdrDAO().Help(data, user);
        }
    }
}
