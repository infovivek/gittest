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
    public class CheckoutAndIntermediateService:IBusinessService
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
                ds = new GuestCheckOutBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
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
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, User user)
        {
            return new GuestCheckOutBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new GuestCheckOutBO().HelpResult(data, user);

        }
    }
}
