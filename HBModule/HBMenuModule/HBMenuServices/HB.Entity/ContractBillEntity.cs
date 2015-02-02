using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractBillEntity
    {
        public decimal LTTax { get; set; }
        public decimal STTax { get; set; }
        public decimal Cess { get; set; }
        public decimal HCess { get; set; }
        public decimal LTPer { get; set; }
        public decimal STPer { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AdjustmentAmount { get; set; }
        public string Attention { get; set; }
        public string ReferenceNo { get; set; }
        public string Remarks { get; set; }
        public string DueDate { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int ContractId { get; set; }
        public int Id { get; set; }
    }
}
