using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class ContractClientPreferHdrBo
    {
        public DataSet Save(string data, User user)
        {
            return new ContractClientPreferHdrDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ContractClientPreferHdrDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new ContractClientPreferHdrDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ContractClientPreferHdrDAO().Help(data, user);
        }
    }
}
