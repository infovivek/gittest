using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;
using System.Xml;
namespace HB.BusinessService.BusinessService
{
   public class VendorAdvancePaymentService:IBusinessService
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                ds = new VendorAdvancePaymentBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
            }
            catch (Exception Ex)
            {
                CreateLogFilesService Err = new CreateLogFilesService();
                Err.ErrorLog(Ex.Message);
                dTable.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            finally
            {
                ds.Tables.Add(dTable);
                dTable.Dispose();
                dTable = null;
            }
            return ds;
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new VendorAdvancePaymentBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }
    }
}
