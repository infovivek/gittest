using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;

namespace HB.Dao
{
    public class KOTEntryDtlsDao
    {
        String UserData;
        public DataSet Save(string KOTEntryHdr, User Usr, int KOTEntryHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            KOTEntryDtls KOTentry = new KOTEntryDtls();
            document.LoadXml(KOTEntryHdr);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                KOTentry.BookingCode = document.SelectNodes("//GridXml")[i].Attributes["BookingCode"].Value;

                KOTentry.GuestName = document.SelectNodes("//GridXml")[i].Attributes["GuestName"].Value;
                KOTentry.RoomNo = document.SelectNodes("//GridXml")[i].Attributes["RoomNo"].Value;
                if (document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value == "")
                {
                    KOTentry.PropertyId = 0;
                }
                else
                {
                    KOTentry.PropertyId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["BookingId"].Value == "")
                {
                    KOTentry.BookingId = 0;
                }
                else
                {
                    KOTentry.BookingId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BookingId"].Value);
                }
                //if (document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value == "")
                //{
                //    KOTentry.RoomId = 0;
                //}
                //else
                //{
                //    KOTentry.RoomId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value);
                //}
                if (document.SelectNodes("//GridXml")[i].Attributes["BreakfastVeg"].Value == "")
                {
                    KOTentry.BreakfastVeg = 0;
                }
                else
                {
                    KOTentry.BreakfastVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BreakfastVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["BreakfastNonVeg"].Value == "")
                {
                    KOTentry.BreakfastNonVeg = 0;
                }
                else
                {
                    KOTentry.BreakfastNonVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BreakfastNonVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["LunchVeg"].Value == "")
                {
                    KOTentry.LunchVeg = 0;
                }
                else
                {
                    KOTentry.LunchVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["LunchVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["LunchNonVeg"].Value == "")
                {
                    KOTentry.LunchNonVeg = 0;
                }
                else
                {
                    KOTentry.LunchNonVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["LunchNonVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["DinnerVeg"].Value == "")
                {
                    KOTentry.DinnerVeg = 0;
                }
                else
                {
                    KOTentry.DinnerVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["DinnerVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["DinnerNonVeg"].Value == "")
                {
                    KOTentry.DinnerNonVeg = 0;
                }
                else
                {
                    KOTentry.DinnerNonVeg = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["DinnerNonVeg"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                {
                    KOTentry.Id = 0;
                }
                else
                {
                    KOTentry.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["CheckInId"].Value == "")
                {
                    KOTentry.CheckInId = 0;
                }
                else
                {
                    KOTentry.CheckInId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["CheckInId"].Value);
                }
                command = new SqlCommand();
                if (KOTentry.Id != 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:KOTEntryDtlsDao Update" + ", ProcName:'" + StoredProcedures.KOTEntryDtls_Update; 

                    command.CommandText = StoredProcedures.KOTEntryDtls_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = KOTentry.Id;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:KOTEntryDtlsDao Insert" + ", ProcName:'" + StoredProcedures.KOTEntryDtls_Insert; 

                    command.CommandText = StoredProcedures.KOTEntryDtls_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@KOTEntryHdrId", SqlDbType.Int).Value = KOTEntryHdrId;
                command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = KOTentry.PropertyId;
                command.Parameters.Add("@BookingId", SqlDbType.Int).Value = KOTentry.BookingId;
               // command.Parameters.Add("@RoomId", SqlDbType.Int).Value = KOTentry.RoomId;
                command.Parameters.Add("@BookingCode", SqlDbType.NVarChar).Value = KOTentry.BookingCode;
                command.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = KOTentry.GuestName;
                command.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = KOTentry.RoomNo;
                command.Parameters.Add("@BreakfastVeg", SqlDbType.Int).Value = KOTentry.BreakfastVeg;
                command.Parameters.Add("@BreakfastNonVeg", SqlDbType.Int).Value = KOTentry.BreakfastNonVeg;
                command.Parameters.Add("@LunchVeg", SqlDbType.Int).Value = KOTentry.LunchVeg;
                command.Parameters.Add("@LunchNonVeg", SqlDbType.Int).Value = KOTentry.LunchNonVeg;
                command.Parameters.Add("@DinnerVeg", SqlDbType.Int).Value = KOTentry.DinnerVeg;
                command.Parameters.Add("@DinnerNonVeg", SqlDbType.Int).Value = KOTentry.DinnerNonVeg;
                command.Parameters.Add("@CheckInId", SqlDbType.Int).Value = KOTentry.CheckInId;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = Usr.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
                {
                    ds.Tables.Add(dTable);
                    return ds;
                }


        }
    }
}
