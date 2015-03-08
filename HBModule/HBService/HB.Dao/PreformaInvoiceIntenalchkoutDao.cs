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
    public class PreformaInvoiceIntenalchkoutDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            PreformaInvoiceIntenalchkout PIChkOut = new PreformaInvoiceIntenalchkout();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);
            PIChkOut.CheckOutNo = doc.SelectSingleNode("HdrXml").Attributes["CheckOutNo"].Value;
            PIChkOut.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            PIChkOut.Stay = doc.SelectSingleNode("HdrXml").Attributes["Stay"].Value;
            PIChkOut.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
            PIChkOut.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            PIChkOut.BillDate = doc.SelectSingleNode("HdrXml").Attributes["BillDate"].Value;
            PIChkOut.ClientName = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            PIChkOut.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value == "")
            {
                PIChkOut.TotalTariff = 0;
            }
            else
            {
                PIChkOut.TotalTariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value == "")
            {
                PIChkOut.NetAmount = 0;
            }
            else
            {
                PIChkOut.NetAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value == "")
            {
                PIChkOut.AdditionalCharge = 0;
            }
            else
            {
                PIChkOut.AdditionalCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value == "")
            {
                PIChkOut.Discountperday = 0;
            }
            else
            {
                PIChkOut.Discountperday = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value == "")
            {
                PIChkOut.TotalDiscount = 0;
            }
            else
            {
                PIChkOut.TotalDiscount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value == "")
            {
                PIChkOut.LuxuryTax = 0;
            }
            else
            {
                PIChkOut.LuxuryTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value == "")
            {
                PIChkOut.SerivceTax = 0;
            }
            else
            {
                PIChkOut.SerivceTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value == "")
            {
                PIChkOut.SerivceNet = 0;
            }
            else
            {
                PIChkOut.SerivceNet = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value == "")
            {
                PIChkOut.ServiceCharge = 0;
            }
            else
            {
                PIChkOut.ServiceCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value == "")
            {
                PIChkOut.ServiceTaxService = 0;
            }
            else
            {
                PIChkOut.ServiceTaxService = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                PIChkOut.Cess = 0;
            }
            else
            {
                PIChkOut.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
                PIChkOut.HECess = 0;
            }
            else
            {
                PIChkOut.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }

            if (doc.SelectSingleNode("HdrXml").Attributes["LT"].Value == "")
            {
                PIChkOut.HECess = 0;
            }
            else
            {
                PIChkOut.LTTaxPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LT"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ST"].Value == "")
            {
                PIChkOut.STTaxPer = 0;
            }
            else
            {
                PIChkOut.STTaxPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ST"].Value);
            }

            PIChkOut.Referance = doc.SelectSingleNode("HdrXml").Attributes["Referance"].Value;
            PIChkOut.Name = doc.SelectSingleNode("HdrXml").Attributes["Name"].Value;
            PIChkOut.ExtraType = doc.SelectSingleNode("HdrXml").Attributes["ExtraType"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value == "")
            {
                PIChkOut.ExtraDays = 0;
            }
            else
            {
                PIChkOut.ExtraDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value == "")
            {
                PIChkOut.ExtraAmount = 0;
            }
            else
            {
                PIChkOut.ExtraAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value);
            }
            PIChkOut.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            PIChkOut.ChkInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkInHdrId"].Value);
            PIChkOut.NoOfDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["NoOfDays"].Value);
            PIChkOut.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            PIChkOut.BedId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BedId"].Value);
            PIChkOut.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
            PIChkOut.CheckInType = doc.SelectSingleNode("HdrXml").Attributes["CheckInType"].Value;
            PIChkOut.BedNo = doc.SelectSingleNode("HdrXml").Attributes["BedNo"].Value;
            PIChkOut.ApartmentNo = doc.SelectSingleNode("HdrXml").Attributes["ApartmentNo"].Value;
            PIChkOut.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            PIChkOut.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            PIChkOut.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            PIChkOut.StateId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            PIChkOut.Direct = doc.SelectSingleNode("HdrXml").Attributes["Direct"].Value;
            PIChkOut.BTC = doc.SelectSingleNode("HdrXml").Attributes["BTC"].Value;
            PIChkOut.PropertyType = doc.SelectSingleNode("HdrXml").Attributes["PropertyType"].Value;
            PIChkOut.Status = doc.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            PIChkOut.CheckInDate = doc.SelectSingleNode("HdrXml").Attributes["CheckInDate"].Value;
            PIChkOut.CheckOutDate = doc.SelectSingleNode("HdrXml").Attributes["CheckOutDate"].Value;
            PIChkOut.InVoiceNo = doc.SelectSingleNode("HdrXml").Attributes["InVoiceNo"].Value;
            PIChkOut.ClientId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            PIChkOut.CityId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            PIChkOut.ServiceChargeChk = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ServiceChargeChk"].Value);
            PIChkOut.BillFromDate = doc.SelectSingleNode("HdrXml").Attributes["BillFromDate"].Value;
            PIChkOut.BillEndDate = doc.SelectSingleNode("HdrXml").Attributes["BillEndDate"].Value;
            PIChkOut.Intermediate = doc.SelectSingleNode("HdrXml").Attributes["Intermediate"].Value;
            PIChkOut.Preformainvoice = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Preformainvoice"].Value);
            PIChkOut.Email = doc.SelectSingleNode("HdrXml").Attributes["Email"].Value;
            PIChkOut.TariffPaymentMode = doc.SelectSingleNode("HdrXml").Attributes["TariffPaymentMode"].Value;
            PIChkOut.BookingType = doc.SelectSingleNode("HdrXml").Attributes["BookingType"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value == "")
            {
                PIChkOut.STAgreedAmount = 0;
            }
            else
            {
                PIChkOut.STAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value == "")
            {
                PIChkOut.LTAgreedAmount = 0;
            }
            else
            {
                PIChkOut.LTAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value == "")
            {
                PIChkOut.STRackAmount = 0;
            }
            else
            {
                PIChkOut.STRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value == "")
            {
                PIChkOut.LTRackAmount = 0;
            }
            else
            {
                PIChkOut.LTRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value);
            }

            if (doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value == "")
            {
                PIChkOut.VATPer = 0;
            }
            else
            {
                PIChkOut.VATPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value == "")
            {
                PIChkOut.RestaurantSTPer = 0;
            }
            else
            {
                PIChkOut.RestaurantSTPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value == "")
            {
                PIChkOut.BusinessSupportST = 0;
            }
            else
            {
                PIChkOut.BusinessSupportST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value);
            }
            //    ChkOut.Flag = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Flag"].Value);
            //  ChkOut.Flag = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Flag"].Value);
            //if (doc.SelectSingleNode("HdrXml").Attributes["Flag"].Value == "")
            //{
            //    ChkOut.Flag = 0;
            //}
            //else
            //{
            //    ChkOut.Flag = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Flag"].Value);
            //}
            Cmd = new SqlCommand();
            if (PIChkOut.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Update" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = PIChkOut.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.PreformaInvoiceInternal_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.PreformaInvoiceInternal_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@CheckOutNo", SqlDbType.NVarChar).Value = PIChkOut.CheckOutNo;
            Cmd.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = PIChkOut.GuestName;
            Cmd.Parameters.Add("@Stay", SqlDbType.NVarChar).Value = PIChkOut.Stay;
            Cmd.Parameters.Add("@Type", SqlDbType.NVarChar).Value = PIChkOut.Type;
            Cmd.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = PIChkOut.BillDate;
            Cmd.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = PIChkOut.BookingLevel;
            Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = PIChkOut.ClientName;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = PIChkOut.Property;
            Cmd.Parameters.Add("@ChkOutTariffTotal", SqlDbType.Decimal).Value = PIChkOut.TotalTariff;
            Cmd.Parameters.Add("@ChkOutTariffNetAmount", SqlDbType.Decimal).Value = PIChkOut.NetAmount;
            Cmd.Parameters.Add("@ChkOutTariffAdays", SqlDbType.Decimal).Value = PIChkOut.AdditionalCharge;
            Cmd.Parameters.Add("@ChkOutTariffDiscount", SqlDbType.Decimal).Value = PIChkOut.Discountperday;
            Cmd.Parameters.Add("@ChkOutTariffLT", SqlDbType.Decimal).Value = PIChkOut.LuxuryTax;
            Cmd.Parameters.Add("@ChkOutTariffST1", SqlDbType.Decimal).Value = PIChkOut.SerivceTax;
            Cmd.Parameters.Add("@ChkOutTariffST2", SqlDbType.Decimal).Value = PIChkOut.SerivceNet;
            Cmd.Parameters.Add("@ChkOutTariffSC", SqlDbType.Decimal).Value = PIChkOut.ServiceCharge;
            Cmd.Parameters.Add("@ChkOutTariffST3", SqlDbType.Decimal).Value = PIChkOut.ServiceTaxService;
            Cmd.Parameters.Add("@ChkOutTariffCess", SqlDbType.Decimal).Value = PIChkOut.Cess;
            Cmd.Parameters.Add("@ChkOutTariffHECess", SqlDbType.Decimal).Value = PIChkOut.HECess;
            Cmd.Parameters.Add("@ChkOutTariffReferance", SqlDbType.NVarChar).Value = PIChkOut.Referance;
            Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = PIChkOut.Name;
            Cmd.Parameters.Add("@ChkOutTariffExtraType", SqlDbType.NVarChar).Value = PIChkOut.ExtraType;
            Cmd.Parameters.Add("@CheckOutTariffExtraDays", SqlDbType.Int).Value = PIChkOut.ExtraDays;
            Cmd.Parameters.Add("@ChkOutTariffExtraAmount", SqlDbType.Decimal).Value = PIChkOut.ExtraAmount;
            Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = PIChkOut.ChkInHdrId;
            Cmd.Parameters.Add("@NoOfDays", SqlDbType.Int).Value = PIChkOut.NoOfDays;
            Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = PIChkOut.RoomId;
            Cmd.Parameters.Add("@BedId", SqlDbType.Int).Value = PIChkOut.BedId;
            Cmd.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = PIChkOut.ApartmentId;
            Cmd.Parameters.Add("@CheckInType", SqlDbType.NVarChar).Value = PIChkOut.CheckInType;
            Cmd.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value = PIChkOut.ApartmentNo;
            Cmd.Parameters.Add("@BedNo", SqlDbType.NVarChar).Value = PIChkOut.BedNo;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = PIChkOut.PropertyId;
            Cmd.Parameters.Add("@BookingId", SqlDbType.Int).Value = PIChkOut.BookingId;
            Cmd.Parameters.Add("@GuestId", SqlDbType.Int).Value = PIChkOut.GuestId;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = PIChkOut.StateId;
            Cmd.Parameters.Add("@Direct", SqlDbType.NVarChar).Value = PIChkOut.Direct;
            Cmd.Parameters.Add("@BTC", SqlDbType.NVarChar).Value = PIChkOut.BTC;
            Cmd.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = PIChkOut.PropertyType;
            Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = PIChkOut.Status;
            Cmd.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = PIChkOut.CheckInDate;
            Cmd.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = PIChkOut.CheckOutDate;
            Cmd.Parameters.Add("@InVoiceNo", SqlDbType.NVarChar).Value = PIChkOut.InVoiceNo;
            Cmd.Parameters.Add("@STAgreedAmount", SqlDbType.Decimal).Value = PIChkOut.STAgreedAmount;
            Cmd.Parameters.Add("@STRackAmount", SqlDbType.Decimal).Value = PIChkOut.STRackAmount;
            Cmd.Parameters.Add("@LTAgreedAmount", SqlDbType.Decimal).Value = PIChkOut.LTAgreedAmount;
            Cmd.Parameters.Add("@LTRackAmount", SqlDbType.Decimal).Value = PIChkOut.LTRackAmount;
            Cmd.Parameters.Add("@LTTaxPer", SqlDbType.Decimal).Value = PIChkOut.LTTaxPer;
            Cmd.Parameters.Add("@STTaxPer", SqlDbType.Decimal).Value = PIChkOut.STTaxPer;
            Cmd.Parameters.Add("@VATPer", SqlDbType.Decimal).Value = PIChkOut.VATPer;
            Cmd.Parameters.Add("@RestaurantSTPer", SqlDbType.Decimal).Value = PIChkOut.RestaurantSTPer;
            Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.Decimal).Value = PIChkOut.BusinessSupportST;
            Cmd.Parameters.Add("@ClientId", SqlDbType.Int).Value = PIChkOut.ClientId;
            Cmd.Parameters.Add("@CityId", SqlDbType.Int).Value = PIChkOut.CityId;
            Cmd.Parameters.Add("@ServiceChargeChk", SqlDbType.Int).Value = PIChkOut.ServiceChargeChk;
            Cmd.Parameters.Add("@BillFromDate", SqlDbType.NVarChar).Value = PIChkOut.BillFromDate;
            Cmd.Parameters.Add("@BillEndDate", SqlDbType.NVarChar).Value = PIChkOut.BillEndDate;
            Cmd.Parameters.Add("@Intermediate", SqlDbType.NVarChar).Value = PIChkOut.Intermediate;
            Cmd.Parameters.Add("@Preformainvoice", SqlDbType.Bit).Value = PIChkOut.Preformainvoice;
            Cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = PIChkOut.Email;
            Cmd.Parameters.Add("@TariffPaymentMode", SqlDbType.NVarChar).Value = PIChkOut.TariffPaymentMode;
            Cmd.Parameters.Add("@BookingType", SqlDbType.NVarChar).Value = PIChkOut.BookingType;
            //      Cmd.Parameters.Add("@Flag", SqlDbType.Bit).Value = ChkOut.Flag;
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
                "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Help" + ", ProcName:'" + StoredProcedures.PreformaInvoiceIntcheckout_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.PreformaInvoiceIntcheckout_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@BillFrom", SqlDbType.NVarChar).Value = data[3].ToString();
            Cmd.Parameters.Add("@BillTo", SqlDbType.NVarChar).Value = data[4].ToString();

            Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[7].ToString());
            Cmd.Parameters.Add("@ExtraMatters", SqlDbType.Decimal).Value = Convert.ToDecimal(data[9].ToString());
            Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[8].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}