using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class BedBookingPropertyAssignedGuest
    {
        public string EmpCode { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int GuestId { get; set; }
        public string BedType { get; set; }
        public decimal Tariff { get; set; }
        public int RoomId { get; set; }
        public int BedId { get; set; }
        public int BookingPropertyId { get; set; }
        public int BookingPropertyTableId { get; set; }
        public int Id { get; set; }
        public int SSPId { get; set; }
        public string ServicePaymentMode { get; set; }
        public string TariffPaymentMode { get; set; }
        //
        public string Column1 { get; set; }
        public string Column2 { get; set; }
        public string Column3 { get; set; }
        public string Column4 { get; set; }
        public string Column5 { get; set; }
        public string Column6 { get; set; }
        public string Column7 { get; set; }
        public string Column8 { get; set; }
        public string Column9 { get; set; }
        public string Column10 { get; set; }
        public string BTCFilePath { get; set; }
        public int RoomCaptured { get; set; }
    }
}
