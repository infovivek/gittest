using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class TravelDeskBo
    {
        public DataSet Save(string[] Hdrval, User user)
        {
            return new TravelDeskDao().Save(Hdrval, user);
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            return new TravelDeskDao().Delete(Hdrval, user);
        }
        public DataSet Search(string[] Hdrval, User user)
        {
            return new TravelDeskDao().Search(Hdrval, user);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new TravelDeskDao().HelpResult(Hdrval, user);
        }
    }
}
