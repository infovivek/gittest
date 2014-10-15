using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Xml;
using System.Collections;


namespace HB.Dao
{
   public class CheckStatusDao
    { 
        public string Checkstatus(int num)
        {
            DataTable dt = new DataTable();
            DataSet ds1 = new DataSet();
            dt.Columns.Add("CreatedBy");
            SqlCommand command = new SqlCommand();
            command.CommandText = "Sp_CheckStatus_View";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = num;
            string val = new WrbErpConnection().ExecuteScalarUID(command, "");
            return val;
        }
        public DataSet ErrorHelp(string type, string[] data)
        {
            SqlCommand command = new SqlCommand();
            // command.CommandText = StoredProcedures.OTTimeleave_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[0].ToString();
            command.Parameters.Add("@PRowId", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@PDocRef", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@CatId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@RId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().SqlExecuteDataSet(command, "");
        }
    }
}
