using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class VendorRequestDtl
    {
        public int VendorRequestHdrId { get; set; }
        public int ApartmentId { get; set; }
        public int RoomId { get; set; }
        public string Description { get; set; }
        public string FilePath { get; set; }
        public string BillNo { get; set; }
        public decimal Amount { get; set; }
        public int Id { get; set; }
    }
}
