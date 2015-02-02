using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ReassignClientBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new ReassignClientDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ReassignClientDAO().Search(data, user);
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            return new ReassignClientDAO().Delete(Hdrval, user);
        }
        public DataSet Help(string[] Hdrval, User user)
        {
            return new ReassignClientDAO().Help(Hdrval, user);
        }
    }
}
