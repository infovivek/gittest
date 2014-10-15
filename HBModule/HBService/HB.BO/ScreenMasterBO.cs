using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
   public class ScreenMasterBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new ScreenMasterDao().Save(data, User);
        }
        public DataSet Search(string[] data, User User)
        {
            return new ScreenMasterDao().Search(data, User);
        }
        public DataSet Delete(string[] data, User User)
        {
            return new ScreenMasterDao().Delete(data, User);
        }
        public DataSet HelpResult(string[] data, User User)
        {
            return new ScreenMasterDao().HelpResult(data, User);
        }
    }
}
