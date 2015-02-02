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
    public class PettyCashHdrService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval = (data[1].ToString());
                ds = new PettyCashHdrBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (ds.Tables[0].Rows[0][0].ToString() == "PC Can be requested after submitting the Expense Report for the Previous Request.")
                {
                    dTable.Rows.Add("PC Can be requested after submitting the Expense Report for the Previous Request.");
                }
                else
                {
                    Int32  PettyCashHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string PettyCashHdrRowId = ds.Tables[0].Rows[0][1].ToString();
                    string PettyCashHdr = data[2].ToString();
                    DataSet ds1 = new PettyCashBO().Save(PettyCashHdr, user, PettyCashHdrId);
                    if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
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
            throw new NotImplementedException();
        }
        public DataSet Search(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new PettyCashHdrBO().HelpResult(data, user);
        }
    }
}
