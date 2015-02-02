using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.BO;
using HB.Entity;
using HB.Dao;
using System.Configuration;

namespace HB.BusinessService.BusinessService
{
    public class PaxInOutService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                DataSet ds1 = new PaxInOutBO().Save(data, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    if (ds1.Tables[0].Rows[0][0].ToString() == "Invalid Process")
                    {
                        dTable.Rows.Add("Invalid Process");
                    }
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
                ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }

            return ds;
        }

        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new PaxInOutBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new PaxInOutBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new PaxInOutBO().Help(data, user);
        }
    }
}
