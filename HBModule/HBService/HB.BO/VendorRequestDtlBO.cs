using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class VendorRequestDtlBO
    {
        public DataSet Save(string VendorRequestHdr, User User, int VendorRequestHdrId, string TempSave)
        {
            return new VendorRequestDtlDAO().Save(VendorRequestHdr, User, VendorRequestHdrId, TempSave);
        }
    }
}
