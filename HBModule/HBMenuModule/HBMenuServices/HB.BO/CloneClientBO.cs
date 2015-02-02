using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CloneClientBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new CloneClientDAO().Save(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new CloneClientDAO().HelpResult(data, user);
        }
    }
}
