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
   public class ApartmentDAO
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
           Apartment Aptment = new Apartment();
           if (document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value == "")
           {
               Aptment.PropertyId = 0;
           }
           else
           {
               Aptment.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value == "")
           {
               Aptment.PropertyId = 0;
           }
           else
           {

               Aptment.BlockId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["BlockId"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["BlockName"].Value == "")
           {
               Aptment.BlockName = "";
           }
           else
           {
               Aptment.BlockName = document.SelectSingleNode("HdrXml").Attributes["BlockName"].Value;
           }

           if (document.SelectSingleNode("HdrXml").Attributes["ApartmentName"].Value == "")
           {
               Aptment.ApartmentName = "";
           }
           else
           {
               Aptment.ApartmentName = document.SelectSingleNode("HdrXml").Attributes["ApartmentName"].Value;
           }

           if (document.SelectSingleNode("HdrXml").Attributes["ApartmentType"].Value == "")
           {
               Aptment.ApartmentType = "";
           }
           else
           {
               Aptment.ApartmentType = document.SelectSingleNode("HdrXml").Attributes["ApartmentType"].Value;
           }
           if (document.SelectSingleNode("HdrXml").Attributes["ApartmentNo"].Value == "")
           {
               Aptment.ApartmentNo = "";
           }
           else
           {
               Aptment.ApartmentNo = document.SelectSingleNode("HdrXml").Attributes["ApartmentNo"].Value;
           }
           if (document.SelectSingleNode("HdrXml").Attributes["SellableApartmentType"].Value == "")
           {
               Aptment.SellableApartmentType = "";
           }
           else
           {
               Aptment.SellableApartmentType = document.SelectSingleNode("HdrXml").Attributes["SellableApartmentType"].Value;
           }
           if (document.SelectSingleNode("HdrXml").Attributes["OwnershipType"].Value == "")
           {
               Aptment.OwnershipType = "";
           }
           else
           {
               Aptment.OwnershipType = document.SelectSingleNode("HdrXml").Attributes["OwnershipType"].Value;
           }
           if (document.SelectSingleNode("HdrXml").Attributes["RackTariff"].Value == "")
           {
               Aptment.RackTariff = 0;
           }
           else
           {
               Aptment.RackTariff = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["RackTariff"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["DiscountModePer"].Value == "")
           {
               Aptment.DiscountModePer = false;
           }
           else
           {
               Aptment.DiscountModePer = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["DiscountModePer"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["DiscountModeRS"].Value == "")
           {
               Aptment.DiscountModeRS = false;
           }
           else
           {
               Aptment.DiscountModeRS = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["DiscountModeRS"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["DiscountAllowed"].Value == "")
           {
               Aptment.DiscountAllowed = 0;
           }
           else
           {
               Aptment.DiscountAllowed = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["DiscountAllowed"].Value);
           }
           if (document.SelectSingleNode("HdrXml").Attributes["Status"].Value == "")
           {
               Aptment.Status = "";
           }
           else
           {
               Aptment.Status = document.SelectSingleNode("HdrXml").Attributes["Status"].Value;
           }
           if (document.SelectSingleNode("HdrXml").Attributes["Id"].Value == "")
           {
               Aptment.Id = 0;
           }
           else
           {
               Aptment.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
           }
            
           if (Aptment.Id != 0)
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:ApartmentDAO Update" + ", ProcName:'" + StoredProcedures.Apartment_Update; 

              command.CommandText = StoredProcedures.Apartment_Update;
              command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Aptment.Id;
           }
           else
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:ApartmentDAO Inser" + ", ProcName:'" + StoredProcedures.Apartment_Insert; 

               command.CommandText = StoredProcedures.Apartment_Insert;
           }
             command.CommandType = CommandType.StoredProcedure; 
             command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value=Aptment.PropertyId;
             command.Parameters.Add("@BlockId", SqlDbType.Int).Value =Aptment.BlockId;
             command.Parameters.Add("@BlockName", SqlDbType.NVarChar).Value =Aptment.BlockName;
             command.Parameters.Add("@ApartmentName", SqlDbType.NVarChar).Value = Aptment.ApartmentName;
             command.Parameters.Add("@ApartmentType", SqlDbType.NVarChar).Value =Aptment.ApartmentType;
             command.Parameters.Add("@ApartmentNo", SqlDbType.NVarChar).Value =Aptment.ApartmentNo;
             command.Parameters.Add("@SellableApartmentType", SqlDbType.NVarChar).Value =Aptment.SellableApartmentType;
             command.Parameters.Add("@OwnershipType", SqlDbType.NVarChar).Value =Aptment.OwnershipType;
             command.Parameters.Add("@RackTariff", SqlDbType.Decimal).Value = Aptment.RackTariff;
             command.Parameters.Add("@DiscountModePer", SqlDbType.Bit).Value =Aptment.DiscountModePer;
             command.Parameters.Add("@DiscountModeRS", SqlDbType.Bit).Value =Aptment.DiscountModeRS;
             command.Parameters.Add("@DiscountAllowed", SqlDbType.Decimal).Value =Aptment.DiscountAllowed;
             command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = Aptment.Status;

           command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

           ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           return ds;
       }
       public DataSet Search(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            "', SctId:" + user.SctId + ", Service:ApartmentDAO Select" + ", ProcName:'" + StoredProcedures.Apartment_Select; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Apartment_Select;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@SelectId", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
           command.Parameters.Add("@Pram1", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[3].ToString(); 
           command.Parameters.Add("@UserId", SqlDbType.Int).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Delete(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            "', SctId:" + user.SctId + ", Service:ApartmentDAO Delete" + ", ProcName:'" + StoredProcedures.Apartment_Delete; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Apartment_Delete;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[0].ToString());
           command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[1].ToString();
           command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, UserData);
       }
       public DataSet Help(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            "', SctId:" + user.SctId + ", Service:ApartmentDAO Help" + ", ProcName:'" + StoredProcedures.Apartment_Help; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.Apartment_Help;
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