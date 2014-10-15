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
   public class BookingGuestDetailsDAO
    {
       string UserData = "";
       public DataSet Save(string BookingGuestDetails, User user, int BookingId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           XmlDocument document = new XmlDocument();
           BookingGuestDetails bookingGD = new BookingGuestDetails();
           document.LoadXml(BookingGuestDetails);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {
               bookingGD.EmpCode = document.SelectNodes("//GridXml")[i].Attributes["EmpCode"].Value;
               bookingGD.Title = document.SelectNodes("//GridXml")[i].Attributes["Title"].Value;
               bookingGD.FirstName = document.SelectNodes("//GridXml")[i].Attributes["FirstName"].Value;
               bookingGD.LastName = document.SelectNodes("//GridXml")[i].Attributes["LastName"].Value;
               bookingGD.Grade = document.SelectNodes("//GridXml")[i].Attributes["Grade"].Value;
               bookingGD.Designation = document.SelectNodes("//GridXml")[i].Attributes["Designation"].Value;
               bookingGD.EmailId = document.SelectNodes("//GridXml")[i].Attributes["EmailId"].Value;
               bookingGD.MobileNo = document.SelectNodes("//GridXml")[i].Attributes["MobileNo"].Value;
               bookingGD.Nationality = document.SelectNodes("//GridXml")[i].Attributes["Nationality"].Value;
               if (document.SelectNodes("//GridXml")[i].Attributes["GuestId"].Value == "")
               {
                   bookingGD.GuestId = 0;
               }
               else
               {
                   bookingGD.GuestId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["GuestId"].Value);
               }               
               if (document.SelectNodes("//GridXml")[i].Attributes["GradeId"].Value == "")
               {
                   bookingGD.GradeId = 0;
               }
               else
               {
                   bookingGD.GradeId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["GradeId"].Value);
               }               
               if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
               {
                   bookingGD.Id = 0;
               }
               else
               {
                   bookingGD.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               }
               command = new SqlCommand();
               if (bookingGD.Id != 0)
               {
                   command.CommandText = StoredProcedures.BookingGuestDetails_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = bookingGD.Id;

                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingGuestDetailsDAO : Update, " + ", ProcName:'" + StoredProcedures.BookingGuestDetails_Update; 
               }
               else
               {
                   command.CommandText = StoredProcedures.BookingGuestDetails_Insert;

                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingGuestDetailsDAO : Insert, " + ", ProcName:'" + StoredProcedures.BookingGuestDetails_Insert; 
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
               command.Parameters.Add("@EmpCode", SqlDbType.NVarChar).Value = bookingGD.EmpCode;
               command.Parameters.Add("@Title", SqlDbType.NVarChar).Value = bookingGD.Title;
               command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = bookingGD.FirstName;
               command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = bookingGD.LastName;
               command.Parameters.Add("@Grade", SqlDbType.NVarChar).Value = bookingGD.Grade;
               command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = bookingGD.Designation;               
               command.Parameters.Add("@EmailId", SqlDbType.NVarChar).Value = bookingGD.EmailId;
               command.Parameters.Add("@MobileNo", SqlDbType.NVarChar).Value = bookingGD.MobileNo;
               command.Parameters.Add("@Nationality", SqlDbType.NVarChar).Value = bookingGD.Nationality;
               command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = bookingGD.GuestId;               
               command.Parameters.Add("@GradeId", SqlDbType.Int).Value = bookingGD.GradeId;
               command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
               ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           }
           if (n == 0)
           {
               DataTable dT = new DataTable("DBERRORTBL");
               ds.Tables.Add(dT);
           }
           return ds;
       }
    }
}
