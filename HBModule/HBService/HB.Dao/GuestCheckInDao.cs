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
    public class GuestCheckInDao
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
         //   UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            GuestCheckIn ChkIn = new GuestCheckIn();
            XmlDocument doc = new XmlDocument();
            //XmlDocument doc1 = new XmlDocument();
            //XmlDocument doc2 = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
           
            //DataTable dTable = new DataTable("DBERRORTBL");
            //dTable.Columns.Add("Exception");
           //doc1.LoadXml(data[2].ToString());
           // int len;
           // len = (doc1).SelectNodes("//GridXml").Count;

            doc.LoadXml(data[1]);
            ChkIn.CheckInNo = doc.SelectSingleNode("HdrXml").Attributes["CheckInNo"].Value;
            ChkIn.Image = data[2];
            ChkIn.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            ChkIn.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            ChkIn.RefGuestId = doc.SelectSingleNode("HdrXml").Attributes["RefGuestId"].Value;
           // ChkIn.Prefix = doc.SelectSingleNode("HdrXml").Attributes["Prefix"].Value;
            ChkIn.ChkInGuest = doc.SelectSingleNode("HdrXml").Attributes["ChkInGuest"].Value;
            ChkIn.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            ChkIn.EmpCode = doc.SelectSingleNode("HdrXml").Attributes["EmpCode"].Value;
            ChkIn.MobileNo = doc.SelectSingleNode("HdrXml").Attributes["MobileNo"].Value;
            //ChkIn.Purpose = doc.SelectSingleNode("HdrXml").Attributes["Purpose"].Value;
            ChkIn.IdProof = doc.SelectSingleNode("HdrXml").Attributes["IdProof"].Value;
            ChkIn.ArrivalDate = doc.SelectSingleNode("HdrXml").Attributes["ArrivalDate"].Value;
            ChkIn.ArrivalTime = doc.SelectSingleNode("HdrXml").Attributes["ArrivalTime"].Value;
            ChkIn.ChkoutDate = doc.SelectSingleNode("HdrXml").Attributes["ChkoutDate"].Value;
            ChkIn.ClientName = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            ChkIn.EmailId = doc.SelectSingleNode("HdrXml").Attributes["EmailId"].Value;
            //ChkIn.Grade = doc.SelectSingleNode("HdrXml").Attributes["Grade"].Value;
            ChkIn.Designation = doc.SelectSingleNode("HdrXml").Attributes["Designation"].Value;
            ChkIn.Nationality = doc.SelectSingleNode("HdrXml").Attributes["Nationality"].Value;
            ChkIn.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            ChkIn.BookingCode = doc.SelectSingleNode("HdrXml").Attributes["BookingCode"].Value;
            ChkIn.Direct = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Direct"].Value);
            ChkIn.BTC = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["BTC"].Value);
            ChkIn.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
           // ChkIn.FirstName = doc.SelectSingleNode("HdrXml").Attributes["FirstName"].Value;
            ChkIn.RoomId =Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            //ChkIn.PaymentMode = doc.SelectSingleNode("HdrXml").Attributes["PaymentMode"].Value;
            //if (doc.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value == "")
            //{
            //    ChkIn.AdvanceAmount = 0;
            //}
            //else
            //{
            //    ChkIn.AdvanceAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value);
            //}
            if (doc.SelectSingleNode("HdrXml").Attributes["ChkinAdvance"].Value == "")
            {
                ChkIn.ChkinAdvance = 0;
            }
            else
            {
                ChkIn.ChkinAdvance = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ChkinAdvance"].Value);
            }
            ChkIn.RoomNo =doc.SelectSingleNode("HdrXml").Attributes["RoomNo"].Value;
            ChkIn.StateId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            ChkIn.Tariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Tariff"].Value);
            ChkIn.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            ChkIn.TimeType = doc.SelectSingleNode("HdrXml").Attributes["TimeType"].Value;
            ChkIn.Occupancy = doc.SelectSingleNode("HdrXml").Attributes["Occupancy"].Value;
            ChkIn.RackTariffSingle = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RackTariffSingle"].Value);
            ChkIn.RackTariffDouble = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RackTariffDouble"].Value);
            ChkIn.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
            ChkIn.BedId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BedId"].Value);
            ChkIn.ApartmentType = doc.SelectSingleNode("HdrXml").Attributes["ApartmentType"].Value;
            ChkIn.BedType = doc.SelectSingleNode("HdrXml").Attributes["BedType"].Value;
            ChkIn.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
            ChkIn.PropertyType = doc.SelectSingleNode("HdrXml").Attributes["PropertyType"].Value;
            ChkIn.CheckStatus = doc.SelectSingleNode("HdrXml").Attributes["CheckStatus"].Value;
            ChkIn.GuestImage = doc.SelectSingleNode("HdrXml").Attributes["GuestImage"].Value;
            ChkIn.ClientId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            ChkIn.CityId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            ChkIn.ServiceCharge = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value);
            if (doc.SelectSingleNode("HdrXml").Attributes["SingleMarkupAmount"].Value == "")
            {
                ChkIn.SingleMarkupAmount = 0;
            }
            else
            {
                ChkIn.SingleMarkupAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SingleMarkupAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["DoubleMarkupAmount"].Value == "")
            {
                ChkIn.DoubleMarkupAmount = 0;
            }
            else
            {
                ChkIn.DoubleMarkupAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["DoubleMarkupAmount"].Value);
            }
            command = new SqlCommand();
            if (ChkIn.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckInHdr_Update; 
 
                Mode = "Update";
                command.CommandText = StoredProcedures.CheckInHdr_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = ChkIn.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckInHdr_Insert; 

                Mode = "Save";
                command.CommandText = StoredProcedures.CheckInHdr_Insert;
                
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ChkInGuest", SqlDbType.NVarChar).Value = ChkIn.ChkInGuest;
            command.Parameters.Add("@CheckInNo", SqlDbType.NVarChar).Value = ChkIn.CheckInNo;
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = ChkIn.BookingId;
            command.Parameters.Add("@GuestId", SqlDbType.Int).Value = ChkIn.GuestId;
            command.Parameters.Add("@RefGuestId", SqlDbType.NVarChar).Value = ChkIn.RefGuestId;
            command.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = ChkIn.GuestName;
            command.Parameters.Add("@Image", SqlDbType.NVarChar).Value = ChkIn.Image;
           // command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = ChkIn.Name;
            command.Parameters.Add("@EmpCode", SqlDbType.NVarChar).Value = ChkIn.EmpCode;
           // command.Parameters.Add("@Prefix", SqlDbType.NVarChar).Value = ChkIn.Prefix;
            command.Parameters.Add("@MobileNo", SqlDbType.NVarChar).Value = ChkIn.MobileNo;
            command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ChkIn.Property;
            command.Parameters.Add("@IdProof", SqlDbType.NVarChar).Value = ChkIn.IdProof;
            command.Parameters.Add("@ArrivalDate", SqlDbType.NVarChar).Value = ChkIn.ArrivalDate;
            command.Parameters.Add("@ArrivalTime", SqlDbType.NVarChar).Value = ChkIn.ArrivalTime;
            command.Parameters.Add("@ChkoutDate", SqlDbType.NVarChar).Value = ChkIn.ChkoutDate;
            command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = ChkIn.Designation;
            command.Parameters.Add("@Nationality", SqlDbType.NVarChar).Value = ChkIn.Nationality;
            command.Parameters.Add("@Direct", SqlDbType.Bit).Value = ChkIn.Direct;
            command.Parameters.Add("@BTC", SqlDbType.Bit).Value = ChkIn.BTC;
            command.Parameters.Add("@EmailId", SqlDbType.NVarChar).Value = ChkIn.EmailId;
            command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ChkIn.ClientName;
            command.Parameters.Add("@BookingCode", SqlDbType.NVarChar).Value = ChkIn.BookingCode;
           // command.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkIn.PaymentMode;
            
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            // Advance Amount       
            command.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = ChkIn.RoomNo;
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = ChkIn.RoomId;
            command.Parameters.Add("@StateId", SqlDbType.Int).Value = ChkIn.StateId;
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = ChkIn.PropertyId;
            command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = ChkIn.Tariff;
            command.Parameters.Add("@ChkinAdvance", SqlDbType.Decimal).Value = ChkIn.ChkinAdvance;
            command.Parameters.Add("@TimeType", SqlDbType.NVarChar).Value = ChkIn.TimeType;
            command.Parameters.Add("@Occupancy", SqlDbType.NVarChar).Value = ChkIn.Occupancy;
            command.Parameters.Add("@RackTariffSingle", SqlDbType.Decimal).Value = ChkIn.RackTariffSingle;
            command.Parameters.Add("@RackTariffDouble", SqlDbType.Decimal).Value = ChkIn.RackTariffDouble;
            command.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = ChkIn.ApartmentId;
            command.Parameters.Add("@BedId", SqlDbType.Int).Value = ChkIn.BedId;
            command.Parameters.Add("@ApartmentType", SqlDbType.NVarChar).Value = ChkIn.ApartmentType;
            command.Parameters.Add("@BedType", SqlDbType.NVarChar).Value = ChkIn.BedType;
            command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = ChkIn.Type;
            command.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = ChkIn.PropertyType;
            command.Parameters.Add("@CheckStatus", SqlDbType.NVarChar).Value = ChkIn.CheckStatus;
            command.Parameters.Add("@GuestImage", SqlDbType.NVarChar).Value = ChkIn.GuestImage;
            command.Parameters.Add("@SingleMarkupAmount", SqlDbType.Decimal).Value = ChkIn.SingleMarkupAmount;
            command.Parameters.Add("@DoubleMarkupAmount", SqlDbType.Decimal).Value = ChkIn.DoubleMarkupAmount;
            command.Parameters.Add("@ClientId", SqlDbType.Int).Value = ChkIn.ClientId;
            command.Parameters.Add("@CityId", SqlDbType.Int).Value = ChkIn.CityId;
            command.Parameters.Add("@ServiceCharge", SqlDbType.Int).Value = ChkIn.ServiceCharge;

   /*         DataSet Value = new WrbErpConnection().ExecuteDataSet(command, UserData);
            if (Value.Tables["DBERRORTBL"].Rows.Count > 0)
            {
                dTable.Rows.Add(Value.Tables["DBERRORTBL"].Rows[0][0].ToString());
                ds.Tables.Add(dTable);
                return ds;
            }*/
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
            
         //   return ds;

        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckIn_Select;
            
            command = new SqlCommand();
            command.CommandText = StoredProcedures.CheckIn_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:GuestCheckInDao Help" + ", ProcName:'" + StoredProcedures.CheckIn_Help;
            
            command = new SqlCommand();
            command.CommandText = StoredProcedures.CheckIn_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
           // command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            //command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = Convert.ToInt32(data[5].ToString());
            command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@SSPId", SqlDbType.BigInt).Value = Convert.ToInt32(data[8].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(data[9].ToString());
        //    command.Parameters.Add("@Roles", SqlDbType.NVarChar).Value = Convert.ToInt32(data[10].ToString());

            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
