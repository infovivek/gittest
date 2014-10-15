using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class PropertyBlockBO
    {
       public DataSet Save(String PropertyRowId, Int32 PropertyId, string PrtyBlock, User user)
       {
           return new PropertyBlockDAO().Save(PropertyRowId, PropertyId, PrtyBlock, user);
       }

    }
}
