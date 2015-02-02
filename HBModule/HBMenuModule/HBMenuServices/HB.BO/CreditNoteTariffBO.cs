using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CreditNoteTariffBO
    {
        public System.Data.DataSet Save(string[] data, Entity.User user)
        {
            return new CreditNoteTariffDAO().Save(data, user);
        }
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new CreditNoteTariffDAO().Help(data, user);
        }
    }
}
