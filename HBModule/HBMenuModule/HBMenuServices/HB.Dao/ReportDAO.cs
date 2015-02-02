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
   public class ReportDAO
    {
       public DataSet Help(string[] data, User user)
       {
           SqlCommand command = new SqlCommand();
           
           if ((data[1].ToString() == "Property") || (data[1].ToString() == "OccupancyChart"))
           {
               command.CommandText = StoredProcedures.Report_Help;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
               command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
               command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
               command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[4].ToString();
               command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = data[5].ToString();
               command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           }
           else if ((data[1].ToString() == "Month") || (data[1].ToString() == "Genarate"))
           {
               command.CommandText = StoredProcedures.ReportRentANDMaintenance_Help;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
               command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
               command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
               command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[4].ToString();
               command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = data[5].ToString();
               command.Parameters.Add("@Pram5", SqlDbType.VarChar).Value = data[6].ToString();
               command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           }
           else if ((data[1].ToString() == "InvoiceBill") || (data[1].ToString() == "Receipts Bill") || (data[1].ToString() == "Contract Bill") || (data[1].ToString() == "UnSettled"))
           {
               command.CommandText = StoredProcedures.InvoiceBill_Help;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
               command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
               command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
               command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[4].ToString();
               command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = data[5].ToString();
               command.Parameters.Add("@Pram5", SqlDbType.VarChar).Value = data[6].ToString();
               command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           }
           else
           {
               command.CommandText = StoredProcedures.BookingAndCheckInReport_Help;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
               command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
               command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
               command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[4].ToString();
               command.Parameters.Add("@Pram4", SqlDbType.VarChar).Value = data[5].ToString();
               command.Parameters.Add("@Pram5", SqlDbType.VarChar).Value = data[6].ToString();
               command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           }
           return new WrbErpConnection().ExecuteDataSet(command, "");
       }
    }
}
