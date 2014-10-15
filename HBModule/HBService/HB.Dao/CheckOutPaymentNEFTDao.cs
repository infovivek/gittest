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
    public class CheckOutPaymentNEFTDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPaymentNEFT ChkOutNEFT = new CheckOutPaymentNEFT();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutNEFT.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("NEFTXml").Attributes["ChkOutHdrId"].Value);
            ChkOutNEFT.Payment = doc.SelectSingleNode("NEFTXml").Attributes["Payment"].Value;
            ChkOutNEFT.PayeeName = doc.SelectSingleNode("NEFTXml").Attributes["PayeeName"].Value;
            ChkOutNEFT.Address = doc.SelectSingleNode("NEFTXml").Attributes["Address"].Value;
            ChkOutNEFT.ReferenceNumber = doc.SelectSingleNode("NEFTXml").Attributes["ReferenceNumber"].Value;
            ChkOutNEFT.DateofNEFT = doc.SelectSingleNode("NEFTXml").Attributes["DateofNEFT"].Value;
            ChkOutNEFT.BankName = doc.SelectSingleNode("NEFTXml").Attributes["BankName"].Value;
            ChkOutNEFT.PaymentMode = doc.SelectSingleNode("NEFTXml").Attributes["PaymentMode"].Value;

            if (doc.SelectSingleNode("NEFTXml").Attributes["AmountPaid"].Value == "")
            {
                ChkOutNEFT.AmountPaid = 0;
            }
            else
            {
                ChkOutNEFT.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("NEFTXml").Attributes["AmountPaid"].Value);
            }

            if (doc.SelectSingleNode("NEFTXml").Attributes["OutStanding"].Value == "")
            {
                ChkOutNEFT.OutStanding = 0;
            }
            else
            {
                ChkOutNEFT.OutStanding = Convert.ToDecimal(doc.SelectSingleNode("NEFTXml").Attributes["OutStanding"].Value);
            }
            ChkOutNEFT.DateNEFTMonth = Convert.ToInt32(doc.SelectSingleNode("NEFTXml").Attributes["DateNEFTMonth"].Value);
            ChkOutNEFT.DateNEFTYear = Convert.ToInt32(doc.SelectSingleNode("NEFTXml").Attributes["DateNEFTYear"].Value);
            ChkOutNEFT.Id = Convert.ToInt32(doc.SelectSingleNode("NEFTXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutNEFT.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentNEFT_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutNEFT.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentNEFT_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutNEFT.ChkOutHdrId;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutNEFT.Payment;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutNEFT.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutNEFT.Address;
            Cmd.Parameters.Add("@ReferenceNumber", SqlDbType.NVarChar).Value = ChkOutNEFT.ReferenceNumber;
            Cmd.Parameters.Add("@DateofNEFT", SqlDbType.NVarChar).Value = ChkOutNEFT.DateofNEFT;
            Cmd.Parameters.Add("@BankName", SqlDbType.NVarChar).Value = ChkOutNEFT.BankName;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutNEFT.AmountPaid;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutNEFT.PaymentMode;
            Cmd.Parameters.Add("@DateNEFTMonth", SqlDbType.Int).Value = ChkOutNEFT.DateNEFTMonth;
            Cmd.Parameters.Add("@DateNEFTYear", SqlDbType.Int).Value = ChkOutNEFT.DateNEFTYear;
            Cmd.Parameters.Add("@OutStanding", SqlDbType.NVarChar).Value = ChkOutNEFT.OutStanding;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
    }
}
