using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutandInterSettleDtlBO
    {
        public DataSet Save(string CheckOutSettleDtls, User user, int CheckOutSettleHdrId)
        {
            return new CheckOutandInterSettleDtlDao().Save(CheckOutSettleDtls, user, CheckOutSettleHdrId);
        }
    }
}
