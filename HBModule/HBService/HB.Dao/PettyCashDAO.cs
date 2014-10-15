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
    public class PettyCashDAO
    {
        string UserData;
        public DataSet Save(string PettyCashHdr, User user, int PettyCashHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            PettyCashEntity Petty = new PettyCashEntity();
            XmlDocument document = new XmlDocument();
            document.LoadXml(PettyCashHdr);
            int n;
            n = (document).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                Petty.Description = document.SelectNodes("//HdrXml")[i].Attributes["Description"].Value;
                Petty.ExpenseHead = document.SelectNodes("//HdrXml")[i].Attributes["ExpenseHead"].Value;
                Petty.Amount = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value);

                command = new SqlCommand();
                if (Petty.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashDAO Update" + ", ProcName:'" + StoredProcedures.PettyCash_Update; 

                    command.CommandText = StoredProcedures.PettyCash_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Petty.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashDAO Insert" + ", ProcName:'" + StoredProcedures.PettyCash_Insert; 

                    command.CommandText = StoredProcedures.PettyCash_Insert;
                }

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PettyCashHdrId", SqlDbType.NVarChar).Value = PettyCashHdrId;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Petty.Description;
                command.Parameters.Add("@ExpenseHead", SqlDbType.NVarChar).Value = Petty.ExpenseHead;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Petty.Amount;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = "Submitted";
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            }
            return ds;
        }
             
    }
}
