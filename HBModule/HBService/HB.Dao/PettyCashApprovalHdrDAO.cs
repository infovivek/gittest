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
    public class PettyCashApprovalHdrDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            PettyCashApprovalHdr PCR = new PettyCashApprovalHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data);
            PCR.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            PCR.UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);
            PCR.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            PCR.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (PCR.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PettyCashApprovalHdrDAO Update" + ", ProcName:'" + StoredProcedures.PettyCashApprovalHdr_Update; 
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.PettyCashApprovalHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = PCR.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PettyCashApprovalHdrDAO Insert" + ", ProcName:'" + StoredProcedures.PettyCashApprovalHdr_Insert; 
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.PettyCashApprovalHdr_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = PCR.PropertyId;
            Cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = PCR.UserId;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = PCR.Property;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashApprovalHdrDAO " + ", Nil:'"; 

            SqlCommand command = new SqlCommand();
            return new WrbErpConnection().ExecuteDataSet(command,UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashApprovalHdrDAO Help" + ", ProcName:'" + StoredProcedures.PettyCashApprovalHdr_Help;
 
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PettyCashApprovalHdr_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[5].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}

 
