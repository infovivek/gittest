using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class KOTEntryUser
    {
        public int KOTEntryHdrId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int BreakfastVeg { get; set; }
        public int BreakfastNonVeg { get; set; }
        public int LunchVeg { get; set; }
        public int LunchNonVeg { get; set; }
        public int DinnerVeg { get; set; }
        public int DinnerNonVeg { get; set; }
        public int Id { get; set; }
        

    }
}
