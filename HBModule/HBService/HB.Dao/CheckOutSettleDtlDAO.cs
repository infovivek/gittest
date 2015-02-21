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
    public class CheckOutSettleDtlDAO
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string CheckOutSettleDtls, User user, int CheckOutSettleHdrId)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutSettleDtl ChkOutSetDtl = new CheckOutSettleDtl();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(CheckOutSettleDtls);
            int n;
            n = (doc).SelectNodes("//SettleXml").Count;
            for (int i = 0; i < n; i++)
            {
                ChkOutSetDtl.Id = Convert.ToInt32(doc.SelectNodes("//SettleXml")[i].Attributes["Id"].Value);
               // ChkOutSetDtl.PropertyId = Convert.ToInt32(doc.SelectNodes("//SettleXml")[i].Attributes["Id"].Value);
               // ChkOutSetDtl.GuestId = Convert.ToInt32(doc.SelectNodes("//SettleXml")[i].Attributes["Id"].Value);
                if (doc.SelectNodes("//SettleXml")[i].Attributes["BillNo"].Value == "")
                {
                    ChkOutSetDtl.BillNo = 0;
                }
                else
                {
                    ChkOutSetDtl.BillNo = Convert.ToInt32(doc.SelectNodes("//SettleXml")[i].Attributes["BillNo"].Value);
                }
                ChkOutSetDtl.BillType = doc.SelectNodes("//SettleXml")[i].Attributes["BillType"].Value;
                if (doc.SelectNodes("//SettleXml")[i].Attributes["Amount"].Value == "")
                {
                    ChkOutSetDtl.Amount = 0;
                }
                else
                {
                    ChkOutSetDtl.Amount = Convert.ToDecimal(doc.SelectNodes("//SettleXml")[i].Attributes["Amount"].Value);
                }
                if (doc.SelectNodes("//SettleXml")[i].Attributes["NetAmount"].Value == "")
                {
                    ChkOutSetDtl.NetAmount = 0;
                }
                else
                {
                    ChkOutSetDtl.NetAmount = Convert.ToDecimal(doc.SelectNodes("//SettleXml")[i].Attributes["NetAmount"].Value);
                }
                if (doc.SelectNodes("//SettleXml")[i].Attributes["OutStanding"].Value == "")
                {
                    ChkOutSetDtl.OutStanding = 0;
                }
                else
                {
                    ChkOutSetDtl.OutStanding = Convert.ToDecimal(doc.SelectNodes("//SettleXml")[i].Attributes["OutStanding"].Value);
                }
                ChkOutSetDtl.PaymentStatus = doc.SelectNodes("//SettleXml")[i].Attributes["PaymentStatus"].Value;
                
                command = new SqlCommand();
                if (ChkOutSetDtl.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:CheckOutHdrSettleDtl_Update" + ", ProcName:'" + StoredProcedures.CheckOutHdrSettleDtl_Update;

                    command.CommandText = StoredProcedures.CheckOutHdrSettleDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ChkOutSetDtl.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:CheckOutHdrSettleDtl_Insert" + ", ProcName:'" + StoredProcedures.CheckOutHdrSettleDtl_Insert;

                    command.CommandText = StoredProcedures.CheckOutHdrSettleDtl_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CheckOutSettleHdrId", SqlDbType.Int).Value = CheckOutSettleHdrId;
                command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = 0;
                command.Parameters.Add("@GuestId", SqlDbType.Int).Value =0;
                command.Parameters.Add("@BillNo", SqlDbType.Int).Value = ChkOutSetDtl.BillNo;
                command.Parameters.Add("@BillType", SqlDbType.NVarChar).Value = ChkOutSetDtl.BillType;
                command.Parameters.Add("@BillAmount", SqlDbType.Decimal).Value = ChkOutSetDtl.Amount;
                command.Parameters.Add("@NetAmount", SqlDbType.Decimal).Value = ChkOutSetDtl.NetAmount;
                command.Parameters.Add("@OutStanding", SqlDbType.Decimal).Value = ChkOutSetDtl.OutStanding;
                command.Parameters.Add("@PaymentStatus", SqlDbType.NVarChar).Value = ChkOutSetDtl.PaymentStatus;

                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            //if (n == 0)
            //{
            //    ds.Tables.Add(dTable);
            //}
            return ds;

        }
    }
}
