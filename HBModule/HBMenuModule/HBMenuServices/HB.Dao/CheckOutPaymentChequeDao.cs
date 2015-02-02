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
    public class CheckOutPaymentChequeDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPaymentCheque ChkOutChq = new CheckOutPaymentCheque();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutChq.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("CheqXml").Attributes["ChkOutHdrId"].Value);
            ChkOutChq.Payment = doc.SelectSingleNode("CheqXml").Attributes["Payment"].Value;
            ChkOutChq.PayeeName = doc.SelectSingleNode("CheqXml").Attributes["PayeeName"].Value;
            ChkOutChq.Address = doc.SelectSingleNode("CheqXml").Attributes["Address"].Value;
            ChkOutChq.PaymentMode = doc.SelectSingleNode("CheqXml").Attributes["PaymentMode"].Value;
            if (doc.SelectSingleNode("CheqXml").Attributes["AmountPaid"].Value == "")
            {
                ChkOutChq.AmountPaid = 0;
            }
            else
            {
                ChkOutChq.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("CheqXml").Attributes["AmountPaid"].Value);
            }
            if (doc.SelectSingleNode("CheqXml").Attributes["OutStanding"].Value == "")
            {
                ChkOutChq.OutStanding = 0;
            }
            else
            {
                ChkOutChq.OutStanding = Convert.ToDecimal(doc.SelectSingleNode("CheqXml").Attributes["OutStanding"].Value);
            }
            ChkOutChq.ChequeNumber = doc.SelectSingleNode("CheqXml").Attributes["ChequeNumber"].Value;
            ChkOutChq.BankName = doc.SelectSingleNode("CheqXml").Attributes["BankName"].Value;
            ChkOutChq.DateIssued = doc.SelectSingleNode("CheqXml").Attributes["DateIssued"].Value;
            ChkOutChq.DateIssueMonth = Convert.ToInt32(doc.SelectSingleNode("CheqXml").Attributes["DateIssueMonth"].Value);
            ChkOutChq.DateIssueYear = Convert.ToInt32(doc.SelectSingleNode("CheqXml").Attributes["DateIssueYear"].Value);
            ChkOutChq.Id = Convert.ToInt32(doc.SelectSingleNode("CheqXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutChq.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCheque_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutChq.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCheque_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutChq.ChkOutHdrId;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutChq.Payment;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutChq.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutChq.Address;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutChq.AmountPaid;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutChq.PaymentMode;
            Cmd.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = ChkOutChq.ChequeNumber;
            Cmd.Parameters.Add("@BankName", SqlDbType.NVarChar).Value = ChkOutChq.BankName;
            Cmd.Parameters.Add("@DateIssued", SqlDbType.NVarChar).Value = ChkOutChq.DateIssued;
            Cmd.Parameters.Add("@DateIssueMonth", SqlDbType.Int).Value = ChkOutChq.DateIssueMonth;
            Cmd.Parameters.Add("@DateIssueYear", SqlDbType.Int).Value = ChkOutChq.DateIssueYear;
            Cmd.Parameters.Add("@OutStanding", SqlDbType.NVarChar).Value = ChkOutChq.OutStanding;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
    }
}
