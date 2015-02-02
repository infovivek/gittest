using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutPaymentCash
    {
        public int ChkOutHdrId { get; set; }

        public int Id { get; set; }

        public string Payment { get; set; }

        public string PayeeName { get; set; }

        public string PaymentMode { get; set; }

        public string Address { get; set; }

        public decimal AmountPaid { get; set; }

        public string CashReceivedOn { get; set; }

        public string CashReceivedBy { get; set; }

        public decimal OutStanding { get; set; }
        

    }
}
