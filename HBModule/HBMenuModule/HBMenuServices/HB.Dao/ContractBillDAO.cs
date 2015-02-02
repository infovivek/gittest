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
    public class ContractBillDAO
    {
        String UserData;
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            ContractBillEntity CB = new ContractBillEntity();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1]);

            CB.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            CB.ContractId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ContractId"].Value);
            if (document.SelectSingleNode("//HdrXml").Attributes["LTTax"].Value == "")
            {
                CB.LTTax = 0;
            }
            else
            {
                CB.LTTax = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["LTTax"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["STTax"].Value == "")
            {
                CB.STTax = 0;
            }
            else
            {
                CB.STTax = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["STTax"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Cess"].Value == "")
            {
                CB.Cess = 0;
            }
            else
            {
                CB.Cess = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["Cess"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Hcess"].Value == "")
            {
                CB.HCess = 0;
            }
            else
            {
                CB.HCess = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["Hcess"].Value);
            }

            if (document.SelectSingleNode("//HdrXml").Attributes["LTPer"].Value == "")
            {
                CB.LTPer = 0;
            }
            else
            {
                CB.LTPer = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["LTPer"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["STPer"].Value == "")
            {
                CB.STPer = 0;
            }
            else
            {
                CB.STPer = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["STPer"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["TotalAmount"].Value == "")
            {
                CB.TotalAmount = 0;
            }
            else
            {
                CB.TotalAmount = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["TotalAmount"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["AdjustmentAmount"].Value == "")
            {
                CB.AdjustmentAmount = 0;
            }
            else
            {
                CB.AdjustmentAmount = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["AdjustmentAmount"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Attention"].Value == "")
            {
                CB.Attention = "";
            }
            else
            {
                CB.Attention = document.SelectSingleNode("//HdrXml").Attributes["Attention"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["ReferenceNo"].Value == "")
            {
                CB.ReferenceNo = "";
            }
            else
            {
                CB.ReferenceNo = document.SelectSingleNode("//HdrXml").Attributes["ReferenceNo"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Remarks"].Value == "")
            {
                CB.Remarks = "";
            }
            else
            {
                CB.Remarks = document.SelectSingleNode("//HdrXml").Attributes["Remarks"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["DueDate"].Value == "")
            {
                CB.DueDate = "";
            }
            else
            {
                CB.DueDate = document.SelectSingleNode("//HdrXml").Attributes["DueDate"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["ContractId"].Value == "")
            {
                CB.ContractId = 0;
            }
            else
            {
                CB.ContractId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ContractId"].Value);
            }

            if (document.SelectSingleNode("//HdrXml").Attributes["EndDate"].Value == "")
            {
                CB.EndDate = "";
            }
            else
            {
                CB.EndDate = document.SelectSingleNode("//HdrXml").Attributes["EndDate"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["StartDate"].Value == "")
            {
                CB.StartDate = "";
            }
            else
            {
                CB.StartDate = document.SelectSingleNode("//HdrXml").Attributes["StartDate"].Value;
            }


            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractBillDAO Update" + ", ProcName:'" + StoredProcedures.ContractBill_Update;

            command.CommandText = StoredProcedures.ContractBill_Update;

            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@LTPer", SqlDbType.Decimal).Value = CB.LTPer;
            command.Parameters.Add("@STPer", SqlDbType.Decimal).Value = CB.STPer;
            command.Parameters.Add("@LTTax", SqlDbType.Decimal).Value = CB.LTTax;
            command.Parameters.Add("@STTax", SqlDbType.Decimal).Value = CB.STTax;
            command.Parameters.Add("@Cess", SqlDbType.Decimal).Value = CB.Cess;
            command.Parameters.Add("@HCess", SqlDbType.Decimal).Value = CB.HCess;
            command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = CB.TotalAmount;
            command.Parameters.Add("@AdjustmentAmount", SqlDbType.Decimal).Value = CB.AdjustmentAmount;
            command.Parameters.Add("@Attention", SqlDbType.NVarChar).Value = CB.Attention;
            command.Parameters.Add("@ReferenceNo", SqlDbType.NVarChar).Value = CB.ReferenceNo;
            command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = CB.Remarks;
            command.Parameters.Add("@DueDate", SqlDbType.NVarChar).Value = CB.DueDate;
            command.Parameters.Add("@StartDate", SqlDbType.NVarChar).Value = CB.StartDate;
            command.Parameters.Add("@EndDate", SqlDbType.NVarChar).Value = CB.EndDate;
            command.Parameters.Add("@ContractId", SqlDbType.BigInt).Value = CB.ContractId;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = CB.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:PettyCashDAO Help" + ", ProcName:'" + StoredProcedures.PettyCash_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractBill_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = data[4].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:DepositDAO " + ", ProcName:'";// + StoredProcedures.; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ContractBill_Search;
            command.CommandType = CommandType.StoredProcedure;
            if (data[2] == null)
            {
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = "";
            }
            else
            {
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[2].ToString();
            }
            if (data[4] == null)
            {
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = "";
            }
            else
            {
                command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[4].ToString();
            }
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[6].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
