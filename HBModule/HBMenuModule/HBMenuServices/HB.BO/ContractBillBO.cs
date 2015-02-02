using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ContractBillBO
    {
        public DataSet Help(string[] data, User user)
        {
            return new ContractBillDAO().Help(data, user);
        }

        public DataSet Search(string[] data, User user)
        {
            return new ContractBillDAO().Search(data, user);
        }

        public DataSet Save(string[] data, User user)
        {
            return new ContractBillDAO().Save(data, user);
        }
    }
}
