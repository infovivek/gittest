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
   public class SSPCodeGenerationApartmentDAO
    {
       String UserData;
       public DataSet Save(string SSPCodeGenerationApartment, User user, int CodegenerationId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           XmlDocument document = new XmlDocument();
           SSPCodeGenerationApartment SSPAP = new SSPCodeGenerationApartment();
           document.LoadXml(SSPCodeGenerationApartment);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {

               
              
               SSPAP.ApartmentNo = document.SelectNodes("//GridXml")[i].Attributes["ApartmentNo"].Value;
               SSPAP.ApartmentType = document.SelectNodes("//GridXml")[i].Attributes["Type"].Value;
               if (document.SelectNodes("//GridXml")[i].Attributes["ApartmentId"].Value == "")
               {
                   SSPAP.ApartmentId = 0;
               }
               else
               {
                   SSPAP.ApartmentId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ApartmentId"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value == "")
               {
                   SSPAP.SingleTariff = 0;
               }
               else
               {
                   SSPAP.SingleTariff =Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value == "")
               {
                   SSPAP.DoubleTariff = 0;
               }
               else
               {
                   SSPAP.DoubleTariff =Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
               {
                   SSPAP.Id = 0;
               }
               else
               {
                   SSPAP.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               }
               command = new SqlCommand();
               if (SSPAP.Id != 0)
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:SSPCodeGenerationApartmentDAO Update" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationApartment_Update;

                   command.CommandText = StoredProcedures.SSPCodeGenerationApartment_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = SSPAP.Id;
               }
               else
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:SSPCodeGenerationApartmentDAO Insert" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationApartment_Insert;

                   command.CommandText = StoredProcedures.SSPCodeGenerationApartment_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@SSPCodeGenerationId", SqlDbType.BigInt).Value = CodegenerationId;
               command.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value = SSPAP.ApartmentNo;
               command.Parameters.Add("@ApartmentType", SqlDbType.NVarChar).Value = SSPAP.ApartmentType;
               command.Parameters.Add("@SingleTariff", SqlDbType.Decimal ).Value = SSPAP.SingleTariff;
               command.Parameters.Add("@DoubleTariff", SqlDbType.Decimal).Value = SSPAP.DoubleTariff;
               command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = SSPAP.ApartmentId;
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
