using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;

namespace HBWindowsService
{
   public class InvoiceGeneration
    {
        public void Invoice(string Type)
        {
            DataSet ds = new DataSet();
            SqlCommand command = new SqlCommand();
            command.CommandText = "SP_Invoice_Calculation";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.VarChar).Value = Type;
            command.Parameters.Add("@Date", SqlDbType.VarChar).Value = "";
            command.Parameters.Add("@Str2", SqlDbType.VarChar).Value = "";
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = "0";
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = "0";
            ds = new WRBERPConnection().ExecuteDataSet(command, Type +"Windows Service");

            if (Type == "Contract Details")
            {
                if (ds.Tables[0].Rows.Count != 0)
                {
                     System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                     message.From = new System.Net.Mail.MailAddress("noreply@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                     message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                     message.To.Add(new System.Net.Mail.MailAddress("Karthi@hummingbirdindia.com"));
                     message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com")); 
                     message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                     //message.To.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                     message.Subject = "Contract Expired";

                    // Dataset Table 0 begin
                    string GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>PropertyType</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Client Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Contract Expired Date</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Type</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Booking Level</p></th>" +
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
                        " </tr>";
                    }
                    message.Body = GuestDetailsTable1;
                    message.IsBodyHtml = true;
                    // SMTP Email email:
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.Host = "smtp.gmail.com";
                    smtp.Port = 587;                    
                    smtp.Credentials = new System.Net.NetworkCredential("noreply@hummingbirdindia.com","Password#2013");
                    smtp.EnableSsl = true;
                    //smtp.Send(message);
                }
            }
            else if (Type == "Booking Close Details")
            {
                if (ds.Tables[0].Rows.Count != 0)
                {
                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                    message.From = new System.Net.Mail.MailAddress("noreply@hummingbirdindia.com", "", System.Text.Encoding.UTF8);
                    message.To.Add(new System.Net.Mail.MailAddress("shiv@hummingbirdindia.com"));
                    message.To.Add(new System.Net.Mail.MailAddress("silam@hummingbirdindia.com"));
                    message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));                  
                    message.Bcc.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                   // message.To.Add(new System.Net.Mail.MailAddress("arun@warblerit.com"));
                    message.Subject = "Expected  Check-In as on : " + ds.Tables[1].Rows[0][0].ToString();

                    // Dataset Table 0 begin
                    string GuestDetailsTable1 =
                        " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                        " <tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>BookingCode</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>CheckInDate</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Client Name</p></th>" +                        
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Property Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Guest Name</p></th>" +
                        " <th style=\"background-color:#ccc; padding:6px 0px; border-right:1px solid #666;\"><p>Resident Managers</p></th>" +
                        " </tr>";

                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        GuestDetailsTable1 +=
                        "<tr style=\"font-size:11px; font-weight:normal;\">" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][0].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][1].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][2].ToString() + "</p></td>" +
                        " <td style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][3].ToString() + "</p></td>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][4].ToString() + "</p></th>" +
                        " <th style=\"background-color:#eee; padding:6px 0px; border-right:1px solid #666;\"><p style=\"text-align:center;\">" + ds.Tables[0].Rows[i][5].ToString() + "</p></th>" +
                        " </tr>";
                    }
                    message.Body = GuestDetailsTable1;
                    message.IsBodyHtml = true;
                    // SMTP Email email:
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.Host = "smtp.gmail.com";
                    smtp.Port = 587;                    
                    smtp.Credentials = new System.Net.NetworkCredential("noreply@hummingbirdindia.com","Password#2013");
                    smtp.EnableSsl = true;
                    //smtp.Send(message);
                }
            }
            DateTime dateTime = DateTime.UtcNow.Date;
            CreateLogFiles Err = new CreateLogFiles();
            Err.ErrorLog(Type +" "+dateTime.ToString("dd/MM/yyyy"));
        }
    }
}
