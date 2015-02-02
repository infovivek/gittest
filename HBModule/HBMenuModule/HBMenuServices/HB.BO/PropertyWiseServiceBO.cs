using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PropertyWiseServiceBO
    {
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new PropertyWiseServiceDAO().Help(data, user);
        }
    }
}
