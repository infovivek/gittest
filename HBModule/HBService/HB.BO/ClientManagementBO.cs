using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ClientManagementBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new ClientManagementDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ClientManagementDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new ClientManagementDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new ClientManagementDAO().Help(data, user);
        }
    }
}
