using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Xml;
using System.Collections;


namespace HB.Dao
{
    public class ReassignClientDtlDAO
    {
        String UserData;
        public DataSet Save(string[] Data, User User, int ReassignClientId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument doc = new XmlDocument();

            int ReassignId, UserId;
            doc.LoadXml(Data[1].ToString());

            ReassignId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ReassignId"].Value);
            UserId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["UserId"].Value);


            XmlDocument document = new XmlDocument();
            document.LoadXml(Data[2].ToString());
            ReassignClientDtl Rcd = new ReassignClientDtl();
            //var dt = Rcd.Id +',';
            int n;
            string dt = "";
            n = (document).SelectNodes("//ClientXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//ClientXml")[i].Attributes["Id"].Value == "")
                {
                    Rcd.Id = 0;
                }
                else
                {
                    Rcd.Id = Convert.ToInt32(document.SelectNodes("//ClientXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["checks"].Value == "0")
                {
                    Rcd.check = false;
                }
                else
                {
                    Rcd.check = Convert.ToBoolean(document.SelectNodes("//ClientXml")[i].Attributes["checks"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["SelectId"].Value == "")
                {
                    Rcd.SelectId = 0;
                }
                else
                {
                    Rcd.SelectId = Convert.ToInt32(document.SelectNodes("//ClientXml")[i].Attributes["SelectId"].Value);
                } 
                dt  = dt + Convert.ToString(Rcd.Id) + ","; 
                Rcd.RoleName = document.SelectNodes("//ClientXml")[i].Attributes["RoleName"].Value;
                command = new SqlCommand();
                if (Rcd.Id != 0)
                {
                    UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
      "', SctId:" + User.SctId + ", Service:ReassignClientDtlDAO Update" + ", ProcName:'" + StoredProcedures.ReassignClientDtl_Update; 

                    command.CommandText = StoredProcedures.ReassignClientDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = Rcd.Id;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ReassignClientHdrId", SqlDbType.BigInt).Value = ReassignClientId;
                command.Parameters.Add("@check", SqlDbType.Int).Value = Rcd.check;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = UserId;
                command.Parameters.Add("@ReassignId", SqlDbType.Int).Value = ReassignId;
                command.Parameters.Add("@SelectId", SqlDbType.Int).Value =Rcd.SelectId;
                command.Parameters.Add("@RoleName", SqlDbType.NVarChar).Value = Rcd.RoleName;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
                command.Parameters.Add("@TranferDtlsId", SqlDbType.NVarChar).Value = dt;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                //return Value;
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }

            return ds;
        }
    }
}
