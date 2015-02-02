using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class CheckOutSettleDtl
    {
        public int Id { get; set; }
        public int PropertyId { get; set; }
        public int GuestId { get; set; }
        public int BillNo { get; set; }
        public string BillType { get; set; }
        public decimal Amount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal OutStanding { get; set; }
        public string PaymentStatus { get; set; }
    }
}
