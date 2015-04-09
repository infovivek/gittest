using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.IO;
using System.Net;
using System.Xml;
using System.Text.RegularExpressions;

namespace HB.Dao
{
    public class APICreateReservationDAO
    {
        string UserData = "";
        User user = new User();
        DataSet ds = new DataSet();
        SqlCommand command = new SqlCommand();
        bool flg = true;
        string FlagStr = "";
        CreateLogFiles log = new CreateLogFiles();
        public DataSet FnCreateReservation(string[] data, User Usr)
        {
            //DataSet asd = new DataSet();DataTable asddT = new DataTable("Table");asddT.Columns.Add("Str");asddT.Columns.Add("Str1");asddT.Rows.Add("No", "No1");ds.Tables.Add(asddT);return ds;            
            string Step = "";
            //DataTable dT = new DataTable("Table1");
            //dT.Columns.Add("Str");
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                       ", SctId : " + user.SctId + ", Service : APICreateReservationDAO" +
                       ", ProcName: " + StoredProcedures.API_Help;
            //
            command = new SqlCommand();
            ds = new DataSet();
            command.CommandText = StoredProcedures.API_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            APIDynamic api = new APIDynamic();
            //
            try
            {
                api.BookingId = Convert.ToInt32(data[6].ToString());
                api.CityCode = ds.Tables[0].Rows[0][0].ToString();
                api.HotelId = ds.Tables[0].Rows[0][1].ToString();
                api.PtyRatePlancode = ds.Tables[0].Rows[0][2].ToString();
                api.PtyRoomTypecode = ds.Tables[0].Rows[0][3].ToString();
                api.start = ds.Tables[0].Rows[0][4].ToString();
                api.End = ds.Tables[0].Rows[0][5].ToString();
                api.singlecnt = Convert.ToInt32(ds.Tables[0].Rows[0][6].ToString());
                api.doublecnt = Convert.ToInt32(ds.Tables[0].Rows[0][7].ToString());                
                //
                //string pattern = @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
                //Regex.IsMatch(api.Surname, pattern);
                //System.Text.RegularExpressions.Match match = Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                //
                Step = "Availability Request";
                //
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
                //soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // test
                soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
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
                soapRequest.Append("<RatePlan code='" + api.PtyRatePlancode + "'/>");
                soapRequest.Append("<RoomType code='" + api.PtyRoomTypecode + "'/>");
                // single & double room added
                soapRequest.Append("<RoomStayCandidates>");
                if (api.singlecnt > 0)
                {
                    for (int i = 0; i < api.singlecnt; i++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                if (api.doublecnt > 0)
                {
                    for (int j = 0; j < api.doublecnt; j++)
                    {
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                    }
                }
                soapRequest.Append("</RoomStayCandidates>");
                //soapRequest.Append("<StayDateRange start="2014-10-10" end="2014-10-11"/>");
                soapRequest.Append("<StayDateRange start='" + api.start + "' end='" + api.End + "'/>");
                soapRequest.Append("</HotelAvailabilityCriteria>");
                soapRequest.Append("</MMTHotelAvailRequest>");
                streamWriter.Write(soapRequest.ToString());
                streamWriter.Close();
                //Get the Response
                HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                StreamReader srd = new StreamReader(wr.GetResponseStream());
                string ResponseXML = srd.ReadToEnd();
                command = new SqlCommand();
                XmlDocument document = new XmlDocument();
                //document.LoadXml(NewHeader);
                document.LoadXml(ResponseXML);
                int n = 0;
                n = document.SelectNodes("//Hotel").Count;
                if (n != 0)
                {
                    Step = "Availability Response";
                    api.AvaavailStatus = document.SelectNodes("//RoomRate")[0].Attributes["availStatus"].Value;
                    if (api.AvaavailStatus == "B")
                    {
                        api.AvaRatePlanCode = document.SelectNodes("//RoomRate")[0].Attributes["ratePlanCode"].Value;
                        //api.AvaRoomTypecode = document.SelectNodes("//RoomRate")[0].Attributes["roomTypeCode"].Value;
                        //
                        api.AmountAfterTax = Convert.ToDecimal(document.SelectNodes("//AmountAfterTax")[0].InnerText);
                        api.AmountBeforeTax = Convert.ToDecimal(document.SelectNodes("//AmountBeforeTax")[0].InnerText);
                        api.AvaResponseCode = document.SelectNodes("//ResponseCode")[0].Attributes["success"].Value;
                        api.AvaResponseReferenceKey = document.SelectNodes("//ResponseReferenceKey")[0].InnerText;
                        //
                        if (api.AvaResponseCode == "true")
                        {
                            Step = "Book Hotel Request";
                            WebRequest webRequest1 = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/book/v1.0/bookHotels");
                            HttpWebRequest httpRequest1 = (HttpWebRequest)webRequest1;
                            httpRequest1.Method = "POST";
                            httpRequest1.ContentType = "application/xml; charset=utf-8";
                            httpRequest1.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                            //httpRequest1.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b"); // test
                            httpRequest1.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                            httpRequest1.ProtocolVersion = HttpVersion.Version11;
                            httpRequest1.Credentials = CredentialCache.DefaultCredentials;
                            httpRequest1.Timeout = 100000000;
                            Stream requestStream1 = httpRequest1.GetRequestStream();
                            //Create Stream and Complete Request             
                            StreamWriter streamWriter1 = new StreamWriter(requestStream1, Encoding.ASCII);
                            StringBuilder BookRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                            BookRequest.Append("<MMTHotelReservationRequest>");
                            BookRequest.Append("<POS>");
                            //BookRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2BWeb\"/>"); // test
                            BookRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
                            BookRequest.Append("<Source iSOCurrency=\"INR\"/>");
                            BookRequest.Append("</POS>");
                            BookRequest.Append("<HotelReservation>");
                            BookRequest.Append("<Criterion>");
                            BookRequest.Append("<Area>");
                            //BookRequest.Append("<CityCode>TCC</CityCode>");
                            BookRequest.Append("<CityCode>");
                            BookRequest.Append(api.CityCode);
                            BookRequest.Append("</CityCode>");
                            BookRequest.Append("<CountryCode>IN</CountryCode>");
                            BookRequest.Append("</Area>");
                            BookRequest.Append("<HotelRef id='" + api.HotelId + "' idContext=\"\"/>");
                            BookRequest.Append("<RatePlan code='" + api.AvaRatePlanCode + "'/>");
                            BookRequest.Append("<RoomType code='" + api.PtyRoomTypecode + "'/>");
                            BookRequest.Append("<RoomStayCandidates>");
                            if (api.singlecnt > 0)
                            {
                                for (int i = 0; i < api.singlecnt; i++)
                                {
                                    BookRequest.Append("<RoomStayCandidate>");
                                    BookRequest.Append("<GuestCounts>");
                                    BookRequest.Append("<GuestCount count='1' ageQualifyingCode='10'/>");
                                    BookRequest.Append("</GuestCounts>");
                                    BookRequest.Append("</RoomStayCandidate>");
                                }
                            }
                            if (api.doublecnt > 0)
                            {
                                for (int j = 0; j < api.doublecnt; j++)
                                {
                                    BookRequest.Append("<RoomStayCandidate>");
                                    BookRequest.Append("<GuestCounts>");
                                    BookRequest.Append("<GuestCount count='2' ageQualifyingCode='10'/>");
                                    BookRequest.Append("</GuestCounts>");
                                    BookRequest.Append("</RoomStayCandidate>");
                                }
                            }
                            BookRequest.Append("</RoomStayCandidates>");
                            BookRequest.Append("<Tariff currencyCode='INR' amountBeforeTax='" + api.AmountBeforeTax + "' amountAfterTax='" + api.AmountAfterTax + "'/>");
                            //BookRequest.Append("<StayDateRange start='2014-10-10' end='2014-10-11'/>");
                            BookRequest.Append("<StayDateRange start='" + api.start + "' end='" + api.End + "'/>");
                            BookRequest.Append("</Criterion>");
                            BookRequest.Append("<ReservationGlobalInfo>");
                            BookRequest.Append("<PayAuth ref='' provider='MMT-PG' code='3143318'/>");
                            BookRequest.Append("</ReservationGlobalInfo>");
                            BookRequest.Append("<ReservationGuests>");
                            // GUST BEGIN
                            api.BookEmail = ds.Tables[0].Rows[0][8].ToString();
                            for (int Cnt = 0; Cnt < ds.Tables[0].Rows.Count; Cnt++)
                            {
                                api.GivenName = ds.Tables[0].Rows[Cnt][9].ToString();
                                api.NamePrefix = ds.Tables[0].Rows[Cnt][10].ToString();
                                api.Surname = ds.Tables[0].Rows[Cnt][11].ToString();                             
                                /*string your_String = "Sakthi!@&()''";
                                string my_String = Regex.Replace(your_String, @"[^a-zA-Z]+", "");
                                int len = my_String.Length;*/
                                if (Cnt == 0)
                                {
                                    BookRequest.Append("<ReservationGuest primary=\"true\">");
                                }
                                else
                                {
                                    BookRequest.Append("<ReservationGuest primary=\"false\">");
                                }                                
                                BookRequest.Append("<CustomerAge>30</CustomerAge>");
                                //BookRequest.Append("<Email type='PERSONAL'>hotels-qa@makemytrip.com</Email>");
                                BookRequest.Append("<Email type='PERSONAL'>" + api.BookEmail + "</Email>");
                                BookRequest.Append("<PersonName>");                                
                                BookRequest.Append("<GivenName>" + api.GivenName + "</GivenName>");
                                BookRequest.Append("<NamePrefix>" + api.NamePrefix + "</NamePrefix>");
                                BookRequest.Append("<Surname>" + api.Surname + "</Surname>");
                                BookRequest.Append("</PersonName>");
                                BookRequest.Append("<SpecialRequests>nothing</SpecialRequests>");
                                BookRequest.Append("<Telephone phoneUseType='DAYTIME' phoneTechType='2' phoneNumber='1234567890' areaCityCode=''/>");
                                BookRequest.Append("</ReservationGuest>");
                            }
                            /*BookRequest.Append("<ReservationGuest primary=\"true\">");
                            BookRequest.Append("<CustomerAge>30</CustomerAge>");
                            BookRequest.Append("<Email type='PERSONAL'>hotels-qa@makemytrip.com</Email>");
                            BookRequest.Append("<PersonName>");
                            BookRequest.Append("<GivenName>Test</GivenName>");
                            BookRequest.Append("<NamePrefix>Mr</NamePrefix>");
                            BookRequest.Append("<Surname>Test</Surname>");
                            BookRequest.Append("</PersonName>");                            
                            BookRequest.Append("<SpecialRequests>nothing</SpecialRequests>");
                            BookRequest.Append("<Telephone phoneUseType='DAYTIME' phoneTechType='2' phoneNumber='1234567890' areaCityCode=''/>");
                            BookRequest.Append("</ReservationGuest>");*/
                            // GUST END
                            BookRequest.Append("</ReservationGuests>");
                            BookRequest.Append("</HotelReservation>");
                            BookRequest.Append("<ResponseReferenceKey>" + api.AvaResponseReferenceKey + "</ResponseReferenceKey>");
                            BookRequest.Append("</MMTHotelReservationRequest>");
                            streamWriter1.Write(BookRequest.ToString());
                            streamWriter1.Close();
                            //Get the Response
                            HttpWebResponse wr1 = (HttpWebResponse)httpRequest1.GetResponse();
                            StreamReader srd1 = new StreamReader(wr1.GetResponseStream());
                            string ResponseXML1 = srd1.ReadToEnd();
                            document = new XmlDocument();
                            document.LoadXml(ResponseXML1);
                            //api.HotelId = document.SelectNodes("//HotelRef")[0].Attributes["id"].Value;
                            api.BookResponseCode = document.SelectNodes("//ResponseCode")[0].Attributes["success"].Value;
                            //
                            if (api.BookResponseCode == "true")
                            {
                                Step = "Book Hotel Response";
                                api.BookReservationGlobalInfo = document.SelectNodes("//ReservationGlobalInfo")[0].Attributes["status"].Value;
                                if (api.BookReservationGlobalInfo == "B")
                                {
                                    api.BookHotelReservationIdvalue = document.SelectNodes("//HotelReservationId")[0].Attributes["value"].Value;
                                    api.BookHotelReservationIdtype = document.SelectNodes("//HotelReservationId")[0].Attributes["type"].Value;
                                    //
                                    api.BookResponseReferenceKey = document.SelectNodes("//ResponseReferenceKey")[0].InnerText;
                                    command = new SqlCommand();
                                    ds = new DataSet();
                                    command.CommandText = StoredProcedures.APIPropertyDetails_Update;
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@AvaRatePlanCode", SqlDbType.NVarChar).Value = api.AvaRatePlanCode;
                                    command.Parameters.Add("@AmountAfterTax", SqlDbType.Decimal).Value = api.AmountAfterTax;
                                    command.Parameters.Add("@AmountBeforeTax", SqlDbType.Decimal).Value = api.AmountBeforeTax;
                                    command.Parameters.Add("@AvaResponseReferenceKey", SqlDbType.NVarChar).Value = api.AvaResponseReferenceKey;
                                    command.Parameters.Add("@BookHotelReservationIdvalue", SqlDbType.NVarChar).Value = api.BookHotelReservationIdvalue;
                                    command.Parameters.Add("@BookHotelReservationIdtype", SqlDbType.NVarChar).Value = api.BookHotelReservationIdtype;
                                    command.Parameters.Add("@BookResponseReferenceKey", SqlDbType.NVarChar).Value = api.BookResponseReferenceKey;
                                    command.Parameters.Add("@HotelId", SqlDbType.BigInt).Value = Convert.ToInt64(api.HotelId);
                                    command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = Convert.ToInt32(api.BookingId);
                                    command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                                    //BookRequest.ToString()
                                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    //
                                    //log = new CreateLogFiles();
                                    log = new CreateLogFiles();
                                    log.ErrorLog("M M T BOOKING CONFIRMATION NO --> " + api.BookHotelReservationIdvalue);
                                }
                                else
                                {
                                    //Book Hotel Response - available status is E.                            
                                    flg = false;
                                    FlagStr = "Book Hotel Response - available status is E.";
                                    log = new CreateLogFiles();
                                    log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + FlagStr);
                                }
                            }
                            else
                            {
                                //Book Response Code is False.
                                flg = false;
                                FlagStr = "Book Response Code is False.";
                                log = new CreateLogFiles();
                                log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + FlagStr);
                            }
                        }
                        else
                        {
                            //Availability Available Status is E.                            
                            flg = false;
                            FlagStr = "Availability Available Status is E";
                            log = new CreateLogFiles();
                            log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + FlagStr);
                        }
                    }
                    else
                    {
                        //Availability Response Code is False.
                        flg = false;
                        FlagStr = "Availability Response Code is False.";
                        log = new CreateLogFiles();
                        log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + FlagStr);
                    }
                }
                else
                {
                    //Availability Hotel Count is Zero OR Error
                    flg = false;
                    FlagStr = "Availability Hotel Count is Zero.";
                    log = new CreateLogFiles();
                    log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + FlagStr);
                }
            }
            catch(Exception ex)
            {
                log = new CreateLogFiles();
                log.ErrorLog("APICreateReservationDAO --> " + Step + " --> " + ex.Message);
                flg = false;
                FlagStr = "Error";
            }
            if (flg == false)
            {
                //dT.Rows.Add("No");ds.Tables.Add(dT);
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.API_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookFalseFlagLoad";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = FlagStr;
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else
            {
                DataSet ds1 = new APIBookingMailDAO().Mail(api.BookingId, user);
                //dT.Rows.Add("Yes");ds.Tables.Add(dT);
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = StoredProcedures.API_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BookTrueFlagLoad";
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
