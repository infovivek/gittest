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
    public class ReconcileDAO
    {
        String UserData; 
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet(); 
            ReconcileEntity RC = new ReconcileEntity();
            XmlDocument doc = new XmlDocument(); 
            doc.LoadXml(data[1]);
            int n;
            n = (doc).SelectNodes("//DtlsXml").Count;
            for (int i = 0; i < n; i++)
            {
                RC.Date = doc.SelectNodes("//DtlsXml")[i].Attributes["Date"].Value;
                RC.BillType = doc.SelectNodes("//DtlsXml")[i].Attributes["BillType"].Value;
                RC.PayType = doc.SelectNodes("//DtlsXml")[i].Attributes["PayType"].Value;
                RC.Invoicenumbr = doc.SelectNodes("//DtlsXml")[i].Attributes["InvoiceNo"].Value;
                RC.TransactionID =Convert.ToInt32(doc.SelectNodes("//DtlsXml")[i].Attributes["TransactionID"].Value);
                RC.TotalAmt =  Convert.ToDecimal(doc.SelectNodes("//DtlsXml")[i].Attributes["TotalAmt"].Value);
                RC.TransactionNumbr = doc.SelectNodes("//DtlsXml")[i].Attributes["TransactionNo"].Value;
                RC.TransactionAmt = Convert.ToDecimal(doc.SelectNodes("//DtlsXml")[i].Attributes["TransactionAmt"].Value);
                RC.InvoiceAmt =  doc.SelectNodes("//DtlsXml")[i].Attributes["InvoiceAmount"].Value;
                if (doc.SelectNodes("//DtlsXml")[i].Attributes["Id"].Value == "")
                {
                    RC.Id = 0;
                }
                else
                {
                    RC.Id = Convert.ToInt32(doc.SelectNodes("//DtlsXml")[i].Attributes["Id"].Value);
                }
                SqlCommand command = new SqlCommand();
                if (RC.Id != 0)
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                         "',SctId:" + user.SctId + ",Service:  ReconcileDAO  Update" + ",ProcName:'" +StoredProcedures.Reconcile_Update;

                   // command.CommandText = StoredProcedures.Reconcile_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = RC.Id;
                }
                else
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                          "',SctId:" + user.SctId + ",Service:  ReconcileDAO  Insert" + ",ProcName:'" + StoredProcedures.Reconcile_Insert;

                    command.CommandText = StoredProcedures.Reconcile_Insert;
                }

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@PayType", SqlDbType.NVarChar).Value =  RC.PayType;
                command.Parameters.Add("@TransactionNo", SqlDbType.NVarChar).Value = RC.TransactionNumbr;
                command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = RC.Invoicenumbr;
                command.Parameters.Add("@BillType", SqlDbType.NVarChar).Value = RC.BillType;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = RC.Date;

                command.Parameters.Add("@InvoiceAmount", SqlDbType.Decimal).Value = RC.InvoiceAmt; 
                command.Parameters.Add("@TransactionAmt",SqlDbType.Decimal).Value = RC.TransactionAmt; 
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                command.Parameters.Add("@TransactionID", SqlDbType.BigInt).Value = RC.TransactionID;
                command.Parameters.Add("@TotalAmt", SqlDbType.Decimal).Value = RC.TotalAmt; 

                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                //return ds;
            }
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                 "',SctId:" + user.SctId + ",Service:  VendorCostDAO  Select" + ",ProcName:'"  +StoredProcedures.Reconcile_Select;
         
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Reconcile_Select;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Datefrom",SqlDbType.NVarChar).Value=data[2].ToString();
            //command.Parameters.Add("@DateTo", SqlDbType.NVarChar).Value = data[3].ToString();
            //command.Parameters.Add("@TransactionId", SqlDbType.NVarChar).Value = data[4].ToString();
            //command.Parameters.Add("@ChequeNo", SqlDbType.NVarChar).Value = data[5].ToString();
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = data[6].ToString();
            //command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = data[7].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                 "',SctId:" + user.SctId + ",Service:  VendorCostDAO  Help" + ",ProcName:'" + StoredProcedures.Reconcile_Help;
         
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.Reconcile_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Datefrom", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@DateTo", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@TransactionId", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@ChequeNo", SqlDbType.NVarChar).Value = data[5].ToString();
            command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.Int).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = data[8].ToString();
            command.Parameters.Add("@Mode", SqlDbType.NVarChar).Value = data[9].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
