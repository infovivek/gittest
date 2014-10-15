using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ReassignPropertyDtlBO
    {
        public DataSet Save(string[] Data, User user, int ReassignPropertyId)
        {
            return new ReassignPropertyDtlDAO().Save(Data, user, ReassignPropertyId);
        }
    }
}
