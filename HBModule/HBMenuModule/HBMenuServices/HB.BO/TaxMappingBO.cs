using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class TaxMappingBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new TaxMappingDAO().Save(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new TaxMappingDAO().Help(data, user);
        } 
    }
}
