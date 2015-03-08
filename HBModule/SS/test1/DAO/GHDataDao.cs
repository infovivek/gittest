using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using test1.Models;

namespace test1.DAO
{
    public class GHDataDao
    {
        public DataSet GHData(string[] data)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = "SP_GHReport_Help";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Pram3", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Pram4", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = 0;
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}