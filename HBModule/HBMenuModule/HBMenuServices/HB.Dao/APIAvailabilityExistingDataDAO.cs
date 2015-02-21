using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using HB.Entity;
using System.Xml;

namespace HB.Dao
{
    public class APIAvailabilityExistingDataDAO
    {
        SqlCommand command = new SqlCommand();
        bool Flag = true;
        string FlagStr = "";
        DataSet ds = new DataSet();
        string UserData = "";
        string UpdateTariffFlag = "";
        public DataSet FnAvailabilityExistingData(string[] data, User User)
        {
            try
            {
                UserData = "UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName +
                       ", SctId : " + User.SctId + ", Service : APIAvailabilityExistingDataDAO" +
                       ", ProcName: " + StoredProcedures.API_Help;
                //
                APIDynamic api = new APIDynamic();
                api.CityCode = data[2].ToString();
                api.HotelId = data[3].ToString();
                api.RatePlanCode = data[4].ToString();
                api.RoomTypecode = data[5].ToString();                
                string d1 = data[6].ToString();
                string d2 = data[7].ToString();
                api.FrmDt = d1.Substring(0, 10);
                api.ToDt = d2.Substring(0, 10);
                api.HeaderId = Convert.ToInt32(data[8].ToString());
                DateTime dt1 = Convert.ToDateTime(api.FrmDt);
                DateTime dt2 = Convert.ToDateTime(api.ToDt);
                double dys = (dt2 - dt1).TotalDays;
                int CntDys = Convert.ToInt32(dys);
                int GstCnt = Convert.ToInt32(data[9].ToString());
                int RoomAvaCnt = 0;
                WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelAvailability");
                HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                httpRequest.Method = "POST";
                httpRequest.ContentType = "application/xml; charset=utf-8";
                httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                httpRequest.ProtocolVersion = HttpVersion.Version11;
                httpRequest.Credentials = CredentialCache.DefaultCredentials;
                httpRequest.Timeout = 100000000;
                Stream requestStream = httpRequest.GetRequestStream();
                //Create Stream and Complete Request             
                StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                soapRequest.Append("<MMTHotelAvailRequest>");
                soapRequest.Append("<POS>");
                //soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // Test
                soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // Live
                soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
                soapRequest.Append("</POS>");
                soapRequest.Append("<ResultTransformer>");
                soapRequest.Append("<CancellationPolicyRulesReq text=\"yes\"/>");
                soapRequest.Append("</ResultTransformer>");
                soapRequest.Append("<HotelAvailabilityCriteria>");
                soapRequest.Append("<Area>");
                soapRequest.Append("<CityCode>");
                soapRequest.Append(api.CityCode);
                soapRequest.Append("</CityCode>");
                //soapRequest.Append("<CityCode>TCC</CityCode>");
                soapRequest.Append("<CountryCode>IN</CountryCode>");
                soapRequest.Append("</Area>");
                soapRequest.Append("<HotelRef id='" + api.HotelId + "'/>");
                soapRequest.Append("<RatePlan code='" + api.RatePlanCode + "'/>");
                soapRequest.Append("<RoomType code='" + api.RoomTypecode + "'/>");
                // single & double room added
                soapRequest.Append("<RoomStayCandidates>");
                soapRequest.Append("<RoomStayCandidate>");
                soapRequest.Append("<GuestCounts>");
                soapRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                soapRequest.Append("</GuestCounts>");
                soapRequest.Append("</RoomStayCandidate>");
                soapRequest.Append("<RoomStayCandidate>");
                soapRequest.Append("<GuestCounts>");
                soapRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                soapRequest.Append("</GuestCounts>");
                soapRequest.Append("</RoomStayCandidate>");
                soapRequest.Append("</RoomStayCandidates>");
                //soapRequest.Append("<StayDateRange start="2014-10-10" end="2014-10-11"/>");
                soapRequest.Append("<StayDateRange start='" + api.FrmDt + "' end='" + api.ToDt + "'/>");
                soapRequest.Append("</HotelAvailabilityCriteria>");
                soapRequest.Append("</MMTHotelAvailRequest>");
                streamWriter.Write(soapRequest.ToString());
                streamWriter.Close();
                //Get the Response
                HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                StreamReader srd = new StreamReader(wr.GetResponseStream());
                string ResponseXML = srd.ReadToEnd();
                //
                //JObject dynObj = JObject.Parse(ResponseXML); 
                //
                command = new SqlCommand();
                XmlDocument document = new XmlDocument();
                document.LoadXml(ResponseXML);
                int n = 0; 
                Flag = true;
                n = document.SelectNodes("//Hotel").Count;
                if (n != 0)
                {
                    api.AvaavailStatus = document.SelectNodes("//RoomRate")[0].Attributes["availStatus"].Value;
                    try
                    {
                        RoomAvaCnt = Convert.ToInt32(document.SelectNodes("//RoomRate")[0].Attributes["availableCount"].Value);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> API Availability Existing Data --> Room Avaliable Count is Empty.");
                        RoomAvaCnt = 0;
                    }                    
                    if (api.AvaavailStatus == "B")
                    {
                        decimal RoomRate1 = 0, RoomRate2 = 0, RoomDiscount1 = 0, RoomDiscount2 = 0;
                        decimal Taxes1 = 0, Taxes2 = 0;
                        XmlNodeList XmlRoomTariffs1 = document.DocumentElement.SelectNodes("/MMTHotelAvailResponse/Hotel/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate/Rate/RoomTariffs/RoomTariff");
                        foreach (XmlNode xnRT in XmlRoomTariffs1)
                        {
                            //string RoomTariffs = xnRT.InnerXml;XmlDocument XmlDoc = new XmlDocument();XmlDoc.LoadXml(RoomTariffs);
                            string RoomTariffs1 = xnRT.OuterXml;
                            XmlDocument XmlDoc1 = new XmlDocument();
                            XmlDoc1.LoadXml(RoomTariffs1);                            
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "1")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes1 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                            if (XmlDoc1.SelectNodes("//RoomTariff ")[0].Attributes["roomNumber"].Value == "2")
                            {
                                int cnt = XmlDoc1.SelectNodes("//Tariff").Count;
                                for (int x = 0; x < cnt; x++)
                                {
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomRate")
                                    {
                                        RoomRate2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "RoomDiscount")
                                    {
                                        RoomDiscount2 =
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                    if (XmlDoc1.SelectNodes("//Tariff")[x].Attributes["group"].Value == "Taxes")
                                    {
                                        Taxes2 = 
                                            Convert.ToDecimal(XmlDoc1.SelectNodes("//Tariff")[x].Attributes["amount"].Value);
                                    }
                                }
                            }
                        }                        
                        command = new SqlCommand();
                        ds = new DataSet();
                        command.CommandText = StoredProcedures.API_Help;
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "SingleDoubleRateLoad";
                        command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                        command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                        command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                        command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                        command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = api.HeaderId;
                        command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                        command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                        ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                        // ROOM RATE
                        decimal RoomNo1Existsamt = Convert.ToDecimal(ds.Tables[0].Rows[0][0].ToString()) * CntDys;
                        decimal RoomNo2Existsamt = Convert.ToDecimal(ds.Tables[1].Rows[0][0].ToString()) * CntDys;
                        // ROOM TAX
                        decimal RoomNo1ExistsTaxamt = 0;
                        if (ds.Tables[2].Rows.Count > 0)
                        {
                            RoomNo1ExistsTaxamt = Convert.ToDecimal(ds.Tables[2].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2ExistsTaxamt = 0;
                        if (ds.Tables[3].Rows.Count > 0)
                        {
                            RoomNo2ExistsTaxamt = Convert.ToDecimal(ds.Tables[3].Rows[0][0].ToString()) * CntDys;
                        }
                        // ROOM discount
                        decimal RoomNo1Existsdiscountamt = 0;
                        if (ds.Tables[4].Rows.Count > 0)
                        {
                            RoomNo1Existsdiscountamt = Convert.ToDecimal(ds.Tables[4].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal RoomNo2Existsdiscountamt = 0;
                        if (ds.Tables[5].Rows.Count > 0)
                        {
                            RoomNo2Existsdiscountamt = Convert.ToDecimal(ds.Tables[5].Rows[0][0].ToString()) * CntDys;
                        }
                        decimal diff = Convert.ToDecimal(ds.Tables[6].Rows[0][0].ToString());
                        //
                        FlagStr = "";
                        //
                        decimal Rate1diff = Math.Abs(RoomNo1Existsamt - RoomRate1);
                        decimal Rate2diff = Math.Abs(RoomNo2Existsamt - RoomRate2);
                        decimal Tax1diff = Math.Abs(RoomNo1ExistsTaxamt - Taxes1);
                        decimal Tax2diff = Math.Abs(RoomNo2ExistsTaxamt - Taxes2);
                        decimal Discount1diff = Math.Abs(RoomNo1Existsdiscountamt - RoomDiscount1);
                        decimal Discount2diff = Math.Abs(RoomNo2Existsdiscountamt - RoomDiscount2);
                        if ((Rate1diff < diff) && (Rate2diff < diff) && (Tax1diff < diff) && (Tax2diff < diff) &&
                            (Discount1diff < diff) && (Discount2diff < diff) && (RoomAvaCnt >= GstCnt))
                        {
                            Flag = true;
                        }
                        else
                        {
                            Flag = false; UpdateTariffFlag = "123";
                            // Tariff is Changed for this Hotel.
                            FlagStr = "Tariff is Changed.";
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = StoredProcedures.API_Help;
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTTariffTaxesUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomRate1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomRate2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = Math.Round(Taxes1 / CntDys);
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = Math.Round(Taxes2 / CntDys);
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            command = new SqlCommand();
                            ds = new DataSet();
                            command.CommandText = StoredProcedures.API_Help;
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTDiscountUpdate";
                            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomDiscount1 / CntDys);
                            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomDiscount2 / CntDys);
                            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            //if ((RoomDiscount1 != 0) || (RoomDiscount2 != 0))
                            //{
                            //    command = new SqlCommand();
                            //    ds = new DataSet();
                            //    command.CommandText = StoredProcedures.API_Help;
                            //    command.CommandType = CommandType.StoredProcedure;
                            //    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "MMTDiscountUpdate";
                            //    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = api.HotelId;
                            //    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = api.RatePlanCode;
                            //    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = api.RoomTypecode;
                            //    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = api.HeaderId;
                            //    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Math.Round(RoomDiscount1 / CntDys);
                            //    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Math.Round(RoomDiscount2 / CntDys);
                            //    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                            //    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                            //    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            //}
                        }
                    }
                    else
                    {
                        Flag = false; UpdateTariffFlag = "";
                        // Room is Not Avaliable for this Date Range.
                        FlagStr = "Room is Not Avaliable";
                    }
                }
                else
                {
                    Flag = false; UpdateTariffFlag = "";
                    // Hotel is Not Avaliable for this Date Range.
                    FlagStr = "Hotel is Not Avaliable";
                }
            }
            catch(Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> API Availability Existing Data.");
                Flag = false;
                FlagStr = "Error";
            }
            if (Flag == false)
            {
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.API_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "FalseFlagLoad";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = FlagStr;
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = UpdateTariffFlag;
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                /*DataTable dT1 = new DataTable("DBERRORTBL");
                ds.Tables.Add(dT1);
                DataTable dTable = new DataTable("ERRORTBL");
                dTable.Columns.Add("Exception");
                DataTable dT = new DataTable("Table");
                dT.Columns.Add("Str");*/
            }
            else
            {
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.API_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "TrueFlagLoad";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }
    }
}
