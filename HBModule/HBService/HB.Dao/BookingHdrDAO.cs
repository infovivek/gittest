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
using System.Text.RegularExpressions;

namespace HB.Dao
{    
    public class BookingHdrDAO
    {
        string UserData = "";
        public DataSet Save(string Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            Booking Book = new Booking();
            Book.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Book.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            Book.GradeId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["GradeId"].Value);
            Book.StateId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            Book.CityId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            Book.ClientName = document.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            Book.CheckInDate = document.SelectSingleNode("HdrXml").Attributes["CheckInDate"].Value;
            Book.ExpectedChkInTime = document.SelectSingleNode("HdrXml").Attributes["ExpectedChkInTime"].Value;
            Book.CheckOutDate = document.SelectSingleNode("HdrXml").Attributes["CheckOutDate"].Value;
            Book.GradeName = document.SelectSingleNode("HdrXml").Attributes["GradeName"].Value;
            Book.StateName = document.SelectSingleNode("HdrXml").Attributes["StateName"].Value;
            Book.CityName = document.SelectSingleNode("HdrXml").Attributes["CityName"].Value;            
            Book.Sales = document.SelectSingleNode("HdrXml").Attributes["Sales"].Value;
            Book.CRM = document.SelectSingleNode("HdrXml").Attributes["CRM"].Value;
            Book.ClientBookerId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientBookerId"].Value);
            Book.ClientBookerName = document.SelectSingleNode("HdrXml").Attributes["ClientBookerName"].Value;
            Book.ClientBookerEmail = document.SelectSingleNode("HdrXml").Attributes["ClientBookerEmail"].Value;
            Book.EmailtoGuest = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["EmailtoGuest"].Value);
            Book.Note = document.SelectSingleNode("HdrXml").Attributes["Note"].Value;
            // tab 3
            Book.SpecialRequirements = document.SelectSingleNode("HdrXml").Attributes["SpecialRequirements"].Value;
            //
            Book.Status = document.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            Book.AMPM = document.SelectSingleNode("HdrXml").Attributes["AMPM"].Value;
            Book.BookingLevel = document.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            Book.ExtraCCEmail = document.SelectSingleNode("HdrXml").Attributes["ExtraCCEmail"].Value;
            Book.HRPolicy = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["HRPolicy"].Value);
            if (Book.Id != 0)
            {
                command.CommandText = StoredProcedures.Booking_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Book.Id;
                command.Parameters.Add("@ExtraCCEmail", SqlDbType.NVarChar).Value = Book.ExtraCCEmail;
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingHdrDAO : Update, " + ", ProcName:'" + StoredProcedures.Booking_Update; 
            }
            else
            {
                command.CommandText = StoredProcedures.Booking_Insert;
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingHdrDAO : Insert, " + ", ProcName:'" + StoredProcedures.Booking_Insert; 
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Book.ClientId;
            command.Parameters.Add("@GradeId", SqlDbType.BigInt).Value = Book.GradeId;
            command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Book.StateId;
            command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Book.CityId;
            command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = Book.ClientName;
            command.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = Book.CheckInDate;
            command.Parameters.Add("@ExpectedChkInTime", SqlDbType.NVarChar).Value = Book.ExpectedChkInTime;
            command.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = Book.CheckOutDate;
            command.Parameters.Add("@GradeName", SqlDbType.NVarChar).Value = Book.GradeName;
            command.Parameters.Add("@StateName", SqlDbType.NVarChar).Value = Book.StateName;
            command.Parameters.Add("@CityName", SqlDbType.NVarChar).Value = Book.CityName;
            command.Parameters.Add("@SpecialRequirements", SqlDbType.NVarChar).Value = Book.SpecialRequirements;
            command.Parameters.Add("@Sales", SqlDbType.NVarChar).Value = Book.Sales;
            command.Parameters.Add("@CRM", SqlDbType.NVarChar).Value = Book.CRM;
            command.Parameters.Add("@ClientBookerId", SqlDbType.BigInt).Value = Book.ClientBookerId;
            command.Parameters.Add("@ClientBookerName", SqlDbType.NVarChar).Value = Book.ClientBookerName;
            command.Parameters.Add("@ClientBookerEmail", SqlDbType.NVarChar).Value = Book.ClientBookerEmail;
            command.Parameters.Add("@EmailtoGuest", SqlDbType.Bit).Value = Book.EmailtoGuest;
            command.Parameters.Add("@Note", SqlDbType.NVarChar).Value = Book.Note;
            command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
            //
            command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = Book.Status;
            command.Parameters.Add("@AMPM", SqlDbType.NVarChar).Value = Book.AMPM;
            command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = Book.BookingLevel;
            command.Parameters.Add("@HRPolicy", SqlDbType.Bit).Value = Book.HRPolicy;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingHdrDAO : Search, " + ", ProcName:'" + StoredProcedures.Booking_Select; 
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Booking_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingHdrDAO : Delete, " + ", ProcName:'" + StoredProcedures.Booking_Delete; 
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Booking_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[0].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingHdrDAO : Help, " + ", ProcName:'" + StoredProcedures.Booking_Help; 
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Booking_Help;
            command.CommandType = CommandType.StoredProcedure;            
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@ChkInDt", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@ChkOutDt", SqlDbType.NVarChar).Value = data[5].ToString();
            command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[8].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt64(data[9].ToString());
            command.Parameters.Add("@GradeId", SqlDbType.BigInt).Value = Convert.ToInt32(data[10].ToString());
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[11].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[12].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
