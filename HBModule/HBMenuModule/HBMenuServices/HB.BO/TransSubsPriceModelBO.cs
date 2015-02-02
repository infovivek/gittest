using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class TransSubsPriceModelBO
    {
        public DataSet Save(string[] Hdrval, User user)
        {
            return new TransSubsPriceModelDAO().Save(Hdrval, user);
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            return new TransSubsPriceModelDAO().Delete(Hdrval, user);
        }
        public DataSet Search(string[] Hdrval, User user)
        {
            return new TransSubsPriceModelDAO().Search(Hdrval, user);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new TransSubsPriceModelDAO().Help(Hdrval, user);
        }
    }
}
