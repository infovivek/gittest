using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using HB.BO;

namespace HB.BusinessService.BusinessService
{
    public class PropertyService : IBusinessService
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
                ds = new PropertyBO().Save(Hdrval, user);

                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 PropertyId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string PropertyRowId = ds.Tables[0].Rows[0][1].ToString();
                    string PrtyUser = data[3].ToString();
                    DataSet ds1 = new PropertyUserBO().Save(PropertyRowId, PropertyId, PrtyUser, user);
                    string PrtyBlock = data[2].ToString();
                    DataSet ds2 = new PropertyBlockBO().Save(PropertyRowId, PropertyId, PrtyBlock, user);
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

            DataSet ds1 = new PropertyBO().Delete(data, user);
            //if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            //{
            //    dTable.Rows.Add("No Data for Deleteing This Category");
            //}
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new PropertyBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new PropertyBO().Help(data, user);
            return ds1;
        }
    }
}
