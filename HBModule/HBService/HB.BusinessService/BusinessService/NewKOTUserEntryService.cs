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
    public class NewKOTUserEntryService:IBusinessService
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
                ds = new NewKOTUserEntryHdrBo().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 NewKOTEntryHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string NewKOTEntryHdrRowId = ds.Tables[0].Rows[0][1].ToString();
                    string NewKOTEntryHdr = data[2].ToString();
                    DataSet ds1 = new NewKOTUserEntryDtlBo().Save(NewKOTEntryHdr, user, NewKOTEntryHdrId);
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
                ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }

            return ds;
        }

        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new NewKOTUserEntryHdrBo().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
            //return new KOTEntryHdrBO().Delete(data, user);
        }

        public DataSet Search(string[] data, User user)
        {
            return new NewKOTUserEntryHdrBo().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new NewKOTUserEntryHdrBo().HelpResult(data, user);
        }
    }
}
