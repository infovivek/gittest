using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckInRollback
    {
        public int Id { get; set; }
        public int RoomId { get; set; }
        public Int64 PropertyId { get; set; }
        public int BookingId { get; set; }
        public int GuestId { get; set; }
        public int ApartmentId { get; set; }
        public int BedId { get; set; }
        public int CheckInHdrId { get; set; }
        public string Chkindate { get; set; }
        public string ChkoutDate { get; set; }
        public string GuestName { get; set; }
        public string Property { get; set; }
        public string BookingCode { get; set; }
        public string BookingLevel { get; set; }
        public string ChangedStatus { get; set; }
        public string Type { get; set; }
        public string Remarks { get; set; }
    }
}
