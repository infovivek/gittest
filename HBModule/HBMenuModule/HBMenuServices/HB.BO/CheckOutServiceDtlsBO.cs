using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutServiceDtlsBO
    {
        public DataSet Save(string CheckOutServiceDtls, User user, int CheckOutServceHdrId, int CheckOutHdrRowId)
        {
            return new CheckOutServiceDtlsDAO().Save(CheckOutServiceDtls, user, CheckOutServceHdrId, CheckOutHdrRowId);
        }


        public DataSet Save(string CheckOutServiceDtls, User user, int CheckOutServceHdrId, string CheckOutHdrRowId)
        {
            throw new NotImplementedException();
        }
    }
}
