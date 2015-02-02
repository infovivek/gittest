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
    public class ForgotService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval;
                Hdrval = data[1].ToString();
                DataSet dsHdr = new ForgotBo().Save(data, user);

                if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    if (dsHdr.Tables[0].Rows[0][0].ToString() == "ALREADY EXISTS")
                    {
                        dTable.Rows.Add("Email Already Exists");
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
                ds.Tables.Add(dTable);
                dTable.Dispose();
                dTable = null;
            }
            return ds;
        }
        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ForgotBo().Delete(data, user);
            if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            {
                dTable.Rows.Add("No Data for Deleteing This Category");
            }
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                 ds= new ForgotBo().Search(data, user);
                 if (ds.Tables[0].Rows[0][0].ToString() == "EmailId Is Incorrect")
                {
                    dTable.Rows.Add("Email Id Is Incorrect");
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
                //ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }
           // ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ForgotBo().Help(data, user);
            return ds1;
        } 
    }
}
