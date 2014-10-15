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
    public class ReassignPropertyDtlDAO
    {
        string UserData;
        public DataSet Save(string[] Data, User User, int ReassignPropertyId)
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
            ReassignPropertyDtl Rpd = new ReassignPropertyDtl();
            //Rcd +=Id+","+, 
            int n;
            string dt = "";
            n = (document).SelectNodes("//PropertyXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//PropertyXml")[i].Attributes["Id"].Value == "")
                {
                    Rpd.Id = 0;
                }
                else
                {
                    Rpd.Id = Convert.ToInt32(document.SelectNodes("//PropertyXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//PropertyXml")[i].Attributes["UserId"].Value == "")
                {
                    Rpd.UserId = 0;
                }
                else
                {
                    Rpd.UserId = Convert.ToInt32(document.SelectNodes("//PropertyXml")[i].Attributes["UserId"].Value);
                }
                if (document.SelectNodes("//PropertyXml")[i].Attributes["checks"].Value == "0")
                {
                    Rpd.check = false;
                }
                else
                {
                    Rpd.check = Convert.ToBoolean(document.SelectNodes("//PropertyXml")[i].Attributes["checks"].Value);
                }
                if (document.SelectNodes("//PropertyXml")[i].Attributes["PropertyId"].Value == "")
                {
                    Rpd.PropertyId = 0;
                }
                else
                {
                    Rpd.PropertyId = Convert.ToInt32(document.SelectNodes("//PropertyXml")[i].Attributes["PropertyId"].Value);
                }
                dt = dt + Convert.ToString(Rpd.PropertyId) + ",";
                Rpd.RoleName = document.SelectNodes("//PropertyXml")[i].Attributes["RoleName"].Value;
                command = new SqlCommand();
                if (Rpd.Id != 0)
                {
                    UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:TIAandATIADAO Update" + ", ProcName:'" + StoredProcedures.ReassignPropertyDtl_Update; 

                    command.CommandText = StoredProcedures.ReassignPropertyDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = Rpd.Id;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ReassignPropertyHdrId", SqlDbType.BigInt).Value = ReassignPropertyId;
                command.Parameters.Add("@check", SqlDbType.Int).Value = Rpd.check;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = UserId;
                command.Parameters.Add("@ReassignId", SqlDbType.Int).Value = ReassignId;
                command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Rpd.PropertyId;
                command.Parameters.Add("@RoleName", SqlDbType.NVarChar).Value = Rpd.RoleName;
                command.Parameters.Add("@TranferDtlsId", SqlDbType.NVarChar).Value = dt;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command,UserData);

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
