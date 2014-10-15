using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Drawing;
using System.Web;
using System.IO;

namespace HBWindowsService
{
    class WRBERPConnection
    {
        public DataSet ExecuteDataSet(SqlCommand command, string UserData)
        {
            DataSet dsResult = new DataSet();

            DataTable dT = new DataTable("DTable");

            DataTable ErrdT = new DataTable("DBERRORTBL");

            ErrdT.Columns.Add("Exception");

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.AppSettings["Client"].ToString()))
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
                    Err.ErrorLog(Ex.Message);                   
                    ErrdT.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
                }
                finally
                {
                    dsResult.Tables.Add(ErrdT); ErrdT.Dispose(); ErrdT = null;
                }
            }
            return dsResult;
        }
    }
}
