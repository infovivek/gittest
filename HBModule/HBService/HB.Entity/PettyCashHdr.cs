using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PettyCashHdr
    {
        public int  PropertyId {get;set;}
        public int  UserId {get;set;}
        public string  Date {get;set;}
        public Decimal  Total {get;set;}
        public int ExpenseGroupId { get; set; }
        public Decimal OpeningBalance { get; set; }
        public int Id { get; set; }
             
    }
}
