using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ApprovedPettyCash
    {
        public string RequestedOn { get; set; }
        public string Description { get; set; }
        public string ExpenseHead { get; set; }
        public decimal RequestedAmount { get; set; }
        public decimal ApprovedAmount { get; set; }
        public string Comments { get; set; }
        public int Id { get; set; }
      //  public decimal Total { get; set; }
        public int ExpenseGroupId { get; set; }
        public int PropertyId { get; set; }
        public int UserId { get; set; }
    }
}
