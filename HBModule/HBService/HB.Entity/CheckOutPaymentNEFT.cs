using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutPaymentNEFT
    {
        public int Id { get; set; }

        public int ChkOutHdrId { get; set; }

        public string Payment { get; set; }

        public string PayeeName { get; set; }

        public string Address { get; set; }

        public decimal AmountPaid { get; set; }

        public string PaymentMode { get; set; }

        public string ReferenceNumber { get; set; }

        public string DateofNEFT { get; set; }

        public string BankName { get; set; }

        public int DateNEFTMonth { get; set; }

        public int DateNEFTYear { get; set; }

        public decimal OutStanding { get; set; }

    }
}
