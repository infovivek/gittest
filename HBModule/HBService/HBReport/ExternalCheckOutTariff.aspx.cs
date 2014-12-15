﻿using System;
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

namespace HBReport
{
    public partial class ExternalCheckOutTariff : System.Web.UI.Page
    {
        SqlCommand command = new SqlCommand();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string domainName = Request.Url.AbsoluteUri;
                string[] Id = domainName.Split('?');
          //      string PropertyType1 = "";

                var asd = Id[1].Split('?');
                var asd1 = Id[2].Split(' ');
                

         //       var Name = Id[1].Split('@');
                command = new SqlCommand();
                ds = new DataSet();
                command.CommandText = "SP_ExtCheckOutTariff_Bill";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = "PAGELOAD";
                command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = asd1[0];
                command.Parameters.Add("@Id1", SqlDbType.Int).Value = asd[0];//Convert.ToInt32(asd[1]);
                command.Parameters.Add("@Id2", SqlDbType.Int).Value = 0;
                ds = new WrbErpConnection1().ExecuteDataSet(command, "");
                string sDataSourceName = "DataSet1";
                ReportDataSource rds = new ReportDataSource(sDataSourceName, ds.Tables[0]);
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(rds);
                ReportViewer1.LocalReport.Refresh();
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("") + @"\ExternalCheckOutTariff.rdlc";
                ReportViewer1.LocalReport.EnableExternalImages = true;

                ReportParameter paramLogo = new ReportParameter();

                paramLogo.Name = "Path";

                //paramLogo.Values.Add(@"D:\Project\HR_Service\WrbHRPrint\Images\Logo.png");
                // string var = ConfigurationManager.ConnectionStrings["Images"].ToString();
                paramLogo.Values.Add(@"http://sstage.in/Company_Images/HummingBird_Travel__0_0_HB_Logo.png_HB_Logo.png");
                ReportViewer1.LocalReport.SetParameters(paramLogo);
            }
        }

        //protected void ReportViewer_OnLoad(object sender, EventArgs e)
        //{
        //    string exportOption = "Excel";
        //    //exportOption[0] = ;
        //    //exportOption[1] = "Word";           
        //    string exportOption1 = "Word";
        //    // string exportOption = "PDF";
        //    RenderingExtension extension = ReportViewer1.LocalReport.ListRenderingExtensions().ToList().
        //        Find(x => x.Name.Equals(exportOption, StringComparison.CurrentCultureIgnoreCase));
        //    if (extension != null)
        //    {
        //        System.Reflection.FieldInfo fieldInfo = extension.GetType().GetField("m_isVisible", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
        //        fieldInfo.SetValue(extension, false);
        //    }

        //    RenderingExtension extension1 = ReportViewer1.LocalReport.ListRenderingExtensions().ToList().
        //       Find(x => x.Name.Equals(exportOption1, StringComparison.CurrentCultureIgnoreCase));
        //    if (extension != null)
        //    {
        //        System.Reflection.FieldInfo fieldInfo = extension1.GetType().GetField("m_isVisible", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
        //        fieldInfo.SetValue(extension1, false);
        //    }

        //}

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