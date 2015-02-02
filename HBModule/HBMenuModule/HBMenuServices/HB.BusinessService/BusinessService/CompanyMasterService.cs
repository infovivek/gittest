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
    public class CompanyMasterService : IBusinessService
    {

        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                DataSet ds1 = new CompanyMasterBO().Save(data, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
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
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new CompanyMasterBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new CompanyMasterBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new CompanyMasterBO().HelpResult(data, user);
        }
    }
}
