using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractProductMaster
    {
        public int Id { get; set; }
        public string EffectiveFrom { get; set; }
        public bool ContractRate { get; set; }
        public bool IsComplimentary { get; set; }
        public string TypeService { get; set; }
        public string ProductName { get; set; }
        public decimal BasePrice { get; set; }
        public decimal PerQuantityprice { get; set; }
        public bool Enable { get; set; }
        public string SubType { get; set; }
        public int SubTypeId { get; set; }
    }
}
