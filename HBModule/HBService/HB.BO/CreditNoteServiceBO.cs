using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CreditNoteServiceBO
    {
        public System.Data.DataSet Save(string[] data, Entity.User user)
        {
            return new CreditNoteServiceDAO().Save(data, user);
        }
        public System.Data.DataSet Help(string[] data, Entity.User user)
        {
            return new CreditNoteServiceDAO().Help(data, user);
        }
    }
}
