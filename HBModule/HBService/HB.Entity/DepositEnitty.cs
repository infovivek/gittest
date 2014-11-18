using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class DepositEnitty
    {
        public string Date { get; set; }
        public decimal Amount { get; set; }
        public int DepositeTo { get; set; }
        public int DepositeBy { get; set; }
        public string Comments { get; set; }
        public string Chalan { get; set; }
        public string Mode { get; set; }
        public int Id { get; set; }
        public string Image { get; set; }
        public int PId { get; set; }
        public string BookingCode { get; set; }
        public string InvoiceNo { get; set; }
       // public decimal Amount { get; set; }
        public string BTCTo { get; set; }
        public string BTCMode { get; set; }
        public decimal Total { get; set; }
        public string DoneBy { get; set; }
        public string ChequeNo { get; set; }
        public int ChkOutHdrId { get; set; }
        public int ClientId { get; set; }
        public int DepHdrId { get; set; }
        public int DepDtlId { get; set; }
        public string BillType { get; set; }
        public bool Tick { get; set; }
    }
}
