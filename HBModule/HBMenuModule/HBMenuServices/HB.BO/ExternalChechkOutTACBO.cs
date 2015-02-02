using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ExternalChechkOutTACBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new ExternalChechkOutTACDao().Save(data, User);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new ExternalChechkOutTACDao().HelpResult(data, user);
        }
    }
}
