using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class KOTEntryDtlsBO
    {
        public DataSet Save(string KOTEntryHdr, User user, int KOTEntryHdrId)
        {
            return new KOTEntryDtlsDao().Save(KOTEntryHdr, user, KOTEntryHdrId);
        }
    }
}
