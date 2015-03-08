using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ProformainvoiceServiceDtls
    {
        public int Id { get; set; }
        public int CheckOutHdrId { get; set; }
        //public decimal ChkOutSerAction { get; set; }
        //public decimal ChkOutserInclude { get; set; }
        public string Date { get; set; }
        public string ServiceItem { get; set; }
        public decimal Amount { get; set; }
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public string TypeService { get; set; }
    }
}
