using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class ProformainvoiceServicehdr
    {
        public int Id { get; set; }
        public int CheckOutHdrId { get; set; }
        public decimal ChkOutServiceAmtl { get; set; }
        public decimal ChkOutServiceVat { get; set; }
        public decimal ChkOutServiceST { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public decimal OtherService { get; set; }
        public decimal NetAmount { get; set; }
        public string MiscellaneousRemarks { get; set; }
        public decimal MiscellaneousAmount { get; set; }
    }
}
