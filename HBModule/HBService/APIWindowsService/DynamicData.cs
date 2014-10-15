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
    public class DynamicData
    {
        public void DynamicDateFun()
        {
            StringBuilder Header = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?> ");
            Header.Append("<MMTHotelSearchResponse><AllHotels>true</AllHotels> <POS>");
            Header.Append("<Requestor type=\"B2C\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2Cweb\" /> ");
            Header.Append("<Source iSOCurrency=\"INR\" /></POS><ResponseCode success=\"true\" /><ResponseReferenceKey>8dcL2oQxH4pnI0/RWiSWBA==</ResponseReferenceKey>");
            Header.Append("<HotelSearchResults total=\"4\" page=\"1\" limit=\"4\"><Hotels><Hotel id=\"20120928153050770\" chainCode=\"25hours Hotels\">");
            Header.Append("<IsMysteryHotel>false</IsMysteryHotel><Name>HotelOneDoNotBook</Name><PropertyInfo><Facets><Facet group=\"starRating\">");
            Header.Append("<FacetValue>3</FacetValue></Facet><Facet group=\"chain\"><FacetValue>25hours Hotels</FacetValue></Facet><Facet group=\"amenities\">");
            Header.Append("<FacetValues><FacetValue>Gym</FacetValue><FacetValue>Personal Conveniences</FacetValue><FacetValue>Spa/Massage/Wellness</FacetValue> ");
            Header.Append("<FacetValue>Restaurant/Bar</FacetValue><FacetValue>Laundry Services</FacetValue><FacetValue>Doctor on Call</FacetValue> ");
            Header.Append("<FacetValue>Group 1</FacetValue><FacetValue>Internet/Wi-Fi</FacetValue><FacetValue>Sports</FacetValue><FacetValue>Business Facilities</FacetValue> ");
            Header.Append("<FacetValue>Disabled Facilities</FacetValue></FacetValues></Facet></Facets><GuestRecommendations totalRecommendations=\"5\">");
            Header.Append("<IndividualGuestRecommendations><IndividualGuestRecommendation recommended=\"false\"><Comment>Vaah!! vaah raamji!! jodi kya banayi!!</Comment> ");
            Header.Append("<DateTime>2014-05-27</DateTime><Rating maxRating=\"5.0\">1.0</Rating><UserName>Test Test</UserName></IndividualGuestRecommendation>");
            Header.Append("</IndividualGuestRecommendations><OverallRecommendation recommended=\"false\">");
            Header.Append("<Comment>Vaah!! vaah raamji!! jodi kya banayi!!</Comment><DateTime>2014-05-27</DateTime><Rating maxRating=\"5.0\">1.0</Rating>");
            Header.Append("<UserName>Test Test</UserName></OverallRecommendation></GuestRecommendations><MediaList>");
            Header.Append("<Media type=\"Image\" src=\"http://images1.makemytrip.com/mmtimgs/images/upload/HotelOneDoNotBook_Room_1_Listing.jpg\" main=\"true\" />");
            Header.Append("</MediaList><Promotions><Promotion promoType=\"deal\" promoLevel=\"TARIFF_LEVEL\" priceSlasher=\"true\" code=\"48173871371894012\">Early Bird Discount &#045; 15&#037; Off&#046;&#046;&#046;&#046;&#033;&#033;&#033;&#033;</Promotion>");
            Header.Append("</Promotions><RoomStays><RoomStay startDate=\"2014-08-28\" endDate=\"2014-08-29\" availStatus=\"E\"><RoomTypes>");
            Header.Append("<RoomType name=\"Royal Suite Palace\" code=\"5170\" /> <RoomType name=\"Presedential Suit\" code=\"4940\" /> ");
            Header.Append("<RoomType name=\"Viceroy Suite\" code=\"1411\" /> ");
            Header.Append("</RoomTypes><RatePlans><RatePlan type=\"ONLINE\" name=\"33000452740928\" code=\"33000452740928\">");
            Header.Append("<Inclusions><Inclusion start=\"2014-08-28\" end=\"2014-08-29\" code=\"Test\">Test</Inclusion>");
            Header.Append("</Inclusions><MealPlans><MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"CP\">Breakfast</MealPlan>");
            Header.Append("</MealPlans></RatePlan><RatePlan type=\"OFFLINE\" name=\"66981320574804\" code=\"66981320574804\">");
            Header.Append("<Inclusions><Inclusion start=\"2014-08-28\" end=\"2014-08-29\" code=\"free use of children play area\">free use of children play area</Inclusion>");
            Header.Append("</Inclusions><MealPlans><MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"EP\">Room Only</MealPlan>");
            Header.Append("</MealPlans></RatePlan><RatePlan type=\"OFFLINE\" name=\"6367720745070\" code=\"6367720745070\"><MealPlans>");
            Header.Append("<MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"EP\">Room Only</MealPlan>");
            Header.Append("</MealPlans></RatePlan><RatePlan type=\"OFFLINE\" name=\"21894540182198\" code=\"21894540182198\"><Inclusions>");
            Header.Append("<Inclusion start=\"2014-08-28\" end=\"2014-08-29\" code=\"free room nights use of gymnasuim\">free room nights use of gymnasuim</Inclusion>");
            Header.Append("</Inclusions><MealPlans><MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"EP\">Room Only</MealPlan>");
            Header.Append("</MealPlans></RatePlan><RatePlan type=\"OFFLINE\" name=\"23438906557264_OFFBAR\" code=\"23438906557264_OFFBAR\">");
            Header.Append("<Inclusions><Inclusion start=\"2014-08-28\" end=\"2014-08-29\" code=\"free room nights use of gymnasuim\">free room nights use of gymnasuim</Inclusion> ");
            Header.Append("</Inclusions><MealPlans><MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"EP\">Room Only</MealPlan>");
            Header.Append("</MealPlans></RatePlan></RatePlans><RoomRates><RoomRate roomTypeCode=\"1411\" ratePlanCode=\"23438906557264_OFFBAR\" inclusionAndPolicyAvail=\"true\" availableCount=\"10\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"100.0\" /><CancellationAmount CurrencyCode=\"INR\">2959</CancellationAmount> ");
            Header.Append("</CancelPenaltyRule></CancelPenaltyRules><PenaltyDescription>This is a special NON-REFUNDABLE rate. 100% of booking amount will be forfeited in case of cancellation.If a booking is cancelled or changed by the customer, the hotel will be notified (of the changes) and the original confirmation email and Booking ID that was generated will become null and void.</PenaltyDescription>");
            Header.Append("</CancelPenalty></CancelPenalties><PromotionReferences><Promotion code=\"48173871371894012\" /> ");
            Header.Append("</PromotionReferences></Rate></RoomRate><RoomRate roomTypeCode=\"4940\" ratePlanCode=\"21894540182198\" inclusionAndPolicyAvail=\"true\" availableCount=\"10\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"100.0\" /><CancellationAmount CurrencyCode=\"INR\">3371</CancellationAmount>");
            Header.Append("</CancelPenaltyRule> </CancelPenaltyRules><PenaltyDescription>This is a special NON-REFUNDABLE rate. 100% of booking amount will be forfeited in case of cancellation.If a booking is cancelled or changed by the customer, the hotel will be notified (of the changes) and the original confirmation email and Booking ID that was generated will become null and void.</PenaltyDescription>");
            Header.Append("</CancelPenalty></CancelPenalties><PromotionReferences><Promotion code=\"48173871371894012\" /> </PromotionReferences>");
            Header.Append("</Rate> </RoomRate><RoomRate roomTypeCode=\"5170\" ratePlanCode=\"6367720745070\" inclusionAndPolicyAvail=\"true\" availableCount=\"10\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"100.0\" /> <CancellationAmount CurrencyCode=\"INR\">13794</CancellationAmount></CancelPenaltyRule>");
            Header.Append("</CancelPenaltyRules><PenaltyDescription>This is a special NON-REFUNDABLE rate. 100% of booking amount will be forfeited in case of cancellation.If a booking is cancelled or changed by the customer, the hotel will be notified (of the changes) and the original confirmation email and Booking ID that was generated will become null and void.</PenaltyDescription>");
            Header.Append("</CancelPenalty></CancelPenalties><PromotionReferences><Promotion code=\"48173871371894012\" />");
            Header.Append("</PromotionReferences></Rate></RoomRate><RoomRate roomTypeCode=\"5170\" ratePlanCode=\"66981320574804\" inclusionAndPolicyAvail=\"true\" availableCount=\"10\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"100.0\" /><CancellationAmount CurrencyCode=\"INR\">3072</CancellationAmount>");
            Header.Append("</CancelPenaltyRule></CancelPenaltyRules><PenaltyDescription>This is a special NON-REFUNDABLE rate. 100% of booking amount will be forfeited in case of cancellation.If a booking is cancelled or changed by the customer, the hotel will be notified (of the changes) and the original confirmation email and Booking ID that was generated will become null and void.</PenaltyDescription>");
            Header.Append("</CancelPenalty></CancelPenalties><PromotionReferences><Promotion code=\"48173871371894012\" /></PromotionReferences>");
            Header.Append("</Rate></RoomRate><RoomRate roomTypeCode=\"5170\" ratePlanCode=\"33000452740928\" inclusionAndPolicyAvail=\"true\" availableCount=\"50\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"0.0\" /><CancellationAmount CurrencyCode=\"INR\">0</CancellationAmount></CancelPenaltyRule>");
            Header.Append("</CancelPenaltyRules><PenaltyDescription>No Fuss refunds only with Makemytrip.com! This booking is FULLY REFUNDABLE in case of cancellation.</PenaltyDescription> ");
            Header.Append("</CancelPenalty></CancelPenalties><PromotionReferences /> </Rate></RoomRate></RoomRates></RoomStay></RoomStays></PropertyInfo>");
            Header.Append("</Hotel><Hotel id=\"201402171424382003\" chainCode=\"Haky Hotel Inns\"><IsMysteryHotel>false</IsMysteryHotel><Name>HotelThreeDoNotBook</Name>");
            Header.Append("<PropertyInfo><Facets><Facet group=\"starRating\"><FacetValue>3</FacetValue> </Facet><Facet group=\"chain\"><FacetValue>Haky Hotel Inns</FacetValue>");
            Header.Append("</Facet><Facet group=\"amenities\"><FacetValues><FacetValue>Gym</FacetValue></FacetValues></Facet></Facets><MediaList><Media type=\"Image\" src=\"http://images1.makemytrip.com/mmtimgs/images/upload/HotelThreeDoNotBook_Lounge_Listing.jpg\" main=\"true\" />");
            Header.Append("</MediaList><Promotions /> <RoomStays><RoomStay startDate=\"2014-08-28\" endDate=\"2014-08-29\" availStatus=\"E\">");
            Header.Append("<RoomTypes><RoomType name=\"Anu testing\" code=\"40303\" /> </RoomTypes><RatePlans><RatePlan type=\"OFFLINE\" name=\"57646568704983_OFFBAR\" code=\"57646568704983_OFFBAR\">");
            Header.Append("<Inclusions><Inclusion start=\"2014-08-28\" end=\"2014-08-29\" code=\"free room nights use of gymnasuim\">free room nights use of gymnasuim</Inclusion>");
            Header.Append("</Inclusions><MealPlans><MealPlan start=\"2014-08-28\" end=\"2014-08-29\" code=\"EP\">Room Only</MealPlan>");
            Header.Append("</MealPlans></RatePlan></RatePlans><RoomRates><RoomRate roomTypeCode=\"40303\" ratePlanCode=\"57646568704983_OFFBAR\" inclusionAndPolicyAvail=\"true\" availableCount=\"10\" availStatus=\"E\">");
            Header.Append("<Rate><CancelPenalties><CancelPenalty><CancelPenaltyRules><CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"7.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"100.0\" /><CancellationAmount CurrencyCode=\"INR\">1239</CancellationAmount></CancelPenaltyRule>");
            Header.Append("<CancelPenaltyRule><Deadline OffsetUnitMultiplier=\"99999.0\" OffsetTimeUnit=\"day\" offSetDropTime=\"BeforeArrival\" />");
            Header.Append("<AmountPercent percent=\"0.0\" /><CancellationAmount CurrencyCode=\"INR\">0</CancellationAmount></CancelPenaltyRule></CancelPenaltyRules>");
            Header.Append("<PenaltyDescription>More than 7 days before check-in date: FREE CANCELLATION. 7 days before check-in date: no refund. In case of no show: no refund. An additional MakeMyTrip service charge of INR 250 will apply</PenaltyDescription> ");
            Header.Append("</CancelPenalty> </CancelPenalties></Rate></RoomRate></RoomRates></RoomStay></RoomStays></PropertyInfo></Hotel></Hotels></HotelSearchResults></MMTHotelSearchResponse>");
            string NewHeader = Header.ToString();

            //WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/staticsearch/v1.0/hotelData");
            WebRequest webRequest = WebRequest.Create("https://apim-gateway.mmtcloud.com/mmt-htlsearch/1.0/search/v1.0/hotelSearch");
            HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
            httpRequest.Method = "POST";
            httpRequest.ContentType = "application/xml; charset=utf-8";
            httpRequest.Headers.Add("MI_XMLPROTOCOLREQUEST", "MatrixRouteRequest");
            httpRequest.Headers.Add("Authorization", "Basic QUZGMTM0MTY6YWZmQDEyMw==, Bearer a6689e5ff46f0604151205f79c63b7b");

            httpRequest.ProtocolVersion = HttpVersion.Version11;
            httpRequest.Credentials = CredentialCache.DefaultCredentials;
            httpRequest.Timeout = 100000000;
            Stream requestStream = httpRequest.GetRequestStream();
            //Create Stream and Complete Request             
            StreamWriter streamWriter = new StreamWriter(requestStream, Encoding.ASCII);
            StringBuilder soapRequest = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            /*soapRequest.Append("<MMTHotelSearchRequest Rows=\"0\" Offset=\"0\">");
            soapRequest.Append("<POS>");
            soapRequest.Append("<Requestor type=\"AFF\" idContext=\"AFF\" id=\"AFF13416\" channel=\"AFF\"/>");
            soapRequest.Append("<Source iSOCurrency=\"INR\"/>");
            soapRequest.Append("<Token>AFF13416</Token>");
            soapRequest.Append("</POS>");
            soapRequest.Append("<RequestHotelParams>");
            soapRequest.Append("<CityCode>BOM</CityCode>");
            soapRequest.Append("<CityName/>");
            soapRequest.Append("<Country/>");
            soapRequest.Append("<CountryCode>IN</CountryCode>");
            soapRequest.Append("<HotelId/>");
            soapRequest.Append("</RequestHotelParams>");
            soapRequest.Append("<RequiredFields/>");
            soapRequest.Append("</MMTHotelSearchRequest>");*/
            soapRequest.Append("<MMTHotelSearchRequest>");
            soapRequest.Append("<POS>");
            soapRequest.Append("<Requestor type=\"B2C\" idContext=\"AFF\" id=\"AFF13416\" channel=\"B2Cweb\"/>");
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
            soapRequest.Append("<CityCode>MAA</CityCode>");
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
            soapRequest.Append("<StayDateRange start=\"2014-10-28\" end=\"2014-10-29\"/>");
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
            StreamReader srd = new StreamReader(wr.GetResponseStream());
            string resulXmlFromWebService = srd.ReadToEnd();

            DynamicEntity api = new DynamicEntity();
            SqlCommand command = new SqlCommand();
            DataSet ds = new DataSet();
            XmlDocument document = new XmlDocument();
            //document.LoadXml(NewHeader);
            document.LoadXml(resulXmlFromWebService);            
            int n;
            int StarRatingCount = 0;
            int RoomTypesCount = 0;
            int RoomTypeCount = 0;
            int Tariffcount = 0;
            n = document.SelectNodes("//Hotel").Count;
            int InclusionCount = 0;
            for (int i = 0; i < n; i++)
            {
                api.HotalId = document.SelectNodes("//Hotel")[i].Attributes["id"].Value;
                StarRatingCount = 0;
                XmlNodeList xnList11 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/Facets/Facet");
                foreach (XmlNode xn in xnList11)
                {
                    if (xn.SelectNodes("//Facet")[StarRatingCount].Attributes["group"].Value.ToString() == "starRating")
                    {
                        api.StarRating = xn["FacetValue"].InnerText;
                    }
                    StarRatingCount += 1;
                }
                //RoomTypesCount = 0;                
                XmlNodeList xnList12 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RoomTypes/RoomType");
                foreach (XmlNode xn in xnList12)
                {
                    api.RoomTypeName = xn.SelectNodes("//RoomType")[RoomTypesCount].Attributes["name"].Value;
                    api.RoomTypeCode = xn.SelectNodes("//RoomType")[RoomTypesCount].Attributes["code"].Value;                    
                    XmlNodeList xnList121 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "]/Rate/RoomTariffs/RoomTariff");
                    foreach (XmlNode xnR in xnList121)
                    {
                        api.RoomTariffroomNumber = xnR.SelectNodes("//RoomTariff")[RoomTypeCount].Attributes["roomNumber"].Value;
                        XmlNodeList xnList122 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate[@roomTypeCode=" + api.RoomTypeCode + "]/Rate/RoomTariffs/RoomTariff[@roomNumber=" + api.RoomTariffroomNumber + "]/Tariffs/Tariff");
                        foreach (XmlNode xnn in xnList122)
                        {
                            api.Tarifftype = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["type"].Value;
                            api.Tariffgroup = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["group"].Value;
                            api.Tariffamount = xnn.SelectNodes("//Tariff")[Tariffcount].Attributes["amount"].Value;
                            Tariffcount += 1;
                        }
                        RoomTypeCount += 1;
                    }
                    RoomTypesCount += 1;
                }
                decimal div = 0;
                int loopcnt = 0;
                bool flag = true;
                api.InclusionCode = "";
                XmlNodeList xnList31 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
                XmlNodeList xnList3 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan/Inclusions/Inclusion");
                if (xnList3.Count > 0)
                {
                    if(xnList31.Count >= xnList3.Count)
                    {
                        div = xnList31.Count / xnList3.Count;
                    }
                    if (xnList31.Count <= xnList3.Count)
                    {
                        div = xnList3.Count / xnList31.Count;
                    }
                    decimal Cnt = Math.Floor(div);
                    foreach (XmlNode xn in xnList3)
                    {
                        if (Cnt > loopcnt)
                        {
                            if (flag == false)
                            {
                                api.InclusionCode += "," + xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["code"].Value;
                            }
                            if (flag == true)
                            {
                                api.InclusionCode += xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["code"].Value;
                                flag = false;
                            }                            
                        }
                        InclusionCount += 1;
                        loopcnt += 1;
                    }                   
                }
            }
        }
    }
}
                /*AreasCount = 0; 
                XmlNodeList xnList3 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
               foreach (XmlNode xn in xnList3)
               {
                   api.RatePlanType = xn.SelectNodes("//RatePlan")[InclusionCount].Attributes["type"].Value;
                   api.RatePlanName = xn.SelectNodes("//RatePlan")[InclusionCount].Attributes["name"].Value;
                   api.RatePlanCode = xn.SelectNodes("//RatePlan")[InclusionCount].Attributes["code"].Value;
                   api.InclusionStart = xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["start"].Value;
                   api.InclusionEnd = xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["end"].Value;
                   api.InclusionCode = xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["code"].Value;
                   api.Inclusion = xn.SelectNodes("//Inclusion")[InclusionCount].InnerText;
                   api.MealPlan = xn.SelectNodes("//MealPlan")[AreasCount].InnerText;
                   InclusionCount += xnList3.Count;
               }
                XmlNodeList xnList3 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
                foreach (XmlNode xn in xnList3)
                {
                    for (int qsc = 0; qsc < 1; qsc++)
                    {
                        api.RatePlanType = xn.SelectNodes("//RatePlan")[InclusionCount].Attributes["type"].Value;
                        api.RatePlanName = xn.SelectNodes("//RatePlan")[InclusionCount].Attributes["name"].Value;
                        api.InclusionCode = xn.SelectNodes("//Inclusion")[InclusionCount].Attributes["code"].Value;
                        /*XmlNodeList xnList31 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan [@name="+api.RatePlanName+"]/Inclusions/Inclusion");
                        foreach (XmlNode xnn in xnList31)
                        {
                            api.InclusionCode = xn.SelectNodes("//Inclusion")[0].Attributes["code"].Value;
                            RtPlnName += 1;
                        }
                    }
                }*/
                   /*if (AreasCount == 0)
                   {
                       api.Facetgroup = xn.SelectNodes("//Facet")[AreasCount].Attributes["group"].Value;
                       api.FacetValue = xn["FacetValue"].InnerText;
                       AreasCount = 1;
                   }
                   else
                   {
                       api.Facetgroup += "," + xn.SelectNodes("//Facet")[AreasCount].Attributes["group"].Value;
                       if (xn.SelectNodes("//Facet")[AreasCount].Attributes["group"].Value.ToString() == "amenities")
                       {
                           XmlNodeList xnList2 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/Facets/Facet/FacetValues/FacetValue");
                           foreach (XmlNode xnn in xnList2)
                           {
                               api.FacetValue += "," + xnn.InnerText;
                           }
                       }
                       else
                       {
                           api.FacetValue += "," + xn["FacetValue"].InnerText;
                       }
                       AreasCount += 1;
                   }
               }
               command = new SqlCommand();
               command.CommandText = "Sp_StaticData_Insert";
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@HotalId", SqlDbType.NVarChar).Value = api.HotalId;
               command.Parameters.Add("@ChainCode", SqlDbType.NVarChar).Value = api.chainCode;
               command.Parameters.Add("@IsMysteryHotel", SqlDbType.NVarChar).Value = api.IsMysteryHotel;
               command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = api.Name;
               command.Parameters.Add("@Facetgroup", SqlDbType.NVarChar).Value = api.Facetgroup;
               command.Parameters.Add("@FacetValue", SqlDbType.NVarChar).Value = api.FacetValue;
               ds = new WRBERPConnections().ExecuteDataSet(command, "");

               AreasCount = 0;
               XmlNodeList xnList3 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RatePlans/RatePlan");
               foreach (XmlNode xn in xnList3)
               {
                   api.RatePlanType = xn.SelectNodes("//RatePlan")[AreasCount].Attributes["type"].Value;
                   api.RatePlanName = xn.SelectNodes("//RatePlan")[AreasCount].Attributes["name"].Value;
                   api.RatePlanCode = xn.SelectNodes("//RatePlan")[AreasCount].Attributes["code"].Value;
                   api.InclusionStart = xn.SelectNodes("//Inclusion")[AreasCount].Attributes["start"].Value;
                   api.InclusionEnd = xn.SelectNodes("//Inclusion")[AreasCount].Attributes["end"].Value;
                   api.InclusionCode = xn.SelectNodes("//Inclusion")[AreasCount].Attributes["code"].Value;
                   api.Inclusion = xn.SelectNodes("//Inclusion")[AreasCount].InnerText;
                   api.MealPlan = xn.SelectNodes("//MealPlan")[AreasCount].InnerText;
                   AreasCount += 1;

                   command = new SqlCommand();
                   command.CommandText = "Sp_StaticData_Insert";
                   command.CommandType = CommandType.StoredProcedure;
                   command.Parameters.Add("@RatePlanType", SqlDbType.NVarChar).Value = api.RatePlanType;
                   command.Parameters.Add("@RatePlanName", SqlDbType.NVarChar).Value = api.RatePlanName;
                   command.Parameters.Add("@RatePlanCode", SqlDbType.NVarChar).Value = api.RatePlanCode;
                   command.Parameters.Add("@InclusionStart", SqlDbType.NVarChar).Value = api.InclusionStart;
                   command.Parameters.Add("@Facetgroup", SqlDbType.NVarChar).Value = api.InclusionEnd;
                   command.Parameters.Add("@FacetValue", SqlDbType.NVarChar).Value = api.FacetValue;
                   ds = new WRBERPConnections().ExecuteDataSet(command, "");
               }
               AreasCount = 0;
               XmlNodeList xnList4 = document.DocumentElement.SelectNodes("/MMTHotelSearchResponse/HotelSearchResults/Hotels/Hotel[@id=" + api.HotalId + "]/PropertyInfo/RoomStays/RoomStay/RoomRates/RoomRate");
               foreach (XmlNode xn in xnList4)
               {

                   api.RoomRateRoomTypeCode = xn.SelectNodes("//RoomRate")[AreasCount].Attributes["roomTypeCode"].Value;
                   api.RoomRateRatePlanCode = xn.SelectNodes("//RoomRate")[AreasCount].Attributes["ratePlanCode"].Value;
                   api.RoomRateInclusionAndPolicyAvail = xn.SelectNodes("//RoomRate")[AreasCount].Attributes["inclusionAndPolicyAvail"].Value;
                   api.RoomRateAvailableCount = xn.SelectNodes("//RoomRate")[AreasCount].Attributes["availableCount"].Value;
                   api.RoomRateAvailStatus = xn.SelectNodes("//RoomRate")[AreasCount].Attributes["availStatus"].Value;
                   api.CancelPenaltiesOffsetUnitMultiplier = xn.SelectNodes("//Deadline")[AreasCount].Attributes["OffsetUnitMultiplier"].Value; ;
                   api.CancelPenaltiesOffsetTimeUnit = xn.SelectNodes("//Deadline")[AreasCount].Attributes["OffsetTimeUnit"].Value;
                   api.CancelPenaltiesoffSetDropTime = xn.SelectNodes("//Deadline")[AreasCount].Attributes["offSetDropTime"].Value;
                   api.CancellationCurrencyCode = xn.SelectNodes("//CancellationAmount")[AreasCount].Attributes["CurrencyCode"].Value;
                   api.PenaltyDescription = xn.SelectNodes("//PenaltyDescription")[AreasCount].InnerText;
                   api.PromotionCode = xn.SelectNodes("//Promotion")[AreasCount].Attributes["code"].Value;
                   api.CancellationAmount = xn.SelectNodes("//CancellationAmount")[AreasCount].InnerText;
                   AreasCount += 1;
               }
           }
       }
   }
}*/
