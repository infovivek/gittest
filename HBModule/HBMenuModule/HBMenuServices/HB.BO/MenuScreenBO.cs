using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class MenuScreenBO
    {
        public DataSet Help(string[] data, User user)
        {
            return new MenuScreenDAO().HelpResult(data, user);
        }
    }

}
