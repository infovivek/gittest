using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractNonDedicated
    {
        public string CreatedBy { get; set; }
        public string ContractType { get; set; }
        public string ContractName { get; set; }
        public string Property { get; set; }
        public string ClientName { get; set; }

        public int PropertyId { get; set; }
        public int ClientId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int Id { get; set; }
        public string TransName { get; set; }
        public int TransId { get; set; }

        public string Types { get; set; }
        public string PricingModel { get; set; } 
 
    }
}
