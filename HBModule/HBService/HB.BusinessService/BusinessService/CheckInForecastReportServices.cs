﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;

namespace HB.BusinessService.BusinessService
{
    public class CheckInForecastReportServices : IBusinessService
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            ds = new CheckInForecastReportBO().Help(data, user);
            return ds;
        }
    }
}
