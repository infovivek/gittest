using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PropertyBO
    {
        public DataSet Save(string data, User user)
        {
            return new PropertyDAO().Save(data, user);
        } 
        public DataSet Search(string[] data, User user)
        {
            return new PropertyDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new PropertyDAO().Delete(data, user);
        }
        public DataSet Help(string[] data,User user)
        {
            return new PropertyDAO().Help(data,user); 
        }
    }
}
