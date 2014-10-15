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
  public  class PropertyAgreementDAO
  {
      String UserData;
        public DataSet Save(string Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            PropertyAgreement PrptyAgrement = new PropertyAgreement();
            XmlDocument document = new XmlDocument();
        document.LoadXml(Hdrval);      
        PrptyAgrement.propertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
        PrptyAgrement.DateOfAgreement = document.SelectSingleNode("HdrXml").Attributes["DateofAgreement"].Value;
        PrptyAgrement.RentalStartDate = document.SelectSingleNode("HdrXml").Attributes["RentalStartDate"].Value;       
        PrptyAgrement.RentalType = document.SelectSingleNode("HdrXml").Attributes["RentalType"].Value;
        PrptyAgrement.Paid = document.SelectSingleNode("HdrXml").Attributes["Paid"].Value;
        PrptyAgrement.TAC = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["TAC"].Value);
        if (document.SelectSingleNode("HdrXml").Attributes["TACPer"].Value == "")
        {
            PrptyAgrement.TACPer = 0;
        }
        else
        {
            PrptyAgrement.TACPer = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TACPer"].Value);
        }
        //PrptyAgrement.Flag = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Flag"].Value);
        //if (document.SelectSingleNode("HdrXml").Attributes["Tariff"].Value == "")
        //{
        //    PrptyAgrement.Tariff = 0;
        //}
        //else
        //{
        //    PrptyAgrement.Tariff = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Tariff"].Value);
        //}
        //PrptyAgrement.Check = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Check"].Value);
        if (document.SelectSingleNode("HdrXml").Attributes["Tenure"].Value == "")
        {
            PrptyAgrement.Tenure = 0;
        }
        else
        {
            PrptyAgrement.Tenure = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["Tenure"].Value);
        }
        if (document.SelectSingleNode("HdrXml").Attributes["LockPeriod"].Value == "")
        {
            PrptyAgrement.LockInPeriod = 0;
        }
        else
        {
            PrptyAgrement.LockInPeriod = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["LockPeriod"].Value);
        }
        if (document.SelectSingleNode("HdrXml").Attributes["NoticePeriod"].Value == "")
        {
            PrptyAgrement.NoticePeriod = 0;
        }
        else
        {
            PrptyAgrement.NoticePeriod = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["NoticePeriod"].Value);
        }
        if (document.SelectSingleNode("HdrXml").Attributes["StartingRental"].Value == "")
        {
            PrptyAgrement.StartingRentalMonth = 0;
        }
        else
        {
            PrptyAgrement.StartingRentalMonth = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["StartingRental"].Value);
        }
        if (document.SelectSingleNode("HdrXml").Attributes["MaintenanceAmount"].Value == "")
        {
            PrptyAgrement.MaintenanceAmount = 0;
        }
        else
        {
            PrptyAgrement.MaintenanceAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["MaintenanceAmount"].Value);
        }
        PrptyAgrement.ExpiryDate = document.SelectSingleNode("HdrXml").Attributes["ExpiryDate"].Value;
        PrptyAgrement.StartingMaintenanceMonth = document.SelectSingleNode("HdrXml").Attributes["MaintenanceStartdate"].Value;
        PrptyAgrement.AssociationName = document.SelectSingleNode("HdrXml").Attributes["AssociationName"].Value;
        PrptyAgrement.RentInclusive = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["Rentinclusive"].Value);
        PrptyAgrement.ApartmentId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ApartmentId"].Value);
        PrptyAgrement.ApartmentName = document.SelectSingleNode("HdrXml").Attributes["ApartmentName"].Value;
        PrptyAgrement.MaintenanceType = document.SelectSingleNode("HdrXml").Attributes["MaintenanceType"].Value;
         if (document.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value == "")
        {
            PrptyAgrement.AdvanceAmount = 0;
        }
        else
        {
            PrptyAgrement.AdvanceAmount = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["AdvanceAmount"].Value);
        }

       // PrptyAgrement.Status = Convert.ToBoolean(document.SelectSingleNode("HdrXml").Attributes["Status"].Value);
        PrptyAgrement.AdvanceDate = document.SelectSingleNode("HdrXml").Attributes["AdvanceDate"].Value;
        PrptyAgrement.AdvanceType = document.SelectSingleNode("HdrXml").Attributes["AdvanceType"].Value;
        PrptyAgrement.Bank = document.SelectSingleNode("HdrXml").Attributes["Bank"].Value;
        PrptyAgrement.ChqNeft = document.SelectSingleNode("HdrXml").Attributes["ChqNEFT"].Value;       
        PrptyAgrement.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);
        command = new SqlCommand();
            if (PrptyAgrement.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PropertyAgreementDAO Update" + ", ProcName:'" + StoredProcedures.PropertyAgreement_Update; 

                command.CommandText = StoredProcedures.PropertyAgreement_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PrptyAgrement.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:PropertyAgreementDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyAgreement_Insert; 

               command.CommandText = StoredProcedures.PropertyAgreement_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = 0;
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PrptyAgrement.propertyId;
            command.Parameters.Add("@DateOfAgreement", SqlDbType.NVarChar).Value = PrptyAgrement.DateOfAgreement;
            command.Parameters.Add("@RentalStartDate", SqlDbType.NVarChar).Value = PrptyAgrement.RentalStartDate;
            command.Parameters.Add("@NoticePeriod", SqlDbType.BigInt).Value = PrptyAgrement.NoticePeriod;
            command.Parameters.Add("@LockInPeriod", SqlDbType.BigInt).Value = PrptyAgrement.LockInPeriod;

            command.Parameters.Add("@StartingRentalMonth", SqlDbType.Decimal).Value = PrptyAgrement.StartingRentalMonth;
            command.Parameters.Add("@RentalType", SqlDbType.NVarChar).Value = PrptyAgrement.RentalType;
            command.Parameters.Add("@StartingMaintenanceMonth", SqlDbType.NVarChar).Value = PrptyAgrement.StartingMaintenanceMonth;
            command.Parameters.Add("@MaintenanceAmount", SqlDbType.Decimal).Value = PrptyAgrement.MaintenanceAmount;
            command.Parameters.Add("@Tenure", SqlDbType.BigInt).Value = PrptyAgrement.Tenure;
            command.Parameters.Add("@ExpiryDate", SqlDbType.NVarChar).Value = PrptyAgrement.ExpiryDate;
            command.Parameters.Add("@RentInclusive", SqlDbType.Bit).Value = PrptyAgrement.RentInclusive;
            command.Parameters.Add("@AssociationName", SqlDbType.NVarChar).Value = PrptyAgrement.AssociationName;
            command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = PrptyAgrement.ApartmentId;
            command.Parameters.Add("@ApartmentName", SqlDbType.NVarChar).Value = PrptyAgrement.ApartmentName;
            command.Parameters.Add("@Paid", SqlDbType.NVarChar).Value = PrptyAgrement.Paid;
            command.Parameters.Add("@AdvanceDate", SqlDbType.NVarChar).Value = PrptyAgrement.AdvanceDate;
            command.Parameters.Add("@AdvanceType", SqlDbType.NVarChar).Value = PrptyAgrement.AdvanceType;
            command.Parameters.Add("@Bank", SqlDbType.NVarChar).Value = PrptyAgrement.Bank;
            command.Parameters.Add("@ChqNeft", SqlDbType.NVarChar).Value = PrptyAgrement.ChqNeft;
            command.Parameters.Add("@AdvanceAmount", SqlDbType.Decimal).Value = PrptyAgrement.AdvanceAmount;
            command.Parameters.Add("@MaintenanceType", SqlDbType.NVarChar).Value = PrptyAgrement.MaintenanceType;
           // command.Parameters.Add("@DurationEscalation", SqlDbType.NVarChar).Value = PrptyAgrement.DurationEscalation;
            command.Parameters.Add("@Status", SqlDbType.Bit).Value = true;
            command.Parameters.Add("@TAC", SqlDbType.Bit).Value = PrptyAgrement.TAC;
            command.Parameters.Add("@TACPer", SqlDbType.Decimal).Value = PrptyAgrement.TACPer;
            //command.Parameters.Add("@Flag", SqlDbType.BigInt).Value = PrptyAgrement.Flag;
            //command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = PrptyAgrement.Tariff;
            //command.Parameters.Add("@Check", SqlDbType.BigInt).Value = PrptyAgrement.Check;
            command.Parameters.Add("@Createdby", SqlDbType.BigInt).Value = user.Id;


            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;

        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            "', SctId:" + user.SctId + ", Service:PropertyAgreementDAO Select" + ", ProcName:'" + StoredProcedures.PropertyAgreement_Select; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PropertyAgreement_Select;
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
            "', SctId:" + user.SctId + ", Service:PropertyAgreementDAO Delete" + ", ProcName:'" + StoredProcedures.PropertyAgreement_Delete; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PropertyAgreement_Delete;
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
            "', SctId:" + user.SctId + ", Service:PropertyAgreementDAO Help" + ", ProcName:'" + StoredProcedures.PropertyAgreement_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PropertyAgreement_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.VarChar).Value = data[1].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Pram1", SqlDbType.BigInt).Value = Convert.ToInt32(data[3].ToString());
            if (data[1].ToString() != "AgreementRooms")
            {
                command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value = data[4].ToString();
            }
            else
            {
                command.Parameters.Add("@Pram2", SqlDbType.VarChar).Value ="";
            }
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

    }
}
