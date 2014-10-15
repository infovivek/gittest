using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ExternalExpenseReportBO
    {
        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new ExternalExpenseReportDAO().Help(data, user);
        }
    }
}
