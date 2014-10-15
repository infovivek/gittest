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
   public class SSPCodeGenerationServiceDAO
    {
       String UserData;
       public DataSet Save(string SSPCodeGenerationApartment, User user, int CodegenerationId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           XmlDocument document = new XmlDocument();
           SSPCodeGenerationServiceEntity SSPRM = new SSPCodeGenerationServiceEntity();
           document.LoadXml(SSPCodeGenerationApartment);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {



               SSPRM.Complimentary = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Complimentary"].Value);
               SSPRM.Enable = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Enable"].Value);
               SSPRM.ServiceName = document.SelectNodes("//GridXml")[i].Attributes["ServiceName"].Value;
               SSPRM.TypeService = document.SelectNodes("//GridXml")[i].Attributes["TypeService"].Value;
               
               if (document.SelectNodes("//GridXml")[i].Attributes["Price"].Value == "")
               {
                   SSPRM.Price = 0;
               }
               else
               {
                   SSPRM.Price = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Price"].Value);
               }

               if (document.SelectNodes("//GridXml")[i].Attributes["ProductId"].Value == "")
               {
                   SSPRM.ProductId = 0;
               }
               else
               {
                   SSPRM.ProductId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ProductId"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
               {
                   SSPRM.Id = 0;
               }
               else
               {
                   SSPRM.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               }
               command = new SqlCommand();
               if (SSPRM.Id != 0)
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:SSPCodeGenerationServiceDAO Update" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationServices_Update;

                   command.CommandText = StoredProcedures.SSPCodeGenerationServices_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = SSPRM.Id;
               }
               else
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service:SSPCodeGenerationServiceDAO Insert" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationServices_Insert;

                   command.CommandText = StoredProcedures.SSPCodeGenerationServices_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@SSPCodeGenerationId", SqlDbType.BigInt).Value = CodegenerationId;
               command.Parameters.Add("@ProductId", SqlDbType.BigInt).Value = SSPRM.ProductId;
               command.Parameters.Add("@Complimentary", SqlDbType.Bit).Value = SSPRM.Complimentary;
               command.Parameters.Add("@Enable", SqlDbType.Bit).Value = SSPRM.Enable;
               command.Parameters.Add("@ServiceName", SqlDbType.NVarChar).Value = SSPRM.ServiceName;
               command.Parameters.Add("@Price", SqlDbType.Decimal).Value = SSPRM.Price;
               command.Parameters.Add("@TypeService", SqlDbType.NVarChar).Value = SSPRM.TypeService;
               command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
               ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           }
           if (n == 0)
           {
               DataTable dTable1 = new DataTable("DBERRORTBL");
               dTable1.Columns.Add("Exception");
               ds.Tables.Add(dTable1);
           }
           return ds;

       }
    }
}
