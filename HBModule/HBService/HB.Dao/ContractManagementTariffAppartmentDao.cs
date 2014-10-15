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
    public class ContractManagementTariffAppartmentDao
    {
        public DataSet Save(string data, Entity.User user, int ContractId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(data);
            ContractManagementTariffAppartment CMTA = new ContractManagementTariffAppartment();
            int n;
            n = (document).SelectNodes("//TarrifApartXml").Count;
            for (int i = 0; i < n; i++)
            {
                CMTA.Place = document.SelectNodes("//TarrifApartXml")[i].Attributes["Place"].Value;
                CMTA.Property = document.SelectNodes("//TarrifApartXml")[i].Attributes["Property"].Value;
                CMTA.Attachedon = "";// document.SelectNodes("//TarrifApartXml")[i].Attributes["Attachedon"].Value;
                CMTA.Detachedon = "";//document.SelectNodes("//TarrifApartXml")[i].Attributes["Detachedon"].Value;
                CMTA.AttachedBy = "";//document.SelectNodes("//TarrifApartXml")[i].Attributes["Detachedon"].Value;
              //  CMTA.Detach = Convert.ToBoolean(document.SelectNodes("//TarrifApartXml")[i].Attributes["Detach"].Value);
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["BlockId"].Value == "")
                {
                    CMTA.BlockId = 0;
                }
                else
                {
                    CMTA.BlockId = Convert.ToInt32(document.SelectNodes("//TarrifApartXml")[i].Attributes["BlockId"].Value);
                }
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["PropertyId"].Value == "")
                {
                    CMTA.PropertyId = 0;
                }
                else
                {
                    CMTA.PropertyId = Convert.ToInt32(document.SelectNodes("//TarrifApartXml")[i].Attributes["PropertyId"].Value);
                }
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["Tariff"].Value == "")
                {
                    CMTA.Tariff = 0;
                }
                else
                {
                    CMTA.Tariff = Convert.ToDecimal(document.SelectNodes("//TarrifApartXml")[i].Attributes["Tariff"].Value);
                }
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["RoomId"].Value == "")
                {
                    CMTA.RoomId  = 0;
                }
                else
                {
                    CMTA.RoomId = Convert.ToInt32(document.SelectNodes("//TarrifApartXml")[i].Attributes["RoomId"].Value);
                }
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["ApartmentId"].Value == "")
                {
                    CMTA.ApartmentId  = 0;
                }
                else
                {
                    CMTA.ApartmentId  = Convert.ToInt32(document.SelectNodes("//TarrifApartXml")[i].Attributes["ApartmentId"].Value);
                }
                if (document.SelectNodes("//TarrifApartXml")[i].Attributes["Id"].Value == "")
                {
                    CMTA.Id = 0;
                }
                else
                {
                    CMTA.Id = Convert.ToInt32(document.SelectNodes("//TarrifApartXml")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                if (CMTA.Id != 0)
                {
                    command.CommandText = StoredProcedures.ContractManagementTariffAppartment_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = CMTA.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.ContractManagementTariffAppartment_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ContractId", SqlDbType.BigInt).Value = ContractId;
                command.Parameters.Add("@Place", SqlDbType.NVarChar).Value = CMTA.Place;
                command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = CMTA.Property;
                command.Parameters.Add("@Attachedon", SqlDbType.NVarChar).Value = CMTA.Attachedon;
                command.Parameters.Add("@Detachedon", SqlDbType.NVarChar).Value = CMTA.Detachedon;
               
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = CMTA.PropertyId;
                command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = CMTA.Tariff;

                command.Parameters.Add("@Detach", SqlDbType.Bit).Value = 1;// CMTA.Detach;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = CMTA.RoomId;
                command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = CMTA.ApartmentId;
                command.Parameters.Add("@AttachedBy", SqlDbType.NVarChar).Value = CMTA.AttachedBy;

                command.Parameters.Add("@BlockId", SqlDbType.BigInt).Value = CMTA.BlockId;

                ds = new WrbErpConnection().ExecuteDataSet(command, "");
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }
         
            return ds;
        }
    }
}
