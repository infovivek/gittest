using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
namespace APIWindowsService
{
   public class StaticData
   {
       string TmpCityCode = "";
       public void staticDateFun()
       {
           try
           {
               SqlCommand command = new SqlCommand();
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
               DataSet dsCode = new WRBERPConnections().ExecuteDataSet(command, "");
               int CodeCnt = dsCode.Tables[0].Rows.Count;
               APIEntity api = new APIEntity();
               for (int Q = 0; Q < CodeCnt; Q++)
               {
                   StringBuilder Header = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?> ");
                   Header.Append("<MMTHotelsSearchResponse Total=\"284\" Rows=\"284\" Offset=\"0\">");
                   Header.Append("<POS><Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"AFF\" />");
                   Header.Append(" <Source iSOCurrency=\"INR\"/><Token>AFF13416</Token></POS><ResponseCode success=\"true\" />");
                   Header.Append(" <ResponseReferenceKey>GueMcx3aPmZ/zc608VdGuA==</ResponseReferenceKey> ");
                   Header.Append("<Hotel Id=\"201102091043011801\">");
                   Header.Append("<AreaInfo><Address><Areas><Area>OMR - Old Mahabalipuram Road</Area>");
                   Header.Append("<Area>West Chennai</Area></Areas><City>Chennai</City><CityCode>MAA</CityCode>");
                   Header.Append("<Country>India</Country><CountryCode>IN</CountryCode><Line1>3/80, Rajivgandhi Salai, OMR,Semmencherry</Line1>");
                   Header.Append("<Line2>OMR</Line2><Pincode>600119</Pincode><State>Tamilnadu</State></Address>");
                   Header.Append("<GeoLocation><Latitude>13.044028</Latitude><Longitude>80.237961</Longitude></GeoLocation>");
                   Header.Append("</AreaInfo><ContactInfo><Email>Balaji@hotelkgroup.com,reservations@hotelkgroup.com,</Email>");
                   Header.Append(" <Fax /><Mobile>91-9094094346</Mobile><ContactPerson>Mr</ContactPerson><Phone1>91-044-24500455</Phone1> ");
                   Header.Append("</ContactInfo><Facilities><Facility>Laundry Service</Facility><Facility>Doctor on Call</Facility> ");
                   Header.Append("<Facility>Parking Facility</Facility><Facility>Outdoor Activities</Facility><Facility>Dining Hall</Facility> ");
                   Header.Append("<Facility>Indoor Multi Cuisine Restaurant</Facility><Facility>Coffee Shop</Facility><Facility>Taxi Services</Facility> ");
                   Header.Append("<Facility>Room Service 24 Hrs</Facility><Facility>Bar</Facility><Facility>Guide Service</Facility>");
                   Header.Append("<Facility>Railway Station Transfer</Facility><Facility>Handicap Facilities</Facility><Facility>Conference Hall</Facility> ");
                   Header.Append("<Facility>Airport Transfer</Facility><Facility>Executive Lounge</Facility></Facilities><HotelInfo><AlternateNames>");
                   Header.Append("<AlternateName /></AlternateNames><CheckInTime>12 PM</CheckInTime><CheckOutTime>12 PM</CheckOutTime><Contact>Mr</Contact> ");
                   Header.Append(" <Currency>INR</Currency><Description>Hotel Kensington is located at a distance of 3.4 km from St. Josephs College of Engineering. It features a multi-cuisine restaurant, coffee shop and travel desk Hotel Kensington is located in the Sholinganallur area of Chennai, opposite the Satyabhama University. The hotel maintains 24 well-furnished rooms that are classified into three categories, namely Standard, Deluxe and Suite. In-room amenities include television set, air-conditioner, tea/coffee maker, electronic safe, fireplace, intercom and ironing board.This hotel features a multi-purpose hall that can be utilised to host corporate as well as social events. Major IT hubs of the city, including Sholinganallur IT park and Siruseri IT park, are in the vicinity of the hotel, thereby making it an ideal pick for business travellers. Facilities provided by the hotel to its guests include laundry, travel desk and doctor-on-call. Hotel Kensington features a multi-cuisine restaurant, which serves a wide range of local and international dishes. In addition, this hotel has a coffee shop and a bar, where people can have a gala time. Uthandi Beach is a popular attraction, located at a 15-minute drive from the hotel.</Description> ");
                   Header.Append("<Name>Hotel Kensington</Name><Overallrating>4</Overallrating><Recommended>false</Recommended><StarRating>2</StarRating><TotalRating>5</TotalRating>  <TotalReviews>1</TotalReviews> <TwentyFourHourCheckinAllowed>false</TwentyFourHourCheckinAllowed> <WebAddress>www.hotelkgroup.com</WebAddress> ");
                   Header.Append("</HotelInfo><HotelMedia><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Hotel_Entrance.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Corridor.jpg</Src> ");
                   Header.Append(" <Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Restaurant_1.jpg</Src>");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Restaurant_2.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_3.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_4.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_6.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>true</Main><Src>http://images1.makemytrip.com/mmtimgs/images/upload/HotelKensington_Hotel_Entrance_Listing.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media></HotelMedia><DateUpdated>2014-07-23</DateUpdated><RoomMedia><Media><Main>false</Main> ");
                   Header.Append("<RoomCode>1</RoomCode><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_1.jpg</Src><Type>Image</Type> ");
                   Header.Append("</Media><Media><Main>false</Main><RoomCode>2</RoomCode><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_2.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><RoomCode>3</RoomCode><Src>http://images5.makemytrip.com/images/hotels/201102091043011801/Room_5.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media></RoomMedia><Rooms><Room><Amenities><Amenity>Tea/Coffee Maker</Amenity><Amenity>Electronic Safe</Amenity>");
                   Header.Append("<Amenity>Ironing Board</Amenity><Amenity>Bathroom Toiletries</Amenity><Amenity>Mineral Water</Amenity><Amenity>Daily Newspaper</Amenity><Amenity>Dining Table</Amenity><Amenity>Study Table</Amenity><Amenity>Living Room</Amenity><Amenity>Sofa Unit</Amenity> ");
                   Header.Append("<Amenity>Fireplace</Amenity><Amenity>Direct dial phone</Amenity><Amenity>Safe Deposit Locker</Amenity><Amenity>Cable T V</Amenity><Amenity>Intercom Facility</Amenity><Amenity>Geyser In Bathroom</Amenity> <Amenity>Hot/cold Water</Amenity> ");
                   Header.Append("<Amenity>Iron</Amenity></Amenities><Code>1</Code><RoomDescription>Suite</RoomDescription><Name>Suite</Name></Room><Room><Amenities><Amenity>Tea/Coffee Maker</Amenity><Amenity>Electronic Safe</Amenity><Amenity>Ironing Board</Amenity> ");
                   Header.Append("<Amenity>Bathroom Toiletries</Amenity><Amenity>Mineral Water</Amenity><Amenity>Daily Newspaper</Amenity><Amenity>Dining Table</Amenity><Amenity>Study Table</Amenity><Amenity>Sofa Unit</Amenity><Amenity>Fireplace</Amenity>");
                   Header.Append("<Amenity>Direct dial phone</Amenity><Amenity>Safe Deposit Locker</Amenity><Amenity>Cable T V</Amenity><Amenity>Intercom Facility</Amenity><Amenity>Geyser In Bathroom</Amenity><Amenity>Hot/cold Water</Amenity>");
                   Header.Append("<Amenity>Iron</Amenity></Amenities><Code>2</Code><RoomDescription>Standard</RoomDescription><Name>Standard</Name></Room><Room><Amenities><Amenity>Tea/Coffee Maker</Amenity><Amenity>Electronic Safe</Amenity><Amenity>Ironing Board</Amenity> ");
                   Header.Append("<Amenity>Bathroom Toiletries</Amenity><Amenity>Mineral Water</Amenity><Amenity>Daily Newspaper</Amenity><Amenity>Dining Table</Amenity><Amenity>Study Table</Amenity><Amenity>Sofa Unit</Amenity><Amenity>Fireplace</Amenity>");
                   Header.Append("<Amenity>Direct dial phone</Amenity> <Amenity>Safe Deposit Locker</Amenity><Amenity>Cable T V</Amenity><Amenity>Intercom Facility</Amenity><Amenity>Geyser In Bathroom</Amenity><Amenity>Hot/cold Water</Amenity> ");
                   Header.Append("<Amenity>Iron</Amenity></Amenities><Code>3</Code><RoomDescription>Deluxe</RoomDescription><Name>Deluxe</Name></Room></Rooms></Hotel>");
                   Header.Append("<Hotel Id=\"201210011058574252\"><AreaInfo><Address><Areas><Area>Tambram Sanatorium</Area></Areas><City>Chennai</City><CityCode>MAA</CityCode>");
                   Header.Append("<Country>India</Country><CountryCode>IN</CountryCode><Line1>No - 347/30, A . Muthuranuia Mudua Street</Line1>");
                   Header.Append("<Line2>Tambaram</Line2><Pincode>600045</Pincode><State>Tamil Nadu</State></Address>");
                   Header.Append("<GeoLocation><Latitude>13.060422</Latitude><Longitude>80.249583</Longitude></GeoLocation>");
                   Header.Append("</AreaInfo><ContactInfo><Email>hkcorporatesales@gmail.com,</Email><Fax /><Mobile>91-9094094346</Mobile><ContactPerson>Mr</ContactPerson> ");
                   Header.Append("<Phone1>91-044-22265678</Phone1></ContactInfo><Facilities><Facility>Laundry Service</Facility><Facility>Doctor on Call</Facility>");
                   Header.Append("<Facility>Internet Facility</Facility><Facility>Taxi Services</Facility><Facility>Wifi Enabled</Facility><Facility>Guide Service</Facility> ");
                   Header.Append("<Facility>Railway Station Transfer</Facility><Facility>Conference Hall</Facility><Facility>Airport Transfer</Facility><Facility>Room Service</Facility>");
                   Header.Append("</Facilities><HotelInfo><AlternateNames><AlternateName /> </AlternateNames><CheckInTime>12 PM</CheckInTime><CheckOutTime>12 PM</CheckOutTime> ");
                   Header.Append("<Contact>Mr</Contact><Currency>INR</Currency><Description>A five minute drive from International Airport, Hotel Le Repose features a well-equipped conference hall for arranging corporate meetings and private parties. Free wi-fi access is available. Simply furnished, air conditioned rooms are fitted with a television, intercom, mini bar, tea/coffee maker, refrigerator and fruit basket. Private bathrooms include shower facilities. Free toiletries are also provided.Car rental and sightseeing bookings can be made at the tour desk. Staff can assist with doctor on call and laundry service. Airport/railway transfers are available. Free guide service is also offered.</Description> ");
                   Header.Append("<Name>Hotel Le Repose</Name><Overallrating>3.2</Overallrating><PropertyType>Business Boutique Hotel</PropertyType> <Recommended>false</Recommended> ");
                   Header.Append("<StarRating>1</StarRating><TotalRating>5</TotalRating><TotalReviews>2</TotalReviews><TwentyFourHourCheckinAllowed>false</TwentyFourHourCheckinAllowed><WebAddress>www.hotellerepose.com</WebAddress> ");
                   Header.Append("</HotelInfo><HotelMedia><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Exterior_View_.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Executive_Room_1_.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Executive_Room_2_.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Room_1.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>false</Main><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Room_2.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media><Media><Main>true</Main><Src>http://images1.makemytrip.com/mmtimgs/images/upload/HotelLeRepose_Executive_Room_1__Listing.jpg</Src> ");
                   Header.Append("<Type>Image</Type></Media></HotelMedia><DateUpdated>2014-07-23</DateUpdated><RoomMedia><Media><Main>false</Main><RoomCode>4</RoomCode> ");
                   Header.Append("<Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Hotel-Le-Repose-Chennai-Executive-Room-2_.jpg</Src> ");
                   Header.Append("<Type>Image</Type> </Media><Media><Main>false</Main> <RoomCode>4</RoomCode><Src>http://images5.makemytrip.com/images/hotels/201210011058574252/Hotel-Le-Repose-Chennai-Executive-Room-1_.jpg</Src>");
                   Header.Append("<Type>Image</Type> </Media> </RoomMedia> <Rooms> <Room><Amenities><Amenity>Minibar</Amenity> <Amenity>Tea/Coffee Maker</Amenity> <Amenity>Ironing Board</Amenity>");
                   Header.Append("<Amenity>Bathroom Toiletries</Amenity><Amenity>Mineral Water</Amenity><Amenity>Fruit Basket</Amenity><Amenity>Daily Newspaper</Amenity> ");
                   Header.Append("<Amenity>Air Conditioning</Amenity><Amenity>Room Heater</Amenity><Amenity>Study Table</Amenity><Amenity>Satellite television</Amenity>");
                   Header.Append("<Amenity>Safety Deposit Box</Amenity><Amenity>Refrigerator</Amenity><Amenity>Cable T V</Amenity><Amenity>Intercom Facility</Amenity><Amenity>Shower Area</Amenity> ");
                   Header.Append("<Amenity>Geyser In Bathroom</Amenity> <Amenity>Hot/cold Water</Amenity><Amenity>Iron</Amenity><Amenity>Wi-fi</Amenity></Amenities><Code>4</Code><RoomDescription>Executive</RoomDescription>");
                   Header.Append("<Name>Executive</Name> </Room></Rooms></Hotel></MMTHotelsSearchResponse>");
                   string NewHeader = Header.ToString();
                   //api.CityId = Convert.ToInt32(dsCode.Tables[0].Rows[Q][1].ToString());
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
                   StrBuil.Append("<MMTHotelSearchRequest Rows=\"0\" Offset=\"0\">");
                   StrBuil.Append("<POS>");
                   StrBuil.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF14453\" channel=\"AFF\"/>");
                   StrBuil.Append("<Source iSOCurrency=\"INR\"/>");
                   StrBuil.Append("<Token>AFF14453</Token>");
                   StrBuil.Append("</POS>");
                   StrBuil.Append("<RequestHotelParams>");
                   //StrBuil.Append("<CityCode>AGR</CityCode>");
                   TmpCityCode = dsCode.Tables[0].Rows[Q][0].ToString();
                   StrBuil.Append("<CityCode>" + dsCode.Tables[0].Rows[Q][0].ToString() + "</CityCode>");                   
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
                   command = new SqlCommand();
                   DataSet ds = new DataSet();
                   XmlDocument document = new XmlDocument();
                   //document.LoadXml(NewHeader);
                   document.LoadXml(resulXmlFromWebService);
                   int n;
                   n = (document).SelectNodes("//Hotel").Count;
                   api.HotelCount = n;
                   for (int i = 0; i < n; i++)
                   {
                       api.HotalId = document.SelectNodes("//Hotel")[i].Attributes["Id"].Value;
                       if (api.HotalId == "201301221658026139")
                       {
                           string ASD = "";
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
                                   XmlDocument docp = new XmlDocument();
                                   docp.LoadXml(str.ToString());
                                   api.Latitude = docp.SelectNodes("//Latitude")[0].InnerXml;
                                   api.Longitude = docp.SelectNodes("//Longitude")[0].InnerXml;
                               }
                               //api.Latitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Latitude")[i].InnerText;
                               //api.Longitude = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel/AreaInfo/GeoLocation/Longitude")[i].InnerText;
                               //
                               command = new SqlCommand();
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
                               //command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = api.CityId;
                               ds = new WRBERPConnections().ExecuteDataSet(command, "");
                               /*AreasCount = 0;
                               XmlNodeList xnList2 = document.DocumentElement.SelectNodes("/MMTHotelsSearchResponse/Hotel[@Id=" + api.HotalId + "]/Rooms/Room");
                               foreach (XmlNode xn in xnList2)
                               {
                                   api.Code = xn["Code"].InnerText;
                                   api.RoomDescription = xn["RoomDescription"].InnerText;
                                   api.RoomName = xn["Name"].InnerText;
                                   command = new SqlCommand();
                                   command.CommandText = "Sp_StaticDataDetails_Insert";
                                   command.CommandType = CommandType.StoredProcedure;
                                   command.Parameters.Add("@Code", SqlDbType.NVarChar).Value = api.Code;
                                   command.Parameters.Add("@RoomDescription", SqlDbType.NVarChar).Value = api.RoomDescription;
                                   command.Parameters.Add("@RoomName", SqlDbType.NVarChar).Value = api.RoomName;
                                   command.Parameters.Add("@StaticHotalsId", SqlDbType.BigInt).Value = ds.Tables[0].Rows[0][0].ToString();
                                   DataSet ds1 = new WRBERPConnections().ExecuteDataSet(command, "");
                               }*/
                           }
                       }
                   }
               }
           }
           catch (Exception Ex)
           {
               CreateLogFile Err = new CreateLogFile();
               string fdf = TmpCityCode;
               Err.ErrorLog(Ex.Message);
               //ErrdT.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
           }
           finally
           {
               //dsResult.Tables.Add(ErrdT); ErrdT.Dispose(); ErrdT = null;
           }

       }
    }
}
