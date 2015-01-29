using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
using HB.Dao;
using HB.Entity;

namespace HB.Dao
{
    public class APIStaticDataDAO
    {
        string TmpCityCode = "";
        public DataSet FnstaticData(User user)
        {
            SqlCommand command = new SqlCommand();
            DataSet ds = new DataSet();
            //return ds;
            string UserData = "";
            try
            {
                UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                               ", SctId : " + user.SctId + ", Service : APIStaticDataDAO" +
                               ", ProcName: Static Data Help";
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_API_Help";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "CityCode";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str3", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str4", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id3", SqlDbType.BigInt).Value = 0;
                command.Parameters.Add("@Id4", SqlDbType.BigInt).Value = 0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                int CodeCnt = ds.Tables[0].Rows.Count;
                for (int Q = 0; Q < CodeCnt; Q++)
                {
                    WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/staticsearch/v1.0/hotelData");
                    HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
                    httpRequest.Method = "POST";
                    httpRequest.ContentType = "application/xml; charset=utf-8";
                    httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
                    //httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b");
                    httpRequest.Headers.Add("Authorization", "Basic QUZGMTQ0NTM6SHVtbWluZ0BCaXJk, Bearer a6689e5ff46f0604151205f79c63b7b"); // live
                    httpRequest.ProtocolVersion = HttpVersion.Version11;
                    httpRequest.Credentials = CredentialCache.DefaultCredentials;
                    httpRequest.Timeout = 100000000;
                    Stream requestStream = httpRequest.GetRequestStream();
                    //Create Stream and Complete Request             
                    StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
                    StringBuilder StrBuil = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                    StrBuil.Append("<MMTHotelSearchRequest Rows=\"0\" Offset=\"1000\">");
                    StrBuil.Append("<POS>");
                    StrBuil.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"AFF\"/>");
                    StrBuil.Append("<Source iSOCurrency=\"INR\"/>");
                    StrBuil.Append("<Token>AFF14453</Token>");
                    StrBuil.Append("</POS>");
                    StrBuil.Append("<RequestHotelParams>");
                    //StrBuil.Append("<CityCode>AGR</CityCode>");
                    TmpCityCode = ds.Tables[0].Rows[Q][0].ToString();
                    StrBuil.Append("<CityCode>" + ds.Tables[0].Rows[Q][0].ToString() + "</CityCode>");
                    StrBuil.Append("<CityName/>");
                    StrBuil.Append("<Country/>");
                    StrBuil.Append("<CountryCode>IN</CountryCode>");
                    StrBuil.Append("<HotelId/>");
                    StrBuil.Append("</RequestHotelParams>");
                    StrBuil.Append("<RequiredFields/>");
                    StrBuil.Append("</MMTHotelSearchRequest>");
                    streamWriter.Write(StrBuil.ToString());
                    streamWriter.Close();
                    //Get the Response    
                    HttpWebResponse wr = (HttpWebResponse)httpRequest.GetResponse();
                    StreamReader srd = new StreamReader(wr.GetResponseStream());
                    string resulXmlFromWebService = srd.ReadToEnd();
                    APIStaticData api = new APIStaticData();                    
                    XmlDocument document = new XmlDocument();
                    //document.LoadXml(NewHeader);
                    document.LoadXml(resulXmlFromWebService);
                    int n;
                    n = (document).SelectNodes("//Hotel").Count;
                    api.Total = Convert.ToInt32(document.SelectNodes("//MMTHotelsSearchResponse")[0].Attributes["Total"].Value);
                    api.Rows = document.SelectNodes("//MMTHotelsSearchResponse")[0].Attributes["Rows"].Value;
                    api.Offset = document.SelectNodes("//MMTHotelsSearchResponse")[0].Attributes["Offset"].Value;
                    if (api.Total > 500)
                    {
                        api.HotelCount = n;                        
                        for (int i = 0; i < n; i++)
                        {
                            api.HotalId = document.SelectNodes("//Hotel")[i].Attributes["Id"].Value;
                            if (api.HotalId == "595288648746443")
                            {
                                string sdff = "";
                            }
                            bool CntFlg = true;
                            XmlNodeList xnList111 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]");
                            foreach (XmlNode xn in xnList111)
                            {
                                if (CntFlg == true)
                                {
                                    CntFlg = false;
                                    // Pincode
                                    api.Pincode = "";
                                    XmlNodeList xnListPinCode11 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/Pincode");
                                    foreach (XmlNode xnp in xnListPinCode11)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Pincode = docp.SelectNodes("//Pincode")[0].InnerXml;
                                    }
                                    // State
                                    api.State = "";
                                    XmlNodeList xnListState11 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/State");
                                    foreach (XmlNode xnp in xnListState11)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.State = docp.SelectNodes("//State")[0].InnerXml;
                                    }
                                    // Mobile
                                    api.Mobile = "";
                                    XmlNodeList xnListMobile11 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/ContactInfo/Mobile");
                                    foreach (XmlNode xnp in xnListMobile11)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Mobile = docp.SelectNodes("//Mobile")[0].InnerXml;
                                    }
                                    // Image
                                    api.Image = "";
                                    int A1 = 0;
                                    XmlNodeList xnListHotelSrc11 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelMedia/Media");
                                    foreach (XmlNode xnp in xnListHotelSrc11)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        if (A1 == 0)
                                        {
                                            api.Image = docp.SelectNodes("//Src")[0].InnerXml;
                                            A1 = 1;
                                        }
                                    }
                                    // WebAddress
                                    api.WebAddress = "";
                                    XmlNodeList xnListWebAddress11 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/WebAddress");
                                    foreach (XmlNode xnp in xnListWebAddress11)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.WebAddress = docp.SelectNodes("//WebAddress")[0].InnerXml;
                                    }
                                    // Description
                                    api.Description = "";
                                    XmlNodeList xnListDescription = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/Description");
                                    foreach (XmlNode xnp in xnListDescription)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Description = docp.SelectNodes("//Description")[0].InnerXml;
                                    }
                                    // Area
                                    int AreasCount = 0;
                                    api.Area = "";
                                    XmlNodeList xnList = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/Areas/Area");
                                    foreach (XmlNode xnN in xnList)
                                    {
                                        if (AreasCount == 0)
                                        {
                                            AreasCount = 1;
                                            api.Area = xnN.InnerText;
                                        }
                                        else
                                        {
                                            api.Area += "," + xnN.InnerText;
                                        }
                                    }
                                    //api.City = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/City")[i].InnerText;
                                    api.City = "";
                                    XmlNodeList xnListCity = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/City");
                                    foreach (XmlNode xnp in xnListCity)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.City = docp.SelectNodes("//City")[0].InnerXml;
                                    }
                                    //api.CityCode = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/CityCode")[i].InnerText;
                                    api.CityCode = "";
                                    XmlNodeList xnListCityCode = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/CityCode");
                                    foreach (XmlNode xnp in xnListCityCode)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.CityCode = docp.SelectNodes("//CityCode")[0].InnerXml;
                                    }
                                    //api.Country = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/Country")[i].InnerText;
                                    api.Country = "";
                                    XmlNodeList xnListCountry = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/Country");
                                    foreach (XmlNode xnp in xnListCountry)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Country = docp.SelectNodes("//Country")[0].InnerXml;
                                    }
                                    //api.CountryCode = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/CountryCode")[i].InnerText;
                                    api.CountryCode = "";
                                    XmlNodeList xnListCountryCode = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/CountryCode");
                                    foreach (XmlNode xnp in xnListCountryCode)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.CountryCode = docp.SelectNodes("//CountryCode")[0].InnerXml;
                                    }
                                    //api.Line1 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/Line1")[i].InnerText;
                                    api.Line1 = "";
                                    XmlNodeList xnListLine1 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/Line1");
                                    foreach (XmlNode xnp in xnListLine1)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Line1 = docp.SelectNodes("//Line1")[0].InnerXml;
                                    }
                                    //api.Line2 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/Address/Line2")[i].InnerText;
                                    api.Line2 = "";
                                    XmlNodeList xnListLine2 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/Address/Line2");
                                    foreach (XmlNode xnp in xnListLine2)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Line2 = docp.SelectNodes("//Line2")[0].InnerXml;
                                    }
                                    //api.Latitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Latitude")[i].InnerText;
                                    //api.Longitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Longitude")[i].InnerText;
                                    //api.Fax = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/ContactInfo/Fax ")[i].InnerText;
                                    //api.Email = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/ContactInfo/Email")[i].InnerText;
                                    api.Email = "";
                                    XmlNodeList xnListEmail = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/ContactInfo/Email");
                                    foreach (XmlNode xnp in xnListEmail)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Email = docp.SelectNodes("//Email")[0].InnerXml;
                                    }
                                    //api.Phone1 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/ContactInfo/Phone1")[i].InnerText;
                                    api.Phone1 = "";
                                    XmlNodeList xnListPhone1 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/ContactInfo/Phone1");
                                    foreach (XmlNode xnp in xnListPhone1)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.Phone1 = docp.SelectNodes("//Phone1")[0].InnerXml;
                                    }
                                    //
                                    bool flg = true; api.Phone = "";
                                    if ((api.Phone1 != "") && (api.Mobile != ""))
                                    {
                                        flg = false;
                                        api.Phone = api.Mobile + ',' + api.Phone1;
                                    }
                                    if (flg == true)
                                    {
                                        if (api.Phone1 != "")
                                        {
                                            api.Phone = api.Phone1;
                                        }
                                        if (api.Mobile != "")
                                        {
                                            api.Phone = api.Mobile;
                                        }
                                    }
                                    //api.ContactPerson = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/ContactInfo/ContactPerson")[i].InnerText;
                                    api.ContactPerson = "";
                                    XmlNodeList xnListContactPerson = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/ContactInfo/ContactPerson");
                                    foreach (XmlNode xnp in xnListContactPerson)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.ContactPerson = docp.SelectNodes("//ContactPerson")[0].InnerXml;
                                    }
                                    //api.AlternateName = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/AlternateNames/AlternateName ")[i].InnerText;
                                    //api.CheckInTime = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/CheckInTime")[i].InnerText;
                                    api.CheckInTime = "";
                                    XmlNodeList CheckInTime = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/CheckInTime");
                                    foreach (XmlNode xnp in CheckInTime)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.CheckInTime = docp.SelectNodes("//CheckInTime")[0].InnerXml;
                                    }
                                    //api.CheckOutTime = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/CheckOutTime")[i].InnerText;
                                    api.CheckOutTime = "";
                                    XmlNodeList CheckOutTime = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/CheckOutTime");
                                    foreach (XmlNode xnp in CheckOutTime)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.CheckOutTime = docp.SelectNodes("//CheckOutTime")[0].InnerXml;
                                    }
                                    //api.Contact = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/Contact")[i].InnerText;
                                    //api.Currency = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/Currency")[i].InnerText;                               
                                    //api.HotalName = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/Name")[i].InnerText;
                                    api.HotalName = "";
                                    XmlNodeList HotalName = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/Name");
                                    foreach (XmlNode xnp in HotalName)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.HotalName = docp.SelectNodes("//Name")[0].InnerXml;
                                    }
                                    //api.Overallrating = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/Overallrating")[i].InnerText;
                                    //api.Recommended = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/Recommended")[i].InnerText;
                                    //api.StarRating = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/StarRating")[i].InnerText;
                                    api.StarRating = "";
                                    XmlNodeList StarRating = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/StarRating");
                                    foreach (XmlNode xnp in StarRating)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.StarRating = docp.SelectNodes("//StarRating")[0].InnerXml;
                                    }
                                    //api.TotalRating = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/TotalRating")[i].InnerText;
                                    //api.TotalReviews = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/TotalReviews")[i].InnerText;
                                    //api.TwentyFourHourCheckinAllowed = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/HotelInfo/TwentyFourHourCheckinAllowed")[i].InnerText;
                                    api.TwentyFourHourCheckinAllowed = "";
                                    XmlNodeList TwentyFourHourCheckinAllowed = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/HotelInfo/TwentyFourHourCheckinAllowed");
                                    foreach (XmlNode xnp in TwentyFourHourCheckinAllowed)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.TwentyFourHourCheckinAllowed = docp.SelectNodes("//TwentyFourHourCheckinAllowed")[0].InnerXml;
                                    }
                                    //api.DateUpdated = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/DateUpdated")[i].InnerText;
                                    api.DateUpdated = "";
                                    XmlNodeList DateUpdated = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/DateUpdated");
                                    foreach (XmlNode xnp in DateUpdated)
                                    {
                                        string str = xnp.OuterXml;
                                        XmlDocument docp = new XmlDocument();
                                        docp.LoadXml(str.ToString());
                                        api.DateUpdated = docp.SelectNodes("//DateUpdated")[0].InnerXml;
                                    }
                                    // Latitude & Longitude
                                    api.Latitude = "";
                                    api.Longitude = "";
                                    XmlNodeList XmlNodeListLatitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/AreaInfo/GeoLocation");
                                    foreach (XmlNode xnlat in XmlNodeListLatitude)
                                    {
                                        string str = xnlat.OuterXml;
                                        if (xnlat.InnerXml != "")
                                        {
                                            XmlDocument docp = new XmlDocument();
                                            docp.LoadXml(str.ToString());
                                            api.Latitude = docp.SelectNodes("//Latitude")[0].InnerXml;
                                            api.Longitude = docp.SelectNodes("//Longitude")[0].InnerXml;
                                        }
                                    }
                                    //api.Latitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Latitude")[i].InnerText;
                                    //api.Longitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Longitude")[i].InnerText;
                                    //
                                    command = new SqlCommand();
                                    UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName +
                                   ", SctId : " + user.SctId + ", Service : APIStaticDataDAO" +
                                   ", ProcName: Static Data Insert";
                                    command.CommandText = "Sp_StaticData_Insert";
                                    command.CommandType = CommandType.StoredProcedure;
                                    command.Parameters.Add("@HotalId", SqlDbType.NVarChar).Value = api.HotalId;
                                    command.Parameters.Add("@City", SqlDbType.NVarChar).Value = api.City;
                                    command.Parameters.Add("@CityCode", SqlDbType.NVarChar).Value = api.CityCode;
                                    command.Parameters.Add("@Country", SqlDbType.NVarChar).Value = api.Country;
                                    command.Parameters.Add("@CountryCode", SqlDbType.NVarChar).Value = api.CountryCode;
                                    command.Parameters.Add("@Line1", SqlDbType.NVarChar).Value = api.Line1;
                                    command.Parameters.Add("@Line2", SqlDbType.NVarChar).Value = api.Line2;
                                    command.Parameters.Add("@Pincode", SqlDbType.NVarChar).Value = api.Pincode;
                                    //command.Parameters.Add("@AlternateName", SqlDbType.NVarChar).Value = api.AlternateName;
                                    command.Parameters.Add("@DateUpdated", SqlDbType.NVarChar).Value = api.DateUpdated;
                                    command.Parameters.Add("@State", SqlDbType.NVarChar).Value = api.State;
                                    command.Parameters.Add("@Latitude", SqlDbType.NVarChar).Value = api.Latitude;
                                    command.Parameters.Add("@Longitude", SqlDbType.NVarChar).Value = api.Longitude;
                                    command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = api.Email;
                                    //command.Parameters.Add("@Fax", SqlDbType.NVarChar).Value = api.Fax;
                                    //command.Parameters.Add("@Mobile", SqlDbType.NVarChar).Value = api.Mobile;
                                    command.Parameters.Add("@ContactPerson", SqlDbType.NVarChar).Value = api.ContactPerson;
                                    command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = api.Phone;
                                    //command.Parameters.Add("@Facility", SqlDbType.NVarChar).Value = api.Facility;
                                    command.Parameters.Add("@CheckOutTime", SqlDbType.NVarChar).Value = api.CheckOutTime;
                                    command.Parameters.Add("@CheckInTime", SqlDbType.NVarChar).Value = api.CheckInTime;
                                    //command.Parameters.Add("@Contact", SqlDbType.NVarChar).Value = api.Contact;
                                    //command.Parameters.Add("@Currency", SqlDbType.NVarChar).Value = api.Currency;
                                    command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = api.Description;
                                    command.Parameters.Add("@HotalName", SqlDbType.NVarChar).Value = api.HotalName;
                                    //command.Parameters.Add("@Overallrating", SqlDbType.NVarChar).Value = api.Overallrating;
                                    //command.Parameters.Add("@Recommended", SqlDbType.NVarChar).Value = api.Recommended;
                                    command.Parameters.Add("@StarRating", SqlDbType.NVarChar).Value = api.StarRating;
                                    //command.Parameters.Add("@TotalRating", SqlDbType.NVarChar).Value = api.TotalRating;
                                    //command.Parameters.Add("@TotalReviews", SqlDbType.NVarChar).Value = api.TotalReviews;
                                    command.Parameters.Add("@TwentyFourHourCheckinAllowed", SqlDbType.NVarChar).Value = api.TwentyFourHourCheckinAllowed;
                                    command.Parameters.Add("@WebAddress", SqlDbType.NVarChar).Value = api.WebAddress;
                                    command.Parameters.Add("@Image", SqlDbType.NVarChar).Value = api.Image;
                                    //command.Parameters.Add("@Amenity", SqlDbType.NVarChar).Value = api.Amenity;
                                    command.Parameters.Add("@Area", SqlDbType.NVarChar).Value = api.Area;
                                    command.Parameters.Add("@HotelCount", SqlDbType.Int).Value = api.HotelCount;
                                    DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                                    try
                                    {
                                        int InsId = Convert.ToInt32(ds1.Tables[0].Rows[0][0].ToString());
                                    }
                                    catch (Exception ex)
                                    {
                                        CreateLogFiles Err = new CreateLogFiles();
                                        Err.ErrorLog("--> API Static Data Insert ERROR --> City Code : " + TmpCityCode + " -->" + ex.Message);
                                    }
                                }
                            }
                        } // 
                    }
                    else
                    {
                        CreateLogFiles Err = new CreateLogFiles();
                        Err.ErrorLog("Total > 500 - '" + TmpCityCode + "' - Total - " + api.Total);
                    }
                }
            }
            catch (Exception Ex)
            {
                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog(Ex.Message +" --> "+ TmpCityCode+" API Static Data Value Assign to Variable ERROR");
                //ErrdT.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            return ds;
        }
    }
}
