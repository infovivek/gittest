using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class OutsourceKOTDtlBO
    {
        public DataSet Save(string KOTEntryHdr, User User, int NewKOTEntryHdrId)
        {
            return new OutsourceKOTDtlDAO().Save(KOTEntryHdr, User, NewKOTEntryHdrId);
        }
    }
}
