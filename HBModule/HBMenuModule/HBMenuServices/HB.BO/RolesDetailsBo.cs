using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class RolesDetailsBo
    {
       public DataSet Save(int RolesId, string Dtlval, User user)
        {
            return new RolesDetailsDao().Save(RolesId, Dtlval, user);
        }
       
    }
}
