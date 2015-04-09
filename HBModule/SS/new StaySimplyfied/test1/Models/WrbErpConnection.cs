﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebMatrix.WebData;

namespace test1.Models
{
    public class WrbErpConnection
    {

        public DataSet sqlExecuteScalar(SqlCommand command, string UserData)
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB"].ToString()))
            {
                connection.Open();
                SqlTransaction sqlTran = connection.BeginTransaction();
                command.Transaction = sqlTran;
                command.Connection = connection;
                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(dsResult);
                    sqlTran.Commit();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //CreateLogFiles Err = new CreateLogFiles();
                    //Err.ErrorLog(ex.Message + UserData);
                    //sqlTran.Rollback();
                }
            }
            return dsResult;
        }
        public DataTable sqlExecuteScalarDataTable(SqlCommand command, string UserData)
        {
            DataTable dsResult = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB"].ToString()))
            {
                connection.Open();
                SqlTransaction sqlTran = connection.BeginTransaction();
                command.Transaction = sqlTran;
                command.Connection = connection;
                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(dsResult);
                    sqlTran.Commit();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //CreateLogFiles Err = new CreateLogFiles();
                    //Err.ErrorLog(ex.Message + UserData);
                    //sqlTran.Rollback();
                }
            }
            return dsResult;
        }
        public DataSet SqlExecuteDataSet(SqlCommand command, string UserData)
        {
            DataSet dsResult = new DataSet();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB"].ToString()))
            {
                try
                {
                    command.CommandTimeout = 120;
                    command.Connection = connection;
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(dsResult);
                }
                catch (Exception ex)
                {
                    //CreateLogFiles Err = new CreateLogFiles();
                    //Err.ErrorLog(ex.Message + UserData);

                }
            }
            return dsResult;
        }
        public string ExecuteScalarUID(SqlCommand command, string UserData)
        {
            string EmpCode = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB"].ToString()))
            {
                connection.Open();
                SqlTransaction sqlTran = connection.BeginTransaction();
                try
                {
                    command.Transaction = sqlTran;
                    command.Connection = connection;

                    EmpCode = Convert.ToString(command.ExecuteScalar());
                    sqlTran.Commit();
                }
                catch (Exception ex)
                {
                    //CreateLogFiles Err = new CreateLogFiles();
                    //Err.ErrorLog(ex.Message);
                    //sqlTran.Rollback();
                }
            }
            return EmpCode;
        }
        public DataSet ExecuteDataSet(SqlCommand command, string UserData)
        {
            DataSet dsResult = new DataSet();

            DataTable dT = new DataTable("DTable");

            DataTable ErrdT = new DataTable("DBERRORTBL");

            ErrdT.Columns.Add("Exception");
            //string strr = "Data Source=I3-PC;Initial Catalog=HB2;User ID=sa;password=sa123;Integrated Security=true";            
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString()))
            {
                try
                {
                    command.Connection = connection;

                    SqlDataAdapter adapter = new SqlDataAdapter(command);

                    adapter.Fill(dsResult);
                }
                catch (Exception Ex)
                {
                    CreateLogFiles Err = new CreateLogFiles();

                    Err.ErrorLog("Database connection error during email send in WrbErpConnection.cs, User Application Id is : " + WebSecurity.CurrentUserId);
                }
                finally
                {
                    dsResult.Tables.Add(ErrdT); ErrdT.Dispose(); ErrdT = null;
                }
            }
            return dsResult;
        }
        public DataSet SaveExecuteDataSet(SqlCommand command, string UserData)// this is not used for two db insert process
        {
            DataSet dsResult = new DataSet();

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB"].ToString()))
            {

                DataTable dT = new DataTable("DTable");

                DataTable ErrdT = new DataTable("DBERRORTBL");

                ErrdT.Columns.Add("Exception");
                try
                {
                    command.Connection = connection;

                    SqlDataAdapter adapter = new SqlDataAdapter(command);

                    adapter.Fill(dsResult);
                }
                catch (Exception Ex)
                {
                    //CreateLogFiles Err = new CreateLogFiles();

                    //Err.ErrorLog(Ex.Message);
                    ////Err.ErrorLog(ConfigurationManager.ConnectionStrings["Log"].ToString(), Ex.Message, UserData);
                    //ErrdT.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
                }
                finally
                {
                    dsResult.Tables.Add(ErrdT); ErrdT.Dispose(); ErrdT = null;
                }
            }
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["HB1"].ToString()))
            {
                dsResult = new DataSet();

                DataTable dT1 = new DataTable("DTable");

                DataTable ErrdT1 = new DataTable("DBERRORTBL");

                ErrdT1.Columns.Add("Exception");
                try
                {
                    command.Connection = connection;

                    SqlDataAdapter adapter = new SqlDataAdapter(command);

                    adapter.Fill(dsResult);
                }
                catch (Exception Ex)
                {
                  

                   
                    ////Err.ErrorLog(ConfigurationManager.ConnectionStrings["Log"].ToString(), Ex.Message, UserData);
                    //ErrdT1.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
                }
                finally
                {
                    dsResult.Tables.Add(ErrdT1); ErrdT1.Dispose(); ErrdT1 = null;
                }
            }
            return dsResult;
        }


    }
}