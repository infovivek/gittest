using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
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
    public partial class ExternalCheckoutTACMail : System.Web.UI.Page
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Warning[] warnings;
                string[] streamids;
                string mimeType;
                string encoding;
                string extension;
                string filename;

                string domainName = Request.Url.AbsoluteUri;
                string[] Id = domainName.Split('?');
                //var Id = asd[1].Split(',');
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_ExternalCheckOutTariffMail_Report";
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
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("") + @"\ExternalCheckoutTACMail.rdlc";
                ReportViewer1.LocalReport.EnableExternalImages = true;


                ReportParameter paramLogo = new ReportParameter();

                paramLogo.Name = "Path";

                //paramLogo.Values.Add(@"D:\Project\HR_Service\WrbHRPrint\Images\Logo.png");
                // string var = ConfigurationManager.ConnectionStrings["Images"].ToString();
                paramLogo.Values.Add(@"http://sstage.in/Company_Images/HummingBird_Travel__0_0_HB_Logo.png_HB_Logo.png");
                ReportViewer1.LocalReport.SetParameters(paramLogo);



                Byte[] mybytes = ReportViewer1.LocalReport.Render("PDF");// for exporting to PDF

               // Guid o = new Guid();
               // Random unique1 = new Random();

                //DateTime now = DateTime.Now;
                //string date = (now.ToString("yyyyMMddThhmmss"));

                using (FileStream fs = File.Create(@"D:\Backend\flex_bin\TACInVoice\" + ds.Tables[0].Rows[0][0].ToString() + ".pdf"))
            //    using (FileStream fs = File.Create(@"E:\Project\HBModule\HB\flex_bin\TACInVoice\" + ds.Tables[0].Rows[0][0].ToString() + ".pdf"))
                {
                    fs.Write(mybytes, 0, mybytes.Length);
                }
                if (ds.Tables[0].Rows[0][11].ToString() != "0") // Mail 
                {
                    string Valid = ""; string Err = "";
                    string Email = "shiv@hummingbirdindia.com";
               //     string Email = "shameem@warblerit.com";
                    Valid = EmailValidate(Email);

                    if ((ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist"))
                    {
                        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                        message.From = new System.Net.Mail.MailAddress("noreply@staysimplyfied.com", "staysimplyfied", System.Text.Encoding.UTF8);
                        if (Valid == "True")
                        {
                            message.To.Add(new System.Net.Mail.MailAddress(Email));
                        }
                        else
                        {
                            Err = "";
                        }

                        message.Bcc.Add(new System.Net.Mail.MailAddress("vivek@warblerit.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("shameem@warblerit.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("silam@hummingbirdindia.com"));
                        message.Bcc.Add(new System.Net.Mail.MailAddress("karthik@hummingbirdindia.com"));

                        message.Subject = "TACInVoice : " + ds.Tables[0].Rows[0][8].ToString();
                        string Imagelocation = "";
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() != "")
                                Imagelocation = ds.Tables[0].Rows[0][26].ToString();
                        }

                        message.Body = "";
                        string Imagebody =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\" position: relative; font-family:  arial, helvetica; font-size: 12px;  border: #cccdcf solid 1px\">" +
                           " <tr><td><table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\">" +
                           " <tr><td width=\"600\" align=\"left\" style=\"padding: 10px 0px 10px 10px;\"> " +
                           " <img src=" + Imagelocation + " width=\"200px\" height=\"52px\" alt=\"Humming bird logo\">" +
                           " </td></tr></table>";
                        string Header =
                                  " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:30px;\">" +
                                  " <tr style=\"font-size:12px; \">" +
                                  " <td width=\"600\" style=\"padding:12px 5px;\">" +
                                  " <p style=\"margin-top:20px;\">" +
                                  " <span> System generated email. Please do not reply. </span>" +
                                  " <style=\"margin-top:20px;\">" +
                                  " <span style=\"float:right\"  >   Date : " + ds.Tables[0].Rows[0][39].ToString() + "</span><br>" +
                                  " </td></tr></table>";
                        string AddressDtls =
                                   " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:0px;\">" +
                                   " <tr style=\"font-size:12px;\">" +
                                   " <td width=\"600\" style=\"padding:3px 5px;\">" +
                                   " <p style=\"margin-top:10px;\">" +
                                   "<span>Hello, </span> " + " <br>" +
                                   " </p>" +
                                   "<span>Kindly find attached Commission Invoice for the booking given to your property, for which payment is collected by you. " + 
                                    " <br>" +
                                   " </p>" +
                                   "<br>"+
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Invoice No                 : </span> " + ds.Tables[0].Rows[0][8].ToString() + "  <br>" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   //" <p style=\"margin-top:20px;\">" +
                                   " <span style=\"color:#f54d02; font-weight:bold\">Guest Name                 :</span> " + ds.Tables[0].Rows[0][0].ToString() + "  <br>" +
                                   " </p><p style=\"margin-top:5px;\">" + "<br>" +
                                  
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Property Name              :</span> " + ds.Tables[0].Rows[0][24].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Client Name                :</span> " + ds.Tables[0].Rows[0][6].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   " <span style=\"color:#f54d02; font-weight:bold\">TAC Amount                 :</span> " + ds.Tables[0].Rows[0][9].ToString() + "" +
                                   " </p><p style=\"margin-top:5px;\">" +
                                   " <span style=\"color:#f54d02; font-weight:bold\">No Of Days                 :</span> " + ds.Tables[0].Rows[0][14].ToString() + "" +
                                   " </p><p style=\"margin-top:5px;\">" +
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Total Amount               :</span> " + ds.Tables[0].Rows[0][10].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Business Service Tax(12%)  :</span> " + ds.Tables[0].Rows[0][12].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   //" <span style=\"color:#f54d02; font-weight:bold\">Cess 2%                    :</span> " + ds.Tables[0].Rows[0][13].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   //" <span style=\"color:#f54d02; font-weight:bold\">HCess 1%                   :</span> " + ds.Tables[0].Rows[0][14].ToString() + "" +
                                   //" </p><p style=\"margin-top:5px;\">" +
                                   " <span style=\"color:#f54d02; font-weight:bold\">Net Amount                 :</span> " + ds.Tables[0].Rows[0][11].ToString() + "" +
                                   " </p><p style=\"margin-top:5px;\">" +
                                   " </p></td></tr></table>";

                        string FooterDtls =
                           " <table cellpadding=\"0\" cellspacing=\"0\" width=\"600\" border=\"0\" align=\"center\" style=\"padding-top:10px;\">" +
                           " <tr style=\"font-size:11px; font-weight:normal;\"> " +
                           " <td colspan=\"3\" style=\"padding-top:30px;\"> <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px;\"> Thanking You, <br>" +
                           " Team Stay Simplyfied </p> " + " <br>" +
                            //   " <p style=\"color:orange; font-weight:bold; margin:0px; font-size:11px; padding-top:20px;\">Disclaimer :</p>" +
                            //   " <p style=\"font-size:10px; padding-top:10px; padding-bottom:20px;\">" +// Disclaimer + "</p>" +
                           " </td></tr> </table>";

                        message.Body = Imagebody + Header + AddressDtls + FooterDtls;
                        message.IsBodyHtml = true;



                        //  message.Subject = "TAC InVoice ";
                        message.Attachments.Add(new Attachment(@"D:\Backend\flex_bin\TACInVoice\" + ds.Tables[0].Rows[0][0].ToString() + ".pdf"));
                   //     message.Attachments.Add(new Attachment(@"E:\Project\HBModule\HB\flex_bin\TACInVoice\" + ds.Tables[0].Rows[0][0].ToString() + ".pdf"));
                        //string[] files = new string[20];
                        //System.Net.Mail.Attachment attachment;
                        //MailMessage mail = new MailMessage();
                        //files = System.IO.Directory.GetFiles(@"E:\ExternalCheckOutTAC" + date + ".pdf", "*");
                        //foreach (string Attachments in files)
                        //{
                        //    attachment = new System.Net.Mail.Attachment(Attachments);
                        //    mail.Attachments.Add(attachment);

                        //}

                        System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                        smtp.EnableSsl = true;
                      smtp.Host = "email-smtp.us-west-2.amazonaws.com"; 
     //Local test       smtp.Host = "smtp.gmail.com"; 

                        smtp.Port = 587;
                        smtp.Credentials = new System.Net.NetworkCredential("AKIAIIVF5D5D3CJAX7SQ", "ApmuZkd+L8tissEga8kac3quhhwohEi5CB+dYD36KTq3");
            //            smtp.Credentials = new System.Net.NetworkCredential("stay@staysimplyfied.com", "stay1234");
                        try
                        {
                            smtp.Send(message);
                        }
                        catch (Exception ex)
                        {
                            CreateLogFiles log = new CreateLogFiles();
                            log.ErrorLog(ex.Message + " -->External Checkout --> " + message.Subject);
                        }
                }
                

                }

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
            filename = string.Format("{0}.{1}", "ExternalCheckoutTAC", "pdf");
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