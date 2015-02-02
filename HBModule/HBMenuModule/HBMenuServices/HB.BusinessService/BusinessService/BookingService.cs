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
    public class BookingService:IBusinessService
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                ds = new BookingBO().Save(data[1], user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 BookingId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                    string BookingRowId = ds.Tables[0].Rows[0][1].ToString();
                    string BookingCode = ds.Tables[0].Rows[0][2].ToString();
                    DataSet ds_Guest = new BookingGuestDetailsBO().Save(data[2], user, BookingId);
                    if (ds_Guest.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds_Guest.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    else
                    {
                        DataSet ds_Property = new BookingPropertyBO().Save(data, user, BookingId);
                        if (ds_Property.Tables["DBERRORTBL"].Rows.Count > 0)
                        {
                            dTable.Rows.Add(ds_Property.Tables["DBERRORTBL"].Rows[0][0].ToString());
                        }
                        else
                        {
                            DataSet ds_Booked = new BookingPropertyAssignedGuestBO().Save(data[4], user, BookingId);
                            if (ds_Property.Tables["DBERRORTBL"].Rows.Count > 0)
                            {
                                dTable.Rows.Add(ds_Property.Tables["DBERRORTBL"].Rows[0][0].ToString());
                            }
                        }
                    }
                    /*DataSet ds_Dtls1 = new BookingCustomFieldsDetailsBO().Save(data[2], user,HdrId);
                    if (ds_Dtls1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds_Dtls1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }*/                    
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

            DataSet ds1 = new BookingBO().Delete(data, user);
            if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            {
                dTable.Rows.Add("No Data for Deleteing This Category");
            }
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            return new BookingBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new BookingBO().Help(data, user);
        }
    }
}
