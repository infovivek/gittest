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
    public class VendorRequestService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval = (data[1].ToString());
                 ds = new VendorRequestBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else //if (ds.Tables[0].Rows[0][3].ToString() != "Property")
                {
                    Int32 VendorRequestHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string VendorRequestHdrRowId = ds.Tables[0].Rows[0][1].ToString();
                    Int32 TempSave = Convert.ToInt32(ds.Tables[0].Rows[0][2].ToString());
                    string VendorRequestHdr = data[2].ToString();
                    DataSet ds1 = new VendorRequestDtlBO().Save(VendorRequestHdr, user, VendorRequestHdrId, TempSave);
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
            return new VendorRequestBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new VendorRequestBO().HelpResult(data, user);
        }
    }
}
