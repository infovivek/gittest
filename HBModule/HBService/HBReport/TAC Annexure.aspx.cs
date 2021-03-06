﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.Web.UI.WebControls;
using System.Configuration;
using HB.Dao;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace HBReport
{
    public partial class TAC_Annexure : System.Web.UI.Page
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            { 
                string domainName = Request.Url.AbsoluteUri;
                string[] Id = domainName.Split('?');
                var Name = Id[1].Split('@');
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "Sp_SearchInvoiceAnnexure_Help";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "PAGELOAD";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = Name[0];
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = Name[1];
                command.Parameters.Add("@Id1", SqlDbType.Int).Value = 0;// Convert.ToInt32(Id[1]);
                command.Parameters.Add("@Id2", SqlDbType.Int).Value = 0;
                ds = new WrbErpConnection1().ExecuteDataSet(command, "");
                string sDataSourceName = "DataSet1";
                ReportDataSource rds = new ReportDataSource(sDataSourceName, ds.Tables[0]);
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(rds);
                ReportViewer1.LocalReport.Refresh();
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("") + @"\TAC Annexure.rdlc";
                ReportViewer1.LocalReport.EnableExternalImages = true; 

                ReportParameter paramLogo = new ReportParameter(); 
                paramLogo.Name = "path";
                string var = ConfigurationManager.ConnectionStrings["Images"].ToString();
                paramLogo.Values.Add(@"file:///" + var + "LogoNew.png");
                // paramLogo.Values.Add(@"D:\Project\HR_Service\WrbHRPrint\Images\Logo.png");
                // string var = ConfigurationManager.ConnectionStrings["Images"].ToString();
        //        paramLogo.Values.Add(@"http://sstage.in/Company_Images/HummingBird_Travel__0_0_HB_Logo.png_HB_Logo.png");
                ReportViewer1.LocalReport.SetParameters(paramLogo); 
            }
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
            filename = string.Format("{0}.{1}", "TACInvoice-Annexure", "pdf");
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