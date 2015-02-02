using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
   public class ContractNonDedicatedApartmentBO
    {
       public DataSet Save(string NonDedicatedContractApartDtls, User user, int NonDedicatedContractId)
        {
            return new ContractNonDedicatedApartmentDAO().Save(NonDedicatedContractApartDtls, user, NonDedicatedContractId);
        }
     }
}
