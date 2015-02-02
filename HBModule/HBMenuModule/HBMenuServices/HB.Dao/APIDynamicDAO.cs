using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Xml;
using HB.Entity;

namespace HB.Dao
{
    public class APIDynamicDAO
    {
        string UserData = "";
        User user = new User();
        DataSet ds = new DataSet();
        SqlCommand command = new SqlCommand();
        XmlDocument document = new XmlDocument();
        APIDynamic api = new APIDynamic();
        public DataSet FnDynamicData(string[] data, User user)
        {
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                               ", SctId : " + user.SctId + ", Service : APIDynamicDAO" +
                               ", ProcName: " + StoredProcedures.APIHeader_Insert;
            //
            command = new SqlCommand();
            DataSet ds_CityId = new DataSet();
            command.CommandText = StoredProcedures.API_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "GetCityId";
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            ds_CityId = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //
            int CityCount = ds_CityId.Tables[0].Rows.Count;
            //
            for (int f = 0; f < CityCount; f++)
            {
                ds = new DataSet();
                command = new SqlCommand();
                api = new APIDynamic();
                string CityId = ds_CityId.Tables[0].Rows[f][0].ToString();
                DataTable dT = new DataTable("Table1");
                dT.Columns.Add("Str");
                string F = data[3].ToString();
                string T = data[4].ToString();
                api.FrmDt = F.Substring(0, 10);
                api.ToDt = T.Substring(0, 10);
                command.CommandText = StoredProcedures.APIHeader_Insert;
                command.CommandType = CommandType.StoredProcedure;
                //command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = data[2].ToString();
                command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = ds_CityId.Tables[0].Rows[f][0].ToString();
                command.Parameters.Add("@FromDt", SqlDbType.NVarChar).Value = api.FrmDt;
                command.Parameters.Add("@ToDt", SqlDbType.NVarChar).Value = api.ToDt;
                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                try
                {
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                    api.HeaderId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    api.CityCode = ds.Tables[0].Rows[0][1].ToString();
                    api.Stats = ds.Tables[0].Rows[0][2].ToString();
                    if (api.Stats == "New")
                    {
                        WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelSearch");
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
                        StreamWriter streamWriter = new StreamWriter(requestStream);
                        //StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                        StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                        soapRequest.Append("<MMTHotelSearchRequest>");
                        soapRequest.Append("<POS>");
                        //soapRequest.Append("<Requestor type=\"B2B\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2Bweb\"/>"); // test
                        soapRequest.Append("<Requestor type=\"B2B\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
                        soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
                        soapRequest.Append("</POS>");
                        soapRequest.Append("<ResultTransformer>");
                        soapRequest.Append("<GuestRecommendationEnabled maxRecommendations=\"1\">true</GuestRecommendationEnabled>");
                        soapRequest.Append("<PriceBreakupEnabled>true</PriceBreakupEnabled>");
                        soapRequest.Append("<CancellationPolicyRulesReq text=\"yes\"/>");
                        soapRequest.Append("</ResultTransformer>");
                        soapRequest.Append("<ResultPreferences>");
                        soapRequest.Append("<ResultPreference>");
                        soapRequest.Append("<Pagination paginate=\"false\" page=\"1\" limit=\"10\"/>");
                        soapRequest.Append("</ResultPreference>");
                        soapRequest.Append("</ResultPreferences>");
                        soapRequest.Append("<SearchCriteria>");
                        soapRequest.Append("<Criterion>");
                        soapRequest.Append("<Area>");
                        // City Code
                        //soapRequest.Append("<CityCode>CJB</CityCode>");
                        //soapRequest.Append("<CityCode>" + data[1].ToString() + "</CityCode>");
                        soapRequest.Append("<CityCode>");
                        soapRequest.Append(api.CityCode);
                        soapRequest.Append("</CityCode>");
                        soapRequest.Append("<CountryCode>IN</CountryCode>");
                        soapRequest.Append("</Area>");
                        soapRequest.Append("<RoomStayCandidates>");
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count=\"1\" ageQualifyingCode=\"10\"/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                        soapRequest.Append("<RoomStayCandidate>");
                        soapRequest.Append("<GuestCounts>");
                        soapRequest.Append("<GuestCount count=\"2\" ageQualifyingCode=\"10\"/>");
                        soapRequest.Append("</GuestCounts>");
                        soapRequest.Append("</RoomStayCandidate>");
                        soapRequest.Append("</RoomStayCandidates>");
                        soapRequest.Append("<StayDateRanges>");
                        // From Date & To Date
                        soapRequest.Append("<StayDateRange start='" + api.FrmDt + "' end='" + api.ToDt + "'/>");
                        //soapRequest.Append("<StayDateRange start=\"2014-10-15\" end=\"2014-10-16\"/>");
                        soapRequest.Append("</StayDateRanges>");
                        soapRequest.Append("<SupplierCodes>");
                        soapRequest.Append("<SupplierCode>EPXX0001</SupplierCode>");
                        soapRequest.Append("</SupplierCodes>");
                        soapRequest.Append("</Criterion>");
                        soapRequest.Append("</SearchCriteria>");
                        soapRequest.Append("</MMTHotelSearchRequest>");
                        streamWriter.Write(soapRequest.ToString());
                        streamWriter.Close();
                        //Get the Response
                        HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                        StreamReader Reader = new StreamReader(wr.GetResponseStream(), Encoding.Default, true);
                        //StreamReader Reader = new StreamReader(wr.GetResponseStream());
                        command = new SqlCommand();
                        document = new XmlDocument();
                        //string resulXmlFromWebService1 = srd.ReadToEnd();
                        //string resulXmlFromWebService = srd.ReadLine();
                        //string resulXmlFromWebService = srd.Read().ToString();
                        //string resulXmlFromWebService = srd.ReadBlock('MMTHotelSearchResponse',0,0);
                        string ResponseXml = Reader.ReadToEnd();
                        //Reader.Close();                    
                        document.LoadXml(ResponseXml);
                        //document.Load(wr.GetResponseStream());                    
                        /*StringBuilder str = new StringBuilder();                    
                        while(Reader.ReadLine() != null){str.Append(Reader.ReadLine());}
                        string s = str.ToString();
                        document.LoadXml(str.ToString());*/
                        //
                        /*XmlDocument document = new XmlDocument();
                        document.Load(Reader);
                        Reader.Close();*/
                        //
                        //document.LoadXml(NewHeader);
                        //document.Save(wr.GetResponseStream());
                        //document.Load(wr.GetResponseStream());
                        //document.Load(srd);
                        //
                        int MealPlanCnt = 0;
                        int RoomTypeCnt = 0;
                        int RoomRateCnt = 0;
                        int RoomNoCount = 0;
                        int n;
                        n = document.SelectNodes("//Hotel").Count;
                        for (int i = 0; i < n; i++)
                        {
                            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                                       ", SctId : " + user.SctId + ", Service : APIDynamicDAO" +
                                       ", ProcName: " + StoredProcedures.APIHotelHeader_Insert;
                            // Hotel Id & Rating
                            api.HotelId = document.SelectNodes("//Hotel")[i].Attributes["id"].Value;
                            if (api.HotelId == "200709192114193539")
                            {
                                string SDD = "";
                            }
                            int StarRatingCount = 0;
                            XmlNodeList xnList11 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/Facets/Facet");
                            foreach (XmlNode xn in xnList11)
                            {
                                if (xn.SelectNodes("//Facet")[StarRatingCount].Attributes["group"].Value.ToString() == "starRating")
                                {
                                    api.StarRating = xn["FacetValue"].InnerText;
                                }
                                StarRatingCount += 1;
                            }
                            command = new SqlCommand();
                            command.CommandText = StoredProcedures.APIHotelHeader_Insert;
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                            command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                            command.Parameters.Add("@HotelCount", SqlDbType.Int).Value = n;
                            command.Parameters.Add("@StarRating", SqlDbType.NVarChar).Value = api.StarRating;
                            //command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                            DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            // RoomStays / RoomStay / RoomTypes / RoomType
                            XmlNodeList xnListRoomTypes = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomTypes/RoomType");
                            if (xnListRoomTypes.Count > 0)
                            {
                                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                                       ", SctId : " + user.SctId + ", Service : APIDynamicDAO" +
                                       ", ProcName: " + StoredProcedures.APIRoomTypeDetails_Insert;
                                foreach (XmlNode xn in xnListRoomTypes)
                                {
                                    api.RoomTypename = xn.SelectNodes("//RoomType")[RoomTypeCnt].Attributes["name"].Value;
                                    api.RoomTypecode = xn.SelectNodes("//RoomType")[RoomTypeCnt].Attributes["code"].Value;
                                    command = new SqlCommand();
                                    command.CommandText = StoredProcedures.APIRoomTypeDetails_Insert;
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                    command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                    command.Parameters.Add("@RoomTypename", SqlDbType.NVarChar).Value = api.RoomTypename;
                                    command.Parameters.Add("@RoomTypecode", SqlDbType.NVarChar).Value = api.RoomTypecode;
                                    //command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                                    DataSet ds2 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    RoomTypeCnt += 1;
                                }
                            }
                            // inclusions
                            XmlNodeList xnListInclusion = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
                            if (xnListInclusion.Count > 0)
                            {
                                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                                       ", SctId : " + user.SctId + ", Service : APIDynamicDAO" +
                                       ", ProcName: " + StoredProcedures.APIRateMealPlanInclusionDetails_Insert;
                                foreach (XmlNode xn in xnListInclusion)
                                {
                                    api.RatePlanType = xn.SelectNodes("//RatePlan")[MealPlanCnt].Attributes["type"].Value;
                                    api.RatePlanName = xn.SelectNodes("//RatePlan")[MealPlanCnt].Attributes["name"].Value;
                                    api.RatePlanCode = xn.SelectNodes("//RatePlan")[MealPlanCnt].Attributes["code"].Value;
                                    //api.MealPlanCode = xn.SelectNodes("//MealPlan")[MealPlanCnt].Attributes["code"].Value;
                                    //api.MealPlan = xn.SelectNodes("//MealPlan")[MealPlanCnt].InnerText;
                                    api.InclusionCode = ""; api.Inclusion = ""; api.MealPlanCode = ""; api.MealPlan = "";
                                    string In = xn.OuterXml;
                                    XmlDocument docu = new XmlDocument();
                                    docu.LoadXml(In);
                                    int IncluCnt = docu.SelectNodes("//Inclusion").Count;
                                    int MealPlnCnt = docu.SelectNodes("//MealPlan").Count;
                                    for (int y = 0; y < IncluCnt; y++)
                                    {
                                        if (y == 0)
                                        {
                                            api.InclusionCode = docu.SelectNodes("//Inclusion")[y].Attributes["code"].Value;
                                            api.Inclusion = docu.SelectNodes("//Inclusion")[y].InnerText;
                                            //api.InclusionCode = xn.SelectNodes("//Inclusion")[y].Attributes["code"].Value;
                                            //api.Inclusion = xn.SelectNodes("//Inclusion")[y].InnerText;
                                        }
                                        else
                                        {
                                            api.InclusionCode += ", " + docu.SelectNodes("//Inclusion")[y].Attributes["code"].Value;
                                            api.Inclusion += ", " + docu.SelectNodes("//Inclusion")[y].InnerText;
                                        }
                                        //InclusionCnt += 1;
                                    }
                                    for (int z = 0; z < MealPlnCnt; z++)
                                    {
                                        if (z == 0)
                                        {
                                            api.MealPlanCode = docu.SelectNodes("//MealPlan")[z].Attributes["code"].Value;
                                            api.MealPlan = docu.SelectNodes("//MealPlan")[z].InnerText;
                                            //api.MealPlanCode = xn.SelectNodes("//MealPlan")[z].Attributes["code"].Value;
                                            //api.MealPlan = xn.SelectNodes("//MealPlan")[z].InnerText;
                                        }
                                        else
                                        {
                                            api.MealPlanCode += ", " + docu.SelectNodes("//MealPlan")[z].Attributes["code"].Value;
                                            api.MealPlan += ", " + docu.SelectNodes("//MealPlan")[z].InnerText;
                                        }
                                        //InclusionCnt += 1;
                                    }
                                    command = new SqlCommand();
                                    command.CommandText = StoredProcedures.APIRateMealPlanInclusionDetails_Insert;
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                    command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                    command.Parameters.Add("@RatePlanType", SqlDbType.NVarChar).Value = api.RatePlanType;
                                    command.Parameters.Add("@RatePlanCode", SqlDbType.NVarChar).Value = api.RatePlanCode;
                                    command.Parameters.Add("@MealPlanCode", SqlDbType.NVarChar).Value = api.MealPlanCode;
                                    command.Parameters.Add("@MealPlan", SqlDbType.NVarChar).Value = api.MealPlan;
                                    command.Parameters.Add("@InclusionCode", SqlDbType.NVarChar).Value = api.InclusionCode;
                                    DataSet ds2 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    MealPlanCnt += 1;
                                }
                            }
                            // Tariff                
                            XmlNodeList xnListRoomRate = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate");
                            if (xnListRoomRate.Count > 0)
                            {
                                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                                       ", SctId : " + user.SctId + ", Service : APIDynamicDAO" +
                                       ", ProcName: " + StoredProcedures.APIRateMealPlanInclusionDetails_Insert;
                                foreach (XmlNode xnRR in xnListRoomRate)
                                {
                                    api.RoomRateroomTypeCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["roomTypeCode"].Value;
                                    api.RoomRateratePlanCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["ratePlanCode"].Value;
                                    if (api.StarRating != "0")
                                    {
                                        api.RoomRateavailableCount = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availableCount"].Value;
                                    }
                                    else
                                    {
                                        api.RoomRateavailableCount = "0";
                                    }
                                    api.RoomRateavailStatus = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availStatus"].Value;
                                    //
                                    string CancelPenalty = xnRR.InnerXml;
                                    XmlDocument xmlcancel = new XmlDocument();
                                    xmlcancel.LoadXml(CancelPenalty);
                                    /*int CancelPenaltyCnt = xmlcancel.SelectNodes("//CancelPenaltyRule").Count;
                                    string CancelAmountPercent = "";
                                    for (int cp = 0; cp < CancelPenaltyCnt; cp++)
                                    {
                                        string OffsetUnitMultiplier = 
                                            xmlcancel.SelectNodes("//Deadline")[cp].Attributes["OffsetUnitMultiplier"].Value;
                                        if (OffsetUnitMultiplier == "99999.0")
                                        {
                                            CancelAmountPercent = xmlcancel.SelectNodes("//AmountPercent")[cp].Attributes["percent"].Value;
                                        }                                        
                                    }*/
                                    api.PenaltyDescription = xmlcancel.SelectNodes("//PenaltyDescription")[0].InnerText;
                                    //
                                    command = new SqlCommand();
                                    command.CommandText = StoredProcedures.APIRoomRateDetails_Insert;
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                    command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                    command.Parameters.Add("@RoomRateroomTypeCode", SqlDbType.NVarChar).Value = api.RoomRateroomTypeCode;
                                    command.Parameters.Add("@RoomRateratePlanCode", SqlDbType.NVarChar).Value = api.RoomRateratePlanCode;
                                    command.Parameters.Add("@RoomRateavailableCount", SqlDbType.NVarChar).Value = api.RoomRateavailableCount;
                                    command.Parameters.Add("@RoomRateavailStatus", SqlDbType.NVarChar).Value = api.RoomRateavailStatus;
                                    command.Parameters.Add("@PenaltyDescription", SqlDbType.NVarChar).Value = api.PenaltyDescription;
                                    DataSet ds3 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    api.RoomRateHdrId = Convert.ToInt32(ds3.Tables[0].Rows[0][0].ToString());
                                    //
                                    //int sss = xnRR.LastChild.ChildNodes.Count;
                                    //string dsfdsdf = xnRR.SelectNodes("//RoomTariff")[RoomRateCnt].InnerXml;
                                    //XmlDocument doc = new XmlDocument();
                                    //doc.LoadXml(dsfdsdf);
                                    string dsfdsdf2 = xnRR.InnerXml;
                                    XmlDocument doc2 = new XmlDocument();
                                    doc2.LoadXml(dsfdsdf2);
                                    int d1 = doc2.SelectNodes("//RoomTariff").Count;
                                    int t1 = doc2.SelectNodes("//Tariff").Count;
                                    for (int i1 = 0; i1 < d1; i1++)
                                    {
                                        string dsfdsdf1 = xnRR.SelectNodes("//RoomTariff")[RoomNoCount].OuterXml;
                                        XmlDocument doc1 = new XmlDocument();
                                        doc1.LoadXml(dsfdsdf1);
                                        int d = doc1.SelectNodes("//RoomTariff").Count;
                                        api.RoomTariffroomNumber = doc2.SelectNodes("//RoomTariff")[i1].Attributes["roomNumber"].Value;
                                        //                            
                                        //
                                        int t = doc1.SelectNodes("//Tariff").Count;
                                        for (int i2 = 0; i2 < t; i2++)
                                        {
                                            api.Tarifftype = doc1.SelectNodes("//Tariff")[i2].Attributes["type"].Value;
                                            api.Tariffgroup = doc1.SelectNodes("//Tariff")[i2].Attributes["group"].Value;
                                            api.Tariffamount = Convert.ToDecimal(doc1.SelectNodes("//Tariff")[i2].Attributes["amount"].Value);
                                            //
                                            command = new SqlCommand();
                                            command.CommandText = StoredProcedures.APITariffDetails_Insert;
                                            command.CommandType = CommandType.StoredProcedure;
                                            command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                            command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                            command.Parameters.Add("@RoomRateHdrId", SqlDbType.BigInt).Value = api.RoomRateHdrId;
                                            command.Parameters.Add("@RoomTariffroomNumber", SqlDbType.NVarChar).Value = api.RoomTariffroomNumber;
                                            command.Parameters.Add("@Tarifftype", SqlDbType.NVarChar).Value = api.Tarifftype;
                                            command.Parameters.Add("@Tariffgroup", SqlDbType.NVarChar).Value = api.Tariffgroup;
                                            command.Parameters.Add("@Tariffamount", SqlDbType.Decimal).Value = api.Tariffamount;
                                            DataSet ds2 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                        }
                                        RoomNoCount += 1;
                                    }
                                    RoomRateCnt += 1;
                                }
                            }
                        }
                        if (n == 0)
                        {
                            if (api.HeaderId != 0)
                            {
                                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                                "', SctId:" + user.SctId + ", Service : APIDynamicDAO : Help, " + ", ProcName:'" + StoredProcedures.API_Help;
                                command = new SqlCommand();
                                command.CommandText = StoredProcedures.API_Help;
                                command.CommandType = CommandType.StoredProcedure;
                                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "UPDATEAPI";
                                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(user.Id);
                                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(api.HeaderId);
                                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                                DataSet ds5 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            }
                            dT.Rows.Add(0);
                            ds.Tables.Add(dT);
                        }
                        if (n != 0)
                        {
                            dT.Rows.Add(api.HeaderId);
                            ds.Tables.Add(dT);
                        }
                    }
                    if (api.Stats == "Exists")
                    {
                        dT.Rows.Add(api.HeaderId);
                        ds.Tables.Add(dT);
                    }
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message);
                    //
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service : APIDynamicDAO : Help, " + ", ProcName:'" + StoredProcedures.API_Help;
                    command = new SqlCommand();
                    command.CommandText = StoredProcedures.API_Help;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "UPDATEAPI";
                    command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(user.Id);
                    command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(api.HeaderId);
                    command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                    command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                    DataSet ds5 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                    //
                    dT.Rows.Add(0);
                    ds.Tables.Add(dT);
                }
            }
            return ds;
        }
    }
}
/*
                // Tariff
                //int RoomRateCnt = 0;
                //int RoomTariffCount = 0;
                //int Tariffcount = 0;
                XmlNodeList xnListRoomRate = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate");
                foreach (XmlNode xnRR in xnListRoomRate)
                {
                    api.RoomRateroomTypeCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["roomTypeCode"].Value;
                    api.RoomRateratePlanCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["ratePlanCode"].Value;
                    api.RoomRateavailableCount = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availableCount"].Value;
                    api.RoomRateavailStatus = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availStatus"].Value;                    
                    bool flag1 = true;
                    try
                    {
                        Int32 Code1 = Convert.ToInt32(xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["ratePlanCode"].Value);
                        flag1 = true;
                    }
                    catch
                    {
                        Int32 Count1 = Convert.ToInt32(xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availableCount"].Value);
                        flag1 = false;
                    }                    
                    //
                    XmlNodeList xnList121 = document.DocumentElement.SelectNodes("/Example");
                    if (flag1 == true)
                    {
                        xnList121 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomRateroomTypeCode + "] [@ratePlanCode=" + api.RoomRateratePlanCode + "]/Rate/RoomTariffs/RoomTariff");
                    }
                    else
                    {
                        xnList121 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomRateroomTypeCode + "] [@availableCount=" + api.RoomRateavailableCount + "]/Rate/RoomTariffs/RoomTariff");
                    }
                    foreach (XmlNode xnR in xnList121)
                    {
                        XmlNodeList xnList122 = document.DocumentElement.SelectNodes("/Sample");
                        api.RoomTariffroomNumber = xnR.SelectNodes("//RoomTariff")[RoomTariffCount].Attributes["roomNumber"].Value;
                        if (flag1 == true)
                        {
                            xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomRateroomTypeCode + "] [@ratePlanCode=" + api.RoomRateratePlanCode + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                        }
                        else
                        {
                            xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomRateroomTypeCode + "] [@availableCount=" + api.RoomRateavailableCount + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                        }
                        foreach (XmlNode xnn in xnList122)
                        {
                            api.Tarifftype = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["type"].Value;
                            api.Tariffgroup = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["group"].Value;
                            api.Tariffamount = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["amount"].Value;
                            Tariffcount += 1;
                        }
                        RoomTariffCount += 1;
                    }
                    RoomRateCnt += 1;
                }
            }
            return ds;
        }
    }
}*/
/*              XmlNodeList xnList31 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
                XmlNodeList xnList3 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan/Inclusions/Inclusion");
                foreach (XmlNode xn in xnList3)
                {
                    api.InclusionCode += "," + xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["code"].Value;
                }
                InclusionCount += 1;                
                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                           ", SctId : " + user.SctId + ", Service : APIDynamicDAO -> Header Insert" +
                           ", ProcName: " + StoredProcedures.APIHeader_Insert;
                command = new SqlCommand();
                command.CommandText = StoredProcedures.APIHeader_Insert;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@HotelId", SqlDbType.BigInt).Value = api.HotelId;
                command.Parameters.Add("@StarRating", SqlDbType.NVarChar).Value = api.StarRating;
                command.Parameters.Add("@Inclusion", SqlDbType.NVarChar).Value = api.InclusionCode;
                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                api.HeaderId = ds.Tables[0].Rows[0][0].ToString();
                // Room Type, Room Number & Tariff                
                XmlNodeList xnList12 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomTypes/RoomType");
                foreach (XmlNode xn in xnList12)
                {
                    if (api.HotelId == "20130505160328891")
                    {
                        string sdf = "sdfsf";
                    }
                    api.RoomTypeName = xn.SelectNodes("//RoomType")[RoomTypesCount].Attributes["name"].Value;
                    api.RoomTypeCode = xn.SelectNodes("//RoomType")[RoomTypesCount].Attributes["code"].Value;
                    //
                    XmlNodeList xnList1221 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate");
                    foreach (XmlNode xnRR in xnList1221)
                    {
                        api.RoomRateroomTypeCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["roomTypeCode"].Value;
                        api.RoomRateratePlanCode = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["ratePlanCode"].Value;
                        api.RoomRateavailableCount = xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availableCount"].Value;
                        RoomRateCnt += 1;
                        bool flag1 = true;
                        try
                        {
                            int Code1 = Convert.ToInt32(xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["ratePlanCode"].Value);
                            flag1 = true;
                        }
                        catch
                        {
                            int Count1 = Convert.ToInt32(xnRR.SelectNodes("//RoomRate")[RoomRateCnt].Attributes["availableCount"].Value);
                            flag1 = false;
                        }
                        //
                        XmlNodeList xnList121 = document.DocumentElement.SelectNodes("/Example");
                        if (flag1 == true)
                        {
                            xnList121 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "] [@ratePlanCode=" + api.RoomRateratePlanCode + "]/Rate/RoomTariffs/RoomTariff");
                        }
                        else
                        {
                            xnList121 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "] [@availableCount=" + api.RoomRateavailableCount + "]/Rate/RoomTariffs/RoomTariff");
                        }                        
                        foreach (XmlNode xnR in xnList121)
                        {
                            XmlNodeList xnList122 = document.DocumentElement.SelectNodes("/Sample");
                            api.RoomTariffroomNumber = xnR.SelectNodes("//RoomTariff")[RoomTypeCount].Attributes["roomNumber"].Value;
                            if (flag1 == true)
                            {
                                xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "] [@ratePlanCode=" + api.RoomRateratePlanCode + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                            }
                            else
                            {
                                xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "] [@availableCount=" + api.RoomRateavailableCount + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                            }
                            //XmlNodeList xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "] [@ratePlanCode=" + api.RoomRateratePlanCode + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                            //XmlNodeList xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotelId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                            foreach (XmlNode xnn in xnList122)
                            {
                                api.Tarifftype = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["type"].Value;
                                api.Tariffgroup = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["group"].Value;
                                api.Tariffamount = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["amount"].Value;
                                Tariffcount += 1;

                                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " +
                                            user.ScreenName + ", SctId:" + user.SctId + ", Service : APIDynamicDAO -> Details Insert" +
                                           ", ProcName: " + StoredProcedures.APIDetails_Insert;
                                command = new SqlCommand();
                                command.CommandText = StoredProcedures.APIDetails_Insert;
                                command.CommandType = CommandType.StoredProcedure;
                                command.Parameters.Add("@HotelId", SqlDbType.BigInt).Value = api.HotelId;
                                command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                command.Parameters.Add("@RoomTypeName", SqlDbType.NVarChar).Value = api.RoomTypeName;
                                command.Parameters.Add("@RoomTypeCode", SqlDbType.BigInt).Value = api.RoomTypeCode;
                                command.Parameters.Add("@RoomTariffroomNumber", SqlDbType.NVarChar).Value = api.RoomTariffroomNumber;
                                command.Parameters.Add("@Tarifftype", SqlDbType.NVarChar).Value = api.Tarifftype;
                                command.Parameters.Add("@Tariffgroup", SqlDbType.NVarChar).Value = api.Tariffgroup;
                                command.Parameters.Add("@Tariffamount", SqlDbType.Decimal).Value = api.Tariffamount;
                                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                                DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                            }
                            RoomTypeCount += 1;
                        }
                        RoomTypesCount += 1;
                    }
                }                
            }
            return ds;
        }
    }
}*/
