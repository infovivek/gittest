﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
    public class PettyCashReportBO
    {
        public System.Data.DataSet HelpResult(string[] data, Entity.User user)
        {
            return new PettyCashReportDAO().Help(data, user);
        }
    }
}