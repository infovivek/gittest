using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class MarkUpBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new MarkUpDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new MarkUpDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new MarkUpDAO().Delete(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new MarkUpDAO().HelpResult(data, user);
        }
    }
}
