using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
   public class ContractManagementBO
    {
        public DataSet Save(string data, User user)
        {
            return new ContractManagementDao().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ContractManagementDao().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new ContractManagementDao().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ContractManagementDao().Help(data, user);
        } 
    }
}
