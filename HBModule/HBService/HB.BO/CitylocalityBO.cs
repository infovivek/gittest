using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CitylocalityBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new CitylocalityDao().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new CitylocalityDao().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new CitylocalityDao().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new CitylocalityDao().Help(data, user);
        } 
    }
}
