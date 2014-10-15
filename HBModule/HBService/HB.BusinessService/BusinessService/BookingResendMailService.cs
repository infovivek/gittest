using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.BusinessService;
using HB.BO;
using HB.Entity;
using System.Xml;

namespace HB.BusinessService.BusinessService
{
    public class BookingResendMailService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                DataSet ds1 = new DataSet();
                int BookingId = Convert.ToInt32(data[2]);
                if (data[1].ToString() == "Room")
                {
                    ds1 = new BookingRoomResendMailDAO().Mail(BookingId, data[3], data[4]);
                    if (ds1.Tables["Table12"].Rows[0][0].ToString() != "")
                    {
                        dTable.Rows.Add(ds1.Tables["Table12"].Rows[0][0].ToString());
                    }
                }
                if (data[1].ToString() == "Apartment")
                {
                    ds1 = new ApartmentBookingResendMailDAO().Mail(BookingId, data[3], data[4]);
                    if (ds1.Tables["Table11"].Rows[0][0].ToString() != "")
                    {
                        dTable.Rows.Add(ds1.Tables["Table11"].Rows[0][0].ToString());
                    }
                }
                if (data[1].ToString() == "Bed")
                {
                    ds1 = new BedBookingesendMailDAO().Mail(BookingId, data[3], data[4]);
                    if (ds1.Tables["Table11"].Rows[0][0].ToString() != "")
                    {
                        dTable.Rows.Add(ds1.Tables["Table11"].Rows[0][0].ToString());
                    }
                }
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
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
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new BookingMailResendBO().Help(data, user);
        }
    }
}
