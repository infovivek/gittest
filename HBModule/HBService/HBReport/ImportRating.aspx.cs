using System;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data.Sql;
using System.Data.OleDb;
using System.Data.Common;
using System.Collections;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using HB.Dao;
using System.Net;

namespace HBReport
{
    public partial class ImportRating : System.Web.UI.Page
    {
        protected void Upload(object sender, EventArgs e)
        {
            string path = "D:/" + FileUpload1.PostedFile.FileName;
            if (FileUpload1.PostedFile.FileName != "")
            {
                FileUpload1.SaveAs(path);
                // Connection String to Excel Workbook
                string excelConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=Excel 8.0", path);
                OleDbConnection connection = new OleDbConnection();
                connection.ConnectionString = excelConnectionString;
                OleDbCommand command = new OleDbCommand("select * from [Sheet1$]", connection);
                connection.Open();
                // Create DbDataReader to Data Worksheet
                DbDataReader dr = command.ExecuteReader();
                // SQL Server Connection String
                //string sqlConnectionString = ConfigurationManager.ConnectionStrings["HB"].ToString();
                string sqlConnectionString = @"Data Source=WARBLERS-AE164B;Initial Catalog=HBDEC10;User ID=sa;Password=sa123";
                // Bulk Copy to SQL Server 
                SqlBulkCopy bulkInsert = new SqlBulkCopy(sqlConnectionString);
                bulkInsert.DestinationTableName = "WRBHBPropertyRating";
                bulkInsert.WriteToServer(dr);
                SqlConnection conn = new SqlConnection(sqlConnectionString);
                connection.Close();
                string sql = null;
                try
                {
                    SqlCommand sqlCommand = new SqlCommand("select Property,Rating,City from WRBHBPropertyRating", conn);
                    SqlDataAdapter adapter1 = new SqlDataAdapter(sqlCommand);
                    DataTable dst = new DataTable();
                    adapter1.Fill(dst);
                    GridView1.DataSource = dst;
                    GridView1.DataBind();
                    Label1.Visible = true;
                    Label1.Text = "Excel Imported Successfully";
                }
                catch (Exception ex)
                {
                    Label1.Visible = true;
                    Label1.Text = ex.ToString();
                }
            }
            else
            {
                Label1.Visible = true;
                Label1.Text = "Select Valid ExcelFile To Import";
            }
        }
    } 
}