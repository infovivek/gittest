using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class VendorSettlementEntity
    {
        public long PropertyId { get; set; }
        public int TACId { get; set; }
        public string TACInvoiceNo { get; set; }
        public string BillDate { get; set; }
        public decimal TACAmount { get; set; }
        public decimal TotalBusinessSupportST { get; set; }
        public decimal Total { get; set; }
        public decimal AdjusementAmount { get; set; }
        public decimal Adjusment { get; set; }
        public string checks { get; set; }

        public int InvoiceId { get; set; }
        public string InvoiceNo { get; set; }
        public string InvoiceDate { get; set; }
        public decimal InvoiceAmount { get; set; }
        public string Status { get; set; }
        public decimal POCount { get; set; }
        public decimal AdjusmentInvoice { get; set; }

       
        public string PaymentMode { get; set; }
        public string DateofPayment { get; set; }
        public decimal AdjustAdvance { get; set; }
        public string BankName { get; set; }
        public decimal AmountPaid { get; set; }
        public string ChequeNumber { get; set; }
        public string Issuedate { get; set; }



        public int VendorAdvancePaymentId { get; set; }
        public decimal AdjusementAdvanceAmount { get; set; }
        public decimal AdvanceAmount { get; set; }
        
    }
}
