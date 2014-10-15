using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
    public class UserRolesBO
    {
        public DataSet Save(int RolesId, string Dtlval, User user)
        {
            return new UserRolesDao().Save(RolesId,Dtlval, user);
        }
    }
}
