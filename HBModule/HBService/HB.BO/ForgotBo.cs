using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using System.Data;
using HB.Entity;
namespace HB.BO
{
    public class ForgotBo
    {
        public DataSet Save(string[] data, User user)
        {
            return new ForgotDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ForgotDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new ForgotDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ForgotDAO().Help(data, user);
        } 
    }
}
