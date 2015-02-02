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
    public class ApprovedPettyCashService : IBusinessService
    {
       public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                //string Hdrval = (data[1].ToString());
                DataSet ds1 = new ApprovedPettyCashBO().Save(data, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (ds1.Tables[0].Rows[0][0].ToString() == "Requestor and Approver cannot be same")
                {
                    dTable.Rows.Add("Requestor and Approver cannot be same");
                }
                else if (ds1.Tables[0].Rows[0][0].ToString() == "Need Operations Manager Approval")
                {
                    dTable.Rows.Add("Need Operations Manager Approval");
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
        

        public DataSet Delete(string[] data, User user)
        {
            throw new NotImplementedException();
        }
        public DataSet Search(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
           throw new NotImplementedException();
        }
    }
}
