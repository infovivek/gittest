using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.BO;
using System.Configuration;
using System.Xml;
using HB.Dao;


namespace HB.BusinessService.BusinessService
{
    public class TACInvoiceService : IBusinessService
    {

        public DataSet Save(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Delete(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, User user)
        {
            return new TACInvoiceBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new TACInvoiceBO().Help(data, user);
            return ds1;
        }
    }
}
