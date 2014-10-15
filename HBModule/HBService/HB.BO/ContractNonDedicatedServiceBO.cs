using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;
namespace HB.BO
{
    public class ContractNonDedicatedServiceBO
    {
        public DataSet Save(string NonDedicatedContractServicesDtls, User user, int NonDedicatedContractId)
        {
            return new ContractNonDedicatedServiceDAO().Save(NonDedicatedContractServicesDtls, user, NonDedicatedContractId);
        }
     }
}
