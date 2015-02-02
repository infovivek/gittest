using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class SlabTaxBO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            return new SlabTaxDAO().Save(data, user);
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            return new SlabTaxDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new SlabTaxDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new SlabTaxDAO().Help(data, user);
        } 

    }
}
