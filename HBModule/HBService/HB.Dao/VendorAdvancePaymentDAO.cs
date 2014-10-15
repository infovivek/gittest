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
   public class VendorAdvancePaymentDAO
    {
        String UserData;
        public DataSet Save(string[] AdvancePay, User user)
        {


            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(AdvancePay[1].ToString());

            //Header Insert
            VendorAdvancePaymentEntity VendorADPAY = new VendorAdvancePaymentEntity();
            VendorADPAY.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            if (document.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value == "")
            {
                VendorADPAY.AdvanceAmount = 0;
            }
            else
            {
                VendorADPAY.AdvanceAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value);
            }
            VendorADPAY.PropertyName = document.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            VendorADPAY.DateofPayment = document.SelectSingleNode("HdrXml").Attributes["DateofPayment"].Value;
            VendorADPAY.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;
            VendorADPAY.BankName = document.SelectSingleNode("HdrXml").Attributes["BankName"].Value;
            VendorADPAY.ChequeNumber = document.SelectSingleNode("HdrXml").Attributes["ChequeNumber"].Value;
            VendorADPAY.IssueDate = document.SelectSingleNode("HdrXml").Attributes["Issuedate"].Value;
            VendorADPAY.PaymentMode = document.SelectSingleNode("HdrXml").Attributes["PaymentMode"].Value;
            VendorADPAY.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);


            if (VendorADPAY.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:VendorAdvancePayment DAO Update" + ", ProcName:'" + StoredProcedures.VendorAdvancePayment_Update;

                command.CommandText = StoredProcedures.VendorAdvancePayment_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = VendorADPAY.Id;

            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:VendorAdvancePayment DAO Insert" + ", ProcName:'" + StoredProcedures.VendorAdvancePayment_Insert;

                command.CommandText = StoredProcedures.VendorAdvancePayment_Insert;
            }           
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = VendorADPAY.PropertyId;
            command.Parameters.Add("@AdvanceAmount", SqlDbType.Decimal).Value = VendorADPAY.AdvanceAmount;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = VendorADPAY.PropertyName;
            command.Parameters.Add("@DateofPayment", SqlDbType.NVarChar).Value = VendorADPAY.DateofPayment;
            command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = VendorADPAY.Comments;
            command.Parameters.Add("@BankName", SqlDbType.NVarChar).Value = VendorADPAY.BankName;
            command.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = VendorADPAY.ChequeNumber;
            command.Parameters.Add("@IssueDate", SqlDbType.NVarChar).Value = VendorADPAY.IssueDate;
            command.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = VendorADPAY.PaymentMode;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            return ds;
        }
        public DataSet Search(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            SqlCommand Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.VendorAdvancePayment_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@SelectId", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            Cmd.Parameters.Add("@Pram1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Pram2", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            Cmd.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(User.Id);            
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
