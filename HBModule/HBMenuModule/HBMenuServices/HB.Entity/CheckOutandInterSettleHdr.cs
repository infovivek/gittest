using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckOutandInterSettleHdr
    {
        public int Id { get; set; }
        public int CheckOutHdrId { get; set; }
        public string PayeeName { get; set; }
        public string Address { get; set; }
        public bool Consolidated { get; set; }
        public string EmailId { get; set; }
    }
}
