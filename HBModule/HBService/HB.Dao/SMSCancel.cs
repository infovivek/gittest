﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Net;
using System.IO;

namespace HB.Dao
{
    public class SMSCancel
    {
        string Content;
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        public DataSet FnSMSGuestCancel(int BookingId, int Id, User Usr)
        {
            try
            {
                string UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                 "', SctId:" + Usr.SctId + ", Service : SMSCancel : BookingCancelSMS, " +
                 ", ProcName:'" + StoredProcedures.BookingDtls_Help;
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.BookingDtls_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookingGuestCancelSMS";
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = Id;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                //if (ds.Tables[0].Rows.Count == 100)
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        Content = ds.Tables[0].Rows[i][0].ToString();
                        WebRequest request = HttpWebRequest.Create(ds.Tables[0].Rows[i][0].ToString());
                        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                        Stream s = (Stream)response.GetResponseStream();
                        StreamReader readStream = new StreamReader(s);
                        string dataString = readStream.ReadToEnd();
                        response.Close();
                        s.Close();
                        readStream.Close();
                        //
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(" --> Booking Guest Cancel SMS --> BookingId --> " + BookingId + ", RoomCapturedTableid --> " + Id + ", Content --> " + Content + ", Status --> " + dataString);
                    }
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(" --> Booking Guest Cancel SMS --> BookingId:" + BookingId + ", RoomCapturedTableid:" + Id + ", Err Msg:" + ex.Message);
            }
            return ds;
        }

        public DataSet FnSMSBookingCancel(int BookingId, User Usr)
        {
            try
            {
                string UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                 "', SctId:" + Usr.SctId + ", Service : SMSCancel : BookingCancelSMSMMT, " +
                 ", ProcName:'" + StoredProcedures.BookingDtls_Help;
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.BookingDtls_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookingCancelSMS";
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                //if (ds.Tables[0].Rows.Count == 100)
                if (ds.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        Content = ds.Tables[0].Rows[i][0].ToString();
                        WebRequest request = HttpWebRequest.Create(ds.Tables[0].Rows[i][0].ToString());
                        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                        Stream s = (Stream)response.GetResponseStream();
                        StreamReader readStream = new StreamReader(s);
                        string dataString = readStream.ReadToEnd();
                        response.Close();
                        s.Close();
                        readStream.Close();
                        //
                        CreateLogFiles log = new CreateLogFiles();
                        log.SMSLog(" --> Booking Cancel SMS --> BookingId --> " + BookingId + ", Content --> " + Content + ", Status --> " + dataString);
                    }
                }
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.SMSLog(" --> Booking Cancel SMS --> BookingId:" + BookingId + ", Err Msg:" + ex.Message);
            }
            return ds;
        }
    }
}
