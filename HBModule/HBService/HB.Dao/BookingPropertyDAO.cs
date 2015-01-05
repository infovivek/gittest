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
    public class BookingPropertyDAO
    {
        string UserData;
        public DataSet Save(string[] data, User Usr, int BookingId)
        {
            UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
             "', SctId:" + Usr.SctId + ", Service:BookingPropertyDAO - Save" + ", ProcName:'" + StoredProcedures.BookingProperty_Insert; 
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            BookingProperty BookPty = new BookingProperty();
            document.LoadXml(data[3].ToString());
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                BookPty.PropertyName = document.SelectNodes("//GridXml")[i].Attributes["PropertyName"].Value;
                BookPty.PropertyId = Convert.ToInt64(document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value);
                BookPty.GetType = document.SelectNodes("//GridXml")[i].Attributes["GetType"].Value;
                BookPty.PropertyType = document.SelectNodes("//GridXml")[i].Attributes["PropertyType"].Value;
                BookPty.RoomType = document.SelectNodes("//GridXml")[i].Attributes["RoomType"].Value;
                if (document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value == "")
                {
                    BookPty.SingleTariff = 0;
                }
                else
                {
                    BookPty.SingleTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value == "")
                {
                    BookPty.DoubleTariff = 0;
                }
                else
                {
                    BookPty.DoubleTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["TripleTariff"].Value == "")
                {
                    BookPty.TripleTariff = 0;
                }
                else
                {
                    BookPty.TripleTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["TripleTariff"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["SingleandMarkup"].Value == "")
                {
                    BookPty.SingleandMarkup = 0;
                }
                else
                {
                    BookPty.SingleandMarkup = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SingleandMarkup"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["DoubleandMarkup"].Value == "")
                {
                    BookPty.DoubleandMarkup = 0;
                }
                else
                {
                    BookPty.DoubleandMarkup = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DoubleandMarkup"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["TripleandMarkup"].Value == "")
                {
                    BookPty.TripleandMarkup = 0;
                }
                else
                {
                    BookPty.TripleandMarkup = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["TripleandMarkup"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Markup"].Value == "")
                {
                    BookPty.Markup = 0;
                }
                else
                {
                    BookPty.Markup = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Markup"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["SingleandMarkup1"].Value == "")
                {
                    BookPty.SingleandMarkup1 = 0;
                }
                else
                {
                    BookPty.SingleandMarkup1 = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SingleandMarkup1"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["DoubleandMarkup1"].Value == "")
                {
                    BookPty.DoubleandMarkup1 = 0;
                }
                else
                {
                    BookPty.DoubleandMarkup1 = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DoubleandMarkup1"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["TripleandMarkup1"].Value == "")
                {
                    BookPty.TripleandMarkup1 = 0;
                }
                else
                {
                    BookPty.TripleandMarkup1 = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["TripleandMarkup1"].Value);
                }
                BookPty.TAC = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["TAC"].Value);
                if ((BookPty.GetType == "API") & (BookPty.PropertyType == "MMT"))
                {
                    BookPty.Inclusions = document.SelectNodes("//GridXml")[i].Attributes["MealPlan"].Value;
                }
                else
                {
                    BookPty.Inclusions = document.SelectNodes("//GridXml")[i].Attributes["Inclusions"].Value;
                }                
                BookPty.DiscountModePer = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["DiscountModePer"].Value);
                BookPty.DiscountModeRS = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["DiscountModeRS"].Value);
                if (document.SelectNodes("//GridXml")[i].Attributes["DiscountAllowed"].Value == "")
                {
                    BookPty.DiscountAllowed = 0;
                }
                else
                {
                    BookPty.DiscountAllowed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DiscountAllowed"].Value);
                }
                BookPty.Phone = document.SelectNodes("//GridXml")[i].Attributes["Phone"].Value;
                BookPty.Email = document.SelectNodes("//GridXml")[i].Attributes["Email"].Value;
                BookPty.Locality = document.SelectNodes("//GridXml")[i].Attributes["Locality"].Value;
                BookPty.LocalityId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["LocalityId"].Value);
                BookPty.MarkupId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["MarkupId"].Value);
                BookPty.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                // Extra Fields for API
                BookPty.APIHdrId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["APIHdrId"].Value);
                BookPty.RatePlanCode = document.SelectNodes("//GridXml")[i].Attributes["RatePlanCode"].Value;
                BookPty.RoomTypeCode = document.SelectNodes("//GridXml")[i].Attributes["RoomTypeCode"].Value;
                //
                BookPty.TaxAdded = document.SelectNodes("//GridXml")[i].Attributes["TaxAdded"].Value;
                // 29 DEC 2014
                if (document.SelectNodes("//GridXml")[i].Attributes["LTAgreed"].Value == "")
                {
                    BookPty.LTAgreed = 0;
                }
                else
                {
                    BookPty.LTAgreed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["LTAgreed"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["STAgreed"].Value == "")
                {
                    BookPty.STAgreed = 0;
                }
                else
                {
                    BookPty.STAgreed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["STAgreed"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["LTRack"].Value == "")
                {
                    BookPty.LTRack = 0;
                }
                else
                {
                    BookPty.LTRack = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["LTRack"].Value);
                }
                BookPty.TaxInclusive = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["TaxInclusive"].Value);
                if (document.SelectNodes("//GridXml")[i].Attributes["BaseTariff"].Value == "")
                {
                    BookPty.BaseTariff = 0;
                }
                else
                {
                    BookPty.BaseTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["BaseTariff"].Value);
                }
                SqlCommand command = new SqlCommand();
                if (BookPty.Id != 0)
                {
                    //command.CommandText = StoredProcedures.BookingProperty_Update;
                    //command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookPty.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.BookingProperty_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = BookPty.PropertyName;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = BookPty.PropertyId;
                command.Parameters.Add("@GetType", SqlDbType.NVarChar).Value = BookPty.GetType;
                command.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = BookPty.PropertyType;
                command.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = BookPty.RoomType;
                command.Parameters.Add("@SingleTariff", SqlDbType.Decimal).Value = BookPty.SingleTariff;
                command.Parameters.Add("@DoubleTariff", SqlDbType.Decimal).Value = BookPty.DoubleTariff;
                command.Parameters.Add("@TripleTariff", SqlDbType.Decimal).Value = BookPty.TripleTariff;
                command.Parameters.Add("@SingleandMarkup", SqlDbType.Decimal).Value = BookPty.SingleandMarkup;
                command.Parameters.Add("@DoubleandMarkup", SqlDbType.Decimal).Value = BookPty.DoubleandMarkup;
                command.Parameters.Add("@TripleandMarkup", SqlDbType.Decimal).Value = BookPty.TripleandMarkup;
                command.Parameters.Add("@Markup", SqlDbType.Decimal).Value = BookPty.Markup;
                command.Parameters.Add("@SingleandMarkup1", SqlDbType.Decimal).Value = BookPty.SingleandMarkup1;
                command.Parameters.Add("@DoubleandMarkup1", SqlDbType.Decimal).Value = BookPty.DoubleandMarkup1;
                command.Parameters.Add("@TripleandMarkup1", SqlDbType.Decimal).Value = BookPty.TripleandMarkup1;
                command.Parameters.Add("@TAC", SqlDbType.Bit).Value = BookPty.TAC;
                command.Parameters.Add("@Inclusions", SqlDbType.NVarChar).Value = BookPty.Inclusions;
                command.Parameters.Add("@DiscountModeRS", SqlDbType.Bit).Value = BookPty.DiscountModeRS;
                command.Parameters.Add("@DiscountModePer", SqlDbType.Bit).Value = BookPty.DiscountModePer;
                command.Parameters.Add("@DiscountAllowed", SqlDbType.Decimal).Value = BookPty.DiscountAllowed;                
                command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = BookPty.Phone;
                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = BookPty.Email;
                command.Parameters.Add("@Locality", SqlDbType.NVarChar).Value = BookPty.Locality;
                command.Parameters.Add("@LocalityId", SqlDbType.BigInt).Value = BookPty.LocalityId;
                command.Parameters.Add("@MarkupId", SqlDbType.BigInt).Value = BookPty.MarkupId;
                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Usr.Id;
                // Extra Fields for API
                command.Parameters.Add("@APIHdrId", SqlDbType.BigInt).Value = BookPty.APIHdrId;
                command.Parameters.Add("@RatePlanCode", SqlDbType.NVarChar).Value = BookPty.RatePlanCode;
                command.Parameters.Add("@RoomTypeCode", SqlDbType.NVarChar).Value = BookPty.RoomTypeCode;
                command.Parameters.Add("@PropertyCnt", SqlDbType.NVarChar).Value = n;
                command.Parameters.Add("@TaxAdded", SqlDbType.NVarChar).Value = BookPty.TaxAdded;
                //
                command.Parameters.Add("@LTRack", SqlDbType.Decimal).Value = BookPty.LTRack;
                command.Parameters.Add("@LTAgreed", SqlDbType.Decimal).Value = BookPty.LTAgreed;
                command.Parameters.Add("@STAgreed", SqlDbType.Decimal).Value = BookPty.STAgreed;
                command.Parameters.Add("@BaseTariff", SqlDbType.Decimal).Value = BookPty.BaseTariff;
                command.Parameters.Add("@TaxInclusive", SqlDbType.Bit).Value = BookPty.TaxInclusive;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }            
            if (n == 0)
            {
                DataTable dT = new DataTable("DBERRORTBL");
                ds.Tables.Add(dT);
            }
            if (n != 0)
            {
                XmlDocument xml = new XmlDocument();
                xml.LoadXml(data[1].ToString());
                string Status = xml.SelectSingleNode("HdrXml").Attributes["Status"].Value;
                if (Status == "RmdPty")
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                    "', SctId:" + Usr.SctId + ", Service:BookingPropertyDAO - Help - Action Name - RecommendProperty" + ", ProcName:'" + StoredProcedures.BookingDtls_Help;
                    SqlCommand command = new SqlCommand();
                    command.CommandText = StoredProcedures.BookingDtls_Help;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "RecommendProperty";
                    command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                    DataSet DSBooking = new WrbErpConnection().ExecuteDataSet(command, UserData);
                    //if (DSBooking.Tables[4].Rows[0][0].ToString() == "RmdPty")
                    //{
                    //SmtpMail Mail = new SmtpMail("TryIt");
                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                    //DSBooking.Tables[1].Rows[0][4].ToString()
                    if (DSBooking.Tables[8].Rows.Count > 0)
                    {
                        message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
                    }
                    else
                    {
                        //message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                        message.From = new System.Net.Mail.MailAddress("stay@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    }
                    //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message.Subject = " Test Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                    message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                    if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                    {
                        if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                        }
                    }
                    else
                    {
                        for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                        {
                            if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                            {
                                message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[3].Rows[i][0].ToString()));
                            }
                        }
                        if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                    {
                        if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[6].Rows[i][0].ToString()));
                        }
                    }
                    if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                    {
                        message.Bcc.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][4].ToString()));
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                    /*if (DSBooking.Tables[8].Rows.Count > 0)
                    {
                        Mail.From = "homestay@uniglobeatb.co.in";
                        Mail.To.Add("booking_confirmation@staysimplyfied.com");
                        if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                        {
                            if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                            {
                                Mail.To.Add(DSBooking.Tables[1].Rows[0][1].ToString());
                            }
                        }
                        else
                        {
                            for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                            {
                                if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                                {
                                    Mail.To.Add(DSBooking.Tables[3].Rows[i][0].ToString());
                                }
                            }
                            if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                            {
                                Mail.Cc.Add(DSBooking.Tables[1].Rows[0][1].ToString());
                            }                        
                        }
                        //Extra CC
                        for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                        {
                            if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                            {
                                Mail.Cc.Add(DSBooking.Tables[6].Rows[i][0].ToString());
                            }
                        }
                        if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                        {
                            Mail.Bcc.Add(DSBooking.Tables[1].Rows[0][4].ToString());
                        }
                        Mail.Bcc.Add("bookingbcc@staysimplyfied.com");
                        Mail.Bcc.Add("vivek@warblerit.com");
                        Mail.Bcc.Add("sakthi@warblerit.com");
                        Mail.Bcc.Add("arun@warblerit.com");
                        Mail.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                    }
                    else
                    {
                        message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                        //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        //message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                        message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                        if (DSBooking.Tables[2].Rows[0][0].ToString() == "0")
                        {
                            if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                            {
                                message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));                                
                            }
                        }
                        else
                        {
                            for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                            {
                                if (DSBooking.Tables[3].Rows[i][0].ToString() != "")
                                {
                                    message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[3].Rows[i][0].ToString()));
                                }
                            }
                            if (DSBooking.Tables[1].Rows[0][1].ToString() != "")
                            {
                                message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][1].ToString()));                                
                            }
                        }
                        //Extra CC
                        for (int i = 0; i < DSBooking.Tables[6].Rows.Count; i++)
                        {
                            if (DSBooking.Tables[6].Rows[i][0].ToString() != "")
                            {
                                message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[6].Rows[i][0].ToString()));
                            }
                        }
                        if (DSBooking.Tables[1].Rows[0][4].ToString() != "")
                        {
                            message.Bcc.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[1].Rows[0][4].ToString()));
                        }
                        message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                        message.Subject = "Recommended Hotel List TID -" + DSBooking.Tables[1].Rows[0][2].ToString();
                    }*/
                    string Imagelocation = "";
                    Imagelocation = DSBooking.Tables[5].Rows[0][0].ToString();
                    string Imagebody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + DSBooking.Tables[5].Rows[0][1].ToString() + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
                    string NameBody =
                        " <p style=\"margin:0px;\">Hello " + DSBooking.Tables[7].Rows[0][0].ToString() + ",</p><br>" +         //Name Change
                        " <p style=\"margin:0px;\">Greetings for the Day.</p><br>" +
                        " <p style=\"margin:0px;\">Rooms are available in below mentioned hotels.   [ Tracking Id: " + DSBooking.Tables[1].Rows[0][2].ToString() + " ]</p>" +
                        " <p style=\"color:orange; font-weight:bold; font-size:14px;\">Property Details :</p>" +
                        " <span style=\"color:#f54d02; font-weight:bold\">City: </span> " + DSBooking.Tables[0].Rows[0][0].ToString() + " " +
                        "<br><br>";
                    /*string NameBody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                        " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                        " <td width=\"400\" style=\" padding-bottom:20px;\">" +
                        " <p style=\"margin:0px;\">Hello " + DSBooking.Tables[2].Rows[0][1].ToString() + ",</p>" +         //Name Change
                        " <p style=\"margin:0px;\">Greetings for the Day.</p>" +
                        " <p style=\"margin:0px;\">Rooms are available in below mentioned hotels.   [Tracking Id: " + DSBooking.Tables[1].Rows[0][2].ToString() + "]</p>" +
                        " </td></tr>" +
                        " <p style=\"color:orange; font-weight:bold; font-size:14px;\">Property Details</p>" +
                        " " +
                        " <span style=\"color:#f54d02; font-weight:bold\">City: </span> " + DSBooking.Tables[0].Rows[0][0].ToString()  + " " +
                        " "+
                        " </table>";*/
                    //" <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property &darr;</p></th>" +
                    string GridBody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Type</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Location</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Room Type</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Single Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Double Tariff</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Inclusions</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #fff;\"><p>Check In Policy</p></th>" +
                        "</tr>";
                    for (int j = 0; j < DSBooking.Tables[0].Rows.Count; j++)
                    {
                        GridBody +=
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][9].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][3].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][4].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][7].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][5].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #fff;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[j][8].ToString() + "</p></td>" +
                            "</tr>";
                    }
                    GridBody += "</table>";
                    GridBody +=
                        "<p style=\"margin-top:10px; margin-left:5px; font-size:11px;\">" +
                        "<span style=\"color:#f54d02; font-weight:bold; font-size:11px;\">Tax </span><ul><li>  &#9733;   - Taxes as applicable</li><li> #   - Including Tax</li></ul></p>" +
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"800px\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                        " <tr style=\"font-size:11px; background-color:#eee;\">" +
                        " <td width=\"100%\" style=\"padding:12px 5px;\">" +
                        " <p style=\"margin-top:0px;\"><b>Conditions : </b><ul><li><b>Please provide us alternate options of hotels/room types, to serve you better</b></li><li><b>All rates quoted are subject to availability and duration of Stay.</b></li><li>All Tariff quoted are limited and subject to availability and has to be confirmed in 30 mins from the time when these tariff's are generated " + DSBooking.Tables[4].Rows[0][1].ToString() + ".</li><li>While every effort has been made to ensure the accuracy and availablity of all information.</li></ul></p>" +
                        " <p style=\"margin-top:0px;\"><b>Cancellation Policy : </b> <ul><li> Cancellation of booking to be confirmed through Email.</li> " +
                        "<li>Mail to be sent to stay@staysimplyfied.com and mention the booking ID no.</li>" +
                        "<li>Cancellation policy varies from Property to property. Please verify confirmation email.</li></ul>" +
                        " <p style=\"margin-top:20px;\"><b>Note : </b>" + DSBooking.Tables[1].Rows[0][5].ToString() + "<br>" +                        
                        " <p style=\"margin-top:20px;\">Kindly confirm the property at the earliest as rooms are subject to availability.<br>" +
                        " <br /> Thanking You,<br />" +
                        " </p><p style=\"margin-top:5px;\">" +
                        " <span style=\"color:#f54d02; font-weight:bold\">" + DSBooking.Tables[1].Rows[0][3].ToString() + "" + //username change
                        " </p></td></tr></table><br><br>";
                    //string Disclaimer = "This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                    /*GridBody +=
                         " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                         " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                         " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                         " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                         " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                         " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                         " </td></tr> </table>";*/
                    /*GridBody +=
                         " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                         " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                         "<hr>"+
                         " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:5px;\">Disclaimer :</p>" +
                         " <p style=\"font-size:10px; padding-top:0px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                         " </td></tr> </table>";*/
                    message.Body = Imagebody + NameBody + GridBody;
                    message.IsBodyHtml = true;
                    // SMTP Email email:
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Port = 587;
                    smtp.Host = "email-smtp.us-west-2.amazonaws.com"; 
                    smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    //smtp.Host = "smtp.gmail.com"; 
                    //smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    try
                    {
                        smtp.Send(message);
                    }
                    catch (Exception ex)
                    {
                        CreateLogFiles log = new CreateLogFiles();
                        log.ErrorLog(ex.Message + " --> Recommend Property Mail --> " + message.Subject);
                    }
                    /*if (DSBooking.Tables[8].Rows.Count > 0)
                    {
                        Mail.HtmlBody = message.Body;
                        SmtpServer Server = new SmtpServer("mail.uniglobeatb.co.in");
                        Server.User = "homestay@uniglobeatb.co.in";
                        Server.Password = "Atb@33%";
                        Server.Port = 465;
                        Server.ConnectType = SmtpConnectType.ConnectSSLAuto;
                        SmtpClient Smtp = new SmtpClient();
                        try
                        {
                            Smtp.SendMail(Server, Mail);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + "Recommend Property Mail Port 465" + Mail.Subject);
                        }
                    }
                    else
                    {
                        System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                        smtp.EnableSsl = true;
                        smtp.Host = "smtp.gmail.com";                        
                        smtp.Port = 587;
                        smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        try
                        {
                            smtp.Send(message);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + "Recommend Property Mail Port 587" + message.Subject);
                        }
                        //smtp.Host = "email-smtp.us-east-1.amazonaws.com";
                        //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                        //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                        //smtp.Credentials = new System.Net.NetworkCredential("AKIAIIKODSRJRJDL5BJQ", "AgOvdhs3s8yN3XovLmMRLkGNZrIa7PppY8Vg+SbWd/7G");                        
                    }*/
                }
            }
            return ds;
        }
    }
}
