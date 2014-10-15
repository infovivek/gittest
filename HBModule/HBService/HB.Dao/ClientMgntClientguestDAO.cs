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
    public class ClientMgntClientguestDAO
    {
        string UserData;
        public DataSet Save(String CltmgntRowId, Int32 CltmgntID, string Dtlval, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            document.LoadXml(Dtlval);
            ClientMgntClientguest ClientGust = new ClientMgntClientguest();
            int n;
            n = (document).SelectNodes("//ClientGuest").Count;
            for (int i = 0; i < n; i++)
            {
                ClientGust.EmpCode = document.SelectNodes("//ClientGuest")[i].Attributes["EmpCode"].Value;
                ClientGust.FirstName = document.SelectNodes("//ClientGuest")[i].Attributes["FirstName"].Value;
                ClientGust.LastName = document.SelectNodes("//ClientGuest")[i].Attributes["LastName"].Value;
                ClientGust.Grade = document.SelectNodes("//ClientGuest")[i].Attributes["Grade"].Value;
                ClientGust.MobileNo = document.SelectNodes("//ClientGuest")[i].Attributes["GMobileNo"].Value;
                ClientGust.EmailId = document.SelectNodes("//ClientGuest")[i].Attributes["EmailId"].Value;
                ClientGust.Designation = document.SelectNodes("//ClientGuest")[i].Attributes["Designation"].Value;
                ClientGust.RangeMax = 0;
                ClientGust.RangeMin = 0;
               /* if(document.SelectSingleNode("//ClientGuest").Attributes["RangeMax"].Value == "")
                {
                    ClientGust.RangeMax = 0;
                }
                else
                {
                    ClientGust.RangeMax = Convert.ToDecimal(document.SelectNodes("//ClientGuest")[i].Attributes["RangeMax"].Value);
                }
                if(document.SelectSingleNode("//ClientGuest").Attributes["RangeMin"].Value == "")
                {
                    ClientGust.RangeMin = 0;
                }
                else
                {
                    ClientGust.RangeMin = Convert.ToDecimal(document.SelectNodes("//ClientGuest")[i].Attributes["RangeMin"].Value);
                }*/
                if (document.SelectNodes("//ClientGuest")[i].Attributes["Id"].Value == "")
                {
                    ClientGust.Id = 0;
                }
                else
                {
                    ClientGust.Id = Convert.ToInt32(document.SelectNodes("//ClientGuest")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                ds = new DataSet();
                if (ClientGust.Id != 0)
                {
                    command.CommandText = StoredProcedures.ClientMgntClientguest_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ClientGust.Id;
                }
                else
                {
                     command.CommandText = StoredProcedures.ClientMgntClientguest_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CltmgntId", SqlDbType.BigInt).Value = CltmgntID;
                command.Parameters.Add("@CltmgntRowId", SqlDbType.NVarChar).Value = CltmgntRowId;
                command.Parameters.Add("@CompanyName", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@EmpCode", SqlDbType.NVarChar).Value = ClientGust.EmpCode;
                command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = ClientGust.FirstName;
                command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = ClientGust.LastName;
                command.Parameters.Add("@Grade", SqlDbType.NVarChar).Value = ClientGust.Grade;
                command.Parameters.Add("@GMobileNo", SqlDbType.NVarChar).Value = ClientGust.MobileNo;
                command.Parameters.Add("@EmailId", SqlDbType.NVarChar).Value = ClientGust.EmailId;
                command.Parameters.Add("@RangeMax", SqlDbType.Decimal).Value = ClientGust.RangeMax;
                command.Parameters.Add("@RangeMin", SqlDbType.Decimal).Value = ClientGust.RangeMin;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = User.Id;
                command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = ClientGust.Designation;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    return ds;
                }
            }
            if (n == 0)
            {
                DataTable ErrdT = new DataTable("DBERRORTBL");
                ds.Tables.Add(ErrdT);
            }
            return ds;
        }
    }
}