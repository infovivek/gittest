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
    public class OutsourceKOTService : IBusinessService
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
                ds = new OutsourceKOTHdrBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 OutsourceKOTHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string OutsourceKOTHdrRowId = ds.Tables[0].Rows[0][1].ToString();
                    string OutsourceKOTHdr = data[2].ToString();
                    DataSet ds1 = new OutsourceKOTDtlBO().Save(OutsourceKOTHdr, user, OutsourceKOTHdrId);
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
            DataSet ds1 = new NewKOTEntryHdrBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
            //return new KOTEntryHdrBO().Delete(data, user);
        }

        public DataSet Search(string[] data, User user)
        {
            return new OutsourceKOTHdrBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new OutsourceKOTHdrBO().HelpResult(data, user);
        }
    }
}
