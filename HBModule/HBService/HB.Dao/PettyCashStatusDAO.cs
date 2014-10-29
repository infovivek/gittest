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
    public class PettyCashStatusDAO
    {
        string UserData;
        public DataSet Save(string PettyCashStatusHdr, User user, int PettyCashStatusHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            PettyCashStatusEntity PettySt = new PettyCashStatusEntity();
            XmlDocument doc = new XmlDocument();

            XmlDocument document = new XmlDocument();
            document.LoadXml(PettyCashStatusHdr);

            int n;
            n = (document).SelectNodes("//HdrXml").Count;
        
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value == "")
                {
                    PettySt.Id = 0;
                }
                else
                {
                    PettySt.Id = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["ExpenseHead"].Value == "")
                {
                    PettySt.ExpenseHead = "";
                }
                else
                {
                    PettySt.ExpenseHead = document.SelectNodes("//HdrXml")[i].Attributes["ExpenseHead"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Status"].Value == "")
                {
                    PettySt.Status = "";
                }
                else
                {
                    PettySt.Status = document.SelectNodes("//HdrXml")[i].Attributes["Status"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["Description"].Value == "")
                {
                    PettySt.Description = "";
                }
                else
                {
                    PettySt.Description = document.SelectNodes("//HdrXml")[i].Attributes["Description"].Value;
                }
                PettySt.Amount = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value);
                PettySt.Paid = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["Paid"].Value);
                if (document.SelectNodes("//HdrXml")[i].Attributes["FilePath"].Value == "")
                {
                    PettySt.FilePath = "";
                }
                else
                {
                    PettySt.FilePath = document.SelectNodes("//HdrXml")[i].Attributes["FilePath"].Value;
                }
                if (document.SelectNodes("//HdrXml")[i].Attributes["BillDate"].Value == "")
                {
                    PettySt.BillDate = "";
                }
                else
                {
                    PettySt.BillDate = document.SelectNodes("//HdrXml")[i].Attributes["BillDate"].Value;
                }
                PettySt.ExpenseId = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["ExpenseId"].Value);
                command = new SqlCommand();
                if (PettySt.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashStatusDAO Update" + ", ProcName:'" + StoredProcedures.PettyCashStatus_Update; 
              
                    command.CommandText = StoredProcedures.PettyCashStatus_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PettySt.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashStatusDAO Insert" + ", ProcName:'" + StoredProcedures.PettyCashStatus_Insert; 

                    command.CommandText = StoredProcedures.PettyCashStatus_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PettyCashStatusHdrId", SqlDbType.BigInt).Value = PettyCashStatusHdrId;
                command.Parameters.Add("@ExpenseHead", SqlDbType.NVarChar).Value = PettySt.ExpenseHead;
                command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = PettySt.Status;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = PettySt.Description;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = PettySt.Amount;
                command.Parameters.Add("@Paid", SqlDbType.Decimal).Value = PettySt.Paid;
                command.Parameters.Add("@BillLogo", SqlDbType.NVarChar).Value = PettySt.FilePath;
                command.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = PettySt.BillDate;
                command.Parameters.Add("@ExpenseId", SqlDbType.BigInt).Value = PettySt.ExpenseId;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }

           
    }
}
