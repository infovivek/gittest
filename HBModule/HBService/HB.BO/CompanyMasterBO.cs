using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CompanyMasterBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new CompanyMasterDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new CompanyMasterDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new CompanyMasterDAO().Delete(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new CompanyMasterDAO().HelpResult(data, user);
        }
    }
}
