using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ExternalIntermediateCheckOutBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new ExternalIntermediateCheckOutDao().Save(data, User);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ExternalIntermediateCheckOutDao().Search(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new ExternalIntermediateCheckOutDao().HelpResult(data, user);
        }
    }
}
