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
    public class ApprovedPettyCasDAO
    {
        string UserData;
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            ApprovedPettyCash Petty = new ApprovedPettyCash();
            XmlDocument doc = new XmlDocument();

            doc.LoadXml(data[1]);
            int n;
            n = (doc).SelectNodes("//HdrXml1").Count;
            for (int i = 0; i < n; i++)
            {
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["Id"].Value == "")
                {
                    Petty.Id = 0;
                }
                else
                {
                    Petty.Id = Convert.ToInt32(doc.SelectNodes("//HdrXml1")[i].Attributes["Id"].Value);
                }
                Petty.RequestedOn = doc.SelectSingleNode("//HdrXml1").Attributes["RequestedOn"].Value;
                Petty.PropertyId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml1").Attributes["PropertyId"].Value);
                Petty.UserId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml1").Attributes["UserId"].Value);
                Petty.ExpenseGroupId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml1").Attributes["ExpenseGroupId"].Value);
                Petty.Description = doc.SelectNodes("//HdrXml1")[i].Attributes["Description"].Value;
                Petty.ExpenseHead = doc.SelectNodes("//HdrXml1")[i].Attributes["ExpenseHead"].Value;
                Petty.RequestedAmount = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["RequestedAmount"].Value);
                Petty.ApprovedAmount = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["ApprovedAmount"].Value);
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["Comments"].Value == "")
                {
                    Petty.Comments = "";
                }
                else
                {
                    Petty.Comments = doc.SelectNodes("//HdrXml1")[i].Attributes["Comments"].Value;
                }
                command = new SqlCommand();
                if (Petty.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashDAO Update" + ", ProcName:'" + StoredProcedures.ApprovedPettyCash_Update;

                    command.CommandText = StoredProcedures.ApprovedPettyCash_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Petty.Id;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = Petty.RequestedOn;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Petty.Description;
                command.Parameters.Add("@ExpenseHead", SqlDbType.NVarChar).Value = Petty.ExpenseHead;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Petty.RequestedAmount;
                command.Parameters.Add("@ApprovedAmount", SqlDbType.Decimal).Value = Petty.ApprovedAmount;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = "Submitted";
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value =Petty.UserId;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Petty.PropertyId;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = Petty.Comments;
                command.Parameters.Add("@ExpenseGroupId", SqlDbType.BigInt).Value = Petty.ExpenseGroupId;
                command.Parameters.Add("@Total", SqlDbType.Decimal).Value =0;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            }
            return ds;
        }
    }
}
