using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ReassignClientDtlBo
    {
        public DataSet Save(string[] Data, User user, int ReassignClientId)
        {
            return new ReassignClientDtlDAO().Save(Data, user, ReassignClientId);
        }
    }
}
