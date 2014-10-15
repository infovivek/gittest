using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class TaxMapping
    {
        public int PropertyId { get; set; }
        public int Property{ get; set; }
        public string ServiceItem { get; set; }
        public int ItemId { get; set; }
        public bool VAT { get; set; }
        public bool LuxuryTax { get; set; }
        public bool ST1 { get; set; }
        public bool ST2 { get; set; }
        public bool ST3 { get; set; }
        public string Service { get; set; }
        public int Id { get; set; }
    }
}
