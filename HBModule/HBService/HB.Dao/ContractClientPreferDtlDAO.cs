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
    public class ContractClientPreferDtlDAO
    {
        public DataSet Save(string ContractClientPrefDtls, User user, int ContractClientprefHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            ContractClientPreferDtl ctrclpd = new ContractClientPreferDtl();
            XmlDocument document = new XmlDocument();
            document.LoadXml(ContractClientPrefDtls);
            int n;
            n = (document).SelectNodes("//ClientXml").Count;
            for (int i = 0; i < n; i++)
            {
                ctrclpd.Property = document.SelectNodes("//ClientXml")[i].Attributes["Property"].Value;
                ctrclpd.RoomType = document.SelectNodes("//ClientXml")[i].Attributes["RoomType"].Value;
                if (document.SelectNodes("//ClientXml")[i].Attributes["TariffSingle"].Value == "")
                {
                    ctrclpd.TariffSingle = 0;
                }
                else
                {
                    ctrclpd.TariffSingle = Convert.ToDecimal(document.SelectNodes("//ClientXml")[i].Attributes["TariffSingle"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["TariffDouble"].Value == "")
                {
                    ctrclpd.TariffDouble = 0;
                }
                else
                {
                    ctrclpd.TariffDouble = Convert.ToDecimal(document.SelectNodes("//ClientXml")[i].Attributes["TariffDouble"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["TariffTriple"].Value == "")
                {
                    ctrclpd.TariffTriple = 0;
                }
                else
                {
                    ctrclpd.TariffTriple = Convert.ToDecimal(document.SelectNodes("//ClientXml")[i].Attributes["TariffTriple"].Value);
                }
                ctrclpd.Facility = document.SelectNodes("//ClientXml")[i].Attributes["Facility"].Value;
                ctrclpd.Inclusive = Convert.ToBoolean(document.SelectNodes("//ClientXml")[i].Attributes["Inclusive"].Value);
                
                if (document.SelectNodes("//ClientXml")[i].Attributes["Tax"].Value == "")
                {
                    ctrclpd.Tax = 0;
                }
                else
                {
                    ctrclpd.Tax = Convert.ToDecimal(document.SelectNodes("//ClientXml")[i].Attributes["Tax"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["Id"].Value == "")
                {
                    ctrclpd.Id = 0;
                }
                else
                {
                    ctrclpd.Id = Convert.ToInt32(document.SelectNodes("//ClientXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["PropertyId"].Value == "")
                {
                    ctrclpd.PropertyId = 0;
                }
                else
                {
                    ctrclpd.PropertyId = Convert.ToInt32(document.SelectNodes("//ClientXml")[i].Attributes["PropertyId"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["RoomId"].Value == "")
                {
                    ctrclpd.RoomId = 0;
                }
                else
                {
                    ctrclpd.RoomId = Convert.ToInt32(document.SelectNodes("//ClientXml")[i].Attributes["RoomId"].Value);
                }
                if (document.SelectNodes("//ClientXml")[i].Attributes["ContactEmail"].Value == "")
                {
                    ctrclpd.ContactEmail = "";
                }
                else
                {
                    ctrclpd.ContactEmail = document.SelectNodes("//ClientXml")[i].Attributes["ContactEmail"].Value;
                }
                ctrclpd.ContactPhone = document.SelectNodes("//ClientXml")[i].Attributes["ContactPhone"].Value;
                ctrclpd.ContactName = document.SelectNodes("//ClientXml")[i].Attributes["ContactName"].Value;
                command = new SqlCommand();
                if (ctrclpd.Id != 0)
                {
                    command.CommandText = StoredProcedures.ContractClientpreferDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ctrclpd.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.ContractClientpreferDtl_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@HeaderId", SqlDbType.NVarChar).Value = ContractClientprefHdrId;
                command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = ctrclpd.Property;
                command.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = ctrclpd.RoomType;
                command.Parameters.Add("@TariffSingle", SqlDbType.Decimal).Value = ctrclpd.TariffSingle;
                command.Parameters.Add("@TariffDouble", SqlDbType.Decimal).Value = ctrclpd.TariffDouble;
                command.Parameters.Add("@TariffTriple", SqlDbType.Decimal).Value = ctrclpd.TariffTriple;
                command.Parameters.Add("@Facility", SqlDbType.NVarChar).Value = ctrclpd.Facility;
                command.Parameters.Add("@TaxInclusive", SqlDbType.Bit).Value = ctrclpd.Inclusive;
                command.Parameters.Add("@TaxPercentage", SqlDbType.Decimal).Value = ctrclpd.Tax;
                command.Parameters.Add("@ContactName", SqlDbType.NVarChar).Value = ctrclpd.ContactName;
                command.Parameters.Add("@ContactPhone", SqlDbType.NVarChar).Value = ctrclpd.ContactPhone;
                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = ctrclpd.ContactEmail;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = ctrclpd.PropertyId;
                command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = ctrclpd.RoomId;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
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

