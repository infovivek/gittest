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
    public class TDSDeclarationDAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            TDSDeclarationEntity TDSD = new TDSDeclarationEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(data[1].ToString());
            SqlCommand command = new SqlCommand();

            TDSD.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            TDSD.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            TDSD.OwnerId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["OwnerId"].Value);
            TDSD.PanNo = doc.SelectSingleNode("HdrXml").Attributes["PanNo"].Value;
            TDSD.TDSPercentage = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["TDSPercentage"].Value);
            TDSD.Date = doc.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            TDSD.FinancialYear = doc.SelectSingleNode("HdrXml").Attributes["FinancialYear"].Value;
            TDSD.Image = doc.SelectSingleNode("HdrXml").Attributes["Image"].Value;

            if (TDSD.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO Update" + ", ProcName:'" + StoredProcedures.TDS_Update;

                 command.CommandText = StoredProcedures.TDS_Update;
                 command.Parameters.Add("@Id", SqlDbType.Int).Value = TDSD.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO save" + ", ProcName:'" + StoredProcedures.TDS_Insert;

                command.CommandText = StoredProcedures.TDS_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = TDSD.PropertyId;
            command.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = TDSD.OwnerId;
            command.Parameters.Add("@PanNo", SqlDbType.NVarChar).Value = TDSD.PanNo;
            command.Parameters.Add("@TDSPercentage", SqlDbType.Int).Value = TDSD.TDSPercentage;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = TDSD.Date;
            command.Parameters.Add("@FinancialYear", SqlDbType.NVarChar).Value = TDSD.FinancialYear;
            command.Parameters.Add("@Image", SqlDbType.NVarChar).Value = TDSD.Image;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO Search" + ", ProcName:'" + StoredProcedures.TDS_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TDS_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Delete(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO Delete" + ", ProcName:'" + StoredProcedures.TDS_Delete;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TDS_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:TDSDeclarationDAO Help" + ", ProcName:'" + StoredProcedures.TDS_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TDS_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
