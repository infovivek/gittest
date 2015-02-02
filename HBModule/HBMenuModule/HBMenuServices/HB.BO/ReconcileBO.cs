using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class ReconcileBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new ReconcileDAO().Save(data, user);
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new ReconcileDAO().Search(data, user);
        }

        public DataSet Help(string[] data, Entity.User user)
        {
            return new ReconcileDAO().Help(data, user);
        }
    }
}
