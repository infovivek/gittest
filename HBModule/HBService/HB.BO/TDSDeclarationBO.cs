using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class TDSDeclarationBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new TDSDeclarationDAO().Save(data, user);
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            return new TDSDeclarationDAO().Delete(data, user);
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new TDSDeclarationDAO().Search(data, user);
        }

        public DataSet Help(string[] data, Entity.User user)
        {
            return new TDSDeclarationDAO().Help(data, user);
        }
    }
}
