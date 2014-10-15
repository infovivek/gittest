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
   public class SSPCodeGenerationRoomsDAO
    {
       String UserData;
       public DataSet Save(string SSPCodeGenerationApartment, User user, int CodegenerationId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           XmlDocument document = new XmlDocument();
           SSPCodeGenerationRooms SSPRM = new SSPCodeGenerationRooms();
           document.LoadXml(SSPCodeGenerationApartment);
           int n;
           n = (document).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {



               SSPRM.RoomNo = document.SelectNodes("//GridXml")[i].Attributes["RoomNo"].Value;

               if (document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value == "")
               {
                   SSPRM.RoomId = 0;
               }
               else
               {
                   SSPRM.RoomId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value == "")
               {
                   SSPRM.SingleTariff = 0;
               }
               else
               {
                   SSPRM.SingleTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SingleTariff"].Value);
               }
               if (document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value == "")
               {
                   SSPRM.DoubleTariff = 0;
               }
               else
               {
                   SSPRM.DoubleTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DoubleTariff"].Value);
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
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationRoomsDAO Update" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationRooms_Update;

                   command.CommandText = StoredProcedures.SSPCodeGenerationRooms_Update;
                   command.Parameters.Add("@Id", SqlDbType.BigInt).Value = SSPRM.Id;
               }
               else
               {
                   UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                  "', SctId:" + user.SctId + ", Service:SSPCodeGenerationRoomsDAO Insert" + ", ProcName:'" + StoredProcedures.SSPCodeGenerationRooms_Insert;

                   command.CommandText = StoredProcedures.SSPCodeGenerationRooms_Insert;
               }
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@SSPCodeGenerationId", SqlDbType.BigInt).Value = CodegenerationId;
               command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = SSPRM.RoomId;
               command.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = SSPRM.RoomNo;
               command.Parameters.Add("@SingleTariff", SqlDbType.Decimal).Value = SSPRM.SingleTariff;
               command.Parameters.Add("@DoubleTariff", SqlDbType.Decimal).Value = SSPRM.DoubleTariff;          
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
