using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.Configuration;
using HB.Dao;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace HBReport
{
    public partial class GuestCheckOutTariff : System.Web.UI.Page
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                //Warning[] warnings;
                //string[] streamids;
                //string mimeType;
                //string encoding;
                //string extension;
                //string filename;

                string domainName = Request.Url.AbsoluteUri;
                string[] Id = domainName.Split('?');
                //var Id = asd[1].Split(',');
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_GuestCheckOutTariff_Bill";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "PAGELOAD";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(Id[1]);
                command.Parameters.Add("@Id2", SqlDbType.Int).Value = 0;
                ds = new WrbErpConnection1().ExecuteDataSet(command, "");
                string sDataSourceName = "DataSet1";
                ReportDataSource rds = new ReportDataSource(sDataSourceName, ds.Tables[0]);
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(rds);
                ReportViewer1.LocalReport.Refresh();
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("") + @"\GuestCheckOutTariff.rdlc";
                ReportViewer1.LocalReport.EnableExternalImages = true;

                ReportParameter paramLogo = new ReportParameter();

                paramLogo.Name = "Path";

                //paramLogo.Values.Add(@"D:\Project\HR_Service\WrbHRPrint\Images\Logo.png");
                // string var = ConfigurationManager.ConnectionStrings["Images"].ToString();
                paramLogo.Values.Add(@"http://sstage.in/Company_Images/HummingBird_Travel__0_0_HB_Logo.png_HB_Logo.png");
                ReportViewer1.LocalReport.SetParameters(paramLogo);
             //   Byte[] mybytes = report.Render("WORD");
              //  Byte[] mybytes = ReportViewer1.LocalReport.Render("PDF");// for exporting to PDF

              // // Guid o = new Guid();
              ////  Random unique1 = new Random();
              //  DateTime now = DateTime.Now;
              //  string date = (now.ToString("yyyyMMddThhmmss"));

              //  using (FileStream fs = File.Create(@"E:\ExternalCheckOutTAC" + date + ".pdf"))
              //  {
              //      fs.Write(mybytes, 0, mybytes.Length);
              //  }

              //  string Valid = ""; string Err = "";
              //  string Email = "shameem@warblerit.com";
              //  Valid = EmailValidate(Email);

              //  if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
              //  {
              //      System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
              //      message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
              //      if (Valid == "True")
              //      {
              //          message.To.Add(new System.Net.Mail.MailAddress(Email));
              //      }
              //      else
              //      {
              //          Err = "";
              //      }
                    
              //      message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));

              //      message.Subject = "PDF Sample ";
              //      message.Attachments.Add(new Attachment(@"E:\ExternalCheckOutTAC" + date + ".pdf"));

              //      System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
              //      smtp.EnableSsl = true;
              //      smtp.Host = "email-smtp.us-west-2.amazonaws.com";
              //      smtp.Port = 587;
              //      smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
              //      try
              //      {
              //          smtp.Send(message);
              //      }
              //      catch (Exception ex)
              //      {
              //          CreateLogFiles log = new CreateLogFiles();
              //          log.ErrorLog(ex.Message + " -->External Checkout --> " + message.Subject);
              //      }
              //  }

                //MailMessage message = new MailMessage();
                //message.To = "abc@domain.com";
                //message.From = "xyz@domain.com";
                //message.Subject = "mail with pdf";
                //message.Body = "your pdf attached";
                //message.Attachments.Add(new Attachment(@"E:\CheckOut.pdf"));

                //SmtpMail.SmtpServer = "mail.domain.com";
                //SmtpMail.Send(message);
            }

        }

        private String EmailValidate(String EmailId)
        {
            string pattern = null;
            string Msg = null;
            pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

            if (Regex.IsMatch(EmailId, pattern))
            {
                Msg = "True";
            }
            else
            {
                Msg = "False";
            }
            return Msg;
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Warning[] warnings;
            string[] streamids;
            string mimeType;
            string encoding;
            string extension;
            string filename;
            byte[] bytes = ReportViewer1.LocalReport.Render(
               "PDF", null, out mimeType, out encoding,
                out extension,
               out streamids, out warnings);
            filename = string.Format("{0}.{1}", "CheckOutBill", "pdf");
            Response.ClearHeaders();
            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + filename);
            Response.ContentType = mimeType;
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }
    }
}