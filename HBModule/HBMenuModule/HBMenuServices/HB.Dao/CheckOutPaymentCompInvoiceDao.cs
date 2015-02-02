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
    public class CheckOutPaymentCompInvoiceDao
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutPaymentCompInvoice ChkOutCmpIn = new CheckOutPaymentCompInvoice();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutCmpIn.ChkOutHdrId = Convert.ToInt32(doc.SelectSingleNode("CmpInXml").Attributes["ChkOutHdrId"].Value);
            ChkOutCmpIn.Payment = doc.SelectSingleNode("CmpInXml").Attributes["Payment"].Value;
            ChkOutCmpIn.PayeeName = doc.SelectSingleNode("CmpInXml").Attributes["PayeeName"].Value;
            ChkOutCmpIn.Address = doc.SelectSingleNode("CmpInXml").Attributes["Address"].Value;
            if (doc.SelectSingleNode("CmpInXml").Attributes["AmountPaid"].Value == "")
            {
                ChkOutCmpIn.AmountPaid = 0;
            }
            else
            {
                ChkOutCmpIn.AmountPaid = Convert.ToDecimal(doc.SelectSingleNode("CmpInXml").Attributes["AmountPaid"].Value);
            }
            if (doc.SelectSingleNode("CmpInXml").Attributes["OutStanding"].Value == "")
            {
                ChkOutCmpIn.OutStanding = 0;
            }
            else
            {
                ChkOutCmpIn.OutStanding = Convert.ToDecimal(doc.SelectSingleNode("CmpInXml").Attributes["OutStanding"].Value);
            }
            ChkOutCmpIn.PaymentMode = doc.SelectSingleNode("CmpInXml").Attributes["PaymentMode"].Value;
            ChkOutCmpIn.Approver = doc.SelectSingleNode("CmpInXml").Attributes["Approver"].Value;
            ChkOutCmpIn.Requester = doc.SelectSingleNode("CmpInXml").Attributes["Requester"].Value;
            ChkOutCmpIn.EmailId = doc.SelectSingleNode("CmpInXml").Attributes["EmailId"].Value;
            ChkOutCmpIn.PhoneNo = doc.SelectSingleNode("CmpInXml").Attributes["PhoneNo"].Value;
            ChkOutCmpIn.FileLoad = doc.SelectSingleNode("CmpInXml").Attributes["FileLoad"].Value;
            ChkOutCmpIn.Id = Convert.ToInt32(doc.SelectSingleNode("CmpInXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutCmpIn.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCompanyInvoice_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutCmpIn.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutPaymentCompanyInvoice_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutCmpIn.ChkOutHdrId;
            Cmd.Parameters.Add("@Payment", SqlDbType.NVarChar).Value = ChkOutCmpIn.Payment;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutCmpIn.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutCmpIn.Address;
            Cmd.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = ChkOutCmpIn.AmountPaid;
            Cmd.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = ChkOutCmpIn.PaymentMode;
            Cmd.Parameters.Add("@Approver", SqlDbType.NVarChar).Value = ChkOutCmpIn.Approver;
            Cmd.Parameters.Add("@Requester", SqlDbType.NVarChar).Value = ChkOutCmpIn.Requester;
            Cmd.Parameters.Add("@EmailId", SqlDbType.NVarChar).Value = ChkOutCmpIn.EmailId;
            Cmd.Parameters.Add("@PhoneNo", SqlDbType.NVarChar).Value = ChkOutCmpIn.PhoneNo;
            Cmd.Parameters.Add("@FileLoad", SqlDbType.NVarChar).Value = ChkOutCmpIn.FileLoad;
            Cmd.Parameters.Add("@OutStanding", SqlDbType.NVarChar).Value = ChkOutCmpIn.OutStanding;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
    }
}
