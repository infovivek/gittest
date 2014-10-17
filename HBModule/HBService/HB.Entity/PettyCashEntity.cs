using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PettyCashEntity
    {
        public int PettyCashHdrId { get; set; }
        public string Description { get; set; }
        public string ExpenseHead { get; set; }
        public int ExpenseId { get; set; }
        public decimal Amount { get; set; }
        public int Id { get; set; }
       
    }
}
