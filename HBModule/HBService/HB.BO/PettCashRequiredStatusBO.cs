using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;
namespace HB.BO
{
    public class PettCashRequiredStatusBO
    {
        public DataSet HelpResult(string[] data, User user)
        {
            return new PettyCashRequiredStatusDAO().Help(data, user);
        }
    }
}
