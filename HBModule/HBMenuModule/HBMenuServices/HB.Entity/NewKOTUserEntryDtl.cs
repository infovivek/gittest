using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class NewKOTUserEntryDtl
    {
        public int NewKOTEntryHdrId { get; set; }
        public string ServiceItem { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public decimal Amount { get; set; }
        public int ItemId { get; set; }
        public int Id { get; set; }
    }
}
