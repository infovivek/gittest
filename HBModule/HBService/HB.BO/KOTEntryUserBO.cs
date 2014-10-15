using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class KOTEntryUserBO
    {
        public DataSet Save(string KOTEntryHdrUser, User user, int KOTEntryHdrId)
        {
            return new KOTEntryUserDAO().Save(KOTEntryHdrUser, user, KOTEntryHdrId);
        }
    }
}
