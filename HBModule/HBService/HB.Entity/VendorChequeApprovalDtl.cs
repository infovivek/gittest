using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class VendorChequeApprovalDtl
    {
        public int VendorChequeApprovalHdrId { get; set; }
        public bool Process { get; set; }
        public string RequestedOn { get; set; }
        public string Requestedby { get; set; }
        public decimal RequestedAmount { get; set; }
        public string Status { get; set; }
        public string Processedby { get; set; }
        public string Processedon { get; set; }
        public int Id { get; set; }
        public int RequestedUserId { get; set; }
        public int PropertyId { get; set; }
    }
}
