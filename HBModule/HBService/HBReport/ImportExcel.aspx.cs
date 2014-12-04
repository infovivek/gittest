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
      public partial class ImportExcel : System.Web.UI.Page
      {
          protected void Page_Load(object sender, EventArgs e)
          {
              if (!Page.IsPostBack)
              {
                  LoadData();
              }
          }

          private void LoadData()
          {
              //SqlCommand cmd = new SqlCommand();
              //cmd.CommandText = "select  ClientName as Client,Id as CId from WRBHBClientManagement";
              //cmd.CommandType = CommandType.Text;
              //DataSet ds = new WrbErpConnection1().ExecuteDataSet(cmd, "");
              //DropDownList1.DataSource = ds.Tables[0];
              string sqlConnectionString1 = @"Data Source=103.230.84.173;Initial Catalog=HBTEST;User ID=sa;Password=HBadmin007";
              SqlConnection con = new SqlConnection(sqlConnectionString1);
              SqlCommand cmd = new SqlCommand("select  ClientName as Client,Id as CId from WRBHBClientManagement GROUP BY ClientName,Id	ORDER BY ClientName ASC", con);
              con.Open();
              DataTable dt = new DataTable();
              dt.Load(cmd.ExecuteReader());
              con.Close();
              DropDownList1.DataSource = dt;
              DropDownList1.DataTextField = "Client";
              DropDownList1.DataValueField = "CId";
              DropDownList1.DataBind();
             
          }
          protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
          {
              string ClientId = DropDownList1.SelectedValue;
          }
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
                  string sqlConnectionString = @"Data Source=103.230.84.173;Initial Catalog=HBTEST;User ID=sa;Password=HBadmin007";
                  // Bulk Copy to SQL Server 
                  SqlBulkCopy bulkInsert = new SqlBulkCopy(sqlConnectionString);
                  bulkInsert.DestinationTableName = "WRBHBImportGuest";
                  bulkInsert.WriteToServer(dr);
                  SqlConnection conn = new SqlConnection(sqlConnectionString);
                  connection.Close();
                  string sql = null;
                  SqlCommand Cmd = new SqlCommand("UPDATE WRBHBImportGuest SET ClientId = @ClientId", conn);
                  Cmd.Parameters.Add("@ClientId", SqlDbType.NVarChar).Value = DropDownList1.SelectedValue;

                  try
                  {
                      conn.Open();
                      Cmd.ExecuteNonQuery();
                      SqlCommand sqlCommand = new SqlCommand("select EmpCode,FirstName,LastName,Grade,MobileNo,Email,Designation,Nationality,Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10 from WRBHBImportGuest", conn);
                      SqlDataAdapter adapter1 = new SqlDataAdapter(sqlCommand);
                      DataTable dst = new DataTable();
                      adapter1.Fill(dst);
                      GridView1.DataSource = dst;
                      GridView1.DataBind();
                      DataTable dsResult = new DataTable();
                      SqlDataAdapter adapter = new SqlDataAdapter("select Id from WRBHBImportGuest", conn);
                      adapter.Fill(dsResult);
                      for (int i = 0; i < dsResult.Rows.Count; i++)
                      {
                          SqlCommand comm = new SqlCommand();
                          DataSet ds = new DataSet();
                          comm.CommandText = "Sp_ImportGuest_Insert";
                          comm.CommandType = CommandType.StoredProcedure;
                          comm.Parameters.Add("@Id", SqlDbType.Int).Value = dsResult.Rows[i][0].ToString();
                          ds = new WrbErpConnection1().ExecuteDataSet(comm, "");
                      }
                      conn.Close();
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
