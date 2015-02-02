using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutPaymentCard
    {
        public int Id { get; set; }

        public int ChkOutHdrId { get; set; }

        public string Payment { get; set; }

        public string PayeeName { get; set; }

        public string Address { get; set; }

        public decimal AmountPaid { get; set; }

        public string PaymentMode { get; set; }

        public string CardDetails { get; set; }

        public string CCBrand { get; set; }

        public string NameoftheCard { get; set; }

        public string CreditCardNo { get; set; }

        public string ExpiryOn { get; set; }

        public string ROC { get; set; }

        public string SOCBatchCloseNo { get; set; }

        public string AmountSwipedFor { get; set; }

        public int ExpiryMonth { get; set; }

        public int ExpiryYear { get; set; }

        public decimal OutStanding { get; set; }

         
    }
}
