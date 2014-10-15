using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class LaundryServiceHdrBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new LaundryServiceHdrDAO().Save(data, User);
        }
        public DataSet Search(string[] data, User user)
        {
            return new LaundryServiceHdrDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new LaundryServiceHdrDAO().Delete(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new LaundryServiceHdrDAO().HelpResult(data, user);
        }
    }
}
