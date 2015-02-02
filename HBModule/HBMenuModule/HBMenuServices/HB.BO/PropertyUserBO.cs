using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public  class PropertyUserBO
    {
       public DataSet Save(String PropertyRowId, Int32 PropertyId, string PrtyUser, User user)
       {
           return new PropertyUserDAO().Save(PropertyRowId, PropertyId, PrtyUser, user);
       }
    }
}
