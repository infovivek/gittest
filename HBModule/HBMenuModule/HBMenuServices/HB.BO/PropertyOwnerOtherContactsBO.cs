using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class PropertyOwnerOtherContactsBO
    {
       public DataSet Save(string OwnerOtherCont, User user, int OwnerId)
       {
           return new PropertyOwnerOtherContactsDAO().Save(OwnerOtherCont, user, OwnerId);
       }
    }
}
