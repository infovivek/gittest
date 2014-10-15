using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PCHistroryBO
    {
        public DataSet HelpResult(string[] data, User user)
        {
            return new PCHistroryDAO().Help(data, user);
        }
    }
}
