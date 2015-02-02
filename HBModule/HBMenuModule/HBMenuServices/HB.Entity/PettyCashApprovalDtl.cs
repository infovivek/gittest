using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PettyCashApprovalDtl
    {
        public int PettyCashApprovalHdrId { get; set; }
        public bool Process { get; set; }
        public string RequestedOn { get; set; }
        public string Requestedby { get; set; }
        public string PCAccount { get; set; }
        public decimal RequestedAmount { get; set; }
        public string RequestedStatus { get; set; }
        public string ProcessedStatus { get; set; }
       // public string Status { get; set; }
        public string Processedon { get; set; }
        public string Comments { get; set; }
        public int RequestedUserId { get; set; }
        public int Id { get; set; }
        public int UserId { get; set; }
        public int PropertyId { get; set; }
    }
}
