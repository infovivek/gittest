using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.IO;
using System.Net;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace HB.Dao
{
    public class APIDynamicJson
    {
        string UserData = "";
        User user = new User();
        DataSet ds = new DataSet();
        SqlCommand command = new SqlCommand();
        APIDynamic api = new APIDynamic();
        DataSet ds_CityId = new DataSet();
        public DataSet FnDynamicData(string[] data, User user)
        {
            //return ds;
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.API_Help;
            command = new SqlCommand();
            
            command.CommandText = StoredProcedures.API_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "GetCityCode";
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
            ds_CityId = new WrbErpConnection().ExecuteDataSet(command, UserData);
            int CityCount = ds_CityId.Tables[0].Rows.Count;
            for (int f = 0; f < CityCount; f++)
            {
                ds = new DataSet();
                command = new SqlCommand();
                api = new APIDynamic();
                string CityId = ds_CityId.Tables[0].Rows[f][0].ToString();
                DataTable dT = new DataTable("Table1");
                dT.Columns.Add("Str");
                api.FrmDt = data[3].ToString();
                api.ToDt = data[4].ToString();
                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APIHeader_Insert;
                command.CommandText = StoredProcedures.APIHeader_Insert;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CityCode", SqlDbType.NVarChar).Value = ds_CityId.Tables[0].Rows[f][0].ToString();
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
                        WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelSearch?responseFormat=json");
                        HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                        httpRequest.Method = "POST";
                        httpRequest.ContentType = "application/xml; charset=utf-8";
                        httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");                        
                        httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                        httpRequest.ProtocolVersion = HttpVersion.Version11;
                        httpRequest.Credentials = CredentialCache.DefaultCredentials;
                        httpRequest.Timeout = 100000000;
                        Stream requestStream = httpRequest.GetRequestStream();                        
                        StreamWriter streamWriter = new StreamWriter(requestStream);                        
                        StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                        soapRequest.Append("<MMTHotelSearchRequest>");
                        soapRequest.Append("<POS>");                        
                        //soapRequest.Append("<Requestor type=\"B2B\" idContext=\"AFF\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
                        soapRequest.Append("<Requestor type=\"B2B\" idContext=\"HMG\" id=\"AFF14453\" channel=\"B2Bweb\"/>"); // live
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
                        string ResponseXml = Reader.ReadToEnd();
                        JObject jsonObj = JObject.Parse(ResponseXml);
                        var Hotels = jsonObj.SelectToken("HotelSearchResults.Hotels");
                        int HotelCount = Hotels.Count();
                        foreach (var Hotelsroot in Hotels)
                        {
                            api.HotelId = (string)Hotelsroot.SelectToken("id");
                            //if (api.HotelId == "5219612481031540")
                            if (api.HotelId != "")
                            {
                                var Facets = Hotelsroot.SelectToken("PropertyInfo.Facets");
                                api.StarRating = "";
                                foreach (var Facetsroot in Facets)
                                {
                                    if (Facetsroot["group"].ToString() == "STAR_RATING")
                                    {
                                        api.StarRating = (string)Facetsroot.SelectToken("FacetValue.value");
                                    }
                                }
                                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APIHotelHeader_Insert;
                                command = new SqlCommand();
                                command.CommandText = StoredProcedures.APIHotelHeader_Insert;
                                command.CommandType = CommandType.StoredProcedure;
                                command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                command.Parameters.Add("@HotelCount", SqlDbType.Int).Value = HotelCount;
                                command.Parameters.Add("@StarRating", SqlDbType.NVarChar).Value = api.StarRating;
                                DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                //
                                var RoomStays = Hotelsroot.SelectToken("PropertyInfo.RoomStays");
                                foreach (var RoomTypesroot in RoomStays)
                                {
                                    var RoomTypes = RoomTypesroot.SelectToken("RoomTypes");
                                    foreach (var RoomTyperoot in RoomTypes)
                                    {
                                        api.RoomTypename = (string)RoomTyperoot.SelectToken("name");
                                        api.RoomTypecode = (string)RoomTyperoot.SelectToken("code");
                                        //
                                        UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APIRoomTypeDetails_Insert;
                                        command = new SqlCommand();
                                        command.CommandText = StoredProcedures.APIRoomTypeDetails_Insert;
                                        command.CommandType = CommandType.StoredProcedure;
                                        command.Parameters.Add("@HeaderId", SqlDbType.BigInt).Value = api.HeaderId;
                                        command.Parameters.Add("@HotelId", SqlDbType.NVarChar).Value = api.HotelId;
                                        command.Parameters.Add("@RoomTypename", SqlDbType.NVarChar).Value = api.RoomTypename;
                                        command.Parameters.Add("@RoomTypecode", SqlDbType.NVarChar).Value = api.RoomTypecode;
                                        DataSet ds2 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    }
                                    //
                                    var RatePlans = RoomTypesroot.SelectToken("RatePlans");
                                    foreach (var RatePlansroot in RatePlans)
                                    {
                                        api.RatePlanCode = (string)RatePlansroot.SelectToken("code");
                                        api.RatePlanName = (string)RatePlansroot.SelectToken("name");
                                        api.RatePlanType = (string)RatePlansroot.SelectToken("type");
                                        var MealPlans = RatePlansroot.SelectToken("MealPlans");
                                        foreach (var MealPlansroot in MealPlans)
                                        {
                                            api.MealPlanCode = (string)MealPlansroot.SelectToken("code");
                                            api.MealPlan = (string)MealPlansroot.SelectToken("value");
                                        }
                                        api.InclusionCode = ""; api.Inclusion = "";
                                        var Inclusions = RatePlansroot.SelectToken("Inclusions");
                                        foreach (var Inclusionsroot in Inclusions)
                                        {
                                            api.InclusionCode += (string)Inclusionsroot.SelectToken("code") + ", ";
                                            api.Inclusion += (string)Inclusionsroot.SelectToken("value") + ", ";
                                        }
                                        UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APIRateMealPlanInclusionDetails_Insert;
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
                                        DataSet Meal = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    }
                                    //
                                    //var RoomRates = RoomTypesroot.SelectToken("RoomRates");
                                    foreach (var RoomRatesroot in RoomTypesroot["RoomRates"])
                                    {
                                        api.RoomRateroomTypeCode = (string)RoomRatesroot.SelectToken("roomTypeCode");
                                        api.RoomRateratePlanCode = (string)RoomRatesroot.SelectToken("ratePlanCode");
                                        api.RoomRateavailableCount = (string)RoomRatesroot.SelectToken("availableCount");
                                        if (api.RoomRateavailableCount == null)
                                        {
                                            api.RoomRateavailableCount = "0";
                                        }
                                        api.RoomRateavailStatus = (string)RoomRatesroot.SelectToken("availStatus");
                                        var Rate = RoomRatesroot.SelectToken("Rate");
                                        foreach (var Rateroot in Rate["CancelPenalties"])
                                        {
                                            api.PenaltyDescription = (string)Rateroot.SelectToken("PenaltyDescription.value");
                                        }
                                        UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APIRoomRateDetails_Insert;
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
                                        var RoomTariffs = Rate.SelectToken("RoomTariffs");
                                        if (RoomTariffs != null)
                                        {
                                            foreach (var RoomTariffsroot in RoomTariffs)
                                            {
                                                api.RoomTariffroomNumber = (string)RoomTariffsroot.SelectToken("roomNumber");
                                                foreach (var Tariffsroot in RoomTariffsroot["Tariffs"])
                                                {
                                                    api.Tarifftype = (string)Tariffsroot.SelectToken("type");
                                                    string group = (string)Tariffsroot.SelectToken("group");
                                                    if (group == "ROOM_RATE")
                                                    {
                                                        api.Tariffgroup = "RoomRate";
                                                    }
                                                    else if (group == "ROOM_DISCOUNT")
                                                    {
                                                        api.Tariffgroup = "RoomDiscount";
                                                    }
                                                    else if (group == "TAXES")
                                                    {
                                                        api.Tariffgroup = "Taxes";
                                                    }
                                                    else
                                                    {
                                                        api.Tariffgroup = group;
                                                    }
                                                    api.Tariffamount = Convert.ToDecimal(Tariffsroot.SelectToken("amount"));
                                                    //
                                                    UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", Service : APIDynamicDAO" + ", ProcName: " + StoredProcedures.APITariffDetails_Insert;
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
                                                    DataSet Tariff = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (HotelCount == 0)
                        {
                            if (api.HeaderId != 0)
                            {
                                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +"', SctId:" + user.SctId + ", Service : APIDynamicDAO : Help, " + ", ProcName:'" + StoredProcedures.API_Help;
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
                        if (HotelCount != 0)
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
                catch(Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog("CityCode : " + api.CityCode + ", " + ex.Message +" MMT Tariff Update");
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +"', SctId:" + user.SctId + ", Service : APIDynamicDAO : Help, " + ", ProcName:'" + StoredProcedures.API_Help;
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
            return ds_CityId;
        }
    }
}
