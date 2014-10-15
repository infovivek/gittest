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
    public class ContractProductMasterService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval = (data[1].ToString());
                DataSet ds1 = new ContractProductMasterBO().Save(Hdrval, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (ds1.Tables[0].Rows[0][0].ToString() == "Product Already Exists")
                {
                    dTable.Rows.Add("Product Already Exists");
                }
                //if (ds1.Tables[0].Rows[0][0].ToString() == "TypeService Already Exists")
                //{
                //    dTable.Rows.Add("TypeService Already Exists.");
                //}
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
            DataSet ds1 = new ContractProductMasterBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new ContractProductMasterBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ContractProductMasterBO().Help(data, user);
            return ds1;
        }
    }
}
