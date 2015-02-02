using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractNondedicatedService
    {
        public string EffectiveFrom { get; set; }
        public bool Complimentary { get; set; }
        public string ServiceName { get; set; }
        public decimal Price { get; set; }
        public bool Enable { get; set; }
        public int ProductId { get; set; }
        public int Id { get; set; } 
        public bool AmountChange { get; set; }
        public string TypeService { get; set; } 
    }
}
