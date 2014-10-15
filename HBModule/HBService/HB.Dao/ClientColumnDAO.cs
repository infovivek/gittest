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
        String UserData;
         public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1]);

            ClientColumnEntity CC = new ClientColumnEntity();

            CC.ClientId = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["ClientId"].Value);
            if (document.SelectSingleNode("//HdrXml").Attributes["Column1"].Value == "")
            {
                CC.Column1 = "";
            }
            else
            {
                CC.Column1 = document.SelectSingleNode("//HdrXml").Attributes["Column1"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column2"].Value == "")
            {
                CC.Column2 = "";
            }
            else
            {
                CC.Column2 = document.SelectSingleNode("//HdrXml").Attributes["Column2"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column3"].Value == "")
            {
                CC.Column3 = "";
            }
            else
            {
                CC.Column3 = document.SelectSingleNode("//HdrXml").Attributes["Column3"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column4"].Value == "")
            {
                CC.Column4 = "";
            }
            else
            {
                CC.Column4 = document.SelectSingleNode("//HdrXml").Attributes["Column4"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column5"].Value == "")
            {
                CC.Column5 = "";
            }
            else
            {
                CC.Column5 = document.SelectSingleNode("//HdrXml").Attributes["Column5"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column6"].Value == "")
            {
                CC.Column6 = "";
            }
            else
            {
                CC.Column6 = document.SelectSingleNode("//HdrXml").Attributes["Column6"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column7"].Value == "")
            {
                CC.Column7 = "";
            }
            else
            {
                CC.Column7 = document.SelectSingleNode("//HdrXml").Attributes["Column7"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column8"].Value == "")
            {
                CC.Column8 = "";
            }
            else
            {
                CC.Column8 = document.SelectSingleNode("//HdrXml").Attributes["Column8"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column9"].Value == "")
            {
                CC.Column9 = "";
            }
            else
            {
                CC.Column9 = document.SelectSingleNode("//HdrXml").Attributes["Column9"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Column10"].Value == "")
            {
                CC.Column10 = "";
            }
            else
            {
                CC.Column10 = document.SelectSingleNode("//HdrXml").Attributes["Column10"].Value;
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["Id"].Value == "")
            {
                CC.Id = 0;
            }
            else
            {
                CC.Id =Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            }

            if (CC.Id == 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:AddUserDAO Insert" + ", ProcName:'" + StoredProcedures.AddUser_Insert;

                command.CommandText = StoredProcedures.ClientColumn_Insert;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:AddUserDAO Insert" + ", ProcName:'" + StoredProcedures.AddUser_Insert;

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
            command.Parameters.Add("CreatedBy", SqlDbType.BigInt).Value = user.Id;

            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                     "', SctId:" + user.SctId + ", Service:AddUserDAO Help" + ", ProcName:'" + StoredProcedures.AddUser_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ClientColumn_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
