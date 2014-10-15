using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class TIAandATIABO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new TIAandATIADAO().Save(data, user);
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            return new TIAandATIADAO().Search(data, user);
        }
        public DataSet Delete(string[] data, Entity.User user)
        {
            return new TIAandATIADAO().Delete(data, user);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            return new TIAandATIADAO().Help(data, user);
        }
    }
}
