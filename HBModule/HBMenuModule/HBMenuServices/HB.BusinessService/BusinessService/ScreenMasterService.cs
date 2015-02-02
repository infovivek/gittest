using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Configuration;
using HB.BO;
using HB.Dao;
using HB.BusinessService.BusinessService;

namespace HB.BusinessService.BusinessService
{
   public class ScreenMasterService:IBusinessService 
    {
        DataSet ds = new DataSet();
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                DataSet ds1 = new ScreenMasterBO().Save(data, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
            }
            catch (Exception Ex)
            {
                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog(Ex.Message + "Service");
                dTable.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            finally
            {
                ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }
            return ds;
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new ScreenMasterBO().HelpResult(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new ScreenMasterBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            return new ScreenMasterBO().Search(data, user);
        }

    }
}
