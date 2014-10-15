using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class NewKOTUserEntryDtlBo
    {
        public DataSet Save(string KOTEntryHdr, User User, int NewKOTEntryHdrId)
        {
            return new NewKOTUserEntryDtlDAO().Save(KOTEntryHdr, User, NewKOTEntryHdrId);
        }
    }
}
