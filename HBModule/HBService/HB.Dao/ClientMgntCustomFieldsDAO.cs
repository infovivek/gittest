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
   public class ClientMgntCustomFieldsDAO
   {
       string UserData;
       SqlCommand command = new SqlCommand();
       DataSet ds = new DataSet();
       public DataSet Save(String CltmgntRowId, Int32 CltmgntID, string Dtlval, User User)
       {
         //  UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           XmlDocument document = new XmlDocument();
           document.LoadXml(Dtlval);
           ClientMgntCustomFields NewCstFlds  = new ClientMgntCustomFields();  
           int n;
           n = (document).SelectNodes("//CustomFields").Count;
           for (int i = 0; i < n; i++)
           {
               NewCstFlds.FieldName = document.SelectNodes("//CustomFields")[i].Attributes["FieldName"].Value;
               NewCstFlds.FieldType = document.SelectNodes("//CustomFields")[i].Attributes["FieldType"].Value;
               if (document.SelectNodes("//CustomFields")[i].Attributes["Id"].Value == "")
               {
                   NewCstFlds.Id = 0;
               }
               else
               {
                   NewCstFlds.Id = Convert.ToInt32(document.SelectNodes("//CustomFields")[i].Attributes["Id"].Value);
               }
               command = new SqlCommand();
               ds = new DataSet();
               if (NewCstFlds.Id != 0)
               {
                   UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                    "', SctId:" + User.SctId + ", Service:ClientMgntCustomFields_Update" +
                     ", ProcName:'" + StoredProcedures.ClientMgntCustomFields_Update;

                   command.CommandText = StoredProcedures.ClientMgntCustomFields_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = NewCstFlds.Id;
               }
               else
               {
                   UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                    "', SctId:" + User.SctId + ", Service:ClientMgntCustomFields_Insert" +
                     ", ProcName:'" + StoredProcedures.ClientMgntCustomFields_Insert;

                   command.CommandText = StoredProcedures.ClientMgntCustomFields_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@CltmgntId", SqlDbType.BigInt).Value = CltmgntID;
               command.Parameters.Add("@CltmgntRowId", SqlDbType.NVarChar).Value = CltmgntRowId;
               command.Parameters.Add("@FieldName", SqlDbType.NVarChar).Value = NewCstFlds.FieldName;
               command.Parameters.Add("@FieldType", SqlDbType.NVarChar).Value = NewCstFlds.FieldType;
               command.Parameters.Add("@FieldValue", SqlDbType.NVarChar).Value = document.SelectNodes("//CustomFields")[i].Attributes["FieldValue"].Value;
               command.Parameters.Add("@Mandatory", SqlDbType.Bit).Value = Convert.ToBoolean(document.SelectNodes("//CustomFields")[i].Attributes["Mandatory"].Value);
               command.Parameters.Add("@Visible", SqlDbType.Bit).Value = Convert.ToBoolean(document.SelectNodes("//CustomFields")[i].Attributes["Visible"].Value);
               command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = User.Id;
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