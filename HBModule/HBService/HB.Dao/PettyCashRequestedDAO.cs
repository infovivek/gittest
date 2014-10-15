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
    public class PettyCashRequestedDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            PettyCashRequested PCR = new PettyCashRequested();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data);
            PCR.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutHdrId"].Value);
            PCR.UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PayeeName"].Value);
            PCR.Property = doc.SelectSingleNode("HdrXml").Attributes["Address"].Value;
            PCR.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Consolidated"].Value);
            Cmd = new SqlCommand();
            if (PCR.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.PettyCashRequested_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = PCR.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.PettyCashRequested_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = PCR.PropertyId;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = PCR.UserId;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = PCR.Property;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PettyCashRequested_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}

 
