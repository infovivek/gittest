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
   public class PropertyRoomBedsDAO
   {
       String UserData;
       public DataSet Save(int RoomId, string PrtyRoomBeds, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           PropertyRoomBeds prptyRoomBed = new PropertyRoomBeds();
           XmlDocument document = new XmlDocument();
           document.LoadXml(PrtyRoomBeds);
            int n;
              n = (document).SelectNodes("//GridXml").Count;
              for (int i = 0; i < n; i++)
              {

                  prptyRoomBed.BedRackTarrif = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["BedRackTarrif"].Value);
                 // prptyRoomBed.RoomId = Convert.ToInt32(document.SelectSingleNode("//GridXml").Attributes["RoomId"].Value);
                  if (document.SelectNodes("//GridXml")[i].Attributes["DiscountAllowed"].Value == "")
                  {
                      prptyRoomBed.DiscountAllowed = 0;
                  }
                  else
                  {
                      prptyRoomBed.DiscountAllowed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DiscountAllowed"].Value);
                  }
                  prptyRoomBed.DiscountModePer = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["DiscountModePer"].Value);
                  prptyRoomBed.DiscountModeRS = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["DiscountModeRS"].Value);
                  if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                  {
                      prptyRoomBed.Id = 0;
                  }
                  else
                  {
                      prptyRoomBed.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                  }
                  command = new SqlCommand();
                  if (prptyRoomBed.Id != 0)
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyRoomBedsDAO Update" + ", ProcName:'" + StoredProcedures.PropertyRoomBeds_Update; 

                      command.CommandText = StoredProcedures.PropertyRoomBeds_Update;
                      command.Parameters.Add("@Id", SqlDbType.BigInt).Value = prptyRoomBed.Id;
                  }
                  else
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyRoomBedsDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyRoomBeds_Insert; 

                       command.CommandText = StoredProcedures.PropertyRoomBeds_Insert;
                  }
                  command.CommandType = CommandType.StoredProcedure;

                  command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = RoomId;

                  command.Parameters.Add("@DiscountAllowed", SqlDbType.Decimal).Value = prptyRoomBed.DiscountAllowed;
                  command.Parameters.Add("@BedRackTarrif", SqlDbType.Decimal).Value = prptyRoomBed.BedRackTarrif;
                  command.Parameters.Add("@DiscountModePer", SqlDbType.Bit).Value = prptyRoomBed.DiscountModePer;
                  command.Parameters.Add("@DiscountModeRS", SqlDbType.Bit).Value = prptyRoomBed.DiscountModeRS;
                 

                  command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

                  ds = new WrbErpConnection().ExecuteDataSet(command, UserData); 
              }
              return ds;
       }
       public DataSet Search(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PropertyRoomBedsDAO Select" + ", ProcName:'" + StoredProcedures.PropertyRoomBeds_Select; 

           SqlCommand command = new SqlCommand();
       //    command.CommandText = StoredProcedures.PropertyRoomBeds_Select;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@SelectId", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
           command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[3].ToString();
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Delete(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PropertyRoomBedsDAO Delete" + ", ProcName:'" + StoredProcedures.PropertyRooms_Delete; 

           SqlCommand command = new SqlCommand();
         //  command.CommandText = StoredProcedures.PropertyRooms_Delete;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[1].ToString();
           command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[2].ToString();
           command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Help(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PropertyRoomBedsDAO Help" + ", ProcName:'" + StoredProcedures.PropertyRoomBeds_Help; 

           SqlCommand command = new SqlCommand();
       //    command.CommandText = StoredProcedures.PropertyRoomBeds_Help;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
           command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
           command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[4].ToString();
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
   }
}
