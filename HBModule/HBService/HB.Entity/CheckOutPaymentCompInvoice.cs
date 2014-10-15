using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutPaymentCompInvoice
    {
        public int Id { get; set; }

        public int ChkOutHdrId { get; set; }

        public string Payment { get; set; }

        public string PayeeName { get; set; }

        public string Address { get; set; }

        public decimal AmountPaid { get; set; }

        public string PaymentMode { get; set; }

        public string Approver { get; set; }

        public string Requester { get; set; }

        public string EmailId { get; set; }

        public string PhoneNo { get; set; }

        public string FileLoad { get; set; }

        public decimal OutStanding { get; set; }

    }
}
