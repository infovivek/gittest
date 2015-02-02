using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;


namespace HB.Dao
{
   public class ContractManagementDao
    {
       public DataSet Save(string data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           ContractManagement ctrmgnt = new ContractManagement();
           XmlDocument document = new XmlDocument();
           document.LoadXml(data);
           ctrmgnt.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
           ctrmgnt.ContractType = document.SelectSingleNode("HdrXml").Attributes["ContractType"].Value;
           ctrmgnt.ContractName = document.SelectSingleNode("HdrXml").Attributes["ContractName"].Value;
           ctrmgnt.ClientName = document.SelectSingleNode("HdrXml").Attributes["ClientName"].Value;
          // ctrmgnt.Property = document.SelectSingleNode("HdrXml").Attributes["Property"].Value;
           ctrmgnt.BookingLevel = document.SelectSingleNode("HdrXml").Attributes["BookingLevel"].Value;
           ctrmgnt.StartDate = document.SelectSingleNode("HdrXml").Attributes["StartDate"].Value;
           ctrmgnt.EndDate = document.SelectSingleNode("HdrXml").Attributes["EndDate"].Value;
        //   ctrmgnt.ExtenstionDate = document.SelectSingleNode("HdrXml").Attributes["ExtenstionDate"].Value;
           ctrmgnt.ContractPriceMode = document.SelectSingleNode("HdrXml").Attributes["ContractPriceMode"].Value;
           ctrmgnt.RateInterval = document.SelectSingleNode("HdrXml").Attributes["RateInterval"].Value;
           ctrmgnt.SalesExecutive = document.SelectSingleNode("HdrXml").Attributes["SalesExecutive"].Value;
           ctrmgnt.AgreementDate = document.SelectSingleNode("HdrXml").Attributes["AgreementDate"].Value;

         //  ctrmgnt.PropertyId =  Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
           ctrmgnt.ClientId =  Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);

           ctrmgnt.SalesExecutiveId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["SalesExecutiveId"].Value);
           ctrmgnt.Types = document.SelectSingleNode("HdrXml").Attributes["Types"].Value;
           ctrmgnt.PrintingModel = document.SelectSingleNode("HdrXml").Attributes["PrintingModel"].Value;
         //  ctrmgnt.Status = document.SelectSingleNode("HdrXml").Attributes["Status"].Value; 
           ctrmgnt.TransubName = document.SelectSingleNode("HdrXml").Attributes["TransubName"].Value;
           ctrmgnt.TransubId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["TransubId"].Value);
           if (ctrmgnt.Id != 0)
           {
               command.CommandText = StoredProcedures.ContractManagement_Update;
               command.Parameters.Add("@Id", SqlDbType.BigInt).Value =  ctrmgnt.Id;
           }
           else
           {
               command.CommandText = StoredProcedures.ContractManagement_Insert;
           }
           command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@ContractType", SqlDbType.NVarChar).Value  =  ctrmgnt.ContractType; 
               command.Parameters.Add("@ContractName", SqlDbType.NVarChar).Value  =   ctrmgnt.ContractName;
               command.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value    = ctrmgnt.ClientName;
               command.Parameters.Add("@Property", SqlDbType.NVarChar).Value      = "Property";
               command.Parameters.Add("@BookingLevel", SqlDbType.NVarChar).Value  = ctrmgnt.BookingLevel; 
               command.Parameters.Add("@StartDate", SqlDbType.NVarChar).Value     =   ctrmgnt.StartDate;
               command.Parameters.Add("@EndDate", SqlDbType.NVarChar).Value       =   ctrmgnt.EndDate;
               command.Parameters.Add("@ExtenstionDate", SqlDbType.NVarChar).Value    = ""; 
               command.Parameters.Add("@ContractPriceMode", SqlDbType.NVarChar).Value =   ctrmgnt.ContractPriceMode;
               command.Parameters.Add("@RateInterval", SqlDbType.NVarChar).Value      =   ctrmgnt.RateInterval;
               command.Parameters.Add("@SalesExecutive", SqlDbType.NVarChar).Value = "";// ctrmgnt.SalesExecutive;
               command.Parameters.Add("@AgreementDate", SqlDbType.NVarChar).Value     = ctrmgnt.AgreementDate;
               command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = 0;//Convert.ToInt32(ctrmgnt.PropertyId);
               command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value         = Convert.ToInt32(ctrmgnt.ClientId);
               command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value        = Convert.ToInt32(user.Id);

               command.Parameters.Add("@PrintingModel", SqlDbType.NVarChar).Value  = ctrmgnt.PrintingModel;
               command.Parameters.Add("@Types", SqlDbType.NVarChar).Value          = ctrmgnt.Types;
               command.Parameters.Add("@Status", SqlDbType.NVarChar).Value         = "";
               command.Parameters.Add("@TransubName", SqlDbType.NVarChar).Value = ctrmgnt.TransubName;
               command.Parameters.Add("@TransubId", SqlDbType.BigInt).Value = Convert.ToInt32(ctrmgnt.TransubId);
               command.Parameters.Add("@SalesExecutiveId", SqlDbType.BigInt).Value = Convert.ToInt32(ctrmgnt.SalesExecutiveId);
           ds = new WrbErpConnection().ExecuteDataSet(command, "");
           return ds;
       }
       public DataSet Search(string[] data, User user)
       {
           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.ContractManagement_Select;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@SelectId", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
           command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[3].ToString();
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, "");
       }
       public DataSet Delete(string[] data, User user)
       {
           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.ContractManagement_Delete;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@Id", SqlDbType.BigInt).Value = data[1].ToString();
           command.Parameters.Add("@Pram1", SqlDbType.VarChar).Value = data[2].ToString();
           command.Parameters.Add("@DeleteId", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, "");
       }
       public DataSet Help(string[] data, User user)
       {
           SqlCommand command = new SqlCommand();
           command.CommandText = StoredProcedures.ContractManagement_Help;
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
           command.Parameters.Add("@HelpId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
           //command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
           command.Parameters.Add("@Pram2", SqlDbType.NVarChar).Value = data[3].ToString(); 
           command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
           return new WrbErpConnection().ExecuteDataSet(command, "");
       }
    }
}
