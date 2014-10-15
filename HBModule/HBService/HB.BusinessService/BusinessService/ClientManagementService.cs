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
    public class ClientManagementService:IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataSet ds_Hdr = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                ds_Hdr = new ClientManagementBO().Save(data, user);
                if (ds_Hdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds_Hdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 HdrId = Convert.ToInt32(ds_Hdr.Tables[0].Rows[0][0]);
                    string RowId = ds_Hdr.Tables[0].Rows[0][1].ToString();
                    DataSet ds_Dtls1 = new ClientMgntAddNewClientBO().Save(RowId, HdrId, data[3], user);
                    if (ds_Dtls1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds_Dtls1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    else
                    {
                        DataSet ds_Dtls2 = new ClientMgntClientguestBO().Save(RowId, HdrId, data[4], user);
                        if (ds_Dtls2.Tables["DBERRORTBL"].Rows.Count > 0)
                        {
                            dTable.Rows.Add(ds_Dtls2.Tables["DBERRORTBL"].Rows[0][0].ToString());
                        }
                        else
                        {
                            DataSet ds_Dtls3 = new ClientMgntCustomFieldsBO().Save(RowId, HdrId, data[5], user);
                            if (ds_Dtls3.Tables["DBERRORTBL"].Rows.Count > 0)
                            {
                                dTable.Rows.Add(ds_Dtls3.Tables["DBERRORTBL"].Rows[0][0].ToString());
                            }
                        }
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
                ds_Hdr.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }
            return ds_Hdr;
        }

        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new ClientManagementBO().Delete(data, user);            
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new ClientManagementBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new ClientManagementBO().Help(data, user);
        }
    }
}
