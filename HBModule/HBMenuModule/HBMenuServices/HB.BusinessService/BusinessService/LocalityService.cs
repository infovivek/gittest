using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.BO;
using System.Configuration;
using HB.Dao;

namespace HB.BusinessService.BusinessService
{
    public class LocalityService : IBusinessService
    {
        public DataSet Save(string[] data, User user = default(User))
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                ds = new LocalityBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "Locality Already Exists.")
                    {
                        dTable.Rows.Add(ds.Tables[0].Rows[0][0].ToString());
                    }
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

        public DataSet Delete(string[] data, User user = default(User))
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new LocalityBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds; 
        }

        public DataSet Search(string[] data, User user = default(User))
        {
            return new LocalityBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user )
        {
            return new LocalityBO().Help(data, user);
        }
    }
}
