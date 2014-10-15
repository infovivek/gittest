using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class DepositBO
    {
        public System.Data.DataSet Save(string[] data, Entity.User user)
        {
            return new DepositDAO().Save(data, user);
        }

        public System.Data.DataSet Delete(string[] data, Entity.User user)
        {
            return new DepositDAO().Delete(data, user);
        }

        public System.Data.DataSet Search(string[] data, Entity.User user)
        {
            return new DepositDAO().Search(data, user);
        }

        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new DepositDAO().Help(data, user);
        }
    }
}
