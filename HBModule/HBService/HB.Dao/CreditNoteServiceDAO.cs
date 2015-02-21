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
   public class CreditNoteServiceDAO
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
            CreditNoteServiceDtl Dep = new CreditNoteServiceDtl();
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
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["CrdInVoiceNo"].Value == "")
                {
                    Dep.CrdInVoiceNo = "";
                }
                else
                {
                    Dep.CrdInVoiceNo = doc.SelectNodes("//HdrXml1")[i].Attributes["CrdInVoiceNo"].Value;
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["VAT"].Value == "")
                {
                    Dep.VAT = 0;
                }
                else
                {
                    Dep.VAT = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["VAT"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTaxFB"].Value == "")
                {
                    Dep.ServiceTaxFB = 0;
                }
                else
                {
                    Dep.ServiceTaxFB = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTaxFB"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTaxOT"].Value == "")
                {
                    Dep.ServiceTaxOT = 0;
                }
                else
                {
                    Dep.ServiceTaxOT = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["ServiceTaxOT"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["Cess"].Value == "")
                {
                    Dep.Cess = 0;
                }
                else
                {
                    Dep.Cess = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["Cess"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["HECess"].Value == "")
                {
                    Dep.HECess = 0;
                }
                else
                {
                    Dep.HECess = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["HECess"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["TotalAmount"].Value == "")
                {
                    Dep.TotalAmount = 0;
                }
                else
                {
                    Dep.TotalAmount = Convert.ToDecimal(doc.SelectNodes("//HdrXml1")[i].Attributes["TotalAmount"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["Description"].Value == "")
                {
                    Dep.Description = "";
                }
                else
                {
                    Dep.Description = doc.SelectNodes("//HdrXml1")[i].Attributes["Description"].Value;
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["ChkOutId"].Value == "")
                {
                    Dep.ChkOutId = 0;
                }
                else
                {
                    Dep.ChkOutId = Convert.ToInt32(doc.SelectNodes("//HdrXml1")[i].Attributes["ChkOutId"].Value);
                }
                if (doc.SelectNodes("//HdrXml1")[i].Attributes["PropertyId"].Value == "")
                {
                    Dep.PropertyId = 0;
                }
                else
                {
                    Dep.PropertyId = Convert.ToInt32(doc.SelectNodes("//HdrXml1")[i].Attributes["PropertyId"].Value);
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
                "', SctId:" + user.SctId + ", Service:DepositDAO Insert" + ", ProcName:'" + StoredProcedures.CreditNoteServiceHdr_Insert;

                command.CommandText = StoredProcedures.CreditNoteServiceHdr_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ChkInVoiceNo", SqlDbType.NVarChar).Value = Dep.ChkInVoiceNo;
                command.Parameters.Add("@CrdInVoiceNo", SqlDbType.NVarChar).Value = Dep.CrdInVoiceNo;
                command.Parameters.Add("@CreditNoteNo", SqlDbType.Decimal).Value = Dep.CreditNoteNo;
                command.Parameters.Add("@VAT", SqlDbType.BigInt).Value = Dep.VAT;
                command.Parameters.Add("@ServiceTaxFB", SqlDbType.NVarChar).Value = Dep.ServiceTaxFB;
                command.Parameters.Add("@ServiceTaxOT", SqlDbType.BigInt).Value = Dep.ServiceTaxOT;
                command.Parameters.Add("@Cess", SqlDbType.NVarChar).Value = Dep.Cess;
                command.Parameters.Add("@HECess", SqlDbType.NVarChar).Value = Dep.HECess;
                command.Parameters.Add("@TotalAmount", SqlDbType.NVarChar).Value = Dep.TotalAmount;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Dep.Description;
                command.Parameters.Add("@ChkOutId", SqlDbType.Int).Value = Dep.ChkOutId;
                command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Dep.PropertyId;
                command.Parameters.Add("@Createdby", SqlDbType.NVarChar).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            }
            Dep.CrdServiceHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            doc = new XmlDocument();
            doc.LoadXml(data[2].ToString());
            n = (doc).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                command = new SqlCommand();
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Item"].Value == "")
                {
                    Dep.Item = "";
                }
                else
                {
                    Dep.Item = doc.SelectNodes("//HdrXml")[i].Attributes["Item"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["ServiceAmount"].Value == "")
                {
                    Dep.ServiceAmount = 0;
                }
                else
                {
                    Dep.ServiceAmount = Convert.ToDecimal(doc.SelectNodes("//HdrXml")[i].Attributes["ServiceAmount"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Quantity"].Value == "")
                {
                    Dep.Quantity = 0;
                }
                else
                {
                    Dep.Quantity = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["Quantity"].Value);
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

                command.CommandText = StoredProcedures.CreditNoteServiceDtl_Insert;
                command.Parameters.Add("@CrdServiceHdrId", SqlDbType.BigInt).Value = Dep.CrdServiceHdrId;
                command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = Dep.Item;
                command.Parameters.Add("@ServiceAmount", SqlDbType.Decimal).Value = Dep.ServiceAmount;
                command.Parameters.Add("@Quantity", SqlDbType.Decimal).Value = Dep.Quantity;
                command.Parameters.Add("@Total", SqlDbType.Decimal).Value = Dep.Total;

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
