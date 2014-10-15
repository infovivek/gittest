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
   public class PropertyOwnersDAO
    {
       String UserData;
       public DataSet Save(string Hdrval, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           PropertyOwners  PrptyOwnrs = new PropertyOwners();
           XmlDocument document = new XmlDocument();
           document.LoadXml(Hdrval);
           PrptyOwnrs.Title = document.SelectSingleNode("HdrXml").Attributes["Title"].Value;
           PrptyOwnrs.PropertyId = document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value;
           PrptyOwnrs.FirstName = document.SelectSingleNode("HdrXml").Attributes["FirstName"].Value;
           PrptyOwnrs.Lastname = document.SelectSingleNode("HdrXml").Attributes["Lastname"].Value;
           PrptyOwnrs.LedgerName = document.SelectSingleNode("HdrXml").Attributes["LedgerName"].Value;
           PrptyOwnrs.EmailID = document.SelectSingleNode("HdrXml").Attributes["EmailId"].Value;
           PrptyOwnrs.PhoneNumber = document.SelectSingleNode("HdrXml").Attributes["Phone"].Value;
           PrptyOwnrs.Alternatephone = document.SelectSingleNode("HdrXml").Attributes["AlternatePhone"].Value;
           if (document.SelectSingleNode("HdrXml").Attributes["TDSPer"].Value == "")
           {
               PrptyOwnrs.TDSPer = 0;
           }
           else
           {
               PrptyOwnrs.TDSPer = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["TDSPer"].Value);
           }           
           PrptyOwnrs.Address = document.SelectSingleNode("HdrXml").Attributes["OwnerAddress"].Value;
           PrptyOwnrs.City = document.SelectSingleNode("HdrXml").Attributes["OwnerCity"].Value;
           PrptyOwnrs.LocalityArea = document.SelectSingleNode("HdrXml").Attributes["LocalityArea"].Value;
           PrptyOwnrs.State = document.SelectSingleNode("HdrXml").Attributes["OwnerState"].Value;
           PrptyOwnrs.Postal = document.SelectSingleNode("HdrXml").Attributes["OwnerPostal"].Value;
           PrptyOwnrs.PaymentMode = document.SelectSingleNode("HdrXml").Attributes["PaymentMode"].Value;
           PrptyOwnrs.PayeeName = document.SelectSingleNode("HdrXml").Attributes["PayeeName"].Value;
           PrptyOwnrs.AccountNumber = document.SelectSingleNode("HdrXml").Attributes["AccountNumber"].Value;
           PrptyOwnrs.AccountType = document.SelectSingleNode("HdrXml").Attributes["AccountType"].Value;
           PrptyOwnrs.Bank = document.SelectSingleNode("HdrXml").Attributes["Bank"].Value;
           PrptyOwnrs.BranchAddress = document.SelectSingleNode("HdrXml").Attributes["BranchAddress"].Value;
           PrptyOwnrs.IFSC = document.SelectSingleNode("HdrXml").Attributes["IFSC"].Value;
           PrptyOwnrs.SWIFTCode = document.SelectSingleNode("HdrXml").Attributes["SWIFTCode"].Value;
           PrptyOwnrs.PANNO = document.SelectSingleNode("HdrXml").Attributes["PAN"].Value;
           PrptyOwnrs.TIN = document.SelectSingleNode("HdrXml").Attributes["TIN"].Value;
           PrptyOwnrs.ST = document.SelectSingleNode("HdrXml").Attributes["ST"].Value;
           PrptyOwnrs.VAT = document.SelectSingleNode("HdrXml").Attributes["VAT"].Value;
           if (document.SelectSingleNode("HdrXml").Attributes["RackRates"].Value == "")
           {
               PrptyOwnrs.RackRates = 0;
           }
           else
           {
               PrptyOwnrs.RackRates = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["RackRates"].Value);
           }         
           PrptyOwnrs.LocalityId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["OwnerLocalityId"].Value);
           PrptyOwnrs.StateId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["OwnerStateId"].Value);
           PrptyOwnrs.CityId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["OwnerCityId"].Value);
         //  Couriercheque= 'true' ,  DirectCredit= 'false'   ,  PaymentMode, 


           PrptyOwnrs.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
           if (PrptyOwnrs.Id != 0)
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:PropertyOwnersDAO Update" + ", ProcName:'" + StoredProcedures.PropertyOwner_Update; 

               command.CommandText = StoredProcedures.PropertyOwner_Update;
               command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PrptyOwnrs.Id;
           }
           else
           {
               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:PropertyOwnersDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyOwner_Insert; 

               command.CommandText = StoredProcedures.PropertyOwner_Insert;
           }
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Title", SqlDbType.NVarChar).Value = PrptyOwnrs.Title;
           command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PrptyOwnrs.PropertyId;
           command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = PrptyOwnrs.FirstName;
           command.Parameters.Add("@Lastname", SqlDbType.NVarChar).Value = PrptyOwnrs.Lastname;
           command.Parameters.Add("@LedgerName", SqlDbType.NVarChar).Value = PrptyOwnrs.LedgerName;
           command.Parameters.Add("@EmailID", SqlDbType.NVarChar).Value = PrptyOwnrs.EmailID;
           command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = PrptyOwnrs.PhoneNumber;
           command.Parameters.Add("@Alternatephone", SqlDbType.NVarChar).Value = PrptyOwnrs.Alternatephone;
           command.Parameters.Add("@TDSPer", SqlDbType.BigInt).Value = PrptyOwnrs.TDSPer;
           command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = PrptyOwnrs.Address;
           command.Parameters.Add("@City", SqlDbType.NVarChar).Value = PrptyOwnrs.City;
           command.Parameters.Add("@LocalityArea", SqlDbType.NVarChar).Value = PrptyOwnrs.LocalityArea;
           command.Parameters.Add("@State", SqlDbType.NVarChar).Value = PrptyOwnrs.State;
           command.Parameters.Add("@Postal", SqlDbType.NVarChar).Value = PrptyOwnrs.Postal;
           command.Parameters.Add("@PaymentMode", SqlDbType.Bit).Value = PrptyOwnrs.PaymentMode;
           command.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = PrptyOwnrs.PayeeName;
           command.Parameters.Add("@AccountNumber", SqlDbType.NVarChar).Value = PrptyOwnrs.AccountNumber;
           command.Parameters.Add("@AccountType", SqlDbType.NVarChar).Value = PrptyOwnrs.AccountType;
           command.Parameters.Add("@Bank", SqlDbType.NVarChar).Value = PrptyOwnrs.Bank;
           command.Parameters.Add("@BranchAddress", SqlDbType.NVarChar).Value = PrptyOwnrs.BranchAddress;
           command.Parameters.Add("@IFSC", SqlDbType.NVarChar).Value = PrptyOwnrs.IFSC;
           command.Parameters.Add("@SWIFTCode", SqlDbType.NVarChar).Value = PrptyOwnrs.SWIFTCode;
           command.Parameters.Add("@PANNO", SqlDbType.NVarChar).Value = PrptyOwnrs.PANNO;
           command.Parameters.Add("@TIN", SqlDbType.NVarChar).Value = PrptyOwnrs.TIN;
           command.Parameters.Add("@ST", SqlDbType.NVarChar).Value = PrptyOwnrs.ST;
           command.Parameters.Add("@VAT", SqlDbType.NVarChar).Value = PrptyOwnrs.VAT;
           command.Parameters.Add("@RackRates", SqlDbType.Decimal).Value = PrptyOwnrs.RackRates;

           command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = PrptyOwnrs.StateId;
           command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = PrptyOwnrs.CityId;
           command.Parameters.Add("@LocalityId", SqlDbType.BigInt).Value = PrptyOwnrs.LocalityId;

              command.Parameters.Add("@Createdby", SqlDbType.BigInt).Value = user.Id;

              ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
           return ds;

       }
       public DataSet Search(string[] data, User user)
       {
           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
              "', SctId:" + user.SctId + ", Service:PropertyOwnersDAO Select" + ", ProcName:'" + StoredProcedures.PropertyOwner_Select; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyOwner_Select;
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
              "', SctId:" + user.SctId + ", Service:PropertyOwnersDAO Delete" + ", ProcName:'" + StoredProcedures.PropertyOwner_Delete; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyOwner_Delete;
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
              "', SctId:" + user.SctId + ", Service:PropertyOwnersDAO Help" + ", ProcName:'" + StoredProcedures.PropertyOwner_Help; 

           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.PropertyOwner_Help;
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
