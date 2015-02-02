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
    public class ExternalChechkOutTACDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            ExternalChechkOutTAC ExChkOutTAC = new ExternalChechkOutTAC();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[2]);
            ExChkOutTAC.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkOutHdrId"].Value);
            ExChkOutTAC.TACInvoiceNo = doc.SelectSingleNode("HdrXml").Attributes["TACInvoiceNo"].Value;
            ExChkOutTAC.TACInvoiceFile =doc.SelectSingleNode("HdrXml").Attributes["TACInvoiceFile"].Value;
            ExChkOutTAC.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            ExChkOutTAC.Stay = doc.SelectSingleNode("HdrXml").Attributes["Stay"].Value;
            ExChkOutTAC.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
     //       ExChkOutTAC.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            ExChkOutTAC.BillDate = doc.SelectSingleNode("HdrXml").Attributes["BillDate"].Value;
            ExChkOutTAC.ClientName = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            ExChkOutTAC.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value == "")
            {
                ExChkOutTAC.TotalTariff = 0;
            }
            else
            {
                ExChkOutTAC.TotalTariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value == "")
            {
                ExChkOutTAC.NetAmount = 0;
            }
            else
            {
                ExChkOutTAC.NetAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value == "")
            {
                ExChkOutTAC.SerivceTax = 0;
            }
            else
            {
                ExChkOutTAC.SerivceTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value);
            }
            
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                ExChkOutTAC.Cess = 0;
            }
            else
            {
                ExChkOutTAC.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
                ExChkOutTAC.HECess = 0;
            }
            else
            {
                ExChkOutTAC.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }
            ExChkOutTAC.Referance = doc.SelectSingleNode("HdrXml").Attributes["Referance"].Value;
            
            ExChkOutTAC.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            ExChkOutTAC.ChkInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkInHdrId"].Value);
            ExChkOutTAC.NoOfDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["NoOfDays"].Value);
            ExChkOutTAC.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            
            ExChkOutTAC.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            ExChkOutTAC.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            ExChkOutTAC.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            ExChkOutTAC.StateId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            ExChkOutTAC.Direct = doc.SelectSingleNode("HdrXml").Attributes["Direct"].Value;
            
            ExChkOutTAC.PropertyType = doc.SelectSingleNode("HdrXml").Attributes["PropertyType"].Value;
            ExChkOutTAC.CheckInDate = doc.SelectSingleNode("HdrXml").Attributes["CheckInDate"].Value;
            ExChkOutTAC.CheckOutDate = doc.SelectSingleNode("HdrXml").Attributes["CheckOutDate"].Value;
            ExChkOutTAC.Status = doc.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["MarkUpAmount"].Value == "")
            {
                ExChkOutTAC.MarkUpAmount = 0;
            }
            else
            {
                ExChkOutTAC.MarkUpAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["MarkUpAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value == "")
            {
                ExChkOutTAC.BusinessSupportST = 0;
            }
            else
            {
                ExChkOutTAC.BusinessSupportST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Rate"].Value == "")
            {
                ExChkOutTAC.Rate = 0;
            }
            else
            {
                ExChkOutTAC.Rate = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Rate"].Value);
            }
            Cmd = new SqlCommand();
            if (ExChkOutTAC.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Update" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ExChkOutTAC.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.ExterCheckOutTAC_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ExChkOutTAC.ChkOutHdrId;
            Cmd.Parameters.Add("@TACInvoiceNo", SqlDbType.NVarChar).Value = ExChkOutTAC.TACInvoiceNo;
            Cmd.Parameters.Add("@TACInvoiceFile", SqlDbType.NVarChar).Value = ExChkOutTAC.TACInvoiceFile;
            Cmd.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = ExChkOutTAC.GuestName;
            Cmd.Parameters.Add("@Stay", SqlDbType.NVarChar).Value = ExChkOutTAC.Stay;
            Cmd.Parameters.Add("@Type", SqlDbType.NVarChar).Value = ExChkOutTAC.Type;
            Cmd.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = ExChkOutTAC.BillDate;
      //      Cmd.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = ExChkOutTAC.BookingLevel;
            Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ExChkOutTAC.ClientName;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ExChkOutTAC.Property;
            Cmd.Parameters.Add("@ChkOutTariffTotal", SqlDbType.Decimal).Value = ExChkOutTAC.TotalTariff;
            Cmd.Parameters.Add("@ChkOutTariffNetAmount", SqlDbType.Decimal).Value = ExChkOutTAC.NetAmount;
            Cmd.Parameters.Add("@ChkOutTariffST", SqlDbType.Decimal).Value = ExChkOutTAC.SerivceTax;
      //      Cmd.Parameters.Add("@ChkOutTariffST2", SqlDbType.Decimal).Value = ExChkOutTAC.SerivceNet;
            Cmd.Parameters.Add("@ChkOutTariffCess", SqlDbType.Decimal).Value = ExChkOutTAC.Cess;
            Cmd.Parameters.Add("@ChkOutTariffHECess", SqlDbType.Decimal).Value = ExChkOutTAC.HECess;
            Cmd.Parameters.Add("@ChkOutTariffReferance", SqlDbType.NVarChar).Value = ExChkOutTAC.Referance;
       //     Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = ExChkOutTAC.Name;
            Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = ExChkOutTAC.ChkInHdrId;
            Cmd.Parameters.Add("@NoOfDays", SqlDbType.Int).Value = ExChkOutTAC.NoOfDays;
            Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = ExChkOutTAC.RoomId;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = ExChkOutTAC.PropertyId;
            Cmd.Parameters.Add("@BookingId", SqlDbType.Int).Value = ExChkOutTAC.BookingId;
            Cmd.Parameters.Add("@GuestId", SqlDbType.Int).Value = ExChkOutTAC.GuestId;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = ExChkOutTAC.StateId;
            Cmd.Parameters.Add("@Direct", SqlDbType.NVarChar).Value = ExChkOutTAC.Direct;
       //     Cmd.Parameters.Add("@BTC", SqlDbType.NVarChar).Value = ExChkOutTAC.BTC;
            Cmd.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = ExChkOutTAC.PropertyType;
            Cmd.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = ExChkOutTAC.CheckInDate;
            Cmd.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = ExChkOutTAC.CheckOutDate;
            Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = ExChkOutTAC.Status;
            Cmd.Parameters.Add("@MarkUpAmount", SqlDbType.Decimal).Value = ExChkOutTAC.MarkUpAmount;
            Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.Decimal).Value = ExChkOutTAC.BusinessSupportST;
            Cmd.Parameters.Add("@Rate", SqlDbType.Decimal).Value = ExChkOutTAC.Rate;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;

        }
        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Help" + ", ProcName:'" + StoredProcedures.Checkout_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.ExternalCheckoutTAC_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
