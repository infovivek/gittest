using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
   public class ClientMgntAddNewClientBO
    {
       public DataSet Save(String CltmgntRowId, Int32 CltmgntID, string Dtlval, User user)
       {
           return new ClientMgntAddNewClientDAO().Save(CltmgntRowId,CltmgntID, Dtlval, user);
       } 
    }
}
