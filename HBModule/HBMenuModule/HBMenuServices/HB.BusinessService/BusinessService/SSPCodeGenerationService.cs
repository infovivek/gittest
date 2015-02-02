using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;

namespace HB.BusinessService.BusinessService
{
  public  class SSPCodeGenerationService:IBusinessService     
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval;
                Hdrval = data[1].ToString();
                DataSet dsHdr = new SSPCodeGenerationBO().Save(Hdrval, user);
                if (dsHdr.Tables[0].Rows[0][0].ToString() == "SSPName Already Exists")
                {
                    dTable.Rows.Add("SSPName Already Exists");
                }
                else if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }                
                else
                {
                    Int32 HdrId = Convert.ToInt32(dsHdr.Tables[0].Rows[0][0]);
                    string RowId = dsHdr.Tables[0].Rows[0][1].ToString();
                    DataSet ds_Dtls = new SSPCodeGenerationServiceBO().Save(data[2], user, HdrId);
                    if (ds_Dtls.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds_Dtls.Tables["DBERRORTBL"].Rows[0][0].ToString());
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

        public DataSet Delete(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new SSPCodeGenerationBO().Delete(data, user);
            //if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            //{
            //    dTable.Rows.Add("No Data for Deleteing This Category");
            //}
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new SSPCodeGenerationBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new SSPCodeGenerationBO().Help(data, user);
        }
    }
}
