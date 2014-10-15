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
    public class PCExpenseApprovalService :IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
               // string Hdrval = (data[1].ToString());
                ds = new PCExpenseApprovalBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    if (ds.Tables[0].Rows[0][0].ToString() == "Requestor and Approver cannot be same")
                    {
                        dTable.Rows.Add("Requestor and Approver cannot be same");
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString() == "Need Operations Manager Approval")
                    {
                        dTable.Rows.Add("Need Operations Manager Approval");
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString() == "Need Operations Head Approval")
                    {
                        dTable.Rows.Add("Need Operations Head Approval");
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString() == "Need Finance Manager Approval")
                    {
                        dTable.Rows.Add("Need Finance Manager Approval");
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString() == "Need Resident Manager Approval")
                    {
                        dTable.Rows.Add("Need Resident Manager Approval");
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
            return new PCExpenseApprovalBO().HelpResult(data, user);
        }

    }
}
