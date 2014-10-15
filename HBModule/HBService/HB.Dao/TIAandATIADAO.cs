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
    public class TIAandATIADAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            TIAandATIAEntity TIA = new TIAandATIAEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(data[1].ToString());
            SqlCommand command = new SqlCommand();

            TIA.Id =Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            TIA.PropertyId=Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            TIA.OwnerId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["OwnerId"].Value);
            TIA.AdjustmentCategory = doc.SelectSingleNode("HdrXml").Attributes["AdjustmentCategory"].Value;
            TIA.AdjustmentAmount = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["AdjustmentAmount"].Value);
            TIA.AdjustmentMonth = doc.SelectSingleNode("HdrXml").Attributes["AdjustmentMonth"].Value;
            TIA.AdjustmentType = doc.SelectSingleNode("HdrXml").Attributes["AdjustmentType"].Value;
            TIA.Description = doc.SelectSingleNode("HdrXml").Attributes["Description"].Value;
            TIA.Flag = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Flag"].Value);

            if (TIA.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TIAandATIADAO Update" + ", ProcName:'" + StoredProcedures.TIA_Update; 

                command.CommandText = StoredProcedures.TIA_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = TIA.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TIAandATIADAO Insert" + ", ProcName:'" + StoredProcedures.TIA_Insert; 

                command.CommandText = StoredProcedures.TIA_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = TIA.PropertyId;
            command.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = TIA.OwnerId;
            command.Parameters.Add("@AdjustmentCategory", SqlDbType.NVarChar).Value = TIA.AdjustmentCategory;
            command.Parameters.Add("@AdjustmentAmount", SqlDbType.BigInt).Value = TIA.AdjustmentAmount;
            command.Parameters.Add("@AdjustmentMonth", SqlDbType.NVarChar).Value = TIA.AdjustmentMonth;
            command.Parameters.Add("@AdjustmentType", SqlDbType.NVarChar).Value = TIA.AdjustmentType;
            command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = TIA.Description;
            command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            command.Parameters.Add("@Flag", SqlDbType.Int).Value = TIA.Flag;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TIAandATIADAO Select" + ", ProcName:'" + StoredProcedures.TIA_Select; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TIA_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Delete(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TIAandATIADAO Delete" + ", ProcName:'" + StoredProcedures.TIA_Delete; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TIA_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:TIAandATIADAO Help" + ", ProcName:'" + StoredProcedures.TIA_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TIA_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
