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
    public class CheckOutPaymentCardDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPaymentCard ChkOutCard = new CheckOutPaymentCard();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutCard.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("CardXml").Attributes["ChkOutHdrId"].Value);
            ChkOutCard.Payment = doc.SelectSingleNode("CardXml").Attributes["Payment"].Value;
            ChkOutCard.PayeeName = doc.SelectSingleNode("CardXml").Attributes["PayeeName"].Value;
            ChkOutCard.Address = doc.SelectSingleNode("CardXml").Attributes["Address"].Value;
            ChkOutCard.CardDetails = doc.SelectSingleNode("CardXml").Attributes["CardDetails"].Value;
            ChkOutCard.CCBrand = doc.SelectSingleNode("CardXml").Attributes["CCBrand"].Value;
            ChkOutCard.PaymentMode = doc.SelectSingleNode("CardXml").Attributes["PaymentMode"].Value;
            if (doc.SelectSingleNode("CardXml").Attributes["AmountPaid"].Value == "")
            {
                ChkOutCard.AmountPaid = 0;
            }
            else
            {
                ChkOutCard.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("CardXml").Attributes["AmountPaid"].Value);
            }
            if (doc.SelectSingleNode("CardXml").Attributes["OutStanding"].Value == "")
            {
                ChkOutCard.OutStanding = 0;
            }
            else
            {
                ChkOutCard.OutStanding = Convert.ToDecimal(doc.SelectSingleNode("CardXml").Attributes["OutStanding"].Value);
            }
            ChkOutCard.NameoftheCard = doc.SelectSingleNode("CardXml").Attributes["NameoftheCard"].Value;
            ChkOutCard.CreditCardNo = doc.SelectSingleNode("CardXml").Attributes["CreditCardNo"].Value;
            ChkOutCard.ExpiryOn = doc.SelectSingleNode("CardXml").Attributes["ExpiryOn"].Value;
            ChkOutCard.ROC = doc.SelectSingleNode("CardXml").Attributes["ROC"].Value;
            ChkOutCard.SOCBatchCloseNo = doc.SelectSingleNode("CardXml").Attributes["SOCBatchCloseNo"].Value;
            ChkOutCard.AmountSwipedFor = doc.SelectSingleNode("CardXml").Attributes["AmountSwipedFor"].Value;
            ChkOutCard.ExpiryMonth =Convert.ToInt32(doc.SelectSingleNode("CardXml").Attributes["ExpiryMonth"].Value);
            ChkOutCard.ExpiryYear = Convert.ToInt32(doc.SelectSingleNode("CardXml").Attributes["ExpiryYear"].Value);
            ChkOutCard.Id = Convert.ToInt32(doc.SelectSingleNode("CardXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutCard.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:CheckOutPaymentCard_Update" + ", ProcName:'" + StoredProcedures.CheckOutPaymentCard_Update;


                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCard_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutCard.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:CheckOutPaymentCard_Insert" + ", ProcName:'" + StoredProcedures.CheckOutPaymentCard_Insert;


                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCard_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutCard.ChkOutHdrId;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutCard.Payment;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutCard.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutCard.Address;
            Cmd.Parameters.Add("@CardDetails", SqlDbType.NVarChar).Value = ChkOutCard.CardDetails;
            Cmd.Parameters.Add("@CCBrand", SqlDbType.NVarChar).Value = ChkOutCard.CCBrand;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutCard.AmountPaid;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutCard.PaymentMode;
            Cmd.Parameters.Add("@NameoftheCard", SqlDbType.NVarChar).Value = ChkOutCard.NameoftheCard;
            Cmd.Parameters.Add("@CreditCardNo", SqlDbType.NVarChar).Value = ChkOutCard.CreditCardNo;
            Cmd.Parameters.Add("@ExpiryOn", SqlDbType.NVarChar).Value = ChkOutCard.ExpiryOn;
            Cmd.Parameters.Add("@ROC", SqlDbType.NVarChar).Value = ChkOutCard.ROC;
            Cmd.Parameters.Add("@SOCBatchCloseNo", SqlDbType.NVarChar).Value = ChkOutCard.SOCBatchCloseNo;
            Cmd.Parameters.Add("@AmountSwipedFor", SqlDbType.NVarChar).Value = ChkOutCard.AmountSwipedFor;
            Cmd.Parameters.Add("@ExpiryMonth", SqlDbType.Int).Value = ChkOutCard.ExpiryMonth;
            Cmd.Parameters.Add("@ExpiryYear", SqlDbType.Int).Value = ChkOutCard.ExpiryYear;
            Cmd.Parameters.Add("@OutStanding", SqlDbType.NVarChar).Value = ChkOutCard.OutStanding;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }
    }
}
