using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public  class MapPOAndVendorEntity
    {
       public decimal InvoiceAmount { get; set; }

       public string InvoiceDate { get; set; }

       public string InvoiceNo { get; set; }

       public string Property { get; set; }

       public long PropertyId { get; set; }

       public decimal TotalPOAmount { get; set; }

       public string FilePath { get; set; }

        public int HdrId { get; set; }

        public int CheckOutId { get; set; }

        public int BookingId { get; set; }


        public string PONo { get; set; }

        public string BookingCode { get; set; }

        public string BillNumber { get; set; }

        public decimal POAmount { get; set; }

        public decimal Adjustment { get; set; } 

        public decimal BillAmount { get; set; }

        public string GuestName { get; set; }

        public string StayDuration { get; set; }

        public int DtlsId { get; set; }
    }
}
