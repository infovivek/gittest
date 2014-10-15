using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class PettyCashBO
    {
        public DataSet Save(string PettyCashHdr, User user, int PettyCashHdrId)
        {
            return new PettyCashDAO().Save(PettyCashHdr, user, PettyCashHdrId);
        }
       
    }
}
