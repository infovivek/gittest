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
    public class CheckoutAndIntermediateDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            CheckoutAndIntermediate ChkOut = new CheckoutAndIntermediate();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);
            ChkOut.CheckOutNo = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutNo"].Value);
            ChkOut.GuestName = doc.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
            ChkOut.Stay = doc.SelectSingleNode("HdrXml").Attributes["Stay"].Value;
            ChkOut.Type = doc.SelectSingleNode("HdrXml").Attributes["Type"].Value;
            ChkOut.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            ChkOut.BillDate = doc.SelectSingleNode("HdrXml").Attributes["BillDate"].Value;
            ChkOut.ClientName = doc.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
            ChkOut.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value == "")
            {
                ChkOut.TotalTariff = 0;
            }
            else
            {
                ChkOut.TotalTariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalTariff"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value == "")
            {
                ChkOut.NetAmount = 0;
            }
            else
            {
                ChkOut.NetAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value == "")
            {
                ChkOut.AdditionalCharge = 0;
            }
            else
            {
                ChkOut.AdditionalCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["AdditionalCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value == "")
            {
                ChkOut.Discountperday = 0;
            }
            else
            {
                ChkOut.Discountperday = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Discountperday"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value == "")
            {
                ChkOut.TotalDiscount = 0;
            }
            else
            {
                ChkOut.TotalDiscount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TotalDiscount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value == "")
            {
                ChkOut.LuxuryTax = 0;
            }
            else
            {
                ChkOut.LuxuryTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LuxuryTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value == "")
            {
                ChkOut.SerivceTax = 0;
            }
            else
            {
                ChkOut.SerivceTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceTax"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value == "")
            {
                ChkOut.SerivceNet = 0;
            }
            else
            {
                ChkOut.SerivceNet = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["SerivceNet"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value == "")
            {
                ChkOut.ServiceCharge = 0;
            }
            else
            {
                ChkOut.ServiceCharge = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceCharge"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value == "")
            {
                ChkOut.ServiceTaxService = 0;
            }
            else
            {
                ChkOut.ServiceTaxService = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceTaxService"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                ChkOut.Cess = 0;
            }
            else
            {
                ChkOut.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
                ChkOut.HECess = 0;
            }
            else
            {
                ChkOut.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }

            if (doc.SelectSingleNode("HdrXml").Attributes["LT"].Value == "")
            {
                ChkOut.HECess = 0;
            }
            else
            {
                ChkOut.LTTaxPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LT"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ST"].Value == "")
            {
                ChkOut.STTaxPer = 0;
            }
            else
            {
                ChkOut.STTaxPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ST"].Value);
            }

            ChkOut.Referance = doc.SelectSingleNode("HdrXml").Attributes["Referance"].Value;
            ChkOut.Name = doc.SelectSingleNode("HdrXml").Attributes["Name"].Value;
            ChkOut.ExtraType = doc.SelectSingleNode("HdrXml").Attributes["ExtraType"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value == "")
            {
                ChkOut.ExtraDays = 0;
            }
            else
            {
                ChkOut.ExtraDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ExtraDays"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value == "")
            {
                ChkOut.ExtraAmount = 0;
            }
            else
            {
                ChkOut.ExtraAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ExtraAmount"].Value);
            }
            ChkOut.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            ChkOut.ChkInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkInHdrId"].Value);
            ChkOut.NoOfDays = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["NoOfDays"].Value);
            ChkOut.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            ChkOut.BedId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BedId"].Value);
            ChkOut.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
            ChkOut.CheckInType = doc.SelectSingleNode("HdrXml").Attributes["CheckInType"].Value;
            ChkOut.BedNo = doc.SelectSingleNode("HdrXml").Attributes["BedNo"].Value;
            ChkOut.ApartmentNo = doc.SelectSingleNode("HdrXml").Attributes["ApartmentNo"].Value;
            ChkOut.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            ChkOut.BookingId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            ChkOut.GuestId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["GuestId"].Value);
            ChkOut.StateId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            ChkOut.Direct = doc.SelectSingleNode("HdrXml").Attributes["Direct"].Value;
            ChkOut.BTC = doc.SelectSingleNode("HdrXml").Attributes["BTC"].Value;
            ChkOut.PropertyType = doc.SelectSingleNode("HdrXml").Attributes["PropertyType"].Value;
            ChkOut.Status = doc.SelectSingleNode("HdrXml").Attributes["Status"].Value;
            ChkOut.CheckInDate = doc.SelectSingleNode("HdrXml").Attributes["CheckInDate"].Value;
            ChkOut.CheckOutDate = doc.SelectSingleNode("HdrXml").Attributes["CheckOutDate"].Value;
            ChkOut.InVoiceNo = doc.SelectSingleNode("HdrXml").Attributes["InVoiceNo"].Value;
            ChkOut.ClientId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            ChkOut.CityId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            ChkOut.ServiceChargeChk = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ServiceChargeChk"].Value);
            ChkOut.BillFromDate = doc.SelectSingleNode("HdrXml").Attributes["BillFromDate"].Value;
            ChkOut.BillEndDate = doc.SelectSingleNode("HdrXml").Attributes["BillEndDate"].Value;
            ChkOut.Intermediate = doc.SelectSingleNode("HdrXml").Attributes["Intermediate"].Value;
            ChkOut.Preformainvoice = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Preformainvoice"].Value);
            ChkOut.Email = doc.SelectSingleNode("HdrXml").Attributes["Email"].Value;
            ChkOut.TariffPaymentMode = doc.SelectSingleNode("HdrXml").Attributes["TariffPaymentMode"].Value;
            ChkOut.BookingType = doc.SelectSingleNode("HdrXml").Attributes["BookingType"].Value;
            if (doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value == "")
            {
                ChkOut.STAgreedAmount = 0;
            }
            else
            {
                ChkOut.STAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value == "")
            {
                ChkOut.LTAgreedAmount = 0;
            }
            else
            {
                ChkOut.LTAgreedAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTAgreedAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value == "")
            {
                ChkOut.STRackAmount = 0;
            }
            else
            {
                ChkOut.STRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["STRackAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value == "")
            {
                ChkOut.LTRackAmount = 0;
            }
            else
            {
                ChkOut.LTRackAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["LTRackAmount"].Value);
            }

            if (doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value == "")
            {
                ChkOut.VATPer = 0;
            }
            else
            {
                ChkOut.VATPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value == "")
            {
                ChkOut.RestaurantSTPer = 0;
            }
            else
            {
                ChkOut.RestaurantSTPer = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value == "")
            {
                ChkOut.BusinessSupportST = 0;
            }
            else
            {
                ChkOut.BusinessSupportST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value);
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
            if (ChkOut.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Update" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOut.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckoutIntermediate_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@CheckOutNo", SqlDbType.Int).Value = ChkOut.CheckOutNo;
            Cmd.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = ChkOut.GuestName;
            Cmd.Parameters.Add("@Stay", SqlDbType.NVarChar).Value = ChkOut.Stay;
            Cmd.Parameters.Add("@Type", SqlDbType.NVarChar).Value = ChkOut.Type;
            Cmd.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = ChkOut.BillDate;
            Cmd.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = ChkOut.BookingLevel;
            Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ChkOut.ClientName;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ChkOut.Property;
            Cmd.Parameters.Add("@ChkOutTariffTotal", SqlDbType.Decimal).Value = ChkOut.TotalTariff;
            Cmd.Parameters.Add("@ChkOutTariffNetAmount", SqlDbType.Decimal).Value = ChkOut.NetAmount;
            Cmd.Parameters.Add("@ChkOutTariffAdays", SqlDbType.Decimal).Value = ChkOut.AdditionalCharge;
            Cmd.Parameters.Add("@ChkOutTariffDiscount", SqlDbType.Decimal).Value = ChkOut.Discountperday;
            Cmd.Parameters.Add("@ChkOutTariffLT", SqlDbType.Decimal).Value = ChkOut.LuxuryTax;
            Cmd.Parameters.Add("@ChkOutTariffST1", SqlDbType.Decimal).Value = ChkOut.SerivceTax;
            Cmd.Parameters.Add("@ChkOutTariffST2", SqlDbType.Decimal).Value = ChkOut.SerivceNet;
            Cmd.Parameters.Add("@ChkOutTariffSC", SqlDbType.Decimal).Value = ChkOut.ServiceCharge;
            Cmd.Parameters.Add("@ChkOutTariffST3", SqlDbType.Decimal).Value = ChkOut.ServiceTaxService;
            Cmd.Parameters.Add("@ChkOutTariffCess", SqlDbType.Decimal).Value = ChkOut.Cess;
            Cmd.Parameters.Add("@ChkOutTariffHECess", SqlDbType.Decimal).Value = ChkOut.HECess;
            Cmd.Parameters.Add("@ChkOutTariffReferance", SqlDbType.NVarChar).Value = ChkOut.Referance;
            Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = ChkOut.Name;
            Cmd.Parameters.Add("@ChkOutTariffExtraType", SqlDbType.NVarChar).Value = ChkOut.ExtraType;
            Cmd.Parameters.Add("@CheckOutTariffExtraDays", SqlDbType.Int).Value = ChkOut.ExtraDays;
            Cmd.Parameters.Add("@ChkOutTariffExtraAmount", SqlDbType.Decimal).Value = ChkOut.ExtraAmount;
            Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = ChkOut.ChkInHdrId;
            Cmd.Parameters.Add("@NoOfDays", SqlDbType.Int).Value = ChkOut.NoOfDays;
            Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = ChkOut.RoomId;
            Cmd.Parameters.Add("@BedId", SqlDbType.Int).Value = ChkOut.BedId;
            Cmd.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = ChkOut.ApartmentId;
            Cmd.Parameters.Add("@CheckInType", SqlDbType.NVarChar).Value = ChkOut.CheckInType;
            Cmd.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value = ChkOut.ApartmentNo;
            Cmd.Parameters.Add("@BedNo", SqlDbType.NVarChar).Value = ChkOut.BedNo;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = ChkOut.PropertyId;
            Cmd.Parameters.Add("@BookingId", SqlDbType.Int).Value = ChkOut.BookingId;
            Cmd.Parameters.Add("@GuestId", SqlDbType.Int).Value = ChkOut.GuestId;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = ChkOut.StateId;
            Cmd.Parameters.Add("@Direct", SqlDbType.NVarChar).Value = ChkOut.Direct;
            Cmd.Parameters.Add("@BTC", SqlDbType.NVarChar).Value = ChkOut.BTC;
            Cmd.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = ChkOut.PropertyType;
            Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = ChkOut.Status;
            Cmd.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = ChkOut.CheckInDate;
            Cmd.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = ChkOut.CheckOutDate;
            Cmd.Parameters.Add("@InVoiceNo", SqlDbType.NVarChar).Value = ChkOut.InVoiceNo;
            Cmd.Parameters.Add("@STAgreedAmount", SqlDbType.Decimal).Value = ChkOut.STAgreedAmount;
            Cmd.Parameters.Add("@STRackAmount", SqlDbType.Decimal).Value = ChkOut.STRackAmount;
            Cmd.Parameters.Add("@LTAgreedAmount", SqlDbType.Decimal).Value = ChkOut.LTAgreedAmount;
            Cmd.Parameters.Add("@LTRackAmount", SqlDbType.Decimal).Value = ChkOut.LTRackAmount;
            Cmd.Parameters.Add("@LTTaxPer", SqlDbType.Decimal).Value = ChkOut.LTTaxPer;
            Cmd.Parameters.Add("@STTaxPer", SqlDbType.Decimal).Value = ChkOut.STTaxPer;
            Cmd.Parameters.Add("@VATPer", SqlDbType.Decimal).Value = ChkOut.VATPer;
            Cmd.Parameters.Add("@RestaurantSTPer", SqlDbType.Decimal).Value = ChkOut.RestaurantSTPer;
            Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.Decimal).Value = ChkOut.BusinessSupportST;
            Cmd.Parameters.Add("@ClientId", SqlDbType.Int).Value = ChkOut.ClientId;
            Cmd.Parameters.Add("@CityId", SqlDbType.Int).Value = ChkOut.CityId;
            Cmd.Parameters.Add("@ServiceChargeChk", SqlDbType.Int).Value = ChkOut.ServiceChargeChk;
            Cmd.Parameters.Add("@BillFromDate", SqlDbType.NVarChar).Value = ChkOut.BillFromDate;
            Cmd.Parameters.Add("@BillEndDate", SqlDbType.NVarChar).Value = ChkOut.BillEndDate;
            Cmd.Parameters.Add("@Intermediate", SqlDbType.NVarChar).Value = ChkOut.Intermediate;
            Cmd.Parameters.Add("@Preformainvoice", SqlDbType.Bit).Value = ChkOut.Preformainvoice;
            Cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = ChkOut.Email;
            Cmd.Parameters.Add("@TariffPaymentMode", SqlDbType.NVarChar).Value = ChkOut.TariffPaymentMode;
            Cmd.Parameters.Add("@BookingType", SqlDbType.NVarChar).Value = ChkOut.BookingType;
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
                "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Help" + ", ProcName:'" + StoredProcedures.CheckoutIntermediate_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.CheckoutIntermediate_Help;
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
