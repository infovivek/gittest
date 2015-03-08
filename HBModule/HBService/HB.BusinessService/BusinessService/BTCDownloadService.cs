using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using HB.BO;
using HB.BusinessService;



namespace HB.BusinessService.BusinessService
{
    public class BTCDownloadService:IBusinessService
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
            ds = new BTCDownloadBO().Help(data, user);
            return ds;
        }
    }
}
