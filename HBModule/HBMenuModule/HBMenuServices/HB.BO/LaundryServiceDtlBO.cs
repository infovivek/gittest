using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class LaundryServiceDtlBO
    {
        public DataSet Save(string LaundryHdr, User user, int LaundryHdrId)
        {
            return new LaundryServiceDtlDAO().Save(LaundryHdr, user, LaundryHdrId);
        }
    }
}
