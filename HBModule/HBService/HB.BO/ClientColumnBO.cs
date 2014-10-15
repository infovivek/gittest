using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ClientColumnBO
    {
        //public DataSet Save(string Hdrval, User user)
        //{
        //    return new ClientColumnDAO().Save(Hdrval, user);
        //}
        public DataSet Help(string[] data, User user)
        {
            return new ClientColumnDAO().Help(data, user);
        }

        public DataSet Save(string[] data, User user)
        {
            return new ClientColumnDAO().Save(data, user);
        }
    }
}
