using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PettyCashStatusEntity
    {
        public string ExpenseHead { get; set; }
        public string Status { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public decimal Paid { get; set; }
        public string FilePath { get; set; }
        public string BillDate { get; set; }
        public int Id { get; set; }
        public int UserId { get; set; }
        public int ExpenseId { get; set; } 
        public int PropertyId { get; set; }
    }
}
