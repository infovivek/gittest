using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class ClientGradeCityDetailsBO
    {
        public DataSet Save(int HdrId,string data, User user)
        {
            return new ClientGradeCityDetailsDAO().Save(HdrId, data, user);
        }
       
    }
}
