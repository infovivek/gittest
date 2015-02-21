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

    public class ExternalIntermediateCheckOutDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            ExternalIntermediateCheckOut ExChkOut = new ExternalIntermediateCheckOut();
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
                    "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.ExterInterCheckOutHdr_Insert;

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
            //  document.LoadXml(data[2].ToString());
            //int m=(document).SelectNodes("GrdXml").Count;
            //if (m > 0)
            //{


            //}
            if ((ExChkOut.PropertyType != "Managed G H") && (ExChkOut.PropertyType != "DdP"))
            {
                if (ExChkOut.BTC != "Bill to Company (BTC)")// || (ExChkOut.BTC ! ="Bill to Client"))
                {
                    if (ExChkOut.BTC != "Bill to Client")
                    {
                        document.LoadXml(data[2].ToString());
                        int n = (document).SelectNodes("GrdXml").Count;
                        if (n > 0)
                        {
                            if (ExChkOut.Direct == "Direct")
                            {
                                if (ExChkOut.PrintInvoice == false)
                                {

                                    //     return ds; 
                                    int ChkOutHdrId;
                                    ChkOutHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);


                                    document.LoadXml(data[2].ToString());
                                    ExChkOut.ChkOutHdrId = ChkOutHdrId;// Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["ChkOutHdrId"].Value);
                                    ExChkOut.TACInvoiceNo = document.SelectSingleNode("GrdXml").Attributes["TACInvoiceNo"].Value;
                                    ExChkOut.TACInvoiceFile = document.SelectSingleNode("GrdXml").Attributes["TACInvoiceFile"].Value;
                                    ExChkOut.GuestName1 = document.SelectSingleNode("GrdXml").Attributes["GuestName"].Value;
                                    //       ExChkOut.Stay1 = document.SelectSingleNode("GrdXml").Attributes["Stay"].Value;
                                    //       ExChkOut.Type1 = document.SelectSingleNode("GrdXml").Attributes["Type"].Value;
                                    //       ExChkOutTAC.BookingLevel = doc.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
                                    ExChkOut.BillDate1 = document.SelectSingleNode("GrdXml").Attributes["BillDate"].Value;
                                    ExChkOut.ClientName1 = document.SelectSingleNode("GrdXml").Attributes["ClientName"].Value;
                                    ExChkOut.Property1 = document.SelectSingleNode("GrdXml").Attributes["Property"].Value;
                                    if (document.SelectSingleNode("GrdXml").Attributes["TotalTariff"].Value == "")
                                    {
                                        ExChkOut.TotalTariff1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.TotalTariff1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["TotalTariff"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["NetAmount"].Value == "")
                                    {
                                        ExChkOut.NetAmount1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.NetAmount1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["NetAmount"].Value);
                                    }
                                    //if (document.SelectSingleNode("GrdXml").Attributes["SerivceTax"].Value == "")
                                    //{
                                    //    ExChkOut.SerivceTax1 = 0;
                                    //}
                                    //else
                                    //{
                                    //    ExChkOut.SerivceTax1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["SerivceTax"].Value);
                                    //}

                                    if (document.SelectSingleNode("GrdXml").Attributes["Cess"].Value == "")
                                    {
                                        ExChkOut.Cess1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.Cess1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["Cess"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["HECess"].Value == "")
                                    {
                                        ExChkOut.HECess1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.HECess1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["HECess"].Value);
                                    }
                                    ExChkOut.Referance1 = document.SelectSingleNode("GrdXml").Attributes["Referance"].Value;

                                    ExChkOut.Id1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["Id"].Value);
                                    ExChkOut.ChkInHdrId1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["ChkInHdrId"].Value);
                                    ExChkOut.NoOfDays1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["NoOfDays"].Value);
                                    ExChkOut.RoomId1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["RoomId"].Value);

                                    ExChkOut.PropertyId1 = Convert.ToInt64(document.SelectSingleNode("GrdXml").Attributes["PropertyId"].Value);
                                    ExChkOut.BookingId1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["BookingId"].Value);
                                    ExChkOut.GuestId1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["GuestId"].Value);
                                    ExChkOut.StateId1 = Convert.ToInt32(document.SelectSingleNode("GrdXml").Attributes["StateId"].Value);
                                    ExChkOut.Direct1 = document.SelectSingleNode("GrdXml").Attributes["Direct"].Value;

                                    ExChkOut.PropertyType1 = document.SelectSingleNode("GrdXml").Attributes["PropertyType"].Value;
                                    ExChkOut.CheckInDate1 = document.SelectSingleNode("GrdXml").Attributes["CheckInDate"].Value;
                                    ExChkOut.CheckOutDate1 = document.SelectSingleNode("GrdXml").Attributes["CheckOutDate"].Value;
                                    ExChkOut.Status1 = document.SelectSingleNode("GrdXml").Attributes["Status"].Value;
                                    if (document.SelectSingleNode("GrdXml").Attributes["MarkUpAmount"].Value == "")
                                    {
                                        ExChkOut.MarkUpAmount1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.MarkUpAmount1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["MarkUpAmount"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["BusinessSupportST"].Value == "")
                                    {
                                        ExChkOut.BusinessSupportST1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.BusinessSupportST1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["BusinessSupportST"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["Rate"].Value == "")
                                    {
                                        ExChkOut.Rate1 = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.Rate1 = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["Rate"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["TotalBusinessSupportST"].Value == "")
                                    {
                                        ExChkOut.TotalBusinessSupportST = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.TotalBusinessSupportST = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["TotalBusinessSupportST"].Value);
                                    }
                                    if (document.SelectSingleNode("GrdXml").Attributes["TACAmount"].Value == "")
                                    {
                                        ExChkOut.TACAmount = 0;
                                    }
                                    else
                                    {
                                        ExChkOut.TACAmount = Convert.ToDecimal(document.SelectSingleNode("GrdXml").Attributes["TACAmount"].Value);
                                    }
                                    ExChkOut.BillFromDate1 = doc.SelectSingleNode("HdrXml").Attributes["BillFromDate"].Value;
                                    ExChkOut.BillEndDate1 = doc.SelectSingleNode("HdrXml").Attributes["BillEndDate"].Value;
                                    ExChkOut.Intermediate1 = doc.SelectSingleNode("HdrXml").Attributes["Intermediate"].Value;
                  //                  ExChkOut.Email1 = doc.SelectSingleNode("HdrXml").Attributes["Email"].Value;
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
                                            "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Insert" + ", ProcName:'" + StoredProcedures.CheckOutHdr_Insert;

                                        Mode = "Save";
                                        Cmd.CommandText = StoredProcedures.ExterInterCheckOutTAC_Insert;

                                    }
                                    Cmd.CommandType = CommandType.StoredProcedure;
                                    Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ExChkOut.ChkOutHdrId;
                                    Cmd.Parameters.Add("@TACInvoiceNo", SqlDbType.NVarChar).Value = ExChkOut.TACInvoiceNo;
                                    Cmd.Parameters.Add("@TACInvoiceFile", SqlDbType.NVarChar).Value = ExChkOut.TACInvoiceFile;
                                    Cmd.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = ExChkOut.GuestName1;
                                    //Cmd.Parameters.Add("@Stay", SqlDbType.NVarChar).Value = ExChkOut.Stay1;
                                    //Cmd.Parameters.Add("@Type", SqlDbType.NVarChar).Value = ExChkOut.Type1;
                                    Cmd.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = ExChkOut.BillDate1;
                                    //      Cmd.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = ExChkOutTAC.BookingLevel;
                                    Cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ExChkOut.ClientName1;
                                    Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ExChkOut.Property1;
                                    Cmd.Parameters.Add("@ChkOutTariffTotal", SqlDbType.Decimal).Value = ExChkOut.TotalTariff1;
                                    Cmd.Parameters.Add("@ChkOutTariffNetAmount", SqlDbType.Decimal).Value = ExChkOut.NetAmount1;
                                    // Cmd.Parameters.Add("@ChkOutTariffST", SqlDbType.Decimal).Value = ExChkOut.SerivceTax1;
                                    //      Cmd.Parameters.Add("@ChkOutTariffST2", SqlDbType.Decimal).Value = ExChkOutTAC.SerivceNet;
                                    Cmd.Parameters.Add("@ChkOutTariffCess", SqlDbType.Decimal).Value = ExChkOut.Cess1;
                                    Cmd.Parameters.Add("@ChkOutTariffHECess", SqlDbType.Decimal).Value = ExChkOut.HECess1;
                                    Cmd.Parameters.Add("@ChkOutTariffReferance", SqlDbType.NVarChar).Value = ExChkOut.Referance1;
                                    //     Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = ExChkOutTAC.Name;
                                    Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = ExChkOut.ChkInHdrId1;
                                    Cmd.Parameters.Add("@NoOfDays", SqlDbType.Int).Value = ExChkOut.NoOfDays1;
                                    Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = ExChkOut.RoomId1;
                                    Cmd.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = ExChkOut.PropertyId1;
                                    Cmd.Parameters.Add("@BookingId", SqlDbType.Int).Value = ExChkOut.BookingId1;
                                    Cmd.Parameters.Add("@GuestId", SqlDbType.Int).Value = ExChkOut.GuestId1;
                                    Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = ExChkOut.StateId1;
                                    Cmd.Parameters.Add("@Direct", SqlDbType.NVarChar).Value = ExChkOut.Direct1;
                                    //     Cmd.Parameters.Add("@BTC", SqlDbType.NVarChar).Value = ExChkOutTAC.BTC;
                                    Cmd.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = ExChkOut.PropertyType1;
                                    Cmd.Parameters.Add("@CheckInDate", SqlDbType.NVarChar).Value = ExChkOut.CheckInDate1;
                                    Cmd.Parameters.Add("@CheckOutDate", SqlDbType.NVarChar).Value = ExChkOut.CheckOutDate1;
                                    Cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = ExChkOut.Status1;
                                    Cmd.Parameters.Add("@MarkUpAmount", SqlDbType.Decimal).Value = ExChkOut.MarkUpAmount1;
                                    Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.Decimal).Value = ExChkOut.BusinessSupportST1;
                                    Cmd.Parameters.Add("@Rate", SqlDbType.Decimal).Value = ExChkOut.Rate1;
                                    Cmd.Parameters.Add("@TotalBusinessSupportST", SqlDbType.Decimal).Value = ExChkOut.TotalBusinessSupportST;
                                    Cmd.Parameters.Add("@TACAmount", SqlDbType.Decimal).Value = ExChkOut.TACAmount;
                                    Cmd.Parameters.Add("@BillFromDate", SqlDbType.NVarChar).Value = ExChkOut.BillFromDate1;
                                    Cmd.Parameters.Add("@BillEndDate", SqlDbType.NVarChar).Value = ExChkOut.BillEndDate1;
                                    Cmd.Parameters.Add("@Intermediate", SqlDbType.NVarChar).Value = ExChkOut.Intermediate1;
                         //           Cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = ExChkOut.Email1;
                                    Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                                    ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);

                                    // if (ExChkOut.NetAmount1 != 0) // Mail 
                                    // {
                                    //     //for mail to direct mode
                                    //     string Valid = ""; string Err = "";
                                    ////     string Email = "shiv@hummingbirdindia.com";
                                    //     string Email = "shameem@warblerit.com";
                                    //     Valid = EmailValidate(Email);

                                    //     if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
                                    //     {

                                    //         System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                                    //         message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
                                    //         if (Valid == "True")
                                    //         {
                                    //             message.To.Add(new System.Net.Mail.MailAddress(Email));
                                    //         }
                                    //         else
                                    //         {
                                    //             Err = "";
                                    //         }
                                    //    //     message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                                    //    //     message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
                                    //    //     message.Bcc.Add(new System.Net.Mail.MailAddress("silam@hummingbirdindia.com"));
                                    //    //     message.Bcc.Add(new System.Net.Mail.MailAddress("karthik@hummingbirdindia.com"));

                                    //         message.Subject = ds.Tables[0].Rows[0][4].ToString();
                                    //         //string Imagelocation = "";
                                    //         //{
                                    //         //    if (ds.Tables[1].Rows[0][0].ToString() != "")
                                    //         //        Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                                    //         //}

                                    //         message.Body = "";
                                    //         string Imagebody =
                                    //            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                                    //            " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                                    //            " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                                    //             //  " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
                                    //            " </td></tr></table>";
                                    //         string Header =
                                    //                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                    //                   " <tr style=\"font-size:12px; \">" +
                                    //                   " <td width=\"600\" style=\"padding:12px 5px;\">" +
                                    //                   " <p style=\"margin-top:20px;\">" +
                                    //                   " <span> System generated email. Please do not reply. </span>" +
                                    //                   " <style=\"margin-top:20px;\">" +
                                    //                   " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][2].ToString() + "</span><br>" +
                                    //                   " </td></tr></table>";
                                    //         string AddressDtls =
                                    //                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                                    //                    " <tr style=\"font-size:12px;\">" +
                                    //                    " <td width=\"600\" style=\"padding:3px 5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Invoice No                 : </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <p style=\"margin-top:20px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Guest Name                 :</span> " + ExChkOut.GuestName1 + "  <br>" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">CheckIn Date               :</span> " + ExChkOut.CheckInDate1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">CheckOut Date              :</span> " + ExChkOut.CheckOutDate1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name              :</span> " + ExChkOut.Property1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Client Name                :</span> " + ExChkOut.ClientName1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">TAC Amount                 :</span> " + ExChkOut.Rate1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">No Of Days                 :</span> " + ExChkOut.NoOfDays1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Total Amount               :</span> " + ExChkOut.MarkUpAmount1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Business Service Tax(12%)  :</span> " + ExChkOut.TotalBusinessSupportST + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Cess 2%                    :</span> " + ExChkOut.Cess1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">HCess 1%                   :</span> " + ExChkOut.HECess1 + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " <span style=\"color:#f54d02; font-weight:bold\">Net Amount                 :</span> " + ExChkOut.TACAmount + "" +
                                    //                    " </p><p style=\"margin-top:5px;\">" +
                                    //                    " </p></td></tr></table>";

                                    //         string FooterDtls =
                                    //            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                                    //            " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                                    //            " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                                    //            " Team Stay Simplyfied </p> " + " <br>" +
                                    //             //   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                                    //             //   " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" +// Disclaimer + "</p>" +
                                    //            " </td></tr> </table>";

                                    //         message.Body = Imagebody + Header + AddressDtls + FooterDtls;
                                    //         message.IsBodyHtml = true;



                                    //         System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                                    //         smtp.EnableSsl = true;
                                    //         smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                                    //         smtp.Port = 587;
                                    //         smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                                    //         try
                                    //         {
                                    //             smtp.Send(message);
                                    //         }
                                    //         catch (Exception ex)
                                    //         {
                                    //             CreateLogFiles log = new CreateLogFiles();
                                    //             log.ErrorLog(ex.Message + " -->External Checkout --> " + message.Subject);
                                    //         }
                                    //     }
                                    // }//Mail Close 
                                }
                            }
                        }
                    }

                }
            }
            
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
                "', SctId:" + user.SctId + ", Service:GuestCheckOutDao Help" + ", ProcName:'" + StoredProcedures.Checkout_Help;

            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.ExternalChkoutIntermediate_Help;
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
