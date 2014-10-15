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
    public class CheckOutSettleHdrDAO
    {
 string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutSettleHdr ChkOutSet = new CheckOutSettleHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutSet.CheckOutHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutHdrId"].Value);
            ChkOutSet.PayeeName = doc.SelectSingleNode("HdrXml").Attributes["PayeeName"].Value;
            ChkOutSet.Address = doc.SelectSingleNode("HdrXml").Attributes["Address"].Value;
            ChkOutSet.Consolidated = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["Consolidated"].Value);
          
            Cmd = new SqlCommand();
            if (ChkOutSet.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdrSettleHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutSet.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutHdrSettleHdr_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutSet.CheckOutHdrId;
            Cmd.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = ChkOutSet.PayeeName;
            Cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = ChkOutSet.Address;
            Cmd.Parameters.Add("@Consolidated", SqlDbType.Bit).Value =ChkOutSet.Consolidated;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
        public DataSet Search(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            //Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.CheckOut_Select;
            //Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
        public DataSet HelpResult(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            //Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.CheckOutHdrService_Help;
            //Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            //Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            //Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            //Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
    
