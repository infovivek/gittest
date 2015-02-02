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
    public class PropertyDAO
    {
        string UserData;
        public DataSet Save(string data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            //UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName +
            //  ",ScreenName:'" + user.ScreenName + "',SctId:" + user.SctId + ",BranchId" + user.BranchId +
            //",KitchenName:'" + user.KitchenName + "',KitchenId " + user.KitchenId + " ";
            //document.LoadXml(data);

            PropertyEntity property = new PropertyEntity();
            XmlDocument document = new XmlDocument();
            document.LoadXml(data);
            property.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            property.PropertyName = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
            property.Code = document.SelectSingleNode("HdrXml").Attributes["Code"].Value;
            property.Category = document.SelectSingleNode("HdrXml").Attributes["Category"].Value;
            property.PropertDescription = document.SelectSingleNode("HdrXml").Attributes["PropertDescription"].Value;
            property.Prefix = document.SelectSingleNode("HdrXml").Attributes["Prefix"].Value;
            property.Propertaddress = document.SelectSingleNode("HdrXml").Attributes["Propertaddress"].Value;
            property.BookingPolicy = document.SelectSingleNode("HdrXml").Attributes["BookingPolicy"].Value;
            property.CancelPolicy = document.SelectSingleNode("HdrXml").Attributes["CancelPolicy"].Value;
            property.Localityarea = document.SelectSingleNode("HdrXml").Attributes["Localityarea"].Value;

            property.Postal = document.SelectSingleNode("HdrXml").Attributes["Postal"].Value;
            property.Phone = document.SelectSingleNode("HdrXml").Attributes["Phone"].Value;
            property.Directions = document.SelectSingleNode("HdrXml").Attributes["Directions"].Value;
            property.Keyword = document.SelectSingleNode("HdrXml").Attributes["Keyword"].Value;
            property.ServicesSwimPool = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesSwimPool"].Value);
            property.ServicesPub = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesPub"].Value);
            property.ServicesGym = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesGym"].Value);
            property.ServicesRestaurant = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesRestaurant"].Value);
            property.ServicesConfHall = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesConfHall"].Value);
            property.ServicesCyberCafe = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesCyberCafe"].Value);
            property.ServicesLaundry = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ServicesLaundry"].Value);
            property.ShowOnWebsite = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["ShowOnWebsite"].Value);
            property.LatitudeLongitude = document.SelectSingleNode("HdrXml").Attributes["LatitudeLongitude"].Value;
            property.Date = document.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            property.LocalityId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["LocalityId"].Value);
            property.StateId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            property.CityId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CityId"].Value);
            property.TotalNoRooms = document.SelectSingleNode("HdrXml").Attributes["TotalNoRooms"].Value;
            property.Email = document.SelectSingleNode("HdrXml").Attributes["Email"].Value;
            property.CheckIn = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CheckIn"].Value);
            property.CheckInType = document.SelectSingleNode("HdrXml").Attributes["CheckInType"].Value;
            property.CheckOut = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["CheckOut"].Value);
            property.CheckOutType = document.SelectSingleNode("HdrXml").Attributes["CheckOutType"].Value;
            property.GraceTime = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["GraceTime"].Value);

            property.PropertyType = document.SelectSingleNode("HdrXml").Attributes["Type"].Value;
           // property.Copy = document.SelectSingleNode("HdrXml").Attributes["CopyFlag"].Value;
           // property.CopyId =Convert.ToInt32( document.SelectSingleNode("HdrXml").Attributes["CopyId"].Value);
            if (document.SelectSingleNode("HdrXml").Attributes["PropertyRackTarrif"].Value == "")
            {
                property.PropertyRackTarrif = 0;
            }
            else
            {
                property.PropertyRackTarrif = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["PropertyRackTarrif"].Value);
            }
            if (document.SelectSingleNode("HdrXml").Attributes["RackTarrifDouble"].Value == "")
            {
                property.RackTarrifDouble = 0;
            }
            else
            {
                property.RackTarrifDouble = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["RackTarrifDouble"].Value);
            }
            if (property.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PropertyDAO Update" + ", ProcName:'" + StoredProcedures.Property_Update; 

                command.CommandText = StoredProcedures.Property_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = property.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PropertyDAO Insert" + ", ProcName:'" + StoredProcedures.Property_Insert; 

                command.CommandText = StoredProcedures.Property_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = property.PropertyName;
            command.Parameters.Add("@Code", SqlDbType.NVarChar).Value = property.Code;
            command.Parameters.Add("@Category", SqlDbType.NVarChar).Value = property.Category;
            command.Parameters.Add("@PropertDescription", SqlDbType.NVarChar).Value = property.PropertDescription;
            command.Parameters.Add("@Prefix", SqlDbType.NVarChar).Value = property.Prefix;
            command.Parameters.Add("@Propertaddress", SqlDbType.NVarChar).Value = property.Propertaddress;
            command.Parameters.Add("@City", SqlDbType.NVarChar).Value = "";//property.City;
            command.Parameters.Add("@Localityarea", SqlDbType.NVarChar).Value = property.Localityarea;
            command.Parameters.Add("@State", SqlDbType.NVarChar).Value = "";//property.State;
            command.Parameters.Add("@Postal", SqlDbType.NVarChar).Value = property.Postal;
            command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = property.Phone;
            command.Parameters.Add("@Directions", SqlDbType.NVarChar).Value = property.Directions;
            command.Parameters.Add("@Keyword", SqlDbType.NVarChar).Value = property.Keyword;
            command.Parameters.Add("@ServicesSwimPool", SqlDbType.Bit).Value = property.ServicesSwimPool;
            command.Parameters.Add("@ServicesPub", SqlDbType.Bit).Value = property.ServicesPub;
            command.Parameters.Add("@ServicesGym", SqlDbType.Bit).Value = property.ServicesGym;
            command.Parameters.Add("@ServicesRestaurant", SqlDbType.Bit).Value = property.ServicesRestaurant;
            command.Parameters.Add("@ServicesConfHall", SqlDbType.Bit).Value = property.ServicesConfHall;
            command.Parameters.Add("@ServicesCyberCafe", SqlDbType.Bit).Value = property.ServicesCyberCafe;
            command.Parameters.Add("@ServicesLaundry", SqlDbType.Bit).Value = property.ServicesLaundry;
            command.Parameters.Add("@ShowOnWebsite", SqlDbType.Bit).Value = property.ShowOnWebsite;
            command.Parameters.Add("@LatitudeLongitude", SqlDbType.NVarChar).Value = property.LatitudeLongitude;
            command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = property.Date;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = property.StateId;
            command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = property.CityId;
            command.Parameters.Add("@LocalityId", SqlDbType.BigInt).Value = property.LocalityId;
            command.Parameters.Add("@TotalNoRooms", SqlDbType.NVarChar).Value = property.TotalNoRooms;
            command.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = property.PropertyType;
            command.Parameters.Add("@PropertyRackTarrif", SqlDbType.Decimal).Value = property.PropertyRackTarrif;
            command.Parameters.Add("@RackTarrifDouble", SqlDbType.Decimal).Value = property.RackTarrifDouble;
            command.Parameters.Add("@BookingPolicy", SqlDbType.NVarChar).Value = property.BookingPolicy;
            command.Parameters.Add("@CancelPolicy", SqlDbType.NVarChar).Value = property.CancelPolicy;
            command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = property.Email;
            command.Parameters.Add("@CheckIn", SqlDbType.BigInt).Value = property.CheckIn;
            command.Parameters.Add("@CheckInType", SqlDbType.NVarChar).Value = property.CheckInType;
            command.Parameters.Add("@CheckOut", SqlDbType.BigInt).Value = property.CheckOut;
            command.Parameters.Add("@CheckOutType", SqlDbType.NVarChar).Value = property.CheckOutType;
            command.Parameters.Add("@GraceTime", SqlDbType.BigInt).Value = property.GraceTime;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            //if (property.Copy == "true")
            //{
            //    command = new SqlCommand();
            //    command.CommandText = StoredProcedures.Property_Delete;
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.Parameters.Add("@Id", SqlDbType.BigInt).Value =property.CopyId;
            //    command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = ds.Tables[0].Rows[0][0].ToString();
            //    command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            //    return new WrbErpConnection().ExecuteDataSet(command, "");
            //}
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
         "', SctId:" + user.SctId + ", Service:PropertyDAO Select" + ", ProcName:'" + StoredProcedures.Property_Select; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Property_Select;
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
                "', SctId:" + user.SctId + ", Service:PropertyDAO Delete" + ", ProcName:'" + StoredProcedures.Property_Delete; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Property_Delete;
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
                "', SctId:" + user.SctId + ", Service:PropertyDAO Help" + ", ProcName:'" + StoredProcedures.Property_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Property_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            if ((data[1].ToString() != "Block") && (data[1].ToString() != "RoomType") && (data[1].ToString() != "RoomCategory"))
            {
                command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[4].ToString();
                command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = data[5].ToString();
            }
            else
            {
                command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = "";
                command.Parameters.Add("@Pram3", SqlDbType.VarChar).Value = "";
            }
            
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
