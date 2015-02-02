using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class NewKOTEntryHdrBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new NewKOTEntryHdrDAO().Save(data, User);
        }
        public DataSet Search(string[] data, User user)
        {
            return new NewKOTEntryHdrDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new NewKOTEntryHdrDAO().Delete(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new NewKOTEntryHdrDAO().HelpResult(data, user);
        }
    }
}
