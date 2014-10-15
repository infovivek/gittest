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
   public class PropertyAgreementDetailsDAO
    {
       String UserData;
       public DataSet Save(string Hdrval, User user, int AgreementId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("DBERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           PropertyAgreementDetails PrptyAgrementDtls = new PropertyAgreementDetails();
           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           
           for (int i = 0; i < n; i++)
           {

               PrptyAgrementDtls.EndDate = document.SelectNodes("//GridXml")[i].Attributes["EndDate"].Value;
               PrptyAgrementDtls.StartDate = document.SelectNodes("//GridXml")[i].Attributes["StartDate"].Value;
               PrptyAgrementDtls.Escalation = document.SelectNodes("//GridXml")[i].Attributes["Escalation"].Value;
               if (document.SelectNodes("//GridXml")[i].Attributes["Rental"].Value == "")
               {
                   PrptyAgrementDtls.Rental = 0;
               }
               else
               {
                   PrptyAgrementDtls.Rental = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Rental"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
               {
                   PrptyAgrementDtls.Id = 0;
               }
               else
               {
                   PrptyAgrementDtls.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               }
               command = new SqlCommand();
               if (PrptyAgrementDtls.Id != 0)
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:PropertyAgreementDetailsDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyAgreementDetails_Update; 

                   command.CommandText = StoredProcedures.PropertyAgreementDetails_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PrptyAgrementDtls.Id;
               }
               else
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:PropertyAgreementDetailsDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyAgreementDetails_Insert; 

                   command.CommandText = StoredProcedures.PropertyAgreementDetails_Insert;  
               }
               command.CommandType = CommandType.StoredProcedure;      
               command.Parameters.Add("@AgreementId", SqlDbType.NVarChar).Value = AgreementId;
               command.Parameters.Add("@Escalation", SqlDbType.NVarChar).Value = PrptyAgrementDtls.Escalation;
               command.Parameters.Add("@Rental", SqlDbType.NVarChar).Value = PrptyAgrementDtls.Rental;
               command.Parameters.Add("@EndDate", SqlDbType.NVarChar).Value = PrptyAgrementDtls.EndDate;
               command.Parameters.Add("@StartDate", SqlDbType.NVarChar).Value = PrptyAgrementDtls.StartDate;
               command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

               ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           }
           if (n == 0)
           {
               ds.Tables.Add(dTable);
           }
         
           return ds;
       }
    }
}
