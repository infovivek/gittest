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
    public class PCExpenseApprovalDAO
    {
        String UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string[] data, Entity.User user)
        {
            PCExpenseApproval PCRD = new PCExpenseApproval();
            XmlDocument document = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            document.LoadXml(data[1]);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {
                PCRD.Process = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Process"].Value);
                if (PCRD.Process == true)
                {
                    PCRD.RequestedOn = document.SelectNodes("//ServiceXml")[i].Attributes["RequestedOn"].Value;
                    PCRD.Requestedby = document.SelectNodes("//ServiceXml")[i].Attributes["Requestedby"].Value;
                    PCRD.PCAccount = document.SelectNodes("//ServiceXml")[i].Attributes["PCAccount"].Value;
                    PCRD.ApprovedAmount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["ApprovedAmount"].Value);
                    PCRD.ExpenseAmount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["ExpenseAmount"].Value);
                    //PCRD.RequestedStatus = document.SelectNodes("//ServiceXml")[i].Attributes["RequestedStatus"].Value;
                    PCRD.ProcessedStatus = document.SelectNodes("//ServiceXml")[i].Attributes["ProcessedStatus"].Value;
                    //PCRD.Status = document.SelectNodes("//ServiceXml")[i].Attributes["Status"].Value;
                    PCRD.Processedon = document.SelectNodes("//ServiceXml")[i].Attributes["Processedon"].Value;
                    PCRD.Comments = document.SelectNodes("//ServiceXml")[i].Attributes["Comments"].Value;
                    PCRD.RequestedUserId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["RequestedUserId"].Value);
                    PCRD.PropertyId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["PropertyId"].Value);
                    PCRD.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                    command = new SqlCommand();
                    if (PCRD.Id != 0)
                    {
                        UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PCExpenseApprovalDAO Update" + ", ProcName:'" + StoredProcedures.PCExpenseApproval_Update;

                        command.CommandText = StoredProcedures.PCExpenseApproval_Update;
                        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PCRD.Id;
                    }
                    else
                    {
                        UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PCExpenseApprovalDAO Insert" + ", ProcName:'" + StoredProcedures.PCExpenseApproval_Insert;

                        command.CommandText = StoredProcedures.PCExpenseApproval_Insert;
                    }


                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@RequestedOn", SqlDbType.NVarChar).Value = PCRD.RequestedOn;
                    command.Parameters.Add("@Requestedby", SqlDbType.NVarChar).Value = PCRD.Requestedby;
                    command.Parameters.Add("@PCAccount", SqlDbType.NVarChar).Value = PCRD.PCAccount;
                    command.Parameters.Add("@ApprovedAmount", SqlDbType.Decimal).Value = PCRD.ApprovedAmount;
                    command.Parameters.Add("@ExpenseAmount", SqlDbType.Decimal).Value = PCRD.ExpenseAmount;
                    command.Parameters.Add("@ProcessedStatus", SqlDbType.NVarChar).Value = PCRD.ProcessedStatus;
                    command.Parameters.Add("@LastProcessedon", SqlDbType.NVarChar).Value = PCRD.Processedon;
                    command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = PCRD.Comments;
                    command.Parameters.Add("@RequestedUserId", SqlDbType.Int).Value = PCRD.RequestedUserId;
                    command.Parameters.Add("@Process", SqlDbType.Int).Value = 1;
                    command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = PCRD.PropertyId;
                    command.Parameters.Add("@UserId", SqlDbType.Int).Value = user.Id;
                    command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }

            }
             return ds;
        }

        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PCExpenseApproval Help" + ", ProcName:'" + StoredProcedures.PCExpenseApproval_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PCExpenseApproval_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[5].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
