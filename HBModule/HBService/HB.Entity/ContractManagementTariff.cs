using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractManagementTariff
    {
        public string EffectiveFrom { get; set; }
        public string EffectiveTo { get; set; }
        public decimal TarrifPrice { get; set; }
        public int Id { get; set; }
        public String TariffChk   { get; set; }
        public String BookLevel { get; set; }
    }
}
