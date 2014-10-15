using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ContractProductMasterBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new ContractProductMasterDAO().Save(Hdrval, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ContractProductMasterDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new ContractProductMasterDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ContractProductMasterDAO().Help(data, user);
        }
    }
}
