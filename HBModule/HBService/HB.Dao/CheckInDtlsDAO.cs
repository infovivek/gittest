using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Xml;
using System.Collections;

namespace HB.Dao
{
     public class CheckInDtlsDAO
        {
           public DataSet Save(string ChkInHdr, User user, int ChkInHdrId)
            {
                DataSet ds = new DataSet();
                DataTable dTable = new DataTable("ERRORTBL");
                dTable.Columns.Add("Exception");
                SqlCommand command = new SqlCommand();

                CheckInDtls ChkIn = new CheckInDtls();
                XmlDocument document = new XmlDocument();
                document.LoadXml(ChkInHdr);
                int n;
                n = (document).SelectNodes("//GridXml").Count;
                for (int i = 0; i < n; i++)
                {
                    ChkIn.RoomType = document.SelectNodes("//GridXml")[i].Attributes["RoomType"].Value;
                    
                    if (document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value == "")
                    {
                        ChkIn.PropertyId = 0;
                    }
                    else
                    {
                        ChkIn.PropertyId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["RoomNo"].Value == "")
                    {
                        ChkIn.RoomNo = 0;
                    }
                    else
                    {
                        ChkIn.RoomNo = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["RoomNo"].Value);
                    }
                //    ChkIn.Property = document.SelectNodes("//GridXml")[i].Attributes["Property"].Value;
                    if (document.SelectNodes("//GridXml")[i].Attributes["Tariff"].Value == "")
                    {
                        ChkIn.Pax = 0;
                    }
                    else
                    {
                        ChkIn.Pax = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Pax"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["Tariff"].Value == "")
                    {
                        ChkIn.Tariff = 0;
                    }
                    else
                    {
                        ChkIn.Tariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Tariff"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["BookingId"].Value == "")
                    {
                        ChkIn.BookingId = 0;
                    }
                    else
                    {
                        ChkIn.BookingId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["BookingId"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value == "")
                    {
                        ChkIn.RoomId = 0;
                    }
                    else
                    {
                        ChkIn.RoomId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["RoomId"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["TariffId"].Value == "")
                    {
                        ChkIn.TariffId = 0;
                    }
                    else
                    {
                        ChkIn.TariffId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["TariffId"].Value);
                    }
                    if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                    {
                        ChkIn.Id = 0;
                    }
                    else
                    {
                        ChkIn.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                    }
                       
                    /*ChkIn.TaxId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["TaxId"].Value);
                    ChkIn.Male = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Male"].Value);
                    ChkIn.Female = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Female"].Value);
                    
                    ChkIn.Tax = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Tax"].Value);
                    ChkIn.Cess = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Cess"].Value);
                    ChkIn.HECess = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["HECess"].Value);
                    ChkIn.VAT = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["VAT"].Value);
                    ChkIn.Service = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Service"].Value);
                    ChkIn.Luxury = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Luxury"].Value);
                    ChkIn.ExtraBed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["ExtraBed"].Value);*/
                    
                    }
                    command = new SqlCommand();
                    if (ChkIn.Id != 0)
                    {
                        command.CommandText = StoredProcedures.CheckInDtls_Update;
                        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ChkIn.Id;
                    }
                    else
                    {
                        command.CommandText = StoredProcedures.CheckInDtls_Insert;
                    }
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = ChkInHdrId;
                    command.Parameters.Add("@PropertyId", SqlDbType.Int).Value =ChkIn.PropertyId; 
                    command.Parameters.Add("@TariffId", SqlDbType.Int).Value =ChkIn.TariffId;
                    command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = ChkIn.Tariff;
                  //  command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = ChkIn.Property;
                    command.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = ChkIn.RoomType;
                    command.Parameters.Add("@Pax", SqlDbType.Int).Value = ChkIn.Pax;
                    command.Parameters.Add("@RoomNo", SqlDbType.Int).Value = ChkIn.RoomNo;
                    command.Parameters.Add("@RoomId", SqlDbType.Int).Value = ChkIn.RoomId;
                    command.Parameters.Add("@BookingId", SqlDbType.Int).Value = ChkIn.BookingId;
                    command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                 /*   command.Parameters.Add("@TaxId", SqlDbType.Int).Value = ChkIn.TaxId;
                    command.Parameters.Add("@Male", SqlDbType.Int).Value = ChkIn.Male;
                    command.Parameters.Add("@Female", SqlDbType.Int).Value = ChkIn.Female;
                    command.Parameters.Add("@Tax", SqlDbType.Decimal).Value = ChkIn.Tax;
                    command.Parameters.Add("@Cess", SqlDbType.Decimal).Value = ChkIn.Cess;
                    command.Parameters.Add("@HECess", SqlDbType.Decimal).Value = ChkIn.HECess;
                    command.Parameters.Add("@ServiceTax", SqlDbType.Decimal).Value = ChkIn.Service;
                    command.Parameters.Add("@VAT", SqlDbType.Decimal).Value = ChkIn.VAT;
                    command.Parameters.Add("@Luxury", SqlDbType.Decimal).Value = ChkIn.Luxury;
                    command.Parameters.Add("@ExtraBed", SqlDbType.Decimal).Value = ChkIn.ExtraBed; */
                    
                   
                    ds = new WrbErpConnection().ExecuteDataSet(command, "");
                    
                    {
                        ds.Tables.Add(dTable);
                        return ds;
                    }
           }
                 public DataSet HelpResult(string[] data, User user)
                     {
                         string UserData;
                         SqlCommand command = new SqlCommand();
                         UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
                         command = new SqlCommand();
                         command.CommandText = StoredProcedures.CheckIn_Help;
                         command.CommandType = CommandType.StoredProcedure;
                         command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                         command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
                         // command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
                         command.Parameters.Add("@BookingId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
                         //command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
                         command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = 0;
                         command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = 0;
                         return new WrbErpConnection().ExecuteDataSet(command, UserData);
                       }
                  }
            }
        
    
    

