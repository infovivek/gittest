using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PropertyReportBO
    {
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new PropertyReportDAO().Help(data, user);
        }

        public DataSet Search(string[] data, User user)
        {
            return new PropertyReportDAO().Search(data, user);
        }
    }
}
