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
    public class ClientColumnDAO
    {
        String UserData = "";
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();            
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1]);
            ClientColumnEntity CC = new ClientColumnEntity();
            CC.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
            CC.Column1 = document.SelectSingleNode("//HdrXml").Attributes["Column1"].Value;
            CC.Column2 = document.SelectSingleNode("//HdrXml").Attributes["Column2"].Value;
            CC.Column3 = document.SelectSingleNode("//HdrXml").Attributes["Column3"].Value;
            CC.Column4 = document.SelectSingleNode("//HdrXml").Attributes["Column4"].Value;
            CC.Column5 = document.SelectSingleNode("//HdrXml").Attributes["Column5"].Value;
            CC.Column6 = document.SelectSingleNode("//HdrXml").Attributes["Column6"].Value;
            CC.Column7 = document.SelectSingleNode("//HdrXml").Attributes["Column7"].Value;
            CC.Column8 = document.SelectSingleNode("//HdrXml").Attributes["Column8"].Value;
            CC.Column9 = document.SelectSingleNode("//HdrXml").Attributes["Column9"].Value;
            CC.Column10 = document.SelectSingleNode("//HdrXml").Attributes["Column10"].Value;
            CC.Column1Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column1Mandatory"].Value);
            CC.Column2Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column2Mandatory"].Value);
            CC.Column3Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column3Mandatory"].Value);
            CC.Column4Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column4Mandatory"].Value);
            CC.Column5Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column5Mandatory"].Value);
            CC.Column6Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column6Mandatory"].Value);
            CC.Column7Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column7Mandatory"].Value);
            CC.Column8Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column8Mandatory"].Value);
            CC.Column9Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column9Mandatory"].Value);
            CC.Column10Mandatory = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Column10Mandatory"].Value);
            CC.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            if (CC.Id == 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ClientColumnDAO Insert" + 
                    ", ProcName:'" + StoredProcedures.ClientColumn_Insert;
                command.CommandText = StoredProcedures.ClientColumn_Insert;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ClientColumnDAO Insert" +
                    ", ProcName:'" + StoredProcedures.ClientColumn_Update;
                command.CommandText = StoredProcedures.ClientColumn_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = CC.Id;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = CC.ClientId;
            command.Parameters.Add("@Column1", SqlDbType.NVarChar).Value = CC.Column1;
            command.Parameters.Add("@Column2", SqlDbType.NVarChar).Value = CC.Column2;
            command.Parameters.Add("@Column3", SqlDbType.NVarChar).Value = CC.Column3;
            command.Parameters.Add("@Column4", SqlDbType.NVarChar).Value = CC.Column4;
            command.Parameters.Add("@Column5", SqlDbType.NVarChar).Value = CC.Column5;
            command.Parameters.Add("@Column6", SqlDbType.NVarChar).Value = CC.Column6;
            command.Parameters.Add("@Column7", SqlDbType.NVarChar).Value = CC.Column7;
            command.Parameters.Add("@Column8", SqlDbType.NVarChar).Value = CC.Column8;
            command.Parameters.Add("@Column9", SqlDbType.NVarChar).Value = CC.Column9;
            command.Parameters.Add("@Column10", SqlDbType.NVarChar).Value = CC.Column10;
            command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = user.Id;
            command.Parameters.Add("@Column1Mandatory", SqlDbType.Bit).Value = CC.Column1Mandatory;
            command.Parameters.Add("@Column2Mandatory", SqlDbType.Bit).Value = CC.Column2Mandatory;
            command.Parameters.Add("@Column3Mandatory", SqlDbType.Bit).Value = CC.Column3Mandatory;
            command.Parameters.Add("@Column4Mandatory", SqlDbType.Bit).Value = CC.Column4Mandatory;
            command.Parameters.Add("@Column5Mandatory", SqlDbType.Bit).Value = CC.Column5Mandatory;
            command.Parameters.Add("@Column6Mandatory", SqlDbType.Bit).Value = CC.Column6Mandatory;
            command.Parameters.Add("@Column7Mandatory", SqlDbType.Bit).Value = CC.Column7Mandatory;
            command.Parameters.Add("@Column8Mandatory", SqlDbType.Bit).Value = CC.Column8Mandatory;
            command.Parameters.Add("@Column9Mandatory", SqlDbType.Bit).Value = CC.Column9Mandatory;
            command.Parameters.Add("@Column10Mandatory", SqlDbType.Bit).Value = CC.Column10Mandatory;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                     "', SctId:" + user.SctId + ", Service:ClientColumnDAO Help" +
                     ", ProcName:'" + StoredProcedures.ClientColumn_Help;
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ClientColumn_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
