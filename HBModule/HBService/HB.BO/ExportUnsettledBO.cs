using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class ExportUnsettledBO
    {
        public DataSet HelpResult(string[] data, User user)
        {
            return new ExportUnsettledDAO().HelpResult(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ExportUnsettledDAO().Search(data, user);
        }
    }
}
