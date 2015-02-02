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
   public class TariffBasedReportDao
    {
       public DataSet Help(string[] data, User user)
       {
           SqlCommand command = new SqlCommand();

            command.CommandText = StoredProcedures.TariffBasedReport;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
           command.Parameters.Add("@Param1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@Param2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
           command.Parameters.Add("@FromDate", SqlDbType.VarChar).Value = data[4].ToString();
           command.Parameters.Add("@ToDate", SqlDbType.VarChar).Value = data[5].ToString();
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;

           return new WrbErpConnection().ExecuteDataSet(command, "");
       }

    }
}

