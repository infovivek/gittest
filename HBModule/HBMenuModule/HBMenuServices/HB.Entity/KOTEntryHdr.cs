using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class KOTEntryHdr
    {
        public int PropertyId { get; set; }

        public int BookingId { get; set; }
        public int CheckInId { get; set; }
        public string PropertyName { get; set; }

        public string Date { get; set; }

        public int Id { get; set; }
    }
}
