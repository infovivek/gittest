using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class NewKOTUserEntryHdr
    {
        public int PropertyId { get; set; }
        public string PropertyName { get; set; }
        public string Date { get; set; }
        public string UserName { get; set; }
        public int UserId { get; set; }
        public string GetType { get; set; }
        public decimal TotalAmount { get; set; }
        public int Id { get; set; }
    }
}
