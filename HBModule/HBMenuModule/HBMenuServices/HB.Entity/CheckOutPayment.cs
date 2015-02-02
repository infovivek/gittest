using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutPayment
    {
        public int Id { get; set; }
        public int CheckOutHdrId { get; set; }
        public string PayeeName { get; set; }
        public string Address { get; set; }
        public decimal AmountPaid { get; set; }
        public string SettlementStatus { get; set; }
        public string PaymentMode { get; set; }
        public string Payment { get; set; }
    }
}
