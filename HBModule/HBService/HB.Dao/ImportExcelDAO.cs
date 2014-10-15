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
    public class ImportExcelDAO
    {
        string UserData;
        string values;
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            ImportExcelEntity Import = new ImportExcelEntity();
            XmlDocument Doc = new XmlDocument();
            values = data[1].ToString();
           // Doc.LoadXml(data[1].ToString());
            Doc.LoadXml(values);
            int n;
            n = (Doc).SelectNodes("//HdrXml").Count;
            //command = new SqlCommand();
            for (int i = 0; i < n; i++)
            {
                Import.AccountNumber = Doc.SelectNodes("//HdrXml")[i].Attributes["AccountNumber"].Value;
                Import.TransactionDate = Doc.SelectNodes("//HdrXml")[i].Attributes["TxnDate"].Value;
               // Import.ValueDate = Doc.SelectNodes("//HdrXml")[i].Attributes["ValueDate"].Value;
                Import.Description = Doc.SelectNodes("//HdrXml")[i].Attributes["Description"].Value;
                Import.RefNo = Doc.SelectNodes("//HdrXml")[i].Attributes["RefNo"].Value;
              //  Import.BranchCode = Doc.SelectNodes("//HdrXml")[i].Attributes["BranchCode"].Value;
                //Import.Credit = Convert.ToDecimal(Doc.SelectNodes("//HdrXml")[i].Attributes["Credit"].Value);
                if (Doc.SelectNodes("//HdrXml")[i].Attributes["Credit"].Value == "")
                {
                    Import.Credit = 0;
                }
                else
                {
                    Import.Credit = Convert.ToDecimal(Doc.SelectNodes("//HdrXml")[i].Attributes["Credit"].Value);
                }

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:ImportExcelDAO Insert" + ", ProcName:'" + StoredProcedures.BankStatement_Insert; 

                command = new SqlCommand();
                command.CommandText = StoredProcedures.BankStatement_Insert;
               
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@AccountNumber", SqlDbType.NVarChar).Value = Import.AccountNumber;
                command.Parameters.Add("@TransactionDate", SqlDbType.NVarChar).Value = Import.TransactionDate;
              //  command.Parameters.Add("@ValueDate", SqlDbType.NVarChar).Value = Import.ValueDate;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Import.Description;
                command.Parameters.Add("@RefNo", SqlDbType.NVarChar).Value = Import.RefNo;
             //   command.Parameters.Add("@BranchCode", SqlDbType.NVarChar).Value = Import.BranchCode;
                command.Parameters.Add("@Credit", SqlDbType.Decimal).Value = Import.Credit;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }
    }
}
