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
    public class CheckOutTariffDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(String[] data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutTariff ChkOutT = new CheckOutTariff();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);
           
            ChkOutT.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (ChkOutT.Id != 0)
            {
                Mode = "Update";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = ChkOutT.Id;
            }
            else
            {
                Mode = "Save";
                Cmd.CommandText = StoredProcedures.CheckOutHdr_Insert;

            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkOutHdrId", SqlDbType.Int).Value = ChkOutT.CheckOutHdrId;
            
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(Cmd, "");
            return ds;
        }
    }
}
