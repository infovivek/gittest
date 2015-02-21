using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class CreditNoteServiceDtl 
    {
        public string ChkInVoiceNo { get; set; }
        public string CrdInVoiceNo { get; set; }
        public string CreditNoteNo { get; set; }
        public decimal VAT { get; set; }
        public decimal ServiceTaxFB { get; set; }
        public decimal ServiceTaxOT { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public decimal TotalAmount { get; set; }
        public string Description { get; set; }
        public int ChkOutId { get; set; }
        public int PropertyId { get; set; }
        public int Id { get; set; }
        public int CrdServiceHdrId { get; set; }
        public string Item { get; set; }
        public decimal ServiceAmount { get; set; }
        public int Quantity { get; set; }
        public decimal Total { get; set; }
    }
}
