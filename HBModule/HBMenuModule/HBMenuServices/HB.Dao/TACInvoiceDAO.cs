﻿using System;
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
    public class TACInvoiceDAO 
    {
         String UserData;
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:TACInvoice Help" + ", ProcName:'" + StoredProcedures.TACInvoice_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TACInvoice_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());

            command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@PId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());

            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[6].ToString();
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[7].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TACInvoice Search" + ", ProcName:'" + StoredProcedures.TACInvoice_Search;


            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TACInvoice_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());

            command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@PId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());

            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[6].ToString();
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[7].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
           // SqlCommand command = new SqlCommand();
           //// command.CommandText = StoredProcedures.TACInvoice_Search;
           // command.CommandType = CommandType.StoredProcedure;
           // command.Parameters.Add("@PId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
           // command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
           // if (data[3] == null)
           // {
           //     command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = "";
           // }
           // else
           // {
           //     command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
           // }
           // if (data[4] == null)
           // {
           //     command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = "";
           // }
           // else
           // {
           //     command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
           // }
           // //command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[7].ToString();
           // command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
           // return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
 }

