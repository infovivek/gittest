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
    public class CheckOutPaymentCashDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPaymentCash ChkOutCash = new CheckOutPaymentCash();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutCash.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("CashXml").Attributes["ChkOutHdrId"].Value);
            ChkOutCash.Payment = doc.SelectSingleNode("CashXml").Attributes["Payment"].Value;
            ChkOutCash.PayeeName = doc.SelectSingleNode("CashXml").Attributes["PayeeName"].Value;
            ChkOutCash.Address = doc.SelectSingleNode("CashXml").Attributes["Address"].Value;
            ChkOutCash.CashReceivedOn = doc.SelectSingleNode("CashXml").Attributes["CashReceivedOn"].Value;
            ChkOutCash.CashReceivedBy = doc.SelectSingleNode("CashXml").Attributes["CashReceivedBy"].Value;
            ChkOutCash.PaymentMode = doc.SelectSingleNode("CashXml").Attributes["PaymentMode"].Value;

            if (doc.SelectSingleNode("CashXml").Attributes["AmountPaid"].Value == "")
            {
                ChkOutCash.AmountPaid = 0;
            }
            else
            {
                ChkOutCash.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("CashXml").Attributes["AmountPaid"].Value);
            }
            if (doc.SelectSingleNode("CashXml").Attributes["OutStanding"].Value == "")
            {
                ChkOutCash.OutStanding = 0;
            }
            else
            {
                ChkOutCash.OutStanding = Convert.ToDecimal(doc.SelectSingleNode("CashXml").Attributes["OutStanding"].Value);
            }
            ChkOutCash.Id = Convert.ToInt32(doc.SelectSingleNode("CashXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutCash.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:CheckOutPaymentCash_Update" + ", ProcName:'" + StoredProcedures.CheckOutPaymentCash_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCash_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutCash.Id;
            }
            else
            {

                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:CheckOutPaymentCash_Insert" + ", ProcName:'" + StoredProcedures.CheckOutPaymentCash_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCash_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutCash.ChkOutHdrId;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutCash.Payment;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutCash.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutCash.Address;
            Cmd.Parameters.Add("@CashReceivedOn", SqlDbType.NVarChar).Value = ChkOutCash.CashReceivedOn;
            Cmd.Parameters.Add("@CashReceivedBy", SqlDbType.NVarChar).Value = ChkOutCash.CashReceivedBy;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutCash.AmountPaid;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutCash.PaymentMode;
            Cmd.Parameters.Add("@OutStanding", SqlDbType.NVarChar).Value = ChkOutCash.OutStanding;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }
    }
}
