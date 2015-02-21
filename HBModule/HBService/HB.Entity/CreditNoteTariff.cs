using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class CreditNoteTariff
    {
        public string ChkInVoiceNo { get; set; }
        public string CrdInVoiceNo { get; set; }
        public string CreditNoteNo { get; set; }
        public decimal LuxuryTax { get; set; }
        public decimal ServiceTax1 { get; set; }
        public decimal ServiceTax2 { get; set; }
        public decimal TotalAmount { get; set; }
        public string Description { get; set; }
        public int ChkOutId { get; set; }
        public int PropertyId { get; set; }
        public int Id { get; set; }
        public int CrdTariffHdrId { get; set; }
        public string Type { get; set; }
        public decimal TariffAmount { get; set; }
        public int NoOfDays { get; set; }
        public decimal Total { get; set; }

    }
}
