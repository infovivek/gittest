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
using System.Text.RegularExpressions;

namespace HB.Dao
{
    public class ExternalCheckOutMailDao
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        string Err;
        string UserData;
        public DataSet Mail(int CheckInHdrId, int StateId, int PropertyId, int UserId)
        {
            User user = new User();
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service : BookingRoomMailDAO : Help, " + ", ProcName:'" + StoredProcedures.ExternalCheckout_Help;
            DataTable dT = new DataTable("Table11");
            dT.Columns.Add("Str");

            command = new SqlCommand();
            command.CommandText = StoredProcedures.ExternalCheckout_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
            command.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = CheckInHdrId;
            command.Parameters.Add("@StateId", SqlDbType.Int).Value = StateId;
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = PropertyId;
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = UserId;
            ds =new WrbErpConnection().ExecuteDataSet(command, UserData);

            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
            //SmtpMail oMail = new SmtpMail("TryIt");
            Err = "";
            string Flag = "true";
            /*string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|" +
               @"0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z]" +
               @"[a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";*/
            string pattern = @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";

            for (int j = 0; j < ds.Tables[9].Rows.Count; j++)
            {
                if (ds.Tables[9].Rows[j][0].ToString() != "")
                {
                    System.Text.RegularExpressions.Match match =
                        Regex.Match(ds.Tables[9].Rows[j][0].ToString(), pattern, RegexOptions.IgnoreCase);
                    if (!match.Success)
                    {
                        if (Flag == "true")
                        {
                            Err += ds.Tables[9].Rows[j][0].ToString(); Flag = "false";
                        }
                        else
                        {
                            Err = Err + ", " + ds.Tables[9].Rows[j][0].ToString();
                        }
                    }
                }
            }

            if (Err != "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
                return ds;
            }
            if (Err == "")
            {
                dT.Rows.Add(Err);
                ds.Tables.Add(dT);
            }
            //ds.Tables[1].Rows[0][4].ToString()

            if (ds.Tables[10].Rows.Count > 0)
            {
                message.From = new System.Net.Mail.MailAddress("homestay@uniglobeatb.co.in", "", System.Text.Encoding.UTF8);
            }
            else
            {
                message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
            }
            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
            //message.Subject = "Room Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();

            message.To.Add(new System.Net.Mail.MailAddress("Shameem@warblerit.com"));
            if (ds.Tables[4].Rows[0][0].ToString() == "0")
            {
                if (ds.Tables[8].Rows[0][0].ToString() != "")
                {
                    message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                }
            }
            else
            {
                for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                {
                    if (ds.Tables[5].Rows[i][0].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                    }
                }
                if (ds.Tables[8].Rows[0][0].ToString() != "")
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                }
            }

            //Extra CC
            for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
            {
                if (ds.Tables[7].Rows[i][0].ToString() != "")
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                }
            }
            if (ds.Tables[2].Rows[0][4].ToString() != "")
            {
                message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
            }
      //      message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
            message.Bcc.Add(new System.Net.Mail.MailAddress("Shameem@warblerit.com"));
            message.Subject = "External CheckOut - " + ds.Tables[2].Rows[0][2].ToString();

            /*if (ds.Tables[10].Rows.Count > 0)
            {
                oMail.From = "homestay@uniglobeatb.co.in";
                oMail.To.Add("booking_confirmation@staysimplyfied.com");
                if (ds.Tables[4].Rows[0][0].ToString() == "0")
                {
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        oMail.To.Add(ds.Tables[8].Rows[0][0].ToString());
                    }
                }
                else
                {
                    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                    {
                        if (ds.Tables[5].Rows[i][0].ToString() != "")
                        {
                            oMail.To.Add(ds.Tables[5].Rows[i][0].ToString());
                        }
                    }
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        oMail.Cc.Add(ds.Tables[8].Rows[0][0].ToString());
                    }
                }
                //Extra CC
                for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                {
                    if (ds.Tables[7].Rows[i][0].ToString() != "")
                    {
                        oMail.Cc.Add(ds.Tables[7].Rows[i][0].ToString());
                    }
                }
                if (ds.Tables[2].Rows[0][4].ToString() != "")
                {
                    oMail.Bcc.Add(ds.Tables[2].Rows[0][4].ToString());
                }
                oMail.Bcc.Add("bookingbcc@staysimplyfied.com");
                oMail.Bcc.Add("vivek@warblerit.com");
                oMail.Bcc.Add("sakthi@warblerit.com");
                oMail.Bcc.Add("arun@warblerit.com");
                oMail.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            }
            else
            {
                message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                //message.To.Add(new System.Net.Mail.MailAddress("vivek@admonk.in"));
                //message.Subject = "Room Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
                message.To.Add(new System.Net.Mail.MailAddress("booking_confirmation@staysimplyfied.com"));
                if (ds.Tables[4].Rows[0][0].ToString() == "0")
                {
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                    }
                }
                else
                {
                    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                    {
                        if (ds.Tables[5].Rows[i][0].ToString() != "")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                        }
                    }
                    if (ds.Tables[8].Rows[0][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[8].Rows[0][0].ToString()));
                    }
                }
                //Extra CC
                for (int i = 0; i < ds.Tables[7].Rows.Count; i++)
                {
                    if (ds.Tables[7].Rows[i][0].ToString() != "")
                    {
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[7].Rows[i][0].ToString()));
                    }
                }
                if (ds.Tables[2].Rows[0][4].ToString() != "")
                {
                    message.Bcc.Add(new System.Net.Mail.MailAddress(ds.Tables[2].Rows[0][4].ToString()));
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("bookingbcc@staysimplyfied.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                message.Subject = "Booking Confirmation - " + ds.Tables[2].Rows[0][2].ToString();
            }*/

            string Imagelocation = "";
            Imagelocation = ds.Tables[6].Rows[0][0].ToString();
            string Imagebody =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                        "<tr><td>" +
                        "<table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                        "<tr> " +
                        "<th align=\"left\" width=\"50%\" style=\"padding: 10px 0px 10px 10px;\">" +
                        "<img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +              //Image Name Change
                        "</th><th width=\"50%\"></th></tr></table>";
            /*string Imagebody =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                " <img src=" + Imagelocation + " width=\"250px\" height=\"70px\" alt=" + ds.Tables[6].Rows[0][1].ToString() + ">" +
                " </td></tr></table>";*/

            string SecondRow =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                " <tr style=\"position:relative; background-color:#fff; font-size:11px;\">" +
                " <td width=\"400\" style=\" padding-bottom:1px;\">" +
                " <p style=\"font-weight:bold; color:orange;\">CheckOut confirmation details" +
            //    " <span style=\"color:#000; background-color:#ffcc00; padding:5px;\">CheckOut # : " + ds.Tables[2].Rows[0][2].ToString() + " </span></p>" + //Reservation
            //    " <p style=\"margin:0px;\">Booked by : <span>" + ds.Tables[2].Rows[0][3].ToString() + "</span></p>" +             //Name                    
            //    " <p style=\"margin:0px;\">Reservation Date : <span>" + ds.Tables[2].Rows[0][7].ToString() + "</span></p>" + //Date
                " <p style=\"margin:0px;\">Company Name : <span>" + ds.Tables[2].Rows[0][1].ToString() + "</span></p>" + //company name
                " </td><td width=\"200\"><p style=\"margin:0px;\"></p>" +
                " <p style=\"margin-top:0px;\"> <span style=\"color:orange; font-size:12px;\"></span></p>" +
                " </td></tr><tr><td width=\"600\" style=\"margin-bottom:\">" +
                " <p style=\"color:orange; font-weight:bold; font-size:14px;\"> Guest Details</p>" +
                " </td> </tr></table>";

            string GuestDetailsTable1 =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                " <tr style=\"font-size:11px; font-weight:normal;\">" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date / Expected Time</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Tariff / Room / Day</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Occupancy</p></th>" +
                " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode<br>for Tariff</p></th>" +
        //        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Payment Mode<br>for Service</p></th>" +
                " </tr>";

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                GuestDetailsTable1 +=
                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">INR " + ds.Tables[0].Rows[i][3].ToString() + "/-</p></td>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][6].ToString() + "</p></th>" +
                " </tr>";
            }
            GuestDetailsTable1 += "</table>";
            string Note = "";
            string CheckInPolicy = "";
            string CheckOutPolicy = "";
            if (ds.Tables[1].Rows[0][6].ToString() == "Internal Property")
            {
                Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
            }
            else if (ds.Tables[1].Rows[0][6].ToString() == "External Property")
            {
                if (ds.Tables[1].Rows[0][11].ToString() == "Serviced Appartments")
                {
                    Note = "This booking entitles you to use only the allotted room during your stay. There may be guests staying in the other rooms of the apartment. The allotted room could have an attached or a non-attached bath. The non-attached bath will be in the same apartment.";
                }
                else
                {
                    Note = "";
                }
            }
            if (ds.Tables[1].Rows[0][8].ToString() != "")
            {
                CheckInPolicy = ds.Tables[1].Rows[0][8].ToString() + ' ' + ds.Tables[1].Rows[0][9].ToString();
            }
            else
            {
                CheckInPolicy = "12 PM";
            }
            if (ds.Tables[1].Rows[0][10].ToString() != "")
            {
                CheckOutPolicy = ds.Tables[1].Rows[0][10].ToString() + ' ' + ds.Tables[1].Rows[0][7].ToString();
            }
            else
            {
                CheckOutPolicy = "12 PM";
            }
            string AddressDtls =
                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                " <tr style=\"font-size:11px; background-color:#eee;\">" +
                " <td width=\"600\" style=\"padding:12px 5px;\">" +
                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Contact Details</p>" +
                    " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Name : </span> " + ds.Tables[1].Rows[0][5].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <p style=\"margin-top:20px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Address :</span> " + ds.Tables[1].Rows[0][0].ToString() + "  <br>" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Property Phone :</span> " + ds.Tables[1].Rows[0][1].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Directions :</span> " + ds.Tables[1].Rows[0][2].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Tax :</span> Taxes as applicable" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Note :</span> " + Note + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Special Requirements :</span> " + ds.Tables[2].Rows[0][8].ToString() + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check In Policy :</span> " + CheckInPolicy + "" +
                " </p><p style=\"margin-top:5px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Check Out Policy :</span> " + CheckOutPolicy + "" +
                " </p><p style=\"margin-top:12px;\">" +
                " <span style=\"color:#f54d02; font-weight:bold\">Need help booking? : </span><strong>1800-425-3454</strong> (9:00 AM  to  5:00 PM)<br>" +
                " </p></td></tr></table>";
            string UserName = "";
            string EmailId = "";
            string PhoneNo = "";
            for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
            {
                if (i == 0)
                {
                    if (ds.Tables[3].Rows[i][1].ToString() != "")
                    {
                        UserName = ds.Tables[3].Rows[i][1].ToString();
                    }
                    if (ds.Tables[3].Rows[i][2].ToString() != "")
                    {
                        EmailId = ds.Tables[3].Rows[i][2].ToString();
                    }
                    if (ds.Tables[3].Rows[i][3].ToString() != "")
                    {
                        PhoneNo = ds.Tables[3].Rows[i][3].ToString();
                    }
                }
                else
                {
                    if (ds.Tables[3].Rows[i][1].ToString() != "")
                    {
                        UserName += " , " + ds.Tables[3].Rows[i][1].ToString();
                    }
                    if (ds.Tables[3].Rows[i][2].ToString() != "")
                    {
                        EmailId += " , " + ds.Tables[3].Rows[i][2].ToString();
                    }
                    if (ds.Tables[3].Rows[i][3].ToString() != "")
                    {
                        PhoneNo += " , " + ds.Tables[3].Rows[i][3].ToString();
                    }
                }
            }
            message.Body = Imagebody + SecondRow + GuestDetailsTable1 + AddressDtls ;
            message.IsBodyHtml = true;
            // SMTP Email email: 
            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            smtp.EnableSsl = true;
            smtp.Host = "email-smtp.us-west-2.amazonaws.com";
            smtp.Port = 587;
            smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
            try
            {
                smtp.Send(message);
            }
            catch (Exception ex)
            {
                CreateLogFiles log = new CreateLogFiles();
                log.ErrorLog(ex.Message + " --> Room Level Booking Confirmation Mail --> " + message.Subject);
            }


            return ds;
        }
        
    }

    
}
