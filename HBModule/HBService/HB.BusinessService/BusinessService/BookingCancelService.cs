using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;
using System.Xml;
namespace HB.BusinessService.BusinessService
{
    public class BookingCancelService : IBusinessService
    {

        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                int BookingId=Convert.ToInt32(data[2].ToString());
                ds = new BookingCancelBO().Save(data[1].ToString(), user, BookingId, data[3].ToString(), data[4].ToString());
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (ds.Tables["ERRORTBLDAO"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["ERRORTBLDAO"].Rows[0][0].ToString());
                }
                if (ds.Tables["Exists"].Rows.Count > 0)
                {
                    string Guest="";
                    for (int i = 0; i < ds.Tables["Exists"].Rows.Count; i++)
                    {
                        if(i==0)
                        Guest=ds.Tables["Exists"].Rows[0][0].ToString();
                        else
                        Guest=","+ds.Tables["Exists"].Rows[0][0].ToString();
                    }
                    if (ds.Tables["Exists"].Rows.Count > 1)
                    {
                        dTable.Rows.Add(" Room is Not Available for the Following Guests, \n -" + Guest);
                    }
                    else
                    {
                        dTable.Rows.Add(" Room is Not Available for the Following Guest, \n -" + Guest);
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

            DataSet ds1 = new BookingCancelBO().Delete(data, user);
            if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            {
                dTable.Rows.Add("No Data for Deleteing This Category");
            }
            if (ds1.Tables["ERRORTBLDAO"].Rows.Count > 0)
            {
                dTable.Rows.Add(ds.Tables["ERRORTBLDAO"].Rows[0][0].ToString());
            }
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new BookingCancelBO().Help(data, user);
        }
    }
}
