using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;
using System.Data.Sql;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace HB.Dao
{
    public class PreformaInvoiceEXTMMTCPPchkoutDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            PreformaInvoiceEXTMMTCPPchkout ExChkOut = new PreformaInvoiceEXTMMTCPPchkout();
            XmlDocument doc = new XmlDocument();
            XmlDocument document = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);

            ExChkOut.CheckOutNo = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutNo"].Value);
            ExChkOut.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            ExChkOut.Stay = doc.SelectSingleNode("HdrXml").Attributes["Stay"].Value;
            ExChkOut.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
            ExChkOut.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            ExChkOut.BillDate = doc.SelectSingleNode("HdrXml").Attributes["BillDate"].Value;
            ExChkOut.ClientName = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            ExChkOut.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            ExChkOut.InVoiceNo = doc.SelectSingleNode("HdrXml").Attributes["InVoiceNo"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value == "")
            {
                ExChkOut.TotalTariff = 0;
            }
            else
            {
                ExChkOut.TotalTariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value == "")
            {
                ExChkOut.NetAmount = 0;
            }
            else
            {
                ExChkOut.NetAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value == "")
            {
                ExChkOut.AdditionalCharge = 0;
            }
            else
            {
                ExChkOut.AdditionalCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value == "")
            {
                ExChkOut.Discountperday = 0;
            }
            else
            {
                ExChkOut.Discountperday = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value == "")
            {
                ExChkOut.TotalDiscount = 0;
            }
            else
            {
                ExChkOut.TotalDiscount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value == "")
            {
                ExChkOut.LuxuryTax = 0;
            }
            else
            {
                ExChkOut.LuxuryTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value == "")
            {
                ExChkOut.SerivceTax = 0;
            }
            else
            {
                ExChkOut.SerivceTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value == "")
            {
                ExChkOut.SerivceNet = 0;
            }
            else
            {
                ExChkOut.SerivceNet = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value == "")
            {
                ExChkOut.ServiceCharge = 0;
            }
            else
            {
                ExChkOut.ServiceCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value == "")
            {
                ExChkOut.ServiceTaxService = 0;
            }
            else
            {
                ExChkOut.ServiceTaxService = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                ExChkOut.Cess = 0;
            }
            else
            {
                ExChkOut.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
                ExChkOut.HECess = 0;
            }
            else
            {
                ExChkOut.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }
            ExChkOut.Referance = doc.SelectSingleNode("HdrXml").Attributes["Referance"].Value;
            ExChkOut.Name = doc.SelectSingleNode("HdrXml").Attributes["Name"].Value;
            ExChkOut.ExtraType = doc.SelectSingleNode("HdrXml").Attributes["ExtraType"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value == "")
            {
                ExChkOut.ExtraDays = 0;
            }
            else
            {
                ExChkOut.ExtraDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value == "")
            {
                ExChkOut.ExtraAmount = 0;
            }
            else
            {
                ExChkOut.ExtraAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value);
            }
            ExChkOut.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            ExChkOut.ChkInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkInHdrId"].Value);
            ExChkOut.NoOfDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["NoOfDays"].Value);
            ExChkOut.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            ExChkOut.BedId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BedId"].Value);
            ExChkOut.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
            ExChkOut.CheckInType = doc.SelectSingleNode("HdrXml").Attributes["CheckInType"].Value;
            ExChkOut.BedNo = doc.SelectSingleNode("HdrXml").Attributes["BedNo"].Value;
            ExChkOut.ApartmentNo = doc.SelectSingleNode("HdrXml").Attributes["ApartmentNo"].Value;
            ExChkOut.PropertyId = Convert.ToInt64(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            ExChkOut.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            ExChkOut.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            ExChkOut.StateId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            ExChkOut.Direct = doc.SelectSingleNode("HdrXml").Attributes["Direct"].Value;
            ExChkOut.BTC = doc.SelectSingleNode("HdrXml").Attributes["BTC"].Value;
            ExChkOut.PropertyType = doc.SelectSingleNode("HdrXml").Attributes["PropertyType"].Value;
            ExChkOut.CheckInDate = doc.SelectSingleNode("HdrXml").Attributes["CheckInDate"].Value;
            ExChkOut.CheckOutDate = doc.SelectSingleNode("HdrXml").Attributes["CheckOutDate"].Value;
            ExChkOut.Status = doc.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value == "")
            {
                ExChkOut.STAgreedAmount = 0;
            }
            else
            {
                ExChkOut.STAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value == "")
            {
                ExChkOut.LTAgreedAmount = 0;
            }
            else
            {
                ExChkOut.LTAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value == "")
            {
                ExChkOut.STRackAmount = 0;
            }
            else
            {
                ExChkOut.STRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value == "")
            {
                ExChkOut.LTRackAmount = 0;
            }
            else
            {
                ExChkOut.LTRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value == "")
            {
                ExChkOut.VATPer = 0;
            }
            else
            {
                ExChkOut.VATPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value == "")
            {
                ExChkOut.RestaurantSTPer = 0;
            }
            else
            {
                ExChkOut.RestaurantSTPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value == "")
            {
                ExChkOut.BusinessSupportST = 0;
            }
            else
            {
                ExChkOut.BusinessSupportST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value);
            }
            ExChkOut.ClientId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            ExChkOut.CityId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            ExChkOut.BillFromDate = doc.SelectSingleNode("HdrXml").Attributes["BillFromDate"].Value;
            ExChkOut.BillEndDate = doc.SelectSingleNode("HdrXml").Attributes["BillEndDate"].Value;
            ExChkOut.Intermediate = doc.SelectSingleNode("HdrXml").Attributes["Intermediate"].Value;
            //if (doc.SelectSingleNode("HdrXml").Attributes["PrintInvoice"].Value == "")
            //{
            //    ExChkOut.PrintInvoice = 0;
            //}
            //else
            //{
            //    ExChkOut.PrintInvoice = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["PrintInvoice"].Value);
            //}
            ExChkOut.PrintInvoice = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["PrintInvoice"].Value);
            ExChkOut.Email = doc.SelectSingleNode("HdrXml").Attributes["Email"].Value;
            Cmd = new SqlCommand();
            if (ExChkOut.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Update" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ExChkOut.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.PreformaInvoiceEXTcheckout_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.PreformaInvoiceEXTcheckout_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@InVoiceNo", SqlDbType.NVarChar).Value = ExChkOut.InVoiceNo;
            Cmd.Parameters.Add("@CheckOutNo", SqlDbType.Int).Value = ExChkOut.CheckOutNo;
            Cmd.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = ExChkOut.GuestName;
            Cmd.Parameters.Add("@Stay", SqlDbType.NVarChar).Value = ExChkOut.Stay;
            Cmd.Parameters.Add("@Type", SqlDbType.NVarChar).Value = ExChkOut.Type;
            Cmd.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = ExChkOut.BillDate;
            Cmd.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = ExChkOut.BookingLevel;
            Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ExChkOut.ClientName;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ExChkOut.Property;
            Cmd.Parameters.Add("@ChkOutTariffTotal", SqlDbType.Decimal).Value = ExChkOut.TotalTariff;
            Cmd.Parameters.Add("@ChkOutTariffNetAmount", SqlDbType.Decimal).Value = ExChkOut.NetAmount;
            Cmd.Parameters.Add("@ChkOutTariffAdays", SqlDbType.Decimal).Value = ExChkOut.AdditionalCharge;
            Cmd.Parameters.Add("@ChkOutTariffDiscount", SqlDbType.Decimal).Value = ExChkOut.Discountperday;
            Cmd.Parameters.Add("@ChkOutTariffLT", SqlDbType.Decimal).Value = ExChkOut.LuxuryTax;
            Cmd.Parameters.Add("@ChkOutTariffST1", SqlDbType.Decimal).Value = ExChkOut.SerivceTax;
            Cmd.Parameters.Add("@ChkOutTariffST2", SqlDbType.Decimal).Value = ExChkOut.SerivceNet;
            Cmd.Parameters.Add("@ChkOutTariffSC", SqlDbType.Decimal).Value = ExChkOut.ServiceCharge;
            Cmd.Parameters.Add("@ChkOutTariffST3", SqlDbType.Decimal).Value = ExChkOut.ServiceTaxService;
            Cmd.Parameters.Add("@ChkOutTariffCess", SqlDbType.Decimal).Value = ExChkOut.Cess;
            Cmd.Parameters.Add("@ChkOutTariffHECess", SqlDbType.Decimal).Value = ExChkOut.HECess;
            Cmd.Parameters.Add("@ChkOutTariffReferance", SqlDbType.NVarChar).Value = ExChkOut.Referance;
            Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = ExChkOut.Name;
            Cmd.Parameters.Add("@ChkOutTariffExtraType", SqlDbType.NVarChar).Value = ExChkOut.ExtraType;
            Cmd.Parameters.Add("@CheckOutTariffExtraDays", SqlDbType.Int).Value = ExChkOut.ExtraDays;
            Cmd.Parameters.Add("@ChkOutTariffExtraAmount", SqlDbType.Decimal).Value = ExChkOut.ExtraAmount;
            Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = ExChkOut.ChkInHdrId;
            Cmd.Parameters.Add("@NoOfDays", SqlDbType.Int).Value = ExChkOut.NoOfDays;
            Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = ExChkOut.RoomId;
            Cmd.Parameters.Add("@BedId", SqlDbType.Int).Value = ExChkOut.BedId;
            Cmd.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = ExChkOut.ApartmentId;
            Cmd.Parameters.Add("@CheckInType", SqlDbType.NVarChar).Value = ExChkOut.CheckInType;
            Cmd.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value = ExChkOut.ApartmentNo;
            Cmd.Parameters.Add("@BedNo", SqlDbType.NVarChar).Value = ExChkOut.BedNo;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = ExChkOut.PropertyId;
            Cmd.Parameters.Add("@BookingId", SqlDbType.Int).Value = ExChkOut.BookingId;
            Cmd.Parameters.Add("@GuestId", SqlDbType.Int).Value = ExChkOut.GuestId;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = ExChkOut.StateId;
            Cmd.Parameters.Add("@Direct", SqlDbType.NVarChar).Value = ExChkOut.Direct;
            Cmd.Parameters.Add("@BTC", SqlDbType.NVarChar).Value = ExChkOut.BTC;
            Cmd.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = ExChkOut.PropertyType;
            Cmd.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = ExChkOut.CheckInDate;
            Cmd.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = ExChkOut.CheckOutDate;
            Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = ExChkOut.Status;
            Cmd.Parameters.Add("@STAgreedAmount", SqlDbType.Decimal).Value = ExChkOut.STAgreedAmount;
            Cmd.Parameters.Add("@STRackAmount", SqlDbType.Decimal).Value = ExChkOut.STRackAmount;
            Cmd.Parameters.Add("@LTAgreedAmount", SqlDbType.Decimal).Value = ExChkOut.LTAgreedAmount;
            Cmd.Parameters.Add("@LTRackAmount", SqlDbType.Decimal).Value = ExChkOut.LTRackAmount;
            Cmd.Parameters.Add("@LTTaxPer", SqlDbType.Decimal).Value = ExChkOut.LTTaxPer;
            Cmd.Parameters.Add("@STTaxPer", SqlDbType.Decimal).Value = ExChkOut.STTaxPer;
            Cmd.Parameters.Add("@VATPer", SqlDbType.Decimal).Value = ExChkOut.VATPer;
            Cmd.Parameters.Add("@RestaurantSTPer", SqlDbType.Decimal).Value = ExChkOut.RestaurantSTPer;
            Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.Decimal).Value = ExChkOut.BusinessSupportST;
            Cmd.Parameters.Add("@PrintInvoice", SqlDbType.Bit).Value = ExChkOut.PrintInvoice;
            Cmd.Parameters.Add("@ClientId", SqlDbType.Int).Value = ExChkOut.ClientId;
            Cmd.Parameters.Add("@CityId", SqlDbType.Int).Value = ExChkOut.CityId;
            Cmd.Parameters.Add("@BillFromDate", SqlDbType.NVarChar).Value = ExChkOut.BillFromDate;
            Cmd.Parameters.Add("@BillEndDate", SqlDbType.NVarChar).Value = ExChkOut.BillEndDate;
            Cmd.Parameters.Add("@Intermediate", SqlDbType.NVarChar).Value = ExChkOut.Intermediate;
            Cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = ExChkOut.Email;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Select" + ", ProcName:'" + StoredProcedures.CheckOut_Select;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.CheckOut_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //Cmd.Parameters.Add("@UserId", SqlDbType.BigInt).Value = User.Id;
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Help" + ", ProcName:'" + StoredProcedures.PreformaInvoiceEXTcheckout_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.PreformaInvoiceEXTcheckout_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@BillFrom", SqlDbType.NVarChar).Value = data[3].ToString();
            Cmd.Parameters.Add("@BillTo", SqlDbType.NVarChar).Value = data[4].ToString();
            Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            Cmd.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt64(data[7].ToString());
            Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[8].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

    }

}
