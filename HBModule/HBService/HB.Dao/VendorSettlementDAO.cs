using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
namespace HB.Dao
{
  public  class VendorSettlementDAO
    {
       String UserData;
       public DataSet Save(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(data[1].ToString());

           //Header Insert
           VendorSettlementEntity VendoSettle = new VendorSettlementEntity();
           var PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);

           document = new XmlDocument();
           document.LoadXml(data[2].ToString());
            int n;
            int HdrId = 0;
           //ADJUSMENT INVOICE AMOUNT 
           n = (document).SelectNodes("//DtlsXml").Count;
           for (int i = 0; i < n; i++)
           {
               VendoSettle = new VendorSettlementEntity();
               VendoSettle.InvoiceId = Convert.ToInt32(document.SelectNodes("//DtlsXml")[i].Attributes["InvoiceId"].Value);
               VendoSettle.InvoiceNo = document.SelectNodes("//DtlsXml")[i].Attributes["InvoiceNo"].Value;
               VendoSettle.InvoiceDate = document.SelectNodes("//DtlsXml")[i].Attributes["InvoiceDate"].Value;
               VendoSettle.InvoiceAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["InvoiceAmount"].Value);
               VendoSettle.Status = document.SelectNodes("//DtlsXml")[i].Attributes["Status"].Value;
               VendoSettle.POCount = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["POCount"].Value);
               VendoSettle.AdjusmentInvoice = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["Adjusment"].Value);
               VendoSettle.checks = document.SelectNodes("//DtlsXml")[i].Attributes["checks"].Value; 
             


               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:VendorSettlementInvoiceAmount DAO Insert" + ",ProcName:'" +
               StoredProcedures.VendorSettlementInvoiceAmount_Insert;

               command = new SqlCommand();
               command.CommandText = StoredProcedures.VendorSettlementInvoiceAmount_Insert;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@HdrId", SqlDbType.BigInt).Value = HdrId;
               command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PropertyId;
               command.Parameters.Add("@InvoiceId", SqlDbType.BigInt).Value = VendoSettle.InvoiceId;
               command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = VendoSettle.InvoiceNo;
               command.Parameters.Add("@InvoiceDate", SqlDbType.NVarChar).Value = VendoSettle.InvoiceDate;
               command.Parameters.Add("@InvoiceAmount", SqlDbType.Decimal).Value = VendoSettle.InvoiceAmount;               
               command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = VendoSettle.Status;
               command.Parameters.Add("@POCount", SqlDbType.Decimal).Value = VendoSettle.POCount;
               command.Parameters.Add("@Adjusment", SqlDbType.Decimal).Value = VendoSettle.AdjusmentInvoice;            
               command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
               command.Parameters.Add("@Flag", SqlDbType.NVarChar).Value = "Adjusment Invoice Amount";

               if (VendoSettle.checks == "true")
               {
                   ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                   if (ds.Tables[0].Rows.Count != 0)
                   {
                       HdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                   }
               }
               
           }

           //TAC ADJUSMENT INVOICE AMOUNT
           document = new XmlDocument();
           document.LoadXml(data[3].ToString());
           n = (document).SelectNodes("//DtlsXml1").Count;
           for (int i = 0; i < n; i++)
           {
               VendoSettle = new VendorSettlementEntity();
               VendoSettle.TACId = Convert.ToInt32(document.SelectNodes("//DtlsXml1")[i].Attributes["TACId"].Value);
               VendoSettle.TACInvoiceNo = document.SelectNodes("//DtlsXml1")[i].Attributes["TACInvoiceNo"].Value;
               VendoSettle.BillDate = document.SelectNodes("//DtlsXml1")[i].Attributes["BillDate"].Value;
               VendoSettle.TACAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml1")[i].Attributes["TACAmount"].Value);
               VendoSettle.TotalBusinessSupportST = Convert.ToDecimal( document.SelectNodes("//DtlsXml1")[i].Attributes["TotalBusinessSupportST"].Value);
               VendoSettle.Total = Convert.ToDecimal(document.SelectNodes("//DtlsXml1")[i].Attributes["Total"].Value);
               VendoSettle.AdjusementAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml1")[i].Attributes["AdjusementAmount"].Value);
               VendoSettle.Adjusment = Convert.ToDecimal(document.SelectNodes("//DtlsXml1")[i].Attributes["Adjusment"].Value);
               VendoSettle.checks = document.SelectNodes("//DtlsXml1")[i].Attributes["checks"].Value; 


               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:VendorSettlementTACInvoiceAmount_Insert" + ",ProcName:'" +
               StoredProcedures.VendorSettlementTACInvoiceAmount_Insert;

               command = new SqlCommand();
               command.CommandText = StoredProcedures.VendorSettlementTACInvoiceAmount_Insert;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@HdrId", SqlDbType.BigInt).Value = HdrId;
               command.Parameters.Add("@TACId", SqlDbType.BigInt).Value = VendoSettle.TACId;
               command.Parameters.Add("@TACInvoiceNo", SqlDbType.NVarChar).Value = VendoSettle.TACInvoiceNo;
               command.Parameters.Add("@BillDate", SqlDbType.NVarChar).Value = VendoSettle.BillDate;
               command.Parameters.Add("@TACAmount", SqlDbType.Decimal).Value = VendoSettle.TACAmount;
               command.Parameters.Add("@TotalBusinessSupportST", SqlDbType.Decimal).Value = VendoSettle.TotalBusinessSupportST;
               command.Parameters.Add("@Total", SqlDbType.Decimal).Value = VendoSettle.Total;
               command.Parameters.Add("@AdjusementAmount", SqlDbType.Decimal).Value = VendoSettle.AdjusementAmount;
               command.Parameters.Add("@Adjusment", SqlDbType.Decimal).Value = VendoSettle.Adjusment;
               command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

               if (VendoSettle.checks == "true")
               {
                   ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                   if (ds.Tables[0].Rows.Count != 0)
                   {
                       HdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                   }
               }
              
           }

           //REAMAINNING INVOICE AMOUNT TO BE PAID
         
           document = new XmlDocument();
           document.LoadXml(data[4].ToString());
           n = (document).SelectNodes("//DtlsXml2").Count;
           for (int i = 0; i < n; i++)
           {
               VendoSettle = new VendorSettlementEntity();
               VendoSettle.InvoiceId = Convert.ToInt32(document.SelectNodes("//DtlsXml2")[i].Attributes["InvoiceId"].Value);
               VendoSettle.InvoiceNo = document.SelectNodes("//DtlsXml2")[i].Attributes["InvoiceNo"].Value;
               VendoSettle.InvoiceDate = document.SelectNodes("//DtlsXml2")[i].Attributes["InvoiceDate"].Value;
               VendoSettle.InvoiceAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml2")[i].Attributes["InvoiceAmount"].Value);
               VendoSettle.Status = document.SelectNodes("//DtlsXml2")[i].Attributes["Status"].Value;
               VendoSettle.POCount = Convert.ToDecimal(document.SelectNodes("//DtlsXml2")[i].Attributes["POCount"].Value);
               VendoSettle.AdjusmentInvoice = Convert.ToDecimal(document.SelectNodes("//DtlsXml2")[i].Attributes["PaidAmount"].Value);
               VendoSettle.checks = document.SelectNodes("//DtlsXml2")[i].Attributes["checks"].Value;



               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:VendorSettlementInvoiceAmount DAO Insert" + ",ProcName:'" +
               StoredProcedures.VendorSettlementInvoiceAmount_Insert;

               command = new SqlCommand();
               command.CommandText = StoredProcedures.VendorSettlementInvoiceAmount_Insert;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@HdrId", SqlDbType.BigInt).Value = HdrId;
               command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PropertyId;
               command.Parameters.Add("@InvoiceId", SqlDbType.BigInt).Value = VendoSettle.InvoiceId;
               command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = VendoSettle.InvoiceNo;
               command.Parameters.Add("@InvoiceDate", SqlDbType.NVarChar).Value = VendoSettle.InvoiceDate;
               command.Parameters.Add("@InvoiceAmount", SqlDbType.Decimal).Value = VendoSettle.InvoiceAmount;
               command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = VendoSettle.Status;
               command.Parameters.Add("@POCount", SqlDbType.Decimal).Value = VendoSettle.POCount;
               command.Parameters.Add("@Adjusment", SqlDbType.Decimal).Value = VendoSettle.AdjusmentInvoice;
               command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
               command.Parameters.Add("@Flag", SqlDbType.NVarChar).Value = "Paid Amount";


               if (VendoSettle.checks == "true")
               {
                   ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                   if (ds.Tables[0].Rows.Count != 0)
                   {
                       HdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                   }
               }

           }
          
           
           //ADJUSMENT ADVANCE TO BE SAVE
           document = new XmlDocument();
           document.LoadXml(data[5].ToString());
           n = (document).SelectNodes("//DtlsXml3").Count;
           for (int i = 0; i < n; i++)
           {
               VendoSettle = new VendorSettlementEntity();
               VendoSettle.VendorAdvancePaymentId = Convert.ToInt32(document.SelectNodes("//DtlsXml3")[i].Attributes["Id"].Value);
               VendoSettle.AdvanceAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml3")[i].Attributes["AdvanceAmount"].Value);
               VendoSettle.AdjusementAdvanceAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml3")[i].Attributes["AdjusmentAmount"].Value);



               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", VendorSettlementAdjusmentAdvanceAmount_Insert DAO Insert" + ",ProcName:'" +
               StoredProcedures.VendorSettlementAdjusmentAdvanceAmount_Insert;

               command = new SqlCommand();
               command.CommandText = StoredProcedures.VendorSettlementAdjusmentAdvanceAmount_Insert;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@HdrId", SqlDbType.BigInt).Value = HdrId;
               command.Parameters.Add("@VendorAdvancePaymentId", SqlDbType.BigInt).Value = VendoSettle.VendorAdvancePaymentId;
               command.Parameters.Add("@AdvanceAmount", SqlDbType.Decimal).Value = VendoSettle.AdvanceAmount;
               command.Parameters.Add("@AdjusementAmount", SqlDbType.Decimal).Value = VendoSettle.AdjusementAdvanceAmount;
               command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

               if (VendoSettle.AdjusementAdvanceAmount != 0)
               {
                   ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                   if (ds.Tables[0].Rows.Count != 0)
                   {
                       HdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                   }
               }
               

           }

           //PAY DETAILS
           document = new XmlDocument();
           document.LoadXml(data[6].ToString());
           n = (document).SelectNodes("DtlsXml4").Count;
           VendoSettle = new VendorSettlementEntity();
           if (document.SelectSingleNode("DtlsXml4").Attributes["AdjustAdvance"].Value == "")
           {
               VendoSettle.AdjustAdvance = 0;
           }
           else
           {
               VendoSettle.AdjustAdvance = Convert.ToDecimal(document.SelectSingleNode("DtlsXml4").Attributes["AdjustAdvance"].Value);
           }

           VendoSettle.DateofPayment = document.SelectSingleNode("DtlsXml4").Attributes["DateofPayment"].Value;
           VendoSettle.AmountPaid = Convert.ToDecimal(document.SelectSingleNode("DtlsXml4").Attributes["AmountPaid"].Value);
           VendoSettle.BankName = document.SelectSingleNode("DtlsXml4").Attributes["BankName"].Value;
           VendoSettle.ChequeNumber = document.SelectSingleNode("DtlsXml4").Attributes["ChequeNumber"].Value;
           VendoSettle.Issuedate = document.SelectSingleNode("DtlsXml4").Attributes["Issuedate"].Value;
           VendoSettle.PaymentMode = document.SelectSingleNode("DtlsXml4").Attributes["PaymentMode"].Value;
          


           UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:VendorSettlementPaidAmount_Insert DAO Insert" + ", ProcName:'"
                   + StoredProcedures.VendorSettlementPaidAmount_Insert;
           command = new SqlCommand();
           command.CommandText = StoredProcedures.VendorSettlementPaidAmount_Insert;           
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@HdrId", SqlDbType.BigInt).Value = HdrId;
           command.Parameters.Add("@AdjustAdvance", SqlDbType.Decimal).Value = VendoSettle.AdjustAdvance;           
           command.Parameters.Add("@DateofPayment", SqlDbType.NVarChar).Value = VendoSettle.DateofPayment;
           command.Parameters.Add("@AmountPaid", SqlDbType.Decimal).Value = VendoSettle.AmountPaid;
           command.Parameters.Add("@BankName", SqlDbType.NVarChar).Value = VendoSettle.BankName;
           command.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = VendoSettle.ChequeNumber;
           command.Parameters.Add("@IssueDate", SqlDbType.NVarChar).Value = VendoSettle.Issuedate;
           command.Parameters.Add("@PaymentMode", SqlDbType.NVarChar).Value = VendoSettle.PaymentMode;
           command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

           ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

         
           return ds;
       }
    }
}
