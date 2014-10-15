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
    public class DepositDAO
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
            DepositEnitty Dep = new DepositEnitty();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1].ToString());
           

            int n;
            n = (doc).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Id"].Value == "")
                {
                    Dep.Id = 0;
                }
                else
                {
                    Dep.Id = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["Id"].Value);
                }

                if (doc.SelectNodes("//HdrXml")[i].Attributes["Date"].Value == "")
                {
                    Dep.Date = "";
                }
                else
                {
                    Dep.Date = doc.SelectNodes("//HdrXml")[i].Attributes["Date"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value == "")
                {
                    Dep.Amount = 0;
                }
                else
                {
                    Dep.Amount = Convert.ToDecimal(doc.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["AccountId"].Value == "")
                {
                    Dep.DepositeTo = 0;
                }
                else
                {
                    Dep.DepositeTo = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["AccountId"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Comments"].Value == "")
                {
                    Dep.Comments = "";
                }
                else
                {
                    Dep.Comments = doc.SelectNodes("//HdrXml")[i].Attributes["Comments"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Chalan"].Value == "")
                {
                    Dep.Chalan = "";
                }
                else
                {
                    Dep.Chalan = doc.SelectNodes("//HdrXml")[i].Attributes["Chalan"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Mode"].Value == "")
                {
                    Dep.Mode = "";
                }
                else
                {
                    Dep.Mode = doc.SelectNodes("//HdrXml")[i].Attributes["Mode"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Image"].Value == "")
                {
                    Dep.Image = "";
                }
                else
                {
                    Dep.Image = doc.SelectNodes("//HdrXml")[i].Attributes["Image"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["PropertyId"].Value == "")
                {
                    Dep.PId = 0;
                }
                else
                {
                    Dep.PId = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["PropertyId"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["BTCTo"].Value == "")
                {
                    Dep.BTCTo = "";
                }
                else
                {
                    Dep.BTCTo = doc.SelectNodes("//HdrXml")[i].Attributes["BTCTo"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["BTCMode"].Value == "")
                {
                    Dep.BTCMode = "";
                }
                else
                {
                    Dep.BTCMode = doc.SelectNodes("//HdrXml")[i].Attributes["BTCMode"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Total"].Value == "")
                {
                    Dep.Total = 0;
                }
                else
                {
                    Dep.Total = Convert.ToDecimal(doc.SelectNodes("//HdrXml")[i].Attributes["Total"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["DoneBy"].Value == "")
                {
                    Dep.DoneBy = "";
                }
                else
                {
                    Dep.DoneBy = doc.SelectNodes("//HdrXml")[i].Attributes["DoneBy"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["ChequeNo"].Value == "")
                {
                    Dep.ChequeNo = "";
                }
                else
                {
                    Dep.ChequeNo = doc.SelectNodes("//HdrXml")[i].Attributes["ChequeNo"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["ClientId"].Value == "")
                {
                    Dep.ClientId = 0;
                }
                else
                {
                    Dep.ClientId = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["ClientId"].Value);
                }
                command = new SqlCommand();
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:DepositDAO Insert" + ", ProcName:'" + StoredProcedures.Deposit_Insert;

                command.CommandText = StoredProcedures.Deposit_Insert;

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = Dep.Date;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Dep.Amount;
                command.Parameters.Add("@DepositeToId", SqlDbType.BigInt).Value = Dep.DepositeTo;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = Dep.Comments;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                command.Parameters.Add("@ChalanImage", SqlDbType.NVarChar).Value = data[2].ToString();
                command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = Dep.Mode;
                command.Parameters.Add("@ImageName", SqlDbType.NVarChar).Value = Dep.Image;
                command.Parameters.Add("@PId", SqlDbType.BigInt).Value = Dep.PId;
                command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = "";
                command.Parameters.Add("@TotalAmount", SqlDbType.Decimal).Value = Dep.Total;
                command.Parameters.Add("BTCTo", SqlDbType.NVarChar).Value = Dep.BTCTo;
                command.Parameters.Add("@BTCMode", SqlDbType.NVarChar).Value = Dep.BTCMode;
                command.Parameters.Add("@DoneBy", SqlDbType.NVarChar).Value = Dep.DoneBy;
                command.Parameters.Add("@ChequeNo", SqlDbType.NVarChar).Value = Dep.ChequeNo;
                command.Parameters.Add("@ChkOutHdrId", SqlDbType.NVarChar).Value = Dep.ChkOutHdrId;
                command.Parameters.Add("@ClientId", SqlDbType.NVarChar).Value = Dep.ClientId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                }
                Dep.DepHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                doc = new XmlDocument();
                Dep.DepDtlId = 0;
                doc.LoadXml(data[3].ToString());
                n = (doc).SelectNodes("//DepDtls").Count;
                for (int i = 0; i < n; i++)
                {
                    command = new SqlCommand();
                    Dep.DepDtlId = Convert.ToInt32(doc.SelectNodes("//DepDtls")[i].Attributes["Id"].Value);
                    Dep.InvoiceNo = doc.SelectNodes("//DepDtls")[i].Attributes["InvoiceNo"].Value;
                    Dep.Amount = Convert.ToDecimal(doc.SelectNodes("//DepDtls")[i].Attributes["Amount"].Value);
                    Dep.Tick = Convert.ToInt32(doc.SelectNodes("//DepDtls")[i].Attributes["Tick"].Value);
                    if (doc.SelectNodes("//DepDtls")[i].Attributes["ClientId"].Value == "")
                    {
                        Dep.ClientId = 0;
                    }
                    else
                    {
                        Dep.ClientId = Convert.ToInt32(doc.SelectNodes("//DepDtls")[i].Attributes["ClientId"].Value);
                    }

                    Dep.BillType = doc.SelectNodes("//DepDtls")[i].Attributes["BillType"].Value;
                    Dep.ChkOutHdrId = Convert.ToInt32(doc.SelectNodes("//DepDtls")[i].Attributes["ChkOutHdrId"].Value);

                    command.CommandType = CommandType.StoredProcedure;
                    if (Dep.DepDtlId == 0)
                    {
                        command.CommandText = StoredProcedures.DtlDeposit_Insert;
                        command.Parameters.Add("@DepHdrId", SqlDbType.BigInt).Value = Dep.DepHdrId;
                        command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = Dep.InvoiceNo;
                        command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Dep.Amount;
                        command.Parameters.Add("@BillType", SqlDbType.NVarChar).Value = Dep.BillType;
                        command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Dep.ClientId;
                        command.Parameters.Add("@Tick", SqlDbType.Bit).Value = Dep.Tick;
                        command.Parameters.Add("@ChkOutHdrId", SqlDbType.BigInt).Value = Dep.ChkOutHdrId;
                        // ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                        DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            //dT.Rows.Add(ds1.Tables[0].Rows[0][0].ToString());
                        }

                    }
                }
                //ds.Tables.Add(dT1);
                //ds.Tables.Add(ErrdT1);
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
        public DataSet Delete(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:DepositDAO " + ", ProcName:'";// +StoredProcedures.; 

            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:DepositDAO " + ", ProcName:'";// + StoredProcedures.; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Deposit_Search;
            command.CommandType = CommandType.StoredProcedure;
           
            if (data[2] == null)
            {
                command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = "";
            }
            else
            {
                command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[2].ToString();
            }
            if (data[3] == null)
            {
                command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = "";
            }
            else
            {
                command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[3].ToString();
            }
            if (data[2] == null)
            {
                command.Parameters.Add("@Id", SqlDbType.NVarChar).Value = "";
            }
            else
            {
                command.Parameters.Add("@Id", SqlDbType.NVarChar).Value = data[1].ToString();
            }
            command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = data[4].ToString();
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
