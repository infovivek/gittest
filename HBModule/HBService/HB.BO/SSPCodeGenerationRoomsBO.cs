using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
   public class SSPCodeGenerationRoomsBO
    {
       public DataSet Save(string SSPCodeGenerationApartment, User user, int CodegenerationId)
       {
           return new SSPCodeGenerationRoomsDAO().Save(SSPCodeGenerationApartment, user, CodegenerationId);
       }
    }
}
