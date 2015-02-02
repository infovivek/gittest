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
    public class VendorChequeApprovalHdrDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            VendorChequeApprovalHdr VCR = new VendorChequeApprovalHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data);
            VCR.UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            VCR.UserName = doc.SelectSingleNode("HdrXml").Attributes["UserName"].Value;
            VCR.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (VCR.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:VendorChequeApprovalHdrDAO Update" + ", ProcName:'" + StoredProcedures.VendorChequeApprovalHdr_Update;
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.VendorChequeApprovalHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = VCR.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:VendorChequeApprovalHdrDAO Insert" + ", ProcName:'" + StoredProcedures.VendorChequeApprovalHdr_Insert;
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.VendorChequeApprovalHdr_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = VCR.UserId;
            Cmd.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = VCR.UserName;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashApprovalHdrDAO " + ", Nil:'";

            SqlCommand command = new SqlCommand();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:VendorChequeApprovalHdr Help" + ", ProcName:'" + StoredProcedures.VendorChequeApprovalHdr_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.VendorChequeApprovalHdr_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@CreatedById", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[4].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
