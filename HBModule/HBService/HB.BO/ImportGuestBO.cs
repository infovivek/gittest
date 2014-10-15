using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
    public class ImportGuestBO
    {
        public DataSet Save(string[] data, User user)
        {
            return new ImportGuestDAO().Save(data, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new ImportGuestDAO().Search(data, user);
        }
        //public DataSet Help(string[] data, User user)
        //{
        //    return new ImportGuestDAO().Help(data, user);
        //}


        public DataSet HelpResult(string[] data, User user)
        {
            return new ImportGuestDAO().HelpResult(data, user);
        }
    }
}
