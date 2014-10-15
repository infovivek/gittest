using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO 
{
   public class ContractManagementTariffBO
    {
       public DataSet Save(string data, User user, int ContractId)
       {
           return new ContractManagementTariffDao().Save(data, user, ContractId);
       }
    }
}
