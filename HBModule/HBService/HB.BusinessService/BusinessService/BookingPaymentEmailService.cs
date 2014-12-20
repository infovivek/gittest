using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using HB.Dao;
using System.Xml;

namespace HB.BusinessService.BusinessService
{
    public class BookingPaymentEmailService:IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                SqlCommand command = new SqlCommand();
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(data[1].ToString());
                int n = (doc).SelectNodes("//GridXml").Count;
                for (int i = 0; i < n; i++)
                {
                    int BookingId = Convert.ToInt32(doc.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                    string Code = doc.SelectNodes("//GridXml")[i].Attributes["PaymentCode"].Value;
                    string Remarks = doc.SelectNodes("//GridXml")[i].Attributes["Remarks"].Value;
                    command = new SqlCommand();
                    command.CommandText = StoredProcedures.BookingConfirmation_Help;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookingCodeGeneration";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Remarks;
                    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = BookingId;
                    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = user.Id;
                    DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, "");
                    if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add("Code : " + Code + ", " + ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    ds = new BookingRoomMailDAO().Mail(BookingId, user);
                    if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add("Code : " + Code + ", " + ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    if (ds.Tables["Table12"].Rows[0][0].ToString() == "")
                    {
                        DataSet ds2 = new SMSDAO().FnSMS(BookingId, user);
                    }
                    if (ds.Tables["Table12"].Rows[0][0].ToString() != "")
                    {
                        command = new SqlCommand();
                        command.CommandText = StoredProcedures.BookingConfirmation_Help;
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookingCodeDeactivated";
                        command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                        command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                        command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = BookingId;
                        command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                        DataSet ds3 = new WrbErpConnection().ExecuteDataSet(command, "");
                        dTable.Rows.Add("Code : " + Code + ", " + ds.Tables["Table12"].Rows[0][0].ToString());
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
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds_Help = new DataSet();
            if (data[1].ToString() == "PaymentEmail")
            {
                ds_Help = new BookingPaymentEmailDAO().FnBookingPaymentEmail(data, user);
            }            
            else
            {
                SqlCommand command = new SqlCommand();
                command.CommandText = StoredProcedures.BookingConfirmation_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[5].ToString());
                ds_Help = new WrbErpConnection().ExecuteDataSet(command, "");
            }
            return ds_Help;
        }
    }
}
