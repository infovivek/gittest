using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using HB.Dao;
using System.Data;
using System.Configuration;
using System.Collections;

namespace HB.BO
{
    public class PaxInOutBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new PaxInOutDAO().Save(data, User);
        }
        public DataSet Search(string[] data, User User)
        {
            return new PaxInOutDAO().Search(data, User);
        }
        public DataSet Delete(string[] data, User User)
        {
            return new PaxInOutDAO().Delete(data, User);
        }
        public DataSet Help(string[] data, User User)
        {
            return new PaxInOutDAO().Help(data, User);
        }
    }
}
