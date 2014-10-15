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
   public class PropertyRoomDAO
    {
       String UserData;
       public DataSet Save(string Hdrval, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
           PropertyRoom prptyRoom = new PropertyRoom();
            int n;
            n = (document).SelectNodes("//HdrXml").Count;
              for (int i = 0; i < n; i++)
              {

                  prptyRoom.BlockId = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["BlockId"].Value);
                  prptyRoom.PropertyId = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["PropertyId"].Value);
                  //prptyRoom.BlockName = document.SelectNodes("//HdrXml")[i].Attributes["BlockName"].Value;
                  // prptyRoom.ApartmentNo = document.SelectNodes("//HdrXml")[i].Attributes["ApartmentNo"].Value;
                  prptyRoom.ApartmentId = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["ApartmentId"].Value);
                  prptyRoom.RoomType = document.SelectNodes("//HdrXml")[i].Attributes["RoomType"].Value;
                  prptyRoom.RoomNo = document.SelectNodes("//HdrXml")[i].Attributes["RoomNo"].Value;
                  prptyRoom.RoomStatus = document.SelectNodes("//HdrXml")[i].Attributes["RoomStatus"].Value;
                  if (document.SelectNodes("//HdrXml")[i].Attributes["RackTariff"].Value == "")
                  {
                      prptyRoom.RackTariff = 0;
                  }
                  else
                  {
                      prptyRoom.RackTariff = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["RackTariff"].Value);
                  }
                  if (document.SelectNodes("//HdrXml")[i].Attributes["DoubleOccupancyTariff"].Value == "")
                  {
                      prptyRoom.DoubleOccupancyTariff = 0;
                  }
                  else
                  {
                      prptyRoom.DoubleOccupancyTariff = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["DoubleOccupancyTariff"].Value);
                  }
                  prptyRoom.RoomCategory = document.SelectNodes("//HdrXml")[i].Attributes["RoomCategory"].Value;
                  prptyRoom.DiscountModePer = Convert.ToBoolean(document.SelectNodes("//HdrXml")[i].Attributes["DiscountModePer"].Value);
                  prptyRoom.DiscountModeRS = Convert.ToBoolean(document.SelectNodes("//HdrXml")[i].Attributes["DiscountModeRS"].Value);
                  if (document.SelectNodes("//HdrXml")[i].Attributes["DiscountAllowed"].Value == "")
                  {
                      prptyRoom.DiscountAllowed = 0;
                  }
                  else
                  {
                      prptyRoom.DiscountAllowed = Convert.ToDecimal(document.SelectNodes("//HdrXml")[i].Attributes["DiscountAllowed"].Value);
                  }
                  prptyRoom.Id = Convert.ToInt32(document.SelectNodes("//HdrXml")[i].Attributes["Id"].Value);
                  command = new SqlCommand();
                  if (prptyRoom.Id != 0)
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyRoomDAO Update" + ", ProcName:'" + StoredProcedures.PropertyRooms_Update; 

                      command.CommandText = StoredProcedures.PropertyRooms_Update;
                      command.Parameters.Add("@Id", SqlDbType.BigInt).Value = prptyRoom.Id;
                  }
                  else
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyRoomDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyRooms_Insert; 

                      command.CommandText = StoredProcedures.PropertyRooms_Insert;
                  }
                  command.CommandType = CommandType.StoredProcedure;

                  command.Parameters.Add("@BlockId", SqlDbType.BigInt).Value = prptyRoom.BlockId;
                  command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = prptyRoom.PropertyId;
                  //   command.Parameters.Add("@BlockName", SqlDbType.NVarChar).Value = prptyRoom.BlockName;
                  //  command.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value = prptyRoom.ApartmentNo;
                  command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = prptyRoom.ApartmentId;
                  command.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = prptyRoom.RoomType;
                  command.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = prptyRoom.RoomNo;
                  command.Parameters.Add("@RackTariff", SqlDbType.Decimal).Value = prptyRoom.RackTariff;
                  command.Parameters.Add("@DoubleOccupancyTariff", SqlDbType.Decimal).Value = prptyRoom.DoubleOccupancyTariff;
                  command.Parameters.Add("@RoomCategory", SqlDbType.NVarChar).Value = prptyRoom.RoomCategory;
                  command.Parameters.Add("@DiscountModePer", SqlDbType.Bit).Value = prptyRoom.DiscountModePer;
                  command.Parameters.Add("@DiscountModeRS", SqlDbType.Bit).Value = prptyRoom.DiscountModeRS;
                  command.Parameters.Add("@DiscountAllowed", SqlDbType.Decimal).Value = prptyRoom.DiscountAllowed;
                  command.Parameters.Add("@RoomStatus", SqlDbType.NVarChar).Value = prptyRoom.RoomStatus;                  
                  command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                  ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
              }

           return ds;

       }
       public DataSet Search(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PropertyRoomDAO Select" + ", ProcName:'" + StoredProcedures.PropertyRooms_Select; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyRooms_Select;
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
              "', SctId:" + user.SctId + ", Service:PropertyRoomDAO Delete" + ", ProcName:'" + StoredProcedures.PropertyRoomBeds_Delete; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyRoomBeds_Delete;
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
           "', SctId:" + user.SctId + ", Service:PropertyRoomDAO Help" + ", ProcName:'" + StoredProcedures.PropertyRooms_Help; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyRooms_Help;
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
