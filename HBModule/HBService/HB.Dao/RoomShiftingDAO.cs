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
    public class RoomShiftingDAO
    {
        string UserData = "";
        SqlCommand command = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : '" + user.ScreenName +
            "', SctId : " + user.SctId + ", Service : RoomShiftingDAO - Save" + ", ProcName : '" + StoredProcedures.RoomShifting_Insert;            
            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            RoomShifting RS = new RoomShifting();
            RS.BookingId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["BookingId"].Value);
            RS.FromRoomId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["FromRoomId"].Value);
            RS.ToRoomId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ToRoomId"].Value);
            RS.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            RS.RoomCaptured = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["RoomCaptured"].Value);
            RS.ChkInDt = document.SelectSingleNode("HdrXml").Attributes["ChkInDt"].Value;
            RS.ChkOutDt = document.SelectSingleNode("HdrXml").Attributes["ChkOutDt"].Value;
            RS.BookingLevel = document.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
            RS.ToRoomNo = document.SelectSingleNode("HdrXml").Attributes["ToRoomNo"].Value;
            RS.CurrentStatus = document.SelectSingleNode("HdrXml").Attributes["CurrentStatus"].Value;
            //
            RS.TariffMode = document.SelectSingleNode("HdrXml").Attributes["TariffMode"].Value;
            RS.ServiceMode = document.SelectSingleNode("HdrXml").Attributes["ServiceMode"].Value;
            command = new SqlCommand();
            if (RS.Id != 0)
            {
                command.CommandText = StoredProcedures.Booking_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = RS.Id;
            }
            else
            {
                command.CommandText = StoredProcedures.RoomShifting_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = RS.BookingId;
            command.Parameters.Add("@FromRoomId", SqlDbType.Int).Value = RS.FromRoomId;
            command.Parameters.Add("@ToRoomId", SqlDbType.Int).Value = RS.ToRoomId;
            command.Parameters.Add("@ChkInDt", SqlDbType.NVarChar).Value = RS.ChkInDt;
            command.Parameters.Add("@ChkOutDt", SqlDbType.NVarChar).Value = RS.ChkOutDt;
            command.Parameters.Add("@ToRoomNo", SqlDbType.NVarChar).Value = RS.ToRoomNo;
            command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = RS.BookingLevel;
            command.Parameters.Add("@RoomCaptured", SqlDbType.NVarChar).Value = RS.RoomCaptured;
            command.Parameters.Add("@CurrentStatus", SqlDbType.NVarChar).Value = RS.CurrentStatus;
            command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
            //
            command.Parameters.Add("@TariffMode", SqlDbType.NVarChar).Value = RS.TariffMode;
            command.Parameters.Add("@ServiceMode", SqlDbType.NVarChar).Value = RS.ServiceMode;
            DataSet ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            if (document.SelectSingleNode("HdrXml").Attributes["Mail"].Value == "Yes")
            {
                try
                {
                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                    //DSBooking.Tables[1].Rows[0][4].ToString()
                    message.From = new System.Net.Mail.MailAddress("stay@staysimplyfied.com", "", System.Text.Encoding.UTF8);
                    //message.To.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    //message.Subject = "Testing Modification Book # : " + ds.Tables[0].Rows[0][0].ToString();
                    message.To.Add(new System.Net.Mail.MailAddress("stay@staysimplyfied.com"));
                    if (ds.Tables[0].Rows[0][10].ToString() == "False")
                    {
                        //string gdfg = ds.Tables[4].Rows[0][0].ToString();
                        message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                    }
                    else
                    {
                        for (int i = 0; i < ds.Tables[5].Rows.Count; i++)
                        {
                            //string sd = ds.Tables[5].Rows[i][0].ToString();
                            message.To.Add(new System.Net.Mail.MailAddress(ds.Tables[5].Rows[i][0].ToString()));
                        }
                        if (ds.Tables[4].Rows[0][0].ToString() != "")
                        {
                            //string sds = ds.Tables[4].Rows[0][0].ToString();
                            message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[4].Rows[0][0].ToString()));
                        }
                    }
                    //Extra CC
                    for (int i = 0; i < ds.Tables[6].Rows.Count; i++)
                    {
                        //string sdsdf3 = ds.Tables[6].Rows[i][0].ToString();
                        message.CC.Add(new System.Net.Mail.MailAddress(ds.Tables[6].Rows[i][0].ToString()));
                    }
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));                
                    message.Bcc.Add(new System.Net.Mail.MailAddress("sakthi@warblerit.com"));
                    message.Subject = "Stay Modification Booking # : " + ds.Tables[0].Rows[0][0].ToString();
                    string Imagelocation = "";
                    if (ds.Tables[7].Rows.Count > 0)
                    {
                        if (ds.Tables[7].Rows[0][0].ToString() != "")
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
                       " <tr><td width=\"50%\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                       " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
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

                    string Remarks = "Stay Modified";
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

                    GuestDetailsTable1 +=
                            "<tr style=\"font-size:11px; font-weight:normal;\">" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][0].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][1].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][2].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][3].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][4].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][5].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][6].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][7].ToString() + "</p></td>" +
                            " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[8].Rows[0][8].ToString() + "</p></td>" +
                            " </tr></table>";

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
                    System.Net.Mail.SmtpClient SMTP = new System.Net.Mail.SmtpClient();
                    SMTP.EnableSsl = true;
                    SMTP.Port = 587;
                    //SMTP.Host = "smtp.gmail.com";SMTP.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                    SMTP.Host = "email-smtp.us-west-2.amazonaws.com";SMTP.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
                    SMTP.Send(message);
                }
                catch (Exception ex)
                {
                    CreateLogFiles log = new CreateLogFiles();
                    log.ErrorLog(ex.Message + " --> Room Shifting Mail --> " + ds.Tables[0].Rows[0][0].ToString());
                }
            }
            return ds;
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = "UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : '" + user.ScreenName +
            "', SctId : " + user.SctId + ", Service : RoomShiftingDAO - Help : Action Name : "+data[1].ToString() + ", ProcName : '" + StoredProcedures.RoomShifting_Insert; 
            command = new SqlCommand();
            command.CommandText = StoredProcedures.RoomShifting_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@ChkInDt", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@ChkOutDt", SqlDbType.NVarChar).Value = data[5].ToString();
            command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[8].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[9].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
