using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class VendorCost
    {
        public int VendorId { get; set; }
        public string EffectiveFrom { get; set; }
        public int ItemId { get; set; }
        public string ServiceItem { get; set; }
        public decimal Cost { get; set; }
        public int Id { get; set; }
        public int Flag { get; set; }
    }
}
