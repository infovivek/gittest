using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class IntermediateCheckoutServiceDtlsBO
    {
        public DataSet Save(string CheckOutServiceDtls, User user, int CheckOutServceHdrId)
        {
            return new IntermediateCheckoutServiceDtlsDAO().Save(CheckOutServiceDtls, user, CheckOutServceHdrId);
        }
    }
}
