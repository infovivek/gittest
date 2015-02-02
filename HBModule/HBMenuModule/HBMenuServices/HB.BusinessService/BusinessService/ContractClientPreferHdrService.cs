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
    public class ContractClientPreferHdrService : IBusinessService
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
                DataSet dsHdr = new ContractClientPreferHdrBo().Save(Hdrval, user);
                if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (dsHdr.Tables[0].Rows[0][0].ToString() == "Client Name Already Exists")
                {
                    dTable.Rows.Add("Client Name Already Exists");
                }
                else
                {
                    Int32 ContractClientprefHdrId = Convert.ToInt32(dsHdr.Tables[0].Rows[0][0].ToString());
                    string ContractClientprefHdrRowId = dsHdr.Tables[0].Rows[0][1].ToString();
                    string ContractClientprefDtls = data[2].ToString();
                    DataSet ds1 = new ContractClientPreferDtlBo().Save(ContractClientprefDtls, user, ContractClientprefHdrId);
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
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ContractClientPreferHdrBo().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new ContractClientPreferHdrBo().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ContractClientPreferHdrBo().Help(data, user);
            return ds1;
        }
    }
}
