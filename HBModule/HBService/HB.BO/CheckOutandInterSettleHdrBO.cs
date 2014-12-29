using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutandInterSettleHdrBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new CheckOutandInterSettleHdrDao().Save(Hdrval, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new CheckOutandInterSettleHdrDao().HelpResult(data, user);
        }
    }
}
