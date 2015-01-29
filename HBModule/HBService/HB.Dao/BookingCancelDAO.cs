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
    public class BookingCancelDAO
    {
        public DataSet Save(string PropertyAssignedGuest, User user, int BookingId, string Remarks, string SendMail)
        {
            DataSet ds = new DataSet();
            DataTable ETable = new DataTable("ERRORTBLDAO");
            DataTable ExTable = new DataTable("Exists");
            ETable.Columns.Add("Exception");
            ExTable.Columns.Add("Exception");

            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            BookingPropertyAssignedGuest PtoG = new BookingPropertyAssignedGuest();
            document.LoadXml(PropertyAssignedGuest);
            int n;
            string AvalFlag = "";
            n = (document).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                command = new SqlCommand();
                command.CommandText = "SP_BookingPropertyAssingedGuest_Validation";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["LastName"].Value;
                command.Parameters.Add("@CheckInDT", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value;
                command.Parameters.Add("@CheckOutDT", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value;
                command.Parameters.Add("@TariffPaymentMode", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["TariffPaymentMode"].Value;
                command.Parameters.Add("@ServicePaymentMode", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ServicePaymentMode"].Value;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value;
                command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["GuestId"].Value;
                command.Parameters.Add("@DateChangeFlag", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["DateChange"].Value;
                command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = Remarks;
                command.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = user.Id;

                ds = new WrbErpConnection().ExecuteDataSet(command, "");
                if (ds.Tables[0].Rows[0][0].ToString() == "Date Not Available")
                {
                    ExTable.Rows.Add(ds.Tables[0].Rows[0][2].ToString());
                    AvalFlag = "true";
                    SendMail = "false";
                }
            }
            if (AvalFlag != "true")
            {
                for (int i = 0; i < n; i++)
                {
                    command = new SqlCommand();
                    command.CommandText = StoredProcedures.BookingPropertyAssingedGuest_Update;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                    command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value;
                    command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["LastName"].Value;
                    command.Parameters.Add("@CheckInDT", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value;
                    command.Parameters.Add("@CheckOutDT", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value;
                    command.Parameters.Add("@TariffPaymentMode", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["TariffPaymentMode"].Value;
                    command.Parameters.Add("@ServicePaymentMode", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["ServicePaymentMode"].Value;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value;
                    command.Parameters.Add("@GuestId", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["GuestId"].Value;
                    command.Parameters.Add("@OldGuestId", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["OldGuestId"].Value;                    
                    command.Parameters.Add("@DateChangeFlag", SqlDbType.NVarChar).Value = document.SelectNodes("//HdrXml")[i].Attributes["DateChange"].Value;
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = Remarks;
                    command.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = user.Id;

                    ds = new WrbErpConnection().ExecuteDataSet(command, "");

                }
            }

            if (SendMail == "true")
            {
                string Err = "";
                string Valid = "";
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                //DSBooking.Tables[1].Rows[0][4].ToString()    

                message.From = new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com", "", System.Text.Encoding.UTF8);
                //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.To.Add(new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com"));
                if (ds.Tables[0].Rows[0][10].ToString() == "False")
                {
                    Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                    if (Valid == "True")
                    {

                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                    }
                    else
                    {
                        Err += ds.Tables[4].Rows[0][0].ToString();
                    }

                }
                else
                {
                    for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                    {
                        Valid = EmailValidate(ds.Tables[5].Rows[i][0].ToString());
                        if (Valid == "True")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                        }
                        else
                        {
                            if (Err != "")
                                Err += " , " + ds.Tables[5].Rows[i][0].ToString();
                            else
                                Err += ds.Tables[5].Rows[i][0].ToString();
                        }
                    }
                    if (ds.Tables[4].Rows[0][0].ToString() != "")
                    {
                        Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                        if (Valid == "True")
                        {
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                        }
                        else
                        {
                            if (Err != "")
                                Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                            else
                                Err += ds.Tables[4].Rows[0][0].ToString();
                        }
                    }
                }
                //Extra CC
                //for (int i = 0; i < ds.Tables[6].Rows.Count; i++)
                //{
                //    Valid = EmailValidate(ds.Tables[6].Rows[i][0].ToString());
                //    if (Valid == "True")
                //    {
                //        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[6].Rows[i][0].ToString()));
                //    }
                //    else
                //    {
                //        if (Err != "")
                //            Err += " , " + ds.Tables[6].Rows[i][0].ToString();
                //        else
                //            Err += ds.Tables[6].Rows[i][0].ToString();
                //    }
                //}
                Valid = EmailValidate(ds.Tables[0].Rows[0][1].ToString());
                if (Valid == "True")
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[0].Rows[0][1].ToString()));
                }
                else
                {
                    if (Err != "")
                        Err += " , " + ds.Tables[0].Rows[0][1].ToString();
                    else
                        Err += ds.Tables[0].Rows[0][1].ToString();
                }
                message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("prabathkar@admonk.in"));
                //message.Bcc.Add(new System.Net.Mail.MailAddress("deepak@admonk.in"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                //message.CC.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                //
                message.Subject = "Stay Modification Booking # : " + ds.Tables[0].Rows[0][0].ToString();


                string Imagelocation = "";
                if (ds.Tables[7].Rows.Count > 0)
                {
                    if(ds.Tables[7].Rows[0][0].ToString() != "")
                        Imagelocation = ds.Tables[7].Rows[0][0].ToString();
                        
                }
                else
                {
                    if (ds.Tables[1].Rows[0][0].ToString() != "")
                    Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                }

                string Imagebody =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                   " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                   " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                   " <img src=" + Imagelocation + " width=\"300px\" height=\"100px\" alt=\"Humming bird logo\">" +
                   " </td></tr></table>";


                string Header =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                   " <tr style=\"font-size:11px; background-color:#eee;\">" +
                   " <td width=\"600\" style=\"padding:12px 5px;\">" +
                   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Modification Details</p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\"> System generated email. Please do not reply. </span><br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\"> Date : " + ds.Tables[0].Rows[0][7].ToString() + "</span><br>" +
                   " </p></td></tr></table>";


                string BookingDtls =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                   " <tr style=\"font-size:11px; background-color:#eee;\">" +
                   " <td width=\"600\" style=\"padding:12px 5px;\">" +
                   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Booking Details Reservation # : " + ds.Tables[0].Rows[0][0].ToString() + "</p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Booking Date : </span> " + ds.Tables[0].Rows[0][8].ToString() + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Client Name: </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + ds.Tables[2].Rows[0][0].ToString() + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Booking Level: </span> " + ds.Tables[0].Rows[0][9].ToString() + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Remarks: </span> " + Remarks + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Stay Modified By: </span> " + ds.Tables[0].Rows[0][5].ToString() + "  <br>" +
                   " </p></td></tr></table>";


                string GuestDetailsTable1 =
                    " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                    " <tr style=\"font-size:11px; font-weight:normal;\">" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Previous Check-In  Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Previous Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Expected Arrival Time</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>No Of Room Nights</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Tariff PaymentMode</p></th>" +
                    " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Service PaymentMode</p></th>" +
                    " </tr>";

                for (int i = 0; i < n; i++)
                {
                    if (document.SelectNodes("//HdrXml")[i].Attributes["Tick"].Value == "1")
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["OldChkInDt"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["OldChkOutDt"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ExpectChkInTime"].Value + " PM</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["DateDiffs"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["TariffPaymentMode"].Value + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ServicePaymentMode"].Value + "</p></td>" +
                        " </tr>";
                    }
                }
                GuestDetailsTable1 += "</table>";


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

                string AddressDtls =
                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                   " <tr style=\"font-size:11px; background-color:#eee;\">" +
                   " <td width=\"600\" style=\"padding:12px 5px;\">" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Resident Manager: </span> " + UserName + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Email: </span> " + EmailId + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Address: </span> " + ds.Tables[2].Rows[0][1].ToString() + "  <br>" +
                   " </p>" +
                   " <p style=\"margin-top:20px;\">" +
                   " <span style=\"color:#f54d02; font-weight:bold\">Phone No: </span> " + PhoneNo + "  <br>" +
                   " </p></td></tr></table>";

                string Disclaimer = "This message (including attachment if any)is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                string FooterDtls =
                     " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                     " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                     " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                     " STAY SIMPLYFIED Travel and stay Pvt Ltd</p><br><hr>" +
                     " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                     " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                     " </td></tr> </table>";

                message.Body = Imagebody + Header + BookingDtls + GuestDetailsTable1 + AddressDtls + FooterDtls;
                message.IsBodyHtml = true;
                // SMTP Email email:
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
               // smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
            //  smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbird.com", "stay1234");
                smtp.Host = "email-smtp.us-west-2.amazonaws.com"; 
                smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                smtp.EnableSsl = true;
                if (Err == "")
                {
                    smtp.Send(message);
                    //ds.Tables.Add(ETable);
                }
                else
                {
                    ETable.Rows.Add(Err+"  This EmailId Are Not Valid.");
                    //ds.Tables.Add(ETable);
                }

            }
            ds.Tables.Add(ETable);
            ds.Tables.Add(ExTable);
            return ds;
        }
        public DataSet Delete(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Booking_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[0].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        private String EmailValidate(String EmailId)
        {
            string pattern = null;
            string Msg = null;
            pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

            if (Regex.IsMatch(EmailId, pattern))
            {
                Msg="True";
            }
            else
            {
               Msg="False";
            }
            return Msg;
        }
        public DataSet Help(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            DataSet ds = new DataSet();
            string Err = "";
            string Valid = "";
            DataTable ETable = new DataTable("ERRORTBLDAO");
            ETable.Columns.Add("Exception");
            command.CommandText = StoredProcedures.BookingCancel_Help;
            command.CommandType = CommandType.StoredProcedure;
            if ((data[1].ToString() != "BookingGuestRoomDelete") && (data[1].ToString() != "BookingGuestBedDelete") && (data[1].ToString() != "BookingGuestApartmentDelete"))
            {
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();                
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[3].ToString();
                if ((data[1].ToString() == "PaymentMode") || (data[1].ToString() == "PaymentModeService") || (data[1].ToString() == "GuestData"))
                {
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value ="";
                }
                else
                {
                    command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value =  data[4].ToString();
                }
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds= new WrbErpConnection().ExecuteDataSet(command, "");
                if (data[1].ToString() == "BookingDelete")
                {
                    if (data[5].ToString() == "true")
                    {

                        if (ds.Tables[0].Rows[0][2].ToString() == "Canceled")
                        {
                            System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                            //DSBooking.Tables[1].Rows[0][4].ToString()    

                            message.From = new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com", "", System.Text.Encoding.UTF8);
                            //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            message.To.Add(new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com"));
                            if (ds.Tables[0].Rows[0][7].ToString() == "False")
                            {
                                Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                                if (Valid == "True")
                                {

                                    message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                                }
                                else
                                {
                                    Err += ds.Tables[4].Rows[0][0].ToString();
                                }
                            }
                            else
                            {
                                for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                                {
                                    Valid = EmailValidate(ds.Tables[5].Rows[i][0].ToString());
                                    if (Valid == "True")
                                    {
                                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                                    }
                                    else
                                    {
                                        if (Err!="")
                                        Err += " , "+ds.Tables[5].Rows[i][0].ToString();
                                        else
                                        Err +=ds.Tables[5].Rows[i][0].ToString();
                                    }
                                }
                                if (ds.Tables[4].Rows[0][0].ToString() != "")
                                {
                                    Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                                    if (Valid == "True")
                                    {
                                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                                    }
                                    else
                                    {
                                        if (Err != "")
                                            Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                                        else
                                            Err += ds.Tables[4].Rows[0][0].ToString();
                                    }
                                }
                            }
                            //Extra CC
                            for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                            {
                                Valid = EmailValidate(ds.Tables[3].Rows[i][0].ToString());
                                if (Valid == "True")
                                {
                                    message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][0].ToString()));
                                }
                                else
                                {
                                    if (Err != "")
                                        Err += " , " + ds.Tables[3].Rows[i][0].ToString();
                                    else
                                        Err += ds.Tables[3].Rows[i][0].ToString();
                                }
                            }
                            Valid = EmailValidate(ds.Tables[0].Rows[0][1].ToString());
                            if (Valid == "True")
                            {
                                message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[0].Rows[0][1].ToString()));
                            }
                            else
                            {
                                if (Err != "")
                                    Err += " , " + ds.Tables[0].Rows[0][1].ToString();
                                else
                                    Err += ds.Tables[0].Rows[0][1].ToString();
                            }
                            message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                            //message.Bcc.Add(new System.Net.Mail.MailAddress("prabathkar@admonk.in"));
                            //message.Bcc.Add(new System.Net.Mail.MailAddress("deepak@admonk.in"));
                            message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                            message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                            //
                            message.Subject = "Booking Confirmation - " + ds.Tables[0].Rows[0][0].ToString() + "- Cancelled ";

                            string Imagelocation = "";

                            if (ds.Tables[6].Rows.Count > 0)
                            {

                                if (ds.Tables[6].Rows[0][0].ToString() != "")
                                    Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                            }
                            else
                            {
                                if (ds.Tables[1].Rows[0][0].ToString() != "")
                                    Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                            }

                            string Imagebody =
                               " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                               " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                               " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                               " <img src=" + Imagelocation + " width=\"300px\" height=\"100px\" alt=\"Humming bird logo\">" +
                               " </td></tr></table>";

                            string AddressDtls =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                             " <tr style=\"font-size:11px; background-color:#eee;\">" +
                             " <td width=\"600\" style=\"padding:12px 5px;\">" +
                              "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:black; font-weight:bold\">Your booking number " + ds.Tables[0].Rows[0][0].ToString() + "   has been cancelled. Details are as follows: </span><br>" +
                             " </p>" +
                             " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Cancel Details</p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Booking Date : </span> " + ds.Tables[0].Rows[0][5].ToString() + "  <br>" +
                             " </p>" +
                             "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Client Name: </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + ds.Tables[2].Rows[0][0].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Booking Level: </span> " + ds.Tables[0].Rows[0][6].ToString() + "  <br>" +
                             " </p>" +
                             " <p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Reason: </span> " + data[4].ToString() + "  <br>" +
                             " </p></td></tr></table>";

                            string GuestDetailsTable1 =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                            " <tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>No Of Room Nights</p></th>" +
                            " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Status</p></th>" +
                            " </tr>";
                            XmlDocument document = new XmlDocument();
                            document.LoadXml(data[2].ToString());
                            int n;
                            n = (document).SelectNodes("//HdrXml").Count;
                            for (int i = 0; i < n; i++)
                            {
                                GuestDetailsTable1 +=
                                "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["DateDiffs"].Value + "</p></td>" +
                                " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">Canceled</p></td>" +
                                " </tr>";
                            }
                            GuestDetailsTable1 += "</table>";


                            string Footer =
                             " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                             " <tr style=\"font-size:11px; background-color:#eee;\">" +
                             " <td width=\"600\" style=\"padding:12px 5px;\">" +
                              "<p style=\"margin-top:20px;\">" +
                             " <span style=\"color:#f54d02; font-weight:bold\">Looking forward to your next stay with us! </span><br>" +
                             " </p>" +
                             " <p style=\"color:black; font-weight:bold; margin:0px; font-size:14px;\"> Please refrain from sending emails to this id as the inbox is not monitored. Please reply to stay@hummingbirdindia.com for clarifications, if any.</p>" +
                             " </td></tr></table>";

                            string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                            string FooterDtls =
                                 " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                 " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                                 " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                                 " STAY SIMPLYFIED Travel and stay Pvt Ltd</p><br><hr>" +
                                 " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                                 " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                                 " </td></tr> </table>";

                            message.Body = Imagebody + AddressDtls + GuestDetailsTable1 + Footer + FooterDtls;
                            message.IsBodyHtml = true;
                            // SMTP Email email:
                            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                           // smtp.Host = "smtp.gmail.com";
                            smtp.Port = 587;
                           // smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbird.com", "stay1234");
                            smtp.Host = "email-smtp.us-west-2.amazonaws.com";
                            smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                            smtp.EnableSsl = true;
                            if (Err == "")
                            {
                                smtp.Send(message);
                                //ds.Tables.Add(ETable);
                            }
                            else
                            {
                                ETable.Rows.Add(Err + "  This EmailId Are Not Valid.");
                                //ds.Tables.Add(ETable);
                            }
                          
                        }
                    }
                }
            }
            else
            {
                XmlDocument document = new XmlDocument();
                document.LoadXml(data[2].ToString());
                int n;
                n = (document).SelectNodes("//HdrXml").Count;
                   for (int i = 0; i < n; i++)
                   {
                       if (document.SelectNodes("//HdrXml")[i].Attributes["Tick"].Value == "1")
                       {
                           command = new SqlCommand();
                           command.CommandType = CommandType.StoredProcedure;
                           command.CommandText = StoredProcedures.BookingCancel_Help;
                           command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                           command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
                           command.Parameters.Add("@Id", SqlDbType.BigInt).Value = document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value;
                           command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = data[4].ToString();
                           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                           ds= new WrbErpConnection().ExecuteDataSet(command, "");
                       }

                   }
                   if (data[5].ToString() == "true")
                   {

                       if (ds.Tables[0].Rows[0][2].ToString() == "Canceled")
                       {
                           System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                           //DSBooking.Tables[1].Rows[0][4].ToString()    

                           message.From = new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com", "", System.Text.Encoding.UTF8);
                           //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                           message.To.Add(new System.Net.Mail.MailAddress("stay@hummingbirdIndia.com"));
                           if (ds.Tables[0].Rows[0][7].ToString() == "False")
                           {
                               Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                               if (Valid == "True")
                               {
                                   message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                               }
                               else
                               {
                                   if (Err != "")
                                       Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                                   else
                                       Err += ds.Tables[4].Rows[0][0].ToString();
                               }

                           }
                           else
                           {
                               for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                               {
                                   Valid = EmailValidate(ds.Tables[5].Rows[i][0].ToString());
                                   if (Valid == "True")
                                   {
                                       message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                                   }
                                   else
                                   {
                                       if (Err != "")
                                           Err += " , " + ds.Tables[5].Rows[i][0].ToString();
                                       else
                                           Err += ds.Tables[5].Rows[i][0].ToString();
                                   }
                               }
                               if (ds.Tables[4].Rows[0][0].ToString() != "")
                               {
                                   Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                                   if (Valid == "True")
                                   {
                                       message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                                   }
                                   else
                                   {
                                       if (Err != "")
                                           Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                                       else
                                           Err += ds.Tables[4].Rows[0][0].ToString();
                                   }
                               }
                           }
                           //Extra CC
                           for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                           {
                               Valid = EmailValidate(ds.Tables[3].Rows[i][0].ToString());
                               if (Valid == "True")
                               {
                                   message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][0].ToString()));
                               }
                               else
                               {
                                   if (Err != "")
                                       Err += " , " + ds.Tables[3].Rows[i][0].ToString();
                                   else
                                       Err += ds.Tables[3].Rows[i][0].ToString();
                               }
                           }
                           message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                           //message.Bcc.Add(new System.Net.Mail.MailAddress("prabathkar@admonk.in"));
                           //message.Bcc.Add(new System.Net.Mail.MailAddress("deepak@admonk.in"));
                           message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                           message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));

                           message.Subject = "Booking Confirmation - " + ds.Tables[0].Rows[0][0].ToString() + "- Cancelled ";

                           string Imagelocation = "";

                           if (ds.Tables[6].Rows.Count > 0)
                           {

                               if (ds.Tables[6].Rows[0][0].ToString() != "")
                                   Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                           }
                           else
                           {
                               if (ds.Tables[1].Rows[0][0].ToString() != "")
                                   Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                           }

                           string Imagebody =
                              " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                              " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                              " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                              " <img src=" + Imagelocation + " width=\"300px\" height=\"100px\" alt=\"Humming bird logo\">" +
                              " </td></tr></table>";

                           string AddressDtls =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"600\" style=\"padding:12px 5px;\">" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:black; font-weight:bold\">Your booking number " + ds.Tables[0].Rows[0][0].ToString() + "   has been cancelled. Details are as follows: </span><br>" +
                            " </p>" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Cancel Details</p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Booking Date : </span> " + ds.Tables[0].Rows[0][5].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Client Name: </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + ds.Tables[2].Rows[0][0].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Booking Level: </span> " + ds.Tables[0].Rows[0][6].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Reason: </span> " + data[4].ToString() + "  <br>" +
                            " </p></td></tr></table>";

                           string GuestDetailsTable1 =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr style=\"font-size:11px; font-weight:normal;\">" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>No Of Room Nights</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Status</p></th>" +
                           " </tr>";
                           document = new XmlDocument();
                           document.LoadXml(data[2].ToString());
                           n = 0;
                           n = (document).SelectNodes("//HdrXml").Count;
                           for (int i = 0; i < n; i++)
                           {
                               GuestDetailsTable1 +=
                               "<tr style=\"font-size:11px; font-weight:normal;\">" +
                               " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value + "</p></td>" +
                               " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value + "</p></td>" +
                               " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value + "</p></td>" +
                               " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["DateDiffs"].Value + "</p></td>" +
                               " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">Canceled</p></td>" +
                               " </tr>";
                           }
                           GuestDetailsTable1 += "</table>";


                           string Footer =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"600\" style=\"padding:12px 5px;\">" +
                             "<p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Looking forward to your next stay with us! </span><br>" +
                            " </p>" +
                            " <p style=\"color:black; font-weight:bold; margin:0px; font-size:14px;\"> Please refrain from sending emails to this id as the inbox is not monitored. Please reply to stay@hummingbirdindia.com for clarifications, if any.</p>" +
                            " </td></tr></table>";

                           string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                           string FooterDtls =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                                " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                                " STAY SIMPLYFIED  Travel and stay Pvt Ltd</p><br><hr>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                                " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                                " </td></tr> </table>";




                           message.Body = Imagebody + AddressDtls + GuestDetailsTable1 + Footer + FooterDtls;
                           message.IsBodyHtml = true;
                           // SMTP Email email:
                           System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                           //smtp.Host = "smtp.gmail.com";
                           smtp.Port = 587;
                          // smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbird.com", "stay1234");
                           smtp.Host = "email-smtp.us-west-2.amazonaws.com"; 
                           smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                           smtp.EnableSsl = true;
                           if (Err == "")
                           {
                              smtp.Send(message);
                              // ds.Tables.Add(ETable);
                           }
                           else
                           {
                               ETable.Rows.Add(Err + "  This EmailId Are Not Valid.");
                               //ds.Tables.Add(ETable);
                           }
                       }
                       else
                       {
                           System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                           //DSBooking.Tables[1].Rows[0][4].ToString()    

                           if (ds.Tables[0].Rows[0][7].ToString() == "False")
                           {
                               Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                               if (Valid == "True")
                               {
                                   message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                               }
                               else
                               {
                                   if (Err != "")
                                       Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                                   else
                                       Err += ds.Tables[4].Rows[0][0].ToString();
                               }

                           }
                           else
                           {
                               for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                               {
                                   Valid = EmailValidate(ds.Tables[5].Rows[i][0].ToString());
                                   if (Valid == "True")
                                   {
                                       message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                                   }
                                   else
                                   {
                                       if (Err != "")
                                           Err += " , " + ds.Tables[5].Rows[i][0].ToString();
                                       else
                                           Err += ds.Tables[5].Rows[i][0].ToString();
                                   }
                               }
                               if (ds.Tables[6].Rows[0][0].ToString() != "")
                               {
                                   Valid = EmailValidate(ds.Tables[4].Rows[0][0].ToString());
                                   if (Valid == "True")
                                   {
                                       message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                                   }
                                   else
                                   {
                                       if (Err != "")
                                           Err += " , " + ds.Tables[4].Rows[0][0].ToString();
                                       else
                                           Err += ds.Tables[4].Rows[0][0].ToString();
                                   }
                               }
                           }
                           //Extra CC
                           for (int i = 0; i < ds.Tables[3].Rows.Count; i++)
                           {
                               Valid = EmailValidate(ds.Tables[3].Rows[i][0].ToString());
                               if (Valid == "True")
                               {
                                   message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[3].Rows[i][0].ToString()));
                               }
                               else
                               {
                                   if (Err != "")
                                       Err += " , " + ds.Tables[3].Rows[i][0].ToString();
                                   else
                                       Err += ds.Tables[3].Rows[i][0].ToString();
                               }
                           }
                           message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                           //message.Bcc.Add(new System.Net.Mail.MailAddress("prabathkar@admonk.in"));
                          // message.Bcc.Add(new System.Net.Mail.MailAddress("deepak@admonk.in"));
                           message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                           message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                           //
                           message.Subject = "Guest Deleted For this Booking Code - " + ds.Tables[0].Rows[0][0].ToString();


                           string Imagelocation = "";
                           if (ds.Tables[6].Rows.Count > 0)
                           {

                               if (ds.Tables[6].Rows[0][0].ToString() != "")
                                   Imagelocation = ds.Tables[6].Rows[0][0].ToString();
                           }
                           else
                           {
                               if (ds.Tables[1].Rows[0][0].ToString() != "")
                               Imagelocation = ds.Tables[1].Rows[0][0].ToString();
                           }

                           string Imagebody =
                              " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                              " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                              " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                              " <img src=" + Imagelocation + " width=\"300px\" height=\"100px\" alt=\"Humming bird logo\">" +
                              " </td></tr></table>";

                           string AddressDtls =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"600\" style=\"padding:12px 5px;\">" +
                             "<p style=\"margin-top:20px;\">" +
                            " <span style=\"color:black; font-weight:bold\">Your booking number " + ds.Tables[0].Rows[0][0].ToString() + "   has been cancelled. Details are as follows: </span><br>" +
                            " </p>" +
                            " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:14px;\"> Cancel Details</p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Booking Date : </span> " + ds.Tables[0].Rows[0][5].ToString() + "  <br>" +
                            " </p>" +
                            "<p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Client Name: </span> " + ds.Tables[0].Rows[0][4].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Property Name: </span> " + ds.Tables[2].Rows[0][0].ToString() + "  <br>" +
                            " </p>" +
                            " <p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Booking Level: </span> " + ds.Tables[0].Rows[0][6].ToString() + "  <br>" +
                            " </p></td></tr></table>";

                           string GuestDetailsTable1 =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr style=\"font-size:11px; font-weight:normal;\">" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-In Date</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Check-Out Date</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>No Of Room Nights</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Status</p></th>" +
                           " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Reason</p></th>" +
                           " </tr>";
                           document = new XmlDocument();
                           document.LoadXml(data[2].ToString());
                           n = 0;
                           n = (document).SelectNodes("//HdrXml").Count;
                           for (int i = 0; i < n; i++)
                           {
                               if (document.SelectNodes("//HdrXml")[i].Attributes["Tick"].Value == "1")
                               {
                                   GuestDetailsTable1 +=
                                   "<tr style=\"font-size:11px; font-weight:normal;\">" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["FirstName"].Value + "</p></td>" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkInDt"].Value + "</p></td>" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["ChkOutDt"].Value + "</p></td>" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + document.SelectNodes("//HdrXml")[i].Attributes["DateDiffs"].Value + "</p></td>" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">Canceled</p></td>" +
                                   " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + data[4].ToString() + "</p></td>" +
                                   " </tr>";
                               }
                           }
                           GuestDetailsTable1 += "</table>";


                           string Footer =
                            " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                            " <tr style=\"font-size:11px; background-color:#eee;\">" +
                            " <td width=\"600\" style=\"padding:12px 5px;\">" +
                             "<p style=\"margin-top:20px;\">" +
                            " <span style=\"color:#f54d02; font-weight:bold\">Looking forward to your next stay with us! </span><br>" +
                            " </p>" +
                            " <p style=\"color:black; font-weight:bold; margin:0px; font-size:14px;\"> Please refrain from sending emails to this id as the inbox is not monitored. Please reply to stay@hummingbirdindia.com for clarifications, if any.</p>" +
                            " </td></tr></table>";

                           string Disclaimer = "This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. HummingBird Travel & Stay Private Limited (HummingBird) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within HummingBird or outside. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. Please note that e-mails are susceptible to change and HummingBird shall not be liable for any improper, untimely or incomplete transmission.";
                           string FooterDtls =
                                " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                                " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                                " STAY SIMPLYFIED Travel and stay Pvt Ltd</p><br><hr>" +
                                " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                                " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" + Disclaimer + "</p>" +
                                " </td></tr> </table>";


                           message.Body = Imagebody + AddressDtls + GuestDetailsTable1 + Footer + FooterDtls;
                           message.IsBodyHtml = true;
                           // SMTP Email email:
                           System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                           smtp.Host = "smtp.gmail.com";
                           smtp.Port = 587;
                          // smtp.Credentials = new System.Net.NetworkCredential("stay@hummingbird.com", "stay1234");
                           smtp.Host = "email-smtp.us-west-2.amazonaws.com"; 
                           smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                           smtp.EnableSsl = true;
                           if (Err == "")
                           {
                                smtp.Send(message);
                               //ds.Tables.Add(ETable);
                           }
                           else
                           {
                               ETable.Rows.Add(Err + "  This EmailId Are Not Valid.");
                               //ds.Tables.Add(ETable);
                           }
                       }
                   }
            }
            ds.Tables.Add(ETable);
            return ds;
        }
    }
}
