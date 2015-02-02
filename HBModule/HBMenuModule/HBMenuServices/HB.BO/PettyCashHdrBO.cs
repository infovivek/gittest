using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PettyCashHdrBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new PettyCashHdrDAO().Save(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new PettyCashHdrDAO().Help(data, user);
        }
    }
}
