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
    public class BTCSPaymentDAO
    {
        String UserData;
        public DataSet Save(string[] Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            DataTable dT = new DataTable("Table");
            DataTable ErrdT = new DataTable("DBERRORTBL");
            ErrdT.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            BTCSubmission BTCS = new BTCSubmission();
            XmlDocument document = new XmlDocument();
         
            dTable.Columns.Add("Exception");
            dT.Columns.Add("Id");
            document.LoadXml(Hdrval[1]);
            

            BTCS.Mode = document.SelectSingleNode("HdrXml").Attributes["Mode"].Value;

            if (BTCS.Mode == "Cash")
            {
                BTCS.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
                BTCS.Amount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Amount"].Value);
                BTCS.ReceivedDate = document.SelectSingleNode("HdrXml").Attributes["ReceivedDate"].Value;
                BTCS.ReceivedBy = document.SelectSingleNode("HdrXml").Attributes["ReceivedBy"].Value;
                BTCS.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;

                command = new SqlCommand();

                 UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:BTC Submission Insert" + ", ProcName:'" + StoredProcedures.BTCSubmission_Save;

                command.CommandText = StoredProcedures.BTCSubmissionCash_Insert;
                

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ClientId", SqlDbType.Int).Value = BTCS.ClientId;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = BTCS.Amount;
                command.Parameters.Add("@ReceivedOn", SqlDbType.NVarChar).Value = BTCS.ReceivedDate;
                command.Parameters.Add("@ReceivedBy", SqlDbType.NVarChar).Value = BTCS.ReceivedBy;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = BTCS.Comments;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = BTCS.Mode;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else if (BTCS.Mode == "Card")
            {
                BTCS.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
                BTCS.Amount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Amount"].Value);
                BTCS.CardBrand = document.SelectSingleNode("HdrXml").Attributes["CardBrand"].Value;
                BTCS.Nameoncard = document.SelectSingleNode("HdrXml").Attributes["Nameoncard"].Value;
                BTCS.CardNumber = document.SelectSingleNode("HdrXml").Attributes["CardNumber"].Value;
                BTCS.ExpiryMonth = document.SelectSingleNode("HdrXml").Attributes["ExpiryMonth"].Value;
                BTCS.ExpiryYear = document.SelectSingleNode("HdrXml").Attributes["ExpiryYear"].Value;
                BTCS.ROC = document.SelectSingleNode("HdrXml").Attributes["ROC"].Value;
                BTCS.SOC = document.SelectSingleNode("HdrXml").Attributes["SOC"].Value;
                BTCS.Swipedfor = document.SelectSingleNode("HdrXml").Attributes["Swipedfor"].Value;
                BTCS.Remarks = document.SelectSingleNode("HdrXml").Attributes["Remarks"].Value;
                BTCS.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;
                BTCS.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

                command = new SqlCommand();

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:BTC Submission Insert" + ", ProcName:'" + StoredProcedures.BTCSubmission_Save;

                command.CommandText = StoredProcedures.BTCSubmissionCard_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ClientId", SqlDbType.Int).Value = BTCS.ClientId;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = BTCS.Amount;
                command.Parameters.Add("@CCBrand", SqlDbType.NVarChar).Value = BTCS.CardBrand;
                command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = BTCS.Nameoncard;
                command.Parameters.Add("@CardNumber", SqlDbType.NVarChar).Value = BTCS.CardNumber;
                command.Parameters.Add("@ExpiryMonth", SqlDbType.NVarChar).Value = BTCS.ExpiryMonth;
                command.Parameters.Add("@ExpiryYear", SqlDbType.NVarChar).Value = BTCS.ExpiryYear;
                command.Parameters.Add("@ROC", SqlDbType.NVarChar).Value = BTCS.ROC;
                command.Parameters.Add("@SOC", SqlDbType.NVarChar).Value = BTCS.SOC;
                command.Parameters.Add("@Swipedfor", SqlDbType.NVarChar).Value = BTCS.Swipedfor;
                command.Parameters.Add("@Remarks", SqlDbType.NVarChar).Value = BTCS.Remarks;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = BTCS.Comments;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = BTCS.Mode;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else if (BTCS.Mode == "Cheque")
            {
                BTCS.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
                BTCS.Amount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Amount"].Value);
                BTCS.ChequeNo = document.SelectSingleNode("HdrXml").Attributes["ChequeNo"].Value;
                BTCS.Bank = document.SelectSingleNode("HdrXml").Attributes["Bank"].Value;
                BTCS.DateIssued = document.SelectSingleNode("HdrXml").Attributes["DateIssued"].Value;
                BTCS.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;
                BTCS.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

                command = new SqlCommand();

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:BTC Submission Insert" + ", ProcName:'" + StoredProcedures.BTCSubmission_Save;

                command.CommandText = StoredProcedures.BTCSubmissionCheque_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ClientId", SqlDbType.Int).Value = BTCS.ClientId;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = BTCS.Amount;
                command.Parameters.Add("@ChequeNo", SqlDbType.NVarChar).Value = BTCS.ChequeNo;
                command.Parameters.Add("@Bank", SqlDbType.NVarChar).Value = BTCS.Bank;
                command.Parameters.Add("@IssueDate", SqlDbType.NVarChar).Value = BTCS.DateIssued;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = BTCS.Comments;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = BTCS.Mode;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            else if (BTCS.Mode == "NEFT")
            {
                BTCS.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
                BTCS.Amount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Amount"].Value);
                BTCS.ReferenceNo = document.SelectSingleNode("HdrXml").Attributes["ReferenceNo"].Value;
                BTCS.Bank = document.SelectSingleNode("HdrXml").Attributes["Bank"].Value;
                BTCS.DateIssued = document.SelectSingleNode("HdrXml").Attributes["NEFTDate"].Value;
                BTCS.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;
                BTCS.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

                command = new SqlCommand();

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:BTC Submission Insert" + ", ProcName:'" + StoredProcedures.BTCSubmission_Save;

                command.CommandText = StoredProcedures.BTCSubmissionNEFT_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ClientId", SqlDbType.Int).Value = BTCS.ClientId;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = BTCS.Amount;
                command.Parameters.Add("@ReferenceNo", SqlDbType.NVarChar).Value = BTCS.ReferenceNo;
                command.Parameters.Add("@Bank", SqlDbType.NVarChar).Value = BTCS.Bank;
                command.Parameters.Add("@NEFTDate", SqlDbType.NVarChar).Value = BTCS.DateIssued;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = BTCS.Comments;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = BTCS.Mode;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }
    }
}

