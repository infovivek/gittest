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
    public class CreditNoteTariffDAO
    {
        String UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            DataTable dT1 = new DataTable("Table1");
            DataTable ErrdT1 = new DataTable("DBERRORTBL1");
           
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            CreditNoteTariff Dep = new CreditNoteTariff();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1].ToString());


            int n;
            n = (doc).SelectNodes("//HdrXml1").Count;
            for (int i = 0; i < n; i++)
            {
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["ChkInVoiceNo"].Value == "")
                {
                    Dep.ChkInVoiceNo = "";
                }
                else
                {
                    Dep.ChkInVoiceNo = doc.SelectNodes("//HdrXml1")[i].Attributes["ChkInVoiceNo"].Value;
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["CreditNoteNo"].Value == "")
                {
                    Dep.CreditNoteNo = "";
                }
                else
                {
                    Dep.CreditNoteNo = doc.SelectNodes("//HdrXml1")[i].Attributes["CreditNoteNo"].Value;
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["LuxuryTax"].Value == "")
                {
                    Dep.LuxuryTax = 0;
                }
                else
                {
                    Dep.LuxuryTax = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["LuxuryTax"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTax1"].Value == "")
                {
                    Dep.ServiceTax1 = 0;
                }
                else
                {
                    Dep.ServiceTax1 = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTax1"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["ServiceTax2"].Value == "")
                {
                    Dep.ServiceTax2 = 0;
                }
                else
                {
                    Dep.ServiceTax2 = Convert.ToDecimal(doc.SelectNodes("//HdrXml")[i].Attributes["ServiceTax2"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["TotalAmount"].Value == "")
                {
                    Dep.TotalAmount = 0;
                }
                else
                {
                    Dep.TotalAmount = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["TotalAmount"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["Id"].Value == "")
                {
                    Dep.Id = 0;
                }
                else
                {
                    Dep.Id = Convert.ToInt32(doc.SelectNodes("//HdrXml1")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:DepositDAO Insert" + ", ProcName:'" + StoredProcedures.Deposit_Insert;

                command.CommandText = StoredProcedures.Deposit_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ChkInVoiceNo", SqlDbType.NVarChar).Value = Dep.ChkInVoiceNo;
                command.Parameters.Add("@CreditNoteNo", SqlDbType.NVarChar).Value = Dep.CreditNoteNo;
                command.Parameters.Add("@LuxuryTax", SqlDbType.Decimal).Value = Dep.LuxuryTax;
                command.Parameters.Add("@ServiceTax1", SqlDbType.Decimal).Value = Dep.ServiceTax1;
                command.Parameters.Add("@ServiceTax2", SqlDbType.Decimal).Value = Dep.ServiceTax2;
                command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = Dep.TotalAmount;
                command.Parameters.Add("@Createdby", SqlDbType.Int).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            }
            Dep.CrdTariffHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            doc = new XmlDocument();
            doc.LoadXml(data[2].ToString());
            n = (doc).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                command = new SqlCommand();
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Type"].Value == "")
                {
                    Dep.Type ="";
                }
                else
                {
                    Dep.Type = doc.SelectNodes("//HdrXml")[i].Attributes["Type"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value == "")
                {
                    Dep.Amount = 0;
                }
                else
                {
                    Dep.Amount = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["NoOfDays"].Value == "")
                {
                    Dep.NoOfDays = 0;
                }
                else
                {
                    Dep.NoOfDays = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["NoOfDays"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Total"].Value == "")
                {
                    Dep.Total = 0;
                }
                else
                {
                    Dep.Total = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["Total"].Value);
                }
                command.CommandType = CommandType.StoredProcedure;
              
                    command.CommandText = StoredProcedures.DtlDeposit_Insert;
                    command.Parameters.Add("@CrdTariffHdrId", SqlDbType.BigInt).Value = Dep.CrdTariffHdrId;
                    command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = Dep.Type;
                    command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Dep.Amount;
                    command.Parameters.Add("@NoOfDays", SqlDbType.NVarChar).Value = Dep.NoOfDays;
                    command.Parameters.Add("@Total", SqlDbType.BigInt).Value = Dep.Total;
                    command.Parameters.Add("@Createdby", SqlDbType.Bit).Value = user.Id;
                                    
                    DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                    if (ds1.Tables[0].Rows.Count > 0)
                    {
                        //dT.Rows.Add(ds1.Tables[0].Rows[0][0].ToString());
                    }
               }
            return ds;
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:DepositDAO Help" + ", ProcName:'" + StoredProcedures.Deposit_Help;

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = StoredProcedures.Deposit_Help;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
