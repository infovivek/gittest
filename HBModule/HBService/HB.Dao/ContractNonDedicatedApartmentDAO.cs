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
    public class ContractNonDedicatedApartmentDAO
    {
        string UserData;
        public DataSet Save(string NonDedicatedContractApartDtls, User user, int NonDedicatedContractId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            ContractNonDedicatedApartment ctrNonDdApt = new ContractNonDedicatedApartment();
            XmlDocument document = new XmlDocument();
            document.LoadXml(NonDedicatedContractApartDtls);
            int n;
            n = (document).SelectNodes("//ApartXml").Count;
            for (int i = 0; i < n; i++)
            {
                ctrNonDdApt.ApartmentType = document.SelectNodes("//ApartXml")[i].Attributes["Type"].Value;
                if (document.SelectNodes("//ApartXml")[i].Attributes["ApartTarif"].Value == "")
                {
                    ctrNonDdApt.ApartTarif = 0;
                }
                else
                {
                    ctrNonDdApt.ApartTarif = Convert.ToDecimal(document.SelectNodes("//ApartXml")[i].Attributes["ApartTarif"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["RoomTariff"].Value == "")
                {
                    ctrNonDdApt.RoomTariff = 0;
                }
                else
                {
                    ctrNonDdApt.RoomTariff = Convert.ToDecimal(document.SelectNodes("//ApartXml")[i].Attributes["RoomTariff"].Value);
                }
                if(document.SelectNodes("//ApartXml")[i].Attributes["DoubleOccupancyTariff"].Value=="")
                {
                      ctrNonDdApt.DoubleTariff =0;
                }
                else
                {
                     ctrNonDdApt.DoubleTariff = Convert.ToDecimal(document.SelectNodes("//ApartXml")[i].Attributes["DoubleOccupancyTariff"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["TripleTarif"].Value == "")
                {
                    ctrNonDdApt.TripleTariff = 0;
                }
                else
                {
                    ctrNonDdApt.TripleTariff = Convert.ToDecimal(document.SelectNodes("//ApartXml")[i].Attributes["TripleTarif"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["BedTariff"].Value == "")
                {
                    ctrNonDdApt.BedTariff=0;
                }
                else
                {
                      ctrNonDdApt.BedTariff = Convert.ToDecimal(document.SelectNodes("//ApartXml")[i].Attributes["BedTariff"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["Description"].Value == "")
                {
                    ctrNonDdApt.Description = "";
                }
                else
                {
                    ctrNonDdApt.Description = document.SelectNodes("//ApartXml")[i].Attributes["Description"].Value;
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["Id"].Value == "")
                {
                    ctrNonDdApt.Id = 0;
                }
                else
                {
                    ctrNonDdApt.Id = Convert.ToInt32(document.SelectNodes("//ApartXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["ApartmentId"].Value == "")
                {
                    ctrNonDdApt.ApartmentId = 0;
                }
                else
                {
                    ctrNonDdApt.ApartmentId = Convert.ToInt32(document.SelectNodes("//ApartXml")[i].Attributes["ApartmentId"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["RoomId"].Value == "")
                {
                    ctrNonDdApt.RoomId = 0;
                }
                else
                {
                    ctrNonDdApt.RoomId = Convert.ToInt32(document.SelectNodes("//ApartXml")[i].Attributes["RoomId"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["BedId"].Value == "")
                {
                    ctrNonDdApt.ApartmentId = 0;
                }
                else
                {
                    ctrNonDdApt.ApartmentId = Convert.ToInt32(document.SelectNodes("//ApartXml")[i].Attributes["BedId"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["PropertyId"].Value == "")
                {
                    ctrNonDdApt.PropertyId = 0;
                }
                else
                {
                    ctrNonDdApt.PropertyId = Convert.ToInt32(document.SelectNodes("//ApartXml")[i].Attributes["PropertyId"].Value);
                }
                if (document.SelectNodes("//ApartXml")[i].Attributes["PrtyCategoryId"].Value == "")
                {
                    ctrNonDdApt.PrtyCategory = "";
                }
                else
                {
                    ctrNonDdApt.PrtyCategory = document.SelectNodes("//ApartXml")[i].Attributes["PrtyCategoryId"].Value;
                }
                ctrNonDdApt.Property = document.SelectNodes("//ApartXml")[i].Attributes["PropertyName"].Value;
                command = new SqlCommand();
                if (ctrNonDdApt.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractNonDedicatedApartment_Update" +
                     ", ProcName:'" + StoredProcedures.ContractNonDedicatedApartment_Update;

                    command.CommandText = StoredProcedures.ContractNonDedicatedApartment_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ctrNonDdApt.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ContractNonDedicatedApartment_Insert" +
                     ", ProcName:'" + StoredProcedures.ContractNonDedicatedApartment_Insert;

                    command.CommandText = StoredProcedures.ContractNonDedicatedApartment_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@NonDedicatedContractId", SqlDbType.BigInt).Value = NonDedicatedContractId;
                command.Parameters.Add("@ApartmentType", SqlDbType.NVarChar).Value = ctrNonDdApt.ApartmentType;
                command.Parameters.Add("@ApartTarif ", SqlDbType.Decimal).Value = ctrNonDdApt.ApartTarif;
                command.Parameters.Add("@RoomTariff", SqlDbType.Decimal).Value = ctrNonDdApt.RoomTariff;
                command.Parameters.Add("@DoubleTariff", SqlDbType.Decimal).Value = ctrNonDdApt.DoubleTariff;
                command.Parameters.Add("@TripleTarif", SqlDbType.Decimal).Value = ctrNonDdApt.TripleTariff;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = ctrNonDdApt.Description;
                command.Parameters.Add("@BedTariff", SqlDbType.Decimal).Value = ctrNonDdApt.BedTariff;
                command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = ctrNonDdApt.ApartmentId;
                command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = ctrNonDdApt.RoomId;
                command.Parameters.Add("@BedId", SqlDbType.BigInt).Value = ctrNonDdApt.BedId;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = ctrNonDdApt.Property;
                command.Parameters.Add("@PropertyCategory", SqlDbType.NVarChar).Value = ctrNonDdApt.PrtyCategory;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = ctrNonDdApt.PropertyId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }

            return ds;
        }
    }
}