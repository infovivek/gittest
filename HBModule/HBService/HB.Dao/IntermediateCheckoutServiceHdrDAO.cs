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
    public class IntermediateCheckoutServiceHdrDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string Hdrval, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutServiceHdr ChkOutSer = new CheckOutServiceHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(Hdrval);
            ChkOutSer.CheckOutHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["CheckOutHdrId"].Value);
            if (doc.SelectSingleNode("HdrXml").Attributes["ChkOutServiceAmtl"].Value == "")
            {
                ChkOutSer.ChkOutServiceAmtl = 0;
            }
            else
            {
                ChkOutSer.ChkOutServiceAmtl = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ChkOutServiceAmtl"].Value);
            }

            if (doc.SelectSingleNode("HdrXml").Attributes["ChkOutserviceVat"].Value == "")
            {
                ChkOutSer.ChkOutServiceVat = 0;
            }
            else
            {
                ChkOutSer.ChkOutServiceVat = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ChkOutserviceVat"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["ChhkOutserviceST"].Value == "")
            {
                ChkOutSer.ChkOutServiceST = 0;
            }
            else
            {
                ChkOutSer.ChkOutServiceST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ChhkOutserviceST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                ChkOutSer.Cess = 0;
            }
            else
            {
                ChkOutSer.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
                ChkOutSer.HECess = 0;
            }
            else
            {
                ChkOutSer.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value == "")
            {
                ChkOutSer.NetAmount = 0;
            }
            else
            {
                ChkOutSer.NetAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["NetAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["MiscellaneousAmount"].Value == "")
            {
                ChkOutSer.MiscellaneousAmount = 0;
            }
            else
            {
                ChkOutSer.MiscellaneousAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["MiscellaneousAmount"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["OtherService"].Value == "")
            {
                ChkOutSer.OtherService = 0;
            }
            else
            {
                ChkOutSer.OtherService = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["OtherService"].Value);
            }

            ChkOutSer.MiscellaneousRemarks = doc.SelectSingleNode("HdrXml").Attributes["MiscellaneousRemarks"].Value;
            Cmd = new SqlCommand();
            if (ChkOutSer.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdrService_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutSer.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutHdrService_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@CheckOutHdrId", SqlDbType.Int).Value = ChkOutSer.CheckOutHdrId;
            Cmd.Parameters.Add("@ChkOutServiceAmtl", SqlDbType.Decimal).Value = ChkOutSer.ChkOutServiceAmtl;
            Cmd.Parameters.Add("@ChkOutServiceVat", SqlDbType.Decimal).Value = ChkOutSer.ChkOutServiceVat;
            Cmd.Parameters.Add("@ChkOutServiceLT", SqlDbType.Decimal).Value = 0;
            Cmd.Parameters.Add("@ChkOutServiceST", SqlDbType.Decimal).Value = ChkOutSer.ChkOutServiceST;
            Cmd.Parameters.Add("@Cess", SqlDbType.Decimal).Value = ChkOutSer.Cess;
            Cmd.Parameters.Add("@HECess", SqlDbType.Decimal).Value = ChkOutSer.HECess;
            Cmd.Parameters.Add("@CheckOutNetAmount", SqlDbType.Decimal).Value = ChkOutSer.NetAmount;
            Cmd.Parameters.Add("@MiscellaneousRemarks", SqlDbType.NVarChar).Value = ChkOutSer.MiscellaneousRemarks;
            Cmd.Parameters.Add("@MiscellaneousAmount", SqlDbType.Decimal).Value = ChkOutSer.MiscellaneousAmount;
            Cmd.Parameters.Add("@OtherService", SqlDbType.Decimal).Value = ChkOutSer.OtherService;
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
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.CheckOutHdrService_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@CheckInHdrId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
