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
    public class BedBookingPropertyAssignedGuestDAO
    {
        public DataSet Save(string PropertyAssignedGuest, User user, int BookingId)
        {
            string UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BedBookingPropertyAssignedGuestDAO : Save, " + ", ProcName:'" + StoredProcedures.BedBookingPropertyAssingedGuest_Insert; 
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            BedBookingPropertyAssignedGuest PtoG = new BedBookingPropertyAssignedGuest();
            document.LoadXml(PropertyAssignedGuest);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                PtoG.EmpCode = document.SelectNodes("//GridXml")[i].Attributes["EmpCode"].Value;
                PtoG.FirstName = document.SelectNodes("//GridXml")[i].Attributes["FirstName"].Value;
                PtoG.LastName = document.SelectNodes("//GridXml")[i].Attributes["LastName"].Value;
                PtoG.GuestId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["GuestId"].Value);
                PtoG.BedType = document.SelectNodes("//GridXml")[i].Attributes["BedType"].Value;
                PtoG.Tariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Tariff"].Value);
                PtoG.RoomId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value);
                PtoG.BedId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BedId"].Value);
                PtoG.BookingPropertyId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BookingPropertyId"].Value);
                PtoG.BookingPropertyTableId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BookingPropertyTableId"].Value);
                PtoG.SSPId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["SSPId"].Value);
                PtoG.ServicePaymentMode = document.SelectNodes("//GridXml")[i].Attributes["ServicePaymentMode"].Value;
                PtoG.TariffPaymentMode = document.SelectNodes("//GridXml")[i].Attributes["TariffPaymentMode"].Value;
                PtoG.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                //
                PtoG.Column1 = document.SelectNodes("//GridXml")[i].Attributes["Column1"].Value;
                PtoG.Column2 = document.SelectNodes("//GridXml")[i].Attributes["Column2"].Value;
                PtoG.Column3 = document.SelectNodes("//GridXml")[i].Attributes["Column3"].Value;
                PtoG.Column4 = document.SelectNodes("//GridXml")[i].Attributes["Column4"].Value;
                PtoG.Column5 = document.SelectNodes("//GridXml")[i].Attributes["Column5"].Value;
                PtoG.Column6 = document.SelectNodes("//GridXml")[i].Attributes["Column6"].Value;
                PtoG.Column7 = document.SelectNodes("//GridXml")[i].Attributes["Column7"].Value;
                PtoG.Column8 = document.SelectNodes("//GridXml")[i].Attributes["Column8"].Value;
                PtoG.Column9 = document.SelectNodes("//GridXml")[i].Attributes["Column9"].Value;
                PtoG.Column10 = document.SelectNodes("//GridXml")[i].Attributes["Column10"].Value;
                command = new SqlCommand();
                if (PtoG.Id != 0)
                {
                    //command.CommandText = StoredProcedures.BookingCustomFieldsDetails_Update;
                    //command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PtoG.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.BedBookingPropertyAssingedGuest_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                command.Parameters.Add("@EmpCode", SqlDbType.NVarChar).Value = PtoG.EmpCode;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = PtoG.FirstName;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = PtoG.LastName;
                command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = PtoG.GuestId;
                command.Parameters.Add("@BedType", SqlDbType.NVarChar).Value = PtoG.BedType;
                command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = PtoG.Tariff;
                command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = PtoG.RoomId;
                command.Parameters.Add("@BedId", SqlDbType.BigInt).Value = PtoG.BedId;
                command.Parameters.Add("@BookingPropertyId", SqlDbType.BigInt).Value = PtoG.BookingPropertyId;
                command.Parameters.Add("@BookingPropertyTableId", SqlDbType.BigInt).Value = PtoG.BookingPropertyTableId;
                command.Parameters.Add("@SSPId", SqlDbType.BigInt).Value = PtoG.SSPId;
                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@ServicePaymentMode", SqlDbType.NVarChar).Value = PtoG.ServicePaymentMode;
                command.Parameters.Add("@TariffPaymentMode", SqlDbType.NVarChar).Value = PtoG.TariffPaymentMode;
                //
                command.Parameters.Add("@Column1", SqlDbType.NVarChar).Value = PtoG.Column1;
                command.Parameters.Add("@Column2", SqlDbType.NVarChar).Value = PtoG.Column2;
                command.Parameters.Add("@Column3", SqlDbType.NVarChar).Value = PtoG.Column3;
                command.Parameters.Add("@Column4", SqlDbType.NVarChar).Value = PtoG.Column4;
                command.Parameters.Add("@Column5", SqlDbType.NVarChar).Value = PtoG.Column5;
                command.Parameters.Add("@Column6", SqlDbType.NVarChar).Value = PtoG.Column6;
                command.Parameters.Add("@Column7", SqlDbType.NVarChar).Value = PtoG.Column7;
                command.Parameters.Add("@Column8", SqlDbType.NVarChar).Value = PtoG.Column8;
                command.Parameters.Add("@Column9", SqlDbType.NVarChar).Value = PtoG.Column9;
                command.Parameters.Add("@Column10", SqlDbType.NVarChar).Value = PtoG.Column10;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            if (n == 0)
            {
                DataTable dT = new DataTable("DBERRORTBL");
                ds.Tables.Add(dT);
            }
            return ds;
        }
    }
}
/*            else
            {
                command = new SqlCommand();
                command.CommandText = StoredProcedures.BookingDtls_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "BedBookingConfirmed";
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookingId;
                DataSet DSBooking = new WrbErpConnection().ExecuteDataSet(command, "");
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                //DSBooking.Tables[1].Rows[0][4].ToString()                
                message.From = new System.Net.Mail.MailAddress(DSBooking.Tables[2].Rows[0][4].ToString(), "", System.Text.Encoding.UTF8);
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.To.Add(new System.Net.Mail.MailAddress("bookingconfirmation@staysimplyfied.com"));
                if (DSBooking.Tables[4].Rows[0][0].ToString() == "0")
                {
                    message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[8].Rows[0][0].ToString()));
                }
                else
                {
                    for (int i = 0; i < DSBooking.Tables[5].Rows.Count; i++)
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[5].Rows[i][0].ToString()));
                    }
                    if (DSBooking.Tables[8].Rows[0][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[8].Rows[0][0].ToString()));
                    }
                }
                //Extra CC
                for (int i = 0; i < DSBooking.Tables[7].Rows.Count; i++)
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(DSBooking.Tables[7].Rows[i][0].ToString()));
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));                
                message.Bcc.Add(new System.Net.Mail.MailAddress("prabathkar@admonk.in"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("deepak@admonk.in"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));               
                message.Subject = "Booking Confirmation - " + DSBooking.Tables[2].Rows[0][2].ToString();
                string Imagelocation = "";
                Imagelocation = DSBooking.Tables[6].Rows[0][0].ToString();
                string Imagebody =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                   " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                   " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                   " <img src=" + Imagelocation + " width=\"300px\" height=\"100px\" alt=" + DSBooking.Tables[1].Rows[0][6].ToString() + ">" +
                   " </td></tr></table>";

                string SecondRow =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                    " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                    " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                    " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + DSBooking.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                    " <p style=\"margin:0px;\">Booked by : <span>" + DSBooking.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
                    " <p style=\"margin:0px;\">Reservation Date : <span>" + DSBooking.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                    " <p style=\"margin:0px;\">Company Name : <span>" + DSBooking.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                    " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                    " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                    " </td></tr><tr><td width=\"600\" style=\"margin-bottom:\">" +
                    " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                    " </td> </tr></table>";
                // Dataset Table 0 begin
                string GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date / Expected Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Tariff / Bed / Day</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode Tariff</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode Service</p></th>" +
                    " </tr>";

                for (int i = 0; i < DSBooking.Tables[0].Rows.Count; i++)
                {
                    GuestDetailsTable1 +=
                    "<tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                    " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">INR " + DSBooking.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                    " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                    " </tr>";
                }
                GuestDetailsTable1 += "</table>";
                // Dataset Table 0 end
                string Note = "";
                string CheckInPolicy = "";
                string CheckOutPolicy = "";
                if (DSBooking.Tables[1].Rows[0][6].ToString() == "Internal Property")
                {
                    Note = "This booking entitles you to use 1 bed in the room during your stay. There may be another bed in the same room, where another guest may be staying. Your room may have an attached or non-attached bath. Guests in a room will be sharing all amenities in the room and the bath.";
                }                
                if (DSBooking.Tables[1].Rows[0][8].ToString() != "")
                {
                    CheckInPolicy = DSBooking.Tables[1].Rows[0][8].ToString() + ' ' + DSBooking.Tables[1].Rows[0][9].ToString();
                }
                else
                {
                    CheckInPolicy = "12 PM";
                }
                if (DSBooking.Tables[1].Rows[0][10].ToString() != "")
                {
                    CheckOutPolicy = DSBooking.Tables[1].Rows[0][10].ToString() + ' ' + DSBooking.Tables[1].Rows[0][7].ToString();
                }
                else
                {
                    CheckOutPolicy = "12 PM";
                }
                string AddressDtls =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                    " <tr style=\"font-size:11px; background-color:#eee;\">" +
                    " <td width=\"600\" style=\"padding:12px 5px;\">" +
                    " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                     " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + DSBooking.Tables[1].Rows[0][5].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <p style=\"margin-top:20px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Address: </span> " + DSBooking.Tables[1].Rows[0][0].ToString() + "  <br>" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Property Phone: </span> " + DSBooking.Tables[1].Rows[0][1].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Directions: </span> " + DSBooking.Tables[1].Rows[0][2].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Tax: </span>Taxes as applicable " +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Note: </span> " + Note + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements:</span> " + DSBooking.Tables[2].Rows[0][8].ToString() + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check-in Policy: </span> " + CheckInPolicy + "" +
                    " </p><p style=\"margin-top:5px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy: </span> " + CheckOutPolicy + "" +
                    " </p><p style=\"margin-top:12px;\">" +
                    " <span style=\"color:#f54d02; font-weight:bold\">Need help booking?: </span><strong>1800-425-3454</strong>(9:00 AM to 5:00 PM)<br>" +
                    " </p></td></tr></table>";
                // Dataset Table 1 Begin
                string UserName = "";
                string EmailId = "";
                string PhoneNo = "";
                for (int i = 0; i < DSBooking.Tables[3].Rows.Count; i++)
                {
                    if (i == 0)
                    {
                        if (DSBooking.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName = DSBooking.Tables[3].Rows[i][1].ToString();
                        }
                        if (DSBooking.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId = DSBooking.Tables[3].Rows[i][2].ToString();
                        }
                        if (DSBooking.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo = DSBooking.Tables[3].Rows[i][3].ToString();
                        }
                    }
                    else
                    {
                        if (DSBooking.Tables[3].Rows[i][1].ToString() != "")
                        {
                            UserName += " , " + DSBooking.Tables[3].Rows[i][1].ToString();
                        }
                        if (DSBooking.Tables[3].Rows[i][2].ToString() != "")
                        {
                            EmailId += " , " + DSBooking.Tables[3].Rows[i][2].ToString();
                        }
                        if (DSBooking.Tables[3].Rows[i][3].ToString() != "")
                        {
                            PhoneNo += " , " + DSBooking.Tables[3].Rows[i][3].ToString();
                        }
                    }
                }


                string QRCode =
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">QR Code</p></th>" +
                     " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Support @ Property Level</p></th>" +
                     " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                     "  <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> QR Code</p>" +
                     "  <br /><br />" +
                     "  <img src=\"http://sstage.in/images/images.jpg\" width=\"100\" height=\"100\" />" +
                     " <p style=\"margin-top:5px;\">" +
                     "  *NOTE: Download QRCode reader to get propery address to your maps" +
                     "    </p>" +
                     " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"> " +
                     " <p> Name:" + UserName + " </p> <p> Email :" + " " + EmailId + " </p><p> Phone: " + PhoneNo + "</p></td>" +
                     " </tr></table>";

                string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                string FooterDtls =
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                     " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                     " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                     " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                     " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                     " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                     " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                     " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                     " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through email. Mail to be sent to stay@hummingbirdindia.com and mention the booking ID no.</span></li>" +
                     " <li><span>Cancellation charges is 100% refund, if the cancellation request is sent 48 (forty eight) hours prior to the booking date and NIL beyond 24 (twenty four) hours.</span></li>" +
                     " <li><span> No-show without intimation: 100% of 1 day tariff.</span></li></td></ol>" +
                     " </tr><tr style=\"font-size:0px; font-weight:normal;\"> " +
                     " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                     " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                     " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                     " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                     " </td></tr> </table>";

                message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls + QRCode + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                smtp.EnableSsl = true;
                smtp.Send(message);

                // Property Mail
                if (DSBooking.Tables[3].Rows.Count > 0)
                {
                    if (DSBooking.Tables[3].Rows[0][4].ToString() != "")
                    {
                        string PropertyMail = DSBooking.Tables[3].Rows[0][4].ToString();
                        //string PropertyMail = "sakthi@warblerit.com,vivek@warblerit.com,arun@warblerit.com";
                        var PtyMail = PropertyMail.Split(',');
                        int cnt = PtyMail.Length;
                        System.Net.Mail.MailMessage message1 = new System.Net.Mail.MailMessage();
                        //DSBooking.Tables[1].Rows[0][4].ToString()
                        message1.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                        for (int i = 0; i < cnt; i++)
                        {
                            if (PtyMail[i].ToString() != "")
                            {
                                message1.To.Add(new System.Net.Mail.MailAddress(PtyMail[i].ToString()));
                            }
                        }
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));                
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                        message1.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                        message1.Subject = "Booking Confirmation - " + DSBooking.Tables[2].Rows[0][2].ToString();
                        string Imagelocation1 = "";
                        Imagelocation1 = DSBooking.Tables[6].Rows[0][0].ToString();
                        string Imagebody1 =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                           " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                           " <img src=" + Imagelocation1 + " width=\"300px\" height=\"100px\" alt=" + DSBooking.Tables[1].Rows[0][6].ToString() + ">" +
                           " </td></tr></table>";

                        string SecondRow1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                            " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                            " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                            " <p style=\"font-weight:bold; color:orange;\">Booking confirmation details" +
                            " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">Booking # : " + DSBooking.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
                            " <p style=\"margin:0px;\">Reservation Date : <span>" + DSBooking.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                            " <p style=\"margin:0px;\">Company Name : <span>" + DSBooking.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                            " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                            " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                            " </td></tr><tr><td width=\"600\" style=\"margin-bottom:\">" +
                            " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details :</p>" +
                            " </td> </tr></table>";

                        string GuestDetailsTable11 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date / Expected Time</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Tariff / Bed / Day</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Occupancy</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode Tariff</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode Service</p></th>" +
                            " </tr>";

                        for (int i = 0; i < DSBooking.Tables[0].Rows.Count; i++)
                        {
                            GuestDetailsTable11 +=
                            "<tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">INR " + DSBooking.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                            " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                            " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                            " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + DSBooking.Tables[0].Rows[i][6].ToString() + "</p></th>" +
                            " </tr>";
                        }
                        GuestDetailsTable11 += "</table>";

                        string AddressDtls1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"600\" style=\"padding:12px 5px;\">" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Special Request :</p>" +
                            "<p style=\"margin-top:5px; margin-left:25px\">" + DSBooking.Tables[2].Rows[0][8].ToString() +
                            " </p></td></tr></table>";
                        string Disclaimer1 = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                        string FooterDtls1 =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:3px;\">" +
                             " <tr style=\"font-size:11px; font-weight:normal;\">" +
                             " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px; border-right:1px solid #ccc;\"><p style=\"text-align:center; padding-left:10px;\">Security Policy</p></th>" +
                             " <th width=\"200\" style=\"background-color:#eee; padding:5px 0px;\"><p style=\"text-align:center; padding-left:10px;\">Cancellation / No Show / Early Departure Policy</p></th>" +
                             " </tr><tr style=\"font-size:11px; font-weight:normal;\">" +
                             " <td width=\"200\" style=\"padding:10px; border-right:1px solid #ccc; margin-bottom:20px; border-bottom:1px solid #ccc;\">" +
                             " <ol type=\"A\" style=\"font-weight: bold;\"><li><span>A picture of the guest will be taken through webcam for records.</span></li>" +
                             " <li><span>The guest's mobile number and official e-mail address needs to be provided.</span></li>" +
                             " <li><span>Government Photo ID proof such as driving license, passport, voter ID card etc. needs to be produced. (Kindly confirm whether PAN CARD is accepted)</span></li>" +
                             " <li><span>A company business card or company ID card needs to be produced.</span></li></ol>" +
                             " </td><td width=\"200\" style=\"padding:10px; margin-bottom:20px; border-bottom:1px solid #ccc;\"><ol type=\"A\" style=\"font-weight: bold;\"><li><span>Cancellation of booking to be confirmed through email. Mail to be sent to stay@hummingbirdindia.com and mention the booking ID no.</span></li>" +
                             " <li><span>Cancellation charges is 100% refund, if the cancellation request is sent 48 (forty eight) hours prior to the booking date and NIL beyond 24 (twenty four) hours.</span></li>" +
                             " <li><span> No-show without intimation: 100% of 1 day tariff.</span></li></td></ol>" +
                             " </tr><tr style=\"font-size:0px; font-weight:normal;\"> " +
                             " <td colspan=\"3\" style=\"padding-top:0px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:0px;\"> " +
                             " HUMMINGBIRD Travel and stay Pvt Ltd</p><br><hr>" +
                             " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:10px;\">Disclaimer :</p>" +
                             " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer1 + "</p>" +
                             " </td></tr> </table>";

                        message1.Body = Imagebody1 + SecondRow1 + GuestDetailsTable11 + AddressDtls1 + FooterDtls1;
                        message1.IsBodyHtml = true;
                        // SMTP Email email:
                        System.Net.Mail.SmtpClient smtp1 = new System.Net.Mail.SmtpClient();
                        smtp1.Host = "smtp.gmail.com";
                        smtp1.Port = 587;
                        //smtp.Credentials = new System.Net.NetworkCredential("vivek@admonk.in", "vivekadmonk");
                        //smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbirdindia.com", "hb@hummingbird");
                        smtp1.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        smtp1.EnableSsl = true;
                        smtp1.Send(message1);
                    }
                }
            }
            return ds;
        }
    }
}*/
