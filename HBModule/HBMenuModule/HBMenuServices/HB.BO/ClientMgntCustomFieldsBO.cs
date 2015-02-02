using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class ClientMgntCustomFieldsBO
    {
       public DataSet Save(String CltmgntRowId, Int32 CltmgntID, string Dtlval, User user)
       {
           return new ClientMgntCustomFieldsDAO().Save(CltmgntRowId,CltmgntID, Dtlval, user);
       }
    }
}
