using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using HB.Entity;

namespace HB.Dao
{
    public class SMSDAO
    {
        public DataSet FnSMS(int BookingId,User Usr)
        {
            string UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
             "', SctId:" + Usr.SctId + ", Service : SMSDAO : Help, " + 
             ", ProcName:'" + StoredProcedures.BookingDtls_Help; 
            SqlCommand command = new SqlCommand();
            DataSet ds = new DataSet();
            command.CommandText = StoredProcedures.BookingDtls_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookingConfirmedSMS";
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            try
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        WebRequest request = HttpWebRequest.Create(ds.Tables[0].Rows[i][0].ToString());
                        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                        Stream s = (Stream)response.GetResponseStream();
                        StreamReader readStream = new StreamReader(s);
                        string dataString = readStream.ReadToEnd();
                        response.Close();
                        s.Close();
                        readStream.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Booking Confirmation SMS --> BookingId --> " + BookingId);
            }
            return ds;
        }
    }
}
