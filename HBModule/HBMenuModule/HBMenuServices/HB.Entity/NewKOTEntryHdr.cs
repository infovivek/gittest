using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class NewKOTEntryHdr
    {
        public int PropertyId { get; set; }
        public string PropertyName { get; set; }
        public string Date { get; set; }
        public string GuestName { get; set; }
        public string RoomNo { get; set; }
        public string BookingCode { get; set; }
        public string ClientName { get; set; }
        public int GuestId { get; set; }
        public int BookingId { get; set; }
        public int RoomId { get; set; }
        public int CheckInId { get; set; }
        public string GetType { get; set; }
        public int Id { get; set; }
        public decimal TotalAmount { get; set; }
    }
}
