using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
    public class BTCDownloadBO
    {
         public DataSet Help(string[] data, User user)
        {
            return new BTCDownloadDAO().Help(data, user);
        }
    }
}
