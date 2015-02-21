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
    public class CheckOutPaymentDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPayment ChkOutPay = new CheckOutPayment();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutPay.CheckOutHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutHdrId"].Value);
            ChkOutPay.PayeeName = doc.SelectSingleNode("HdrXml").Attributes["PayeeName"].Value;
            ChkOutPay.Address = doc.SelectSingleNode("HdrXml").Attributes["Address"].Value;
            ChkOutPay.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["AmountPaid"].Value);
            ChkOutPay.SettlementStatus = doc.SelectSingleNode("HdrXml").Attributes["SettlementStatus"].Value;
            ChkOutPay.PaymentMode =doc.SelectSingleNode("HdrXml").Attributes["PaymentMode"].Value;
            ChkOutPay.Payment = doc.SelectSingleNode("HdrXml").Attributes["Payment"].Value;
            Cmd = new SqlCommand();
            if (ChkOutPay.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:CheckOutPayment_Update" + ", ProcName:'" + StoredProcedures.CheckOutPayment_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPayment_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutPay.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:CheckOutPayment_Insert" + ", ProcName:'" + StoredProcedures.CheckOutPayment_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPayment_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutPay.CheckOutHdrId;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutPay.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutPay.Address;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutPay.AmountPaid;
            Cmd.Parameters.Add("@SettlementStatus", SqlDbType.NVarChar).Value = ChkOutPay.SettlementStatus;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutPay.PaymentMode;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutPay.Payment;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }
    }
}
