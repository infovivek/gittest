using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class ContractClientPreferDtlBo
    {
        public DataSet Save(string ContractClientPrefDtls, User user, int ContractClientprefHdrId)
        {
            return new ContractClientPreferDtlDAO().Save(ContractClientPrefDtls, user ,ContractClientprefHdrId);
        }
    }
}
