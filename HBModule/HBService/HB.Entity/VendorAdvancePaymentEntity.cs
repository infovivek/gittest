using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class VendorAdvancePaymentEntity
    {
        public decimal AdvanceAmount { get; set; }

        public string DateofPayment { get; set; }

        public string Comments { get; set; }

        public string PropertyName { get; set; }

        public int PropertyId { get; set; }

        public string PaymentMode { get; set; }

        public string BankName { get; set; }

        public string ChequeNumber { get; set; }

        public string IssueDate { get; set; }

        public int Id { get; set; }

    }
}
