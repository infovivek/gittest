using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class VendorChequeApprovalDtlBO
    {
        public DataSet Save(string PettyCashApprovalHdr, User user, int PettyCashApprovalHdrId)
        {
            return new VendorChequeApprovalDtlDAO().Save(PettyCashApprovalHdr, user, PettyCashApprovalHdrId);
        }
    }
}
