using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PettyCashStatusBO
    {
        public DataSet Save(string PettyCashStatusHdr, User user, int PettyCashStatusHdrId)
        {
            return new PettyCashStatusDAO().Save(PettyCashStatusHdr, user, PettyCashStatusHdrId);
        }
     }
}
