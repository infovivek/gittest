using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ReconcileEntity
    {
        public int Id { get; set; }
        public string InvoiceAmt { get; set; }
        public decimal TransactionAmt { get; set; }

        public string BillType { get; set; }  
        public string PayType { get; set; }
        public string Invoicenumbr { get; set; }
        public string TransactionNumbr { get; set; }
        public string Date { get; set; }

        public int TransactionID { get; set; }
        public decimal TotalAmt { get; set; }
    }
}
