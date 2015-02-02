using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Xml;
using System.Collections;
using HB.Entity;
namespace HB.Dao
{
   public class PropertyAgreementOwnerDAO
    {
       SqlCommand cmd = new SqlCommand();
       String UserData;
       public DataSet Save(string Hdrval, User user, int AgreementId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("DBERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           PropertyAgreementOwner PrptyAgrementOwner = new PropertyAgreementOwner();
           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {
               PrptyAgrementOwner.AgreementId = AgreementId;
               PrptyAgrementOwner.OwnerId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["OwnerId"].Value);
               PrptyAgrementOwner.OwnerName = document.SelectNodes("//GridXml")[i].Attributes["Owner"].Value;
               PrptyAgrementOwner.SplitPer = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SplitPer"].Value);
               PrptyAgrementOwner.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               
               command = new SqlCommand();
               if (PrptyAgrementOwner.Id != 0)
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:PropertyAgreementOwnerDAO Update" + ", ProcName:'" + StoredProcedures.PropertyAgreementOwner_Update; 

                   command.CommandText = StoredProcedures.PropertyAgreementOwner_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PrptyAgrementOwner.Id;
               }
               else
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                       "', SctId:" + user.SctId + ", Service:PropertyAgreementOwnerDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyAgreementOwner_Insert; 

                   command.CommandText = StoredProcedures.PropertyAgreementOwner_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@AgreementId", SqlDbType.BigInt).Value = PrptyAgrementOwner.AgreementId;
               command.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = PrptyAgrementOwner.OwnerId;
               command.Parameters.Add("@OwnerName", SqlDbType.NVarChar).Value = PrptyAgrementOwner.OwnerName;
               command.Parameters.Add("@SplitPer", SqlDbType.Decimal).Value = PrptyAgrementOwner.SplitPer;
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
