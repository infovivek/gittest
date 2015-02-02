using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutServiceHdrBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new CheckOutServiceHdrDAO().Save(Hdrval, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new CheckOutServiceHdrDAO().HelpResult(data, user);
        }      
    }
}
