using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;
namespace HB.BO
{
  public  class ContractManagementTariffAppartmentBO
    {
        public DataSet Save(string data, User user, int ContractId)
        {
            return new ContractManagementTariffAppartmentDao().Save(data, user, ContractId);
        }
    }
}
